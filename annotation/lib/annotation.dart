library annotation;

/// A Calculator.
class Calculator {
  /// Returns [value] plus 1.
  int addOne(int value) => value + 1;
}

/// NoSql 键值对数据应该实现的方法，方便从内部获取到实体
abstract class JsonEntityData<T> {
  /// 有数据时返回
  T createForMap(Map<String, dynamic> map);

  /// 没有数据时返回
  T emptyReturn();
}

class ToJsonEntity {
  const ToJsonEntity();
}

class RegisterRoleGenerator {
  final List<Type> types;

  const RegisterRoleGenerator(this.types);
}

class ToJsonConverter {
  const ToJsonConverter();
}
