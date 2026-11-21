# UAE City Life Version 6.0 — One Big Upgrade

**Built on 21 November 2026. Status: GitHub source committed and consistency-checked, NOT Play-tested in Roblox Studio or published.** This single command-bar installer contains 14 separate source modules. It is a large **production-prototype pass**, not the final game or photorealistic AAA artwork.

## How to install (one run)
1. Open your **working UAE City Life v5.4 or v5.5** Roblox Studio place. The place must include `Workspace > UAE_City_Life > Phase54_CityExpansion`.
2. **Stop Play mode** using the top red button. You must be in **Edit** mode.
3. Save a backup with **File > Save to File As**, e.g. `UAE_City_Life_v5_5_BACKUP.rbxl`. Do not overwrite it.
4. Open [**the Phase 6 all-in-one installer**](../build/Phase6_UAE_City_Life_OneBigUpgrade.luau). Click **Raw** in GitHub, then **Ctrl+A / Ctrl+C** to copy its entire code.
5. Click the Roblox Studio **Command Bar**, replace the old code using **Ctrl+A / Ctrl+V**, and use its small **Run** button.
6. In **Output** look for `UAE CITY LIFE v6.0 BIG BUILD INSTALLED`. If a red error appears, copy it or photograph it; do not keep rerunning the script.
7. **Save as a new file** `UAE_City_Life_v6_0.rbxl`.
8. Now press the top **Play** button, and click inside the 3D viewport. New service interiors, roads, NPCs, aircraft, art and traffic are made by the server **during Play** and will not necessarily exist in Edit mode.

A large pasted code block may be less responsive in Studio. Once you see the **installer success message in Output**, stop pasting/rerunning and use normal Play mode.

## What Phase 6 adds

### Vehicle repair and redesign
- Dynamic personal taxi/sedan/SUV and original ambulance, police and fire vehicles are classified from their existing names.
- Existing tyre/rim decorations are hidden and replaced with **round cylinder rubber tyres** at reasonable ground positions, silver hubs and wheel-spoke detailing.
- The vehicles receive **different procedural body silhouettes**: sedan cabin/bonnet, SUV, ambulance, police, Civil Defence, bus; emergency lightbars and bilingual service labels.
- Preserves the earlier scripted car-control system rather than forcibly converting it to an untested chassis.
- **Important**: These cars are still procedural Roblox parts, not authentic high-poly imported vehicle meshes or suspension rigs. Some old vehicle shapes may require follow-up corrections in Studio.
- A server-side **movement/raycast collision monitor** can detect some collisions of *script-driven anchored cars*. Damage appears as a vehicle attribute and color change, with a repair terminal near x=-340,z=-1010. This is *not* physical deformation, realistic crash physics or a guaranteed collision trigger in all circumstances.

### More complete usable buildings
- **Dubai Hotel** at x=-550,z=-890: walkable lobby, reception check-in, guest suite 101, checkout and temporary points.
- **Dubai Hospital** at x=-235,z=-1095: register as patient, consultation, pharmacy and treatment ward.
- **DXB terminal** at x=-1020,z=-925: booking, baggage drop, security, Gate A1 boarding, simulated travel document and rewards.
- **Dubai Police Office** at x=-1135,z=-480: start patrol, file incident report, finish duty.
- **Civil Defence** at x=-1135,z=-630: briefing, tool inspection and dispatch.
- Prompts and progression state are checked on the server; player must physically be close to the counter. A nearby **CITY TRANSIT** feature helps reach selected entrance locations in this large **fictional in-game** layout.

### Pilotable aircraft
- A stylized airliner can be piloted from the airport runway near x=-1280,z=-1350.
- A rescue helicopter is at the western helipad near x=-1050,z=-790.
- Approach the cockpit, hold **E** when the pilot prompt appears.
- **W / S** = forward acceleration/deceleration; **A / D** = turn; **R** = ascend; **F** = descend; **Space** = exit seat.
- A cockpit display shows aircraft type, speed and altitude. The movement inputs are validated on the server.
- These are **arcade flight prototypes** made with anchored model `PivotTo`, not aerodynamically simulated physics, working landing gear, complete crash behaviour or real passenger flights. Aircraft flight must be tested before relying on it in gameplay.

