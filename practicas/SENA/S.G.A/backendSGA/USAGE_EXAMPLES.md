# Sistema de Gestión Académica (SGA) - Ejemplos de Uso

## Estructura de la Base de Datos

El sistema incluye las siguientes entidades:

1. **Usuario** - Administradores e Instructores
2. **Asignatura** - Materias/Cursos
3. **Ficha** - Grupos/Cohortes
4. **Aprendiz** - Estudiantes
5. **AsignacionFichaInstructor** - Relación entre Instructor, Asignatura y Ficha
6. **Asistencia** - Registro de asistencias

## Modelos y Relaciones

### Usuario
- Tiene método `has_secure_password` para autenticación
- Puede ser `admin` o `instructor`
- Un instructor puede tener múltiples asignaciones

### Ficha
- Tiene muchos aprendices
- Tiene múltiples asignaturas a través de asignaciones

### AsignacionFichaInstructor
- Une Instructor + Asignatura + Ficha
- Un instructor enseña una asignatura específica a una ficha específica

### Asistencia
- Registra asistencia de un aprendiz en una asignación específica
- Estados: `presente`, `ausente`, `justificado`

## Ejemplos de Uso en Rails Console

Abre la consola con: `rails console`

### 1. Consultar Usuarios

```ruby
# Ver todos los usuarios
Usuario.all

# Ver solo admins
Usuario.admins

# Ver solo instructores
Usuario.instructores

# Buscar por correo
instructor = Usuario.find_by(correo: "maria.garcia@sga.com")

# Verificar rol
instructor.instructor? # => true
```

### 2. Ver Fichas y Aprendices

```ruby
# Ver todas las fichas
Ficha.all

# Buscar ficha por código
ficha = Ficha.find_by(codigo: "2823345")

# Ver aprendices de una ficha
ficha.aprendizs

# Ver cuántos aprendices tiene una ficha
ficha.aprendizs.count

# Ver las asignaturas de una ficha
ficha.asignaturas
```

### 3. Asignaciones

```ruby
# Ver todas las asignaciones
AsignacionFichaInstructor.all

# Ver asignaciones de un instructor
instructor = Usuario.find_by(correo: "maria.garcia@sga.com")
instructor.asignacion_ficha_instructors

# Ver qué fichas tiene un instructor
instructor.fichas

# Ver qué asignaturas enseña un instructor
instructor.asignaturas

# Buscar asignación específica
asignacion = AsignacionFichaInstructor.find_by(
  instructorid: instructor.id,
  asignaturaid: Asignatura.find_by(nombre: "Programación Básica").id,
  fichaid: ficha.id
)
```

### 4. Registrar Asistencia

```ruby
# Obtener una asignación
asignacion = AsignacionFichaInstructor.first

# Obtener un aprendiz
aprendiz = Aprendiz.first

# Tomar asistencia (método personalizado del modelo)
asignacion.tomar_asistencia(Date.today, aprendiz.id, "presente")

# O crear directamente
Asistencia.create!(
  fecha: Date.today,
  estado: "presente",
  aprendiz: aprendiz,
  asignacion_ficha_instructor: asignacion
)
```

### 5. Consultar Asistencias

```ruby
# Ver todas las asistencias
Asistencia.all

# Asistencias de hoy
Asistencia.por_fecha(Date.today)

# Asistencias presentes
Asistencia.presentes

# Asistencias ausentes
Asistencia.ausentes

# Asistencias justificadas
Asistencia.justificadas

# Asistencias de un aprendiz
aprendiz = Aprendiz.first
aprendiz.asistencias

# Asistencias de una asignación
asignacion = AsignacionFichaInstructor.first
asignacion.asistencias

# Ver asistencias de una asignación para una fecha
asignacion.ver_asistencias(Date.today)

# Ver todas las asistencias de una asignación
asignacion.ver_asistencias
```

### 6. Estadísticas

```ruby
# Porcentaje de asistencia de un aprendiz
aprendiz = Aprendiz.first
total = aprendiz.asistencias.count
presentes = aprendiz.asistencias.presentes.count
porcentaje = (presentes.to_f / total * 100).round(2)
puts "#{aprendiz.nombre}: #{porcentaje}% de asistencia"

# Asistencias por estado para una asignación
asignacion = AsignacionFichaInstructor.first
puts "Presentes: #{asignacion.asistencias.presentes.count}"
puts "Ausentes: #{asignacion.asistencias.ausentes.count}"
puts "Justificados: #{asignacion.asistencias.justificados.count}"

# Aprendices con más de 2 ausencias
Aprendiz.all.select do |aprendiz|
  aprendiz.asistencias.ausentes.count > 2
end
```

### 7. Crear Nuevos Registros

```ruby
# Crear una nueva ficha
ficha = Ficha.create!(
  codigo: "2823348",
  nombre: "Gestión de Redes"
)

# Agregar un aprendiz a la ficha
aprendiz = ficha.agregar_aprendiz(
  nombre: "Nuevo Estudiante",
  tipodocumento: "CC",
  ndocumento: 1000000099,
  correo: "nuevo@aprendiz.com"
)

# Crear una asignación
AsignacionFichaInstructor.create!(
  instructor: Usuario.instructores.first,
  asignatura: Asignatura.first,
  ficha: ficha
)
```

### 8. Consultas Avanzadas

```ruby
# Instructores que enseñan más de 2 asignaturas
Usuario.instructores.select do |instructor|
  instructor.asignacion_ficha_instructors.count > 2
end

# Asignaturas con más instructores
Asignatura.all.sort_by { |a| a.instructores.count }.reverse

# Fichas con más aprendices
Ficha.all.sort_by { |f| f.aprendizs.count }.reverse.first(3)

# Aprendices que nunca han faltado
Aprendiz.all.select do |aprendiz|
  aprendiz.asistencias.ausentes.count == 0
end

# Buscar asistencias en un rango de fechas
inicio = Date.today - 7
fin = Date.today
Asistencia.por_rango_fechas(inicio, fin)
```

## Credenciales de Prueba

- **Admin**: admin@sga.com / password123
- **Instructor**: maria.garcia@sga.com / password123
- **Instructor**: carlos.rodriguez@sga.com / password123
- **Instructor**: ana.martinez@sga.com / password123

## Validaciones Importantes

1. **Usuario**: Correo debe ser único y válido
2. **Aprendiz**: Documento debe ser único por tipo de documento
3. **AsignacionFichaInstructor**: Un instructor no puede tener la misma asignatura-ficha duplicada
4. **Asistencia**: Un aprendiz no puede tener múltiples asistencias para la misma fecha y asignación

## Próximos Pasos

Para crear una API REST completa, necesitarás crear:
1. Controladores para cada modelo
2. Rutas en `config/routes.rb`
3. Sistema de autenticación (JWT recomendado)
4. Serializers para formatear JSON
5. Tests unitarios y de integración
