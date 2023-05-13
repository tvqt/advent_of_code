# Day 3: Squares With Three Sides
# https://adventofcode.com/2016/day/3

file_path = "2016/data/day_3.txt"

function clean_input(file_path::String, part::Int=1)::Vector{Vector{Int64}}
    result = Vector{Vector{Int64}}()
    for x in readlines(file_path)
        line = [parse(Int, x) for x in match(r"(\d+)\s+(\d+)\s+(\d+)", x).captures]
        if part == 1 # if part 1, then sort the line sides smallest to largest. if part 2, then don't sort
            line = sort(line)
        end
        push!(result, line)
    end
    return result
end

function part_1(file_path::String)::Int
    input = clean_input(file_path)
    count = 0
    for i in input # check if the sum of the two smallest sides is greater than the largest side
        if i[1] + i[2] > i[3]
            count += 1 # if so, then increment the count
        end
    end
    return count
end

function part_2(file_path)
    input = clean_input(file_path, 2)
    count = 0
    for i in 1:3:length(input) # for every three rows
        for j in 1:3 # for every column
            line = sort([input[i][j], input[i+1][j], input[i+2][j]]) # sort the nth item in each of the three selected rows
            if line[1] + line[2] > line[3] # check if the sum of the two smallest sides is greater than the largest side
                count += 1
            end
        end
    end
    return count
end

@show part_1(file_path)
@show part_2(file_path)
