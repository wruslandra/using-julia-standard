# File: julia-coroutines-tasks-01.jl
# Date:     Tue Jul  9 22:02:54 +08 2019
# Modified: 
# =========================================================
"""
https://docs.julialang.org/en/v1/manual/control-flow/#man-tasks-1

https://www.quora.com/Does-the-Julia-programming-language-have-asynchronous-features

# https://stackoverflow.com/questions/41928047/julia-lang-cache-data-in-a-parallel-thread-using-async?rq=1

Instead, Julia can schedule any function for asynchronous execution using the @async macro, which returns a scheduled task that you can wait for later. While you don’t have to do anything, you may want to sprinkle some calls to yield() around your code, so scheduled tasks get a chance to run. All IO in will be handled in a non-blocking manner.


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

# f = open("file")

try
    # operate on file f
catch
    # ha ha ha

finally
    # close(f)
end


# =======================
chan = Channel() do c
           for line in eachline(download("https://google.com/"))
               put!(c, line)
           end
       end
# =======================
for line in chan
           println(line)
       end

# =========================================================
print("\n\n", Dates.time(), " Alhamdulillah from WRY in Julia script. \n\n") 
# =========================================================

"""
EXECUTION

wruslan@HPEliteBk8470p-ub1604-64b:~/Documents/julia-parallel# julia julia-coroutines-tasks-01.jl 
1.562744052015321e9 Current date today() = 2019-07-10
1.562744052170703e9 Current date time now: 2019-07-10T15:34:12.17
1.56274405227489e9 Bismillah from WRY in Julia script. 

Julia Version 1.1.1
Commit 55e36cc308 (2019-05-16 04:10 UTC)
Platform Info:
  OS: Linux (x86_64-pc-linux-gnu)
  CPU: Intel(R) Core(TM) i5-3380M CPU @ 2.90GHz
  WORD_SIZE: 64
  LIBM: libopenlibm
  LLVM: libLLVM-6.0.1 (ORCJIT, ivybridge)
nothing

  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100   220  100   220    0     0    385      0 --:--:-- --:--:-- --:--:--   385
100 11858    0 11858    0     0  12208      0 --:--:-- --:--:-- --:--:-- 1017k
<!doctype html><html itemscope="" itemtype="http://schema.org/WebPage" lang="en-MY"><head><meta content="text/html; charset=UTF-8" http-equiv="Content-Type"><meta content="/images/branding/googleg/1x/googleg_standard_color_128dp.png" itemprop="image"><title>Google</title><script nonce="y2RyV5TEyS5+NkHg7BKe0A==">(function(){window.google={kEI:'95QlXbOTHLOymgfq1pLwBA',kEXPI:'0,1353804,1957,2423,1225,731,223,510,19,695,351,2081,1070,58,321,206,1017,175,109,451,472,75,202,240,55,329,22,1133726,1197790,329478,1294,12383,4855,32692,15247,867,12163,5281,1100,3335,2,2,6801,364,3319,5505,224,2218,260,5107,575,835,284,2,578,728,2431,59,2,4,1297,4323,4968,773,2251,1406,3337,1146,9,4558,2287,1314,669,1050,1808,1397,81,7,3,488,2044,


1.5627440556856e9 Alhamdulillah from WRY in Julia script. 

wruslan@HPEliteBk8470p-ub1604-64b:~/Documents/julia-parallel# 

"""

