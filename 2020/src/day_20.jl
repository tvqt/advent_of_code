# Day 20: Jurassic Jigsaw
# https://adventofcode.com/2020/day/20

file_path = "2020/data/day_20.txt"

function clean_input(file_path=file_path)
    out = Dict()
    row = 1
    new_tile = zeros(Bool, 10, 10)
    tile_id = 0
    for line in readlines(file_path)
        if line == ""
            out[tile_id] = new_tile
        elseif split(line)[1] == "Tile"
            new_tile = zeros(Bool, 10, 10)
            row = 1
            tile_id = parse(Int, split(line)[2][1:end-1])
        else
            new_tile[row, :] = split(line, "") .== "#"
            row += 1
        end
    end
    return out
end


function tile_edges(tile)
    return [tile[1, :], tile[:, end], tile[end, :],  tile[:, 1]] # top, right, bottom, left 
end


function unique_edges(edges, edge_dict=all_edges_dict()) 
    return [edge in all_other_edges(edges, edge_dict) for edge in edges]

end

all_edges_dict(tile_dict=clean_input()) = Dict(tile_id => tile_edges(tile) for (tile_id, tile) in tile_dict)


function all_other_edges(edges, edge_dict=all_edges_dict())
    vals = unique(vcat((values(filter(x -> x[2] != edges, edge_dict)))...))
    return vcat(vals,[reverse(x) for x in vals])
end


function part_1(input=clean_input(), edge_dict= all_edges_dict())
    unique_edge_dict = Dict(tile_id => unique_edges(edges, edge_dict) for (tile_id, edges) in edge_dict)
    
    return filter!(x -> sum(x[2]) == 2, unique_edge_dict)
end

@show part_1()

# get the number of duplicates of each edge in the edge_dict
function edge_counts(edge_dict=all_edges_dict())
    edge_counts = Dict()
    for edge in unique(vcat(values(edge_dict)...))
        edge_counts[edge] = count(x -> x == edge, all_other_edges(edge, edge_dict)) + 1
    end
    return filter!(x -> x[2] > 3, edge_counts)
end
@show edge_counts()

function assemble_picture(p1=part_1())
    potential_images = Set([zeros(Int, 12,12)])
    while length(potential_images) > 0
        image = pop!(potential_images)
        
    end


    
    
    return picture
end


rotate_right(matrix) = reverse(transpose(matrix), dims=1)
rotate_left(matrix) = transpose(reverse(matrix, dims=2))
rotate180(matrix) = reverse(reverse(matrix, dims=1), dims=2)
flip_left_to_right(matrix) = reverse(matrix, dims=2)
flip_top_to_bottom(matrix) = reverse(matrix, dims=1)
flip_both(matrix) = flip_left_to_right(flip_top_to_bottom(matrix))

matrix_vars(matrix) = [matrix, rotate_right(matrix), rotate180(matrix), rotate_left(matrix), flip_left_to_right(matrix), flip_top_to_bottom(matrix)]
function matrix_variants(matrix)
    out = matrix_vars(matrix)
    push!(matrix_vars(flip_left_to_right(matrix)), out...)
    push!(matrix_vars(flip_top_to_bottom(matrix)), out...)
    push!(matrix_vars(flip_both(matrix)), out...)
    return out
end
1


@show assemble_picture()






