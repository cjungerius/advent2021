using Base:Bool
function preprocess(inputstr)
    input = readlines(inputstr)
    input = split.(input, "-")
end

function paths(input)
    names = unique(vcat(input...))
    namedict = Dict(["start" => 1,"end" => length(names)])
    bigcaves = Set([])
    for name in names
        if !(name in keys(namedict))
            namedict[name] = length(keys(namedict))
        end

        if isuppercase(name[1])
            push!(bigcaves, namedict[name])
        end
    end

    adjmat = zeros(Bool, (length(names), length(names)))
    for line in input
        i = namedict[line[1]]
        j = namedict[line[2]]
        adjmat[i,j] = true
        adjmat[j,i] = true
    end
    (adjmat, bigcaves)

    partone = dfs(adjmat, bigcaves, 1, repeat([false], length(names)))
    smallcaves = [!(x in bigcaves) for x in 1:length(names)]
    parttwo = dfs(adjmat, bigcaves, smallcaves, 1, repeat([0], length(names)))

    (partone, parttwo)
end


function dfs(adjmat, bigcaves, current, visited::Array{Bool})
    pathcount = 0
    visited[current] = true
    if current == size(adjmat)[1]
        pathcount += 1
    else
        for neighbour in findall(adjmat[current,:])
            if neighbour in bigcaves || !(visited[neighbour])
                pathcount += dfs(adjmat, bigcaves, neighbour, visited)            
            end
        end
    end
    visited[current] = false
    pathcount
end

function dfs(adjmat, bigcaves, smallcaves, current, visited::Array{Int64})
    pathcount = 0
    visited[current] += 1
    if current == size(adjmat)[1]
        pathcount += 1
    else
        for neighbour in findall(adjmat[current,:])
            if neighbour in bigcaves || visited[neighbour] == 0 || neighbour != 1 && maximum(visited[smallcaves]) < 2
                pathcount += dfs(adjmat, bigcaves, smallcaves, neighbour, visited)            
            end
        end
    end
    visited[current] -= 1
    pathcount
end


input = preprocess("input.txt")
example = preprocess("example.txt")
partone, parttwo = paths(input)
