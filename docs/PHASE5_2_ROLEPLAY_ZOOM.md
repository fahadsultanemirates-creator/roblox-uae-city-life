# UAE City Life — Version 5.2: Dubai Roleplay & I/O Zoom Repair

**Status, 18 November 2026:** Source code committed to GitHub and checked for internal consistency. **NOT tested in Roblox Studio or published to Roblox.** This update is a follow-on to the saved working **v5.1** place and is intended to improve the current experience, not replace it from an empty Baseplate.

## Install safely — one script

1. Open **your saved v5 or v5.1 place** in Roblox Studio. Confirm Explorer contains `Workspace > UAE_City_Life > Phase5_DubaiModern`. If `Phase51_RoleplayHomes` is missing, the **repaired v5.2 installer now creates the missing v5.1 villas and home interactions automatically**.
2. Use **File → Save to File As** to back it up as `UAE_City_Life_before_v5_2_backup.rbxl`.
3. Press **STOP** to leave Play mode. Be in Edit mode before modifying the world.
4. On GitHub, open the [**v5.2 all-in-one patch**](../build/Patch_UAE_City_Life_v5_2_RoleplayAndIOZoom.luau).
5. Select **Raw**, then Ctrl+A, Ctrl+C to copy all its contents.
6. In Roblox Studio, open **Command Bar**; select previous text with Ctrl+A, paste with Ctrl+V, run with **Ctrl+Enter**.
7. Watch Output for `UAE CITY LIFE v5.2 READY`. If there is an error, do not overwrite the saved v5.1 place. Take a screenshot showing the error text and line number.
8. Explorer should now contain `Workspace > UAE_City_Life > Phase52_RoleplayDistrict`. Save as **NEW** `Roblox_UAE_City_Life_v5_2.rbxl`.
9. Press **Play**, then use the controls and check the improvements. Do not publish until tested.

**Do not rerun v5, v5.1 or the v4 mega city generator on this place just to install v5.2.** Version 5.2 repairs missing v5.1 houses automatically. The older pasted code will not self-update; re-open GitHub **Raw** and copy the latest file, replace ALL contents of the Command Bar, and click its small **Run** button. You only need this v5.2 patch on top of your saved v5.1 game.

## Mandatory zoom repair: I and O

| Keyboard/control | Action |
| --- | --- |
| **I** | Zoom **in** (brings camera closer to avatar/car) |
| **O** | Zoom **out** (moves camera farther away) |
| Mouse wheel | Zoom camera, if mouse pointer isn't over the UI |
| Right-click + drag | Rotate view/orbit around avatar/car |
| PageUp / PageDown | Adjust camera height/view angle |
| **C** | Reset camera angle and distance |
| **M** or click circular map | Open/close full city map |
| Radar's tiny +/− | Zoom the **map only**, not the camera |
| **B** or press the **CITY** button | Open the roleplay City menu |

The **camera distance indicator** appears in the lower-right and changes when I or O is detected. The script now **polls the physical I/O key states** because Roblox's CoreScripts may treat keypress events as processed. The game draws its own third-person camera while walking and riding. When the character hasn't spawned, the normal Roblox camera can take over.

If pressing I/O still does not change the distance indicator while in **Play** mode, capture the **Output** errors and the right side of the Play viewport. That indicates a script execution or key-handling issue rather than a request to add more keyboard shortcuts.

## Smaller HUD / better visibility
- Top-left circular minimap reduced to **96 × 96 px**.
- Small + / − for map only; no big background panel. Click map to open full schematic city map.
- Clock and compact mission status have reduced dimensions.
- **Huge** legacy welcome/vehicle boards are reduced in visible size/distance near original spawn.
- The GAME OWNER overhead tag is reduced in size, not removed.
- The HUD changes are **functional UI adjustments**; not a replacement for proper texture or 3D model quality.

## New Brookhaven-like features, original UAE designs

### New walkable neighbourhood
The patch adds `Phase52_RoleplayDistrict`, near the four interactive v5.1 villas. Houses now have a more detailed exterior treatment: balconies, entrance canopy, gardens, paved walkways, lighting and palms.

