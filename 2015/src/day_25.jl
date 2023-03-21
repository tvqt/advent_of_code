# https://adventofcode.com/2015/day/25
# Day 25: Let It Snow

function solve()
    codes = Dict(CartesianIndex(1, 1) => 20151125) # initialize the dictionary
    row, col = 2, 1
    next_value(n) = (n * 252533) % 33554393 # function to calculate the next value
    prev_coords = CartesianIndex(1, 1)
    while true
        codes[CartesianIndex(row, col)] = next_value(codes[prev_coords]) # calculate the next value
        if row == 2978 && col == 3083 # if we've reached the end
            return codes[CartesianIndex(row, col)] # return the value
        end
        prev_coords = CartesianIndex(row, col) # update the previous coordinate pair
        
        # update the current coordinate pair, according to the following rules
        if row == 1 
            row = col + 1
            col = 1
        else
            row -= 1
            col += 1
        end
    end
end

@show solve()