# db/seeds.rb
# Limpiar datos existentes (opcional, comentar en producción)
puts "Limpiando base de datos..."
Asistencia.destroy_all
AsignacionFichaInstructor.destroy_all
Aprendiz.destroy_all
Ficha.destroy_all
Asignatura.destroy_all
Usuario.destroy_all

# Crear usuarios admin
puts "Creando administradores..."
admin1 = Usuario.create!(
  nombre: "Juan Pérez",
  correo: "admin@sga.com",
  password: "password123",
  password_confirmation: "password123",
  rol: "admin"
)

# Crear instructores
puts "Creando instructores..."
instructor1 = Usuario.create!(
  nombre: "María García",
  correo: "maria.garcia@sga.com",
  password: "password123",
  password_confirmation: "password123",
  rol: "instructor"
)

instructor2 = Usuario.create!(
  nombre: "Carlos Rodríguez",
  correo: "carlos.rodriguez@sga.com",
  password: "password123",
  password_confirmation: "password123",
  rol: "instructor"
)

instructor3 = Usuario.create!(
  nombre: "Ana Martínez",
  correo: "ana.martinez@sga.com",
  password: "password123",
  password_confirmation: "password123",
  rol: "instructor"
)

# Crear asignaturas
puts "Creando asignaturas..."
asignatura1 = Asignatura.create!(nombre: "Programación Básica")
asignatura2 = Asignatura.create!(nombre: "Bases de Datos")
asignatura3 = Asignatura.create!(nombre: "Desarrollo Web")
asignatura4 = Asignatura.create!(nombre: "Inglés Técnico")

# Crear fichas
puts "Creando fichas..."
ficha1 = Ficha.create!(
  codigo: "2823345",
  nombre: "Análisis y Desarrollo de Software"
)

ficha2 = Ficha.create!(
  codigo: "2823346",
  nombre: "Desarrollo de Aplicaciones Móviles"
)

ficha3 = Ficha.create!(
  codigo: "2823347",
  nombre: "Sistemas de Información"
)

# Crear aprendices para la ficha 1
puts "Creando aprendices para la ficha 1..."
aprendiz1 = Aprendiz.create!(
  nombre: "Pedro Gómez",
  tipodocumento: "CC",
  ndocumento: 1000000001,
  correo: "pedro.gomez@aprendiz.com",
  ficha: ficha1
)

aprendiz2 = Aprendiz.create!(
  nombre: "Laura Fernández",
  tipodocumento: "CC",
  ndocumento: 1000000002,
  correo: "laura.fernandez@aprendiz.com",
  ficha: ficha1
)

aprendiz3 = Aprendiz.create!(
  nombre: "Diego Silva",
  tipodocumento: "TI",
  ndocumento: 1000000003,
  correo: "diego.silva@aprendiz.com",
  ficha: ficha1
)

aprendiz4 = Aprendiz.create!(
  nombre: "Camila Torres",
  tipodocumento: "CC",
  ndocumento: 1000000004,
  correo: "camila.torres@aprendiz.com",
  ficha: ficha1
)

# Crear aprendices para la ficha 2
puts "Creando aprendices para la ficha 2..."
aprendiz5 = Aprendiz.create!(
  nombre: "Andrés Morales",
  tipodocumento: "CC",
  ndocumento: 1000000005,
  correo: "andres.morales@aprendiz.com",
  ficha: ficha2
)

aprendiz6 = Aprendiz.create!(
  nombre: "Valentina Ruiz",
  tipodocumento: "CC",
  ndocumento: 1000000006,
  correo: "valentina.ruiz@aprendiz.com",
  ficha: ficha2
)

# Crear asignaciones instructor-asignatura-ficha
puts "Creando asignaciones instructor-asignatura-ficha..."

# María García enseña Programación Básica en ficha 1
asignacion1 = AsignacionFichaInstructor.create!(
  instructor: instructor1,
  asignatura: asignatura1,
  ficha: ficha1
)

# María García enseña Bases de Datos en ficha 1
asignacion2 = AsignacionFichaInstructor.create!(
  instructor: instructor1,
  asignatura: asignatura2,
  ficha: ficha1
)

