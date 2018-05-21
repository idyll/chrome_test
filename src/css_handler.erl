%% Feel free to use, reuse and abuse the code in this file.

%% @doc Hello world handler.
-module(css_handler).

-export([init/2]).

init(Req0, Opts) ->
  Req = cowboy_req:stream_reply(200, #{
		<<"content-type">> => <<"text/css">>
	}, Req0),

	timer:sleep(500),
  cowboy_req:stream_body(<<"body{
      color: green;
      background-color: pink;
      font-size: 24px;
    }
	">>,  fin, Req),
	{ok, Req, Opts}.
