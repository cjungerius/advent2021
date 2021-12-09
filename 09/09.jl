function islowest(input,y,x)
	point = input[y,x]
	neighbourlist = neighbours(input,CartesianIndex(y,x))
	for neighbour in neighbourlist
		point < input[neighbour] || return false
		
	end
	true	
end

function neighbours(input,idx)
	y = idx[1]
	x = idx[2]
	candidates = [(y-1,x),(y+1,x),(y,x-1),(y,x+1)]
	neighbourlist = []	
	for (a,b) in candidates
		if 0 < a <= size(input)[1] && 0 < b <= size(input)[2]
			push!(neighbourlist,CartesianIndex(a,b))
		end
	end
	neighbourlist
end

function basinsearch(input,start)
	visited = Set([start])
	q = [start]
	while length(q) > 0
		current = pop!(q)
		neighbourlist = neighbours(input,current)
		for neighbour in neighbourlist
			if !(neighbour in visited) && input[current] < input[neighbour] < 9 
				push!(visited, neighbour)
				push!(q, neighbour)
			end
		end
	end
	length(visited)
end


function partone(input)

	lowpoints = zeros(Bool,size(input))
	for i in 1:size(input)[1]
		for j in 1:size(input)[2]
			lowpoints[i,j] = islowest(input,i,j)
		end
	end
	lowpoints
end

function parttwo(input)
	lowpoints = partone(input)
	basins = []

	for idx in findall(lowpoints)
		push!(basins,basinsearch(input,idx))
	end

	basins 
end

function preprocess(input)
	input = split.(input,"")
	input = [parse.(Int, line) for line in input]
	hcat(input...)
end

input = preprocess(readlines("input.txt"))
example = preprocess(readlines("example.txt"))
lowpoints = partone(input)

one = sum(input[lowpoints]) + length(lowpoints)
two = *(sort!(parttwo(input))[end-2:end]...)