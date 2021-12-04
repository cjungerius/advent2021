using Base: Bool



function bingo(input)

    sequence = parse.(Int,split(input[1],","))

    card = []
    cards = []

    for i in 3:length(input)
        if input[i] != ""
            line = parse.(Int,split(input[i]))
            push!(card,line)
        else
            push!(cards,card)
            card=[]
        end
    end
    push!(cards,card)
    
    cards = cat([hcat(card...) for card in cards]...,dims=3)
    called = zeros(Bool,size(cards))

    for val in sequence
        indices = findall(num->num==val,cards)
        called[indices] .= true


        for i in 1:size(called)[2]
            rowsums = [sum(called[:,i,j]) for j in 1:size(called)[3]]
            colsums = [sum(called[i,:,j]) for j in 1:size(called)[3]]

            if any(x-> x==size(called)[2],rowsums)
                winning = argmax(rowsums)
                return (val * sum(cards[:,:,winning] .* .!called[:,:,winning]))
            elseif any(x->x==size(called)[2],colsums)
                winning = argmax(colsums)
                return (val * sum(cards[:,:,winning] .* .!called[:,:,winning]))
            end
        end
    end
    cards

end

function bingolast(input)

    sequence = parse.(Int,split(input[1],","))

    card = []
    cards = []

    for i in 3:length(input)
        if input[i] != ""
            line = parse.(Int,split(input[i]))
            push!(card,line)
        else
            push!(cards,card)
            card=[]
        end
    end
    push!(cards,card)
    
    losers = [1:length(cards)...]
    cards = cat([hcat(card...) for card in cards]...,dims=3)
    called = zeros(Bool,size(cards))

    for val in sequence
        indices = findall(num->num==val,cards)
        called[indices] .= true


        for i in 1:size(called)[2]
            rowsums = [sum(called[:,i,j]) for j in 1:size(called)[3]]
            colsums = [sum(called[i,:,j]) for j in 1:size(called)[3]]

            winning = [findall(x->x==size(called)[2],rowsums)..., findall(x->x==size(called)[2],colsums)...] 
            if length(losers) != 1
                filter!(x->!(x in winning), losers)
            elseif length(losers) == 1 && losers[1] in winning
                loser = losers[1]
                return val * sum(cards[:,:,loser] .* .!called[:,:,loser])
            end
        end
    end
    cards

end

input = readlines("input.txt")
bingo(input)
bingolast(input)