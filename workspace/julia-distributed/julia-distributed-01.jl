# File: julia-script-04.jl
# Date:     Fri Aug 31 16:02:56 +08 2018
# Modified: Thu Jul 04 19:39:22 +08 2019
# ========================================================

# ========================================================
using Dates 
print(Dates.time(), " Current date today() = ", Dates.today(), "\n")
print(Dates.time(), " Current date time now: ", Dates.now(), "\n")
print(Dates.time(), " Bismillah from WRY in Julia script. \n") 

using PyCall
## @pyimport psutil
psutil = pyimport("psutil")
nCPU = psutil.cpu_count()
print(Dates.time(), " PyCall: Value of psutil.cpu_count() = $nCPU \n")

using Hwloc
topology = Hwloc.topology_load()
counts = Hwloc.histmap(topology)
ncores = counts[:Core]
npus = counts[:PU]
print(Dates.time(), " Hwloc: This machine has $ncores cores and $npus PUs (processing units). \n")
nphysicalcores = Hwloc.num_physical_cores()
print(Dates.time(), " Hwloc: This machine has $nphysicalcores physical cores. \n")

# =========================================================
# PARALLEL COMPUTING IN JULIA (Distributed package)
# =========================================================
# Create n workers at start of Julia session
# MUST RUN "julia -p n" TO GET nprocs(), IF NOT ERROR

# View number of workers + master process
# Create n workers during a session if required
# workers are addressed by numbers (PIDs)
# master process had PID =1, the rest are PID of workers
using Distributed
Distributed.addprocs(4);
my_nprocs = Distributed.nprocs();
print(Dates.time(), " Number of workers + master process = $my_nprocs \n")
my_wpid = Distributed.workers();
print(Dates.time(), " List of workers PIDs = $my_wpid \n")

# =========================================================
function fxn02(input02, sleeprand02)
    print(Dates.time(), " Started  running fxn02 \n")
    print(Dates.time(), " Value input02 = $input02 \n")
    print(Dates.time(), " Value sleeprand02 = $sleeprand02 \n")
    sleep(sleeprand02)
    str02 = " Result $input02 returned from fxn02"  
    print(Dates.time(), " Finished running fxn02 \n")
    return (str02)	
end 

function fxn03(input03, sleeprand03)
    print(Dates.time(), " Started  running fxn03 \n")
    print(Dates.time(), " Value input03 = $input03 \n")
    print(Dates.time(), " Value sleeprand03 = $sleeprand03 \n")
    sleep(sleeprand03)
    str03 = " Result $input03 returned from fxn03"  
    print(Dates.time(), " Finished running fxn03 \n")
    return (str03)	
end 

function fxn04(input04, sleeprand04)
    print(Dates.time(), " Started  running fxn04 \n")
    print(Dates.time(), " Value input04 = $input04 \n")
    print(Dates.time(), " Value sleeprand04 = $sleeprand04 \n")
    sleep(sleeprand04)
    str04 = " Result $input04 returned from fxn04"  
    print(Dates.time(), " Finished running fxn04 \n")
    return (str04)	
end 

function fxn05(input05, sleeprand05)
    print(Dates.time(), " Started  running fxn05 \n")
    print(Dates.time(), " Value input05 = $input05 \n")
    print(Dates.time(), " Value sleeprand05 = $sleeprand05 \n")
    sleep(sleeprand05)
    str05 = " Result $input05 returned from fxn05"  
    print(Dates.time(), " Finished running fxn05 \n")
    return (str05)	
end 

# =========================================================
# DATA ASSIGNED TO FUNCTIONS
input02 = 2.2222; sleeprand02 = rand(1:10)
input03 = 3.3333; sleeprand03 = rand(1:10)
input04 = 4.4444; sleeprand04 = rand(1:10)
input05 = 5.5555; sleeprand05 = rand(1:10)
# =========================================================
# SEQUENTIAL FUNCTIONS EXECUTION
print(Dates.time(), " ====== START SEQUENTIAL FUNCTIONS EXECUTION ====== \n")
runfxn02 = fxn02(input02, sleeprand02)
runfxn03 = fxn03(input03, sleeprand03)
runfxn04 = fxn04(input04, sleeprand04)
runfxn05 = fxn05(input05, sleeprand05)

# DISPLAY RESULTS OF EXECUTIONS
print(Dates.time(), " In Main runfxn02 = $runfxn02 \n")
print(Dates.time(), " In Main runfxn03 = $runfxn03 \n")
print(Dates.time(), " In Main runfxn04 = $runfxn04 \n")
print(Dates.time(), " In Main runfxn05 = $runfxn05 \n")

