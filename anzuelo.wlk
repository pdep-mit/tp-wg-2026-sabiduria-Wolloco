import wollok.game.*
object anzuelo {
  var property estadoPesca = sinPesca
  var property estado = estadoNormal
  var property vidas = 3 //el anzuelo es el que "muere" y empieza con tres vidas
  var property pecesPescados = []
  //guardo los puntos en la siguiente variable
  var property puntos = 0

  method partidaTerminada() = estado.partidaTerminada()
  method congelado() = estado.congelado()
  method invulnerable() = estado.invulnerable()

  method pezAgarrado() = estadoPesca.pezAgarrado()
  method pecesAcompaniantes() = estadoPesca.pecesAcompaniantes()

  method pescar(unPez) {
    estadoPesca.pescar(self, unPez)
  }

  method pescarCardumen(unRey, pecesDisponibles) {
    estadoPesca.pescarCardumen(self, unRey, pecesDisponibles)
  }

  method resetear() {
  puntos = 0
  estadoPesca = sinPesca
  vidas = 3
  estado = estadoNormal
  position = game.at(4, 7)
  pecesPescados.clear()

  if (game.hasVisual(pantallaGameOver)) {
    game.removeVisual(pantallaGameOver)
  }

  if (game.hasVisual(efectoDanio)) {
    game.removeVisual(efectoDanio)
  }

  if (game.hasVisual(efectoHielo)) {
    game.removeVisual(efectoHielo)
  }

  game.boardGround("fondo.jpg")
}
  

  var property position = game.at(4,7) 
  method image() = "anzuelo.png"



 method subirAnzuelo() {
    estado.subirAnzuelo(self)
  }

  method bajarAnzuelo() {
    estado.bajarAnzuelo(self)
  }

  method moverArriba() {
    if (position.y() < 7) {
      position = position.up(1)
    } else {
      estadoPesca.llegarASuperficie(self)
    }
  }

  method moverAbajo() {
    if (position.y() > 0) {
      position = position.down(1)
    }
  }


method soltar() {
    estadoPesca.soltar(self)
  }

  method moverPezAgarrado() {
    estadoPesca.moverPezAgarrado(self)
  }

//sacar o dejar¿ (ver que pasa al pescar un pez y como aparece ya pescado)
method registrarPezPescado(unPez) {
  puntos = puntos + unPez.daPuntos()

  if (game.hasVisual(unPez)) {
    unPez.estaPescado(true)
    pecesPescados.add(unPez)
    game.removeVisual(unPez)
  }
}



method perderVida() {
  self.perderVidas(1)
}

 method perderVidas(cantidad) {
    estado.perderVidas(self, cantidad)
  }

  method recibirDanio(cantidad) {
    if (vidas <= cantidad) {
      vidas = 0
    } else {
      vidas = vidas - cantidad
    }

    // Destello rojo e inmunidad durante 1 segundo
    if (!game.hasVisual(efectoDanio)) {
      game.addVisual(efectoDanio)
    }

    if (vidas == 0) {
      estado = estadoGameOver
      game.addVisual(pantallaGameOver)
    } else {
      estado = estadoInvulnerable
      game.schedule(1000, {
        if (game.hasVisual(efectoDanio)) {
          game.removeVisual(efectoDanio)
        }
        if (estado == estadoInvulnerable) {
          estado = estadoNormal
        }
      })
    }
  }


  method cantidadDeEspecie(nombreEspecie) {
    return pecesPescados.count({ pez => pez.nombreEspecie() == nombreEspecie })
  }

  method cantidadPecesComunes() = self.cantidadDeEspecie("Pez Comun")
  method cantidadPecesRapidos() = self.cantidadDeEspecie("Pez Rapido")
  method cantidadPecesCardumen() = self.cantidadDeEspecie("Pez Cardumen")
  method cantidadPecesEspeciales() = self.cantidadDeEspecie("Pez Especial")

method congelar() {
    estado.congelar(self)
  }

  method aplicarCongelamiento() {
    estado = estadoCongelado
    if (!game.hasVisual(efectoHielo)) {
      game.addVisual(efectoHielo)
    }
    game.schedule(2000, {
      if (game.hasVisual(efectoHielo)) {
        game.removeVisual(efectoHielo)
      }
      if (estado == estadoCongelado) {
        estado = estadoNormal
      }
    })
  }

method pescoTodasLasEspecies() {
    return self.cantidadPecesComunes() > 0 && self.cantidadPecesRapidos() > 0 && self.cantidadPecesCardumen() > 0
  }

}


object sinPesca {
  method pezAgarrado() = null
  method pecesAcompaniantes() = []

  method pescar(unAnzuelo, unPez) {
    if (!unPez.estaPescado()) {
      unPez.estaPescado(true)
      unAnzuelo.estadoPesca(new PescaIndividual(pezAgarrado = unPez))
    }
  }

  method pescarCardumen(unAnzuelo, unRey, pecesDisponibles) {
    if (!unRey.estaPescado()) {
      unRey.estaPescado(true)
      const acompaniantes = pecesDisponibles.filter({ pez => pez != unRey })
      acompaniantes.forEach({ pez => pez.estaPescado(true) })
      unAnzuelo.estadoPesca(new PescaCardumen(pezAgarrado = unRey, pecesAcompaniantes = acompaniantes))
    }
  }

