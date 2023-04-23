# https://adventofcode.com/2018/day/22
using QuickHeaps

depth= 11109

target_input = 9,731
target = target_input .+ 1


function geologic_index(x, y, depth=depth, target=target)
    x == 0 && y == 0 && return 0
    x == target[1] && y == target[2] && return 0
    y == 0 && return x * 16807
    x == 0 && return y * 48271
    return erosion_level(x-1, y, depth) * erosion_level(x, y-1, depth)
end

erosion_history = Dict()
function erosion_level(x, y, depth=depth, target=target)
    if (x, y) in keys(erosion_history)
        return erosion_history[(x, y)]
    end
    return erosion_history[(x, y)] = (geologic_index(x, y, depth, target) + depth)  % 20183
end

function erosion_type(x, y, depth=depth, target=target)
    return erosion_level(x, y, depth, target) % 3
end

#@assert erosion_type(0, 0) == 0

grid(x, y, depth, target=target) = [erosion_type(x, y, depth, target) for x in 0:x, y in 0:y]

@show p1 = sum(grid(target[1], target[2], depth, target))

g = grid(target[1]+25, target[2]+25, depth, target) # add some padding

@assert g[target[1]+1, target[2]+1] == 0

# create a larger grid for part 2
#g = grid(target[1]+100, target[2]+100, depth, target)


function neighbours(state::Tuple{Int, Int, String}, grid=g)::Vector{Tuple{Int, Int, String}}
    x, y, gear = state
    out::Vector{Tuple{Int, Int, String}} = []
    # add gear changes
    if g[x, y] == 0 # rocky
        push!(out, (x, y, setdiff(["climbing gear", "torch"], [gear])[1]))
    elseif g[x, y] == 1 # wet
        push!(out, (x, y, setdiff(["climbing gear", "neither"], [gear])[1]))
    elseif g[x, y] == 2 # narrow
        push!(out, (x, y, setdiff(["torch", "neither"], [gear])[1]))
    end
    neighbs = [(x, y+1), (x+1, y), (x-1, y), (x, y-1)]

    for n in neighbs
        if n[1] > 0 && n[2] > 0 && n[1] <= size(g)[1] && n[2] <= size(g)[2]
            if g[n[1], n[2]] == 0 # rocky
                if gear ∈ ["climbing gear", "torch"]
                    push!(out, (n[1], n[2], gear))
                end
            elseif g[n[1], n[2]] == 1 # wet
                if gear ∈ ["climbing gear", "neither"]
                    push!(out, (n[1], n[2], gear))
                end
            elseif g[n[1], n[2]] == 2 # narrow
                if gear ∈ ["torch", "neither"]
                    push!(out, (n[1], n[2], gear))
                end
            end
        end
    end
    return out
end

function hikecost(a, b)
    if a[3] == b[3]
        return 1
    else
        return 7
    end
end

start = 1, 1, "torch"
goal = target[1], target[2], "torch"


function heuristic(state::Tuple{Int, Int, String})::Int
    return abs(state[1] - goal[1]) + abs(state[2] - goal[2])
end


function hike()
    frontier = PriorityQueue{Tuple{Int, Int, String}, Int}()
    frontier[start] = 0
    came_from = Dict{Tuple{Int, Int, String}, Union{Nothing, Tuple{Int, Int, String}}}()
    cost_so_far = Dict{Tuple{Int, Int, String}, Int}()
    came_from[start] = nothing
    cost_so_far[start] = 0
    best = typemax(Inf)

    while !isempty(frontier)
        current, _ = pop!(frontier)
        if current == goal
            return cost_so_far[current]
        end

        for next in neighbours(current)
            new_cost = cost_so_far[current] + hikecost(current, next)
            if next ∉ keys(cost_so_far) || new_cost < cost_so_far[next]
                cost_so_far[next] = new_cost 
                frontier[next] = new_cost + heuristic(next)
                came_from[next] = current
            end
        end
    end
    
end

@show hike() 
