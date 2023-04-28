# https://adventofcode.com/2019/day/4

input = 124075:580770

function solve(input)
    p1 = 0
    p2 = 0
    for n in input
        n = string(n)
        f = findall(r"(\d)\1", n)
        if !isempty(f) && (n == join(sort(split(n, ""))))
            p1 += 1

            # found in the Reddit answer thread
            if occursin(r"(\d)(?<!(?=\1)..)\1(?!\1)", i)
                p2 += 1
            end
           # original solution, by me
            """for c in f
                # original solution, by me
                b = c[1] == 1 ? true : n[c[1]] != n[c[1]-1]
                e = c[2] == length(n) ? true : n[c[1]] != n[c[2]+1]
                if b && e
                    p2 += 1
                    break
                end
            end"""
        end
    end
    return p1, p2
end
@info solve(input)