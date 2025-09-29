import from uuid { uuid4 }

# complete_notebook.jac
node Note {
    has title: str;
    has content: str;
    has author: str;
    has priority: int = 1;
    has created_at: str = "2024-01-15";
    has id: str;
}

# CREATE - Add new note
walker create_note {
    has title: str;
    has content: str;
    has author: str;
    has priority: int = 1;

    can add_note with `root entry {
        new_note = Note(
            title=self.title, content=self.content,
            author=self.author, priority=self.priority,
            id="note_" + str(uuid4())
        );
        here ++> new_note;
        report {"message": "Note created", "id": new_note.id};
    }
}

# READ - Get all notes
walker list_notes {
    can get_all_notes with `root entry {
        all_notes = [-->(`?Note)];
        report {
            "notes": [
                {
                    "id": n.id,
                    "title": n.title,
                    "author": n.author,
                    "priority": n.priority
                }
                for n in all_notes
            ],
            "total": len(all_notes)
        };
    }
}

# READ - Get specific note
walker get_note {
    has note_id: str;

    can fetch_note with `root entry {
        target_note = [-->(`?Note)](?id == self.note_id);

        if target_note {
            note = target_note[0];
            report {
                "note": {
                    "id": note.id,
                    "title": note.title,
                    "content": note.content,
                    "author": note.author,
                    "priority": note.priority
                }
            };
        } else {
            report {"error": "Note not found"};
        }
    }
}

# UPDATE - Modify note
walker update_note {
    has note_id: str;
    has title: str = "";
    has content: str = "";
    has priority: int = 0;

    can modify_note with `root entry {
        target_note = [-->(`?Note)](?id == self.note_id);

        if target_note {
            note = target_note[0];

            # Update only provided fields
            if self.title {
                note.title = self.title;
            }
            if self.content {
                note.content = self.content;
            }
            if self.priority > 0 {
                note.priority = self.priority;
            }

            report {"message": "Note updated", "id": note.id};
        } else {
            report {"error": "Note not found"};
        }
    }
}

# DELETE - Remove note
walker delete_note {
    has note_id: str;

    can remove_note with `root entry {
        target_note = [-->(`?Note)](?id == self.note_id);

        if target_note {
            note = target_note[0];
            # Delete the node and its connections
            del note;
            report {"message": "Note deleted", "id": self.note_id};
        } else {
            report {"error": "Note not found"};
        }
    }
}   