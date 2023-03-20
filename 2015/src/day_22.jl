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
    if part == 2
        my_stats["hp"] -=1
        if my_stats["hp"] <=0
            return false
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
    # 4. check if boss is dead, or we don't have enough mana to cast another spell
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
        boss_stats["hp"] -= spell_dict["damage"]
        my_stats["mana"] -= spell_dict["cost"]
    elseif spell == "Drain"
        boss_stats["hp"] -= spell_dict["damage"]
        my_stats["mana"] -= spell_dict["cost"]
        my_stats["hp"] += spell_dict["heal"]
    elseif spell == "Shield"
        cooldowns["Shield"] = spell_dict["turns"]
        my_stats["mana"] -= spell_dict["cost"]
    elseif spell == "Poison"
        cooldowns["Poison"] = spell_dict["turns"]
        my_stats["mana"] -= spell_dict["cost"]
    elseif spell == "Recharge"
        cooldowns["Recharge"] = spell_dict["turns"]
        my_stats["mana"] -= spell_dict["cost"]
    end
    my_stats["mana_spent"] += spell_dict["cost"]
    return my_stats, boss_stats, cooldowns
end

function status_effects(my_stats, boss_stats, cooldowns)
    if cooldowns["Shield"] > 0
        my_stats["Shield"] = 7
        cooldowns["Shield"] -= 1
    else
        my_stats["Shield"] = 0
    end
    if cooldowns["Poison"] > 0
        boss_stats["hp"] -= 3
        cooldowns["Poison"] -= 1
    end
    if cooldowns["Recharge"] > 0
        my_stats["mana"] += 101
        cooldowns["Recharge"] -= 1
    end
    return my_stats, boss_stats, cooldowns
end

function available_spells(spells, cooldowns, my_stats)
    available = []
    if cooldowns["Shield"] <= 1 && my_stats["mana"] >= spells["Shield"]["cost"]
        push!(available, "Shield")
    end
    if cooldowns["Poison"] <= 1 && my_stats["mana"] >= spells["Poison"]["cost"]
        push!(available, "Poison")
    end
    if cooldowns["Recharge"] <= 1 && my_stats["mana"] >= spells["Recharge"]["cost"]
        push!(available, "Recharge")
    end
    if my_stats["mana"] >= spells["Magic Missile"]["cost"]
        push!(available, "Magic Missile")
    end
    if my_stats["mana"] >= spells["Drain"]["cost"]
        push!(available, "Drain")
    end
    return available
end

function fight_sims(spells, my_stats, boss_stats, cooldowns, part=1)
    min_mana = 100000
    branches = [[[""], my_stats, boss_stats, cooldowns]]
    spellnames = [k for (k, v) in spells]

    while length(branches)> 0
        branch, my_stats, boss_stats, cooldowns = deepcopy(branches[1])
        av_spells = available_spells(spells, cooldowns, my_stats)
        if my_stats["mana_spent"] <= min_mana  && my_stats["hp"] > 0
            for spell in av_spells
                branch, my_stats, boss_stats, cooldowns = deepcopy(branches[1])
                branch = vcat(branch, spell)
                rnd = round(my_stats, boss_stats, spell, spells[spell], cooldowns, part)
                if rnd[1] == true
                    if rnd[2] < min_mana
                        min_mana = rnd[2]
                    end
                    continue
                elseif rnd[1] == false
                    continue
                else
                    push!(branches, [branch, rnd...])
                end
            end
        end
        popfirst!(branches)
    end
    return min_mana
end
@show fight_sims(spells, my_stats, boss_stats, cooldowns, 1)
@show fight_sims(spells, my_stats, boss_stats, cooldowns, 2)

