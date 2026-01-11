import 'package:get_it/get_it.dart';
import 'package:pelgrim/data/datasources/local/local_song_list_storage.dart';
import 'package:pelgrim/data/datasources/local/local_user_storage.dart';
import 'package:pelgrim/data/datasources/remote/announcement_datasource.dart';
import 'package:pelgrim/data/datasources/remote/auth_datasource.dart';
import 'package:pelgrim/data/datasources/remote/contact_datasource.dart';
import 'package:pelgrim/data/datasources/remote/duty_datasource.dart';
import 'package:pelgrim/data/datasources/remote/group_datasource.dart';
import 'package:pelgrim/data/datasources/remote/song_datasource.dart';
import 'package:pelgrim/data/datasources/remote/user_datasource.dart';
import 'package:pelgrim/data/repositories/announcement_repository_impl.dart';
import 'package:pelgrim/data/repositories/auth_repository_impl.dart';
import 'package:pelgrim/data/repositories/contact_repository_impl.dart';
import 'package:pelgrim/data/repositories/duty_repository_impl.dart';
import 'package:pelgrim/data/repositories/group_repository_impl.dart';
import 'package:pelgrim/data/repositories/song_repository_impl.dart';
import 'package:pelgrim/data/repositories/user_repository_impl.dart';
import 'package:pelgrim/data/repositories/user_session_repository_impl.dart';
import 'package:pelgrim/domain/repositories/announcement_repository.dart';
import 'package:pelgrim/domain/repositories/auth_repository.dart';
import 'package:pelgrim/domain/repositories/contact_repository.dart';
import 'package:pelgrim/domain/repositories/duty_repository.dart';
import 'package:pelgrim/domain/repositories/group_repository.dart';
import 'package:pelgrim/domain/repositories/song_repository.dart';
import 'package:pelgrim/domain/repositories/user_repository.dart';
import 'package:pelgrim/domain/repositories/user_session_repository.dart';
import 'package:pelgrim/domain/usecases/announcement/add_announcement_use_case.dart';
import 'package:pelgrim/domain/usecases/announcement/delete_announcement_use_case.dart';
import 'package:pelgrim/domain/usecases/announcement/get_announcements_stream_use_case.dart';
import 'package:pelgrim/domain/usecases/auth/is_user_authenticated_use_case.dart';
import 'package:pelgrim/domain/usecases/auth/sign_in_use_case.dart';
import 'package:pelgrim/domain/usecases/auth/sign_out_use_case.dart';
import 'package:pelgrim/domain/usecases/contact/get_contact_info_use_case.dart';
import 'package:pelgrim/domain/usecases/contact/save_contact_info_use_case.dart';
import 'package:pelgrim/domain/usecases/duty/add_duty_use_case.dart';
import 'package:pelgrim/domain/usecases/duty/delete_duty_use_case.dart';
import 'package:pelgrim/domain/usecases/duty/get_duties_use_case.dart';
import 'package:pelgrim/domain/usecases/duty/toggle_duty_sign_up_use_case.dart';
import 'package:pelgrim/domain/usecases/group/delete_group_use_case.dart';
import 'package:pelgrim/domain/usecases/group/get_all_group_names_use_case.dart';
import 'package:pelgrim/domain/usecases/group/get_group_use_case.dart';
import 'package:pelgrim/domain/usecases/group/set_admin_status_use_case.dart';
import 'package:pelgrim/domain/usecases/session/clear_local_session_use_case.dart';
import 'package:pelgrim/domain/usecases/session/load_local_session_use_case.dart';
import 'package:pelgrim/domain/usecases/session/save_local_session_use_case.dart';
import 'package:pelgrim/domain/usecases/session/sync_user_session_use_case.dart';
import 'package:pelgrim/domain/usecases/song/add_song_use_case.dart';
import 'package:pelgrim/domain/usecases/song/delete_song_use_case.dart';
import 'package:pelgrim/domain/usecases/song/edit_song_use_case.dart';
import 'package:pelgrim/domain/usecases/song/get_local_song_list_use_case.dart';
import 'package:pelgrim/domain/usecases/song/get_song_use_case.dart';
import 'package:pelgrim/domain/usecases/song/stream_song_use_case.dart';
import 'package:pelgrim/domain/usecases/song/watch_playing_now_use_case.dart';
import 'package:pelgrim/domain/usecases/song/watch_song_list_use_case.dart';
import 'package:pelgrim/domain/usecases/user/get_all_users_by_group_use_case.dart';
import 'package:pelgrim/domain/usecases/user/get_user_by_id_use_case.dart';
import 'package:pelgrim/domain/usecases/user/register_admin_create_group_use_case.dart';
import 'package:pelgrim/domain/usecases/user/register_user_join_group_use_case.dart';
import 'package:pelgrim/presentation/providers/contact_provider.dart';
import 'package:pelgrim/presentation/providers/duty_provider.dart';
import 'package:pelgrim/presentation/providers/song_provider.dart';
import 'package:pelgrim/presentation/providers/user_provider.dart';

