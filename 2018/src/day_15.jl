# https://adventofcode.com/2018/day/15

using QuickHeaps, Base

file_path = "2018/data/day_15.txt"

function clean_input(f=file_path)
    input = permutedims(hcat(split.(readlines(f), "")...))
    goblin, elf = Dict(), Dict()
    for coord in CartesianIndices(input)
        if input[coord] == "G"
            goblin[coord] = 200
        elseif input[coord] == "E"
            elf[coord] = 200
        end
    end
    return input .== "#", goblin, elf
end

function neighbours(c::CartesianIndex, friend)
    ns = [c + CartesianIndex(-1, 0), c + CartesianIndex(0, -1), c + CartesianIndex(0, 1), c + CartesianIndex(1, 0)]
    return filter(x -> x[1] > 0 && x[1] <= size(grid, 1) && x[2] > 0 && x[2] <= size(grid, 2) && grid[x] == false && x ∉ keys(friend), ns)
end

function take_action(c::CartesianIndex, friend, enemy, elf_attack, elf_coords)
    attacked, friend, enemy = attack_enemy(friend, enemy, c, elf_attack, elf_coords)
    if !attacked
        new_coords = move_to_enemy(c, friend, enemy)
        if new_coords === nothing
            return friend, enemy
        end
        friend[new_coords] = friend[c]
        delete!(friend, c)
        _, friend, enemy = attack_enemy(friend, enemy, new_coords, elf_attack, elf_coords)
    end
    return friend, enemy
end

function attack_enemy(friend, enemy, c, elf_attack, elf_coords)
    neighbs = neighbours(c, friend)
    neighbs = filter(x -> x in keys(enemy), neighbs)
    if !isempty(neighbs) # we have an enemy we can attack
        if length(neighbs) == 1
            enemy_coords = neighbs[1]
        else
            # find the enemy(ies?) with the lowest hp
            min_hp = minimum([enemy[x] for x in neighbs])
            neighbs = filter(x -> enemy[x] == min_hp, neighbs)
            if length(neighbs) == 1
                enemy_coords = neighbs[1]
            else
                enemy_coords = sort(neighbs, by= x ->(x[1], x[2]))[1]
            end
        end
        if enemy_coords ∈ elf_coords
            enemy[enemy_coords] -= elf_attack
        else
            enemy[enemy_coords] -= 3
        end
        if enemy[enemy_coords] <= 0
            delete!(enemy, enemy_coords)
        end
        return true, friend, enemy
    else
        return false, friend, enemy
    end
end

function move_to_enemy(start::CartesianIndex, friend, enemy)
    best = typemax(Int)
    c = start
    out = []
    frontier = PriorityQueue{CartesianIndex, Int}()
    frontier[c] = 0
    seen = Dict()
    seen[c] = 0
    came_from = Dict()
    
    while !isempty(frontier)
        c, cost = pop!(frontier)
        cost > best && continue
        for next in neighbours(c, friend)
            if next in keys(enemy)
                if cost + 1 < best
                    best = cost + 1
                    out = [next]
                    came_from[next] = c
                elseif cost + 1 == best
                    if next ∉ out
                        push!(out, next)
                        came_from[next] = c
                    else
                        came_from[next] = sort([came_from[next], c], by= x ->(x[1], x[2]))[1]
                    end
                end
            elseif next ∉ keys(seen)
                seen[next] = cost + 1
                frontier[next] = cost + 1
                came_from[next] = c
            elseif seen[next] > cost + 1
                seen[next] = cost + 1
                came_from[next] = c
            elseif seen[next] == cost + 1
                came_from[next] = sort([came_from[next], c], by= x ->(x[1], x[2]))[1]
            end
        end
    end
    
    if isempty(out)
        return nothing
    end
    # sort the best options by reading order to find our goal
    goal = sort(out, by= x ->(x[1], x[2]))[1]

    # trace our steps back, to the first step towards the goal
    step = goal
    while true
        if came_from[step] == start
            break
        end
        step = came_from[step]
    end
    return step
end


grid, goblin, elf = clean_input()

function battle(g, e, part1, elf_attack=3)
    rnd = 0
    elves = length(e)

    while length(g) > 0 && length(e) > 0
        coords = sort([collect(keys(g)); collect(keys(e))], by= x ->(x[1], x[2]))
        rnd += 1
        for c in coords
            if !(length(g) > 0 && length(e) > 0)
                break
            end
            if c in keys(g)
                g, e = take_action(c, g, e, elf_attack, keys(e))
            elseif c in keys(e)
                e, g = take_action(c, e, g, elf_attack, keys(e))
            end
        end
        if length(g) > 0 && length(e) > 0
            #println("Goblin HP is $(sum(values(goblin))), Elf HP is $(sum(values(elf)))")
            #print_grid(grid, goblin, elf)
        end
        if length(e) < elves && !part1
            return false, nothing
        end
        
        

    end
    winner = isempty(g) ? e : g
    return part1 ? (rnd-1) * (sum(values(winner))) : isempty(g), (rnd-1) * (sum(values(winner)))
end

function print_grid(grid, g, e)
    # make a string version of grid
    string_grid = Matrix(undef, size(grid, 1), size(grid, 2))
    for coord in CartesianIndices(grid)
        if grid[coord]
            string_grid[coord] = "#"
        else
            string_grid[coord] = "."
        end
    end
    for coord in keys(g)
        string_grid[coord] = "G"
    end
    for coord in keys(e)
        string_grid[coord] = "E"
    end
    for row in 1:size(string_grid, 1)
        println(join(string_grid[row, :]))
    end
end

function part2(g, e)
    elf_attack = 4
    step = 1
    last_result = false
    while true
        ng, ne = deepcopy(g), deepcopy(e)
        won, score = battle(ng, ne, false, elf_attack)
        if won
            println(score)
            break
        end
        elf_attack += step
        last_result = won
            
    end
end

@show part2(deepcopy(goblin), deepcopy(elf))