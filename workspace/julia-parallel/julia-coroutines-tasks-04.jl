# File: julia-coroutines-tasks-03.jl
# Date:     Wed Jul 10 22:02:54 +08 2019
# Modified: 
# =========================================================
"""

Note that currently Julia tasks are not scheduled to run on separate CPU cores.

https://docs.julialang.org/en/v1/manual/control-flow/#man-tasks-1

https://www.quora.com/Does-the-Julia-programming-language-have-asynchronous-features

# https://stackoverflow.com/questions/41928047/julia-lang-cache-data-in-a-parallel-thread-using-async?rq=1

Instead, Julia can schedule any function for asynchronous execution using the @async macro, which returns a scheduled task that you can wait for later. While you don’t have to do anything, you may want to sprinkle some calls to yield() around your code, so scheduled tasks get a chance to run. All IO in will be handled in a non-blocking manner.

Julia provides a Channel mechanism for solving this problem. A Channel is a waitable first-in first-out queue which can have multiple tasks reading from and writing to it.

Let's define a producer task, which produces values via the put! call. To consume values, we need to schedule the producer to run in a new task. A special Channel constructor which accepts a 1-arg function as an argument can be used to run a task bound to a channel. We can then take! values repeatedly from the channel object:


One way to think of this behavior is that producer was able to return multiple times. Between calls to put!, the producer's execution is suspended and the consumer has control.

To orchestrate more advanced work distribution patterns, bind and schedule can be used in conjunction with Task and Channel constructors to explicitly link a set of channels with a set of producer/consumer tasks.

Tasks are a control flow feature that allows computations to be suspended and resumed in a flexible manner. This feature is sometimes called by other names, such as symmetric coroutines, lightweight threads, cooperative multitasking, or one-shot continuations.

At first, this may seem similar to a function call. However there are two key differences. First, switching tasks does not use any space, so any number of task switches can occur without consuming the call stack. Second, switching among tasks can occur in any order, unlike function calls, where the called function must finish executing before control returns to the calling function.

bind associates the lifetime of chnl with a task. Channel chnl is automatically closed when the task terminates. Any uncaught exception in the task is propagated to all waiters on chnl.

Task(func)

Create a Task (i.e. coroutine) to execute the given function func (which must be callable with no arguments). The task exits when this function returns.

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

# Create functions with arguments
function myfunction1(x,y)
	y = x*x + 3
	println(Dates.time(), " RESULT Execute myfunction1(x,y) = ", y+x)
	return (y+x)
end;

function myfunction2(x)
	println(Dates.time(), " RESULT Execute myfunction2(x) = ", x*x)
	return (x+x)
end;

# ============================
#Create tasks from functions with arguments
#The task exits when this function returns.
# METHOD 1
#Create a channel and bind a task with a channel
println(Dates.time()," Associate myfunction1(3,4) as a task named task1"); task1 = Task(() -> myfunction1(3, 4))
println(Dates.time()," Execute set chn1 as Channel(1)"); chn1 = Channel(1);
println(Dates.time()," Execute bind chn1 to task1"); bind(chn1, task1);
println(Dates.time()," Check isopen(chn1) = ", isopen(chn1))
println(Dates.time()," Check istaskstarted(task1) = ", istaskstarted(task1))
println(Dates.time()," Execute schedule(task1)"); schedule(task1);
println(Dates.time()," Check istaskstarted(task1) = ", istaskstarted(task1))
println(Dates.time()," Check istaskdone(task1) = ", istaskdone(task1))
println(Dates.time()," Execute yield()"); yield();
println(Dates.time()," Check istaskstarted(task1) = ", istaskstarted(task1))
println(Dates.time()," Check istaskdone(task1) = ", istaskdone(task1))
println(Dates.time()," Check isopen(chn1) = ", isopen(chn1))
println(Dates.time(),"")

#Create tasks from functions with arguments
# METHOD 2
#Create a channel and bind a task with a channel

# @task ==> Wrap an expression in a Task without executing it, and return the Task. This only creates a task, and does not run it.

println(Dates.time()," Associate myfunction2(7) as a task named task2"); task2 = @task myfunction2(7); 
println(Dates.time()," Execute set chn2 as Channel(2)"); chn2 = Channel(2);
println(Dates.time()," Execute bind chn2 to task2"); bind(chn2, task2);
println(Dates.time()," Check isopen(chn2) = ", isopen(chn2))
println(Dates.time()," Check istaskstarted(task2) = ", istaskstarted(task2))
println(Dates.time()," Execute schedule(task2)"); schedule(task2);
println(Dates.time()," Check istaskstarted(task2) = ", istaskstarted(task2))
println(Dates.time()," Check istaskdone(task2) = ", istaskdone(task2))
println(Dates.time()," Execute yield()"); yield();
println(Dates.time()," Check istaskstarted(task2) = ", istaskstarted(task2))
println(Dates.time()," Check istaskdone(task2) = ", istaskdone(task2))
println(Dates.time()," Check isopen(chn2) = ", isopen(chn2))
println(Dates.time(),"")

# =========================================================
# Create functions with no arguments
function myfunction3()
	X = sum(i for i in 1:1000);
	println(Dates.time(), " RESULT Execute myfunction3() = return(X) ", X)
	return X
end;


function myfunction4()
 	Y = sum(i for i in 1:100);
	println(Dates.time(), " RESULT Execute myfunction4() = return(Y) = ", Y)
	return Y
end;

# METHOD 3
# Create tasks from functions with no arguments
println(Dates.time()," Associate myfunction3() as a task named task3"); task3 = Task(myfunction3);
println(Dates.time()," Execute istaskstarted(task3) = ", istaskstarted(task3))
println(Dates.time()," Execute istaskdone(task3) = ", istaskdone(task3))
println(Dates.time()," Execute schedule(task3)"); schedule(task3);
println(Dates.time()," Execute istaskstarted(task3) = ", istaskstarted(task3))
println(Dates.time()," Execute istaskdone(task3) = ", istaskdone(task3))
println(Dates.time()," Execute yield()"); yield();
println(Dates.time()," Execute istaskstarted(task3) = ", istaskstarted(task3))
println(Dates.time()," Execute istaskdone(task3) = ", istaskdone(task3))
println(Dates.time(),"")

println(Dates.time()," Associate myfunction4() as a task named task4"); task4 = Task(myfunction4);
println(Dates.time()," Execute istaskstarted(task4) = ", istaskstarted(task4))
println(Dates.time()," Execute istaskdone(task4) = ", istaskdone(task4))
println(Dates.time()," Execute schedule(task4)"); schedule(task4);
println(Dates.time()," Execute istaskstarted(task4) = ", istaskstarted(task4))
println(Dates.time()," Execute istaskdone(task4) = ", istaskdone(task4))
println(Dates.time()," Execute yield()"); yield();
println(Dates.time()," Execute istaskstarted(task4) = ", istaskstarted(task4))
println(Dates.time()," Execute istaskdone(task4) = ", istaskdone(task4))
println(Dates.time(),"")


"""
# EXAMPLE
# ==============================
for x in Channel(producer2)
           println(x)
       end

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

