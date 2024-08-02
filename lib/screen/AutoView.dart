import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/CubitAuto.dart';
import '../model/Auto.dart';

class AutoView extends StatefulWidget {
  const AutoView({Key? key}) : super(key: key);

  @override
  _AutoViewState createState() => _AutoViewState();
}

class _AutoViewState extends State<AutoView> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _marcaController;
  late TextEditingController _modeloController;
  late TextEditingController _autonomiaController;
  late TextEditingController _consumoController;
  Auto? _editingAuto;

  @override
  void initState() {
    super.initState();
    _marcaController = TextEditingController();
    _modeloController = TextEditingController();
    _autonomiaController = TextEditingController();
    _consumoController = TextEditingController();
  }

  @override
  void dispose() {
    _marcaController.dispose();
    _modeloController.dispose();
    _autonomiaController.dispose();
    _consumoController.dispose();
    super.dispose();
  }

  void _resetForm() {
    _editingAuto = null;
    _marcaController.clear();
    _modeloController.clear();
    _autonomiaController.clear();
    _consumoController.clear();
  }

  void _setFormForEditing(Auto auto) {
    _editingAuto = auto;
    _marcaController.text = auto.marca;
    _modeloController.text = auto.modelo;
    _autonomiaController.text = auto.autonomiaElectrica.toString();
    _consumoController.text = auto.consumoCombustible.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Gestión de Autos')),
      body: Column(
        children: [
          Expanded(
            child: BlocBuilder<AutoCubit, AutoState>(
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
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: Icon(Icons.edit),
                              onPressed: () => _setFormForEditing(auto),
                            ),
                            IconButton(
                              icon: Icon(Icons.delete),
                              onPressed: () => context.read<AutoCubit>().deleteAuto(auto.id),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                } else if (state is AutoError) {
                  return Center(child: Text(state.message));
                }
                return Center(child: Text('Carga los autos'));
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: _marcaController,
                    decoration: InputDecoration(labelText: 'Marca'),
                    validator: (value) => value?.isEmpty ?? true ? 'Este campo es requerido' : null,
                  ),
                  TextFormField(
                    controller: _modeloController,
                    decoration: InputDecoration(labelText: 'Modelo'),
                    validator: (value) => value?.isEmpty ?? true ? 'Este campo es requerido' : null,
                  ),
                  TextFormField(
                    controller: _autonomiaController,
                    decoration: InputDecoration(labelText: 'Autonomía Eléctrica'),
                    keyboardType: TextInputType.number,
                    validator: (value) => value?.isEmpty ?? true ? 'Este campo es requerido' : null,
                  ),
                  TextFormField(
                    controller: _consumoController,
                    decoration: InputDecoration(labelText: 'Consumo Combustible'),
                    keyboardType: TextInputType.number,
                    validator: (value) => value?.isEmpty ?? true ? 'Este campo es requerido' : null,
                  ),
                  SizedBox(height: 10),
                  ElevatedButton(
                    child: Text(_editingAuto == null ? 'Añadir Auto' : 'Actualizar Auto'),
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        final auto = Auto(
                          id: _editingAuto?.id ?? 0,
                          marca: _marcaController.text,
                          modelo: _modeloController.text,
                          autonomiaElectrica: _autonomiaController.text,
                          consumoCombustible: _consumoController.text,
                        );
                        if (_editingAuto == null) {
                          context.read<AutoCubit>().addAuto(auto);
                        } else {
                          context.read<AutoCubit>().updateAuto(auto);
                        }
                        _resetForm();
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}