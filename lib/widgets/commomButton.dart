import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CommonButton extends StatefulWidget {
  final String text;
  final VoidCallback onPressed;
  final Color color;
  final Color textColor;

  const CommonButton({
    required this.text,
    required this.onPressed,
    required this.color,
    required this.textColor,

  });

  @override
  State<CommonButton> createState() => _CommonButtonState();
}

class _CommonButtonState extends State<CommonButton> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onPressed,
      child: Container(
          margin: const EdgeInsets.only(left: 15, right: 15),
          height: 55,
          width: Get.width,
          decoration: BoxDecoration(color: widget.color, borderRadius: BorderRadius.circular(25)),
          child: Center(
              child: Text(
                widget.text,
                style: TextStyle(color: widget.textColor, fontWeight: FontWeight.w500),
              ))),
    );
  }
}

class LetsYouInContainer extends StatelessWidget {
  final String text;
  final String imagePath;
  final VoidCallback onPressed;

  const LetsYouInContainer({
    required this.text,
    required this.imagePath,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 20, right: 20, bottom: 10),
      padding: const EdgeInsets.only(top: 8, bottom: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(11),
        border: Border.all(color: Colors.grey.shade300, width: 1),
      ),
      child: InkWell(
        onTap: onPressed,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              imagePath,
              height: 35,
              width: 35,
            ),
            const SizedBox(
              width: 5,
            ),
            Text(
              text,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w500,
                color: Colors.black,
              ),
            )
          ],
        ),
      ),
    );
  }
}
