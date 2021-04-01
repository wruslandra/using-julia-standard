# File: julia-docs-parallel-03.jl
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

# https://pkg.julialang.org/docs/ProgressMeter/3V8n6/1.0.0/
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



"""
# =========================================================