The original v5.1 villa claims, doors, locks, furniture and beds are **retained**.

### Six accessible shops/services
Buildings with entrance gaps, window walls, interiors, counter furnishings and server-checked proximity interactions:
- **Dubai Clinic** — receive medical healing.
- **Karak Café** — roleplay service and a small health increase.
- **City Market** — retail interaction.
- **Hotel Al Wasl** — reception interaction.
- **Dubai Bank** — banking roleplay interaction.
- **Fashion Souq** — fashion/shopping interaction.

Some services give +5 **temporary CityPoints**, with a cooldown. Points do not persist across game sessions. Shops are not yet complete inventory systems.

### Driveable personal vehicles
Use the **CITY** menu to visit Homes first, then select:
- **Dubai Taxi**
- **Family SUV**
- **City Sedan**

One prototype personal car per player. Car models have corrected vertical wheels, alloy rims, windows, headlamps and revised body panels. The cars use the game's existing anchored prototype driving system (W/A/S/D) and do **not** have realistic physics, collision-avoidance, suspension or licensed real-vehicle meshes. Press **E** near the car to enter. You can remove the car through the City menu.

### A City menu to actually reach the new places
The **CITY** button or **B** opens travel options:
- Homes & Villas
- Sheikh Zayed Road
- Burj Khalifa downtown
- Dubai Marina
- Airport

All travel locations and personal car types are approved and validated on the server. Players keep their own Roblox avatars.

### More street activity
- Two decorative Dubai-style city buses
- Six new Roblox R15 pedestrians using simple walking routes
- Pedestrian crossings and a commercial boulevard
- Additional street lamps connected to the game’s existing day/night cycle
- Palm landscaping, stone sidewalks, storefront window detail and canopies

## What remains for a genuine Brookhaven-level city game
These are improvements to the existing **part-based prototype**, not a complete new game:
- high-quality art assets and mesh models (buildings, vehicles, people, animations)
- avatar outfit/role selection UI and full home customization/persistent ownership
- drivable physics-based cars with traffic safety and real passenger systems
- map layout redesign, road markings, real intersections, parking and walkable downtown interiors
- furniture placement, money/inventory system, social roleplay interactions and job progression
- immersive audio and mobile/gamepad UI testing
- high-quality imported Dubai city textures with lighting/LOD optimization

No Brookhaven source, images, maps, characters or proprietary game assets have been copied. The inspiration is **open-ended roleplay design**, not direct reproduction.

## Must-pass Studio test checklist
- [ ] Script runs without syntax/runtime errors in Edit mode.
- [ ] Version 5.2 district appears in Explorer and in the world.
- [ ] On foot, **I** visibly zooms in; **O** zooms out.
- [ ] Lower-right zoom distance number actually changes with I/O.
- [ ] I/O also works after entering a yellow truck or personal car.
- [ ] Camera doesn't snap inside vehicles or stop character movement.
- [ ] Circular minimap is smaller; clicking opens the full map; M toggles it.
- [ ] Press B (or click CITY); visit Homes & Villas from the original emergency spawn.
- [ ] Four original claimable villas and doors still function.
- [ ] Six interior shops can be entered; prompt activates at the counter.
- [ ] Can spawn one taxi/SUV/sedan at the garage, sit and drive with WASD.
- [ ] Drive buttons and City menu work without unexpected teleporting.
- [ ] At least one shopper NPC walks and stays above the ground.
- [ ] Two decorative buses, palm trees and road markings are visible.
- [ ] Old oversized landmark signs have smaller display.
- [ ] Original emergency vehicles, mission system, four UAE flags, Dubai clock and all prior v5 landmarks remain.
- [ ] Laptop remains responsive; no unbounded NPC/car replication.
- [ ] Play test once with a non-owner avatar and once in a multiplayer session.
- [ ] Save as separate v5.2 place, not over the backup.

If tests fail, send a screenshot of **View → Output** with the error message and the affected feature. The code has not been executed in your Roblox Studio by the assistant, so those results will determine the next repair.
