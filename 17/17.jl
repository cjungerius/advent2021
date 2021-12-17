
function findroots(a,b,c)
	#didnt really end up using this haha
	roots = Array{Float64}(undef,0)
	D = b^2-4*a*c
	D < 0 && (return roots)
	push!(roots, (-b-sqrt(D))/(2*a))
	push!(roots, (-b+sqrt(D))/(2*a))
	unique(roots)
end 


sx(n,v) = n > v ? v*(v+1)/2 : n*v - n*(n-1)/2
sy(n,v) = n*v - n*(n-1)/2
loc(n,vx,vy) = (sx(n,vx), sy(n,vy) )


function partone(a,b)
	peaks = []
	for vy in a:-a
		for steps in 1:1000
			a <= sy(steps,vy) <= b && push!(peaks,maximum(sy.(1:steps,vy)))
		end
	end
maximum(peaks)
end

function parttwo(xa,xb,ya,yb)
	candidates = []
	for vy in ya:-ya
		for steps in 1:1000
			ya <= sy(steps,vy) <= yb && push!(candidates,(vy,steps))
		end
	end

	xlb = floor(filter(x-> x>0, findroots(0.5,0.5,-xa))[1])

	pairs = Set([])
	for candidate in candidates
		for xv in xlb:xb
			xa<=sx(candidate[2],xv)<=xb && push!(pairs,(xv,candidate[1]))
		end
	end
	length(pairs)
end

input = readline("input.txt")

xa, xb, ya, yb = map((eachmatch(r"-?[0-9]+",input))) do m
	parse(Int,m.match)
end

partone(ya,yb)
parttwo(xa,xb,ya,yb)
