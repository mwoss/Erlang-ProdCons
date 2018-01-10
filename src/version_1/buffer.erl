%%%-------------------------------------------------------------------
%%% @author Matthew
%%% @copyright (C) 2018, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 10. sty 2018 01:16
%%%-------------------------------------------------------------------
-module(buffer).
-author("Matthew").

%% API
-export([start/1, produce/2, consume/1, stop/1, last/1, buffer/2]).

start(Size) ->
  Last = spawn(buffer, last, [empty]),
  Next = spawnBuffer(Size - 2, Last),
  First = spawn(buffer, buffer, [Next, empty]),
  {First, Last}.

produce(PID, Data) ->
  PID ! {self(), pass, Data},
  receive
    ok -> ok
  end.

consume(PID) ->
  PID ! {self(), get},
  receive
    {ok, Data} -> Data
  end.

last(empty) ->
  receive
    {PID, pass, Data} ->
      PID ! ok,
      last(Data);
    stop -> ok
  end;
last(Data) ->
  receive
    {PID, get} ->
      PID ! {ok, Data},
      last(empty);
    stop -> ok
  end.

spawnBuffer(N, Last) ->
  case N of
    0 -> Last;
    _ -> Next = spawnBuffer(N - 1, Last),
      spawn(buffer, buffer, [Next, empty])
  end.

buffer(Next, empty) ->
  receive
    {PID, pass, Data} ->
      PID ! ok,
      buffer(Next, Data);
    stop ->
      Next ! stop
  end;
buffer(Next, Data) ->
  Next ! {self(), pass, Data},
  receive
    ok ->
      buffer(Next, empty);
    stop ->
      Next ! stop
  end.

%***UTILS***%
stop(PID) ->
  PID ! {stop}.