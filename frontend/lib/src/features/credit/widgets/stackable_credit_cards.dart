import 'package:flutter/material.dart';
import 'package:card_stack_widget/card_stack_widget.dart';
import '../models/credit_card_model.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';

class StackableCreditCards extends StatefulWidget {
  const StackableCreditCards({
    required this.cards,
    required this.onCardTap,
    super.key,
  });

  final List<CreditCardModel> cards;
  final ValueChanged<int> onCardTap;

  @override
  State<StackableCreditCards> createState() => _StackableCreditCardsState();
}

class _StackableCreditCardsState extends State<StackableCreditCards> {
  List<CardModel>? _cardModels;
  List<CreditCardModel> _orderedCards = [];

  @override
  void initState() {
    super.initState();
    _orderedCards = List.from(widget.cards);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _buildCardModels();
    });
  }

  @override
  void didUpdateWidget(StackableCreditCards oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.cards != widget.cards) {
      _orderedCards = List.from(widget.cards);
      _buildCardModels();
    }
  }

  void _buildCardModels() {
    if (!mounted) return;

    final screenWidth = MediaQuery.of(context).size.width - 32;

    setState(() {
      _cardModels = _orderedCards
          .asMap()
          .entries
          .map((entry) => CardModel(
                radius: const Radius.circular(16),
                shadowColor: AppColors.primaryBlue.withOpacity(0.3),
                backgroundColor: Colors.transparent,
                child: SizedBox(
                  width: screenWidth,
                  height: 180,
                  child: _buildCardItem(entry.value, entry.key),
                ),
              ))
          .toList();
    });
  }

  void _moveCardToFront(int index) {
    if (index < 0 || index >= _orderedCards.length) return;

    setState(() {
      final tappedCard = _orderedCards.removeAt(index);
      _orderedCards.insert(0, tappedCard);
      _buildCardModels();
    });

    widget.onCardTap(index);
  }

  @override
  Widget build(BuildContext context) {
    if (widget.cards.isEmpty) {
      return _EmptyState();
    }

    if (_cardModels == null) {
      return const Center(
        child: CircularProgressIndicator(
          color: AppColors.primaryBlue,
        ),
      );
    }

    return CardStackWidget(
      cardList: _cardModels!,
      onCardTap: (cardModel) {
        final index = _cardModels!.indexOf(cardModel);
        if (index >= 0 && index < _orderedCards.length) {
          _moveCardToFront(index);
        }
      },
      animateCardScale: false,
      reverseOrder: true,
      alignment: Alignment.center,
      positionFactor: 3,
      scaleFactor: 1.0,
      swipeOrientation: CardOrientation.both,
      cardDismissOrientation: CardOrientation.none,
      opacityChangeOnDrag: true,
    );
  }

  Widget _buildCardItem(CreditCardModel card, int index) {
    return Container(
      width: double.infinity,
      height: 180,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: _getCardGradient(card.primaryColor),
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: AppSpacing.screenPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.asset(
                          card.bankLogoUrl,
                          width: 36,
                          height: 36,
                          fit: BoxFit.contain,
                          errorBuilder: (context, error, stackTrace) {
                            return const Center(
                              child: Icon(
                                Icons.account_balance,
                                color: AppColors.primaryBlue,
                                size: 20,
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    AppSpacing.horizontalSpaceSM,
                    Text(
                      card.bankName,
                      style: AppTextStyles.bodyMedium.copyWith(
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                        fontFamily: 'Inter',
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white24,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    card.cardScheme.displayName,
                    style: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                      fontFamily: 'Inter',
                    ),
                  ),
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  card.maskedCardNumber,
                  style: AppTextStyles.bodyLarge.copyWith(
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                    letterSpacing: 2,
                    fontFamily: 'Inter',
                  ),
                ),
                AppSpacing.verticalSpaceMD,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _CardInfoColumn(
                      label: 'Balance',
                      value: _formatCurrency(card.currentBalance),
                    ),
                    _CardInfoColumn(
                      label: 'Limit',
                      value: _formatCurrency(card.creditLimit),
                    ),
                    _CardInfoColumn(
                      label: 'Available',
                      value: _formatCurrency(card.availableCredit),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  List<Color> _getCardGradient(String primaryColorHex) {
    final baseColor =
        Color(int.parse(primaryColorHex.replaceFirst('#', '0xFF')));

    return [
      _darkenColor(baseColor, 0.3),
      _darkenColor(baseColor, 0.15),
      baseColor,
    ];
  }

  Color _darkenColor(Color color, double amount) {
    final hslColor = HSLColor.fromColor(color);
    final darkenedColor = hslColor.withLightness(
      (hslColor.lightness - amount).clamp(0.0, 1.0),
    );
    return darkenedColor.toColor();
  }

  String _formatCurrency(double amount) {
    if (amount >= 1000) {
      return 'RM ${(amount / 1000).toStringAsFixed(1)}k';
    }
    return 'RM ${amount.toStringAsFixed(0)}';
  }
}

class _EmptyState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 180,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.border,
          width: 2,
        ),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.credit_card_off,
              size: 48,
              color: AppColors.textTertiary,
            ),
            AppSpacing.verticalSpaceMD,
            Text(
              'No credit cards found',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondary,
                fontFamily: 'Inter',
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CardInfoColumn extends StatelessWidget {
  const _CardInfoColumn({
    required this.label,
    required this.value,
  });

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.labelSmall.copyWith(
            color: Colors.white60,
            fontFamily: 'Inter',
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: AppTextStyles.labelLarge.copyWith(
            fontWeight: FontWeight.w600,
            color: Colors.white,
            fontFamily: 'Inter',
          ),
        ),
      ],
    );
  }
}
