local units = import "units.jsonnet";
local drifter = import "drifter.jsonnet";
{
    drifterU : drifter + {
	location: 3*units.millimeter,
    },
    drifterV : drifter + {
	location: 2*units.millimeter,
    },
    drifterW : drifter + {
	location: 1*units.millimeter,
    },
}

