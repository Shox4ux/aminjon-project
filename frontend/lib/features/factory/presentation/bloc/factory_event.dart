import 'package:equatable/equatable.dart';

abstract class FactoryEvent extends Equatable {
  const FactoryEvent();
  @override
  List<Object?> get props => [];
}

class LoadFactories extends FactoryEvent {
  final String? name;
  final String? productName;
  final String? category;
  const LoadFactories({this.name, this.productName, this.category});
  @override
  List<Object?> get props => [name, productName, category];
}

class CreateFactory extends FactoryEvent {
  final Map<String, dynamic> data;
  const CreateFactory(this.data);
  @override
  List<Object?> get props => [data];
}

class UpdateFactory extends FactoryEvent {
  final int id;
  final Map<String, dynamic> data;
  const UpdateFactory(this.id, this.data);
  @override
  List<Object?> get props => [id, data];
}

class DeleteFactory extends FactoryEvent {
  final int id;
  const DeleteFactory(this.id);
  @override
  List<Object?> get props => [id];
}
