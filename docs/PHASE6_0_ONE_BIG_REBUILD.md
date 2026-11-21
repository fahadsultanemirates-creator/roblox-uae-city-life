# UAE City Life — Version 6.0 One Big Rebuild

**Status 21 November 2026:** This is one consolidated Luau installer (approximately 67 KB), delivered on GitHub and checked for source consistency. It has **not been executed in your Roblox Studio**, has **not been gameplay-validated**, and has **not been published**. It is a substantial next prototype, not a finished international-quality production game.

## Do this once — safely

1. Open the **saved working v5.5 UAE City Life game**, not a new Baseplate. Ensure the v5.4 Dubai City Atlas is present.
2. Press the red **Stop** button to leave Play. Save a complete backup using **File > Save to File As**, e.g. `UAE_City_Life_v5_5_BACKUP.rbxl`.
3. Open [**the one v6.0 installer**](../build/Patch_UAE_City_Life_v6_0_OneBigRebuild.luau) on GitHub, click **Raw**, select all code and copy.
4. Open Roblox Studio **Command Bar**, select its old code and replace it with the entire v6.0 code. Click the Command Bar's small **Run** button.
5. In the **Output** window verify it prints `UAE CITY LIFE PHASE 6 INSTALLED`. If a red error appears, **don't keep re-running**; save the screenshot and share it.
6. Save a **new file** `UAE_City_Life_v6_0.rbxl` and keep your v5.5 backup intact.
7. Click the main **Play** button, let the server create the v6.0 runtime content, click inside the 3D game viewport. Some of the new objects exist **during Play only**, not in Edit.
8. Watch Output for startup logs starting with `[UAE60]`. Check any red errors and note the script name / line.

The installer preserves v4–v5.4 city districts and keeps old v5.5 scripts as **disabled backups** to avoid duplicate services. It replaces their 5.5 graphics, citizen, activities and crash loop with Phase 6 systems. Your 5.4 map, camera, drivable car controls, City travel and older missions remain in the saved place.

The v5.5 build you used creates `Phase55_LivingCity` and scripts `UAE55_WorldAndInteriors`, `UAE55_InteractiveCity`, `UAE55_TrafficAndVehicles`, `UAE55_R15Pedestrians` and `UAE55_CityLifeHUD`. Phase 6 recognizes this layout and disables these outdated runtime scripts (without deleting them), specifically to avoid the malformed wheel models and duplicate service menus. The alternative earlier `Phase55_RealLife` and `Phase55_ProductionPass` layouts are also accepted.

## What's built

### 1. Improved visible vehicles and tyres
- Re-skins driven police, ambulance, Civil Defence, taxis, SUV, sedans and buses **where the vehicle has a `VehicleSeat`** and an identifiable model.
- Repairs visible geometry: upright circular cylinders on horizontal axles, hubcaps, body panels, side windows, roof lights, grille, bumpers and basic bilingual vehicle markings. Includes static police/fire fleet and selected buses.
- Existing seat interaction and previous `UAE_Driving` system remain intact. New tyres are **decorative**, not physically driven suspension; collision handling is an approximation based on travel distance and forward raycasts.
- A new repair workshop is near **x=-320, z=-1030**. Use **E** at the garage terminal with an appropriate vehicle parked nearby. Cosmetic bumper colour changes after a detected crash.
- Adds **six road-following, non-colliding E11 civilian traffic cars**, or four with `LOW_PERFORMANCE=true`. They slow down for nearby players and other scripted traffic rather than passing straight through each other.
- Cars are visibly better-proportioned *procedural Roblox Parts*, **not** imported real-world production car meshes or fully realistic car physics.

### 2. Pilotable plane and helicopter
- A procedural passenger jet appears near **x=-1160, z=-1370**, on the airport apron.
- A scenic helicopter appears near **x=-1070, z=-790**, near the west-side viewpoint.
- Walk near the aircraft, press **E** to enter the pilot seat. Aircraft are server-moved via PivotTo in bounded ranges and have arcade-style controls. They can fly around the game's modeled districts; the motion is not aerodynamics.
- **W** = forward, **S** = slow/reverse, **A/D** = turn, **R** = climb, **F** = descend. An on-screen 6-button cockpit appears while seated. Hold buttons to move.
- The previous phase's non-playable animated metro, yacht, helicopter and airplane scenery is preserved separately.
- No air traffic control, physics-based landing gear, commercial airline brand assets, full airplane interiors or true passenger boarding yet.

