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
show(versioninfo());
println("");
# =========================================================

function do_some_work(delta::Real)
    total = 0.0
    start_time = time()
    println(Dates.time(), " start_time = ", start_time);

    while (time() - start_time) < 5  # perform loop within 5 seconds
        total += delta
        sleep(0.3)
	#sleep(0.1)
	#sleep(0.01)
        #sleep(0.001)
	#sleep(1)   
	println(Dates.time(), " total = ", total);
    end 

    return (total)
end; 

# =================
# =================
function run_async_print()
    start_time = time()

    task2 = @async try
	println(Dates.time(), " 0 Execute istaskstarted(task2) = ", istaskstarted(task2))
        println(Dates.time()," This is try block.")
	print(Dates.time()," 1 "); @show task2
	println(Dates.time(), " 1 Execute istaskstarted(task2) = ", istaskstarted(task2))
 	print(Dates.time()," 2 "); @show task2

	do_some_work(10)     ## EXECUTE FUNCTION ASYNCHRONOUSLY

 	print(Dates.time()," 3 "); @show task2
	println(Dates.time(), " 2 Execute istaskstarted(task2) = ", istaskstarted(task2))
        print(Dates.time()," 4 "); @show task2
    catch err
        println(Dates.time()," This is catch block.")
        bt = catch_backtrace()
        println()
        showerror(stderr, err, bt)
    finally
        println(Dates.time()," This is finally block.")
    end

    while !istaskdone(task2)
	sleep(1)
        println(Dates.time(), " Execute istaskdone(task2) = ", istaskdone(task2))
    end
    print(Dates.time()," 5 "); @show task2
end

println()
println("=== Execute @show run_async_print()")
# @show run_async_print() ## EXECUTE FUNCTION
run_async_print() ## EXECUTE FUNCTION

# =========================================================
print("\n\n", Dates.time(), " Alhamdulillah from WRY in Julia script. \n\n") 
# =========================================================

"""
EXECUTION
wruslan@HPEliteBk8470p-ub1604-64b:~/Documents/julia-async# julia julia-async-09.jl 
1.563019903195268e9 Current date today() = 2019-07-13
1.563019903320868e9 Current date time now: 2019-07-13T20:11:43.32
1.563019903424269e9 Bismillah from WRY in Julia script. 
Julia Version 1.1.1
Commit 55e36cc308 (2019-05-16 04:10 UTC)
Platform Info:
  OS: Linux (x86_64-pc-linux-gnu)
  CPU: Intel(R) Core(TM) i5-3380M CPU @ 2.90GHz
  WORD_SIZE: 64
  LIBM: libopenlibm
  LLVM: libLLVM-6.0.1 (ORCJIT, ivybridge)
nothing

=== Execute @show run_async_print()
1.563019905582467e9 0 Execute istaskstarted(task2) = true
1.563019905609694e9 This is try block.
1.563019905609772e9 1 task2 = Task (runnable) @0x00007fc9ec453d00
1.563019905684845e9 1 Execute istaskstarted(task2) = true
1.563019905684942e9 2 task2 = Task (runnable) @0x00007fc9ec453d00
1.563019905685055e9 start_time = 1.563019905685054e9
1.563019905986553e9 total = 10.0
1.563019906288066e9 total = 20.0
1.563019906525523e9 Execute istaskdone(task2) = false
1.563019906588801e9 total = 30.0
1.563019906890283e9 total = 40.0
1.563019907191785e9 total = 50.0
1.563019907493336e9 total = 60.0
1.563019907526594e9 Execute istaskdone(task2) = false
1.563019907795064e9 total = 70.0
1.563019908096585e9 total = 80.0
1.563019908398104e9 total = 90.0
1.563019908527472e9 Execute istaskdone(task2) = false
1.563019908699845e9 total = 100.0
1.563019909001391e9 total = 110.0
1.563019909302921e9 total = 120.0
1.563019909529370e9 Execute istaskdone(task2) = false
1.563019909603676e9 total = 130.0
1.563019909905194e9 total = 140.0
1.563019910206734e9 total = 150.0
1.563019910508238e9 total = 160.0
1.563019910530510e9 Execute istaskdone(task2) = false
1.563019910809983e9 total = 170.0
1.563019910810105e9 3 task2 = Task (runnable) @0x00007fc9ec453d00
1.563019910810197e9 2 Execute istaskstarted(task2) = true
1.563019910810261e9 4 task2 = Task (runnable) @0x00007fc9ec453d00
1.563019910810336e9 This is finally block.
1.563019911532193e9 Execute istaskdone(task2) = true
1.563019911532289e9 5 task2 = Task (done) @0x00007fc9ec453d00

1.563019911532657e9 Alhamdulillah from WRY in Julia script. 

wruslan@HPEliteBk8470p-ub1604-64b:~/Documents/julia-async# 


"""

