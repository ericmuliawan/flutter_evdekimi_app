# flutter_evdekimi_app

Evdekimi app.

dummy user login 
"email": "eve.holt@reqres.in",
"password": "cityslicka"

"email": "michael.lawson@reqres.in",
"password": "pistol"



#####My Ai Assistante#####

1. User: You and I are senior Flutter developers; we will build the application with great care and precision, always prioritizing clean code, architecture, and performance, while ensuring the UI runs smoothly across all devices.

2. User: As usual, I have `uikit` and `common` folders that serve as the foundational base before the build; now, let's adapt them to this project. Oh, and we'll be using BLoC for state management. also MVVM architecture

3. User: Okay, before we start building the UI, let's first ensure our app supports both dark and light modes.

4. User: why you not use or modif my UIKIT for appcolor to setup darkmode and lightmode

5. User: Now, let's start setting up the UI for authentication—specifically, the login and registration screens—with excellent UI/UX, you can add label "EVDEKimi" in center top

6. User: Please check main.dart. i already add some code, make sure its clean and run smoothly

7. User: oke next we will build home page chatbot screen, we will use google generative ai, using streaming responses

8. User: oke now after lgin succes, direct user to home screen chat bot

9. User: great UI, but we have some problem on chatbot, the respone chat always says "sorry something went wrong, please try again" i already checked on apikey but i think apikey its correct

10. User: why the response chat, its not like stream respone text by text

11. User: Why does the AI chatbot's response feel quite slow? Is there a specific buffer setting involved, and can we optimize it to make it faster?

12. User: Before we move on to the chat history storage feature, could we add a dark mode toggle button to the main screen to the left of the trash icon

13. User: Okay, now we're going to save the entire chat history to local storage so we can display it later in offline mode. Let's use SQLite, I find it to be the most stable option. What do you think?

14. User: It looks like we missed something yesterday: on the message sender side, we need to add a label displaying the username based on the login. Also, local storage should be specific to each logged-in user. Since the dummy API doesn't seem to provide a user ID, we can use the username for now so that message history remains separated between users.

15. User: oke now because my exmaple api register just needed only email and password like this "{"email": "eve.holt@reqres.in", "password": "pistol"}", so can we just update on function post api, dont update the ui

16. User: oke letsgo to implement ai llm on device, like my project before, the rules is if in offline mode will use ai on device, dont add in aseset, if offline and not downloaded model, will be appear popup to suggest dowbnload ai for offline mode

17. User: ah okay, can we add on chat message with speechtotext, i ever use flutter library speech_to_text, thats good plan or you have some suggest other thinks

18. User: next we will add option to upload image on chat bot, as I know, Google's generative AI can read images
