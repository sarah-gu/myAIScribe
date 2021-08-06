

# myAIScribe

## Table of Contents
1. [Overview](#Overview)
1. [Product Spec](#Product-Spec)
1. [Wireframes](#Wireframes)
2. [Schema](#Schema)

## Overview
### Description
Mobile app to keep track of your coursework history, grades, and plan for upcoming semesters

### App Evaluation
[Evaluation of your app across the following attributes]
- **Category:** Lifestyle / Social / Utility
- **Mobile:** Easy to access notes-viewing on your phone, more accessible than a webpage that you need to navigate to
- **Story:** Creates a seamlined and all-in-one-place view of notes, with ML automatically highlighting the phrases and keywords. 
- **Market:** Any student can use this app. 
- **Habit:** Students use the app to keep track of their notes, and have a faster note-taking system altogether. Additionally, students can use the app to create goals for their note-taking and study habits. 
- **Scope:** V1 could be the basic scanning / storing notes setup without any ML function. V2 would expand to incorporate CoreML image to text translator (search function). V3 would add in ability to track graphs set goals. V4 stretch goal incorporate user field subject and highlight based on user input. 

## Product Spec

### 1. User Stories (Required and Optional)

**Required Must-have Stories**

* User can log in / create account
* User can take pictures of notes 
* User can view the stored notes and filter by subject or by recent date of addition
* Settings page for basic profile information display



**Optional Nice-to-have Stories**

* Goals page with pie charts showing the status of the goal 
* Reminders tab to set reminders about completing goals/ studying
* General graphs page showing trends of learning over the history of using the app 

### 2. Screen Archetypes

* Login Screen
   * user logs in
* Register Screen
   * user registers for an account
* Scanner Screen
   * user can take picture of notes
* Notes Display 
   * User can view the stored notes and filter by subject or by recent date of addition
* Settings Screen
   * Settings page for basic profile information display

### 3. Navigation

**Tab Navigation** (Tab to Screen)

* Scanner
* Note Display
* Settings

**Flow Navigation** (Screen to Screen)

* Login Page
   * Notes Display
* Notes Display
   * Scanner
   * Settings
* Settings
   * Goals
   * Reminders
   * Notes Display
   * Login Page
   * Scanner

## Wireframes

![figma wireframes](https://github.com/sarah-gu/myAIScribe/blob/main/figma.png)


### Models
- Notes model, has info about the subject and image to be uploaded. 
### Networking
- Send requests to the CoreML API 
- Parse Network uploads a new Note 

## Work Plan 
**Required MVP Stories**
* Week 1
  - [X] Set up the general workflow of required User Stories mentioned above (LoginViewController, SettingsViewController, NotesViewController, ScannerViewController) [1 day]
  - [X] Integrate the CoreML feature into the app, doing a basic image to text translation system. At the same time, expand the Notes model to incorporate more fields. 
  - [X] Adding search bar feature for the notes, and filtering by self-posted notes and public notes. [1 day] 
  - [X] Create separate user registration page & tie in functionalities for updating & saving notes. [1 day]
  - [X] Create DetailsViewController that displays captions [1 day]
  - [X] Delete Note feature 
  - [X] Add Class tag to Notes 
  - [X] Add SVProgressHUD loading functionality for uploading notes [1 day] 
* Week 2
  - [X] Display graphs for history of uploading notes [1 day]
  - [X] Add support for up to 3 class tags [1 day] 
  - [X] Add ProfileViewController & friending functionality [1 day]
  - [X] Add FollowerViewController to display followers and following [2 days] 
  
**Stretch Goals**
* Week 3 
  - [X] Add pinch to zoom on the details page 
  - [X] Allow for caption textView editing on the Details Page
  - [X] Create Friends class on Parse database for better storing of Follower / Following information [1 day]
  - [X] Added a view notes by class grouping function, and a new page to display those notes [1 day]
  - [X] Improve UI design / Autolayout constraints [2 days] 
  - [X] Test accuracy of CoreML (uploading new pictures handwritten vs textbook) [1/2 day] 
  - [X] Scrollable UI View 
* Week 4 & 5
  - [X] Animations for the class tags & scrollable caption, constraining scrollview 
  - [X] Add buttons for scanning and finding friends if TableView is empty [1 day]
  - [X] Edit info view controller & profile picture upload option [1 day]
  - [X] Polishing UI & rounding corners of buttons / formatting [2 days] 








