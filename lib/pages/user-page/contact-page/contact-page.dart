import 'package:flutter/material.dart';
import 'package:pelgrim/consts.dart';
import 'package:pelgrim/dbfeatures/Contact.dart';
import 'package:pelgrim/dbfeatures/User.dart';

class ContactPage extends StatefulWidget {
  final Map<String, dynamic> settings;
  final MyUser myUser;

  const ContactPage({super.key, required this.settings, required this.myUser});

  @override
  State<ContactPage> createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {
  late String group;
  bool _isEditing = false;
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    group =
        '${widget.settings['groupColor']} - ${widget.settings['groupCity']}';
    _loadContactInfo();
  }

  Future<void> _loadContactInfo() async {
    final contactInfo = await Contact.get(group);
    setState(() {
      _controller.text = contactInfo?.description ?? '';
    });
  }

  Future<void> _saveContactInfo() async {
    final updated = Contact(description: _controller.text);
    await updated.save(group);
    setState(() {
      _isEditing = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Container(
          padding: const EdgeInsets.all(20),
          width: screenWidth,
          height: screenHeight,
          child: Column(children: [
            Expanded(
                child: Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 15, horizontal: 20),
                    width: screenWidth * 0.75,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: const [BOX_SHADOW_CONTAINER]),
                    child: Scrollbar(
                      thumbVisibility: true,
                      child: _isEditing
                          ? TextField(
                              controller: _controller,
                              maxLines: null,
                              expands: true,
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.zero,
                                hintText: "Tutaj wypisz wszystkie niezbędne kontakty w dowolnym formacie",
                                hintMaxLines: 2
                              ),
                              style: const TextStyle(
                                fontFamily: 'Lexend',
                                fontSize: 14,
                                height: 1.4,
                                letterSpacing: 0.2,
                              ),
                            )
                          : SingleChildScrollView(
                              child: Padding(
                                padding: const EdgeInsets.only(right: 15.0),
                                child: Text(
                                    _controller.text == ""
                                        ? contactInfo
                                        : _controller.text,
                                    style: const TextStyle(
                                        fontFamily: 'Lexend',
                                        fontSize: 14,
                                        letterSpacing: 0.2)),
                              ),
                            ),
                    ))),
            if (widget.myUser.admin)
              Padding(
                padding: const EdgeInsets.only(top: 30),
                child:
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  InkWell(
                    onTap: () {
                      if (_isEditing) {
                        _saveContactInfo();
                      } else {
                        setState(() => _isEditing = true);
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 40),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          boxShadow: const [BOX_SHADOW_CONTAINER],
                          borderRadius: BorderRadius.circular(15)),
                      child: Center(
                        child: Text(
                          _isEditing ? 'Zapisz' : 'Edytuj',
                          style: const TextStyle(
                              fontFamily: 'Lexend', fontSize: 18),
                        ),
                      ),
                    ),
                  ),
                ]),
              )
            else
              SizedBox(height: screenHeight * 0.05)
          ])),
    );
  }
}
