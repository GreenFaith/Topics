Topics
======

basic Topic/Reply web applicant（build on openresty)



Benchmark
======
cpu MHz		: 2000.000
cpu MHz		: 1200.000

Server Software:        openresty/1.7.0.1
Server Hostname:        api.mysite.com
Server Port:            80

Document Path:          /topics
Document Length:        1928 bytes

Concurrency Level:      1000
Time taken for tests:   4.640 seconds
Complete requests:      10000
Failed requests:        825
   (Connect: 0, Receive: 0, Length: 825, Exceptions: 0)
Write errors:           0
Total transferred:      20866425 bytes
HTML transferred:       17738075 bytes
Requests per second:    2154.94 [#/sec] (mean)
Time per request:       464.049 [ms] (mean)
Time per request:       0.464 [ms] (mean, across all concurrent requests)
Transfer rate:          4391.21 [Kbytes/sec] received

Connection Times (ms)
              min  mean[+/-sd] median   max
Connect:        0  259 595.1      0    3011
Processing:    18  100 110.7     68    1750
Waiting:       17  100 110.8     68    1750
Total:         19  359 646.0     71    3904

Percentage of the requests served within a certain time (ms)
  50%     71
  66%     91
  75%    183
  80%    300
  90%   1092
  95%   1365
  98%   3078
  99%   3272
 100%   3904 (longest request)

