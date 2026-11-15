# Roblox UAE – City Life | Phase 4 Mega City (beta)

**Source uploaded to GitHub. NOT tested on the user's Windows PC or published to Roblox.** Do not treat the features below as guaranteed until tested in Roblox Studio.

## Reference and intent
- The two new user-supplied photos show a **yellow Dubai Civil Defence fire truck** (cab with diagonal red striping, metal equipment shutters, blue roof lights and 997) and a **white/blue ambulance** (white cab, large deep-blue rear body, red medical detail).
- The source builds **more detailed approximations with Roblox Parts**, not photo-exact game-ready 3D meshes. Achieving exact curves, branding and proportions requires modeling/importing custom MeshParts with appropriate permissions, texturing, UVs and asset moderation.
- Available Gulf Afterglow reference is **a text design brief**, not its 3D source files or code. It describes golden-hour marina streets, airport, highways, busy city and an on-screen map. These themes inform this build.

## What's in this large upgrade

### Bigger map / graphics
- Increase existing desert platform to **3,300 × 3,100 studs** while preserving the original seven emirate districts.
- Add three landscaped **road rings** with two isolated lanes each: Dubai Downtown, Central UAE and Outer Emirates.
- Add connector boulevards, around **160 additional varied building shells** across eight districts, multiple shopfront-like entrance windows, parks, more palms, streetlights and benches.
- Polished high-rise ribbon windows, glass and facade materials, milder atmospheric haze, golden-hour colour grade.
- Keep exactly **four UAE flags** previously in the map. This script doesn't add or remove flags.

### More faithful emergency vehicles
- Replace only the existing emergency vehicle **body parts** with more detailed pieces, preserving their Model names, DriverSeat and ProximityPrompt. Their existing *experimental* driving scripts remain installed.
- Police: white SUV, dark green doors with **white “الشرطة / POLICE” text**, green stripe, red/blue roof lights.
- Ambulance: white cab and roof, navy rear medical box, red accents, Arabic **الإسعاف** and AMBULANCE, roof lights.
- Yellow Dubai Civil Defence truck: taller cab, white roof/bumper, blue beacons, red diagonal striping, silver shutter compartments, **997**, Arabic **الدفاع المدني**, and English DUBAI CIVIL DEFENCE.
- New wider chase-camera script for tall emergency vehicles.
- **Remaining:** mesh-quality exactness, vehicle suspension/wheels, indicators, real sirens, collision-aware driving, better handling and seat animations.

### Better traffic / people
- Replace prior Phase 3A moving traffic script (where vehicles crossed each other) with **52 route-locked civilian vehicles**, including multiple taxis, sedans, SUVs, buses and vans. In Edit mode they already appear placed on separate road lanes. During Play, same-lane traffic has equal speed and even spacing: **no AI merging or intersections**, so automated vehicles don't cross each other at junctions.
- A runtime script creates **up to 15 Roblox R15 humanoid NPCs** with different default clothing/body colours and real movement on sidewalks. This may depend on Studio's ability to create default humanoid rigs.
- These are **non-colliding visual traffic** models; they are **not realistic physical car AI**. Player-driven cars can still overlap with them; full traffic collision, stop signs, actual lights, overtaking and junction priority are for later builds.

### HUD and time
- Smaller **circular minimap** at top-left, with roads and player centre dot, **M** to hide/show.
- **Live Dubai local clock** shown as GST (UTC+04:00), always distinct from game time.
- Accelerated **40-minute in-game day/night cycle**, starting at 14:00 game time. Game daytime is 06:00–17:59, night 18:00–05:59. Changes in Lighting are distributed through a ReplicatedStorage attribute. Night-only street lamps switch on.
- Prototype **UAE Explorer** mission: visit Dubai Burj Khalifa, Sharjah Heritage and Ajman. The mission resets when you rejoin and gives no monetary rewards yet.

## Install v4 on your Dell laptop
**Prerequisite:** `Roblox_UAE_City_Life_v2.rbxl` or v3A with the Phase 1 city present and Phase 2 installed. You don't need to run the older scripts again.

1. **Back up your current working place.** In Roblox Studio, **File → Save to File As** (or **Download a Copy** depending on the Studio screen). Keep a safe `v2` or `v3A` file.
2. Press **Stop**. Stay in **Edit** mode.
3. On GitHub, open [`build/Upgrade_UAE_City_Life_Phase4_MegaCity.luau`](../build/Upgrade_UAE_City_Life_Phase4_MegaCity.luau).
4. Click **Raw**, then press **Ctrl+A**, **Ctrl+C**.
5. In Roblox Studio's **Command Bar**, select the older text with **Ctrl+A**, paste using **Ctrl+V**, then run using **Ctrl+Enter**.
6. Watch the **Output** panel for errors. If successful, Explorer should show **Workspace → UAE_City_Life → Phase4_MegaCity**. Check the road layout and three redesigned vehicles *before pressing Play*.
7. **File → Save to File As** `Roblox_UAE_City_Life_v4.rbxl`. Keep the old v2/v3A copy.
8. Press **Play**. Test the circular minimap, real Dubai time, time-of-day lighting, moving cars and NPCs, Arabic lettering and the third-person fire-truck camera. If you see red errors in Output, take a screenshot including the line number and send it.
9. **Do not publish** to Roblox until you've tested walking, vehicles, respawn, and actual performance.

### If the laptop is slow
Near the top of the GitHub build script, change:
```lua
local PERFORMANCE_MODE=false
```
to
```lua
local PERFORMANCE_MODE=true
```
**before executing the script**. This generates about half the buildings and cars and only 7 NPCs. You can rerun the complete v4 build script in **Edit mode** (it replaces only its own Phase4 folder and generated script names). Save as a new file after testing.

## Quality assurance (pending Studio test)
- [ ] Run the 42k-character code without parse or runtime errors.
- [ ] v4 folder appears, highway lanes fit terrain, no buildings overlap core landmarks.
- [ ] Vehicles start on the road, not all at (0, 0, 0).
- [ ] Sit in yellow Civil Defence vehicle, check camera clears the roof, steer and exit.
- [ ] Check white Arabic letters on police dark-green door, side text on both other vehicles.
- [ ] Check the top-left map updates when walking; M toggles it.
- [ ] Compare Dubai GST displayed time with your real Dubai clock.
- [ ] Verify in-game Day/Night clock advances and lights turn on at night.
- [ ] Ensure 52 civilian cars stay on separate lanes without crossing each other. Note there is **no collision system yet**.
- [ ] Ensure R15 pedestrians spawn and stay on sidewalks; confirm no collisions or falling.
- [ ] Check performance, mobile players and multiplayer.
- [ ] Keep **exactly 4 UAE flags** across all existing buildings.
- [ ] Run UAE Explorer mission checkpoints.
- [ ] Verify no earlier user save is overwritten.

## Future high-priority passes
1. Custom 3D mesh vehicles matched to the two photos more closely (Blender/Studio import, licensed livery decals), ambulance and fire roles, improved wheels.
2. Real geographically considered road/area layout, more specific UAE landmarks, more enterable interiors, shops, parking/garages, transit systems and traffic intersection controls.
3. Real server-validated **police patrol**, **ambulance rescue**, **civil defence fire response** missions with dispatch UI, safe route GPS markers, co-op and optional achievements.

This build is a large prototype. It does not copy Gulf Afterglow assets and cannot be called finished, realistic, fully working or published until Studio testing and asset polish.
