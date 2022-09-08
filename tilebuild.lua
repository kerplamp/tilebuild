
TOOL.Category		= "Construction"
TOOL.Name			= "Tile Build"
--TOOL.RightClickAutomatic = true


local mouseheld = false

local dist, startpos, endpos, lastpos, orientupdate, active, invert = Vector(0,0,0), Vector(0,0,0), Vector(0,0,0), Vector(0,0,0), Vector(0,0,0), false, false

local linetable = {}

local finalrotation = Angle(0,0,0)

local finalmodel = ""

local displacementfix = Vector(0, 0, 0)

local ghostprop 

local cornerfix = Vector(0, 0, 1) 

local finalpos = Vector(0,0,0)

local finalkey = 0

local finalinversion = Vector(0,0,0)

local snapamount = 11.9

local doubletapprevention = 0

local lastmax = Vector(0, 0, 0)

TOOL.ClientConVar["material"] = ""
TOOL.ClientConVar["red"] = 255
TOOL.ClientConVar["green"] = 255
TOOL.ClientConVar["blue"] = 255
TOOL.ClientConVar["alpha"] = 255
TOOL.ClientConVar["proptype"] = "models/squad/sf_plates/sf_plate4x4.mdl"
TOOL.ClientConVar["ghostenabled"] = "0"
TOOL.ClientConVar["modelselected"] = "0"
TOOL.ClientConVar["debug"] = "0"
TOOL.ClientConVar["guide"] = "1"

local superflat = {

	{Vector(-0.25,-0.25,-0.25), Vector(96.25,96.25,1.25), 'models/squad/sf_plates/sf_plate8x8.mdl', Vector(0,0,0)},
	{Vector(-0.25,-0.25,-0.25), Vector(60.25,48.25,1.25), 'models/squad/sf_plates/sf_plate4x5.mdl', Vector(0,0,0)},
	{Vector(-0.25,-0.25,-0.25), Vector(84.25,36.25,1.25), 'models/squad/sf_plates/sf_plate3x7.mdl', Vector(0,0,0)},
	{Vector(-0.25,-0.25,-0.25), Vector(84.25,12.25,1.25), 'models/squad/sf_plates/sf_plate1x7.mdl', Vector(0,0,0)},
	{Vector(-0.25,-0.25,-0.25), Vector(36.25,24.25,1.25), 'models/squad/sf_plates/sf_plate2x3.mdl', Vector(0,0,0)},
	{Vector(-0.25,-0.25,-0.25), Vector(84.25,24.25,1.25), 'models/squad/sf_plates/sf_plate2x7.mdl', Vector(0,0,0)},
	{Vector(-0.25,-0.25,-0.25), Vector(72.25,24.25,1.25), 'models/squad/sf_plates/sf_plate2x6.mdl', Vector(0,0,0)},
	{Vector(-0.25,-0.25,-0.25), Vector(72.25,48.25,1.25), 'models/squad/sf_plates/sf_plate4x6.mdl', Vector(0,0,0)},
	{Vector(-0.25,-0.25,-0.25), Vector(48.25,36.25,1.25), 'models/squad/sf_plates/sf_plate3x4.mdl', Vector(0,0,0)},
	{Vector(-0.25,-0.25,-0.25), Vector(72.25,12.25,1.25), 'models/squad/sf_plates/sf_plate1x6.mdl', Vector(0,0,0)},
	{Vector(-0.25,-0.25,-0.25), Vector(72.25,60.25,1.25), 'models/squad/sf_plates/sf_plate5x6.mdl', Vector(0,0,0)},
	{Vector(-0.25,-0.25,-0.25), Vector(24.25,12.25,1.25), 'models/squad/sf_plates/sf_plate1x2.mdl', Vector(0,0,0)},
	{Vector(-12.25,-0.25,-0.25), Vector(48.25,12.25,1.25), 'models/squad/sf_plates/sf_plate1x5.mdl', Vector(-12,0,0)},
	{Vector(-0.25,-0.25,-0.25), Vector(60.25,60.25,1.25), 'models/squad/sf_plates/sf_plate5x5.mdl', Vector(0,0,0)},
	{Vector(-0.25,-0.25,-0.25), Vector(84.25,60.25,1.25), 'models/squad/sf_plates/sf_plate5x7.mdl', Vector(0,0,0)},
	{Vector(-0.25,-0.25,-0.25), Vector(48.25,24.25,1.25), 'models/squad/sf_plates/sf_plate2x4.mdl', Vector(0,0,0)},
	{Vector(-0.25,-0.25,-0.25), Vector(96.25,48.25,1.25), 'models/squad/sf_plates/sf_plate4x8.mdl', Vector(0,0,0)},
	{Vector(-0.25,-0.25,-0.25), Vector(60.25,24.25,1.25), 'models/squad/sf_plates/sf_plate2x5.mdl', Vector(0,0,0)},
	{Vector(-12.25,-0.25,-0.25), Vector(36.25,12.25,1.25), 'models/squad/sf_plates/sf_plate1x4.mdl', Vector(-12,0,0)},
	{Vector(-0.25,-0.25,-0.25), Vector(24.25,24.25,1.25), 'models/squad/sf_plates/sf_plate2x2.mdl', Vector(0,0,0)},
	{Vector(-0.25,-6.25,-0.25), Vector(36.25,6.25,1.25), 'models/squad/sf_plates/sf_plate1x3.mdl', Vector(0,-6,0)},
	{Vector(-0.25,-0.25,-0.25), Vector(60.25,36.25,1.25), 'models/squad/sf_plates/sf_plate3x5.mdl', Vector(0,0,0)},
	{Vector(-0.25,-0.25,-0.25), Vector(96.25,12.25,1.25), 'models/squad/sf_plates/sf_plate1x8.mdl', Vector(0,0,0)},
	{Vector(-0.25,-0.25,-0.25), Vector(72.25,36.25,1.25), 'models/squad/sf_plates/sf_plate3x6.mdl', Vector(0,0,0)},
	{Vector(-0.25,-0.25,-0.25), Vector(36.25,36.25,1.25), 'models/squad/sf_plates/sf_plate3x3.mdl', Vector(0,0,0)},
	{Vector(-0.25,-0.25,-0.25), Vector(12.25,12.25,1.24), 'models/squad/sf_plates/sf_plate1x1.mdl', Vector(0,0,0)},
	{Vector(-0.25,-0.25,-0.25), Vector(96.25,60.25,1.25), 'models/squad/sf_plates/sf_plate5x8.mdl', Vector(0,0,0)},
	{Vector(-0.25,-0.25,-0.25), Vector(84.25,84.25,1.25), 'models/squad/sf_plates/sf_plate7x7.mdl', Vector(0,0,0)},
	{Vector(-0.25,-0.25,-0.25), Vector(48.25,48.25,1.25), 'models/squad/sf_plates/sf_plate4x4.mdl', Vector(0,0,0)},
	{Vector(-0.25,-0.25,-0.25), Vector(84.25,72.25,1.25), 'models/squad/sf_plates/sf_plate6x7.mdl', Vector(0,0,0)},
	{Vector(-0.25,-0.25,-0.25), Vector(72.25,72.25,1.25), 'models/squad/sf_plates/sf_plate6x6.mdl', Vector(0,0,0)},
	{Vector(-0.25,-0.25,-0.25), Vector(96.25,72.25,1.25), 'models/squad/sf_plates/sf_plate6x8.mdl', Vector(0,0,0)},
	{Vector(-0.25,-0.25,-0.25), Vector(96.25,84.25,1.25), 'models/squad/sf_plates/sf_plate7x8.mdl', Vector(0,0,0)},
	{Vector(-0.25,-0.25,-0.25), Vector(96.25,36.25,1.25), 'models/squad/sf_plates/sf_plate3x8.mdl', Vector(0,0,0)},
	{Vector(-0.25,-0.25,-0.25), Vector(12.25,12.25,1.24), 'models/squad/sf_plates/sf_plate1x1.mdl', Vector(0,0,0)},
	{Vector(-0.25,-0.25,-0.25), Vector(84.25,48.25,1.25), 'models/squad/sf_plates/sf_plate4x7.mdl', Vector(0,0,0)},
	{Vector(-0.25,-0.25,-0.25), Vector(96.25,24.25,1.25), 'models/squad/sf_plates/sf_plate2x8.mdl', Vector(0,0,0)},


}

local steel = {

	{Vector(-24.052,-47.731,-0.045), Vector(23.961,47.731,3.534), 'models/props_phx/construct/metal_plate1x2.mdl', Vector(-23.771,-47.45,0.237)},
	{Vector(-24.052,-24.006,-0.045), Vector(23.961,24.006,3.534), 'models/props_phx/construct/metal_plate1.mdl', Vector(-23.771,-23.725,0.237)},
	{Vector(-47.729,-47.731,-0.045), Vector(47.734,47.731,3.534), 'models/props_phx/construct/metal_plate2x2.mdl', Vector(-47.447,-47.45,0.237)},
	{Vector(-47.721,-95.181,-0.045), Vector(47.742,95.181,3.534), 'models/props_phx/construct/metal_plate2x4.mdl', Vector(-47.44,-94.9,0.237)},
	{Vector(-95.171,-95.181,-0.045), Vector(95.192,95.181,3.534), 'models/props_phx/construct/metal_plate4x4.mdl', Vector(-94.89,-94.9,0.237)},

}

