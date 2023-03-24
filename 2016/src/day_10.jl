# https://adventofcode.com/2016/day/10

file_path = "2016/data/day_10.txt"

function clean_input(file_path=file_path)
    bots = Dict{String, Vector{Int}}()
    instructions = Dict()
    for line in readlines(file_path)
        if line[1:3] == "bot"
            # parse
            # example line "bot 138 gives low to bot 5 and high to bot 143"
            bot, low, low_to, high, high_to = match(r"bot (\d+) gives low to (\w+) (\d+) and high to (\w+) (\d+)", line).captures
            
            instructions[bot] = (low, low_to, high, high_to)
        else
            # parse
            # example line "value 23 goes to bot 138"
            value, bot = match(r"value (\d+) goes to bot (\d+)", line).captures
            value = parse(Int, value)
            if !haskey(bots, bot)
                bots[bot] = [value]
            else
                push!(bots[bot], value)
            end

        end
    end
    [bots[x] = [] for x in setdiff(keys(instructions), keys(bots))]
    return bots, instructions
end
bots, instructions = clean_input()
function part_1(bots=bots, instructions=instructions)
    outputs = Dict()
    outs = ["0", "1", "2"]
    p1, p2 = nothing, nothing
    while true
        for two_bot in keys(filter(x->length(x.second) == 2, bots))
            if sort(bots[two_bot]) == [17, 61]
                p1 = parse(Int, two_bot)
            end
            if all([haskey(outputs, x) for x in outs])
                p2 = prod([outputs[x] for x in outs])
            end
            if all((p1,p2) .!== nothing)
                return p1, p2
            end
            if instructions[two_bot][1] == "bot"
                push!(bots[instructions[two_bot][2]], sort(bots[two_bot])[1])
            else
                outputs[instructions[two_bot][2]] = sort(bots[two_bot])[1]
            end
            if instructions[two_bot][3] == "bot"
                push!(bots[instructions[two_bot][4]], sort(bots[two_bot])[2])
            else
                outputs[instructions[two_bot][4]] = sort(bots[two_bot])[2]
            end
            
            bots[two_bot] = []
                
            
        end
    end
end
@info part_1()

