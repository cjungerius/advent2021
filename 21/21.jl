using Memoize 

function turn(die, player)

    for i in 1:3
        player += die
        die+=1
        die > 100 ? die -= 100 : die
    end

    player = mod1(player,10)

    (die, player)
end 


function deterministic(a,b)
    die = 1
    rolls = 0
    sa = 0
    sb = 0
    while !(sa >= 1000) && !(sb > 1000)
        
        die, a = turn(die, a)
        sa += a
        rolls += 3
        if sa >= 1000
            break
        end

        die, b = turn(die, b)
        sb += b
        rolls += 3
        if sb >= 1000
            break
        end

    end
    min(sa, sb) * rolls
end



@memoize function diracdice(a,sa, b, sb, turn)
    if sa >= 21
        return 1
    elseif sb >= 21
        return 0

    else
        universes = vec([a+b+c for a in 1:3, b in 1:3, c in 1:3])
        if turn == 0
            new_a = mod1.(a.+universes,10)
            new_sa = sa.+new_a

            return sum([diracdice(x,y,b,sb,1) for (x,y) in zip(new_a,new_sa)])
        elseif turn == 1
            new_b = mod1.(b.+universes,10)
            new_sb = sb.+new_b
            return sum([diracdice(a,sa,x,y,0) for (x,y) in zip(new_b,new_sb)])
        end
    end
end