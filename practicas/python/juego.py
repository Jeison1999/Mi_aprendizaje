import random

numeroPC= random.randint(1,20)
adivine=  False

while adivine == False:
    numeroUsuario= int(input('Adivina el número: '))

    if numeroUsuario == numeroPC:
        print ('Felicidades!') 
        adivine= True
    else:
        if numeroUsuario > numeroPC:
            print('El número es menor')
        else:
            print('El número es mayor')