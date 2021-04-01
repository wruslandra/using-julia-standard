# File: julia-async-01.jl
# Date:     Sat Jul 13 09:46:42 +08 2019
# Modified: 
# =========================================================
"""
MAKE task async

https://discourse.julialang.org/t/how-to-get-backtrace-of-async-task/18170

Note that currently Julia tasks are not scheduled to run on separate CPU cores.

https://docs.julialang.org/en/v1/manual/control-flow/#man-tasks-1
https://www.quora.com/Does-the-Julia-programming-language-have-asynchronous-features
# https://stackoverflow.com/questions/41928047/julia-lang-cache-data-in-a-parallel-thread-using-async?rq=1


Task(func)
Create a Task (i.e. coroutine) to execute the given function func (which must be callable with no arguments). The task exits when this function returns.

# Create functions with arguments
   task1 = @task myfunction1(3, 4);
   schedule(task1);
   yield();	

# Create functions with no arguments
   task3 = Task(myfunction3);
   schedule(task3);
   yield();

"""
# =========================================================
using Dates 
print(Dates.time(), " Current date today() = ", Dates.today(), "\n")
print(Dates.time(), " Current date time now: ", Dates.now(), "\n")
print(Dates.time(), " Bismillah from WRY in Julia script. \n") 
using InteractiveUtils
import InteractiveUtils
# show(versioninfo());
println("");
# =========================================================

# ===============
function do_some_work(increment::Real)
    total = 0.0
    start_time = time()

    while (time() - start_time) < 2  # perform within 2 seconds
        total += increment
        sleep(0.2)   ## 10 times perform while loop
	println(Dates.time(), " total = ", total);
    end #endwhile 

    return (total)
end; #endfunction

println("")
@show do_some_work(1)  ## EXECUTE FUNCTION

# ==============
function start_blocking()
    println("start() is waiting for do_some_work() to be done")
    # do_some_work(5)     ## EXECUTE FUNCTION
    return do_some_work(5)     ## EXECUTE FUNCTION
end; #endfunction

println("")
@show start_blocking()

"""
# EXAMPLE

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
"""


# =========================================================
print("\n\n", Dates.time(), " Alhamdulillah from WRY in Julia script. \n\n") 
# =========================================================

"""
EXECUTION
wruslan@HPEliteBk8470p-ub1604-64b:~/Documents/julia-async# julia julia-async-01.jl 
1.562985561924525e9 Current date today() = 2019-07-13
1.562985562077498e9 Current date time now: 2019-07-13T10:39:22.077
1.562985562179278e9 Bismillah from WRY in Julia script. 


1.562985562427029e9 total = 1.0
1.562985562642777e9 total = 2.0
1.56298556284416e9 total = 3.0
1.562985563045532e9 total = 4.0
1.562985563246934e9 total = 5.0
1.562985563448339e9 total = 6.0
1.562985563649742e9 total = 7.0
1.562985563851146e9 total = 8.0
1.562985564052544e9 total = 9.0
1.562985564253943e9 total = 10.0
do_some_work(1) = 10.0

start() is waiting for do_some_work() to be done
1.562985564500102e9 total = 5.0
1.562985564701478e9 total = 10.0
1.562985564902877e9 total = 15.0
1.562985565104266e9 total = 20.0
1.562985565305656e9 total = 25.0
1.562985565507026e9 total = 30.0
1.562985565708406e9 total = 35.0
1.562985565909781e9 total = 40.0
1.56298556611116e9 total = 45.0
1.562985566312532e9 total = 50.0
start_blocking() = 50.0


1.562985566313009e9 Alhamdulillah from WRY in Julia script. 

wruslan@HPEliteBk8470p-ub1604-64b:~/Documents/julia-async# 

"""

