# File: julia-docs-parallel-05.jl
# Date:     Tue Jul  9 22:02:54 +08 2019
# Modified: 
# =========================================================
"""

# https://stackoverflow.com/questions/41928047/julia-lang-cache-data-in-a-parallel-thread-using-async?rq=1


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

using Base
Base.Threads.nthreads()=4
Base.Threads.nthreads()

# =====================================
macro swap(x,y)
  quote
    local tmp = $(esc(x))
    $(esc(x)) = $(esc(y))
    $(esc(y)) = tmp
  end
end

# ====================================
# some slow function 
# NOTE: (@everywhere requires execution pf "julia -p numprocs  xxx.jl", and not just "julia xxx.jl")
@everywhere function prime(i)
  sleep(2)
  println("prime $i")
  i
end

# ====================================
function slow_process(x)
  sleep(2)
  println("slow_process $x")
end

# ====================================
function each(rng)
  @assert length(rng) > 1
  rng = collect(rng)
  a = b = nothing
  function _iter()
    for i ∈ 1:length(rng)
      if a == nothing
        a = remotecall(prime, 2, rng[i])
        b = remotecall(prime, 2, rng[i+1])
      else
        if i < length(rng)
          a = remotecall(prime, 2, rng[i+1])
        end
        @swap(a,b)
      end
      d = fetch(a)
      produce(d)
    end
  end
  return Base.Task(_iter)
end

# =========================
# @time for x ∈ each(1000:1002)
#  slow_process(x)
# end

@time slow_process(1000)
@time slow_process(2000)
@time slow_process(4000)


# =========================================================
print("\n\n", Dates.time(), " Alhamdulillah from WRY in Julia script. \n\n") 
# =========================================================

"""
EXECUTION

wruslan@HPEliteBk8470p-ub1604-64b:~/Documents/julia-parallel# julia -p 4 julia-docs-parallel-05.jl 
1.562681442838032e9 Current date today() = 2019-07-09
1.562681442958997e9 Current date time now: 2019-07-09T22:10:42.959
1.5626814430597e9 Bismillah from WRY in Julia script. 

Julia Version 1.1.1
Commit 55e36cc308 (2019-05-16 04:10 UTC)
Platform Info:
  OS: Linux (x86_64-pc-linux-gnu)
  CPU: Intel(R) Core(TM) i5-3380M CPU @ 2.90GHz
  WORD_SIZE: 64
  LIBM: libopenlibm
  LLVM: libLLVM-6.0.1 (ORCJIT, ivybridge)
nothing

slow_process 1000
  2.010119 seconds (2.40 k allocations: 115.066 KiB)
slow_process 1001
  2.003162 seconds (22 allocations: 1.063 KiB)
slow_process 1002
  2.003148 seconds (21 allocations: 752 bytes)


1.562681452164689e9 Alhamdulillah from WRY in Julia script. 

wruslan@HPEliteBk8470p-ub1604-64b:~/Documents/julia-parallel# 
wruslan@HPEliteBk8470p-ub1604-64b:~/Documents/julia-parallel# julia -p 2 julia-docs-parallel-05.jl 
1.562681489469989e9 Current date today() = 2019-07-09
1.562681489590288e9 Current date time now: 2019-07-09T22:11:29.59
1.562681489692222e9 Bismillah from WRY in Julia script. 

Julia Version 1.1.1
Commit 55e36cc308 (2019-05-16 04:10 UTC)
Platform Info:
  OS: Linux (x86_64-pc-linux-gnu)
  CPU: Intel(R) Core(TM) i5-3380M CPU @ 2.90GHz
  WORD_SIZE: 64
  LIBM: libopenlibm
  LLVM: libLLVM-6.0.1 (ORCJIT, ivybridge)
nothing

slow_process 1000
  2.010088 seconds (2.40 k allocations: 115.066 KiB)
slow_process 1001
  2.003158 seconds (21 allocations: 752 bytes)
slow_process 1002
  2.003166 seconds (21 allocations: 752 bytes)


1.56268149864212e9 Alhamdulillah from WRY in Julia script. 

wruslan@HPEliteBk8470p-ub1604-64b:~/Documents/julia-parallel#
wruslan@HPEliteBk8470p-ub1604-64b:~/Documents/julia-parallel# julia julia-docs-parallel-05.jl 
1.562681513472002e9 Current date today() = 2019-07-09
1.562681513625287e9 Current date time now: 2019-07-09T22:11:53.625
1.562681513726677e9 Bismillah from WRY in Julia script. 

Julia Version 1.1.1
Commit 55e36cc308 (2019-05-16 04:10 UTC)
Platform Info:
  OS: Linux (x86_64-pc-linux-gnu)
  CPU: Intel(R) Core(TM) i5-3380M CPU @ 2.90GHz
  WORD_SIZE: 64
  LIBM: libopenlibm
  LLVM: libLLVM-6.0.1 (ORCJIT, ivybridge)
nothing

ERROR: LoadError: LoadError: UndefVarError: @everywhere not defined
Stacktrace:
 [1] top-level scope
 [2] include at ./boot.jl:326 [inlined]
 [3] include_relative(::Module, ::String) at ./loading.jl:1038
 [4] include(::Module, ::String) at ./sysimg.jl:29
 [5] exec_options(::Base.JLOptions) at ./client.jl:267
 [6] _start() at ./client.jl:436
in expression starting at /home/wruslan/Documents/julia-parallel/julia-docs-parallel-05.jl:36
in expression starting at /home/wruslan/Documents/julia-parallel/julia-docs-parallel-05.jl:36
wruslan@HPEliteBk8470p-ub1604-64b:~/Documents/julia-parallel# 

"""

