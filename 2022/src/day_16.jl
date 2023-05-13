# Day 16: Proboscidea Volcanium
# https://adventofcode.com/2022/day/16
using AStarSearch, QuickHeaps

file_path = "2022/data/day_16.txt"

function clean_input(file_path=file_path)::Tuple{Dict{String, Int}, Dict{String, Vector{String}}}
    valves = Dict() # initialise empty dictionary
    tunnels = Dict()
    for line in readlines(file_path)
        name, flow_rate, leads_to = match(r"Valve (\w+) has flow rate=(\d+); tunnels? leads? to valves? (.*)", line).captures # parse line
        tunnels[name] = split(leads_to, ", ") # split the list of tunnels into a vector
        if parse(Int, flow_rate) != 0 # if the flow rate is not zero, add it to the valves dictionary
            valves[name] = parse(Int, flow_rate)
        end
    end
    return valves, tunnels
end
valves, tunnels = clean_input()

function find_path!(start, goal, out, valves=valves, tunnels=tunnels)
    [out[k] = k in keys(out) ? out[k] : Dict() for k in [start, goal]]  # initialise empty dictionary values for start and goal if they don't exist as keys in out, yet, otherwise do nothing
    astar_ = astar(neighbours, start, goal)                             # find shortest path from start to goal
    path = Set(intersect(astar_.path[2:end-1], keys(valves)))           # find all the valves in the path that are not the start or goal which release pressure. We don't want to go past an unopened valve with a flow rate that is larger than zero
    out[start][goal] = path, astar_.cost                                # add the path and cost from start to goal to the out dictionary
    if start != "AA"                                                    # we don't want to return to the initial starting place, "AA", so we check if start is not "AA". If not, we add the path and cost from goal to start to the out dictionary
        out[goal][start] = path, astar_.cost
    end
end


neighbours(node, tunnels=tunnels) = tunnels[node]
function new_tunnel_dict(valves=valves, tunnels=tunnels) 
    out = Dict()
    for start in union(keys(valves), ["AA"])
        for goal in keys(valves)
            if start != goal
                find_path!(start, goal, out) # for each valve, find the shortest path to each other valve
            end
        end
    end
    return out
end

tunnels = new_tunnel_dict()

heuristic(released_pressure, opened_valves, remaining_time) = released_pressure + (length(opened_valves)*remaining_time*100) + (sum(1:remaining_time)*100) # equal to the pressure released so far, plus the number of open valves mulitplied by ten times the remaining_time, plus the sum of one to `remaining_time` multiplied by ten
#heuristic(opened_valves, valves) = mean([v for (k, v) in valves if k ∈ opened_valves])
function solve(part_1=true, tunnels=tunnels, valves=valves)
    time_limit= part_1 ? 30 : 24
    queue = PriorityQueue{Tuple{Set,String,Int64}, Int}(Base.Order.Reverse)
    queue[Set(), "AA", 0] = 0  
    seen = Dict((Set(), "AA", 0) => (0,0))
    finished_ones = Dict()
    
    while true
        best = 0
        while !isempty(queue)
            (opened_valves, pos, time), _ = pop!(queue)
            released_pressure, fpm = seen[opened_valves, pos, time]
            if time == time_limit
                best = max(best, released_pressure)
                continue
                if !part_1
                    finished_ones[opened_valves] = released_pressure
                end
            end
            unopened_valves = setdiff(keys(valves), opened_valves)
            no_more = true
            for neighbour in unopened_valves ∩ keys(tunnels[pos])
                path, travel_time = tunnels[pos][neighbour]
                new_time = time + travel_time + 1
                new_pressure = released_pressure + (fpm*(travel_time+1))
                new_opened_valves = union(copy(opened_valves), [neighbour])
                new_heuristic = heuristic(new_pressure, new_opened_valves, time_limit-new_time)
                if new_time >= time_limit
                    continue
                end
                if (new_opened_valves, neighbour, new_time) ∉ keys(seen) || seen[new_opened_valves, neighbour, new_time][1] < new_pressure
                    queue[new_opened_valves, neighbour, new_time] = new_heuristic
                    seen[new_opened_valves, neighbour, new_time] = new_pressure, fpm+valves[neighbour]
                end
            end
            if !part_1 || no_more
                released_pressure = released_pressure + (fpm*(time_limit - time))
                if released_pressure > best
                    println("$released_pressure, $(length(queue))")
                end
                best = max(best, released_pressure)
                if !part_1 
                    finished_ones[opened_valves] = released_pressure
                end
            end
        end
        if part_1
            return best
        else
            println("here!!")
            best = 0
            for (opened_valves, released_pressure) in finished_ones
                for (other_valves, other_pressure) in finished_ones
                    if opened_valves ∩ other_valves == Set()
                        best = max(best, released_pressure + other_pressure)
                    end
                end
            end
            return best
        end
    end
end
#@show solve()
@show solve(false)
