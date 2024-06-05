# Work Log

### 5/22/2024

Played around with some GUI libraries (LazyGUI, ControlP5), made some skeleton classes like Cell and Grid3D. Still trying to figure out how this will all come together. Doing alot of reading and research.

### 5/23/2024

Played around more with GUI, having a better idea of how to simulate everything

### 5/25/2024

Didn't do much. :/

### 5/26/2024

Did some more GUI Stuff, trying to figure out how to simulate conductors in an electric field, dialectrics, all the fun stuff

### 5/27/2024

More research. quite clueless on how to do things, played more around with the UI layout, rethinking class structures.

### 5/28/2024

Finally got a GUI layout in mind. Physics is real? I'm going to solve poisson's equations (the laplace of potential is equal to -charge density/permittivity. Going to use Finite Difference Method.

### 5/29/2024

render/slicing menu done. Added my laptop to the workflow

### 5/30/2024

I love linear algebra! Experimenting with various linear algebra libraries.
The most computationally expensive operation is solving the large system of equations needed. 

### 5/31/2024

For now I'm using the Jeigen linear algebra library. The grid's dimensions can be customized (not resitricted to a cube shape).
Got rid of the SlicerUI, ObjectUI, and other Uis. To set up the simulation, I'm going to use a description language that the program
will interpret. Worked on the Slicer and Screen2D classes. 

### 6/1/2024

Switched to using EJML, it has sparse matrix support and it really speeds up calculations. Played around with rendering things to a screen. Trying to get color scaling working (the nice ones matplotlib uses). 

### 6/2/2024

Huge crunch before demo day. Got rendering geometries working (to some extent) got color schemes it, UI, and description language. Getting ready for demo. need to have Efield vectors

### 6/3/2024

Demo day! Found bug in creating geometries, particularly the hollow box, looking into it.

### 6/4/2024

Still looking into issues with hollow box. Figuring out how to render field vectors and change the scaling so that induced charges can show up, might just use a different scale or do a logarithmic one, who knows. 

