# music_piano coworker : https://github.com/TK-32
An electronic organ with recording and playback functions（FPGA）
Family : Cyclone IV E
Device : EP4CE10F17C8N
The simple music generator is a function expansion based on the simple electronic organ, so that it not only has the performance function of the electronic organ, but also can realize the simple recording, storage and playback function.
The design is realized through the combination of software and hardware. The hardware system includes the main controller chip, LED, etc. The software resources include the VHDL program and the software Quartus II for simulation.
The simple music generator mainly includes six functions: music playing, scale conversion, music recording, pause recording, playback recording, and LED display of working status.
Music playing: press keys s1 to s8 to play the scale do, re, mi, fa, sol, la, si, do (next tone) respectively. Click s1 to s8 to play the required music under a scale.
Tone conversion: press the keys s9 to s11 to switch the tones to low, medium and high respectively. Through the control of these three places, the tone conversion of playing and recording tracks can be realized.
Music recording: click s12 once to start recording.
Pause for re-recording: the Pause key can terminate the recording and clear the previous recording content, waiting for the next re-recording.
playback recording: After recording, click s12 again to play the track.
LED display working status: LED digital tube will display the current tone status and working status. Low, middle, high, and play represent the electronic organ working in low, medium and high tone areas and whether it is the function of playing recorded tracks.
