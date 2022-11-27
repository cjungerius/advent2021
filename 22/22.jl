input = readlines("input.txt")

function partone(input)
    active_cubes = Set()
    for line in input[1:20]
        rx = r"(-?[0-9]+)"
        m = eachmatch(rx,line)
        coords = parse.(Int,[x.captures[1] for x in m])
        for x in coords[1]:coords[2], y in coords[3]:coords[4], z in coords[5]:coords[6]
            if line[1:2] == "on"
                push!(active_cubes,(x,y,z))
            else
                pop!(active_cubes, (x,y,z),nothing)
            end
        end
    end
    length(active_cubes)
end

function parttwo(input)
end