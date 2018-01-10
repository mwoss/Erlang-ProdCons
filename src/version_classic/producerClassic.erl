%%%-------------------------------------------------------------------
%%% @author wosma
%%% @copyright (C) 2018, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 10. sty 2018 08:48
%%%-------------------------------------------------------------------
-module(producerClassic).
-author("wosma").

%% API
-export([start/1, init/1, stop/1, listener/1]).

start(Buffer) ->
  ProdPID = spawn(producerClassic, init, [Buffer]),
  spawn(producerClassic, listener,[ProdPID]).

init(Buffer) ->
  loop(Buffer).

loop(Buffer) ->
  Data = rand:uniform(100),
  io:format("Producer ~p produce value ~s~n",[self(),integer_to_list(Data)]),
  bufferClassic:put(Buffer, Data),
  timer:sleep(500),
  loop(Buffer).


%***UTILS***%
stop(ProdPID) ->
  ProdPID ! {request, stop}.

listener(ProdPID)->
  receive
    {request, stop}->
      exit(ProdPID,kill),
      ok
  end.
