import '../model/todo.dart';
import 'todoprovider.dart';

class TodoRepository {
  final todoprovider = Todoprovider();
  Future<Todo> fetchAllTodos() => todoprovider.fetchTodoList();
}