local steelframe = {

	{Vector(-24.035,-24.014,-0.281), Vector(23.982,24.004,6.213), 'models/props_phx/construct/metal_wire1x1.mdl', Vector(-23.754,-23.732,0)},
	{Vector(-47.736,-24.014,-24.036), Vector(0.281,24.004,23.982), 'models/props_phx/construct/metal_wire1x1x1.mdl', Vector(-47.455,-23.732,-23.754)},
	{Vector(-24.035,-24.014,-0.281), Vector(23.982,71.459,6.213), 'models/props_phx/construct/metal_wire1x2.mdl', Vector(-23.754,-23.732,0)},
	{Vector(-24.035,-24.014,-0.281), Vector(71.437,24.004,47.736), 'models/props_phx/construct/metal_wire1x1x2b.mdl', Vector(-23.754,-23.732,0)},
	{Vector(-24.035,-24.014,-0.281), Vector(71.437,24.004,47.736), 'models/props_phx/construct/metal_wire1x1x2.mdl', Vector(-23.754,-23.732,0)},
	{Vector(-47.736,-47.736,-0.281), Vector(47.736,47.736,6.213), 'models/props_phx/construct/metal_wire2x2.mdl', Vector(-47.455,-47.455,0)},
	{Vector(-24.014,-71.437,-0.281), Vector(71.459,24.035,47.736), 'models/props_phx/construct/metal_wire1x2x2b.mdl', Vector(-23.732,-71.156,0)},
	{Vector(-24.014,-71.438,-0.281), Vector(71.459,24.035,95.191), 'models/props_phx/construct/metal_wire2x2x2b.mdl', Vector(-23.732,-71.156,0)},
	{Vector(-0.25,-0.25,-0.25), Vector(6.172,47.626,6.172), 'models/phxtended/bar1x.mdl', Vector(0,0,0)},
	{Vector(-0.25,-0.25,-0.25), Vector(6.172,95.002,6.172), 'models/phxtended/bar2x.mdl', Vector(0,0,0)},


}