# Carlos Rodríguez enseña Desarrollo Web en ficha 1
asignacion3 = AsignacionFichaInstructor.create!(
  instructor: instructor2,
  asignatura: asignatura3,
  ficha: ficha1
)

# Ana Martínez enseña Programación Básica en ficha 2
asignacion4 = AsignacionFichaInstructor.create!(
  instructor: instructor3,
  asignatura: asignatura1,
  ficha: ficha2
)

# Crear asistencias de ejemplo
puts "Creando asistencias de ejemplo..."

# Asistencias para Programación Básica - Ficha 1
fecha_hoy = Date.today
fecha_ayer = Date.yesterday
fecha_antier = Date.today - 2

# Día 1
Asistencia.create!(
  fecha: fecha_antier,
  estado: "presente",
  aprendiz: aprendiz1,
  asignacion_ficha_instructor: asignacion1
)

Asistencia.create!(
  fecha: fecha_antier,
  estado: "presente",
  aprendiz: aprendiz2,
  asignacion_ficha_instructor: asignacion1
)

Asistencia.create!(
  fecha: fecha_antier,
  estado: "ausente",
  aprendiz: aprendiz3,
  asignacion_ficha_instructor: asignacion1
)

Asistencia.create!(
  fecha: fecha_antier,
  estado: "presente",
  aprendiz: aprendiz4,
  asignacion_ficha_instructor: asignacion1
)

# Día 2
Asistencia.create!(
  fecha: fecha_ayer,
  estado: "presente",
  aprendiz: aprendiz1,
  asignacion_ficha_instructor: asignacion1
)

Asistencia.create!(
  fecha: fecha_ayer,
  estado: "ausente",
  aprendiz: aprendiz2,
  asignacion_ficha_instructor: asignacion1
)

Asistencia.create!(
  fecha: fecha_ayer,
  estado: "justificado",
  aprendiz: aprendiz3,
  asignacion_ficha_instructor: asignacion1
)

Asistencia.create!(
  fecha: fecha_ayer,
  estado: "presente",
  aprendiz: aprendiz4,
  asignacion_ficha_instructor: asignacion1
)

# Asistencias para Bases de Datos - Ficha 1
Asistencia.create!(
  fecha: fecha_hoy,
  estado: "presente",
  aprendiz: aprendiz1,
  asignacion_ficha_instructor: asignacion2
)

Asistencia.create!(
  fecha: fecha_hoy,
  estado: "presente",
  aprendiz: aprendiz2,
  asignacion_ficha_instructor: asignacion2
)

Asistencia.create!(
  fecha: fecha_hoy,
  estado: "presente",
  aprendiz: aprendiz3,
  asignacion_ficha_instructor: asignacion2
)

Asistencia.create!(
  fecha: fecha_hoy,
  estado: "ausente",
  aprendiz: aprendiz4,
  asignacion_ficha_instructor: asignacion2
)

# Asistencias para Programación Básica - Ficha 2
Asistencia.create!(
  fecha: fecha_hoy,
  estado: "presente",
  aprendiz: aprendiz5,
  asignacion_ficha_instructor: asignacion4
)

Asistencia.create!(
  fecha: fecha_hoy,
  estado: "presente",
  aprendiz: aprendiz6,
  asignacion_ficha_instructor: asignacion4
)

puts "\n=========================================="
puts "Base de datos poblada exitosamente!"
puts "=========================================="
puts "\nDatos creados:"
puts "- #{Usuario.count} usuarios (#{Usuario.admins.count} admins, #{Usuario.instructores.count} instructores)"
puts "- #{Asignatura.count} asignaturas"
puts "- #{Ficha.count} fichas"
puts "- #{Aprendiz.count} aprendices"
puts "- #{AsignacionFichaInstructor.count} asignaciones instructor-asignatura-ficha"
puts "- #{Asistencia.count} asistencias registradas"
puts "\n=========================================="
puts "Credenciales de prueba:"
puts "Admin: admin@sga.com / password123"
puts "Instructor: maria.garcia@sga.com / password123"
puts "=========================================="
