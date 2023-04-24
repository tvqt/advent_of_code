# https://adventofcode.com/2021/day/23
using AStarSearch, Combinatorics, QuickHeaps

file_path = "2021/data/day_23.txt"
letter_strings = ["A", "B", "C", "D"]
movement_cost = Dict("A" => 1, "B" => 10, "C" => 100, "D" => 1000)

function clean_input(f=file_path)
    out = zeros(Int, length(readlines(f)), length(readline(f)))
    out .= -1
    letters = Dict()
    for (i, line) in enumerate(split.(readlines(f),""))
        for (j, char) in enumerate(line)
            if char == "#"
                out[i, j] = 1
            elseif char in letter_strings
                if char in keys(letters)
                    push!(letters[char], CartesianIndex(i, j))
                else
                    letters[char] = Set([CartesianIndex(i, j)])
                end
                out[i, j] = 0
            elseif char == "."
                out[i, j] = 0
            end
        end
    end
    return out, letters
end

function get_rooms(letters)
    out = Dict()
    cols = sort(unique([x[2] for x in letter_spaces]))
    for (i, col) in enumerate(cols)
        out[letter_strings[i]] = Set([x for x in letter_spaces if x[2] == col])
    end
    return out
end


waiting_spaces(grid, letters) = [x for x in CartesianIndices(grid) if grid[x] == 0 && x + CartesianIndex(1, 0) ∉ letter_spaces] ∪ letter_spaces

function immediate_neighbours(c, grid=grid)
    n = [c + dir for dir in [CartesianIndex(-1, 0), CartesianIndex(1, 0), CartesianIndex(0, -1), CartesianIndex(0, 1)]]
    return [x for x in n if grid[x] == 0]
end

function generate_paths(grid, spaces, letters, rooms, outsides)
    out = Dict()
    blocking = Dict()
    for comb in combinations(spaces, 2)
        
        if comb[1] ∈ keys(rooms) && comb[2] ∈ keys(rooms) && rooms[comb[1]] == rooms[comb[2]]
            continue
        end
        if comb[1] in outsides && comb[2] in outsides
            continue
        end
        comb = sort(collect(comb))
        astar_ = astar(immediate_neighbours, comb[1], comb[2])
        out[comb] = astar_.cost
        blockers = intersect(astar_.path, spaces)
        if length(blockers) == 2
            blocking[comb] = []
        end
        blocking[comb] = blockers[2:end-1]
    end
    return out, blocking
end

manhattan_distance(a, b) = abs(a[1] - b[1]) + abs(a[2] - b[2])

function heuristic(letters)
    out = 0
    for letter in letter_strings
        out += sum([manhattan_distance(x, first(rs[letter])) for x in letters[letter]])
    end
    return out
end

success(letters) = all([letters[l] == rs[l] for l in letter_strings])

function neighbours(letter, lettercoords, letters)
    out = []
    move_costs = []
    l_s = vcat([collect(x) for x in values(letters)]...)
    potential_spaces = setdiff(spaces, l_s)
    
    if lettercoords in outsides
        potential_spaces = setdiff(potential_spaces, outsides)
    elseif lettercoords[1] == 4 && lettercoords + CartesianIndex(-1, 0) ∈ l_s
        return [], []
    end
    other_letter_coord = setdiff(collect(letters[letter]), [lettercoords])[1]
    if lettercoords == lower_spaces[letter] || (lettercoords == upper_spaces[letter] && other_letter_coord == lower_spaces[letter])
        return [], []
    end
    if upper_spaces[letter] ∉ l_s && lower_spaces[letter] ∉ l_s
        comb = sort([lettercoords, lower_spaces[letter]])
        if isempty(intersect(l_s, blocking[comb]))
            new_letters = deepcopy(letters)
            delete!(new_letters[letter], lettercoords)
            push!(new_letters[letter], lower_spaces[letter])
            push!(out, new_letters)
            push!(move_costs, movement_cost[letter] * paths[comb])
            return out, move_costs
        end
    elseif upper_spaces[letter] ∉ l_s && lower_spaces[letter] == other_letter_coord
        comb = sort([lettercoords, upper_spaces[letter]])
        if isempty(intersect(l_s, blocking[comb]))
            new_letters = deepcopy(letters)
            delete!(new_letters[letter], lettercoords)
            push!(new_letters[letter], upper_spaces[letter])
            push!(out, new_letters)
            push!(move_costs, movement_cost[letter] * paths[comb])
            return out, move_costs
        end 
    end
        

    for space in potential_spaces
        if space in letter_spaces 
            if space ∉ rs[letter]
                continue
            end
            other_slot = setdiff(collect(rs[letter]), [space])[1]
            if other_slot in l_s && other_slot != other_letter_coord
                continue
            end
        end
        comb = sort([lettercoords, space])
        if isempty(intersect(l_s, blocking[comb]))
            new_letters = deepcopy(letters)
            delete!(new_letters[letter], lettercoords)
            push!(new_letters[letter], space)
            push!(out, new_letters)
            push!(move_costs, movement_cost[letter] * paths[comb])
        end
    end
    return out, move_costs
end

function visualise(letters)
    new_grid = map(string, grid)
    for letter in letter_strings
        for coords in letters[letter]
            new_grid[coords] = letter
        end
    end
    for c in CartesianIndices(new_grid)
        if new_grid[c] == "0"
            new_grid[c] = "."
        elseif new_grid[c] == "1"
            new_grid[c] = "#"
        elseif new_grid[c] == "-1"
            new_grid[c] = " "
        end
    end
    # print new_grid without commas or quotation marks
    for row in axes(new_grid, 1)
        println(join(new_grid[row, :], ""))
    end
    
end
    
function part_1(grid, letters, rs, paths)
    frontier = PriorityQueue{Dict{Any, Any}, Int}()
    frontier[letters] = 0
    cost_so_far = Dict()
    cost_so_far[letters] = 0
    best = typemax(Int)

    while !isempty(frontier)
        letters, _ = pop!(frontier)
        if cost_so_far[letters] > best
            continue
        end
        if cost_so_far[letters] >= 10000
            continue
        end
        if letters == rs
            if cost_so_far[letters] < best
                best = cost_so_far[letters]
            end
            println(best)
        end
        for (letter, coords) in letters
            for coordinates in coords
                neighbs, move_costs = neighbours(letter, coordinates, letters)
                for n in eachindex(neighbs)
                    move_cost, neighbour = move_costs[n], neighbs[n]
                    new_cost = cost_so_far[letters] + move_cost
                    if neighbour ∉ keys(cost_so_far) || new_cost < cost_so_far[neighbour]
                        cost_so_far[neighbour] = new_cost
                        frontier[neighbour] = (new_cost÷ 100) + heuristic(neighbour)
                    end
                end
            end
        end
    end
end


grid, letters =  clean_input()
letter_spaces = vcat([collect(x) for x in values(letters)]...)
rs= get_rooms(letters)
spaces = waiting_spaces(grid, letters)
outsides = setdiff(spaces, letter_spaces)
paths, blocking = generate_paths(grid, spaces, letters, rs, outsides)
upper_spaces = Dict([k => minimum(v) for (k,v) in rs])
lower_spaces = Dict([k => maximum(v) for (k,v) in rs])




part_1(grid, letters, rs, paths)

