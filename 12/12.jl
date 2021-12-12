using Base: Bool
function preprocess(inputstr)
    input = readlines(inputstr)
    input = split.(input,"-")
end

function paths(input)
    names = unique(vcat(input...))
    namedict = Dict(["start"=>1,"end"=>length(names)])
    bigcaves = Set([])
    for name in names
        if !(name in keys(namedict))
            namedict[name] = length(keys(namedict))
        end

        if isuppercase(name[1])
            push!(bigcaves,namedict[name])
        end
    end

    adjmat = zeros(Bool,(length(names),length(names)))
    for line in input
        i=namedict[line[1]]
        j=namedict[line[2]]
        adjmat[i,j] = true
        adjmat[j,i] = true
    end
    (adjmat, bigcaves)

    partone = length(dfs(adjmat, bigcaves, 1, repeat([false],length(names)), []))
    parttwo = length(dfs(adjmat, bigcaves, 1, repeat([0],length(names)), []))

    (partone, parttwo)
end


function dfs(adjmat, bigcaves, current, visited::Array{Bool} ,paths)

    visited[current] = true
    if current==size(adjmat)[1]
        push!(paths,copy(visited))
    end
    for neighbour in findall(adjmat[current,:])
        if neighbour in bigcaves || !(visited[neighbour])
            dfs(adjmat,bigcaves, neighbour,visited,paths)            
        end
    end
    visited[current] = false
    paths
end

function dfs(adjmat, bigcaves, current,visited::Array{Int64},paths)
    visited[current] += 1
    if current==size(adjmat)[1]
        push!(paths,copy(visited))
    end
    for neighbour in findall(adjmat[current,:])
        if neighbour in bigcaves || visited[neighbour] == 0 || neighbour != 1 && neighbour != length(visited) && maximum( visited[[!(x in bigcaves) for x in 1:length(visited)]] ) <2
            dfs(adjmat,bigcaves, neighbour,visited,paths)            
        end
    end
    visited[current] -= 1
    paths
end


input = preprocess("input.txt")
example = preprocess("example.txt")
partone, parttwo = paths(input)