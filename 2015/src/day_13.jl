# https://adventofcode.com/2015/day/13
using Combinatorics
file_path = "2015/data/day_13.txt"
function clean_input(file_path, part::Int=1)::Vector{Tuple{String, String, Int}}
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
    return both_ways
end
input = clean_input(file_path)
input2 = clean_input(file_path, 2)

function solve(input, part::Int=1)
     people =  unique([x[1] for x in input])
    seating_plans = permutations(people)
    max_happiness = 0
    for seating_plan in seating_plans
        happiness = 0
        push!(seating_plan, seating_plan[1])
        for i in 1:length(seating_plan)-1
            happiness += input[findfirst(x -> x[1] == seating_plan[i] && x[2] == seating_plan[i+1], input)][3]
        end
        if happiness > max_happiness
            max_happiness = happiness
        end
    end
    return max_happiness
end
@info solve(input)
@info solve(input2, 2)