local plastic = {
	{Vector(-190.05,-190.05,-23.975), Vector(190.05,190.05,356.125), 'models/hunter/blocks/cube8x8x8.mdl', Vector(-189.8,-189.8,-23.725),},
	{Vector(-190.05,-190.05,-23.975), Vector(190.05,190.05,71.425), 'models/hunter/blocks/cube8x8x2.mdl', Vector(-189.8,-189.8,-23.725),},
	{Vector(-190.05,-190.05,-23.975), Vector(190.05,190.05,166.325), 'models/hunter/blocks/cube8x8x4.mdl', Vector(-189.8,-189.8,-23.725),},
	{Vector(-142.6,-190.05,-23.975), Vector(142.6,190.05,71.425), 'models/hunter/blocks/cube6x8x2.mdl', Vector(-142.35,-189.8,-23.725),},
	{Vector(-190.05,-190.05,-23.975), Vector(190.05,190.05,23.975), 'models/hunter/blocks/cube8x8x1.mdl', Vector(-189.8,-189.8,-23.725),},
	{Vector(-190.05,-190.05,-6.181), Vector(190.05,190.05,6.181), 'models/hunter/blocks/cube8x8x025.mdl', Vector(-189.8,-189.8,-5.931),},
	{Vector(-142.6,-190.05,-12.113), Vector(142.6,190.05,12.113), 'models/hunter/blocks/cube6x8x05.mdl', Vector(-142.35,-189.8,-11.863),},
	{Vector(-142.6,-190.05,-23.975), Vector(142.6,190.05,23.975), 'models/hunter/blocks/cube6x8x1.mdl', Vector(-142.35,-189.8,-23.725),},
	{Vector(-190.05,-190.05,-12.113), Vector(190.05,190.05,12.113), 'models/hunter/blocks/cube8x8x05.mdl', Vector(-189.8,-189.8,-11.863),},
	{Vector(-142.6,-142.6,-23.975), Vector(142.6,142.6,71.425), 'models/hunter/blocks/cube6x6x2.mdl', Vector(-142.35,-142.35,-23.725),},
	{Vector(-142.6,-142.6,-23.975), Vector(142.6,142.6,261.225), 'models/hunter/blocks/cube6x6x6.mdl', Vector(-142.35,-142.35,-23.725),},
	{Vector(-142.6,-142.6,-6.181), Vector(142.6,142.6,6.181), 'models/hunter/blocks/cube6x6x025.mdl', Vector(-142.35,-142.35,-5.931),},
	{Vector(-142.6,-142.6,-12.113), Vector(142.6,142.6,12.113), 'models/hunter/blocks/cube6x6x05.mdl', Vector(-142.35,-142.35,-11.863),},
	{Vector(-95.15,-190.05,-23.975), Vector(95.15,190.05,23.975), 'models/hunter/blocks/cube4x8x1.mdl', Vector(-94.9,-189.8,-23.725),},
	{Vector(-142.6,-142.6,-23.975), Vector(142.6,142.6,23.975), 'models/hunter/blocks/cube6x6x1.mdl', Vector(-142.35,-142.35,-23.725),},
	{Vector(-95.15,-190.05,-6.181), Vector(95.15,190.05,6.181), 'models/hunter/blocks/cube4x8x025.mdl', Vector(-94.9,-189.8,-5.931),},
	{Vector(-95.15,-190.05,-12.113), Vector(95.15,190.05,12.113), 'models/hunter/blocks/cube4x8x05.mdl', Vector(-94.9,-189.8,-11.863),},
	{Vector(-142.6,-142.6,-23.975), Vector(142.6,142.6,166.325), 'models/hunter/blocks/cube4x6x6.mdl', Vector(-142.35,-142.35,-23.725),},
	{Vector(-95.15,-142.6,-23.975), Vector(95.15,142.6,166.325), 'models/hunter/blocks/cube4x6x4.mdl', Vector(-94.9,-142.35,-23.725),},
	{Vector(-95.15,-142.6,-23.975), Vector(95.15,142.6,23.975), 'models/hunter/blocks/cube4x6x1.mdl', Vector(-94.9,-142.35,-23.725),},
	{Vector(-95.15,-142.6,-23.975), Vector(95.15,142.6,71.425), 'models/hunter/blocks/cube4x6x2.mdl', Vector(-94.9,-142.35,-23.725),},
	{Vector(-95.15,-142.6,-12.113), Vector(95.15,142.6,12.113), 'models/hunter/blocks/cube4x6x05.mdl', Vector(-94.9,-142.35,-11.863),},
	{Vector(-95.15,-142.6,-6.181), Vector(95.15,142.6,6.181), 'models/hunter/blocks/cube4x6x025.mdl', Vector(-94.9,-142.35,-5.931),},
	{Vector(-95.15,-95.15,-95.15), Vector(95.15,95.15,95.15), 'models/hunter/blocks/cube4x4x4.mdl', Vector(-94.9,-94.9,-94.9),},
	{Vector(-95.15,-95.15,-47.7), Vector(95.15,95.15,47.7), 'models/hunter/blocks/cube4x4x2.mdl', Vector(-94.9,-94.9,-47.45),},
	{Vector(-95.15,-95.15,-23.975), Vector(95.15,95.15,23.975), 'models/hunter/blocks/cube4x4x1.mdl', Vector(-94.9,-94.9,-23.725),},
	{Vector(-95.15,-95.15,-12.113), Vector(95.15,95.15,12.113), 'models/hunter/blocks/cube4x4x05.mdl', Vector(-94.9,-94.9,-11.863),},
	{Vector(-71.425,-190.05,-6.181), Vector(71.425,190.05,6.181), 'models/hunter/blocks/cube3x8x025.mdl', Vector(-71.175,-189.8,-5.931),},
	{Vector(-71.425,-142.6,-6.181), Vector(71.425,142.6,6.181), 'models/hunter/blocks/cube3x6x025.mdl', Vector(-71.175,-142.35,-5.931),},
	{Vector(-71.425,-95.15,-6.181), Vector(71.425,95.15,6.181), 'models/hunter/blocks/cube3x4x025.mdl', Vector(-71.175,-94.9,-5.931),},
	{Vector(-71.425,-71.425,-12.113), Vector(71.425,71.425,12.113), 'models/hunter/blocks/cube3x3x05.mdl', Vector(-71.175,-71.175,-11.863),},
	{Vector(-95.15,-95.15,-6.156), Vector(95.15,95.15,6.156), 'models/hunter/blocks/cube4x4x025.mdl', Vector(-94.9,-94.9,-5.906),},
	{Vector(-47.7,-190.05,-23.975), Vector(47.7,190.05,23.975), 'models/hunter/blocks/cube2x8x1.mdl', Vector(-47.45,-189.8,-23.725),},
	{Vector(-71.425,-71.425,-6.181), Vector(71.425,71.425,6.181), 'models/hunter/blocks/cube3x3x025.mdl', Vector(-71.175,-71.175,-5.931),},
	{Vector(-47.7,-190.05,-12.113), Vector(47.7,190.05,12.113), 'models/hunter/blocks/cube2x8x05.mdl', Vector(-47.45,-189.8,-11.863),},
	{Vector(-47.7,-142.6,-23.975), Vector(47.7,142.6,23.975), 'models/hunter/blocks/cube2x6x1.mdl', Vector(-47.45,-142.35,-23.725),},
	{Vector(-47.7,-190.05,-6.181), Vector(47.7,190.05,6.181), 'models/hunter/blocks/cube2x8x025.mdl', Vector(-47.45,-189.8,-5.931),},
	{Vector(-47.7,-142.6,-12.113), Vector(47.7,142.6,12.113), 'models/hunter/blocks/cube2x6x05.mdl', Vector(-47.45,-142.35,-11.863),},
	{Vector(-47.7,-142.6,-6.181), Vector(47.7,142.6,6.181), 'models/hunter/blocks/cube2x6x025.mdl', Vector(-47.45,-142.35,-5.931),},
	{Vector(-47.7,-95.15,-23.975), Vector(47.7,95.15,23.975), 'models/hunter/blocks/cube2x4x1.mdl', Vector(-47.45,-94.9,-23.725),},
	{Vector(-47.7,-95.15,-12.113), Vector(47.7,95.15,12.113), 'models/hunter/blocks/cube2x4x05.mdl', Vector(-47.45,-94.9,-11.863),},
	{Vector(-47.7,-95.15,-6.181), Vector(47.7,95.15,6.181), 'models/hunter/blocks/cube2x4x025.mdl', Vector(-47.45,-94.9,-5.931),},
	{Vector(-47.7,-71.425,-6.181), Vector(47.7,71.425,6.181), 'models/hunter/blocks/cube2x3x025.mdl', Vector(-47.45,-71.175,-5.931),},
	{Vector(-47.7,-47.7,-6.181), Vector(47.7,47.7,6.181), 'models/hunter/blocks/cube2x2x025.mdl', Vector(-47.45,-47.45,-5.931),},
	{Vector(-47.7,-47.7,-12.113), Vector(47.7,47.7,12.113), 'models/hunter/blocks/cube2x2x05.mdl', Vector(-47.45,-47.45,-11.863),},
	{Vector(-47.7,-47.7,-23.975), Vector(47.7,47.7,23.975), 'models/hunter/blocks/cube2x2x1.mdl', Vector(-47.45,-47.45,-23.725),},
	{Vector(-47.7,-47.7,-47.7), Vector(47.7,47.7,47.7), 'models/hunter/blocks/cube2x2x2.mdl', Vector(-47.45,-47.45,-47.45),},
	{Vector(-18.044,-18.044,-6.181), Vector(18.044,18.044,6.181), 'models/hunter/blocks/cube075x075x025.mdl', Vector(-17.794,-17.794,-5.931),},
	{Vector(-29.906,-29.906,-6.181), Vector(29.906,29.906,6.181), 'models/hunter/blocks/cube125x125x025.mdl', Vector(-29.656,-29.656,-5.931),},
	{Vector(-35.838,-35.837,-6.181), Vector(35.838,35.837,6.181), 'models/hunter/blocks/cube150x150x025.mdl', Vector(-35.588,-35.587,-5.931),},
	{Vector(-23.975,-190.05,-12.113), Vector(23.975,190.05,12.113), 'models/hunter/blocks/cube1x8x05.mdl', Vector(-23.725,-189.8,-11.863),},
	{Vector(-23.975,-190.05,-23.975), Vector(23.975,190.05,23.975), 'models/hunter/blocks/cube1x8x1.mdl', Vector(-23.725,-189.8,-23.725),},
	{Vector(-23.975,-190.05,-6.181), Vector(23.975,190.05,6.181), 'models/hunter/blocks/cube1x8x025.mdl', Vector(-23.725,-189.8,-5.931),},
	{Vector(-23.975,-142.6,-23.975), Vector(23.975,142.6,23.975), 'models/hunter/blocks/cube1x6x1.mdl', Vector(-23.725,-142.35,-23.725),},
	{Vector(-23.975,-166.325,-6.181), Vector(23.975,166.325,6.181), 'models/hunter/blocks/cube1x7x025.mdl', Vector(-23.725,-166.075,-5.931),},
	{Vector(-23.975,-142.6,-12.113), Vector(23.975,142.6,12.113), 'models/hunter/blocks/cube1x6x05.mdl', Vector(-23.725,-142.35,-11.863),},
	{Vector(-23.975,-142.6,-6.181), Vector(23.975,142.6,6.181), 'models/hunter/blocks/cube1x6x025.mdl', Vector(-23.725,-142.35,-5.931),},
	{Vector(-23.975,-118.875,-6.181), Vector(23.975,118.875,6.181), 'models/hunter/blocks/cube1x5x025.mdl', Vector(-23.725,-118.625,-5.931),},
	{Vector(-23.975,-95.15,-23.975), Vector(23.975,95.15,23.975), 'models/hunter/blocks/cube1x4x1.mdl', Vector(-23.725,-94.9,-23.725),},
	{Vector(-23.975,-95.15,-12.113), Vector(23.975,95.15,12.113), 'models/hunter/blocks/cube1x4x05.mdl', Vector(-23.725,-94.9,-11.863),},
	{Vector(-18.044,-190.05,-6.181), Vector(18.044,190.05,6.181), 'models/hunter/blocks/cube075x8x025.mdl', Vector(-17.794,-189.8,-5.931),},
	{Vector(-12.113,-190.05,-12.113), Vector(12.113,190.05,12.113), 'models/hunter/blocks/cube05x8x05.mdl', Vector(-11.863,-189.8,-11.863),},
	{Vector(-12.113,-166.325,-12.113), Vector(12.113,166.325,12.113), 'models/hunter/blocks/cube05x7x05.mdl', Vector(-11.863,-166.075,-11.863),},
	{Vector(-23.975,-95.15,-12.113), Vector(12.113,95.15,23.975), 'models/hunter/blocks/cube075x4x075.mdl', Vector(-23.725,-94.9,-11.863),},
	{Vector(-23.975,-71.425,-23.975), Vector(23.975,71.425,23.975), 'models/hunter/blocks/cube1x3x1.mdl', Vector(-23.725,-71.175,-23.725),},
	{Vector(-23.975,-35.837,-23.975), Vector(23.975,35.837,23.975), 'models/hunter/blocks/cube1x150x1.mdl', Vector(-23.725,-35.587,-23.725),},
	{Vector(-12.113,-142.6,-12.113), Vector(12.113,142.6,12.113), 'models/hunter/blocks/cube05x6x05.mdl', Vector(-11.863,-142.35,-11.863),},
	{Vector(-12.113,-47.7,-12.113), Vector(12.113,47.7,12.113), 'models/hunter/blocks/cube05x2x05.mdl', Vector(-11.863,-47.45,-11.863),},
	{Vector(-23.975,-142.6,-12.113), Vector(12.113,142.6,23.975), 'models/hunter/blocks/cube075x6x075.mdl', Vector(-23.725,-142.35,-11.863),},
	{Vector(-23.975,-47.7,-12.113), Vector(12.113,47.7,23.975), 'models/hunter/blocks/cube075x2x075.mdl', Vector(-23.725,-47.45,-11.863),},
	{Vector(-12.113,-12.113,-12.113), Vector(12.113,12.113,12.113), 'models/hunter/blocks/cube05x05x05.mdl', Vector(-11.863,-11.863,-11.863),},
	{Vector(-18.044,-71.425,-6.181), Vector(18.044,71.425,6.181), 'models/hunter/blocks/cube075x3x025.mdl', Vector(-17.794,-71.175,-5.931),},
	{Vector(-12.113,-95.15,-6.181), Vector(12.113,95.15,6.181), 'models/hunter/blocks/cube05x4x025.mdl', Vector(-11.863,-94.9,-5.931),},
	{Vector(-18.044,-18.044,-18.044), Vector(18.044,18.044,18.044), 'models/hunter/blocks/cube075x075x075.mdl', Vector(-17.794,-17.794,-17.794),},
	{Vector(-23.975,-23.975,-12.113), Vector(12.113,23.975,23.975), 'models/hunter/blocks/cube075x1x075.mdl', Vector(-23.725,-23.725,-11.863),},
	{Vector(-18.044,-95.15,-6.181), Vector(18.044,95.15,6.181), 'models/hunter/blocks/cube075x4x025.mdl', Vector(-17.794,-94.9,-5.931),},
	{Vector(-12.113,-47.7,-0.25), Vector(0.25,47.7,12.113), 'models/hunter/blocks/cube025x2x025.mdl', Vector(-11.863,-47.45,0),},
	{Vector(-12.113,-142.6,-6.181), Vector(12.113,142.6,6.181), 'models/hunter/blocks/cube05x6x025.mdl', Vector(-11.863,-142.35,-5.931),},
	{Vector(-12.113,-166.325,-6.181), Vector(12.113,166.325,6.181), 'models/hunter/blocks/cube05x7x025.mdl', Vector(-11.863,-166.075,-5.931),},
	{Vector(-12.113,-23.975,-6.181), Vector(12.113,23.975,6.181), 'models/hunter/blocks/cube05x1x025.mdl', Vector(-11.863,-23.725,-5.931),},
	{Vector(-12.113,-207.844,-0.25), Vector(0.25,172.256,12.113), 'models/hunter/blocks/cube025x8x025.mdl', Vector(-11.863,-207.594,0),},
	{Vector(-12.113,-184.119,-0.25), Vector(0.25,148.531,12.113), 'models/hunter/blocks/cube025x7x025.mdl', Vector(-11.863,-183.869,0),},
	{Vector(-12.113,-95.15,-12.113), Vector(12.113,95.15,12.113), 'models/hunter/blocks/cube05x4x05.mdl', Vector(-11.863,-94.9,-11.863),},
	{Vector(-12.113,-136.669,-0.25), Vector(0.25,101.081,12.113), 'models/hunter/blocks/cube025x5x025.mdl', Vector(-11.863,-136.419,0),},
	{Vector(-23.975,-190.05,-12.113), Vector(12.113,190.05,23.975), 'models/hunter/blocks/cube075x8x075.mdl', Vector(-23.725,-189.8,-11.863),},
	{Vector(-23.975,-47.7,-18.044), Vector(23.975,47.7,29.906), 'models/hunter/blocks/cube1x2x1.mdl', Vector(-23.725,-47.45,-17.794),},
	{Vector(-23.975,-95.15,-6.181), Vector(23.975,95.15,6.181), 'models/hunter/blocks/cube1x4x025.mdl', Vector(-23.725,-94.9,-5.931),},
	{Vector(-12.113,-71.425,-6.181), Vector(12.113,71.425,6.181), 'models/hunter/blocks/cube05x3x025.mdl', Vector(-11.863,-71.175,-5.931),},
	{Vector(-12.113,-160.394,-0.25), Vector(0.25,124.806,12.113), 'models/hunter/blocks/cube025x6x025.mdl', Vector(-11.863,-160.144,0),},
	{Vector(-12.113,-47.7,-6.181), Vector(12.113,47.7,6.181), 'models/hunter/blocks/cube05x2x025.mdl', Vector(-11.863,-47.45,-5.931),},
	{Vector(-12.113,-12.113,-6.181), Vector(12.113,12.113,6.181), 'models/hunter/blocks/cube05x05x025.mdl', Vector(-11.863,-11.863,-5.931),},
	{Vector(-12.113,-190.05,-6.181), Vector(12.113,190.05,6.181), 'models/hunter/blocks/cube05x8x025.mdl', Vector(-11.863,-189.8,-5.931),},
	{Vector(-12.113,-118.875,-6.181), Vector(12.113,118.875,6.181), 'models/hunter/blocks/cube05x5x025.mdl', Vector(-11.863,-118.625,-5.931),},
	{Vector(-12.113,-12.113,-0.25), Vector(0.25,12.113,12.113), 'models/hunter/blocks/cube025x05x025.mdl', Vector(-11.863,-11.863,0),},
	{Vector(-6.156,-6.156,-6.156), Vector(6.156,6.156,6.156), 'models/hunter/blocks/cube025x025x025.mdl', Vector(-5.906,-5.906,-5.906),},
	{Vector(-12.113,-53.631,-0.25), Vector(0.25,18.044,12.113), 'models/hunter/blocks/cube025x150x025.mdl', Vector(-11.863,-53.381,0),},
	{Vector(-12.113,-23.975,-0.25), Vector(0.25,23.975,12.113), 'models/hunter/blocks/cube025x1x025.mdl', Vector(-11.863,-23.725,0),},
	{Vector(-12.113,-89.219,-0.25), Vector(0.25,53.631,12.113), 'models/hunter/blocks/cube025x3x025.mdl', Vector(-11.863,-88.969,0),},
	{Vector(-23.975,-71.425,-6.181), Vector(23.975,71.425,6.181), 'models/hunter/blocks/cube1x3x025.mdl', Vector(-23.725,-71.175,-5.931),},
	{Vector(-23.975,-118.875,-12.113), Vector(12.113,118.875,23.975), 'models/hunter/blocks/cube075x5x075.mdl', Vector(-23.725,-118.625,-11.863),},
	{Vector(-23.975,-23.975,-23.975), Vector(12.113,23.975,23.975), 'models/hunter/blocks/cube075x1x1.mdl', Vector(-23.725,-23.725,-23.725),},
	{Vector(-18.044,-142.6,-6.181), Vector(18.044,142.6,6.181), 'models/hunter/blocks/cube075x6x025.mdl', Vector(-17.794,-142.35,-5.931),},
	{Vector(-12.113,-112.944,-0.25), Vector(0.25,77.356,12.113), 'models/hunter/blocks/cube025x4x025.mdl', Vector(-11.863,-112.694,0),},
	{Vector(-23.975,-47.7,-23.975), Vector(12.113,47.7,23.975), 'models/hunter/blocks/cube075x2x1.mdl', Vector(-23.725,-47.45,-23.725),},
	{Vector(-23.975,-166.325,-12.113), Vector(12.113,166.325,23.975), 'models/hunter/blocks/cube075x7x075.mdl', Vector(-23.725,-166.075,-11.863),},
	{Vector(-12.113,-18.044,-6.181), Vector(12.113,18.044,6.181), 'models/hunter/blocks/cube05x075x025.mdl', Vector(-11.863,-17.794,-5.931),},
	{Vector(-18.044,-47.7,-6.181), Vector(18.044,47.7,6.181), 'models/hunter/blocks/cube075x2x025.mdl', Vector(-17.794,-47.45,-5.931),},
	{Vector(-18.044,-23.975,-6.181), Vector(18.044,23.975,6.181), 'models/hunter/blocks/cube075x1x025.mdl', Vector(-17.794,-23.725,-5.931),},
	{Vector(-12.113,-71.425,-12.113), Vector(12.113,71.425,12.113), 'models/hunter/blocks/cube05x3x05.mdl', Vector(-11.863,-71.175,-11.863),},
	{Vector(-23.975,-71.425,-12.113), Vector(12.113,71.425,23.975), 'models/hunter/blocks/cube075x3x075.mdl', Vector(-23.725,-71.175,-11.863),},
	{Vector(-12.113,-23.975,-12.113), Vector(12.113,23.975,12.113), 'models/hunter/blocks/cube05x1x05.mdl', Vector(-11.863,-23.725,-11.863),},
	{Vector(-23.975,-23.975,-6.181), Vector(23.975,23.975,6.181), 'models/hunter/blocks/cube1x1x025.mdl', Vector(-23.725,-23.725,-5.931),},
	{Vector(-23.975,-47.7,-6.181), Vector(23.975,47.7,6.181), 'models/hunter/blocks/cube1x2x025.mdl', Vector(-23.725,-47.45,-5.931),},
	{Vector(-23.975,-23.975,-12.113), Vector(23.975,23.975,12.113), 'models/hunter/blocks/cube1x1x05.mdl', Vector(-23.725,-23.725,-11.863),},
	{Vector(-12.113,-35.838,-12.113), Vector(12.113,35.838,12.113), 'models/hunter/blocks/cube05x105x05.mdl', Vector(-11.863,-35.588,-11.863),},
	{Vector(-23.975,-47.7,-12.113), Vector(23.975,47.7,12.113), 'models/hunter/blocks/cube1x2x05.mdl', Vector(-23.725,-47.45,-11.863),},
	{Vector(-23.975,-23.975,-23.975), Vector(23.975,23.975,23.975), 'models/hunter/blocks/cube1x1x1.mdl', Vector(-23.725,-23.725,-23.725),},
	{Vector(-23.975,-71.425,-23.975), Vector(12.113,71.425,23.975), 'models/hunter/blocks/cube075x3x1.mdl', Vector(-23.725,-71.175,-23.725),},
	{Vector(-12.113,-118.875,-12.113), Vector(12.113,118.875,12.113), 'models/hunter/blocks/cube05x5x05.mdl', Vector(-11.863,-118.625,-11.863),},
	{Vector(-12.113,-35.838,-0.25), Vector(0.25,0.25,12.113), 'models/hunter/blocks/cube025x075x025.mdl', Vector(-11.863,-35.588,0),},
	{Vector(-12.113,-47.7,-0.25), Vector(0.25,12.112,12.113), 'models/hunter/blocks/cube025x125x025.mdl', Vector(-11.863,-47.45,0),},
	--plates
	{Vector(-6.181,-6.181,-1.75), Vector(6.181,6.181,1.75), 'models/hunter/plates/plate025x025.mdl', Vector(-5.931,-5.931,-1.5)},
	{Vector(-6.181,-12.112,-1.75), Vector(6.181,12.112,1.75), 'models/hunter/plates/plate025x05.mdl', Vector(-5.931,-11.862,-1.5)},
	{Vector(-6.181,-18.044,-1.75), Vector(6.181,18.044,1.75), 'models/hunter/plates/plate025x075.mdl', Vector(-5.931,-17.794,-1.5)},
	{Vector(-6.181,-23.975,-1.75), Vector(6.181,23.975,1.75), 'models/hunter/plates/plate025x1.mdl', Vector(-5.931,-23.725,-1.5)},
	{Vector(-6.181,-29.906,-0.25), Vector(6.181,29.906,3.25), 'models/hunter/plates/plate025x125.mdl', Vector(-5.931,-29.656,0)},
	{Vector(-6.181,-35.838,-0.25), Vector(6.181,35.838,3.25), 'models/hunter/plates/plate025x150.mdl', Vector(-5.931,-35.588,0)},
	{Vector(-6.181,-41.769,-0.25), Vector(6.181,41.769,3.25), 'models/hunter/plates/plate025x175.mdl', Vector(-5.931,-41.519,0)},
	{Vector(-6.181,-47.7,-1.75), Vector(6.181,47.7,1.75), 'models/hunter/plates/plate025x2.mdl', Vector(-5.931,-47.45,-1.5)},
	{Vector(-6.181,-71.425,-1.75), Vector(6.181,71.425,1.75), 'models/hunter/plates/plate025x3.mdl', Vector(-5.931,-71.175,-1.5)},
	{Vector(-6.181,-95.15,-1.75), Vector(6.181,95.15,1.75), 'models/hunter/plates/plate025x4.mdl', Vector(-5.931,-94.9,-1.5)},
	{Vector(-6.181,-118.875,-1.75), Vector(6.181,118.875,1.75), 'models/hunter/plates/plate025x5.mdl', Vector(-5.931,-118.625,-1.5)},
	{Vector(-6.181,-142.6,-1.75), Vector(6.181,142.6,1.75), 'models/hunter/plates/plate025x6.mdl', Vector(-5.931,-142.35,-1.5)},
	{Vector(-6.181,-166.325,-1.75), Vector(6.181,166.325,1.75), 'models/hunter/plates/plate025x7.mdl', Vector(-5.931,-166.075,-1.5)},
	{Vector(-6.181,-190.05,-1.75), Vector(6.181,190.05,1.75), 'models/hunter/plates/plate025x8.mdl', Vector(-5.931,-189.8,-1.5)},
	{Vector(-6.181,-379.85,-1.75), Vector(6.181,379.85,1.75), 'models/hunter/plates/plate025x16.mdl', Vector(-5.931,-379.6,-1.5)},
	{Vector(-6.181,-569.65,-1.75), Vector(6.181,569.65,1.75), 'models/hunter/plates/plate025x24.mdl', Vector(-5.931,-569.4,-1.5)},
	{Vector(-6.181,-759.45,-1.75), Vector(6.181,759.45,1.75), 'models/hunter/plates/plate025x32.mdl', Vector(-5.931,-759.2,-1.5)},
	{Vector(-12.113,-12.113,-1.75), Vector(12.113,12.113,1.75), 'models/hunter/plates/plate05x05.mdl', Vector(-11.863,-11.863,-1.5)},
	{Vector(-12.113,-23.975,-1.75), Vector(12.113,12.112,1.75), 'models/hunter/plates/plate05x075.mdl', Vector(-11.863,-23.725,-1.5)},
	{Vector(-12.113,-23.975,-1.75), Vector(12.113,23.975,1.75), 'models/hunter/plates/plate05x1.mdl', Vector(-11.863,-23.725,-1.5)},
	{Vector(-12.113,-47.7,-1.75), Vector(12.113,47.7,1.75), 'models/hunter/plates/plate05x2.mdl', Vector(-11.863,-47.45,-1.5)},
	{Vector(-12.113,-71.425,-1.75), Vector(12.113,71.425,1.75), 'models/hunter/plates/plate05x3.mdl', Vector(-11.863,-71.175,-1.5)},
	{Vector(-12.113,-95.15,-1.75), Vector(12.113,95.15,1.75), 'models/hunter/plates/plate05x4.mdl', Vector(-11.863,-94.9,-1.5)},
	{Vector(-12.113,-118.875,-1.75), Vector(12.113,118.875,1.75), 'models/hunter/plates/plate05x5.mdl', Vector(-11.863,-118.625,-1.5)},
	{Vector(-12.113,-142.6,-1.75), Vector(12.113,142.6,1.75), 'models/hunter/plates/plate05x6.mdl', Vector(-11.863,-142.35,-1.5)},
	{Vector(-12.113,-166.325,-1.75), Vector(12.113,166.325,1.75), 'models/hunter/plates/plate05x7.mdl', Vector(-11.863,-166.075,-1.5)},
	{Vector(-12.113,-190.05,-1.75), Vector(12.113,190.05,1.75), 'models/hunter/plates/plate05x8.mdl', Vector(-11.863,-189.8,-1.5)},
	{Vector(-12.113,-379.85,-1.75), Vector(12.113,379.85,1.75), 'models/hunter/plates/plate05x16.mdl', Vector(-11.863,-379.6,-1.5)},
	{Vector(-12.113,-759.45,-1.75), Vector(12.113,759.45,1.75), 'models/hunter/plates/plate05x32.mdl', Vector(-11.863,-759.2,-1.5)},
	{Vector(-12.113,-569.65,-1.75), Vector(12.113,569.65,1.75), 'models/hunter/plates/plate05x24.mdl', Vector(-11.863,-569.4,-1.5)},
	{Vector(-23.975,-23.975,-1.75), Vector(12.113,12.112,1.75), 'models/hunter/plates/plate075x075.mdl', Vector(-23.725,-23.725,-1.5)},
	{Vector(-23.975,-23.975,-1.75), Vector(12.113,23.975,1.75), 'models/hunter/plates/plate075x1.mdl', Vector(-23.725,-23.725,-1.5)},
	{Vector(-23.975,-35.838,-1.75), Vector(12.113,35.837,1.75), 'models/hunter/plates/plate075x105.mdl', Vector(-23.725,-35.588,-1.5)},
	{Vector(-23.975,-47.7,-1.75), Vector(12.113,47.7,1.75), 'models/hunter/plates/plate075x2.mdl', Vector(-23.725,-47.45,-1.5)},
	{Vector(-23.975,-71.425,-1.75), Vector(12.113,71.425,1.75), 'models/hunter/plates/plate075x3.mdl', Vector(-23.725,-71.175,-1.5)},
	{Vector(-23.975,-95.15,-1.75), Vector(12.113,95.15,1.75), 'models/hunter/plates/plate075x4.mdl', Vector(-23.725,-94.9,-1.5)},
	{Vector(-23.975,-118.875,-1.75), Vector(12.113,118.875,1.75), 'models/hunter/plates/plate075x5.mdl', Vector(-23.725,-118.625,-1.5)},
	{Vector(-23.975,-142.6,-1.75), Vector(12.113,142.6,1.75), 'models/hunter/plates/plate075x6.mdl', Vector(-23.725,-142.35,-1.5)},
	{Vector(-23.975,-166.325,-1.75), Vector(12.113,166.325,1.75), 'models/hunter/plates/plate075x7.mdl', Vector(-23.725,-166.075,-1.5)},
	{Vector(-23.975,-190.05,-1.75), Vector(12.113,190.05,1.75), 'models/hunter/plates/plate075x8.mdl', Vector(-23.725,-189.8,-1.5)},
	{Vector(-23.975,-379.85,-1.75), Vector(12.113,379.85,1.75), 'models/hunter/plates/plate075x16.mdl', Vector(-23.725,-379.6,-1.5)},
	{Vector(-23.975,-569.65,-1.75), Vector(12.113,569.65,1.75), 'models/hunter/plates/plate075x24.mdl', Vector(-23.725,-569.4,-1.5)},
	{Vector(-23.975,-759.45,-1.75), Vector(12.113,759.45,1.75), 'models/hunter/plates/plate075x32.mdl', Vector(-23.725,-759.2,-1.5)},
	{Vector(-23.975,-23.975,-1.75), Vector(23.975,23.975,1.75), 'models/hunter/plates/plate1x1.mdl', Vector(-23.725,-23.725,-1.5)},
	{Vector(-23.975,-47.7,-1.75), Vector(23.975,47.7,1.75), 'models/hunter/plates/plate1x2.mdl', Vector(-23.725,-47.45,-1.5)},
	{Vector(-23.975,-71.425,-1.75), Vector(23.975,71.425,1.75), 'models/hunter/plates/plate1x3.mdl', Vector(-23.725,-71.175,-1.5)},
	{Vector(-23.975,-95.15,-1.75), Vector(23.975,95.15,1.75), 'models/hunter/plates/plate1x4.mdl', Vector(-23.725,-94.9,-1.5)},
	{Vector(-23.975,-118.875,-1.75), Vector(23.975,118.875,1.75), 'models/hunter/plates/plate1x5.mdl', Vector(-23.725,-118.625,-1.5)},
	{Vector(-23.975,-142.6,-1.75), Vector(23.975,142.6,1.75), 'models/hunter/plates/plate1x6.mdl', Vector(-23.725,-142.35,-1.5)},
	{Vector(-23.975,-166.325,-1.75), Vector(23.975,166.325,1.75), 'models/hunter/plates/plate1x7.mdl', Vector(-23.725,-166.075,-1.5)},
	{Vector(-23.975,-190.05,-1.75), Vector(23.975,190.05,1.75), 'models/hunter/plates/plate1x8.mdl', Vector(-23.725,-189.8,-1.5)},
	{Vector(-23.975,-379.85,-1.75), Vector(23.975,379.85,1.75), 'models/hunter/plates/plate1x16.mdl', Vector(-23.725,-379.6,-1.5)},
	{Vector(-23.975,-569.65,-1.75), Vector(23.975,569.65,1.75), 'models/hunter/plates/plate1x24.mdl', Vector(-23.725,-569.4,-1.5)},
	{Vector(-23.975,-759.45,-1.75), Vector(23.975,759.45,1.75), 'models/hunter/plates/plate1x32.mdl', Vector(-23.725,-759.2,-1.5)},
	{Vector(-47.7,-47.7,-1.75), Vector(47.7,47.7,1.75), 'models/hunter/plates/plate2x2.mdl', Vector(-47.45,-47.45,-1.5)},
	{Vector(-47.7,-71.425,-1.75), Vector(47.7,71.425,1.75), 'models/hunter/plates/plate2x3.mdl', Vector(-47.45,-71.175,-1.5)},
	{Vector(-47.7,-95.15,-1.75), Vector(47.7,95.15,1.75), 'models/hunter/plates/plate2x4.mdl', Vector(-47.45,-94.9,-1.5)},
	{Vector(-47.7,-118.875,-1.75), Vector(47.7,118.875,1.75), 'models/hunter/plates/plate2x5.mdl', Vector(-47.45,-118.625,-1.5)},
	{Vector(-47.7,-142.6,-1.75), Vector(47.7,142.6,1.75), 'models/hunter/plates/plate2x6.mdl', Vector(-47.45,-142.35,-1.5)},
	{Vector(-47.7,-166.325,-1.75), Vector(47.7,166.325,1.75), 'models/hunter/plates/plate2x7.mdl', Vector(-47.45,-166.075,-1.5)},
	{Vector(-47.7,-190.05,-1.75), Vector(47.7,190.05,1.75), 'models/hunter/plates/plate2x8.mdl', Vector(-47.45,-189.8,-1.5)},
	{Vector(-47.7,-379.85,-1.75), Vector(47.7,379.85,1.75), 'models/hunter/plates/plate2x16.mdl', Vector(-47.45,-379.6,-1.5)},
	{Vector(-47.7,-569.65,-1.75), Vector(47.7,569.65,1.75), 'models/hunter/plates/plate2x24.mdl', Vector(-47.45,-569.4,-1.5)},
	{Vector(-47.7,-759.45,-1.75), Vector(47.7,759.45,1.75), 'models/hunter/plates/plate2x32.mdl', Vector(-47.45,-759.2,-1.5)},
	{Vector(-71.425,-71.425,-1.75), Vector(71.425,71.425,1.75), 'models/hunter/plates/plate3x3.mdl', Vector(-71.175,-71.175,-1.5)},
	{Vector(-71.425,-95.15,-1.75), Vector(71.425,95.15,1.75), 'models/hunter/plates/plate3x4.mdl', Vector(-71.175,-94.9,-1.5)},
	{Vector(-71.425,-118.875,-1.75), Vector(71.425,118.875,1.75), 'models/hunter/plates/plate3x5.mdl', Vector(-71.175,-118.625,-1.5)},
	{Vector(-71.425,-142.6,-1.75), Vector(71.425,142.6,1.75), 'models/hunter/plates/plate3x6.mdl', Vector(-71.175,-142.35,-1.5)},
	{Vector(-71.425,-166.325,-1.75), Vector(71.425,166.325,1.75), 'models/hunter/plates/plate3x7.mdl', Vector(-71.175,-166.075,-1.5)},
	{Vector(-71.425,-190.05,-1.75), Vector(71.425,190.05,1.75), 'models/hunter/plates/plate3x8.mdl', Vector(-71.175,-189.8,-1.5)},
	{Vector(-71.425,-379.85,-1.75), Vector(71.425,379.85,1.75), 'models/hunter/plates/plate3x16.mdl', Vector(-71.175,-379.6,-1.5)},
	{Vector(-71.425,-569.65,-1.75), Vector(71.425,569.65,1.75), 'models/hunter/plates/plate3x24.mdl', Vector(-71.175,-569.4,-1.5)},
	{Vector(-71.425,-759.45,-1.75), Vector(71.425,759.45,1.75), 'models/hunter/plates/plate3x32.mdl', Vector(-71.175,-759.2,-1.5)},
	{Vector(-95.15,-95.15,-1.75), Vector(95.15,95.15,1.75), 'models/hunter/plates/plate4x4.mdl', Vector(-94.9,-94.9,-1.5)},
	{Vector(-95.15,-118.875,-1.75), Vector(95.15,118.875,1.75), 'models/hunter/plates/plate4x5.mdl', Vector(-94.9,-118.625,-1.5)},
	{Vector(-95.15,-142.6,-1.75), Vector(95.15,142.6,1.75), 'models/hunter/plates/plate4x6.mdl', Vector(-94.9,-142.35,-1.5)},
	{Vector(-95.15,-166.325,-1.75), Vector(95.15,166.325,1.75), 'models/hunter/plates/plate4x7.mdl', Vector(-94.9,-166.075,-1.5)},
	{Vector(-95.15,-190.05,-1.75), Vector(95.15,190.05,1.75), 'models/hunter/plates/plate4x8.mdl', Vector(-94.9,-189.8,-1.5)},
	{Vector(-95.15,-379.85,-1.75), Vector(95.15,379.85,1.75), 'models/hunter/plates/plate4x16.mdl', Vector(-94.9,-379.6,-1.5)},
	{Vector(-95.15,-569.65,-1.75), Vector(95.15,569.65,1.75), 'models/hunter/plates/plate4x24.mdl', Vector(-94.9,-569.4,-1.5)},
	{Vector(-95.15,-759.45,-1.75), Vector(95.15,759.45,1.75), 'models/hunter/plates/plate4x32.mdl', Vector(-94.9,-759.2,-1.5)},
	{Vector(-118.875,-118.875,-1.75), Vector(118.875,118.875,1.75), 'models/hunter/plates/plate5x5.mdl', Vector(-118.625,-118.625,-1.5)},
	{Vector(-118.875,-142.6,-1.75), Vector(118.875,142.6,1.75), 'models/hunter/plates/plate5x6.mdl', Vector(-118.625,-142.35,-1.5)},
	{Vector(-118.875,-166.325,-1.75), Vector(118.875,166.325,1.75), 'models/hunter/plates/plate5x7.mdl', Vector(-118.625,-166.075,-1.5)},
	{Vector(-118.875,-190.05,-1.75), Vector(118.875,190.05,1.75), 'models/hunter/plates/plate5x8.mdl', Vector(-118.625,-189.8,-1.5)},
	{Vector(-118.875,-379.85,-1.75), Vector(118.875,379.85,1.75), 'models/hunter/plates/plate5x16.mdl', Vector(-118.625,-379.6,-1.5)},
	{Vector(-118.875,-569.65,-1.75), Vector(118.875,569.65,1.75), 'models/hunter/plates/plate5x24.mdl', Vector(-118.625,-569.4,-1.5)},
	{Vector(-118.875,-759.45,-1.75), Vector(118.875,759.45,1.75), 'models/hunter/plates/plate5x32.mdl', Vector(-118.625,-759.2,-1.5)},
	{Vector(-142.6,-142.6,-1.75), Vector(142.6,142.6,1.75), 'models/hunter/plates/plate6x6.mdl', Vector(-142.35,-142.35,-1.5)},
	{Vector(-142.6,-166.325,-1.75), Vector(142.6,166.325,1.75), 'models/hunter/plates/plate6x7.mdl', Vector(-142.35,-166.075,-1.5)},
	{Vector(-142.6,-190.05,-1.75), Vector(142.6,190.05,1.75), 'models/hunter/plates/plate6x8.mdl', Vector(-142.35,-189.8,-1.5)},
	{Vector(-142.6,-379.85,-1.75), Vector(142.6,379.85,1.75), 'models/hunter/plates/plate6x16.mdl', Vector(-142.35,-379.6,-1.5)},
	{Vector(-142.6,-569.65,-1.75), Vector(142.6,569.65,1.75), 'models/hunter/plates/plate6x24.mdl', Vector(-142.35,-569.4,-1.5)},
	{Vector(-142.6,-759.45,-1.75), Vector(142.6,759.45,1.75), 'models/hunter/plates/plate6x32.mdl', Vector(-142.35,-759.2,-1.5)},
	{Vector(-166.325,-166.325,-1.75), Vector(166.325,166.325,1.75), 'models/hunter/plates/plate7x7.mdl', Vector(-166.075,-166.075,-1.5)},
	{Vector(-166.325,-190.05,-1.75), Vector(166.325,190.05,1.75), 'models/hunter/plates/plate7x8.mdl', Vector(-166.075,-189.8,-1.5)},
	{Vector(-166.325,-379.85,-1.75), Vector(166.325,379.85,1.75), 'models/hunter/plates/plate7x16.mdl', Vector(-166.075,-379.6,-1.5)},
	{Vector(-166.325,-569.65,-1.75), Vector(166.325,569.65,1.75), 'models/hunter/plates/plate7x24.mdl', Vector(-166.075,-569.4,-1.5)},
	{Vector(-166.325,-759.45,-1.75), Vector(166.325,759.45,1.75), 'models/hunter/plates/plate7x32.mdl', Vector(-166.075,-759.2,-1.5)},
	{Vector(-190.05,-190.05,-1.75), Vector(190.05,190.05,1.75), 'models/hunter/plates/plate8x8.mdl', Vector(-189.8,-189.8,-1.5)},
	{Vector(-190.05,-379.85,-1.75), Vector(190.05,379.85,1.75), 'models/hunter/plates/plate8x16.mdl', Vector(-189.8,-379.6,-1.5)},
	{Vector(-190.05,-569.65,-1.75), Vector(190.05,569.65,1.75), 'models/hunter/plates/plate8x24.mdl', Vector(-189.8,-569.4,-1.5)},
	{Vector(-190.05,-759.45,-1.75), Vector(190.05,759.45,1.75), 'models/hunter/plates/plate8x32.mdl', Vector(-189.8,-759.2,-1.5)},
	{Vector(-379.85,-379.85,-1.75), Vector(379.85,379.85,1.75), 'models/hunter/plates/plate16x16.mdl', Vector(-379.6,-379.6,-1.5)},
	{Vector(-379.85,-569.65,-1.75), Vector(379.85,569.65,1.75), 'models/hunter/plates/plate16x24.mdl', Vector(-379.6,-569.4,-1.5)},
	{Vector(-379.85,-759.45,-1.75), Vector(379.85,759.45,1.75), 'models/hunter/plates/plate16x32.mdl', Vector(-379.6,-759.2,-1.5)},
	{Vector(-569.65,-569.65,-1.75), Vector(569.65,569.65,1.75), 'models/hunter/plates/plate24x24.mdl', Vector(-569.4,-569.4,-1.5)},
	{Vector(-569.65,-759.45,-1.75), Vector(569.65,759.45,1.75), 'models/hunter/plates/plate24x32.mdl', Vector(-569.4,-759.2,-1.5)},
	{Vector(-759.45,-759.45,-1.75), Vector(759.45,759.45,1.75), 'models/hunter/plates/plate32x32.mdl', Vector(-759.2,-759.2,-1.5)},

}

