# https://adventofcode.com/2015/day/16

file_path = "2015/data/day_16.txt"
file_path2 = "2015/data/day_16_2.txt"
function clean_input(file_path)
    aunts = Dict() # store the aunts
    for line in eachline(file_path)
        aunt = Dict{String, Int}()
        # parse line
        # example line
        # Sue 1: cars: 9, akitas: 3, goldfish: 0
        line = match(r"Sue (\d+): (\w+): (\d+), (\w+): (\d+), (\w+): (\d+)", line).captures # parse line
        aunt[line[2]] = parse(Int, line[3])
        aunt[line[4]] = parse(Int, line[5])
        aunt[line[6]] = parse(Int, line[7])
        aunts[line[1]] = aunt
        end
    return aunts # return a dictionary of the aunts
end

function clean_input2(file_path)
    properties = Dict() # store the properties
    for line in eachline(file_path)
        # parse line
        # example line
        # children: 3
        line = match(r"(\w+): (\d+)", line).captures
        properties[line[1]] = parse(Int, line[2])
    end
    return properties # return a dictionary of the properties
end
input = clean_input(file_path)
input2 = clean_input2(file_path2)

function solve(input, input2, part::Int=1)
    for (aunt, aunt_property_dict) in input # for each aunt
        keys_in_both = intersect(keys(aunt_property_dict), keys(input2)) # find the intersection of the keys of the two dicts
        if all(aunt_property_dict[key] == input2[key] for key in keys_in_both) && part == 1 # if all the keys are the same
            return aunt # return the aunt
        elseif part == 2 # if part 2
            function part_2_checker(aunt_property_dict, input2, keys_in_both) # check if the aunt is the correct one
                greater_than = ["cats", "trees"] # these properties are greater than
                less_than = ["pomeranians", "goldfish"] # these properties are less than
                for key in keys_in_both # for each key in the intersection
                    if key in greater_than # if the key is in the greater than list
                        if aunt_property_dict[key] <= input2[key] # if the aunt property is less than or equal to the input property
                            return false # return false
                        end
                    elseif key in less_than # if the key is in the less than list
                        if aunt_property_dict[key] >= input2[key] # if the aunt property is greater than or equal to the input property
                            return false # return false
                        end
                    elseif aunt_property_dict[key] !== input2[key] # if the aunt property is not equal to the input property
                        return false # return false
                    end
                end # if all the keys are the same
                return true # return true
            end
            if part_2_checker(aunt_property_dict, input2, keys_in_both) # if the aunt is the correct one
                return aunt # return the aunt
            end

        end
    end
end

@show solve(input, input2)
@show solve(input, input2, 2)
