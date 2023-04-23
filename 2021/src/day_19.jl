# https://adventofcode.com/2021/day/19


using LinearAlgebra


file_path = "2021/data/day_19.txt"

function clean_input(file_path=file_path)
    input = readlines(file_path)
    out = []
    scanner = []
    for line in 2:length(input)
        if input[line] == ""
            push!(out, scanner)
            scanner = []
        elseif input[line][end] == '-'
            continue
        else
            push!(scanner, parse.(Int, split(input[line], ",")))
        end
    end
    push!(out, scanner)
    return out
end

@show input =  clean_input()

manhattan_distance(p1, p2) = sum(abs.(p1 .- p2))


rotation_permuations(x, y, z) = [[x, y, z], [y, -x, z], [-x, -y, z], [-y, x, z]]
position_permuations(x, y, z) = vcat([rotation_permuations(x, y, z) for (x, y, z) in [(x, y, z), (z, y, -x), (-x, y, -z), (-z, y, x), (x, -z, y), (x, z, -y)]]...)

function input_permutations(input)
    out = []
    for scanner in input
        scan_vec = [[] for p in 1:24]
        for beacon in scanner
            [push!(scan_vec[i], p) for (i, p) in enumerate(position_permuations(beacon...))]
        end
        push!(out, scan_vec)

    end
    # group scanners instead by their position
    return out
end
@show perms = input_permutations(input)


closest_beacon(beacon, beacons) = minimum([norm(beacon - otherbeacon) for otherbeacon in setdiff(beacons, [beacon])])


function distances(input)
    out = []
    for scanner in input
        push!(out, [closest_beacon(beacon, scanner) for beacon in scanner])
    end
    return out
end

ds = distances(input)

function comparer(perms)
    out = []
    for p1 in perms[1]
        for p2 in perms[2]
            push!(intersect(p1, p2))
        end
    end
    return out
end
@show comparer(perms)