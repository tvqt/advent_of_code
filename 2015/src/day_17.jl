# https://adventofcode.com/2015/day/17
using Combinatorics
file_path = "2015/data/day_17.txt"

function clean_input(file_path)
    containers = []
    for line in eachline(file_path)
        push!(containers, parse(Int, line))
    end
    return containers
end
@show input = clean_input(file_path)

function solve(input, part::Int=1)
    variations = []
    for i in 1:length(input)
        for combination in combinations(input, i)
            if sum(combination) == 150
                push!(variations, sort(combination))
            end
        end
    end
    if part == 1
        return length(variations)
    elseif part == 2
        min_length = minimum(length.(variations))
        println(min_length)
        return length(filter(x -> length(x) == min_length, variations))
    end
end

@info solve(input)

@info solve(input,2)
