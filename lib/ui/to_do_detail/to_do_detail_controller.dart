import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:maybank_todo/model/to_do_model.dart';
import 'package:maybank_todo/ui/home/home_controller.dart';
import 'package:maybank_todo/utils/custom_widget/app_util.dart';

class ToDoDetailController extends GetxController {
  final formKey = GlobalKey<FormState>();

  TextEditingController title = TextEditingController();
  TextEditingController startDate = TextEditingController();
  TextEditingController endDate = TextEditingController();

  DateTime? selectedStartDate;
  DateTime? selectedEndDate;

  RxBool isButtonEnabled = false.obs;
  RxBool isEditMode = false.obs;
  RxBool isCompleted = false.obs;

  ToDoModel? model;

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
  }

  @override
  void onClose() {
    // TODO: implement onClose
    super.onClose();
  }

  @override
  void onReady() {
    // TODO: implement onClose
    super.onReady();
    if (isEditMode.isTrue) {
      validate();
    }
  }

  init(ToDoModel? model) {
    if (model != null) {
      isEditMode.value = true;
      this.model = model;
      title.text = model.title ?? "";
      startDate.text = _formattedDate(model.startDate!);
      selectedStartDate = model.startDate;
      endDate.text = _formattedDate(model.endDate!);
      selectedEndDate = model.endDate;
      isCompleted.value = model.status == ToDoStatus.completed;
    }
  }

  validate() {
    isButtonEnabled.value = formKey.currentState!.validate();
  }

  void showDatePicker(BuildContext context) async {
    DateTime now = DateTime.now();
    DateTime firstDate = DateTime(now.year - 1, now.month, now.day);
    DateTime lastDate = DateTime(now.year + 1, now.month, now.day);
    DateTimeRange? initialRange;
    if (selectedStartDate != null && selectedEndDate != null) {
      initialRange =
          DateTimeRange(start: selectedStartDate!, end: selectedEndDate!);
    }
    var result = await showDateRangePicker(
        context: context,
        firstDate: firstDate,
        lastDate: lastDate,
        initialDateRange: initialRange);

    if (result != null) {
      selectedStartDate = result.start;
      startDate.text = _formattedDate(selectedStartDate!);
      selectedEndDate = result.end;
      endDate.text = _formattedDate(selectedEndDate!);
      validate();
    }
  }

  String _formattedDate(DateTime date) {
    return DateFormat("dd MMM yyyy").format(date);
  }

  onDeleteToDo() async {
    var result =
        await showConfirmation("Delete", "Are you sure you want to delete?");
    if (!(result ?? false)) return;
    var deleted = await model?.delete();
    if (deleted ?? false) {
      Get.find<HomeController>().fetchData();
      Get.back();
      showSnackBar("Success", "Successfully deleted!");
    }
  }

  onSubmitted() async {
    if (isEditMode.isTrue) {
      model = model?.copyWith(
          startDate: selectedStartDate,
          endDate: selectedEndDate,
          title: title.text);
    } else {
      model = ToDoModel(
          id: generateUUID(),
          startDate: selectedStartDate,
          endDate: selectedEndDate,
          title: title.text);
    }

    var result = await model?.save();
    if (result ?? false) {
      Get.find<HomeController>().fetchData();
      Get.back();
      showSnackBar("Success", "Successfully saved!");
    }
  }
}
