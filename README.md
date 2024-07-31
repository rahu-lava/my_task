Task Management App
Overview
The Task Management App is a Flutter application that allows users to manage their tasks, including creating, updating, and deleting tasks. It integrates with a Strapi backend for data storage and retrieval.

Setup Instructions
Prerequisites
Flutter SDK: Ensure that Flutter is installed on your machine. Follow the Flutter installation guide if it's not already installed.

Node.js: Ensure that Node.js is installed for running the Strapi backend. Follow the Node.js installation guide if it's not already installed.

Strapi: This project uses Strapi as the backend CMS. Ensure that Strapi is correctly set up and configured.

Installation Steps
Clone the Repository:

bash
Copy code
git clone https://github.com/your-username/your-repo.git
cd your-repo
Install Dependencies:

Flutter Dependencies:

bash
Copy code
flutter pub get
Strapi Dependencies:
Navigate to the Strapi project directory (if separate) and install dependencies:

bash
Copy code
cd path/to/strapi-project
npm install
Configure Strapi:

Ensure that Strapi is running and accessible. Update the Strapi URL in your Flutter code to point to the correct endpoint.

If you're running Strapi on your local machine and need to access it from a mobile device connected via USB, use your computer’s local IP address with the appropriate port. Typically, this would be done in your graphql_client.dart file:

dart
Copy code
final String uri = 'http://<your-computer-ip>:1337/graphql';
To find your local IP address, use:

Windows: ipconfig
macOS/Linux: ifconfig or ip a
Run Strapi:

Start the Strapi server:
bash
Copy code
npm run develop
Running the Project
Running on an Emulator
Start the Emulator:
Open your Android or iOS emulator.

Run the Flutter Application:

bash
Copy code
flutter run
Running on a Physical Device
Connect Your Device:
Connect your mobile device via USB and ensure USB debugging is enabled on Android or the device is properly set up for iOS development.

Run the Flutter Application:

bash
Copy code
flutter run
API Endpoints
The application uses the following Strapi API endpoints:

Tasks Query:

graphql
Copy code
query {
  tasks {
    data {
      id
      attributes {
        title
        description
        completed
      }
    }
  }
}
Create Task Mutation:

graphql
Copy code
mutation($title: String!, $description: String!, $completed: Boolean!) {
  createTask(data: { title: $title, description: $description, completed: $completed }) {
    data {
      id
    }
  }
}
Update Task Mutation:

graphql
Copy code
mutation($id: ID!, $title: String!, $description: String!) {
  updateTask(id: $id, data: { title: $title, description: $description }) {
    data {
      id
    }
  }
}
Delete Task Mutation:

graphql
Copy code
mutation($id: ID!) {
  deleteTask(id: $id) {
    data {
      id
    }
  }
}
Additional Notes
Error Handling: If you encounter errors related to GraphQL queries, ensure that your Strapi server is running and accessible.
Troubleshooting: If the application is not reflecting changes or updates, try restarting both the Strapi server and the Flutter application.
Network Configuration: Ensure that your device can access your computer’s local IP address and that there are no firewall rules blocking the connection.
