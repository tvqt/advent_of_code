# https://adventofcode.com/2016/day/17

using MD5

input = "dmypynyp"

directions(hash) = occursin(r"[bcdef]", hash[1]), occursin(r"[bcdef]", hash[2]), occursin(r"[bcdef]", hash[3]), occursin(r"[bcdef]", hash[4])

function 🖩(input=input)
    queue = [(input, (1, 1))]
    p1 = nothing
    p2 = nothing
    while !isempty(queue)
        path, (x, y) = popfirst!(queue)
        if x == 4 && y == 4
            p1 === nothing ? (p1 = path[length(input)+1:end]) : nothing
            p2 === nothing || length(path) > p2 ? (p2 = length(path) - length(input)) : nothing
            println(p2)
            continue
        end
        hash = bytes2hex(md5(path)[1:2])
        up, down, left, right = occursin.(r"[bcdef]", split(hash,""))
        if up && y > 1
            push!(queue, (path * "U", (x, y - 1)))
        end
        if down && y < 4
            push!(queue, (path * "D", (x, y + 1)))
        end
        if left && x > 1
            push!(queue, (path * "L", (x - 1, y)))
        end
        if right && x < 4
            push!(queue, (path * "R", (x + 1, y)))
        end
    end
    return p1, p2
end
@show 🖩()