# Day 8: Memory Maneuver
# https://adventofcode.com/2018/day/8

file_path = "2018/data/day_8.txt"
input = parse.(Int, split(readline(file_path)))



function node_parse(i)
    n_children = input[i]
    n_metadata = input[i+1]
    i += 2
    children = []
    for _ in 1:n_children
        child, i = node_parse(i)
        push!(children, child)
    end
    metadata = input[i:(i+n_metadata-1)]
    i += n_metadata
    return Dict(:children => children, :metadata => metadata), i
end
@show node_parse(1)


function part_1(input)
    tree, _ = node_parse(1)
    function sum_metadata(tree)
        children_sum = !isempty(tree[:children]) ? sum(sum_metadata(child) for child in tree[:children]) : 0
        return sum(tree[:metadata]) + children_sum
    end
    return sum_metadata(tree)
end
@show part_1(input)

function part_2(input)
    tree, _ = node_parse(1)
    function sum_value(tree)
        children = [sum_value(child) for child in tree[:children]]
        if isempty(children)
            return sum(tree[:metadata])
        else
            return sum(children[i] for i in tree[:metadata] if i <= length(children))
        end

    end
    return sum_value(tree)
end

@show part_2(input)