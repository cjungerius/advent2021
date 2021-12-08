input = readlines("input.txt")
input = split.(input," | ")

displays = split.([line[1] for line in input]," ")
values = split.([line[2] for line in input]," ")



sorting(seq) = join.(sort.(split.(seq,"")))
finddigits(A, l) = A[findall(x->length(x)==l,A)]
finduniquedigit(A, l) = finddigits(A,l)[1]
iscontainedby(str1,str2) = all([occursin(letter, str2) for letter in split(str1,"")])
invert(d) = Dict(value => key for (key, value) in d)

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

function convert(display, value)
	display = sorting(display)
	value = sorting(value)
	decoder = decode(display)
	join(get.(Ref(decoder),value,0))
end



translations = convert.(displays,values)
parttwo = sum(parse.(Int,translations))