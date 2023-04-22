# https://adventofcode.com/2016/day/22
using AStarSearch

file_path = "2016/data/day_22.txt"
function clean_input(file_path=file_path, dims=(37,28))
    size_out = zeros(Int, dims...)
    avail_out = zeros(Int, dims...)
    used_out = zeros(Int, dims...)
    percentage_out = zeros(Int, dims...)
    for line in readlines(file_path)[3:end]
        filesystem, size, used, avail, use = split(line)
        _, x, y = split(filesystem, "-")
        x, y = parse.(Int, [x[2:end], y[2:end]])
        size, avail, used = parse.(Int, [size[1:end-1], avail[1:end-1], used[1:end-1]])
        size_out[x+1,y+1] = size
        avail_out[x+1,y+1] = avail
        used_out[x+1,y+1] = used
        percentage_out[x+1,y+1] = parse(Int, use[1:end-1])
    end
    return permutedims(size_out), permutedims(avail_out), permutedims(percentage_out), permutedims(used_out)
end

sizes, avails, percentage, used = clean_input()
free_square = findfirst(percentage .== 0)
barriers = findall(x-> x .> sizes[free_square], used)
startG = 2,1
goalG = size(sizes)[1], 1

function neighbours(c::CartesianIndex, avails=avails, barriers=barriers ) 
    n = [CartesianIndex(c.I[1]+1, c.I[2]), CartesianIndex(c.I[1]-1, c.I[2]), CartesianIndex(c.I[1], c.I[2]+1), CartesianIndex(c.I[1], c.I[2]-1)]
    n = filter(x->x.I[1] > 0 && x.I[2] > 0 && x.I[1] <= size(avails, 1) && x.I[2] <= size(avails, 2) && avails[x] > 0, n)
    return filter(x-> x ∉ barriers, n)
end


# for each node, check if it is viable with any other node: if it is not empty (used > 0) and the node's `used` is less than or equal to the other node's `avail`. Sum the number of viable pairs.
p1 = sum([sum([(a[1], a[2]) != (b[1], b[2]) && used[a[1], a[2]] > 0 && used[a[1], a[2]] <= avails[b[1], b[2]] for b in CartesianIndices(avails)]) for a in CartesianIndices(avails)])




function solve(startG=CartesianIndex(2, 1))
    zero_coords = findfirst(percentage .== 0)
    a_star = astar(neighbours, zero_coords, startG).cost + 1
    println("hi")
    remaining_trip = astar(neighbours, startG, goalG, cost=cost_fun).cost

end

@show solve()