# Day 20: Firewall Rules
# https://adventofcode.com/2016/day/20

file_path = "2016/data/day_20.txt"

a = sort([(parse(Int, x[1]):parse(Int, x[2])) for x in split.(readlines(file_path), "-")])
function 🖩(a=a)
    for i in 1:length(a)-1
        if  a[i+1][1] - a[i][end] >= 2
            for j in a[i][end]+1:a[i+1][1]-1
                if !any(x -> j in x, a)
                    return j
                end
            end
        end
    end
end

@show 🖩()


# turn input into a dictionary

function new_input(a=a)
    out = Vector{UnitRange{Int}}([a[1]])
    for new in a[2:end]
        if new[1] in out[end] && new[end] in out[end]
            continue
        elseif new[1] in out[end]
            out[end] = out[end][1]:new[end]
        elseif new[end] in out[end]
            out[end] = new[1]:out[end][end]
        elseif new[1] - out[end][end] == 1
            out[end] = out[end][1]:new[end]
        else
            push!(out, new)
        end
    end
    return out
end

function 🖩(b=new_input())
    out = 0
    for (i, r) in enumerate(b[1:end-1])
        out += b[i+1][1] - r[end] - 1
    end
    return out

end
@show 🖩()