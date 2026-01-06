import '../../models/auth/age_group.dart';
import '../../models/content/icap_chapter.dart';

/// Service for loading ICAP educational content
/// Currently uses mock data, will later load from assets/API
class ContentService {
  ContentService._();
  static final instance = ContentService._();

  /// Get all chapters
  List<IcapChapter> getAllChapters() => _mockChapters;

  /// Get chapters filtered by age group
  List<IcapChapter> getChaptersForAgeGroup(AgeGroup ageGroup) {
    return _mockChapters
        .where((chapter) => chapter.isAvailableFor(ageGroup))
        .toList();
  }

  /// Get a single chapter by ID
  IcapChapter? getChapterById(String id) {
    return _mockChapters.where((c) => c.id == id).firstOrNull;
  }

  /// Get chapter content (markdown) for a topic
  Future<String> getTopicContent(String chapterId, String topicId) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 300));
    return _topicContent['$chapterId/$topicId'] ?? 'Content not found';
  }
}

/// Mock chapter data based on ICAP content
final List<IcapChapter> _mockChapters = [
  IcapChapter(
    id: 'chapter-1',
    chapterNumber: 1,
    title: 'Child Development',
    description: 'Overview of the 4 domains of child development',
    youtubeVideoId: 'aYCBdZLCDBQ', // UNICEF early childhood development
    icon: 'child_care',
    ageGroups: AgeGroup.values.toList(), // All age groups
    order: 1,
    topics: [
      const ChapterTopic(
        id: 'physical',
        title: 'Physical Development',
        icon: 'fitness_center',
        contentFile: 'physical.md',
        order: 1,
      ),
      const ChapterTopic(
        id: 'cognitive',
        title: 'Cognitive Development',
        icon: 'psychology',
        contentFile: 'cognitive.md',
        order: 2,
      ),
      const ChapterTopic(
        id: 'social-emotional',
        title: 'Social & Emotional Development',
        icon: 'favorite',
        contentFile: 'social-emotional.md',
        order: 3,
      ),
      const ChapterTopic(
        id: 'language',
        title: 'Language Development',
        icon: 'chat',
        contentFile: 'language.md',
        order: 4,
      ),
    ],
  ),
  IcapChapter(
    id: 'chapter-2',
    chapterNumber: 2,
    title: 'Pregnancy',
    description: 'Taking care of yourself and your baby during pregnancy',
    youtubeVideoId: 'PE4xfMpYOQw', // UNICEF pregnancy care
    icon: 'pregnant_woman',
    ageGroups: [AgeGroup.pregnancy],
    order: 2,
    topics: [
      const ChapterTopic(
        id: 'things-to-do',
        title: 'Things You Should Do',
        icon: 'check_circle',
        contentFile: 'things-to-do.md',
        order: 1,
      ),
      const ChapterTopic(
        id: 'things-not-to-do',
        title: 'Things You Should NOT Do',
        icon: 'cancel',
        contentFile: 'things-not-to-do.md',
        order: 2,
      ),
    ],
  ),
  IcapChapter(
    id: 'chapter-3',
    chapterNumber: 3,
    title: 'Birth to 3 Years',
    description: 'Caring for your baby from birth to 36 months',
    youtubeVideoId: 'RLCl2GQ_P0Q', // UNICEF early years
    icon: 'child_care',
    ageGroups: [AgeGroup.infant],
    order: 3,
    topics: [
      const ChapterTopic(
        id: 'birth-to-6-months',
        title: 'Birth to 6 Months',
        icon: 'baby_changing_station',
        contentFile: 'birth-to-6-months.md',
        order: 1,
      ),
      const ChapterTopic(
        id: '6-to-12-months',
        title: '6 to 12 Months',
        icon: 'child_care',
        contentFile: '6-to-12-months.md',
        order: 2,
      ),
      const ChapterTopic(
        id: '1-to-3-years',
        title: '1 to 3 Years',
        icon: 'child_friendly',
        contentFile: '1-to-3-years.md',
        order: 3,
      ),
    ],
  ),
  IcapChapter(
    id: 'chapter-4',
    chapterNumber: 4,
    title: 'Preschool Years',
    description: 'Supporting your 3 to 5 year old child',
    youtubeVideoId: 'TjGKhwpkBRU', // UNICEF preschool
    icon: 'child_friendly',
    ageGroups: [AgeGroup.toddler],
    order: 4,
    topics: [
      const ChapterTopic(
        id: 'development',
        title: 'Development Milestones',
        icon: 'trending_up',
        contentFile: 'development.md',
        order: 1,
      ),
      const ChapterTopic(
        id: 'learning',
        title: 'Learning Through Play',
        icon: 'toys',
        contentFile: 'learning.md',
        order: 2,
      ),
      const ChapterTopic(
        id: 'school-readiness',
        title: 'School Readiness',
        icon: 'school',
        contentFile: 'school-readiness.md',
        order: 3,
      ),
    ],
  ),
  IcapChapter(
    id: 'chapter-5',
    chapterNumber: 5,
    title: 'School Age Child',
    description: 'Guiding your 6 to 12 year old',
    youtubeVideoId: 'Hpn_n5_YUDI', // UNICEF school age
    icon: 'school',
    ageGroups: [AgeGroup.child],
    order: 5,
    topics: [
      const ChapterTopic(
        id: 'education',
        title: 'Supporting Education',
        icon: 'menu_book',
        contentFile: 'education.md',
        order: 1,
      ),
      const ChapterTopic(
        id: 'social-skills',
        title: 'Social Skills',
        icon: 'groups',
        contentFile: 'social-skills.md',
        order: 2,
      ),
      const ChapterTopic(
        id: 'health-safety',
        title: 'Health & Safety',
        icon: 'health_and_safety',
        contentFile: 'health-safety.md',
        order: 3,
      ),
    ],
  ),
  IcapChapter(
    id: 'chapter-6',
    chapterNumber: 6,
    title: 'Your Teenager',
    description: 'Navigating the teenage years (13-17)',
    youtubeVideoId: 'cYGmlVS1M0I', // UNICEF adolescent
    icon: 'person',
    ageGroups: [AgeGroup.teen],
    order: 6,
    topics: [
      const ChapterTopic(
        id: 'physical-changes',
        title: 'Physical Changes',
        icon: 'accessibility_new',
        contentFile: 'physical-changes.md',
        order: 1,
      ),
      const ChapterTopic(
        id: 'emotional-support',
        title: 'Emotional Support',
        icon: 'psychology',
        contentFile: 'emotional-support.md',
        order: 2,
      ),
      const ChapterTopic(
        id: 'communication',
        title: 'Communication',
        icon: 'forum',
        contentFile: 'communication.md',
        order: 3,
      ),
    ],
  ),
  IcapChapter(
    id: 'chapter-7',
    chapterNumber: 7,
    title: 'Cross-Cutting Issues',
    description: 'Important topics for all ages',
    youtubeVideoId: 'GD41eFXGE1c', // UNICEF child protection
    icon: 'hub',
    ageGroups: AgeGroup.values.toList(), // All age groups
    order: 7,
    topics: [
      const ChapterTopic(
        id: 'mental-health',
        title: 'Mental Health',
        icon: 'psychology',
        contentFile: 'mental-health.md',
        order: 1,
      ),
      const ChapterTopic(
        id: 'nutrition',
        title: 'Nutrition',
        icon: 'restaurant',
        contentFile: 'nutrition.md',
        order: 2,
      ),
      const ChapterTopic(
        id: 'positive-discipline',
        title: 'Positive Discipline',
        icon: 'thumb_up',
        contentFile: 'positive-discipline.md',
        order: 3,
      ),
      const ChapterTopic(
        id: 'online-safety',
        title: 'Online Safety',
        icon: 'security',
        contentFile: 'online-safety.md',
        order: 4,
      ),
    ],
  ),
  IcapChapter(
    id: 'chapter-8',
    chapterNumber: 8,
    title: 'Self-Care for Parents',
    description: 'Taking care of yourself as a caregiver',
    youtubeVideoId: 'WuyPuH9ojCE', // UNICEF parenting
    icon: 'self_improvement',
    ageGroups: AgeGroup.values.toList(), // All age groups
    order: 8,
    topics: [
      const ChapterTopic(
        id: 'stress-management',
        title: 'Stress Management',
        icon: 'spa',
        contentFile: 'stress-management.md',
        order: 1,
      ),
      const ChapterTopic(
        id: 'support-network',
        title: 'Building Support Network',
        icon: 'group',
        contentFile: 'support-network.md',
        order: 2,
      ),
      const ChapterTopic(
        id: 'work-life-balance',
        title: 'Work-Life Balance',
        icon: 'balance',
        contentFile: 'work-life-balance.md',
        order: 3,
      ),
    ],
  ),
  IcapChapter(
    id: 'chapter-9',
    chapterNumber: 9,
    title: 'Support & Services',
    description: 'Available resources and support services',
    youtubeVideoId: 'rTZ3K8PQOUE', // UNICEF support services
    icon: 'support_agent',
    ageGroups: AgeGroup.values.toList(), // All age groups
    order: 9,
    topics: [
      const ChapterTopic(
        id: 'helplines',
        title: 'Helplines & Contacts',
        icon: 'phone',
        contentFile: 'helplines.md',
        order: 1,
      ),
      const ChapterTopic(
        id: 'health-services',
        title: 'Health Services',
        icon: 'local_hospital',
        contentFile: 'health-services.md',
        order: 2,
      ),
      const ChapterTopic(
        id: 'education-support',
        title: 'Education Support',
        icon: 'school',
        contentFile: 'education-support.md',
        order: 3,
      ),
    ],
  ),
];

