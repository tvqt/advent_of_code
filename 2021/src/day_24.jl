# https://adventofcode.com/2021/day/24

file_path = "2021/data/day_24.txt"

function clean_input(f=file_path)
    out = []
    input = split.(readlines(file_path))
    for line in input
        if length(line) == 3
            if occursin(r"\d+", line[3])
                line3 = parse(Int, line[3])
            else
                line3 = Symbol(line[3])
            end
            push!(out, (line[1], Symbol(line[2]), line3))
        else
            push!(out, (line[1], Symbol(line[2])))
        end
    end
    return out
end


using MetaGraphsNext, Graphs

function dot_file(f=file_path)
    g = MetaGraph(DiGraph(), label_type = String)
    most_recent = Dict("w" => "", "x" => "", "y" => "", "z" => "")
    for instruction in readlines(f)
        add_vertex!(g, instruction)
        s = split(instruction)
        vars = intersect(s[2:end], keys(most_recent))
        for v in vars
            if s[1] == "mul" && s[end] == "0"
                most_recent[s[2]] = ""
            elseif most_recent[v] !== ""
                add_edge!(g, most_recent[v], instruction)
            end
            most_recent[v] = instruction
        end
        
    end
    return g
end
@show g = dot_file()



function alu(n)
    n = parse.(Int,  split(string(n), ""))
    registry = Dict(:w => 0, :x => 0, :y => 0, :z => 0)
    i = 1
    for line in input
        if line[1] == "add"
            if line[3] isa Int
                registry[line[2]] += line[3]
            else
                registry[line[2]] += registry[line[3]]
            end
        elseif line[1] == "mul"
            if line[3] isa Int
                registry[line[2]] *= line[3]
            else
                registry[line[2]] *= registry[line[3]]
            end
        elseif line[1] == "div"
            if line[3] isa Int
                registry[line[2]] ÷= line[3]
            else
                registry[line[2]] ÷= registry[line[3]]
            end
        elseif line[1] == "mod"
            if line[3] isa Int
                registry[line[2]] %= line[3]
            else
                registry[line[2]] %= registry[line[3]]
            end
        elseif line[1] == "eql"
            if line[3] isa Int
                registry[line[2]] = registry[line[2]] == line[3] ? 1 : 0
            else
                registry[line[2]] = registry[line[2]] == registry[line[3]] ? 1 : 0
            end
        elseif line[1] == "inp"
            registry[line[2]] = n[i]
            i += 1
        end
    end
    return registry[:z] == 0
end


function next_monad(n)
    while true
        n += 1
        if !occursin(r"0", string(n)) && sort(collect(string(n))) == collect(string(n))
            return n
        end
    end
end


function part_1()
    n = 11111111111111
    while true
        n = next_monad(n)
        if alu(n)
            return n
        end
    end
end
@show part_1()

