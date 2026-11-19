# UAE City Life — Version 5.5: Living City + Graphics Pass

**Date:** 19 November 2026. **Status:** GitHub code and all-in-one installer uploaded; source/dependency checks pending final confirmation. **Not yet Play-tested in Roblox Studio or published to Roblox.**

This is an **incremental functional and visual patch** built upon your **working v5.4 game**. It does **not** replace your earlier city or copy Brookhaven/GTA assets.

## Install the patch safely

1. In Roblox Studio, open your **saved working v5.4** project containing `Workspace > UAE_City_Life > Phase54_CityExpansion` and `Phase52_RoleplayDistrict`.
2. Click **Stop**; do not use the installer while in Play mode.
3. **File → Save to File As**: make an independent `Roblox_UAE_City_Life_v5_4_BACKUP.rbxl`.
4. Open [**v5.5 Living City all-in-one installer**](../build/Patch_UAE_City_Life_v5_5_LivingCityAndGraphics.luau), click **Raw**, then select and copy all text (Ctrl+A, Ctrl+C).
5. In Studio, open the **Command Bar**, click inside it, **Ctrl+A** to remove old pasted code, then **Ctrl+V** with v5.5. Click the small **Run** button on the Command Bar.
6. You should see `UAE CITY LIFE v5.5 INSTALLED` in **Output**. This installs scripts and a named folder; **the new scenery, vehicles and NPCs are built by server scripts when Play begins**.
7. Save a **NEW file** named `Roblox_UAE_City_Life_v5_5.rbxl`, then click **Play**. Open Output and check for the v5.5 world/services/traffic/R15 start messages.
8. If you see a red error, capture the complete Output line and script name. Do not paste the installer a second time until we diagnose it.

By default `PERFORMANCE_MODE=true` in the first few lines of the installer for the older Dell laptop. This runs **8 moving new traffic vehicles and up to 7 R15 figures**. If performance remains comfortable you may try `PERFORMANCE_MODE=false` **on a second backup copy** for 12 vehicles and up to 10 figures. Existing earlier-generation traffic and people are not removed.

## Three priorities completed at prototype level

### 1. Graphics and environmental details
- Improved E11 vehicle silhouettes (sedans, SUVs, vans, taxis): windows, lights, grille, door handles, roof signs, four correctly oriented rubber tyre wheels and simulated visual wheel spinning.
- A wheel-axis correction pass for older eligible personal/emergency/static vehicle models, since some cylinders in earlier phases were incorrectly horizontal. This **does not** replace the whole driving system.
- New accessible hotel, hospital, airport, police and Civil Defence annex interiors with marble floor, reception furniture, lighting, glazing, signs in English/Arabic and benches.
- Improved road crosswalks and city direction signs, restrained colour correction and atmosphere.
- Up to 10 standard R15-style pedestrian/service humanoid rigs with basic custom part colours. Some visitors move within a small pedestrian area.

**Visual quality limitation:** these structures are still made mainly from procedural Roblox Parts, with some Roblox R15 humanoids. They are **not photorealistic 3D mesh assets**, do not replace all older blocky buildings, and don't provide professionally rigged clothing or licensed brand-identical vehicles. A final high-quality graphics overhaul will need original or properly licensed MeshParts/PBR textures, animations, optimized LOD and artist review.

### 2. Working city businesses — approach and press E
- **Dubai Hospital Reception** (~X -235, Z -1090). Check in, then use treatment counter to restore player health and earn session CityPoints.
- **Al Wasl Hotel Reception** (~X -550, Z -870). Register for a guest room, visit the rest station, restore health and earn session points.
- **DXB Passenger Terminal** (~X -1150, Z -996). Collect an airport check-in pass, then approach boarding. This provides a **simulated sightseeing transfer (teleport) to Dubai Marina**, not real air travel or a flyable aircraft.
- **Dubai Police Reception** (~X -1120, Z -475). Make an incident report or join rescue response.
- **Dubai Civil Defence Reception** (~X -1120, Z -650). Start a road rescue response.
- **Accident training scene** (~X -830, Z -740). Follow a 4-stage rescue scenario: start shift → inspect accident → clear road → repair car. Completion briefly clears engine smoke, changes damaged bonnet and awards temporary points. The scene resets for other players.

These are working **roleplay systems with server-checked proximity, sequence validation and simple cooldowns**. They are not a full car crash physics simulation, full medical treatment simulator, realistic airline operations or hotel room inventory. Rewards are **session-only**.

### 3. Pedestrians and road traffic
- Visual traffic on a section of E11 is assigned to fixed individual lanes, in a uniform loop, with no crossing between the new lanes. **They cannot be driven and are not full obstacle-aware AI cars.**
- Standard Roblox **R15** staff and civilians (up to 7 by default), using basic role-based colour styling, are generated with Roblox's built-in rig API. At least some pedestrians use `Humanoid:MoveTo` for short walks; their appearance remains stylized.
- Existing player vehicles and earlier driving scripts remain available; the new wheel correction aims to improve appearance, **not physics**.
- No new emergency fleet license rights, third-party outfit assets or copyrighted game files are bundled.

## Interface
- Existing **M** full map / radar, **K** missions, **B** city menu, earlier JOBS and camera controls are retained.
- v5.5 map catalogue grows from **32 to 38 locations**, including the actual new service interiors and accident scene. Search **Hospital Reception**, **Al Wasl Hotel**, **Airport Passenger Check-in**, **Police Reception**, **Civil Defence** or **Accident**.
- Press **L** or click **LIFE** below the Dubai clock to see service instructions.
- After a service interaction, a small banner gives the result. When appropriate, a right-side service GPS box gives distance to the next area.

## Suggested 10-minute playtest
- [ ] Confirm `UAE CITY LIFE v5.5 INSTALLED` in Edit-mode Output.
- [ ] After Play, confirm `[UAE v5.5] 5 enterable service annexes`, `Interactive city services started`, and `higher-detail E11 lane traffic` messages.
- [ ] Open MAP (M), search `hospital reception`, navigate there. Approach a reception counter and press E to check in, then E at treatment.
- [ ] Visit Al Wasl Hotel; check in and try the guest-room rest interaction.
- [ ] Visit the airport annex; receive a boarding pass and test the short simulated Marina transfer.
- [ ] Visit Police or Civil Defence; accept road rescue and follow the service GPS to the accident area.
- [ ] Inspect accident, clear road, repair car; verify the smoke clears briefly and 140 session CityPoints are awarded.
- [ ] Check that the new cars have upright tires and move only within their designated E11 lanes.
- [ ] Walk near an R15 NPC. Check whether it appears, animates/walks and doesn't cause severe slowdown.
- [ ] Verify existing homes, CITY, JOBS, older driving, clock, missions, minimap and zoom still work.
- [ ] Check frame rate on the Dell laptop, especially at the airport with crowds.

**Important:** GitHub upload and static source checks are not equivalent to Play testing. Some v5.5 features may need fixes after observing your Studio Output. Screenshots from the hospital, accident, taxi traffic and in-game map will help identify those changes.

## After playtest: path to a publishable game

The next production milestones are: real driveable rigid-body cars with reliable wheel placement and safe crash/contact handling; traffic obstacle avoidance and pedestrian crossing logic; custom licensed 3D assets, textures and animation; detailed clinic/hotel/airport building interiors and staff AI; secure persistent economy and home ownership; server performance profiling and LOD; mobile/gamepad controls; multiplayer and publication testing. Don't claim this game is complete until those are working under real Play testing.
