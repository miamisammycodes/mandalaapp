import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/auth/age_group.dart';
import '../../models/safety/safety_topic.dart';
import '../content/chapters_provider.dart';

/// Provider for all safety topics
final safetyTopicsProvider = Provider<List<SafetyTopic>>((ref) {
  return _mockSafetyTopics;
});

/// Provider for safety topics filtered by category
final safetyTopicsByCategoryProvider =
    Provider.family<List<SafetyTopic>, SafetyCategory>((ref, category) {
  final topics = ref.watch(safetyTopicsProvider);
  return topics.where((t) => t.category == category).toList();
});

/// Provider for a single safety topic by ID
final safetyTopicByIdProvider =
    Provider.family<SafetyTopic?, String>((ref, id) {
  final topics = ref.watch(safetyTopicsProvider);
  try {
    return topics.firstWhere((t) => t.id == id);
  } catch (_) {
    return null;
  }
});

/// Provider for age-filtered safety topics
final ageFilteredSafetyTopicsProvider = Provider<List<SafetyTopic>>((ref) {
  final topics = ref.watch(safetyTopicsProvider);
  final ageGroup = ref.watch(activeAgeGroupProvider);

  if (ageGroup == null) return topics; // Parents see all

  return topics.where((t) => t.isRelevantFor(ageGroup)).toList();
});

/// Provider for all safety tips
final safetyTipsProvider = Provider<List<SafetyTip>>((ref) {
  return _mockSafetyTips;
});

/// Provider for safety tips filtered by audience (parents vs children)
final safetyTipsForParentsProvider = Provider<List<SafetyTip>>((ref) {
  final tips = ref.watch(safetyTipsProvider);
  return tips.where((t) => t.forParents).toList();
});

final safetyTipsForChildrenProvider = Provider<List<SafetyTip>>((ref) {
  final tips = ref.watch(safetyTipsProvider);
  final ageGroup = ref.watch(activeAgeGroupProvider);

  var childTips = tips.where((t) => !t.forParents).toList();

  if (ageGroup != null) {
    childTips = childTips
        .where((t) =>
            t.targetAgeGroups.isEmpty || t.targetAgeGroups.contains(ageGroup))
        .toList();
  }

  return childTips;
});

/// Provider for emergency contacts
final emergencyContactsProvider = Provider<List<EmergencyContact>>((ref) {
  return _emergencyContacts;
});

/// Emergency contact model
class EmergencyContact {
  final String name;
  final String phone;
  final String description;
  final bool isEmergency;

  const EmergencyContact({
    required this.name,
    required this.phone,
    required this.description,
    this.isEmergency = false,
  });
}

// Mock emergency contacts for Bhutan
const _emergencyContacts = [
  EmergencyContact(
    name: 'Police Emergency',
    phone: '113',
    description: 'For immediate danger or crime',
    isEmergency: true,
  ),
  EmergencyContact(
    name: 'Child Helpline',
    phone: '1098',
    description: '24/7 support for children in need',
    isEmergency: true,
  ),
  EmergencyContact(
    name: 'RENEW (Women & Children)',
    phone: '+975-2-334751',
    description: 'Support for women and children',
    isEmergency: false,
  ),
  EmergencyContact(
    name: 'NCWC (Child Welfare)',
    phone: '+975-2-325987',
    description: 'National Commission for Women and Children',
    isEmergency: false,
  ),
];