# =========================================================
# PARALLEL FUNCTIONS EXECUTIONS (ASYNCHRONOUSLY, OR NON BLOCKING)
print(Dates.time(), " ====== START PARALLEL FUNCTIONS EXECUTION ====== \n")

const jobs = Channel{Int}(32);
const results = Channel{Tuple}(32);

# ======================
function do_work()
   for job_id in jobs
       print(Dates.time(), " job_id $job_id started do_work().\n")
       exec_time = rand(1:10)
       sleep(exec_time)    # simulates elapsed time doing actual work
       print(Dates.time(), " job_id $job_id set to finish in $exec_time seconds. \n")
       put!(results, (job_id, exec_time))
       print(Dates.time(), " job_id $job_id finished do_work(). \n")
   end
end;

# ======================
function make_jobs(n)
    for i in 1:n
        put!(jobs, i)
    end
end;

# feed the jobs channel with "n" jobs
n = 4;
@async make_jobs(n); 

# start 4 tasks to process requests in parallel
for i in 1:4 
    @async do_work()
end

# print out results
@elapsed while n > 0 
    job_id, exec_time = take!(results)
    print(Dates.time(), " job_id $job_id actually finished in $(round(exec_time; digits=4)) seconds \n")
    global n = n - 1
end

# =========================================================
print(Dates.time(), " Alhamdulillah from WRY in Julia script. \n")
# =========================================================
"""
EXECUTION 1

wruslan@HP-ELBook8470p-ub1604-64b:~/Downloads/temp julia -p 4 julia-script04.jl
1.535760901044821e9 Current date today() = 2018-09-01
1.535760901176391e9 Current date time now: 2018-09-01T08:15:01.176
1.535760901266606e9 Bismillah from WRY in Julia script. 
1.535760910499787e9 PyCall: Value of psutil.cpu_count() = 4 
1.535760918305807e9 Hwloc: This machine has 2 cores and 4 PUs (processing units). 
1.535760918463921e9 Hwloc: This machine has 2 physical cores. 
1.535760918464832e9 Number of workers + master process = 5 
1.535760918473897e9 List of workers PIDs = [2, 3, 4, 5] 
1.535760918762892e9 ====== START SEQUENTIAL FUNCTIONS EXECUTION ====== 
1.5357609187739e9 Started  running fxn02 
1.535760918774005e9 Value input02 = 2.2222 
1.535760918774057e9 Value sleeprand02 = 1 
1.535760919776272e9 Finished running fxn02 
1.535760919798129e9 Started  running fxn03 
1.535760919798278e9 Value input03 = 3.3333 
1.535760919798374e9 Value sleeprand03 = 2 
1.535760921801578e9 Finished running fxn03 
1.535760921820814e9 Started  running fxn04 
1.535760921820915e9 Value input04 = 4.4444 
1.535760921820977e9 Value sleeprand04 = 1 
1.535760922823194e9 Finished running fxn04 
1.535760922847947e9 Started  running fxn05 
1.535760922848116e9 Value input05 = 5.5555 
1.535760922848213e9 Value sleeprand05 = 3 
1.535760925852463e9 Finished running fxn05 
1.53576092585304e9 In Main runfxn02 =  Result 2.2222 returned from fxn02 
1.535760925853588e9 In Main runfxn03 =  Result 3.3333 returned from fxn03 
1.535760925854025e9 In Main runfxn04 =  Result 4.4444 returned from fxn04 
1.535760925854435e9 In Main runfxn05 =  Result 5.5555 returned from fxn05 
1.535760925854789e9 ====== START PARALLEL FUNCTIONS EXECUTION ====== 
1.535760926140693e9 job_id 1 started 
1.535760926140750e9 job_id 2 started 
1.535760926140759e9 job_id 3 started 
1.535760926140762e9 job_id 4 started 
1.535760930146089e9 job_id 2 set to finish in 4 seconds. 
1.535760930146177e9 job_id 4 set to finish in 4 seconds. 
1.535760930146448e9 job_id 2 actually finished in 4.0 seconds 
1.535760930178436e9 job_id 4 actually finished in 4.0 seconds 
1.535760932143593e9 job_id 3 set to finish in 6 seconds. 
1.535760932143825e9 job_id 3 actually finished in 6.0 seconds 
1.535760935145178e9 job_id 1 set to finish in 9 seconds. 
1.535760935145356e9 job_id 1 actually finished in 9.0 seconds 
1.535760935145937e9 Alhamdulillah from WRY in Julia script. 
wruslan@HP-ELBook8470p-ub1604-64b:~/Downloads/temp

ANALYSIS 1.1
 1.535760,935,145,356e9 job_id 1 actually finished in 9.0 seconds 
-1.535760,926,140,693e9 job_id 1 started 
========================
            9,004,663e9 CONFIRMED 9 seconds, 

ANALYSIS 1.2

 1.535760932,143,825e9 job_id 3 actually finished in 6.0 seconds 
-1.535760926,140,759e9 job_id 3 started 
========================
           6,003,066e9 CONFIRMED 6 seconds.

EXECUTION 2

wruslan@HP-ELBook8470p-ub1604-64b:~/Downloads/temp julia -p 4 julia-script04.jl
1.535761821515869e9 Current date today() = 2018-09-01
1.535761821656556e9 Current date time now: 2018-09-01T08:30:21.656
1.535761821745387e9 Bismillah from WRY in Julia script. 
1.535761830903611e9 PyCall: Value of psutil.cpu_count() = 4 
1.535761838714373e9 Hwloc: This machine has 2 cores and 4 PUs (processing units). 
1.535761838876378e9 Hwloc: This machine has 2 physical cores. 
1.535761838876955e9 Number of workers + master process = 5 
1.535761838901269e9 List of workers PIDs = [2, 3, 4, 5] 
1.535761839174190e9 ====== START SEQUENTIAL FUNCTIONS EXECUTION ====== 
1.535761839185062e9 Started  running fxn02 
1.535761839185163e9 Value input02 = 2.2222 
1.535761839185216e9 Value sleeprand02 = 7 
1.535761846192202e9 Finished running fxn02 
1.535761846214519e9 Started  running fxn03 
1.535761846214672e9 Value input03 = 3.3333 
1.535761846214757e9 Value sleeprand03 = 4 
1.535761850219946e9 Finished running fxn03 
1.535761850239776e9 Started  running fxn04 
1.535761850239921e9 Value input04 = 4.4444 
1.535761850240005e9 Value sleeprand04 = 10 
1.535761860247521e9 Finished running fxn04 
1.535761860269229e9 Started  running fxn05 
1.535761860269385e9 Value input05 = 5.5555 
1.535761860269468e9 Value sleeprand05 = 9 
1.535761869279662e9 Finished running fxn05 
1.535761869280255e9 In Main runfxn02 =  Result 2.2222 returned from fxn02 
1.535761869280763e9 In Main runfxn03 =  Result 3.3333 returned from fxn03 
1.535761869281252e9 In Main runfxn04 =  Result 4.4444 returned from fxn04 
1.535761869281725e9 In Main runfxn05 =  Result 5.5555 returned from fxn05 
1.535761869282145e9 ====== START PARALLEL FUNCTIONS EXECUTION ====== 
1.535761869574609e9 job_id 1 started do_work().
1.535761869574664e9 job_id 2 started do_work().
1.535761869574676e9 job_id 3 started do_work().
1.535761869574683e9 job_id 4 started do_work().
1.535761872579027e9 job_id 4 set to finish in 3 seconds. 
1.535761872579328e9 job_id 4 finished do_work(). 
1.535761872579457e9 job_id 4 actually finished in 3.0 seconds 
1.535761873576851e9 job_id 2 set to finish in 4 seconds. 
1.535761873577079e9 job_id 2 finished do_work(). 
1.535761873577144e9 job_id 2 actually finished in 4.0 seconds 
1.535761875577793e9 job_id 1 set to finish in 6 seconds. 
1.535761875578067e9 job_id 1 finished do_work(). 
1.535761875578148e9 job_id 1 actually finished in 6.0 seconds 
1.535761876576700e9 job_id 3 set to finish in 7 seconds. 
1.535761876576916e9 job_id 3 finished do_work(). 
1.535761876576973e9 job_id 3 actually finished in 7.0 seconds 
1.535761876577773e9 Alhamdulillah from WRY in Julia script. 
wruslan@HP-ELBook8470p-ub1604-64b:~/Downloads/temp 

ANALYSIS 2.1

 1.535761,876,576,973e9 job_id 3 actually finished in 7.0 seconds 
 1.535761,876,576,916e9 job_id 3 finished do_work(). 
-1.535761,869,574,676e9 job_id 3 started do_work().  
=======================
            7,002,240e9 CONFIRMED 7 seconds.

"""
# =========================================================

