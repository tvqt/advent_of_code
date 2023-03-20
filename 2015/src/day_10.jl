input = "3113322113"




function look_and_say(input::String)::String
    output = ""
    i = 1
    while i <= length(input)
        count = 1
        while i < length(input) && input[i] == input[i+1]
            count += 1
            i += 1
        end
        output = output * string(count) * input[i]
        i += 1
    end
    return output
end

# look and say n times
function look_and_say_n(input::String, n::Int)::String
    for i in 1:n
        input = look_and_say(input)
        println(i)
    end
    return input
end
part_1 = look_and_say_n(input, 40)


part_2 = length(look_and_say_n(part_1,10))
@show length(part_1)
@show part_2