// Mock safety topics data
final _mockSafetyTopics = [
  // CONTENT risks
  SafetyTopic(
    id: 'content-1',
    category: SafetyCategory.content,
    title: 'Harmful Content Online',
    description: 'Protecting children from inappropriate material',
    content: '''
## What is Harmful Content?

Harmful content includes any material that is inappropriate for children's age and development, including:

- **Violent content** - Graphic violence, gore, or disturbing imagery
- **Adult content** - Material meant only for adults
- **Hate speech** - Content promoting discrimination or hatred
- **Misinformation** - False or misleading information

## Warning Signs

Your child may have seen harmful content if they:
- Suddenly change their online behavior
- Become secretive about their device usage
- Show signs of distress after being online
- Ask unusual questions about mature topics

## What Parents Can Do

1. **Use parental controls** on all devices
2. **Monitor** browsing history regularly
3. **Create a safe space** for children to talk about what they see
4. **Educate** children about identifying harmful content
5. **Set clear rules** about what content is acceptable
''',
    targetAgeGroups: AgeGroup.values,
    tips: [
      const SafetyTip(
        id: 'content-tip-1',
        title: 'Enable Safe Search',
        content:
            'Turn on safe search filters on all browsers and apps your child uses.',
        category: SafetyCategory.content,
        forParents: true,
      ),
    ],
    order: 1,
  ),
  SafetyTopic(
    id: 'content-2',
    category: SafetyCategory.content,
    title: 'Age-Appropriate Media',
    description: 'Choosing the right content for your child\'s age',
    content: '''
## Age Guidelines for Content

### Ages 0-5
- Educational videos and apps
- Simple games with no violence
- Parent-supervised viewing only

### Ages 6-12
- Age-rated games and movies
- Educational content
- Limited social media (with supervision)

### Ages 13-17
- Teen-rated content with discussion
- Supervised social media use
- Open conversations about online content

## Tips for Choosing Content

1. **Check age ratings** on all media
2. **Preview content** before allowing children to view
3. **Watch together** when possible
4. **Discuss** what they're watching or playing
''',
    targetAgeGroups: AgeGroup.values,
    tips: [],
    order: 2,
  ),

  // CONDUCT risks
  SafetyTopic(
    id: 'conduct-1',
    category: SafetyCategory.conduct,
    title: 'Cyberbullying',
    description: 'Recognizing and preventing online harassment',
    content: '''
## What is Cyberbullying?

Cyberbullying is bullying that takes place online through:
- Social media posts and comments
- Text messages or chat apps
- Online gaming platforms
- Email or instant messaging

## Forms of Cyberbullying

- **Harassment** - Repeated mean messages
- **Exclusion** - Deliberately leaving someone out online
- **Outing** - Sharing private information publicly
- **Impersonation** - Pretending to be someone else
- **Trolling** - Posting to upset others

## Warning Signs

- Avoiding devices or social media
- Appearing upset after being online
- Reluctance to go to school
- Changes in mood, sleep, or appetite
- Secretive behavior about online activity

## What to Do

1. **Don't respond** to the bully
2. **Save evidence** (screenshots)
3. **Block** the person
4. **Report** to the platform
5. **Tell a trusted adult**
''',
    targetAgeGroups: [AgeGroup.toddler, AgeGroup.child, AgeGroup.teen],
    tips: [
      const SafetyTip(
        id: 'conduct-tip-1',
        title: 'Be Kind Online',
        content:
            'Treat others online the way you want to be treated. Think before you post!',
        category: SafetyCategory.conduct,
        forParents: false,
        targetAgeGroups: [AgeGroup.child, AgeGroup.teen],
      ),
    ],
    order: 1,
  ),
  SafetyTopic(
    id: 'conduct-2',
    category: SafetyCategory.conduct,
    title: 'Digital Citizenship',
    description: 'Being a responsible online citizen',
    content: '''
## What is Digital Citizenship?

Being a good digital citizen means:
- Being **respectful** to others online
- Being **responsible** for your actions
- Being **safe** with personal information
- Being **smart** about what you share

## Online Etiquette Rules

1. **Think before you post** - Would you say it in person?
2. **Respect others' privacy** - Ask before sharing photos
3. **Give credit** - Don't copy others' work
4. **Be honest** - Don't pretend to be someone else
5. **Stand up** - Report bullying when you see it

## Building a Positive Digital Footprint

Everything you do online leaves a trace. Make sure your digital footprint shows:
- Kindness and respect
- Creativity and achievement
- Positive contributions to communities
''',
    targetAgeGroups: [AgeGroup.child, AgeGroup.teen],
    tips: [],
    order: 2,
  ),

  // CONTACT risks
  SafetyTopic(
    id: 'contact-1',
    category: SafetyCategory.contact,
    title: 'Stranger Danger Online',
    description: 'Protecting children from online predators',
    content: '''
## Online Stranger Danger

Just like in the real world, not everyone online is who they say they are. Online predators may:
- Pretend to be children or teens
- Build trust slowly over time
- Ask for personal information
- Try to meet in person

## Warning Signs of Grooming

- An adult showing unusual interest in your child
- Receiving gifts or money from online contacts
- Secretive behavior about online friendships
- New contacts your child won't discuss

## Safety Rules for Children

1. **Never share** personal information with strangers
2. **Never meet** online friends in person without a parent
3. **Tell a parent** if someone makes you uncomfortable
4. **Block and report** suspicious contacts

## What Parents Should Do

1. Know who your child talks to online
2. Keep devices in common areas
3. Have regular conversations about online friends
4. Trust your instincts - if something feels wrong, investigate
''',
    targetAgeGroups: AgeGroup.values,
    tips: [
      const SafetyTip(
        id: 'contact-tip-1',
        title: 'Keep Secrets Safe',
        content:
            'Never tell anyone online your real name, address, school, or phone number.',
        category: SafetyCategory.contact,
        forParents: false,
        targetAgeGroups: [AgeGroup.toddler, AgeGroup.child, AgeGroup.teen],
      ),
    ],
    order: 1,
  ),
  SafetyTopic(
    id: 'contact-2',
    category: SafetyCategory.contact,
    title: 'Safe Social Media Use',
    description: 'Guidelines for social media safety',
    content: '''
## Social Media Safety

Social media can be fun, but it requires careful use:

## Age Requirements

Most social media platforms require users to be at least 13 years old. This is for good reason - younger children are more vulnerable to online risks.

## Privacy Settings

1. **Set profiles to private**
2. **Only accept friend requests** from people you know in real life
3. **Review** what information is visible to others
4. **Turn off** location sharing

## Safe Posting Guidelines

- Never post your location in real-time
- Don't share personal details (school, address, phone)
- Think about who might see your posts
- Remember: posts can be screenshot and shared

## Red Flags to Watch For

- Strangers trying to connect
- Requests for personal information
- Pressure to share photos
- Anyone who asks you to keep secrets from parents
''',
    targetAgeGroups: [AgeGroup.child, AgeGroup.teen],
    tips: [],
    order: 2,
  ),

  // CONTRACT risks
  SafetyTopic(
    id: 'contract-1',
    category: SafetyCategory.contract,
    title: 'Privacy & Data Protection',
    description: 'Keeping personal information safe online',
    content: '''
## Why Privacy Matters

Your personal information is valuable. Companies, hackers, and others want your data for:
- Targeted advertising
- Identity theft
- Scams and fraud
- Selling to third parties

## What is Personal Information?

- Full name
- Date of birth
- Address and phone number
- School name
- Photos
- Location data
- Passwords

## Protecting Your Privacy

1. **Use strong passwords** - Different for each account
2. **Enable two-factor authentication** where possible
3. **Read privacy policies** (or ask a parent to help)
4. **Limit what you share** on social media
5. **Be careful with apps** - Check what permissions they request

## Your Rights

Under data protection laws, you have the right to:
- Know what data is collected about you
- Request deletion of your data
- Opt out of data collection
''',
    targetAgeGroups: [AgeGroup.child, AgeGroup.teen],
    tips: [
      const SafetyTip(
        id: 'contract-tip-1',
        title: 'Strong Passwords',
        content:
            'Use a mix of letters, numbers, and symbols. Never use your name or birthday!',
        category: SafetyCategory.contract,
        forParents: false,
        targetAgeGroups: [AgeGroup.child, AgeGroup.teen],
      ),
    ],
    order: 1,
  ),
  SafetyTopic(
    id: 'contract-2',
    category: SafetyCategory.contract,
    title: 'Online Scams & Fraud',
    description: 'Recognizing and avoiding online scams',
    content: '''
## Common Online Scams

### Phishing
Fake emails or messages pretending to be from trusted sources, asking for personal information or passwords.

### Prize Scams
"You've won!" messages that ask for payment or personal details to claim a prize.

### In-App Purchases
Games that trick children into spending real money on virtual items.

### Fake Websites
Websites designed to look legitimate but steal your information.

## Warning Signs of Scams

- Too good to be true offers
- Urgency ("Act now!")
- Requests for money or personal information
- Poor spelling and grammar
- Suspicious email addresses or links

## How to Stay Safe

1. **Never click** suspicious links
2. **Verify** before sharing any information
3. **Ask a parent** before buying anything online
4. **Report** suspicious messages
5. **Use secure payment** methods only

## If You've Been Scammed

1. Tell a parent immediately
2. Change passwords
3. Report to the platform
4. Monitor accounts for suspicious activity
''',
    targetAgeGroups: [AgeGroup.child, AgeGroup.teen],
    tips: [],
    order: 2,
  ),
];

