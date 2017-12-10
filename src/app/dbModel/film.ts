export class Film {
    Id: number;
    Tytul: String;
    Rezyser: String;
    Rok: String;
    Gatunek: String;
    Dlugosc: String;
}

export class Serializable {
    
        fromJSON(json) {
            for (var propName in json)
                this[propName] = json[propName];
            return this;
        }
    
    }