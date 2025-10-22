# db/seeds.rb - Sistema de Gestión Académica (SGA)
# Limpiar datos existentes (comentar en producción)
puts "Limpiando base de datos..."
Asistencia.destroy_all
AsignacionFicha.destroy_all
Aprendiz.destroy_all
Ficha.destroy_all
Usuario.destroy_all
Asignatura.destroy_all

puts "\n=========================================="
puts "   CREANDO DATOS DE PRUEBA - SGA"
puts "=========================================="

# PASO 1: Admin crea asignaturas
puts "\n1️⃣  Admin creando asignaturas..."
asignatura1 = Asignatura.create!(nombre: "Programación Básica")
asignatura2 = Asignatura.create!(nombre: "Bases de Datos")
asignatura3 = Asignatura.create!(nombre: "Desarrollo Web")
asignatura4 = Asignatura.create!(nombre: "Inglés Técnico")
asignatura5 = Asignatura.create!(nombre: "Matemáticas Aplicadas")
puts "   ✓ #{Asignatura.count} asignaturas creadas"

# PASO 2: Crear administrador
puts "\n2️⃣  Creando administrador..."
admin1 = Usuario.create!(
  nombre: "Juan Pérez",
  correo: "admin@sga.com",
  password: "password123",
  password_confirmation: "password123",
  rol: "admin"
)
puts "   ✓ Admin creado: #{admin1.correo}"

# PASO 3: Instructores se registran y escogen su asignatura
puts "\n3️⃣  Instructores registrándose con sus asignaturas..."
instructor1 = Usuario.create!(
  nombre: "María García",
  correo: "maria.garcia@sga.com",
  password: "password123",
  password_confirmation: "password123",
  rol: "instructor",
  asignatura: asignatura1
)
puts "   ✓ #{instructor1.nombre} - #{instructor1.asignatura.nombre}"

instructor2 = Usuario.create!(
  nombre: "Carlos Rodríguez",
  correo: "carlos.rodriguez@sga.com",
  password: "password123",
  password_confirmation: "password123",
  rol: "instructor",
  asignatura: asignatura2
)
puts "   ✓ #{instructor2.nombre} - #{instructor2.asignatura.nombre}"

instructor3 = Usuario.create!(
  nombre: "Ana Martínez",
  correo: "ana.martinez@sga.com",
  password: "password123",
  password_confirmation: "password123",
  rol: "instructor",
  asignatura: asignatura3
)
puts "   ✓ #{instructor3.nombre} - #{instructor3.asignatura.nombre}"

instructor4 = Usuario.create!(
  nombre: "Luis Fernández",
  correo: "luis.fernandez@sga.com",
  password: "password123",
  password_confirmation: "password123",
  rol: "instructor",
  asignatura: asignatura4
)
puts "   ✓ #{instructor4.nombre} - #{instructor4.asignatura.nombre}"

# PASO 4: Admin crea fichas
puts "\n4️⃣  Admin creando fichas..."
ficha1 = Ficha.create!(codigo: "2823345", nombre: "Análisis y Desarrollo de Software")
ficha2 = Ficha.create!(codigo: "2823346", nombre: "Desarrollo de Aplicaciones Móviles")
ficha3 = Ficha.create!(codigo: "2823347", nombre: "Sistemas de Información")
puts "   ✓ #{Ficha.count} fichas creadas"

# PASO 5: Admin asigna fichas a instructores
puts "\n5️⃣  Admin asignando fichas a instructores..."
asignacion1 = AsignacionFicha.create!(instructor: instructor1, ficha: ficha1)
puts "   ✓ #{instructor1.nombre} (#{instructor1.asignatura.nombre}) → #{ficha1.codigo}"

asignacion2 = AsignacionFicha.create!(instructor: instructor1, ficha: ficha2)
puts "   ✓ #{instructor1.nombre} (#{instructor1.asignatura.nombre}) → #{ficha2.codigo}"

asignacion3 = AsignacionFicha.create!(instructor: instructor2, ficha: ficha1)
puts "   ✓ #{instructor2.nombre} (#{instructor2.asignatura.nombre}) → #{ficha1.codigo}"

asignacion4 = AsignacionFicha.create!(instructor: instructor3, ficha: ficha2)
puts "   ✓ #{instructor3.nombre} (#{instructor3.asignatura.nombre}) → #{ficha2.codigo}"

asignacion5 = AsignacionFicha.create!(instructor: instructor3, ficha: ficha3)
puts "   ✓ #{instructor3.nombre} (#{instructor3.asignatura.nombre}) → #{ficha3.codigo}"

asignacion6 = AsignacionFicha.create!(instructor: instructor4, ficha: ficha1)
puts "   ✓ #{instructor4.nombre} (#{instructor4.asignatura.nombre}) → #{ficha1.codigo}"

asignacion7 = AsignacionFicha.create!(instructor: instructor4, ficha: ficha2)
puts "   ✓ #{instructor4.nombre} (#{instructor4.asignatura.nombre}) → #{ficha2.codigo}"

