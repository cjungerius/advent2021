using DelimitedFiles

function preprocess(filestr)
	input = readdlm(filestr,',')
	scanners = []
	start = 2
	for line in 2:size(input)[1]
		if typeof(input[line,1]) != Int
			push!(scanners,input[start:line-1,:])
			start = line+1
		end
	end
	push!(scanners,input[start:end,:])
	scanners
end

function probedistances(input)
	s = size(input)[1]
	distances = zeros((s,s))
	for i in 1:s, j in 1:s
		distances[i,j] = sqrt(sum((input[i,:] .- input[j,:]).^2))
	end
	distances
end

function distancematches(scannera,scannerb)
	for a in 1:size(scannera)[1]
		for b in 1:size(scannerb)[1]
			temp = map(enumerate(scannera[a,:])) do distance
				distance[1], findnext(x->x==distance[2],scannerb[b,:],1)
			end
			filter!(x->!isnothing(x[2]),temp)
			length(temp) >= 12 && return temp
		end
	end
end

function findscannerorder(current, scanners, added)

	orders = []
	rotations = []
	translations = []
	matches = []

	target = current
		for i in 1:size(scanners)[1]
			i in added && continue
			todo = scanners[i]
			pairs = distancematches(probedistances(target),probedistances(todo))
			isnothing(pairs) && continue
			targetcoords = target[pairs[1][1],:].-target[pairs[2][1],:]
			todocoords = todo[pairs[1][2],:].-todo[pairs[2][2],:]
			order = sortperm(todocoords,by=x->findnext(y->abs(y)==abs(x),targetcoords,1))
			rotation = sign.(targetcoords .* todocoords[order])
			translation = target[pairs[1][1],:] .- rotation.*todo[pairs[1][2],order]

			push!(orders,order)
			push!(rotations,rotation)
			push!(translations, translation)
			push!(matches,i)
		end
	(matches,orders,rotations,translations)
end

example = preprocess("example.txt")
input = preprocess("input.txt")

function findbeacons(input)
	beacons = deepcopy(input[1])
	scanners = [[0,0,0]]
	seen = Set([input[1][i,:] for i in 1:size(input[1])[1]])
	visited = Set([1])
	searchidx = 1

	while length(visited)<length(input)
		println(searchidx)
		matches, orders, rotations, translations = findscannerorder(beacons[searchidx:end,:],input,visited)
		searchidx = size(beacons)[1]
		println(matches)
		for (i,m) in enumerate(matches)
			(m in visited) && continue
			push!(visited,m)
			push!(scanners,translations[i])
			for b in 1:size(input[m])[1]
				beacon = rotations[i].*input[m][b,orders[i]].+translations[i]
				if !(beacon in seen)
					push!(seen,beacon)
					beacons = vcat(beacons,reshape(beacon,(1,3)))
				end
			end
		end
	end
	(scanners,seen)
end

scanners, beacons = findbeacons(input)

biggestdist = 0
for i in scanners, j in scanners
	i==j && continue
	biggestdist = max(biggestdist,sum(abs.(i.-j)))
end

partone = length(beacons)
parttwo = biggestdist
