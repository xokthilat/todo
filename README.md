# ToDo Project

A Task Management Application that includes required, optional (from the assignment), and developer-added features all listed below.



## Features

- The user must have the ability to view tasks categorized as 'Todo,' 'Doing,' and 'Done,' which are fetched from a provided REST API (Required).

- The user should be able to delete unwanted items by swiping left (Required).

- Tasks in the list must be grouped by their respective creation dates (Required).

- Groups and items within them must be ordered in ascending order based on their creation date (Required).

- The application should load a maximum of 10 items per page and implement pagination (Required).

- If the user remains inactive for a period of 10 seconds or longer, the application should automatically redirect to a passcode page (Required).

- The automatic redirection to the passcode page should occur even if the app is killed or remains open (Required).

- The user should be able to continue using the app without redirection if their period of inactivity is shorter than 10 seconds, and the app is neither killed nor closed (Required).

- Implement unit testing to ensure code reliability and functionality (Required).

- Implement error handling mechanisms to manage and report any encountered issues (Required).

- perform integration testing (Optional).

- Optionally, provide the ability for the user to change the passcode, with the default passcode set as '123456' (Optional).

- implementing an offline access feature, allowing the application to function without an internet connection (Developer add-on).

## Screenshots

| Passcode check | Passcode change | Home Todo |
| ------------- | ------------- | ------------- |
| <img src="https://github.com/xokthilat/todo/assets/32994521/4a60b685-9366-43ac-8371-4e4600a5a942" height="480"> | <img src="https://github.com/xokthilat/todo/assets/32994521/0167be7b-5868-4905-986c-415d10749c74" height="480"> | <img src="https://github.com/xokthilat/todo/assets/32994521/8994d046-be26-41de-b3f9-7561b6fbfdb3" height="480"> |

| Swipe to Delete | Offline Mode |
| ------------- | ------------- |
| <img src="https://github.com/xokthilat/todo/assets/32994521/1c269587-2260-4b93-9091-203f98f2b51d" height="480"> | <img src="https://github.com/xokthilat/todo/assets/32994521/7a54012b-3671-43c8-98dc-fc6023c74b10" height="480"> | 




## Prerequisites

Before you begin, ensure you have met the following requirements:

- Flutter 3.13.4 or higher
- Dart 3.1.2 or higher
- Xcode or Android Studio

## Installation

A step-by-step guide on how to install and run this project.

```bash
# Clone the repository
git clone https://github.com/xokthilat/todo.git

# Navigate to the project directory
cd todo

# Install dependencies
flutter pub get

# Run the project
flutter run
```

## Automated testing

A step-by-step guide on how to run unit test, widget test .

```bash
# Clone the repository
git clone https://github.com/xokthilat/todo.git

# Navigate to the project directory
cd todo

# Install dependencies
flutter pub get

# run the command
flutter test
```
Integration test
```bash
# Clone the repository
git clone https://github.com/xokthilat/todo.git

# Navigate to the project directory
cd todo

# Install dependencies
flutter pub get

# make it executable
chmod +x run_integration_test.sh

# run the command
./run_integration_test.sh

```
Note that the 'run_integration_test.sh' was created to run accuracy tests 100 times, and you can edit it by changing the 'running_number' parameter inside the file.
## Project Structure
This project adheres to the Clean Architecture software design principle, which includes a self-made library for the network layer. 


![Clean-Architecture-Flutter-Diagram](https://github.com/xokthilat/todo/assets/32994521/b8e8c72f-e3a6-484f-a04e-3e38a551fb4d)

## Android APK

![IzBq58](https://github.com/xokthilat/todo/assets/32994521/87344173-cf9d-4554-9442-9079b8d633af)


