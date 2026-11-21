-- UAE City Life v6.0: extended 40-destination catalogue of IN-GAME destinations.
-- Coordinates refer to this fictional Roblox layout, NOT real-world GPS.
local destinations={
 {id="BURJ",name="Burj Khalifa",category="Landmarks",position=Vector3.new(-84,6,-392),description="Downtown skyline tower"},
 {id="MALL",name="Dubai Mall",category="Shopping",position=Vector3.new(100,6,-399),description="Downtown retail and attractions"},
 {id="MUSEUM",name="Museum of the Future",category="Landmarks",position=Vector3.new(315,6,-1180),description="Iconic museum-inspired landmark"},
 {id="FRAME",name="Dubai Frame",category="Landmarks",position=Vector3.new(-770,5,-830),description="Gold architectural frame"},
 {id="ARAB",name="Burj Al Arab",category="Landmarks",position=Vector3.new(1125,6,-940),description="Sail-shaped coastal hotel"},
 {id="E11",name="Sheikh Zayed Road",category="Transport",position=Vector3.new(0,5,-1200),description="Main expressway corridor"},
 {id="DXB",name="Dubai International Airport",category="Transport",position=Vector3.new(-1070,5,-1260),description="Airport terminal and apron"},
 {id="METRO",name="Dubai Metro Station",category="Transport",position=Vector3.new(194,25,-1215),description="Elevated metro station"},
 {id="MARINA",name="Dubai Marina",category="Leisure",position=Vector3.new(1060,5,-1285),description="Harbour, yachts and promenade"},
 {id="CRUISE",name="Cruise Port",category="Transport",position=Vector3.new(1110,5,-1450),description="Cruise terminal waterfront"},
 {id="MED",name="Dubai Medical Centre",category="Services",position=Vector3.new(-235,5,-1175),description="Hospital and medical centre on E11"},
 {id="POLICE",name="Dubai Police Station",category="Services",position=Vector3.new(-960,5,-480),description="Community police office"},
 {id="FIRE",name="Civil Defence Station",category="Services",position=Vector3.new(-930,5,-630),description="Civil defence service station"},
 {id="SHOP",name="Dubai City Mall",category="Shopping",position=Vector3.new(620,5,-996),description="West-end retail plaza"},
 {id="SOUK",name="Souk & Cafe",category="Shopping",position=Vector3.new(430,5,-996),description="Souk shops and cafes"},
 {id="HOTEL",name="E11 Grand Hotel",category="Services",position=Vector3.new(-550,5,-980),description="Sheikh Zayed Road hotel"},
 {id="DESK",name="Emirates Tour Desk",category="Services",position=Vector3.new(-400,5,-965),description="Tourism and city information"},
 {id="HOMES",name="Dubai Villas",category="Living",position=Vector3.new(0,5,-790),description="Claimable homes and gardens"},
 {id="PARK",name="Al Wasl Community Park",category="Leisure",position=Vector3.new(0,5,-850),description="Fountain, trees and family activities"},
 {id="CLINIC",name="Dubai Clinic",category="Services",position=Vector3.new(-370,5,-665),description="Neighbourhood clinic and help"},
 {id="KARAK",name="Karak Cafe",category="Shopping",position=Vector3.new(-225,5,-665),description="Local cafe and refreshments"},
 {id="MARKET",name="City Market",category="Shopping",position=Vector3.new(-80,5,-665),description="Everyday grocery shop"},
 {id="WASL",name="Hotel Al Wasl",category="Services",position=Vector3.new(80,5,-665),description="City hotel and lobby"},
 {id="BANK",name="Dubai Bank",category="Services",position=Vector3.new(225,5,-665),description="Bank reception"},
 {id="FASHION",name="Fashion Souq",category="Shopping",position=Vector3.new(370,5,-665),description="Clothing shops"},
 {id="SHJ",name="Sharjah Heritage",category="Landmarks",position=Vector3.new(390,5,-380),description="Emirate heritage district"},
 {id="AJMAN",name="Ajman Beach",category="Leisure",position=Vector3.new(390,5,210),description="Beach destination"},
 {id="BEACH",name="Jumeirah Beach Walk",category="Leisure",position=Vector3.new(1050,5,-720),description="Beach promenade"},
 {id="ARRIVE",name="Airport Arrivals Plaza",category="Transport",position=Vector3.new(-970,5,-1120),description="Terminal pickup and taxi zone"},
 {id="GARDEN",name="Dubai Community Gardens",category="Leisure",position=Vector3.new(-940,5,-890),description="Green public space"},
 {id="TAXI",name="Residential Taxi Stand",category="Transport",position=Vector3.new(0,5,-746),description="Personal vehicle garage area"},
 {id="HELIPAD",name="Helicopter Viewing Deck",category="Leisure",position=Vector3.new(-1010,5,-780),description="Helicopter sightseeing viewpoint"},

 {id="HOTEL6",name="Dubai Hotel Check-in Lobby",category="Services",position=Vector3.new(-550,5,-890),description="Working hotel reception, guest room booking and checkout"},
 {id="HOSP6",name="Dubai Hospital Patient Entrance",category="Services",position=Vector3.new(-235,5,-1095),description="Interactive hospital registration examination and pharmacy"},
 {id="DXB6",name="DXB Airport Check-in Terminal",category="Transport",position=Vector3.new(-1020,5,-925),description="Working airport ticket baggage security and boarding"},
 {id="POLICE6",name="Dubai Police Operations Office",category="Services",position=Vector3.new(-1135,5,-480),description="Interactive police duty and incident reporting"},
 {id="FIRE6",name="Civil Defence Training Centre",category="Services",position=Vector3.new(-1135,5,-630),description="Safety briefing equipment check and dispatch"},
 {id="REPAIR6",name="City Vehicle Repair Workshop",category="Services",position=Vector3.new(-340,5,-1010),description="Repair car collision damage"},
 {id="FLIGHT6",name="Pilotable Passenger Jet",category="Transport",position=Vector3.new(-1280,5,-1350),description="Airliner flight training plane W S A D R F"},
 {id="HELI6",name="Pilotable Rescue Helicopter",category="Transport",position=Vector3.new(-1050,5,-790),description="Helicopter flight experience W S A D R F"},
}
local byId={}
local categories={"All","Landmarks","Transport","Services","Shopping","Living","Leisure"}
for _,place in ipairs(destinations) do byId[place.id]=place end
return {
 List=destinations,
 ById=byId,
 Categories=categories,
 -- Drawing extents in game-world studs, not geographical longitude/latitude
 Bounds={xmin=-1600,xmax=1650,zmin=-1530,zmax=750},
}
