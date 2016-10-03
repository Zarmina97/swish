#!/usr/bin/env swipl

/* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
Run

    ./daemon.pl --help for help
- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */

/*  Part of SWISH

    Author:        Jan Wielemaker
    E-mail:        J.Wielemaker@cs.vu.nl
    WWW:           http://www.swi-prolog.org
    Copyright (C): 2014-2016, VU University Amsterdam
			      CWI Amsterdam
    All rights reserved.

    Redistribution and use in source and binary forms, with or without
    modification, are permitted provided that the following conditions
    are met:

    1. Redistributions of source code must retain the above copyright
       notice, this list of conditions and the following disclaimer.

    2. Redistributions in binary form must reproduce the above copyright
       notice, this list of conditions and the following disclaimer in
       the documentation and/or other materials provided with the
       distribution.

    THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
    "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
    LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
    FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE
    COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT,
    INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING,
    BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
    LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
    CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
    LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN
    ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
    POSSIBILITY OF SUCH DAMAGE.
*/

:- use_module(library(http/http_unix_daemon)).

swish_daemon.

user:file_search_path(swish, SwishDir) :-
	getenv('SWISH_HOME', SwishDir), !.
user:file_search_path(swish, SwishDir) :-
	source_file(swish_daemon, ThisFile),
	file_directory_name(ThisFile, SwishDir).

:- initialization http_daemon.

:- use_module(swish(lib/ssl_certificate)).
:- [swish(swish)].
:- use_module(swish:swish(lib/swish_debug)).

%%	load_swish_modules
%
%	Load additional modules into SWISH

load_swish_modules :-
	getenv('SWISH_MODULES', Atom), !,
	atomic_list_concat(Modules, :, Atom),
	maplist(load_swish_module, Modules).
load_swish_modules.

load_swish_module(Module) :-
	use_module(swish(lib/Module)).
