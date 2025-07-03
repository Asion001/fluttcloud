import 'package:test/test.dart';

// Import the generated test helper file, it contains everything you need.
import 'test_tools/serverpod_test_tools.dart';

void main() {
  withServerpod('Given Greeting endpoint', (sessionBuilder, endpoints) {
    test(
      'when calling `hello` with name then returned greeting includes name',
      () async {
        // Call the endpoint method by using the `endpoints` parameter and
        // pass `sessionBuilder` as a first argument. Refer to the docs on
        // how to use the `sessionBuilder` to set up different test scenarios.
        final greeting = await endpoints.greeting.hello(sessionBuilder, 'Bob');
        expect(greeting.message, 'Hello Bob');
      },
    );
  });
}
