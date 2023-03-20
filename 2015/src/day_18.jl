# https://adventofcode.com/2015/day/18

file_path = "2015/data/day_18.txt"

function clean_input(file_path)
    out = zeros(Bool, length(readlines(file_path)), length(readlines(file_path)[1]))
    for (l_n, line) in enumerate(readlines(file_path))
        line = split(line, "")
        for i in eachindex(line)
            if line[i] == "#"
                out[l_n,i] = true
            end
        end
    end
    return out
end
input = clean_input(file_path)

function sum_of_neighbours(matrix, row, column)
    out = 0
    # get neighbours of matrix[row, column]
    # if they are true, add 1 to out
    for i in -1:1
        for j in -1:1
            if i == 0 && j == 0
                continue
            end
            if row + i > 0 && row + i <= size(matrix, 1) && column + j > 0 && column + j <= size(matrix, 2)
                if matrix[row + i, column + j]
                    out += 1
                end
            end
        end
    end
    return out
end
function update_matrix(matrix, part::Int=1)
    # loop through matrix
    # if matrix[row, column] is true and sum_of_neighbours(matrix, row, column) is not 2 or 3, set matrix[row, column] to false
    # if matrix[row, column] is false and sum_of_neighbours(matrix, row, column) is 3, set matrix[row, column] to true
    out = copy(matrix)
    for row in 1:size(matrix, 1)
        for column in 1:size(matrix, 2)
            if part == 2 && (row == 1 && column == 1  || row == 1 && column == size(matrix, 2)|| row == size(matrix, 1) && column == 1 || row == size(matrix, 1) && column == size(matrix, 2))
                out[row, column] = true
                print(row, " ", column, "\n")
            elseif matrix[row, column]
                if sum_of_neighbours(matrix, row, column) != 2 && sum_of_neighbours(matrix, row, column) != 3
                    out[row, column] = false
                end
            
            else
                if sum_of_neighbours(matrix, row, column) == 3
                    out[row, column] = true
                end
            end
        end
    end
    return out
end
function solve(input, part::Int=1, steps::Int=100)
    matrix = copy(input)
    for i in 1:steps
        matrix = update_matrix(matrix,part)
    end
    return sum(matrix)
end
display(solve(input, 2, 100))