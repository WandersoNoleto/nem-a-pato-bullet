import 'dart:math';

import 'package:flutter/material.dart';

import '../../domain/question.dart';
import '../../l10n/l10n.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import 'raised_box.dart';

/// The question card; flips in 3D to show the answer when [revealed].
class QuestionCard extends StatefulWidget {
  const QuestionCard({
    super.key,
    required this.question,
    required this.revealed,
  });

  final Question question;
  final bool revealed;

  @override
  State<QuestionCard> createState() => _QuestionCardState();
}

class _QuestionCardState extends State<QuestionCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _flip = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 450),
    value: widget.revealed ? 1 : 0,
  );
  late final Animation<double> _angle = CurvedAnimation(
    parent: _flip,
    curve: Curves.easeInOutBack,
  ).drive(Tween(begin: 0.0, end: pi));

  @override
  void didUpdateWidget(QuestionCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.revealed != oldWidget.revealed) {
      widget.revealed ? _flip.forward() : _flip.value = 0;
    }
  }

  @override
  void dispose() {
    _flip.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _angle,
      builder: (context, _) {
        final angle = _angle.value;
        final showBack = angle > pi / 2;
        return Transform(
          alignment: Alignment.center,
          transform: Matrix4.identity()
            ..setEntry(3, 2, 0.001)
            ..rotateY(angle),
          child: showBack
              ? Transform(
                  alignment: Alignment.center,
                  transform: Matrix4.rotationY(pi),
                  child: _AnswerFace(question: widget.question),
                )
              : _QuestionFace(question: widget.question),
        );
      },
    );
  }
}

class _CardFrame extends StatelessWidget {
  const _CardFrame({
    required this.category,
    required this.headerColors,
    required this.headerTextColor,
    required this.child,
  });

  final String category;
  final List<Color> headerColors;
  final Color headerTextColor;
  final Widget child;

  static const _radius = 18.0;

  @override
  Widget build(BuildContext context) {
    return RaisedBox(
      colors: AppColors.paperGradient,
      radius: _radius,
      borderWidth: 3,
      lipHeight: 6,
      constraints: const BoxConstraints(minHeight: 300),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(_radius - 3),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: headerColors,
                ),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
              child: Text(
                category.toUpperCase(),
                style: AppTextStyles.category.copyWith(color: headerTextColor),
              ),
            ),
            Container(height: 3, color: AppColors.ink),
            Padding(padding: const EdgeInsets.all(24), child: child),
          ],
        ),
      ),
    );
  }
}

class _QuestionFace extends StatelessWidget {
  const _QuestionFace({required this.question});

  final Question question;

  @override
  Widget build(BuildContext context) {
    return _CardFrame(
      category: question.category,
      headerColors: AppColors.headerGradient,
      headerTextColor: AppColors.ink,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 32),
        child: Text(
          question.text,
          textAlign: TextAlign.center,
          style: AppTextStyles.question,
        ),
      ),
    );
  }
}

class _AnswerFace extends StatelessWidget {
  const _AnswerFace({required this.question});

  final Question question;

  @override
  Widget build(BuildContext context) {
    final fact = question.fact;
    return _CardFrame(
      category: question.category,
      headerColors: const [AppColors.ink, AppColors.ink],
      headerTextColor: AppColors.yellow,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            context.l10n.answerLabel,
            textAlign: TextAlign.center,
            style: AppTextStyles.cardLabel,
          ),
          const SizedBox(height: 6),
          Text(
            question.answer,
            textAlign: TextAlign.center,
            style: AppTextStyles.answer,
          ),
          if (fact != null) ...[
            const SizedBox(height: 20),
            Container(height: 2, color: AppColors.cardDivider),
            const SizedBox(height: 16),
            Text(
              context.l10n.factLabel,
              style: AppTextStyles.cardLabel.copyWith(color: AppColors.orange),
            ),
            const SizedBox(height: 6),
            Text(fact, style: AppTextStyles.fact),
          ],
        ],
      ),
    );
  }
}
