using Statistics



function partone(input)
    #value where sum of absolute distance to all points is minimal is just the median
    xtilde = median(input)
    Int(sum(abs.(input.-xtilde)))
end


function parttwo(input)
    #since triangular error term has a quadratic, optimum is probably either the mean or close to the mean: since we're working with integers, let's look in the neighbourhood
    triangular = x->x*(x+1)/2
    target = round(mean(input))
    results = []
    for i in target-5:target+5
        result = triangular.(abs.(input.-i))
        push!(results,sum(result))
    end
    Int(minimum(results))
end

function parttwogeneral(input)
    #apparently the solution is not *guaranteed* to be near the mean (although it usually is), so to solve more generally:
    triangular = x->x*(x+1)/2
    results = []
    for i in minimum(input):maximum(input)
        result = triangular.(abs.(input.-i))
        push!(results,sum(result))
    end
    Int(minimum(results))
end

function parttwogradient(x)
    #since the loss function is convex we can find the optimal solution using gradient descent too, if we wanted!
    η = 0.001
    loss(x,a) = sum( ( abs.(x.-a).^2 .+ abs.(x.-a) ) / 2 )
    dloss(x,a) = sum((x.-a) .+ 1/2)

    a = rand(minimum(x):maximum(x))
    as = []
    dlosses = []

    for i in 1:1000
        a += η*dloss(x,a)
        push!(as,a)
        push!(dlosses, dloss(x,a))
    end
    a = round(a)
    loss(x,a)
end

input = readline("input.txt")
input = split(input,",")
input = parse.(Int,input)

example = readline("example.txt")
example = split(example,",")
example = parse.(Int,example)




one = partone(input)
two = parttwo(input)