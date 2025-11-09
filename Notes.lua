__Add searchable comment throughout codebase
__Swap AI path randomly for more interesting behavior
__Add bounding box to cleansed geckos to prevent walking over
__Ensure entities table in scene class not in use
__Rename playercollision function for entity collision
__Prevent geckos from being cut off rendering
__Add death sprite for player
__Have geckos return to start positions if player is dead
__Factor gecko logic into gecko class, which aspects of entity class do enemies inherit
__Incorporate Prosto closure fix for local variables

Todo
__Add Elder Gecko NPC for item harvesting proficency
__Add inventory to state changes
__Standardize particle emission upon init
__Add showOff to Lute
__Remove beeps on non idol DialogueBox
__Prevent Inventory load if gameOver
__Flush DX DY, flashing, hit, resetAll player variables upon gameOver
__Add invulnerable state for tashio upon being hurt, esp when falling
__Automate idol DialogueBox insertions, have code, not working
__Add treasure sprites
__Fix lone pixel in flower animation
__Add correct text indicator timing to dialogue boxes
__Rehaul touch input into global buttonOutput table
__IDLE STATE for Player
__Hold off on rendering fret presses until luteState has been active a while
__Function to change tunic equip?
__Init Idle State without player render bug, and properly switch to idle if no inputs
__Add player fallState to help with falling animations
__Add falling Tunic overlays
__Add game objects to pickup
__New holding item animation state for player
__Add pushing sprites, as well as pushing animation state
__add left and right sprite to our player class
__Add case insensitivity to our chatbot command listens
__Add all colors to color constants palette
__Sweat when pushing without tunic of strength


Next Episode
X__Cursor blink reset when item inventory up
__Proper tome 1 enscription
__Element Showoff Red

__BUGFIX bats flying after chestOpen
__Improve distanceToPlayer in Bat Entity
__Add entity to collidable map objects collision
__Lute equip upon tunic change bug
__Hold off fret render on luteState swap
__Add credited supporters role
__Render string colors based on string animations
__Ensure signposts are inserted into currentMap.signposts
__Multiple page posts for signs
__Deinstantiate NPC when offscreen

__Channel trailer edit!
__Make substantial new sprites for tileMap
__Give enemy entities collidable map object logic
__Record channel trailer with demo levels
__Have cleansed geckos pick closest edge to walk to
__Collision detection for entities v MapObjects
__Update only currentMap entities
__Consider added time until next note into Note class

Research
__Potential mechanic to lessen enemy spawn
__From Shaky love.system.setClipboardText( text )
__How to reset entities to default locations upon a scene change
__How to render corruption particles over player
__Start game with quick session of five sprite spell cast?
__Circle radius for player to trigger attack states

CREDITED SUPPORTERS
X_K_Tronix at 7:23PM 8/17/2024**
X_soup_or_king at 8:02PM 4/09/2025**
X_roughcookie at 11:47PM 8/2/2025**
__Add flower anim to be transparent
__Tweak falling trigger upon pit collision

COMPLETED
X_Add timer for spitball spitting
X_Prevent bat entity from moving upon player
X_Normalize outputs based on both keyboard and touch
X_Add Tashio getting treasure sprite
X_Scripting for bottom trigger mageOpen cinematic
X_Move DialogueBox collidables into MageOpenCinematic State
X_Add Collision to the magic barrier
X_Store Scene Particles systems in scene psystem table
X_Render psystem at scenes adjacent offset
X_Add Gameboy resolution screen
X_Add Sprite
X_Moving with input
X_Clamping movement for player
X_Add HUD Stand-in
X_Add Walking animations
X_Normalize diagonal walking vector
X_Added lastInput animation overwrite
X_Prevent walking animation  when multiple inputs held
X_increase borders so that player can walk all the way to each side
X_Draw a whole screen using tile keycodes_Check if print function can round decimals -if so, stop truncating x and y positions
X_Change velocity to be Link Accurate
X_Increase character walking borders to be Link accurate
X_Add Repeating ground tile
X_Configure pretty way to declare tile id, hopefully grid fashion
X_Translate all images off screen when player walks offscreen
X_Make sure player position is accurate upon shiftingFinish
X_Prevent event dispatch if scene transitioning
X_Populate ALL Maps in global MAP[][]
X_Spritesheet additions --BIGGER MASTER SPRITE SHEET, currently 284x284
X_Fix the direction of player upon multiple input on scene transition
X_Handle three and four inputs better, maybe change direciton for the fourth input?
X_Add gecko directions
X_shrinkage for our collision detection
X_97 THROUGH 224
X_Add new bricks
X_Make Purple Fire Sprites
X_add perspective based collision detection for map objects
X_Add in MapObject class with collision detection
X_Find random particle bug, off way in middle
X_update tween values for all spellcastEntities
X_Stop updating orbs on scene transition
X_draw gecko on scene
X_BIG EPISODE ENTITY SYSTEM IMPLEMENTATION
X_Collision detection for map
X_Implement spinning fire spell cast for lvl 1 - 5
X_Shrink spellcast entity hitBox for enemy collisions
X_Randomize entity AI
X_Casting spell sprites
X_Add Entity health
X_Add knockback upon spellcast v entity collide
X_Add flashy pain indicator
X_Collision detection Spellcast v entity
X_Add more elegant flipped in entity
X_Add health to corrupted Gecko
X_Decrement health upon cast collision
X_Cleanse gecko with running away AI
X_Collision detection for player v entities
X_Player health
X_Clamp entity knockback to just before they deinstantiate
X_Limit Geck entities from being knocked out of bounds
X_Limit Player from being knocked out of bounds
X_Reset geckos position after collision
X_Redesign hitboxes for player to entity collision
X_Add 3 health Heart to HUD
X_Add Player health
X_Tiled map data downloader working
X_Spellcast entities need to ignore wall collisions
X_Work on 4th panel for channel trailer
X_Corrupted gecko health decrement bug
X_INSERTANIM()
X_Find where we reset Tashios animation up falling frames playing out
X_Add gravity suck upon pitCollide
X_Trigger falling animation
X_Add damage, and set Flashing for player
X_Respawn player in safe spot... algo for legal respawn
X_Change fall damage away from safeFromFall
X_Refactor safeFromFall name?
X_walking bug when idle
X_add animatbles functions into map[][] as tile id recognized
X_Falling Animation
X_New sprites!
X_Inventory system
X_Add framerate independence for player update and spellcast update
X_Manis framerate independent????
X_NPC walking in circle state
X_Incorporate Hud Items
X_Stenciling for log cabin
X_stilken idea for walking partially behind sprites
X_Add Inventory to HUD
X_HUD mockup overlay
X_Put entity instantions inside of MapDeclations
X_Render Particle systems in the currentMap, not scene
X_Fix fretsheld for touch
X_rehaul data downloader for layers,
X_WHY game break with collision and pits after playerLoad
