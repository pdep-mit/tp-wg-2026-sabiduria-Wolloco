import wollok.game.*
class PezRapido {
  var property position
  var property orientacion

  method daPuntos() = 25

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
		position = game.at(0, 1.randomUpTo(6))
	} else {
        position = position.right(1)
    }
  }

  method moverPezAIzquierda() {
    if(position.x() <= 0) {
		position = game.at(game.width() - 1, 1.randomUpTo(6))
	} else {
        position = position.left(1)
    }	
  }
}

class PezComun {

  var property position
  var property orientacion

  method daPuntos() = 5

  method image() {
    if(orientacion == "derecha") {
        return "pezComunDer.png"
    } else {
        return "pezComunIzq.png"
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
    if(position.x() >= game.width() - 1) {
        position = game.at(0, 1.randomUpTo(6))
    } else {
        position = position.right(1)
    }
}

  method moverPezAIzquierda() {
    if(position.x() <= 0) {
        position = game.at(game.width() - 1, 1.randomUpTo(6))
    } else {
        position = position.left(1) 
    }
}


}