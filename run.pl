
%% Run yesbot here

:- initialization(run).

:- use_module(core).
:- use_module(config).
:- use_module(utilities).
:- use_module(dispatch).
:- use_module(operator).
:- use_module(library(lambda)).
:- use_module(library(func)).
:- use_module(library(mavis)).


%% run is det.
run :-
  catch(
    (  thread_property(ct, _),
       thread_join(ct, _)
    ),
    _Cterror,
    true
  ), !,
  desired_extensions(Es),
  catch(check_valid_extensions(Es), _Error, safety),
  thread_create(connect, Connect, [alias(ct)]),
  thread_signal(Connect, attach_console).

safety :-
  writeln('WARNING: The set of extensions you have provided \c
    has been determined to be invalid. Your extension list \c
    has been emptied and will be running nothing if you do \c
    not take action. Please update this setting to a valid \c
    one.'),
  retractall(info:extensions(_,_)),
  retractall(info:sync_extensions(_,_)),
  set_setting(config:extensions, []),
  save_settings.


