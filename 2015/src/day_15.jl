# Day 15: Science for Hungry People
# https://adventofcode.com/2015/day/15

using Combinatorics

file_path = "2015/data/day_15.txt"

function clean_input(file_path) # read in the file and parse the integers
    ingredients = []
    for line in readlines(file_path)
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
    return ingredients # return the array of integers
end
@show input = clean_input(file_path)

function solve(input, part::Int=1, sum::Int=100)
    maximum_score = 0
    for i1 in 0:sum # loop through all possible combinations of ingredients
        for i2 in 0:sum # 
            for i3 in 0:sum
                i4 = sum - i1 - i2 - i3 # calculate the amount of the last ingredient
                if i4 >= 0 # if the amount is positive
                    capacity = i1 * input[1][2] + i2 * input[2][2] + i3 * input[3][2] + i4 * input[4][2] # calculate the capacity
                    durability = i1 * input[1][3] + i2 * input[2][3] + i3 * input[3][3] + i4 * input[4][3] # calculate the durability
                    flavor = i1 * input[1][4] + i2 * input[2][4] + i3 * input[3][4] + i4 * input[4][4] # calculate the flavor
                    texture = i1 * input[1][5] + i2 * input[2][5] + i3 * input[3][5] + i4 * input[4][5] # calculate the texture
                    calories = i1 * input[1][6] + i2 * input[2][6] + i3 * input[3][6] + i4 * input[4][6] # calculate the calories
                    if capacity > 0 && durability > 0 && flavor > 0 && texture > 0  && (part == 1 || calories == 500) # if all are positive and the calories are 500 or it's part 1            
                        score = capacity * durability * flavor * texture # calculate the score
                        if score > maximum_score # if the score is greater than the maximum score
                            maximum_score = score # set the maximum score to the score
                        end
                    end
                end
            end
        end
    end
    return maximum_score # return the maximum score
end
@info solve(input)
@info solve(input, 2)
