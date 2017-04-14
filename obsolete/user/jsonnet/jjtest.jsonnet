local drifter = import "drifter.jsonnet";
local trackdepos = import "trackdepos.jsonnet";
[
    drifter {
	name: "DrifterU",
	data +: { location_mm: 1.0 },
    },
    drifter {
	name: "DrifterV",
	data +: { location_mm: 2.0 },
    },
    drifter {
	name: "DrifterW",
	data +: { location_mm: 3.0 },
    },	
    trackdepos {
	local ray = [[0.0,0.0,0.0],[1.0,1.0,1.0]],
	name: "ParallelMuons",
	data +: {
	    tracks: [
		{time_s:t, dedx:-1, ray_mm:ray}
		     for t in [1,2,3]
	    ]
	},
    },
]
