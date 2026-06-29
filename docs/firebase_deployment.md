# Firebase Deployment Configuration

See the official documentation for more details: https://firebase.google.com/docs/flutter/setup?hl=es-419&platform=android

### Step 1: Install Firebase CLI

Follow this command to access to Firebase with CLI:

```
firebase login
```

Go to this Url to install the Firebase CLI: https://firebase.google.com/docs/cli?hl=es-419&authuser=0&_gl=1*1q8lmcf*_ga*NzkwNTUyMzQ2LjE3NzQ4NTMyODM.*_ga_CW55HF8NVT*czE3ODA3OTA4MjUkbzI0JGcxJHQxNzgwNzkxMjA3JGo2MCRsMCRoMA..#install_the_firebase_cli

### Step 2: Install and execute the FlutterFire CLI

Only the first command to add the FlutterFire CLI to your system, the second command is to execute the configuration of the Firebase project in your Flutter project.

follow this command to install the FlutterFire CLI:

```
dart pub global activate flutterfire_cli
```

Select the UITopic Project

![step-2](https://i.imgur.com/fpGUFdy.png)

Select the platforms you want to configure (Android and iOS in this case)

```
flutterfire configure --project=uitopic-1406c
```

![step-2](https://i.imgur.com/wbG81nn.png)


### Step 3: Configure the apps to use Firebase

Follow this command:

```
flutterfire configure
```

![step-4](https://i.imgur.com/ULjQPd8.png)
