from car import Carro
from car import texto

def test_verifique_instancia_car():
    p = Carro('uvx123', 'rojo')
    assert isinstance(p, Carro)


def test_atributos_funcionan():
    p = Carro('uvx123', 'rojo')
    assert(p.color,p.placa) == ('rojo','uvx123')


def prueba_de_texto():
    p = Carro.texto("el carro de placa uvx123 es de color rojo")
    assert p == "el carro de placa uvx123 es de color rojo"
