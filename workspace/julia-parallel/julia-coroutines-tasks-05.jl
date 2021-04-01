# File: julia-coroutines-tasks-05.jl
# Date:     Fri Jul 12 11:38:58 +08 2019
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
@show task1
println(Dates.time()," Execute set chn1 as Channel(1)"); chn1 = Channel(1);
@show chn1
@show task1
println(Dates.time()," Execute bind chn1 to task1"); bind(chn1, task1);
@show chn1
@show task1
println(Dates.time()," Check isopen(chn1) = ", isopen(chn1))
@show chn1
@show task1
println(Dates.time()," Check istaskstarted(task1) = ", istaskstarted(task1))
@show chn1
@show task1
println(Dates.time()," Execute schedule(task1)"); schedule(task1);
@show chn1
@show task1
println(Dates.time()," Check istaskstarted(task1) = ", istaskstarted(task1))
@show chn1
@show task1
println(Dates.time()," Check istaskdone(task1) = ", istaskdone(task1))
@show chn1
@show task1
println(Dates.time()," Execute yield()"); yield();
@show chn1
@show task1
println(Dates.time()," Check istaskstarted(task1) = ", istaskstarted(task1))
@show chn1
@show task1
println(Dates.time()," Check istaskdone(task1) = ", istaskdone(task1))
@show chn1
@show task1
println(Dates.time()," Check isopen(chn1) = ", isopen(chn1))
@show chn1
@show task1
println(Dates.time(),"")
@show chn1
@show task1
println("")

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
# @show task3
# println(Dates.time()," Associate myfunction3() as a task named task3"); 
task3 = Task(myfunction3);
@show task3
# println(Dates.time()," Execute istaskstarted(task3) = ", istaskstarted(task3))
@show task3
# println(Dates.time()," Execute istaskdone(task3) = ", istaskdone(task3))
@show task3
println(Dates.time()," Execute schedule(task3)"); 
schedule(task3);
@show task3
# println(Dates.time()," Execute istaskstarted(task3) = ", istaskstarted(task3))
@show task3
# println(Dates.time()," Execute istaskdone(task3) = ", istaskdone(task3))
@show task3
println(Dates.time()," Execute yield()"); 
yield();
@show task3
# println(Dates.time()," Execute istaskstarted(task3) = ", istaskstarted(task3))
@show task3
# println(Dates.time()," Execute istaskdone(task3) = ", istaskdone(task3))
@show task3
# println(Dates.time(),"")
println("")

@show myfunction3()

println("")
@show myfunction4()

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

wruslan@HPEliteBk8470p-ub1604-64b:~/Documents/julia-parallel# julia julia-coroutines-tasks-05.jl 
1.562906645417919e9 Current date today() = 2019-07-12
1.562906645568759e9 Current date time now: 2019-07-12T12:44:05.568
1.562906645670084e9 Bismillah from WRY in Julia script. 



1.56290664568707e9 Associate myfunction1(3,4) as a task named task1
1.562906645711182e9 Execute set chn1 as Channel(1)
1.562906645715759e9 Execute bind chn1 to task1
1.562906645727866e9 Check isopen(chn1) = true@task

Wrap an expression in a Task without executing it, and return the Task. This only creates a task, and does not run it.
1.562906645751637e9 Check istaskstarted(task1) = false
1.56290664575824e9 Execute schedule(task1)
1.562906645767977e9 Check istaskstarted(task1) = false
1.562906645778845e9 Check istaskdone(task1) = false
1.562906645783519e9 Execute yield()
1.562906645778417e9 RESULT Execute myfunction1(x,y) = 15
1.562906645783891e9 Check istaskstarted(task1) = true
1.562906645933242e9 Check istaskdone(task1) = true
1.562906645933537e9 Check isopen(chn1) = false
1.562906645933798e9
chn1 = Channel{Any}(sz_max:1,sz_curr:0)
1.562906646050196e9 Associate myfunction2(7) as a task named task2
1.562906646051132e9 Execute set chn2 as Channel(2)
1.562906646051465e9 Execute bind chn2 to task2
1.562906646051818e9 Check isopen(chn2) = true
1.562906646052079e9 Check istaskstarted(task2) = false
1.562906646052297e9 Execute schedule(task2)
1.56290664605262e9 Check istaskstarted(task2) = false
1.56290664605961e9 Check istaskdone(task2) = false
1.562906646059924e9 Execute yield()
1.562906646059143e9 RESULT Execute myfunction2(x) = 49
1.56290664606033e9 Check istaskstarted(task2) = true
1.56290664606068e9 Check istaskdone(task2) = true
1.562906646060952e9 Check isopen(chn2) = false
1.562906646061196e9
chn2 = Channel{Any}(sz_max:2,sz_curr:0)
1.562906646063923e9 Associate myfunction3() as a task named task3
1.562906646064316e9 Execute istaskstarted(task3) = false
1.56290664606459e9 Execute istaskdone(task3) = false
1.562906646064816e9 Execute schedule(task3)
1.562906646065165e9 Execute istaskstarted(task3) = false
1.562906646107844e9 Execute istaskdone(task3) = false
1.562906646108091e9 Execute yield()
1.562906646107441e9 RESULT Execute myfunction3() = return(X) 500500
1.562906646108471e9 Execute istaskstarted(task3) = true
1.562906646108802e9 Execute istaskdone(task3) = true
1.56290664610904e9
1.562906646109254e9 Associate myfunction4() as a task named task4
1.562906646109645e9 Execute istaskstarted(task4) = false
1.562906646109924e9 Execute istaskdone(task4) = false
1.56290664611015e9 Execute schedule(task4)
1.562906646110492e9 Execute istaskstarted(task4) = false
1.562906646148221e9 Execute istaskdone(task4) = false
1.562906646148477e9 Execute yield()
1.562906646147801e9 RESULT Execute myfunction4() = return(Y) = 5050
1.56290664614968e9 Execute istaskstarted(task4) = true
1.562906646150118e9 Execute istaskdone(task4) = true
1.562906646150364e9
task4 = Task (done) @0x00007f084be2a230
1.562906646199088e9 RESULT Execute myfunction4() = return(Y) = 5050
myfunction4() = 5050


1.562906646220545e9 Alhamdulillah from WRY in Julia script. 

wruslan@HPEliteBk8470p-ub1604-64b:~/Documents/julia-parallel# 

"""

