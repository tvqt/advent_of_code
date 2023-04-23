# https://adventofcode.com/2021/day/16

file_path = "2021/data/day_16.txt"
clean_input(f=file_path) = join(string.([parse(Int, char, base=16 ) for char in readline(f)], base=2, pad=4))

function decode_packet(input=clean_input())
    id_dict = Dict(0 => +, 1 => *, 2 => min, 3 => max, 5 => >, 6 => <, 7 => ==)
    length_of_subpackets, number_of_subpackets = 0, nothing, nothing
    version_sum = parse(Int, input[1:3], base=2)
    id = parse(Int, input[4:6], base=2)
    id !== 4 ? println(id_dict[id]) : nothing
    if id == 4 # literal mode
        i = 7
        out = ""
        while true
            out *= input[i+1:i+4]
            i += 5
            if input[i-5] == '0'
                return parse(Int, out, base=2), i - 1, version_sum, parse(Int, out, base=2) # -1 because we want to return the index of the last bit we processed
            end
        end
    end
    if input[7] == '0' # next 15 bits are a number that represents the total length in bits of the sub-packets contained by this packet.
        length_of_subpackets = parse(Int, input[8:22], base=2)
        i = 23
    elseif input[7] == '1' # next 11 bits are a number that represents the number of sub-packets immediately contained by this packet.
        number_of_subpackets = parse(Int, input[8:18], base=2)
        i = 19
    end
    if number_of_subpackets !== nothing
        packets_processed = 0
        subpackets = []
        while packets_processed < number_of_subpackets
            child_value, child_length, child_version = decode_packet(input[i:end])
            push!(subpackets, child_value)
            i += child_length
            version_sum += child_version
            packets_processed += 1
        end
    elseif length_of_subpackets !== nothing
        current_length = 0
        subpackets = []
        while current_length < length_of_subpackets
            child_value, child_length, child_version = decode_packet(input[i:end])
            push!(subpackets, child_value)
            i += child_length 
            version_sum += child_version
            current_length += child_length
        end
    end
    
    return id_dict[id](subpackets...), i-1, version_sum
end

test1 = clean_input("2021/data/day_16_test_1.txt")

@show decode_packet()
