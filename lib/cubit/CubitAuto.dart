// lib/cubits/auto_cubit.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import '../helper/Service.dart';
import '../model/Auto.dart';

// Estados del Cubit
abstract class AutoState {}

class AutoInitial extends AutoState {}
class AutoLoading extends AutoState {}
class AutoLoaded extends AutoState {
  final List<Auto> autos;
  AutoLoaded(this.autos);
}
class AutoError extends AutoState {
  final String message;
  AutoError(this.message);
}

class AutoCubit extends Cubit<AutoState> {
  final AutoRepository repository;

  AutoCubit(this.repository) : super(AutoInitial());

  Future<void> loadAutos() async {
    emit(AutoLoading());
    try {
      final autos = await repository.getAutos();
      emit(AutoLoaded(autos));
    } catch (e) {
      emit(AutoError('Error al cargar los autos: $e'));
    }
  }

  Future<void> addAuto(Auto auto) async {
    emit(AutoLoading());
    try {
      await repository.createAuto(auto);
      await loadAutos();
    } catch (e) {
      emit(AutoError('Error al añadir el auto: $e'));
    }
  }

  Future<void> updateAuto(Auto auto) async {
    emit(AutoLoading());
    try {
      await repository.updateAuto(auto);
      await loadAutos();
    } catch (e) {
      emit(AutoError('Error al actualizar el auto: $e'));
    }
  }

  Future<void> deleteAuto(int id) async {
    emit(AutoLoading());
    try {
      await repository.deleteAuto(id);
      await loadAutos();
    } catch (e) {
      emit(AutoError('Error al eliminar el auto: $e'));
    }
  }
}