final sl = GetIt.instance;

void setupLocator() {
  // --- 1. Data Sources (Services) ---
  sl.registerLazySingleton<AnnouncementDataSource>(() => AnnouncementDataSource());
  sl.registerLazySingleton<AuthDataSource>(() => AuthDataSource());
  sl.registerLazySingleton<ContactDataSource>(() => ContactDataSource());
  sl.registerLazySingleton<DutyDataSource>(() => DutyDataSource());
  sl.registerLazySingleton<GroupDataSource>(() => GroupDataSource());
  sl.registerLazySingleton<SongDataSource>(() => SongDataSource());
  sl.registerLazySingleton<UserDataSource>(() => UserDataSource());
  sl.registerLazySingleton<LocalUserStorage>(() => LocalUserStorage());

  // --- 2. Repositories ---
  sl.registerLazySingleton<AnnouncementRepository>(
    () => AnnouncementRepositoryImpl(
      sl<AnnouncementDataSource>(),
    ),
  );
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      sl<AuthDataSource>(),
    ),
  );
  sl.registerLazySingleton<ContactRepository>(
    () => ContactRepositoryImpl(
      sl<ContactDataSource>(),
    ),
  );
  sl.registerLazySingleton<DutyRepository>(
    () => DutyRepositoryImpl(
      sl<DutyDataSource>(),
    ),
  );
  sl.registerLazySingleton<GroupRepository>(
    () => GroupRepositoryImpl(
      sl<GroupDataSource>(),
    ),
  );
  sl.registerLazySingleton<SongRepository>(
    () => SongRepositoryImpl(
      sl<SongDataSource>(),
      sl<LocalSongListStorage>(),
    ),
  );
  sl.registerLazySingleton<UserRepository>(
    () => UserRepositoryImpl(
      sl<UserDataSource>(),
    ),
  );
  sl.registerLazySingleton<UserSessionRepository>(
    () => UserSessionRepositoryImpl(
      sl<LocalUserStorage>(),
    ),
  );

  // --- 3. Use Cases ---
  sl.registerLazySingleton(() => AddAnnouncementUseCase(sl<AnnouncementRepository>()));
  sl.registerLazySingleton(() => DeleteAnnouncementUseCase(sl<AnnouncementRepository>()));
  sl.registerLazySingleton(() => GetAnnouncementsStreamUseCase(sl<AnnouncementRepository>()));

  sl.registerLazySingleton(() => IsUserAuthenticatedUseCase(sl<AuthRepository>()));
  sl.registerLazySingleton(
      () => SignInUseCase(sl<AuthRepository>(), sl<UserRepository>(), sl<GroupRepository>()));
  sl.registerLazySingleton(() => SignOutUseCase(sl<AuthRepository>()));

  sl.registerLazySingleton(() => GetContactInfoUseCase(sl<ContactRepository>()));
  sl.registerLazySingleton(() => SaveContactInfoUseCase(sl<ContactRepository>()));

  sl.registerLazySingleton(() => AddDutyUseCase(sl<DutyRepository>()));
  sl.registerLazySingleton(() => DeleteDutyUseCase(sl<DutyRepository>()));
  sl.registerLazySingleton(() => GetDutiesUseCase(sl<DutyRepository>()));
  sl.registerLazySingleton(() => ToggleDutySignUpUseCase(sl<DutyRepository>()));

  sl.registerLazySingleton(() => DeleteGroupUseCase(sl<GroupRepository>()));
  sl.registerLazySingleton(() => GetAllGroupNamesUseCase(sl<GroupRepository>()));
  sl.registerLazySingleton(() => GetGroupUseCase(sl<GroupRepository>()));
  sl.registerLazySingleton(
      () => SetAdminStatusUseCase(sl<GroupRepository>(), sl<UserRepository>()));

  sl.registerLazySingleton(() => ClearLocalSessionUseCase(sl<UserSessionRepository>()));
  sl.registerLazySingleton(() => LoadLocalSessionUseCase(sl<UserSessionRepository>()));
  sl.registerLazySingleton(() => SaveLocalSessionUseCase(sl<UserSessionRepository>()));
  sl.registerLazySingleton(() => SyncUserSessionUseCase(
      sl<UserRepository>(), sl<GroupRepository>(), sl<UserSessionRepository>()));

  sl.registerLazySingleton(() => AddSongUseCase(sl<SongRepository>()));
  sl.registerLazySingleton(() => DeleteSongUseCase(sl<SongRepository>()));
  sl.registerLazySingleton(() => EditSongUseCase(sl<SongRepository>()));
  sl.registerLazySingleton(() => GetLocalSongListUseCase(sl<SongRepository>()));
  sl.registerLazySingleton(() => GetSongUseCase(sl<SongRepository>()));
  sl.registerLazySingleton(() => StreamSongUseCase(sl<SongRepository>()));
  sl.registerLazySingleton(() => WatchPlayingNowUseCase(sl<SongRepository>()));
  sl.registerLazySingleton(() => WatchSongListUseCase((sl<SongRepository>())));

  sl.registerLazySingleton(() => GetAllUsersByGroupUseCase(sl<UserRepository>()));
  sl.registerLazySingleton(() => GetUserByIdUseCase(sl<UserRepository>()));
  sl.registerLazySingleton(() => RegisterAdminCreateGroupUseCase(
      sl<AuthRepository>(), sl<GroupRepository>(), sl<UserRepository>()));
  sl.registerLazySingleton(() => RegisterUserJoinGroupUseCase(
      sl<AuthRepository>(), sl<GroupRepository>(), sl<UserRepository>()));

  // --- 4. Providers ---
  sl.registerLazySingleton(
    () => ContactProvider(
      sl<GetContactInfoUseCase>(),
      sl<SaveContactInfoUseCase>(),
    ),
  );
  sl.registerLazySingleton(
    () => DutyProvider(
      sl<GetDutiesUseCase>(),
      sl<AddDutyUseCase>(),
      sl<DeleteDutyUseCase>(),
      sl<ToggleDutySignUpUseCase>(),
    ),
  );

  sl.registerLazySingleton(
    () => UserProvider(
      sl<SignInUseCase>(),
      sl<SignOutUseCase>(),
      sl<SaveLocalSessionUseCase>(),
      sl<ClearLocalSessionUseCase>(),
      sl<LoadLocalSessionUseCase>(),
      sl<SyncUserSessionUseCase>(),
      sl<IsUserAuthenticatedUseCase>(),
      sl<RegisterAdminCreateGroupUseCase>(),
      sl<RegisterUserJoinGroupUseCase>(),
      sl<GetAllGroupNamesUseCase>(),
    ),
  );

  sl.registerLazySingleton(
    () => SongProvider(
      sl<GetLocalSongListUseCase>(),
      sl<WatchSongListUseCase>(),
      sl<WatchPlayingNowUseCase>(),
      sl<StreamSongUseCase>(),
      sl<EditSongUseCase>(),
      sl<DeleteSongUseCase>(),
    ),
  );
}
