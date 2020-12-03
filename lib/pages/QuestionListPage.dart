import 'package:flutter/material.dart';
import 'package:inquirescape/firebase/FirebaseController.dart';
import 'package:inquirescape/model/Question.dart';
import 'package:inquirescape/widgets/QuestionCard.dart';

// This is the type used by the popup menu below.
enum _SortSetting { date, rating, author, platform }

class QuestionListPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return QuestionListPageState();
  }
}

class QuestionListPageState extends State<QuestionListPage> {
  final List<PopupMenuEntry<_SortSetting>> sortButtonEntries = [];
  _SortSetting _selection = _SortSetting.date;
  int descendingVal = -1;

  bool get descending {
    return descendingVal == -1;
  }

  static final Map sortName = {
    _SortSetting.date: "Date",
    _SortSetting.rating: "Rating",
    _SortSetting.author: "Author",
    _SortSetting.platform: "Platform",
  };

  Comparator<Question> dateComparator;
  final Map comparators = Map();

  @override
  void initState() {
    FirebaseController.reloadQuestions((arg) {
      setState(() {});
    });

    this.comparators[_SortSetting.date] =
        (Question a, Question b) => this.descendingVal * a.postDate.compareTo(b.postDate);
    this.comparators[_SortSetting.rating] =
        (Question a, Question b) => this.descendingVal * a.avgRating.compareTo(b.avgRating);
    this.comparators[_SortSetting.author] =
        (Question a, Question b) => this.descendingVal * a.authorDisplayName.compareTo(b.authorDisplayName);
    this.comparators[_SortSetting.platform] =
        (Question a, Question b) => this.descendingVal * a.authorPlatform.compareTo(b.authorPlatform);

    _SortSetting.values.forEach((value) {
      this.sortButtonEntries.add(
            PopupMenuItem<_SortSetting>(
              value: value,
              child: Text(sortName[value]),
            ),
          );
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<Question> questions = FirebaseController.conferenceQuestions;
    questions?.sort(this.comparators[this._selection]);

    return Scaffold(
      appBar: AppBar(
        title: Text("Questions"),
        centerTitle: true,
      ),
      body: SafeArea(
        child: questions == null ? _questionsUnloaded(context) : _questionList(context, questions),
      ),
    );
  }

  Widget _questionsUnloaded(BuildContext context) {
    return Center(
      child: Text(
        "No questions have been asked yet",
        style: TextStyle(color: Colors.grey, fontSize: 22),
      ),
    );
  }

  Future<void> _onRefresh() async {
    this.setState(() {});
  }

  Widget _sortButton(BuildContext context) {
    return PopupMenuButton<_SortSetting>(
      icon: Icon(
        Icons.filter_alt_outlined,
        color: Colors.grey,
      ),
      onSelected: (_SortSetting result) {
        setState(() {
          _selection = result;
        });
      },
      itemBuilder: (ctx) => this.sortButtonEntries,
    );
  }

  Widget _questionList(BuildContext context, List<Question> questions) {
    return RefreshIndicator(
      onRefresh: this._onRefresh,
      child: Column(
        children: [
          Align(
            child: Row(
              children: [
                this._sortButton(context),
                IconButton(
                  icon: Icon(
                    this.descending ? Icons.arrow_downward : Icons.arrow_upward,
                    color: Colors.grey,
                  ),
                  onPressed: () {
                    setState(() {
                      this.descendingVal *= -1;
                    });
                  },
                ),
                Text(
                  "Sorting by: " + sortName[this._selection],
                  style: TextStyle(fontSize: 16),
                  overflow: TextOverflow.clip,
                ),
              ],
            ),
            alignment: Alignment.centerLeft,
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: questions.length,
              itemBuilder: (BuildContext context, int index) {
                return ExpandableQuestionCard(
                  question: questions[index],
                  questionIndex: index,
                  onUpdate: () => this.setState(() {}),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
