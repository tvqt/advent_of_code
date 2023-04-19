# https://adventofcode.com/2022/day/18
using AStarSearch
file_path = "2022/data/day_18.txt"
function clean_input(file_path=file_path)::Vector{Tuple}
    out = []
    for line in readlines(file_path)
        c = parse.(Int, split(line, ","))
        push!(out, (c[1], c[2], c[3]))
    end
    return out
end
input = clean_input()

function neighbours(c) 
    n = [(c[1]+1, c[2], c[3]),
            (c[1]-1, c[2], c[3]),
            (c[1], c[2]+1, c[3]),
            (c[1], c[2]-1, c[3]),
            (c[1], c[2], c[3]+1),
            (c[1], c[2], c[3]-1)]
        return filter(x -> x ∉ input, n)
end


faces = [neighbours(c) for c in input]
sum([length(face) for face in faces])

goal = (99, 99, 99)
total = 0
input2 = unique(vcat(faces...))

@show neighbours((10,17,7))
function part_2(input2=input2, goal=goal)
    min_x, min_y, min_z = minimum(input) .- 1 
    current = (min_x, min_y, min_z)
    outer = []
    while !isempty(input2)
        next = pop!(input2)
        if astar(neighbours, current, next).cost > 1
            push!(outer, current) 
        end
        current = outer[end]
    end
    return length(outer)
end

@show part_2()
@show astar(neighbours, input[1], input[2]).cost