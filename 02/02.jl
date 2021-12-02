function dive(input)
    x = 0
    y = 0
    for i in input
        instruction = split(i," ")
        if instruction[1]=="forward"
            x += parse(Int,instruction[2])
        elseif instruction[1]=="down"
            y += parse(Int,instruction[2])
        elseif instruction[1]=="up"
            y -= parse(Int,instruction[2])
        end
    end
    x*y
end


function dive_aim(input)
    x = 0
    y = 0
    aim = 0
    for i in input
        instruction = split(i," ")
        if instruction[1]=="forward"
            x += parse(Int,instruction[2])
            y += aim*parse(Int,instruction[2])
        elseif instruction[1]=="down"
            aim += parse(Int,instruction[2])
        elseif instruction[1]=="up"
            aim -= parse(Int,instruction[2])
        end
    end
    x*y
end


f = open(ARGS[1]);
input = readlines(f)
close(f)

println(dive(input))
println(dive_aim(input))