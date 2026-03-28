# 18: Design a Chat System

<p align="center">
  <img src="images/sd_chat_system.png" alt="Chat System Design" width="800"/>
</p>

## 🎯 The Big Goal

> **Design a real-time messaging system like WhatsApp or Facebook Messenger — handling 1-on-1 chat, group chat, presence, and message delivery guarantees.**

---

## 1. Requirements

| Functional | Non-Functional |
| :--- | :--- |
| 1-on-1 messaging | Low latency (< 100ms) |
| Group chat (up to 500 members) | High availability |
| Online/offline status | Message ordering guaranteed |
| Read receipts | Exactly-once delivery |
| Push notifications for offline users | Support 50M concurrent users |
| Message history | End-to-end encryption |

---

## 2. High-Level Architecture

<p align="center">
  <img src="images/sd_chat_arch.png" alt="Chat System Architecture" width="700"/>
</p>

---

## 3. WebSocket Connection

```
HTTP Upgrade (one-time):
  Client ──GET /ws──→ Server
  Server ──101 Switching Protocols──→ Client

Then: Full-duplex, persistent connection
  Client ◄──────── messages ────────► Server
```

| Protocol | Direction | Use Case |
| :--- | :--- | :--- |
| **WebSocket** | Bi-directional | Real-time chat |
| **HTTP** | Client → Server | Profile updates, history |
| **Push Notification** | Server → Client (offline) | FCM/APNs when app is closed |

---

## 4. Message Flow

### 1-on-1 Chat:
```
1. Alice sends message via WebSocket → Chat Server A
2. Chat Server A stores message in DB (status: SENT)
3. Chat Server A checks: Is Bob online?
   a. YES → Find Bob's Chat Server B → forward via message queue → deliver
   b. NO → Store for later + push notification
4. Bob receives → acknowledge → update status: DELIVERED
5. Bob reads → update status: READ → notify Alice
```

### Group Chat:
```
Alice sends to Group (100 members):
  1. Message stored once in DB
  2. Fan-out to 100 members:
     - Online members: deliver via WebSocket
     - Offline members: push notification
```

---

## 5. Message Storage

```
┌──────────────────────────────────────────────┐
│ messages                                      │
├──────────────────────────────────────────────┤
│ message_id    UUID  (sorted by time)         │
│ channel_id    UUID  (conversation/group)     │
│ sender_id     UUID                           │
│ content       TEXT (encrypted)               │
│ type          ENUM (text, image, video)      │
│ status        ENUM (sent, delivered, read)   │
│ created_at    TIMESTAMP                      │
└──────────────────────────────────────────────┘
```

**Database Choice:** Cassandra or HBase — optimized for write-heavy, time-series data with partition key = channel_id.

---

## 6. Presence (Online Status)

```
User connects:    → Set status ONLINE in Redis (TTL: 30s)
Heartbeat:        → Refresh TTL every 10s
Disconnect:       → TTL expires → status OFFLINE
```

| Approach | How | Trade-off |
| :--- | :--- | :--- |
| **Heartbeat** | Client pings every 10s | Simple, slight delay |
| **Connection tracking** | Track WebSocket connections | Accurate, more complex |

---

## 📝 Key Interview Talking Points

- WebSocket for real-time; push notifications for offline users
- Message ordering via time-sorted IDs (Snowflake ID or ULID)
- Fan-out for small groups; message queue for large groups
- Presence uses Redis with TTL-based heartbeats

---

[<< Previous: URL Shortener](./17_Design_URL_Shortener.md) | [Home: Curriculum Map](./README.md) | [Next: Design News Feed >>](./19_Design_News_Feed.md)
