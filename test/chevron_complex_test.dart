import "package:test/test.dart";
import 'package:xmlstream/xmlstream.dart';

main() {
  var states = [XmlState.StartDocument, XmlState.Top, XmlState.Open, XmlState.Attribute, XmlState.Text, XmlState.Closed, XmlState.EndDocument];

  test('chevron attached to GT and with capital letter right after it', () {
    var values = getValues("<SvelteKit & SvelteKit> yoyo");
    var rawText = '<?xml version="1.0" encoding="UTF-8"?><hello attr="flow"><SvelteKit & SvelteKit> yoyo</hello>';
    var xmlStreamer = new XmlStreamer(rawText, strictTagOpenings: true);
    int count = 0;
    xmlStreamer.read().listen((e) {
      expect(e.state, states[count]);
      expect(e.value, values[count]);
      count++;
    });
  });

  test('chevron with & after it', () {
    var values = getValues("<&SvelteKit & SvelteKit> all");
    var rawText = '<?xml version="1.0" encoding="UTF-8"?><hello attr="flow"><&SvelteKit & SvelteKit> all</hello>';
    var xmlStreamer = new XmlStreamer(rawText, strictTagOpenings: true);
    int count = 0;
    xmlStreamer.read().listen((e) {
      expect(e.state, states[count]);
      expect(e.value, values[count]);
      count++;
    });
  });

  test('chevron with - after it', () {
    var values = getValues("<-SvelteKit & SvelteKit> all");
    var rawText = '<?xml version="1.0" encoding="UTF-8"?><hello attr="flow"><-SvelteKit & SvelteKit> all</hello>';
    var xmlStreamer = new XmlStreamer(rawText, strictTagOpenings: true);
    int count = 0;
    xmlStreamer.read().listen((e) {
      expect(e.state, states[count]);
      expect(e.value, values[count]);
      count++;
    });
  });

  test('chevron with another LT inside it', () {
    var values = getValues("<svelteKit<SvelteKit> all");
    var rawText = '<?xml version="1.0" encoding="UTF-8"?><hello attr="flow"><svelteKit<SvelteKit> all</hello>';
    var xmlStreamer = new XmlStreamer(rawText, strictTagOpenings: true);
    int count = 0;
    xmlStreamer.read().listen((e) {
      expect(e.state, states[count]);
      expect(e.value, values[count]);
      count++;
    });
  });

  test('chevron with & inside it', () {
    var values = getValues("<svelteKit & SvelteKit> all");
    var rawText = '<?xml version="1.0" encoding="UTF-8"?><hello attr="flow"><svelteKit & SvelteKit> all</hello>';
    var xmlStreamer = new XmlStreamer(rawText, strictTagOpenings: true);
    int count = 0;
    xmlStreamer.read().listen((e) {
      expect(e.state, states[count]);
      expect(e.value, values[count]);
      count++;
    });
  });

  test('chevron with simple quotes attributes', () {
    var values = getValues("<sveltekit attr  =  \'hello\'> all");
    var rawText = '<?xml version="1.0" encoding="UTF-8"?><hello attr="flow"><sveltekit attr  =  \'hello\'> all</hello>';
    var xmlStreamer = new XmlStreamer(rawText, strictTagOpenings: true);
    int count = 0;
    xmlStreamer.read().listen((e) {
      expect(e.state, states[count]);
      expect(e.value, values[count]);
      count++;
    });
  });

  test('valid tags with spaced attributes', () {
    var values = getValues("<sveltekit attr  =  \'hello\'> all");
    var rawText = '<?xml version= "1.0" encoding =  "UTF-8"   ?><hello attr   =  "flow"  ><sveltekit attr  =  \'hello\'> all</hello>';
    var xmlStreamer = new XmlStreamer(rawText, strictTagOpenings: true);
    int count = 0;
    xmlStreamer.read().listen((e) {
      expect(e.state, states[count]);
      expect(e.value, values[count]);
      count++;
    });
  });

  test('valid tags without attributes', () {
    var values = ["", "", "hello", "Sveltekit> all", "hello", ""];
    var rawText = '<?xml version="1.0" encoding="UTF-8"?><hello>Sveltekit> all</hello>';
    var states = [XmlState.StartDocument, XmlState.Top, XmlState.Open, XmlState.Text, XmlState.Closed, XmlState.EndDocument];
    var xmlStreamer = new XmlStreamer(rawText, strictTagOpenings: true);
    int count = 0;
    xmlStreamer.read().listen((e) {
      expect(e.state, states[count]);
      expect(e.value, values[count]);
      count++;
    });
  });

  test('chevron with unnamed attribute', () {
    var values = getValues('<sveltekit attr="hello" =""> all');
    var rawText = '<?xml version= "1.0" encoding =  "UTF-8"   ?><hello attr   =  "flow"  ><sveltekit attr="hello" =""> all</hello>';
    var xmlStreamer = new XmlStreamer(rawText, strictTagOpenings: true);
    int count = 0;
    xmlStreamer.read().listen((e) {
      expect(e.state, states[count]);
      expect(e.value, values[count]);
      count++;
    });
  });

  test('chevron with attached attribute', () {
    var values = getValues('<sveltekit attr="hello"f=""> all');
    var rawText = '<?xml version= "1.0" encoding =  "UTF-8"   ?><hello attr   =  "flow"  ><sveltekit attr="hello"f=""> all</hello>';
    var xmlStreamer = new XmlStreamer(rawText, strictTagOpenings: true);
    int count = 0;
    xmlStreamer.read().listen((e) {
      expect(e.state, states[count]);
      expect(e.value, values[count]);
      count++;
    });
  });
}

List<String> getValues(String text) {
  return ["", "", "hello", "flow", text, "hello", ""];
}