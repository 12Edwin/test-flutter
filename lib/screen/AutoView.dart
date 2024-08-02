// lib/screen/AutoView.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/CubitAuto.dart';
import '../model/Auto.dart';

class AutoView extends StatelessWidget {
  const AutoView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Gestión de Autos')),
      body: BlocBuilder<AutoCubit, AutoState>(
        builder: (context, state) {
          if (state is AutoLoading) {
            return Center(child: CircularProgressIndicator());
          } else if (state is AutoLoaded) {
            return ListView.builder(
              itemCount: state.autos.length,
              itemBuilder: (context, index) {
                final auto = state.autos[index];
                return ListTile(
                  title: Text('${auto.marca} ${auto.modelo}'),
                  subtitle: Text('Autonomía: ${auto.autonomiaElectrica} km'),
                  trailing: IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () => context.read<AutoCubit>().deleteAuto(auto.id),
                  ),
                  onTap: () => _showEditDialog(context, auto),
                );
              },
            );
          } else if (state is AutoError) {
            return Center(child: Text(state.message));
          }
          return Center(child: Text('Carga los autos'));
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => _showAddDialog(context),
      ),
    );
  }

  void _showAddDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => BlocProvider.value(
        value: BlocProvider.of<AutoCubit>(context),
        child: _AutoForm(
          onSubmit: (auto) {
            BlocProvider.of<AutoCubit>(dialogContext).addAuto(auto);
            Navigator.of(dialogContext).pop();
          },
        ),
      ),
    );
  }

  void _showEditDialog(BuildContext context, Auto auto) {
    showDialog(
      context: context,
      builder: (dialogContext) => BlocProvider.value(
        value: BlocProvider.of<AutoCubit>(context),
        child: _AutoForm(
          auto: auto,
          onSubmit: (updatedAuto) {
            BlocProvider.of<AutoCubit>(dialogContext).updateAuto(updatedAuto);
            Navigator.of(dialogContext).pop();
          },
        ),
      ),
    );
  }
}

class _AutoForm extends StatefulWidget {
  final Auto? auto;
  final Function(Auto) onSubmit;

  const _AutoForm({this.auto, required this.onSubmit});

  @override
  __AutoFormState createState() => __AutoFormState();
}

class __AutoFormState extends State<_AutoForm> {
  late TextEditingController _marcaController;
  late TextEditingController _modeloController;
  late TextEditingController _autonomiaController;
  late TextEditingController _consumoController;

  @override
  void initState() {
    super.initState();
    _marcaController = TextEditingController(text: widget.auto?.marca ?? '');
    _modeloController = TextEditingController(text: widget.auto?.modelo ?? '');
    _autonomiaController = TextEditingController(text: widget.auto?.autonomiaElectrica.toString() ?? '');
    _consumoController = TextEditingController(text: widget.auto?.consumoCombustible.toString() ?? '');
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.auto == null ? 'Añadir Auto' : 'Editar Auto'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(controller: _marcaController, decoration: InputDecoration(labelText: 'Marca')),
          TextField(controller: _modeloController, decoration: InputDecoration(labelText: 'Modelo')),
          TextField(controller: _autonomiaController, decoration: InputDecoration(labelText: 'Autonomía Eléctrica'), keyboardType: TextInputType.number),
          TextField(controller: _consumoController, decoration: InputDecoration(labelText: 'Consumo Combustible'), keyboardType: TextInputType.number),
        ],
      ),
      actions: [
        TextButton(
          child: Text('Cancelar'),
          onPressed: () => Navigator.of(context).pop(),
        ),
        ElevatedButton(
          child: Text('Guardar'),
          onPressed: () {
            final auto = Auto(
              id: widget.auto?.id ?? 0,
              marca: _marcaController.text,
              modelo: _modeloController.text,
              autonomiaElectrica: _autonomiaController.text,
              consumoCombustible: _consumoController.text,
            );
            widget.onSubmit(auto);
          },
        ),
      ],
    );
  }

  @override
  void dispose() {
    _marcaController.dispose();
    _modeloController.dispose();
    _autonomiaController.dispose();
    _consumoController.dispose();
    super.dispose();
  }
}