# Day 14: Disk Defragmentation
# https://adventofcode.com/2017/day/14

input = "ffayrhll"
input = [input * "-" * string(i) for i in 0:127] # add the row number to the end of the input
input = [[Int(x) for x in row] for row in input] # convert the input to a vector of integers
suffix = [17, 31, 73, 47, 23]
input = [vcat(row, suffix) for row in input] # add the suffix to the end of the input

function reverse_list(list::Vector{Int}, sublist, current_position::Int, skip_size::Int)::Tuple{Vector{Int64}, Int64}
    list = circshift(list, -current_position)
    list = vcat(reverse(list[1:sublist]), list[sublist+1:end])
    return circshift(list,current_position), (current_position + sublist + skip_size) % length(list)
end

function knot_hash_round(list::Vector{Int}, sublists)::Int64 # return the product of the first two elements
    skip_size, current_position = 0, 0
    for sublist in sublists
        list, current_position = reverse_list(list, sublist, current_position, skip_size)
        skip_size += 1
    end
    return prod(list[1:2])
end


function knot_hash(input::Vector{Int})::Vector{Int} # go through 64 rounds of the knot hash
    list = collect(0:255)
    skip_size, current_position = 0, 0
    for i in 1:64
        for sublist in input
            list, current_position = reverse_list(list, sublist, current_position, skip_size) 
            skip_size += 1
        end
    end
    return list # return 
end
function dense_hash(sequence::Vector{Int})::String # convert the sequence to a dense hash
    hexes = []
    for i in 1:16
        push!(hexes, foldl(xor, sequence[(i-1)*16+1:i*16]))
    end
    out = []
    for hex in [string(x, base= 16) for x in hexes]
        if length(hex) == 1
            push!(out, "0" * hex)
        else
            push!(out, hex)    
        end
    end
    return join(out)
end

hex_to_bin(x) = string(parse(Int, x, base=16), base=2, pad=4)
function grid(input::Vector{Vector{Int64}})
    out = zeros(Int64, 128, 128)
    for (row_index, row) in enumerate(input)
        sequence = knot_hash(row)
        hash = dense_hash(sequence)
        out_row = []
        for char in hash
            char = parse.(Int, [split(hex_to_bin(char), "")...])    
            push!(out_row, char...)
        end
        out[row_index, :] = out_row
    end
    
    return out
end
@show sum(grid(input))

function adjacent_ones(grid, row, column)
    out = []
    if row > 1 && grid[row-1, column] == 1
        push!(out, (row-1, column))
    end
    if row < 128 && grid[row+1, column] == 1
        push!(out, (row+1, column))
    end
    if column > 1 && grid[row, column-1] == 1
        push!(out, (row, column-1))
    end
    if column < 128 && grid[row, column+1] == 1
        push!(out, (row, column+1))
    end 
    return out
end

function find_region(grid, row, column)
    region = Set([(row, column)])
    candidates = Set([(row, column)])
    explored = Set()
    while !isempty(candidates)
        candidate = pop!(candidates)
        push!(explored, candidate)
        for neighbor in adjacent_ones(grid, candidate[1], candidate[2])
            if neighbor ∉ region
                push!(region, neighbor)
                grid[neighbor[1], neighbor[2]] = 0
            end
            if neighbor ∉ explored
                push!(candidates, neighbor)
            end
        end
    end
    return grid
end

function count_regions(grid=grid(input))
    count = 0
    for row in 1:128
        for column in 1:128
            if grid[row, column] == 1
                count += 1
                grid = find_region(grid, row, column)
            end
        end
    end
    return count
end
@show count_regions()