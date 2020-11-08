# InquireScape

- [Business Modeling](#business-modeling)
  - [Product Vision](#product-vision)
  - [Elevator Pitch](#elevator-pitch)
- [Requirements](#requirements)
  - [Use Cases](#use-cases)
  - [User Stories](#user-stories)
  - [Problem Domain](#problem-domain)
- [Architecture and design](#architecture-and-design)
  - [Logical Architecture](#logical-architecture)
  - [Physical Architecture](#physical-architecture)
- [Implementation](#implementation)
- [Test](#test)
- [Configuration and Change management](#configuration-and-change-management)
- [Project Management](#project-management)

---

# Business Modeling

## Product Vision
The app aims to remove the need for attendees to use a third-party app to post questions, while giving a moderation team a platform to hilghlight the best questions and relay them to the speaker.


## Elevator Pitch
Lots of speakers in conferences have a hard time managing the questions asked by the attendees and the presentation itself, wasting time that could be used to enrich the conference. Our application aims to solve that broken link by giving a platform for attendees to post their questions, where a moderation team will review, sort by relevance and redirect them to the speaker. Using our app, wasted time gets converted into productive time.

---

# Requirements

## Use Cases
![Use Cases UML](./docs/use_cases.svg)

**View/Sort Questions**:
- **Actor**: Speaker.
- **Description**: Gives the speaker the option to view the questions asked and sort them by different parameters.
- **Preconditions**: In order to access the questions, the speaker must login into his account on the app and join the conference in question.
- **Postconditions**: If successful, the questions will be displayed on the speaker's screen.
- **Normal Flow**:
  1. The speaker chooses the parameters for sorting the questions;
  2. The questions are sorted and displayed on the screen.
- **Alternative Flows and Exceptions**:
  1. The speaker doesn't choose any parameters for sorting the questions;
  2. The sorting is done by the default parameters and are displayed on the screen.

**Manage Questions**:
- **Actor**: Moderator.
- **Description**: Allows the moderators to manage the question (edit, delete, etc) before redirecting them to speaker, so it allows better time management in conference.
- **Preconditions**: In order to manage the question, the moderator must login into his account and join the conference in question.
- **Postconditions**: In the end, the action chosen by the moderator is applied and updates the database accordingly.
- **Normal Flow**:
  1. The moderator presses the button to delete a question;
  2. A confirmation prompt opens to verify the decision;
  3. If confirmed, the question is deleted, otherwise the action is cancelled and returns to the question page.
- **Alternative Flows and Exceptions**:
  1. The moderator presses the button to edit a question;
  2. The edition page is opened, allowing the moderator to change multiple fields regarding the question;
  3. The moderator presses the save button, and all the changes are saved into the database;
  4. App returns to the question page with the changes applied.

  - **OR**
  1. The moderator presses the button to edit a question;
  2. The edition page is opened, allowing the moderator to change multiple fields regarding the question;
  3. The moderator presses the return button;
  4. A prompt for verification opens to confirm the cancellation of the changes made;
  5. If confirmed, the changes are discarded and returns to the question page, otherwise it stays on the edition page.
- **Add Questions**:
  - **Actor**: Moderator.
  - **Description**: Allows the moderator to also add his own questions.
  - **Preconditions**: In order to add the question, the moderator must login into his account and join the conference in question.
  - **Postconditions**: In the end, the question is added to the database.
  - **Normal Flow**:
    1. The moderator presses the button to add a question;
    2. The moderator types his question;
    3. The moderator presses the confirm button, and the question is added to the database and displayed on the question list.
  - **Alternative Flows and Exceptions**:
    1. The moderator presses the button to add a question;
    2. The moderator types his question;
    3. The moderator presses the cancel button;
    4. A confirmation prompt is opened to confirm the cancellation;
    5. If confirmed, the question is discarded and returns to the question list page, otherwise it stays on the page to add question.
**Ban User from posting**:
  - **Actor**: Moderator.
  - **Description**: Allows the moderator to ban a user from posting questions on the conference.
  - **Preconditions**: In order to ban a user, the moderator must login into his account and join the conference in question.
  - **Postcondition**: The user banned can't add new questions.
  - **Normal Flow**:
    1. TBD
  - **Alternative Flows and Exceptions**:
    1. TBD


## User Stories

### **View All Questions**
As a moderator, I would like to see all the questions asked in the conference, so that I am able to manage them.

#### **UI mockup**
*TODO*

#### **Acceptance Tests**
```gherkin
Scenario: Displaying a question
  Given A list of questions
  When  I enter the page containing the list of questions
  Then  Display the questions stored in the database
```

#### **Value and Effort**
Value: Must have

Effort: S

### **Sorting Questions**
As a speaker, I would like to receive my questions in order of importance, so that I can use the conference time more effectively.

#### **UI mockup**
*TODO*

#### **Acceptance Tests**
```gherkin
Scenario: Sorting questions by rating
  Given A list of questions
  When  I select to sort questions by rating
  Then  The questions with higher rating are displayed at the top
```

#### **Value and Effort**
Value: Must have

Effort: M

### **Editing Questions**
As a moderator, I'd like to edit a question, so that I can make it more clear before redirecting it to the speaker.

#### **UI mockup**
*TODO*

#### **Acceptance Tests**
```gherkin
Scenario: Edit a question
  Given A question
  When  I click to edit the question
  And   Change the text
  Then  Save the changes in database
  And   Update the page display
```

#### **Value and Effort**
Value: Must have

Effort: L

### **Notify Speaker**
As a moderator, I want to be able to notify the speaker, so that he acknowledges an urgent question to be answered.

#### **UI mockup**
*TODO*

#### **Acceptance Tests**
```gherkin
Scenario: Notify speaker
  Given An important question
  When  Click the question options
  And   Click on notify speaker
  Then  The speaker receives a notification
  And   Upon click redirects to the question page
```

#### **Value and Effort**
Value: Could have

Effort: M


## Problem Domain

---

# Architecture and design

## Logical Architecture

## Physical Architecture

---

# Implementation

## Project Iteration 1
**Changelog:**
- Added a page to list all questions
- Added a page to focus on a single question
- Added a page to edit a questions and locally save its changes

**Screenshots:**
![Question listing page](docs/increment_1_question_list.png)
![Focused question page](docs/increment_1_full_page_question.png)
![Question editing page](docs/increment_1_edit.png)

---

# Test

---

# Configuration and Change Management

---

# Project Management

To plan and manage our project we are using [GitHub Projects](https://github.com/FEUP-ESOF-2020-21/open-cx-t1g4-gof/projects/1).

---