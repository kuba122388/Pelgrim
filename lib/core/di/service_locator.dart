import 'package:get_it/get_it.dart';
import 'package:pelgrim/data/repositories/announcement_repository_impl.dart';
import 'package:pelgrim/data/repositories/contact_repository_impl.dart';
import 'package:pelgrim/data/sources/announcement_service.dart';
import 'package:pelgrim/data/sources/auth_service.dart';
import 'package:pelgrim/data/sources/contact_service.dart';
import 'package:pelgrim/data/sources/group_service.dart';
import 'package:pelgrim/data/sources/user_service.dart';
import 'package:pelgrim/domain/repositories/announcement_repository.dart';
import 'package:pelgrim/domain/repositories/contact_repository.dart';
import 'package:pelgrim/domain/usecases/announcement/add_announcement_usecase.dart';
import 'package:pelgrim/domain/usecases/announcement/delete_announcement_usecase.dart';
import 'package:pelgrim/domain/usecases/announcement/get_announcements_stream_usecase.dart';
import 'package:pelgrim/domain/usecases/contact/get_contact_info_usecase.dart';
import 'package:pelgrim/domain/usecases/contact/save_contact_info_usecase.dart';
import 'package:pelgrim/presentation/providers/announcement_provider.dart';
import 'package:pelgrim/presentation/providers/contact_provider.dart';

final sl = GetIt.instance;

void setupLocator() {
  // --- 1. Data Sources (Services) ---
  sl.registerLazySingleton<AuthService>(() => AuthService());
  sl.registerLazySingleton<GroupService>(() => GroupService());
  sl.registerLazySingleton<UserService>(() => UserService());
  sl.registerLazySingleton<AnnouncementService>(() => AnnouncementService());
  sl.registerLazySingleton<ContactService>(() => ContactService());

  // --- 2. Repositories ---
  sl.registerLazySingleton<AnnouncementRepository>(
    () => AnnouncementRepositoryImpl(sl<AnnouncementService>()),
  );
  sl.registerLazySingleton<ContactRepository>(() => ContactRepositoryImpl(sl<ContactService>()));

  // --- 3. Use Cases ---
  sl.registerLazySingleton(() => AddAnnouncementUseCase(sl<AnnouncementRepository>()));
  sl.registerLazySingleton(() => DeleteAnnouncementUseCase(sl<AnnouncementRepository>()));
  sl.registerLazySingleton(() => GetAnnouncementsStreamUseCase(sl<AnnouncementRepository>()));
  sl.registerLazySingleton(() => GetContactInfoUseCase(sl<ContactRepository>()));
  sl.registerLazySingleton(() => SaveContactInfoUseCase(sl<ContactRepository>()));

  // --- 4. Providers ---
  sl.registerFactory(
    () => AnnouncementProvider(
      sl<AddAnnouncementUseCase>(),
      sl<DeleteAnnouncementUseCase>(),
      sl<GetAnnouncementsStreamUseCase>(),
    ),
  );

  sl.registerFactory(
    () => ContactProvider(sl<GetContactInfoUseCase>(), sl<SaveContactInfoUseCase>()),
  );
}
