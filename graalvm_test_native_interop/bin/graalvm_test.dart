import 'package:jni/jni.dart';
import 'package:path/path.dart';
import 'package:graalvm_test/graal/org/graalvm/polyglot/_package.dart' as graal;

void main(List<String> arguments) {
  Jni.spawn(
    dylibDir: join('build', 'jni_libs'),
    classPath: [
      './mvn_jar/collections-24.2.2.jar',
      './mvn_jar/icu4j-24.2.2.jar',
      './mvn_jar/jniutils-24.2.2.jar',
      './mvn_jar/js-language-24.2.2.jar',
      './mvn_jar/nativebridge-24.2.2.jar',
      './mvn_jar/nativeimage-24.2.2.jar',
      './mvn_jar/polyglot-24.2.2.jar',
      './mvn_jar/regex-24.2.2.jar',
      './mvn_jar/truffle-api-24.2.2.jar',
      './mvn_jar/truffle-compiler-24.2.2.jar',
      './mvn_jar/truffle-enterprise-24.2.2.jar',
      './mvn_jar/truffle-runtime-24.2.2.jar',
      './mvn_jar/word-24.2.2.jar',
      './mvn_jar/xz-24.2.2.jar'
    ],
  );

  var jsCode = "(function myFun(param){console.log('Hello ' + param + ' from JS');})";

  var langs = JArray.of(JString.type, ["js".toJString()]);
  var context = graal.Context.create(langs);
  var value = context?.eval$1("js".toJString(), jsCode.toJString());
  print(value);
  value?.execute(JArray.of(JString.type, ["World".toJString()]));
  return;
}

