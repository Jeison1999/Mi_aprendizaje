# Sistema de Gestión Académica (SGA) - Nueva Lógica

## 🎯 Flujo del Sistema

### 1. Admin crea asignaturas
```ruby
# Solo los admin pueden crear asignaturas
admin = Usuario.find_by(correo: "admin@sga.com")
Asignatura.create!(nombre: "Programación Avanzada")
```

### 2. Instructor se registra y escoge asignatura
```ruby
# Al registrarse, el instructor debe escoger una asignatura
Usuario.create!(
  nombre: "Pedro Ramírez",
  correo: "pedro@sga.com",
  password: "password123",
  password_confirmation: "password123",
  rol: "instructor",
  asignatura_id: Asignatura.find_by(nombre: "Programación Básica").id
)

# O usando la relación directa
Usuario.create!(
  nombre: "Pedro Ramírez",
  correo: "pedro@sga.com",
  password: "password123",
  password_confirmation: "password123",
  rol: "instructor",
  asignatura: Asignatura.find_by(nombre: "Programación Básica")
)
```

### 3. Admin crea fichas
```ruby
Ficha.create!(
  codigo: "2823348",
  nombre: "Gestión de Proyectos TI"
)
```

### 4. Admin asigna fichas a instructores
```ruby
# El admin asigna fichas a instructores
instructor = Usuario.find_by(correo: "maria.garcia@sga.com")
ficha = Ficha.find_by(codigo: "2823345")

# Opción 1: Crear asignación directamente
AsignacionFicha.create!(
  instructor: instructor,
  ficha: ficha
)

# Opción 2: Usar el método del modelo
instructor.asignar_ficha(ficha)
```

### 5. Instructor toma asistencia
```ruby
# El instructor toma asistencia en sus fichas asignadas
instructor = Usuario.find_by(correo: "maria.garcia@sga.com")

# Ver fichas asignadas
instructor.fichas

# Obtener una asignación específica
asignacion = instructor.asignacion_fichas.first

# Tomar asistencia
aprendiz = Aprendiz.first
asignacion.tomar_asistencia(Date.today, aprendiz.id, "presente")
```

## 📖 Consultas Útiles

### Consultas de Usuario/Instructor

```ruby
# Ver todos los instructores
Usuario.instructores

# Ver instructores de una asignatura específica
asignatura = Asignatura.find_by(nombre: "Programación Básica")
asignatura.instructores

# Ver fichas de un instructor
instructor = Usuario.find_by(correo: "maria.garcia@sga.com")
instructor.fichas
# o con detalles
instructor.ver_fichas

# Ver asignatura de un instructor
instructor.asignatura.nombre
```

### Consultas de Ficha

```ruby
# Ver ficha con código
ficha = Ficha.find_by(codigo: "2823345")

# Ver aprendices de una ficha
ficha.aprendizs

# Ver instructores asignados a una ficha
ficha.instructores

# Ver instructores con sus asignaturas (método personalizado)
ficha.ver_instructores
# Retorna: [{ id: 1, nombre: "María García", correo: "...", asignatura: "Programación Básica" }]
```

### Consultas de Asignación

```ruby
# Ver todas las asignaciones
AsignacionFicha.all

# Ver asignaciones de un instructor
instructor = Usuario.instructores.first
instructor.asignacion_fichas

# Ver asignaciones de una ficha
ficha = Ficha.first
ficha.asignacion_fichas

# Ver asignaturas que se enseñan en una ficha (a través de instructores)
ficha.instructores.includes(:asignatura).map { |i| i.asignatura.nombre }.uniq

# Ver asistencias de una asignación
asignacion = AsignacionFicha.first
asignacion.ver_asistencias(Date.today)
```

### Consultas de Asistencia

```ruby
# Ver asistencias de hoy
Asistencia.por_fecha(Date.today)

# Ver asistencias presentes/ausentes/justificadas
Asistencia.presentes
Asistencia.ausentes
Asistencia.justificados

# Ver asistencias de un aprendiz
aprendiz = Aprendiz.first
aprendiz.asistencias

# Ver asistencia con detalles de instructor y asignatura
asistencia = Asistencia.first
puts "Aprendiz: #{asistencia.aprendiz.nombre}"
puts "Instructor: #{asistencia.instructor.nombre}"
puts "Asignatura: #{asistencia.asignatura.nombre}"
puts "Ficha: #{asistencia.ficha.codigo}"
puts "Estado: #{asistencia.estado}"
```

## 📊 Ejemplos de Reportes

### Reporte por Instructor

