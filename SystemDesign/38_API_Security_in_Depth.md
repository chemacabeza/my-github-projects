# 38: API Security in Depth

<p align="center">
  <img src="images/sd_api_security_design.png" alt="API Security" width="800"/>
</p>

> **Imagine your house has layers of protection.** The front gate has a lock (HTTPS). A security guard checks your ID at the door (Authentication). Even after you're inside, you can only enter rooms you have keys for (Authorization). And there's a rule: you can only ring the doorbell 5 times per minute so you don't annoy everyone (Rate Limiting). API Security works the same way — multiple layers, each catching different kinds of bad guys.

## What You'll Learn

> **After this chapter, you'll understand OAuth 2.0 authorization flows, JWT token structure and validation, HTTPS/TLS, CORS, and API-specific attack surfaces — drawn from API Security in Action (Neil Madden) and Mastering API Architecture.**

---

## 1. Authentication vs Authorization

> **Son, authentication is "proving who you are" — showing your school ID card at the door. Authorization is "proving what you're allowed to do" — your ID says you're a student, but only teachers can enter the staff room.**

| Concept | Question | Example |
| :--- | :--- | :--- |
| **Authentication (AuthN)** | "WHO are you?" | Login with username/password |
| **Authorization (AuthZ)** | "WHAT can you do?" | Admin can delete; user can only read |

---

## 2. OAuth 2.0: The Authorization Framework

> **Imagine you want a photo printing app to access your Google Photos.** You don't want to give the app your Google password! Instead, Google acts as a trusted middleman. You tell Google "I allow this app to see my photos" and Google gives the app a special temporary badge (access token). The app never sees your password.

### The Authorization Code Flow (Most Secure)

```
┌──────────┐     ┌──────────────┐     ┌──────────────┐
│  User's   │     │    Auth      │     │   Resource    │
│  Browser  │     │   Server     │     │   Server     │
│  (Client) │     │  (Google)    │     │  (Photos API)│
└─────┬─────┘     └──────┬───────┘     └──────┬───────┘
      │                  │                    │
      │ 1. Click         │                    │
      │   "Login with    │                    │
      │    Google"       │                    │
      ├─────────────────►│                    │
      │                  │                    │
      │ 2. Google shows  │                    │
      │   "Allow Photo   │                    │
      │    App to access │                    │
      │    your photos?" │                    │
      │◄─────────────────┤                    │
      │                  │                    │
      │ 3. User clicks   │                    │
      │   "Allow"        │                    │
      ├─────────────────►│                    │
      │                  │                    │
      │ 4. Auth Code     │                    │
      │◄─────────────────┤                    │
      │                  │                    │
      │ 5. Exchange code │                    │
      │   for tokens     │                    │
      │   (server-side)  │                    │
      ├─────────────────►│                    │
      │                  │                    │
      │ 6. Access Token  │                    │
      │   + Refresh Token│                    │
      │◄─────────────────┤                    │
      │                  │                    │
      │ 7. GET /photos   │                    │
      │   Authorization: │                    │
      │   Bearer <token> │                    │
      ├──────────────────┼───────────────────►│
      │                  │                    │
      │ 8. Photos data   │                    │
      │◄─────────────────┼────────────────────┤
```

### OAuth 2.0 Grant Types

| Grant Type | Use Case | Security Level |
| :--- | :--- | :--- |
| **Authorization Code** | Web apps with a backend server | Highest |
| **Authorization Code + PKCE** | Mobile apps, single-page apps | High |
| **Client Credentials** | Server-to-server (no user involved) | High |
| **Implicit** (deprecated) | Old SPAs | Low — don't use |
| **Password** (deprecated) | Legacy only | Low — don't use |

---

## 3. JWT: The Access Badge

> **A JWT is like a concert wristband.** When you enter the concert, security checks your ticket and gives you a wristband. After that, every bouncer just looks at your wristband — they don't call the ticket office each time. The wristband itself contains info about which areas you can access (VIP, backstage), and it has a special hologram (signature) so it can't be forged.

### JWT Structure: Three Parts

```
eyJhbGciOiJSUzI1NiJ9.eyJzdWIiOiIxMjMiLCJyb2xlIjoiYWRtaW4ifQ.signature

       HEADER              PAYLOAD                    SIGNATURE
    (algorithm)        (who you are)              (proof it's real)

Decoded:

HEADER:  { "alg": "RS256", "typ": "JWT" }
PAYLOAD: { "sub": "123", "name": "Alice", "role": "admin", "exp": 1700000000 }
SIGNATURE: RS256(header + "." + payload, privateKey)
```

### How the API Gateway Validates a JWT

