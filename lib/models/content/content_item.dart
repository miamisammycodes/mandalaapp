import 'package:flutter/foundation.dart';

/// Content item types
enum ContentType {
  text,
  markdown,
  video,
  image,
  quiz,
}

/// Individual content piece within a topic
@immutable
class ContentItem {
  final String id;
  final String topicId;
  final ContentType type;
  final String title;
  final String content; // Markdown text, video URL, or image URL
  final int order;
  final Map<String, dynamic>? metadata;

  const ContentItem({
    required this.id,
    required this.topicId,
    required this.type,
    required this.title,
    required this.content,
    required this.order,
    this.metadata,
  });

  /// Whether this is video content
  bool get isVideo => type == ContentType.video;

  /// Whether this is text/markdown content
  bool get isText => type == ContentType.text || type == ContentType.markdown;

  ContentItem copyWith({
    String? id,
    String? topicId,
    ContentType? type,
    String? title,
    String? content,
    int? order,
    Map<String, dynamic>? metadata,
  }) {
    return ContentItem(
      id: id ?? this.id,
      topicId: topicId ?? this.topicId,
      type: type ?? this.type,
      title: title ?? this.title,
      content: content ?? this.content,
      order: order ?? this.order,
      metadata: metadata ?? this.metadata,
    );
  }

  factory ContentItem.fromJson(Map<String, dynamic> json) {
    return ContentItem(
      id: json['id'] as String,
      topicId: json['topicId'] as String,
      type: ContentType.values.firstWhere(
        (e) => e.name == json['type'],
        orElse: () => ContentType.markdown,
      ),
      title: json['title'] as String,
      content: json['content'] as String,
      order: json['order'] as int? ?? 0,
      metadata: json['metadata'] as Map<String, dynamic>?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'topicId': topicId,
      'type': type.name,
      'title': title,
      'content': content,
      'order': order,
      'metadata': metadata,
    };
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ContentItem && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'ContentItem($id: $title, type: $type)';
}

/// Parsed markdown content for display
@immutable
class ParsedContent {
  final String rawMarkdown;
  final List<ContentSection> sections;

  const ParsedContent({
    required this.rawMarkdown,
    required this.sections,
  });

  factory ParsedContent.empty() => const ParsedContent(
        rawMarkdown: '',
        sections: [],
      );

  factory ParsedContent.fromMarkdown(String markdown) {
    // Parse markdown into sections (headers, paragraphs, lists, etc.)
    final sections = <ContentSection>[];
    final lines = markdown.split('\n');
    final buffer = StringBuffer();
    String? currentType;

    for (final line in lines) {
      if (line.startsWith('# ')) {
        if (buffer.isNotEmpty && currentType != null) {
          sections.add(ContentSection(
            type: currentType,
            content: buffer.toString().trim(),
          ));
          buffer.clear();
        }
        currentType = 'h1';
        buffer.writeln(line.substring(2));
      } else if (line.startsWith('## ')) {
        if (buffer.isNotEmpty && currentType != null) {
          sections.add(ContentSection(
            type: currentType,
            content: buffer.toString().trim(),
          ));
          buffer.clear();
        }
        currentType = 'h2';
        buffer.writeln(line.substring(3));
      } else if (line.startsWith('- ') || line.startsWith('* ')) {
        if (currentType != 'list' && buffer.isNotEmpty && currentType != null) {
          sections.add(ContentSection(
            type: currentType,
            content: buffer.toString().trim(),
          ));
          buffer.clear();
        }
        currentType = 'list';
        buffer.writeln(line);
      } else {
        if (currentType == 'list' && !line.startsWith('  ') && line.isNotEmpty) {
          sections.add(ContentSection(
            type: currentType!,
            content: buffer.toString().trim(),
          ));
          buffer.clear();
          currentType = 'paragraph';
        }
        currentType ??= 'paragraph';
        buffer.writeln(line);
      }
    }

    if (buffer.isNotEmpty && currentType != null) {
      sections.add(ContentSection(
        type: currentType,
        content: buffer.toString().trim(),
      ));
    }

    return ParsedContent(
      rawMarkdown: markdown,
      sections: sections,
    );
  }
}

/// Section of parsed content
@immutable
class ContentSection {
  final String type; // h1, h2, paragraph, list, etc.
  final String content;

  const ContentSection({
    required this.type,
    required this.content,
  });

  bool get isHeading => type == 'h1' || type == 'h2';
  bool get isList => type == 'list';
  bool get isParagraph => type == 'paragraph';
}
