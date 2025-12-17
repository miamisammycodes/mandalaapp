import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_dimensions.dart';

/// Expandable/collapsible section widget for chapter content
class ExpandableSection extends StatefulWidget {
  final String title;
  final String? subtitle;
  final IconData? icon;
  final Widget content;
  final bool initiallyExpanded;
  final bool isChildFriendly;
  final Color? headerColor;

  const ExpandableSection({
    super.key,
    required this.title,
    this.subtitle,
    this.icon,
    required this.content,
    this.initiallyExpanded = false,
    this.isChildFriendly = false,
    this.headerColor,
  });

  @override
  State<ExpandableSection> createState() => _ExpandableSectionState();
}

class _ExpandableSectionState extends State<ExpandableSection>
    with SingleTickerProviderStateMixin {
  late bool _isExpanded;
  late AnimationController _animationController;
  late Animation<double> _expandAnimation;
  late Animation<double> _rotateAnimation;

  @override
  void initState() {
    super.initState();
    _isExpanded = widget.initiallyExpanded;
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _expandAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
    _rotateAnimation = Tween<double>(begin: 0, end: 0.5).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    if (_isExpanded) {
      _animationController.value = 1.0;
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _toggleExpand() {
    setState(() {
      _isExpanded = !_isExpanded;
      if (_isExpanded) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final headerColor = widget.headerColor ?? AppColors.unicefBlue;

    return Container(
      margin: EdgeInsets.only(bottom: AppDimensions.spaceSm),
      decoration: BoxDecoration(
        color: AppColors.cardWhite,
        borderRadius: BorderRadius.circular(
          widget.isChildFriendly
              ? AppDimensions.radiusLg
              : AppDimensions.radiusMd,
        ),
        border: Border.all(
          color: _isExpanded
              ? headerColor.withValues(alpha: 0.3)
              : AppColors.surfaceGray,
          width: _isExpanded ? 2 : 1,
        ),
        boxShadow: _isExpanded
            ? [
                BoxShadow(
                  color: headerColor.withValues(alpha: 0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ]
            : null,
      ),
      child: Column(
        children: [
          // Header
          InkWell(
            onTap: _toggleExpand,
            borderRadius: BorderRadius.circular(
              widget.isChildFriendly
                  ? AppDimensions.radiusLg
                  : AppDimensions.radiusMd,
            ),
            child: Container(
              padding: EdgeInsets.all(
                widget.isChildFriendly
                    ? AppDimensions.spaceMd
                    : AppDimensions.spaceSm + 4,
              ),
              child: Row(
                children: [
                  if (widget.icon != null) ...[
                    Container(
                      width: widget.isChildFriendly ? 44 : 36,
                      height: widget.isChildFriendly ? 44 : 36,
                      decoration: BoxDecoration(
                        color: headerColor.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(
                          widget.isChildFriendly
                              ? AppDimensions.radiusMd
                              : AppDimensions.radiusSm,
                        ),
                      ),
                      child: Icon(
                        widget.icon,
                        color: headerColor,
                        size: widget.isChildFriendly ? 24 : 20,
                      ),
                    ),
                    SizedBox(width: AppDimensions.spaceSm),
                  ],
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.title,
                          style: widget.isChildFriendly
                              ? Theme.of(context).textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: _isExpanded
                                        ? headerColor
                                        : AppColors.textDark,
                                  )
                              : Theme.of(context).textTheme.titleSmall?.copyWith(
                                    fontWeight: FontWeight.w600,
                                    color: _isExpanded
                                        ? headerColor
                                        : AppColors.textDark,
                                  ),
                        ),
                        if (widget.subtitle != null) ...[
                          const SizedBox(height: 2),
                          Text(
                            widget.subtitle!,
                            style:
                                Theme.of(context).textTheme.bodySmall?.copyWith(
                                      color: AppColors.textMedium,
                                    ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  RotationTransition(
                    turns: _rotateAnimation,
                    child: Icon(
                      Icons.keyboard_arrow_down,
                      color: _isExpanded ? headerColor : AppColors.textMedium,
                      size: widget.isChildFriendly ? 28 : 24,
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Content
          SizeTransition(
            sizeFactor: _expandAnimation,
            child: Column(
              children: [
                Divider(height: 1, color: AppColors.surfaceGray),
                Padding(
                  padding: EdgeInsets.all(
                    widget.isChildFriendly
                        ? AppDimensions.spaceMd
                        : AppDimensions.spaceSm + 4,
                  ),
                  child: widget.content,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Simple expandable text section
class ExpandableTextSection extends StatelessWidget {
  final String title;
  final String content;
  final IconData? icon;
  final bool initiallyExpanded;
  final bool isChildFriendly;
  final Color? headerColor;

  const ExpandableTextSection({
    super.key,
    required this.title,
    required this.content,
    this.icon,
    this.initiallyExpanded = false,
    this.isChildFriendly = false,
    this.headerColor,
  });

  @override
  Widget build(BuildContext context) {
    return ExpandableSection(
      title: title,
      icon: icon,
      initiallyExpanded: initiallyExpanded,
      isChildFriendly: isChildFriendly,
      headerColor: headerColor,
      content: Text(
        content,
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppColors.textDark,
              height: 1.6,
            ),
      ),
    );
  }
}
