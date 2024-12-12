open Css
open Bootstrap4

fun nextToken (txt: list char) (p: char -> bool) : (string * list char) =
  let
    fun nextToken' acc txt =
      case txt of
        | [] => (acc, [])
        | (c::[]) => (acc ^ (String.str c), [])
        | (c::c'::cs) => if (p c)
                         then
                           (acc ^ (String.str c), (c'::cs))
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
    List.filter (fn x => x <> "" && x <> " ") (List.rev (tokens' [] txt p))
  end

fun nonAlpha c =
  not (Char.isAlnum c)

fun words (txt: string) : list string =
  tokens (explode txt) nonAlpha

fun inits' acc (xs: list string) (i: int) =
  case xs of
  | (w::ws) =>
      let
        val wordLength = String.length w
        val word =
                   if i = 0 || w = ""
                   then <xml><span class="text-primary">{[w]}</span></xml>
                   else
                    let val lastChar = String.sub w (wordLength - 1)
                    in
                      <xml><span class="text-muted">
                      {[
                        (String.str (String.sub w 0)) ^
                          if String.length w > 1 && nonAlpha lastChar
                          then String.str lastChar
                          else ""
                      ]}
                      </span></xml>
                    end
      in
        inits' (word :: acc) ws (i - 1)
      end
  | [] => List.rev acc

fun inits txt revealIndex =
  inits' [] (words txt) revealIndex

fun concat xs =
  List.foldr (fn x acc => x ^ acc) "" xs

fun seek difference txtSrc i =
  oldIndex <- get i;
  txt <- get txtSrc;

  if difference = 0
  then
    set i oldIndex
  else
    let val length = List.length (inits txt oldIndex)
    in
      set i (max 0 (min (length - 1) (oldIndex + difference)))
    end

fun main () =
  txtSrc <- source "";
  i <- source (-1);
  edit <- source True;
  editModeId <- fresh;

  return <xml>
    <head>
      <link rel="stylesheet" type="text/css" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.3.1/css/bootstrap.min.css" />
      <link rel="stylesheet" type="text/css" href="/style.css" />
      <meta name="viewport" content="width=device-width, initial-scale=1" />
    </head>

    <body onkeydown={fn k =>
      editing <- get edit;

      let val difference =
        case (editing, k.KeyCode) of
          | (False, 37) => -1
          | (False, 39) => 1
          | _ => 0
      in
        seek difference txtSrc i
      end
    }>

      <div class="container">
        <div class="row">
          <div class="col">
            <dyn signal={
              editMode <- signal edit;

              return <xml>
                {if editMode
                  then
                    <xml><ctextarea source={txtSrc} class={editBox} style="width: 100%" /></xml>
                else
                  <xml/>}
              </xml>
            }/>

            <dyn signal={
              editMode <- signal edit;
              txt <- signal txtSrc;
              revealIndex <- signal i;

              return
                <xml>
                  {if editMode
                    then
                      <xml/>
                    else
                      <xml>
                        <div class={card}>
                          <div class={card_body}>
                            {List.mapX (fn x => x) (inits txt revealIndex)}
                          </div>
                        </div>
                      </xml>
                  }
                </xml>
            }/><br/>

            <div class="custom-control custom-switch">
              <ccheckbox class="custom-control-input" source={edit} id={editModeId}/>
              <label class="custom-control-label" for={editModeId}>Edit</label>
            </div>
          </div>
        </div>

        <div class="row">
          <div class="col-md-4">
            <button class="btn btn-lg btn-block btn-warning" Onclick={fn _ => seek (-9999) txtSrc i}>
              <h3>⇤</h3>
            </button>
          </div>

          <div class="col-md-4">
            <button class="btn btn-lg btn-block btn-primary" Onclick={fn _ => seek (-1) txtSrc i}>
              <h3>←</h3>
            </button>
          </div>

          <div class="col-md-4">
            <button class="btn btn-lg btn-block btn-success" Onclick={fn _ => seek 1 txtSrc i}>
              <h3>→</h3>
            </button>
          </div>
        </div>

        <div class="row" style="padding-top: 20px">
          <div class="col-sm-12 text-center">
            <a href="https://github.com/DestyNova/memvalid">
              <span class="badge bg-dark">
                Source code
              </span>
            </a>
          </div>
        </div>
      </div>
    </body>
  </xml>
