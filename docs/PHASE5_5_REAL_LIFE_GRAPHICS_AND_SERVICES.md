# UAE City Life v5.5 — Graphics, Working Services and Vehicle Incidents

**Status:** GitHub source delivered. **Not run or verified in Roblox Studio.** This is a playable-systems prototype, **not photorealistic, a complete real-world Dubai replica, or a production-ready game**.

## Install
1. Open your **working v5.4** place in Roblox Studio. Stop Play and save a **v5.4 backup**.
2. Open [the v5.5 all-in-one installer](../build/Patch_UAE_City_Life_v5_5_RealLifeGraphicsAndInteractions.luau). Select **Raw**; copy all text.
3. Paste into Roblox Studio **Command Bar** in **Edit mode** and run. Watch Output for `UAE CITY LIFE v5.5 INSTALLED`.
4. Save as **UAE_City_Life_v5_5.rbxl** (new file), then press Play.
5. The new world objects are created on the **server at Play time**. Watch Output for the v5.5 graphics, activities, vehicle and R15 citizen logs.

## What's implemented
- **Graphics:** Atmosphere, color grading, bloom, shadows, subtle glass reflectance, more E11 streetlights, planters and greenery. Original geometry and low-poly cars remain; lighting is not a substitute for high-quality imported MeshParts and textures.
- **Hotel:** Walk into the new lobby near x=-550,z=-920. Hold the Roblox ProximityPrompt to check in. Use the guest room access terminal; check out from the room. Session-only state.
- **Hospital:** At x=-235,z=-1095, register, complete an examination, then collect a prescription at the pharmacy. Earn 30 temporary CityPoints. This is a roleplay flow, not a real medical simulation.
- **DXB airport:** At x=-1020,z=-980, use the check-in desk, security checkpoint and boarding gate in order. Earn 40 temporary CityPoints. No flyable aircraft or flight mechanics yet.
- **Cafe:** Order karak at the counter near x=-225,z=-595.
- **Cars:** Vehicles with a Roblox `VehicleSeat` get a simple server-side damage attribute from significant collisions while driven. A vehicle near the garage at x=-320,z=-1030 can be repaired with a ProximityPrompt. Damage currently changes a body part's appearance and adds feedback; it **does not** deform meshes, break wheels, apply physical injury, or simulate insurance.
- **Characters:** Six basic Roblox R15 humanoid NPCs are attempted in the new service areas. These are **stationary** NPCs, not realistic animated pedestrians or AI. Their appearance is Roblox-standard, not photorealistic. R15 creation can fail in some Studio contexts; Output will show a warning.
- **Notifications:** Activity results and crash feedback appear at the top of the player's screen.
- **Existing systems:** v5.4 city atlas, GPS, camera and missions are left installed.

## Playtest checklist
- [ ] Output contains installer success and no red runtime errors.
- [ ] Existing city, v5.4 atlas, missions and camera still function.
- [ ] Day/night visuals look acceptable and frame rate remains smooth.
- [ ] Hotel reception check-in, room access and checkout work in order.
- [ ] Hospital registration, examination and pharmacy work in order.
- [ ] Airport check-in, security and boarding work in order.
- [ ] A car with a VehicleSeat registers a significant collision and its `UAE55Damage` attribute increases.
- [ ] Drive/park a car by the garage and repair it.
- [ ] NPCs are visible in the hotel, hospital, airport and tourist areas.
- [ ] Test with **two players** for independent hotel and hospital state.
- [ ] Check that existing roads remain passable; note any new structure overlapping the old map.

## Remaining major work
For realistic graphics and working everyday life, a later art-and-systems production pass must create **high-quality original licensed vehicle meshes**, physical suspension/wheel rigs, interiors with doors/elevators/rooms, functional flights, hospital staff/ambulance AI, walking NPC animation and traffic AI, clothing/face customization, persistence (DataStores), mobile/gamepad UX, sound design, and performance optimization. Do not copy GTA or Brookhaven proprietary assets. Before calling the game complete, do a real Studio multiplayer playtest and publish only after fixing errors.
