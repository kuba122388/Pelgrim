import 'package:get_it/get_it.dart';
import 'package:pelgrim/data/datasources/announcement_datasource.dart';
import 'package:pelgrim/data/datasources/auth_datasource.dart';
import 'package:pelgrim/data/datasources/contact_datasource.dart';
import 'package:pelgrim/data/datasources/group_datasource.dart';
import 'package:pelgrim/data/datasources/user_datasource.dart';
import 'package:pelgrim/data/repositories/announcement_repository_impl.dart';
import 'package:pelgrim/data/repositories/contact_repository_impl.dart';
import 'package:pelgrim/domain/repositories/announcement_repository.dart';
import 'package:pelgrim/domain/repositories/contact_repository.dart';
import 'package:pelgrim/domain/usecases/announcement/add_announcement_use_case.dart';
import 'package:pelgrim/domain/usecases/announcement/delete_announcement_use_case.dart';
import 'package:pelgrim/domain/usecases/announcement/get_announcements_stream_use_case.dart';
import 'package:pelgrim/domain/usecases/contact/get_contact_info_use_case.dart';
import 'package:pelgrim/domain/usecases/contact/save_contact_info_use_case.dart';
import 'package:pelgrim/presentation/providers/announcement_provider.dart';
import 'package:pelgrim/presentation/providers/contact_provider.dart';

final sl = GetIt.instance;

void setupLocator() {
  // --- 1. Data Sources (Services) ---
  sl.registerLazySingleton<AuthDataSource>(() => AuthDataSource());
  sl.registerLazySingleton<GroupDataSource>(() => GroupDataSource());
  sl.registerLazySingleton<UserDataSource>(() => UserDataSource());
  sl.registerLazySingleton<AnnouncementDataSource>(() => AnnouncementDataSource());
  sl.registerLazySingleton<ContactDataSource>(() => ContactDataSource());

  // --- 2. Repositories ---
  sl.registerLazySingleton<AnnouncementRepository>(
    () => AnnouncementRepositoryImpl(sl<AnnouncementDataSource>()),
  );
  sl.registerLazySingleton<ContactRepository>(() => ContactRepositoryImpl(sl<ContactDataSource>()));

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
