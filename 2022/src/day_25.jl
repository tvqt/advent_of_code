# https://adventofcode.com/2022/day/25

file_path = "2022/data/day_25.txt"
input = readlines(file_path)
function decimal_to_snafu(n)
    n = reverse(string(n, base=5))
    out = ""
    carry = 0
    i = 1
    while i <= length(n)
        value = parse(Int, n[i]) + carry
        carry = 0
        if value in [0, 1, 2]
            out *= string(value)
        elseif value == 3
            out *= "="
            carry = 1
        elseif value == 4
            out *= "-"
            carry = 1
        elseif value == 5
            out *= "0"
            carry = 1
        end
        i += 1
    end
    if carry == 1
        out *= "1"
    end
    return reverse(out)

end


function snafu_to_decimal(s)
    out = []
    s = reverse(s)
    i = 1
    while i <= length(s)
        if s[i] == '='
            push!(out, -2*(5^(i-1)))
        elseif s[i] == '-'
            push!(out, -1*(5^(i-1)))
        else
            push!(out, parse(Int, s[i])*(5^(i-1)))
        end    
        i += 1
    end
    return sum(out)
end

@show decimal_to_snafu(sum([snafu_to_decimal(x) for x in input]))
