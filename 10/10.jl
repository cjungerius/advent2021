function chunk(line)
    startchars = ["(" ,"[", "{" ,"<"]
    stopchars = [")", "]", "}", ">"]
    points = [3  57  1197 25137]
    score = 0
    started = []
    for i in line
        if i in startchars
            push!(started,findall(x->x==i, startchars)[1])

        elseif i in stopchars
            if started[end] != findall(x->x==i, stopchars)[1]
                score += points[findall(x->x==i, stopchars)[1]]
                break
            end
            pop!(started)
        end
    end
    (score, started)
end

function close(line)
    score = 0
    (corrupted, unfinished) = chunk(line)
    if corrupted == 0
        for i in 1:length(unfinished)
            score *= 5
            score += pop!(unfinished)
        end
    end
    score
end

input = readlines("input.txt")
example = readlines("example.txt")

input = split.(input,"")
example = split.(example,"")

chunks = chunk.(input)
partone = sum([x[1] for x in chunks])
sortedscores = sort!(filter!(x->x>0,close.(input)))
parttwo = sortedscores[length(sortedscores)÷2+1]
