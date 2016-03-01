local wc = import "wirecell.jsonnet";
[
    wc.Component {
        type: "ExampleType",
        data: {
            pitch: 5*wc.mm,
	    tick: 0.5*wc.us,
        }
    }
]

    
