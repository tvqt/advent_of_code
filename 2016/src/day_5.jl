# Day 5: How About a Nice Game of Chess?
# https://adventofcode.com/2016/day/5

using MD5

file_path = "2016/data/day_5.txt"
input = read(file_path, String)

function part_1(input::String)::String
    n = 0
    password = ""
    while true
        n+=1
        if bytes2hex(md5(input*string(n)))[1:5] == "00000"
            password *= bytes2hex(md5(input*string(n)))[6]
            if length(password) == 8
                return password
            end
        end
    end
end

function part_2(input::String)::String
    n = 0
    password = "XXXXXXXX"
    while true
        n+=1
        if bytes2hex(md5(input*string(n)))[1:5] == "00000"
            position = bytes2hex(md5(input*string(n)))[6]
            character = bytes2hex(md5(input*string(n)))[7]
            if position in '0':'7' && password[parse(Int, position)+1] == 'X'
                password = password[1:parse(Int, position)]*character*password[parse(Int, position)+2:end]
            end
            if !('X' in password)
                return password
            end
        end
    end
end

@show part_1(input)
@show part_2(input)
