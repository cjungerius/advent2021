function vents(input; diag = false)
	starts = []
	stops = []
	diagstarts = []
	diagstops = []
	for line in input
		line = split(line)
		start, stop = coords.([line[1], line[3]])

		if start[1] == stop[1] || start[2] == stop[2]
			push!(starts,start)
			push!(stops, stop)
		elseif diag==true
			push!(diagstarts,start)
			push!(diagstops,stop)
		end
	end
	xmax = maximum([[coords[1] for coords in starts]..., [coords[1] for coords in stops]...])
	ymax = maximum([[coords[2] for coords in starts]..., [coords[2] for coords in stops]...])
	if diag == true
		xmax = max(xmax, maximum([[coords[1] for coords in diagstarts]..., [coords[1] for coords in diagstops]...]))
		ymax = max(ymax, maximum([[coords[2] for coords in diagstarts]..., [coords[2] for coords in diagstops]...]))
	end

	grid = zeros(Int,(xmax,ymax))

	for i in 1:length(starts)
		start = starts[i]
		stop = stops[i]
		xs = sort([start[1],stop[1]])
		ys = sort([start[2],stop[2]])
		@views grid[xs[1]:xs[2],ys[1]:ys[2]] .+= 1
	end

	if diag == true
		for i in 1:length(diagstarts)
			start = diagstarts[i]
			stop = diagstops[i]
			xs = ([start[1],stop[1]])
			ys = ([start[2],stop[2]])
			xrange = xs[1]:sign(xs[2]-xs[1]):xs[2]
			yrange = ys[1]:sign(ys[2]-ys[1]):ys[2]
			for coords in zip(xrange,yrange)
				@views grid[coords[1],coords[2]] += 1
			end
		
		
		end
	end
	count(x->x>1,grid)
end

function coords(string)
	parse.(Int,split(string,","))
end


input = readlines("input.txt")
partone = vents(input)
parttwo = vents(input, diag=true)