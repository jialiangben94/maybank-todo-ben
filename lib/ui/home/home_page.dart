import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:maybank_todo/model/to_do_model.dart';
import 'package:maybank_todo/ui/home/home_controller.dart';
import 'package:maybank_todo/utils/app_color.dart';
import 'package:maybank_todo/utils/custom_widget/app_util.dart';

class HomePage extends GetView {
  final HomeController _controller = Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Obx(
      () => Scaffold(
        backgroundColor: AppColor.themeBackground,
        appBar: getAppBar("To-Do List",
            actions: _controller.checkedList.isEmpty
                ? null
                : [
                    InkWell(
                        onTap: _controller.onSaveList,
                        child: const Icon(Icons.save, size: 30)),
                    const SizedBox(width: 20)
                  ]),
        body: SafeArea(child: _body()),
        floatingActionButton: FloatingActionButton(
          onPressed: _controller.onAddTapped,
          child: const Icon(Icons.add),
          backgroundColor: AppColor.themeRed,
        ),
        floatingActionButtonLocation:
            FloatingActionButtonLocation.miniCenterFloat,
      ),
    );
  }

  Widget _body() {
    return RefreshIndicator(
      onRefresh: () async {
        await _controller.fetchData();
        return;
      },
      child: Obx(
        () => ListView.separated(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 80),
            itemBuilder: (_, index) => _cardItem(_controller.model[index]),
            separatorBuilder: (_, index) => const SizedBox(height: 20),
            itemCount: _controller.model.length),
      ),
    );
  }

  Widget _cardItem(ToDoModel item) {
    return InkWell(
      onTap: () => _controller.onToDoSelected(item),
      child: Card(
        elevation: 5,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.title ?? "",
                    style: const TextStyle(
                        color: AppColor.themeBlack,
                        fontSize: 16,
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: [
                      _verticalItem("Start Date",
                          DateFormat("dd MMM yyyy").format(item.startDate!)),
                      _verticalItem("End Date",
                          DateFormat("dd MMM yyyy").format(item.endDate!)),
                      _verticalItem("Time Left", item.getTimeLeft()),
                    ],
                  )
                ],
              ),
            ),
            Container(
              color: AppColor.themeGreen,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(children: [
                const Text(
                  "Status",
                  style: TextStyle(
                      color: AppColor.themeGrey,
                      fontSize: 14,
                      fontWeight: FontWeight.w500),
                ),
                const SizedBox(width: 5),
                Expanded(
                  child: Text(
                    item.status.desc,
                    style: const TextStyle(
                        color: AppColor.themeBlack,
                        fontSize: 14,
                        fontWeight: FontWeight.w500),
                  ),
                ),
                const SizedBox(width: 5),
                if (item.status == ToDoStatus.pending)
                  Row(
                    children: [
                      const Text(
                        "Tick if completed",
                        style:
                            TextStyle(color: AppColor.themeBlack, fontSize: 12),
                      ),
                      const SizedBox(width: 15),
                      Obx(() => SizedBox(
                            width: 15,
                            height: 15,
                            child: Checkbox(
                                activeColor: AppColor.themeRed,
                                value: _controller.checkedList.contains(item),
                                onChanged: (value) {
                                  _controller.onCompletedChecked(
                                      item, value ?? false);
                                }),
                          ))
                    ],
                  ),
              ]),
            )
          ],
        ),
      ),
    );
  }

  Widget _verticalItem(String title, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
              color: AppColor.themeGrey,
              fontSize: 14,
              fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 5),
        Text(
          value,
          style: const TextStyle(
              color: AppColor.themeBlack,
              fontSize: 14,
              fontWeight: FontWeight.w500),
        ),
      ],
    );
  }
}
