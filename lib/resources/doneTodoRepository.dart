import '../model/doneTodo.dart';
import 'doneTodoprovider.dart';

class DoneTodoRepository {
  final doneTodoProvider = DoneTodoprovider();
  Future<DoneTodo> fetchAllDoneTodos() => doneTodoProvider.fetchDoneTodoList();
}
