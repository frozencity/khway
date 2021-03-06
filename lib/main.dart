import 'package:flutter/material.dart';
import 'package:backdrop/backdrop.dart';
import 'package:timelines/timelines.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  runApp(ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.red,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        textButtonTheme: TextButtonThemeData(
          style: ButtonStyle(
            foregroundColor: MaterialStateProperty.all(Colors.white),
            overlayColor: MaterialStateProperty.all(Colors.black12),
          ),
        ),
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: Colors.white,
          foregroundColor: Colors.red,
        ),
      ),
      home: MyHomePage(title: 'Doggy Style'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return BackdropScaffold(
      appBar: BackdropAppBar(
        title: Consumer(
          // Consumer is a widget from Riverpod that conumes provided provider
          // that was providing the value.
          builder: (context, watch, child) {
            // Listens to the value exposed by counterProvider
            String title = watch(titleProvider.state);
            return InkWell(
              child: Text('$title'),
              onTap: () => (Backdrop.of(context).isBackLayerConcealed)
                  ? Backdrop.of(context).revealBackLayer()
                  : Backdrop.of(context).concealBackLayer(),
            );
          },
        ),
        actions: <Widget>[
          BackdropToggleButton(
            icon: AnimatedIcons.close_menu,
          )
        ],
      ),
      backLayer: BackLayer(),
      frontLayer: Center(
        child: FrontLayer(),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.map_rounded),
        onPressed: () {},
      ),
    );
  }
}

// BackLayer is a back layer of a backdrop widget.
class BackLayer extends StatelessWidget {
  final townships = [
    "အကုန်လုံး",
    "မြေနီကုန်း / စမ်းချောင်း",
    "လှည်းတန်း / ကမာရွတ်",
    "မြို့ထဲ / ဆူးလေ",
    "မြောက်ဥက္ကလာ",
    "တောင်ဥက္ကလာ",
    "မြောက်ဒဂုံ",
    "သာကေတ",
    "အခြား",
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: List.generate(
            townships.length,
            (index) => Container(
              margin: EdgeInsets.symmetric(
                vertical: 16.0,
              ),
              child: TextButton(
                child: Text(
                  townships[index],
                  style: TextStyle(fontSize: 16),
                ),
                onPressed: () {
                  context.read(titleProvider).setTitle(townships[index]);
                  Backdrop.of(context).concealBackLayer();
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class FrontLayer extends StatelessWidget {
  final time = [
    "9:00 PM",
    "8:00 PM",
    "7:00 PM",
    "6:00 PM",
    "5:00 PM",
    "4:00 PM",
    "3:00 PM",
    "2:00 PM",
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Timeline.tileBuilder(
        theme: TimelineThemeData(
          color: Colors.red,
        ),
        builder: TimelineTileBuilder.fromStyle(
          nodePositionBuilder: (context, index) => 0.2,
          contentsAlign: ContentsAlign.basic,
          contentsBuilder: (context, index) => NewsBox(),
          oppositeContentsBuilder: (context, index) => Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(time[index]),
          ),
          itemCount: time.length,
        ),
      ),
    );
  }
}

class NewsBox extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Card(
        child: Padding(
          padding: EdgeInsets.all(12.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                  "မအေလိုး မင်းအောင်လှိုင်၊ ကိုမေကိုလိုး မင်းအောင်လှိုင်၊ ကျွဲဲလိုးနွားလိုး ခံရပြီး သေမယ့် တိုင်းပြည်သစ္စာဖောက် အဖျက်သမား၊ လီးပဲ။"),
              Container(
                margin: EdgeInsets.only(top: 16.0),
                child: Chip(
                  label: Text(
                    "# မြောက်ဥက္ကလာ",
                    style: TextStyle(fontSize: 12),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

final titleProvider = StateNotifierProvider((ref) => TitleName());

class TitleName extends StateNotifier<String> {
  TitleName() : super("အစုံအလင်");
  void setTitle(value) => state = value;
}