local wood = {

	{Vector(-166.4,-23.992,-0.046), Vector(23.96,166.208,3.536), 'models/props_phx/construct/wood/wood_panel4x4.mdl', Vector(-166.119,-23.71,0.236)},
	{Vector(-71.501,-23.99,-0.046), Vector(23.96,166.208,3.536), 'models/props_phx/construct/wood/wood_panel2x4.mdl', Vector(-71.22,-23.709,0.236)},
	{Vector(-71.501,-23.99,-0.046), Vector(23.961,71.391,3.536), 'models/props_phx/construct/wood/wood_panel2x2.mdl', Vector(-71.22,-23.709,0.236)},
	{Vector(-24.052,-23.989,-0.046), Vector(23.961,71.391,3.536), 'models/props_phx/construct/wood/wood_panel1x2.mdl', Vector(-23.771,-23.708,0.236)},
	{Vector(-24.052,-23.989,-0.046), Vector(23.96,23.982,3.536), 'models/props_phx/construct/wood/wood_panel1x1.mdl', Vector(-23.771,-23.708,0.236)},

}

local woodframe = {

	{Vector(-24.036,-24.014,-0.281), Vector(71.438,71.459,95.191), 'models/props_phx/construct/wood/wood_wire2x2x2b.mdl', Vector(-23.754,-23.732,0)},
	{Vector(-24.036,-24.014,-0.281), Vector(71.437,71.459,47.736), 'models/props_phx/construct/wood/wood_wire1x2x2b.mdl', Vector(-23.754,-23.732,0)},
	{Vector(-47.736,-47.736,-0.281), Vector(47.736,47.736,6.213), 'models/props_phx/construct/wood/wood_wire2x2.mdl', Vector(-47.455,-47.455,0)},
	{Vector(-24.036,-24.014,-0.281), Vector(71.437,24.004,47.736), 'models/props_phx/construct/wood/wood_wire1x1x2.mdl', Vector(-23.754,-23.732,0)},
	{Vector(-24.035,-24.014,-0.281), Vector(23.982,71.459,6.213), 'models/props_phx/construct/wood/wood_wire1x2.mdl', Vector(-23.754,-23.732,0)},
	{Vector(-24.036,-24.014,-0.281), Vector(23.982,24.004,47.736), 'models/props_phx/construct/wood/wood_wire1x1x1.mdl', Vector(-23.754,-23.732,0)},
	{Vector(-24.035,-24.014,-0.281), Vector(23.982,24.004,6.213), 'models/props_phx/construct/wood/wood_wire1x1.mdl', Vector(-23.754,-23.732,0)},


}

