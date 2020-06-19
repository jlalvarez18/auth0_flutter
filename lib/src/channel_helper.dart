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

    if (error != null) {
      throw error;
    }

    return null;
  }
}

Future<Map<K, V>> invokeMapMethod<K, V>(
    {@required MethodChannel channel,
    @required String method,
    @required dynamic arguments,
    @required ExceptionHandler exceptionHandler}) async {
  try {
    final result = await channel.invokeMapMethod(method, arguments);

    final Map<K, V> map = Map.castFrom(result);

    return map;
  } on PlatformException catch (e) {
    final error = exceptionHandler(e);

    if (error != null) {
      throw error;
    }

    return null;
  }
}

Future<List<T>> invokeListMethod<T>(
    {@required MethodChannel channel,
    @required String method,
    @required dynamic arguments,
    @required ExceptionHandler exceptionHandler}) async {
  try {
    final result = await channel.invokeListMethod(method, arguments);

    final List<T> list = List.castFrom(result);

    return list;
  } on PlatformException catch (e) {
    final error = exceptionHandler(e);

    if (error != null) {
      throw error;
    }

    return null;
  }
}
