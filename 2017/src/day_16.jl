# https://adventofcode.com/2017/day/16
file_path = "2017/data/day_16.txt"
function clean_input(file_path=file_path)
    input = split(readline(file_path), ",")
    out = []
    for x in input
        if x[1] == 's'
            push!(out, (x[1], [parse(Int, x[2:end])]))
        elseif x[1] == 'x'
            push!(out, (x[1], parse.(Int, split(x[2:end], "/"))))
        elseif x[1] == 'p'
            push!(out, (x[1], [x[2], x[4]]))
        end
    end
    return out
end

function dance(input=clean_input()::Vector{Any}, programs = collect('a':'p'))::Vector{Char}
    for (command, args) in input
        if command == 's'
            circshift!(programs, args[1])
        elseif command == 'x'
            programs[args[1]+1], programs[args[2]+1] = programs[args[2]+1], programs[args[1]+1]
        elseif command == 'p'
            p1, p2 = findfirst(isequal(args[1]), programs), findfirst(isequal(args[2]), programs)
            programs[p1], programs[p2] = programs[p2], programs[p1]
        end
    end
    return programs
end

function repeated_dance(rounds=1000000000,input=clean_input()::Vector{Any},programs = collect('a':'p'))::String
    found_positions = []
    for r in 1:rounds
        programs = dance(input, programs)
        if programs in found_positions
            phase = findfirst(x->x == programs, found_positions):r-1
            start = 1 - phase[1]
            last_position = ((rounds) % length(phase)) + start
            return join(found_positions[last_position])
        else
            push!(found_positions, copy(programs))
        end
    end
end
@show p1 = join(dance())

@show p2 = repeated_dance()