  method llegarASuperficie(unAnzuelo) { }
  method soltar(unAnzuelo) { }
  method moverPezAgarrado(unAnzuelo) { }
}

class PescaIndividual {
  const property pezAgarrado

  method pecesAcompaniantes() = []

  method pescar(unAnzuelo, unPez) { }
  method pescarCardumen(unAnzuelo, unRey, pecesDisponibles) { }

  method llegarASuperficie(unAnzuelo) {
    unAnzuelo.registrarPezPescado(pezAgarrado)
    game.say(unAnzuelo, "¡Puntos: " + unAnzuelo.puntos().toString() + "!")
    unAnzuelo.estadoPesca(sinPesca)
  }

  method soltar(unAnzuelo) {
    const fila = 1.randomUpTo(6)
    pezAgarrado.position(game.at(0, fila))
    pezAgarrado.estaPescado(false)
    unAnzuelo.estadoPesca(sinPesca)
  }

  method moverPezAgarrado(unAnzuelo) {
    pezAgarrado.position(unAnzuelo.position())
  }
}

class PescaCardumen inherits PescaIndividual {
  const property pecesAcompaniantes = []

  override method llegarASuperficie(unAnzuelo) {
    unAnzuelo.registrarPezPescado(pezAgarrado)
    pecesAcompaniantes.forEach({ pez =>
      unAnzuelo.registrarPezPescado(pez)
    })
    game.say(unAnzuelo, "¡Puntos: " + unAnzuelo.puntos().toString() + "!")
    unAnzuelo.estadoPesca(sinPesca)
  }

  override method soltar(unAnzuelo) {
    const fila = 1.randomUpTo(6)

    if (pecesAcompaniantes.size() > 0) {
      pezAgarrado.position(game.at(2, fila))
      pecesAcompaniantes.get(0).position(game.at(0, fila))

      if (pecesAcompaniantes.size() > 1) {
        pecesAcompaniantes.get(1).position(game.at(4, fila))
      }
    } else {
      pezAgarrado.position(game.at(0, fila))
    }

    pezAgarrado.estaPescado(false)
    pecesAcompaniantes.forEach({ pez =>
      pez.estaPescado(false)
    })
    unAnzuelo.estadoPesca(sinPesca)
  }

  override method moverPezAgarrado(unAnzuelo) {
    if (pecesAcompaniantes.size() > 0 && unAnzuelo.position().y() < 2) {
      pezAgarrado.position(game.at(unAnzuelo.position().x(), 2))
    } else {
      super(unAnzuelo)
    }

    if (pecesAcompaniantes.size() > 0) {
      pecesAcompaniantes.get(0).position(
        pezAgarrado.position().down(1)
      )
    }

    if (pecesAcompaniantes.size() > 1) {
      pecesAcompaniantes.get(1).position(
        pezAgarrado.position().down(2)
      )
    }
  }
}



object estadoNormal {
  method partidaTerminada() = false
  method congelado() = false
  method invulnerable() = false

  method subirAnzuelo(unAnzuelo) {
    unAnzuelo.moverArriba()
  }

  method bajarAnzuelo(unAnzuelo) {
    unAnzuelo.moverAbajo()
  }

  method perderVidas(unAnzuelo, cantidad) {
    unAnzuelo.recibirDanio(cantidad)
  }

  method congelar(unAnzuelo) {
    unAnzuelo.aplicarCongelamiento()
  }
}

object estadoCongelado {
  method partidaTerminada() = false
  method congelado() = true
  method invulnerable() = false

  method subirAnzuelo(unAnzuelo) { }
  method bajarAnzuelo(unAnzuelo) { }

  method perderVidas(unAnzuelo, cantidad) {
    if (game.hasVisual(efectoHielo)) {
      game.removeVisual(efectoHielo)
    }
    unAnzuelo.recibirDanio(cantidad)
  }

  method congelar(unAnzuelo) { }
}

object estadoInvulnerable {
  method partidaTerminada() = false
  method congelado() = false
  method invulnerable() = true

  method subirAnzuelo(unAnzuelo) {
    unAnzuelo.moverArriba()
  }

  method bajarAnzuelo(unAnzuelo) {
    unAnzuelo.moverAbajo()
  }

  method perderVidas(unAnzuelo, cantidad) { }
  method congelar(unAnzuelo) { }
}

object estadoGameOver {
  method partidaTerminada() = true
  method congelado() = false
  method invulnerable() = false

  method subirAnzuelo(unAnzuelo) { }
  method bajarAnzuelo(unAnzuelo) { }
  method perderVidas(unAnzuelo, cantidad) { }
  method congelar(unAnzuelo) { }
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

  method text() =
  "GAME OVER\n" +
  "Peces Atrapados:\n" +
  "Pez Comun x" + anzuelo.cantidadPecesComunes().toString() + "\n" +
  "Pez Rapido x" + anzuelo.cantidadPecesRapidos().toString() + "\n" +
  "Pez Cardumen x" + anzuelo.cantidadPecesCardumen().toString() + "\n" +
  "Pez Especial x" + anzuelo.cantidadPecesEspeciales().toString() + "\n" +
  "Presiona R para reiniciar"

  method textColor() = "FF0000"
}

object efectoDanio {
  method position() = game.at(0, 0)
  method image() = "destelloRojo.png"
}

object efectoHielo{
  method position()= game.at(0,0)
  method image()= "destellohielo.png"
}