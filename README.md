# CV-Challenge-G7

## Project Description

This project is the result of a challenge from the Computer Vision Department of the Chair of Data Processing in the summer semester 2020. The motivation is based on the fact that in today's pandemic time more and more video calls and conferences take place in the own four walls. At the same time, you want to protect your own privacy from the eyes of others. This year's Challenge therefore deals with the distinction between foreground and background, as well as the possibility of replacing unwanted scene components. 

The data for this challenge is the ChokePoint dataset, which consists of recordings from surveillance cameras at various portals (P1, P2). There are three cameras each (C1, C2, C3), which film the same scenes (S1 - S5) simultaneously. Each portal was also recorded once from the inside (E enter) and once from the outside (L leave). The resulting images have a size of 800×600 pixels and were taken at 30fps.

__Link:__ http://arma.sourceforge.net/chokepoint/

## Challenge Requirements

* The group has to implement a ImageReader class, which is able to play two of the three video streams from a scene folder as an endless loop,
* The group has to implement a way to load images. In order to load an appropriate amount of images from the camera folders, the class should provide the method .next(),
* The group has to implement a function segmentation(left, right) which uses the two previously created tensors left and right with successive image pairs to estimate foreground and background for the first image pair,
* The group has to implement a function render(frame, mask, bg, render mode), which can process the current image of the left camera frame using the corresponding segmentation mask mask. 

The parameter render mode selects between the following modes:
- foreground: The background is set to black. The foreground in the image should be as little as can be changed.
- background: The foreground is set to black and only the background is visible.
- overlay: Foreground and background are set to black with good distinguishable colours are dyed transparent.
- substitute: Replaces the background with a virtual background which is passed in bg. 

The virtual background bg is an RGB image with any size N × M × 3



## Graphical User Interface

### General Design and Functionality

Figure 1: Main view of the gui with source path already set. 

The gui was designed with Matlab’s graphical user interface development environment (short GUIDE). As the replay of the rendered video is at the centre of attention, the design for GUI was split in two different panels. The Videoplayer panel consists of the two screens and for playback and pause, the respective push buttons. The other panel, the Menu panel, allows the user to define the source path for the desired playback, select the mode, and finally select a background image in .jpg format. The start pushbutton is used to start playback. If the user wants to have a specific starting point, he can set it via the start field. By default the value 0 is set. Finally there are three more push buttons. A push button that allows the user to record the viewed scenes and save them as an .av document. And another pushbutton to set the Loop mode. In Loop mode, playback is continued in an endless loop. From the moment the video reaches the last frame, it is reset to the defined start value. The last button is the Exit button which gives the user the chance to quit the gui. To make a clearer distinction between the many functionalities, the different buttons have been colored differently. The chosen colouring is based on common programs.  

### Code Architecture
One advantage of implementing the gui with Matlab's GUIDE is that the various components can be uniquely defined via tags. This is especially important because the interaction with the components is controlled by callback functions. These callback functions are automatically created by GUIDE. The naming of the functions is based on the selected tags.

### Storing States for Information Exchange between Application Components
In order to enable an exchange of information between the different components or the various callback functions, a state vector is defined when the gui is instantiated. This vector reflects the different selection options of the user. 

states = struct('gui_loop_set', 0, 'gui_start', 0, 'be_src', 0, 'be_L',1, 'be_R', 2, 'be_N', 2, 'EXIT', 0, 'selected_bg', 0, 'selected_mode', 'substitute', 'gui_save', 0);

Thus the state vector serves as a single source of truth, which decides, for example, whether the playback should be recorded or at which starting value the playback should begin. A global variable has been defined for saving, which contains the video object in save mode. Last but not least, at the beginning of the gui, an information window is also called up, which provides the most important information regarding use. 

Figure 2: Instruction window which provides additional information about usability for the user.

### Source Path, Background Image and Mode Selection
One of the main elements of the gui is the selection of a scene order whose frames are manipulated using the ImageReader class and the respective methods. To allow an easy selection of the scene folder, Matlab's built-in uigetdit() method was used. Here the user can click through his own file structure and select the desired scene folder. Using the browse_btn callback function, the first frames of the selected scene folder are loaded into the Figures. This serves to visually confirm the correct selection. The next_left() method implemented by the ImageReader class was used to load the frames. This loads only the left tensor for improved performance. 

Figure 3: Selection of the source folder. 

This selection of the background image in substitute mode is controlled by a similar procedure as the selection of the scene folder. Again, for user experience reasons, Matlab's built-in uigetfile() method is used. The method has been specified to allow only a selection of .jpg files.  The selection adjusts the respective field in the states vector. 

Figure 4: Browse background option only permits the selection of .jpg files.

With regard to the mode selection a popup menu element was chosen. This allows the 4 different modes to be defined as options. The states vector persists the selected mode. 
Start and Reset the Video 
The central function in the GUI.m script is the start_btn callback function. This is the interface for playback and modification via mode selection or background selection of the videos. A while loop is implemented in the function, which instantiates a new ImageReader object for each iteration and then outputs the n-selected frames via the next_left() method. The left tensor is then manipulated with the segmentation() and render() functions according to the user's specifications. If the user has selected the substitute mode, but did not set a background image, a warning message is called to allow a new background image selection. The rendered frame and the original frame are loaded into the gui's FIgures. To get a better overview of the frame number, background and mode selection, the current specification is displayed with text fields in the lower left margin. The correct iteration of the respective frames is controlled by an external variable counter. The exit from the While loop can be done via the global state variable EXIT, or with the exit of the video (if the Loop variable is not set). With the Loop variable, the video can be continued in an endless loop. To do this, the While Loop checks for the Loop state variable, and if the condition is met, the counter is reset to the selected start value. In the While Loop the counter is also checked for the recording request. A more detailed explanation is given below. 

### Enter the Loop Mode or Record the Replay
Another requirement regarding the gui is the endless playing of the scene with the specifications given by the user. As explained in the previous section, this requirement is checked and implemented using the variable gui_loop_set. Within the While loop, the condition is checked in each iteration. This allows to set the loop mode even during the already started playback. If gui_loop_set is set, the counter is reset to the original start value and the while loop starts counting again. 
The recording or saving of frames is controlled by the Record button. This calls the stop_btn callback function. A video object is created within the function. The current rendered frame is stored in this object after playback has started. This allows the recording of videos with different specifications, because the video object remains even after a restart or another mode selection. The video object is not closed and deleted until the Record button is called again. Before that, the accumulated frames are saved to an .avi file. The default file name is output.avi.

### Play and Pause the video
Another functionality that gui must include is the ability to pause and resume playback. Pausing the playback is realized with the Matlab function uiwait(). This stops the execution of the playback loop in the start function and does not interrupt it completely. To resume playback, use the Play button. By pressing it the counterpart function of the uiwait(), the uiresume() function is called. 
