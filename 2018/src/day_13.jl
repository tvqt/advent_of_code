# Day 13: Mine Cart Madness
# https://adventofcode.com/2018/day/13
using DataStructures
file_path = "2018/data/day_13.txt"

function clean_input(file_path=file_path)
    mat = zeros(Int, length(readline(file_path)), length(readlines(file_path)))
    carts = Dict()
    input = readlines(file_path)
    for (l, line) in enumerate(input)
        for (i, c) in enumerate(line)
            if c == '|'
                mat[i, l] = 1
            elseif c == '-'
                mat[i, l] = 2
            elseif c == '/'
                mat[i, l] = 3
            elseif c == '\\'
                mat[i, l] = 4
            elseif c == '+'
                mat[i, l] = 5
            elseif c ∈ ['<', '>', '^', 'v']
                up = input[l-1][i] ∈ ['|', '+', '/', '\\', '^', 'v'] ? true : false
                down = input[l+1][i] ∈ ['|', '+', '/', '\\', '^', 'v'] ? true : false
                left = input[l][i-1] ∈ ['-', '+', '/', '\\', '<', '>'] ? true : false
                right = input[l][i+1] ∈ ['-', '+', '/', '\\', '<', '>'] ? true : false

                if up && down && left && right
                    mat[i, l] = 5
                elseif up && down 
                    mat[i, l] = 1
                elseif left && right
                    mat[i, l] = 2
                elseif up && left || down && right
                    mat[i, l] = 3
                elseif up && right || down && left
                    mat[i, l] = 4
                else
                    throw("Error")
                end
                if c == '<'
                    carts[(i, l)] = [270, "L"]
                elseif c == '>'
                    carts[(i, l)] = [90, "L"]
                elseif c == '^'
                    carts[(i, l)] = [0, "L"]
                elseif c == 'v'
                    carts[(i, l)] = [180, "L"]
                end
            elseif c == ' '
                mat[i, l] = 0
            else
                throw("Error")
            end


        end
    end
    return mat, carts
end


cart_check(cart, mat) = mat[cart] > 5 ? true : false

function turn_plus(cart, carts=carts)
    if carts[cart][2] == "L"
        carts[cart][1] = carts[cart][1] == 0 ? 270 : carts[cart][1] - 90
        carts[cart][2] = "S"
    elseif carts[cart][2] == "S"
        carts[cart][2] = "R"
    elseif carts[cart][2] == "R"
        carts[cart][1] = carts[cart][1] == 270 ? 0 : carts[cart][1] + 90
        carts[cart][2] = "L"
    else
        throw("Error")
    end
    return carts
end
function turn_3(cart, carts)
    if carts[cart][1] == 0
        carts[cart][1] = 90
    elseif carts[cart][1] == 90
        carts[cart][1] = 0
    elseif carts[cart][1] == 180
        carts[cart][1] = 270
    elseif carts[cart][1] == 270
        carts[cart][1] = 180
    else
        throw("Error")
    end
end

function turn_4(cart,carts)
    if carts[cart][1] == 0
        carts[cart][1] = 270
    elseif carts[cart][1] == 90
        carts[cart][1] = 180
    elseif carts[cart][1] == 180
        carts[cart][1] = 90
    elseif carts[cart][1] == 270
        carts[cart][1] = 0
    else
        throw("Error")
    end
end

function turn_cart!(cart, carts, mat)
    if mat[cart[1], cart[2]] == 3
        turn_3(cart, carts)
    elseif mat[cart[1], cart[2]] == 4
        turn_4(cart, carts)
    elseif mat[cart[1], cart[2]] == 5
        turn_plus(cart, carts)
    else
        throw("Error")
    end
end

function move_cart!(cart, crash, carts=carts, mat=mat )
    if cart ∉ keys(carts)
        return
    end
    if mat[cart[1], cart[2]] ∈ [3, 4, 5]
        turn_cart!(cart, carts, mat)
    end
    if carts[cart][1] == 0
        new_cart = (cart[1], cart[2] - 1)
    elseif carts[cart][1] == 90
        new_cart = (cart[1] + 1, cart[2])
    elseif carts[cart][1] == 180
        new_cart = (cart[1], cart[2] + 1)
    elseif carts[cart][1] == 270
        new_cart = (cart[1] - 1, cart[2])
    else
        throw("Error")
    end
    
    if crash == false && new_cart in keys(carts)
        println("Crash at $(new_cart[1]-1),$(new_cart[2]-1)")
        delete!(carts, new_cart)
        crash == true
    else
        carts[new_cart] = carts[cart]
    end
    delete!(carts, cart)
end

function solve(input=clean_input())
    mat, carts = input
    crash = false
    while length(carts) > 1        
        for cart in sort(collect(keys(carts)), by = x -> (x[2], x[1]))
            move_cart!(cart, crash, carts, mat)
        end
    end
    return carts
end
@show solve()
