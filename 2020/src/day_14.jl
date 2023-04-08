# Day 14 - Docking Data
# https://adventofcode.com/2020/day/14
using IterTools

file_path = "2020/data/day_14.txt"

function solve(version=1, file_path=file_path)
    mask = ""
    mem = Dict()
    for line in readlines(file_path) # iterate through the lines
        if split(line, " ")[1] == "mask"
            mask = split(line, " ")[3] # update mask
        else
            mem_index, mem_value = match(r"mem\[(\d+)\] = (\d+)", line).captures # parse mem index and value
            if version == 1 # if part 1, apply bitmask to value
                mem[parse(Int, mem_index)] = apply_bitmask(mem_value, mask) 
            elseif version == 2 # if part 2, apply bitmask to address index, and write to all possible addresses
                for address in floating_bitmask(mem_index, mask)
                    mem[address] = parse(Int, mem_value)
                end
            end
        end
    end
    return sum(values(mem)) # return sum of all values in memory
end

function apply_bitmask(value, bitmask, version=1)
    value = bin_pad(value) # convert value to binary
    for (i, bit) in enumerate(bitmask)
        if bit in (version == 1 ? ['0', '1'] : ['1', 'X']) # if bit is 0 or 1 in part 1, or X or 1 in part 2
            value[i] = string(bit)
        end
    end
    return version == 1 ? parse(Int, join(value), base=2) : value # return value as integer in part 1, or as string in part 2
end

bin_pad(x)::Vector{String} = split(string(parse(Int, x), base=2, pad=36),"")

ones_and_zeros(x) = collect(Iterators.product(fill(["0", "1"], x)...))

function floating_bitmask(address, bitmask)
    out = []
    address = apply_bitmask(address, bitmask, 2) # apply bitmask to address
    x_indices = findall(x -> x == "X", address) # find all X indices
    for comb in ones_and_zeros(length(x_indices)) # iterate through all possible combinations of 0 and 1
        new_address = copy(address)
        for (i, x) in enumerate(x_indices)
            new_address[x] = comb[i] # replace X with 0 or 1 from the current combination
        end
        push!(out, join(new_address)) # add the new address to the output
    end
    return out # return all possible addresses
end




@show solve(2)