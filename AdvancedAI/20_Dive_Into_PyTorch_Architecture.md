# 20: Dive Into PyTorch Architecture

<p align="center">
  <img src="images/adv_ai_pytorch_cover.png" alt="PyTorch Dynamic Computation Graph" width="900"/>
</p>

## 🎯 The Big Goal

> **After this chapter, you will master PyTorch, the undisputed king of modern AI Research and LLM development. You will understand how Dynamic Computation Graphs (Autograd) radically distinguish it from TensorFlow, how to structure models using pure Object-Oriented `nn.Module` classes, and exactly how to write custom low-level training loops.**

While TensorFlow dominated the enterprise industry from 2016-2020 by compiling static, unchangeable code graphs, the research community rebelled. If you wanted to build an irregular network (like a recurrent network that loops a different number of times depending on the length of a sentence), TensorFlow's static rigidity made it a nightmare.

Meta released **PyTorch**. Instead of compiling a static graph ahead of time, PyTorch builds its graph *on the fly*, dynamically, line-by-line using Python syntax. 

---

## 1. The Autograd Engine (Dynamic Graphs)

PyTorch uses a mechanism called "Define-by-Run" or "Tape-based Autograd".

<p align="center">
  <img src="images/adv_ai_pytorch_autograd.png" alt="PyTorch Autograd Tape Engine" width="800"/>
</p>

1.  **Forward Pass (The Tape Recorder):** As you execute Python code mathematically multiplying tensors together, the Autograd Engine secretly acts like a tape recorder. It records a massive tree of operations, attaching a specific `grad_fn` (Gradient Function) to the metadata of each tensor.
2.  **The Trigger:** When you call `loss.backward()`, the tape recorder immediately plays in reverse.
3.  **Backward Pass:** It traverses the graph from the loss output backward, executing the Chain Rule mathematics instantly, and depositing the final gradients nicely inside the `.grad` attribute of every single parameter in your model. 
4.  **The Cleanup:** The graph is instantly destroyed. It will build a brand new graph from scratch in the very next millisecond for the next batch.

---

## 2. Object-Oriented AI (`nn.Module`)

Because PyTorch is dynamic, it embraces standard Python Object-Oriented Programming (OOP). 
You don't string together long functional pipelines. You create a Python Class that inherits from `torch.nn.Module`. 

*   `__init__()`: This is your parts catalog. You instantiate all the layers (parameters) your model will need.
*   `forward()`: This is your plumbing. You explicitly write exactly how data should flow from `input x` to the output. You can use standard Python `if` statements, `for` loops, and `print()` statements right in the middle of a forward pass!

---

## 🐳 Dockerized Application: PyTorch Custom Class & Training Loop

We will build a PyTorch application using the official CPU environment. Instead of the high-level `.fit()` we used in Keras, we will explicitly write a custom OOP class and handcraft the training loop so you can see exactly how the Autograd Engine works.

### `docker-compose.yml`
```yaml
version: '3.8'
services:
  pytorch_model:
    image: pytorch/pytorch:latest
    container_name: torch_autograd_engine
    volumes:
      - .:/app
    working_dir: /app
    command: python app.py
```

