# File: julia-async-05.jl
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

# println("")
# @show start_blocking() ## EXECUTE FUNCTION

# ===============
function start_async()
    start_time = time()
    task1 = @async do_some_work(10)   ### ASSIGN async TO function TO task

    while !istaskdone(task1)
        # println("start() is waiting for do_some_work() to be done")
        sleep(0.2)
        println(Dates.time(), " istaskdone(task1) = ", istaskdone(task1));
    end
end

# println("")
# @show start_async() ## EXECUTE FUNCTION

# =================
function start_async_print()
    start_time = time()
    t = @async try
        do_some_work(10)
    catch err
        bt = catch_backtrace()
        println()
        showerror(stderr, err, bt)
    end
    while !istaskdone(t)
        sleep(0.1)
        println(Dates.time(), " Execute istaskdone(t) on every sleep = ", istaskdone(t))
        #sleep(0.5)
    end
end

println("=== Execute @show start_async_print()")
@show start_async_print() ## EXECUTE FUNCTION


"""



# EXECUTE TASK
task2 = @task @async do_some_work(10)
@show task2
schedule(task2);
yield();
@show task2

task3 = @task do_some_work(10)
@show task3
schedule(task3);
yield();
@show task3

# task4 = @async @task do_some_work(10)
# schedule(task4);
# yield();
# @show task4
"""


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
function start_async_throw()
    start_time = time()
    t = do_some_work(10)
    while !istaskdone(t)
  
        sleep(1)
    end
    wait(t) # or fetch(t)
end
===========================

wruslan@HPEliteBk8470p-ub1604-64b:~/Documents/julia-async# julia julia-async-05.jl 
1.562989695322423e9 Current date today() = 2019-07-13
1.562989695448145e9 Current date time now: 2019-07-13T11:48:15.448
1.562989695550221e9 Bismillah from WRY in Julia script. 

=== Execute @show start_async_print()
1.562989695631627e9 start_time = 1.562989695631627e9
1.562989695705123e9 Execute istaskdone(t) on every sleep = false
1.562989695817745e9 Execute istaskdone(t) on every sleep = false
1.562989695848012e9 total = 10.0
1.562989695918293e9 Execute istaskdone(t) on every sleep = false
1.562989696019587e9 Execute istaskdone(t) on every sleep = false
1.562989696049803e9 total = 20.0
1.562989696121076e9 Execute istaskdone(t) on every sleep = false
1.562989696222368e9 Execute istaskdone(t) on every sleep = false
1.562989696250619e9 total = 30.0
1.562989696323904e9 Execute istaskdone(t) on every sleep = false
1.562989696425185e9 Execute istaskdone(t) on every sleep = false
1.562989696451388e9 total = 40.0
1.562989696526648e9 Execute istaskdone(t) on every sleep = false
1.562989696627943e9 Execute istaskdone(t) on every sleep = false
1.562989696652148e9 total = 50.0
1.562989696729428e9 Execute istaskdone(t) on every sleep = false
1.562989696830696e9 Execute istaskdone(t) on every sleep = false
1.562989696853927e9 total = 60.0
1.562989696931204e9 Execute istaskdone(t) on every sleep = false
1.562989697032491e9 Execute istaskdone(t) on every sleep = false
1.562989697055714e9 total = 70.0
1.562989697134022e9 Execute istaskdone(t) on every sleep = false
1.562989697235281e9 Execute istaskdone(t) on every sleep = false
1.56298969725649e9 total = 80.0
1.562989697336758e9 Execute istaskdone(t) on every sleep = false
1.562989697438012e9 Execute istaskdone(t) on every sleep = false
1.562989697457235e9 total = 90.0
1.562989697539526e9 Execute istaskdone(t) on every sleep = false
1.5629896976408e9 Execute istaskdone(t) on every sleep = false
1.56298969765902e9 total = 100.0
1.562989697741306e9 Execute istaskdone(t) on every sleep = true
start_async_print() = nothing


1.562989697798895e9 Alhamdulillah from WRY in Julia script. 

wruslan@HPEliteBk8470p-ub1604-64b:~/Documents/julia-async#

"""

