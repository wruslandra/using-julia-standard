# File: julia-async-03.jl
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
        println("start() is waiting for do_some_work() to be done")
        sleep(0.2)
        println(Dates.time(), " istaskdone(task1) = ", istaskdone(task1));
    end
end

println("")
@show start_async() ## EXECUTE FUNCTION




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
wruslan@HPEliteBk8470p-ub1604-64b:~/Documents/julia-async# julia julia-async-03.jl 
1.562986961223086e9 Current date today() = 2019-07-13
1.562986961349005e9 Current date time now: 2019-07-13T11:02:41.349
1.562986961451722e9 Bismillah from WRY in Julia script. 


start() is waiting for do_some_work() to be done
1.562986961530403e9 start_time = 1.562986961530403e9
1.56298696174636e9 istaskdone(task1) = false
start() is waiting for do_some_work() to be done
1.562986961746403e9 total = 10.0
1.562986961959516e9 istaskdone(task1) = false
start() is waiting for do_some_work() to be done
1.562986961959561e9 total = 20.0
1.562986962160996e9 istaskdone(task1) = false
start() is waiting for do_some_work() to be done
1.562986962161049e9 total = 30.0
1.562986962362514e9 istaskdone(task1) = false
start() is waiting for do_some_work() to be done
1.562986962362557e9 total = 40.0
1.562986962564e9 istaskdone(task1) = false
start() is waiting for do_some_work() to be done
1.562986962564038e9 total = 50.0
1.562986962765467e9 istaskdone(task1) = false
start() is waiting for do_some_work() to be done
1.562986962765508e9 total = 60.0
1.56298696296695e9 istaskdone(task1) = false
start() is waiting for do_some_work() to be done
1.562986962967e9 total = 70.0
1.562986963168481e9 istaskdone(task1) = false
start() is waiting for do_some_work() to be done
1.562986963168526e9 total = 80.0
1.562986963370005e9 istaskdone(task1) = false
start() is waiting for do_some_work() to be done
1.562986963370047e9 total = 90.0
1.562986963571494e9 istaskdone(task1) = false
start() is waiting for do_some_work() to be done
1.562986963571553e9 total = 100.0
1.562986963773005e9 istaskdone(task1) = true
start_async() = nothing


1.562986963831601e9 Alhamdulillah from WRY in Julia script. 

wruslan@HPEliteBk8470p-ub1604-64b:~/Documents/julia-async# 

"""

