import { Body, Controller, Delete, Get, Param, ParseIntPipe, ParseUUIDPipe, Patch, Post, UsePipes, ValidationPipe } from '@nestjs/common';
import { CarsService } from './cars.service';
import { CreateCarDto } from './dto/create-car.dto';
import { create } from 'domain';
import { UpdateCarDto } from './dto/update-car.dto ';


@Controller('cars')
export class CarsController {

    constructor(
        private readonly carsService :CarsService
    ){}

    @Get()
    getAllCars(){
        return this.carsService.findAll()
    }

    @Get(':id')
    getCarById(@Param('id', ParseUUIDPipe) id: string){
        // console.log({id})
        return this.carsService.findOneById( id );
    }

    @Post()
    createCars(@Body() createCarsDto: CreateCarDto){
        return this.carsService.createCars(createCarsDto);
    }

    @Patch(':id')
    updateCars( 
        @Param('id', ParseUUIDPipe) id: string,
        @Body() updateCarsDto: UpdateCarDto ){
        return this.carsService.updateCars(id, updateCarsDto);
    }

    @Delete(':id')
    deleteCars( @Param( 'id', ParseUUIDPipe) id: string){
        return this.carsService.deleteCars(id)
    }

}
