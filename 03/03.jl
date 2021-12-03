
function fuelcodes(input)
    epsilon = ""
    theta = ""
    for i in 1:length(input[1])
        value = count(x->x[i]=='1',input) > length(input)/2
        epsilon *= string(Int(value))
        theta *= string(Int(!value))
    end
parse(Int,epsilon,base=2)*parse(Int,theta,base=2)
end

function lifesupportcodes(input)

    o2codes = copy(input)
    o2 = ""
    for i in 1:length(o2codes[1])
        value = Int(count(x->x[i]=='1',o2codes) >= length(o2codes)/2)
        filter!(x->parse(Int,x[i])==value,o2codes)
        if length(o2codes)==1
            o2 = o2codes[1]
            break
        end
    end

    co2codes = copy(input)
    co2 = ""
    for i in 1:length(co2codes[1])
        value = Int(count(x->x[i]=='1',co2codes) < length(co2codes)/2)
        filter!(x->parse(Int,x[i])==value,co2codes)
        if length(co2codes)==1
            co2 = co2codes[1]
            break
        end
    end
   
    parse(Int,o2,base=2)*parse(Int,co2,base=2)
end



input = readlines("input.txt")
fuelcodes(input)
lifesupportcodes(input)

