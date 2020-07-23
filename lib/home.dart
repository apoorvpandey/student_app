import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jitsi_meet/jitsi_meet.dart';
import 'package:jitsi_meet/jitsi_meeting_listener.dart';
import 'package:jitsi_meet/room_name_constraint.dart';
import 'package:jitsi_meet/room_name_constraint_type.dart';
import 'package:jitsi_meet/feature_flag/feature_flag_enum.dart';

void main() => runApp(HomeScreen());

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final serverText = TextEditingController();
  final roomText = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final subjectText = TextEditingController();
  final nameText = TextEditingController();
  final emailText = TextEditingController(text: "fake@email.com");
  final iosAppBarRGBAColor =
  TextEditingController(text: "#0080FF80"); //transparent blue
  var isAudioOnly = true;
  var isAudioMuted = true;
  var isVideoMuted = true;

  @override
  void initState() {
    super.initState();
    JitsiMeet.addListener(JitsiMeetingListener(
        onConferenceWillJoin: _onConferenceWillJoin,
        onConferenceJoined: _onConferenceJoined,
        onConferenceTerminated: _onConferenceTerminated,
        onError: _onError));
  }

  @override
  void dispose() {
    super.dispose();
    roomText.dispose();
    JitsiMeet.removeAllListeners();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
          primarySwatch: Colors.orange,
          primaryColor: Colors.deepOrange,
          accentColor: Colors.deepOrangeAccent),
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: Text("Home"),
        ),
        body: Form(
          key: _formKey,
//          padding: const EdgeInsets.symmetric(
//            horizontal: 16.0,
//          ),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: <Widget>[
                  SizedBox(
                    height: 24.0,
                  ),
                  TextField(
                    controller: serverText,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16)
                        ),
                        labelText: "Server URL",
                        hintText: "Hint: Leave empty for meet.jitsi.si"),
                  ),
                  SizedBox(
                    height: 16.0,
                  ),
                  TextFormField(
                    controller: roomText,
                    validator: (String value) {
                      if(value.length <=5) {
                        return "Can not be empty or less than 6 characters";
                      }/*else if(value.length <=6){
                        return "can not be lessthan";
                      }*/
                      return null;
                    },
                    decoration: InputDecoration(
//                        errorText: _validate ? 'It Can\'t Be Empty' : null,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16)
                        ),
                        hintText: "Name of the class room provided by teacher"),
                  ),
                  SizedBox(
                    height: 16.0,
                  ),
//                  TextFormField(
//                    validator: (String value) {
//                      if(value.length <=4) {
//                        return "Enter Subject's name";
//                      }/*else if(value.length <=6){
//                        return "can not be lessthan";
//                      }*/
//                      return null;
//                    },
//                    controller: subjectText,
//                    decoration: InputDecoration(
//                      border: OutlineInputBorder(
//                          borderRadius: BorderRadius.circular(16)
//                      ),
//                      labelText: "Name of the Subject",
//                    ),
//                  ),
                  SizedBox(
                    height: 16.0,
                  ),
                  TextFormField(
                    validator: (String value) {
                      if(value.length <=4) {
                        return "Your name";
                      }
                      return null;
                    },
                    controller: nameText,
                    decoration: InputDecoration(
//                      errorText: _validate ? 'It Can\'t Be Empty' : null,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16)
                      ),
                      labelText: "Teacher's name",
                    ),
                  ),
                  SizedBox(
                    height: 16.0,
                  ),
                  SizedBox(
                    height: 16.0,
                  ),
//                TextField(
//                  controller: iosAppBarRGBAColor,
//                  decoration: InputDecoration(
//                      border: OutlineInputBorder(),
//                      labelText: "AppBar Color(IOS only)",
//                      hintText: "Hint: This HAS to be in HEX RGBA format"),

