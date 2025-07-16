import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mbarete_padel/domain/repositories/user_repository.dart';
import 'package:mbarete_padel/infraestructure/datasources/user_datasource_impl.dart';
import 'package:mbarete_padel/infraestructure/repositories/user_repository_impl.dart';

final userRepositoryProvider = Provider<UserRepository>((ref) {
  final userRepository = UserRepositoryImpl(datasource: UserDatasourceImpl());
  return userRepository;
});
