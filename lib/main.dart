import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:flutter_tts/flutter_tts.dart';
import 'package:number_to_words/number_to_words.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_chat_bubble/bubble_type.dart';
import 'package:flutter_chat_bubble/chat_bubble.dart';
import 'package:flutter_chat_bubble/clippers/chat_bubble_clipper_1.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:speech/rate.dart';
import 'package:speech/voice.dart';
void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Voice',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.red,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: SpeechScreen(),
    );
  }
}

class SpeechScreen extends StatefulWidget {
  @override
  _SpeechScreenState createState() => _SpeechScreenState();
}

class _SpeechScreenState extends State<SpeechScreen> {
  var focusNode = new FocusNode();
  final controller = TextEditingController();
  final List<String> names = <String>[];
  final List results = ['Press the button and start speaking'];
  FlutterTts flutterTts = FlutterTts();
  stt.SpeechToText _speech;
  bool _isListening = false;
  String _text = 'Press the button and start speaking';
  String _reply = 'reply';
  double _confidence = 1.0;
  var actualDate = DateTime.now();
  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery. of(context). size. width;
    double height = MediaQuery. of(context). size. height;
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        flexibleSpace: Container(decoration: new BoxDecoration(
            gradient: new LinearGradient(
              colors: [
                Colors.red[600],
                Colors.redAccent
              ]
            ),
          )
        ),
        actions: <Widget>[
          Container(
            margin: EdgeInsets.symmetric(horizontal:10, vertical:5),
            decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            gradient: LinearGradient(
            colors: [
                Colors.red[600],
                Colors.red[500]
              ]
            ),
          ),
              child: IconButton(icon: Icon(Icons.clear), onPressed: () {
              names.clear();
              results.clear();
              results.insert(results.length,'Press the button and start speaking');
            }),
          ),
        ],
        title: Text('Voice Assistant', style: GoogleFonts.raleway(),),
      ),
      floatingActionButtonLocation:FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
        Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: SizedBox(
            width: width-100,
            child: TextFormField(
              controller: controller,
              decoration: InputDecoration(
                  labelText: 'Type here',
                  labelStyle: GoogleFonts.raleway(),
                  contentPadding: const EdgeInsets.all(15.0),
                  border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(50),
                ),
                suffixIcon: IconButton(
                  onPressed: _send,
                  icon: Icon(Icons.send),
                ),
              ),
            ),
          ),
        ),
            AvatarGlow(
              animate: _isListening,
              glowColor: Theme.of(context).primaryColor,
              endRadius: 25.0,
              duration: const Duration(milliseconds: 2000),
              repeatPauseDuration: const Duration(milliseconds: 100),
              repeat: true,
              child: GestureDetector(
                onTap:(){
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return VoicePay();
                    },
                  );
                },
                  child: FloatingActionButton(
                  onPressed: _listen,
                  child: Icon(_isListening ? Icons.mic : Icons.mic_none),
                ),
              ),
            )
          ],
        ),
      ),
      body:
      SizedBox(
        width: width,
        height: height-150,
        child: Row(
          children: <Widget>[
            Flexible(
              child:  ListView.builder(
                itemCount: results.length,
                itemBuilder: (context, index) {
                  final item = results[index];
                  if(index % 2 == 1){}
                  return ChatBubble(
                    clipper: ChatBubbleClipper1(type: BubbleType.receiverBubble),
                    backGroundColor: Color(0xffE7E7ED),
                    margin: EdgeInsets.only(top: 20),
                    child: Container(
                      constraints: BoxConstraints(
                        maxWidth: MediaQuery.of(context).size.width * 0.7,
                      ),
                      child: Text(
                        '${results[index]}',
                        style: GoogleFonts.raleway(color: Colors.black),
                      ),
                    ),
                  );
                },
              ),
            ),
            SizedBox(width:15),
            Flexible(
                child:  ListView.builder(
                  itemCount: names.length,
                  itemBuilder: (context, index) {
                    final item = names[index];
                    return ChatBubble(
                      clipper: ChatBubbleClipper1(type: BubbleType.sendBubble),
                      alignment: Alignment.topRight,
                      margin: EdgeInsets.only(top: 20),
                      backGroundColor: Colors.redAccent,
                      child: Container(
                        constraints: BoxConstraints(
                          maxWidth: MediaQuery.of(context).size.width * 0.7,
                        ),
                        child: Text(
                          '${names[index]}',
                          style: GoogleFonts.raleway(color: Colors.white),
                        ),
                      ),
                    );
                  },
                ),
            ),
          ],
        ),
      )
    );
  }

  void _listen() async {
    await flutterTts.setLanguage("en-US");
    await flutterTts.setSpeechRate(1.0);
    await flutterTts.setVolume(1.0);
    await flutterTts.setPitch(1.0);
    //da-dk-x-nmm-network
    await flutterTts.setVoice('en-AU-language');
    //names.add(_text);
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return VoicePay();
      },
    );
    if (!_isListening) {
      bool available = await _speech.initialize(
        onStatus: (val) => print('onStatus: $val'),
        onError: (val) => print('onError: $val'),
      );
      if (available) {
        setState(() => _isListening = true);
        _speech.listen(
          onResult: (val) =>
              setState(() {
                _text = val.recognizedWords;
                if (val.hasConfidenceRating && val.confidence > 0) {
                  _confidence = val.confidence;
                  setState(() => _isListening = false);
                  _speech.stop();
                  Navigator.pop(context);
                  if (_text.contains('good') || _text.contains('great') ||
                      _text.contains('love you') || _text.contains('best') ||
                      _text.contains('lovely')) {
                    setState(() async {
                      names.insert(names.length, _text);
                      print(names);
                      _reply = "Glad, You like me";
                      results.insert(results.length, _reply);
                      await flutterTts.speak("Glad, You like me");
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return MyApp1();
                        },
                      );
                    });
                  }
                  else if (_text.contains('hello') || _text.contains('hi') ||
                      _text.contains('hey') || _text.contains('Whatsapp') ||
                      _text.contains('hay')) {
                    setState(() async {
                      names.insert(names.length, _text);
                      print(names);
                      _reply = "Hi, What's About you";
                      results.insert(results.length, _reply);
                      await flutterTts.speak("Hey, What's About you");
                    });
                  }
                  else if (_text.contains('fine') || _text.contains('good') ||
                      _text.contains('great') || _text.contains('sup') ||
                      _text.contains('nice') || _text.contains('superb')) {
                    setState(() async {
                      names.insert(names.length, _text);
                      print(names);
                      _reply = "Same Here";
                      results.insert(results.length, _reply);
                      await flutterTts.speak("Same Here");
                    });
                  }
                  else if (_text.contains('what') && _text.contains('doing')) {
                    setState(() async {
                      names.insert(names.length, _text);
                      print(names);
                      _reply = "Just Assisting you";
                      results.insert(results.length, _reply);
                      await flutterTts.speak("Just Assisting you");
                    });
                  }
                  else
                  if (_text.contains('who') && _text.contains('developer')) {
                    setState(() async {
                      names.insert(names.length, _text);
                      print(names);
                      _reply = "My Developer is Rishi Ahuja";
                      results.insert(results.length, _reply);
                      await flutterTts.speak("My Developer is Rishi Ahuja");
                    });
                  }
                  else
                  if (_text.contains('who') && _text.contains('developed')) {
                    setState(() async {
                      names.insert(names.length, _text);
                      print(names);
                      _reply = "My Developer is Rishi Ahuja";
                      results.insert(results.length, _reply);
                      await flutterTts.speak("My Developer is Rishi Ahuja");
                    });
                  }
                  else if (_text.contains('date')) {
                    setState(() async {
                      names.insert(names.length, _text);
                      print(names);
                      _reply =
                      'It is ${actualDate.day}-${actualDate.month}-${actualDate
                          .year}';
                      flutterTts.speak(_text);
                      results.insert(results.length, _reply);
                      NumberToWord().convert('en-in', actualDate.month);
                      await flutterTts.speak('It is ${NumberToWord().convert(
                          'en-in', actualDate.day)}${NumberToWord().convert(
                          'en-in', actualDate.month)}${NumberToWord().convert(
                          'en-in', actualDate.year)}');
                    });
                  }else if (_text.contains('time')) {
                    setState(() async {
                      names.insert(names.length, _text);
                      print(names);
                      _reply =
                      'Right now it is ${actualDate.hour}:${actualDate.minute}:${actualDate
                          .second}';
                      flutterTts.speak(_text);
                      results.insert(results.length, _reply);
                      await flutterTts.speak('Right now It is ${NumberToWord().convert(
                          'en-in', actualDate.hour)}${NumberToWord().convert(
                          'en-in', actualDate.minute)}${NumberToWord().convert(
                          'en-in', actualDate.second)}');
                    });
                  }else if (_text.contains('open YouTube') ||
                      _text.contains('launch YouTube')) {
                    setState(() async {
                      names.insert(names.length, _text);
                      print(names);
                      _reply = "Opening Youtube";
                      results.insert(results.length, _reply);
                      const url = 'https://www.youtube.com';
                      await flutterTts.speak("Opening Youtube");
                      if (await canLaunch(url)) {
                        await launch(url);
                      } else {
                        throw 'Could not launch $url';
                      }
                    });
                  } else if (_text.contains('open Google') ||
                      _text.contains('launch google')) {
                    setState(() async {
                      names.insert(names.length, _text);
                      print(names);
                      _reply = "Opening Google";
                      results.insert(results.length, _reply);
                      const url = 'https://google.com';
                      await flutterTts.speak("Opening Google");
                      if (await canLaunch(url)) {
                        await launch(url);
                      } else {
                        throw 'Could not launch $url';
                      }
                    });
                  }
                  else if (_text.contains('open phone') ||
                      _text.contains('launch phone') ||
                      _text.contains('call') || _text.contains('dialer') ||
                      _text.contains('dialler')) {
                    setState(() async {
                      names.insert(names.length, _text);
                      print(names);
                      _reply = "Opening Phone";
                      results.insert(results.length, _reply);
                      const url = 'tel:';
                      await flutterTts.speak("Opening Dialer");
                      if (await canLaunch(url)) {
                        await launch(url);
                      } else {
                        throw 'Could not launch $url';
                      }
                    });
                  }
                  else if (_text.contains('open Wikipedia') ||
                      _text.contains('launch Wikipedia')) {
                    setState(() async {
                      names.insert(names.length, _text);
                      print(names);
                      _reply = "Opening Wikipedia";
                      results.insert(results.length, _reply);
                      const url = 'https://en.wikipedia.org';
                      await flutterTts.speak("Opening Wikipedia");
                      if (await canLaunch(url)) {
                        await launch(url);
                      } else {
                        throw 'Could not launch $url';
                      }
                    });
                  }
                  else if (_text.contains('on Wikipedia')) {
                    setState(() async {
                      names.insert(names.length, _text);
                      print(names);
                      String finall = _text.substring(0, _text.indexOf('on'));
                      _reply = "Opening Wikipedia";
                      results.insert(results.length, _reply);
                      await flutterTts.speak("Opening Wikipedia");
                      if (await canLaunch(
                          'https://en.wikipedia.org/wiki/$finall')) {
                        await launch('https://en.wikipedia.org/wiki/$finall');
                      } else {
                        throw 'Could not launch';
                      }
                    });
                  }
                  else if (_text.contains('call')) {
                    setState(() async {
                      main();
                      names.insert(names.length, _text);
                      print(names);
                      _reply = "Opening Wikipedia";
                      results.insert(results.length, _reply);
                    });
                  } else if (_text.contains('Wikipedia')) {
                    setState(() {
                      names.insert(names.length, _text);
                      print(names);
                      _reply = "Opening Page";
                      results.insert(results.length, _reply);
                    });
                  } else {
                    setState(() {
                      _reply = "Sorry I didn't get you";
                      flutterTts.speak("Sorry I didn't get you");
                      names.insert(names.length, _text);
                      print(names);
                      results.insert(results.length, _reply);
                    });
                  }
                }
              }),
        );
      }
    }
  }




  void _send() async {
    await flutterTts.setLanguage("en-US");
    await flutterTts.setSpeechRate(1.0);
    await flutterTts.setVolume(1.0);
    await flutterTts.setPitch(1.0);
    await flutterTts.setVoice('en-AU-language');

    if (controller.text.toLowerCase().contains('good') || controller.text.toLowerCase().contains('great') ||
            controller.text.toLowerCase().contains('love you') || controller.text.toLowerCase().contains('best') ||
            controller.text.toLowerCase().contains('lovely')) {
          setState(() async {
            names.insert(names.length, controller.text);
            print(names);
            _reply = "Glad, You liked me";
            results.insert(results.length, _reply);
            await flutterTts.speak("Glad, You liked me");
            FocusScope.of(context).requestFocus(FocusNode());
            showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return MyApp1();
                        },
            );
          });
        }
    else if (controller.text.toLowerCase().contains('hello') || controller.text.toLowerCase().contains('hi') ||
        controller.text.toLowerCase().contains('hey') || controller.text.toLowerCase().contains('whatsapp') ||
        controller.text.toLowerCase().contains('hay')) {
      setState(() async {
        names.insert(names.length, controller.text);
        print(names);
        _reply = "Hi, What's About you";
        results.insert(results.length, _reply);
        await flutterTts.speak("Hey, What's About you");
        FocusScope.of(context).requestFocus(FocusNode());
      });
    }
    else if (controller.text.toLowerCase().contains('fine') || controller.text.toLowerCase().contains('good') ||
        controller.text.toLowerCase().contains('great') || controller.text.toLowerCase().contains('sup') ||
        controller.text.toLowerCase().contains('nice') || controller.text.toLowerCase().contains('superb')) {
      setState(() async {
        names.insert(names.length, controller.text);
        print(names);
        _reply = "Same Here";
        results.insert(results.length, _reply);
        await flutterTts.speak("Same Here");
        FocusScope.of(context).requestFocus(FocusNode());
      });
    }
    else if (controller.text.toLowerCase().contains('what') && controller.text.toLowerCase().contains('doing')) {
      setState(() async {
        names.insert(names.length, controller.text);
        print(names);
        _reply = "Just Assisting you";
        results.insert(results.length, _reply);
        await flutterTts.speak("Just Assisting you");
        FocusScope.of(context).requestFocus(FocusNode());
      });
    }
    else
    if (controller.text.toLowerCase().contains('who') && controller.text.toLowerCase().contains('developer')) {
      setState(() async {
        names.insert(names.length, controller.text);
        print(names);
        _reply = "My Developer is Rishi Ahuja";
        results.insert(results.length, _reply);
        await flutterTts.speak("My Developer is Rishi Ahuja");
        FocusScope.of(context).requestFocus(FocusNode());
      });
    }
    else
    if (controller.text.toLowerCase().contains('who') && controller.text.toLowerCase().contains('developed')) {
      setState(() async {
        names.insert(names.length, controller.text);
        print(names);
        _reply = "My Developer is Rishi Ahuja";
        results.insert(results.length, _reply);
        await flutterTts.speak("My Developer is Rishi Ahuja");
        FocusScope.of(context).requestFocus(FocusNode());
      });
    }
    else if (controller.text.toLowerCase().contains('date')) {
      setState(() async {
        names.insert(names.length, controller.text);
        print(names);
        _reply =
        'It is ${actualDate.day}-${actualDate.month}-${actualDate
            .year}';
        flutterTts.speak(_text);
        results.insert(results.length, _reply);
        FocusScope.of(context).requestFocus(FocusNode());
        NumberToWord().convert('en-in', actualDate.month);
        await flutterTts.speak('It is ${NumberToWord().convert(
            'en-in', actualDate.day)}${NumberToWord().convert(
            'en-in', actualDate.month)}${NumberToWord().convert(
            'en-in', actualDate.year)}');
      });
    }
    else if (controller.text.toLowerCase().contains('time')) {
      setState(() async {
        names.insert(names.length, controller.text);
        print(names);
        _reply =
        'Right now it is ${actualDate.hour}:${actualDate.minute}:${actualDate
            .second}';
        flutterTts.speak(_text);
        results.insert(results.length, _reply);
        FocusScope.of(context).requestFocus(FocusNode());
        await flutterTts.speak('Right now It is ${NumberToWord().convert(
            'en-in', actualDate.hour)}${NumberToWord().convert(
            'en-in', actualDate.minute)}${NumberToWord().convert(
            'en-in', actualDate.second)}');
      });
    }else if (controller.text.toLowerCase().contains('open youtube') ||
        controller.text.contains('launch youtube')) {
      setState(() async {
        names.insert(names.length, controller.text);
        print(names);
        _reply = "Opening Youtube";
        results.insert(results.length, _reply);
        const url = 'https://www.youtube.com';
        await flutterTts.speak("Opening Youtube");
        FocusScope.of(context).requestFocus(FocusNode());
        if (await canLaunch(url)) {
          await launch(url);
        } else {
          throw 'Could not launch $url';
        }
      });
    } else if (controller.text.toLowerCase().contains('open google') ||
        controller.text.toLowerCase().contains('launch google')) {
      setState(() async {
        names.insert(names.length, controller.text);
        print(names);
        _reply = "Opening Google";
        results.insert(results.length, _reply);
        FocusScope.of(context).requestFocus(FocusNode());
        const url = 'https://google.com';
        await flutterTts.speak("Opening Google");
        if (await canLaunch(url)) {
          await launch(url);
        } else {
          throw 'Could not launch $url';
        }
      });
    }
    else if (controller.text.toLowerCase().contains('open phone') ||
        controller.text.toLowerCase().contains('launch phone') ||
        controller.text.toLowerCase().contains('call') || controller.text.toLowerCase().contains('dialer') ||
        controller.text.toLowerCase().contains('dialler')) {
      setState(() async {
        names.insert(names.length, controller.text);
        print(names);
        _reply = "Opening Phone";
        results.insert(results.length, _reply);
        FocusScope.of(context).requestFocus(FocusNode());
        const url = 'tel:';
        await flutterTts.speak("Opening Dialer");
        if (await canLaunch(url)) {
          await launch(url);
        } else {
          throw 'Could not launch $url';
        }
      });
    }
    else if (controller.text.toLowerCase().contains('open Wikipedia') ||
        controller.text.toLowerCase().contains('launch Wikipedia')) {
      setState(() async {
        names.insert(names.length, controller.text);
        print(names);
        _reply = "Opening Wikipedia";
        results.insert(results.length, _reply);
        FocusScope.of(context).requestFocus(FocusNode());
        const url = 'https://en.wikipedia.org';
        await flutterTts.speak("Opening Wikipedia");
        if (await canLaunch(url)) {
          await launch(url);
        } else {
          throw 'Could not launch $url';
        }
      });
    }
    else if (controller.text.toLowerCase().contains('on wikipedia')) {
      setState(() async {
        names.insert(names.length, controller.text);
        print(names);
        String finall = _text.substring(0, _text.indexOf('on'));
        _reply = "Opening Wikipedia";
        results.insert(results.length, _reply);
        FocusScope.of(context).requestFocus(FocusNode());
        await flutterTts.speak("Opening Wikipedia");
        if (await canLaunch(
            'https://en.wikipedia.org/wiki/$finall')) {
          await launch('https://en.wikipedia.org/wiki/$finall');
        } else {
          throw 'Could not launch';
        }
      });
    }
    else if (controller.text.toLowerCase().contains('call')) {
      setState(() async {
        main();
        names.insert(names.length, controller.text);
        print(names);
        _reply = "Opening Wikipedia";
        results.insert(results.length, _reply);
        FocusScope.of(context).requestFocus(FocusNode());
      });
    } else if (controller.text.toLowerCase().contains('wikipedia')) {
      setState(() {
        names.insert(names.length, controller.text);
        print(names);
        _reply = "Opening Wikipedia";
        results.insert(results.length, _reply);
        FocusScope.of(context).requestFocus(FocusNode());
      });
    } else {
      setState(() {
        _reply = "Sorry I didn't get you";
        flutterTts.speak("Sorry I didn't get you");
        names.insert(names.length, controller.text);
        print(names);
        results.insert(results.length, _reply);
        FocusScope.of(context).requestFocus(FocusNode());
      });
    }
  }
}