local glass = {

	{Vector(-24.052,-24.006,-0.051), Vector(23.961,24.006,3.542), 'models/props_phx/construct/glass/glass_plate1x1.mdl', Vector(-23.771,-23.725,0.231)},
	{Vector(-24.052,-24.006,-0.045), Vector(23.961,71.456,3.534), 'models/props_phx/construct/glass/glass_plate1x2.mdl', Vector(-23.771,-23.725,0.237)},
	{Vector(-71.502,-24.006,-0.051), Vector(23.961,71.456,3.542), 'models/props_phx/construct/glass/glass_plate2x2.mdl', Vector(-71.22,-23.725,0.231)},
	{Vector(-71.502,-24.006,-0.045), Vector(23.961,166.355,3.534), 'models/props_phx/construct/glass/glass_plate2x4.mdl', Vector(-71.22,-23.725,0.237)},
	{Vector(-118.952,-24.006,-0.051), Vector(23.961,118.907,3.542), 'models/props_phx/construct/glass/glass_plate4x4.mdl', Vector(-118.67,-23.725,0.231)},

}

local strongglass = {

	{Vector(-24.052,-24.006,-0.045), Vector(23.961,24.006,3.534), 'models/props_phx/construct/windows/window1x1.mdl', Vector(-23.771,-23.725,0.237)},
	{Vector(-24.052,-24.006,-0.045), Vector(23.961,71.456,3.534), 'models/props_phx/construct/windows/window1x2.mdl', Vector(-23.771,-23.725,0.237)},
	{Vector(-71.502,-24.006,-0.045), Vector(23.961,71.456,3.534), 'models/props_phx/construct/windows/window2x2.mdl', Vector(-71.221,-23.725,0.237)},
	{Vector(-71.502,-24.006,-0.045), Vector(23.961,166.356,3.534), 'models/props_phx/construct/windows/window2x4.mdl', Vector(-71.221,-23.725,0.237)},
	{Vector(-166.402,-24.006,-0.045), Vector(23.961,166.356,3.534), 'models/props_phx/construct/windows/window4x4.mdl', Vector(-166.121,-23.725,0.237)},

}

