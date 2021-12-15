using Datastructures

input = readlines("input.txt")
input = split.(input,"")
input = [parse.(Int,line) for line in input]
input = hcat(input...)


function neighbours(s,idx)::Array{CartesianIndex,1}
	y = idx[1]
	x = idx[2]
	candidates = [(y-1,x),(y+1,x),(y,x-1),(y,x+1)]
	neighbourlist = []	
	for (a,b) in candidates
		if 0 < a <= s[1] && 0 < b <= s[2]
			push!(neighbourlist,CartesianIndex(a,b))
		end
	end
	neighbourlist
end

function dijkstra(input::Array{Int64,2})

    s = size(input)
    visited = Set([CartesianIndex(1,1)])
    distances = fill(Inf,s)
    distances[1,1] = 0

    pq = PriorityQueue()
    enqueue!(pq,CartesianIndex(1,1),0)

    while isinf(distances[end,end])
        node = dequeue!(pq)
        for neighbour in neighbours(s,node) 
            newdist = distances[node] + input[neighbour]
            distances[neighbour] = min(distances[neighbour], newdist)
            if !(neighbour in visited)
                push!(visited,neighbour)
                pq[neighbour] = distances[neighbour]
            end
        end
    end
    distances[end,end]
end


biginput = repeat(input,5,5)
for i in 1:size(biginput)[1], j in 1:size(biginput)[2]
    biginput[i,j] += ( (i-1) ÷ size(input)[1] )
    biginput[i,j] += ( (j-1) ÷ size(input)[2] )
    biginput[i,j] > 9 ? biginput[i,j] = rem(biginput[i,j],9) : continue
end


partone = dijkstra(input)
parttwo = dijkstra(biginput)