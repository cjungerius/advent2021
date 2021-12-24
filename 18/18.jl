import JSON

function magnitude(a,b)
	if length(a) == 1 && length(b) == 1
		return 3*a+2*b
	elseif length(a) == 1
		return 3*a+2*magnitude(b...)
	elseif length(b) == 1
		return 3*magnitude(a...)+2*b
	else
		return 3*magnitude(a...)+2*magnitude(b...)
	end
end


function stringreduction(line)

	line = split(line,"")
	line = map(line) do i
		if isnumeric(i[1])
			return parse(Int,i)
		else
			return i
		end
	end
	
	previouslength = length(line)
	while true
		line = explode(line)
		if length(line) < previouslength
			previouslength = length(line)
			continue
		end
		line = splitting(line)
		if length(line)==previouslength
			break
		end
		previouslength=length(line)
	end

	join(line)
end

function explode(line)
	level = 0
	idx = 0
	levels = []
	idxs = []
	map(line) do i
		if i=="["
			level += 1
		elseif i=="]"
			level -= 1
		end

		idx += 1
	
		if typeof(i)==Int
			push!(levels,level)
			push!(idxs,idx)
		end
	end
	expindex = findfirst(x->x>=5,levels)
	if !isnothing(expindex)
		idxa = idxs[expindex]
		idxb = idxa+2
		a = line[idxa]
		b = line[idxb]
		expindex>1 && (line[idxs[expindex-1]] += a)
		expindex<(length(idxs)-1) && (line[idxs[expindex+2]] += b)
		line = vcat(line[1:idxa-2],[0],line[idxb+2:end])
	end
	line
end

function splitting(line)
	idxs = findall(x->typeof(x)==Int,line)
	for i in idxs
		if line[i] >=10
			a = floor(Int,line[i]/2)
			b = ceil(Int,line[i]/2)
			line = vcat(line[1:i-1],["["],[a],",",[b],"]",line[i+1:end])
			return line
		end
	end
	line
end

function homework(input)
	partone = reduce(input) do a, b
		stringreduction("["*a*","*b*"]")
	end

	magnitude(JSON.parse(partone)...)
end

function largest(input)
	currentmax = 0
	for i in 1:length(input)-1
		for j in i+1:length(input)
			combination = stringreduction("["*input[i]*","*input[j]*"]")
			newval = magnitude(JSON.parse(combination)...)
			currentmax = max(currentmax,newval)
		end
	end
	currentmax
end

input = readlines("input.txt")
partone = homework(input)
parttwo = max(largest(input),largest(reverse(input)))