# https://adventofcode.com/2019/day/10
file_path = "2019/data/day_10.txt"
using StatsBase

function clean_input(file_path)
    # create a matrix of the same size as the input
    # fill it with 0
    # replace 0 with 1 if the corresponding input is a #
    # return the matrix
    input = readlines(file_path)
    grid = Dict()
   
    for (y, line) in enumerate(input)
        for (x, char) in enumerate(line)
            grid[CartesianIndex(x, y)] = char
        end
    end
    return grid
end
input = clean_input(file_path)

function angle_(cx::Int, cy::Int, x::Int, y::Int)::Tuple{Int,Int} # returns the shift in x and shift in y to get from (cx, cy) to the point (x, y)
    dx, dy = x - cx,  y - cy
    return (dx == 0 ? 0 : dx / gcd(dx, dy)), (dy == 0 ? 0 : dy / gcd(dx, dy))
end

function raytrace(cx::Int, cy::Int, dx::Int, dy::Int, input) # finds the first asteroid in the direction of (dx, dy) from (cx, cy) if it exists, else nothing
    x, y = cx + dx, cy + dy 
    while x in 1:maximum(keys(input))[1] && y in 1:maximum(keys(input))[2]
        if input[CartesianIndex(x, y)] == '#'
            return CartesianIndex(x, y)
        end
        x += dx
        y += dy
    end
    return nothing
end


function part_1(input)
    mins, maxs =  extrema(keys(input))


    function seen_asteroids(cx::Int, cy::Int ) # returns the number of asteroids that can be seen from (cx, cy)
        seen = Set()
        for (k, v) in input
            if k != CartesianIndex(cx, cy) && v == '#'
                dx, dy = angle_(cx, cy, k[1], k[2])
                ray = raytrace(cx, cy, dx, dy, input)
                if ray !== nothing
                    push!(seen, ray)
                end
            end
        end
        return seen
    end

    max_seen = 0
    best_asteroid = CartesianIndex(0, 0)
    for (k, v) in input
        if v == '#'
            seen = seen_asteroids(k[1], k[2])
            #println("seen: $(length(seen)) at $k")
            #for s in seen
            #    println("____ $k sees: $s")
            #end
            if length(seen) > max_seen
                max_seen = length(seen)
                best_asteroid = k
            end
        end
    end
    return best_asteroid, max_seen
end
best_asteroid, p1, = part_1(input)

function rotate_path(input, best_asteroid=best_asteroid)
    angles = Set()
    for (k, v) in input
        push!(angles, angle_(best_asteroid[1], best_asteroid[2], k[1], k[2]))
    end
    north = (0, -1)
    q1 = sort(filter(x -> x[1] > 0 && x[2] < 0, collect(angles)), by = x -> atan(x[2], x[1]))
    east = (1, 0)
    q2 = sort(filter(x -> x[1] > 0 && x[2] > 0, collect(angles)), by = x -> atan(x[2], x[1]))
    q3 = sort(filter(x -> x[1] <= 0 && x[2] > 0, collect(angles)), by = x -> atan(x[2], x[1]))
    west = (-1, 0)
    q4 = sort(filter(x -> x[1] < 0 && x[2] < 0, collect(angles)), by = x -> atan(x[2], x[1]))
    
    return vcat(north, q1, east, q2, q3, west, q4)
end

function part_2(input, best_asteroid=best_asteroid)
    path = rotate_path(input, best_asteroid)
    destroyed = 0
    i = 1
    # find the duplicate in path
    ray = nothing


    while destroyed < 200
        dx, dy = path[i]
        ray = raytrace(best_asteroid[1], best_asteroid[2], dx, dy, input)
        if ray !== nothing
            input[ray] = '.'
            destroyed += 1
        end
        i = i % length(path) + 1 
    end
    answer = ray - CartesianIndex(1, 1)
    return answer[1] * 100 + answer[2]
end
@show p1
@show part_2(input)