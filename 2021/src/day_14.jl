# https://adventofcode.com/2021/day/14
using StatsBase
input = "BNSOSBBKPCSCPKPOPNNK"
file_path = "2021/data/day_14.txt"

function clean_input(file_path=file_path)
    out = Dict()
    for line in eachline(file_path)
        line = split(line, " -> ")
        out[line[1]] = line[2]
    end
    return out
end

function solve(steps=10, insertions_dict=clean_input(), input=input)
    partials = Dict()
    current_step=0

    while current_step < steps
        new = ""
        current_step += 1
        println(current_step)
        for i in 1:length(input)-1
            if input[i:i+1] in keys(insertions_dict)
                new *= input[i] * insertions_dict[input[i:i+1]]
            else
                new *= input[i]
            end
        end
        new *= input[end]
        input = new 
    end
    counts = countmap(input)
    return maximum(values(counts)) - minimum(values(counts))
end
@show solve(40)