import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

part 'app_database.g.dart';

// Tabla de tareas
@DataClassName('TareaDb')
class Tareas extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get titulo => text()();
  BoolColumn get completada =>
      boolean().withDefault(const Constant(false))();
}

// Configuración de la base de datos
@DriftDatabase(tables: [Tareas])
class AppDatabase extends _$AppDatabase {
  AppDatabase({
    String databaseName = 'gestor_tareas_local',
  }) : super(
          driftDatabase(
            name: databaseName,
            web: DriftWebOptions(
              sqlite3Wasm: Uri.parse('sqlite3.wasm'),
              driftWorker: Uri.parse('drift_worker.js'),
            ),
          ),
        );

    AppDatabase.withExecutor(super.executor);
  @override
  int get schemaVersion => 1;
}