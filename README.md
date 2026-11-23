# Gestor de tareas con SQLite

Aplicación multiplataforma desarrollada con Flutter para administrar tareas mediante una base de datos SQLite local. Utiliza Drift como capa de persistencia y permite trabajar sin conexión a internet, sin depender de servidores externos.

## 1. Funcionalidades

- Registrar nuevas tareas.
- Consultar las tareas guardadas.
- Editar el título de una tarea existente.
- Marcar tareas como completadas o pendientes.
- Eliminar tareas mediante su identificador.
- Validar que los títulos no estén vacíos ni contengan solamente espacios.
- Conservar los datos después de cerrar y volver a abrir la aplicación.

## 2. Tecnologías utilizadas

- Flutter y Dart.
- SQLite como base de datos local.
- Drift y drift_flutter para administrar la persistencia.
- drift_dev y build_runner para generar el código de la base de datos.
- WebAssembly para utilizar SQLite en el navegador.

## 3. Estructura del proyecto

```text
gestor_tareas_local/
│
├── android/
├── ios/
├── linux/
├── macos/
├── windows/
│
├── lib/
│   ├── data/
│   │   ├── app_database.dart
│   │   └── app_database.g.dart
│   ├── models/
│   │   └── tarea.dart
│   ├── screens/
│   │   └── tareas_page.dart
│   └── main.dart
│
├── test/
│   ├── database_test.dart
│   ├── validation_test.dart
│   └── widget_test.dart
│
├── web/
│   ├── sqlite3.wasm
│   ├── drift_worker.js
│   └── index.html
│
├── .gitignore
├── README.md
├── pubspec.yaml
└── pubspec.lock
```

## 4. Modelo de datos

La base de datos contiene una tabla llamada `tareas`:

| Campo | Tipo | Descripción |
|---|---|---|
| id | INTEGER | Identificador único autoincremental |
| titulo | TEXT | Nombre de la tarea |
| completada | BOOLEAN | Estado de la tarea; inicia en falso |

El identificador permite distinguir cada registro. Las operaciones de inserción, consulta, actualización y eliminación se realizan directamente sobre SQLite.

## 5. Arquitectura de persistencia

Se seleccionó Drift junto con drift_flutter para administrar SQLite desde Flutter y mantener una capa de persistencia compatible con las plataformas contempladas en el proyecto.

La clase `AppDatabase`, ubicada en `lib/data/app_database.dart`, configura la conexión y define la tabla `Tareas`.

El archivo `app_database.g.dart` contiene el código generado mediante build_runner.

Las operaciones CRUD se ejecutan de manera asíncrona. Para actualizar la interfaz cuando cambia la información almacenada, se utilizan consultas reactivas mediante Stream.

Para las pruebas automatizadas se utiliza una conexión SQLite en memoria, independiente de la conexión persistente de la aplicación.

## 6. Compatibilidad Web

Para utilizar SQLite en Chrome se configuraron los recursos WebAssembly correspondientes:

- `web/sqlite3.wasm`
- `web/drift_worker.js`

Estos archivos permiten ejecutar SQLite en el navegador mediante WebAssembly y el Worker de Drift.

Para las pruebas de persistencia web se utiliza el puerto 8080, manteniendo el mismo origen y perfil del navegador.

## 7. Instalación

Clonar el repositorio:

```bash
git clone https://github.com/Angel230-ISC/gestor-tareas-sqlite.git
cd gestor-tareas-sqlite
```

Instalar las dependencias:

```bash
flutter pub get
```

## 8. Ejecución

### Windows

```bash
flutter run -d windows
```

### Web (Chrome)

```bash
flutter run -d chrome --web-hostname localhost --web-port 8080
```

La aplicación utiliza los recursos WebAssembly ubicados en la carpeta `web/`.

## 9. Generación del código de Drift

Para regenerar el código de la base de datos:

```bash
dart run build_runner build --delete-conflicting-outputs
```

## 10. Pruebas automatizadas y análisis

Ejecutar todas las pruebas automatizadas:

```bash
flutter test
```

Analizar el código:

```bash
flutter analyze
```

Se implementaron cuatro pruebas automatizadas:

1. Verificación de la visualización inicial de la aplicación.
2. Inserción y consulta de tareas en SQLite.
3. Actualización del estado y eliminación de una tarea.
4. Rechazo de títulos vacíos y compuestos únicamente por espacios.

**Resultados:** las cuatro pruebas aprobaron mediante `flutter test`. El análisis estático finalizó sin problemas mediante `flutter analyze`.

## 11. Resultados de las pruebas manuales P1–P6

Se realizaron las seis comprobaciones solicitadas en la práctica:

| Prueba | Descripción | Plataforma | Resultado |
|---|---|---|---|
| P1 | Agregar tres tareas, cerrar y abrir la aplicación | Windows | Aprobada |
| P2 | Conservar el estado de una tarea completada después de reiniciar | Windows | Aprobada |
| P3 | Conservar el título editado después de reiniciar | Windows | Aprobada |
| P4 | Comprobar que una tarea eliminada no reaparezca | Windows | Aprobada |
| P5 | Rechazar títulos vacíos y formados únicamente por espacios | Windows | Aprobada |
| P6 | Recargar y cerrar/abrir la pestaña conservando los datos | Chrome | Aprobada |

## 12. Plataformas verificadas

**Plataformas ejecutadas y comprobadas:**

- Windows: aplicación de escritorio y persistencia local.
- Google Chrome: aplicación web y persistencia del navegador.

**Plataformas contempladas en la estructura del proyecto, pero no verificadas:**

- Android.
- iOS.
- Linux.
- macOS.

## 13. Autoría y contexto académico

Práctica individual de Programación de Dispositivos Móviles.

Ingeniería en Sistemas Computacionales  
Universidad Autónoma de Aguascalientes

Repositorio: https://github.com/Angel230-ISC/gestor-tareas-sqlite

