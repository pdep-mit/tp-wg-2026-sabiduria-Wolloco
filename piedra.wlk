import wollok.game.*

object piedra {
    var property position = game.at(0, 3)

    method image() = "piedra.png"

    method mover() {
    if(position.x() >= game.width() - 1) {
        position = game.at(0, 1.randomUpTo(6))
    } else {
        position = position.right(1)
    }
}

method interactuarCon(unAnzuelo) {
  unAnzuelo.soltar()
  unAnzuelo.perderVidas(2)
}

}