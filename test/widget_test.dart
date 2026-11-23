import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:drift/native.dart';
import 'package:gestor_tareas_local/main.dart';
import 'package:gestor_tareas_local/data/app_database.dart';

void main() {
  testWidgets(
    'La aplicación muestra el gestor de tareas',
    (WidgetTester tester) async {
      final database = AppDatabase.withExecutor(
        NativeDatabase.memory(),
      );

      await tester.pumpWidget(
        GestorTareasApp(database: database),
      );

      await tester.pump();

      expect(find.text('Gestor de tareas'), findsOneWidget);
      expect(find.text('Nueva tarea'), findsOneWidget);
      expect(find.text('Mis tareas'), findsOneWidget);

      // Desmontar la aplicación y cancelar el Stream.
      await tester.pumpWidget(
        const MaterialApp(
          home: SizedBox.shrink(),
        ),
      );

      await tester.pump(const Duration(milliseconds: 10));
      await database.close();
    },
  );
}