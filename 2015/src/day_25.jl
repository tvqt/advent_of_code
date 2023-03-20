# https://adventofcode.com/2015/day/25
# Day 25: Let It Snow

function solve()
    codes = Dict(CartesianIndex(1, 1) => 20151125)
    row, col = 2, 1
    next_value(n) = (n * 252533) % 33554393
    prev_coords = CartesianIndex(1, 1)
    while true
        codes[CartesianIndex(row, col)] = next_value(codes[prev_coords])
        if row == 2978 && col == 3083
            return codes[CartesianIndex(row, col)]
        end
        prev_coords = CartesianIndex(row, col)
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