### People, traffic and city appearance
- Eight R15 walking NPCs by default, optionally 16 for stronger hardware. Roblox standard humanoid body proportions, simple varied clothing colors and optional standard walking animation.
- Six civilian traffic cars move on fixed E11 lane routes and stop or slow when players are ahead. They are **non-colliding traffic props**, not advanced AI police or pedestrian-avoidance vehicles.
- New facade glazing, roofline accents, building signs, crossings, roadside lighting, furniture and architectural details.
- The **40-destination city atlas** adds the active hotel, hospital, airport, police, fire, garage and aircraft locations to the v5.4 map. The original 10 v5.4 missions remain.
- Six additional **longer route-based missions** are available from **BIG MISSIONS** or **L**: emergency response, police patrol, Civil Defence drill, airplane training, hotel tourist transfer and marina search. Rewards are *temporary* CityPoints.

## Laptop performance option
The installer has `local LOW_PERFORMANCE_MODE=true` near the top. It starts with only eight walking R15 NPCs. After the build has been tested, you can switch it to `false` for all 16. **You do not need to turn this on in Studio unless you are rebuilding v6.** On a lower-power Dell laptop, test frame rate before increasing density.

## Where to test first
1. **Ambulance wheels:** find the white/blue ambulance from your screenshot. Are the visible tyres circular and correctly placed?
2. **Police and fire vehicle:** do the body silhouettes and wheel positioning make sense? Can you still drive?
3. **Hotel:** CITY ATLAS > search `Dubai Hotel Check-in Lobby` > select it > CITY TRANSIT. Use the check-in and room prompts in order.
4. **Hospital:** search `Dubai Hospital Patient Entrance`. Register, consult the doctor, use the pharmacy.
5. **DXB:** search `DXB Airport Check-in Terminal`. Complete ticket, bags, security and boarding.
6. **Aircraft:** search `Pilotable Passenger Jet` or `Pilotable Rescue Helicopter`, use CITY TRANSIT, approach E pilot prompt and test W/S, A/D, R/F.
7. **BIG MISSIONS / L:** select a longer job and follow the local gold waypoint to its checkpoints.
8. **Map:** verify original downtown landmarks, metro, residential homes and previous missions still function.
9. **Output:** any red error? Take a clear photo including the script name, line number and first error message.
10. **Performance:** is the laptop smooth while walking and flying? If not, keep low-performance mode and reduce background traffic before adding detail.

## Why this still isn't an international-level finished game
Scripts and Parts can create functioning prototypes, gameplay rules and original stylized scenery. However, the user-requested visual standard cannot be honestly achieved by **procedural boxes alone**. The next production art pipeline needs:
- Original licensed/imported **MeshPart** vehicles with correct wheel constraints, chassis and PBR materials; ambulance, Civil Defence, police, modern sedans, family SUVs, buses.
- Custom vehicle interiors, suspension and traffic collision interactions.
- Original detailed **airport terminal, hotel, hospital, police and Civil Defence assets** with signage, animated doors, elevators, waiting rooms, proper equipment, sounds and staff.
- High-quality **airplane/helicopter meshes**, rotors, control surfaces, seating and a physics-based flight model.
- Original NPC clothes, faces, hair, realistic animations, pathfinding and accessible interactions.
- Persistent data systems, multiplayer performance and security checks, sound design, accessibility, mobile input, memory/LOD optimization, moderation and complete Roblox publishing QA.

**Do not buy or reuse proprietary GTA or Brookhaven 3D/game assets.** Use original work or properly licensed assets. The real-world cities/districts in this project are creatively inspired by Dubai; the current map is not a surveyed accurate geographical street map.

**Do not claim completion until tested in Studio.** The GitHub source cannot change the game already saved on your computer until you run the Command Bar installer, save, and test.
