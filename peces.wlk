import wollok.game.*

object derecha {
  method imagen() = "Der.png"
  
  method siguientePosicion(posicionActual) {
    if (posicionActual.x() >= (game.width() - 1)) {
      return game.at(0, posicionActual.y())
    } else {
      return posicionActual.right(1)
    }
  }
}
object izquierda {
  method imagen() = "Izq.png"
  
  method siguientePosicion(posicionActual) {
    if (posicionActual.x() <= 0) {
      return game.at(game.width() - 1, posicionActual.y())
    } else {
      return posicionActual.left(1)
    }
  }
} 

///CLASE PADRE

class Pez {
  var property position
  var property orientacion //Guarda objeto izq o der
  var property estaPescado = false 
  
  method daPuntos()
  method nombreImagen()
  method nombreEspecie() = "Pez"
  
  method image() = self.nombreImagen() + orientacion.imagen()
  
  method mover() {
    if(!estaPescado){
    position = orientacion.siguientePosicion(position)
    }
  }
  
  method interactuarCon(unAnzuelo) {
    unAnzuelo.pescar(self)
  }
}
class PezRapido inherits Pez {
  override method daPuntos() = 25
  override method nombreImagen() = "pezRapido"
  override method nombreEspecie() = "Pez Rapido"
}
class PezComun inherits Pez {
  override method daPuntos() = 5
  override method nombreImagen() = "pezComun"
  override method nombreEspecie() = "Pez Comun"
}

class PezVenenoso inherits Pez{
  override method daPuntos() = 0
  override method nombreImagen()= "pezVenenoso"

  override method interactuarCon(unAnzuelo){
    unAnzuelo.perderVida()
    self.position(game.at(0.randomUpTo(game.width()-1), 1.randomUpTo(5)))
  }

  
}
