
# Flutter Todo Application

This Flutter application is a Todo app that incorporates the Bloc pattern, Hive database for local storage, and follows the Clean Architecture principles. The app is designed to work seamlessly in both offline and online modes, providing a reliable Todo management experience.
![image](https://github.com/naveenyadav530/machine-test/assets/48934200/d03fa65b-f6d7-40e6-8d98-7fe98a2c0c4c)
![image](https://github.com/naveenyadav530/machine-test/assets/48934200/4cf3502f-dad1-42f1-b287-d0b6fad80892)
![image](https://github.com/naveenyadav530/machine-test/assets/48934200/06227d41-3500-49c8-b346-7246a2c49507)
![image](https://github.com/naveenyadav530/machine-test/assets/48934200/c6cc36d4-e05a-4f99-9539-dcae30492ce6)

## Features

- **Offline and Online Mode:** The application supports offline functionality using Hive for local storage. It can sync data with a remote server when an internet connection is available.

- **Bloc Pattern:** The app follows the Bloc (Business Logic Component) pattern for state management. This helps in separating the presentation layer from the business logic, making the codebase modular and scalable.

- **Clean Architecture:** The project structure adheres to Clean Architecture principles, promoting separation of concerns and maintainability. The architecture is organized into three layers: Domain, Data, and Presentation.

## Tech Stack

- **Flutter:** The framework for building the cross-platform mobile application.

- **Bloc Library:** Used for implementing the Bloc pattern, providing a clean way to manage the state of the application.

- **Hive Database:** A lightweight and fast NoSQL database used for local storage of Todo items.

- **Firestore:** A Lightweight free NoSql database used for server side data storage.

## Project Structure

The project is organized into the following directories:

- **lib/**
  - **data/:** Contains data layer implementations (repositories, data sources).
  - **domain/:** Contains business logic (use cases, entities, and repositories interfaces).
  - **presentation/:** Contains the UI layer, including screens, widgets, and Bloc components.

## Setup

1. Clone the repository:

   ```bash
   git clone https://github.com/your-username/flutter-todo-app.git
