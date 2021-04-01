# File: julia-docs-parallel-02.jl
# Date:     Sun Jul  7 10:05:35 +08 2019
# Modified: 
# =========================================================
"""

https://pkg.julialang.org/docs/julia/THl1k/1.1.1/manual/methods.html
https://pkg.julialang.org/docs/julia/THl1k/1.1.1/manual/functions.html
https://docs.julialang.org/en/v1/manual/parallel-computing/index.html
https://docs.julialang.org/en/latest/manual/metaprogramming/

https://docs.julialang.org/en/v1/base/parallel/#Core.Task

The different levels of parallelism offered by Julia. We can divide them in three main categories :

    (1) Julia Coroutines (Green Threading) = Tasks
    (2) Multi-Threading
    (3) Multi-Core or Distributed Processing

(1) We will first consider Julia Tasks (aka Coroutines) and other modules that rely on the Julia runtime library, that allow us to suspend and resume computations with full control of inter-Tasks communication without having to manually interface with the operating system's scheduler. Julia also supports communication between Tasks through operations like wait and fetch. Communication and data synchronization is managed through Channels, which are the conduits that provide inter-Tasks communication.

(2) Julia also supports experimental multi-threading, where execution is forked and an anonymous function is run across all threads. Known as the fork-join approach, parallel threads execute independently, and must ultimately be joined in Julia's main thread to allow serial execution to continue. Multi-threading is supported using the Base.Threads module that is still considered experimental, as Julia is not yet fully thread-safe. In particular segfaults seem to occur during I/O operations and task switching. As an up-to-date reference, keep an eye on the issue tracker. Multi-Threading should only be used if you take into consideration global variables, locks and atomics, all of which are explained later.

(3) In the end we will present Julia's approach to distributed and parallel computing. With scientific computing in mind, Julia natively implements interfaces to distribute a process across multiple cores or machines. Also we will mention useful external packages for distributed programming like MPI.jl and DistributedArrays.jl.

Channels can serve as a way to communicate between tasks, as Channel{T}(sz::Int) creates a buffered channel of type T and size sz. Whenever code performs a communication operation like fetch or wait, the current task is suspended and a scheduler picks another task to run. A task is restarted when the event it is waiting for completes.

Tips for parallel programming

When multiple processes or tasks are being used for a computation, the workers should communicate back to a single task for displaying the progress bar. This can be accomplished with a RemoteChannel:

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

# https://pkg.julialang.org/docs/ProgressMeter/3V8n6/1.0.0/
using ProgressMeter
using Distributed

# ============================
@showprogress 1 "Computing..." for i in 1:100
    sleep(0.1)
end
# ===========================

# p = Progress(10)
# channel = RemoteChannel(()->Channel{Bool}(10), 1)

p = Progress(20)
channel = RemoteChannel(()->Channel{Bool}(20), 1)

# p = Progress(500)
# channel = RemoteChannel(()->Channel{Bool}(500), 1)

# ============================
@sync begin
    # this task prints the progress bar
    @async while take!(channel)
        next!(p)
    end

    # this task does the computation
    @async begin
	# @distributed (+) for i in 1:10
	@distributed (+) for i in 1:20
        # @distributed (+) for i in 1:500
            sleep(0.1)
	    # sleep(0.5)
            put!(channel, true)
            i^2
        end
        put!(channel, false) # this tells the printing task to finish
    end
end

# =========================================================
print("\n\n", Dates.time(), " Alhamdulillah from WRY in Julia script. \n\n") 
# =========================================================

"""
EXECUTION

wruslan@HPEliteBk8470p-ub1604-64b:~/Documents/julia-parallel# julia julia-docs-parallel-02.jl 
1.562545928924885e9 Current date today() = 2019-07-08
1.56254592907643e9 Current date time now: 2019-07-08T08:32:09.076
1.562545929176885e9 Bismillah from WRY in Julia script. 

Julia Version 1.1.1
Commit 55e36cc308 (2019-05-16 04:10 UTC)
Platform Info:
  OS: Linux (x86_64-pc-linux-gnu)
  CPU: Intel(R) Core(TM) i5-3380M CPU @ 2.90GHz
  WORD_SIZE: 64
  LIBM: libopenlibm
  LLVM: libLLVM-6.0.1 (ORCJIT, ivybridge)
nothing

Computing...100%|███████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████| Time: 0:00:10
Progress: 100%|█████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████| Time: 0:00:02

1.562545934571963e9 Alhamdulillah from WRY in Julia script. 

wruslan@HPEliteBk8470p-ub1604-64b:~/Documents/julia-parallel# 

===========================

julia> a() = sum(i for i in 1:1000);

julia> a
a (generic function with 1 method)

julia> b = Task(a);

julia> b
Task (runnable) @0x00007f24e806abf0

julia> current_task()
Task (runnable) @0x00007f2504fcf5b0

julia> Base.current_task()
Task (runnable) @0x00007f2504fcf5b0

julia> 
julia> function d() sum(i for i in 1:10);

       end;

julia> d()
55

julia> e = sum(i for i in 1:10);

julia> e
55

julia> e = sum(i for i in 1:11);

julia> e
66

julia> function g(n) 
           result = sum(i for i in 1:n);
       end;

julia> g(11)
66

julia> g(12)
78

julia> g(13)
91

julia> 
julia> a2() = sum(i for i in 1:1000);

julia> b = Task(a2);

julia> istaskdone(b)
false

julia> schedule(b);

julia> istaskdone(b)
true

julia> yield();

julia> istaskdone(b)
true


julia> a3() = sum(i for i in 1:1001);

julia> a3()
501501

julia> a2()
500500

julia> b3 = Task(a3)
Task (runnable) @0x00007f24e80b4010

julia> schedule(b3)
Task (done) @0x00007f24e80b4010

julia> Base.yield();

julia> istaskdone(b3)
true

julia> Base.istaskstarted(b3)
true

julia> Base.istaskdone(b3)
true

julia> b3
Task (done) @0x00007f24e80b4010

======================================

julia> chn1 = Channel(1);

julia> isopen(chn1)
true

julia> task1 = @async foreach(i->put!(chn1, i), 1:6);

julia> isopen(chn1)
true

julia> bind(chn1,task1);

julia> isopen(chn1)
true

julia> for i in chn1
          @show i
       end;
i = 1
i = 2
i = 3
i = 4
i = 5
i = 6

julia> isopen(chn1)
false

julia> 

===================================================
using ProgressMeter
using Distributed

p = Progress(10)
channel = RemoteChannel(()->Channel{Bool}(10), 1)

@sync begin
    # this task prints the progress bar
    @async while take!(channel)
        next!(p)
    end

    # this task does the computation
    @async begin
        @distributed (+) for i in 1:10
            sleep(0.1)
            put!(channel, true)
            i^2
        end
        put!(channel, false) # this tells the printing task to finish
    end
end



"""
# =========================================================

