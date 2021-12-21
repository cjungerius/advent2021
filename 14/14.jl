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

function polymatrix(chain, chaindict, n=1)
	polyboth(pair) = [pair[1] * chaindict[pair], chaindict[pair] * pair[2]]
	lastchar = string(chain[end])

	idxdict = Dict(key=> i for (i, key) in enumerate(keys(chaindict)))
	lettercountdict = Dict(idxdict[key]=>string(key[1]) for key in keys(idxdict))
	outputdict = Dict(letter => 0 for letter in unique(values(chaindict)))

	input = zeros(Int,length(keys(chaindict)))

	for pair in zip(chain,chain[2:end])
		input[idxdict[join(pair)]] += 1
	end

	adjmat = zeros(Int,length(keys(chaindict)),length(keys(chaindict)))

	for key in keys(idxdict)
		result = polyboth(key)
		adjmat[idxdict[result[1]],idxdict[key]] = 1
		adjmat[idxdict[result[2]],idxdict[key]] = 1
	end
	adjmat = adjmat^n
	output = adjmat*input

	[outputdict[lettercountdict[i]] += output[i] for i in 1:length(output)]
	outputdict[lastchar] += 1
	outputdict
end

chain, chaindict = preprocess("input.txt")

naivesolution = polynaive(chain,10)
dictsolution = polydict(chain,chaindict,10)
matsolution = polymatrix(chain,chaindict,10)

#confirm that the dictsolution finds the same answers
println(sort(collect(values(countmap(naivesolution)))) == sort(collect(values(dictsolution))) == sort(collect(values(matsolution))))

partone = maximum(values(dictsolution)) - minimum(values(dictsolution))
dictsolution = polydict(chain,chaindict,40)

parttwo = maximum(values(dictsolution)) - minimum(values(dictsolution))