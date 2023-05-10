# Day 19: Robot Blueprint
# https://adventofcode.com/2022/day/19
# I tried out a couple of other people's solutions after completing mine, and they were significantly faster than mine. Not entirely sure why. One used recursion and multithreading, the other cut the search space at an arbitrary point, which I'm guessing is the main reason for the speedup. Either that, or I'm just bad at Julia lol
# a few potential speedups: 1. multithreading, 2. switching the vectors to be arrays/tuples, 3. adding types to everything, 4. creating a dictionary of the minutes it takes to get from one state to another, so that analagous states don't have to be recalculated, 5. using a different data structure for the queue, 6. using a different heuristic function, 7. using a different algorithm entirely

using QuickHeaps

file_path = "2022/data/day_19.txt"
clean_input(file_path=file_path) = [parse.(Int, match(r"Blueprint (\d+): Each ore robot costs (\d+) ore. Each clay robot costs (\d+) ore. Each obsidian robot costs (\d+) ore and (\d+) clay. Each geode robot costs (\d+) ore and (\d+) obsidian.", line).captures) for line in readlines(file_path)] # 4-tuple: (id, ore, clay_ore, obsidian_ore, obsidian_clay, geode_ore, geode_obsidian)
heuristic(resources, robots, time, time_limit=24) = resources[4] + ((time_limit-time) * robots[4]) + sum(1:time_limit-time) # heuristic function borrowed from Reddit: the amount of geodes we have right now, plus the amount of geodes we will mine in the remaining time with the geode robots we currently have, plus the amount of geodes we will mine if we buy a geode robot every minute until the end


function solve(part_1=true, blueprints=clean_input(), time=0) # algorithm which is vaguely similar to A*
    resources, robots = [0, 0, 0, 0], [1, 0, 0, 0]
    time_limit = part_1 ? 24 : 32
    blueprints = part_1 ? blueprints : blueprints[1:3] # only the first 3 blueprints are needed for part 2

    queue = PriorityQueue{Tuple{Int64, Vector{Int64}, Vector{Int64}}, Int64}() # queue of unchecked states, sorted by the heuristic
    seen = Dict{Tuple{Int64, Vector{Int64}, Vector{Int64}}, Int64}() # dictionary of checked states, with the time it took to reach them as the value
    for blueprint in eachindex(blueprints) # add the starting state to the queue, and seen dictionary
        seen[blueprint, copy(resources), copy(robots)] = 0
        queue[blueprint, copy(resources), copy(robots)] = heuristic(resources, robots, time, time_limit)
    end
    best = [0 for i in eachindex(blueprints)] # best[i] is the best amount of geodes we can get from blueprint i
    while !isempty( queue)
        (b, r, o), _ = pop!(queue) # b is the *B*lueprint id, r is the *R*esources, o is the r*O*bots
        time = seen[b, r, o]
        if time == time_limit # if we've reached the time limit, we can't buy any more robots, so we can't get any more geodes
            best[b] = max(best[b], r[end]) # update the best amount of geodes we can get from blueprint b
        end
        options = ops(blueprints[b], r, o, time, time_limit) # get all possible next states

        for (new_resources, new_robots, new_time) in options
            if (b, new_resources, new_robots) ∉ keys(seen) || seen[b, new_resources, new_robots] > new_time # if we haven't seen this state before, or we've seen it before but it took longer to reach it, add it to the queue and seen dictionary
                new_heur = heuristic(new_resources, new_robots, new_time, time_limit) # 
                new_heur < best[b] && continue # if the heuristic estimate is worse than the best amount of geodes we can get from blueprint b, don't add it to the queue
                queue[b, new_resources, new_robots] = new_heur
                seen[b, new_resources, new_robots] = new_time
            end
        end
    end
    
    return part_1 ? sum([x * i for (i, x) in enumerate(best)]) : prod(best) # return the sum of the best amount of geodes we can get from each blueprint, or the product of the best amount of geodes we can get from each blueprint, depending on the part
end


function ops(b, r, o, t, time_limit)
    t == time_limit && return [] # if we've reached the time limit, we can't buy any more robots, so we can't get any more geodes
    out = []
    new_o, new_r = copy(o), copy(r)
    diff =  convert(Int, max(ceil((b[2] - r[1])/o[1]), 0)) # the number of minutes it will take to get enough ore to buy an ore robot, rounded up, or 0 if we already have enough ore
    new_t = t + diff + 1 
    if new_t < time_limit && new_o[1] < max(b[2], b[3], b[4], b[6]) # if we haven't reached the time limit, and the ore needed per minute is larger than the number of ore robots we have, then we can buy an ore robot
        new_o[1] += 1
        [new_r[i]+= o[i] * (diff +1) for i in eachindex(r)]
        new_r[1] -= b[2]
        push!(out, [new_r, new_o, new_t])
    end
    
    new_o, new_r = copy(o), copy(r)
    diff =  convert(Int, max(ceil((b[3] - r[1])/o[1]), 0))
    new_t = t + diff + 1
    if new_t < time_limit && new_o[2] < b[5]
        new_o[2] += 1
        [new_r[i]+= o[i] * (diff+1) for i in eachindex(r)]
        new_r[1] -= b[3]
        push!(out, [new_r, new_o, new_t])
    end
    if o[2] != 0
        new_o, new_r = copy(o), copy(r)
        diff = convert(Int, max(ceil((b[4] - r[1])/o[1]), ceil((b[5] - r[2])/o[2]), 0))
        new_t = t + diff + 1
        if new_t < time_limit && new_o[3] < b[7]
            new_o[3] += 1
            [new_r[i]+= o[i] * (diff + 1) for i in eachindex(r)]
            new_r[2] -= b[5]
            new_r[1] -= b[4]
            push!(out, [new_r, new_o, new_t])
        end
        if o[3] != 0
            new_o, new_r = copy(o), copy(r)
            diff = max(ceil((b[6] - r[1])/o[1]), ceil((b[7] - r[3])/o[3]), 0)
            new_t = t + diff + 1
            if new_t < time_limit
                new_o[4] += 1
                [new_r[i]+= o[i] * (diff + 1) for i in eachindex(r)]
                new_r[3] -= b[7]
                new_r[1] -= b[6]
                push!(out, [new_r, new_o, new_t])
            end
            if o[4] != 0
                new_o, new_r = copy(o), copy(r)
                diff = time_limit - t
                [new_r[i]+= o[i] * diff for i in eachindex(r)]
                push!(out, [new_r, new_o, time_limit])
            end

        end
    end
    return out
end

@show solve()
@show solve(false)