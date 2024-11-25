import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../style.dart';

TextEditingController dateController = TextEditingController();
Widget customText(
    String title,
    String hintText,
    TextEditingController controller,
    TextInputType inputType,
    List<TextInputFormatter> inputformatter,
    bool isprefixIcon,
    bool isreadonly,
    BuildContext context) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceAround,
    children: [
      Container(
          padding: const EdgeInsets.all(12),
          width: MediaQuery.of(context).size.width * 0.40,
          child: Text(
            title,
            style: tableheader,
          )),
      Container(
        width: MediaQuery.of(context).size.width * 0.50,
        height: 35,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
        ),
        child: TextFormField(
          style: formtext,
          readOnly: isreadonly,
          keyboardType: inputType,
          inputFormatters: inputformatter,
          decoration: InputDecoration(
              // suffixIcon: isprefixIcon
              //     ? IconButton(onPressed: () {

              //     }, icon: const Icon(Icons.today))
              //     : Container(),
              hintText: hintText,
              hintStyle: tablefonttext,
              contentPadding: const EdgeInsets.only(left: 2, right: 2)),
          controller: controller,
        ),
      ),
    ],
  );
}

tableFooter(TextEditingController controller) {
  return Padding(
    padding: const EdgeInsets.all(10.0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Remark if Any',
          style: tableheader,
          textAlign: TextAlign.start,
        ),
        TextFormField(
          controller: controller,
          maxLines: null,
          minLines: 1,
        )
      ],
    ),
  );
}