//                ),
                  SizedBox(
                    height: 16.0,
                  ),
                  CheckboxListTile(
                    title: Text("Audio Only"),
                    value: isAudioOnly,
                    onChanged: _onAudioOnlyChanged,
                  ),
                  SizedBox(
                    height: 16.0,
                  ),
                  CheckboxListTile(
                    title: Text("Audio Muted"),
                    value: isAudioMuted,
                    onChanged: _onAudioMutedChanged,
                  ),
                  SizedBox(
                    height: 16.0,
                  ),
                  CheckboxListTile(
                    title: Text("Video Muted"),
                    value: isVideoMuted,
                    onChanged: _onVideoMutedChanged,
                  ),
                  Divider(
                    height: 48.0,
                    thickness: 1.0,
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        if(_formKey.currentState.validate()){
                          _joinMeeting();
                        }
                      });

                    },
                    child: Container(
                      margin: const EdgeInsets.fromLTRB(64, 0, 64, 18),
                      alignment: Alignment.center,
                      width: MediaQuery.of(context).size.width,
                      padding: EdgeInsets.symmetric(vertical: 20),
                      decoration: BoxDecoration(
                        color: Colors.orange,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Text(
                        "Join now!",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 48.0,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  _onAudioOnlyChanged(bool value) {
    setState(() {
      isAudioOnly = value;
    });
  }

  _onAudioMutedChanged(bool value) {
    setState(() {
      isAudioMuted = value;
    });
  }

  _onVideoMutedChanged(bool value) {
    setState(() {
      isVideoMuted = value;
    });
  }

  _joinMeeting() async {
    String serverUrl =
    serverText.text?.trim()?.isEmpty ?? "" ? null : serverText.text;

    try {
      // Enable or disable any feature flag here
      // If feature flag are not provided, default values will be used
      // Full list of feature flags (and defaults) available in the README
      Map<FeatureFlagEnum, bool> featureFlags = {
        FeatureFlagEnum.WELCOME_PAGE_ENABLED: false,
        // FeatureFlagEnum.INVITE_ENABLED : false,
      };

      // Here is an example, disabling features for each platform
      if (Platform.isAndroid) {
        // Disable ConnectionService usage on Android to avoid issues (see README)
        featureFlags[FeatureFlagEnum.CALL_INTEGRATION_ENABLED] = false;
      } else if (Platform.isIOS) {
        // Disable PIP on iOS as it looks weird
        featureFlags[FeatureFlagEnum.PIP_ENABLED] = false;
      }

      // Define meetings options here
      var options = JitsiMeetingOptions()
        ..room = roomText.text
        ..serverURL = serverUrl
        ..subject = subjectText.text
        ..userDisplayName = nameText.text
        ..userEmail = emailText.text
        ..iosAppBarRGBAColor = iosAppBarRGBAColor.text
        ..audioOnly = isAudioOnly
        ..audioMuted = isAudioMuted
        ..videoMuted = isVideoMuted
        ..featureFlags.addAll(featureFlags);

      debugPrint("JitsiMeetingOptions: $options");
      await JitsiMeet.joinMeeting(
        options,
        listener: JitsiMeetingListener(onConferenceWillJoin: ({message}) {
          debugPrint("${options.room} will join with message: $message");
        }, onConferenceJoined: ({message}) {
          debugPrint("${options.room} joined with message: $message");
        }, onConferenceTerminated: ({message}) {
          debugPrint("${options.room} terminated with message: $message");
        }),
        // by default, plugin default constraints are used
        //roomNameConstraints: new Map(), // to disable all constraints
        //roomNameConstraints: customContraints, // to use your own constraint(s)
      );
    } catch (error) {
      debugPrint("error: $error");
    }
  }

  static final Map<RoomNameConstraintType, RoomNameConstraint>
  customContraints = {
    RoomNameConstraintType.MAX_LENGTH: new RoomNameConstraint((value) {
      return value.trim().length <= 50;
    }, "Maximum room name length should be 30."),
    RoomNameConstraintType.FORBIDDEN_CHARS: new RoomNameConstraint((value) {
      return RegExp(r"[$€£]+", caseSensitive: false, multiLine: false)
          .hasMatch(value) ==
          false;
    }, "Currencies characters aren't allowed in room names."),
  };

  void _onConferenceWillJoin({message}) {
    debugPrint("_onConferenceWillJoin broadcasted with message: $message");
  }

  void _onConferenceJoined({message}) {
    debugPrint("_onConferenceJoined broadcasted with message: $message");
  }

  void _onConferenceTerminated({message}) {
    debugPrint("_onConferenceTerminated broadcasted with message: $message");
  }

  _onError(error) {
    debugPrint("_onError broadcasted: $error");
  }
}