```
1. Extract token from: Authorization: Bearer <token>
2. Decode the header → find the algorithm (RS256)
3. Verify the signature using the Auth Server's PUBLIC key
4. Check "exp" claim → is the token expired?
5. Check "iss" claim → was it issued by OUR auth server?
6. Check "aud" claim → is it intended for THIS API?
7. Extract "sub" and "role" → attach to request context
8. Forward request to the microservice

NO DATABASE CALL NEEDED — everything is in the token itself!
```

### Access Token vs Refresh Token

| Token | Lifetime | Purpose |
| :--- | :--- | :--- |
| **Access Token** | 15 minutes | Authenticates API requests |
| **Refresh Token** | 7-30 days | Gets a new access token when the old one expires |

> **Why short-lived access tokens?** If a hacker steals your access token, it only works for 15 minutes. The refresh token is stored securely server-side and requires the client secret to use.

---

## 4. CORS: The Browser's Bouncer

> **Son, imagine your school has a rule: students from School A can only visit School B if School B specifically said "Students from School A are welcome."** CORS (Cross-Origin Resource Sharing) is that rule for websites. Your frontend at `app.example.com` can only call the API at `api.example.com` if the API explicitly allows it.

```
Browser: "Hey api.example.com, can app.example.com talk to you?"
  (OPTIONS request — the "preflight" check)

Server: "Yes, here are the rules:"
  Access-Control-Allow-Origin: https://app.example.com
  Access-Control-Allow-Methods: GET, POST, PUT, DELETE
  Access-Control-Allow-Headers: Authorization, Content-Type
  Access-Control-Max-Age: 3600

Browser: "OK, rules check out. Sending the real request now."
  (Actual GET/POST request)
```

**NEVER set `Access-Control-Allow-Origin: *` in production.** It lets ANY website call your API, including malicious ones.

---

## 5. API-Specific Attack Surfaces

> **Bad guys attack APIs differently than they attack websites.** Here are the top dangers, from *API Security in Action*:

| Attack | How It Works | Defense |
| :--- | :--- | :--- |
| **Broken Authentication** | Weak tokens, no expiry | Short-lived JWTs, strong signing |
| **Broken Authorization** | User A accesses User B's data | Check ownership in EVERY endpoint |
| **Injection (SQL/NoSQL)** | Malicious input in query params | Parameterized queries, input validation |
| **Mass Assignment** | Client sends `{"role":"admin"}` | Whitelist allowed fields explicitly |
| **Excessive Data Exposure** | API returns ALL fields including secrets | Select only needed fields |
| **Rate Limiting Bypass** | Abuse with thousands of requests | Token bucket algorithm at the gateway |
| **SSRF** | Trick API into calling internal services | Whitelist allowed outbound URLs |

---

## 6. API Key vs OAuth vs JWT

| Method | How | Best For |
| :--- | :--- | :--- |
| **API Key** | Static key in header `X-API-Key: abc123` | Simple server-to-server, tracking usage |
| **OAuth 2.0** | Delegated auth via authorization server | Third-party access to user data |
| **JWT** | Self-contained signed token | Stateless auth, microservices |

---

## Reflection Questions

1. **Your mobile app uses OAuth 2.0 Authorization Code flow.** But mobile apps can't keep a `client_secret` safe because the app binary can be decompiled. How does PKCE solve this?
<details>
<summary>Show Answer</summary>

PKCE (Proof Key for Code Exchange) replaces the static client_secret with a dynamically generated `code_verifier` (random string) and `code_challenge` (SHA256 hash of the verifier). The client sends the challenge when requesting the auth code, and the verifier when exchanging it for tokens. An attacker who intercepts the auth code can't exchange it without the original verifier. This makes the Authorization Code flow safe for public clients (mobile/SPA).
</details>

2. **A developer stores the JWT in localStorage.** What's the security risk? Where should it be stored instead?
<details>
<summary>Show Answer</summary>

localStorage is vulnerable to Cross-Site Scripting (XSS) — any JavaScript on the page can read it. If an attacker injects a script (via an XSS vulnerability), they steal the JWT. Store tokens in **httpOnly, Secure, SameSite=Strict cookies** instead. httpOnly means JavaScript can't access the cookie, and Secure means it's only sent over HTTPS.
</details>

---

## Key Interview Talking Points

- OAuth 2.0 Authorization Code + PKCE is the gold standard for auth flows
- JWTs are verified with public keys — no database needed per request
- Access tokens: short-lived (15min). Refresh tokens: long-lived (days)
- CORS preflight checks prevent unauthorized cross-origin requests
- Top API threats: Broken AuthZ, injection, mass assignment, excess data exposure

---

[<< Previous: GraphQL Architecture](./37_GraphQL_Architecture.md) | [Home: Curriculum Map](./README.md) | [Next: API Lifecycle & Evolution >>](./39_API_Lifecycle_and_Evolution.md)
