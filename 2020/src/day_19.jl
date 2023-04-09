# Day 19: Monster Messages
# https://adventofcode.com/2020/day/19


using IterTools

messages_path = "2020/data/day_19.txt"
rules_path = "2020/data/day_19_rules.txt"

function clean_input(messages=messages_path, rules=rules_path) # parse the input messages and rules
    messages = []
    rules = Dict{String,Vector{Vector{String}}}()
    clean_rules = Dict{String,Any}()
    
    for line in readlines(messages_path) # parse the messages
        push!(messages, line)
    end

    for line in readlines(rules_path) # parse the rules
        line = split(line, ": ")

        if line[2][1] == '"' # if the rule is a single character, add it to the clean rules
            clean_rules[line[1]] = [string(line[2][2])]
        else
            rules[line[1]] = [split(x) for x in split(replace(line[2], "\"" => ""), " | ")]
        end
    end
    return messages, rules, clean_rules
end

messages, rules, clean_rules = clean_input()


function unnest_rules(messages=messages, rules=rules, clean_rules=clean_rules)
    uncleaned_rules = copy(rules)

    while length(uncleaned_rules) > 0
        ready = filter(kv -> all(x -> x in keys(clean_rules), vcat(kv[2]...)), uncleaned_rules) # find rules that are ready to be cleaned
        for (k, v) in ready
            clean_rules[k] = vcat([new_value(x, clean_rules) for x in v]...) # clean the rules
            delete!(uncleaned_rules, k) # remove the rule from the uncleaned rules
        end
    end
    return clean_rules["0"] # return the values that match rule 0
end





new_value(v::Vector{String}, clean_rules) = vec([join(vcat(x...)) for x in IterTools.product([clean_rules[x] for x in v]...)])



rule_0s = unnest_rules()

function message_checker2(message, clean_rules=clean_rules)
    # chop message into chunks of length 8
    rule_length = length(clean_rules["42"][1])
    input = [message[i:i+rule_length-1] for i in 1:rule_length:length(message)]
    # for each chunk check if it matches the rule 42
    matching42, matching31 = [x in clean_rules["42"] for x in input], [x in clean_rules["31"] for x in input]
    
    if !matching31[end]
        return false
    elseif !(sum(matching42) > sum(matching31))
        return false
    end
    
    while length(input) > 0
        if matching42[1] && matching31[end]
            pop_both_ends!(matching42), pop_both_ends!(matching31), pop_both_ends!(input)
        elseif matching42[1]
            popfirst!(matching42), popfirst!(input), pop!(matching31)
        else
            return false
        end
    end
    return true
end

function pop_both_ends!(x)
    popfirst!(x)
    pop!(x)
end


part_1() = filter(x -> x in rule_0s, messages)
part_2(messages=messages, clean_rules=clean_rules, p1=p1) = length(filter(x -> message_checker2(x, clean_rules), filter(x -> x ∉ p1, messages))) + length(p1)


p1 = part_1()
@show length(p1), part_2()
