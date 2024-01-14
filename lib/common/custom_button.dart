import 'package:flutter/material.dart';
import 'package:nuriya_tailers/constants/colors.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final Color? color;
  final VoidCallback onTap;
  final isLoading;
  const CustomButton(
      {super.key, required this.text, this.color, required this.onTap,required this.isLoading});

  @override
  Widget build(BuildContext context) {
    return isLoading?
    CircularProgressIndicator(color: GlobalVariables.primaryColor,)
    
    : ElevatedButton(
      onPressed: ()=>{onTap},
      style: ElevatedButton.styleFrom(
        minimumSize: const Size(double.infinity, 50),
        backgroundColor: GlobalVariables.primaryColor,
      ),
      child: Text(
        text,
        style: TextStyle(color: color == null ? Colors.white : Colors.black),
      ),
    );
  }
}
