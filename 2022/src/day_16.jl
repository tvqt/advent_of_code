# Day 16: Proboscidea Volcanium
# https://adventofcode.com/2022/day/16
using AStarSearch, DataStructures

file_path = "2022/data/day_16.txt"

function clean_input(file_path=file_path)::Tuple{Dict{String, Int}, Dict{String, Vector{String}}}
    valves = Dict()
    tunnels = Dict()
    for line in readlines(file_path)
        name, flow_rate, leads_to = match(r"Valve (\w+) has flow rate=(\d+); tunnels? leads? to valves? (.*)", line).captures
        tunnels[name] = split(leads_to, ", ")
        if parse(Int, flow_rate) != 0
            valves[name] = parse(Int, flow_rate)
        end
    end
    return valves, tunnels
end
valves, tunnels = clean_input()

function find_path!(start, goal, new_dict, valves=valves, tunnels=tunnels)
    start, goal = sort([start, goal])
    if [start, goal] in keys(new_dict)
        return new_dict[[start, goal]]
    else
        new_dict[[start, goal]] = astar(neighbours, start, goal).cost
        return new_dict[[start, goal]]
    end
end


neighbours(node, tunnels=tunnels) = tunnels[node]

function new_tunnel_dict(tunnels=tunnels, valves=valves)
    new_dict = Dict()
    for start in keys(valves)
        for goal in keys(valves)
            if start != goal
                find_path!(start, goal, new_dict)
            end
        end
    end
    return new_dict
end
tunnels = new_tunnel_dict()

function solve(tunnels=tunnels, valves=valves)
    max_released = 0
    👀 = Dict()
    🚶🚶🚶 = PriorityQueue{Tuple{Set, }, Int, Base.Order.ReverseOrdering}()
    while !isempty(🚶🚶🚶)
        # get the first item from the queue
        (visited, 📍, 🕒), 💨rate = first(🚶🚶🚶)
        delete!(🚶🚶🚶, first(keys(🚶🚶🚶)))
        
        # if we've visited all the valves, or if the shortest path from here to an unvisited node is longer than the remaining time, we're done
        if length(visited) == length(valves)  || min([find_path!(📍, unvisited, tunnels) for unvisited in setdiff(keys(valves), visited)]) + 🕒 >= 29
            # figure out how much we would release from now until the end
            remaining_time = 30 - 🕒
            max_released = max(max_released, total💨 + (remaining_time * 💨rate))
            continue
        end
        
        # if 📍 not in visited, then add turning that valve on to the queue
        if 📍 ∉ visited  && (vcat(copy(visited), 📍) 📍, 🕒 + 1) ∉ keys(👀) || 👀[(vcat(copy(visited), 📍) 📍, 🕒 + 1)] <
            new_rate = 💨rate + valves[📍]
            new_total💨 = total💨 + 💨rate
            if (new_visited, 📍) ∉ keys(👀) || new_time < 👀[(new_visited, 📍)][1]
                👀[(new_visited, 📍)] = (new_time, new_total💨)
                enqueue!(🚶🚶🚶, (new_visited, 📍), 🕒 + 1)
            end
        end


        for 🥾 in neighbours(📍)
            if 🥾 ∉ visited
                new_visited = vcat(copy(visited), 🥾)
                new_time = 🕒 + tunnels[sort([📍, 🥾])]
                new_rate = 💨rate + valves[🥾]

            end

            
        end
        
        
    end
end