local platetable = {

	["superflat"] = {1, 2, superflat, 0.5, 12},
	["steel"] = {2, 1, steel, 0.5179, 11.863},
	["plastic"] = {2, 1, plastic, .5, 11.863},
	["steelframe"] = {2, 1, steelframe, 0.5805, 11.863},
	["wood"] = {2, 1, wood, 0.5179, 11.863},
	["woodframe"] = {2, 1, woodframe, 0.5805, 11.863},
	["glass"] = {2, 1, glass, 0.5179, 11.885},
	["strongglass"] = {2, 1, strongglass, 0.5179, 11.863},

}

if SERVER then 

	util.AddNetworkString("createsmplate") 
	util.AddNetworkString("logsmplate") 
	util.AddNetworkString("tilebuildsingleplayerbs")
	util.AddNetworkString("tilebuildsingleplayerbspt2")
	util.AddNetworkString("tilebuildtoolstage")  

end


local tool, currentproptype

if CLIENT then 

	--CreateClientConVar("tilebuild_debug", "0", true, false, "debug mode",  0, 1)

	ghostprop = ents.CreateClientProp("prop_dynamic")

	TOOL.Information = {
		{name = "left", stage = 0},
		{name = "right", stage = 0},
		{name = "left2", stage = 1},
	}

	language.Add("tool.tilebuild.name", "Tile Build")
	language.Add("tool.tilebuild.desc", "Creates a prop based on specified dimensions.")

	language.Add("tool.tilebuild.left", "Select minimum bounds.")
	language.Add("tool.tilebuild.right", "Snap prop to grid.")
	language.Add("tool.tilebuild.left2", "Select maximum bounds.")


