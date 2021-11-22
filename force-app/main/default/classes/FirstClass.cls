public class FirstClass {

    public static Decimal fahrenheitToCelsius(Decimal fh) {
        Decimal cs = (fh - 32) * 5/9;
        system.debug('first class yes we did !! wohoo');
        return cs.setScale(2);
    }
}
