# Day 19: Go With The Flow
# https://adventofcode.com/2018/day/19

file_path ="2018/data/day_21.txt"
registers = []

addr(a, b, c, registers) = (registers[c+1] = registers[a+1] + registers[b+1]); return registers;
addi(a, b, c, registers) = (registers[c+1] = registers[a+1] + b); return registers;
mulr(a, b, c, registers) = (registers[c+1] = registers[a+1] * registers[b+1]); return registers;
muli(a, b, c, registers) = (registers[c+1] = registers[a+1] * b); return registers;
banr(a, b, c, registers) = (registers[c+1] = registers[a+1] & registers[b+1]) ; return registers;
bani(a, b, c, registers) = (registers[c+1] = registers[a+1] & b); return registers;
borr(a, b, c, registers) = (registers[c+1] = registers[a+1] | registers[b+1]); return registers;
bori(a, b, c, registers) = (registers[c+1] = registers[a+1] | b); return registers;
setr(a, b, c, registers) = (registers[c+1] = registers[a+1]); return registers;
seti(a, b, c, registers) = (registers[c+1] = a); return registers;
gtir(a, b, c, registers) = (registers[c+1] = a > registers[b+1] ? 1 : 0); return registers;
gtri(a, b, c, registers) = (registers[c+1] = registers[a+1] > b ? 1 : 0); return registers;
gtrr(a, b, c, registers) = (registers[c+1] = registers[a+1] > registers[b+1] ? 1 : 0); return registers;
eqir(a, b, c, registers) = (registers[c+1] = a == registers[b+1] ? 1 : 0); return registers;
eqri(a, b, c, registers) = (registers[c+1] = registers[a+1] == b ? 1 : 0); return registers;
eqrr(a, b, c, registers) = (registers[c+1] = registers[a+1] == registers[b+1] ? 1 : 0); return registers;

function clean_input(f=file_path)
    [(getfield(Main, Symbol(line[1])), parse(Int, line[2]), parse(Int, line[3]), parse(Int, line[4])) for line in split.(readlines(f)[2:end])]
end
@show clean_input()