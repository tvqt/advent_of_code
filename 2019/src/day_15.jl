# https://adventofcode.com/2019/day/15
using AStarSearch

file_path = "2019/data/day_15.txt"
input = parse.(Int, split(readline(file_path), ','))


function Intcode(program::Vector{Int}, input=[], silent=false, i=1, relative_base=0)
    history = []
    while i <= length(program)
        w, a, b = 0, 0, 0
        vals = []
        # get parameters
        instruction = lpad(program[i], 5, "0")
        opcode = parse(Int, instruction[end-1:end])
        modes = parse.(Int, split(reverse(instruction[1:3]), ""))
        if opcode in [1, 2, 3, 7, 8]
            w, program = opcode != 3 ? interpreter(program, modes[3], i+3, relative_base, true) : interpreter(program, modes[1], i+1, relative_base, true)
            push!(vals, w)
        end
        if opcode in [1, 2, 4, 5, 6, 7, 8, 9]
            a, program = interpreter(program, modes[1], i+1, relative_base)
            push!(vals, a)
        end
        if opcode in [1, 2, 5, 6, 7, 8]
            b, program = interpreter(program, modes[2], i+2, relative_base)
            push!(vals, b)
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

function print_grid(grid::Dict)
    mins, maxs = extrema(keys(grid))
    if CartesianIndex(-1, 0) in keys(grid)
        println("Score: $(grid[CartesianIndex(-1, 0)])")
    end
    print("\033[$(maxs[2]-mins[2]+2)A")
    for row in mins[2]:maxs[2]
        for col in mins[1]:maxs[1]
            if col == -1
                continue
            elseif CartesianIndex(col, row) in keys(grid)
                if grid[CartesianIndex(col, row)] == 0
                    print("⬜️")
                elseif grid[CartesianIndex(col, row)] == 1
                    print("🔥")
                elseif grid[CartesianIndex(col, row)] == 2
                    print("⬛️")
                elseif grid[CartesianIndex(col, row)] == 3
                    print("🟪")
                elseif grid[CartesianIndex(col, row)] == 4
                    print("🔴")
                end
            else
                print("⬜️")
            end
        end
        println()
    end
end


function day_2(program)
    function part_1(program, noun=12, verb=2)
        p = copy(program)
        p[2], p[3] = noun, verb
        Intcode(p)
        return p[1]
    end

    function part_2(program)
        for noun in 0:99
            for verb in 0:99
                if part_1(program, noun, verb) == 19690720
                    return 100noun + verb
                end
            end
        end
    end
    part_1(program),part_2(program)
end


function day_5(program, input=[1,5])
    Intcode(copy(program), [input[1]])
    Intcode(copy(program), [input[2]])
end

function day_9(program, input=[1, 2])
    Intcode(copy(program), [input[1]])
    Intcode(copy(program), [input[2]])
end

function day_11(program )
    function run_robot(program, initial_colour=0)
        # up = 0, right = 1, down = 2, left = 3
        dirs = [CartesianIndex(-1, 0), CartesianIndex(0, 1), CartesianIndex(1, 0), CartesianIndex(0, -1)]
        direction = 1
        over_colour = initial_colour
        position = CartesianIndex(0, 0)
        grid = Dict()
        i = 1
        relative_base = 0
        while true
            state = Intcode(program, [over_colour], i, relative_base)
            if state === nothing
                break
            else
                program, i, relative_base, history = state
            end 
            color, turn = history
            grid[position] = color
            direction = turn == 0 ? mod(direction-1, 4) : mod(direction+1, 4)
            direction = direction == 0 ? 4 : direction
            position += dirs[direction]
            if position in keys(grid)
                over_colour = grid[position]
            else
                over_colour = initial_colour
            end
        end
        min_g, max_g = minimum(keys(grid)), maximum(keys(grid))
        for row in min_g[1]:max_g[1]
            for col in min_g[2]:max_g[2]
                if CartesianIndex(row, col) in keys(grid)
                    print(grid[CartesianIndex(row, col)] == 1 ? "⬛️" : "⬜️")
                else
                    print(" ")
                end
            end
            println()
        end
        return length(grid)
    end

    return run_robot(program), run_robot(program, 1)
end

function day_12(program )
    function part_1(program)
        history = Intcode(program, input, true)
        history = Dict(CartesianIndex(history[i], history[i+1]) => history[i+2] for i in 1:3:length(history))
        return count(x-> x[2] == 2, history)
    end

    function part_2(program, input = [], i=1, relative_base=0)
        program[1] = 2
        paddle, ball, history = nothing, nothing, Dict()
        while true
            state = Intcode(program, input, true, i, relative_base)
            if length(state) == 4
                program, i, relative_base, new_history = state
            else
                return state[end]
            end
            new_history = Dict(CartesianIndex(new_history[i], new_history[i+1]) =>  new_history[i+2] for i in 1:3:length(new_history))
            history = merge(history, new_history)
            #print_grid(history)
            bricks = count(x-> x[2] == 2, history)
            #if bricks == 0
            #    return history[CartesianIndex(-1, 0)]
            #end
            
            # get the ball and paddle positions
            new_ball = [k for (k, v) in history if v == 4]
            if !isempty(new_ball)
                ball = new_ball[1]
            end
            new_paddle = [k for (k, v) in history if v == 3]
            if !isempty(new_paddle)
                paddle = new_paddle[1]
            end
            # move the paddle to the ball
            if  paddle[1] < ball[1]
                input = [1]
            elseif ball[1] < paddle[1]
                input = [-1]
            else
                input = [0]
            end
        end

        
    end
   println(part_1(program))
   println(part_2(program))
end

function day_15(program, input = [], i=1, relative_base=0, start=CartesianIndex(0, 0))
    seen = Dict(start => 0)
    frontier = Dict((program, i, relative_base, start) => 0)
    dirs = [1 => CartesianIndex(-1, 0), 2 => CartesianIndex(1, 0), 3 => CartesianIndex(0, -1), 4 => CartesianIndex(0, 1)]
    goal = nothing
    while !isempty(frontier)
        (program, i, relative_base, location), cost = pop!(frontier)
        for direction in dirs
            if location + direction[2] ∉ keys(seen) || cost +1 < seen[location + direction[2]]
                state = Intcode(copy(program), [direction[1]], true, i, relative_base)
                if state === nothing
                    continue
                else
                    new_program, new_i, new_relative_base, history = state
                end 
                if history == [0]
                    continue
                end
                seen[location + direction[2]] = cost + 1
                if history == [2]
                    goal = location + direction[2]
                end
                frontier[(new_program, new_i, new_relative_base, location + direction[2])] = cost + 1 
            end
        end
    end
    function neighbours(location)
        ns = [location + c[2] for c in values(dirs)]
        return [n for n in ns if n in keys(seen)]
    end
    println("Part 1: $(astar(neighbours, start, goal).cost)")
    oxygenated = Set([goal])
    minute = 0
    while oxygenated != keys(seen)
        minute += 1
        oxygenated = union(oxygenated, Set([k for k in keys(seen) if any(n in oxygenated for n in neighbours(k))]))
    end
    println("Part 2: $minute") 
end

day_15(input)