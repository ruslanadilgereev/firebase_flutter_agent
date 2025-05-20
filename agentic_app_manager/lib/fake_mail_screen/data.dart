enum EmailType { primary, everything }

class Email {
  String fromFirstName = '';
  String fromLastName = '';
  String subject = '';
  String content = '';
  EmailType? tag;
  bool favorited = false;

  Email(
    this.fromFirstName,
    this.fromLastName,
    this.subject,
    this.content,
    this.tag, [
    this.favorited = false,
  ]);
}

List<Email> emails = [
  Email(
    'Khanh',
    'Nguyen',
    'Look at this meme!',
    'hehehe isn\'t it so funny?',
    EmailType.primary,
  ),
  Email(
    'Some',
    'Random Store',
    '50% off sale this weekend only!',
    'Have you got your eye on this sweater? Now\'s your chance to get it!',
    EmailType.everything,
  ),
  Email(
    'Craig',
    'Labenz',
    'Knock, knock',
    'Who\'s There? Dash! Dash who?',
    EmailType.primary,
  ),
  Email(
    'Here\'s another',
    'Store',
    'Hello from the other store',
    'That thing you\'ve been looking at is on sale. You should get it.',
    EmailType.everything,
  ),
  Email(
    'Eric',
    'Windmill',
    'Cute Cat Alert',
    'Hello, This is your daily does of cute cats. You\'re welcome so very welcome.',
    EmailType.primary,
    true,
  ),
  Email(
    'Yet ANOTHER',
    'store',
    'You\'ve left something in your cart!',
    'Here\'s 15% off of that thing that you left in your cart two days ago.',
    EmailType.everything,
  ),
  Email(
    'Flutter',
    'Dash',
    'You\'re invited to my birthday party!',
    'Be there or be square.',
    EmailType.primary,
  ),
  Email(
    'Some',
    'Person',
    'Can you believe this deal?!',
    'Hey you, yes you. So I heard you\'re shopping for a new car...',
    EmailType.everything,
  ),
  Email(
    'Eric',
    'Windmill',
    'Cute Cat Alert',
    'Hello, This is your daily does of cute cats. You\'re welcome so very welcome.',
    EmailType.primary,
    true,
  ),
  Email(
    'Jane',
    'Smith',
    '🚨 3-Day Flash Sale! Save Up to 50%',
    "You won't want to miss this, Jane! Our biggest sale...",
    EmailType.everything,
  ),
  // Email 2
  Email(
    'Ben',
    'Johnson',
    'Your Personalized Recommendations Are Here',
    "Hey Ben, check out these items, hand-picked just for you...",
    EmailType.everything,
  ),

  // Email 3
  Email(
    'Sarah',
    'Lee',
    'Exclusive Offer: Free Gift with Purchase',
    "Hi Sarah, enjoy a complimentary gift when you spend...",
    EmailType.primary,
  ),
  Email(
    'Olivia',
    'Davis',
    'Your Order Has Shipped! 🎉',
    'Great news, Olivia! Your package is on its way...',
    EmailType.primary,
  ),
  Email(
    'Michael',
    'Brown',
    'Welcome to the Community!',
    'Thanks for joining us, Michael. Explore, connect, and...',
    EmailType.everything,
  ),
  Email(
    'Emily',
    'Wilson',
    'Reminder: Your Appointment is Tomorrow',
    'Hi Emily, just a friendly reminder about your...',
    EmailType.primary,
  ),
  Email(
    'Alex',
    'Carter',
    'Limited Time Offer: Upgrade Your Plan',
    'Unlock more features and benefits, Alex. Upgrade today...',
    EmailType.everything,
  ),
  Email(
    'Sophia',
    'Miller',
    'Your Cart is Waiting...',
    'Hey Sophia, did you forget something? Complete your purchase...',
    EmailType.everything,
  ),
  Email(
    'Noah',
    'Garcia',
    'New Arrivals You Might Like',
    'Fresh styles just dropped, Noah! Check them out...',
    EmailType.everything,
  ),
  Email(
    'Emma',
    'Rodriguez',
    'Feedback Request: Help Us Improve',
    'Hi Emma, could you spare a few minutes to share your thoughts...',
    EmailType.primary,
  ),
  Email(
    'Liam',
    'Martinez',
    'Earn Rewards with Our Referral Program',
    'Share the love, Liam! Invite friends and earn perks...',
    EmailType.everything,
  ),
  Email(
    'Isabella',
    'Thompson',
    'Happy Birthday from Us!',
    'Isabella, we\'re celebrating you! Here\'s a special gift...',
    EmailType.primary,
  ),
  Email(
    'Ethan',
    'Hernandez',
    'Travel Inspiration: Weekend Getaways',
    'Need a break, Ethan? Browse these destinations...',
    EmailType.everything,
  ),
  Email(
    'Mia',
    'Robinson',
    'Price Drop Alert!',
    'That item you\'ve been eyeing, Mia? It\'s now on sale...',
    EmailType.everything,
  ),
  Email(
    'Jacob',
    'Clark',
    'Your Subscription Renewal is Coming Up',
    'Hi Jacob, a friendly reminder about your upcoming renewal...',
    EmailType.primary,
  ),
  Email(
    'Ava',
    'Lopez',
    'Join Us for a Special Event!',
    'Ava, you\'re invited to an exclusive members-only event...',
    EmailType.primary,
  ),
  Email(
    'Mason',
    'Harris',
    'Tips for Getting the Most Out of [Product Name]',
    'Hey Mason, enhance your experience with these helpful tips...',
    EmailType.everything,
  ),
  Email(
    'Charlotte',
    'Moore',
    'We Miss You! Here\'s a Discount to Come Back',
    'We haven\'t seen you in a while, Charlotte. Here\'s something...',
    EmailType.everything,
  ),
  Email(
    'Elijah',
    'Taylor',
    'Back in Stock: Your Favorite Item',
    'The wait is over, Elijah! The item you wanted is available...',
    EmailType.everything,
  ),
  Email(
    'Madison',
    'Jackson',
    'Refer a Friend and Earn Rewards',
    'Spread the word, Madison! Get rewarded for sharing...',
    EmailType.everything,
  ),
  Email(
    'Aiden',
    'Lewis',
    'Expert Tips: Content Creation',
    'Level up your skills, Aiden. Learn from the pros...',
    EmailType.everything,
  ),
  Email(
    'Chloe',
    'Wang',
    'Your Order Has Been Confirmed',
    'Thanks for your purchase, Chloe! Order details inside...',
    EmailType.primary,
  ),
  Email(
    'Daniel',
    'Martin',
    'Important Account Update',
    'Daniel, please review these changes to your account...',
    EmailType.primary,
  ),
  Email(
    'Amelia',
    'Anderson',
    'Community Spotlight: Meet Dash',
    'Get inspired, Amelia! Learn about a fellow community member...',
    EmailType.everything,
  ),
];
