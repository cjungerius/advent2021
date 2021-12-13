
function preprocess(inputstr)
	input = readlines(inputstr)

	points = []
	instructions = []
	for line in input
		if length(line)>0 && line[1]=='f'
			push!(instructions,line)
		elseif length(line)>0
			push!(points,line)
		end
	end

	points = [parse.(Int,split(point,",")) for point in points]
	instructions = split.(instructions,"=")
	instructions = [[instruction[1][end],parse(Int,instruction[2])] for instruction in instructions]
	(points, instructions)
end


function fold!(points,instruction)
direction = instruction[1]=='x' ? 1 : 2
minpoint = minimum([point[direction] for point in points])
minpoint > 0 && (minpoint = 0)

foldline = instruction[2] + minpoint + 1

filter!(x->(x[direction]+1)!=foldline,points)

for point in points
	if point[direction]+1 > foldline
	point[direction] -= 2*abs(point[direction]+1 - foldline)
	end
	
end

unique!(points)
end

(points, instructions) = preprocess("input.txt")

fold!.(Ref(points),instructions)

image = fill(' ',(maximum([point[2] for point in points])+1,maximum([point[1] for point in points])+1))

for point in points
	image[point[2]+1,point[1]+1] = '#'
end

for i in 1:size(image)[1]
	println(join(image[i,:]))
end