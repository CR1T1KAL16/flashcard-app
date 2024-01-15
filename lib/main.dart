import 'package:flutter/material.dart';
import 'package:flip_card/flip_card.dart';
import 'package:flutter_flashcards/flashcard_view.dart';
import 'package:flutter_flashcards/flashcard.dart';

void main() {
  runApp(MaterialApp(
    home: MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  List<String> _subjects = ['Math', 'Science'];
  Map<String, List<Flashcard>> _flashcards = {
    'Math': [
      Flashcard(
        usage: "meth",
        formula: "a^2",
      ),
      Flashcard(
        usage: "another math usage",
        formula: "b^2 + c",
      ),
    ],
    'Science': [
      Flashcard(
        usage: "energy",
        formula: "e = mc^2",
      ),
      Flashcard(
        usage: "science usage",
        formula: "science formula",
      ),
    ],
  };

  int _currentIndex = 0;
  String _selectedSubject = 'Math';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: 50,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: _subjects.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ElevatedButton(
                        onPressed: () {
                          setState(() {
                            _selectedSubject = _subjects[index];
                            _currentIndex = 0;
                          });
                        },
                        child: Text(_subjects[index]),
                      ),
                    );
                  },
                ),
              ),
              SizedBox(
                height: 250,
                child: _flashcards[_selectedSubject]?.isNotEmpty == true
                    ? PageView.builder(
                        itemCount: _flashcards[_selectedSubject]!.length,
                        controller: PageController(viewportFraction: 0.7),
                        onPageChanged: (index) {
                          setState(() {
                            _currentIndex = index;
                          });
                        },
                        itemBuilder: (context, index) {
                          return SizedBox(
                            width: 250,
                            child: FlipCard(
                              front: FlashcardView(
                                text:
                                    _flashcards[_selectedSubject]![index].usage,
                              ),
                              back: FlashcardView(
                                text: _flashcards[_selectedSubject]![index]
                                    .formula,
                              ),
                            ),
                          );
                        },
                      )
                    : Center(
                        child: Text('No formulas for $_selectedSubject'),
                      ),
              ),
              ElevatedButton(
                onPressed: () {
                  _showAddFlashcardDialog(context);
                },
                child: Text('Add Flashcard'),
              ),
              ElevatedButton(
                onPressed: () {
                  if (_flashcards[_selectedSubject]?.isNotEmpty == true) {
                    setState(() {
                      _flashcards[_selectedSubject]?.removeAt(_currentIndex);
                      if (_currentIndex >=
                          _flashcards[_selectedSubject]!.length) {
                        _currentIndex =
                            _flashcards[_selectedSubject]!.length - 1;
                      }
                    });
                  }
                },
                child: Text('Delete Flashcard'),
              ),
              ElevatedButton(
                onPressed: () {
                  _showAddSubjectDialog(context);
                },
                child: Text('Add Subject'),
              ),
              ElevatedButton(
                onPressed: () {
                  _showDeleteSubjectDialog(context);
                },
                child: Text('Delete subject'),
              )
            ],
          ),
        ),
      ),
    );
  }

  void _showAddSubjectDialog(BuildContext context) {
  String newSubject = '';

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Add New Subject'),
        content: TextField(
          decoration: InputDecoration(labelText: 'Subject'),
          onChanged: (value) {
            newSubject = value;
          },
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              if (newSubject.isNotEmpty) {
                setState(() {
                  _subjects.add(newSubject);
                  _selectedSubject = newSubject;
                  _currentIndex = 0;
                  _flashcards[newSubject] = [];
                });
                Navigator.of(context).pop();
              }
            },
            child: Text('Add'),
          ),
        ],
      );
    },
  );
}

void _showAddFlashcardDialog(BuildContext context) {
  String newFormulaUsage = '';
  String newFormula = '';

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Add New Flashcard'),
        content: Column(
          children: [
            TextField(
              decoration: InputDecoration(labelText: 'Usage for formula'),
              onChanged: (value) {
                newFormulaUsage = value;
              },
            ),
            TextField(
              decoration: InputDecoration(labelText: 'Formula'),
              onChanged: (value) {
                newFormula = value;
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              if (newFormulaUsage.isNotEmpty && newFormula.isNotEmpty) {
                setState(() {
                  _flashcards[_selectedSubject]?.add(
                    Flashcard(
                      usage: newFormulaUsage,
                      formula: newFormula,
                    ),
                  );
                  Navigator.of(context).pop();
                });
              }
            },
            child: Text('Add'),
          ),
        ],
      );
    },
  );
}
  void _showDeleteSubjectDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete Subject'),
          content: Text('Are you sure you want to delete $_selectedSubject?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  _subjects.remove(_selectedSubject);
                  if (_subjects.isNotEmpty) {
                    _selectedSubject = _subjects[0];
                  } else {
                    _selectedSubject = '';
                  }
                });
                Navigator.of(context).pop();
              },
              child: Text('Delete'),
            ),
          ],
        );
      },
    );
  }
}
