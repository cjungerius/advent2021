input = readlines("input.txt")
outputs = [split(line,"|")[2] for line in input]
outputs = [split.(line," ") for line in outputs]


outnumbers=vcat(outputs...)
partone = count(x-> length(x) == 2 || length(x) == 4 || length(x) == 3 || length(x) == 7, outnumbers)

