export class User {
    Id: number;
    Imie: String;
    Nazwisko: String;
    Login: String;
    Haslo: String;
    Kot: String;

    static setCurrentUser(user: User) {
        localStorage.setItem('currentUser', JSON.stringify(user));
    }

    static getCurrentUser() {
        return JSON.parse(localStorage.getItem('currentUser'));
    }

    static removeCurrentUser() {
        localStorage.removeItem('currentUser');
    }
}
