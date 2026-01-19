import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../viewmodels/auth_viewmodel.dart';
import '../../banking/models/bank_model.dart';
import '../../profile/views/data_consent_view.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';

/// OTP verification screen
class OtpVerificationView extends ConsumerStatefulWidget {
  const OtpVerificationView({super.key});

  static const routeName = '/auth/otp';

  @override
  ConsumerState<OtpVerificationView> createState() =>
      _OtpVerificationViewState();
}

class _OtpVerificationViewState extends ConsumerState<OtpVerificationView> {
  final _otpController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isVerifying = false;
  bool _isResending = false;
  int _remainingSeconds = 60;
  bool _canResend = false;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  @override
  void dispose() {
    _otpController.dispose();
    super.dispose();
  }

  void _startTimer() {
    setState(() {
      _remainingSeconds = 60;
      _canResend = false;
    });

    Future.delayed(const Duration(seconds: 1), _updateTimer);
  }

  void _updateTimer() {
    if (!mounted) return;

    if (_remainingSeconds > 0) {
      setState(() {
        _remainingSeconds--;
      });
      Future.delayed(const Duration(seconds: 1), _updateTimer);
    } else {
      setState(() {
        _canResend = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    final bankId = args?['bankId'] ?? 'unknown';
    final username = args?['username'] ?? '';
    final bank = args?['bank'] as Bank?;

    return Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/background.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            title: const Text('OTP Verification'),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppSpacing.xl),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Center(
                      child: Icon(
                        Icons.message_outlined,
                        size: 80,
                        color: Colors.blue,
                      ),
                    ),
                    AppSpacing.verticalSpaceXL,

                    const Text(
                      'Enter OTP Code',
                      style: AppTextStyles.displayMedium,
                      textAlign: TextAlign.center,
                    ),
                    AppSpacing.verticalSpaceMD,

                    Text(
                      'Enter the 6-digit OTP sent to your registered mobile number',
                      style:
                          AppTextStyles.bodyLarge.copyWith(color: Colors.grey),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: AppSpacing.xxxl),

                    // OTP input field
                    TextFormField(
                      controller: _otpController,
                      decoration: const InputDecoration(
                        labelText: 'OTP Code',
                        hintText: '******',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.pin),
                        counterText: '',
                      ),
                      keyboardType: TextInputType.number,
                      maxLength: 6,
                      textAlign: TextAlign.center,
                      style: AppTextStyles.headingLarge.copyWith(
                        letterSpacing: 8,
                        fontWeight: FontWeight.bold,
                      ),
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please enter OTP code';
                        }
                        if (value.length != 6) {
                          return 'OTP must be 6 digits';
                        }
                        return null;
                      },
                      onFieldSubmitted: (_) =>
                          _verifyOtp(bankId, username, bank),
                    ),
                    AppSpacing.verticalSpaceLG,

                    if (!_canResend)
                      Container(
                        padding: const EdgeInsets.all(AppSpacing.md),
                        decoration: BoxDecoration(
                          color: Colors.blue.shade50,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.timer_outlined,
                                color: Colors.blue, size: 20),
                            const SizedBox(width: AppSpacing.sm),
                            Text(
                              'Code expires in $_remainingSeconds seconds',
                              style: AppTextStyles.bodyMedium.copyWith(
                                color: Colors.blue,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    AppSpacing.verticalSpaceXXL,

                    if (_isVerifying)
                      const Center(child: CircularProgressIndicator())
                    else
                      ElevatedButton(
                        onPressed: () => _verifyOtp(bankId, username, bank),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                              vertical: AppSpacing.lg),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text(
                          'Verify OTP',
                          style: AppTextStyles.buttonMedium,
                        ),
                      ),
                    AppSpacing.verticalSpaceMD,

                    // Resend OTP
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Didn't receive OTP? ",
                          style: TextStyle(color: Colors.grey),
                        ),
                        if (_isResending)
                          const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        else
                          TextButton(
                            onPressed: _canResend ? _resendOtp : null,
                            child: Text(
                              _canResend
                                  ? 'Resend'
                                  : 'Resend ($_remainingSeconds)',
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ));
  }

  Future<void> _verifyOtp(String bankId, String username, Bank? bank) async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isVerifying = true);

    final otp = _otpController.text.trim();
    final isValid =
        await ref.read(authViewModelProvider.notifier).verifyOtp(otp);

    if (!mounted) return;

    if (isValid) {
      if (bank != null) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => DataConsentView(
              bank: bank,
              username: username,
            ),
          ),
        );
      } else {
        Navigator.of(context).pushNamedAndRemoveUntil(
          '/main',
          (route) => false,
        );
      }
    } else {
      setState(() => _isVerifying = false);
      _showErrorSnackBar('Invalid OTP. Please try again.');
    }
  }

  Future<void> _resendOtp() async {
    if (!_canResend) return;

    setState(() => _isResending = true);

    await ref.read(authViewModelProvider.notifier).resendOtp();

    if (!mounted) return;

    setState(() => _isResending = false);
    _startTimer();
    _showSuccessSnackBar('OTP has been resent to your mobile number');
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
      ),
    );
  }
}
