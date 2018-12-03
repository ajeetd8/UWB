package Server;

import gameroom.GameRoom;
import gameroom.GameUser;
import Helper.RoomManager;
import javafx.application.Application;
import javafx.application.Platform;
import javafx.scene.Scene;
import javafx.scene.control.ScrollPane;
import javafx.scene.control.TextArea;
import javafx.stage.Stage;

import java.io.*;
import java.net.ServerSocket;
import java.net.Socket;
import java.util.*;

public class game_server extends Application {
//    TreeSet<GameUser> GameUsers = new TreeSet<>();
    Map<String, GameUser> GameUsers = new HashMap<>();

    @Override
    public void start(Stage primaryStage) {
        TextArea serverLog = new TextArea();

        // Create a scene and place it in the stage
        Scene scene = new Scene(new ScrollPane(serverLog), 450, 200);
        primaryStage.setTitle("Game Server"); // Set the stage title
        primaryStage.setScene(scene); // Place the scene in the stage
        primaryStage.show(); // Display the stage

        // socket open
        new Thread( () -> {
            try {
                ServerSocket serverSocket = new ServerSocket(8889);
                serverLog.appendText(": Server start at socket 8888 \n");

                while (true) {
                    Socket player = serverSocket.accept();
                    Platform.runLater(() -> {
                        serverLog.appendText("Someone join the server \n");
                        new Thread(new HandleASession(player)).start();
                    });
                }
            } catch (IOException e) {
                e.printStackTrace();
            }
        } ).start();
    }

    class HandleASession implements Runnable, MessageControl {
        private Socket player;
        private DataInputStream fromPlayerData;
        private ObjectInputStream fromPlayerObject;
        private DataOutputStream toPlayerData;
        private ObjectOutputStream toPlayerObject;
        private String username;


        HandleASession(Socket player) {
            try {
                // Initialize the socket, and run the program.
                this.player = player;
                this.fromPlayerData = new DataInputStream(this.player.getInputStream());
                this.fromPlayerObject = new ObjectInputStream(this.player.getInputStream());
                this.toPlayerData = new DataOutputStream(this.player.getOutputStream());
                this.toPlayerObject = new ObjectOutputStream(this.player.getOutputStream());
            } catch(IOException e) {
                e.printStackTrace();
            }
        }

        @Override
        public void run() {
            try {
                boolean nextScene = false;
//                DataInputStream fromPlayerData = new DataInputStream(player.getInputStream());
//                ObjectInputStream fromPlayerObject = new ObjectInputStream(player.getInputStream());
//                DataOutputStream toPlayerData = new DataOutputStream(player.getOutputStream());
//                ObjectOutputStream toPlayerObject = new ObjectOutputStream(player.getOutputStream());

                while(!nextScene) {
                    int action = fromPlayerData.readInt();
                    if (action == signInReq) {
                        System.out.println("Sign in Action detected");
                        GameUser clientUser = (GameUser) fromPlayerObject.readObject();
                        String username = clientUser.getUserName();
                        GameUser serverUser = GameUsers.get(username);

                        if( (serverUser!=null) && (serverUser.equals(clientUser)) ) {
                            System.out.println("Success");
                            this.username = username;
                            toPlayerData.writeInt(signInSuccess);
                            toPlayerObject.writeObject(GameUsers.get(username));
                        } else {
                            toPlayerData.writeInt(signInFail);
                        }
                    } else if (action == signUpReq) {
                        String username = fromPlayerData.readUTF();
                        String userpass = fromPlayerData.readUTF();
                        System.out.println("Sign up Action detected");

                        //Length check (longer than 3)
                        if(username.length() < 3) {
                            toPlayerData.writeInt(signUpFail);
                        } else if(null != GameUsers.put(username, new GameUser(username, userpass))) {
                            toPlayerData.writeInt(signUpSuccess);
                        } else {
                            toPlayerData.writeInt(signUpFail);
                        }

                    } else if (action == joinRoomReq) {
                        GameRoom room = (GameRoom)fromPlayerObject.readObject();
                        System.out.println(room.getRoomName());
//                        RoomManager.getRoom(room.getRoomName()).enterUser(GameUsers.get(username));
//                        RoomManager.removeRoom(room);

                    } else if (action == createRoomReq) {

                        System.out.println("create Room request detected");

                        String roomName = fromPlayerData.readUTF();
                        String username = fromPlayerData.readUTF();
                        if(!RoomManager.hasRoom(roomName)) {
                            // Making the room, when room does not exist.
                            RoomManager.createRoom(GameUsers.get(username), roomName);
                            toPlayerData.writeInt(createRoomSuccess);
                        } else {
                            // when room exist, do not create room.
                            toPlayerData.writeInt(createRoomFail);
                        }
                    } else if(action == refreshReq) {
                        ArrayList<GameRoom> userList = new ArrayList<>(RoomManager.getRoomList().values());
                        toPlayerObject.writeObject(userList);
                    }
                    else {
                        System.out.println(action);
//                        System.out.println("A Serious error at Sign in detected. Terminating the server");
//                        System.exit(0);
                    }
                }
            } catch (IOException e) {
                e.printStackTrace();
            } catch (ClassNotFoundException e) {
                e.printStackTrace();
            }
        }
    }
}
