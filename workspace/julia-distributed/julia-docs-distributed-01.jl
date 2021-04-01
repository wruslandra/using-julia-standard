# File: julia-docs-distributed-01.jl
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

using Distributed
initial_numprocs = Distributed.nprocs()
println("\n (1) initial_numprocs = ", initial_numprocs)

initial_numworkers = Distributed.nworkers()
println("\n (2) initial_numworkers = ", initial_numworkers)

# ADD PROCESSES
println("\n (3) ADD 4 PROCESSORS ")
total_numprocs = Distributed.addprocs(4)

# DISPLAY PROCESSES
total_numprocs = Distributed.nprocs()
println("\n (4) total_numprocs = ", total_numprocs)
disp_numprocs = Distributed.procs()
println("\n (5) display_numprocs = ", disp_numprocs)

# DISPLAY WORKERS
total_numworkers = Distributed.nworkers()
println("\n (6) total_numworkers = ", total_numworkers)
disp_numworkers = Distributed.workers()
println("\n (7) display_numworkers = ", disp_numworkers)

# =========================================================
print("\n", Dates.time(), " Alhamdulillah from WRY in Julia script. \n") 
# =========================================================

# EXECUTION
"""
wruslan@HPEliteBk8470p-ub1604-64b:~/Documents# julia julia-docs-distributed-01.jl 
1.562310959560568e9 Current date today() = 2019-07-05
1.562310959689201e9 Current date time now: 2019-07-05T15:15:59.689
1.56231095979215e9 Bismillah from WRY in Julia script. 

 (1) initial_numprocs = 1

 (2) initial_numworkers = 1

 (3) ADD 4 PROCESSORS 

 (4) total_numprocs = 5

 (5) display_numprocs = [1, 2, 3, 4, 5]

 (6) total_numworkers = 4

 (7) display_numworkers = [2, 3, 4, 5]

1.562310962883121e9 Alhamdulillah from WRY in Julia script. 
wruslan@HPEliteBk8470p-ub1604-64b:~/Documents# 

"""
# =========================================================
# =========================================================

