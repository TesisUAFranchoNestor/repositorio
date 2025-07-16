import 'package:flutter/material.dart';


class AuthTextField extends StatelessWidget {

  final String title;
  final bool isPassword;
  final TextInputType? keyboardType;
  final Widget? prefixIcon;
  final Function(String)? onChanged;
  final String? errorMessage;

  const AuthTextField({
    super.key, 
    required this.title, 
    this.isPassword=false,
    this.keyboardType, 
    this.prefixIcon, 
    this.onChanged, 
    this.errorMessage = ''
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          ),
          const SizedBox(
            height: 10,
          ),
          TextField(
              obscureText: isPassword,
              onChanged: onChanged,
              style: const TextStyle(color: Colors.black45),
              keyboardType: keyboardType==null ? TextInputType.text : keyboardType!,
              decoration: InputDecoration(
                  prefixIcon: prefixIcon,
                  border: InputBorder.none,
                  fillColor: const Color(0xfff3f3f4),
                  filled: true,
                  errorText: errorMessage,
                  )
              )
        ],
      ),
    );
  }
}