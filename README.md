# 🇦🇪 ROBLOX UAE – CITY LIFE

A first **Roblox Studio prototype** for a friendly UAE roleplay game. **This code has not yet been tested in Roblox Studio or published to Roblox.**

## Included in v0.1
- Stylized districts for **all 7 emirates**.
- Burj Khalifa-inspired tower, Dubai Mall, Grand Mosque-inspired landmark, roads, desert, lagoon, beach, mountains, fort, and palms.
- **Exactly 4 UAE flags**, on buildings.
- Green-and-white police SUV, blue-and-white ambulance, and yellow fire truck built from basic Roblox Parts.
- First-pass arcade driving and entry via ProximityPrompt.
- Everyone keeps their own Roblox avatar; the owner username gets an overhead "GAME OWNER" title.
- A welcome popup and a spawn area.

## How to build it in Roblox Studio (Windows)
1. Open your intended game/place in Roblox Studio and **save a backup** using File > Save to File. Do not overwrite a different place.
2. On GitHub, open **[build/Create_UAE_City_Life.luau](build/Create_UAE_City_Life.luau)**. Click **Raw** and copy the entire text (Ctrl+A, Ctrl+C).
3. In Roblox Studio's editing window (**not** while playing), open the **Command Bar** from the Studio menus (usually in the Script/View tooling).
4. Paste the entire build script in the Command Bar and execute it. The generated map appears under `Workspace > UAE_City_Life`.
5. Press **Play** and walk to a vehicle. Press **E** to enter, then try W/A/S/D to drive. This prototype is **not yet playtested**; adjust as needed.
6. Press **Stop** and save the game. Publish only after verifying the correct Roblox account and destination experience.

The build script replaces only the existing generated `UAE_City_Life` workspace folder and its own specifically named scripts. Other projects are unaffected as long as you run it in the correct place.

## Files
- `build/Create_UAE_City_Life.luau` — single-click city generator with runtime scripts embedded.
- `src/ServerScriptService/` — readable driving and owner scripts.
- `src/StarterPlayer/StarterPlayerScripts/` — readable player input and welcome UI scripts.
- `docs/GAME_DESIGN.md` — the agreed game design and roadmap.
- Concept pictures are supplied in the original ZIP package shared in the project conversation. Source code in GitHub does not automatically upload those images to Roblox.

## Important
The emergency vehicles are **rough block-model prototypes**, not exact copies of the photo references. Arcade movement, multiplayer, performance, and permissions must be tested. Mobile support and detailed buildings are later tasks.

Never put Roblox passwords, verification codes, session cookies, access tokens, or other secrets in this public repository. GitHub and Roblox are different platforms: **pushing to GitHub does not publish your Roblox game**.


## Phase 2 graphics upgrade — available now (separate script)

**Keep your local v1 .rbxl backup.** The Phase 2 code is a non-destructive enhancement for the city you already generated, not a newly published Roblox game.

1. Open your saved `Roblox_UAE_City_Life_v1.rbxl` file in **Roblox Studio**.
2. If you're testing in Play mode, press **Stop**. Stay in **Edit** mode.
3. Open [build/Upgrade_UAE_City_Life_Phase2.luau](build/Upgrade_UAE_City_Life_Phase2.luau) on GitHub. Press **Raw**, then Ctrl+A and Ctrl+C.
4. In Studio, focus the **Command Bar**, paste the Phase 2 script, then press Ctrl+Enter to execute (or the execution shortcut configured in your Studio).
5. Check for `Workspace > UAE_City_Life > Phase2_GulfStyle` in Explorer. Zoom out to find the new waterfront and airport district.
6. **Save to File As** `Roblox_UAE_City_Life_v2.rbxl`, then click Play to test.
7. Enter the fire truck with **E**. It should now use a wider third-person camera. Try **W/A/S/D**. Leave the vehicle to restore the normal player camera.

**What is new:** golden-hour colors and atmospheric lighting, Dubai Marina waterfront, airport and runway, bridge, modern glass-fronted towers, family park, streetlights, reduced billboard clutter, and an experimental third-person camera. These are **stylized Roblox Part models**, not yet production-quality 3D assets.

**What remains to do:** verify the camera and drive controls in Roblox Studio, implement physical wheel behavior and accurate vehicle bodies, refine landmark meshes, improve geographic routing and city traffic, add mobile controls and multiplayer tests. We have not imported the actual meshes or textures from the separate *Gulf Afterglow* game; only its available design brief inspired the lighting and marina direction.

If you run the upgrade a second time, its `Phase2_GulfStyle` folder and `UAE_VehicleCamera` script are replaced, but the original `UAE_City_Life` city and its four UAE flags are preserved.


## Phase 3A — Three-part improvement plan (November 2026)

The next build follows the prioritized plan: **(1) better Gulf-inspired visuals and top-left minimap**, **(2) detailed living city with cars and Arabic vehicle names**, **(3) missions**.

Start from the saved **v2** Roblox place; don't run the Phase 1 or Phase 2 scripts again.

1. Click **Stop** if in Play mode.
2. Open [build/Upgrade_UAE_City_Life_Phase3A.luau](build/Upgrade_UAE_City_Life_Phase3A.luau) on GitHub. Click **Raw**, then press Ctrl+A and Ctrl+C.
3. In Studio's **Command Bar**, Ctrl+A to replace the previous command, Ctrl+V to paste this script, then **Ctrl+Enter**.
4. Check Explorer: `Workspace > UAE_City_Life > Phase3_LivingCity`.
5. Use **Save to File As** to save `Roblox_UAE_City_Life_v3A.rbxl` (keep v2 backup).
6. Click Play: see the **live top-left seven-emirates schematic map**, six moving traffic vehicles, four simple pedestrian models, shops and street details. Press **M** to collapse/expand the map.
7. Inspect the **green-and-white police SUV doors**: the dark green panels should now read **الشرطة in white Arabic lettering**. The ambulance and yellow Civil Defence fire truck also get Arabic text.
8. The first mission is a **UAE Explorer** visit to Dubai, Sharjah and Ajman; it is client-side, experimental and does not save progress. More developed emergency-service missions are future work.

This is a **new prototype upgrade, not yet playtested in Roblox Studio**. The map is a schematic map of game areas, not a real UAE street map. Cars and NPCs are simple automated visual models; vehicle physics, navigation and pedestrian animation still need improvement. The Gulf Afterglow comparison used a saved *text design brief* only, not actual meshes or graphics files. View [docs/PHASE3_DEVELOPMENT_PLAN.md](docs/PHASE3_DEVELOPMENT_PLAN.md) for the whole roadmap.
