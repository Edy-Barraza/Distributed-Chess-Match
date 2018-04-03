# Distributed-Chess-Match

A distributed chess system supporting gameplay across multiple computers! 
<img width="700" alt="screen shot 2018-04-03 at 9 46 24 am" src="https://user-images.githubusercontent.com/29441448/38253367-7b142a9c-3724-11e8-9884-353f70d917ca.png">


To run this on your machine, follow these steps in the folder with the source files in the command terminal:

1. Compile the program: run the command `make`

2. Create a server: On the desired server hosting machine, run the command `make server`.
   By defualt this command will set up a socket in the port '12344' in the host's ip address.
   Should the user desire to set up a server in a different port, 
  the user can run `./server.byte port` after compiling server (i.e. after running `make`)
    where port is replaced by the integer of a unused port.
   (Note it is only possible if the machine runs Unix OS and has a visible IP address.) 
   
 3. Initiate the game: run the command `make main`.
   This will start a repl prompting the user for input. The repl gives instruction for possible inputs and the user chooses    how they wish to proceed. 


NOTE: for correct functioning of the game, the person playing 'white' must run `make main` and finish connecting to the server (once the game pops up you have connected to the server) before the person playing 'black' connects.

4. Repl configurations: All of the following commands are possible inputs to the repl. Here are some specifications about them for clarity. Note: ip and port are replaced by the integer values representing the ip and port numbers of the server respectively:
- `white ip port`: Must be called before the second player connects to the repl.
- `black ip port`: Must be called after the first player connects to the repl.
- `white1`: Can only be ran from the same computer as the server, and assumes the same default port '12344' as the server. In addition, it must also be ran before the player playing black connects.
- `black1`: Can only be ran from the same computer as the server, and assumes the same default port '12344' as the server. In addition, it must also be ran after the player playing white connects.


Acknowledgements:
Collaborated with Daniel Vicuña (dav74@cornell.edu), Jang Hyun Cho (jc2926@cornell.edu), and William Chen (wlc54@cornell.edu).
