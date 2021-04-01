# File: julia-async-02.jl
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
    println(Dates.time(), " start_time = ", start_time);

    while (time() - start_time) < 2  # perform within 2 seconds
        total += increment
        sleep(0.2)   ## 10 times perform while loop
	println(Dates.time(), " total = ", total);
    end #endwhile 

    return (total)
end; #endfunction

# println("")
# @show do_some_work(1)  ## EXECUTE FUNCTION

# ==============
function start_blocking()
    println("start() is waiting for do_some_work() to be done")
    # do_some_work(5)     ## EXECUTE FUNCTION
    return do_some_work(5)     ## EXECUTE FUNCTION
end; #endfunction

println("")
@show start_blocking() ## EXECUTE FUNCTION

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
wruslan@HPEliteBk8470p-ub1604-64b:~/Documents/julia-async# julia julia-async-02.jl 
1.562986204114317e9 Current date today() = 2019-07-13
1.562986204267395e9 Current date time now: 2019-07-13T10:50:04.267
1.56298620437015e9 Bismillah from WRY in Julia script. 


start() is waiting for do_some_work() to be done
1.562986204425399e9 start_time = 1.562986204425399e9
1.562986204642274e9 total = 5.0
1.562986204843678e9 total = 10.0
1.56298620504509e9 total = 15.0
1.562986205246514e9 total = 20.0
1.562986205447917e9 total = 25.0
1.562986205649307e9 total = 30.0
1.562986205850711e9 total = 35.0
1.562986206052115e9 total = 40.0
1.562986206253542e9 total = 45.0
1.56298620645494e9 total = 50.0
start_blocking() = 50.0


1.562986206489522e9 Alhamdulillah from WRY in Julia script. 

wruslan@HPEliteBk8470p-ub1604-64b:~/Documents/julia-async# 

"""