end





function TOOL:Deploy()

	--[[if SERVER then

		net.Start("tilebuildsingleplayerbspt2")
		net.Broadcast()

 	else

 		tool = LocalPlayer():GetTool("tilebuild")

		currentproptype = platetable[tostring(tool:GetClientInfo("proptype"))]

	end]]
	
end

--[[net.Receive("tilebuildsingleplayerbspt2", function()

	tool = LocalPlayer():GetTool("tilebuild")

	currentproptype = platetable[tostring(tool:GetClientInfo("proptype"))]

end)]]





function tilebuildclick()

	if CLIENT then

		tool = LocalPlayer():GetTool("tilebuild")

		currentproptype = platetable[tostring(tool:GetClientInfo("proptype"))]


		local ent = LocalPlayer():GetEyeTrace().Entity

		local ent1, ent2 = ent:GetCollisionBounds()


		if active then

			net.Start("createsmplate")
			net.WriteString(finalmodel)
			net.WriteAngle(finalrotation)
			net.WriteVector(finalpos)
			net.WriteString(LocalPlayer():SteamID())
			net.WriteColor(Color(tool:GetClientNumber("red"), tool:GetClientNumber("green"), tool:GetClientNumber("blue"), tool:GetClientNumber("alpha")))
			net.WriteString(tool:GetClientInfo("material"))
			net.SendToServer()

			print(tostring(Color(tool:GetClientNumber("red"), tool:GetClientNumber("green"), tool:GetClientNumber("blue"), tool:GetClientNumber("alpha"))))

			active = false

			ghostprop:SetNoDraw(true)

		else

			snapamount = currentproptype[5]

			local hitpos = LocalPlayer():GetEyeTrace().HitPos
			dist = LocalPlayer():EyePos():Distance(hitpos)

			startpos = Vector(math.SnapTo(hitpos.x, snapamount), math.SnapTo(hitpos.y, snapamount), math.SnapTo(hitpos.z, snapamount))

			active = true

			ghostprop = ents.CreateClientProp("prop_dynamic")

			net.Start("tilebuildtoolstage")
			net.WriteString(LocalPlayer():SteamID())
			net.SendToServer()

		end


	end

end




net.Receive("tilebuildtoolstage", function()

	local ply = player.GetBySteamID(net.ReadString())

	ply:GetTool("tilebuild"):SetStage(1)

end)





net.Receive("createsmplate", function()

	local model = net.ReadString()
	local angle = net.ReadAngle()
	local pos = net.ReadVector()
	local ply = player.GetBySteamID(net.ReadString())
	local color = net.ReadColor()
	local material = net.ReadString()

	local prop = ents.Create("prop_physics")

	if ply:CheckLimit("props") then

		ply:GetTool("tilebuild"):SetStage(0)

		prop:SetModel(model)
		prop:SetPos(pos)
		prop:SetAngles(angle)
		prop:SetRenderMode( RENDERMODE_TRANSCOLOR )
		prop:SetColor(color)
		prop:SetMaterial(material)
		prop:Spawn()
		prop:GetPhysicsObject():EnableMotion(false)

		ply:AddCount("props", prop)

		cleanup.Add(ply, "props", prop)

		undo.Create("prop")
 			undo.AddEntity(prop)
 			undo.SetPlayer(ply)
 		undo.Finish()

 	end
	

end)





function TOOL:LeftClick()

	if doubletapprevention < CurTime() then

		doubletapprevention = CurTime() + FrameTime()

		if game.SinglePlayer() then

			net.Start("tilebuildsingleplayerbs")
			net.Broadcast()

		else

			tilebuildclick()

		end

	end

end





net.Receive("tilebuildsingleplayerbs", function()

	tilebuildclick()

end)





function TOOL:RightClick(tr)

	if CLIENT then

		net.Start("logsmplate")
		net.WriteString(LocalPlayer():SteamID())
		net.SendToServer()

	else

		if game.SinglePlayer() then

			rightclicksingleplayerbs(Entity(1))

		end

	end

end





net.Receive("logsmplate", function()

	local ply = player.GetBySteamID(net.ReadString())

	rightclicksingleplayerbs(ply)


end)





function rightclicksingleplayerbs(ply)

	for i = 0, 2 do

		local ent = ply:GetEyeTrace().Entity

		local ent1, ent2 = ent:GetCollisionBounds()

		local min, max = ent:GetPhysicsObject():GetAABB()

		local mmin, mmax = ent:GetModelBounds()

		tool = ply:GetTool("tilebuild")

		currentproptype = platetable[tostring(tool:GetClientInfo("proptype"))]


		if ent:GetClass() == "prop_physics" and ent:GetColor() ~= Color(0, 255, 0) then

			--ply:ChatPrint("{Vector("..tostring(math.Round(ent1.x, 3))..","..tostring(math.Round(ent1.y, 3))..","..tostring(math.Round(ent1.z, 3)).."), Vector("..tostring(math.Round(ent2.x, 3))..","..tostring(math.Round(ent2.y, 3))..","..tostring(math.Round(ent2.z, 3)).."), '" .. ent:GetModel() .."',".. " Vector(" ..tostring(math.Round(min.x, 3))..","..tostring(math.Round(min.y, 3))..","..tostring(math.Round(min.z, 3))..")}," )

			--ent:SetAngles(Angle(0,0,0))

			--ent:SetColor(Color(0, 255, 0))

			local newangle = ent:GetAngles():SnapTo( "p", 90 ):SnapTo( "y", 90 ):SnapTo( "r", 90 )

			local minlocation = min
			minlocation:Rotate( ent:GetAngles() )
			minlocation = minlocation + ent:GetPos()

			local snapfixamount = currentproptype[5]

			local snapfixpoint = Vector(math.SnapTo(minlocation.x,  snapfixamount), math.SnapTo(minlocation.y,  snapfixamount), math.SnapTo(minlocation.z,  snapfixamount))

			ent:SetPos(snapfixpoint - minlocation + ent:GetPos())

			ent:SetAngles(newangle)

			ent:GetPhysicsObject():EnableMotion(false)

	end

	end


end



