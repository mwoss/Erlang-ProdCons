%%%-------------------------------------------------------------------
%%% @author Matthew
%%% @copyright (C) 2018, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 09. sty 2018 22:36
%%%-------------------------------------------------------------------
-module(consumer).
-author("Matthew").

%% API
-export([start/1, stop/1, init/1, listener/1]).

start(Buffer) ->
  ConsPID = spawn(consumer, init, [Buffer]),
  spawn(consumer,listener,[ConsPID]).

init(Buffer) ->
  loop(Buffer).

loop(Buffer) ->
  Data = buffer:consume(Buffer),
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