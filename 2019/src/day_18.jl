# https://adventofcode.com/2019/day/18

using DataStructures, AStarSearch, Combinatorics

file_path = "2019/data/day_18.txt"

function clean_input(file_path=file_path)
    maze = zeros(Bool, length(readlines(file_path)), length(readlines(file_path)[1]))
    kds2coords = Dict()
    coords2kds = Dict()
    starting_position = nothing
    for (row, line) in enumerate(readlines(file_path))
        for (col, char) in enumerate(line)
            if char == '#'
                maze[row, col] = true
            elseif char != '.'
                kds2coords[char] = row, col
                coords2kds[row, col] = char
            end
        end
    end
    return maze, kds2coords, starting_position, coords2kds
end

maze, kds2coords, starting_position, coords2kds = clean_input()

function object_path_variations(start, goal, out=Dict(), maze=maze, kds2coords=kds2coords, coords2kds=coords2kds)
    [x in keys(out) ? nothing : out[x] = Dict() for x in [start, goal]]
    a_star = astar(neighbours, kds2coords[start], kds2coords[goal])
    crossed_objects = [coords2kds[x] for x in intersect(a_star.path[2:end-1], values(kds2coords))]
    out[start][goal] = (crossed_objects, a_star.cost)
    out[goal][start] = (crossed_objects, a_star.cost)
    return out
end

function neighbours(c::Tuple{Int64, Int64}, kds2coords=kds2coords)::Vector{Tuple{Int64, Int64}}
    return filter!(x -> maze[x[1], x[2]] == false, [(c[1], c[2] + 1), (c[1], c[2] - 1), (c[1] + 1, c[2]), (c[1] - 1, c[2])])
end

function all_object_dicts()
    out = Dict()
    sum = 0
    for (start, goal) in combinations(collect(keys(kds2coords)), 2)
        out = object_path_variations(start, goal, out)
    end
    return out
end
object_dict = all_object_dicts()


function options(start, opened_objects=Set(), object_dict=object_dict, coords2kds=coords2kds)
    out = Dict()
    for (goal, (required_objects, cost)) in object_dict[start]
        if all(x -> x in opened_objects, required_objects) && goal ∉ opened_objects
            out[goal] = cost
        end
    end
    return out
end

function solve()
    position = '@'
    opened_objects = Set(position)
    cost = 0
    queue = PriorityQueue{Tuple{Char, Set{Char}, Int64}, Float64}((position, opened_objects, cost) => cost)
    history = Set((position, opened_objects))
    num_keys = length(filter(x -> x == lowercase(x), keys(object_dict)))
    while !isempty(queue)
        (position, opened_objects, cost), _ = first(queue)
        println(length(opened_objects))
        if num_keys == length(filter(x -> x == lowercase(x), opened_objects))
            return cost
        end
        delete!(queue, (position, opened_objects, cost))
        for (object, object_cost) in options(position, opened_objects)
            if (object, union(opened_objects, Set([object]))) ∉ history
                enqueue!(queue, (object, union(opened_objects, Set([object])), cost + object_cost) => ((cost + object_cost)/ (length(opened_objects)+1)))
                push!(history, (object, union(opened_objects, Set([object]))))
            end
        end
    end
end
@show solve()