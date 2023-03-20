# https://adventofcode.com/2015/day/2
# Day 2: I Was Told There Would Be No Math

input = [parse.(Int, split(line, 'x')) for line in readlines("2015/data/day_2.txt")]

function solve(part::Int=1, input=input)
    total = 0
    for (l, w, h) in input
        if part == 1
            total += 2*l*w + 2*w*h + 2*h*l + min(l*w, w*h, h*l)
        else
            total += 2*min(l+w, w+h, h+l) + l*w*h
        end
    end
    return total
end

@show solve(1)
@show solve(2)


