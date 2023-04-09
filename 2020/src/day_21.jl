# https://adventofcode.com/2020/day/21

file_path = "2020/data/day_21.txt"

function clean_input(file_path=file_path)::Vector{Tuple{Vector{String},Vector{String}}}
    out = []
    for line in readlines(file_path)
        line = split(line, "(")
        ingredients = split(line[1][1:end-1], " ")
        allergens = split(replace(line[2][1:end-1], "contains " => ""), ", ")
        push!(out, (ingredients, allergens))
    end
    return out
end
input = clean_input()


function potential_allergens(input=input)
    allergen_dict = Dict()
    for (ingredients, allergens) in input
        for allergen in allergens
            if !haskey(allergen_dict, allergen)
                allergen_dict[allergen] = ingredients
            else
                allergen_dict[allergen] = intersect(allergen_dict[allergen], ingredients)
            end
        end
    end
    return allergen_dict
end

function part_1(allergen_dict=potential_allergens())
    allergen_ingredients = vcat(values(allergen_dict)...)
    all_ingredients = vcat([x[1] for x in input]...)
    return length(filter(x -> x ∉ allergen_ingredients, all_ingredients))
end
@show part_1()

function part_2(allergen_dict=potential_allergens())
    out_dict= Dict()
    #filter allergen_dict to only those where the length is 1
    while length(allergen_dict) > 0
        only_one = filter(x -> length(x[2]) == 1, allergen_dict)
        for (k, v) in only_one
            out_dict[k] = v[1]
            delete!(allergen_dict, k)
            for (k2, v2) in allergen_dict
                allergen_dict[k2] = filter(x -> x != v[1], v2)
            end
        end
    end
    # return the values of out_dict sorted by key
    return join([x[2] for x in sort(collect(out_dict))], ",")
end
@show part_2()