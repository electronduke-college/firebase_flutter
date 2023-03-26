import 'package:firebase_auth2/presentation/di/profile_holder.dart';
import 'package:get_it/get_it.dart';

import '../../data/repositories_impl/auth_repository_impl.dart';
import '../../domain/repositories/auth_repository.dart';

class AppModule {
  static bool _provided = false;

  void provideDependencies() {
    if (_provided) return;
    _provideAuthRepository();
    _provideProfileHolder();
    _provided = true;
  }

  void _provideAuthRepository() {
    GetIt.instance.registerSingleton(AuthRepositoryImpl());
  }

  static AuthRepository getAuthRepository() {
    return GetIt.instance.get<AuthRepositoryImpl>();
  }

  void _provideProfileHolder() {
    GetIt.instance.registerSingleton(ProfileHolder());
  }

  static ProfileHolder getProfileHolder() {
    return GetIt.instance.get<ProfileHolder>();
  }
}
