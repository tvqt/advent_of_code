# https://adventofcode.com/2021/day/8

file_path = "2021/data/day_8.txt"

function solve(file_path=file_path)
    letters = ["a", "b", "c", "d", "e", "f"]
    out = []
    p1 = 0
    p2 = 0
    for line in readlines(file_path)
        numbers = Dict()
        signal_patterns, output = split(line, " | ")
        signal_patterns, output = sort.(split.(split(signal_patterns),"")), sort.(split.(split(output),""))
        # find the number of times an element in output appears in all
        p1 += length(filter(x -> length(x) ∈ [2, 3, 4, 7], output))
        all = unique([signal_patterns; output])
        val1 = filter(x -> length(x) == 2, all)[1]
        val4 = filter(x -> length(x) == 4, all)[1]
        numbers[val1] = 1
        numbers[val4] = 4
        numbers[filter(x -> length(x) == 3, all)[1]] = 7
        numbers[filter(x -> length(x) == 7, all)[1]] = 8
        remaining = setdiff(all, keys(numbers))
        for number in remaining
            if length(setdiff(number, val1)) == 3
                numbers[number] = 3
            elseif length(setdiff(number, val1)) == 5
                numbers[number] = 6
            elseif length(intersect(number, val4)) == 2
                numbers[number] = 2
            elseif length(intersect(number, val4)) == 4
                numbers[number] = 9
            end

        end
        # sort remaining by length
        val5and0 = sort(setdiff(remaining, keys(numbers)), by=length)
        numbers[val5and0[1]], numbers[val5and0[2]] = 5, 0
        p2 += parse(Int, join([numbers[value] for value in output]))
    end
    return p1, p2
end

@show solve()
