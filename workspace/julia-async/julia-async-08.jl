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
    @show task1

    while !istaskdone(task1)
        println(Dates.time()," run_async() function is waiting for task1 to be done")
        sleep(1)
        println(Dates.time(), " istaskdone(task1) = ", istaskdone(task1));
    end

    @show task1
end

println()
println("=== Execute @show run_async()")
@show run_async() ## EXECUTE FUNCTION
run_async() ## EXECUTE FUNCTION

# =================
function run_async_print()
    start_time = time()

    task2 = @async try
        println(Dates.time()," This is try block.")
	@show task2
        do_some_work(10)     ## EXECUTE FUNCTION ASYNCHRONOUSLY
        @show task2
    catch err
        println(Dates.time()," This is catch block.")
        bt = catch_backtrace()
        println()
        showerror(stderr, err, bt)
    finally
        println(Dates.time()," This is finally block.")
	@show task2
    end
    @show task2

    while !istaskdone(task2)
        println(Dates.time()," run_async_print() function is waiting for task2 to be done")
	sleep(1)
        println(Dates.time(), " Execute istaskdone(task2) = ", istaskdone(task2))
    end
    @show task2
end

println()
println("=== Execute @show run_async_print()")
@show run_async_print() ## EXECUTE FUNCTION
run_async_print() ## EXECUTE FUNCTION

# ====================================
println();
println("=== Execute schedule(task3) and yield()");
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

wruslan@HPEliteBk8470p-ub1604-64b:~/Documents/julia-async# julia julia-async-08.jl 
1.563017089921693e9 Current date today() = 2019-07-13
1.563017090074048e9 Current date time now: 2019-07-13T19:24:50.074
1.563017090177335e9 Bismillah from WRY in Julia script. 
Julia Version 1.1.1
Commit 55e36cc308 (2019-05-16 04:10 UTC)
Platform Info:
  OS: Linux (x86_64-pc-linux-gnu)
  CPU: Intel(R) Core(TM) i5-3380M CPU @ 2.90GHz
  WORD_SIZE: 64
  LIBM: libopenlibm
  LLVM: libLLVM-6.0.1 (ORCJIT, ivybridge)
nothing

=== Execute @show run_async()
1.56301709029417e9 Just after execute @async do_some_work(10) 
task1 = Task (queued) @0x00007fbf05779fc0
1.56301709037356e9 run_async() function is waiting for task1 to be done
1.563017090327445e9 start_time = 1.563017090327445e9
1.563017090601375e9 total = 10.0
1.563017090802777e9 total = 20.0
1.56301709100419e9 total = 30.0
1.563017091205598e9 total = 40.0
1.563017091401002e9 istaskdone(task1) = false
1.563017091412539e9 run_async() function is waiting for task1 to be done
1.563017091412501e9 total = 50.0
1.563017091613974e9 total = 60.0
1.563017091815369e9 total = 70.0
1.563017092016779e9 total = 80.0
1.56301709221816e9 total = 90.0
1.56301709241356e9 istaskdone(task1) = false
1.563017092413677e9 run_async() function is waiting for task1 to be done
1.563017092419812e9 total = 100.0
1.563017092621221e9 total = 110.0
1.56301709282263e9 total = 120.0
1.56301709302403e9 total = 130.0
1.563017093225411e9 total = 140.0
1.563017093414813e9 istaskdone(task1) = false
1.563017093414929e9 run_async() function is waiting for task1 to be done
1.563017093427099e9 total = 150.0
1.563017093628483e9 total = 160.0
1.563017093829882e9 total = 170.0
1.563017094031271e9 total = 180.0
1.56301709423268e9 total = 190.0
1.563017094416038e9 istaskdone(task1) = false
1.563017094416132e9 run_async() function is waiting for task1 to be done
1.563017094434283e9 total = 200.0
1.563017094635681e9 total = 210.0
1.563017094837071e9 total = 220.0
1.56301709503849e9 total = 230.0
1.56301709523988e9 total = 240.0
1.563017095417268e9 istaskdone(task1) = false
1.563017095417375e9 run_async() function is waiting for task1 to be done
1.563017095440551e9 total = 250.0
1.563017096419738e9 istaskdone(task1) = true
task1 = Task (done) @0x00007fbf05779fc0
run_async() = Task (done) @0x00007fbf05779fc0
1.563017096422952e9 Just after execute @async do_some_work(10) 
task1 = Task (queued) @0x00007fbf067bc9d0
1.563017096423058e9 run_async() function is waiting for task1 to be done
1.563017096422968e9 start_time = 1.563017096422968e9
1.56301709662448e9 total = 10.0
1.563017096825895e9 total = 20.0
1.563017097027314e9 total = 30.0
1.563017097228681e9 total = 40.0
1.563017097424084e9 istaskdone(task1) = false
1.563017097424203e9 run_async() function is waiting for task1 to be done
1.563017097429326e9 total = 50.0
1.563017097630716e9 total = 60.0
1.563017097832123e9 total = 70.0
1.563017098033533e9 total = 80.0
1.563017098234943e9 total = 90.0
1.563017098426331e9 istaskdone(task1) = false
1.563017098426427e9 run_async() function is waiting for task1 to be done
1.563017098435568e9 total = 100.0
1.563017098636959e9 total = 110.0
1.563017098838338e9 total = 120.0
1.56301709903974e9 total = 130.0
1.563017099241148e9 total = 140.0
1.563017099427557e9 istaskdone(task1) = false
1.56301709942767e9 run_async() function is waiting for task1 to be done
1.563017099442845e9 total = 150.0
1.563017099644246e9 total = 160.0
1.563017099845642e9 total = 170.0
1.563017100047065e9 total = 180.0
1.563017100248459e9 total = 190.0
1.563017100428842e9 istaskdone(task1) = false
1.563017100428959e9 run_async() function is waiting for task1 to be done
1.563017100450129e9 total = 200.0
1.56301710065154e9 total = 210.0
1.56301710085294e9 total = 220.0
1.563017101054311e9 total = 230.0
1.563017101255698e9 total = 240.0
1.563017101430078e9 istaskdone(task1) = false
1.563017101430196e9 run_async() function is waiting for task1 to be done
1.563017101456376e9 total = 250.0
1.563017102432543e9 istaskdone(task1) = true
task1 = Task (done) @0x00007fbf067bc9d0

