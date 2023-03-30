# Day 12: Digital Plumber
# https://adventofcode.com/2017/day/12

file_path = "2017/data/day_12.txt"

function clean_input(file_path=file_path) # returns a Dict of program -> children
    out = Dict()
    for line in readlines(file_path)
        line = split(line, " <-> ")
        program = parse(Int, line[1])
        children = parse.(Int, split(line[2], ", "))
        out[program] = children
    end
    return out
end
 

function group(input=clean_input(), starting_program=0) # returns a Set of programs in the same group as starting_program
    visited = Set()
    to_visit = Set([starting_program])
    while !isempty(to_visit)
        program = pop!(to_visit)
        push!(visited, program)
        for child in input[program]
            if child ∉ visited
                push!(to_visit, child)
            end
        end
    end
    return visited
end
@show length(group())

function count_groups(input=clean_input()) # returns the number of groups
    unvisited = Set(keys(input))
    count = 0
    while !isempty(unvisited)
        program = pop!(unvisited) # pick a random program
        count += 1
        unvisited = setdiff(unvisited, group(input, program)) # remove all programs in the same group as program from unvisited
    end
    return count 
end
@show count_groups()