```ruby
instructor = Usuario.find_by(correo: "maria.garcia@sga.com")

puts "Instructor: #{instructor.nombre}"
puts "Asignatura: #{instructor.asignatura.nombre}"
puts "\nFichas asignadas:"

instructor.asignacion_fichas.includes(ficha: :aprendizs).each do |asignacion|
  ficha = asignacion.ficha
  total_asistencias = asignacion.asistencias.count
  presentes = asignacion.asistencias.presentes.count
  
  puts "  Ficha #{ficha.codigo} - #{ficha.nombre}"
  puts "    Aprendices: #{ficha.aprendizs.count}"
  puts "    Asistencias tomadas: #{total_asistencias}"
  puts "    Presentes: #{presentes}"
end
```

### Reporte por Ficha

```ruby
ficha = Ficha.find_by(codigo: "2823345")

puts "Ficha: #{ficha.codigo} - #{ficha.nombre}"
puts "\nInstructores y asignaturas:"

ficha.ver_instructores.each do |instructor|
  puts "  #{instructor[:nombre]} - #{instructor[:asignatura]}"
end

puts "\nAprendices (#{ficha.aprendizs.count}):"
ficha.aprendizs.each do |aprendiz|
  total = aprendiz.asistencias.count
  presentes = aprendiz.asistencias.presentes.count
  porcentaje = total > 0 ? (presentes.to_f / total * 100).round(1) : 0
  
  puts "  #{aprendiz.nombre}: #{porcentaje}% asistencia"
end
```

### Reporte de Asistencia por Fecha

```ruby
fecha = Date.today

puts "Asistencias del #{fecha}"
puts "=" * 50

Asistencia.por_fecha(fecha).includes(:aprendiz, asignacion_ficha: [:instructor, :ficha]).each do |asistencia|
  puts "#{asistencia.aprendiz.nombre} - #{asistencia.ficha.codigo}"
  puts "  Instructor: #{asistencia.instructor.nombre} (#{asistencia.asignatura.nombre})"
  puts "  Estado: #{asistencia.estado}"
  puts ""
end
```

## 🔐 Validaciones Importantes

```ruby
# Un instructor DEBE tener una asignatura
instructor = Usuario.new(nombre: "Test", correo: "test@sga.com", password: "123", rol: "instructor")
instructor.valid?  # => false
instructor.errors[:asignatura_id]  # => ["debe existir"]

# Un instructor no puede estar asignado dos veces a la misma ficha
instructor = Usuario.instructores.first
ficha = Ficha.first
AsignacionFicha.create!(instructor: instructor, ficha: ficha)
AsignacionFicha.create!(instructor: instructor, ficha: ficha)  # => Error: ya está asignado

# Solo usuarios con rol "instructor" pueden asignarse a fichas
admin = Usuario.admins.first
AsignacionFicha.create!(instructor: admin, ficha: ficha)  # => Error: debe tener rol de instructor

# Un instructor debe tener asignatura para poder tomar asistencia
instructor_sin_asignatura = Usuario.create!(nombre: "Test", correo: "test2@sga.com", password: "123", rol: "instructor", asignatura_id: nil)
AsignacionFicha.create!(instructor: instructor_sin_asignatura, ficha: ficha)  # => Error: debe tener una asignatura asignada
```

## 🎨 Métodos Útiles

```ruby
# Usuario
usuario.admin?  # => true/false
usuario.instructor?  # => true/false
usuario.asignar_ficha(ficha)  # Admin asigna ficha a instructor
usuario.ver_fichas  # Ver fichas con detalles

# Ficha
ficha.agregar_aprendiz(params)  # Agregar aprendiz a ficha
ficha.ver_instructores  # Ver instructores con sus asignaturas

# AsignacionFicha
asignacion.tomar_asistencia(fecha, aprendiz_id, estado)
asignacion.ver_asistencias(fecha)  # fecha opcional
asignacion.asignatura_nombre  # Nombre de asignatura del instructor

# Asistencia
asistencia.presente?
asistencia.ausente?
asistencia.justificado?
```

## 🚀 Próximos Pasos

Para crear una API REST completa:

1. **Controladores por funcionalidad:**
   - `Admin::AsignaturasController` - CRUD de asignaturas
   - `Admin::FichasController` - CRUD de fichas
   - `Admin::AsignacionesController` - Asignar fichas a instructores
   - `Auth::RegistrationsController` - Registro de instructores con asignatura
   - `Instructor::AsistenciasController` - Tomar asistencia
   - `Instructor::FichasController` - Ver fichas asignadas

2. **Sistema de autenticación JWT**
3. **Serializers para formatear JSON**
4. **Políticas de autorización (Pundit o CanCanCan)**
5. **Tests unitarios y de integración**

## 🔐 Credenciales de Prueba

```
Admin:
  Email: admin@sga.com
  Password: password123

Instructores:
  Email: maria.garcia@sga.com
  Password: password123
  Asignatura: Programación Básica
  
  Email: carlos.rodriguez@sga.com
  Password: password123
  Asignatura: Bases de Datos
```
