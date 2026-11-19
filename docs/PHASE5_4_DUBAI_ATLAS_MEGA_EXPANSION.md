# UAE City Life v5.4 — Dubai City Atlas & Major Expansion

**Status (19 November 2026):** The source is uploaded to GitHub and inspected for consistency. **It is not yet executed or Play-tested in your Roblox Studio, and it is not published to Roblox.** This is a major incremental feature patch, **not** a finished photorealistic Brookhaven-equivalent game.

## Safest installation — save your working game

1. Open your **working v5.3 or v5.3.1** Roblox Studio place, not an empty Baseplate. Its Explorer should contain `Workspace > UAE_City_Life > Phase52_RoleplayDistrict` and `Phase53CommunityPark`.
2. Press the **red Stop** button. The patch must be run in **Edit mode**, not Play mode.
3. **File > Save to File As** and save a backup named `UAE_City_Life_v5_3_backup.rbxl`.
4. Open [**v5.4 all-in-one source**](../build/Patch_UAE_City_Life_v5_4_DubaiCityAtlasMegaExpansion.luau), select **Raw**, then copy the entire code with **Ctrl+A, Ctrl+C**.
5. In Studio's **Command Bar**, click inside, **Ctrl+A** to replace the older script, **Ctrl+V** to paste v5.4, then click the small **Run** button at the right edge of the Command Bar.
6. Open **Output**; look for `UAE CITY LIFE v5.4 INSTALLED`. Any red error should be photographed along with its line number.
7. In Explorer you should see `Workspace > UAE_City_Life > Phase54_CityExpansion`. Save the place as a **new file** `Roblox_UAE_City_Life_v5_4.rbxl`, then press **Play**.
8. **Important:** some new buildings are built by the server **when Play starts**, rather than appearing immediately in Edit mode. Output during Play should contain `UAE v5.4 world` and `UAE v5.4 mission service`.
9. When playing, **click inside the 3D game area** before testing keyboard controls. Close or minimize the Command Bar and Output pane so keyboard focus isn't stuck in the editor.

### What is new

**32-location city atlas** (schematic positions within our Roblox game, not actual Dubai GPS):
- Click the little **circular map** or **MAP / M** to see the larger atlas.
- Use **Find a place...** to search; filter Landmarks, Services, Transport, Shopping, Living and Leisure.
- Click a place in the list or a map dot to select it.
- A compact **GPS direction and straight-line distance** appears at bottom-left, and the selected target displays as a gold dot on the radar and a local 3D marker visible within about 450 studs.
- Your position is red, the selected location is gold. The guide is **not** an automatically calculated driving route: roads, barriers and intersections still need to be navigated by the player.

Existing destinations shown include Burj Khalifa, Dubai Mall, Museum of the Future, Dubai Frame, Burj Al Arab, Dubai Marina, cruise port, Dubai Airport, Metro, Sheikh Zayed Road, the existing hospital, clinics, bank, cafes, mall, hotels, villas, park and nearby Sharjah/Ajman areas. New destinations include Police, Civil Defence, city gardens, airport arrivals, Jumeirah Beach Walk and a scenic helicopter viewpoint.

**Major new world expansion:** Western public-service avenue, police and Civil Defence buildings, decorative patrol vehicles, gardens, road markings, streetlights; airport arrivals plaza with taxi stands; marina and Jumeirah coast signposts and landscaping; helicopter lookout; new E11 directional boards, lights and pedestrian plazas. These are **original low-to-medium detail procedural structures**, not licensed realistic 3D vehicle/landmark meshes or full usable interiors. Earlier v4/v5 districts and emergency cars remain untouched.

