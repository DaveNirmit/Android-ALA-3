📅 Timetable Generator (TG)

A Flutter-based Timetable Generator application that helps users create, manage, and visualize academic timetables.
The application uses Hive Local Database to store and manage data persistently while demonstrating CRUD operations (Create, Read, Update, Delete).

This project was developed as part of the Persistent Data Management Assignment.

🎥 Project Demo

📽️ Video Demonstration:
[Watch the Demo](https://drive.google.com/drive/folders/1Trwk0X875gyHX8EUjzCmQuZI704UsfsN?usp=sharing)

The demo video explains:

Application workflow

CRUD operations

Hive database usage

Timetable generation and editing

🖼 Application Screenshots

Replace the image links with your screenshots.

Welcome Screen
<img width="1919" height="990" alt="image" src="https://github.com/user-attachments/assets/b94ae96c-24f5-4937-b7d3-c03659b273e7" />


Home Dashboard
<img width="1576" height="853" alt="image" src="https://github.com/user-attachments/assets/3d5f1dc8-64e8-495e-85e8-58d3c6388950" />


Add Subject Form
<img width="551" height="648" alt="image" src="https://github.com/user-attachments/assets/d3498401-e7d9-456f-94b9-4a28da3bce50" />


Faculty Assignment
<img width="1563" height="878" alt="image" src="https://github.com/user-attachments/assets/bb671884-702c-4748-963a-64ce613d20e7" />


Timetable Grid View
<img width="1578" height="540" alt="image" src="https://github.com/user-attachments/assets/c77264b6-7a8f-46d6-b568-fd0cace9b984" />


🚀 Project Objective

The objective of this project is to build a Flutter application with persistent local data storage that demonstrates how applications can manage and maintain structured data efficiently.

The application allows users to:

Create academic timetables

Add and manage subjects

Assign faculty members

Allocate subjects into time slots

Prevent scheduling conflicts

Store all information locally using Hive database

🧠 Why Timetable Generator?

Managing academic schedules manually can be difficult and prone to conflicts.
The Timetable Generator simplifies this process by providing a structured system to:

Organize subjects and faculty

Allocate lecture slots efficiently

Visualize schedules in a grid format

Prevent overlapping classes or faculty conflicts

This project demonstrates how local storage and structured data validation can solve real-world scheduling problems.

🏗 System Architecture

The application follows a structured Flutter architecture:

Flutter UI
   ↓
Application Logic
   ↓
Hive Local Database
   ↓
Persistent Storage

The UI interacts with the application logic, which then reads and writes data to the Hive database boxes.

🗂 Hive Local Storage

The project uses Hive, a lightweight and high-performance local database for Flutter applications.

Hive stores data in boxes, which function similarly to key-value storage containers.

Hive Boxes Used
subjectsBox
facultyBox
timeSlotsBox
timetablesBox
timetableEntriesBox

These boxes ensure that all data remains persistent even after the application restarts.

🔄 CRUD Operations Demonstration

The application clearly demonstrates Create, Read, Update, and Delete operations.

Create

Users can create:

Subjects

Faculty members

Time slots

Timetables

Read

The system retrieves stored data to:

Display subjects and faculty lists

Show timetable grids

Populate dropdown selections

Update

Users can modify:

Subject information

Faculty assignments

Timetable slots

Subject allocation

Delete

Users can remove:

Subjects

Faculty members

Timetable slots

Entire timetables

These operations demonstrate persistent data management using Hive.

🧩 Core Features
Welcome Screen

Blueprint-style welcome page with Timetable Generator branding.

Subject Management

Users can add, edit, and delete subjects with unique subject codes and color identifiers.

Faculty Management

Faculty members can be assigned to multiple subjects or remain available for all subjects.

Timetable Creation

Users can create multiple timetables and assign subjects to specific time slots.

Grid-Based Timetable Visualization

Schedules are displayed in a grid layout (Monday–Saturday) similar to real academic timetables.

Conflict Validation

The system ensures that:

Faculty cannot teach multiple classes at the same time

Subjects do not overlap in the same slot

Time slots remain structured

🎨 UI Design

The application follows a minimal and structured UI theme.

Color Palette:

Primary Color
#BAB86C

Accent Color
#E2725B

The design aims to provide a clean, modern, and easy-to-navigate interface.

🛠 Technology Stack
Technology	Purpose
Flutter	Mobile Application Development
Hive	Local Database Storage
Dart	Application Programming Language
