import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:drift/native.dart';
import 'package:gestor_tareas_local/main.dart';
import 'package:gestor_tareas_local/data/app_database.dart';

void main() {
  testWidgets(
    'Rechaza títulos vacíos y con espacios',
    (WidgetTester tester) async {
      final database = AppDatabase.withExecutor(
        NativeDatabase.memory(),
      );

      await tester.pumpWidget(
        GestorTareasApp(database: database),
      );

      await tester.pump();

      // Intentar agregar un título vacío.
      await tester.tap(find.text('Agregar tarea'));
      await tester.pump();

      var tareas = await database.select(database.tareas).get();
      expect(tareas, isEmpty);

      // Intentar agregar un título con espacios.
      await tester.enterText(
        find.byType(TextField),
        '   ',
      );

      await tester.tap(find.text('Agregar tarea'));
      await tester.pump();

      tareas = await database.select(database.tareas).get();
      expect(tareas, isEmpty);

      // Cerrar la pantalla y la base de datos.
      await tester.pumpWidget(const SizedBox.shrink());
      await tester.pump(const Duration(milliseconds: 10));
      await database.close();
    },
  );
}