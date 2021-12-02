function depth(input)
    sum(map(Base.splat(<), zip(input,input[2:end])))
end

function windowdepth(input)
    input = map(Base.splat(+), zip(input,input[2:end],input[3:end]))
    depth(input)
end

input = parse.(Int64,readlines("input.txt"))

depth(input)
windowdepth(input)