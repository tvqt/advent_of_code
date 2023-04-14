# Day 14: Space Stoichiometry
# https://adventofcode.com/2019/day/14

file_path = "2019/data/day_14.txt"

function clean_input(file_path=file_path::String)::Dict
    out = Dict()
    for line in readlines(file_path)
        line = split(line, " => ") # split input and output
        reaction_input = split(line[1], ", ") # split input into vector of amounts and names
        reaction_input_cleaned = []
        for r in reaction_input # for each input, split into amount and name
            r = split(r, " ")
            push!(reaction_input_cleaned, (parse(Int, r[1]), r[2]))
        end
        reaction_output = split(line[2], " ") # split output into amount and name
        out[reaction_output[2]] = (parse(Int, reaction_output[1]), reaction_input_cleaned) # add to dict
    end
    return out # return dict
end

function reaction(target="FUEL", amount::Int=1, reactions::Dict=clean_input(), leftovers=Dict())::Int
    if target == "ORE" # if target is ore, return amount
        return amount
    elseif target in keys(leftovers) # if target is in leftovers, use leftovers
        if leftovers[target] >= amount
            leftovers[target] -= amount
            return 0
        else
            amount -= leftovers[target]
            leftovers[target] = 0
        end
    end
    reaction_amount, reaction_input = reactions[target] # get reaction amount and input
    reaction_count = ceil(Int, amount / reaction_amount) # the number of reactions needed; e.g. if we need 5 abc and each reaction produces 3, we need 2 reactions
    ore = 0
    for (amount, input) in reaction_input # for each input, calculate ore
        ore += reaction(input, amount * reaction_count, reactions, leftovers) # recursive call to reaction
    end
    leftovers[target] = reaction_count * reaction_amount - amount # add leftovers
    return ore
end
@show reaction()

function max_fuel(ore=1000000000000, reactions=clean_input())
    step = 100000000
    fuel = 1
    
    while !(reaction("FUEL", fuel) <= ore &&  reaction("FUEL", fuel + 1) > ore) # find the fuel amount where the reaction is less than ore and the next one is more
        if reaction("FUEL", fuel+ step) > ore  # if the reaction uses more ore than we have, divide the step by 2 and try again
            step = div(step, 2)
        else # if not, add step to fuel
            fuel += step
        end
    end
    return fuel # return fuel
end
@show max_fuel()