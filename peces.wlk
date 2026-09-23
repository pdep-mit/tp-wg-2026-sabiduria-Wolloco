class PezRapido {
  var property position
  var property orientacion

  method image() {
    if(orientacion == "derecha") {
        return "pezRapidoDer.png"
    } else {
        return "pezRapidoIzq.png"
    }
  }

  method mover() {
    if(orientacion == "derecha") {
        self.moverPezADerecha()
    } else {
        self.moverPezAIzquierda()
    }
  }

  method moverPezADerecha() {
    if(position.x() > game.width() - 1) {
		position = game.at(0, position.y())
	} else {
        position = position.right(1)
    }
  }

  method moverPezAIzquierda() {
    if(position.x() <= 0) {
		position = game.at(game.width() - 1, position.y())
	} else {
        position = position.left(1)
    }	
  }
}