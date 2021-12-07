using Statistics

input = readline("input.txt")
input = split(input,",")
input = parse.(Int,input)
xtilde = median(input)

partone = sum(abs.(input.-xtilde))
