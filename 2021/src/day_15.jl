# https://adventofcode.com/2021/day/15

using AStarSearch

file_path = "2021/data/day_15.txt"


function clean_input(file_path=file_path)
    dim = length(readline(file_path))
    out = zeros(Int, dim, dim)
    for (i, line) in enumerate(eachline(file_path))
        for (j, char) in enumerate(line)
            out[i, j] = parse(Int, char)
        end
    end
    return out
end
input = clean_input()

function neighbours(coords, input=input)
    neighbs = [CartesianIndex(coords[1]-1, coords[2]), CartesianIndex(coords[1]+1, coords[2]), CartesianIndex(coords[1], coords[2]-1), CartesianIndex(coords[1], coords[2]+1)]
    return filter(x -> x[1] > 0 && x[2] > 0 && x[1] <= size(input)[1] && x[2] <= size(input)[2], neighbs)
end



function cost_(a, b)
    return input[b]
end

start = CartesianIndex(1, 1)
goal = CartesianIndex(size(input)[1], size(input)[2])
@show astar(neighbours, start, goal, cost=cost_).cost


function big_map(input)
    new = input
    dim = size(input)[1]
    x, y = 1, 1
    out = zeros(Int, 5dim, 5dim)
    # change 10s to 0s
    for i in 0:4
        for j in 0:4
            println("$i, $j, $([(j)dim+1:(j+1)dim, (i)dim+1:(i+1)dim])")
            new = (input .+ (i + j))
            # if a number equals 10, change it to 1
            new[new .>= 10] .-= 9
            display(new)
            out[(j)dim+1:(j+1)dim, (i)dim+1:(i+1)dim] = new
        end
    end
    return out
end

input =  big_map(input)
new_goal = CartesianIndex(size(input)[1], size(input)[2])
@show astar(neighbours, start, new_goal, cost=cost_).cost


6444961841755517295286
6444961841755517195186