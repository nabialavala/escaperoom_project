import '../models/puzzle.dart';

final List<Puzzle> seedPuzzles = [
  // ZOMBIE THEME
  Puzzle(
    theme: 'Zombie',
    levelNumber: 1,
    storyText:
        'You enter a contaminated lab. To create the antidote, you must collect all 10 ingredients before the infection spreads.',
    question: 'What has to be broken before you can use it?',
    acceptedAnswers: 'egg',
    rewardText: 'protein sample',
    isFinalLevel: 0,
    hint: 'It is something you crack open before cooking or using.',
  ),
  Puzzle(
    theme: 'Zombie',
    levelNumber: 2,
    storyText:
        'You locate a storage freezer labeled Stage 2 Compounds. A lock blocks your access. A sticky note reads: Only those who understand basics may proceed.',
    question: 'What gets wetter the more it dries?',
    acceptedAnswers: 'towel',
    rewardText: 'solvent',
    isFinalLevel: 0,
    hint: 'You usually use this after a shower.',
  ),
  Puzzle(
    theme: 'Zombie',
    levelNumber: 3,
    storyText:
        'You move deeper into the lab. A terminal flickers with a security question tied to chemical stability.',
    question: 'What is always in front of you but cannot be seen?',
    acceptedAnswers: 'future',
    rewardText: 'enzyme',
    isFinalLevel: 0,
    hint: 'It has not happened yet.',
  ),
  Puzzle(
    theme: 'Zombie',
    levelNumber: 4,
    storyText:
        'The next chamber contains broken equipment and chemical spills. Time is running out.',
    question: 'I am tall when I am young and short when I am old. What am I?',
    acceptedAnswers: 'candle',
    rewardText: 'catalyst',
    isFinalLevel: 0,
    hint: 'It melts as time passes.',
  ),
  Puzzle(
    theme: 'Zombie',
    levelNumber: 5,
    storyText: 'You find a sealed container labeled Core Compound.',
    question: 'What month has 28 days?',
    acceptedAnswers: 'all|all of them|every month',
    rewardText: 'compound base',
    isFinalLevel: 0,
    hint: 'Do not focus on just February.',
  ),
  Puzzle(
    theme: 'Zombie',
    levelNumber: 6,
    storyText: 'The system begins combining your collected materials.',
    question: 'Rearrange "CIDA" to form something used in science.',
    acceptedAnswers: 'acid',
    rewardText: 'acid',
    isFinalLevel: 0,
    hint: 'It is a common chemical substance with four letters.',
  ),
  Puzzle(
    theme: 'Zombie',
    levelNumber: 7,
    storyText: 'You hear infected pounding on the lab doors.',
    question: 'I have no life, but I can die. What am I?',
    acceptedAnswers: 'battery',
    rewardText: 'energy source',
    isFinalLevel: 0,
    hint: 'Phones and remotes need it for power.',
  ),
  Puzzle(
    theme: 'Zombie',
    levelNumber: 8,
    storyText: 'A numeric pattern appears on the screen.',
    question: '2, 6, 7, 21, 22, ?',
    acceptedAnswers: '66',
    rewardText: 'stabilizer',
    isFinalLevel: 0,
    hint: 'The pattern alternates between multiplying by 3 and adding 1.',
  ),
  Puzzle(
    theme: 'Zombie',
    levelNumber: 9,
    storyText: 'The cure is almost ready.',
    question:
        'A virus doubles every hour and fills a room in 24 hours. When was it half full?',
    acceptedAnswers: '23',
    rewardText: 'dosage formula',
    isFinalLevel: 0,
    hint: 'Think one hour before it becomes completely full.',
  ),
  Puzzle(
    theme: 'Zombie',
    levelNumber: 10,
    storyText: 'All ingredients are ready.',
    question: 'Decode: 3-1-20',
    acceptedAnswers: 'cat',
    rewardText: 'cure',
    isFinalLevel: 0,
    hint: 'Convert each number to its letter in the alphabet.',
  ),

  // TIME TRAVEL THEME
  Puzzle(
    theme: 'Time Travel',
    levelNumber: 1,
    storyText:
        'The time machine is broken. You must collect all 10 parts to restore it and return home.',
    question: 'What goes up but never comes down?',
    acceptedAnswers: 'age',
    rewardText: 'power core',
    isFinalLevel: 0,
    hint: 'Everyone gets more of it every birthday.',
  ),
  Puzzle(
    theme: 'Time Travel',
    levelNumber: 2,
    storyText: 'The interface requires simple logic.',
    question: 'What has hands but cannot clap?',
    acceptedAnswers: 'clock',
    rewardText: 'time dial',
    isFinalLevel: 0,
    hint: 'You look at it to tell time.',
  ),
  Puzzle(
    theme: 'Time Travel',
    levelNumber: 3,
    storyText: 'A cooling system needs activation.',
    question: 'What runs but never walks?',
    acceptedAnswers: 'water',
    rewardText: 'coolant',
    isFinalLevel: 0,
    hint: 'It flows in rivers and from faucets.',
  ),
  Puzzle(
    theme: 'Time Travel',
    levelNumber: 4,
    storyText: 'A navigation module flickers.',
    question: '1, 4, 9, 16, 25, ?',
    acceptedAnswers: '36',
    rewardText: 'navigation chip',
    isFinalLevel: 0,
    hint: 'These are square numbers.',
  ),
  Puzzle(
    theme: 'Time Travel',
    levelNumber: 5,
    storyText: 'The machine hums faintly.',
    question:
        'What can travel around the world while staying in one spot?',
    acceptedAnswers: 'stamp',
    rewardText: 'signal transmitter',
    isFinalLevel: 0,
    hint: 'You put it on mail.',
  ),
  Puzzle(
    theme: 'Time Travel',
    levelNumber: 6,
    storyText: 'A security lock activates.',
    question: 'If you have me, you want to share me.',
    acceptedAnswers: 'secret',
    rewardText: 'encryption key',
    isFinalLevel: 0,
    hint: 'Once you tell someone, it is no longer private.',
  ),
  Puzzle(
    theme: 'Time Travel',
    levelNumber: 7,
    storyText: 'The system begins recalibrating.',
    question:
        'What begins with T, ends with T, and has T in it?',
    acceptedAnswers: 'teapot',
    rewardText: 'containment unit',
    isFinalLevel: 0,
    hint: 'It is a container used for tea.',
  ),
  Puzzle(
    theme: 'Time Travel',
    levelNumber: 8,
    storyText: 'Energy surges through the machine.',
    question: '2, 6, 7, 21, 22, ?',
    acceptedAnswers: '66',
    rewardText: 'energy regulator',
    isFinalLevel: 0,
    hint: 'The pattern alternates between multiplying by 3 and adding 1.',
  ),
  Puzzle(
    theme: 'Time Travel',
    levelNumber: 9,
    storyText: 'The machine prepares for activation.',
    question: 'Where do you bury survivors of a plane crash?',
    acceptedAnswers: 'nowhere',
    rewardText: 'safety override',
    isFinalLevel: 0,
    hint: 'Read the word survivors carefully.',
  ),
  Puzzle(
    theme: 'Time Travel',
    levelNumber: 10,
    storyText: 'Everything is ready.',
    question:
        'I speak without a mouth and hear without ears. What am I?',
    acceptedAnswers: 'echo',
    rewardText: 'time machine',
    isFinalLevel: 0,
    hint: 'You hear it in caves or large empty spaces.',
  ),

  // MURDER MYSTERY THEME
  Puzzle(
    theme: 'Murder Mystery',
    levelNumber: 1,
    storyText:
        'The dinner party ended in chaos when the host suddenly collapsed at the table. The doctor later confirmed it was poison. Four people were present: Chef Marco, Butler James, Lila the victim\'s best friend, and Mr. Grant, a business partner. Each claims innocence, but the truth is hidden somewhere in their stories.',
    question:
        'I enter quietly, hidden from sight.\nNo blade, no force, yet I still take life.\nWhat am I?',
    acceptedAnswers: 'poison',
    rewardText:
        'Clue 1: The cause of death was not obvious to anyone at the table',
    isFinalLevel: 0,
    hint: 'It kills without a visible wound and can be hidden in food or drink.',
  ),
  Puzzle(
    theme: 'Murder Mystery',
    levelNumber: 2,
    storyText:
        'No one recalls seeing anything unusual happen. There was no struggle, no sudden movement, and nothing that drew attention. Whatever happened, it happened without anyone noticing.',
    question:
        'I act without being seen,\nand leave no mark behind.\nWhat am I?',
    acceptedAnswers: 'silent|hidden|unseen',
    rewardText: 'Clue 2: The act happened without drawing attention',
    isFinalLevel: 0,
    hint: 'The word describes something done without anyone noticing.',
  ),
  Puzzle(
    theme: 'Murder Mystery',
    levelNumber: 3,
    storyText:
        'You begin to think about timing. Everyone remembers the dinner, but not every second of it. The moment that mattered may have passed unnoticed.',
    question:
        'I come and go, yet leave no trace.\nMiss me once, I am gone without a face.\nWhat am I?',
    acceptedAnswers: 'moment|time',
    rewardText: 'Clue 3: The act happened in a brief, unnoticed moment',
    isFinalLevel: 0,
    hint: 'It is a very short piece of time.',
  ),
  Puzzle(
    theme: 'Murder Mystery',
    levelNumber: 4,
    storyText:
        'You reconsider where everyone was during the dinner. Some stayed in one place, while others moved around. If the act required the right moment, then movement becomes important.',
    question:
        'The more you take, the more you leave behind.\nWhat am I?',
    acceptedAnswers: 'footsteps|steps',
    rewardText: 'Clue 4: Not everyone stayed where they were',
    isFinalLevel: 0,
    hint: 'You leave these behind when you walk.',
  ),
  Puzzle(
    theme: 'Murder Mystery',
    levelNumber: 5,
    storyText:
        'You review the suspects\' reasons for being there. Some had strong emotional ties, while others had financial interests. But having a reason does not mean having the ability.',
    question:
        'I explain why, but not how.\nI give a reason, but not the act.\nWhat am I?',
    acceptedAnswers: 'motive|reason',
    rewardText:
        'Clue 5: Having a reason does not mean someone committed the crime',
    isFinalLevel: 0,
    hint: 'In investigations, this explains why someone might commit a crime.',
  ),
  Puzzle(
    theme: 'Murder Mystery',
    levelNumber: 6,
    storyText:
        'You compare each person\'s story with what others remember. Some accounts match perfectly, while others leave small gaps. Those gaps may matter more than they seem.',
    question:
        'I tell where you were,\nso you cannot be elsewhere.\nWhat am I?',
    acceptedAnswers: 'alibi',
    rewardText: 'Clue 6: Some stories confirm where people were the entire time',
    isFinalLevel: 0,
    hint: 'It is proof that someone was somewhere else during the crime.',
  ),
  Puzzle(
    theme: 'Murder Mystery',
    levelNumber: 7,
    storyText:
        'One detail stands out from a witness account. Someone was seen somewhere they did not mention. That inconsistency may be the key.',
    question:
        'I show the truth, even when denied.\nI place you somewhere you tried to hide.\nWhat am I?',
    acceptedAnswers: 'evidence|proof',
    rewardText:
        'Clue 7: Someone was seen away from where they claimed to be',
    isFinalLevel: 0,
    hint: 'Investigators use this to support what really happened.',
  ),
  Puzzle(
    theme: 'Murder Mystery',
    levelNumber: 8,
    storyText:
        'You now focus on how the poison could have been delivered. It had to reach the victim without suspicion, hidden in something trusted.',
    question:
        'I travel inside what you consume,\nhidden where trust is assumed.\nWhat am I?',
    acceptedAnswers: 'food|meal|dish',
    rewardText: 'Clue 8: The poison was delivered through something consumed',
    isFinalLevel: 0,
    hint: 'The victim would have eaten this.',
  ),
  Puzzle(
    theme: 'Murder Mystery',
    levelNumber: 9,
    storyText:
        'Everything begins to connect. The method, the timing, the movement, and the access all point in one direction. Only one person had complete control over what was prepared and served.',
    question:
        'I decide what is made and what is served,\ntrusted by all, yet rarely observed.\nWho am I?',
    acceptedAnswers: 'chef|cook',
    rewardText:
        'Clue 9: The person who controlled the meal had the opportunity',
    isFinalLevel: 0,
    hint: 'This person prepares the meal.',
  ),
  Puzzle(
    theme: 'Murder Mystery',
    levelNumber: 10,
    storyText:
        'You review everything you discovered throughout the investigation. Each clue reveals a piece of the truth. When placed together, they point clearly to one person.',
    question: 'Who is the killer?',
    acceptedAnswers: 'chef marco|marco|chef',
    rewardText: 'Case closed',
    isFinalLevel: 1,
    hint: 'Think about who had full control over the food.',
  ),
];