### 3. Functional everyday destinations
- **Al Wasl hotel lobby at (-550,-920)**: E-check-in, collect room key, use lift to the guest room, check out. Reward: 40 temporary CityPoints.
- **Dubai hospital at (-235,-1095)**: patient registration, nurse triage, doctor examination, pharmacy discharge. Reward: 55 temporary CityPoints.
- **DXB terminal at (-1080,-919)**: flight check-in, baggage security, passport control, boarding-gate roleplay. After a short simulated transfer, you arrive at the airport arrivals area. Reward: 75 temporary CityPoints.
- **Dubai Police public desk at (-1125,-474)**: community report then duty officer. Reward: 35 temporary CityPoints.
- **Civil Defence at (-1120,-624)**: emergency drill and safety inspection. Reward: 35 temporary CityPoints.
- **Karak Café at (-225,-594)**: tea order and service feedback.
- Interiors include walkable floors, reception counters, waiting seating, signage, lighting and multi-step server-checked interactions. They are **open-front prototype rooms**, not highly detailed full hospitals, hotel towers or terminals.

### 4. More human NPCs and city details
- Up to **12 R15 humanoid pedestrians** with color-coded uniforms and limited local walking routes around service areas, shopping/tourist locations and the park.
- Roblox default R15 animation is attempted; some NPC appearances/animations depend on Creator Hub assets and Studio permissions.
- More E11 streetlights, decorative palms, crossing lines, medical and airport entrances, hotel drive-up, balanced shadows, atmosphere and glass.
- Set `LOW_PERFORMANCE=true` in the installer (near the top) if the Dell laptop becomes unresponsive. That reduces NPCs and visual effects.

### 5. Eight additional career routes
Open **CAREERS** or press **L** in Play to start:
1. Luxury Hotel Concierge
2. DXB Ground Services
3. Ambulance Community Response
4. Police Response Patrol
5. Civil Defence Safety Duty
6. Helicopter Sightseeing Pilot
7. Passenger Jet City Tour
8. Dubai Airport Taxi Transfer

The new careers have multi-stop GPS destinations, visible markers, a distance readout and server-checked checkpoints. These are **roleplay missions based on reaching places**, not animated medical procedures, interacting passengers or a GTA-like mission campaign. Previous missions remain available.

## Important user controls

| Control | Action |
|---|---|
| **E** near a terminal or pilot seat | Interact / check in / enter aircraft |
| **W, S, A, D** in an aircraft | Forward / reverse / turn |
| **R / F** in an aircraft | Climb / descend |
| **L** / CAREERS | Phase 6 career missions |
| **M** | Existing v5.4 full Dubai atlas |
| **K** | Existing v5.4 missions |
| **J** | Earlier v5.3 roleplay jobs |
| **I/O**, or **=/-** | Camera zoom, where supported by Roblox; fallback on-screen controls remain |
| Right-mouse-drag | Rotate camera |

## Practical test priorities
1. **Ambulance wheel geometry**: compare the same ambulance to the previous screenshot; ensure all wheels sit as wheels beside the body, not black posts.
2. **Car driving**: enter an old police/ambulance/taxi vehicle and check steering/zoom; make sure the new cosmetic body moves with it.
3. **Garage repair**: detect one qualifying collision, then park and repair. This is approximate and may miss certain incidents.
4. **Hotel**: check-in → room key → elevator → check-out.
5. **Hospital**: patient registration → nurse → doctor → pharmacy.
6. **Airport**: check-in → security → passport control → boarding; confirm transport to arrivals.
7. **Aircraft**: walk to plane/helicopter → E → pilot → W/S, A/D, R/F → exit. Test in open space to avoid clipping.
8. **Humans**: look for R15 people and local walking at hotel, hospital, airport, park.
9. **CAREERS**: choose a career and navigate to the first checkpoint; confirm mission update and score after finishing.
10. **Performance**: map, day/night, older missions, City menu and new aircraft all coexist and run smoothly on the laptop.
11. **Output**: photograph the **first red error** if any script fails, with line number and script name.

## Rollback and remaining production work

If v6.0 causes problems, **open the untouched v5.5 backup .rbxl** rather than running older installers on top of it. Phase 6 changes the visible skin of existing vehicles and disables older scripts; that is why a backup is essential.

For the requested *international-level* art quality, this code-driven rebuild alone cannot deliver the final visual target. Roblox's official [3D Importer](https://create.roblox.com/docs/studio/importer) supports custom **FBX/OBJ/glTF meshes and PBR textures**, while custom rigged characters need a separate art and animation pipeline. Our next production work should prioritize authored/legally licensed imported emergency vehicle, civilian car, jet/helicopter, building interior, character clothing and animation assets, plus collision rig/vehicle physics, AI traffic, multiuser testing, performance/LOD and persisted progress. **No external assets are bundled in v6.0.**
