import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'dart:convert';

import '../models/subject.dart';

import '../components/subject_item.dart';
import '../components/new_subject_form.dart';
import '../components/main_drawer.dart';

class SubjectsScreen extends StatefulWidget {
  final Map<String, dynamic> userData;
  const SubjectsScreen(this.userData, {super.key});

  @override
  State<SubjectsScreen> createState() => _SubjectsScreenState();
}

class _SubjectsScreenState extends State<SubjectsScreen> {
  List<Subject> subjects = [];

  dynamic subjectData;

  ScrollController controller = ScrollController();

  Future getSubjects(int userId, String token) async {
    subjects = [];
    final dataUser = {"user_id": userId, "authentication_token": token};

    final http.Response response = await http.post(
      Uri.parse('https://app.uff.br/umm/api/get_subjects_from_igeo'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(dataUser),
    );

    var data = jsonDecode(response.body);
    subjectData = await data;

    print(data);

    if (subjectData.length == 0) {
      print("Vazio");
      return;
    }
    subjectData.forEach((subject) {
      subjects.add(
        Subject(
          id: subject["id"],
          name: subject["name"],
        ),
      );
    });

    // controller.animateTo(
    //   controller.position.maxScrollExtent,
    //   curve: Curves.easeOut,
    //   duration: const Duration(milliseconds: 300),
    // );

    return response;
  }

  Future<http.Response> postSubject(
      int subjectId, String name, int userId, String token) async {
    final data = {
      "user_id": userId,
      "authentication_token": token,
      "name": name
    };

    final http.Response response = await http.post(
      Uri.parse('https://app.uff.br/umm/api/post_subject_in_igeo'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(data),
    );

    return response;
  }

  void _addSubject(String name) {
    postSubject(subjects.isEmpty ? 0 : subjects.last.id + 1, name,
            widget.userData["id"], widget.userData["token"])
        .then((value) => setState(() {
              subjects.add(Subject(
                id: subjects.isEmpty ? 0 : subjects.last.id + 1,
                name: name,
              ));
              //getSubjects(widget.userData["id"], widget.userData["token"]);
            }));

    Navigator.of(context).pop();
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Campo adicionado'),
        duration: Duration(seconds: 2),
        // action: SnackBarAction(
        //   label: 'DESFAZER',
        //   onPressed: () {
        //     cart.removeSingleItem(product.id);
        //   },
      ),
    );

    //getSubjects(widget.userData["id"], widget.userData["token"]);
  }

  _openNewSubjectFormModal(BuildContext context) {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (BuildContext context) {
          return SingleChildScrollView(
              child: Container(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            child: NewSubjectForm(_addSubject),
          ));
        });
  }

  Future<void> refresh(BuildContext context) {
    return getSubjects(widget.userData["id"], widget.userData["token"]);
  }

  // @override
  // void initState() {
  //   super.initState();
  //   getSubjects(widget.userData["id"], widget.userData["token"]);
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () => refresh(context),
        child: FutureBuilder(
          future: getSubjects(widget.userData["id"], widget.userData["token"]),
          builder: (context, snapshot) => snapshot.connectionState ==
                  ConnectionState.waiting
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : subjects.length > 0
                  ? ListView.builder(
                      controller: controller,
                      itemCount: subjects.length,
                      itemBuilder: (ctx, index) {
                        return SubjectItem(subjects[index], widget.userData);
                      },
                    )
                  : Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.beach_access,
                            color: Theme.of(context).primaryColor,
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          const Text(
                            'Nenhum trabalho de campo criado',
                            style: TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
        ),
      ),
      drawer: const MainDrawer(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _openNewSubjectFormModal(context);
        },
        backgroundColor: Theme.of(context).primaryColor,
        child: const Icon(Icons.add),
      ),
    );
  }
}
