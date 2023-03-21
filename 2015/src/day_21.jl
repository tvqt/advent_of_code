# https://adventofcode.com/2015/day/21

boss_file_path = "2015/data/day_21.txt"
shop_file_path = "2015/data/day_21_2.txt"

function clean_boss_data(boss_file_path)
    boss_data = Dict()
    for line in eachline(boss_file_path) # read each line
        line = split(line, ": ")
        boss_data[line[1]] = parse(Int, line[2])
    end
    return boss_data # return a dictionary of the boss data
end
boss = clean_boss_data(boss_file_path)

function clean_shop_data(boss_file_path)
    shop_data = Dict()
    sections = split(read(boss_file_path, String), "\n\n")
    for section in sections # read each section
        section_dict = Dict()
        section_title = split(section, ":")[1]
        for line in split(section, "\n")
            line = strip(replace(line, r"\s+" => " "))
            # check "Cost" doesn't appear in line
            if !occursin(r"Cost", line) # check "Cost" doesn't appear in line
                # parse line
                # example lines
                #"Dagger +1 8 4 0"
                #"Splintmail 53 0 3"
                item, buff, cost, damage, armour= match(r"(\w+)\s*(\+\d)?\s(\d+)\s(\d+)\s(\d+)", line).captures
                if buff !== nothing
                    item = item * buff
                end
                section_dict[item] = Dict("cost" => parse(Int, cost), "damage" => parse(Int, damage), "armour" => parse(Int, armour))
            end
        end
        if section_title == "Armor"
            section_dict["No Armor"] = Dict("cost" => 0, "damage" => 0, "armour" => 0) # add a "no armor" option
        elseif section_title == "Rings"
            section_dict["No Ring"] = Dict("cost" => 0, "damage" => 0, "armour" => 0) # add a "no ring" option
            section_dict["No Ring #2"] = Dict("cost" => 0, "damage" => 0, "armour" => 0) # add another "no ring" option
        end
        shop_data[section_title] = section_dict # add section to shop data
    end
    return shop_data # return a dictionary of the shop data
end
shop = clean_shop_data(shop_file_path)


function solve(shop, boss)
    Ws = [] # wins
    Ls = [] # losses
    for armour in shop["Armor"] # for each armour
        for weapon in shop["Weapons"] # for each weapon
            for ring_1 in collect(shop["Rings"]) # for each ring
                for ring_2 in collect(shop["Rings"]) # for each ring
                    loadout = [armour, weapon, ring_1, ring_2] # create loadout
                    if ring_1[1]== ring_2[1] # if the rings are the same, skip
                        continue # skip
                    else
                        player = Dict("cost" => 0, "damage" => 0, "armour" => 0) # create player
                        for item in loadout # for each item in the loadout
                            player["cost"] += item[2]["cost"] # add the cost
                            player["damage"] += item[2]["damage"] # add the damage
                            player["armour"] += item[2]["armour"] # add the armour
                        end
                        if fight(player, boss) # if the player wins
                            push!(Ws, player["cost"]) # add the cost to the wins
                        else
                            push!(Ls, player["cost"]) # add the cost to the losses
                        end  
                    end                
                end
            end
        end
    end
    return "Part 1: $(minimum(Ws)), Part 2: $(maximum(Ls))" # return the minimum cost of a win and the maximum cost of a loss
end


function fight(player, boss, hp::Int=100)
    player_hp = 100 # player hp
    boss_hp = boss["Hit Points"] # boss hp
    player_damage = max(1, player["damage"] - boss["Armor"]) # player damage
    boss_damage = max(1, boss["Damage"] - player["armour"]) # boss damage

    while player_hp > 0 && boss_hp > 0 # while both are alive
        boss_hp -= player_damage # boss takes damage
        if boss_hp <= 0 # if boss is dead
            break # break
        end
        player_hp -= boss_damage # player takes damage
    end
    return player_hp > 0 # return: is the player is alive?
end
@show solve(shop, boss) 
