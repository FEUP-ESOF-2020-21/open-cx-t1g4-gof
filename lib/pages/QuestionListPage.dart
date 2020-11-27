import 'package:flutter/material.dart';
import 'package:inquirescape/firebase/FirebaseController.dart';
import 'package:inquirescape/model/Question.dart';
import 'package:inquirescape/widgets/QuestionCard.dart';

// This is the type used by the popup menu below.
enum _SortSetting { date, rating, author, platform }

class QuestionListPage extends StatefulWidget {
  final FirebaseController _fbController;
  final Widget _drawer;

  QuestionListPage(this._fbController, this._drawer);

  @override
  State<StatefulWidget> createState() {
    return QuestionListPageState();
  }
}

class QuestionListPageState extends State<QuestionListPage> {
  final List<PopupMenuEntry<_SortSetting>> sortButtonEntries = [];
  _SortSetting _selection = _SortSetting.date;
  bool descending = true;

  @override
  void initState() {
    this.widget._fbController.reloadQuestions((arg) {
      setState(() {});
    });

    _SortSetting.values.forEach((value) {
      this.sortButtonEntries.add(
        PopupMenuItem<_SortSetting>(
          value: value,
          child: Text(this._getSortText(value)),
        ),
      );
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<Question> questions = this.widget._fbController.conferenceQuestions;
    if (questions != null) {
      switch (this._selection) {
        case _SortSetting.date:
          if (this.descending)
            questions.sort((a, b) => a.postDate.compareTo(b.postDate));
          else
            questions.sort((b, a) => a.postDate.compareTo(b.postDate));
          break;
        case _SortSetting.rating:
          if (this.descending)
            questions.sort((a, b) => a.avgRating.compareTo(b.avgRating));
          else
            questions.sort((b, a) => a.avgRating.compareTo(b.avgRating));
          break;
        case _SortSetting.author:
          if (this.descending)
            questions.sort((a, b) =>
                a.authorDisplayName.compareTo(b.authorDisplayName));
          else
            questions.sort((b, a) =>
                a.authorDisplayName.compareTo(b.authorDisplayName));
          break;
        case _SortSetting.platform:
          if (this.descending)
            questions.sort((a, b) =>
                a.authorPlatform.compareTo(b.authorPlatform));
          else
            questions.sort((b, a) =>
                a.authorPlatform.compareTo(b.authorPlatform));
          break;
      }
    }

    return SafeArea(
      child: RefreshIndicator(
        child: Scaffold(
          appBar: AppBar(
            title: Text("Questions"),
            centerTitle: true,
          ),
          drawer: this.widget._drawer,
          body: questions == null
              ? _questionsUnloaded(context)
              : _questionList(context, questions),
        ),
        onRefresh: this._onRefresh,
      ),
    );
  }

  Widget _questionsUnloaded(BuildContext context) {
    return Center(
      child: Text(
        "No questions D:",
        style: TextStyle(color: Colors.grey, fontSize: 22),
      ),
    );
  }

  Future<void> _onRefresh() async {
    this.setState(() {});
    print("I feel rather refreshed");
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

  String _getSortText(_SortSetting sortSet) {
    switch (sortSet) {
      case _SortSetting.date:
        return "Date";
        break;
      case _SortSetting.rating:
        return "Rating";
        break;
      case _SortSetting.author:
        return "Author";
        break;
      case _SortSetting.platform:
        return "Platform";
        break;
    }
  }

  Widget _questionList(BuildContext context, List<Question> questions) {
    return Column(
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
                    this.descending = !this.descending;
                  });
                },
              ),
              Text(
                "Sorting by: " + this._getSortText(this._selection),
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
              return QuestionCard(
                question: questions[index],
                questionIndex: index,
                fbController: this.widget._fbController,
                onUpdate: () => this.setState(() {}),
              );
            },
          ),
        ),
      ],
    );
  }
}
