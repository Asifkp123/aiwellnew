import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../components/buttons/label_button.dart';
import '../../../../components/constants.dart';
import '../../../../components/theme/light_theme.dart';

class CustomPinInput extends StatefulWidget {
  final TextEditingController controller;
  final ValueChanged<String> onCompleted;
  final bool isLoading;
  final int countdownSeconds;
  final bool canResend;
  final VoidCallback onResend;
  final String? errorMessage;

  const CustomPinInput({
    Key? key,
    required this.controller,
    required this.onCompleted,
    required this.isLoading,
    required this.countdownSeconds,
    required this.canResend,
    required this.onResend,
    required this.errorMessage,
  }) : super(key: key);

  @override
  State<CustomPinInput> createState() => _CustomPinInputState();
}

class _CustomPinInputState extends State<CustomPinInput> with SingleTickerProviderStateMixin {
  String _pin = '';
  bool _showKeyboard = true;
  late AnimationController _blinkController;
  late Animation<double> _blinkAnimation;

  @override
  void initState() {
    super.initState();
    // Initialize animation controller for blinking effect
    _blinkController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _blinkAnimation = Tween<double>(begin: 0.3, end: 1.0).animate(_blinkController);
    if (mounted) {
      _blinkController.repeat(reverse: true);
    }
  }

  @override
  void dispose() {
    _blinkController.stop();
    _blinkController.dispose();
    super.dispose();
  }

  void _addDigit(String value) {
    if (_pin.length < 6 && mounted) {
      setState(() {
        _pin += value;
        widget.controller.text = _pin;
      });
    }
  }

  void _deleteDigit() {
    if (_pin.isNotEmpty && mounted) {
      setState(() {
        _pin = _pin.substring(0, _pin.length - 1);
        widget.controller.text = _pin;
      });
    }
  }

  void _submitOtp() {
    if (_pin.length == 6 && mounted) {
      widget.onCompleted(_pin);
      setState(() => _showKeyboard = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: () => setState(() => _showKeyboard = true),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: List.generate(6, (index) {
              bool isFocused = index == _pin.length && _showKeyboard;
              return AnimatedBuilder(
                animation: _blinkAnimation,
                builder: (context, child) {
                  return Container(
                    width: 50,
                    height: 60,
                    alignment: Alignment.center,
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(
                        color: isFocused
                            ? lightTheme.primaryColor.withOpacity(_blinkAnimation.value)
                            : Colors.grey.shade300,
                        width: isFocused ? 2.0 : 1.0,
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      index < _pin.length ? _pin[index] : '',
                      style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.w600),
                    ),
                  );
                },
              );
            }),
          ),
        ),
        if (_showKeyboard) ...[
          const SizedBox(height: 16),
          _buildResendRow(),
        ],
        const SizedBox(height: 16),
        if (!_showKeyboard) _buildResendRow(),
        if (_showKeyboard) ...[
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: LabelButton(
              label: widget.isLoading ? 'Verifying...' : 'Verify OTP',
              onTap: _pin.length == 6 && !widget.isLoading ? _submitOtp : null,
              gradient: _pin.length == 6 && !widget.isLoading ? splashGradient() : null,
              bgColor: _pin.length < 6 || widget.isLoading ? Colors.grey.shade300 : null,
              fontColor: _pin.length == 6 && !widget.isLoading
                  ? Theme.of(context).primaryColorLight
                  : Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 60),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: GridView.count(
              padding: EdgeInsets.zero,
              crossAxisCount: 3,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              childAspectRatio: 2.5,
              children: [
                ...['1', '2', '3', '4', '5', '6', '7', '8', '9'].map((e) => _buildKey(e)),
                _buildIcon(Icons.check, _submitOtp),
                _buildKey('0'),
                _buildIcon(Icons.backspace, _deleteDigit),
              ],
            ),
          ),
          const SizedBox(height: 10),
        ],
      ],
    );
  }

  Widget _buildKey(String label) {
    return ElevatedButton(
      onPressed: () => _addDigit(label),
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
      ),
      child: Text(label, style: const TextStyle(fontSize: 20)),
    );
  }

  Widget _buildIcon(IconData icon, VoidCallback onTap) {
    return ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        backgroundColor: Colors.grey.shade600,
        foregroundColor: Colors.white,
        elevation: 1,
      ),
      child: Icon(icon, size: 20),
    );
  }

  Widget _buildResendRow() {
    return GestureDetector(
      onTap: widget.canResend ? widget.onResend : null,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              RichText(
                text: TextSpan(
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: const Color(0xFF606060),
                    fontWeight: FontWeight.w400,
                  ),
                  children: [
                    const TextSpan(text: "Didn't get the code? "),
                    TextSpan(
                      text: widget.countdownSeconds > 0
                          ? 'Resend in ${widget.countdownSeconds}s'
                          : 'Resend',
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: widget.canResend ? Colors.black : Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (widget.errorMessage != null) ...[
            const SizedBox(height: 8),
            Text(
              widget.errorMessage!,
              style: const TextStyle(color: Colors.red, fontSize: 12),
            ),
          ],
        ],
      ),
    );
  }
}