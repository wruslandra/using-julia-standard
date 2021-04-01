# File: julia-docs-parallel-04.jl
# Date:     Tue Jul  9 13:02:54 +08 2019
# Modified: 
# =========================================================
"""
https://stackoverflow.com/questions/1050222/what-is-the-difference-between-concurrency-and-parallelism?rq=1

Concurrency is two lines of customers ordering from a single cashier (lines take turns ordering); 
Parallelism is two lines of customers ordering from two cashiers (each line gets its own cashier).

Concurrency is when two or more tasks can start, run, and complete in overlapping time periods. It doesn't necessarily mean they'll ever both be running at the same instant. For example, multitasking on a single-core machine.

Parallelism is when tasks literally run at the same time, e.g., on a multicore processor.

Concurrency refers managing multiple threads of execution, where parallelism is more specifically, multiple threads of execution executing simultaneously. Concurrency is the broader term which can encompass parallelism.

Note: independentability (either one of you can do it) 
and interruptability (you can stop it and resume it later). 

Asynchronous methods aren't directly related to the previous two concepts (concurrent and parallel), asynchrony is used to present the impression of concurrent or parallel tasking but effectively an asynchronous method call is normally used for a process that needs to do work away from the current application and we don't want to wait and block our application awaiting the response. 

It's probably worth adding that in many implementations an asynchronous method call will cause a thread to be spun up but it's not essential, it really depends on the operation being executed and how the response can be notified back to the system.

=====================
Differences between concurrency vs. parallelism

Now let’s list down remarkable differences between concurrency and parallelism.

Concurrency is when two tasks can start, run, and complete in overlapping time periods. Parallelism is when tasks literally run at the same time, eg. on a multi-core processor.

Concurrency is the composition of independently executing processes, while parallelism is the simultaneous execution of (possibly related) computations.

Concurrency is about dealing with lots of things at once. Parallelism is about doing lots of things at once.

An application can be concurrent  but not parallel, which means that it processes more than one task at the same time, but no two tasks are executing at same time instant.

An application can be parallel but not concurrent, which means that it processes multiple sub-tasks of a task in multi-core CPU at same time.

An application can be neither parallel nor concurrent, which means that it processes all tasks one at a time, sequentially.

An application can be both parallel and concurrent, which means that it processes multiple tasks concurrently in multi-core CPU at same time.
=====================
https://pkg.julialang.org/docs/julia/THl1k/1.1.1/manual/methods.html
https://pkg.julialang.org/docs/julia/THl1k/1.1.1/manual/functions.html
https://docs.julialang.org/en/v1/manual/parallel-computing/index.html
https://docs.julialang.org/en/latest/manual/metaprogramming/
https://docs.julialang.org/en/v1/base/parallel/#Core.Task

The different levels of parallelism offered by Julia. We can divide them in three main categories :

    (1) Julia Coroutines (Green Threading) = Tasks and Channels
    (2) Multi-Threading
    (3) Multi-Core or Distributed Processing

===================
# https://pkg.julialang.org/docs/ProgressMeter/3V8n6/1.0.0/
Tips for parallel programming

When multiple processes or tasks are being used for a computation, the workers should communicate back to a single task for displaying the progress bar. This can be accomplished with a RemoteChannel:

====================
https://stackoverflow.com/questions/51217145/simple-parallelism-using-sync-async-in-julia
Simple parallelism using @sync @async in Julia


"""

# =========================================================
using Dates 
print(Dates.time(), " Current date today() = ", Dates.today(), "\n")
print(Dates.time(), " Current date time now: ", Dates.now(), "\n")
print(Dates.time(), " Bismillah from WRY in Julia script. \n\n") 
using InteractiveUtils
import InteractiveUtils
show(versioninfo());
println("\n");
# =========================================================

function f0(x,y,z)
  v1 = x+y;
  v2 = y+z;
  return (v1)*(v2)
end
print(Dates.time(), " f0(1, 3, 5) = ", f0(1, 3, 5), "\n")


## @sync and @async are TASKS in Base.

using Base
Base.Threads.nthreads() = 4
print(Dates.time(), " Threads.nthreads() = ", Threads.nthreads(), "\n")

function f1(x,y,z)
  v1 = @async x+y;
  v2 = @async y+z;
  return wait(v1)*wait(v2)
end
#print(Dates.time(), " f1(2, 3, 4) = ", f1(2, 3, 4), "\n")

# However, in many examples that I have seen, the wait statement seems to be unnecessary if one uses a @sync block. 
function f2(x,y,z)
  v1 = @async x+y;
  v2 = @async y+z;
  return (v1)*(v2)
end
# print(Dates.time(), " f2(4, 5, 6) = ", f2(4, 5, 6), "\n")

function f3(x,y,z)
  v1 = Base.@async x+y;
  v2 = Base.@async y+z;
  return Base.wait(v1)*Base.wait(v2)
end
# print(Dates.time(), " f3(2, 3, 4) = ") ## f3(2, 3, 4), "\n")

## f4 IS THE CORRECT WAY
function f4(x,y,z)
           local v1, v2
           @sync @async begin
               v1 = x+y; 
               v2 = y+z;
           end
           return v1*v2
       end
print(Dates.time(), " f4(2, 3, 4) = ", f4(2, 3, 4), "\n")

## f5 IS THE CORRECT WAY
function f5(x,y,z)
           local v1, v2
           Base.@sync Base.@async begin
               v1 = x+y; 
               v2 = y+z;
           end
           return v1*v2
       end
print(Dates.time(), " f5(4, 4, 7) = ", f5(4, 4, 7), "\n")

## GLOBAL 
x,y,z = 1,2,3
@sync @async begin
          global v1 = x+y;
          global v2 = y+z;
       end
result = v1*v2
print(Dates.time(), " v1*v2 = ", v1*v2, "\n")
print(Dates.time(), " result = ", result, "\n")

# =========================================================
print("\n\n", Dates.time(), " Alhamdulillah from WRY in Julia script. \n\n") 
# =========================================================

"""
EXECUTION

wruslan@HPEliteBk8470p-ub1604-64b:~/Documents/julia-parallel# julia julia-docs-parallel-04.jl 
1.562651163016872e9 Current date today() = 2019-07-09
1.562651163140563e9 Current date time now: 2019-07-09T13:46:03.14
1.562651163241815e9 Bismillah from WRY in Julia script. 

Julia Version 1.1.1
Commit 55e36cc308 (2019-05-16 04:10 UTC)
Platform Info:
  OS: Linux (x86_64-pc-linux-gnu)
  CPU: Intel(R) Core(TM) i5-3380M CPU @ 2.90GHz
  WORD_SIZE: 64
  LIBM: libopenlibm
  LLVM: libLLVM-6.0.1 (ORCJIT, ivybridge)
nothing

1.562651165236215e9 f0(1, 3, 5) = 32
1.56265116525045e9 Threads.nthreads() = 4
1.562651165261168e9 f4(2, 3, 4) = 35
1.562651165346521e9 f5(4, 4, 7) = 88
1.562651544811439e9 v1*v2 = 15
1.562651544811718e9 result = 15

1.56265116537462e9 Alhamdulillah from WRY in Julia script. 

wruslan@HPEliteBk8470p-ub1604-64b:~/Documents/julia-parallel# 


"""
# =========================================================

