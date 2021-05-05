```                                   
 _______  ____ ___  ___ ___________  
 \_  __ \/ __ \\  \/  // __ \_  __ \ 
  |  | \|  ___/ >    <\  ___/|  | \/ 
  |__|   \___  >__/\_ \\___  >__|    
             \/      \/    \/                
```

# rexer
REXPaint batch conversion utility.
Why batchscript? Becuse it is text that you can edit and read (if you want) and you do not need any extre tools or compile it to run it. That's why.

## Usage
Place files you wish to convert into 'images' folder of you REXPaint instalation.
Place this file 'rexer.bat' next to your 'REXPaint.exe' executable and run it. Follow instructions on screen to chose your convrsion options TXT/PNG.
Once run it displays certain passages from REXPaint manual to eplain what it does and what format of data it expects. It is safe, without you explicitly selecting some meaningfull option, it does nothing. Be warned tho (next section).

## Warning
REXPaint does not care if during conversion there is already file with same name. It will happily write over it so take great care how you name your files. I might extend this batch file in future to take care of this situation. Or this will be fixed in REXPaint itself as on their side it is pretty trivial and makes much more sense.
