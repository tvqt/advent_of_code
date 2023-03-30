# Day 7: Recursive Circus
# https://adventofcode.com/2017/day/7

using StatsBase

file_path = "2017/data/day_7.txt"

function clean_input(file_path=file_path)
    out = Dict()
    for line in readlines(file_path)
        line = split(line, " -> ")
        program, weight = match(r"(\w+) \((\d+)\)", line[1]).captures
        weight = parse(Int, weight)
        children = length(line)!= 1 ? split(line[2], ", ") : []
        out[program] = (weight, children)
    end

    function actual_weight(program, input=clean_input())
        weight, children = input[program]
        if isempty(children)
            return weight
        end
        return weight + sum([actual_weight(child, input) for child in children])
    end

    return Dict(k => (v[1], v[2], actual_weight(k, out)) for (k,v) in out)

end

part_1(input=clean_input()) = first(setdiff(keys(input), unique(vcat([x[2] for x in values(input)]...))))

function part_2(input=clean_input())
    parent = part_1(input)
    while !isempty(input[parent][2])
        child_weights = [input[child][3] for child in input[parent][2]]
        if length(unique(child_weights)) == 1
            break
        end
        global old_parent = parent
        parent = input[parent][2][findall(x->x!=mode(child_weights), child_weights)[1]]
    end
    sibling_weights = [input[sibling][3] for sibling in input[old_parent][2]]
    return input[parent][1] - (input[parent][3] - mode(sibling_weights))
end
@show part_1()
@show part_2()
