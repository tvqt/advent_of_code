# https://adventofcode.com/2018/day/23

using NearestNeighbors

file_path = "2018/data/day_23.txt"

function clean_input(file_path=file_path)
    [(x, y, z, r) = parse.(Int, match(r"pos=<(-?\d+),(-?\d+),(-?\d+)>, r=(\d+)", line).captures) for line in readlines(file_path)]
end

manhattan_distance(p1, p2) = sum(abs.(p1 .- p2))

function part1(input=clean_input())
    strongest = argmax(input) do (x, y, z, r)
        r
    end
    sum((manhattan_distance(strongest[1:3], p[1:3]) <= strongest[4]) for p in input)
end

@show part1()

#in_range_of(p, input) = sum((manhattan_distance(p[1:3], q[1:3]) <= q[4]) for q in input)

function all_coords_in_range_of_x(p, input)
    x, y, z, r = p
    [(x + i, y, z, r) for i in -r:r]
end

