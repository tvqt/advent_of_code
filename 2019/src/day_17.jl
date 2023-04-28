# https://adventofcode.com/2019/day/17

using AStarSearch, Combinatorics

file_path = "2019/data/day_17.txt"
input = parse.(Int, split(readline(file_path), ','))


function Intcode(program::Vector{Int}, input=[], silent=false, i=1, relative_base=0)
    history = []
    while i <= length(program)
        w, a, b = 0, 0, 0
        # get parameters
        instruction = lpad(program[i], 5, "0")
        opcode = parse(Int, instruction[end-1:end])
        modes = parse.(Int, split(reverse(instruction[1:3]), ""))
        if opcode in [1, 2, 3, 7, 8]
            w, program = opcode != 3 ? interpreter(program, modes[3], i+3, relative_base, true) : interpreter(program, modes[1], i+1, relative_base, true)
        end
        if opcode in [1, 2, 4, 5, 6, 7, 8, 9]
            a, program = interpreter(program, modes[1], i+1, relative_base)
        end
        if opcode in [1, 2, 5, 6, 7, 8]
            b, program = interpreter(program, modes[2], i+2, relative_base)
        end

        if opcode == 1 # add
            program[w] = a + b
            i += 4
        elseif opcode == 2 # multiply
            program[w] = a * b
            i += 4
        elseif opcode == 3 # write
            if length(input) == 0
                return program, i, relative_base, history
            end
            program[w] = pop!(input)
            i += 2
        elseif opcode == 4 # output
            !silent ? println(a) : nothing
            push!(history, a)
            i += 2
        elseif opcode == 5 # jump if true
            #println("$(a), $(b+1)")
            i = a != 0 ? b+1 : i+3
        elseif opcode == 6 # jump if false
            i = a == 0 ? b+1 : i+3
        elseif opcode == 7 # less than
            program[w] = a < b ? 1 : 0
            i += 4
        elseif opcode == 8 # greater than
            program[w] = a == b ? 1 : 0
            i += 4
        elseif opcode == 9 # relative base offset
            relative_base += a
            i += 2
        elseif opcode == 99 # halt
            return history
        else
            throw("Unknown command: $opcode")
        end
    end
end

function interpreter(program::Vector{Int}, mode, i, relative_base, value=false)
    if mode in [0,2] # 
        if mode == 0
            w = program[i]+1
        else
            w = program[i]+1+relative_base
        end
        if w > length(program)
            program = vcat(program, zeros(Int, w-length(program)))
        end
        return value ? (w, program) : (program[w], program)
    elseif mode == 1 # immediate mode
        if value
            throw("Immediate mode does not support writing")
        end
        return program[i], program
    else
        throw("Unknown mode: $mode")
    end
end

function neighbours(location, grid)
    dirs = [CartesianIndex(-1, 0), CartesianIndex(0, 1), CartesianIndex(1, 0), CartesianIndex(0, -1)]
    ns = [location + c for c in dirs]
    return [n for n in ns if n in grid]
end


function day_17(program)
    history = Intcode(program, [], true)
    out = []
    line = []
    for c in history
        if c == 10
            push!(out, line)
            line = []
        else
            push!(line, Char(c))
        end
    end
    g = hcat(out[1:end-1]...)
    display(g)
    grid = g .!== '.'
    p1 = 0
    scaffolds = findall(x-> x, grid)
    intersections = [findall(x-> x in ['^', '<', '>', 'v'], g)[1]]
    for scaffold in scaffolds
        if length(neighbours(scaffold, scaffolds)) >= 3
            p1 += (scaffold[1]-1) * (scaffold[2]-1)
            push!(intersections, scaffold)
        end
    end
    println("Part 1: $intersections")
    return scaffolds, intersections
end

scaffolds, intersections =  day_17(input)

function intersection_paths(scaffolds, intersection, intersections)
    directions = Dict(CartesianIndex(-1, 0) => 'N', CartesianIndex(0, 1) => 'E', CartesianIndex(1, 0) => 'S', CartesianIndex(0, -1) => 'W')
    out = []
    seen = Dict(intersection => [])
    frontier = [intersection]
    while !isempty(frontier)
        current = pop!(frontier) 
        for neighbour in neighbours(current, scaffolds)
            path = [seen[current]..., directions[neighbour-current]]
            if neighbour in intersections && neighbour != intersection
                push!(out, path)
            elseif !(neighbour in keys(seen))             
                seen[neighbour] = path
                push!(frontier, neighbour)
            end
        end
    end
    return out
end

function paths(intersections, scaffolds)
    out = []
    for intersection in intersections
        push!(out, intersection_paths(scaffolds, intersection, intersections))
    end
    return out
end

@show all_paths = paths(intersections, scaffolds)