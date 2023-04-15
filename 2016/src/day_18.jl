# https://adventofcode.com/2016/day/18

input = "......^.^^.....^^^^^^^^^...^.^..^^.^^^..^.^..^.^^^.^^^^..^^.^.^.....^^^^^..^..^^^..^^.^.^..^^..^^^.."
test = "..^^."

function trap(l, c, r)
    if l == '^' && c == '^' && r == '.'
        return '^'
    elseif l == '.' && c == '^' && r == '^'
        return '^'
    elseif l == '^' && c == '.' && r == '.'
        return '^'
    elseif l == '.' && c == '.' && r == '^'
        return '^'
    else
        return '.'
    end
end

function 🖩(n, input=input)
    out = count(==('.'), input)
    

    for i in 1:n-1
        new = ""
        for j in 1:length(input)
            if j == 1
                new *= trap('.', input[j], input[j+1])
            elseif j == length(input)
                new *= trap(input[j-1], input[j], '.')
            else
                new *= trap(input[j-1], input[j], input[j+1])
            end
        end
        input = new
        out += count(==('.'), input)
    end
    return out
end
@show 🖩(40)
@show 🖩(400000)