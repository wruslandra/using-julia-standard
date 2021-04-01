# File: julia-async-06.jl
# Date:     Sat Jul 13 09:46:42 +08 2019
# Modified: 
# =========================================================
"""

This program shows that
(1) do_some_work(delta::Real) task runs independently of run_async() 
(2) do_some_work(delta::Real) task runs independently of run_async_print() 
(3) do_some_work(delta::Real) task runs independently of task3 

Independently above means asynchronously. THINK. 
Function do_some_work(delta::Real) runs without waiting for anybody to finish.

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
	#sleep(0.1)
	#sleep(0.01)
        #sleep(0.001)
	#sleep(1)   
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
# @show run_async() ## EXECUTE FUNCTION
# run_async() ## EXECUTE FUNCTION

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
# @show run_async_print() ## EXECUTE FUNCTION
# run_async_print() ## EXECUTE FUNCTION

# ====================================
println("=== Execute schedule(task3) and yield()")
task3 = @task do_some_work(10)

schedule(task3);
println(Dates.time(), " Execute istaskstarted(task3) = ", istaskstarted(task3))
@show task3

yield(); ## EXECUTE TASK FUNCTION
println(Dates.time(), " Execute istaskstarted(task3) = ", istaskstarted(task3))
@show task3

while !istaskdone(task3)
        println(Dates.time()," do_some_work(10) function is waiting for task3 to be done")
	sleep(1)
        println(Dates.time(), " Execute istaskdone(task3) = ", istaskdone(task3))
end
@show task3


# =========================================================
print("\n\n", Dates.time(), " Alhamdulillah from WRY in Julia script. \n\n") 
# =========================================================

"""
EXECUTION

wruslan@HPEliteBk8470p-ub1604-64b:~/Documents/julia-async# julia julia-async-07.jl 
1.563015337260015e9 Current date today() = 2019-07-13
1.563015337385281e9 Current date time now: 2019-07-13T18:55:37.385
1.563015337485421e9 Bismillah from WRY in Julia script. 

=== Execute @show run_async()
=== Execute @show run_async_print()
1.563015337523945e9 Execute istaskstarted(task3) = false
task3 = Task (queued) @0x00007fb1c687fd00
1.563015337569381e9 start_time = 1.563015337569381e9
1.563015337669361e9 Execute istaskstarted(task3) = true
task3 = Task (runnable) @0x00007fb1c687fd00
1.563015337709558e9 do_some_work(10) function is waiting for task3 to be done
1.563015337870637e9 total = 10.0
1.563015338072031e9 total = 20.0
1.563015338273422e9 total = 30.0
1.56301533847483e9 total = 40.0
1.563015338676212e9 total = 50.0
1.563015338737474e9 Execute istaskdone(task3) = false
1.563015338737593e9 do_some_work(10) function is waiting for task3 to be done
1.563015338877864e9 total = 60.0
1.563015339079259e9 total = 70.0
1.563015339280668e9 total = 80.0
1.563015339482053e9 total = 90.0
1.563015339683456e9 total = 100.0
1.563015339738732e9 Execute istaskdone(task3) = false
1.563015339738847e9 do_some_work(10) function is waiting for task3 to be done
1.56301533988513e9 total = 110.0
1.563015340086547e9 total = 120.0
1.563015340287954e9 total = 130.0
1.563015340489364e9 total = 140.0
1.563015340690777e9 total = 150.0
1.563015340740038e9 Execute istaskdone(task3) = false
1.563015340740159e9 do_some_work(10) function is waiting for task3 to be done
1.563015340892449e9 total = 160.0
1.563015341093858e9 total = 170.0
1.56301534129527e9 total = 180.0
1.563015341496677e9 total = 190.0
1.563015341698085e9 total = 200.0
1.563015341741383e9 Execute istaskdone(task3) = false
1.563015341741486e9 do_some_work(10) function is waiting for task3 to be done
1.563015341898785e9 total = 210.0
1.563015342100193e9 total = 220.0
1.563015342301603e9 total = 230.0
1.563015342503011e9 total = 240.0
1.563015342704423e9 total = 250.0
1.563015342742706e9 Execute istaskdone(task3) = true
task3 = Task (done) @0x00007fb1c687fd00


1.56301534274346e9 Alhamdulillah from WRY in Julia script. 

wruslan@HPEliteBk8470p-ub1604-64b:~/Documents/julia-async# 

"""

