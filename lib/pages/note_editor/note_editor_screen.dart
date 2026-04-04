import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../../models/note.dart';
import '../../shared/services/note_service.dart';
import '../../app_theme.dart';

class NoteEditorScreen extends StatefulWidget {
  final String username;
  final Note? existingNote;

  const NoteEditorScreen({
    super.key,
    required this.username,
    this.existingNote,
  });

  @override
  State<NoteEditorScreen> createState() => _NoteEditorScreenState();
}

class _NoteEditorScreenState extends State<NoteEditorScreen> {
  final _titleCtrl = TextEditingController();
  final _contentCtrl = TextEditingController();
  final _noteService = NoteService();
  bool _saving = false;
  bool get _isEdit => widget.existingNote != null;

  @override
  void initState() {
    super.initState();
    if (_isEdit) {
      _titleCtrl.text = widget.existingNote!.title;
      _contentCtrl.text = widget.existingNote!.content;
    }
  }

  Future<void> _save() async {
    final title = _titleCtrl.text.trim();
    final content = _contentCtrl.text.trim();
    if (title.isEmpty && content.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Cannot save an empty note.'),
            backgroundColor: AppTheme.danger),
      );
      return;
    }

    setState(() => _saving = true);

    final now = DateTime.now();
    final note = _isEdit
        ? (widget.existingNote!
          ..title = title
          ..content = content
          ..updatedAt = now)
        : Note(
            id: const Uuid().v4(),
            title: title,
            content: content,
            createdAt: now,
            updatedAt: now,
          );

    await _noteService.saveNote(widget.username, note);
    setState(() => _saving = false);
    if (!mounted) return;
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(_isEdit ? 'Note updated!' : 'Note saved!'),
        backgroundColor: AppTheme.success,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEdit ? 'Edit Note' : 'New Note'),
        actions: [
          _saving
              ? const Padding(
                  padding: EdgeInsets.all(16),
                  child: SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                          color: Colors.white, strokeWidth: 2)),
                )
              : TextButton.icon(
                  onPressed: _save,
                  icon: const Icon(Icons.check, color: Colors.white),
                  label: const Text('Save',
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700)),
                ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: _titleCtrl,
              style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.textDark),
              decoration: const InputDecoration(
                hintText: 'Note title...',
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                filled: false,
                contentPadding: EdgeInsets.zero,
              ),
              maxLines: 2,
              minLines: 1,
              textCapitalization: TextCapitalization.sentences,
            ),
            const Divider(height: 24),
            Expanded(
              child: TextField(
                controller: _contentCtrl,
                style: const TextStyle(
                    fontSize: 16,
                    color: AppTheme.textDark,
                    height: 1.6),
                decoration: const InputDecoration(
                  hintText: 'Start writing your note here...',
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  filled: false,
                  contentPadding: EdgeInsets.zero,
                ),
                maxLines: null,
                expands: true,
                textAlignVertical: TextAlignVertical.top,
                textCapitalization: TextCapitalization.sentences,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _titleCtrl.dispose();
    _contentCtrl.dispose();
    super.dispose();
  }
}