# https://adventofcode.com/2019/day/20
using AStarSearch
file_path = "2019/data/day_20.txt"

mutable struct Tile
    floor::Bool
    portal::Union{Nothing, CartesianIndex{2}}
    level::Union{Nothing, Int}
end

function neighbours_input(c::CartesianIndex, input) 
    out = [CartesianIndex(c.I[1], c.I[2] + 1), CartesianIndex(c.I[1], c.I[2] - 1), CartesianIndex(c.I[1] + 1, c.I[2]), CartesianIndex(c.I[1] - 1, c.I[2])]
    return filter(x->x[1] > 0 && x[2] > 0 && x[1] <= size(input, 1) && x[2] <= size(input, 2), out)
end

function clean_input(file_path=file_path) 
    input = hcat([split(line, "") for line in readlines(file_path)]...)
    output = Dict(CartesianIndex{2}(i, j) => Tile(input[i, j] == ".", nothing, nothing) for i in 1:size(input, 1), j in 1:size(input, 2))
    interim_portals = Dict()
    for match in findall(x -> isuppercase(x[1]), input)
        neighbs = neighbours_input(match, input)
        dot = findfirst(x -> input[x] == ".", neighbs)
        output[match].level = (match[1] == 1 || match[1] == size(input, 1) || match[2] == 1 || match[2] == size(input, 2)) ? -1 : 1
        if dot !== nothing
            name = sort([input[match + match-neighbs[dot]], input[match]])
            if name in keys(interim_portals)
                output[match].portal = interim_portals[name][1]
                output[interim_portals[name][2]].portal = neighbs[dot]
                delete!(interim_portals, name)
            else
                interim_portals[name] = neighbs[dot], match
            end
        end
    end
    output[interim_portals[["Z", "Z"]][2]].floor = true
    return output, interim_portals[["A", "A"]][1], interim_portals[["Z", "Z"]][1]
end
input, start, goal = clean_input()



function neighbours(c::CartesianIndex{2}, input=input) 
    out =  filter(x->input[x].floor == true || input[x].portal !== nothing, [CartesianIndex(c.I[1], c.I[2] + 1), CartesianIndex(c.I[1], c.I[2] - 1), CartesianIndex(c.I[1] + 1, c.I[2]), CartesianIndex(c.I[1] - 1, c.I[2])])
    return [input[x].portal !== nothing ? input[x].portal : x for x in out]
end

@show a_star = astar(neighbours, start, goal).cost


visited = Dict()
function neighbours2(state::Tuple{CartesianIndex{2}, Int}, input=input, visited=visited)
    c, l = state
    out =  filter(x->input[x].floor == true || input[x].portal !== nothing, [CartesianIndex(c.I[1], c.I[2] + 1), CartesianIndex(c.I[1], c.I[2] - 1), CartesianIndex(c.I[1] + 1, c.I[2]), CartesianIndex(c.I[1] - 1, c.I[2])])
    if any([input[x].portal !== nothing for x in out]) 
        println(l)
    end
    out = [input[x].portal !== nothing ? (input[x].portal, l + input[x].level) : (x, l) for x in out]
    return filter(x->x[2] >= 0, out)
end
function heuristic(state::Tuple{CartesianIndex{2}, Int}, goal::Tuple{CartesianIndex{2}, Int})
    return abs(state[1][1] - goal[1][1]) + abs(state[1][2] - goal[1][2]) * (goal[2]-state[2])
end


@show a_star2 = astar(neighbours2, (start, 0), (goal, 0), heuristic=heuristic, maxcost=400).cost