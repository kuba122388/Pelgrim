import '../../repositories/informant_repository.dart';

class DeleteInformantImageUseCase {
  final InformantRepository _informantRepository;

  DeleteInformantImageUseCase(this._informantRepository);

  Future<void> execute(String imageUrl) {
    return _informantRepository.deleteImage(imageUrl);
  }
}
