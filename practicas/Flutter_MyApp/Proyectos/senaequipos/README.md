# senaequipos

**senaequipos** es una aplicación multiplataforma (móvil y escritorio) desarrollada en Flutter, diseñada para gestionar el registro, entrada y salida de equipos y vehículos. Utiliza Firebase como base de datos no relacional y permite el escaneo de códigos de barras para agilizar el registro de seriales.

> **Nota:** El soporte para iOS, Linux y macOS aún no ha sido verificado. Actualmente, la app está probada en Android, Windows.

## Características principales

- **Registro de equipos y vehículos:** Guarda información como nombre del responsable, cédula, serial y características del equipo o vehículo.
- **Control de entrada y salida:** Permite registrar la hora de entrada y salida de cada equipo o vehículo.
- **Escaneo de código de barras:** Compatible con cámaras móviles y lectores USB para ingresar seriales de forma rápida y precisa.
- **Listado y edición:** Consulta, edita o elimina registros existentes de manera sencilla.
- **Multiplataforma:** Funciona en Android, Windows, Linux y macOS gracias a Flutter.
- **Sincronización en la nube:** Todos los datos se almacenan y sincronizan en tiempo real usando Firebase Firestore.

## Tecnologías y paquetes utilizados

- **Flutter**: Framework principal para desarrollo multiplataforma.
- **Firebase**: Autenticación, Firestore y Storage.
- **mobile_scanner**: Escaneo de códigos de barras.
- **flutter_bloc, provider**: Gestión de estado.
- **get_it, injectable**: Inyección de dependencias.
- **equatable, uuid, http, json_serializable**: Utilidades y serialización.
- **google_fonts, flutter_svg**: Personalización de UI.

Consulta el archivo [`pubspec.yaml`](pubspec.yaml) para ver todas las dependencias.

## Instalación y configuración

1. **Clona el repositorio:**
   ```bash
   git clone <url-del-repo>
   cd senaequipos
   ```

2. **Instala las dependencias:**
   ```bash
   flutter pub get
   ```

3. **Configura Firebase:**
   - Descarga el archivo `google-services.json` (Android) desde la consola de Firebase y colócalo en `android/app/`.
   - (Opcional) Si deseas probar en iOS, descarga `GoogleService-Info.plist` y colócalo en `ios/Runner/`.
   - Asegúrate de que tu proyecto de Firebase tenga habilitado Firestore.

4. **Ejecuta la app:**
   ```bash
   flutter run
   ```

## Uso

- **Registrar equipo/vehículo:** Ingresa los datos requeridos y escanea el serial usando la cámara o un lector de código de barras.
- **Listar registros:** Busca por cédula y visualiza todos los equipos asociados.
- **Editar o eliminar:** Accede a los detalles de un registro para modificar o eliminar la información.
- **Registrar salida:** Actualiza la hora de salida cuando el equipo o vehículo abandona las instalaciones.

## Estructura del proyecto

- `lib/domain/`: Entidades, repositorios y objetos de valor.
- `lib/application/`: Casos de uso (crear, buscar, actualizar, eliminar).
- `lib/infrastructure/`: Implementaciones concretas (ej. Firebase).
- `lib/presentation/`: UI, controladores y widgets.
- `assets/`: Imágenes y recursos gráficos.

## Contribución

¡Las contribuciones son bienvenidas! Por favor, abre un issue o pull request para sugerencias o mejoras.

## Autores

- [Jeison andres ortiz castillo]
- [3052006108]
- [ojeison21@gmail.com]