// Mock safety tips
const _mockSafetyTips = [
  // Tips for Parents
  SafetyTip(
    id: 'parent-tip-1',
    title: 'Keep Devices in Common Areas',
    content:
        'Place computers and devices in shared family spaces where you can easily monitor activity.',
    forParents: true,
  ),
  SafetyTip(
    id: 'parent-tip-2',
    title: 'Set Screen Time Limits',
    content:
        'Establish clear rules about when and how long children can use devices.',
    forParents: true,
  ),
  SafetyTip(
    id: 'parent-tip-3',
    title: 'Have Regular Conversations',
    content:
        'Talk openly with your children about their online activities without judgment.',
    forParents: true,
  ),
  SafetyTip(
    id: 'parent-tip-4',
    title: 'Know Their Online Friends',
    content:
        'Ask about who they talk to online, just as you would about their school friends.',
    forParents: true,
  ),
  SafetyTip(
    id: 'parent-tip-5',
    title: 'Use Parental Controls',
    content:
        'Set up parental controls on devices, browsers, and apps to filter inappropriate content.',
    forParents: true,
  ),

  // Tips for Children (younger)
  SafetyTip(
    id: 'child-tip-1',
    title: 'Tell a Grown-Up',
    content:
        'If something online makes you scared or uncomfortable, always tell a parent or teacher.',
    forParents: false,
    targetAgeGroups: [AgeGroup.toddler, AgeGroup.child],
  ),
  SafetyTip(
    id: 'child-tip-2',
    title: 'Keep Secrets Safe',
    content:
        'Never tell anyone online your name, where you live, or what school you go to.',
    forParents: false,
    targetAgeGroups: [AgeGroup.toddler, AgeGroup.child],
  ),
  SafetyTip(
    id: 'child-tip-3',
    title: 'Ask Before Clicking',
    content:
        'Always ask a parent before clicking on links, downloading apps, or buying anything.',
    forParents: false,
    targetAgeGroups: [AgeGroup.toddler, AgeGroup.child],
  ),

  // Tips for Teens
  SafetyTip(
    id: 'teen-tip-1',
    title: 'Think Before You Post',
    content:
        'Once something is online, it can be there forever. Consider how posts might affect your future.',
    forParents: false,
    targetAgeGroups: [AgeGroup.teen],
  ),
  SafetyTip(
    id: 'teen-tip-2',
    title: 'Protect Your Passwords',
    content:
        'Use strong, unique passwords for each account. Never share them with friends.',
    forParents: false,
    targetAgeGroups: [AgeGroup.child, AgeGroup.teen],
  ),
  SafetyTip(
    id: 'teen-tip-3',
    title: 'Be Skeptical',
    content:
        'Not everything online is true. Question information and verify before believing or sharing.',
    forParents: false,
    targetAgeGroups: [AgeGroup.teen],
  ),
  SafetyTip(
    id: 'teen-tip-4',
    title: 'Stand Up to Bullying',
    content:
        'Don\'t participate in cyberbullying. Report it when you see it and support those being bullied.',
    forParents: false,
    targetAgeGroups: [AgeGroup.child, AgeGroup.teen],
  ),
];