/// Mock topic content - markdown text for each topic
final Map<String, String> _topicContent = {
  // Chapter 1: Child Development
  'chapter-1/physical': '''
## Physical Development

Physical development is the growth of the child's body including:
- **Height and weight**
- **Muscles and bones**
- **The five senses** (sight, hearing, taste, touch and smell)

### Motor Skills

**Gross Motor Skills:**
- Walking
- Running
- Climbing
- Jumping

**Fine Motor Skills:**
- Grasping objects
- Drawing
- Writing
- Buttoning clothes

Physical development is foundational to all other areas of development. A healthy body supports a healthy mind!
''',
  'chapter-1/cognitive': '''
## Cognitive Development

Cognitive development is the development of thinking, learning, problem-solving, memory and understanding.

### Key Areas

- **Thinking:** Processing information and ideas
- **Learning:** Acquiring new knowledge and skills
- **Problem-solving:** Finding solutions to challenges
- **Memory:** Storing and recalling information
- **Understanding:** Making sense of the world

### How to Support Cognitive Development

1. Provide stimulating environments
2. Ask open-ended questions
3. Encourage curiosity and exploration
4. Read together regularly
5. Play games that challenge thinking
''',
  'chapter-1/social-emotional': '''
## Social and Emotional Development

Social and emotional development is the ability to:
- Learn to interact and connect with others
- Manage emotions
- Develop self-awareness
- Build empathy and relationships

### Building Blocks

**Self-Awareness:** Understanding their own feelings and needs

**Self-Regulation:** Managing emotions and behavior

**Social Skills:** Making friends, sharing, taking turns

**Empathy:** Understanding others' feelings

### What You Can Do

- Model healthy emotional expression
- Validate your child's feelings
- Teach problem-solving in conflicts
- Create opportunities for social interaction
''',
  'chapter-1/language': '''
## Language Development

Language development is the ability to understand and use words to communicate.

### Two Types

**Receptive Language (Understanding):**
- Following instructions
- Understanding questions
- Comprehending stories

**Expressive Language (Speaking, Gesturing, Writing):**
- Using words and sentences
- Asking questions
- Telling stories
- Writing thoughts

### Supporting Language Development

1. **Talk often** - Describe what you're doing
2. **Read daily** - Books build vocabulary
3. **Listen actively** - Give full attention when they speak
4. **Expand responses** - Build on what they say
5. **Sing songs** - Music helps with rhythm and words
''',

  // Chapter 2: Pregnancy
  'chapter-2/things-to-do': '''
## Things You Should DO During Pregnancy

### Nutrition
- Eat a balanced diet that includes rice, meat/fish, leafy green vegetables, fruits, milk, eggs, and milk products
- Eat small frequent meals and healthy snacks
- Drink lots of water and fluids, including milk and fruit juices
- Take all multivitamins as advised by health workers

### Physical Activity
- Stay physically active throughout your pregnancy
- Exercises such as walking, yoga and aerobics benefit both you and your child
- Get as much rest as your body needs

### Health Care
- If you visit a health facility for any medical condition, always let the doctor know you are pregnant
- Consult a doctor if you have any concerns or experience complications
- Plan to deliver your baby at a health facility
- Sleep under a mosquito net if living in malaria-prone areas

### Mental Health
- Share your feelings with a trusted friend or family member
- Do calming breathing exercises if you feel overwhelmed
- Engage in moderate physical activity
''',
  'chapter-2/things-not-to-do': '''
## Things You Should NOT DO During Pregnancy

### Medical Care
- **Do not miss** your scheduled checkups
- You should receive 8 or more ANC (antenatal care) visits
- **Do not self-medicate**

### Substances to Avoid
- Do not smoke
- Do not drink alcohol
- Do not eat doma (betel nut)
- Do not abuse any kind of substances

### Physical Safety
- Do not lift heavy objects
- Do not do heavy work
- Do not engage in activities that may cause injury or falls

### Nutrition Tips
- Do not take iron and calcium tablets together
- Do not drink tea with meals
- Both of these decrease iron absorption
''',

  // Chapter 3: Birth to 3 Years
  'chapter-3/birth-to-6-months': '''
## Birth to 6 Months

This is a very exciting time for you and your family! With all the changes, it is quite normal that you may be feeling overwhelmed and exhausted.

### Sleep
- A newborn may sleep up to 20 hours a day
- No set sleeping pattern for the first two months
- By six months, baby may sleep about 15 hours a day
- It takes up to six weeks to learn day from night

### Crying
- All babies cry - it's their only way to communicate
- Average newborn cries 2-3 hours a day
- Respond by meeting their needs:
  - Food
  - Warmth
  - Comfort
  - Diaper change
  - Holding and talking gently

### Nutrition
- **Breastfeed exclusively** for the first 6 months
- No other foods or fluids (not even water)
- Breastfeed at least 8 times in 24 hours
- Newborns need feeding every 2-3 hours
''',
  'chapter-3/6-to-12-months': '''
## 6 to 12 Months

Your baby is growing rapidly and becoming more interactive!

### Development Milestones
- Sitting without support
- Starting to crawl
- Pulling up to stand
- Babbling and making sounds
- Responding to their name
- Showing emotions

### Nutrition
- Continue breastfeeding
- Start introducing complementary foods at 6 months
- Begin with soft, mashed foods
- Gradually introduce variety
- Avoid honey, salt, and sugar

### Safety
- Baby-proof your home
- Watch for choking hazards
- Supervise during playtime
- Keep dangerous objects out of reach
''',
  'chapter-3/1-to-3-years': '''
## 1 to 3 Years (Toddler)

Your little one is becoming more independent and curious about everything!

### Development
- Walking and running
- Saying first words and sentences
- Following simple instructions
- Playing alongside other children
- Showing independence

### Nutrition
- Continue breastfeeding if possible
- Offer family foods cut into small pieces
- Encourage self-feeding
- Provide healthy snacks
- Ensure adequate iron intake

### Positive Parenting Tips
- Set simple, clear boundaries
- Offer choices when possible
- Praise good behavior
- Be patient with tantrums
- Read and sing together daily
''',

  // Chapter 7: Cross-Cutting Issues
  'chapter-7/mental-health': '''
## Mental Health

Just like physical health, mental health is very important for a child's overall development and success in life.

### Warning Signs to Watch For

**Changes in Sleep or Eating:**
- Sleeping or eating too much or too little

**Signs of Depression:**
- Persistent sadness
- Loss of interest in activities
- Feeling hopeless or worthless
- Getting irritated easily
- Withdrawing from friends and family

**Signs of Anxiety:**
- Constant worry or fear
- Restlessness or nervousness
- Fast heartbeat or trouble breathing
- Trouble focusing
- Panic attacks

### What Parents Can Do

1. **Talk and listen** - Encourage your child to share feelings
2. **Show love and support** - Be patient and understanding
3. **Spend quality time** - Connect through play, reading, or talking
4. **Maintain routines** - Keep regular schedules for stability
5. **Teach healthy coping skills** - Deep breathing, mindfulness
6. **Seek help if needed** - Don't wait to reach out to professionals
''',
  'chapter-7/nutrition': '''
## Nutrition

Good nutrition is essential for your child's growth, development, and overall health.

### Key Principles

- Provide a variety of foods from all food groups
- Include fruits and vegetables daily
- Choose whole grains over refined grains
- Ensure adequate protein intake
- Limit sugary drinks and snacks

### Age-Specific Tips

**Infants (0-6 months):**
- Exclusive breastfeeding is best

**6-12 months:**
- Introduce complementary foods
- Continue breastfeeding

**1-5 years:**
- Offer healthy snacks between meals
- Make mealtimes family time

**School age and teens:**
- Involve them in meal planning
- Teach about healthy choices
''',
  'chapter-7/positive-discipline': '''
## Positive Discipline

Positive discipline focuses on teaching and guiding children rather than punishing them.

### Core Principles

1. **Be kind and firm** - Show respect while setting boundaries
2. **Focus on solutions** - Help children learn from mistakes
3. **Connect before correct** - Build relationship first
4. **Encourage** - Focus on effort, not just results

### Strategies

**Instead of punishment:**
- Use natural consequences
- Give choices within limits
- Use "I" statements
- Take time to cool down

**Building good behavior:**
- Catch them being good
- Set clear expectations
- Be consistent
- Model the behavior you want to see

### What NOT to Do
- Never use physical punishment
- Avoid harsh words or humiliation
- Don't compare children to others
- Never discipline in anger
''',
  'chapter-7/online-safety': '''
## Online Safety

In today's digital world, keeping children safe online is essential.

### The 4 C's of Online Risk

1. **Content** - Inappropriate or harmful content
2. **Contact** - Dangerous people online
3. **Conduct** - Cyberbullying or sharing too much
4. **Commerce** - Scams and inappropriate purchases

### Tips for Parents

**Set boundaries:**
- Establish screen time limits
- Keep devices in common areas
- Use parental controls

**Communicate:**
- Talk about online safety regularly
- Encourage them to tell you if something feels wrong
- Keep communication open and judgment-free

**Educate:**
- Teach them not to share personal information
- Explain the permanence of online posts
- Discuss cyberbullying and what to do

### Age-Appropriate Guidance
- Young children: Supervised use only
- School age: Teach safe browsing habits
- Teens: Discuss digital footprint and privacy
''',

  // Chapter 8: Self-Care
  'chapter-8/stress-management': '''
## Stress Management for Parents

Taking care of yourself is essential for being the best parent you can be.

### Recognizing Stress

Signs you may be stressed:
- Feeling overwhelmed or anxious
- Difficulty sleeping
- Irritability or mood swings
- Physical tension or headaches
- Loss of patience with children

### Coping Strategies

**Immediate Relief:**
- Deep breathing exercises
- Step away for a moment
- Count to 10 before reacting

**Daily Practices:**
- Get enough sleep
- Exercise regularly
- Eat nutritious meals
- Take short breaks during the day

**Long-term Wellness:**
- Maintain social connections
- Practice mindfulness or meditation
- Pursue hobbies and interests
- Seek professional help if needed
''',
  'chapter-8/support-network': '''
## Building Your Support Network

No one should parent alone. A strong support network makes parenting easier and more enjoyable.

### Types of Support

**Emotional Support:**
- Someone to listen and validate
- Friends and family who understand
- Support groups for parents

**Practical Support:**
- Help with childcare
- Assistance with household tasks
- Transportation help

**Informational Support:**
- Parenting advice and resources
- Health and development information
- Community programs and services

### Building Your Network

1. **Reach out to family** - Even distant relatives can help
2. **Connect with other parents** - Through school, community, or online
3. **Utilize community resources** - Parent groups, religious organizations
4. **Don't be afraid to ask** - People often want to help
''',
  'chapter-8/work-life-balance': '''
## Work-Life Balance

Balancing work responsibilities with family life is challenging but achievable.

### Strategies for Balance

**Set Boundaries:**
- Define work hours and stick to them
- Create dedicated family time
- Learn to say no when needed

**Be Present:**
- Put away devices during family time
- Focus fully on whoever you're with
- Quality matters more than quantity

**Get Organized:**
- Plan meals and activities ahead
- Share responsibilities with partner
- Use calendars and reminders

**Self-Compassion:**
- Accept that you can't do everything
- Let go of perfectionism
- Celebrate small wins

### When Working from Home
- Create a dedicated workspace
- Establish clear boundaries with children
- Take regular breaks
- Maintain work-life separation
''',

  // Chapter 9: Support Services
  'chapter-9/helplines': '''
## Helplines & Emergency Contacts

Keep these important numbers handy for when you need help.

### Emergency Services
- **Police:** 113
- **Fire:** 110
- **Ambulance:** 112

### Child Care
- **Women and Child Care Unit (WCCU)**
- **National Commission for Women and Children (NCWC)**

### Mental Health Support
- Hospital psychiatric services
- Community mental health programs
- School counselors

### Health Services
- BHU (Basic Health Unit)
- District Hospital
- JDWNR Hospital (Thimphu)

*Contact your local government office for specific numbers in your area.*
''',
  'chapter-9/health-services': '''
## Health Services

A range of health services are available to support you and your child.

### Primary Health Care

**Basic Health Units (BHU):**
- Immunizations
- Growth monitoring
- Prenatal and postnatal care
- Treatment of common illnesses

**District Hospitals:**
- More specialized care
- Emergency services
- Referrals to specialists

### Specialized Services

- Pediatric care
- Mental health services
- Nutrition counseling
- Developmental assessments

### Accessing Services

1. Visit your nearest health facility
2. Bring your child's health record book
3. Ask about available programs
4. Follow up on referrals

*Health services are free for children under 5 at government facilities.*
''',
  'chapter-9/education-support': '''
## Education Support

Various programs exist to support your child's education and development.

### Early Childhood

- Early Childhood Care and Development (ECCD) centers
- Parent education programs
- Home-based early learning support

### School Age

- Free primary and secondary education
- School feeding programs
- Learning support for struggling students
- Inclusive education for children with disabilities

### Additional Support

**For Learning Difficulties:**
- Special education services
- Individual learning plans
- Tutoring and remedial programs

**For Financial Needs:**
- School supplies assistance
- Scholarship programs
- Transportation support

### Getting Involved
- Attend parent-teacher meetings
- Join the school management committee
- Communicate with teachers regularly
- Support learning at home
''',
};
