# HTTP Performance
Specifically httperf util


Learn more on [httperf/httperf|https://github.com/httperf/httperf].  

Usage  
===============


- Generate 100 connections at fixed rate of 10 per second  
- 5 calls per session in 2 second intervals  
`httperf --hog --server=www --wsess=10,5,2 --rate=1 --timeout=5 --ssl`  



