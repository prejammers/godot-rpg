# godot-rpg

Starter godot project following this tutorial

https://www.youtube.com/watch?v=pBoXqW4RykE

This project uses a free sprite pack, you can find it here. 
https://game-endeavor.itch.io/mystic-woods
Simply download and place the sprites folder in the project's root folder at

res://sprites

DO NOT MOVE THESE FILES. 

Git is ingoring this sprites folder. We can use and refence it but we are not granted
the right to distribute those files, so you must install them locally and leave them in
the ignored folder.

## Style Guide

Refer to [the Godot Docs](https://docs.godotengine.org/en/stable/tutorials/scripting/gdscript/gdscript_styleguide.html) for indepth styling, but here are some reminders and key points.

### Git Branches and Commits

Branches should contain specific functionality, with specific and readable names. For example, if you were to create a skeleton enemy, you should checkout a new branch (off of main) to contain that code, and *only* that code. 

Names for branches should be specific and readable. The name should have a prefix that quickly identifies the purpose of the branch. For instance, a branch used to create a skeleton enemy should not be named `stick`. A good example for a name would be `feature/skeleton_1`, with `feature/` being the prefix that denotes its an added feature. If you were to revisit it to fix bugs, instead use the prefix `bugfix/`. Other prefixes may be used; use your best judgement.

When committing changes to a branch, always include a message. Commits should be done frequently and after every change. You message should always finish the sentence, "this commit will..." For example, after completing the coding for a skeleton enemy's pathing, you should commit those changes with a detailed and concise message, such as `add skeleton enemy pathing`. You should avoid unnecessary capitalization and punctuation.

When making a pull request, include in the comment a summary of what changes were made. This should include any potential issues, fixes, or any relevant information for the commit. 

You should not merge your own pull requests. Once a branch has been merged, it is best to move on to a different branch.

### GDScript Styling

The Godot Docs contain more details, however, here are some important reminders.

#### Naming Conventions
Variables should be named in snake_case. Constants should be named in CONSTANT_CASE. Node and Class names should be in PascalCase. Names for Enums should be PascalCase, but the values of the enum should be CONSTANT_CASE. Files should always be named in snake_case. 

Functions should be named in snake_case, and should typically be named with active verbs. For example, a function for player movement should not be named `player_movement`, but instead should be named `move_player`. This is not a universal rule however, and specificity should take precedence. 

In all cases, avoid generic names and try to be as specific and concise as possible. Avoid repeating names as well.

#### Other Considerations
Append comments to areas of code that may be unclear or otherwise complex. If a piece of functionality is not working or unused, but you believe it may be fixable or used later, do not remove it; instead, comment it out. 

Save files in the correct locations. All scripts, regardless of origin, should be saved in the Scripts folder.
