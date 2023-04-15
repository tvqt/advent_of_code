# Day 24: Air Duct Spelunking
# https://adventofcode.com/2016/day/24

using DelimitedFiles, AStarSearch, DataStructures


file_path = "2016/data/day_24.txt"

function clean_input(file_path=file_path)
    nums = string.(collect(0:9)) # ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9"]
    input = hcat(split.(readlines(file_path),"")...) # 2d array of chars
    return input .== "#", Dict(parse(Int, input[number]) => number for number in findall(x -> x in nums, input)) # maze, dict of numbers to their positions
end



function x_to_y(maze, start, goal, seen, 🥾📕) 
    start, goal = sort([start, goal]) # sort to make sure we don't have to check both orders
    [start, goal] ∉ keys(🥾📕) ? 🥾📕[[start, goal]] = astar(neighbours, start, goal) : nothing # 
    return 🥾📕[[start, goal]] # return the path from start to goal
end

function neighbours(current, maze=m)
    neighbs = [CartesianIndex(current.I[1]+1, current.I[2]), CartesianIndex(current.I[1]-1, current.I[2]), CartesianIndex(current.I[1], current.I[2]+1), CartesianIndex(current.I[1], current.I[2]-1)]
    # filter neighbs to ones which are in maze but are not walls
    return filter(x -> x.I[1] in 1:size(maze, 1) && x.I[2] in 1:size(maze, 2) && maze[x] == false, neighbs) 
end

m, d = clean_input()
function solve(maze, 🔢📕)
    📚 = Dict() # Dict of states to their cost
    start = 🔢📕[0] # save the starting position separately
    🚶🚶🚶 = PriorityQueue{Tuple, Int}((Set(), start)=> 0)
    🥾📕 = Dict()
    filter!(x -> x[1] != 0, 🔢📕) # remove the 0 (i.e. the start) from the dict
    p1, p2 = typemax(Int), typemax(Int)
    while !isempty(🚶🚶🚶)
        (👜🔢, 📍), 💸 = first(🚶🚶🚶)
        delete!(🚶🚶🚶, first(🚶🚶🚶)[1])
        if length(👜🔢) == length(🔢📕) # if we have collected all the numbers
        
            p2_cost = 💸 + x_to_y(maze, 📍, start, 📚, 🥾📕).cost # add the cost of going back to the start
        
            if 💸 < p1
                p1 = 💸 # update the p1 cost
            end
            if p2_cost < p2
                p2 = p2_cost # update the p2 cost
            end 
            continue
        end
        
        if (👜🔢, 📍) in keys(📚) && 💸 >= 📚[(👜🔢, 📍)] # if we have already been here and it was cheaper, then skip
            continue
        end
        
        📚[(👜🔢, 📍)] = 💸  # update the state history

        for (🔢, 🏁) in 🔢📕 # for number, goal in number book
        
            if 🔢 in 👜🔢 # check if we have already collected this number
                continue
            end
        
            🥾 = x_to_y(maze, 📍, 🏁, 📚, 🥾📕).cost + 💸 # path cost from current position to goal

            🆕🔑 = (push!(copy(👜🔢), 🔢), 🏁) # new key
            
            if 🥾 != 💸 && (🆕🔑 ∉ keys(📚) || 🥾 < 📚[🆕🔑]) # if we have not been here before or if this is a cheaper path
            
                if 🆕🔑 ∉ keys(🚶🚶🚶) # if newkey isn't in the queue
                    enqueue!(🚶🚶🚶, 🆕🔑 => 🥾) # add it to the queue
            
                elseif 🥾 < 🚶🚶🚶[🆕🔑] # if the new path is cheaper than the old one
                    🚶🚶🚶[🆕🔑] = 🥾 # update the queue
                end
            end
        end
    end
    return p1, p2
end

@show solve(m, d)