=== Execute @show run_async_print()
task2 = Task (queued) @0x00007fbf067bceb0
1.56301710248139e9 run_async_print() function is waiting for task2 to be done
1.563017102481315e9 This is try block.
task2 = Task (runnable) @0x00007fbf067bceb0
1.563017102481557e9 start_time = 1.563017102481557e9
1.563017102682893e9 total = 10.0
1.563017102884284e9 total = 20.0
1.563017103085705e9 total = 30.0
1.563017103287098e9 total = 40.0
1.56301710348348e9 Execute istaskdone(task2) = false
1.563017103483563e9 run_async_print() function is waiting for task2 to be done
1.563017103487708e9 total = 50.0
1.563017103689094e9 total = 60.0
1.563017103890514e9 total = 70.0
1.563017104091923e9 total = 80.0
1.563017104293298e9 total = 90.0
1.563017104484687e9 Execute istaskdone(task2) = false
1.563017104484803e9 run_async_print() function is waiting for task2 to be done
1.563017104494941e9 total = 100.0
1.563017104696349e9 total = 110.0
1.56301710489776e9 total = 120.0
1.563017105099182e9 total = 130.0
1.563017105300601e9 total = 140.0
1.563017105485994e9 Execute istaskdone(task2) = false
1.563017105486125e9 run_async_print() function is waiting for task2 to be done
1.563017105502306e9 total = 150.0
1.563017105703717e9 total = 160.0
1.563017105905147e9 total = 170.0
1.563017106106591e9 total = 180.0
1.563017106307998e9 total = 190.0
1.563017106487381e9 Execute istaskdone(task2) = false
1.563017106487512e9 run_async_print() function is waiting for task2 to be done
1.563017106508693e9 total = 200.0
1.563017106710082e9 total = 210.0
1.563017106911498e9 total = 220.0
1.563017107112932e9 total = 230.0
1.563017107314358e9 total = 240.0
1.563017107488757e9 Execute istaskdone(task2) = false
1.56301710748889e9 run_async_print() function is waiting for task2 to be done
1.563017107516086e9 total = 250.0
task2 = Task (runnable) @0x00007fbf067bceb0
1.563017107516273e9 This is finally block.
1.56301710849039e9 Execute istaskdone(task2) = true
task2 = Task (done) @0x00007fbf067bceb0
run_async_print() = Task (done) @0x00007fbf067bceb0
task2 = Task (queued) @0x00007fbf067bdd50
1.563017108490803e9 run_async_print() function is waiting for task2 to be done
1.563017108490782e9 This is try block.
task2 = Task (runnable) @0x00007fbf067bdd50
1.563017108490926e9 start_time = 1.563017108490926e9
1.56301710869229e9 total = 10.0
1.563017108893716e9 total = 20.0
1.563017109095127e9 total = 30.0
1.563017109296538e9 total = 40.0
1.563017109491962e9 Execute istaskdone(task2) = false
1.563017109492072e9 run_async_print() function is waiting for task2 to be done
1.563017109498219e9 total = 50.0
1.563017109699614e9 total = 60.0
1.563017109901027e9 total = 70.0
1.5630171101024e9 total = 80.0
1.563017110303791e9 total = 90.0
1.56301711049318e9 Execute istaskdone(task2) = false
1.563017110493315e9 run_async_print() function is waiting for task2 to be done
1.563017110504451e9 total = 100.0
1.563017110705832e9 total = 110.0
1.56301711090727e9 total = 120.0
1.563017111108658e9 total = 130.0
1.563017111310062e9 total = 140.0
1.563017111495467e9 Execute istaskdone(task2) = false
1.563017111495562e9 run_async_print() function is waiting for task2 to be done
1.563017111510746e9 total = 150.0
1.563017111712139e9 total = 160.0
1.563017111913578e9 total = 170.0
1.563017112114979e9 total = 180.0
1.563017112316372e9 total = 190.0
1.563017112496768e9 Execute istaskdone(task2) = false
1.563017112496873e9 run_async_print() function is waiting for task2 to be done
1.563017112518049e9 total = 200.0
1.563017112719481e9 total = 210.0
1.56301711292086e9 total = 220.0
1.563017113122257e9 total = 230.0
1.563017113323651e9 total = 240.0
1.563017113498029e9 Execute istaskdone(task2) = false
1.563017113498131e9 run_async_print() function is waiting for task2 to be done
1.563017113525337e9 total = 250.0
task2 = Task (runnable) @0x00007fbf067bdd50
1.563017113525484e9 This is finally block.
1.563017114499589e9 Execute istaskdone(task2) = true
task2 = Task (done) @0x00007fbf067bdd50