**10 new missions**, on top of the earlier v5 and v5.3 missions, selected through **MISSIONS** button or **K**:
1. Ambulance Assistance — 110 session CityPoints
2. Police Community Patrol — 120
3. Civil Defence Safety Inspection — 120
4. Dubai Airport Shuttle — 120
5. Landmark Photo Trail — 160
6. Marina Safety Volunteer — 110
7. Karak & Grocery Delivery — 90
8. Public Transport Explorer — 140
9. Dubai Healthcare Checkup — 100
10. Community Park Volunteer — 90

Each new mission has sequential destinations and a GPS target. To finish each checkpoint, approach within about **36 studs horizontally**. Rewards are validated and awarded **on the server**, not by the local UI. These are route/checkpoint roleplay missions, not full passenger or hospital simulations. Rewards and progress are **session-only**, not persistent.

### Camera and game controls

| Control | Action |
| --- | --- |
| **I** | Zoom in (best effort; Roblox engine may intercept this key) |
| **O** | Zoom out (best effort; same restriction) |
| **=** | Reliable alternative: zoom **in** |
| **-** | Reliable alternative: zoom **out** |
| On-screen **I+ / O−** | Zoom in/out, independent of physical keyboard |
| **Right-click and drag** | Rotate camera / look up or down |
| **C** | Reset the camera |
| **M** or tap circular map | Open/close the city atlas |
| **K** or **MISSIONS** button | Open 10 additional mission routes |
| **J** / **JOBS** | Earlier v5.3 city jobs |
| **B** / **CITY** | Earlier v5.2 fast travel and vehicle menu |

**Known Roblox limitation:** Roblox's built-in camera uses `I` and `O`, and recent developer reports say custom scripts cannot reliably intercept them in some Studio/client versions. High-priority `ContextActionService` bindings, key polling and fallback `InputBegan` are all attempted. If I/O doesn't respond but = / - does, the keyboard is working and Roblox is consuming I/O. Please report this exact test result; repeated full patch installs will not solve a Roblox engine interception issue.

### Playtest checklist

- [ ] Studio Output in Edit mode prints `UAE CITY LIFE v5.4 INSTALLED` (no red error).
- [ ] Explorer contains `Phase54_CityExpansion`.
- [ ] Start Play; 32-destination guide and new world generator report start in Output.
- [ ] Click circular radar and full atlas opens; search `airport` and see the destination.
- [ ] Select **Dubai International Airport**, exit map and verify bottom-left GPS distance and gold radar marker.
- [ ] Search `hospital` or `medical` and find Dubai Medical Centre.
- [ ] Press **K** / MISSIONS; start Police Community Patrol; confirm checkpoint name and marker.
- [ ] Test I/O; also test = / - and the on-screen I+ / O− buttons.
- [ ] Right-mouse drag rotates the view on foot and when driving; C resets.
- [ ] Existing CITY menu and the four claimable homes still work.
- [ ] New police/Civil Defence service district is visible near x=-960 z=-480 to -630.
- [ ] New airport-arrivals facilities are visible near x=-970 z=-1120.
- [ ] New Jumeirah beach promenade and Marina guidance signs are visible.
- [ ] At least one mission completes and awards the promised CityPoints on the server.
- [ ] Original Burj Khalifa, Museum, mall, DXB, old missions and Dubai GST clock still exist.
- [ ] Camera responsiveness and frame rate are acceptable on the Dell laptop.

### What remains before public release

This version is intended to make the city easier to navigate and more playable. **It is not a completed game yet.** Next work after testing should include: proper physics-driven car wheel rigs and crash-safe traffic, clearer usable hospital/police/fire interiors, licensed or custom high-quality 3D assets/animations and textures, persistent money/home data, mobile/gamepad UI, player privacy/permissions, moderation and multiplayer playtests, memory/LOD performance optimization and real Roblox publishing. Do not copy copyrighted code or models from Brookhaven or GTA. Aim instead for a distinctive original Dubai city experience.

**The GitHub script does not publish itself to Roblox.** Saving locally in Studio is a separate step; publishing is done later through Studio's Roblox publishing flow after gameplay testing.
