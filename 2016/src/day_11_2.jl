# Day 11: Radioisotope Thermoelectric Generators
# https://adventofcode.com/2016/day/11

# I spent probably over twelve hours on this problem, creating a variety of different programs that all failed to get the right solution. I ended up porting a Python program to Julia, and it worked on the first try. I'm not sure what I did wrong, but I'm glad I got it working in the end. The original Julia program is in the other file. Below is the ported progam, which I subsequently golfed for fun. Shoutout to narimiran

using DataStructures


h(g, c, l) = join(string.([[count(ch -> ch == Char(i), x) for i in '1':'4'] for x in [g, c]]...)) * string(l)
i(g,c,l)=l∉1:4||any(([k≠j&&any(i.==k for i in g) for(j, k) in zip(g,c)]))
s(p)=all(p.==4)
g(p,l,s)=join(string.(p[1:end÷2])),join(string.(p[end÷2+1:end])),l,s
n(f,p,l,s,i,j=0)=(p[i]+=f;j!=0&&(p[j]+=f);o=g(copy(p),l+f,s+1);p[i]-=f;j!=0&&(p[j]-=f);o)
function 🖩(⚡️,🍟,🛗,🪜);👀=Set();📝=Deque{Tuple}();push!(📝,(⚡️,🍟,🛗,🪜));while !isempty(📝);⚡️,🍟,🛗,🪜=popfirst!(📝);🎄=parse.(Int,split(⚡️*🍟,""));🖂=h(⚡️,🍟,🛗);(🖂∈👀||i(⚡️,🍟,🛗))&&continue;s(🎄)  && return 🪜;push!(👀, 🖂);;for (i,💖) in enumerate(🎄);if 💖==🛗;🛗<4&&push!(📝,n(1,🎄,🛗,🪜,i));🛗>1&&push!(📝,n(-1,🎄,🛗,🪜,i));for (j,💕) in enumerate(🎄);j<=i&&continue;if 💕==🛗;🛗<4&&push!(📝,n(1,🎄,🛗,🪜,i,j));🛗>1&&push!(📝,n(-1,🎄,🛗,🪜,i,j));end;end;end;end;end;end
@show 🖩("12222", "13333", 1, 0)
@show 🖩("1222211", "1333311", 1, 0)