class Monstruo {
  const objetosNecesariosIndividuales = #{}
  const objetosNecesariosEspecie

  // Para Versión B de cazador.pelearCon(monstruo)
  method puedeSerCazadoPor(cazador) =
    cazador.tieneTodo(self.objetosNecesarios())

  method objetosNecesarios() = objetosNecesariosIndividuales.union(objetosNecesariosEspecie)

  method hacerDanio(cazador) {}

  method esFacil() = self.objetosNecesarios().size() == 1
}

class Banshee inherits Monstruo(objetosNecesariosEspecie = #{"hierro", "sal"} ) {
  override method hacerDanio(cazador) {
    cazador.perderObjetos()
  }
}

class Curupi inherits Monstruo(objetosNecesariosEspecie = #{"hacha"} ) {
  override method hacerDanio(cazador) {
    cazador.modificarDestreza( - cazador.destreza() / 2)
  }
}

class LuzMala inherits Monstruo(objetosNecesariosEspecie = #{} ) {
  override method hacerDanio(cazador) {
    cazador.modificarDestreza( - cazador.cantidadObjetos())
  }
}

class Cazador {
  const objetos = []
  const monstruosCazados = []
  var destreza

  /*
  Punto 1
  */
  method pelearCon(monstruo) {
    if(self.puedeCazar(monstruo)) // Versión A
    //if(monstruo.puedeSerCazadoPor(self))  //Versión B
      monstruosCazados.add(monstruo)
    else
      monstruo.hacerDanio(self)
  }

  // Para Versión A de pelearCon(monstruo)
  method puedeCazar(monstruo) =
    self.tieneTodo(monstruo.objetosNecesarios()) 
    // Para el punto 5 se agrega:
    and monstruo.puedeSerCazadoPor(self)

  method tieneTodo(objetosNecesarios) =
    objetosNecesarios.intersection(objetos) == objetosNecesarios
    // objetosNecesarios.difference(objetos).isEmtpy()  // Otra opción

  method perderObjetos() = objetos.clear()

  method modificarDestreza(cantidad) {
    destreza = 0.max(destreza + cantidad)
  }

  method cantidadObjetos() = objetos.size()

  /*
  Punto 2 - Puede saltarse este paso e ir directamente a las implementaciones de los distintos casos
  */
  method investigar(caso) {
    caso.investigar(self)
  }

  method agregarObjeto(objeto) {
    objetos.add(objeto)
  }

  method perderUltimoObjeto() {
    objetos.remove(objetos.last())
  }

  method cantidadDeMonstruosFaciles() = 
    monstruosCazados.count{ monstruo => monstruo.esFacil() }
}

class Crimen {
  const objeto

  method investigar(cazador) {
    cazador.agregarObjeto(objeto)
  }
}

object trampa {
  method investigar(cazador) {
    cazador.perderUltimoObjeto()
  }
}

class Avistaje {
  const destreza
  
  method investigar(cazador) {
    cazador.modificarDestreza(destreza)
  }
}

/*
Punto 3
*/
class Concurso {
  const participantes = #{}
  /* Como variante, el criterio podría llegar como argumento del mensaje podio, 
  y también podría ser todo el bloque, recibiendo y comparando ambos cazadores,
  en lugar de ser sólo una valoración de un cazador. */
  const criterioValoracion    
  const criterioAceptacion

  method podio() = 
    participantes.sortedBy{c1, c2 => criterioValoracion.apply(c1) > criterioValoracion.apply(c2)}.take(3) 

  /*
  Punto 4
  */
  method registrar(cazador) {
    self.validar(cazador)    
    participantes.add(cazador)
  }

  method validar(cazador) {
    if(not cazador.cumple(criterioAceptacion))
      throw new NoPuedeParticiparException(message = "El cazador no cumple el criterio de aceptación")
  }
}

/* Criterios de valoración para punto 3 */
const criterioDeMayorCantidadDeMonstruos = 
  { cazador => cazador.cantidadMonstruosCazados() }

const criterioDeMonstruoMasJodido = 
  { cazador => cazador.cantidadDeObjetosDelMonstruoMasJodidoDedicadoANicoKalaydjianConCarinio() }

const criterioMasHolgazan = 
  { cazador => cazador.cantidadDeMonstruosFaciles() }

/*
Ejemplo de criterio de aceptación para el punto 4
*/
const criterioCantidadMonstruos = 
  { cazador => cazador.cantidadMonstruosCazados() >= 10 }

/* Ejemplo de creación de un concurso */
const elRamboGuarani = new Concurso(criterioValoracion = criterioDeMonstruoMasJodido,
                                    criterioAceptacion = criterioCantidadMonstruos)

object kraken inherits Monstruo(objetosNecesariosEspecie = #{}) {
  /*
  Punto 5 - Para versión A de cazador.pelearCon(monstruo)
  */
  override method puedeSerCazadoPor(cazador) = 
    cazador.destreza() > 1000

  /* Punto 5 - Para versión B de cazador.pelearCon(monstruo)
  override method puedeSerCazadoPor(cazador) = 
    super(cazador) and cazador.destreza() > 1000
  */
}

class NoPuedeParticiparException inherits Exception {}