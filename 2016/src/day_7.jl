# Day 7: Internet Protocol Version 7
# https://adventofcode.com/2016/day/7

# this one is a bunch of string parsing. not the funnest thing in the world, but good to keep on top of. Enjoy!

input = readlines("2016/data/day_7.txt")

function line_checker(line, part::Int=1)
    original_line = line
    # remove hypernet sequences
    supernet_sequence = replace(line, r"\[.*?\]"=> "[]")
    for hypernet_sequence in findall(r"\[.*?\]", line)
        hypernet_sequence = line[hypernet_sequence]
        if part == 1 # look for ABBA sequences
            for i in 1:length(hypernet_sequence)-3
                # look for ABBA sequences
                if hypernet_sequence[i] == hypernet_sequence[i+3] &&
                hypernet_sequence[i+1] == hypernet_sequence[i+2] &&
                hypernet_sequence[i] != hypernet_sequence[i+1]
                    return false
                end
            end
        elseif part == 2 # look for ABA sequences
            for i in 1:length(hypernet_sequence)-2
                # look for ABA sequences
                if hypernet_sequence[i] == hypernet_sequence[i+2] &&
                hypernet_sequence[i] != hypernet_sequence[i+1]
                    # check if BAB sequence exists in supernet
                    bab_sequence = hypernet_sequence[i+1:i+2] * hypernet_sequence[i+1]
                    if occursin(bab_sequence, supernet_sequence)
                        return true
                    end
                end
            end
        end 
    end
    for i in 1:length(supernet_sequence)-3
        # look for ABBA sequences
        if supernet_sequence[i] == supernet_sequence[i+3] &&
            supernet_sequence[i+1] == supernet_sequence[i+2] &&
            supernet_sequence[i] != supernet_sequence[i+1] &&
           part == 1
            return true
        end
    end
    return false
end

@show sum([line_checker(line) for line in input])
@show sum([line_checker(line,2) for line in input])
