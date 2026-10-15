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
  
  method daPuntos()
  
  method nombreImagen()
  
  method image() = self.nombreImagen() + orientacion.imagen()
  
  method mover() {
    position = orientacion.siguientePosicion(position)
  }
  
  method interactuarCon(unAnzuelo) {
    unAnzuelo.pescar(self)
  }
}
class PezRapido inherits Pez {
  override method daPuntos() = 25
  override method nombreImagen() = "pezRapido"
}
class PezComun inherits Pez {
  override method daPuntos() = 5
  override method nombreImagen() = "pezComun"
}

class PezVenenoso inherits Pez{
  override method daPuntos() = 0
  override method nombreImagen()= "pezVenenoso"

  override method interactuarCon(unAnzuelo){
    unAnzuelo.perderVida()
  }
}
