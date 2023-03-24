# https://adventofcode.com/2016/day/9
input = read("2016/data/day_9.txt", String)



function part1(input=input )
  out = ""
  i = 1
  while i <= length(input)
    if input[i] == '('
      subsequent, times = [parse(Int, x) for x in match(r"\((\d+)x(\d+)\)", input[i:end]).captures]
      sublist = repeat(input[i+length(string(subsequent, times)*"(x)"):i+length(string(subsequent, times)*"(x)")+subsequent-1], times)
      if part == 1 || length(findall("(", sublist)) == 0
        out *= sublist
        i += length(string(subsequent, times)*"(x)") + subsequent
      else
        input = input[1:i] * sublist * input[i+length(string(subsequent, times)*"(x)") + subsequent:end]
        i += 1
      end
    else
      out *= input[i]
      i += 1
    end
    
  end
  return out

end
function part2(input=input)
  p2_vec = [1 for i in 1:length(input)]
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


@show p2 = part2()
@show length(p1)
@show length(part_1(p1))
