
// Esta clase define la estructura de datos que debe enviar el cliente al crear un nuevo coche.

import { IsString } from "class-validator";


//pero no la valida.
export class CreateCarDto {
    @IsString()
    readonly brand: string;
    @IsString()
    readonly model: string;
}