# https://adventofcode.com/2015/day/16

file_path = "2015/data/day_16.txt"
file_path2 = "2015/data/day_16_2.txt"
function clean_input(file_path)
    aunts = Dict()
    for line in eachline(file_path)
        aunt = Dict{String, Int}()
        # parse line
        # example line
        # Sue 1: cars: 9, akitas: 3, goldfish: 0
        line = match(r"Sue (\d+): (\w+): (\d+), (\w+): (\d+), (\w+): (\d+)", line).captures
        aunt[line[2]] = parse(Int, line[3])
        aunt[line[4]] = parse(Int, line[5])
        aunt[line[6]] = parse(Int, line[7])
        aunts[line[1]] = aunt
        end
    return aunts
end
function clean_input2(file_path)
    properties = Dict()
    for line in eachline(file_path)
        # parse line
        # example line
        # children: 3
        line = match(r"(\w+): (\d+)", line).captures
        properties[line[1]] = parse(Int, line[2])
    end
    return properties
end
input = clean_input(file_path)
@show input2 = clean_input2(file_path2)

function solve(input, input2, part::Int=1)
    for (aunt, aunt_property_dict) in input
        # find the intersection of the keys of the two dicts
        keys_in_both = intersect(keys(aunt_property_dict), keys(input2))
        if all(aunt_property_dict[key] == input2[key] for key in keys_in_both) && part == 1
            return aunt
        elseif part == 2
            function part_2_checker(aunt_property_dict, input2, keys_in_both)
                greater_than = ["cats", "trees"]
                less_than = ["pomeranians", "goldfish"]
                for key in keys_in_both
                    if key in greater_than
                        if aunt_property_dict[key] <= input2[key]
                            return false
                        end
                    elseif key in less_than
                        if aunt_property_dict[key] >= input2[key]
                            return false
                        end
                    elseif aunt_property_dict[key] !== input2[key]
                        return false
                    end
                end
                return true
            end
            if part_2_checker(aunt_property_dict, input2, keys_in_both)
                return aunt
            end

        end
    end
end
@show solve(input, input2)


@info solve(input, input2, 2)
