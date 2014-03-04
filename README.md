Objective-View
==============

A simple OBJ view written in Objective-C. I created this project to get in touch with Objective-C, a
language that I did not know. I developed the whole thing under windows using GNUstep, it *should*
build also under mac and linux without much pain. You just need to export the right environment 
variables I am using:

 - `NS_INCLUDE` should point to the include folder where Cocoa/OpenStep/GNUstep header are.
 - `NS_LIBRARY` should point to the library folder where the link-time libraries are. 


Currently the program is pretty limited, it just load a mesh (without material and no actions are 
performed on faces with more than 4 vertices). I am using display list for two reason, they are 
faster to implement and debug and they are faster for visualization purposes, a cleaner solution 
would be to use VBOs to store geometry data. Maybe in the future (if I got time) I will re-implement 
the `Mesh` class.

