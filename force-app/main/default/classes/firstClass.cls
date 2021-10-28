public class firstClass {

    public static Decimal FahrenheitToCelsius(Decimal fh) {
        Decimal cs = (fh - 32) * 5/9;
        system.debug('FahrenheitToCelsius');
        return cs.setScale(2);
    }
}