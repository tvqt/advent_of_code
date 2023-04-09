# Day 22: Crab Combat
# https://adventofcode.com/2020/day/22


player_1_path = "2020/data/day_22_1.txt"
player_2_path = "2020/data/day_22_2.txt"

player_1 = [parse(Int, x) for x in readlines(player_1_path)]
player_2 = [parse(Int, x) for x in readlines(player_2_path)]

function crab_combat(part1=true, player_1=player_1, player_2=player_2)
    history = []
    p1, p2 = copy(player_1), copy(player_2)
    
    while length(p1) > 0 && length(p2) > 0  
        if (p1, p2) in history && !part1 # if the current state is in the history, player 1 wins
            return p1
        end
        push!(history, (copy(p1), copy(p2))) # add the current state to the history
        card_1, card_2 = popfirst!(p1), popfirst!(p2) # draw cards
        round!(card_1, card_2, p1, p2, part1) # play the round
    end
    return p1,  p2
end

function round!(card_1, card_2, player_1, player_2, part1=true)
    if !part1 && length(player_1) >= card_1 && length(player_2) >= card_2 # if it's part 2 and both players have enough cards to recurse
        length(crab_combat(false, player_1[1:card_1], player_2[1:card_2])[1]) != 0 ? append!(player_1, [card_1, card_2]) : append!(player_2, [card_2, card_1]) # if player 1 wins the recursive game, player 1 wins the round
    else
        card_1 > card_2 ? append!(player_1, [card_1, card_2]) : append!(player_2, [card_2, card_1]) # if it's part 1 or player 1 doesn't have enough cards to recurse, play the round as normal
    end
end

score(player_1, player_2) = sum([x * y for (x, y) in zip(player_1, reverse(1:length(player_1)))])

@show score(crab_combat()...)
@show score(crab_combat(false)...)