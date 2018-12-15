package Client;

import Helper.AccountManager;
import Helper.SocketManger;
import Server.MessageControl;
import gameroom.GameUser;
import javafx.application.Application;
import javafx.geometry.Insets;
import javafx.geometry.Pos;
import javafx.scene.Node;
import javafx.scene.Scene;
import javafx.scene.control.*;
import javafx.scene.layout.*;
import javafx.scene.text.Text;
import javafx.stage.Stage;

import java.io.*;

/**
 *
 */
public class client_main extends Application {
    private SocketManger socket;
    private Text title;
    Label username;
    Label password;
    TextField userTextField;
    PasswordField pwBox;
    Text actionTarget;

    /**
     *
     * @param primaryStage
     */
    @Override
    public void start(Stage primaryStage) {
        // Initialize the socket.
        socket = new SocketManger();

        // Initialize the socket.
        GridPane pane = new GridPane();
        pane.setHgap(10);
        pane.setVgap(10);
        pane.setPadding(new Insets(25, 25, 25, 25));

        // Setting label, and text box
        title = new Text("Welcome");
        username = new Label("User Name: ");
        password = new Label("Password");
        userTextField = new TextField();
        pwBox = new PasswordField();
        actionTarget = new Text();

        // Setting the position of labe, and text field.
        pane.add(title, 0, 0, 2, 1);
        pane.add(username, 0, 1);
        pane.add(password, 0, 2);
        pane.add(userTextField, 1, 1);
        pane.add(pwBox, 1, 2);

        // Setting the signin and signout button.
        Button signInButton = new Button("Sign in");
        Button signUpButton = new Button("Sing up");
        HBox hBox = new HBox(10);
        hBox.setAlignment(Pos.BOTTOM_RIGHT);
        hBox.getChildren().add(signInButton);
        hBox.getChildren().add(signUpButton);
        pane.add(hBox, 1, 4);
        // sign in/up meesage added
        pane.add(actionTarget, 1, 6);

        // Sign in "Actions
        signInButton.setOnAction(event -> {
            String userID = userTextField.getText();
            String userPassword = pwBox.getText();
            try {
                socket.toServerData.writeInt(MessageControl.signInReq);
                socket.toServerObject.writeObject(new GameUser(userID, userPassword));

                int ack = socket.fromServerData.readInt();


                if(ack == MessageControl.signInSuccess) {
                    // Signin Success case handle

                    // Login Process started.
                    GameUser object = (GameUser) socket.fromServerObject.readObject();
                    new AccountManager(object);
                    System.out.println(object.getUserName());
                    new GameView(socket).start(primaryStage);

                    // Hide sign in page when the login is done.
//                    ((Node)(event.getSource())).getScene().getWindow().hide();
                } else if (ack == MessageControl.signInFail) {


                    System.out.println("Signin failed");
                    actionTarget.setText("Signin Failed. \nCheck ID and password");
                } else {
                    System.out.println("A serious problem in signin process");
                }

            } catch(IOException ex) {
                ex.printStackTrace();
            } catch(ClassNotFoundException ex) {
                ex.printStackTrace();
            }
        });

        // Singup button.
        signUpButton.setOnAction(event -> {
            String userID = userTextField.getText();
            String pass = pwBox.getText();
            try {
                socket.toServerData.writeInt(MessageControl.signUpReq);
                socket.toServerData.writeUTF(userID);
                socket.toServerData.writeUTF(pass);
                int ack = socket.fromServerData.readInt();

                if(ack == MessageControl.signUpSuccess) {

                } else if (ack == MessageControl.signUpFail) {

                } else {
                    System.out.println("A serious problem in signUp process");
                }
            } catch (IOException ex) {
                ex.printStackTrace();
            }
        });

        Scene scene = new Scene(pane, 300, 275);
        primaryStage.setScene(scene);
        primaryStage.setTitle("Game Login");
        primaryStage.show();
        primaryStage.setOnCloseRequest(event -> System.exit(0));
    }
}


