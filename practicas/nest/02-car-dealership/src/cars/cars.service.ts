import { BadRequestException, Injectable, NotFoundException, Param, ParseIntPipe } from '@nestjs/common';
import { Car } from './interfaces/car.interface';
import { v4 as uuid} from 'uuid';
import { CreateCarDto, UpdateCarDto } from './dto';
import { refCount } from 'rxjs';


@Injectable()
export class CarsService {



    private cars :Car[] = [
        {
            id: uuid(),
            brand: 'toyota',
            model: 'Corolla'
        },
        {
            id: uuid(),
            brand: 'Honda',
            model: 'Civic'
        },
        {
            id: uuid(),
            brand: 'Ducati',
            model: 'pagani'
        }
    ];

    findAll(){
        return this.cars;
    }

    findOneById(id : string,){
        const buscar = this.cars.find( car => car.id === id );
        /*
        Forma corta
        if (!buscar) throw new NotFoundException(`No existe cars con el id ${ id }`);
        */

         if (!buscar){
            throw new NotFoundException(`No existe cars con el id ${ id }`);
         }  

        return buscar ;
    }

    createCars(createCarDto: CreateCarDto){
        const car :Car = {
            id: uuid(),
            //... autocompleta los valores que faltan(brand,model)
            ...createCarDto
        }
        this.cars.push(car);
        return car;
    }

    updateCars(id: string, updateCarsDto: UpdateCarDto){
        let carDB = this.findOneById(id);
        
        if ( updateCarsDto.id && updateCarsDto.id == id)
            throw new BadRequestException(`Car id is not valid inside body`);

        this.cars = this.cars.map( car => {
            if (car.id === id) {
                carDB = { ...carDB,...updateCarsDto, id}
                return carDB;
            }
            
            return car;
        })
        return carDB ;
    }



}
