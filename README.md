Game of life
------------
<img src="https://github.com/garynewby/Game-of-Life/blob/master/GameOfLife/Assets.xcassets/GOL.imageset/GOL.png" width="320">

A cellular automaton devised by the British mathematician John Horton Conway in 1970.  
The 4 simple rules below are applied to each cell in the system each pass, and the  
state of each cell is calculated as alive or dead. From this intricate life-like  
forms evolve over time.  

Rules:  
1. Any live cell with less than two live neighbours dies, as if caused by under-population.  
2. Any live cell with two or three live neighbours lives on to the next generation.  
3. Any live cell with more than three live neighbours dies, as if by overcrowding.  
4. Any dead cell with exactly three live neighbours becomes a live cell, as if by reproduction.  

Implementation
--------------------
Swift, SpriteKit and UIKit

Notes
--------------------
Tap "New" to start from a random state, and "Pause/Continue" to halt or continue iterating.  
Tap any cell to change it's state while running or stopped, to influence the patterns that will evolve.

Author
------
Gary Newby

License
-------
Licensed under the MIT License.

