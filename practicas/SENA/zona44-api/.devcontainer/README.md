# Configuración del Dev Container

Este proyecto está configurado para usar VS Code Dev Containers con PostgreSQL.

## Configuración de la Base de Datos

### Configuración Automática

El devcontainer está configurado para:

1. **PostgreSQL**: Se ejecuta en un contenedor separado
2. **Configuración automática**: La base de datos se configura automáticamente al crear el container
3. **Puertos**: PostgreSQL está disponible en el puerto 5432
4. **Credenciales por defecto**:
   - Usuario: `postgres`
   - Contraseña: `postgres`
   - Host: `localhost` (dentro del container)
   - Puerto: `5432`

### Archivos de Configuración

- **`.devcontainer/devcontainer.json`**: Configuración principal del devcontainer
- **`.devcontainer/docker-compose.yml`**: Definición de servicios (app + postgres)
- **`.devcontainer/Dockerfile`**: Imagen personalizada con Ruby y Rails
- **`.devcontainer/create-db-user.sql`**: Script para crear usuario de base de datos
- **`config/database.yml`**: Configuración de Rails para la base de datos
- **`.env.development`**: Variables de entorno para desarrollo

### Comandos Útiles

Una vez que el devcontainer esté ejecutándose:

```bash
# Instalar dependencias
bundle install

# Configurar la base de datos
bin/rails db:prepare

# Crear y migrar la base de datos
bin/rails db:create
bin/rails db:migrate

# Ejecutar el servidor
bin/rails server

# Ejecutar la consola de Rails
bin/rails console

# Ejecutar las pruebas
bin/rails test
```

### Puertos Expuestos

- **3000**: Aplicación Rails
- **5432**: PostgreSQL (para conexiones externas si es necesario)

### Solución de Problemas

1. **Error de conexión a la base de datos**: Asegúrate de que el servicio de PostgreSQL esté ejecutándose
2. **Puerto ocupado**: Verifica que los puertos 3000 y 5432 no estén siendo usados por otros servicios
3. **Permisos**: Si hay problemas de permisos, reconstruye el container

### Reconstruir el Container

Si necesitas reconstruir el container:

1. `Ctrl+Shift+P` → "Dev Containers: Rebuild Container"
2. O desde la línea de comandos: `docker-compose down && docker-compose up --build`
