function bingo(input)

    sequence = parse.(Int,split(input[1],","))

    card = []
    cards = []
    winvals = []

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
    
    waiting = [1:length(cards)...]
    cards = cat([hcat(card...) for card in cards]...,dims=3)
    called = zeros(Bool,size(cards))

    for val in sequence
        indices = findall(num->num==val,cards)
        called[indices] .= true


        for i in 1:size(called)[2]

            rowsums = [sum(called[:,i,j]) for j in waiting]
            colsums = [sum(called[i,:,j]) for j in waiting]

            winning = Set([findall(x->x==size(called)[2],rowsums)..., findall(x->x==size(called)[2],colsums)...])
            winning = [waiting[loc] for loc in winning]

            for winner in winning
               filter!(x->x!=winner, waiting)
               push!(winvals,val * sum(cards[:,:,winner] .* .!called[:,:,winner]))                
            end
            
        end
    end
    winvals
end

input = readlines("input.txt")

winvals  = bingo(input)
partone = winvals[1]
parttwo = winvals[end]
