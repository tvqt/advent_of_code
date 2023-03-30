# Day 13: Packet Scanners
# https://adventofcode.com/2017/day/13

file_path = "2017/data/day_13.txt"

function clean_input(file_path=file_path)
    out = Dict()
    for line in readlines(file_path)
        layer, depth = split(line, ": ")
        layer = parse(Int, layer)
        depth = parse(Int, depth)
        out[layer] = depth
    end
    return out
end


function severity(delay=0, input=clean_input())
    severity = 0
    caught = false
    for (layer, depth) in input
        if (layer + delay) % (2depth - 2) == 0
            caught = true
            severity += layer * depth
        end
    end
    return severity, caught
end
function part_2(input=clean_input())
    delay = 0
    while severity(delay, input)[2]
        delay += 1
    end
    return delay
end
    
@show part_2()