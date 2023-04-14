file_path = "2019/data/day_18.txt"

M = [collect(strip.(line)) for line in eachline(file_path)]
D = Dict()
Y, X = [-1, 0, 1, 0], [0, 1, 0, -1]

for r in axes(M, 1)
    for c in 1:length(M[r])
        if islowercase(M[r][c]) || M[r][c] == '@'
            D[M[r][c]] = (r, c)
        end
    end
end

keys_ = length(keys(D)) - 1

function bfs(p)
    Q = [(p..., 0, ())]
    S, K = Set(), Dict()
    while !isempty(Q)
        y, x, t, D = popfirst!(Q)
        if (y, x) in S
            continue
        end
        push!(S, (y, x))
        if islowercase(M[y][x]) && p != (y, x)
            K[M[y][x]] = (t, Set(D))
        end
        for i in 1:4
            dy, dx = y+Y[i], x+X[i]
            if M[dy][dx] != '#'
                if uppercase(M[dy][dx]) == M[dy][dx]
                    push!(Q, (dy, dx, t+1, (D..., lowercase(M[dy][dx]))))
                else
                    push!(Q, (dy, dx, t+1, D))
                end
            end
        end
    end
    return K
end

G = Dict{Char, Dict}()
for c in keys(D)
    G[c] = Dict()
    for (k, v) in bfs(D[c])
        G[c][k] = v
    end
end

Q = [(0, ('@', Set()))]
dist = Dict()
while !isempty(Q)
    d, node = popfirst!(Q)
    if node in keys(dist)
        continue
    end
    dist[node] = d
    u, S = node
    if length(S) == keys_
        println(d)
        break
    end
    for (v, (w, T)) in G[u]
        if length(T-S) == 0 && !(v in S)
            heappush!(Q, (d+w, (v, S ∪ Set([v]))))
        end
    end
end

@show dist