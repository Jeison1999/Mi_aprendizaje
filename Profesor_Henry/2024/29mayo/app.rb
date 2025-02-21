puts "ingrese un numero entero"
i = gets.chomp.to_f

if i > 0
    puts " #{i} es un numero positivo"
else 
    if i < 0
        puts " #{i} su numero es negativo"
    else
        puts " su numero es cero"
    end
end