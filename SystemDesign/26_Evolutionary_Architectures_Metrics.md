# 26: Evolutionary Architectures & Metrics

<p align="center">
  <img src="images/sys_evolutionary_architecture.png" alt="Evolutionary Architecture" width="100%"/>
</p>

> 🧠 **The Feynman Hook:** A bridge is designed not just for today's load, but to evolve — it has expansion joints to flex in heat, reinforced piers for heavier trucks, and load sensors to detect stress before failure. Evolutionary Architecture applies the same thinking to code: build automated "fitness functions" that continuously measure architectural health, just like bridge sensors measure structural stress. Without these guardrails, the bridge (codebase) slowly degrades under load until it fails catastrophically.

## 🎯 What You'll Learn

> **After this chapter, you will understand how to design systems that safely adapt to change. You will learn how to measure code health and prevent slow decay.**

Code rots over time. Business requirements change. New frameworks emerge.

An **Evolutionary Architecture** expects change and builds automated ways to protect against bad code.

---

## 1. 🛡️ Fitness Functions

> **Feynman Insight:** Without fitness functions, architectural rules exist only in a README that nobody reads. A fitness function is a building inspector who runs automated checks every time a new wall is added: "Does this wall meet fire code? Does it add weight beyond the foundation limit?" If it violates the rules, construction stops immediately — not six months later after 100 bad walls have been added.

How do you make sure junior developers don't destroy your beautiful architecture? You write **Fitness Functions**.

A fitness function is a test that runs automatically (like a unit test). But instead of testing business logic, it tests architectural rules.

*   ⚖️ **Atomic Fitness Function**: Checks one specific thing. Example: *Ensure module A never imports module B directly*. If someone writes a circular dependency, the build fails automatically.
*   🌍 **Holistic Fitness Function**: Checks the entire system. Example: *Simulate taking down a database node and measure if the system recovers in under 5 seconds*.

```python
# Example of an automated Fitness Function
def check_circular_dependencies(architecture_model):
    cycles = detect_cycles(architecture_model)
    if cycles:
        raise ArchitectureViolation(f"Stop! Circular dependency found: {cycles}")
```

---

## 2. ⏱️ Technical Debt and Cycle Time

> **Feynman Insight:** Cycle Time is like measuring how long it takes a car factory to build a car: from raw steel in to finished car out. A new, well-organised factory does it in 1 day. A factory that has accumulated years of ad-hoc workarounds takes 3 weeks because each car has to navigate around all the legacy machinery. When Cycle Time grows, it's a measurement of accumulated architectural debt — not developer slowness. MTTR is the fire drill practice time: how fast can the firefighters respond when the alarm sounds?

Architects must prove their design works by measuring it. 

If your architecture makes it hard to code, it's a bad architecture.

### 🔄 Cycle Time
*   This measures speed. How long does it take an idea to go from a developer's brain directly into production?
*   A long cycle time means high technical debt. Clean architecture keeps this fast.

### ⏱️ MTTR (Mean Time to Recovery)
*   Systems will fail. It's guaranteed.
*   MTTR measures **how fast** you bounce back. 
*   If a service crashes, does it take 2 hours to manually reboot, or 2 seconds for an orchestrator to spin up a replacement?

---

## 🤔 Reflection Questions

1. **Imagine adding a fitness function that fails a build if code execution takes over 200ms.** How does this structurally prevent the system from getting slowly bloated over 3 years?
<details>
<summary>💡 View Answer</summary>

The fitness function acts as an **automated architectural guardrail** that runs in CI on every commit. Without it, performance degrades gradually — each commit adds 1ms of latency, and after 3 years nobody notices until the system is 10x slower. With the 200ms threshold, any commit that pushes latency above 200ms **breaks the build immediately**, forcing the developer to fix or optimize before merging. As *Building Evolutionary Architectures* (Ford, Parsons, Kua) explains, fitness functions are the architectural equivalent of unit tests — they make architectural requirements measurable, automated, and impossible to silently violate.
</details>

2. **If your Cycle Time jumps from 1 day to 3 weeks over a year, what does this mathematically prove about your codebase?**
<details>
<summary>💡 View Answer</summary>

It mathematically proves that your codebase has accumulated **structural coupling** — changes that should be isolated to one module now require touching multiple modules, code reviews take longer, merge conflicts increase, and testing requires more integration time. As *Software Architecture Metrics* explains, Cycle Time is a proxy for architectural health: a healthy, well-decomposed architecture has short cycle times because changes are isolated. When cycle time grows 21x (1 day → 3 weeks), it proves the architecture has degraded — boundaries have been violated, dependencies have tangled, and the system resists change. This is the exact signal that triggers architectural refactoring.
</details>

---

## 📝 Key Interview Talking Points

*   **Continuous Governance**: Good architecture isn't just a diagram you draw once. It must be actively protected every single day using automated Fitness Functions.
*   **Design for Change**: Always assume your database will change. Always assume scale will 10x. Evolutionary architecture expects flexibility natively.
*   **Metrics over Opinions**: Use MTTR and Cycle Time to prove your architectural decisions are objectively working. Show hard data.

---

[<< Previous: Architecture Hard Parts](./25_Software_Architecture_Hard_Parts.md) | [Home: System Design Curriculum](./README.md) | [Next: C4 Model >>](./27_Visualising_Software_Architecture_C4.md)
