# Day 22: Wizard Simulator 20XX
# https://adventofcode.com/2015/day/22

using Combinatorics

my_stats = Dict("hp" => 50, "mana" => 500, "Shield" => 0, "mana_spent" => 0)
boss_stats = Dict("hp" => 55, "damage" => 8)

spells = Dict("Magic Missile" => Dict("cost" => 53, "damage" => 4, "heal" => 0, "Shield" => 0, "mana" => 0, "turns" => 0),
    "Drain" => Dict("cost" => 73, "damage" => 2, "heal" => 2, "Shield" => 0, "mana" => 0, "turns" => 0),
    "Shield" => Dict("cost" => 113, "damage" => 0, "heal" => 0, "Shield" => 7, "mana" => 0, "turns" => 6),
    "Poison" => Dict("cost" => 173, "damage" => 3, "heal" => 0, "Shield" => 0, "mana" => 0, "turns" => 6),
    "Recharge" => Dict("cost" => 229, "damage" => 0, "heal" => 0, "Shield" => 0, "mana" => 101, "turns" => 5))

cooldowns = Dict("Shield" => 0, "Poison" => 0, "Recharge" => 0)



function round(my_stats, boss_stats, spell, spell_dict, cooldowns, part=1)
    if part == 2 # hard mode
        my_stats["hp"] -=1 # player takes 1 damage
        if my_stats["hp"] <=0 # if player is dead,
            return false # return false
        end
    end

    # player turn
    # 1. apply status effects
    my_stats, boss_stats, cooldowns = status_effects(my_stats, boss_stats, cooldowns)
    # 2. check if boss is dead
    if boss_stats["hp"] <= 0
        return true, my_stats["mana_spent"]
    end
    # 3. cast spell
    my_stats, boss_stats, cooldowns = spellcast(spell, spell_dict, my_stats, boss_stats, cooldowns)
    # 4. check if boss is dead
    if boss_stats["hp"] <= 0 
        return true, my_stats["mana_spent"]
    end
    # boss turn
    # 1. status effects
    my_stats, boss_stats, cooldowns = status_effects(my_stats, boss_stats, cooldowns)
    # boss damage is at least 1
    boss_damage = max(1, boss_stats["damage"] - my_stats["Shield"])
    # player takes damage
    my_stats["hp"] -= boss_damage
    # if hp has run out, return false
    if my_stats["hp"] <= 0
        return false
    end
    return my_stats, boss_stats, cooldowns
end

function spellcast(spell, spell_dict, my_stats, boss_stats, cooldowns)
    if spell == "Magic Missile"
        boss_stats["hp"] -= spell_dict["damage"] # apply damage
        my_stats["mana"] -= spell_dict["cost"] # apply mana cost
    elseif spell == "Drain"
        boss_stats["hp"] -= spell_dict["damage"] # apply damage
        my_stats["mana"] -= spell_dict["cost"] # apply mana cost
        my_stats["hp"] += spell_dict["heal"] # apply heal
    elseif spell == "Shield"
        cooldowns["Shield"] = spell_dict["turns"] # apply cooldown
        my_stats["mana"] -= spell_dict["cost"]  # apply mana cost
    elseif spell == "Poison"
        cooldowns["Poison"] = spell_dict["turns"] # apply cooldown
        my_stats["mana"] -= spell_dict["cost"] # apply mana cost
    elseif spell == "Recharge"
        cooldowns["Recharge"] = spell_dict["turns"] # apply cooldown
        my_stats["mana"] -= spell_dict["cost"] # apply mana cost
    end
    my_stats["mana_spent"] += spell_dict["cost"] # apply mana spent
    return my_stats, boss_stats, cooldowns # return updated stats
end

function status_effects(my_stats, boss_stats, cooldowns)
    if cooldowns["Shield"] > 0 # if shield is active
        my_stats["Shield"] = 7 # apply shield
        cooldowns["Shield"] -= 1 # reduce cooldown
    else
        my_stats["Shield"] = 0 # remove shield
    end
    if cooldowns["Poison"] > 0 # if poison is active
        boss_stats["hp"] -= 3 # apply poison
        cooldowns["Poison"] -= 1 # reduce cooldown
    end
    if cooldowns["Recharge"] > 0 # if recharge is active
        my_stats["mana"] += 101 # apply recharge
        cooldowns["Recharge"] -= 1 # reduce cooldown
    end
    return my_stats, boss_stats, cooldowns # return updated stats
end

function available_spells(spells, cooldowns, my_stats)
    available = []
    if cooldowns["Shield"] <= 1 && my_stats["mana"] >= spells["Shield"]["cost"] # if shield is off cooldown, and player has enough mana
        push!(available, "Shield")
    end
    if cooldowns["Poison"] <= 1 && my_stats["mana"] >= spells["Poison"]["cost"] # if poison is off cooldown, and player has enough mana
        push!(available, "Poison")
    end
    if cooldowns["Recharge"] <= 1 && my_stats["mana"] >= spells["Recharge"]["cost"] # if recharge is off cooldown, and player has enough mana
        push!(available, "Recharge")
    end
    if my_stats["mana"] >= spells["Magic Missile"]["cost"] # if player has enough mana
        push!(available, "Magic Missile")
    end
    if my_stats["mana"] >= spells["Drain"]["cost"] # if player has enough mana
        push!(available, "Drain")
    end
    return available # return available spells
end

function fight_sims(spells, my_stats, boss_stats, cooldowns, part=1)
    min_mana = 100000 # set min mana to a high value
    branches = [[[""], my_stats, boss_stats, cooldowns]] # set up branches (should have probably used A* here)
    spellnames = [k for (k, v) in spells] # get spell names

    while length(branches)> 0 # while there are still branches 
        branch, my_stats, boss_stats, cooldowns = deepcopy(branches[1]) # get the first branch
        av_spells = available_spells(spells, cooldowns, my_stats) # get available spells
        if my_stats["mana_spent"] <= min_mana  && my_stats["hp"] > 0
            for spell in av_spells
                branch, my_stats, boss_stats, cooldowns = deepcopy(branches[1])
                branch = vcat(branch, spell) # add spell to branch
                rnd = round(my_stats, boss_stats, spell, spells[spell], cooldowns, part) # run round
                if rnd[1] == true # if player wins
                    if rnd[2] < min_mana # if mana spent is less than min mana
                        min_mana = rnd[2] # update min mana
                    end
                    continue # continue to next branch
                elseif rnd[1] == false # if player loses
                    continue # continue to next branch
                else # if player is still alive
                    push!(branches, [branch, rnd...]) # add branch to branches
                end
            end
        end
        popfirst!(branches) # remove branch from branches
    end
    return min_mana # return min mana
end
@show fight_sims(spells, my_stats, boss_stats, cooldowns, 1)
@show fight_sims(spells, my_stats, boss_stats, cooldowns, 2)

