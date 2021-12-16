input = readline("input.txt")

function preprocess(input)
    b = ""
    for i in input
        b *= bitstring(parse(Int,i,base=16))[end-3:end]
    end
    b
end

function parsepacket(packet)

    operators = Dict([
        "000" => +,
        "001" => *,
        "010" => min,
        "011" => max,
        "101" => >,
        "110" => <,
        "111" => isequal,
    ])

    version = packet[1:3]
    version = parse(Int,version,base=2)
    type = packet[4:6]

    if type=="100"
        value = ""
        readlength = 6
        content = packet[7:end]
        position = 1
        while true
            value *= content[position+1:position+4]
            if content[position]=='0'
                break
            end
            position += 5
        end
        readlength += position+4
        value = parse(Int,value,base=2)

    else
        subvals = []
        lengthtype = packet[7]
        if lengthtype == '0'
            readlength = 22
            subpacketbitlength = parse(Int,packet[8:22],base=2)
            content = packet[23:23+subpacketbitlength]
            readlength += subpacketbitlength
            while subpacketbitlength > 0
                v, subval, l = parsepacket(content)
                version += v
                push!(subvals,subval)
                content = content[l+1:end]
                subpacketbitlength -= l
            end
    
        elseif lengthtype == '1'
            readlength = 18
            subpacketnumber = parse(Int,packet[8:18], base=2)
            content = packet[19:end]
            while subpacketnumber > 0
                v, subval, l = parsepacket(content)
                push!(subvals,subval)
                version += v
                readlength += l
                content = content[l+1:end]
                subpacketnumber -= 1
            end
        end
        operator = operators[type]

        value = Int(operator(subvals...))

    end
    
    if value == ""
        value = "0"
    end
    (version, value, readlength)
end

partone, parttwo, _ = parsepacket(preprocess(input))


