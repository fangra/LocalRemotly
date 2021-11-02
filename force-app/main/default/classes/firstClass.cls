public class FirstClass {
/* class for testing github actions*/
    public static Decimal fahrenheitToCelsius(Decimal fh) {
         /**
     * @description fahrenheitToCelsius
     */
        Decimal cs = (fh - 32) * 5/9;
        system.debug('first class !');
        return cs.setScale(2);
    }
}
