# https://adventofcode.com/2020/day/19

messages_path = "2020/data/day_19.txt"
rules_path = "2020/data/day_19_rules.txt"

function clean_input(messages=messages_path, rules=rules_path)
    out = []
    rules = Dict{String,Any}()
    
    for line in readlines(messages_path) # parse the messages
        push!(out, line)
    end

    for line in readlines(rules_path) # parse the rules
        line = split(line, ": ")
        rules[line[1]] = line[2]
    end
    return out, rules
end

out, rules = clean_input()


# replace the numbers in the rules with the rules they point to
function replace_numbers(rules)
    # filter to only the rules without numbers
    out = Dict{String, Vector{String}}(k => [replace(v, r"\"" => "")] for (k, v) in rules if !occursin(r"\d", v))
    while length(out) < length(rules)
        for (k, v) in rules
            
            for key in intersect(split(v), keys(out))
                rules[k] = [join(replace(split(v), key => subtype), " ") for subtype in out[key]]

            end
        end
        for (k, v) in rules
            if !occursin(r"\d", v)
                out[k] = split(v, " | ")
            end
        end

    end
    return out
end
@show rules = replace_numbers(rules)
# replace the items in 101 with the corresponding rule in out

rules["101"] = replace(rules["101"], r"\d+" => s -> rules[s])

# check if a message is valid
function check_message(message, rule_string)
    i = 1
    if !occursin('(', rule_string)
        if !evaluate(message[i], rule_string)
            return false
        end
    end
    nesting_level = 0
    nested_rule = ""
    while true
        if rule_string[i] == '(' 
            nesting_level += 1
            if nesting_level == 1
                i += 1
                continue
            end
        elseif rule_string[i] == ')'
            nesting_level -= 1
        end
        if nesting_level == 0
            if !evaluate(message[i], nested_rule)
                return false
            end
            nested_rule = ""
        else
            nested_rule *= rule_string[i]
        end

        i += 1
    end
    return true
end

@show check_message("ababbb", rules["0"])