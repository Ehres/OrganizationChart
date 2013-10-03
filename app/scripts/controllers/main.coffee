'use strict'

angular.module('organizationChartApp').controller 'MainCtrl', ($scope) ->
	$scope.create = ->
		width = 960
		height = 1200

		cluster = d3.layout.cluster()
			.size([height, width - 160]);

		diagonal = d3.svg.diagonal()
		    .projection (d) -> 
		    	[d.y, d.x]

		svg = d3.select("body").select(".container").select("svg")
		    .attr("width", width)
		    .attr("height", height)
		  	.append("g")
		    .attr("transform", "translate(40, 0)")

		_this = this
		d3.json "sample.json", (error, root) ->
			root = _this.changeNode(root)
			console.log root

			nodes = cluster.nodes(root)
			links = cluster.links(nodes)

			link = svg.selectAll(".link")
			  .data(links)
			  .enter().append("path")
			  .attr("class", "link")
			  .attr("d", diagonal)

			node = svg.selectAll(".node")
			  .data(nodes)
			  .enter().append("g")
			  .attr("class", "node")
			  .attr("transform", (d) -> 
			  	"translate(" + d.y + "," + d.x + ")"
			  )
			  

			node.append("circle").attr "r", 4.5

			restSize = 170
			node.append("svg:rect")
			    .attr("rx", 15)
			    .attr("ry", 15)
			    .attr("x", - restSize/2)
			    .attr("y", - restSize/2)
			    .attr("fill", "grey")
			    .attr("width", (d) ->
			    	if (d.stc_company) then 0 else restSize
			    )
			    .attr("height", (d) ->
			    	if (d.stc_company) then 0 else restSize
			    )

		    node.append("image")
		      .attr("xlink:href", (d) ->
		      	d.stc_picture
		      )
		      .attr("x", - restSize/4)
		      .attr("y", - restSize/4)
		      .attr("width", 100)
		      .attr("height", 100);

			node.append("text")
			  .attr("dx", (d) ->
			  	if d.stc_employees then -8 else 8 
			  )
			  .attr("dy", 3)
			  .attr("x", (d) ->
			  	if d.stc_company then -20 else -60
			  )
			  .attr("y", (d) ->
			  	if d.stc_company then -10 else -70
			  )
			  .attr("fill", (d) ->
			  	if d.stc_company then "black" else "white"
			  )
			  .style("text-anchor", (d) ->
			  	if d.stc_employees then "end" else "start"
			  )
			  .text((d) ->
			  	if d.stc_company then d.stc_company else if d.stc_name then d.stc_name else "" 
			  )

			node.append("text")
			  .attr("dy", 3)
			  .attr("x", -80)
			  .attr("y", 70)
			  .attr("fill", "white")
			  .text (d) ->
			  	"role : " + if d.stc_role then d.stc_role else ""
			  
		

		d3.select(self.frameElement).style("height", height + "px")

	$scope.changeNode = (node) ->
		for key of node
			if node[key] instanceof Array
	  			node.children = node[key]
	  			node.children.NodeName = key
	  			console.log node
	  			@changeNode node[key]
	  			delete node[key]
		node