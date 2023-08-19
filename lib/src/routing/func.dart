// Copied from https//github.com/helpisdev/utilities/lib/src/utils/functions.dart

/// Calls [producer] with [dependency] and returns the result of [producer] with
/// [dependency] as a parameter if [dependency] is not null, otherwise returns
/// `null`. The result [T1] and the dependency [T2] are distinct types.
T1? produceT1fromT2orNull<T1, T2>(
  final Producer<T1, T2> producer,
  final T2? dependency,
) {
  if (dependency != null) {
    return producer.call(dependency);
  }
  return null;
}

/// Calls [producer] with [dependency] and returns the result of [producer] with
/// [dependency] as a parameter if [dependency] is not null, otherwise returns
/// `null`. The result and the dependency are the same type [T].
T? produceValOrNull<T>(final ProducerOfT<T> producer, final T? dependency) =>
    produceT1fromT2orNull<T, T>(producer, dependency);

/// A function that takes a dependency of type [T2] and produces a value of type
/// [T1].
typedef Producer<T1, T2> = T1? Function(T2 dependency);

/// A function that takes a dependency of type [T] and produces a value of type
/// [T].
typedef ProducerOfT<T> = Producer<T, T>;
