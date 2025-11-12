import 'package:flutter/material.dart';

void main() {
  runApp(const SmartQuizApp());
}

class SmartQuizApp extends StatelessWidget {
  const SmartQuizApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Smart Quiz App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Smart Quiz App'),
        centerTitle: true,
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.blue.shade50, Colors.blue.shade100],
          ),
        ),
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            const SizedBox(height: 20),
            const Text(
              'Select a Subject',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
            const SizedBox(height: 30),
            SubjectCard(
              subject: 'Operating Systems',
              icon: Icons.computer,
              color: Colors.blue,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => QuizScreen(subject: 'Operating Systems'),
                ),
              ),
            ),
            const SizedBox(height: 16),
            SubjectCard(
              subject: 'Database Management Systems',
              icon: Icons.storage,
              color: Colors.green,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => QuizScreen(subject: 'DBMS'),
                ),
              ),
            ),
            const SizedBox(height: 16),
            SubjectCard(
              subject: 'Computer Networks',
              icon: Icons.language,
              color: Colors.orange,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => QuizScreen(subject: 'Networks'),
                ),
              ),
            ),
            const SizedBox(height: 16),
            SubjectCard(
              subject: 'Data Structures',
              icon: Icons.account_tree,
              color: Colors.purple,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => QuizScreen(subject: 'DSA'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SubjectCard extends StatelessWidget {
  final String subject;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const SubjectCard({
    Key? key,
    required this.subject,
    required this.icon,
    required this.color,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        contentPadding: const EdgeInsets.all(20),
        leading: Icon(icon, size: 40, color: color),
        title: Text(
          subject,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        trailing: Icon(Icons.arrow_forward, color: color),
        onTap: onTap,
      ),
    );
  }
}

class QuizScreen extends StatefulWidget {
  final String subject;

  const QuizScreen({Key? key, required this.subject}) : super(key: key);

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  late List<Question> questions;
  int currentIndex = 0;
  int score = 0;
  bool answered = false;
  String? selectedAnswer;

  @override
  void initState() {
    super.initState();
    questions = QuizData.getQuestions(widget.subject);
  }

  void selectAnswer(String answer) {
    if (!answered) {
      setState(() {
        selectedAnswer = answer;
        answered = true;
        if (answer == questions[currentIndex].correctAnswer) {
          score++;
        }
      });
    }
  }

  void nextQuestion() {
    if (currentIndex < questions.length - 1) {
      setState(() {
        currentIndex++;
        answered = false;
        selectedAnswer = null;
      });
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => ResultScreen(
            score: score,
            total: questions.length,
            subject: widget.subject,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    Question question = questions[currentIndex];

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.subject),
        centerTitle: true,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.blue.shade50, Colors.blue.shade100],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Question ${currentIndex + 1}/${questions.length}',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),
                  Text(
                    'Score: $score',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              LinearProgressIndicator(
                value: (currentIndex + 1) / questions.length,
                minHeight: 8,
                backgroundColor: Colors.grey.shade300,
                valueColor: AlwaysStoppedAnimation(Colors.blue.shade600),
              ),
              const SizedBox(height: 30),
              Text(
                question.questionText,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 30),
              ...question.options.map((option) {
                bool isSelected = selectedAnswer == option;
                bool isCorrect = option == question.correctAnswer;
                Color? backgroundColor;
                Color? borderColor;

                if (answered) {
                  if (isSelected && isCorrect) {
                    backgroundColor = Colors.green.shade100;
                    borderColor = Colors.green;
                  } else if (isSelected && !isCorrect) {
                    backgroundColor = Colors.red.shade100;
                    borderColor = Colors.red;
                  } else if (!isSelected && isCorrect) {
                    backgroundColor = Colors.green.shade100;
                    borderColor = Colors.green;
                  }
                } else if (isSelected) {
                  backgroundColor = Colors.blue.shade100;
                  borderColor = Colors.blue;
                }

                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: GestureDetector(
                    onTap: () => selectAnswer(option),
                    child: Container(
                      decoration: BoxDecoration(
                        color: backgroundColor ?? Colors.white,
                        border: Border.all(
                          color: borderColor ?? Colors.grey.shade300,
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.all(16),
                      child: Text(
                        option,
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey.shade800,
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
              const Spacer(),
              if (answered)
                ElevatedButton(
                  onPressed: nextQuestion,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    backgroundColor: Colors.blue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    currentIndex == questions.length - 1 ? 'See Results' : 'Next Question',
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class ResultScreen extends StatelessWidget {
  final int score;
  final int total;
  final String subject;

  const ResultScreen({
    Key? key,
    required this.score,
    required this.total,
    required this.subject,
  }) : super(key: key);

  String getFeedback() {
    double percentage = (score / total) * 100;
    if (percentage >= 80) {
      return 'Excellent! You have mastered this subject!';
    } else if (percentage >= 60) {
      return 'Good job! Keep practicing to improve further.';
    } else if (percentage >= 40) {
      return 'You need more practice. Review the concepts.';
    } else {
      return 'Start from the basics and practice more.';
    }
  }

  Color getFeedbackColor() {
    double percentage = (score / total) * 100;
    if (percentage >= 80) {
      return Colors.green;
    } else if (percentage >= 60) {
      return Colors.blue;
    } else if (percentage >= 40) {
      return Colors.orange;
    } else {
      return Colors.red;
    }
  }

  @override
  Widget build(BuildContext context) {
    double percentage = (score / total) * 100;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Quiz Results'),
        centerTitle: true,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.blue.shade50, Colors.blue.shade100],
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  subject,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                ),
                const SizedBox(height: 40),
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: getFeedbackColor().withOpacity(0.2),
                  ),
                  padding: const EdgeInsets.all(40),
                  child: Text(
                    '${percentage.toStringAsFixed(1)}%',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 64,
                      fontWeight: FontWeight.bold,
                      color: getFeedbackColor(),
                    ),
                  ),
                ),
                const SizedBox(height: 40),
                Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        Text(
                          '$score out of $total',
                          style: const TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Questions Correct',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                Container(
                  decoration: BoxDecoration(
                    color: getFeedbackColor().withOpacity(0.1),
                    border: Border.all(color: getFeedbackColor()),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    getFeedback(),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: getFeedbackColor(),
                    ),
                  ),
                ),
                const SizedBox(height: 40),
                ElevatedButton(
                  onPressed: () {
                    Navigator.popUntil(context, (route) => route.isFirst);
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    backgroundColor: Colors.blue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'Back to Home',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class Question {
  final String questionText;
  final List<String> options;
  final String correctAnswer;

  Question({
    required this.questionText,
    required this.options,
    required this.correctAnswer,
  });
}

class QuizData {
  static List<Question> getQuestions(String subject) {
    switch (subject) {
      case 'Operating Systems':
        return osQuestions;
      case 'DBMS':
        return dbmsQuestions;
      case 'Networks':
        return networkQuestions;
      case 'DSA':
        return dsaQuestions;
      default:
        return [];
    }
  }

  static final List<Question> osQuestions = [
    Question(
      questionText: 'What is an operating system?',
      options: [
        'A software that manages hardware',
        'A type of browser',
        'A programming language',
        'A database system'
      ],
      correctAnswer: 'A software that manages hardware',
    ),
    Question(
      questionText: 'Which is not a type of operating system?',
      options: ['Linux', 'Windows', 'Python', 'macOS'],
      correctAnswer: 'Python',
    ),
    Question(
      questionText: 'What is a process?',
      options: [
        'An instance of a program in execution',
        'A file stored on disk',
        'A network connection',
        'A memory location'
      ],
      correctAnswer: 'An instance of a program in execution',
    ),
    Question(
      questionText: 'What is the purpose of a file system?',
      options: [
        'To store and organize files',
        'To run programs',
        'To manage network',
        'To display graphics'
      ],
      correctAnswer: 'To store and organize files',
    ),
    Question(
      questionText: 'What is virtual memory?',
      options: [
        'An extension of RAM using disk storage',
        'A type of ROM',
        'A network protocol',
        'A programming concept'
      ],
      correctAnswer: 'An extension of RAM using disk storage',
    ),
  ];

  static final List<Question> dbmsQuestions = [
    Question(
      questionText: 'What does DBMS stand for?',
      options: [
        'Database Management System',
        'Data Basic Management System',
        'Database Management Storage',
        'Data Block Management System'
      ],
      correctAnswer: 'Database Management System',
    ),
    Question(
      questionText: 'Which is a relational database?',
      options: ['MySQL', 'MongoDB', 'Redis', 'Cassandra'],
      correctAnswer: 'MySQL',
    ),
    Question(
      questionText: 'What is normalization?',
      options: [
        'Process of organizing data to reduce redundancy',
        'Creating backups',
        'Encrypting data',
        'Compressing files'
      ],
      correctAnswer: 'Process of organizing data to reduce redundancy',
    ),
    Question(
      questionText: 'What is an index in a database?',
      options: [
        'A data structure to speed up queries',
        'A list of all tables',
        'A backup file',
        'A log entry'
      ],
      correctAnswer: 'A data structure to speed up queries',
    ),
    Question(
      questionText: 'What is a primary key?',
      options: [
        'A field that uniquely identifies a record',
        'The first column in a table',
        'An encrypted password',
        'A temporary value'
      ],
      correctAnswer: 'A field that uniquely identifies a record',
    ),
  ];

  static final List<Question> networkQuestions = [
    Question(
      questionText: 'What does TCP/IP stand for?',
      options: [
        'Transmission Control Protocol/Internet Protocol',
        'Transport Control Protocol/Internal Protocol',
        'Transmission Connection Protocol/Internet Process',
        'Transfer Control Protocol/Internet Port'
      ],
      correctAnswer: 'Transmission Control Protocol/Internet Protocol',
    ),
    Question(
      questionText: 'Which layer deals with routing?',
      options: [
        'Network Layer',
        'Transport Layer',
        'Data Link Layer',
        'Application Layer'
      ],
      correctAnswer: 'Network Layer',
    ),
    Question(
      questionText: 'What is an IP address?',
      options: [
        'A unique identifier for a device on a network',
        'A type of protocol',
        'A port number',
        'A bandwidth measure'
      ],
      correctAnswer: 'A unique identifier for a device on a network',
    ),
    Question(
      questionText: 'What is the purpose of DNS?',
      options: [
        'To translate domain names to IP addresses',
        'To encrypt data',
        'To manage files',
        'To route packets'
      ],
      correctAnswer: 'To translate domain names to IP addresses',
    ),
    Question(
      questionText: 'What is a firewall?',
      options: [
        'A security system that controls network traffic',
        'A type of malware',
        'A network cable',
        'A database system'
      ],
      correctAnswer: 'A security system that controls network traffic',
    ),
  ];

  static final List<Question> dsaQuestions = [
    Question(
      questionText: 'What is a data structure?',
      options: [
        'A way of organizing and storing data',
        'A programming language',
        'A network protocol',
        'A database file'
      ],
      correctAnswer: 'A way of organizing and storing data',
    ),
    Question(
      questionText: 'What is the time complexity of binary search?',
      options: ['O(log n)', 'O(n)', 'O(n²)', 'O(1)'],
      correctAnswer: 'O(log n)',
    ),
    Question(
      questionText: 'Which data structure uses LIFO?',
      options: ['Stack', 'Queue', 'Linked List', 'Tree'],
      correctAnswer: 'Stack',
    ),
    Question(
      questionText: 'What is a graph?',
      options: [
        'A collection of nodes and edges',
        'A chart in a spreadsheet',
        'A type of array',
        'A sorting algorithm'
      ],
      correctAnswer: 'A collection of nodes and edges',
    ),
    Question(
      questionText: 'What is the best case time complexity of quicksort?',
      options: ['O(n log n)', 'O(n)', 'O(n²)', 'O(log n)'],
      correctAnswer: 'O(n log n)',
    ),
  ];
}
