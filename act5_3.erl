-module(act5_3).
-import(timer, [now_diff/2]).
-export([runSequencial/0, setup/1]).
-export([runParallel/0, parallelHelper/1]).
-export([run/0]).

realizaCalculo(SOut, A, Calc, B) -> case Calc of
            "*" -> io:format(SOut, "~s~n", [integer_to_list(A*B)]);
            "+" -> io:format(SOut, "~s~n", [integer_to_list(A+B)]);
            "-" -> io:format(SOut, "~s~n", [integer_to_list(A-B)]);
            "/" -> io:format(SOut, "~s~n", [integer_to_list(floor(A/B))]);
            "%" -> io:format(SOut, "~s~n", [integer_to_list(A rem B)])
        end.

leeLinea(List1, SOut) ->    
    A = list_to_integer(lists:nth(1, List1)),
    Calc = lists:nth(2, List1),
    Bprev = re:replace(lists:nth(3, List1), "[\r\n]", "", [global, {return, list}]),
    B =  list_to_integer(Bprev),

    realizaCalculo(SOut, A, Calc, B).

leeArchivo(SIn, SOut) -> 
    Txt1 = io:get_line(SIn, ''),
    case Txt1 of
        eof  -> [];
        Line -> List1 = string:split(Line, " ", all), leeLinea(List1, SOut), leeArchivo(SIn, SOut)
    end.

setup(File) ->
    FileIn = File ++ ".in",
    FileOut = File ++ ".out",
    {ok, SIn} = file:open(FileIn, read),
    {ok, SOut} = file:open(FileOut, [write]),
    leeArchivo(SIn, SOut).

runSequencial() -> 
    T1 = erlang:timestamp(),
    setup("case1"),
    setup("case2"),
    setup("case3"),
    setup("case4"),
    T2 = erlang:timestamp(),
    Dif = now_diff(T2, T1),
    io:format("Tiempo de ejecucion: ~p~n~n", [Dif]).

parallelHelper(File) ->
    T1 = erlang:timestamp(),
    setup(File),
    T2 = erlang:timestamp(),
    Dif = now_diff(T2, T1),
    io:format(" ~p~n", [Dif]).

runParallel() ->
    spawn(act5_3, parallelHelper, ["case1"]),
    spawn(act5_3, parallelHelper, ["case2"]),
    spawn(act5_3, parallelHelper, ["case3"]),
    spawn(act5_3, parallelHelper, ["case4"]).
run() ->
    io:format("-------Sequencial--------~n"),
    runSequencial(),
    io:format("-------Parallel--------~n Tiempo de ejecucion: "),
    runParallel().