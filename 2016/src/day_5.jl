# Day 5: How About a Nice Game of Chess?
# https://adventofcode.com/2016/day/5
# this runs quite sorry, unfortunately. My apologies!

using MD5

file_path = "2016/data/day_5.txt"
input = read(file_path, String)

function part_1(input::String)::String
    n = 0
    password = ""
    while true
        n+=1
        if bytes2hex(md5(input*string(n)))[1:5] == "00000" # if the first 5 characters of the md5 hash are 0
            password *= bytes2hex(md5(input*string(n)))[6] # add the 6th character to the password
            if length(password) == 8 # if the password is 8 characters long
                return password # return the password
            end
        end
    end
end

function part_2(input::String)::String
    n = 0
    password = "XXXXXXXX"
    while true
        n+=1
        val = bytes2hex(md5(input*string(n)))
        if val[1:5] == "00000" # as before, find numbers which have a hash which start with five 0s
            position = val[6] # get position
            character = val[7] # get character
            if position in '0':'7' && password[parse(Int, position)+1] == 'X' # if the position is between 0 and 7 and the position in the password has yet to be filled, then replace the X with the character
                password = password[1:parse(Int, position)]*character*password[parse(Int, position)+2:end] # this is a bit of a mess but I think I wrote it this way because the password is saved as a string, and I don't think they are mutable
            end
            if !('X' in password) # if all of the characters in the string have been found, then return the password
                return password
            end
        end
    end
end

@show part_1(input)
@show part_2(input)
