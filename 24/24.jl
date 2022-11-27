using Base.Iterators

#we barely used the alu program haha

monad = readlines("input.txt")

function alu(program,input=[],z=0)
	
	m = Dict(["w"=>0,"x"=>0,"y"=>0,"z"=>z])
	for (idx, line) in enumerate(program)
		line = split(line," ")
		if line[1]=="inp"
			if length(input)==0
				println("please provide input at line ",idx)
				m[line[2]] = parse(Int,readline())
			else
				m[line[2]] = popfirst!(input)
			end
		elseif line[1]=="add"
			m[line[2]] += isnumeric(line[3][end]) ? parse(Int,line[3]) : get(m,line[3],0)
		elseif line[1]=="mul"
			m[line[2]] *= isnumeric(line[3][end]) ? parse(Int,line[3]) : get(m,line[3],0)
		elseif line[1]=="div"
			m[line[2]] ÷= isnumeric(line[3][end]) ? parse(Int,line[3]) : get(m,line[3],0)
		elseif line[1]=="mod"
			m[line[2]] %= isnumeric(line[3][end]) ? parse(Int,line[3]) : get(m,line[3],0)
		elseif line[1]=="eql"
			m[line[2]] = Int(m[line[2]] == (isnumeric(line[3][end]) ? parse(Int,line[3]) : get(m,line[3],0)))
		end
	end
	m
end

#upon inspection the monad program consists of 14 subprograms
input = readlines("input.txt")
programs = [[], [], [], [], [], [], [], [], [], [], [], [], [], []]
idx = 0
for line in input
	if line=="inp w"
		idx +=1
		println("next program!")
	end
	push!(programs[idx],line)
end

#upon FURTHER inspection, every program has the following form

operators = [
	[1,13,8],
	[1,12,13],
	[1,12,8],
	[1,10,10],
	[26,-11,12],	#can avoid multiplication
	[26,-13,1],	#
	[1,15,13],
	[1,10,5],
	[26,-2,10],	#
	[26,-6,3],	#
	[1,14,2],	
	[26,0,2],	#
	[26,-15,12],	#
	[26,-4,7]	#
]

function monadstep(w,z,operators)
	x = z%26
	z ÷= operators[1]
	x += operators[2]
	if operators[1]==26 && x!=w #if multiplication can be avoided but isnt: error
		return -1
	end
	if x!=w
		z*=26
		z+=w+operators[3]
	end
	z
end


#now we have a solution to step through, how to iterate through candidates?

function nextcandidatelow!(candidate, idx)
	for i in idx:-1:1
		if candidate[i] < 9
			candidate[i] += 1
			break
		else
			candidate[i] = 1		
		end
	end
end


function nextcandidatehigh!(candidate, idx)
	for i in idx:-1:1
		if candidate[i] > 1
			candidate[i] -= 1
			break
		else
			candidate[i] = 9		
		end
	end
end	

#function that steps through program, if error: next candidate
function stepthroughmonad(candidate,lowest=false)
	z = 0
	for (idx, operator) in enumerate(operators)
		z = monadstep(candidate[idx],z,operator)
		if z==-1
			lowest ? nextcandidatelow!(candidate,idx) : nextcandidatehigh!(candidate,idx)
			return z
		end
	end
	z
end

#let's search for numbers!

function findcandidate(lowest=false)
lowest ? candidate = "11111111111111" : candidate = "99999999999999"
candidate = parse.(Int,split(candidate,""))

	while true
		if stepthroughmonad(candidate, lowest)==-1
			continue
		end
		return candidate
	end
end

partone = findcandidate()
parttwo = findcandidate(true)
alu(monad,partone)["z"] == alu(monad,parttwo)["z"] == 0 && println("success!")
