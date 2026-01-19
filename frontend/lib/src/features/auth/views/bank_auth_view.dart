import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../banking/models/bank_model.dart';
import '../models/bank_auth_state.dart';
import '../viewmodels/bank_auth_viewmodel.dart';
import 'otp_verification_view.dart';
import 'bank_selection_sheet.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';

class BankAuthView extends ConsumerStatefulWidget {
  const BankAuthView({
    required this.bank,
    super.key,
  });

  final Bank bank;

  @override
  ConsumerState<BankAuthView> createState() => _BankAuthViewState();
}

class _BankAuthViewState extends ConsumerState<BankAuthView> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool _showPasswordField = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(bankAuthViewModelProvider.notifier).reset();
    });
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _listenToAuthStateChanges();
    final isLoading = _isLoading();

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: _buildAppBar(),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: AppSpacing.screenPadding,
            child: _buildAuthCard(isLoading),
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return PreferredSize(
      preferredSize: const Size.fromHeight(kToolbarHeight + 16),
      child: Padding(
        padding: const EdgeInsets.only(top: 16.0, left: 8.0, right: 8.0),
        child: AppBar(
          backgroundColor: Colors.black,
          elevation: 0,
          automaticallyImplyLeading: false,
          title: Row(
            children: [
              _buildBankLogo(),
              AppSpacing.horizontalSpaceMD,
              _buildBankName(),
            ],
          ),
          actions: [_buildCancelButton()],
        ),
      ),
    );
  }

  Widget _buildBankLogo() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: Image.asset(
        widget.bank.logoAsset,
        height: 32,
        width: 32,
        fit: BoxFit.contain,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            height: 32,
            width: 32,
            color: widget.bank.brandColor,
            child: const Icon(
              Icons.account_balance,
              size: 16,
              color: Colors.white,
            ),
          );
        },
      ),
    );
  }

  Widget _buildBankName() {
    return Text(
      widget.bank.onlineBankingName,
      style: AppTextStyles.headingSmall.copyWith(
        fontWeight: FontWeight.normal,
        color: widget.bank.brandColor,
      ),
    );
  }

  Widget _buildCancelButton() {
    return TextButton(
      onPressed: _handleCancel,
      child: Text(
        'Cancel',
        style: AppTextStyles.bodyMedium.copyWith(
          color: Colors.white,
        ),
      ),
    );
  }

  void _handleCancel() {
    Navigator.pop(context);
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => const BankSelectionSheet(),
    );
  }

  Widget _buildAuthCard(bool isLoading) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 400),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(AppSpacing.xxl),
      child: Form(
        key: _formKey,
        child: _showPasswordField
            ? _buildPasswordStep(isLoading)
            : _buildUsernameStep(isLoading),
      ),
    );
  }

  Widget _buildUsernameStep(bool isLoading) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Welcome',
          style: AppTextStyles.headingMedium.copyWith(
            color: Colors.black,
          ),
          textAlign: TextAlign.center,
        ),
        AppSpacing.verticalSpaceXL,
        _SecurityNote(),
        AppSpacing.verticalSpaceXL,
        _buildTextField(
          controller: _usernameController,
          label: 'Username',
          hint: 'Enter your username',
          enabled: !isLoading,
          onSubmit: _onUsernameSubmit,
        ),
        AppSpacing.verticalSpaceXL,
        _buildSubmitButton(isLoading, 'Next', _onUsernameSubmit),
        AppSpacing.verticalSpaceLG,
        _buildForgotPasswordLink(),
        AppSpacing.verticalSpaceSM,
        _buildSignUpLink(),
        AppSpacing.verticalSpaceXXL,
        _SecurityInformation(),
      ],
    );
  }

  Widget _buildPasswordStep(bool isLoading) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Log in to ${widget.bank.onlineBankingName} online banking',
          style: AppTextStyles.headingMedium.copyWith(
            color: Colors.black,
          ),
          textAlign: TextAlign.left,
        ),
        AppSpacing.verticalSpaceXL,
        _SecurityNote(),
        AppSpacing.verticalSpaceXL,
        _buildUsernameDisplay(),
        AppSpacing.verticalSpaceLG,
        _buildTextField(
          controller: _passwordController,
          label: 'Password',
          hint: 'Enter your password',
          obscureText: true,
          enabled: !isLoading,
          autofocus: true,
          onSubmit: _onPasswordSubmit,
        ),
        AppSpacing.verticalSpaceXL,
        _buildSubmitButton(isLoading, 'Login', _onPasswordSubmit),
        AppSpacing.verticalSpaceLG,
        _buildForgotPasswordLink(),
        AppSpacing.verticalSpaceSM,
        _buildSignUpLink(),
      ],
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    bool obscureText = false,
    bool enabled = true,
    bool autofocus = false,
    required VoidCallback onSubmit,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$label:',
          style: AppTextStyles.bodyMedium.copyWith(
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        AppSpacing.verticalSpaceSM,
        TextFormField(
          controller: controller,
          style: AppTextStyles.bodyMedium.copyWith(
            color: Colors.black,
          ),
          decoration: InputDecoration(
            hintText: hint,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(4),
              borderSide: BorderSide(color: Colors.grey[400]!),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(4),
              borderSide: BorderSide(color: Colors.grey[400]!),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(4),
              borderSide: BorderSide(color: widget.bank.brandColor, width: 2),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 12,
            ),
            filled: true,
            fillColor: Colors.white,
          ),
          obscureText: obscureText,
          enabled: enabled,
          autofocus: autofocus,
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Please enter your $label';
            }
            return null;
          },
          onFieldSubmitted: (_) => onSubmit(),
        ),
      ],
    );
  }

  Widget _buildUsernameDisplay() {
    return RichText(
      text: TextSpan(
        style: AppTextStyles.bodyMedium.copyWith(
          color: Colors.black87,
        ),
        children: [
          const TextSpan(
            text: 'Username: ',
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
          TextSpan(
            text: _usernameController.text.trim(),
            style: const TextStyle(fontWeight: FontWeight.normal),
          ),
        ],
      ),
    );
  }

  Widget _buildSubmitButton(
      bool isLoading, String label, VoidCallback onPressed) {
    if (isLoading) {
      return Center(
        child: SizedBox(
          width: 24,
          height: 24,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            valueColor: AlwaysStoppedAnimation<Color>(widget.bank.brandColor),
          ),
        ),
      );
    }

    return Align(
      alignment: Alignment.centerRight,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: widget.bank.brandColor,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4),
          ),
          elevation: 0,
        ),
        child: Text(
          label,
          style: AppTextStyles.bodyMedium.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _buildForgotPasswordLink() {
    return Align(
      alignment: Alignment.centerLeft,
      child: TextButton(
        onPressed: () => _openBankWebsite('forgot'),
        style: TextButton.styleFrom(
          padding: EdgeInsets.zero,
          minimumSize: const Size(0, 0),
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
        child: Text(
          'Forgot login details?',
          style: AppTextStyles.labelLarge.copyWith(
            color: Colors.blue,
            decoration: TextDecoration.underline,
          ),
        ),
      ),
    );
  }

  Widget _buildSignUpLink() {
    return Wrap(
      children: [
        Text(
          "Don't have a ${widget.bank.onlineBankingName} account? ",
          style: AppTextStyles.labelLarge.copyWith(color: Colors.black87),
        ),
        InkWell(
          onTap: () => _openBankWebsite('signup'),
          child: Text(
            'Click here to sign up now',
            style: AppTextStyles.labelLarge.copyWith(
              color: Colors.blue,
              decoration: TextDecoration.underline,
            ),
          ),
        ),
      ],
    );
  }

  void _listenToAuthStateChanges() {
    ref.listen<BankAuthState>(bankAuthViewModelProvider, (previous, next) {
      next.when(
        initial: () {},
        usernameValidating: () {},
        usernameValid: (userIconUrl) {
          setState(() {
            _showPasswordField = true;
          });
        },
        usernameInvalid: (message) {
          _showErrorSnackbar(message);
        },
        passwordValidating: () {},
        passwordValid: () {},
        passwordInvalid: (message) {
          _showErrorSnackbar(message);
        },
        otpSent: (message) {
          _navigateToOtp();
        },
        error: (message) {
          _showErrorSnackbar(message);
        },
      );
    });
  }

  bool _isLoading() {
    final bankAuthState = ref.watch(bankAuthViewModelProvider);
    return bankAuthState.maybeWhen(
      usernameValidating: () => true,
      passwordValidating: () => true,
      orElse: () => false,
    );
  }

  Future<void> _onUsernameSubmit() async {
    if (!_formKey.currentState!.validate()) return;

    final username = _usernameController.text.trim();
    await ref
        .read(bankAuthViewModelProvider.notifier)
        .validateUsername(widget.bank.id, username);
  }

  Future<void> _onPasswordSubmit() async {
    if (!_formKey.currentState!.validate()) return;

    final password = _passwordController.text;
    await ref
        .read(bankAuthViewModelProvider.notifier)
        .validatePassword(password);
  }

  void _navigateToOtp() {
    final username = _usernameController.text.trim();

    Navigator.pushNamed(
      context,
      OtpVerificationView.routeName,
      arguments: {
        'bankId': widget.bank.id,
        'username': username,
        'bank': widget.bank,
      },
    );
  }

  void _showErrorSnackbar(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _openBankWebsite(String action) {
    final String url = widget.bank.websiteUrl;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Visit ${widget.bank.name}'),
        content: Text(
          'This would normally open the ${widget.bank.name} website for ${action == 'forgot' ? 'password recovery' : 'account registration'}.\n\nURL: $url',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}

class _SecurityNote extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: AppSpacing.cardPadding,
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Note:',
            style: TextStyle(
              color: AppColors.textTertiary,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
          AppSpacing.verticalSpaceSM,
          _SecurityBullet(text: 'You are in a secured site.'),
        ],
      ),
    );
  }
}

class _SecurityBullet extends StatelessWidget {
  const _SecurityBullet({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '• ',
          style: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.textTertiary,
          ),
        ),
        Expanded(
          child: Text(
            text,
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textTertiary,
            ),
          ),
        ),
      ],
    );
  }
}

class _SecurityInformation extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Security Information:',
          style: AppTextStyles.bodyMedium.copyWith(
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        AppSpacing.verticalSpaceMD,
        const _SecurityTip(text: 'Never login via email links'),
        AppSpacing.verticalSpaceXS,
        const _SecurityTip(text: 'Never reveal your PIN and/or Password to anyone'),
        AppSpacing.verticalSpaceXS,
        const _SecurityTip(
          text:
              'To report any suspicious websites or transactions, please call our fraud hotline.',
        ),
      ],
    );
  }
}

class _SecurityTip extends StatelessWidget {
  const _SecurityTip({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '• ',
          style: AppTextStyles.labelLarge
              .copyWith(color: Colors.black87, height: 1.5),
        ),
        Expanded(
          child: Text(
            text,
            style: AppTextStyles.labelLarge.copyWith(
              color: Colors.black87,
              height: 1.5,
            ),
          ),
        ),
      ],
    );
  }
}
