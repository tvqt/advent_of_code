# Day 17: No Such Thing as Too Much
# https://adventofcode.com/2015/day/17

using Combinatorics

file_path = "2015/data/day_17.txt"

function clean_input(file_path) # read in the file and parse the integers
    containers = []
    for line in eachline(file_path)
        push!(containers, parse(Int, line))
    end
    return containers # return the array of integers
end
input = clean_input(file_path)

function solve(input, part::Int=1) # solve the problem
    variations = [] # store the variations
    for i in eachindex(input)
        for combination in combinations(input, i) # get all combinations of i items
            if sum(combination) == 150 # if the sum of the combination is 150
                push!(variations, sort(combination)) # add the combination to the variations
            end
        end
    end
    if part == 1 # return the number of variations
        return length(variations)
    elseif part == 2 # return the number of variations with the smallest number of containers
        min_length = minimum(length.(variations))
        return length(filter(x -> length(x) == min_length, variations))
    end
end

@show solve(input)
@show solve(input,2)
