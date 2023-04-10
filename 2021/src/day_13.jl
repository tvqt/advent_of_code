# Day 13: Transparent Origami
# https://adventofcode.com/2021/day/13

coords_path = "2021/data/day_13_coords.txt"
folds_path = "2021/data/day_13_folds.txt"

function clean_input(coords_path=coords_path, folds_path=folds_path)::Tuple{Set{Vector{Int64}}, Vector{Vector{Any}}} # returns a set of coordinates and a vector of folds
    coords = Set()
    for line in readlines(coords_path)
        push!(coords, [parse(Int, x)+1 for x in split(line, ",")]) # coords are of the form [x, y]. We add 1 to each coordinate to make the coordinates 1-indexed
    end
    folds = []
    for line in readlines(folds_path)
        push!(folds, [split(line, "=")[1], parse(Int, split(line, "=")[2])+1]) # folds are of the form ["x" or "y", fold_value]. We add 1 to the fold value to make the coordinates 1-indexed
    end
    return coords, folds
end
coords, folds = clean_input()

function fold_(coords::Vector{Int64}, fold::Vector{Any})::Vector{Int64} # returns the coordinates after folding
   return fold[1] == "x" ? foldleft(coords, fold[2]) : foldup(coords, fold[2]) # fold[1] is either "x" or "y"
end

function fold_all(all_coords::Set{Vector{Int64}}, fold::Vector{Any})::Set{Vector{Int64}} # returns the set of coordinates after folding
    out = Set()
    for coords in all_coords
        push!(out, fold_(coords, fold))
    end
    return out
end

foldup(coords, fold) = coords[2] < fold ? [coords[1], coords[2]] : [coords[1], fold - (coords[2] - fold)] # if the y coordinate is less than the fold, the coordinates are unchanged. Otherwise, the y coordinate is changed to fold - (y - fold)

foldleft(coords,fold) = coords[1] < fold ? [coords[1], coords[2]] : [fold - (coords[1] - fold), coords[2]] # if the x coordinate is less than the fold, the coordinates are unchanged. Otherwise, the x coordinate is changed to fold - (x - fold)


function solve(coords::Set{Vector{Int64}}=coords, folds::Vector{Vector{Any}}=folds)::Set{Vector{Int64}} # returns the set of coordinates after folding
    first_fold = false
    for fold in folds
        coords = fold_all(coords, fold)
        if !first_fold
            first_fold = true
            println(length(coords)) # part 1
        end
    end
    return coords
end

function print_solution(coords=solve())
    # get the dimensions of the solution
    min_x, max_x, min_y, max_y = minimum([x[1] for x in coords]), maximum([x[1] for x in coords]), minimum([x[2] for x in coords]), maximum([x[2] for x in coords])

    # create a matrix of the solution
    solution = zeros(max_y-min_y+1, max_x-min_x+1)
    [solution[coord[2]-min_y+1, coord[1]-min_x+1] = 1 for coord in coords]
     
    # print the solution
    for row in 1:size(solution)[1]
        for col in 1:size(solution)[2]
            print(solution[row, col] == 1 ? "⬛️" : "⬜️")
        end
        println()
    end
end
print_solution()