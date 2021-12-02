function dive(input)
    x = 0
    y = 0
    for i in input
        instruction = split(i," ")
        value = parse(Int,instruction[2])
        if instruction[1]=="forward"
            x += value
        elseif instruction[1]=="down"
            y += value
        elseif instruction[1]=="up"
            y -= value
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
        value = parse(Int,instruction[2])
        if instruction[1]=="forward"
            x += value
            y += aim*value
        elseif instruction[1]=="down"
            aim += value
        elseif instruction[1]=="up"
            aim -= value
        end
    end
    x*y
end


f = open(ARGS[1]);
input = readlines(f)
close(f)

println(dive(input))
println(dive_aim(input))