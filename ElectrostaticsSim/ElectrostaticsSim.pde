import controlP5.*;
import java.io.File;

/* simulation inner workings */
Grid3D mainGrid;
Slicer mainSlicer;
Screen2D mainScreen2D;
Interpreter mainInterpreter;

/* UI */
ControlP5 mainUi;
File selectedFile;

RadioButton sliceButton;
RadioButton renderButton;

/* mechanics */
char renderOptions = 'p';
char sliceOptions = 'j';
int currentSlice = 0;
int sliceMin=0, sliceMax=0;


/* Default Fonts */
HashMap<String, PFont> fontMap;

public void setup() {
  size(400, 300);
  mainInterpreter = new Interpreter(this);
  mainUi = new ControlP5(this);
  surface.setAlwaysOnTop(true);
  
  /* init fonts */
  fontMap = new HashMap<String, PFont>();
  fontMap.put("h1", createFont("JetBrainsMono.ttf", 24, true));
  fontMap.put("h2", createFont("JetBrainsMono.ttf", 20, true));
  fontMap.put("h3", createFont("JetBrainsMono.ttf", 14, true));
  fontMap.put("p", createFont("JetBrainsMono.ttf", 12, true));
  
  // Button to open file
  mainUi.addButton("openFile")
     .setPosition(20, 20)
     .setSize(360, 30) // Same width as the submit button
     .setLabel("Open File to Run")
     .onClick(new CallbackListener() {
       public void controlEvent(CallbackEvent event) {
         selectInput("Select a file to open:", "fileSelected");
       }
     });

  // Textfield to show the file path
  mainUi.addTextfield("filePathField")
     .setPosition(20, 60)
     .setSize(360, 30)
     .setColor(color(255))
     .setText("") // Remove default text
     .setAutoClear(false)
     .setLock(true) // Make the text field read-only
     .getCaptionLabel().setVisible(false);

 sliceButton = mainUi.addRadioButton("sliceOptions")
     .setPosition(20, 145)
     .setSize(30, 30)
     .setColorForeground(color(120))
     .setColorActive(color(255))
     .setColorLabel(color(255))
     .setItemsPerRow(1)
     .setSpacingColumn(30)
     .addItem("Slice X", 'i')
     .addItem("Slice Y", 'j')
     .addItem("Slice Z", 'k');
     

  // Second Radio Button List
  renderButton = mainUi.addRadioButton("renderOptions")
     .setPosition(220, 145) // Positioned a bit more up
     .setSize(30, 30) // Made bigger
     .setColorForeground(color(120))
     .setColorActive(color(255))
     .setColorLabel(color(255))
     .setItemsPerRow(1)
     .setSpacingColumn(30)
     .addItem("Electric Field", 'v')
     .addItem("Potential", 'p')
     .addItem("Charge", 'c');

  // Horizontal Slider (called "slice")
  mainUi.addSlider("currentSlice")
     .setBroadcast(false)
     .setPosition(20, 255) // Moved a bit more up
     .setSize(330, 30) // Made shorter horizontally
     .setRange(0, 100)
     .setValue(50)
     .setLabel("Slice")
     .setSliderMode(Slider.FLEXIBLE)
     .setDecimalPrecision(0)
     .addListener(new ControlListener() {
       public void controlEvent(ControlEvent event) {
         if (event.isFrom(mainUi.getController("currentSlice")) && (mainScreen2D != null)) {
           mainScreen2D.updateBuffer(mainSlicer.getSlice(sliceOptions, true, currentSlice));
         }
       }
     })
     .setBroadcast(true);
     
  // Submit Button
  mainUi.addButton("run")
     .setPosition(20, 100)
     .setSize(360, 30)
     .setLabel("run")
     .onClick(new CallbackListener() {
       public void controlEvent(CallbackEvent event) {
         mainInterpreter.run(selectedFile);
         mainGrid = mainInterpreter.getGrid();
         mainSlicer = mainInterpreter.getSlicer();
         mainScreen2D = mainInterpreter.getScreen2D();
         mainUi.getController("currentSlice").setValue(0);
         mainUi.getController("currentSlice").setMin(0);
         mainUi.getController("currentSlice").setMax((float)mainGrid.getjRes());
       }
     });
           
  
}

void controlEvent(ControlEvent event) {
  if (event.isFrom(sliceButton) && (mainScreen2D != null)) {
    mainUi.getController("currentSlice").setBroadcast(false);
    mainUi.getController("currentSlice").setValue(0);
    sliceOptions = (char)event.getValue();
    mainScreen2D.setSliceMode(sliceOptions);
    currentSlice = 0;
    mainUi.getController("currentSlice").setMin(0);
    mainUi.getController("currentSlice").setMax((float)mainGrid.getRes(sliceOptions));
    mainUi.getController("currentSlice").setBroadcast(true);
  }
  if (event.isFrom(renderButton) && (mainScreen2D != null)) {
    mainUi.getController("currentSlice").setBroadcast(false);
    renderOptions = (char)event.getValue();
    mainScreen2D.setMode(renderOptions);
    mainUi.getController("currentSlice").setBroadcast(true);
  }
}

public void draw() {
}

void fileSelected(File selection) {
  if (selection != null) {
    selectedFile = selection;
    String filePath = selectedFile.getAbsolutePath();
    
    Textfield filePathField = mainUi.get(Textfield.class, "filePathField");
    if (filePathField != null) {
      filePathField.setText(filePath);
    } else {
      println("Error: Textfield 'filePathField' not found.");
    }
  }
}
