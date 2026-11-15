# Release notes — Version 5: Dubai Modern City (development build)

**Status (2026-11-15):** Uploaded to GitHub, source-level checks only. This is **not** a tested Roblox Studio place file or a live published game. The user must apply the upgrade to their saved v4 Roblox Studio game and test it.

## Why this patch exists
The user reported: a big HUD, no minimap zoom, no easy camera up/down controls, visually wrong tire orientation, a huge red patch on the fire truck cab, coarse graphics, empty streets, and a city that does not yet feel like modern Dubai. Reference screenshots from a GTA Vice City mobile version were supplied as **style/function guidance**. This build does not copy GTA textures, code, maps, characters or other game assets.

## Install safely (Windows Roblox Studio)

**Choose just one:** 
- **Recommended for the Dell laptop:** [Phase 5 Lite installer](../build/Upgrade_UAE_City_Life_Phase5_DubaiModern_LITE.luau)
- **Higher detail:** [Phase 5 Full installer](../build/Upgrade_UAE_City_Life_Phase5_DubaiModern.luau)

Do NOT run both on the same copy.

1. Open your **saved v4 Roblox place** in Roblox Studio (the place that shows the Phase4_MegaCity folder in Workspace). Do not open a blank Baseplate.
2. **File → Save to File As** and create a backup: `Roblox_UAE_City_Life_v4_backup.rbxl`.
3. Click **Stop** if you're playing.
4. Open the chosen installer on GitHub. Click **Raw**, press Ctrl+A then Ctrl+C.
5. In Roblox Studio, click the **Command Bar**, Ctrl+A to select old text, Ctrl+V to paste v5, then **Ctrl+Enter** to execute it.
6. Wait for the Output line starting `UAE V5 DUBAI MODERN READY`. If an error appears instead, **do not save over v4**. Send the exact error line and a screenshot.
7. In **Explorer**, confirm `Workspace > UAE_City_Life > Phase5_DubaiModern`. For easy navigation, select the `SheikhZayedRoadE11` child of that folder and press **F** to frame its content.
8. Save to a NEW local file: `Roblox_UAE_City_Life_v5_Lite.rbxl` or `..._v5_Full.rbxl`.
9. Click **Play**. Check the compact minimap, more detailed roads, moving transport, emergency vehicle tyres, mission boards, R15 citizens and camera controls.
10. Do not publish the build publicly until the Output window is free from important errors and Play mode is acceptable on your computer.

## Features added

### Compact HUD and controls
- **Original**, smaller 132 × 132 circular radar at top left. Keeps user centered; redraws nearby streets, **maximum three visible destination pins**.
- Zoom the radar with its small **+ / −** buttons or mouse wheel over the radar.
- Click the radar, the **MAP** button or press **M** for a full expanded schematic city guide.
- Tiny top-right **actual Dubai clock, GST UTC+4**, with separate accelerated game day/night time. Does not falsely use accelerated game time as Dubai's real time.
- Mission status is a **single compact bar at bottom left**.
- On foot, normal Roblox camera zoom and right-drag camera movement, zoom range 5–85 studs.
- While driving an emergency vehicle: scroll to zoom camera, right mouse drag to rotate/orbit, **PageUp / PageDown** tilt up/down, **C** resets the camera.

### Vehicle and road corrections
- Rebuilds the rubber tyres of all three emergency vehicles, putting **Cylinder thickness on its X axis** so wheels stand vertically. Fixes their silver rim placement as well.
- Applies the same wheel-orientation fix to existing **52 v4 moving traffic vehicles**.
- Removes the enormous rectangular **red cab badge and stripes** that covered the yellow Civil Defence fire truck door, replacing them with a smaller yellow-and-red readable label.
- Retains blue/white ambulance, yellow/red Civil Defence vehicle, white-and-dark-green police car with white Arabic lettering. Photo-accurate vehicles are **NOT** yet achieved.
- Adds a dedicated straight boulevard (Sheikh Zayed Road **E11-inspired**) with multiple lanes, dashed road stripes, pavement and bilingual guide gantries.
- This v5 does not implement collision-aware AI; v4 automatic cars are still visually route locked, not physical traffic.

### Modern Dubai attractions and city
- 15 varied high-rises (half that number in Lite), sunny stone-and-glass architectural details, window bands and rooftop accents.
- Original tall Burj Khalifa-tier model's glass coloring refined.
- **Museum of the Future–inspired oval** near the E11 road, with a plaza and Arabic/English signage.
- **Dubai Frame** (landmark-scale gold arch).
- **Burj Al Arab–inspired** sail hotel.
- Dubai medical centre, E11 hotel, modern mall, Souk/Cafe and visitor desk.
- More palm trees and warm night street lighting.
- Existing 7 emirate zones and **exactly 4 UAE flags are preserved**; no new flags added.

