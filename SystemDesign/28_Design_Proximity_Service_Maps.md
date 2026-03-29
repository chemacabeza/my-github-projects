# 28: Design a Proximity Service (Maps)

<p align="center">
  <img src="images/sys_proximity_service.png" alt="Proximity Service Design" width="100%"/>
</p>

## 🎯 The Big Goal

> **After this chapter, you will understand how apps like Uber, Tinder, and Yelp find things near you.**

How do you find all the coffee shops within a 5-mile radius quickly? 

You cannot scan millions of restaurants every time a user opens map. You must divide the world geographically using clever databases.

---

## 1. 🌍 Geospatial Indexing

If your database only stores Latitude (X) and Longitude (Y), searching for nearby items requires complex math.

To search fast, you convert the 2D map into a 1D string. 

You slice the world into smaller and smaller boxes.

### 🧩 Option A: Geohashes
*   The world is a giant box. 
*   Cut the box into 4 smaller boxes (A, B, C, D).
*   Cut box A into 4 smaller boxes (A1, A2, A3, A4), and so on.
*   The longer the string (`9q8yy`), the smaller and more precise the box.
*   **Why it's great**: Finding nearby places just means finding places that share the same prefix (e.g. `9q8`).

### 🌲 Option B: Quadtrees
*   This is a tree data structure in memory.
*   If a box has too many places (like New York City), you split the box into four smaller squares.
*   If a box is empty (like the Ocean), you leave it huge.
*   **Why it's great**: It perfectly balances dense cities and empty countryside.

---

## 2. 🗄️ API Design & Database Sharding

Now that you have Geohashes, how do you handle scale?

### 🪚 Sharding by Geohash
*   Put all places starting with `9q` in Server 1.
*   Put all places starting with `8a` in Server 2.
*   This means nearby places are stored together physically, making queries lightning fast.

### ⚠️ Handling Boundary Issues
*   What happens if you are standing exactly on the edge of two Geohash boxes? 
*   **The Solution**: When you search, you must calculate your current box AND the 8 surrounding neighbor boxes to guarantee you do not miss a place right next to you!

---

## 🤔 Reflection Questions

1. **Why is it a terrible idea to shard servers based on City Names instead of Geohashes?** Think about the load on the "New York" server versus the "Wyoming" server.
2. **If a driver is constantly moving (like Uber), how do you prevent the Quadtree from constantly breaking and rebuilding every second?**

---

## 📝 Key Interview Talking Points

*   **Geohashing**: Show you know that geohashing is just converting 2D space into 1D strings using grid subdivision.
*   **Prefix Matching**: Explain that databases excel at prefix string matching (`LIKE 9q8%`), which maps perfectly to finding places inside a specific Geohash sector.
*   **The Edge Case**: Always mention "Boundary Edge Cases". If you search a radius, you must check the 8 neighboring sectors just in case the radius crosses the grid boundary.

---

[<< Previous: Visualising Software Architecture](./27_Visualising_Software_Architecture_C4.md) | [Home: System Design Curriculum](./README.md) | [Next: Metrics Monitoring System >>](./29_Design_Metrics_Monitoring_System.md)
