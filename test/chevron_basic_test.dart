import "package:test/test.dart";
import 'package:xmlstream/xmlstream.dart';

main() {
  var rawText = '<?xml version="1.0" encoding="UTF-8"?><hello attr="flow">all < SvelteKit & SvelteKit > all</hello>';

  var states = [XmlState.StartDocument, XmlState.Top, XmlState.Open, XmlState.Attribute, XmlState.Text, XmlState.Closed, XmlState.EndDocument];
  var values = ["", "", "hello", "flow", "all < SvelteKit & SvelteKit > all", "hello", ""];
  int count = 0;

  var xmlStreamer = new XmlStreamer(rawText);
  test('basic chevrons in simple text', () {
    xmlStreamer.read().listen((e) {
      expect(e.state, states[count]);
      expect(e.value, values[count]);
      count++;
    });
  });
}
