# Day 20: A Regular Map
# https://adventofcode.com/2018/day/20

file_path = "2018/data/day_20.txt"
input = readline(file_path)[2:end-1]

north_pole_map = Dict()

function solve(input=input, x=0, y=0, steps=0, i=1, level=0, north_pole_map=north_pole_map)
    original_x, original_y, original_steps = x, y, steps
    options = []
    while i <= length(input)
        if input[i] == 'N'
            steps += 1
            y += 1
        elseif input[i] == 'S'
            steps += 1
            y -= 1
        elseif input[i] == 'E'
            steps += 1
            x += 1
        elseif input[i] == 'W'
            steps += 1
            x -= 1
        elseif input[i] == '('
            x, y, i = solve(input, x, y, steps, i+1, level +1)
        elseif input[i] == ')'
            return x, y, i
        elseif input[i] == '|'
            push!(options, (x, y))
            x, y, steps = original_x, original_y, original_steps
        end
        if (x, y) ∉ keys(north_pole_map) || north_pole_map[(x, y)] > steps
            north_pole_map[(x, y)] = steps
        end
        i += 1
    end
    return level == 0 ? (maximum(values(north_pole_map)), length(filter(x -> x >= 1000, collect(values(north_pole_map))))) : (x, y, i)
end

@show solve()