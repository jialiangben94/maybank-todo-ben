import 'package:get/get.dart';
import 'package:maybank_todo/model/database/database_controller.dart';
import 'package:maybank_todo/model/to_do_model.dart';
import 'package:maybank_todo/ui/to_do_detail/to_do_detail_page.dart';
import 'package:maybank_todo/utils/custom_widget/app_util.dart';

class HomeController extends GetxController {
  RxList<ToDoModel> model = <ToDoModel>[].obs;

  RxList<ToDoModel> checkedList = <ToDoModel>[].obs;

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    initDb();
  }

  initDb() async {
    await DatabaseController.db.initialize("maybank_todo", 1);
    fetchData();
  }

  Future fetchData() async {
    model.value = await ToDoModelDb.getAll();
  }

  onToDoSelected(ToDoModel item) {
    Get.to(() => ToDoDetailPage(model: item));
  }

  onAddTapped() {
    Get.to(() => ToDoDetailPage());
  }

  onCompletedChecked(ToDoModel model, bool checked) {
    if (checked) {
      checkedList.add(model);
    } else {
      checkedList.remove(model);
    }
  }

  onSaveList() async {
    bool result = true;
    for (var item in checkedList.toList()) {
      item.status = ToDoStatus.completed;
      result = await item.save();
      if (!result) {
        showSnackBar("Failed", "Failed to save for title ${item.title}");
        return;
      }
    }
    showSnackBar("Successfully", "Successfully updated");
    checkedList.clear();
    fetchData();
  }
}
