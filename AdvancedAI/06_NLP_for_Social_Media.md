# 06: NLP for Social Media & Unstructured Text

<p align="center">
  <img src="images/ai_nlp_social.jpg" alt="NLP on Unstructured Data" width="800"/>
</p>

## 🎯 The Big Goal

> **Extract flawless mathematical structure (sentiment, named entities, intents) from completely chaotic, unstructured, internet-slang data streams like Twitter or Reddit.**

---

## 1. The Challenge of Unstructured Text

Processing a formal Wikipedia article is easy. Processing a tweet like `"idk why yall hype this phone... battery is literal 🗑️ fr fr no cap"` is incredibly difficult for legacy systems.
*   **Out of Vocabulary (OOV) Words:** Slang like "fr fr" or "yall" do not exist in traditional NLP dictionaries.
*   **Sarcasm & Emojis:** The trash can emoji `🗑️` carries massive semantic weight regarding sentiment, and traditional text parsers often drop emojis entirely.

## 2. 🔧 Deep Dive: Sub-word Tokenization (BPE)

Modern Transformers (like BERT or RoBERTa) solve the OOV problem using **Byte-Pair Encoding (BPE)** or **WordPiece Tokenization**.
Instead of learning whole words, the model learns sub-words and characters. 
If it encounters the unknown slang `hyperfast`, it doesn't crash. It breaks it down into `[hyper, ##fast]` and processes the mathematical meaning of the two known sub-components. Emojis are treated as their own unique unicode tokens, allowing the Neural Network to natively calculate their emotional weight.

---

## 💻 Reproducible Code: HuggingFace Pipelines

This script uses Europe's HuggingFace `transformers` library to seamlessly download a pre-trained RoBERTa model specifically fine-tuned on 58 million tweets to perform flawless sentiment analysis on dense slang.

### `social_nlp.py`
```python
from transformers import pipeline

# 1. Load Twitter-RoBERTa model optimized for social media
print("Loading specialized Social Media NLP model...")
sentiment_analyzer = pipeline(
    model="cardiffnlp/twitter-roberta-base-sentiment-latest", 
    task="sentiment-analysis"
)

# 2. Define chaotic, unstructured test inputs
texts = [
    "idk why yall hype this phone... battery is literal 🗑️ fr fr no cap",
    "THE NEW GPU IS AN ABSOLUTE MONSTER!! 🚀🔥 best purchase ever",
    "service was okay I guess, nothing special tbh."
]

# 3. Analyze
for text in texts:
    result = sentiment_analyzer(text)[0]
    print(f"\nText: {text}")
    print(f"Sentiment: {result['label'].upper()} (Confidence: {result['score']:.4f})")
```

### 🐳 Run it with Docker

**Create `Dockerfile`:**
```dockerfile
FROM python:3.9-slim
WORKDIR /app
# Install PyTorch and Transformers
RUN pip install torch transformers
COPY social_nlp.py /app/
CMD ["python", "social_nlp.py"]
```

**Execute:**
```bash
docker build -t social-nlp-demo .
docker run social-nlp-demo
```

---

[Home: Curriculum Map](./README.md) | [Next: Conversational AI >>](./07_Conversational_AI.md)
