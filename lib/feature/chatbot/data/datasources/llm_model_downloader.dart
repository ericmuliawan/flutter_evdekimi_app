abstract class ILlmModelDownloader {
  Future<String> get modelFilePath;
  Future<bool> isModelDownloaded();
  Future<void> download({
    void Function(int received, int total)? onProgress,
  });
}
