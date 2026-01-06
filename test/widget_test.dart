import 'package:flutter_test/flutter_test.dart';
import 'package:bongpal/main.dart';

void main() {
  testWidgets('앱 시작 테스트', (WidgetTester tester) async {
    await tester.pumpWidget(const SubbyApp());
    expect(find.text('이번 달 고정비'), findsOneWidget);
  });
}
