# UAE City Life — v5.1 Zoom & Homes hotfix (beta)

**Status:** GitHub source committed and consistency-checked; **not yet tested in Roblox Studio**. This is an incremental patch **for an existing saved v5 game**. It does not recreate v5 city or use Brookhaven maps/models/code.

## Install on your existing Version 5

1. Open your previously saved **v5 Dubai Modern City** place in Roblox Studio. You must see `Workspace > UAE_City_Life > Phase5_DubaiModern` in Explorer.
2. **File → Save to File As** and back it up as `UAE_City_Life_v5_backup.rbxl`.
3. Press **Stop** to leave Play mode.
4. Open [the v5.1 patch](../build/Patch_UAE_City_Life_v5_1_ZoomAndHomes.luau). Click **Raw**, then **Ctrl+A**, **Ctrl+C**.
5. In Roblox Studio, open the **Command Bar**. Press **Ctrl+A** to replace previous commands, **Ctrl+V**, then **Ctrl+Enter** to execute.
6. Watch Output. A successful installation prints `UAE City Life v5.1 patch installed`.
7. Verify `Workspace > UAE_City_Life > Phase51_RoleplayHomes > Villas` and `StarterPlayer > StarterPlayerScripts > UAE_Phase51Camera` and `UAE_Phase51HUD`.
8. **Save to File As** a new `UAE_City_Life_v5_1.rbxl`. Do not overwrite your v5 backup.
9. Press **Play** and test camera zoom and the four villas, then report any errors from the Output panel.

**Do not run the large v5 installer again** to apply this hotfix.

## Important distinction: TWO different zooms

| Location | Control | Expected behaviour |
| --- | --- | --- |
| LEFT of screen | + / − beside circular minimap | Enlarges or shrinks the **radar view**; an on-screen scale indicator changes |
| LEFT of screen | Click circular map or MAP / M key | Opens/closes expanded city map |
| RIGHT of screen | + / − beneath CAMERA buttons | Zooms third-person **world camera** while **walking or driving** |
| RIGHT of screen | ↑ / ↓ buttons | Tilts camera higher/lower |
| Mouse | wheel (pointer away from map) | Zooms the **world camera** |
| Mouse | right-drag | Orbits camera around avatar/vehicle |
| Keyboard | PageUp / PageDown | Raises/lowers the camera angle |
| Keyboard | C | Resets distance and camera angle |

Zoom range is approximately **6–80 studs walking**, **14–100 studs driving**. The game no longer relies on Roblox's default camera to provide on-screen zoom.

## New roleplay starter neighbourhood

Four houses are generated on a new residential street in the southern area:
- Each house includes glass windows, a living room, kitchen counter, sofa, bed, porch and carport.
- **Green pad:** press E to claim one available house; pressing it again releases your own house. One house per player at a time.
- **Front door:** press E to open or close it. It closes automatically after about nine seconds.
- **Lock panel:** the homeowner can lock/unlock their house. Guests can use the door when unlocked.
- **Bed:** press E to rest and recover some health.
- Owner name is shown on each house sign.
- Claims are **temporary per game server**, not saved. Garages are decorative; car spawning from the house is not yet implemented.

## Why this differs from Brookhaven

The inspiration is **interactive, accessible roleplaying**: a compact interface, avatar freedom, homes, public buildings and city life. Brookhaven is a separate game by Voldex. We are not copying its source code, 3D models, images, audio, characters, branding or map layout. UAE City Life should feature recognizable, original Dubai-themed places and unique police/Civil Defence/ambulance roles.

## Follow-up features to build, in priority order
1. Studio testing and bugfixes: map controls, walking camera, car camera, user house claims and doors.
2. Roleplay **vehicle-spawn menu** with city buses, family cars, police SUV, Dubai taxi, emergency response. Should be secure, per-player capped and actually drivable.
3. Interior home customization, apartments and property persistence with a safe datastore.
4. Interactive grocery stores, clothing shops, schools, hospital, hotel reception and mall.
5. Jobs: taxi, ambulance, police patrol, Civil Defence. Reward systems should be server-authoritative.
6. Drivable metro/boats/helicopters, collision-aware road traffic, improved meshes and materials.
7. Graphics/performance passes for older Dell hardware and mobile users.

**Known limitations:** This is a source patch, not a published Roblox update. Cameras, doors and furniture have not yet been playtested. If the game has an unseen additional camera controller, it may conflict with v5.1 and need a follow-up change. Do not call the game complete or live from GitHub alone.
