import 'package:flutter/material.dart';
import 'package:drift/drift.dart' hide Column;
import '../data/app_database.dart';

class TareasPage extends StatefulWidget {
  final AppDatabase database;

  const TareasPage({
    super.key,
    required this.database,
  });

  @override
  State<TareasPage> createState() => _TareasPageState();
}

class _TareasPageState extends State<TareasPage> {
  final TextEditingController _tituloController =
      TextEditingController();

  // CONSULTA: escuchar los cambios de SQLite
  Stream<List<TareaDb>> _consultarTareas() {
    return widget.database.select(widget.database.tareas).watch();
  }

  // ALTA: agregar una tarea
  Future<void> _agregarTarea() async {
    final titulo = _tituloController.text.trim();

    if (titulo.isEmpty) {
      _mostrarMensaje('Escribe un título para la tarea');
      return;
    }

    try {
      await widget.database.into(widget.database.tareas).insert(
        TareasCompanion.insert(
          titulo: titulo,
        ),
      );

      _tituloController.clear();

      _mostrarMensaje('Tarea agregada correctamente');
    } catch (e) {
      _mostrarMensaje('Error al guardar la tarea: $e');
    }
  }

  // ACTUALIZAR: cambiar estado de la tarea
  Future<void> _alternarCompletada(
    TareaDb tarea,
    bool completada,
  ) async {
    try {
      await (widget.database.update(widget.database.tareas)
            ..where((tabla) => tabla.id.equals(tarea.id)))
          .write(
        TareasCompanion(
          completada: Value(completada),
        ),
      );
    } catch (e) {
      _mostrarMensaje('Error al actualizar el estado: $e');
    }
  }

  // ACTUALIZAR: editar título
  Future<void> _editarTarea(TareaDb tarea) async {
    final controller = TextEditingController(text: tarea.titulo);

    final nuevoTitulo = await showDialog<String>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Editar tarea'),
          content: TextField(
            controller: controller,
            autofocus: true,
            decoration: const InputDecoration(
              labelText: 'Título de la tarea',
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancelar'),
            ),
            FilledButton(
              onPressed: () {
                Navigator.pop(context, controller.text);
              },
              child: const Text('Guardar'),
            ),
          ],
        );
      },
    );

    controller.dispose();

    if (nuevoTitulo == null) return;

    final titulo = nuevoTitulo.trim();

    if (titulo.isEmpty) {
      _mostrarMensaje('El título no puede estar vacío');
      return;
    }

    try {
      await (widget.database.update(widget.database.tareas)
            ..where((tabla) => tabla.id.equals(tarea.id)))
          .write(
        TareasCompanion(
          titulo: Value(titulo),
        ),
      );

      _mostrarMensaje('Tarea modificada correctamente');
    } catch (e) {
      _mostrarMensaje('Error al editar la tarea: $e');
    }
  }

  // ELIMINAR: borrar tarea por identificador
  Future<void> _eliminarTarea(TareaDb tarea) async {
    final confirmar = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Eliminar tarea'),
          content: Text(
            '¿Deseas eliminar "${tarea.titulo}"?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancelar'),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Eliminar'),
            ),
          ],
        );
      },
    );

    if (confirmar != true) return;

    try {
      await (widget.database.delete(widget.database.tareas)
            ..where((tabla) => tabla.id.equals(tarea.id)))
          .go();

      _mostrarMensaje('Tarea eliminada correctamente');
    } catch (e) {
      _mostrarMensaje('Error al eliminar la tarea: $e');
    }
  }

  // Mostrar mensajes al usuario
  void _mostrarMensaje(String mensaje) {
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(mensaje)),
    );
  }

  @override
  void dispose() {
    _tituloController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gestor de tareas'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _tituloController,
              decoration: const InputDecoration(
                labelText: 'Nueva tarea',
                border: OutlineInputBorder(),
              ),
              onSubmitted: (_) => _agregarTarea(),
            ),
            const SizedBox(height: 8),
            FilledButton.icon(
              onPressed: _agregarTarea,
              icon: const Icon(Icons.add),
              label: const Text('Agregar tarea'),
            ),
            const SizedBox(height: 12),
            const Text(
              'Mis tareas',
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 8),

            // CONSULTA REACTIVA MEDIANTE STREAM
            Expanded(
              child: StreamBuilder<List<TareaDb>>(
                stream: _consultarTareas(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Center(
                      child: Text(
                        'Error al consultar las tareas: ${snapshot.error}',
                      ),
                    );
                  }

                  if (snapshot.connectionState ==
                      ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  final tareas = snapshot.data ?? [];

                  if (tareas.isEmpty) {
                    return const Center(
                      child: Text(
                        'Todavía no hay tareas guardadas',
                      ),
                    );
                  }

                  return ListView.builder(
                    itemCount: tareas.length,
                    itemBuilder: (context, index) {
                      final tarea = tareas[index];

                      return Card(
                        child: ListTile(
                          leading: Checkbox(
                            value: tarea.completada,
                            onChanged: (valor) {
                              if (valor != null) {
                                _alternarCompletada(
                                  tarea,
                                  valor,
                                );
                              }
                            },
                          ),
                          title: Text(
                            tarea.titulo,
                            style: TextStyle(
                              decoration: tarea.completada
                                  ? TextDecoration.lineThrough
                                  : TextDecoration.none,
                            ),
                          ),
                          subtitle: Text('ID: ${tarea.id}'),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                tooltip: 'Editar',
                                icon: const Icon(Icons.edit),
                                onPressed: () =>
                                    _editarTarea(tarea),
                              ),
                              IconButton(
                                tooltip: 'Eliminar',
                                icon: const Icon(
                                  Icons.delete_outline,
                                ),
                                onPressed: () =>
                                    _eliminarTarea(tarea),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
