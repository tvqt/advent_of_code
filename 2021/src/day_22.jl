# https://adventofcode.com/2021/day/22
using Combinatorics
file_path1 = "2021/data/day_22_1.txt"
file_path2 = "2021/data/day_22_2.txt"
function clean_input(f=file_path1)
    out = []
    for line in readlines(f)
        state, min_x, max_x, min_y, max_y, min_z, max_z, = match(r"(\w+) x=(-?\d+)..(-?\d+),y=(-?\d+)..(-?\d+),z=(-?\d+)..(-?\d+)", line).captures
        push!(out, (state == "on" ? 1 : -1, parse(Int, min_x):parse(Int, max_x), parse(Int, min_y):parse(Int, max_y), parse(Int, min_z):parse(Int, max_z)))
    end
    return out
end
input = clean_input()
input2 = clean_input(file_path2)
function turn_on(ons, offs, instruction)
    for cube in ons
        inter = intersect(instruction[2], cube[1]), intersect(instruction[3], cube[2]), intersect(instruction[4], cube[3])
        println(inter)
        if !isempty(inter)
            push!(offs, inter)
        end
    end
    push!(ons, instruction[2:end])
    return ons, offs
end




function part_1(input=clean_input())
    negative = []
    positive = []
    for instruction in input
        positive, negative = turn_on(positive, negative, instruction)
    end
    return negative, positive
end

p1= part_1()

605068