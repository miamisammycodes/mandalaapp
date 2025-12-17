import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_dimensions.dart';

/// Widget for rendering markdown content
class MarkdownContent extends StatelessWidget {
  final String data;
  final bool isChildFriendly;
  final bool selectable;

  const MarkdownContent({
    super.key,
    required this.data,
    this.isChildFriendly = false,
    this.selectable = true,
  });

  @override
  Widget build(BuildContext context) {
    final textScaleFactor = isChildFriendly ? 1.15 : 1.0;

    return MarkdownBody(
      data: data,
      selectable: selectable,
      styleSheet: _buildStyleSheet(context, textScaleFactor),
      onTapLink: (text, href, title) {
        if (href != null) {
          _launchUrl(href);
        }
      },
    );
  }

  MarkdownStyleSheet _buildStyleSheet(
      BuildContext context, double textScaleFactor) {
    final baseTextStyle = Theme.of(context).textTheme.bodyMedium?.copyWith(
          color: AppColors.textDark,
          height: 1.6,
          fontSize: 14 * textScaleFactor,
        );

    return MarkdownStyleSheet(
      // Paragraphs
      p: baseTextStyle,
      pPadding: EdgeInsets.only(bottom: AppDimensions.spaceSm),

      // Headings
      h1: Theme.of(context).textTheme.headlineMedium?.copyWith(
            color: AppColors.textDark,
            fontWeight: FontWeight.bold,
            fontSize: 24 * textScaleFactor,
          ),
      h1Padding: EdgeInsets.only(
        top: AppDimensions.spaceMd,
        bottom: AppDimensions.spaceSm,
      ),
      h2: Theme.of(context).textTheme.headlineSmall?.copyWith(
            color: AppColors.textDark,
            fontWeight: FontWeight.bold,
            fontSize: 20 * textScaleFactor,
          ),
      h2Padding: EdgeInsets.only(
        top: AppDimensions.spaceMd,
        bottom: AppDimensions.spaceXs,
      ),
      h3: Theme.of(context).textTheme.titleLarge?.copyWith(
            color: AppColors.textDark,
            fontWeight: FontWeight.w600,
            fontSize: 18 * textScaleFactor,
          ),
      h3Padding: EdgeInsets.only(
        top: AppDimensions.spaceSm,
        bottom: AppDimensions.spaceXs,
      ),
      h4: Theme.of(context).textTheme.titleMedium?.copyWith(
            color: AppColors.textDark,
            fontWeight: FontWeight.w600,
            fontSize: 16 * textScaleFactor,
          ),
      h5: Theme.of(context).textTheme.titleSmall?.copyWith(
            color: AppColors.textDark,
            fontWeight: FontWeight.w600,
            fontSize: 14 * textScaleFactor,
          ),
      h6: Theme.of(context).textTheme.bodyLarge?.copyWith(
            color: AppColors.textMedium,
            fontWeight: FontWeight.w600,
            fontSize: 14 * textScaleFactor,
          ),

      // Strong and emphasis
      strong: baseTextStyle?.copyWith(fontWeight: FontWeight.bold),
      em: baseTextStyle?.copyWith(fontStyle: FontStyle.italic),

      // Lists
      listBullet: baseTextStyle?.copyWith(
        color: AppColors.unicefBlue,
      ),
      listIndent: 24.0,
      listBulletPadding: EdgeInsets.only(right: AppDimensions.spaceXs),

      // Links
      a: baseTextStyle?.copyWith(
        color: AppColors.unicefBlue,
        decoration: TextDecoration.underline,
      ),

      // Blockquotes
      blockquote: baseTextStyle?.copyWith(
        color: AppColors.textMedium,
        fontStyle: FontStyle.italic,
      ),
      blockquoteDecoration: BoxDecoration(
        border: Border(
          left: BorderSide(
            color: AppColors.unicefBlue.withValues(alpha: 0.5),
            width: 4,
          ),
        ),
        color: AppColors.unicefBlue.withValues(alpha: 0.05),
      ),
      blockquotePadding: EdgeInsets.all(AppDimensions.spaceSm),

      // Code
      code: TextStyle(
        fontFamily: 'monospace',
        fontSize: 13 * textScaleFactor,
        color: AppColors.textDark,
        backgroundColor: AppColors.surfaceGray,
      ),
      codeblockDecoration: BoxDecoration(
        color: AppColors.surfaceGray,
        borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
      ),
      codeblockPadding: EdgeInsets.all(AppDimensions.spaceSm),

      // Horizontal rule
      horizontalRuleDecoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: AppColors.surfaceGray,
            width: 1,
          ),
        ),
      ),

      // Tables
      tableHead: baseTextStyle?.copyWith(fontWeight: FontWeight.bold),
      tableBody: baseTextStyle,
      tableBorder: TableBorder.all(
        color: AppColors.surfaceGray,
        width: 1,
      ),
      tableHeadAlign: TextAlign.center,
      tableCellsPadding: EdgeInsets.all(AppDimensions.spaceXs),
    );
  }

  Future<void> _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }
}

/// Scrollable markdown content with loading state
class ScrollableMarkdownContent extends StatelessWidget {
  final String data;
  final bool isChildFriendly;
  final bool isLoading;

  const ScrollableMarkdownContent({
    super.key,
    required this.data,
    this.isChildFriendly = false,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(
        child: CircularProgressIndicator(
          color: AppColors.unicefBlue,
        ),
      );
    }

    return SingleChildScrollView(
      padding: EdgeInsets.all(AppDimensions.spaceMd),
      child: MarkdownContent(
        data: data,
        isChildFriendly: isChildFriendly,
      ),
    );
  }
}