asignacion8 = AsignacionFicha.create!(instructor: instructor4, ficha: ficha3)
puts "   ✓ #{instructor4.nombre} (#{instructor4.asignatura.nombre}) → #{ficha3.codigo}"

# PASO 6: Agregar aprendices
puts "\n6️⃣  Agregando aprendices a las fichas..."
aprendiz1 = ficha1.agregar_aprendiz(nombre: "Pedro Gómez", tipodocumento: "CC", ndocumento: 1000000001, correo: "pedro.gomez@aprendiz.com")
aprendiz2 = ficha1.agregar_aprendiz(nombre: "Laura Fernández", tipodocumento: "CC", ndocumento: 1000000002, correo: "laura.fernandez@aprendiz.com")
aprendiz3 = ficha1.agregar_aprendiz(nombre: "Diego Silva", tipodocumento: "TI", ndocumento: 1000000003, correo: "diego.silva@aprendiz.com")
aprendiz4 = ficha1.agregar_aprendiz(nombre: "Camila Torres", tipodocumento: "CC", ndocumento: 1000000004, correo: "camila.torres@aprendiz.com")
puts "   ✓ Ficha #{ficha1.codigo}: #{ficha1.aprendizs.count} aprendices"

aprendiz5 = ficha2.agregar_aprendiz(nombre: "Andrés Morales", tipodocumento: "CC", ndocumento: 1000000005, correo: "andres.morales@aprendiz.com")
aprendiz6 = ficha2.agregar_aprendiz(nombre: "Valentina Ruiz", tipodocumento: "CC", ndocumento: 1000000006, correo: "valentina.ruiz@aprendiz.com")
aprendiz7 = ficha2.agregar_aprendiz(nombre: "Sebastián López", tipodocumento: "CC", ndocumento: 1000000007, correo: "sebastian.lopez@aprendiz.com")
puts "   ✓ Ficha #{ficha2.codigo}: #{ficha2.aprendizs.count} aprendices"

aprendiz8 = ficha3.agregar_aprendiz(nombre: "Sofía Ramírez", tipodocumento: "CC", ndocumento: 1000000008, correo: "sofia.ramirez@aprendiz.com")
aprendiz9 = ficha3.agregar_aprendiz(nombre: "Daniel Castro", tipodocumento: "CC", ndocumento: 1000000009, correo: "daniel.castro@aprendiz.com")
puts "   ✓ Ficha #{ficha3.codigo}: #{ficha3.aprendizs.count} aprendices"

# PASO 7: Instructores toman asistencia
puts "\n7️⃣  Registrando asistencias..."
fecha_hoy = Date.today
fecha_ayer = Date.yesterday
fecha_antier = Date.today - 2

asignacion1.tomar_asistencia(fecha_antier, aprendiz1.id, "presente")
asignacion1.tomar_asistencia(fecha_antier, aprendiz2.id, "presente")
asignacion1.tomar_asistencia(fecha_antier, aprendiz3.id, "ausente")
asignacion1.tomar_asistencia(fecha_antier, aprendiz4.id, "presente")

asignacion1.tomar_asistencia(fecha_ayer, aprendiz1.id, "presente")
asignacion1.tomar_asistencia(fecha_ayer, aprendiz2.id, "ausente")
asignacion1.tomar_asistencia(fecha_ayer, aprendiz3.id, "justificado")
asignacion1.tomar_asistencia(fecha_ayer, aprendiz4.id, "presente")

asignacion3.tomar_asistencia(fecha_hoy, aprendiz1.id, "presente")
asignacion3.tomar_asistencia(fecha_hoy, aprendiz2.id, "presente")
asignacion3.tomar_asistencia(fecha_hoy, aprendiz3.id, "presente")
asignacion3.tomar_asistencia(fecha_hoy, aprendiz4.id, "ausente")

asignacion2.tomar_asistencia(fecha_hoy, aprendiz5.id, "presente")
asignacion2.tomar_asistencia(fecha_hoy, aprendiz6.id, "presente")
asignacion2.tomar_asistencia(fecha_hoy, aprendiz7.id, "ausente")

asignacion5.tomar_asistencia(fecha_hoy, aprendiz8.id, "presente")
asignacion5.tomar_asistencia(fecha_hoy, aprendiz9.id, "justificado")

puts "   ✓ #{Asistencia.count} asistencias registradas"

puts "\n=========================================="
puts "   ✅ BASE DE DATOS POBLADA"
puts "=========================================="
puts "\n📊 RESUMEN:"
puts "   - Usuarios: #{Usuario.count} (#{Usuario.admins.count} admin, #{Usuario.instructores.count} instructores)"
puts "   - Asignaturas: #{Asignatura.count}"
puts "   - Fichas: #{Ficha.count}"
puts "   - Aprendices: #{Aprendiz.count}"
puts "   - Asignaciones: #{AsignacionFicha.count}"
puts "   - Asistencias: #{Asistencia.count}"
puts "\n🔐 CREDENCIALES:"
puts "   Admin: admin@sga.com / password123"
puts "   Instructor: maria.garcia@sga.com / password123"
puts "=========================================="
