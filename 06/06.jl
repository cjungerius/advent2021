function fishcount(input,cycles)

    input = parse.(Int,split(input,","))
    state = zeros(Int,9)
    
    #initialize state
    for i in 1:9
        state[i] = count(x->x==i-1,input)
    end

    #perform updates
    for i in 1:cycles

        state = circshift(state,-1)
        state[7] += state[end]

    end

state
end

input = readline("input.txt")
partone = fishcount(input,80)
parttwo = fishcount(input,256)
