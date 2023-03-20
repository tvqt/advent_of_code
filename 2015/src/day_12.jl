using JSON
file_path = "2015/data/day_12.txt"

input = read(file_path, String)
@show sum([parse(Int, input[x]) for x in findall(r"(-?\d+)", input)])

part_two = JSON.parse(input)

function item_parser(item::Dict)::Int
    if "red" in values(item)
        println("red!!")
        #print values from Dict line by lines

        return 0
    else
        total = 0
        for x in values(item)
            if typeof(x) <: Dict
                total += item_parser(x)
            elseif typeof(x) <: Vector

                total += item_parser(x)
            elseif typeof(x) <: Int
                total += x
            end
        end
    end
    return total
end

function item_parser(item::Array)::Int
    total = 0
    for (n, x) in enumerate(item)
        if typeof(x) <: Dict
            total += item_parser(x)
        elseif typeof(x) <: Vector
            total += item_parser(x)
        elseif typeof(x) <: Int
            total += x
        end
    end
    return total
end

@show sum([item_parser(x) for x in part_two])