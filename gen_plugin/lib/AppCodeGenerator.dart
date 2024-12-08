import 'dart:async';

import 'package:annotation/annotation.dart';
import 'package:build/build.dart';
import 'package:source_gen/source_gen.dart';

Builder appCodeGenerator(BuilderOptions options) => SharedPartBuilder(
      [AppCodeGenerator()],
      'codegen', // 生成的部分文件的名称
    );

Builder appCodeGeneratorPart(BuilderOptions options) => PartBuilder(
      [AppCodeGenerator()],
      '*.codegen.g.dart', // 生成的部分文件的名称
    );

Builder appCodeGeneratorLibrary(BuilderOptions options) => LibraryBuilder(AppCodeGenerator(), generatedExtension: ".g.dart");

class AppCodeGenerator extends Generator {
  @override
  FutureOr<String?> generate(LibraryReader library, BuildStep buildStep) async {
    // ToJsonEntity;
    // const TypeChecker.fromRuntime(JsonSerializable);
    var toJETC = const TypeChecker.fromRuntime(ToJsonEntity);
    //
    final annotatedClasses = library.annotatedWith(toJETC);
    if (annotatedClasses.isNotEmpty) {
      print("测试：是否启用 ${annotatedClasses.map((e) => e.element.name).toList()}");
    }

    final buffer = StringBuffer();
    for (var value in annotatedClasses) {
      // final annotation = value.annotation;
      final classElement = value.element;
      final className = classElement.name;
      // final annotationValue = annotation.getField('value').toStringValue();

      buffer.writeln("class ${className}JsonData extends JsonEntityData<$className> {");
      buffer.writeln("@override");
      buffer.writeln("$className createForMap(Map<String, dynamic> map) {");
      buffer.writeln('return $className.fromJson(map);');
      buffer.writeln('}');
      buffer.writeln();
      buffer.writeln("@override");
      buffer.writeln("$className emptyReturn() {");
      buffer.writeln('return $className();');
      buffer.writeln('}');
      buffer.writeln();
      buffer.writeln('}');

      buffer.writeln();
      buffer.writeln("");

      // // 使用注解信息生成代码
      // buffer.writeln('class ${className}Generated {');
      // // buffer.writeln('  String get message => "$annotationValue";');
      // buffer.writeln('}');
    }

    buffer.writeln(execToRegister(library));
    buffer.writeln(execToJsonConverter(library));
    return buffer.toString();
  }

  String execToRegister(LibraryReader library) {
    final Iterable<AnnotatedElement> annotatedClasses = library.annotatedWith(const TypeChecker.fromRuntime(RegisterRoleGenerator));
    final buffer = StringBuffer();
    for (AnnotatedElement value in annotatedClasses) {
      var className = value.element.name;
      var types = value.annotation
          .read("types")
          .listValue
          .map((e) => e.toString().substring("Type (".length, e.toString().length - 1))
          // .map((e) => e.toString())
          .toList();
      print("types : ${types}");
      buffer.writeln("extension ${className}RoleGeneratorExtends on ${className} {");
      buffer.writeln("List<RoleGenerator> get _\$Generators => [");
      for (var item in types) {
        buffer.writeln("${item}(factory: this),");
      }
      buffer.writeln("];");
      buffer.writeln();
      buffer.writeln();
      buffer.writeln("  Map<Role, RoleGenerator> get _\$GeneratorMap {");
      buffer.writeln("    Map<Role, RoleGenerator> map = {};");
      buffer.writeln("    for (var value in _\$Generators) {");
      buffer.writeln("      map[value.role] = value;");
      buffer.writeln("    }");
      buffer.writeln("    return map;");
      buffer.writeln("  }");
      buffer.writeln("  RoleGenerator? getRoleGenerator(Role role) => _\$GeneratorMap[role];");
      buffer.writeln();

      buffer.writeln(nightTranCode);
      buffer.writeln("");
      buffer.writeln(dayTranCode);
      buffer.writeln("");
      buffer.writeln("}");
    }

    return buffer.toString();
  }

  var nightTranCode = (StringBuffer()
        ..writeln("Map<Role, JsonEntityData<RoleAction>> _\$nightActionJsonTransition(")
        ..writeln("  GameFactory factory,")
        ..writeln(") {")
        ..writeln("  Map<Role, JsonEntityData<RoleAction>> map = {};")
        ..writeln("  for (var value in _\$Generators) {")
        ..writeln("    var action = value.getNightRoundGenerator(NightFactory(0, factory))?.actionJsonConvertor();")
        ..writeln("    if (action == null) continue;")
        ..writeln("    map[value.role] = action;")
        ..writeln("  }")
        ..writeln("  return map;")
        ..writeln("}")
        ..writeln("")
        ..writeln(""))
      .toString();

  var dayTranCode = (StringBuffer()
        ..writeln("Map<Role, JsonEntityData<RoleAction>> _\$dayActionJsonTransition(")
        ..writeln("  GameFactory factory,")
        ..writeln(") {")
        ..writeln("  Map<Role, JsonEntityData<RoleAction>> map = {};")
        ..writeln("  for (var value in _\$Generators) {")
        ..writeln("    var action = value.getDayRoundGenerator(DayFactory(0, factory))?.actionJsonConvertor();")
        ..writeln("    if (action == null) continue;")
        ..writeln("    map[value.role] = action;")
        ..writeln("  }")
        ..writeln("  return map;")
        ..writeln("}")
        ..writeln("")
        ..writeln(""))
      .toString();

  String execToJsonConverter(LibraryReader library) {
    // ToJsonConverter
    final Iterable<AnnotatedElement> annotatedClasses = library.annotatedWith(const TypeChecker.fromRuntime(ToJsonConverter));
    final buffer = StringBuffer();
    for (AnnotatedElement value in annotatedClasses) {
      var className = value.element.name;
      // value.element
      buffer.writeln("");
      buffer.writeln("/// $className 数据库转换器");
      buffer.writeln(""
          "class ${className}DriftConverter "
          "extends drift.TypeConverter<$className?, String?> "
          "with drift.JsonTypeConverter<$className?, String?> {");
      buffer.writeln("");
      buffer.writeln("const ${className}DriftConverter();");
      buffer.writeln("");
      buffer.writeln("  @override");
      buffer.writeln("  $className? fromSql(String? fromDb) {");
      buffer.writeln("    if(null == fromDb) return null;");
      buffer.writeln("    return _\$${className}FromJson(jsonDecode(fromDb));");
      buffer.writeln("  }");
      buffer.writeln("  @override");
      buffer.writeln("  String? toSql($className? value) {");
      buffer.writeln("    if(null == value) return null;");
      buffer.writeln("    return jsonEncode(_\$${className}ToJson(value));");
      buffer.writeln("  }");
      buffer.writeln("}");
      buffer.writeln("");
      buffer.writeln("");
    }

    return buffer.toString();
  }
}
