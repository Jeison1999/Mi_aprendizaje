puts "ingrese un valor para declarar su renta"
v = gets.chomp.to_f

if v <= 10
    r = (v * (20/100.to_f))
    d = v - r
    puts ("su renta con su descuento es #{d}")

elsif v <= 100
    r = (v * (10/100.to_f))
    d = v - r
    puts ("su renta con su descuento es #{d}")

elsif v <= 1000
    r = (v * (5/100.to_f))
    d = v - r
    puts ("su renta con su descuento es #{d}")
else
    r = (v * (1/100.to_f))
    d = v - r
    puts ("su renta con su descuento es #{d}")
end

