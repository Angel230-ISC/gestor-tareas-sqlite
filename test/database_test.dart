import 'package:flutter_test/flutter_test.dart';
import 'package:drift/native.dart';
import 'package:drift/drift.dart' show Value;
import 'package:gestor_tareas_local/data/app_database.dart';

void main() {
  late AppDatabase database;

  setUp(() {
    database = AppDatabase.withExecutor(
      NativeDatabase.memory(),
    );
  });

  tearDown(() async {
    await database.close();
  });

  test('Permite insertar y consultar una tarea', () async {
    await database.into(database.tareas).insert(
      TareasCompanion.insert(titulo: 'Estudiar Flutter'),
    );

    final tareas = await database.select(database.tareas).get();

    expect(tareas, hasLength(1));
    expect(tareas.first.titulo, 'Estudiar Flutter');
    expect(tareas.first.completada, isFalse);
  });

  test('Permite actualizar y eliminar una tarea', () async {
    final id = await database.into(database.tareas).insert(
      TareasCompanion.insert(titulo: 'Practicar SQLite'),
    );

    await (database.update(database.tareas)
          ..where((tarea) => tarea.id.equals(id)))
        .write(
      const TareasCompanion(
        completada: Value(true),
      ),
    );

    final tarea = await (database.select(database.tareas)
          ..where((tarea) => tarea.id.equals(id)))
        .getSingle();

    expect(tarea.completada, isTrue);

    await (database.delete(database.tareas)
          ..where((tarea) => tarea.id.equals(id)))
        .go();

    final tareas = await database.select(database.tareas).get();

    expect(tareas, isEmpty);
  });
}