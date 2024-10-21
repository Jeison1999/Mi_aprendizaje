public class Agosto21 {
    public static void main(String[] args) {
        Particular car = new Particular(2000);
        car.ciudad = "bogota";
        car.placa = "dfg34f";
        car.color = "rojo";
        System.out.println("Particular: " +car.getInfo()+ "-" +car.placa+ "-" +car.color+ "-" +car.getRtm());

        Publico carro = new Publico(977);
        carro.ciudad = "mexico";
        carro.ruta = "123";
        System.out.println("Publico: " + carro.getInfo() + "-" + carro.getCodigo());
    }  
}

class Transporte{
    public String empresa;
    public String ciudad;
    public String getInfo(){
        return this.empresa+ "-" +this.ciudad;
    }
}

class Particular extends Transporte{
    public String placa;
    public String color;
    public int modelo;

    @Override
    public String getInfo(){
        return this.ciudad;
    }

    Particular(int m) {
        this.modelo = m;
    }

    public int getRtm(){
        return this.modelo + 5;
    }
}

class Publico extends Transporte{
    private int  ninterdo;
    public String  ruta;

    Publico(int n) {
        this.ninterdo = n;
    }

    public String getCodigo(){
       return this.ruta+ "-" +this.ninterdo;
    }
}




