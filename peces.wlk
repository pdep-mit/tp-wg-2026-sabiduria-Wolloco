import wollok.game.*

object derecha {
  method imagen() = "Der.png"
  
method siguientePosicion(posicionActual) {
  if (posicionActual.x() >= game.width() - 1) {
    return game.at(0, 1.randomUpTo(6))
  } else {
    return posicionActual.right(1)
  }
}
}
object izquierda {
  method imagen() = "Izq.png"
  
method siguientePosicion(posicionActual) {
  if (posicionActual.x() <= 0) {
    return game.at(game.width() - 1, 1.randomUpTo(6))
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

class PezCardumen inherits PezComun {
  override method daPuntos() = 20
  override method nombreImagen() = "pezCardumen"
  override method nombreEspecie() = "Pez Cardumen"
}

class PezRey inherits PezCardumen {
  var property grupo = null

  override method nombreImagen() = "pezRey"

  override method interactuarCon(unAnzuelo) {
    unAnzuelo.pescarCardumen(self, grupo.pecesDisponibles())
  }
}

class PezVenenoso inherits Pez{
  override method daPuntos() = 0
  override method nombreImagen()= "pezVenenoso"

  override method interactuarCon(unAnzuelo){
    unAnzuelo.perderVida()
    self.position(game.at(0.randomUpTo(game.width()-1), 1.randomUpTo(5)))
  }
}

class PezEspecial inherits Pez{
  override method daPuntos() = 50
  override method nombreImagen() = "pezEspecial"
  override method nombreEspecie() = "Pez Especial"
}
