# https://adventofcode.com/2019/day/22

file_path = "2019/data/day_22.txt"

function clean_input(f=file_path)
    out = []
    for line in readlines(f )
        if occursin("deal into new stack", line)
            push!(out, (Symbol("deal_into_new_stack"), 0))
        elseif occursin("cut", line)    
            push!(out, (Symbol("cut"), parse(Int, split(line, " ")[2])))
        elseif occursin("deal with increment", line)    
            push!(out, (Symbol("deal_with_increment"), parse(Int, split(line, " ")[4])))
        end
    end
    return out
end
@show clean_input()

deal_into_new_stack(deck) = reverse(deck)
function cut(deck, n) 
    if n == 0
        deck
    elseif n > 0
        return vcat(deck[n+1:end], deck[1:n])
    elseif n < 0
        return vcat(deck[end+n+1:end], deck[1:end+n])
    end
end

function deal_with_increment(deck, n)
    out = [0 for i in 1:length(deck)]
    times = 0
    i = 1
    while times < length(deck)
        out[i] = deck[times+1]
        times += 1
        i = mod1(i+n, length(deck))
    end
    return out
end
deck = 0:1:10006
@show deal_into_new_stack(deck)

function part_1(deck)
    for line in clean_input()
        if line[1] == :deal_into_new_stack
            deck = deal_into_new_stack(deck)
        elseif line[1] == :cut
            deck = cut(deck, line[2])
        elseif line[1] == :deal_with_increment
            deck = deal_with_increment(deck, line[2])
        end
    end
    return findfirst(x->x==2019, deck)-1
end
@show part_1(deck)


function part_2(deck)
    for line in clean_input()
        if line[1] == :deal_into_new_stack
            deck = deal_into_new_stack(deck)
        elseif line[1] == :cut
            deck = cut(deck, line[2])
        elseif line[1] == :deal_with_increment
            deck = deal_with_increment(deck, line[2])
        end
        println(deck[2020+1])
    end
    return deck[2020+1]
end

@show part_2(deck)
