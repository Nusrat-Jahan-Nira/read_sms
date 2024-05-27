import 'package:flutter/material.dart';
import 'package:flutter_sms_inbox/flutter_sms_inbox.dart';
import 'package:permission_handler/permission_handler.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final SmsQuery _query = SmsQuery();
  List<SmsMessage> _messages = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter SMS Inbox App',
      theme: ThemeData(
        primarySwatch: Colors.teal,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('SMS Inbox Example'),
        ),
        body: Container(
          padding: const EdgeInsets.all(10.0),
          child: _messages.isNotEmpty
              ? _MessagesListView(
            messages: _messages,
          )
              : Center(
            child: Text(
              'No messages to show.\n Tap refresh button...',
              style: Theme.of(context).textTheme.headlineSmall,
              textAlign: TextAlign.center,
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            var permission = await Permission.sms.status;
            if (permission.isGranted) {
              final messages = await _query.querySms(
                kinds: [
                  SmsQueryKind.inbox,
                  SmsQueryKind.sent,
                  SmsQueryKind.draft
                ],
                //address: '01512345678',
                // address: '+254712345789',
                count: 10,
              );
              debugPrint('sms inbox messages: ${messages.length}');

              setState(() => _messages = messages);
            } else {
              await Permission.sms.request();
            }
          },
          child: const Icon(Icons.refresh),
        ),
      ),
    );
  }
}

class _MessagesListView extends StatelessWidget {
  const _MessagesListView({
    required this.messages,
  });

  // Future getAllMessages() async {
  //   SmsQuery query = new SmsQuery();
  //   List<SmsMessage> messages = await query.getAllSms;
  //   debugPrint("Total Messages : ${messages.length}");
  //   print(messages);
  // }
  Future getAllMessages() async {
    SmsQuery query = SmsQuery();
    List<SmsMessage> messages = await query.getAllSms;
    print("Total Messages : ${messages.length}");
    for (var element in messages) { print(element.body); }
  }

  // Future<void> getAllInboxMessages() async {
  //   SmsQuery query = SmsQuery();
  //   List<SmsMessage> messages = await query.getAllSms;
  //
  //   // Filter inbox messages
  //   List<SmsMessage> inboxMessages = messages
  //       .where((message) => message.kind == SmsQueryKind.inbox)
  //       .toList();
  //
  //   print("Total Inbox Messages: ${inboxMessages.length}");
  //
  //   for (var message in inboxMessages) {
  //     print("From: ${message.sender}");
  //     print("Body: ${message.body}");
  //     print("Timestamp: ${message.date}");
  //     // Add more properties you might want to access from the message object
  //   }
  // }
  Future<void> getAllInboxMessages() async {
    SmsQuery query = SmsQuery();
    List<SmsMessage> messages = await query.getAllSms;

    // Filter inbox messages
    List<SmsMessage> inboxMessages = messages
        .where((message) => message.kind == SmsMessageKind.received)
        .toList();

    print("Total Inbox Messages: ${inboxMessages.length}");

    for (var message in inboxMessages) {
      print("From: ${message.sender}");
      print("Body: ${message.body}");
      print("Timestamp: ${message.date}");
      // Add more properties you might want to access from the message object
    }
  }
  Future<void> getAllSendMessages() async {
    SmsQuery query = SmsQuery();
    List<SmsMessage> messages = await query.getAllSms;

    // Filter inbox messages
    List<SmsMessage> inboxMessages = messages
        .where((message) => message.kind == SmsMessageKind.sent)
        .toList();

    print("Total Send Messages: ${inboxMessages.length}");

    for (var message in inboxMessages) {
      print("From: ${message.sender}");
      print("Body: ${message.body}");
      print("Timestamp: ${message.date}");
      // Add more properties you might want to access from the message object
    }
  }
  Future<void> getAllDraftMessages() async {
    SmsQuery query = SmsQuery();
    List<SmsMessage> messages = await query.getAllSms;

    // Filter inbox messages
    List<SmsMessage> inboxMessages = messages
        .where((message) => message.kind == SmsMessageKind.draft)
        .toList();

    print("Total Inbox Messages: ${inboxMessages.length}");

    for (var message in inboxMessages) {
      print("From: ${message.sender}");
      print("Body: ${message.body}");
      print("Timestamp: ${message.date}");
      // Add more properties you might want to access from the message object
    }
  }

  final List<SmsMessage> messages;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){

        getAllMessages();
        getAllInboxMessages();
        getAllSendMessages();
        getAllDraftMessages();
      },
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: messages.length,
        itemBuilder: (BuildContext context, int i) {
          var message = messages[i];

          return ListTile(
            title: Text('${message.sender} [${message.date}]'),
            subtitle: Text('${message.body}'),
          );
        },
      ),
    );
  }
}