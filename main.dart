import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:blogs_flutter/data/local/db_helper.dart'; // ✅ Centralized NoteDB

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final titleController = TextEditingController();
  final descController = TextEditingController();

  List<Map<String, dynamic>> allNotes = [];
  final NoteDB noteDB = NoteDB(); // ✅ Updated

  @override
  void initState() {
    super.initState();
    getNotes();
  }

  Future<void> getNotes() async {
    final prefs = await SharedPreferences.getInstance();
    final uid = prefs.getString('uid');

    if (uid != null) {
      allNotes = await noteDB.getNotes(uid);
      setState(() {});
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("User ID not found")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("My Notes")),
      body: allNotes.isNotEmpty
          ? ListView.builder(
        itemCount: allNotes.length,
        itemBuilder: (_, index) {
          final note = allNotes[index];
          return ListTile(
            leading: Text('${note['sno']}'),
            title: Text(note['title']),
            subtitle: Text(note['desc']),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                InkWell(
                  child: const Icon(Icons.edit),
                  onTap: () => _showEditNoteSheet(context, note),
                ),
                const SizedBox(width: 10),
                InkWell(
                  child: const Icon(Icons.delete, color: Colors.red),
                  onTap: () async {
                    final deleted = await noteDB.deleteNote(note['sno']);

                    if (deleted) {
                      getNotes();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Note deleted')),
                      );
                    }
                  },
                ),
              ],
            ),
          );
        },
      )
          : const Center(child: Text('No notes yet!')),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddNoteSheet(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showAddNoteSheet(BuildContext context) {
    titleController.clear();
    descController.clear();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom + 20,
          left: 11,
          right: 11,
          top: 20,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text("Add Note", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24)),
            const SizedBox(height: 20),
            TextField(
              controller: titleController,
              decoration: InputDecoration(
                labelText: 'Title',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(11)),
              ),
            ),
            const SizedBox(height: 15),
            TextField(
              controller: descController,
              decoration: InputDecoration(
                labelText: 'Description',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(11)),
              ),
            ),
            const SizedBox(height: 20),
            OutlinedButton(
              onPressed: () async {
                final title = titleController.text.trim();
                final desc = descController.text.trim();
                final prefs = await SharedPreferences.getInstance();
                final uid = prefs.getString('uid');

                if (uid != null && title.isNotEmpty && desc.isNotEmpty) {
                  final success = await noteDB.addNote(title: title, desc: desc, uid: uid);
                  if (success) {
                    Navigator.pop(context);
                    getNotes();
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Failed to add note')),
                    );
                  }
                }
              },
              child: const Text('Add'),
            ),
          ],
        ),
      ),
    );
  }

  void _showEditNoteSheet(BuildContext context, Map<String, dynamic> note) {
    titleController.text = note['title'];
    descController.text = note['desc'];

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom + 20,
          left: 11,
          right: 11,
          top: 20,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text("Edit Note", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24)),
            const SizedBox(height: 20),
            TextField(
              controller: titleController,
              decoration: InputDecoration(
                labelText: 'Title',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(11)),
              ),
            ),
            const SizedBox(height: 15),
            TextField(
              controller: descController,
              decoration: InputDecoration(
                labelText: 'Description',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(11)),
              ),
            ),
            const SizedBox(height: 20),
            OutlinedButton(
              onPressed: () async {
                final title = titleController.text.trim();
                final desc = descController.text.trim();
                final sno = note['sno'];

                if (title.isNotEmpty && desc.isNotEmpty) {
                  final success = await noteDB.updateNote(sno: sno, title: title, desc: desc);
                  if (success) {
                    Navigator.pop(context);
                    getNotes();
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Failed to update note')),
                    );
                  }
                }
              },
              child: const Text('Update'),
            ),
          ],
        ),
      ),
    );
  }
}
