# https://adventofcode.com/2015/day/15
using Combinatorics
file_path = "2015/data/day_15.txt"

function clean_input(file_path)
    ingredients = []
    for line in readlines(file_path)
        # example line
        # Butterscotch: capacity -1, durability -2, flavor 6, texture 3, calories 8
        line = match(r"(\w+): capacity (-?\d+), durability (-?\d+), flavor (-?\d+), texture (-?\d+), calories (-?\d+)", line).captures
        name = line[1]
        capacity = parse(Int, line[2])
        durability = parse(Int, line[3])
        flavor = parse(Int, line[4])
        texture = parse(Int, line[5])
        calories = parse(Int, line[6])
        out = (name, capacity, durability, flavor, texture, calories)
        push!(ingredients, out)
    end
    return ingredients
end
@show input = clean_input(file_path)

function solve(input, part::Int=1, sum::Int=100)
    maximum_score = 0
    for i1 in 0:sum
        for i2 in 0:sum
            for i3 in 0:sum
                i4 = sum - i1 - i2 - i3
                if i4 >= 0
                    capacity = i1 * input[1][2] + i2 * input[2][2] + i3 * input[3][2] + i4 * input[4][2]
                    durability = i1 * input[1][3] + i2 * input[2][3] + i3 * input[3][3] + i4 * input[4][3]
                    flavor = i1 * input[1][4] + i2 * input[2][4] + i3 * input[3][4] + i4 * input[4][4]
                    texture = i1 * input[1][5] + i2 * input[2][5] + i3 * input[3][5] + i4 * input[4][5]
                    calories = i1 * input[1][6] + i2 * input[2][6] + i3 * input[3][6] + i4 * input[4][6]
                    if capacity > 0 && durability > 0 && flavor > 0 && texture > 0  && (part == 1 || calories == 500)                   
                        score = capacity * durability * flavor * texture
                        if score > maximum_score 
                            maximum_score = score
                        end
                    end
                end
            end
        end
    end
    return maximum_score
end
@info solve(input)


@info solve(input, 2)
