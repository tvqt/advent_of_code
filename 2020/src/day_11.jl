# Day 11: Seating System
# https://adventofcode.com/2020/day/11

file_path = "2020/data/day_11.txt"

function clean_input(file_path=file_path)
    # create a matrix of 0s the size of the input
    matrix = zeros(Int, length(readlines(file_path)[1]),length(readlines(file_path)))
    for (i, line) in enumerate(readlines(file_path)) # for each row
        for (j, char) in enumerate(line) # for each column
            if char == '#' # if the seat is occupied
                matrix[j,i] = 1
            elseif char == '.' # if the seat is floor
                matrix[j, i] = -99
            end # if the seat is empty, it will remain 0
        end
    end
    return matrix # return the matrix
end

function neighbours(matrix, i, j, part1=true)
    # return the number of occupied seats around the seat at (i,j)
    n = 0
    directions = collect(CartesianIndices((-1:1, -1:1))) # all the directions around the seat, including diagonals
    for dir in directions
        if dir[1] == 0 && dir[2] == 0 # if the direction is the seat itself,
            continue
        else
            n += check_direction(matrix, i, j, dir, part1) # check if the seat in that direction is occupied
        end
    end
    return n
end

function check_direction(matrix, i, j, carts, part1=true)
    di, dj = i+carts[1], j + carts[2] # add the direction to the seat
    if part1 
        if di in 1:size(matrix,1) && dj in 1:size(matrix,2) && matrix[di, dj] == 1 # if the seat is in the matrix and is occupied and we're in part 1
            return true
        else
            return false
        end
    end

    while di in 1:size(matrix,1) && dj in 1:size(matrix,2) # while the seat is in the matrix
        if matrix[di, dj] == 1 # if di,dj is a seat that is occupied
            return true
        elseif matrix[di, dj] == 0 # if di,dj is a seat that is empty
            return false
        end
        di, dj = di+carts[1], dj + carts[2] # if di,dj is a floor, keep going in that direction
    end
    return false # if we get to the end of the matrix, return false
end

empty_rule(matrix, i, j, part1=true) = neighbours(matrix, i, j, part1) == 0 ? 1 : matrix[i,j] # if a seat is empty (L) and there are no occupied seats adjacent to it, the seat becomes occupied.
occupied_rule(matrix, i, j, neighbs=4, part1=true) = neighbours(matrix, i, j, part1) >= neighbs ? 0 : matrix[i,j] # if a seat is occupied (#) and four or more seats adjacent to it are also occupied, the seat becomes empty.
apply_rules(matrix, i, j, neighbs=4, part1=true) = matrix[i,j] == 0 ? empty_rule(matrix, i, j, part1) : occupied_rule(matrix, i, j, neighbs, part1) # apply the rules to the seat at (i,j), depending on whether it is occupied or not occupied.

function solve(part1=true,input=clean_input())
    # return the number of occupied seats after the seating stabilises
    matrix = copy(input)
    neighbs = part1 ? 4 : 5
    while true
        new_matrix = copy(matrix)
        for i in axes(matrix,1)
            for j in axes(matrix,2)
                if matrix[i,j] != -99
                    new_matrix[i,j] = apply_rules(matrix, i, j, neighbs, part1)
                end
            end
        end
        if new_matrix == matrix
            return sum(new_matrix .== 1)
        end
        matrix = copy(new_matrix)
    end
end
@show solve()
@show solve(false)



    

