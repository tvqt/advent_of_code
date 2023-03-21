# Day 12: JSAbacusFramework.io
# https://adventofcode.com/2015/day/12

using JSON

file_path = "2015/data/day_12.txt"
input = read(file_path, String)

@show sum([parse(Int, input[x]) for x in findall(r"(-?\d+)", input)]) # part 1


function item_parser(item::Dict)::Int # if the item is a dictionary
    if "red" in values(item)
        return 0
    else
        total = 0
        for x in values(item) # loop through the values
            if typeof(x) <: Dict # if the value is a dictionary
                total += item_parser(x) # recursive call
            elseif typeof(x) <: Vector # if the value is a vector
                total += item_parser(x) # recursive call
            elseif typeof(x) <: Int # if the value is an integer
                total += x # add it to the total
            end
        end
    end
    return total
end

function item_parser(item::Array)::Int # if the item is an array
    total = 0
    for x in item # loop through the values
        if typeof(x) <: Dict # if the value is a dictionary
            total += item_parser(x) # recursive call
        elseif typeof(x) <: Vector # if the value is a vector
            total += item_parser(x) # recursive call
        elseif typeof(x) <: Int # if the value is an integer
            total += x # add it to the total
        end
    end
    return total # return the total
end

input2 = JSON.parse(input) # parse the input
@show sum([item_parser(x) for x in input2]) # part 2