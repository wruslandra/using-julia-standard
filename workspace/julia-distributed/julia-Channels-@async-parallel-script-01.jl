# File: julia-docs-distributed-05.jl
# Date:     Fri Jul  5 09:28:51 +08 2019
# Modified: 
# =========================================================
"""
https://docs.julialang.org/en/v1/manual/parallel-computing/index.html

"""

# =========================================================
using Dates 
print(Dates.time(), " Current date today() = ", Dates.today(), "\n")
print(Dates.time(), " Current date time now: ", Dates.now(), "\n")
print(Dates.time(), " Bismillah from WRY in Julia script. \n") 
# =========================================================



# =========================================================
# PARALLEL FUNCTIONS EXECUTIONS (ASYNCHRONOUSLY, OR NON BLOCKING)
print(Dates.time(), " ====== START PARALLEL FUNCTIONS EXECUTION ====== \n")

const jobs = Channel{Int}(32);
const results = Channel{Tuple}(32);

# ======================
function do_work()
   for job_id in jobs
	exec_time = rand(1:100)
        print(Dates.time(), " job_id $job_id started do_work() duration $exec_time seconds.\n")
        sleep(exec_time)    # simulates elapsed time doing actual work

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
print(Dates.time(), " Alhamdulillah from WRY in Julia script. \n\n")
# =========================================================

"""
EXECUTION 
wruslan@HPEliteBk8470p-ub1604-64b:~/Documents# julia julia-Channels-@async-parallel-script-01.jl 
1.56231556450686e9 Current date today() = 2019-07-05
1.562315564630705e9 Current date time now: 2019-07-05T16:32:44.63
1.562315564729785e9 Bismillah from WRY in Julia script. 
1.562315564740206e9 ====== START PARALLEL FUNCTIONS EXECUTION ====== 
1.562315565038119e9 job_id 1 started do_work().
1.562315565038178e9 job_id 2 started do_work().
1.562315565038203e9 job_id 3 started do_work().
1.562315565038216e9 job_id 4 started do_work().
1.562315566070373e9 job_id 3 set to finish in 1 seconds. 
1.562315566070447e9 job_id 3 finished do_work(). 
1.562315566070459e9 job_id 3 actually finished in 1.0 seconds 
1.562315567069519e9 job_id 2 set to finish in 2 seconds. 
1.562315567069623e9 job_id 2 finished do_work(). 
1.562315567069568e9 job_id 4 set to finish in 2 seconds. 
1.56231556706974e9 job_id 4 finished do_work(). 
1.56231556706964e9 job_id 2 actually finished in 2.0 seconds 
1.562315567069828e9 job_id 4 actually finished in 2.0 seconds 
1.562315572073945e9 job_id 1 set to finish in 7 seconds. 
1.562315572074035e9 job_id 1 finished do_work(). 
1.56231557207405e9 job_id 1 actually finished in 7.0 seconds 
1.562315572074396e9 Alhamdulillah from WRY in Julia script. 

wruslan@HPEliteBk8470p-ub1604-64b:~/Documents# julia julia-Channels-@async-parallel-script-01.jl 
1.562315680875752e9 Current date today() = 2019-07-05
1.562315681001034e9 Current date time now: 2019-07-05T16:34:41.001
1.562315681100605e9 Bismillah from WRY in Julia script. 
1.562315681111823e9 ====== START PARALLEL FUNCTIONS EXECUTION ====== 
1.56231568140983e9 job_id 1 started do_work().
1.56231568140989e9 job_id 2 started do_work().
1.562315681409918e9 job_id 3 started do_work().
1.562315681409933e9 job_id 4 started do_work().
1.562315682441955e9 job_id 4 set to finish in 1 seconds. 
1.562315682442034e9 job_id 4 finished do_work(). 
1.56231568244205e9 job_id 4 actually finished in 1.0 seconds 
1.562315683441488e9 job_id 2 set to finish in 2 seconds. 
1.562315683441591e9 job_id 2 finished do_work(). 
1.562315683441609e9 job_id 2 actually finished in 2.0 seconds 
1.562315685442784e9 job_id 3 set to finish in 4 seconds. 
1.56231568544287e9 job_id 3 finished do_work(). 
1.562315685442881e9 job_id 3 actually finished in 4.0 seconds 
1.562315690446053e9 job_id 1 set to finish in 9 seconds. 
1.562315690446139e9 job_id 1 finished do_work(). 
1.562315690446154e9 job_id 1 actually finished in 9.0 seconds 
1.562315690446512e9 Alhamdulillah from WRY in Julia script. 

wruslan@HPEliteBk8470p-ub1604-64b:~/Documents#
"""



