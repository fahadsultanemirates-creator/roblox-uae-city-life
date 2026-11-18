# UAE City Life — Version 5.3 Controls + Community Jobs

**Status — 18 November 2026:** GitHub source uploaded and checked for consistency. **Not run in the user's Roblox Studio, not Play-tested, not published on Roblox.** This is an **incremental patch** on top of your saved v5.2 game. It is not a Brookhaven graphics replacement.

## Install once

1. In Windows Roblox Studio, open your **saved v5.2 place**. It must have `Workspace → UAE_City_Life → Phase52_RoleplayDistrict`. Do **not** open a blank Baseplate.
2. Press the red **Stop** button. Make sure you are in **Edit** mode.
3. Back up with **File → Save to File As** to `UAE_City_Life_v5_2_backup.rbxl`.
4. Open [**v5.3 single-script patch**](../build/Patch_UAE_City_Life_v5_3_ControlsAndJobs.luau) on GitHub. Click **Raw** and press **Ctrl+A**, **Ctrl+C**.
5. In Roblox Studio's **Command Bar** (bottom), select its old code using **Ctrl+A** and paste with **Ctrl+V**.
6. Click the Command Bar's little **Run** button. Look in the **Output** panel for `UAE CITY LIFE v5.3 READY` or any red error message.
7. Confirm Explorer contains `Workspace → UAE_City_Life → Phase53CommunityPark`. Save this place as **`Roblox_UAE_City_Life_v5_3.rbxl`** (not over the backup).
8. Press the blue **Play** button. **Click once inside the game viewport** before testing keyboard keys. Close or minimize the Command Bar while playing so text editor focus cannot intercept I/O.

**The command-bar Run button executes installation; the main blue Play button tests the game.** Those are different actions. The success print in the code editor itself is not a result; check the **Output** window.

## Version 5.3 controls — requested scheme

| Input | In the game |
| --- | --- |
| **I** | **Zoom IN** — world camera moves closer |
| **O** | **Zoom OUT** — world camera moves farther away |
| Small **I+ / O−** buttons at right | Click/tap to zoom if keyboard input is unavailable or Studio is not focused |
| Mouse **right-button + drag** | Rotate / look around the player or vehicle; drag vertically to look up or down |
| Mouse wheel/touchpad scroll | **No custom camera zoom** in v5.3; the mouse is for looking around |
| **C** | Reset the camera position |
| **PageUp / PageDown** | Raise / lower the viewpoint |
| **CITY** / B | Existing locations and personal vehicle menu |
| **JOBS** / J | New roleplay job selection |
| **MAP** / M | Existing full city map |

The previous `UAE_V52_Camera` script is removed when installing v5.3. A new camera script binds **I/O with ContextActionService** at higher priority and also polls held keys for repeated zoom. This is designed to override Roblox's built-in I/O handling **while the game viewport has focus**. Clickable camera zoom buttons work independently of keyboard focus.

## New walkable Dubai roleplay park
`Phase53CommunityPark`, centered between the earlier v5.1 villas in the v5.2 residential district:
- Landscaped family park with fountain/water sculpture, tiled walkway, benches, decorative palms and lighting.
- Three job kiosks with **E** proximity prompts.
- Rest interactions at park benches (small server-checked health recovery with cooldown).
- Park lights linked to the pre-existing accelerated day/night hour when its shared attribute exists.
- Designed with procedural Roblox Parts and lightweight models; the look is **stylized rather than photorealistic**.

**Find it:** In Play mode click **CITY → Homes & Villas**, then walk from the residential street toward the central park with its family-park sign and fountain.

## Three real playable prototype jobs
Use **JOBS** on screen, press **J**, or use a kiosk at the park:
1. **Taxi Driver** — visit Karak Cafe, Hotel Al Wasl, then the residential taxi stand. Reward: **55 temporary CityPoints**.
2. **Clinic Helper** — visit Dubai Clinic, park, and clinic again. Reward: **55 temporary CityPoints**.
3. **Dubai Tour Guide** — visit the family park, Sheikh Zayed Road, and Burj Khalifa area. Reward: **70 temporary CityPoints**.

You receive a bottom-center task status, distance indication and a local destination marker. Checkpoints require physically being within ~24 studs, and points are awarded on the **server**. You can end a shift using **JOBS → End current shift**.

These are **checkpoint-based prototype jobs**, not yet simulated passengers, medical treatments, or real business operations. CityPoints and job progress do **not** persist across servers.

## Why this is different from Brookhaven RP
The design goal is a **fully original Dubai/7-emirates roleplay game** with houses, jobs, open businesses, driving and local landmarks. Brookhaven is design inspiration, and no copyrighted Brookhaven game maps, vehicles, code, logos, character assets or textures have been copied. Roblox Part-based buildings remain visually basic compared with custom modeled games. The next substantial art/engineering milestones would be licensed/imported 3D assets for Dubai vehicles and landmark buildings, integrated interior systems, optimized traffic, improved collision/physics and multiplayer playtesting.

## Check before continuing to v5.4
- [ ] v5.3 installer prints `UAE CITY LIFE v5.3 READY` in **Output** with no red error.
- [ ] New `Phase53CommunityPark` folder appears in **Explorer**.
- [ ] Press **Play**, click inside the 3D game area, then I moves camera in and O moves it out.
- [ ] The **I+ / O−** buttons visually change the camera distance indicator.
- [ ] Mouse **right-drag** rotates camera both horizontally and vertically, and scroll is no longer needed for zoom.
- [ ] I/O also works while driving.
- [ ] CITY → Homes & Villas still teleports safely near the neighbourhood.
- [ ] Park entrance, fountain, greenery, benches and three role kiosks are visible; players do not sink into the ground.
- [ ] JOBS menu opens, one role starts, progress appears and checkpoint completion updates task.
- [ ] Completed role awards exactly the displayed temporary CityPoints.
- [ ] Existing minimap, Dubai GST clock, missions, emergency vehicles and four UAE flags still exist.
- [ ] Laptop is responsive after Play starts.
- [ ] Save a new local .rbxl once tested; keep older backups.

If the I/O keys still don't work after clicking the game area, **use the new on-screen I+ / O− buttons** and send a photo of the Output errors and the camera distance label. That will distinguish keyboard focus from a broken camera script.
