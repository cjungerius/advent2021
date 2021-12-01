function depth(input)
    depth = input[1]
    increases = 0
    for i in input[2:end]
        increases += newdepth > depth
        depth = i
    end     
    increases  
end

function windowdepth(input)
    depth = sum(input[1:3])
    increases = 0
    for i in 2:length(input)-2
        newdepth = sum(input[i:i+2])
        increases += newdepth > depth
        depth = newdepth
    end
    increases
end


f = open(ARGS[1]);
input = parse.(Int64,readlines(f))
close(f)
println(depth(input))
println(windowdepth(input))
