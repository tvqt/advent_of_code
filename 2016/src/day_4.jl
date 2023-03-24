# https://adventofcode.com/2016/day/4
using StatsBase
file_path = "2016/data/day_4.txt"

function clean_input(file_path::String)::Vector{Vector{String}}
    result = []
    for L in readlines(file_path)
        # example line
        line = match(r"([a-z-]+)-(\d+)\[([a-z]+)\]", L).captures
        push!(result, line)
    end
    return result
end

function part_1(file_path, part::Int = 1)
    sum = 0
    good_ones = []
    input = clean_input(file_path)
    for line in input
        # remove the dashes
        if line[3] == join([x[1] for x in sort(sort(collect(countmap(replace(line[1], "-"=>"")))), by= x->x[2], rev = true)[1:5]])
            if part == 1
                sum += parse(Int, line[2])
            else
                push!(good_ones, line)
            end
            

        end
    end
    if part == 1
        return sum
    else
        return good_ones
    end
end
@show part_1(file_path)

function part_2(file_path)
    input = part_1(file_path, 2)
    for line in input
        # remove the dashes
        shift_value = parse(Int, line[2]) % 26
        new_name = ""
        for c in line[1]
            if c == '-'
                new_name *= ' '
            else
                new_name *='`' + ((c - '`' + shift_value) % 26)
            end
            
        end
        if new_name == "northpole object storage"
            return line[2]
        end
    end
end

@show part_2(file_path)