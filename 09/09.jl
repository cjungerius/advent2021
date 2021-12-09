function islowest(input,y,x)
	point = input[y,x]
	neighbours = [(y-1,x),(y+1,x),(y,x-1),(y,x+1)]
	for (a,b) in neighbours
		if 0 < a <= size(input)[1] && 0 < b <= size(input)[2]
			point < input[a,b] || return false
		end
	end
	return true	
end

function partone(input)
	input = split.(input,"")
	input = [parse.(Int, line) for line in input]
	input = hcat(input...)

	lowpoints = zeros(Bool,size(input))
	for i in 1:size(input)[1]
		for j in 1:size(input)[2]
			lowpoints[i,j] = islowest(input,i,j)
		end
	end

	sum(input[lowpoints]) + length(input[lowpoints])
end

input = readlines("input.txt")
output = partone(input)
