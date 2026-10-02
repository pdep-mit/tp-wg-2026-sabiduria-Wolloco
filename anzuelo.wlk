import wollok.game.*
object anzuelo {

  //guardo los puntos en la siguiente variable
  var property puntos = 0

  method pescar(unPez) {
    puntos = puntos + unPez.daPuntos()
    game.say(self, "¡Puntos: " + puntos.toString() + "!")
  }

  method position() = game.center()
  method image() = "anzuelo.png"
}

object marcadorPuntos {
  method position() = game.at(0,9)
  method text() = "Puntos: " + anzuelo.puntos().toString()
  method textColor() = "FFFFFF"
}