# https://adventofcode.com/2016/day/22
using Combinatorics, DataStructures

file_path = "2016/data/day_22.txt"

function clean_input(file_path=file_path, dims=(37,28))
    size_out = zeros(Int, dims...)
    avail_out = zeros(Int, dims...)
    percentage_out = zeros(Int, dims...)
    for line in readlines(file_path)[3:end]
        filesystem, size, used, avail, use = split(line)
        _, x, y = split(filesystem, "-")
        x, y = parse.(Int, [x[2:end], y[2:end]])
        size, avail = parse.(Int, [size[1:end-1], avail[1:end-1]])
        size_out[x+1,y+1] = size
        avail_out[x+1,y+1] = avail
        percentage_out[x+1,y+1] = parse(Int, use[1:end-1])
    end
    return size_out, avail_out, percentage_out
end

sizes, avails, percentage = clean_input()

neighbours(c::CartesianIndex) = [CartesianIndex(c.I[1]+1, c.I[2]), CartesianIndex(c.I[1]-1, c.I[2]), CartesianIndex(c.I[1], c.I[2]+1), CartesianIndex(c.I[1], c.I[2]-1)]

function viable_pairs_with_x(x1, y1, size1, avail1, avails, seen, G, cost)
    for (x2, y2) in avails
        if (x1, y1) == (x2, y2)
            continue
        end
        avail2 = avails[(x2, y2)]
        if size1-avail1 <= avail2
            avails[x2, y2] += avail1
            if avails ∉ seen || seen[avails] > cost + 1
                
    
            end
            avails[x2, y2] -= avail1
        end
    end
end

function viable_pairs_with_neighbours(c1, size1, avail1, avails, seen, G, cost, queue, goalG)
    for c2 in neighbours(c1)
        if c2 ∉ keys(avails)
            continue
        end
        avail2 = avails[c2]
        if size1-avail1 <= avail2
            avails[c1] = 0
            avails[c2] += avail1
            state = G == c1 ? (copy(avails), c2) : (copy(avails), G)
            if state ∉ keys(seen) 
                seen[state] = cost + 1
                enqueue!(queue, (state..., cost + 1)=> heuristic(state[2], avails, goalG))
            end
            avails[c1] = avail1
            avails[c2] -= avail1
        end
    end
end


function viable_pairs(sizes, avails, seen, G, cost, queue, best, goalG)
    if cost + 1 >= best
        return
    end
    for c1 in CartesianIndices(avails)
        avail1 = avails[c1]
        size1 = sizes[c1]
        if size1 == avail1
            continue
        end
        
        viable_pairs_with_neighbours(c1, size1, avail1, avails, seen, G, cost, queue, goalG)
    end
end

heuristic(G, a, goalG) = G == goalG ? 0 : a[goalG]

function solve(sizes=sizes, avails=avails, startG=CartesianIndex(2, 1), goalG=CartesianIndex(1,1))
    seen = Dict()
    queue = PriorityQueue{Tuple{Matrix{Int}, CartesianIndex, Int}, Int}()
    best = typemax(Int)
    enqueue!(queue, (copy(avails), startG, 0)=> heuristic(startG, avails, goalG))
    while !isempty(queue)
        (avails, G, cost), _= first(queue)
        #println("$(length(queue)) $cost")

        delete!(queue, first(queue)[1])
        if G == goalG
            if cost < best
                best = cost
                println("----------$cost---------------")
                println(cost)
            end
            continue
        end
        viable_pairs(sizes, avails, seen, G, cost, queue, best, goalG)
    end
    return cost
end

@show solve()