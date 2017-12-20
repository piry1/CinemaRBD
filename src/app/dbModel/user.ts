export class User {
    Id: string;
    Imie: String;
    Nazwisko: String;
    Login: String;
    Haslo: String;
    Kot: String;

    static setCurrentUser(user: User) {
        localStorage.setItem('currentUser', JSON.stringify(user));
    }

    static getCurrentUser(): User {
        return JSON.parse(localStorage.getItem('currentUser')) as User;
    }

    static removeCurrentUser() {
        localStorage.removeItem('currentUser');
    }
}
