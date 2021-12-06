function fishcount(input,cycles)

    input = parse.(Int,split(input,","))
    state = zeros(Int,9)
    next = zeros(Int,9)

    #initialize state
    for i in 1:9
        state[i] = count(x->x==i-1,input)
    end

    #perform updates
    for i in 1:cycles

        next[end] = state[1]
        for i in 1:8
            next[i] = state[i+1]  
            if i==7
                next[i] += state[1]
            end      
        end
        
        state = copy(next)
    end

state
end

input = readline("input.txt")
partone = fishcount(input,80)
parttwo = fishcount(input,256)
