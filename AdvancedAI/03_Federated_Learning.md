# 03: Federated Learning

<p align="center">
  <img src="images/ai_federated.jpg" alt="Federated Learning Architecture" width="800"/>
</p>

## 🎯 The Big Goal

> **Train machine learning models on vast amounts of real-world user data without the data *ever* leaving the user's localized edge device, thereby preserving absolute privacy.**

---

## 1. The Core Paradigm Shift

Traditional AI training requires moving all the data to the model. 
*   *Old Way:* User takes a photo -> Photo uploaded to Cloud Database -> Cloud server trains model on millions of photos. (Massive privacy risk).

**Federated Learning (FL)** reverses this paradigm: *We move the model to the data.*
*   *New Way:* Global model downloaded to cell phone -> Phone trains localized model purely on local private photos -> Phone uploads **only the learned weight updates (gradients)** back to the cloud -> The cloud averages millions of gradients to update the global model. 

---

## 2. 🔧 Deep Dive: The Federated Averaging (FedAvg) Algorithm

How do millions of separate updates merge safely? The industry standard is **FedAvg**.

1.  **Initialization:** The Central Server initializes a global model $W_0$.
2.  **Distribution:** The server selects a random subset of active edge clients (e.g., 10,000 phones plugged in to Wi-Fi at night) and sends them $W_0$.
3.  **Local Training:** Each client $k$ trains $W_0$ exclusively on its local, private dataset for a few epochs, producing a new local model $W_k$.
4.  **Aggregation:** The clients send the difference (the gradient update) back to the server. The server computes a weighted average of these local models (weighted by the amount of data each client had) to produce the next global model $W_1$.
5.  **Iteration:** Repeat process until convergence.

---

## 3. 🔧 Deep Dive: Secure Aggregation

Even if you only upload weight gradients (and not raw photos), researchers have proven that malicious actors analyzing those gradients can sometimes reverse-engineer exactly what local data produced them (known as a *Gradient Inversion Attack*).

**The Mitigation: Secure Aggregation via Cryptography.**
*   Before the edge devices upload their local gradients to the cloud, they use cryptographic multi-party computation.
*   They intentionally inject localized mathematical "noise" into their gradients.
*   The math is orchestrated so that the noise completely hides the signal of any *individual* device, but when the server sums up the gradients from 10,000 devices, the noise perfectly cancels itself out to exactly zero.
*   The server successfully calculates the accurate, averaged global update without ever being physically capable of reading an individual user's updates.

---

## 4. Challenges & Limitations

*   **Communication Overhead:** Uploading massive gradient files from millions of phones uses tremendous bandwidth. Gradients are often heavily quantized (see Chapter 2) before upload.
*   **Non-IID Data:** (Non-Independent and Identically Distributed). A user in Japan types very differently than a user in Brazil. A model trained simultaneously on completely different data distributions struggles to converge smoothly compared to a homogenous centralized dataset.
*   **Stragglers:** If 1,000 phones are training, but 5 have terrible internet connections, the entire aggregation step hangs waiting for them to finish.

---

## 🤔 Reflection Questions

1. **Why is Federated Learning heavily dependent on device power status (e.g., "only run when plugged in and on Wi-Fi")?**
<details>
<summary>💡 View Answer</summary>

Training a neural network using backpropagation is incredibly computationally expensive and power-hungry. If an app attempted to run Federated Learning in the background while the user was navigating on 5G with 20% battery, it would violently drain the battery and consume potentially gigabytes of the user's cellular data plan just to upload model weight gradients. Therefore, OS-level constraints strictly block FL unless the device considers itself in an idle, high-power, unmetered network state.
</details>

2. **Imagine a Federated Learning system training a predictive text keyboard. One user is intentionally typing malicious gibberish or harmful language to corrupt the global model. How do you defend against this "Data Poisoning" attack?**
<details>
<summary>💡 View Answer</summary>

Because the server is mathematically blind to the user's raw data (due to privacy constraints), it cannot visually inspect what they are typing. Instead, defense relies on **Byzantine Robust Aggregation protocols** (like Krum or Median Aggregation). Instead of doing a blind average of all localized model updates, the server assesses the "distance" or variance between all the incoming gradient vectors. If a gradient from a specific user is a massive outlier compared to the consensus of the other 9,999 users, the aggregation algorithm automatically rejects or heavily downweights it as a presumed anomaly or poisoning attempt.
</details>

---

[<< Previous: Efficient DNN Processing](./02_Efficient_DNN_Processing.md) | [Home: Curriculum Map](./README.md)
