# https://adventofcode.com/2016/day/21

file_path = "2016/data/day_21.txt"
password = "abcdefgh"
scrambled_password = "fbgdceah"

function solve(password=password, decrypt=false, file_path=file_path)
    password = collect(password)
    out = []
  
    input = !decrypt ? readlines(file_path) : reverse(readlines(file_path))
    for line in input
        push!(out, join(password))
        #println(join(password))
        line = split(line)
        if join(password) == "hfcdbaeg"
            #println("here")
        end
        
        if line[1] == "swap" && line[2] == "position"
            x, y = parse(Int, line[3])+1, parse(Int, line[6])+1
            password[y], password[x] = password[x], password[y]
        elseif line[1] == "swap" && line[2] == "letter"
            x = findfirst(x -> x == line[3][1], password)
            y = findfirst(x -> x == line[6][1], password)
            password[x], password[y] = password[y], password[x]
        elseif line[1] == "rotate" 
            if line[2] != "based"
                degree = parse(Int, line[3]) * (line[2] == "left" ? -1 : 1)
                degree = decrypt ? -degree : degree
                password = circshift(password, degree)
            else
                x = findfirst(x -> x == line[7][1], password) -1
                degree = x >= 4 ? x + 2 : x + 1
                if decrypt
                    if x in [0,1]
                        degree = 7
                    elseif x  in [2, 5]
                        degree = x
                    elseif x == 3
                        degree = 6
                    elseif x == 4
                        degree = 1
                    elseif x == 6
                        degree = 0
                    elseif x == 7
                        degree = 4
                    end
                end
                circshift!(password, degree)
            end
        elseif line[1] == "reverse"
            x, y = parse(Int, line[3])+1, parse(Int, line[5])+1
            password[x:y] = reverse(password[x:y])
        elseif line[1] == "move"
            x, y = parse(Int, line[3])+1, parse(Int, line[6])+1
            x, y = decrypt ? y : x, decrypt ? x : y
            removed = splice!(password, x)
            insert!(password, y, removed)
        else
            throw("error: $(line)")
        end
    end
    return join(password)
end

#@show solve(password)
@show solve(scrambled_password, true)

