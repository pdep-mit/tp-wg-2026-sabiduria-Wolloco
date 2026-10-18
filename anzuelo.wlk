import wollok.game.*
object anzuelo {
  var property pezAgarrado = null
  var property pecesAcompaniantes = []
  var property invulnerable = false
  var property vidas = 3 //el anzuelo es el que "muere" y empieza con tres vidas
  var property pecesPescados = []
  //guardo los puntos en la siguiente variable
  var property puntos = 0
  var property partidaTerminada = false

 method pescar(unPez) {
  if (pezAgarrado == null && !unPez.estaPescado()) {
    pezAgarrado = unPez
    unPez.estaPescado(true)
  }
}

method pescarCardumen(unRey, pecesDisponibles) {
  if (pezAgarrado == null && !unRey.estaPescado()) {
    self.pescar(unRey)

    pecesAcompaniantes = pecesDisponibles.filter({
      pez => pez != unRey
    })

    pecesAcompaniantes.forEach({
      pez => pez.estaPescado(true)
    })
  }
}

  method resetear() {
  puntos = 0
  pezAgarrado = null
  pecesAcompaniantes.clear()
  vidas = 3
  invulnerable = false
  position = game.at(4, 7)
  pecesPescados.clear()

  if (game.hasVisual(pantallaGameOver)) {
    game.removeVisual(pantallaGameOver)
  }

  if (game.hasVisual(efectoDanio)) {
  game.removeVisual(efectoDanio)
}

  game.boardGround("fondo.jpg")
  partidaTerminada = false
}
  

  var property position = game.at(4,7) 
  method image() = "anzuelo.png"

method subirAnzuelo() {
  if (position.y() < 7) {
    position = position.up(1)
  } else {
    if (pezAgarrado != null) {

      self.registrarPezPescado(pezAgarrado)

      pecesAcompaniantes.forEach({ pez =>
        self.registrarPezPescado(pez)
      })

      game.say(self, "¡Puntos: " + puntos.toString() + "!")

      pezAgarrado = null
      pecesAcompaniantes.clear()
    }
  }
}

  method bajarAnzuelo(){
    if (position.y()>0){
      position= position.down(1)
    }
  }


method soltar() {
  if (pezAgarrado != null) {
    const fila = 1.randomUpTo(6)

    if (pecesAcompaniantes.size() > 0) {
      // Devolvemos el cardumen al agua
      pezAgarrado.position(game.at(2, fila))
      pecesAcompaniantes.get(0).position(game.at(0, fila))

      if (pecesAcompaniantes.size() > 1) {
        pecesAcompaniantes.get(1).position(game.at(4, fila))
      }
    } else {
      // Pesca individual
      pezAgarrado.position(game.at(0, fila))
    }

    pezAgarrado.estaPescado(false)

    pecesAcompaniantes.forEach({ pez =>
      pez.estaPescado(false)
    })

    pezAgarrado = null
    pecesAcompaniantes.clear()
  }
}


method moverPezAgarrado() {
  if (pezAgarrado != null) {

    if (pecesAcompaniantes.size() > 0 && position.y() < 2) {
      pezAgarrado.position(game.at(position.x(), 2))
    } else {
      pezAgarrado.position(position)
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

//sacar o dejar¿ (ver que pasa al pescar un pez y como aparece ya pescado)
method registrarPezPescado(unPez) {
  puntos = puntos + unPez.daPuntos()

  if (game.hasVisual(unPez)) {
    unPez.estaPescado(true)
    unPez.position(game.at(pecesPescados.size(), 8))
    pecesPescados.add(unPez)
  }
}



method perderVida() {
  self.perderVidas(1)
}

method perderVidas(cantidad) {
  if (!partidaTerminada && !invulnerable) {

    invulnerable = true

    if (vidas <= cantidad) {
      vidas = 0
    } else {
      vidas = vidas - cantidad
    }

    // Destello rojo e inmunidad durante 1 segundo
    if (!game.hasVisual(efectoDanio)) {
      game.addVisual(efectoDanio)
    }

    game.schedule(1000, {
      if (game.hasVisual(efectoDanio)) {
        game.removeVisual(efectoDanio)
      }
      invulnerable = false
    })

    if (vidas == 0) {
      partidaTerminada = true
      game.addVisual(pantallaGameOver)
    }
  }
}


  method cantidadDeEspecie(nombreEspecie) {
    return pecesPescados.count({ pez => pez.nombreEspecie() == nombreEspecie })
  }

  method cantidadPecesComunes() = self.cantidadDeEspecie("Pez Comun")
  method cantidadPecesRapidos() = self.cantidadDeEspecie("Pez Rapido")
  method cantidadPecesCardumen() = self.cantidadDeEspecie("Pez Cardumen")
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
  "Presiona R para reiniciar"

  method textColor() = "FF0000"
}

object efectoDanio {
  method position() = game.at(0, 0)
  method image() = "destelloRojo.png"
}