=== Execute schedule(task3) and yield()
1.563017114518507e9 Execute istaskstarted(task3) = false
task3 = Task (queued) @0x00007fbf067bdfc0
1.56301711453849e9 start_time = 1.56301711453849e9
1.563017114539461e9 Execute istaskstarted(task3) = true
task3 = Task (runnable) @0x00007fbf067bdfc0
1.563017114555517e9 do_some_work(10) function is waiting for task3 to be done
1.563017114740911e9 total = 10.0
1.563017114942342e9 total = 20.0
1.563017115143791e9 total = 30.0
1.563017115345208e9 total = 40.0
1.563017115546669e9 total = 50.0
1.563017115556907e9 Execute istaskdone(task3) = false
1.563017115557016e9 do_some_work(10) function is waiting for task3 to be done
1.563017115748357e9 total = 60.0
1.563017115949783e9 total = 70.0
1.563017116151202e9 total = 80.0
1.563017116352642e9 total = 90.0
1.563017116554037e9 total = 100.0
1.563017116558247e9 Execute istaskdone(task3) = false
1.563017116558358e9 do_some_work(10) function is waiting for task3 to be done
1.563017116754681e9 total = 110.0
1.563017116956068e9 total = 120.0
1.563017117157469e9 total = 130.0
1.563017117358866e9 total = 140.0
1.563017117560279e9 Execute istaskdone(task3) = false
1.563017117560383e9 do_some_work(10) function is waiting for task3 to be done
1.563017117560321e9 total = 150.0
1.56301711776179e9 total = 160.0
1.563017117963217e9 total = 170.0
1.563017118164644e9 total = 180.0
1.56301711836607e9 total = 190.0
1.563017118562489e9 Execute istaskdone(task3) = false
1.56301711856258e9 do_some_work(10) function is waiting for task3 to be done
1.563017118566731e9 total = 200.0
1.563017118768134e9 total = 210.0
1.563017118969537e9 total = 220.0
1.563017119170929e9 total = 230.0
1.563017119372324e9 total = 240.0
1.563017119563734e9 Execute istaskdone(task3) = false
1.563017119563847e9 do_some_work(10) function is waiting for task3 to be done
1.563017119574016e9 total = 250.0
1.563017120566218e9 Execute istaskdone(task3) = true
task3 = Task (done) @0x00007fbf067bdfc0


1.563017120567052e9 Alhamdulillah from WRY in Julia script. 

wruslan@HPEliteBk8470p-ub1604-64b:~/Documents/julia-async# 

"""

