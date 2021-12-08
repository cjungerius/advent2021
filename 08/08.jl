sorting(seq) = join.(sort.(split.(seq,"")))
finddigits(A, l) = A[findall(x->length(x)==l,A)]
finduniquedigit(A, l) = finddigits(A,l)[1]
iscontainedby(str1,str2) = all([occursin(letter, str2) for letter in split(str1,"")])
invert(d) = Dict(value => key for (key, value) in d)
other(n) = filter(x->x!=n,[1,2])[1]

function decode(display)

	
	
	decoder = Dict( finduniquedigit.(Ref(display),[2 4 3 7]) .=> ["1" "4" "7" "8"] )
	encoder =invert(decoder)
	
	zerosixnine = finddigits(display,6)
	twothreefive = finddigits(display,5)
	
	decoder[zerosixnine[iscontainedby.(encoder["4"],zerosixnine)][1]] = "9"
	decoder[zerosixnine[.!iscontainedby.(encoder["1"],zerosixnine)][1]] = "6"
	decoder[zerosixnine[.!iscontainedby.(encoder["4"],zerosixnine) .* iscontainedby.(encoder["1"],zerosixnine)][1]] = "0"

	encoder = invert(decoder)

	decoder[twothreefive[.!iscontainedby.(twothreefive, encoder["9"])][1]] = "2"
	decoder[twothreefive[iscontainedby.(twothreefive,encoder["6"])][1]] = "5"
	decoder[twothreefive[.!iscontainedby.(twothreefive,encoder["6"]).*iscontainedby.(twothreefive, encoder["9"])][1]] = "3"
	
	decoder
end

function brutedecode(display)
	#alternative semi-brute force method
	cipher = Dict()
	decoder = Dict()
	plaintext = ["abcefg","cf","acdeg","acdfg","bcdf","abdfg","abdefg","acf","abcdefg","abcdfg"]
	one, four, seven, eight = finduniquedigit.(Ref(display),[2 4 3 7])
	groups = repeat([""],4)
	groups[1] = one
	groups[2] = filter(x->!(x in one), seven)
	groups[3] = filter(x->!(x in one), four)
	groups[4] = filter(x->!(x in four) && !(x in seven), eight)

	cipher[groups[2][1]] = 'a'

	for i in 1:2
		cipher[groups[1][i]] = 'c'
		cipher[groups[1][other(i)]] = 'f'

		for j in 1:2
			cipher[groups[3][j]] = 'b'
			cipher[groups[3][other(j)]] = 'd'

			for k in 1:2
				cipher[groups[4][k]] = 'e'
				cipher[groups[4][other(k)]] = 'g'

				decoded = join.([sort(get.(Ref(cipher),[c for c in d],0)) for d in display])
				
				if all([d in plaintext for d in decoded])

					for i in 1:length(plaintext)
						decoder[display[findall(x->x==plaintext[i],decoded)[1]]]  = i-1
					end
					return decoder
				end
			end
		end
	end

	groups
end

function convert(display, value; method="overlap")
	display = sorting(display)
	value = sorting(value)
	if method=="overlap"
		decoder = decode(display)
	elseif method=="brute"
		decoder = brutedecode(display)
	end
	join(get.(Ref(decoder),value,0))
end

input = readlines("input.txt")
input = split.(input," | ")

displays = split.([line[1] for line in input]," ")
values = split.([line[2] for line in input]," ")

outnumbers=vcat(values...)
partone = count(x-> length(x) == 2 || length(x) == 4 || length(x) == 3 || length(x) == 7, outnumbers)

translations = convert.(displays,values)
parttwo = sum(parse.(Int,translations))