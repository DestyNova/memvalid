open String
open Char

fun main () =
  src <- source "";

  return <xml>
    <body>
      <ctextbox source={src}/>
    </body>
  </xml>
