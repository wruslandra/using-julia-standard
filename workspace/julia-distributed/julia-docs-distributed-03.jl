# File: julia-docs-distributed-03.jl
# Date:     Fri Jul  5 09:28:51 +08 2019
# Modified: 
# ========================================================
"""
https://pkg.julialang.org/docs/julia/THl1k/1.1.1/stdlib/Distributed.html

Replaced @parallel by @distributed and the errors are gone!
"""

# ========================================================
using Dates 
print(Dates.time(), " Current date today() = ", Dates.today(), "\n")
print(Dates.time(), " Current date time now: ", Dates.now(), "\n")
print(Dates.time(), " Bismillah from WRY in Julia script. \n") 
# =========================================================

# ==========================================
using BenchmarkTools
function simple_loop_sum()
     M = 1000000
     n = Core.Array{Float64,1}(UndefInitializer(), M)
     for i=1:M; n[i] = log1p(i); end#for
     return sum(n)
end

println("\n (1) Run function simple_loop_sum() = ", simple_loop_sum())
BenchmarkTools.@btime simple_loop_sum()
Base.@time simple_loop_sum()
BenchmarkTools.@benchmark simple_loop_sum()

# ==========================================
using SharedArrays
using Base
using Distributed
function sharedarray_parallel_sum()
    M = 3000000
    a = SharedArrays.SharedArray{Float64,1}(M)
    s = Base.@sync Distributed.@distributed for i=1:M; a[i]=log1p(i); end#for
    return sum(a)
end

println("\n (2) Run function sharedarray_parallel_sum() = ", sharedarray_parallel_sum())
BenchmarkTools.@btime sharedarray_parallel_sum()
Base.@time sharedarray_parallel_sum()
BenchmarkTools.@benchmark sharedarray_parallel_sum()

# =========================================
function sharedarray_mapreduce()
    M = 3000000
    a = SharedArrays.SharedArray{Float64,1}(M)
    s = Distributed.@distributed (+) for i=1:M; a[i]=log1p(i); end#for
    return s
end

println("\n (4) Run function sharedarray_mapreduce() = ", sharedarray_mapreduce())
BenchmarkTools.@btime sharedarray_mapreduce()
Base.@time sharedarray_mapreduce()
BenchmarkTools.@benchmark sharedarray_parallel_sum()

# ========================================
function threads_sum()
    M = 3000000
    a = Core.Array{Float64,1}(UndefInitializer(),M)
    Base.Threads.@threads for i=1:M
        a[i]=log1p(i)
    end#for
    return sum(a)
end

println("\n (5) Run function threads_sum() = ", threads_sum())
BenchmarkTools.@btime threads_sum()
Base.@time threads_sum()
BenchmarkTools.@benchmark threads_sum()

# =========================================================
print("\n", Dates.time(), " Alhamdulillah from WRY in Julia script. \n\n") 
# =========================================================

# EXECUTION
"""
wruslan@HPEliteBk8470p-ub1604-64b:~/Documents# julia julia-docs-distributed-03.jl 
1.562313285650974e9 Current date today() = 2019-07-05
1.562313285778144e9 Current date time now: 2019-07-05T15:54:45.778
1.562313285880801e9 Bismillah from WRY in Julia script. 

 (1) Run function simple_loop_sum() = 1.2815532200169727e7
  16.752 ms (2 allocations: 7.63 MiB)
  0.020498 seconds (7 allocations: 7.630 MiB, 10.01% gc time)

 (2) Run function sharedarray_parallel_sum() = 4.1742391830020316e7
  59.940 ms (157 allocations: 8.50 KiB)
  0.061880 seconds (169 allocations: 8.828 KiB)

 (4) Run function sharedarray_mapreduce() = 4.174239183001794e7
  89.150 ms (141 allocations: 7.20 KiB)
  0.090208 seconds (148 allocations: 7.453 KiB)

 (5) Run function threads_sum() = 4.1742391830020316e7
  51.300 ms (3 allocations: 22.89 MiB)
  0.054556 seconds (8 allocations: 22.888 MiB, 0.50% gc time)

1.562313383183144e9 Alhamdulillah from WRY in Julia script. 

wruslan@HPEliteBk8470p-ub1604-64b:~/Documents# 


# ==========================
julia> versioninfo()
Julia Version 1.1.1
Commit 55e36cc308 (2019-05-16 04:10 UTC)
Platform Info:
  OS: Linux (x86_64-pc-linux-gnu)
  CPU: Intel(R) Core(TM) i5-3380M CPU @ 2.90GHz
  WORD_SIZE: 64
  LIBM: libopenlibm
  LLVM: libLLVM-6.0.1 (ORCJIT, ivybridge)
# ===========================
julia> @benchmark simple_loop_sum()
BenchmarkTools.Trial: 
  memory estimate:  7.63 MiB
  allocs estimate:  2
  --------------
  minimum time:     16.600 ms (0.00% GC)
  median time:      16.736 ms (0.00% GC)
  mean time:        17.314 ms (2.18% GC)
  maximum time:     66.841 ms (73.36% GC)
  --------------
  samples:          289
  evals/sample:     1

julia> 
# ==========================
julia> BenchmarkTools.@benchmark simple_loop_sum()
BenchmarkTools.Trial: 
  memory estimate:  7.63 MiB
  allocs estimate:  2
  --------------
  minimum time:     16.623 ms (0.00% GC)
  median time:      16.720 ms (0.00% GC)
  mean time:        17.296 ms (2.17% GC)
  maximum time:     66.836 ms (73.69% GC)
  --------------
  samples:          289
  evals/sample:     1

julia>
# ========================== 
julia> BenchmarkTools.@benchmark sharedarray_parallel_sum()
BenchmarkTools.Trial: 
  memory estimate:  8.52 KiB
  allocs estimate:  158
  --------------
  minimum time:     60.057 ms (0.00% GC)
  median time:      60.507 ms (0.00% GC)
  mean time:        60.570 ms (0.00% GC)
  maximum time:     62.805 ms (0.00% GC)
  --------------
  samples:          83
  evals/sample:     1

julia> 

# ========================== 
julia> 
julia> BenchmarkTools.@benchmark sharedarray_mapreduce()
BenchmarkTools.Trial: 
  memory estimate:  7.20 KiB
  allocs estimate:  141
  --------------
  minimum time:     89.165 ms (0.00% GC)
  median time:      89.555 ms (0.00% GC)
  mean time:        89.540 ms (0.00% GC)
  maximum time:     90.078 ms (0.00% GC)
  --------------
  samples:          56
  evals/sample:     1

julia> 
# =========================
julia> BenchmarkTools.@benchmark threads_sum()
BenchmarkTools.Trial: 
  memory estimate:  22.89 MiB
  allocs estimate:  3
  --------------
  minimum time:     51.564 ms (1.59% GC)
  median time:      53.109 ms (0.90% GC)
  mean time:        54.072 ms (3.51% GC)
  maximum time:     113.825 ms (53.58% GC)
  --------------
  samples:          93
  evals/sample:     1

julia> 

"""

# =========================================================

