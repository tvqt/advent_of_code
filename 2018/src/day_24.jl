# Day 24: Immune System Simulator 20XX
# https://adventofcode.com/2018/day/24

file_path = "2018/data/day_24.txt"

function clean_input(f=file_path)::Vector{Vector{Any}}
    out = []
    current = "immune"

    for line in readlines(f)[2:end]
        if !isempty(line) && line[1:9] == "Infection"
            current = "infection" # flip from immune to infection
        elseif occursin('(', line)
            units, hp, buffs, attack_damage, attack_type, initiative = match(r"(\d+) units each with (\d+) hit points \(([\w,; ]+)\) with an attack that does (\d+) (\w+) damage at initiative (\d+)", line).captures
            buffs = split(buffs, "; ")
            clean_weaknesses = []
            for buff in buffs # the way buffs are stored is kinda a mess, hence this code
                buff_or_weakness, type_buff = split(buff, " to ")
                type_buff = split(type_buff, ", ")
                push!(clean_weaknesses, (buff_or_weakness, type_buff))
            end
            push!(out, [current, parse(Int, units), parse(Int, hp), clean_weaknesses, parse(Int, attack_damage), attack_type, parse(Int, initiative), parse(Int, units)* parse(Int, attack_damage)])
        elseif !isempty(line) # some lines don't have buffs, hence this
            units, hp, attack_damage, attack_type, initiative = match(r"(\d+) units each with (\d+) hit points with an attack that does (\d+) (\w+) damage at initiative (\d+)", line).captures
            push!(out, [current, parse(Int, units), parse(Int, hp), [], parse(Int, attack_damage), attack_type, parse(Int, initiative), parse(Int, units)* parse(Int, attack_damage)])
        end
    end
    return out
end

function target_selection(units::Vector{Vector{Any}}, order::Vector{Int})::Dict{Int, Int} # returns a dictionary of units with their targets, e.g. 1 => 2 means unit with initiative 1 targets unit with initiative 2
    remaining_targets = copy(units)
    unit_to_target = Dict()
    for initiative in order
        n = findfirst(x -> x[7] == initiative, units) # get the index of the unit with the current initiative
        damage = [(i, attack(units[n], target), target[8], target[7]) for (i, target) in enumerate(remaining_targets) if units[n][1] != target[1]] # get the damage dealt to each remaining target
        if isempty(damage) # if there are no remaining targets,
            continue
        end
        damage = sort(damage, by = x -> (x[2], x[3], x[4]), rev = true) # sort by damage dealt, then effective power, and then initiative
        if damage[1][2] == 0 # if the damage dealt is 0,
            continue
        end
        unit_to_target[initiative] = damage[1][4] # the unit's initiative => the target's initiative
        deleteat!(remaining_targets, damage[1][1]) # remove the target from the list of remaining targets
    end
    return unit_to_target
end

function attack(unit, target)
    damage = unit[8] # effective power
    if !isempty(target[4])
        for buff in target[4]
            if buff[1] == "weak"
                if unit[6] in buff[2] # if the attack type is in the list of weaknesses, then double damage
                    damage *= 2 
                end
            elseif buff[1] == "immune"
                if unit[6] in buff[2] # if the attack type is in the list of immunities, then no damage
                    damage = 0
                end
            end
        end
    end
    return damage
end

function attack_all(units::Vector{Vector{Any}}, attacks::Dict{Int, Int}, order::Vector{Int})::Tuple{Vector{Vector{Any}}, String} # returns the units after the attack and the status of the battle
    infection_kills = 0
    immune_kills = 0
    for initiative in order
        if initiative in keys(attacks)
            n = findfirst(x -> x[7] == initiative, units)
            if n !== nothing
                target = findfirst(x -> x[7] == attacks[initiative], units)
                units_killed = min(convert(Int, floor(attack(units[n], units[target]) / units[target][3])), units[target][2])
                if units[n][1] == "immune"
                    immune_kills += units_killed
                else
                    infection_kills += units_killed
                end
                #println("$(units[n][1]) unit with initiative $initiative attacks unit with initiative $(units[target][7]), killing $units_killed units")
                units[target][2] -= units_killed
                if units[target][2] <= 0
                    deleteat!(units, target)          
                else
                    units[target][8] = units[target][2] * units[target][5]
                end
            end
        end
    end
    if infection_kills == 0 && immune_kills == 0 # if no units were killed,
        status = "stalemate"
    elseif infection_kills == 0 # if only immune units were killed,
        status = "immune winning"
    elseif immune_kills == 0 # if only infection units were killed,
        status = "infection winning"
    else # if both were killed,
        status = "inconclusive"
    end
    return units, status
end

function battle(units::Vector{Vector{Any}})::Tuple{Vector{Vector{Any}}, String} # returns the units after the battle and the status of the battle
    # sort by effective power, then initiative
    order = [x[7] for x in sort(units, by = x -> (x[8], x[7]), rev = true)]
    # every unit picks a target (they cannot pick the same target)
    attacks = target_selection(units, order)
    # sort units by initiative
    order = sort([x[7] for x in units], rev = true)
    # every unit attacks
    return attack_all(units, attacks, order)
end

function part1(units::Vector{Vector{Any}}, part2::Bool=false, boost::Int=0) # returns the number of units remaining after the battle, or if part2 is true, the winner and the number of units remaining
    if part2
        for i in eachindex(units) # add the boost to the immune system's attack damage
            if units[i][1] == "immune"
                units[i][5] += boost
                units[i][8] = units[i][2] * units[i][5]
            end
        end
    end

    while true
        units, status = battle(units) # run the battle

        if length(unique([x[1] for x in units])) == 1 # if there is only one type of unit left,
            return part2 ? (units[1][1], sum([x[2] for x in units])) : sum([x[2] for x in units])
        elseif status == "stalemate" # if no units were killed,
            return part2 ? ("infection", sum([x[2] for x in units])) : sum([x[2] for x in units])
        elseif status == "infection winning" && count(x -> x[1] == "immune", units) == 1 # if there is only one immune unit left, and the immune system is winning, then the infection will always win  
            return part2 ? ("infection", sum([x[2] for x in units if x[1] == "infection"])) : sum([x[2] for x in units if x[1] == "infection"])
        elseif status == "immune winning" && count(x -> x[1] == "infection", units) == 1 # if there is only one infection unit left, and the immune system is winning, then the immune system will always win
            return part2 ? ("immune", sum([x[2] for x in units if x[1] == "immune"])) : sum([x[2] for x in units if x[1] == "immune"])
        end
    end
end

function part_2(units)
    boost = 1 # start with a boost of 1
    while true
        println("Boost: $boost")
        winner, units_left = part1(deepcopy(units), true, boost) # run the battle with the boost
        if winner == "immune"
            return units_left
        end
        boost += 1
    end
end
input = clean_input()
@show part1(deepcopy(input))
@show part_2(input)