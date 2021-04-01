# File: julia-async-06.jl
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
Create a Task (i.e. coroutine) to execute the given function func (which must be callable with no arguments). 
The task exits when this function returns.

# Create functions with arguments
   task1 = @task myfunction1(3, 4); ## ASSOCIATE FUNCTION TO TASK
   schedule(task1);
   yield(); ## EXECUTE TASK	

# Create functions with no arguments
   task3 = Task(myfunction3);  ## ASSOCIATE FUNCTION TO TASK
   schedule(task3);
   yield();  ## EXECUTE TASK


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

function do_some_work(delta::Real)
    total = 0.0
    start_time = time()
    println(Dates.time(), " start_time = ", start_time);

    while (time() - start_time) < 5  # perform loop within 5 seconds
        total += delta
        sleep(0.2)   
	println(Dates.time(), " total = ", total);
    end 

    return (total)
end; 

# =================
function run_async()
    start_time = time()

    ### ASSIGN async TO function TO task
    task1 = @async do_some_work(10)  ## EXECUTE FUNCTION ASYNCHRONOUSLY
    println(Dates.time(), " Just after execute @async do_some_work(10) ");

    while !istaskdone(task1)
        println(Dates.time()," run_async() function is waiting for task1 to be done")
        sleep(1)
        println(Dates.time(), " istaskdone(task1) = ", istaskdone(task1));
    end
end

println("=== Execute @show run_async()")
@show run_async() ## EXECUTE FUNCTION

# =================
function run_async_print()
    start_time = time()

    task2 = @async try
        println(Dates.time()," This is try block.")
        do_some_work(10)     ## EXECUTE FUNCTION ASYNCHRONOUSLY
    catch err
        println(Dates.time()," This is catch block.")
        bt = catch_backtrace()
        println()
        showerror(stderr, err, bt)
    finally
        println(Dates.time()," This is finally block.")
    end

    while !istaskdone(task2)
        println(Dates.time()," run_async_print() function is waiting for task2 to be done")
	sleep(1)
        println(Dates.time(), " Execute istaskdone(task2) = ", istaskdone(task2))
    end
end

println("=== Execute @show run_async_print()")
@show run_async_print() ## EXECUTE FUNCTION


# =========================================================
print("\n\n", Dates.time(), " Alhamdulillah from WRY in Julia script. \n\n") 
# =========================================================

"""
EXECUTION

wruslan@HPEliteBk8470p-ub1604-64b:~/Documents/julia-async# julia julia-async-06.jl 
1.563013100893791e9 Current date today() = 2019-07-13
1.563013101047406e9 Current date time now: 2019-07-13T18:18:21.047
1.563013101148597e9 Bismillah from WRY in Julia script. 

=== Execute @show run_async()
1.563013101223263e9 Just after execute @async do_some_work(10) 
1.563013101263589e9 run_async() function is waiting for task1 to be done
1.56301310125643e9 start_time = 1.56301310125643e9
1.563013101492006e9 total = 10.0
1.563013101693421e9 total = 20.0
1.563013101894813e9 total = 30.0
1.56301310209624e9 total = 40.0
1.563013102291663e9 istaskdone(task1) = false
1.563013102303702e9 run_async() function is waiting for task1 to be done
1.563013102303656e9 total = 50.0
1.563013102505149e9 total = 60.0
1.563013102706587e9 total = 70.0
1.563013102907996e9 total = 80.0
1.563013103109377e9 total = 90.0
1.56301310330479e9 istaskdone(task1) = false
1.563013103304909e9 run_async() function is waiting for task1 to be done
1.56301310331105e9 total = 100.0
1.563013103512432e9 total = 110.0
1.563013103713862e9 total = 120.0
1.563013103915305e9 total = 130.0
1.563013104116734e9 total = 140.0
1.563013104306172e9 istaskdone(task1) = false
1.563013104306298e9 run_async() function is waiting for task1 to be done
1.56301310431746e9 total = 150.0
1.563013104518843e9 total = 160.0
1.563013104720267e9 total = 170.0
1.563013104921695e9 total = 180.0
1.563013105123123e9 total = 190.0
1.563013105307546e9 istaskdone(task1) = false
1.563013105307668e9 run_async() function is waiting for task1 to be done
1.563013105324838e9 total = 200.0
1.563013105526238e9 total = 210.0
1.563013105727669e9 total = 220.0
1.563013105929085e9 total = 230.0
1.563013106130516e9 total = 240.0
1.563013106308934e9 istaskdone(task1) = false
1.563013106309052e9 run_async() function is waiting for task1 to be done
1.563013106332225e9 total = 250.0
1.563013107310435e9 istaskdone(task1) = true
run_async() = nothing
=== Execute @show run_async_print()
1.563013107391307e9 run_async_print() function is waiting for task2 to be done
1.563013107407437e9 This is try block.
1.563013107407599e9 start_time = 1.563013107407599e9
1.563013107608985e9 total = 10.0
1.563013107810407e9 total = 20.0
1.563013108011852e9 total = 30.0
1.563013108213292e9 total = 40.0
1.5630131084087e9 Execute istaskdone(task2) = false
1.563013108408836e9 run_async_print() function is waiting for task2 to be done
1.563013108414973e9 total = 50.0
1.563013108616356e9 total = 60.0
1.563013108817785e9 total = 70.0
1.563013109019213e9 total = 80.0
1.563013109220649e9 total = 90.0
1.563013109410072e9 Execute istaskdone(task2) = false
1.563013109410199e9 run_async_print() function is waiting for task2 to be done
1.563013109421423e9 total = 100.0
1.563013109622844e9 total = 110.0
1.563013109824274e9 total = 120.0
1.563013110025695e9 total = 130.0
1.563013110227078e9 total = 140.0
1.563013110412483e9 Execute istaskdone(task2) = false
1.563013110412588e9 run_async_print() function is waiting for task2 to be done
1.563013110427763e9 total = 150.0
1.563013110629195e9 total = 160.0
1.563013110830646e9 total = 170.0
1.563013111032074e9 total = 180.0
1.563013111233474e9 total = 190.0
1.56301311141389e9 Execute istaskdone(task2) = false
1.563013111413992e9 run_async_print() function is waiting for task2 to be done
1.563013111435172e9 total = 200.0
1.563013111636602e9 total = 210.0
1.563013111838016e9 total = 220.0
1.563013112039414e9 total = 230.0
1.563013112240839e9 total = 240.0
1.563013112415229e9 Execute istaskdone(task2) = false
1.563013112415322e9 run_async_print() function is waiting for task2 to be done
1.563013112441468e9 total = 250.0
1.563013112441635e9 This is finally block.
1.563013113417762e9 Execute istaskdone(task2) = true
run_async_print() = nothing


1.563013113418197e9 Alhamdulillah from WRY in Julia script. 

wruslan@HPEliteBk8470p-ub1604-64b:~/Documents/julia-async# 


"""

