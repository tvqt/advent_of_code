# https://adventofcode.com/2021/day/22
using Combinatorics
file_path = "2021/data/day_22.txt"

function clean_input(f=file_path)
    out = []
    for line in readlines(f)
        state, min_x, max_x, min_y, max_y, min_z, max_z, = match(r"(\w+) x=(-?\d+)..(-?\d+),y=(-?\d+)..(-?\d+),z=(-?\d+)..(-?\d+)", line).captures
        push!(out, (state == "on" ? true : false, parse(Int, min_x):parse(Int, max_x), parse(Int, min_y):parse(Int, max_y), parse(Int, min_z):parse(Int, max_z)))
    end
    return out
end
input = clean_input()

function turn_on(on_groups, instruction)
    for (i, group) in enumerate(on_groups)
        if !isempty(group[1] ∩ instruction[2]) && !isempty(group[2] ∩ instruction[3]) && !isempty(group[3] ∩ instruction[4])
            on_groups[i] = min(group[1][1], instruction[2][1]):max(group[1][end], instruction[2][end]), min(group[2][1], instruction[3][1]):max(group[2][end], instruction[3][end]), min(group[3][1], instruction[4][1]):max(group[3][end], instruction[4][end])
            return on_groups
        end
    end
    push!(on_groups, instruction[2:end])
    return on_groups
end

function turn_off(on_groups, instruction)
    for (i, group) in enumerate(on_groups)
        if !isempty(group[1] ∩ instruction[2]) && !isempty(group[2] ∩ instruction[3]) && !isempty(group[3] ∩ instruction[4])
            on_groups[i] = setdiff(group, instruction[2]:instruction[3]:instruction[4])
        end
    end
end


function part_1(input=clean_input())
    out = []
    for instruction in input
        if instruction[1]
            out = turn_on(out, instruction)
        else
            out = turn_off(out, instruction)
        end
    end
    return sum(out)
end
@show part_1()
