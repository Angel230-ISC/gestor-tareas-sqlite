# Gestor de tareas con SQLite

Aplicación multiplataforma desarrollada con Flutter para administrar tareas mediante una base de datos SQLite local. Utiliza Drift como capa de persistencia y permite trabajar sin conexión a internet.

## Funcionalidades

- Registrar nuevas tareas.
- Consultar las tareas guardadas.
- Editar el título de una tarea.
- Marcar tareas como completadas o pendientes.
- Eliminar tareas.
- Validar que los títulos no estén vacíos ni contengan solamente espacios.
- Conservar los datos después de cerrar y volver a abrir la aplicación.

## Tecnologías utilizadas

- Flutter y Dart.
- SQLite.
- Drift y drift_flutter.
- drift_dev y build_runner para generar el código de la base de datos.

## Estructura del proyecto

```text
lib/
├── data/
│   ├── app_database.dart
│   └── app_database.g.dart
├── screens/
│   └── tareas_page.dart
└── main.dart

test/
├── database_test.dart
└── widget_test.dart

web/
├── sqlite3.wasm
└── drift_worker.js
```

## Modelo de datos

La base de datos contiene una tabla llamada `tareas`:

| Campo | Tipo | Descripción |
|---|---|---|
| id | INTEGER | Identificador único autoincremental |
| titulo | TEXT | Nombre de la tarea |
| completada | BOOLEAN | Estado de la tarea; inicia en falso |

## Instalación

Clonar el repositorio:

```bash
git clone https://github.com/Angel230-ISC/gestor-tareas-sqlite.git
cd gestor-tareas-sqlite
```

Instalar las dependencias:

```bash
flutter pub get
```

## Ejecución

### Windows

```bash
flutter run -d windows
```

### Web (Chrome)

Se utiliza el puerto 8080 para conservar el mismo origen y almacenamiento del navegador:

```bash
flutter run -d chrome --web-hostname localhost --web-port 8080
```

La aplicación utiliza los recursos WebAssembly ubicados en la carpeta `web/`.

## Generación del código de Drift

Para regenerar el código de la base de datos:

```bash
dart run build_runner build --delete-conflicting-outputs
```

## Pruebas y análisis

Ejecutar todas las pruebas automatizadas:

```bash
flutter test
```

Analizar el código:

```bash
flutter analyze
```

Las pruebas automatizadas verifican la visualización inicial de la aplicación y las operaciones de inserción, consulta, actualización y eliminación en la base de datos.

## Plataformas verificadas

- Windows: ejecución como aplicación de escritorio.
- Chrome: ejecución web y persistencia al recargar y volver a abrir la pestaña.

La arquitectura está planteada para las plataformas compatibles con Flutter, pero las demás plataformas deben verificarse individualmente antes de afirmar que fueron probadas.

## Autoría

Práctica individual de Programación de Dispositivos Móviles.

Ingeniería en Sistemas Computacionales  
Universidad Autónoma de Aguascalientes