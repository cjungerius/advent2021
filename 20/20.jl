input = readlines("input.txt")
algo = input[1]
algo = map(x->x=='#',collect(algo))

image = zeros(Int8,length(input[3:end]), length(input[3]))

for (i, line) in enumerate(input[3:end])
       image[i,:] = map(x->x=='#',collect(line)) 
end

function enhance(image, algo, n)

for i in 1:n
        oldsurround = Int(algo[1] * (i+1) % 2)
        newimage = fill(oldsurround,size(image).+4)
        newimage[3:end-2,3:end-2] = image
        image = deepcopy(newimage)

        for i in 1:size(image)[1]-2, j in 1:size(image)[2]-2
                key = reshape(transpose(newimage[i:i+2,j:j+2]),9)
                key = *(string.(key)...)
                newval = (parse(Int,key,base=2))
                image[i+1,j+1] = algo[newval+1]
        end

        newsurround = Int(algo[1] * (i) % 2)
        image[1:end,1] .= newsurround
        image[1:end,end] .= newsurround
        image[1,1:end] .= newsurround
        image[end,1:end] .= newsurround

end

image
end

result = enhance(image, algo, 50)
