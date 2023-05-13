# Day 9: Explosives in Cyberspace
# https://adventofcode.com/2016/day/9
# one of my least favourite ones tbh! I don't like these bracket-based problems, they always give me grief argh :'-(

input = read("2016/data/day_9.txt", String)

function part1(input=input)
  out = ""
  i = 1
  while i <= length(input) # until we reach the end of the input
    if input[i] == '('
      out, i = process_marker(input, out, i, 1)
    else
      out *= input[i]
      i += 1
    end
  end
  return out
end

function process_marker(input, out, i, part) #this just does the orthodox way of solving it, by expanding out the input part by part
  subsequent, times = [parse(Int, x) for x in match(r"\((\d+)x(\d+)\)", input[i:end]).captures]
  sublist = repeat(input[i+length(string(subsequent, times)*"(x)"):i+length(string(subsequent, times)*"(x)")+subsequent-1], times)
  if part == 1 || length(findall("(", sublist)) == 0
    out *= sublist
    i += length(string(subsequent, times)*"(x)") + subsequent
  else
    input = input[1:i] * sublist * input[i+length(string(subsequent, times)*"(x)") + subsequent:end]
    i += 1
  end
  return out, i
end

function part2(input=input)
  p2_vec = [1 for i in 1:length(input)] # I found this idea on Reddit (thank you Reddit). The gist of it is that you have a vector of the same length as the input, with each value initialised at 1. Then, for each time you would ordinarily expand out a particular set of brackets, you instead just multiply the relevant area by whatever the multiple is. That way, you can keep track of the multiples without dealing with a ridiculously long string (like this line). Genius!
  i = 1
  while i <= length(input)
    if input[i] == '('
      subsequent, times = [parse(Int, x) for x in match(r"\((\d+)x(\d+)\)", input[i:end]).captures]
      p2_vec[i+length(string(subsequent, times)*"(x)"):i+length(string(subsequent, times)*"(x)")+subsequent-1] *= times
      p2_vec[i:i+length(string(subsequent, times)*"(x)")-1] .= 0
      i += length(string(subsequent, times)*"(x)")
    else
      i += 1
    end
  end
  return sum(p2_vec)
end

@show p1 = length(part1())
@show p2 = part2()

