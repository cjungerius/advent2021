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

input = readline("input.txt")
input = split(input,",")
input = parse.(Int,input)

one = partone(input)
two = parttwo(input)