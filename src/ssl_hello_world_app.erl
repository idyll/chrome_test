%% Feel free to use, reuse and abuse the code in this file.

%% @private
-module(ssl_hello_world_app).
-behaviour(application).

%% API.
-export([start/2]).
-export([stop/1]).

%% API.

start(_Type, _Args) ->
	Dispatch = cowboy_router:compile([
		{'_', [
			{"/", toppage_handler, []},
			{"/app.css", css_handler, []}
		]}
	]),
	PrivDir = code:priv_dir(ssl_hello_world),
	{ok, _} = cowboy:start_tls(https, [
		{port, 8443},
		{cacertfile, PrivDir ++ "/ssl/cowboy-ca.crt"},
		{certfile, PrivDir ++ "/ssl/server.crt"},
		{keyfile, PrivDir ++ "/ssl/server.key"},
		{versions, ['tlsv1.2', 'tlsv1.1', 'tlsv1']},
		{ciphers, ["ECDHE-ECDSA-AES256-GCM-SHA384","ECDHE-RSA-AES256-GCM-SHA384",
				"ECDHE-ECDSA-AES256-SHA384","ECDHE-RSA-AES256-SHA384", "ECDHE-ECDSA-DES-CBC3-SHA",
				"ECDH-ECDSA-AES256-GCM-SHA384","ECDH-RSA-AES256-GCM-SHA384","ECDH-ECDSA-AES256-SHA384",
				"ECDH-RSA-AES256-SHA384","DHE-DSS-AES256-GCM-SHA384","DHE-DSS-AES256-SHA256",
				"AES256-GCM-SHA384","AES256-SHA256","ECDHE-ECDSA-AES128-GCM-SHA256",
				"ECDHE-RSA-AES128-GCM-SHA256","ECDHE-ECDSA-AES128-SHA256","ECDHE-RSA-AES128-SHA256",
				"ECDH-ECDSA-AES128-GCM-SHA256","ECDH-RSA-AES128-GCM-SHA256","ECDH-ECDSA-AES128-SHA256",
				"ECDH-RSA-AES128-SHA256","DHE-DSS-AES128-GCM-SHA256","DHE-DSS-AES128-SHA256",
				"AES128-GCM-SHA256","AES128-SHA256","ECDHE-ECDSA-AES256-SHA",
				"ECDHE-RSA-AES256-SHA","DHE-DSS-AES256-SHA","ECDH-ECDSA-AES256-SHA",
				"ECDH-RSA-AES256-SHA","AES256-SHA","ECDHE-ECDSA-AES128-SHA",
				"ECDHE-RSA-AES128-SHA","DHE-DSS-AES128-SHA","ECDH-ECDSA-AES128-SHA",
				"ECDH-RSA-AES128-SHA","AES128-SHA"]},
		{secure_renegotiate, true},
		{reuse_sessions, true},
		{honor_cipher_order, true},
		{max_connections, infinity}
	], #{env => #{dispatch => Dispatch}}),
	ssl_hello_world_sup:start_link().

stop(_State) ->
	ok.
