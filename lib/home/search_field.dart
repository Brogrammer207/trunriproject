import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:trunriproject/accommodation/accommodationHomeScreen.dart';
import 'package:trunriproject/events/event_list_screen.dart';
import 'package:trunriproject/home/groceryStoreListScreen.dart';
import 'package:trunriproject/home/resturentItemListScreen.dart';
import 'package:trunriproject/job/jobHomePageScreen.dart';
import 'package:trunriproject/temple/templeHomePageScreen.dart';

import 'icon_btn_with_counter.dart';


class SearchField extends StatefulWidget {
  const SearchField({Key? key}) : super(key: key);

  @override
  _SearchFieldState createState() => _SearchFieldState();
}

class _SearchFieldState extends State<SearchField> {
  final TextEditingController _controller = TextEditingController();
  List<String> _allItems = [];
  List<String> _filteredItems = [];

  @override
  void initState() {
    super.initState();
    _fetchItems();
  }

  Future<void> _fetchItems() async {
    try {
      final querySnapshot =
      await FirebaseFirestore.instance.collection('search').get();
      final items = querySnapshot.docs.map((doc) => doc['name'] as String).toList();
      setState(() {
        _allItems = items;
      });
    } catch (e) {
      print("Error fetching items: $e");
    }
  }

  void _filterItems(String query) {
    final filtered = _allItems
        .where((item) => item.toLowerCase().contains(query.toLowerCase()))
        .toList();
    setState(() {
      _filteredItems = filtered;
    });
  }

  void _navigateToScreen(String selectedItem) {
    switch (selectedItem.toLowerCase()) {
      case "restaurants":
        Get.to(const ResturentItemListScreen());
        break;
      case "grocery stores":
        Get.to(const GroceryStoreListScreen());
        break;
      case "accommodation":
        Get.to(const Accommodationhomescreen());
        break;
      case "temple":
        Get.to(const TempleHomePageScreen());
        break;
      case "job":
        Get.to(const JobHomePageScreen());
        break;
      case "events":
        Get.to(EventListScreen());
        break;
      default:
        Get.snackbar("Error", "No matching screen found for '$selectedItem'");
    }
  }
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: Form(
                child: TextFormField(
                  controller: _controller,
                  onChanged: (value) {
                    _filterItems(value);
                  },
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Color(0xFF979797).withOpacity(0.1),
                    contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    hintText: "Search product",
                    prefixIcon: const Icon(Icons.search),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),
            IconBtnWithCounter(
              svgSrc: "assets/images/navigation.png",
              press: () => {},
            ),
            const SizedBox(width: 8),
            IconBtnWithCounter(
              svgSrc: "assets/images/notification.png",
              numOfitem: 3,
              press: () {},
            ),
          ],
        ),
        SizedBox(height: 10,),
        if (_filteredItems.isNotEmpty)
          ListView.builder(
            shrinkWrap: true,
            itemCount: _filteredItems.length,
            itemBuilder: (context, index) {
              return Column(
                children: [

                  Container(
                    child: ListTile(
                      leading: Icon(Icons.search),
                      title: Text(_filteredItems[index]),
                      onTap: () {
                        FocusScope.of(context).unfocus();
                        String selectedItem = _filteredItems[index];
                        _controller.text = selectedItem;
                        setState(() {
                          _filteredItems.clear();
                        });
                        _navigateToScreen(selectedItem);
                        _controller.clear();

                      },
                    ),
                  ),
                ],
              );
            },
          ),
      ],
    );
  }
}


const searchOutlineInputBorder = OutlineInputBorder(
  borderRadius: BorderRadius.all(Radius.circular(12)),
  borderSide: BorderSide.none,
);