wruslan@HPEliteBk8470p-ub1604-64b:~/Documents/julia-parallel# julia julia-coroutines-tasks-04.jl 
1.562902137483772e9 Current date today() = 2019-07-12
1.56290213763511e9 Current date time now: 2019-07-12T11:28:57.635
1.562902137739361e9 Bismillah from WRY in Julia script. 



1.562902137756145e9 Associate myfunction1(3,4) as a task named task1
1.562902137783323e9 Execute set chn1 as Channel(1)
1.562902137787836e9 Execute bind chn1 to task1
1.562902137800734e9 Check isopen(chn1) = true
1.562902137823262e9 Check istaskstarted(task1) = false
1.562902137830161e9 Execute schedule(task1)
1.562902137839868e9 Check istaskstarted(task1) = false
1.562902137850327e9 Check istaskdone(task1) = false
1.562902137854956e9 Execute yield()
1.562902137849904e9 RESULT Execute myfunction1(x,y) = 15
1.562902137855345e9 Check istaskstarted(task1) = true
1.562902138011084e9 Check istaskdone(task1) = true
1.562902138011375e9 Check isopen(chn1) = false
1.562902138011643e9
1.562902138016029e9 Associate myfunction2(7) as a task named task2
1.562902138017004e9 Execute set chn2 as Channel(2)
1.562902138017352e9 Execute bind chn2 to task2
1.562902138017725e9 Check isopen(chn2) = true
1.562902138017999e9 Check istaskstarted(task2) = false
1.562902138018226e9 Execute schedule(task2)
1.56290213801856e9 Check istaskstarted(task2) = false
1.562902138025417e9 Check istaskdone(task2) = false
1.562902138025667e9 Execute yield()
1.562902138025008e9 RESULT Execute myfunction2(x) = 49
1.562902138026069e9 Check istaskstarted(task2) = true
1.562902138026403e9 Check istaskdone(task2) = true
1.562902138026669e9 Check isopen(chn2) = false
1.56290213802691e9
1.562902138029268e9 Associate myfunction3() as a task named task3
1.562902138029666e9 Execute istaskstarted(task3) = false
1.562902138029942e9 Execute istaskdone(task3) = false
1.562902138030162e9 Execute schedule(task3)
1.562902138030503e9 Execute istaskstarted(task3) = false
1.562902138070669e9 Execute istaskdone(task3) = false
1.562902138070923e9 Execute yield()
1.56290213807024e9 RESULT Execute myfunction3() = return(X) 500500
1.562902138071272e9 Execute istaskstarted(task3) = true
1.562902138071579e9 Execute istaskdone(task3) = true
1.56290213807179e9
1.562902138071987e9 Associate myfunction4() as a task named task4
1.562902138072354e9 Execute istaskstarted(task4) = false
1.56290213807259e9 Execute istaskdone(task4) = false
1.562902138072789e9 Execute schedule(task4)
1.562902138073112e9 Execute istaskstarted(task4) = false
1.562902138111912e9 Execute istaskdone(task4) = false
1.562902138112172e9 Execute yield()
1.562902138111482e9 RESULT Execute myfunction4() = return(Y) = 5050
1.562902138115907e9 Execute istaskstarted(task4) = true
1.562902138116274e9 Execute istaskdone(task4) = true
1.562902138116553e9


1.562902138118311e9 Alhamdulillah from WRY in Julia script. 

wruslan@HPEliteBk8470p-ub1604-64b:~/Documents/julia-parallel#


"""

