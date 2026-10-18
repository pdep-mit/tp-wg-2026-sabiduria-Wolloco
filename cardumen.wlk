
import wollok.game.*
import peces.*

object cardumen {
  const integrantes = [
    new PezCardumen(position = game.at(0, 4), orientacion = derecha),
    new PezRey(position = game.at(2, 4), orientacion = derecha),
    new PezCardumen(position = game.at(4, 4), orientacion = derecha)
  ]

  method peces() = integrantes

  method pecesDisponibles() {
  return integrantes.filter({ pez =>
    !pez.estaPescado() && game.hasVisual(pez)
  })
}

  var property aparecio = false

  method reiniciar() {
  integrantes.forEach({ pez =>
    if (game.hasVisual(pez)) {
      game.removeVisual(pez)
    }
    pez.estaPescado(false)
  })

  integrantes.get(0).position(game.at(0, 4))
  integrantes.get(1).position(game.at(2, 4))
  integrantes.get(2).position(game.at(4, 4))

  aparecio = false
}


method mover() {
  integrantes.forEach({ pez =>
    if (!pez.estaPescado() && game.hasVisual(pez)) {
      if (pez.position().x() >= game.width() - 1) {
        game.removeVisual(pez)
      } else {
        pez.position(pez.position().right(1))
      }
    }
  })
}


method aparecer() {
  integrantes.get(1).grupo(self)

  self.mostrarSiDisponible(integrantes.get(0), 0)
  self.mostrarSiDisponible(integrantes.get(1), 2)
  self.mostrarSiDisponible(integrantes.get(2), 4)

  aparecio = true
}

method mostrarSiDisponible(unPez, columna) {
  if (!unPez.estaPescado()) {
    unPez.position(game.at(columna, 4))

    if (!game.hasVisual(unPez)) {
      game.addVisual(unPez)
    }
  }
}

}
