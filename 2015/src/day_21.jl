# https://adventofcode.com/2015/day/21

boss_file_path = "2015/data/day_21.txt"
shop_file_path = "2015/data/day_21_2.txt"

function clean_boss_data(boss_file_path)
    boss_data = Dict()
    for line in eachline(boss_file_path)
        line = split(line, ": ")
        boss_data[line[1]] = parse(Int, line[2])

    end
    return boss_data
end
@show boss = clean_boss_data(boss_file_path)

function clean_shop_data(boss_file_path)
    shop_data = Dict()
    sections = split(read(boss_file_path, String), "\n\n")
    for section in sections
        section_dict = Dict()
        section_title = split(section, ":")[1]
        for line in split(section, "\n")
            line = strip(replace(line, r"\s+" => " "))
            # check "Cost" doesn't appear in line
            if !occursin(r"Cost", line)
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
            section_dict["No Armor"] = Dict("cost" => 0, "damage" => 0, "armour" => 0)
        elseif section_title == "Rings"
            section_dict["No Ring"] = Dict("cost" => 0, "damage" => 0, "armour" => 0)
            section_dict["No Ring #2"] = Dict("cost" => 0, "damage" => 0, "armour" => 0)

        end
        shop_data[section_title] = section_dict
    end
    return shop_data
end
@show shop = clean_shop_data(shop_file_path)


function part_1(shop, boss)
    Ws = []
    Ls = []
    for armour in shop["Armor"]
        for weapon in shop["Weapons"]
            for ring_1 in collect(shop["Rings"])
                for ring_2 in collect(shop["Rings"])
                    loadout = [armour, weapon, ring_1, ring_2]
                    if ring_1[1]== ring_2[1]
                        continue
                    else
                        player = Dict("cost" => 0, "damage" => 0, "armour" => 0)
                        for item in loadout
                            player["cost"] += item[2]["cost"]
                            player["damage"] += item[2]["damage"]
                            player["armour"] += item[2]["armour"]
                        end
                        if fight(player, boss)
                            push!(Ws, player["cost"])
                        else
                            push!(Ls, player["cost"])
                        end  
                    end                
                end
            end
        end
    end
    return minimum(Ws), maximum(Ls)
end


function fight(player, boss, hp::Int=100)
    player_hp = 100
    boss_hp = boss["Hit Points"]
    player_damage = max(1, player["damage"] - boss["Armor"])
    boss_damage = max(1, boss["Damage"] - player["armour"])

    while player_hp > 0 && boss_hp > 0
        boss_hp -= player_damage
        if boss_hp <= 0
            break
        end
        player_hp -= boss_damage
    end
    return player_hp > 0
end
@info part_1(shop, boss)
