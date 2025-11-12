from app import promedio

def test_promedio_ok():
    assert promedio( 2,2,2) == 2

def test_promedio_none():
    assert promedio(50,50,50) is None

