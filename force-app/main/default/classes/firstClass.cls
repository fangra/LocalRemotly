public class FirstClass {/* class for testing github actions*/
    public static Decimal fahrenheitToCelsius(Decimal fh) { /** comment  */
         /**
     * @description fahrenheitToCelsius
     */
        Decimal cs = (fh - 32) * 5/9;/**  */
        return cs.setScale(2);/**comment  */
    }
}
