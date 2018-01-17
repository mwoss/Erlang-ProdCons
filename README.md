# Erlang Producer and Consumer problem solution using Erlang

Solution for Producer and Consumer concurrency problem using Erlang language. 
Implemented solution is based on book "Programowanie współbieżne" - Weiss, Gruźlewski.

#### How to use:
```
 {First, Last} = buffer:start(BUFFER_SIZE).
 consumer:start(CONSUMER_AMOUNT, Last), producer:start(PRODUCER_AMOUNT, First).
```
