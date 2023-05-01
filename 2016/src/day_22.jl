# https://adventofcode.com/2016/day/22
using AStarSearch

file_path = "2016/data/day_22.txt"
function clean_input(file_path=file_path)
    last = split(split(readlines(file_path)[end])[1], "-")
    dims = parse(Int, last[3][2:end])+1, parse(Int, last[2][2:end])+1
    size_out = zeros(Int, dims...)
    avail_out = zeros(Int, dims...)
    used_out = zeros(Int, dims...)
    percentage_out = zeros(Int, dims...)
    for line in readlines(file_path)[3:end]
        filesystem, size, used, avail, use = split(line)
        _, x, y = split(filesystem, "-")
        x, y = parse.(Int, [x[2:end], y[2:end]])
        size, avail, used = parse.(Int, [size[1:end-1], avail[1:end-1], used[1:end-1]])
        size_out[y+1, x+1] = size
        avail_out[y+1, x+1] = avail
        used_out[y+1, x+1] = used
        percentage_out[y+1, x+1] = parse(Int, use[1:end-1])
    end
    zero_coords = findfirst(percentage_out .== 0)
    return avail_out, used_out, (used_out .> size_out[zero_coords]), zero_coords
end

avails, used, p2_grid, zero_coords = clean_input()



# for each node, check if it is viable with any other node: if it is not empty (used > 0) and the node's `used` is less than or equal to the other node's `avail`. Sum the number of viable pairs.
p1 = sum([sum([(a[1], a[2]) != (b[1], b[2]) && used[a[1], a[2]] > 0 && used[a[1], a[2]] <= avails[b[1], b[2]] for b in CartesianIndices(avails)]) for a in CartesianIndices(avails)])


function neighbours(c::CartesianIndex)
    n = [c + x for x in [CartesianIndex(0, 1), CartesianIndex(0, -1), CartesianIndex(1, 0), CartesianIndex(-1, 0)]]
    return filter(x -> x[1] >= 1 && x[1] <= size(p2_grid, 1) && x[2] >= 1 && x[2] <= size(p2_grid, 2) && !p2_grid[x[1], x[2]], n)
end

function solve(grid)
    data = CartesianIndex(1, size(grid, 2)-1)
    a_star = astar(neighbours, zero_coords, data).cost + 1
    println("hi")
    return a_star + 5(size(grid, 2)-2)

end

@show solve(p2_grid)