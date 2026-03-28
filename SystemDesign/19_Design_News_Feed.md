# 19: Design a News Feed

<p align="center">
  <img src="images/sd_news_feed.png" alt="News Feed Design" width="800"/>
</p>

## 🎯 The Big Goal

> **Design a social media news feed like Twitter or Facebook — where users see posts from people they follow, ranked by relevance.**

---

## 1. Requirements

| Functional | Non-Functional |
| :--- | :--- |
| User publishes a post | Feed loads in < 200ms |
| User sees feed of followed users' posts | Support 500M users, 1B posts/day |
| Feed is ranked (not just chronological) | Highly available |
| Support images, videos, text | Eventually consistent (slight delay OK) |

---

## 2. Two Core Approaches

### Fan-Out on Write (Push Model)
```
Alice posts → Pre-compute feed for all 1000 followers
  1. Alice creates post → stored in DB
  2. Worker looks up Alice's followers: [Bob, Carol, Dave, ...]
  3. Worker writes post_id to each follower's feed cache
  4. When Bob opens app → read from pre-built feed cache → instant!
```

### Fan-Out on Read (Pull Model)
```
Bob opens app → Compute feed on-the-fly
  1. Bob opens app → "Give me my feed"
  2. Server queries: Who does Bob follow? [Alice, Eve, Frank, ...]
  3. Server fetches recent posts from each followed user
  4. Server merges, ranks, returns → slower but always fresh
```

| Approach | Pros | Cons | Best For |
| :--- | :--- | :--- | :--- |
| **Fan-out Write** | Fast reads (pre-computed) | Celebrity problem (millions of writes) | Most users |
| **Fan-out Read** | No wasted writes | Slow reads (compute on request) | Celebrities |

> 💡 **Hybrid Approach (Twitter):** Fan-out on write for normal users; fan-out on read for celebrities (>1M followers).

---

## 3. Architecture

<p align="center">
  <img src="images/sd_newsfeed_arch.png" alt="News Feed Architecture" width="700"/>
</p>

---

## 4. Feed Ranking

Instead of pure chronological order, rank by **engagement signals**:

```
Score = w₁(recency) + w₂(likes) + w₃(comments) + w₄(shares)
        + w₅(user_affinity) + w₆(content_type) - w₇(already_seen)
```

| Signal | Weight | Description |
| :--- | :--- | :--- |
| **Recency** | High | Newer posts rank higher |
| **Engagement** | High | Posts with many likes/comments |
| **Affinity** | Medium | How much Bob interacts with Alice |
| **Content Type** | Medium | Videos > images > text (varies) |
| **Diversity** | Low | Avoid too many posts from one person |

---

## 5. Storage Design

| Data | Storage | Reason |
| :--- | :--- | :--- |
| **Posts** | PostgreSQL / MySQL | Relational, ACID for writes |
| **Feed Cache** | Redis (sorted sets) | Pre-computed, fast reads |
| **Social Graph** | Graph DB or adjacency table | Who follows whom |
| **Media** | Object Storage (S3) + CDN | Images, videos |

---

## 🤔 Reflection Questions

1. **A celebrity with 50 million followers posts an update.** Fan-out on write would create 50 million cache entries. Fan-out on read would make every follower wait. How does the hybrid approach handle this, and where exactly do you draw the line between "normal" and "celebrity"?

2. **Your ranking algorithm optimizes for engagement (likes, comments, shares), and the feed is filled with controversial content** because controversy drives engagement. How do you balance algorithmic ranking with responsible content curation? Should "engagement" even be the primary ranking signal?

3. **A user follows 5,000 accounts, and their feed cache has room for only 500 posts.** How do you decide which 500 posts to pre-compute? What happens when the user scrolls past those 500 — do you switch from push to pull seamlessly?

4. **Two users in the same household see completely different feeds.** How does feed personalization create "filter bubbles"? Should you intentionally inject diverse or opposing viewpoints? What are the ethical implications for a system designer?

5. **Your feed shows a post from 2 hours ago at the top because it has high engagement, but the user already saw it.** How do you prevent "stale" but popular content from dominating the feed? What signals indicate that a user has already consumed a piece of content?

---

## 📝 Key Interview Talking Points

- Always mention the **hybrid fan-out approach** (push for normal, pull for celebrities)
- Feed ranking uses ML in production (not just simple scoring)
- Redis sorted sets are ideal for ordered feed caches
- Discuss the trade-off: fast reads (pre-computed) vs fresh data (on-demand)

---

[<< Previous: Chat System](./18_Design_Chat_System.md) | [Home: Curriculum Map](./README.md) | [Next: Design Video Platform >>](./20_Design_Video_Platform.md)
