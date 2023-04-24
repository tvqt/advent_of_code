# https://adventofcode.com/2021/day/20

file_path = "2021/data/day_20.txt"

algo_string = convert(Vector{Int8}, split(readline(file_path), "") .== "#")

jpg= convert(Matrix{Int8}, permutedims(hcat(split.(readlines(file_path)[3:end], "")...)) .== "#")

# for each pixel get the enhancement number of a pixel. If the number is on the edge, then it is the bordernum. The empty space flickers between 1 and 0. 
enhancement_number(c::CartesianIndex{2}, image, bordernum) = parse(Int, join((c + x in CartesianIndices(image) ? image[c + x] : bordernum) for x in [CartesianIndex(-1, -1), CartesianIndex(-1, 0), CartesianIndex(-1, 1), CartesianIndex(0, -1), CartesianIndex(0, 0), CartesianIndex(0, 1), CartesianIndex(1, -1), CartesianIndex(1, 0), CartesianIndex(1, 1)]), base=2) + 1  # 1-indexed

# get the nth item of algo_string, where n is the enhancement number of the original pixel
pixel(c::CartesianIndex{2}, image, algo_string, bordernum) = algo_string[enhancement_number(c, image, bordernum)] #

function enhancement_algo(image, algo_string, fun, border=1)
    # add a border of ones or zeros to the image
    image = hcat(fun(Int8, size(image, 1), border), image, fun(Int8, size(image, 1), border)) # left and right sides
    image = vcat(fun(Int8, border, size(image, 2)), image, fun(Int8, border, size(image, 2))) # top and bottom sides
    out = zeros(Int8, size(image))
    bordernum = fun == ones ? 1 : 0
    return [pixel(c, image, algo_string, bordernum) for c in CartesianIndices(image)]
end

function solve(image, algo_string, a=2, b=50)
    fun = zeros
    for i in 1:b
        image = enhancement_algo(image, algo_string, fun)
        fun = fun == zeros ? ones : zeros
        if i == a
            println("Part 1: ", sum(image))
        end
    end
    println("Part 2: ", sum(image))
end

solve(jpg, algo_string)


