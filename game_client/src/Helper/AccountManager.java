package Helper;

import gameroom.GameUser;

/**
 * This is helper function for client side.
 */
public class AccountManager {
    public static GameUser gameUser;

    public AccountManager(GameUser gameUser) {
        this.gameUser = gameUser;
    }

    public static String getUsername() {
        return gameUser.getUserName();
    }
}
