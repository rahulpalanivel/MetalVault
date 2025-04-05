import 'package:flutter/material.dart';
import 'package:gold/Utils/deviceSize.dart';

class Dropdown extends StatefulWidget {
  const Dropdown({super.key, required this.items, required this.defaultItem, required this.updatedValue});
  final List<String> items;
  final String defaultItem;
  final Function(String) updatedValue;

  @override
  State<Dropdown> createState() => _DropdownState();
}

class _DropdownState extends State<Dropdown> {
  String selectedItem = "";
  @override
  Widget build(BuildContext context) {
    List<String> items = widget.items;
    String defaultItem = widget.defaultItem;
    return Container(
      height: Devicesize.height!/16,
      width: Devicesize.width!/2.2,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey, width: 2),
        borderRadius: BorderRadius.circular(15)
      ),
      child: DropdownButton(
        underline: Text(""),
        borderRadius: BorderRadius.circular(15),
        icon: Icon(Icons.arrow_drop_down),
        iconSize: 30,
        isExpanded: true,
        value: selectedItem == "" ? defaultItem : selectedItem,
        items: items.map((String item){
          return DropdownMenuItem(value: item,child: Text(item),);
        }).toList(), 
        onChanged: (item)=>{
          setState(() => selectedItem=item!),
          widget.updatedValue(selectedItem)
        }
        ),
    );
  }
}