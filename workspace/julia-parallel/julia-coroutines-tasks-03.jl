# File: julia-coroutines-tasks-03.jl
# Date:     Wed Jul 10 22:02:54 +08 2019
# Modified: 
# =========================================================
"""
https://docs.julialang.org/en/v1/manual/control-flow/#man-tasks-1

https://www.quora.com/Does-the-Julia-programming-language-have-asynchronous-features

# https://stackoverflow.com/questions/41928047/julia-lang-cache-data-in-a-parallel-thread-using-async?rq=1

Instead, Julia can schedule any function for asynchronous execution using the @async macro, which returns a scheduled task that you can wait for later. While you don’t have to do anything, you may want to sprinkle some calls to yield() around your code, so scheduled tasks get a chance to run. All IO in will be handled in a non-blocking manner.

Julia provides a Channel mechanism for solving this problem. A Channel is a waitable first-in first-out queue which can have multiple tasks reading from and writing to it.

Let's define a producer task, which produces values via the put! call. To consume values, we need to schedule the producer to run in a new task. A special Channel constructor which accepts a 1-arg function as an argument can be used to run a task bound to a channel. We can then take! values repeatedly from the channel object:




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
function producer1(c::Channel)
   put!(c, "start")
   for n=1:4
     inp = put!(c, n*n)
     println(Dates.time(), " Value put!(chnl) = ", inp)
   end
   put!(c, "stop")
end;

function producer2(c::Channel)
   put!(c, "start")
   for n=1:4
     inp = put!(c, 10*rand(n))
     println(Dates.time(), " Value put!(chnl) = ", inp)
   end
   put!(c, "stop")
end;

chnl1 = Channel(producer1);
chnl2 = Channel(producer2);

# ==============================
function taker1(c::Channel)
   for n=1:6
       outp = take!(chnl1)
       println(Dates.time(), " Value take!(chnl) = ", outp)
   end
end;

function taker2(c::Channel)
   for n=1:6
       outp = take!(chnl2)
       println(Dates.time(), " Value take!(chnl) = ", outp)
   end
end;

result1 = taker1(chnl1)
result2 = taker2(chnl2)


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

wruslan@HPEliteBk8470p-ub1604-64b:~/Documents/julia-parallel# julia julia-coroutines-tasks-03.jl 
1.56280988299078e9 Current date today() = 2019-07-11
1.562809883120149e9 Current date time now: 2019-07-11T09:51:23.12
1.562809883222795e9 Bismillah from WRY in Julia script. 



1.562809883617646e9 Value take!(chnl) = start
1.562809883635404e9 Value take!(chnl) = 1
1.562809883642498e9 Value put!(chnl) = 1
1.562809883654317e9 Value take!(chnl) = 4
1.562809883654339e9 Value put!(chnl) = 4
1.562809883654458e9 Value take!(chnl) = 9
1.56280988365447e9 Value put!(chnl) = 9
1.562809883654595e9 Value take!(chnl) = 16
1.562809883654606e9 Value put!(chnl) = 16
1.562809883654712e9 Value take!(chnl) = stop
1.562809883814172e9 Value take!(chnl) = start
1.562809883814294e9 Value take!(chnl) = [0.200631]
1.562809883814307e9 Value put!(chnl) = [0.200631]
1.562809884191297e9 Value take!(chnl) = [0.504428, 7.61231]
1.562809884191324e9 Value put!(chnl) = [0.504428, 7.61231]
1.562809884191553e9 Value take!(chnl) = [9.3095, 8.05555, 3.28402]
1.562809884191564e9 Value put!(chnl) = [9.3095, 8.05555, 3.28402]
1.562809884191847e9 Value take!(chnl) = [4.12072, 1.71847, 0.833844, 0.0246618]
1.562809884191856e9 Value put!(chnl) = [4.12072, 1.71847, 0.833844, 0.0246618]
1.562809884192171e9 Value take!(chnl) = stop


1.562809884192753e9 Alhamdulillah from WRY in Julia script. 

wruslan@HPEliteBk8470p-ub1604-64b:~/Documents/julia-parallel#


"""

