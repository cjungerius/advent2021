input = readlines("input.txt")

function partone(input)
    active_cubes = Set()
    for line in input[1: min(20,length(input))]
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

# struct Cube
#     x_min::Int
#     x_max::Int
#     y_min::Int
#     y_max::Int
#     z_min::Int
#     z_max::Int
#     value::Int
# end

# function intersect(a::Cube, b::Cube)
#     xspan = intersect(a.x_min:a.x_max,b.x_min:b.x_max)
#     yspan = intersect(a.y_min:a.y_max,b.y_min:b.y_max)
#     zspan = intersect(a.z_min:a.z_max,b.z_min:b.z_max)

#     if any(x->x==0,length.([xspan,yspan,zspan]))
#         return nothing
#     end

#     value = -b.value

# end

function parttwo(input)
    active_cubes = []
    for line in input
        rx = r"(-?[0-9]+)"
        m = eachmatch(rx,line)
        coords = parse.(Int,[x.captures[1] for x in m])
        value = line[1:2] == "on" ? 1 : -1
        new_cube = [coords..., value]
        intersect_cubes = []
        for cube in active_cubes
            intersection = [
                intersect(cube[1]:cube[2],new_cube[1]:new_cube[2]),
                intersect(cube[3]:cube[4],new_cube[3]:new_cube[4]),
                intersect(cube[5]:cube[6],new_cube[5]:new_cube[6])
                ]
                 
            if all(x-> x>0, length.(intersection))
                intersect_cube = [
                    intersection[1][1], intersection[1][end],intersection[2][1],intersection[2][end],intersection[3][1],intersection[3][end]
                ]
            status = cube[7] * new_cube[7]
            if cube[7] == new_cube[7]
                status = -cube[7]
            elseif cube[7] == -1 && new_cube[7] == 1
                status = 1
            end

            push!(intersect_cube, status)
            push!(intersect_cubes,intersect_cube)
            end
        
        end
        if new_cube[7] == 1
            push!(active_cubes,new_cube)
        end
        if length(intersect_cubes) > 0
            push!(active_cubes,intersect_cubes...)
        end
    end

    result = 0
    for cube in active_cubes
        cube_size = (cube[2]-cube[1]+1) * (cube[4] - cube[3]+1) * (cube[6] - cube[5] + 1)
        cube_val = cube_size * cube[7]
        println(result, " + " , cube_val, " = ", result+cube_val)
        result += cube_val
    end
  result
end