### `app.py`
```python
import torch
import torch.nn as nn
import torch.optim as optim
import time

print(f"🔥 Initializing PyTorch Engine v{torch.__version__}")

# 1. Generate Synthetic Data
# X: 1000 samples, 10 features. y: 1000 samples, 1 output (binary 0 or 1 classification)
X = torch.randn(1000, 10)
# Create a dummy target. If the sum of the features > 0, class 1, else class 0
y = (torch.sum(X, dim=1) > 0).float().unsqueeze(1) 

# 2. Build the Model using Object-Oriented Principles
class AdvancedClassifier(nn.Module):
    def __init__(self):
        super(AdvancedClassifier, self).__init__()
        # Store layers as attributes. 
        self.fc1 = nn.Linear(10, 64) # Fully Connected Layer 1 (10 inputs -> 64 hidden)
        self.relu = nn.ReLU()        # Non-linear activation
        self.fc2 = nn.Linear(64, 1)  # Fully Connected Layer 2 (64 hidden -> 1 output)
        self.sigmoid = nn.Sigmoid()  # Squeeze output to probability between 0 and 1
        
    def forward(self, x):
        # We explicitly dictate the flow of the computation graph mathematically
        x = self.fc1(x)
        x = self.relu(x)
        x = self.fc2(x)
        x = self.sigmoid(x)
        
        # In PyTorch, you can use normal python debugging right here in the graph!
        # uncomment next line if you want to inspect tensor shapes mid-training:
        # print("Current tensor shape:", x.shape) 
        
        return x

model = AdvancedClassifier()
print("\n⚙️ Object-Oriented Model Instantiated:")
print(model)

# 3. Setup Loss Function and Optimizer
criterion = nn.BCELoss() # Binary Cross Entropy Loss
optimizer = optim.Adam(model.parameters(), lr=0.01) # Link Optimizer directly to our model's weights

# 4. Handcrafted Custom Training Loop
print("\n🧠 Commencing Dynamic Training Loop...")
epochs = 5
start_time = time.time()

for epoch in range(epochs):
    # Step A: ZERO GRADIENTS!
    # By default, PyTorch ACCUMULATES gradients. We must explicitly wipe the slate clean.
    optimizer.zero_grad()
    
    # Step B: Forward Pass (This dynamically constructs the Graph tape!)
    predictions = model(X)
    
    # Step C: Calculate Loss
    loss = criterion(predictions, y)
    
    # Step D: Backward Pass (Auto-magically calculates Chain Rule gradients via Autograd)
    loss.backward()
    
    # Step E: Optimization Step (Adam applies the calculated gradients to update weights)
    optimizer.step()
    
    print(f"Epoch [{epoch+1}/{epochs}] | Loss: {loss.item():.4f}")

end_time = time.time()
print(f"\n✅ Training Complete in {end_time - start_time:.4f} seconds.")

# Prove the model learned something! Let's pass a random vector through it.
test_vector = torch.ones(1, 10) 
prediction = model(test_vector)
print(f"\n🎯 Inference Test Vector -> Predicted Output Probability: {prediction.item():.4f}")
```

To run this:
1. Save the above files.
2. Run `docker-compose up`. *Note: The official PyTorch CPU Docker image is large and will take a moment to download.*

---

## 🤔 Reflection Questions

1. **In the handmade PyTorch training loop above, why is the specific command `optimizer.zero_grad()` absolutely critical? What happens if you delete that line?**
<details>
<summary>💡 View Answer</summary>

Unlike TensorFlow, PyTorch was designed originally for Recurrent Neural Networks (RNNs) and complex multi-step reinforcement learning architectures where you might *want* gradients from different sub-components to stack up together. Therefore, calling `loss.backward()` **adds** the newly computed gradients to whatever already exists in the `.grad` attributes. If you forget `zero_grad()`, the gradients from Epoch 1, 2, and 3 will infinitely stack on top of each other, and your model weights will instantly explode into chaos resulting in `NaN` losses.
</details>

2. **If PyTorch executes regular Python code, what happens if I put an `if/else` statement inside my `forward(self, x)` method that routes the data to entirely different massive layers randomly for every single batch?**
<details>
<summary>💡 View Answer</summary>

It works perfectly natively! This is the core magic of Dynamic Computation Graphs. Because the Autograd engine literally constructs the graph fresh for *every single batch run*, it has zero problem handling branches. If the data goes down the `if` branch, Autograd tapes the `if` architecture. In the next batch, if it goes down the `else` branch, it tapes the `else` architecture. This kind of dynamic flexibility is incredibly painful to achieve in statically compiled frameworks like older versions of TensorFlow (where you must use hacky `tf.cond` structures).
</details>

---

<div align="center">

| [<< Previous: Hands-On TensorFlow Architecture](./19_Hands_On_TensorFlow_Architecture.md) | [Home: Curriculum Map](./README.md) |

</div>
