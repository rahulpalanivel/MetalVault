import 'package:flutter/material.dart';
import 'package:gold/Utils/deviceSize.dart';

class Datepicker extends StatefulWidget {
  const Datepicker({super.key, required this.dateController});
  final TextEditingController dateController;

  @override
  State<Datepicker> createState() => _DatepickerState();
}

class _DatepickerState extends State<Datepicker> {
  @override
  Widget build(BuildContext context) {

    Future<void> selectDate() async{
      DateTime? select = await showDatePicker(context: context, firstDate: DateTime(2000), lastDate: DateTime(3000));
      if(select != null){
        setState(() {
          widget.dateController.text = select.toString();
        });
      }
    }

    return Container(
      height: Devicesize.height!/14,
      width: Devicesize.width!/2.2,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey, width: 2),
        borderRadius: BorderRadius.circular(15)
      ),
      child: TextField(
        controller: widget.dateController,
        decoration: InputDecoration(
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide(
              color: Colors.white,
            )
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide(
              color: Colors.white,
            )
          ), 
        ),
        onTap: (){selectDate();},
      ),
    );
  }
}