### Public transport, waterfront, airport
- Elevated Dubai Metro station, rails and **moving, driverless decorative train**.
- Airport runway, terminal district and a generic Emirates-themed red-tail **widebody plane** (not licensed real Emirates aircraft or actual imported mesh).
- Stylized marina quays with Roblox **Terrain Water**.
- Moving **yacht** and **cruise ship**; scenic **helicopter** with animated rotor; animated flyover airplane.
- These new animated transport props are **not player-drivable/flyable in v5**.
- Up to 12 more local R15 humanoid **residents and tourists** (5 in Lite), with varied body colours and walking routes. Roblox-generated avatars, not realistic human scans. Animation is best-effort.

### Mission foundation
Server-side, checkpoint-distance-validated missions:
- Explorer: Burj Khalifa → Dubai Mall → Museum of the Future.
- Police community patrol: Dubai Mall crosswalk → Sheikh Zayed Road → Museum district.
- Ambulance assistance: UAE Family Park → Dubai Medical Centre.
- Civil Defence safety exercise: Sheikh Zayed Road → community assembly area.

Press **E** near the mission boards to accept one. Each grants temporary **CityPoints** upon completion; CityPoints reset when the player leaves. No persistent DataStore, money economy or real emergency simulated yet.

## Scope and limitations
- These buildings/vehicles are procedural Roblox **Part/Cylinder/WedgePart** models. They can look much better than v1–v4, but they will **not visually equal GTA Vice City, contemporary GTA graphics, or photo-accurate custom 3D models** without external licensed meshes, textures, animation rigs, optimization and substantial art production.
- Some city roads and landmarks are **stylized** and not an accurate street map of Dubai. The map is schematic, not a real GIS basemap.
- No copied GTA, Gulf Afterglow or commercial model assets.
- The available Gulf Afterglow material was a **design brief only**. Its original game source, art assets and renderer were not available for code reuse.
- Vehicles are experimental, and existing anchored drive mechanics and NPC movement may still have glitches. Graphics performance depends on device specs and Roblox Studio quality settings.
- New water terrain is intentionally created and isn't guaranteed to be removed by re-running the script; use backups for experimenting.
- The script has **not been executed by the assistant in Roblox Studio**. It needs user playtesting and fixes based on Roblox Output logs.

## Test matrix before publication
- [ ] Script executes cleanly in Studio **Edit** mode and Phase5_DubaiModern appears.
- [ ] Player still spawns and rainbow owner avatar/tag works; all other players can keep their own avatar.
- [ ] Minimap stays compact and redraws as player moves.
- [ ] Click radar opens full map; + / − zoom; M closes; only three radar pins visible.
- [ ] Dubai GST clock and game day/night show different accurate values.
- [ ] On-foot camera zoom works; vehicle camera can orbit, tilt and zoom, and resets after leaving seat.
- [ ] All three emergency vehicles have correctly **vertical wheels**, and fire truck door is not covered by red panel.
- [ ] Existing civilian cars have corrected tyres, remain on their lanes, and don't visually overlap.
- [ ] New airport, Metro, museum, Burj Khalifa zone, Dubai Frame, Burj Al Arab, hotel, mall and souk can be found.
- [ ] Water is visible and does not cover roads.
- [ ] Metro/train, ferry/cruise ship, yacht, helicopter, aircraft animate.
- [ ] R15 residents appear and do not sink, float or block traffic.
- [ ] At least one mission starts and completes with temporary points.
- [ ] Night streetlights turn on and daytime lights turn off.
- [ ] Exactly four original UAE flags remain.
- [ ] Test **Lite** on Dell FPS first. Compare Full only if computer remains responsive.
- [ ] No repeated scripts/duplicate UI in StarterPlayerScripts.
- [ ] Saved as NEW .rbxl file; old v4 stays safe.

## Next technical work after v5 is tested
1. **Custom mesh modeling pipeline** (Blender/Roblox Studio import) for exact Dubai Civil Defence vehicle, ambulance, green police SUV and high-profile landmarks. This requires a dedicated modeling pipeline and reference-to-mesh asset workflow, not just Lua.
2. Traffic with actual lanes at intersections, signals, pedestrians crossing safely, obstacle avoidance, car suspension and collision.
3. Real metro/boat/helicopter ride mechanics, optimized scripts, mobile controls, better voice/soundscape.
4. Persistent missions, co-op, safe dispatch, path/route UI, rewards balancing, tourism and transport jobs.
5. Terrain/city layout audit, building collisions, purposeful interiors, baking/LOD, performance profiling and publishing.
