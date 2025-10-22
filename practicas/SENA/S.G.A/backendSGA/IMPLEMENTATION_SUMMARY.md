# Sistema de Gestión Académica (SGA)

## ✅ Estructura Completa Creada

### 📊 Base de Datos

Se han creado **6 tablas principales**:

1. **usuarios** - Administradores e Instructores con autenticación segura
2. **asignaturas** - Materias/Cursos del programa (creadas por admin)
3. **fichas** - Grupos/Cohortes de aprendices (creadas por admin)
4. **aprendizs** - Estudiantes del programa
5. **asignacion_fichas** - Tabla que relaciona Instructor + Ficha (asignación hecha por admin)
6. **asistencias** - Registro de asistencia de aprendices

### 🔗 Nueva Lógica de Relaciones

```
Usuario (Instructor)
    ├── Asignatura (escoge al registrarse)
    ├── AsignacionFicha (asignada por admin)
    │       ├── Ficha
    │       └── Asistencias
    │
Ficha (creada por admin)
    ├── Aprendizs
    └── AsignacionFicha (instructores asignados por admin)
    
Aprendiz
    ├── Ficha
    └── Asistencias

Asistencia
    ├── Aprendiz
    └── AsignacionFicha
```

### 🎯 Flujo de Trabajo

1. **Admin crea asignaturas** → Ej: "Programación Básica", "Bases de Datos"
2. **Instructor se registra** → Escoge su asignatura de la lista
3. **Admin crea fichas** → Ej: Ficha "2823345"
4. **Admin asigna fichas a instructores** → María (Programación) → Ficha 2823345
5. **Instructor toma asistencia** → En su(s) ficha(s) asignada(s)

### 📝 Modelos con Validaciones

Todos los modelos incluyen:
- ✅ Validaciones de presencia
- ✅ Validaciones de unicidad
- ✅ Validaciones de formato (email)
- ✅ Relaciones correctas con foreign keys
- ✅ Scopes útiles para consultas
- ✅ Métodos helper personalizados

### 🎯 Características Especiales

**Usuario**
- `has_secure_password` con bcrypt
- Scopes: `admins`, `instructores`
- Métodos: `admin?`, `instructor?`

**AsignacionFichaInstructor**
- Validación personalizada: solo usuarios con rol "instructor"
- Método `tomar_asistencia(fecha, aprendiz_id, estado)`
- Método `ver_asistencias(fecha = nil)`

**Asistencia**
- Estados: `presente`, `ausente`, `justificado`
- Scopes: `presentes`, `ausentes`, `justificados`, `por_fecha`, `por_rango_fechas`
- Métodos: `presente?`, `ausente?`, `justificado?`
- Validación única: un aprendiz no puede tener múltiples asistencias para la misma fecha y asignación

**Aprendiz**
- Validación de tipo de documento: `CC`, `TI`, `CE`, `PPT`
- Documento único por tipo

**Ficha**
- Método `agregar_aprendiz(aprendiz_params)`
- Código único

### 📊 Datos de Prueba

La base de datos viene poblada con:
- ✅ 4 usuarios (1 admin, 3 instructores)
- ✅ 4 asignaturas
- ✅ 3 fichas
- ✅ 6 aprendices
- ✅ 4 asignaciones instructor-asignatura-ficha
- ✅ 14 asistencias registradas (de 3 días diferentes)

### 🔐 Credenciales de Prueba

```
Admin:
  Email: admin@sga.com
  Password: password123

Instructores:
  Email: maria.garcia@sga.com
  Password: password123
  
  Email: carlos.rodriguez@sga.com
  Password: password123
  
  Email: ana.martinez@sga.com
  Password: password123
```

### 🚀 Comandos Útiles

```bash
# Ver migraciones ejecutadas
rails db:migrate:status

# Abrir consola de Rails
rails console

# Poblar base de datos
rails db:seed

# Resetear y poblar base de datos
rails db:reset

# Ver schema de la base de datos
cat db/schema.rb

# Ejecutar servidor
rails server
```

### 📖 Ejemplos de Uso

Ver el archivo `USAGE_EXAMPLES.md` para ejemplos detallados de:
- Consultas básicas
- Creación de registros
- Consultas de asistencias
- Estadísticas
- Consultas avanzadas

### 🎨 Índices Creados

Para optimizar consultas:
- `usuarios.correo` (único)
- `usuarios.rol`
- `asignaturas.nombre` (único)
- `fichas.codigo` (único)
- `aprendizs.[tipodocumento, ndocumento]` (único compuesto)
- `asignacion_ficha_instructors.[instructorid, asignaturaid, fichaid]` (único compuesto)
- `asistencias.[aprendizid, asignacionid, fecha]` (único compuesto)

### 🔒 Foreign Keys

Todas las relaciones tienen foreign keys con integridad referencial:
- `aprendizs.ficha_id` → `fichas.id`
- `asignacion_ficha_instructors.instructorid` → `usuarios.id`
- `asignacion_ficha_instructors.asignaturaid` → `asignaturas.id`
- `asignacion_ficha_instructors.fichaid` → `fichas.id`
- `asistencias.aprendizid` → `aprendizs.id`
- `asistencias.asignacionid` → `asignacion_ficha_instructors.id`

### 📋 Próximos Pasos Sugeridos

1. **API REST**: Crear controladores y rutas para exponer los datos
2. **Autenticación JWT**: Implementar sistema de tokens para la API
3. **Serializers**: Formatear respuestas JSON con ActiveModel::Serializers o Jbuilder
4. **Tests**: Agregar tests unitarios y de integración
5. **Documentación API**: Usar Swagger/OpenAPI
6. **Paginación**: Implementar con gemas como Kaminari o Pagy
7. **Búsqueda**: Agregar filtros y búsqueda avanzada
8. **Reportes**: Generar reportes de asistencias en PDF/Excel

---

## 🎉 ¡Sistema Listo para Usar!

Toda la lógica de negocio y estructura de datos está implementada y funcionando correctamente.
