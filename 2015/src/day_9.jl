# Day 9: All in a Single Night
# https://adventofcode.com/2015/day/9

using Combinatorics
file_path = "2015/data/day_9.txt"

function solve(file_path::String)::Tuple{String, String}
    input = convert(Vector{Vector{String}}, [collect(match(r"(.*) to (.*) = (\d+)", x)) for x in readlines(file_path)]) # parse the input
    input = [input; [[x[2], x[1], x[3]] for x in input]] # append the reverse, because end_location -> start_location isn't included in the input
    locations = convert(Vector{String}, unique([x[1] for x in input])::Vector{String}) # get all locations
    paths = permutations(locations) # get all possible paths
    min_dist = Inf
    max_dist = 0
    for i in paths # for each path, calculate the distance
        distance = 0
        for j in 1:length(i)-1 # loop through all the locations
            for k in input
                if k[1] == i[j] && k[2] == i[j+1]
                    distance += parse(Int, k[3]) # add the distance
                end
            end
        end
        if distance < min_dist # if the distance is less than the minimum distance
            min_dist = distance
        end
        if distance > max_dist  # if the distance is greater than the maximum distance
            max_dist = distance
        end
    end
return "Part 1: " * string(min_dist), "Part 2: " * string(max_dist) # return the answer
end


@show solve(file_path)
