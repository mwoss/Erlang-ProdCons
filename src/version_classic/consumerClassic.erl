%%%-------------------------------------------------------------------
%%% @author wosma
%%% @copyright (C) 2018, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 10. sty 2018 08:48
%%%-------------------------------------------------------------------
-module(consumerClassic).
-author("wosma").

%% API
-export([start/1, stop/1, init/1, listener/1]).

start(Buffer) ->
  ConsPID = spawn(consumerClassic, init, [Buffer]),
  spawn(consumerClassic,listener,[ConsPID]).

init(Buffer) ->
  loop(Buffer).

loop(Buffer) ->
  Data = bufferClassic:take(Buffer),
  io:format("Consumer ~p consume value ~s~n",[self(),integer_to_list(Data)]),
  timer:sleep(1000),
  loop(Buffer).


%***UTILS***%
stop(ConsPID) ->
  ConsPID ! {request, stop}.

listener(ConsPID)->
  receive
    {request, stop}->
      exit(ConsPID,kill),
      ok
  end.