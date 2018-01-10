%%%-------------------------------------------------------------------
%%% @author wosma
%%% @copyright (C) 2018, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 10. sty 2018 08:48
%%%-------------------------------------------------------------------
-module(bufferClassic).
-author("wosma").

%% API
-export([start/1, put/2, take/1, stop/1]).

start(Size) ->
  spawn(bufferClassic, init, [Size]).

init(Maxsize) ->
  loop([],0,Maxsize).


put(Pid, Element) ->
  Pid ! {request, self(), put, Element},
  receive
    {reply,ok}->ok
  end.

take(Pid) ->
  Pid ! {request, self(), take},
  receive
    {reply,Element}->Element
  end.

stop(Pid) ->
  Pid ! {request, self(), stop},
  receive
    {reply,ok}->ok
  end.

loop([],0,Maxsize) ->
  receive
    {request, Pid, put, Element} ->
      io:format("Number of elements: ~s~n",[integer_to_list(1)]),
      Pid ! {reply, ok},
      loop([Element],1,Maxsize);
    {request, Pid, stop} ->
      Pid ! {reply, ok}
  end;
loop([H|T],Maxsize,Maxsize) ->
  receive
    {request, Pid, take} ->
      io:format("Number of elements: ~s~n",[integer_to_list(Maxsize-1)]),
      Pid ! {reply, H},
      loop(T,Maxsize-1,Maxsize);
    {request, Pid, stop} ->
      Pid ! {reply, ok}
  end;
loop([H|T], Size, Maxsize) ->
  receive
    {request, Pid, put, Element} ->
      io:format("Number of elements: ~s~n",[integer_to_list(Size+1)]),
      Pid ! {reply, ok},
      loop([Element|[H|T]], Size+1, Maxsize);
    {request, Pid, take} ->
      io:format("Number of elements: ~s~n",[integer_to_list(Size-1)]),
      Pid ! {reply, H},
      loop(T, Size-1, Maxsize);
    {request, Pid, stop} ->
      Pid ! {reply, ok}
  end.