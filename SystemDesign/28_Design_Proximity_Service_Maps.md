# 28: Design a Proximity Service (Maps)

<p align="center">
  <img src="images/sys_proximity_service.png" alt="Proximity Service Design" width="100%"/>
</p>

> 🧠 **The Feynman Hook:** Finding "coffee shops near me" is trivial when there are 10 shops. It's an engineering challenge when there are 10 million. Scanning every shop's latitude/longitude for every query would be like calling every person in the country to ask if they live near a specific address. Geospatial indexing is the postal code system: instead of scanning everywhere, you divide the world into zones (geohash boxes) and only search within your zone and its 8 neighbours. The longer the postcode, the smaller and more precise the zone.

## 🎯 What You'll Learn

> **After this chapter, you will understand how apps like Uber, Tinder, and Yelp find things near you.**

How do you find all the coffee shops within a 5-mile radius quickly? 

You cannot scan millions of restaurants every time a user opens map. You must divide the world geographically using clever databases.

---

## 1. 🌍 Geospatial Indexing

> **Feynman Insight:** Latitude and longitude are two-dimensional coordinates. Traditional databases are great at filtering a single column (fast), but terrible at filtering two columns simultaneously (slow, requires scanning everything). Geohashing converts two dimensions (latitude, longitude) into one dimension (a string like `9q8yy`). Now the database just does a prefix string match — the same fast operation it does for any index — and finds all locations in the same geographic box.

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

> **Feynman Insight:** Sharding by geohash prefix is like a library that physically stores books by their Dewey Decimal prefix on specific shelves. All books starting with "530" (Physics) are on shelves 1-3. You never have to search the whole library — you go directly to shelves 1-3. All nearby locations share a geohash prefix, so they physically live on the same database shard — making proximity queries a single-shard lookup instead of a full cluster scan.

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
<details>
<summary>💡 View Answer</summary>

City-based sharding creates **massive hot partitions**. The "New York" shard handles millions of location queries (8.3 million residents + millions of tourists), while the "Wyoming" shard sits nearly idle (580,000 residents in an area 100x larger). This is the classic hot partition problem: load is distributed by population density, not geographic area. **Geohash-based sharding** solves this by dividing the Earth into equal-sized grid cells. Dense areas like Manhattan generate many small geohash cells (more partitions), while sparse areas like Wyoming generate fewer large cells — naturally balancing load. As Alex Xu's proximity service design explains, geohash length determines cell size, and the system uses shorter geohashes for sparse regions and longer ones for dense areas.
</details>

2. **If a driver is constantly moving (like Uber), how do you prevent the Quadtree from constantly breaking and rebuilding every second?**
<details>
<summary>💡 View Answer</summary>

You don't update the Quadtree in real-time — that would be far too expensive. Instead, use a **dual-layer architecture**: 1) The Quadtree is rebuilt periodically (every 5-15 minutes) for static or slowly-changing data (restaurants, gas stations). 2) For rapidly moving objects (drivers), store their current position in a **fast in-memory store** (Redis with geospatial indexes using `GEOADD`/`GEORADIUS`). The driver's app sends GPS updates every 3-5 seconds, and Redis updates the position in O(log N). Proximity queries combine the static Quadtree results with real-time Redis positions. As Alex Xu's design shows, this separation of static and dynamic data is essential for location-based systems.
</details>

---

## 📝 Key Interview Talking Points

*   **Geohashing**: Show you know that geohashing is just converting 2D space into 1D strings using grid subdivision.
*   **Prefix Matching**: Explain that databases excel at prefix string matching (`LIKE 9q8%`), which maps perfectly to finding places inside a specific Geohash sector.
*   **The Edge Case**: Always mention "Boundary Edge Cases". If you search a radius, you must check the 8 neighboring sectors just in case the radius crosses the grid boundary.

---

[<< Previous: Visualising Software Architecture](./27_Visualising_Software_Architecture_C4.md) | [Home: System Design Curriculum](./README.md) | [Next: Metrics Monitoring System >>](./29_Design_Metrics_Monitoring_System.md)
