import 'package:flutter/material.dart';
import 'package:pelgrim/core/const/app_consts.dart';
import 'package:pelgrim/domain/entities/contact.dart';
import 'package:pelgrim/presentation/providers/contact_provider.dart';
import 'package:pelgrim/presentation/providers/user_provider.dart';
import 'package:provider/provider.dart';

class ContactPage extends StatefulWidget {
  const ContactPage({super.key});

  @override
  State<ContactPage> createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {
  late String _group;

  bool _isEditing = false;
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _group = context.read<UserProvider>().groupInfo!.id!;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadContactInfo();
    });
  }

  Future<void> _loadContactInfo() async {
    try {
      final contactProvider = context.read<ContactProvider>();

      await contactProvider.fetchContactInfo(groupName: _group);
      setState(() {
        _controller.text = contactProvider.contactDescription;
      });
    } catch (e) {
      print(e);
    }
  }

  Future<void> _saveContactInfo() async {
    try {
      final contactProvider = context.read<ContactProvider>();

      await contactProvider.saveContactInfo(
        groupName: _group,
        contact: Contact(
          description: _controller.text,
        ),
      );
      setState(() {
        _controller.text = contactProvider.contactDescription;
      });
    } catch (e) {
      print(e);
    } finally {
      setState(() {
        _isEditing = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isAdmin = context.read<UserProvider>().user!.isAdmin;

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 25.0),
        child: Column(
          children: [
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
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
                            hintText:
                                "Tutaj wypisz wszystkie niezbędne kontakty w dowolnym formacie",
                            hintMaxLines: 2,
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
                            child: Consumer<ContactProvider>(
                              builder: (context, provider, child) {
                                if (provider.isLoading) {
                                  return const Center(
                                    child: CircularProgressIndicator(),
                                  );
                                }
                                return Text(
                                  _isEditing ? _controller.text : provider.contactDescription,
                                  style: const TextStyle(
                                    fontFamily: 'Lexend',
                                    fontSize: 14,
                                    letterSpacing: 0.2,
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 30),
              child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                if (_isEditing) ...[
                  InkWell(
                    onTap: () {
                      setState(() {
                        _isEditing = !_isEditing;
                      });
                    },
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: const [BOX_SHADOW_CONTAINER],
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: const Padding(
                        padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                        child: Icon(Icons.close),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 20.0,
                  )
                ],
                if (isAdmin)
                  InkWell(
                    onTap: () {
                      if (_isEditing) {
                        _saveContactInfo();
                      } else {
                        setState(() => _isEditing = true);
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 40),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: const [BOX_SHADOW_CONTAINER],
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Center(
                        child: Text(
                          _isEditing ? 'Zapisz' : 'Edytuj',
                          style: const TextStyle(fontFamily: 'Lexend', fontSize: 18),
                        ),
                      ),
                    ),
                  ),
              ]),
            )
          ],
        ),
      ),
    );
  }
}
