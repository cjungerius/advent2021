function depth(input)
    sum(map(x-><(x...), zip(input,input[2:end])))
end

function windowdepth(input)
    input = map(x->+(x...), zip(input,input[2:end],input[3:end]))
    depth(input)
end

input = parse.(Int64,readlines("input.txt"))

depth(input)
windowdepth(input)