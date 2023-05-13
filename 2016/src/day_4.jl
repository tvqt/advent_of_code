# Day 4: Security Through Obscurity
# https://adventofcode.com/2016/day/4

using StatsBase

file_path = "2016/data/day_4.txt"

function clean_input(file_path::String)::Vector{Vector{String}}
    result = []
    for line in readlines(file_path) # for each line, parse the important values
        line = match(r"([a-z-]+)-(\d+)\[([a-z]+)\]", line).captures
        push!(result, line)
    end
    return result
end

function part_1(file_path) 
    sum = 0
    good_ones = []
    input = clean_input(file_path)
    for line in input
        # check that the five most common letters in the encrypted name, sorted by frequency and then by alphabetical order, are the same as the checksum. If so, then add the sector ID to the sum
        if line[3] == join([x[1] for x in sort(sort(collect(countmap(replace(line[1], "-"=>"")))), by= x->x[2], rev = true)[1:5]])
            sum += parse(Int, line[2])
            push!(good_ones, line)
        end
    end
    return sum, good_ones
end
p1a, p1b = part_1(file_path)
@show p1a

function part_2(input=p1b)
    for line in input
        # remove the dashes
        shift_value = parse(Int, line[2]) % 26
        new_name = ""
        for c in line[1]
            # for each item in the encrypted name, move it forward by the shift value, then find the value mod 26
            c == '-' ? new_name *= ' ' : new_name *='`' + ((c - '`' + shift_value) % 26)
        end
        if new_name == "northpole object storage" # if the decrypted name is "northpole object storage", then return the sector ID
            return parse(Int, line[2])
        end
    end
end

@show part_2()