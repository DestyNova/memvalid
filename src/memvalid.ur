(*
This is easy in SML:

let val ws = String.tokens Char.isSpace "what the pox"
in
  String.concat (List.map (fn(s) => String.str(String.sub(s, 0)) ^ " ") ws)
end

=> val it = "w t p " : string

Why are these basic string functions missing in the Urweb standard lib?
There isn't even a straightforward way to go from string to list of chars!
I'm guessing this is because it needs to work in both the backend and in JS?
So they'd need to be re-implemented in straight Ur. Maybe that already exists.
Anyway, I'll do it and maybe share it as a separate lib later.
*)

fun nextToken (txt: list char) (p: char -> bool) : (string * list char) =
  let
    fun nextToken' acc txt =
      case txt of
        | [] => (acc, [])
        | (c::[]) => (acc ^ (String.str c), [])
        | (c::c'::cs) => if (p c)
                         then
                           (acc, (c'::cs))
                         else
                           nextToken' (acc ^ (String.str c)) (c'::cs)
  in
    nextToken' "" txt
  end

fun explode (txt: string) : list char =
  let
    fun explode' (i: int) (acc: list char) =
      if i < 0
      then
        acc
      else
        explode' (i - 1) ((String.sub txt i) :: acc)

  in
    explode' ((String.length txt) - 1) []
  end

fun tokens (txt: list char) (p: char -> bool) : list string =
  let
    fun tokens' acc txt p =
      case nextToken txt p of
        (w, []) => w :: acc
        | (w, xs) => tokens' (w :: acc) xs p
  in
    List.rev (tokens' [] txt p)
  end

fun words (txt: string) : list string =
  tokens (explode txt) Char.isSpace

fun inits' (acc: list string) (xs: list string) (i: int) : list string =
  case xs of
  | (w::ws) =>
      let val word =
                   if i = 0 || w = ""
                   then w
                   else (String.str (String.sub w 0))
      in
        inits' ((word ^ " ") :: acc) ws (i - 1)
      end
  | [] => List.rev acc

fun inits txt revealIndex =
  inits' [] (words txt) revealIndex

fun concat xs =
  List.foldr (fn x acc => x ^ acc) "" xs

fun main () =
  src <- source "";
  i <- source (-1);
  edit <- source False;

  Uru.run (
    JQuery.add (
      Bootstrap.add (

        Uru.withHeader (
          <xml>
            <title>Memvalid</title>
          </xml>) (

        Uru.withBody (fn _ =>
          return <xml>
            <body onkeydown={fn k =>
              oldIndex <- get i;
              editing <- get edit;

              let val newIndex =
                case (editing, k.KeyCode) of
                  | (False, 37) => oldIndex - 1
                  | (False, 39) => oldIndex + 1
                  | _ => oldIndex
              in
                set i newIndex
              end
            }>
              <dyn signal={
                editMode <- signal edit;

                return <xml>
                  {if editMode
                    then
                      <xml><ctextarea source={src}/></xml>
                  else
                    <xml/>}
                </xml>
              }/>

              <dyn signal={
                editMode <- signal edit;
                v <- signal src;
                revealIndex <- signal i;

                return
                  <xml>
                    {if editMode
                      then
                        <xml/>
                      else
                        <xml><div onclick={fn _ => set src "wtf"} class={well}>{[concat (inits v revealIndex)]}</div></xml>
                    }
                  </xml>
              }/><br/>
              <ccheckbox source={edit}/> Edit
            </body>
          </xml>
        )
      )
    )
  )
)
