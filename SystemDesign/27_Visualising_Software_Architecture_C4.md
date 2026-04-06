# 27: Visualising Software Architecture (C4 Model)

<p align="center">
  <img src="images/sys_c4_model.png" alt="C4 Model" width="100%"/>
</p>

> 🧠 **The Feynman Hook:** Most architecture diagrams are like hand-drawn maps with no scale, no legend, and no consistent symbols — everyone draws differently and no one understands anyone else's map. The C4 Model is an Ordnance Survey standard for software: four agreed zoom levels, consistent notation, and a clear rule about what belongs on each level. With C4, a new developer can navigate an unfamiliar system the same way a tourist can navigate a new city with a standardised street map.

## 🎯 What You'll Learn

> **After this chapter, you will finally know how to draw diagrams that make sense. You will be able to communicate complex ideas to anyone using the C4 Model.**

Diagramming is broken. Most developers draw completely chaotic boxes and lines. No one knows what the boxes mean.

The **C4 Model** fixes this. It is like Google Maps for your code. You can zoom in step-by-step to see more detail natively.

---

## 1. 🔍 The 4 Levels of Zoom (C4)

> **Feynman Insight:** C4 is four zoom levels on a single map. Level 1 (Context) is the satellite view: you can see countries but not streets. Level 2 (Container) is the city view: you can see motorways and districts. Level 3 (Component) is the street view: individual buildings and their entrances. Level 4 (Code) is the floor plan: specific rooms inside one building. A tourist needs Level 2. A courier needs Level 3. An interior designer needs Level 4. The CEO is still on the satellite.

C4 stands for Context, Containers, Components, and Code.

### 1️⃣ System Context (The Big Picture)
*   **Zoom Level**: Astronaut View.
*   **Who is it for?**: The CEO, Product Managers.
*   **What it shows**: Just users interacting with your massive system box, and any external systems you talk to (like Stripe or AWS).

### 2️⃣ Containers (The Applications)
*   **Zoom Level**: High-level technical view.
*   **Who is it for?**: System Architects.
*   **What it shows**: You zoom inside the system box. You reveal the independently deployable applications. (e.g., The React Web App, The Mobile App, The Java Backend, The SQL Database).

### 3️⃣ Components (The Internal Structure)
*   **Zoom Level**: Inside a single Container.
*   **Who is it for?**: Developers.
*   **What it shows**: You zoom inside the Java Backend. You see the internal modules (e.g., AuthController, EmailService, UserRepository).

### 4️⃣ Code (The Deep Dive)
*   **Zoom Level**: Microscopic.
*   **Who is it for?**: Junior Developers exploring specific files.
*   **What it shows**: UML diagrams of classes, methods, and functions. (Rarely used unless absolutely necessary).

---

## 2. 🚫 Abstraction over Implementation

A good diagram doesn't show everything. It shows **exactly enough** to understand the level you are looking at.

*   Never put low-level Code details on a Context diagram.
*   Always define what the arrows mean (e.g., "Makes API Call" or "Reads Data").
*   Use simple, clear language.

---

## 🤔 Reflection Questions

1. **Why is it useless to show a CEO exactly how the EmailService component talks to the UserRepository?** How does the C4 model protect against oversharing?
<details>
<summary>💡 View Answer</summary>

A CEO cares about business outcomes: "Which systems do our customers interact with? What external partners do we depend on?" Showing them class-level component interactions is noise that obscures the strategic picture. The C4 model protects against oversharing by providing **four explicit zoom levels**: Level 1 (Context) for executives, Level 2 (Container) for architects, Level 3 (Component) for developers, Level 4 (Code) for deep implementation details. As Simon Brown explains in *The C4 Model*, each audience gets exactly the detail they need — no more, no less. The CEO sees Level 1; the developer sees Level 3.
</details>

2. **If you were a new developer joining the team on day one, which C4 level would immediately help you understand where to write your SQL query?**
<details>
<summary>💡 View Answer</summary>

**Level 3 (Component Diagram)**. It shows the internal structure of a specific container — for example, the backend application broken into components like UserController, OrderService, PaymentGateway, and **UserRepository**. The UserRepository component is where SQL queries live. Level 1 is too high-level (just "Backend System"). Level 2 shows containers (the API server, the database) but not internal components. Level 4 (Code) is too granular — it shows individual classes and methods. Level 3 is the sweet spot: it tells you which component owns data access and how it connects to the database container.
</details>

---

## 📝 Key Interview Talking Points

*   **Clarity Over Complexity**: Explain that you use standard, agreed-upon structures (like C4) instead of chaotic ad-hoc diagrams.
*   **Audience Awareness**: Always mention that you tailor your diagrams depending on who you are talking to (Business vs Engineering).
*   **Consistency**: A common language for boxes and arrows prevents critical misunderstandings in large-scale system designs.

---

[<< Previous: Evolutionary Architectures](./26_Evolutionary_Architectures_Metrics.md) | [Home: System Design Curriculum](./README.md) | [Next: Proximity Service >>](./28_Design_Proximity_Service_Maps.md)
