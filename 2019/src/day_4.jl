# https://adventofcode.com/2019/day/4

input = 124075:580770

function part_1(input)
    out = []
    for i in input
        i = string(i)
        if occursin(r"(\d)\1", i) && (i == join(sort(split(i, ""))))
            push!(out, i)
        end
    end
    return length(out)
end
@info part_1(input)

function rule_2(s)
    # Corner cases
    s[1] == s[2] != s[3] && return true
    s[end-2] != s[end-1] == s[end] && return true
    # Check rest of the string
    for i = 2:length(s)-2
        s[i-1] != s[i] == s[i+1] != s[i+2] && return true
    end
    return false
end
not_decreasing(s) = join(sort(collect(s))) == s
meets_criteria_2(s) = not_decreasing(s) && rule_2(s)
result_2 = count(x -> meets_criteria_2(string(x)), input)
@info result_2
