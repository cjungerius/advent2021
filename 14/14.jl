using StatsBase

function preprocess(inputstr)
	input = readlines(inputstr)
	chain = input[1]
	insertions = input[3:end]
	insertions = split.(insertions, " -> ")
	chaindict = Dict([a => b for (a, b) in insertions])
	(chain, chaindict)
end


function polychain(chain)
	polymerize(pair) = chaindict[pair] * pair[2]
	newchain = chain[1]
	for i in zip(chain, chain[2:end])
		newchain *= polymerize(join(i))
	end
	newchain
end


function polynaive(chain, n)
	for i in 1:n
		chain = polychain(chain)
	end
	chain
end


function polydict(chain, chaindict, n=1)
	polyboth(pair) = [pair[1] * chaindict[pair], chaindict[pair] * pair[2]]
	lettercount = Dict(letter => 0 for letter in unique(values(chaindict)))
	paircount = Dict(key => 0 for key in keys(chaindict))
	for letter in chain
		lettercount[string(letter)] += 1
	end

	for pair in zip(chain, chain[2:end])
		paircount[join(pair)] += 1
	end

	for i in 1:n
	newpaircount = copy(paircount)
		for key in keys(paircount)
			lettercount[chaindict[key]] += paircount[key]
			newpairs = polyboth(key)
			newpaircount[key] -= paircount[key]
			newpaircount[newpairs[1]] += paircount[key]
			newpaircount[newpairs[2]] += paircount[key]
		end
		paircount = copy(newpaircount)
	
    end
	lettercount
end

chain, chaindict = preprocess("input.txt")

naivesolution = polynaive(chain,10)
dictsolution = polydict(chain,chaindict,10)

#confirm that the dictsolution finds the same answers
println(sort(collect(values(countmap(naivesolution)))) == sort(collect(values(dictsolution))))


partone = maximum(values(dictsolution)) - minimum(values(dictsolution))
dictsolution = polydict(chain,chaindict,40)
parttwo = maximum(values(dictsolution)) - minimum(values(dictsolution))