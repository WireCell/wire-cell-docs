local node = {type:"",name:"",port:0};
{
    TbbFlow: {
	tbbapp: {
	    dfp: "TbbDataFlowGraph",
	    graph: [
		{ tail: node {type:"TrackDepos"}, head: node {type:"Drifter",name:"DrifterU"} },
		{ tail: node {type:"TrackDepos"}, head: node {type:"Drifter",name:"DrifterV"} },
		{ tail: node {type:"TrackDepos"}, head: node {type:"Drifter",name:"DrifterW"} },
	    ]
	}
    }
}
