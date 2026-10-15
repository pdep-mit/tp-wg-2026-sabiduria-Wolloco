import wollok.game.*
object anzuelo {
  var property pezAgarrado = null
  var property vidas = 3 //el anzuelo es el que "muere" y empieza con tres vidas
  var property pecesPescados = []
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
    vidas = 3
    pecesPescados=[]
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
        if(game.hasVisual(pezAgarrado)){
          pezAgarrado.estaPescado(true)
          pezAgarrado.position(game.at(pecesPescados.size(),8))
          pecesPescados.add(pezAgarrado)
        }
        
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
        self.perderVida()
    }
}

  method moverPezAgarrado() {
    if(pezAgarrado != null) {
        pezAgarrado.position(position)
    }
  }

  method perderVida(){
    vidas = vidas - 1
    if (vidas == 0){
      game.addVisual(pantallaGameOver)
      game.stop()
    }
  }
}

object marcadorPuntos {
  method position() = game.at(1,9)
  method text() = "Puntos: " + anzuelo.puntos().toString()
  method textColor() = "FFFFFF"
}

object marcadorVidas{
  method position() = game.at(8,9)
  method text()= "Vidas: " + anzuelo.vidas().toString()
  method textColor()= "FF0000"
}

object pantallaGameOver{
  method position() = game.at(5,5)
  method text() = "GAME OVER - Presiona R para reiniciar"
  method textColor() = "FF0000"
}