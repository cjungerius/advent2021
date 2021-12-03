
function fuelcodes(input)
    input = split.(input,"")
    code = zeros(Int,length(input),length(input[1]))
    for i in 1:length(input)
        code[i,:] = parse.(Int,input[i])
    end


    epsilon=""
    theta=""
    for i in 1:length(code[1,:])
        numbers = code[:,i]
        value = sum(numbers) > length(code[:,1])/2
        epsilon *= string(Int(value))
        theta *= string(Int(!value))
    end
(parse(Int,theta,base=2), parse(Int,epsilon,base=2))
end

function lifesupportcodes(input)


    o2 = codefilter(input, epsilon)
    co2 = codefilter(input, theta)
    (o2, co2)
end

function codefilter(input,template)
    template = string(template)
    for i in length(template)
        if length(input) == 1
            return input[1]
        else
            filter!(x->x[i]==template[i],input)
        end
    end
end

input = readlines("input.txt")
fuelcodes(input)

