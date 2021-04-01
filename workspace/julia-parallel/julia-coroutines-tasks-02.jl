# File: julia-coroutines-tasks-02.jl
# Date:     Tue Jul  9 22:02:54 +08 2019
# Modified: 
# =========================================================
"""
https://docs.julialang.org/en/v1/manual/control-flow/#man-tasks-1

https://www.quora.com/Does-the-Julia-programming-language-have-asynchronous-features

# https://stackoverflow.com/questions/41928047/julia-lang-cache-data-in-a-parallel-thread-using-async?rq=1

Instead, Julia can schedule any function for asynchronous execution using the @async macro, which returns a scheduled task that you can wait for later. While you don’t have to do anything, you may want to sprinkle some calls to yield() around your code, so scheduled tasks get a chance to run. All IO in will be handled in a non-blocking manner.


"""
# =========================================================
using Dates 
print(Dates.time(), " Current date today() = ", Dates.today(), "\n")
print(Dates.time(), " Current date time now: ", Dates.now(), "\n")
print(Dates.time(), " Bismillah from WRY in Julia script. \n\n") 
using InteractiveUtils
import InteractiveUtils
# show(versioninfo());
println("\n");
# =========================================================

#c1 = Channel(32)
#c2 = Channel(32)

function producer(c::Channel)
   put!(c, "start")
   for n=1:4
       inp = put!(c, 2n)
       println(Dates.time(), " Value put!(chnl) = ", inp)
   end
   put!(c, "stop")
end;

chnl = Channel(producer);

# ==============================
function taker(c::Channel)
   for n=1:6
       outp = take!(chnl)
       println(Dates.time(), " Value take!(chnl) = ", outp)
   end
end;

result = taker(chnl)

show(result)


# ==============================
# f = open("file")
try
    # operate on file f
    # return x
catch
    # ha ha ha

finally
    # close(f)
end



# =========================================================
print("\n\n", Dates.time(), " Alhamdulillah from WRY in Julia script. \n\n") 
# =========================================================

"""
EXECUTION

wruslan@HPEliteBk8470p-ub1604-64b:~/Documents/julia-parallel# julia julia-coroutines-tasks-02.jl | sort

1.562762976168678e9 Current date today() = 2019-07-10
1.562762976320715e9 Current date time now: 2019-07-10T20:49:36.32
1.56276297642077e9 Bismillah from WRY in Julia script. 
1.562762976554125e9 Value take!(chnl) = start
1.56276297657184e9 Value put!(chnl) = 2
1.56276297660766e9 Value take!(chnl) = 2
1.562762976625693e9 Value take!(chnl) = 4
1.562762976625806e9 Value put!(chnl) = 4
1.562762976625867e9 Value take!(chnl) = 6
1.562762976625901e9 Value put!(chnl) = 6
1.562762976625944e9 Value take!(chnl) = 8
1.562762976625979e9 Value put!(chnl) = 8
1.56276297662602e9 Value take!(chnl) = stop
1.562762976767943e9 Alhamdulillah from WRY in Julia script. 
wruslan@HPEliteBk8470p-ub1604-64b:~/Documents/julia-parallel# 

"""