hook.Add( "PostDrawTranslucentRenderables", "holothink`", function( bDepth, bSkybox )

	if bSkybox then return end

	local hitpos = LocalPlayer():GetEyeTrace().HitPos
	endpos = (LocalPlayer():GetAimVector() * dist) + LocalPlayer():EyePos()


	if active then

		render.SetMaterial(Material("gm_construct/color_room"))

		if tool:GetClientNumber("debug") == 1 then 

			render.DrawLine(endpos, startpos, Color( 255, 0, 0 ))

			render.DrawLine(startpos, Vector(startpos.x,startpos.y,endpos.z), Color( 0, 255, 0 ))

			render.DrawLine(startpos, Vector(startpos.x,endpos.y,startpos.z), Color( 0, 0, 255))

			render.DrawLine(startpos, Vector(endpos.x,startpos.y,startpos.z), Color( 255, 166, 0))


		end

		if tool:GetClientNumber("guide") == 1 then 

			render.DrawLine(startpos, endpos, Color( 255, 255, 255))

			render.DrawSphere(endpos, 1 , 10, 10, Color( 255, 255, 255 ))

			render.DrawSphere(startpos, 1 , 10, 10, Color( 255, 255, 255 ))

		end




	

		local xline = Vector(endpos.x,startpos.y,startpos.z)

		local yline = Vector(startpos.x,endpos.y,startpos.z)

		local zline = Vector(startpos.x,startpos.y,endpos.z)

		linetable = {
			{xline, xline:Distance(startpos), "x"},
			{yline, yline:Distance(startpos), "y"},
			{zline, zline:Distance(startpos), "z"}
		}
			
		table.sort( linetable, function(a, b) return a[2] > b[2] end )



		local firstpriority = currentproptype[1]

		local secondpriority = currentproptype[2]


		local longvector = (linetable[firstpriority][1] - startpos):GetNormalized()

		local longangle = longvector:Angle() 

		longangle = Angle(longangle.x, longangle.y, longangle.z)


		local holovector = Vector(0, 50, 0):GetNormalized()

		holovector:Rotate(longangle)


		local shortangle = (linetable[secondpriority][1] - startpos):GetNormalized():AngleEx(longvector) 

		local flip = math.Round(math.abs(longvector.x) + math.abs(longvector.y) + longvector.z, 0)
 
		local rotation = Angle(0, 0, (shortangle - holovector:AngleEx(holovector)).y * flip) 
	

		finalrotation = longangle + rotation 



		



		local displacepointer = Vector(0, 0, 1)
		displacepointer:Rotate(finalrotation)

		local spherepos = Vector(0,0,0)

		local thirdline = (linetable[3][1] - startpos):GetNormalized() * -1

		local displacestr = string.gsub(tostring(displacepointer), "-0", "0")
		local thirdlinestr = string.gsub(tostring(thirdline), "-0", "0")


		if displacestr == thirdlinestr  then 

			invert = true

		else

			invert = false 

		end


		



		if lastpos:Distance(endpos) >= 1 then 

			
			lastpos = endpos

			local cursordistance = 215225

			local lastmodel = finalmodel

			local truemax = Vector(0, 0, 0)

			for k, v in ipairs(currentproptype[3]) do

				local inversion = Vector(0,0,0)

				displacementfix = Vector(0, 0, 0)

				if invert then 

					inversion = Vector(((linetable[3][1] - startpos):GetNormalized()) * (v[2].z - v[1].z))

					displacementfix = Vector(0, 0, currentproptype[4])
					displacementfix:Rotate(finalrotation)

				end

		
				local max = Vector(v[2].x, v[2].y, v[2].z)
				max:Rotate(finalrotation)

				local min = Vector(v[1].x, v[1].y, v[1].z)

				local tempcornerfix = Vector(v[4].x, v[4].y, v[4].z)
				tempcornerfix:Rotate(finalrotation)

				local currentmax = max + startpos - tempcornerfix + (inversion * 2)

				if endpos:Distance(currentmax) < cursordistance then 

					cursordistance = endpos:Distance(currentmax)
					finalmodel = v[3]

					cornerfix = Vector(v[4].x, v[4].y, v[4].z)
					cornerfix:Rotate(finalrotation)

					finalinversion = inversion

					finalkey = k

					truemax = currentmax

				end

			end

			local color = Color(tool:GetClientInfo("red"), tool:GetClientInfo("green"), tool:GetClientInfo("blue"), 200)
			local material = tool:GetClientInfo("material")

			ghostprop:SetModel(finalmodel)
			ghostprop:SetRenderMode( RENDERMODE_GLOW )
			ghostprop:SetRenderFX( 15 )
			ghostprop:SetPos(startpos - cornerfix + finalinversion + displacementfix)
			ghostprop:SetAngles(finalrotation)
			ghostprop:SetMaterial(material)
			ghostprop:SetColor(color)

			finalpos = startpos - cornerfix + finalinversion + displacementfix


				

			if (lastmodel ~= finalmodel) or (not lastmax:IsEqualTol(truemax, 5) and lastmodel == finalmodel) then

				lastmax = truemax

				LocalPlayer():EmitSound("buttons/lightswitch2.wav", 75, 100, .2)

				timer.Create("waitforcolor", .01, 1, function()

					ghostprop:SetNoDraw(false)
					ghostprop:DrawModel()

				end)


			end

		end

		




		if tool:GetClientNumber("debug") == 1 then 

			render.DrawLine(endpos, (displacepointer * 10) + endpos, Color( 255, 0, 255))

			render.DrawWireframeSphere(lastmax, 3, 4, 4, Color(255, 0, 0))

			for k, v in pairs(currentproptype[3]) do

				local cornershit = Vector(v[1].x, v[1].y, v[1].z)
				cornershit:Rotate(finalrotation)

				local color = Color( 255, 255, 255 )

				local spherepos1 = Vector( v[1].x, v[1].y, v[1].z )
				spherepos1:Rotate(finalrotation)

				local spherepos2 = Vector( v[2].x, v[2].y, v[2].z )
				spherepos2:Rotate(finalrotation)

				local spherepos3 = Vector( 0, 25, 0)
				spherepos3:Rotate(finalrotation)


				local inversion = Vector(0,0,0)

				if invert then 

					inversion = Vector(((linetable[3][1] - startpos):GetNormalized()) * (v[2].z - v[1].z))

				end


				if v[3] == finalmodel then color = Color( 255, 255, 0 ) end

				render.DrawWireframeBox( startpos - cornershit + inversion, finalrotation, v[1],  v[2], color, false)

				render.DrawWireframeSphere(spherepos1 + startpos - cornershit, 2, 4, 4, color)

				render.DrawWireframeSphere(spherepos2 + startpos - cornershit + inversion * 2, 2, 4, 4, color)

				render.DrawWireframeSphere(spherepos1 + startpos - cornershit + spherepos3 + inversion, 2, 4, 4, color)

				--render.DrawLine(v[1] + startpos - cornerpos, cornerpos + Vector(0,100,0), Color(255,255,255))

			end

		end

	else 

		if IsValid(ghostprop) then

			ghostprop:SetNoDraw(true)

		end

	end

end)





function TOOL:Holster()

	startpos = Vector(0,0,0)
	endpos = Vector(0,0,0)

	if active then

			ghostprop:SetNoDraw(true)
			active = false

	end

end




list.Add( "tilebuildmaterials", "No_Material" )
list.Add( "tilebuildmaterials", "models/wireframe" )
list.Add( "tilebuildmaterials", "debug/env_cubemap_model" )
list.Add( "tilebuildmaterials", "models/shadertest/shader3" )
list.Add( "tilebuildmaterials", "models/shadertest/shader4" )
list.Add( "tilebuildmaterials", "models/shadertest/shader5" )
list.Add( "tilebuildmaterials", "models/shiny" )
list.Add( "tilebuildmaterials", "models/debug/debugwhite" )
list.Add( "tilebuildmaterials", "Models/effects/comball_sphere" )
list.Add( "tilebuildmaterials", "Models/effects/comball_tape" )
list.Add( "tilebuildmaterials", "Models/effects/splodearc_sheet" )
list.Add( "tilebuildmaterials", "Models/effects/vol_light001" )
list.Add( "tilebuildmaterials", "models/props_combine/stasisshield_sheet" )
list.Add( "tilebuildmaterials", "models/props_combine/portalball001_sheet" )
list.Add( "tilebuildmaterials", "models/props_combine/com_shield001a" )
list.Add( "tilebuildmaterials", "models/props_c17/frostedglass_01a" )
list.Add( "tilebuildmaterials", "models/props_lab/Tank_Glass001" )
list.Add( "tilebuildmaterials", "models/props_combine/tprings_globe" )
list.Add( "tilebuildmaterials", "models/rendertarget" )
list.Add( "tilebuildmaterials", "models/screenspace" )
list.Add( "tilebuildmaterials", "brick/brick_model" )
list.Add( "tilebuildmaterials", "models/props_pipes/GutterMetal01a" )
list.Add( "tilebuildmaterials", "models/props_pipes/Pipesystem01a_skin3" )
list.Add( "tilebuildmaterials", "models/props_wasteland/wood_fence01a" )
list.Add( "tilebuildmaterials", "models/props_foliage/tree_deciduous_01a_trunk" )
list.Add( "tilebuildmaterials", "models/props_c17/FurnitureFabric003a" )
list.Add( "tilebuildmaterials", "models/props_c17/FurnitureMetal001a" )
list.Add( "tilebuildmaterials", "models/props_c17/paper01" )
list.Add( "tilebuildmaterials", "models/flesh" )
list.Add( "tilebuildmaterials", "phoenix_storms/metalset_1-2" )
list.Add( "tilebuildmaterials", "phoenix_storms/metalfloor_2-3" )
list.Add( "tilebuildmaterials", "phoenix_storms/plastic" )
list.Add( "tilebuildmaterials", "phoenix_storms/wood" )
list.Add( "tilebuildmaterials", "phoenix_storms/bluemetal" )
list.Add( "tilebuildmaterials", "phoenix_storms/cube" )
list.Add( "tilebuildmaterials", "phoenix_storms/dome" )
list.Add( "tilebuildmaterials", "phoenix_storms/gear" )
list.Add( "tilebuildmaterials", "phoenix_storms/stripes" )
list.Add( "tilebuildmaterials", "phoenix_storms/wire/pcb_green" )
list.Add( "tilebuildmaterials", "phoenix_storms/wire/pcb_red" )
list.Add( "tilebuildmaterials", "phoenix_storms/wire/pcb_blue" )
list.Add( "tilebuildmaterials", "hunter/myplastic" )
list.Add( "tilebuildmaterials", "models/XQM/LightLinesRed_tool" )

list.Set( "tilebuildproptypes", "models/squad/sf_plates/sf_plate4x4.mdl")
list.Set( "tilebuildproptypes", "models/props_phx/construct/metal_plate1.mdl")
list.Set( "tilebuildproptypes", "models/maxofs2d/lamp_projector.mdl")

proptypes = {

	["models/squad/sf_plates/sf_plate4x4.mdl"] = {["tilebuild_proptype"] = "superflat"},
	["models/props_phx/construct/metal_plate1.mdl"] = {["tilebuild_proptype"] = "steel"},
	["models/props_phx/construct/metal_wire1x1.mdl"] = {["tilebuild_proptype"] = "steelframe"},
	["models/hunter/plates/plate1x1.mdl"] = {["tilebuild_proptype"] = "plastic"},
	["models/props_phx/construct/wood/wood_panel1x1.mdl"] = {["tilebuild_proptype"] = "wood"},
	["models/props_phx/construct/wood/wood_wire1x1.mdl"] = {["tilebuild_proptype"] = "woodframe"},
	["models/props_phx/construct/glass/glass_plate1x1.mdl"] = {["tilebuild_proptype"] = "glass"},
	["models/props_phx/construct/windows/window1x1.mdl"] = {["tilebuild_proptype"] = "strongglass"},

}

function TOOL.BuildCPanel( DForm )

	DForm:SetName( "Tile Build" )

	DForm:CheckBox( "Corner helper.", "tilebuild_guide" )

	DForm:PropSelect( "Prop Type", "tilebuild_modelselected", proptypes,  2 )

	DForm.ColorSelect = DForm:AddControl("Color", {
		["label"] = "",
		["red"] = "tilebuild_red",
		["green"] = "tilebuild_green",
		["blue"] = "tilebuild_blue",
		["alpha"] = "tilebuild_alpha"
	})

	DForm.Material = DForm:MatSelect("tilebuild_material", list.Get("tilebuildmaterials"), true, 0.25, 0.25)

	DForm:CheckBox( "Debug mode.", "tilebuild_debug" )

end


	




