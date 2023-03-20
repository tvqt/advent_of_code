# https://adventofcode.com/2015/day/6
# Day 6: Probably a Fire Hazard

function clean_input(s::String) # "turn on 0,0 through 999,999" -> ["turn", "on", "0,0", "through", "999,999"]
    s = split(s)
    if s[1] == "turn"
        s = s[2:end]
    end
    start_coords = parse.(Int,split(s[2], ",")) .+1
    end_coords = parse.(Int,split(s[4], ",")) .+1
    return [s[1],start_coords, end_coords]
end

input = [input_cleaner(x) for x in readlines("2015/data/day_6.txt")]


function solve(part::Int=1, input=input) 
    matrix = zeros(1000, 1000) # 1000x1000 grid
    for i in input # 
        if i[1] == "on" # if instruction is turn on
            if part == 1
             matrix[i[2][1]:i[3][1], i[2][2]:i[3][2]] .= true # turn on all lights in the range
            else
                matrix[i[2][1]:i[3][1], i[2][2]:i[3][2]] .+= 1 # increase brightness by 1
            end
        elseif i[1] == "off" # if instruction is turn off
            if part == 1
                matrix[i[2][1]:i[3][1], i[2][2]:i[3][2]] .= false # turn off all lights in the range
            else
                matrix[i[2][1]:i[3][1], i[2][2]:i[3][2]] .-= 1 # decrease brightness by 1
                matrix[matrix .< 0] .= 0
            end
        elseif i[1] == "toggle" # if instruction is toggle
            if part == 1
                matrix[i[2][1]:i[3][1], i[2][2]:i[3][2]] .= abs.(matrix[i[2][1]:i[3][1], i[2][2]:i[3][2]] .-1) # toggle all lights in the range
            else
                matrix[i[2][1]:i[3][1], i[2][2]:i[3][2]] .+= 2 # increase brightness by 2
            end
        end
    end
    return BigInt(sum(matrix)) #return the number of lights that are on
end
@show solve(1)
@show solve(2)