function depth(input)
    sum(map(Base.splat(<), zip(input,input[2:end])))
end

function windowdepth(input)
    input = map(Base.splat(+), zip(input,input[2:end],input[3:end]))
    depth(input)
end


f = open(ARGS[1]);
input = parse.(Int64,readlines(f))
close(f)
println(depth(input))
println(windowdepth(input))