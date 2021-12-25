input = readlines("input.txt")
input = split.(input,"")

function cucumbers!(input)

	rightmoves = Set([])
	downmoves = Set([])
	for i in 1:length(input)
		for j in 1:length(input[i])
			if input[i][j]==">"	
				j==length(input[i]) ? next = 1 : next = j + 1
				input[i][next]=="." && push!(rightmoves,(i,j,next))
			end
		end
	end

	for (i,j,next) in rightmoves
		input[i][next], input[i][j] = input[i][j], input[i][next]
	end

	for i in 1:length(input)
		for j in 1:length(input[i])
			if input[i][j]=="v"	
				i==length(input) ? next = 1 : next = i + 1
				if input[next][j]=="."
					push!(downmoves,(i,j,next))
				end
			end
		end
	end

	for (i,j,next) in downmoves
		input[next][j], input[i][j] = input[i][j], input[next][j]
	end
	length(rightmoves)==0 && length(downmoves)==0
end


function cyclestillstop(input)
	i=1
	while !cucumbers!(input)
		i+=1
	end
	i
end

result = cyclestillstop(input)