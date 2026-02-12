import { NestFactory } from '@nestjs/core';
import { AppModule } from './app.module';
import { ValidationPipe } from '@nestjs/common';

async function bootstrap() {
  const app = await NestFactory.create(AppModule);
  
  app.useGlobalPipes(
    new ValidationPipe({
      //omite propiedades que no estan en el dto
      whitelist: true,
      //lanza un error si hay propiedades no definidas en el dto
      forbidNonWhitelisted: true,
    })
  );

  await app.listen(process.env.PORT ?? 3000);


}
bootstrap();
