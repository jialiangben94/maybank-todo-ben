import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:maybank_todo/model/to_do_model.dart';
import 'package:maybank_todo/ui/to_do_detail/to_do_detail_controller.dart';
import 'package:maybank_todo/utils/app_color.dart';
import 'package:maybank_todo/utils/custom_widget/app_util.dart';

class ToDoDetailPage extends GetView {
  final ToDoModel? model;
  ToDoDetailPage({this.model});
  final ToDoDetailController _controller = Get.put(ToDoDetailController());
  @override
  Widget build(BuildContext context) {
    _controller.init(model);
    return Obx(
      () => Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: AppColor.themeBackground,
        appBar: getAppBar(
            "${_controller.isEditMode.value ? (_controller.isCompleted.value ? "View" : "Edit") : "Add New"} To-Do List",
            actions: _controller.isEditMode.value
                ? [
                    InkWell(
                        onTap: _controller.onDeleteToDo,
                        child: const Icon(Icons.delete, size: 30)),
                    const SizedBox(width: 20)
                  ]
                : null),
        body: SafeArea(child: _body(context)),
      ),
    );
  }

  Widget _body(BuildContext context) {
    return InkWell(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(25),
              child: Form(
                key: _controller.formKey,
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _formTitle("To-Do Title"),
                      const SizedBox(height: 10),
                      Obx(
                        () => TextFormField(
                          maxLines: 5,
                          enabled: _controller.isCompleted.isFalse,
                          controller: _controller.title,
                          validator: (value) {
                            return _validator(value, "Please enter some text");
                          },
                          decoration: _formFieldDecoration(
                              "Please key in your To-Do title here", false),
                          onChanged: (_) => _controller.validate(),
                        ),
                      ),
                      const SizedBox(height: 20),
                      _formTitle("Start Date"),
                      const SizedBox(height: 10),
                      Obx(
                        () => TextFormField(
                          maxLines: 1,
                          controller: _controller.startDate,
                          enabled: _controller.isCompleted.isFalse,
                          readOnly: true,
                          validator: (value) {
                            return _validator(value, "Please select a date");
                          },
                          decoration: _formFieldDecoration(
                              "Please select a date", true),
                          onTap: () {
                            _controller.showDatePicker(context);
                          },
                        ),
                      ),
                      const SizedBox(height: 20),
                      _formTitle("End Date"),
                      const SizedBox(height: 10),
                      Obx(
                        () => TextFormField(
                          maxLines: 1,
                          controller: _controller.endDate,
                          enabled: _controller.isCompleted.isFalse,
                          readOnly: true,
                          validator: (value) {
                            return _validator(value, "Please select a date");
                          },
                          decoration: _formFieldDecoration(
                              "Please select a date", true),
                          onTap: () {
                            _controller.showDatePicker(context);
                          },
                        ),
                      ),
                    ]),
              ),
            ),
          ),
          Obx(() => _controller.isButtonEnabled.value &&
                  _controller.isCompleted.isFalse
              ? _bottomButton()
              : const SizedBox.shrink())
        ],
      ),
    );
  }

  Widget _formTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
          color: AppColor.themeGrey, fontSize: 16, fontWeight: FontWeight.w500),
    );
  }

  InputDecoration _formFieldDecoration(String hint, bool isDropdown) {
    return InputDecoration(
      isCollapsed: true,
      contentPadding: EdgeInsets.all(10),
      hintText: hint,
      hintStyle: const TextStyle(color: AppColor.themeLightrey),
      suffixIcon: isDropdown
          ? const Icon(Icons.keyboard_arrow_down, color: AppColor.themeGrey)
          : null,
      border: const OutlineInputBorder(
          borderSide: BorderSide(color: AppColor.themeBlack)),
      enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: AppColor.themeBlack)),
      focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: AppColor.themeBlack)),
      errorBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: AppColor.themeRed, width: 2)),
    );
  }

  String? _validator(String? value, String errorMessage) {
    if (value == null || value.isEmpty) {
      return errorMessage;
    }
    return null;
  }

  Widget _bottomButton() {
    return SizedBox(
        width: double.infinity,
        height: 50,
        child: ElevatedButton(
          onPressed: _controller.onSubmitted,
          child: Obx(
            () => Text(
              _controller.isEditMode.value ? "Save" : "Create New",
              style: const TextStyle(
                  color: AppColor.themeWhite,
                  fontSize: 16,
                  fontWeight: FontWeight.w500),
            ),
          ),
          style: ElevatedButton.styleFrom(primary: AppColor.themeBlack),
        ));
  }
}
