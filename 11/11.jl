example = readlines("example.txt")
example = split.(example,"")
example = [parse.(Int,line) for line in example]
example = hcat(example...)'

function getneighbours(input,idx)
	y = idx[1]
	x = idx[2]
	candidates = [(y-1,x-1),(y,x-1),(y+1,x-1),(y-1,x),(y+1,x),(y-1,x+1),(y,x+1),(y,x+1)]
	neighbourlist = []	
	for (a,b) in candidates
		if 0 < a <= size(input)[1] && 0 < b <= size(input)[2]
			push!(neighbourlist,CartesianIndex(a,b))
		end
	end
	neighbourlist
end

function step!(input,steps)
flashes = 0
for s in 1:steps
	for y in 1:size(example)[1], x in 1:size(example)[2]
		input[y,x] += 1
	end

	flashers = Set([])
	newflashers = Tuple.(findall(x->x>9,input))
	while length(newflashers) > length(flashers)
		for newflasher in newflashers
			if !(newflasher in flashers)
				flashes += 1
				push!(flashers,newflasher)
				neighbours = getneighbours(input,newflasher)
				for neighbour in neighbours
					println(neighbour)
					println(input[neighbour])
					input[neighbour] += 1
				end
			end	
		end
		newflashers = Tuple.(findall(x->x>9,input))
	end

	for (y,x) in flashers
		input[y,x] = 0
	end

end
input
end


