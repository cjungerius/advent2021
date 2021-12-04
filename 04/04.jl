function bingo(input)

    sequence = parse.(Int,split(input[1],","))

    card = []
    cards = []
    winners = []

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
    
    waiting = Set([1:length(cards)...])
    cards = cat([hcat(card...) for card in cards]...,dims=3)
    called = zeros(Bool,size(cards))

    for val in sequence
        indices = findall(num->num==val,cards)
        called[indices] .= true


        for i in 1:size(called)[2]
            rowsums = [sum(called[:,i,j]) for j in 1:size(called)[3]]
            colsums = [sum(called[i,:,j]) for j in 1:size(called)[3]]

            winning = [findall(x->x==size(called)[2],rowsums)..., findall(x->x==size(called)[2],colsums)...] 

            for winner in winning
                if winner in waiting
                    pop!(waiting, winner)
                    push!(winners,val * sum(cards[:,:,winner] .* .!called[:,:,winner]))
                end

            end
        end
    end
    winners

end

input = readlines("input.txt")

winorder  = bingo(input)
partone = winorder[1]
parttwo = winorder[end]
