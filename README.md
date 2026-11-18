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


## NEW: Phase 4 Mega City beta (November 2026)

**Latest major upgrade:** [`build/Upgrade_UAE_City_Life_Phase4_MegaCity.luau`](build/Upgrade_UAE_City_Life_Phase4_MegaCity.luau)

**Start from your previously saved Phase 2 or Phase 3A Roblox Studio place, not an empty Baseplate.** Press **Stop** before executing. On GitHub select **Raw → Ctrl+A → Ctrl+C**, paste into the Studio **Command Bar** with Ctrl+V, run with Ctrl+Enter, then save **as a NEW file** `Roblox_UAE_City_Life_v4.rbxl`.

**What's new:** 3,300 × 3,100 stud map, three two-lane road rings, eight new urban clusters, 50+ lane-based traffic cars (no crossing routes), up to 15 R15 residents, circular top-left minimap, actual Dubai GST clock, 40-minute in-game day/night cycle, richer road lighting, rebuilt yellow Civil Defence truck and blue/white ambulance based on the supplied reference pictures, white Arabic police lettering **الشرطة** on dark green doors, and improved third-person vehicle camera. Preserves all seven original districts, 4 UAE flags and avatar choice.

**Quality note:** These are procedural Roblox Parts, not exact photo-accurate imported 3D meshes; traffic does not yet have car-to-car collision physics, junction AI or full NPC walking animations; missions remain an early exploration prototype. The source is **uploaded but not yet run or verified in Studio**. For older Dell laptops, edit the script near the top to set `local PERFORMANCE_MODE=true` before executing. Save backups.

See [complete Phase 4 release notes and playtest checklist](docs/PHASE4_MEGA_CITY_RELEASE.md). Do not publish this as a finished product until you have tested it and fixed any runtime errors.


## NEW — Version 5 Dubai Modern City (development build, November 2026)

A larger **optional upgrade** is now available on GitHub. Start from the **saved v4** Roblox Studio project: it preserves the earlier emirates, three emergency vehicles and four UAE flags.

**Choose ONE installer:**
- [**v5 Lite (recommended for older Dell laptops)**](build/Upgrade_UAE_City_Life_Phase5_DubaiModern_LITE.luau)
- [v5 Full visual detail](build/Upgrade_UAE_City_Life_Phase5_DubaiModern.luau)

**Install:** Open your v4 place → File → **Save to File As** to create a backup → click **Stop** → open the chosen GitHub installer and click **Raw** → **Ctrl+A / Ctrl+C** → in Roblox Studio's Command Bar **Ctrl+A / Ctrl+V**, then **Ctrl+Enter** → verify `Workspace > UAE_City_Life > Phase5_DubaiModern` → save a **new** `Roblox_UAE_City_Life_v5.rbxl` → test with **Play**.

**Features:** smaller circular radar with zoom/full-map controls and up to 3 destination pins; compact Dubai GST clock; vehicle camera tilt/orbit/zoom; repaired emergency and civilian tyre axes and smaller fire truck door artwork; stylized Sheikh Zayed Road corridor, modern towers, museum oval, Dubai Frame, Burj Al Arab-inspired hotel, airport with white/red aircraft, elevated metro, yacht, cruise ship and sightseeing helicopter; more Roblox R15 citizens; four starter civic missions.

These are **code-generated Roblox Parts and scripted scenery**, not photorealistic GTA-quality meshes. Transit is primarily decorative and cars still lack full traffic AI. **Not yet tested in Roblox Studio or published.** The original Gulf project's text brief inspired layout and lighting, but no other game's source/assets were copied.

See [the v5 feature list, shortcuts, limitations and complete test checklist](docs/PHASE5_DUBAI_MODERN_RELEASE.md).


## v5.1 update — camera zoom fix + Brookhaven-style roleplay starter

**New incremental hotfix:** [**Patch UAE City Life v5.1 — Zoom and Homes**](build/Patch_UAE_City_Life_v5_1_ZoomAndHomes.luau).

The player reported that v5 zoom did not work as intended. In v5, the +/- buttons only affected the minimap, while the custom camera lacked dedicated on-screen controls outside driving. In **v5.1** there are distinct:
- **Left +/-:** zooms the small minimap, with a visible changing scale
- **Right +/-:** zooms the **actual third-person world camera while walking or driving**
- **Right ↑/↓, PageUp/PageDown, right-drag:** changes viewing angle
- **Map click / M:** shows or hides the full city map

v5.1 also adds **four claimable UAE villas**, owner signs, openable/lockable doors, beds, furnishings and decorative carports. Property claims are **not persistent** yet. This is **original UAE City Life roleplay functionality**, not copied Brookhaven maps/assets or code.

**Install only after Version 5**, not on an empty Baseplate or on v4. In Roblox Studio **stop Play**, back up your v5 place, open the patch link, click **Raw** and copy all the script, paste into **Command Bar** and run with **Ctrl+Enter**. Save as a new `UAE_City_Life_v5_1.rbxl`, then press Play.

For details and test checklist: [docs/PHASE5_1_ZOOM_AND_HOMES.md](docs/PHASE5_1_ZOOM_AND_HOMES.md).

**Status:** Source uploaded and checked, but still requires a Roblox Studio Play test. It is not published to Roblox.


## Current incremental upgrade — **Version 5.2 (18 Nov 2026)**

**Your reported problem:** v5.1's camera zoom still didn't respond; the minimap and signs remained intrusive, and the new district was too hard to find from the original emergency-vehicle spawn. The user requested **I zoom in**, **O zoom out**, and a more interactive **Brookhaven-style** game with its own Dubai identity.

**[Install this standalone v5.2 Roleplay & I/O Zoom patch](build/Patch_UAE_City_Life_v5_2_RoleplayAndIOZoom.luau)** on your already saved **v5.1** Roblox Studio place. **Backup first; STOP Play; copy GitHub Raw script into Studio Command Bar and run Ctrl+Enter.** Save to a new `UAE_City_Life_v5_2.rbxl`.

The code:
- Replaces older camera scripts with a **keyboard-state-polled I/O third-person camera**; camera changes can be seen via an on-screen distance indicator. **I = in; O = out** while walking or driving. Right drag rotates, PageUp/Down tilts, C resets.
- Shrinks the circular radar to **96 × 96 pixels**, reduces the clock/mission overlay and shrinks cluttering original vehicle/welcome signs and owner tag.
- Adds a **CITY** menu (or B key) to travel directly to **Homes, E11, Downtown, Marina and Airport** — no searching the giant map to find new features.
- Adds a walkable **roleplay shopping street** by the v5.1 villas: 6 interactive interiors (clinic, karak cafe, market, hotel, bank, fashion souq), better house facades, gardens, detailed pavement, decorative buses, lighting and six R15 pedestrians.
- Offers **one personal drivable prototype car per player**: taxi, SUV or sedan. It uses existing prototype `UAE_Driving` code, not realistic vehicle physics or licensed imported assets.
- Preserves v5/v5.1 landmarks, roleplay house ownership, three emergency vehicles, exploration missions and the four original UAE flags.

Read [**v5.2 install, exact key controls, feature list, limitations and test plan**](docs/PHASE5_2_ROLEPLAY_ZOOM.md).

**Status:** GitHub source committed, consistency checks pending/complete as documented; Roblox Studio runtime and gameplay still **unverified**. GTA or Brookhaven maps/code/images/assets are **not copied**. Achieving comparably polished art will require genuine 3D modeling, bespoke textures, animation, collisions and performance work beyond this procedural patch.
