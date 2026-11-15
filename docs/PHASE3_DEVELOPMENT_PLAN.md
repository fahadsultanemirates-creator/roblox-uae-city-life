# Development phases — Roblox UAE City Life

Based on the user's playtest feedback (November 2026).

## Reference: Gulf Afterglow
The accessible Gulf Afterglow design brief mentions golden-hour marina visuals, an in-game city map, highways, airport, bridge, city traffic, mission sequences, buildings with enterable interiors and many vehicles. **We have the text design brief, not its project models, source code or complete render captures**. The target style is therefore *Gulf-inspired*, not a direct transfer of the existing game's assets.

## 1 — Visual quality and UI (first priority)
- A readable **top-left map** with markers for all seven prototype districts and a live player dot
- More restrained floating signs, warmer sunset lighting, shopfronts, glass, metal, street furniture
- Better visibility in cars, Arabic vehicle decals in legible colors
- Longer-term: better authentic architectural meshes, detailed roads, realistic water and materials, optimized shadows and lighting for lower-end laptops

**Phase 3A delivered to GitHub:** schematic minimap, buildings and storefront props, sign improvements started in previous build. Visual work remains incomplete.

## 2 — Living city (second priority)
- Realistic routes and streets, crosswalks, parking lots, traffic signal logic
- Ambient taxis, sedans, buses, pedestrians, families, shops
- Modern and traditional landmark areas for all seven emirates
- Arabic emergency vehicle labels: **الشرطة** in white on dark-green police doors; **الإسعاف** on blue ambulance panel; **الدفاع المدني** on yellow fire engine panel
- Proper vehicle physics, traffic collision avoidance and NPC animations are a later upgrade.

**Phase 3A delivered:** six decorative automated low-poly cars, four animated block-style pedestrians, a few shops and crossings. These are not physics vehicles, do not have AI and need in-Studio testing.

## 3 — Missions (third priority)
User-friendly, non-combat roleplay tasks:
1. **UAE Explorer:** reach Burj Khalifa in Dubai, Sharjah Heritage, Ajman Beach. In Phase 3A this is a client-only, non-persistent starter mission. Distance threshold is ~87 studs and progress resets on rejoining.
2. **Ambulance Assistance:** collect a patient from a clinic and reach the hospital within a time window
3. **Fire Safety:** respond to a fire-alert practice and guide civilians to safety
4. **Police Patrol:** safely drive between districts, inspect roads, report suspicious broken traffic signals; no combat
5. **Visitor Welcome:** meet tourists and guide them to landmarks

Future mission implementation requires authoritative server validation, mission status saving, clear markers, cooperative multiplayer support and reasonable rewards. Phase 3A only implements the starter explorer mission, not the five complete systems.

## Phase 3A installation order
The project scripts are incremental and should be executed **in Studio Edit mode only**:

1. Base map generator `build/Create_UAE_City_Life.luau` (already completed by user)
2. Phase 2 `build/Upgrade_UAE_City_Life_Phase2.luau` (already completed by user)
3. **NEW** `build/Upgrade_UAE_City_Life_Phase3A.luau`.

In GitHub, open the link, click Raw, Ctrl+A, Ctrl+C. In Studio, click Stop, select the Command Bar, Ctrl+A, Ctrl+V, then Ctrl+Enter. Verify newly generated `Workspace > UAE_City_Life > Phase3_LivingCity`. Save to a *new* local file as `Roblox_UAE_City_Life_v3A.rbxl`, press Play, and test the map, police doors, traffic and starter mission.

Press **M** to toggle the map panel. A tiny red dot represents your player. Map dots are in-game districts, not a geographically accurate plan of the UAE. New traffic is lightweight scenery, not yet steerable.

## Safety / publishing
Keep backups of v1 and v2. No passwords, codes, Roblox cookie values or tokens belong in GitHub. The repo holds source, **not a live experience**. Roblox Studio still needs the code run, tested and published manually by the intended account. The scripts have not yet been tested in a real Roblox Studio session by the assistant.
