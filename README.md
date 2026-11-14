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
