part of auth0_flutter;

typedef ExceptionHandler = Exception Function(PlatformException exception);

Future<T> invokeMethod<T>(
    {@required MethodChannel channel,
    @required String method,
    @required dynamic arguments,
    @required ExceptionHandler exceptionHandler}) async {
  try {
    final result = await channel.invokeMethod<T>(method, arguments);

    return result;
  } on PlatformException catch (e) {
    final error = exceptionHandler(e);

    throw error;
  }
}

Future<Map<K, V>> invokeMapMethod<K, V>(
    {@required MethodChannel channel,
    @required String method,
    @required dynamic arguments,
    @required ExceptionHandler exceptionHandler}) async {
  try {
    final result = await channel.invokeMapMethod<K, V>(method, arguments);

    return result;
  } on PlatformException catch (e) {
    final error = exceptionHandler(e);

    throw error;
  }
}

Future<List<T>> invokeListMethod<T>(
    {@required MethodChannel channel,
    @required String method,
    @required dynamic arguments,
    @required ExceptionHandler exceptionHandler}) async {
  try {
    final result = await channel.invokeListMethod<T>(method, arguments);
    return result;
  } on PlatformException catch (e) {
    final error = exceptionHandler(e);

    throw error;
  }
}
