import wollok.game.*
object anzuelo {
  var property pezAgarrado = null

  //guardo los puntos en la siguiente variable
  var property puntos = 0

  method pescar(unPez) {
    
    if(pezAgarrado == null && unPez != pezAgarrado) {
        pezAgarrado = unPez
  
  }
  }
  method resetear() {
    puntos = 0
    pezAgarrado = null
  }
  

  var property position = game.at(4,7) 
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


  method soltar() {
    if(pezAgarrado != null) {
        pezAgarrado.position(game.at(0, 1.randomUpTo(6)))
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
  method position() = game.at(1,9)
  method text() = "Puntos: " + anzuelo.puntos().toString()
  method textColor() = "FFFFFF"
}