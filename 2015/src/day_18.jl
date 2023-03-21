# Day 18: Like a GIF For Your Yard
# https://adventofcode.com/2015/day/18

file_path = "2015/data/day_18.txt"

function clean_input(file_path)
    out = zeros(Bool, length(readlines(file_path)), length(readlines(file_path)[1])) # create a matrix of the same size as the input
    for (l_n, line) in enumerate(readlines(file_path)) # loop through each line
        line = split(line, "") # split each line into an array of characters
        for i in eachindex(line)
            if line[i] == "#" # if the character is a #, set the corresponding matrix element to true
                out[l_n,i] = true
            end
        end
    end
    return out # return the matrix
end
input = clean_input(file_path)

function sum_of_neighbours(matrix, row, column)
    out = 0 # initialise the output
    for i in -1:1 # loop through the 3x3 matrix around the current element
        for j in -1:1
            if i == 0 && j == 0 # if the current element is the same as the current element,
                continue # skip to the next iteration of the loop
            end
            if row + i > 0 && row + i <= size(matrix, 1) && column + j > 0 && column + j <= size(matrix, 2) # if the element is within the bounds of the matrix
                if matrix[row + i, column + j] # if the element is true
                    out += 1 # add 1 to the output
                end
            end
        end
    end
    return out # return the output
end
function update_matrix(matrix, part::Int=1)
    # loop through matrix
    # if matrix[row, column] is true and sum_of_neighbours(matrix, row, column) is not 2 or 3, set matrix[row, column] to false
    # if matrix[row, column] is false and sum_of_neighbours(matrix, row, column) is 3, set matrix[row, column] to true
    out = copy(matrix)
    for row in 1:size(matrix, 1) # loop through each row in the matrix
        for column in 1:size(matrix, 2) # loop through each column in the matrix
            if part == 2 && (row == 1 && column == 1  || row == 1 && column == size(matrix, 2)|| row == size(matrix, 1) && column == 1 || row == size(matrix, 1) && column == size(matrix, 2)) # if part 2 and the current element is a corner
                out[row, column] = true # set the current element to true
            elseif matrix[row, column] # if the current element is true
                if sum_of_neighbours(matrix, row, column) != 2 && sum_of_neighbours(matrix, row, column) != 3 # if the sum of the neighbours is not 2 or 3
                    out[row, column] = false # set the current element to false
                end
            
            else
                if sum_of_neighbours(matrix, row, column) == 3 # if the sum of the neighbours is 3
                    out[row, column] = true # set the current element to true
                end
            end
        end
    end
    return out # return the updated matrix
end
function solve(input, part::Int=1, steps::Int=100)
    matrix = copy(input) # copy the input matrix
    for i in 1:steps # loop through the number of steps
        matrix = update_matrix(matrix,part) # update the matrix
    end
    return sum(matrix) # return the sum of the matrix
end
@show solve(input, 1)
@show solve(input, 2)