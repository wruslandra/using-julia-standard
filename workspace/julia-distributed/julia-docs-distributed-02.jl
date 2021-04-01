# File: julia-docs-distributed-02.jl
# Date:     Fri Jul  5 11:28:51 +08 2019
# Modified: 
# ========================================================
# REFERENCES 
# https://docs.julialang.org/en/v1/manual/parallel-computing/index.html
# =======================================================
using Distributed	# https://pkg.julialang.org/docs/julia/THl1k/1.1.1/stdlib/Distributed.html
using BenchmarkTools	# https://github.com/JuliaCI/BenchmarkTools.jl/blob/master/doc/manual.md
using Core		# https://docs.julialang.org/en/v1/base/arrays/index.html
using SharedArrays 	# https://pkg.julialang.org/docs/julia/THl1k/1.1.1/stdlib/SharedArrays.html
using Base: Threads	# https://pkg.julialang.org/docs/julia/THl1k/1.1.1/stdlib/Distributed.html#Base.@sync
# ========================================================
# ========================================================
using Dates 
print(Dates.time(), " Current date today() = ", Dates.today(), "\n")
print(Dates.time(), " Current date time now: ", Dates.now(), "\n")
print(Dates.time(), " Bismillah from WRY in Julia script. \n") 

# ==========================================
function simple_loop_sum()
     M = 3000000
     n = Core.Array{Float64,1}(UndefInitializer(), M)
     for i=1:M; n[i] = log1p(i); end#for
     return sum(n)
end

println("\n (1) Run function simple_loop_sum() = ", simple_loop_sum())
BenchmarkTools.@btime simple_loop_sum()
Base.@time simple_loop_sum()

# ==========================================
# =========================================
function pmap_sum()
         M = 3000000
         r = Distributed.pmap(log1p, 1:M, batch_size=ceil(Int,M/nworkers()))
         return sum(r)
end

println("\n (2) Run function pmap_sum() = ", pmap_sum())
BenchmarkTools.@btime pmap_sum()
Base.@time pmap_sum()

# ==========================================
# ==========================================
function sharedarray_parallel_sum()
    M = 3000000
    a = SharedArrays.SharedArray{Float64,1}(M)
    s = Base.@sync Distributed.@distributed for i=1:M; a[i]=log1p(i); end#for
    return sum(a)
end

println("\n (3) Run function sharedarray_parallel_sum() = ", sharedarray_parallel_sum())
BenchmarkTools.@btime sharedarray_parallel_sum()
Base.@time sharedarray_parallel_sum()

# =========================================
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

# ========================================
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
Base.@time threads_sum

# =========================================================
print("\n", Dates.time(), " Alhamdulillah from WRY in Julia script. \n") 
# =========================================================

"""
EXECUTION
wruslan@HPEliteBk8470p-ub1604-64b:~/Documents# julia  julia-docs-distributed-02.jl 
1.562300170372028e9 Current date today() = 2019-07-05
1.562300170496291e9 Current date time now: 2019-07-05T12:16:10.496
1.562300170599442e9 Bismillah from WRY in Julia script. 

 (1) Run function simple_loop_sum() = 4.1742391830020316e7
  50.302 ms (2 allocations: 22.89 MiB)
  0.054570 seconds (7 allocations: 22.888 MiB, 3.82% gc time)

 (2) Run function pmap_sum() = 4.1742391830020316e7
  11.044 s (24000046 allocations: 457.77 MiB)
 10.966952 seconds (24.00 M allocations: 457.766 MiB, 13.38% gc time)

 (3) Run function sharedarray_parallel_sum() = 4.1742391830020316e7
  60.225 ms (157 allocations: 8.50 KiB)
  0.061108 seconds (166 allocations: 8.734 KiB)

 (4) Run function sharedarray_mapreduce() = 4.174239183001794e7
  89.082 ms (141 allocations: 7.20 KiB)
  0.090043 seconds (147 allocations: 7.391 KiB)

 (5) Run function threads_sum() = 4.1742391830020316e7
  50.945 ms (3 allocations: 22.89 MiB)
  0.000001 seconds (3 allocations: 144 bytes)

1.562300289919222e9 Alhamdulillah from WRY in Julia script. 
wruslan@HPEliteBk8470p-ub1604-64b:~/Documents#

"""
# =========================================================

