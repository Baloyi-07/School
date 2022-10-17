import 'package:backendless_sdk/backendless_sdk.dart';

import 'package:flutter/material.dart';
import 'package:stock/lifecycle.dart';
import 'package:stock/models/item.dart';
import 'package:stock/models/notes.dart';
import 'package:stock/models/todo.dart';
import 'package:stock/models/todo_entry.dart';

class TodoService with ChangeNotifier {
  TodoEntry? _todoEntry;

  List<Todo> _todos = [];
  List<Item> _items = [];
  List<Note> _notes = [];

  List<Todo> get todos => _todos;
  List<Item> get items => _items;
  List<Note> get notes => _notes;

  void emptyTodos() {
    _todos = [];
    notifyListeners();
  }

  void emptyItems() {
    _todos = [];
    notifyListeners();
  }

  void emptyNotes() {
    _todos = [];
    notifyListeners();
  }

  bool _busyRetrieving = false;
  bool _busySaving = false;

  bool get busyRetrieving => _busyRetrieving;
  bool get busySaving => _busySaving;

  Future<String> getTodos(String username) async {
    String result = 'OK';
    DataQueryBuilder queryBuilder = DataQueryBuilder()
      ..whereClause = "username = '$username'";

    _busyRetrieving = true;
    notifyListeners();

    List<Map<dynamic, dynamic>?>? map = await Backendless.data
        .of('TodoEntry')
        .find(queryBuilder)
        .onError((error, stackTrace) {
      result = error.toString();
    });

    if (result != 'OK') {
      _busyRetrieving = false;
      notifyListeners();
      return result;
    }

    if (map != null) {
      if (map.length > 0) {
        _todoEntry = TodoEntry.fromJson(map.first);
        _todos = convertMapToTodoList(_todoEntry!.todos);
        notifyListeners();
      } else {
        emptyTodos();
      }
    } else {
      result = 'NOT OK';
    }

    _busyRetrieving = false;
    notifyListeners();

    return result;
  }

  //
  Future<String> getItems(String username) async {
    String result = 'OK';
    DataQueryBuilder queryBuilder = DataQueryBuilder()
      ..whereClause = "username = '$username'";

    _busyRetrieving = true;
    notifyListeners();

    List<Map<dynamic, dynamic>?>? map = await Backendless.data
        .of('TodoEntry')
        .find(queryBuilder)
        .onError((error, stackTrace) {
      result = error.toString();
    });

    if (result != 'OK') {
      _busyRetrieving = false;
      notifyListeners();
      return result;
    }

    if (map != null) {
      if (map.length > 0) {
        _todoEntry = TodoEntry.fromJson(map.first);
        _items = convertMapToItemList(_todoEntry!.items);
        notifyListeners();
      } else {
        emptyItems();
      }
    } else {
      result = 'NOT OK';
    }

    _busyRetrieving = false;
    notifyListeners();

    return result;
  }

  //
  Future<String> getNotes(String username) async {
    String result = 'OK';
    DataQueryBuilder queryBuilder = DataQueryBuilder()
      ..whereClause = "username = '$username'";

    _busyRetrieving = true;
    notifyListeners();

    List<Map<dynamic, dynamic>?>? map = await Backendless.data
        .of('TodoEntry')
        .find(queryBuilder)
        .onError((error, stackTrace) {
      result = error.toString();
    });

    if (result != 'OK') {
      _busyRetrieving = false;
      notifyListeners();
      return result;
    }

    if (map != null) {
      if (map.length > 0) {
        _todoEntry = TodoEntry.fromJson(map.first);
        _notes = convertMapToNoteList(_todoEntry!.notes);
        notifyListeners();
      } else {
        emptyTodos();
      }
    } else {
      result = 'NOT OK';
    }

    _busyRetrieving = false;
    notifyListeners();

    return result;
  }

  Future<String> saveTodoEntry(String username, bool inUI) async {
    String result = 'OK';
    if (_todoEntry == null) {
      _todoEntry = TodoEntry(
          todos: convertTodoListToMap(_todos),
          username: username,
          items: convertItemListToMap(_items),
          notes: convertNoteListToMap(_notes));
    } else {
      _todoEntry!.todos = convertTodoListToMap(_todos);
      _todoEntry!.notes = convertNoteListToMap(_notes);
      _todoEntry!.items = convertItemListToMap(_items);
    }

    if (inUI) {
      _busySaving = true;
      notifyListeners();
    }
    await Backendless.data
        .of('TodoEntry')
        .save(_todoEntry!.toJson())
        .onError((error, stackTrace) {
      result = error.toString();
    });
    if (inUI) {
      _busySaving = false;
      notifyListeners();
    }

    return result;
  }

  void toggleTodoDone(int index) {
    _todos[index].done = !_todos[index].done;
    notifyListeners();
    setUIStateFlag(UIState.CHANGED);
  }

  void toggleNoteDone(int index) {
    _notes[index].done = !_notes[index].done;
    notifyListeners();
    setUIStateFlag(UIState.CHANGED);
  }

  void toggleItemDone(int index) {
    _items[index].done = !_items[index].done;
    notifyListeners();
    setUIStateFlag(UIState.CHANGED);
  }

  void deleteTodo(Todo todo) {
    _todos.remove(todo);
    notifyListeners();
    setUIStateFlag(UIState.CHANGED);
  }

  void deleteNote(Note note) {
    _notes.remove(note);
    notifyListeners();
    setUIStateFlag(UIState.CHANGED);
  }

  void deleteItem(Item item) {
    _items.remove(item);
    notifyListeners();
    setUIStateFlag(UIState.CHANGED);
  }

  void createTodo(Todo todo) {
    _todos.insert(0, todo);
    notifyListeners();
    setUIStateFlag(UIState.CHANGED);
  }

  void createNote(Note note) {
    _notes.insert(0, note);
    notifyListeners();
    setUIStateFlag(UIState.CHANGED);
  }

  void createItem(Item item) {
    _items.insert(0, item);
    notifyListeners();
    setUIStateFlag(UIState.CHANGED);
  }
}
