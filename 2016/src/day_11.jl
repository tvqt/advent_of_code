# https://adventofcode.com/2016/day/11

using Combinatorics, StatsBase, DataStructures

file_path = "2016/data/day_11.txt"




function clean_input(file_path=file_path)
    state = Dict("levels" => [Dict("level" => i, "objects" => []) for i in 1:4], "current" => 1)
    actual = Dict()
    debug = Dict()

    for (i, line) in enumerate(readlines(file_path))
        for item in match(r"The \w+ floor contains (.*)\.", line).captures[1] |> x -> split(x, r", and|, |and ")
            name = split(strip(item), r" |-")[2]
            if name in keys(actual)
                if split(strip(item))[end] == "generator"
                    push!(state["levels"][i]["objects"], Dict("generator" => true, "partnerlevel" => actual[name]))
                    push!(state["levels"][actual[name]]["objects"], Dict("generator" => false, "partnerlevel" => i))
                    debug[uppercase(name[1])*'G'] = i
                    debug[uppercase(name[1])*'M'] = actual[name]
                else
                    push!(state["levels"][i]["objects"], Dict("generator" => false, "partnerlevel" => actual[name]))
                    push!(state["levels"][actual[name]]["objects"], Dict("generator" => true, "partnerlevel" => i))
                    debug[uppercase(name[1])*'M'] = i
                    debug[uppercase(name[1])*'G'] = actual[name]
                end
            else
                actual[name] = i
            end
        end
    end
    [state["levels"][i]["objects"] = sort(state["levels"][i]["objects"], by = x -> (x["partnerlevel"], x["generator"])) for i in 1:4]
    debug["E"] = 1
    return state, debug
end
input, debug =  clean_input()

function validlevel(level::Dict)
    l = copy(level)
    if length(l["objects"]) == 0
        return true
    end
    microchips = filter(x-> x["generator"] == false, l["objects"])
    generators = setdiff(l["objects"], microchips)
    num_pairs = length(filter(x-> x["partnerlevel"] == l["level"], microchips))
    # filter names to only those with a value of 1
    return length(microchips) == 0 || length(generators) == 0 || length(microchips) == num_pairs
end



function neighbours(state::Dict, desperate::Bool=false, seen::Dict=Dict())
    objects = state["levels"][state["current"]]["objects"]
    combs = unique(vcat([collect(combinations(objects,n)) for n in 1:2]...))
    interim = unique(vcat([new_states(deepcopy(state), deepcopy(combination), desperate) for combination in combs]...))
    out = []
    for inter in interim
        if inter in keys(seen) 
            if seen[state] + 1 < seen[inter]
                seen[inter] = seen[state] + 1
                push!(out, inter)
            end
        elseif !isempty(inter)
            seen[inter] = seen[state] + 1
            push!(out, inter)
        end
    end
    if length(out) == 0 && !desperate
        return neighbours(state, true, seen)
    end
    return out
end

function new_states(state::Dict, combination::Vector, desperate::Bool)
    out = []
    for option in up_and_down(deepcopy(combination), deepcopy(state), desperate)
        new_state = updated_state(deepcopy(state), deepcopy(combination), state["current"], state["current"] + option)
        if !validlevel(new_state["levels"][state["current"]])
            return []
        elseif validlevel(new_state["levels"][state["current"] + option])
            push!(out, new_state)
        end
    end
    if any([Dict{String, Integer}("generator" => true, "partnerlevel" => 2) in out[i]["levels"][2]["objects"] && Dict{String, Integer}("generator" => false, "partnerlevel" => 2) ∉ out[i]["levels"][2]["objects"] for i in eachindex(out)])
        println("here")
    end
    return out
end

function updated_state(state::Dict, combination::Vector, old::Int, new::Int)
    out = deepcopy(state)
    comb = deepcopy(combination)
    if any([Dict{String, Integer}("generator" => true, "partnerlevel" => x) in state["levels"][x]["objects"] && Dict{String, Integer}("generator" => false, "partnerlevel" => x) ∉ state["levels"][x]["objects"] for x in 1:4])
        println("here")
    end 
    
    for c in comb 
        ind = findfirst(x-> x == c, out["levels"][old]["objects"])
        if ind === nothing
            ind = findfirst(x-> x["partnerlevel"] == new  && x["generator"] == c["generator"], out["levels"][old]["objects"])
            c["partnerlevel"] = new

        end
        deleteat!(out["levels"][old]["objects"], ind)
        partnerind = findfirst(x-> x["partnerlevel"] == old  && x["generator"] != c["generator"], out["levels"][c["partnerlevel"]]["objects"])
        out["levels"][c["partnerlevel"]]["objects"][partnerind]["partnerlevel"] = new
        out["levels"][c["partnerlevel"]]["objects"] = sort(out["levels"][c["partnerlevel"]]["objects"], by = x -> (x["partnerlevel"], x["generator"]))
        push!(out["levels"][new]["objects"], c)
        out["levels"][new]["objects"] = sort(out["levels"][new]["objects"], by = x -> (x["partnerlevel"], x["generator"]))
    end
    out["current"] = new
    if any([Dict{String, Integer}("generator" => true, "partnerlevel" => x) in out["levels"][x]["objects"] && Dict{String, Integer}("generator" => false, "partnerlevel" => x) ∉ out["levels"][x]["objects"] for x in 1:4])
        println("here")
    end
    
    return out
end


function up_and_down(comb::Vector, state::Dict, desperate::Bool=false) 
    if !all(x-> isempty(x["objects"]), state["levels"][1:state["current"] - 1]) && length(comb) == 1 && state["current"] > 1 && !desperate
        return [-1]
    elseif length(comb) == 2 && state["current"] < length(state["levels"]) && !desperate
        return [1]
    elseif !desperate
        return []
    elseif state["current"] == 1
        return [1]
    elseif state["current"] == length(state["levels"])
        return [-1]
    else
        return [-1, 1]

    end
end

heuristic(state::Dict) = sum([(length(input["levels"])- i) * length(x["objects"]) for (i, x) in enumerate(input["levels"])])

function solve(input=input)
    seen = Dict(input => 0)
    queue = PriorityQueue(input => heuristic(input))
    best = typemax(Int)
    num_objects = sum([length(x["objects"]) for x in input["levels"]])
    top_floor = length(input["levels"])
    while true
        if isempty(queue)
            return best
        end
        state, cost = first(queue)
        println(length(queue))
        quickview = [length(state["levels"][i]["objects"]) for i in 1:4]
        println("state is $quickview")
        delete!(queue, state)
        if state["current"] == top_floor && length(state["levels"][top_floor]["objects"]) == num_objects
            return cost, seen[state]
        end
        neighbs = neighbours(state, true, seen) 

        for neighbour in neighbs
            quickview = [length(neighbour["levels"][i]["objects"]) for i in 1:4]
            println("neighbour is $quickview")
            if neighbour in keys(queue)
                delete!(queue, neighbour)
            end
            enqueue!(queue, neighbour => cost + 1)
        end
    end
end

@show solve()

