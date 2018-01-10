%%%-------------------------------------------------------------------
%%% @author Matthew
%%% @copyright (C) 2018, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 09. sty 2018 22:36
%%%-------------------------------------------------------------------
-module(producer).
-author("Matthew").

%% API
-export([init/1, stop/1, start/1, listener/1]).

start(Buffer) ->
  ProdPID = spawn(producer, init, [Buffer]),
  spawn(producer, listener,[ProdPID]).

init(Buffer) ->
  loop(Buffer).

loop(Buffer) ->
  Data = rand:uniform(100),
  io:format("Producer ~p produce value ~s~n",[self(),integer_to_list(Data)]),
  buffer:produce(Buffer, Data),
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
