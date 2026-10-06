import wollok.game.*
object anzuelo {
  var pezAgarrado = null

  //guardo los puntos en la siguiente variable
  var property puntos = 0

  method pescar(unPez) {
    
    if(pezAgarrado == null && unPez != pezAgarrado) {
        pezAgarrado = unPez
    
  }
  }

  var property position = game.center() 
  method image() = "anzuelo.png"

  method subirAnzuelo(){
    if(position.y() < 7){
      position = position.up(1)
    }else{
      if(pezAgarrado != null){
        puntos = puntos + pezAgarrado.daPuntos()
        game.say(self, "¡Puntos:" + puntos.toString() + "!")
        game.removeVisual(pezAgarrado)
        pezAgarrado=null
      }
    }
  }

  method bajarAnzuelo(){
    if (position.y()>0){
      position= position.down(1)
    }
  }

  method moverDerecha(){
    if (position.x()< game.width()-1){
      position = position.right(1)
    }
  }

  method moverIzquierda(){
    if(position.x()>0){
      position=position.left(1)
    }
  }

  method soltar() {
    if(pezAgarrado != null) {
        pezAgarrado.position(game.at(0, 1.randomUpTo(5)))
        pezAgarrado = null
    }
}

  method moverPezAgarrado() {
    if(pezAgarrado != null) {
        pezAgarrado.position(position)
    }
  }
}

object marcadorPuntos {
  method position() = game.at(0,9)
  method text() = "Puntos: " + anzuelo.puntos().toString()
  method textColor() = "FFFFFF"
}