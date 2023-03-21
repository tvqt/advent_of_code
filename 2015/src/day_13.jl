# Day 13: Knights of the Dinner Table
# https://adventofcode.com/2015/day/13

using Combinatorics

file_path = "2015/data/day_13.txt"

function clean_input(file_path, part::Int=1)::Vector{Tuple{String, String, Int}} # read in the file and parse the integers
    one_way = []
    both_ways = []
    for line in readlines(file_path)
        # example line
        # parse line. Example below
        # Alice would gain 54 happiness units by sitting next to Bob.
        line = match(r"(\w+) would (\w+) (\d+) happiness units by sitting next to (\w+).", line).captures
        if line[2] == "lose"
            units = -parse(Int, line[3])
        else
            units = parse(Int, line[3])
        end
        out = (line[1], line[4], units)
        push!(one_way, out)
    end
    for (a, b, c) in one_way
        c += one_way[findfirst(x -> x[1] == b && x[2] == a, one_way)][3]
        push!(both_ways, (a, b, c))
    end
    if part == 2
        for person in unique([x[1] for x in both_ways])
            push!(both_ways, ("Me", person, 0))
            push!(both_ways, (person, "Me", 0))
        end
    end
    return both_ways # return the array of integers
end

input = clean_input(file_path)
input2 = clean_input(file_path, 2)

function solve(input, part::Int=1)
    people =  unique([x[1] for x in input]) # get the unique people
    seating_plans = permutations(people) # get all the possible seating plans
    max_happiness = 0 # set the maximum happiness to 0
    for seating_plan in seating_plans # loop through all the seating plans
        happiness = 0
        push!(seating_plan, seating_plan[1]) # add the first person to the end of the list
        for i in 1:length(seating_plan)-1 # loop through all the people
            happiness += input[findfirst(x -> x[1] == seating_plan[i] && x[2] == seating_plan[i+1], input)][3] # add the happiness
        end
        if happiness > max_happiness # if the happiness is greater than the maximum happiness
            max_happiness = happiness # set the maximum happiness to the happiness
        end
    end
    return max_happiness # return the maximum happiness
end
@show solve(input)
@show solve(input2, 2)


