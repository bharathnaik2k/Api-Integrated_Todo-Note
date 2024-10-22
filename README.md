# Todo Note - App Project_Flutter with Dart

 #### This is a Todo Note project using a Flutter framework with dart language. And I am storing the Data of todo note to [Nstack.in](https://api.nstack.in/) website. That means I have integrated [Nstack.in](https://api.nstack.in/) API in this Project

 

### Nstack API Details
Nstack offers Todo API For Free. But It Collects by defalt **Only 10 Todo Notes**. You can change the API End Point Up to 20 Todo Note.
- I have Changed at End Point in this to store 20 Todo Notes

## App Preview

![App Preview](https://raw.githubusercontent.com/bharathnaik2k/Api-Integrated_Todo-Note/refs/heads/main/preview.jpg)

<h1 align="center" style="border-bottom: none">
    <b>

###### Check Here All Screenshots 👉 [Click Here](https://github.com/bharathnaik2k/Api-Integrated_Todo-Note/tree/main/screenshots) 

</h1>

## Project Details
- Used floatingActionButton to add New Todo Note

- After clicking the floatingActionButton the showModelButtonSheet opens.
which means I used the showModelBottomSheet widget to add the todo note.

- Here I have placed two textFields one todo Title and another one todo Description. and I have put a limit of 40 characters in the todo title

- After clicking Add Todo button showModelBottomSheet will be closed
After adding note the message show "adding successfully" will appear in the snack bar from below. If note Not is added "adding unsuccessful" message will appear.

- Home screen will be rebuilt after "adding successfully" That means the added note will be displayed on the home screen.

- The added note can also be edited and deleted For that, I added a PopupMenuButton widget in the trailing of the listtile
After clicking on the edit option, the showModelSottomSheet will open Which one do you want to edit? Title and description data will already be prefilled It can be edited and updated. It also shows same edited "Update successful" else 'Update unsuccessful"

- Clicking on the delete option will show the alertDialog widget It will show if you are sure to delete There you can click on Delete or Cancel. If You Click On Delete it also it also shows same deleted "Delete Successful" else "Delete Unsuccessful"

- ## other details
    - [Acme](https://fonts.google.com/specimen/Acme?query=acme) Font Style Is Used In This Project
    - I have used an SVG Image in Center of Splash Screen