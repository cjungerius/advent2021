
function turn(die, player)

    for i in 1:3
        player += die
        die+=1
        die > 100 ? die -= 100 : die
    end

    player%10 == 0 ? player = 10 : player = player%10

    (die, player)
end 


function diracdice(a,b)
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


