# https://adventofcode.com/2019/day/6

file_path = "2019/data/day_6.txt"

function clean_input(file_path)
    out = []
    for line in readlines(file_path)
        push!(out, split(line, ")"))
    end
    return out
end
input = clean_input(file_path)

function solve(input)
    orbits = Dict()
    for orbit in input
        orbits[orbit[2]] = orbit[1]
    end
    count = 0

    count_orbits(orbit) = orbit == "COM" ? 0 : return 1 + count_orbits(orbits[orbit])
    path(orbit) = orbit == "COM" ? [] : return [orbits[orbit]; path(orbits[orbit])]

    for orbit in keys(orbits)
        count += count_orbits(orbit)
    end
    you = path("YOU")
    santa = path("SAN")
    min_transfers = 0
    for (i, planet) in enumerate(you)
        if planet in santa
            min_transfers = i + findfirst(x -> x == planet, santa) - 2
            break
        end
    end


    return count, min_transfers
end
@show part1(input)