input = readlines("input.txt")
algo = input[1]
algo = map(x->x=='#',collect(algo))

image = zeros(Int8,length(input[3:end]), length(input[3]))

for (i, line) in enumerate(input[3:end])
       image[i,:] = map(x->x=='#',collect(line)) 
end

function enhance(image, algo, n)

enhancements = 0



for i in 1:n
        surround = Int(algo[1] * n % 2)
        newimage = fill(surround,size(image).+2)
        newimage[2:end-1,2:end-1] = image
        image = copy(newimage)

        for i in 1:size(image)[1]-2, j in 1:size(image)[2]-2
                key = reshape(newimage[i:i+2,j:j+2],9)
                key = *(string.(key)...)
                newval = (parse(Int,key,base=2))
                image[i+1,j+1] = algo[newval+1]
        end

        
end

image
end

result = enhance(image, algo, 2)
