@isTest
private class TestFirstClass {
    @isTest 
    static void testWarmTemp() {
        Decimal celsius = FirstClass.fahrenheitToCelsius(70);
        System.assertEquals(21.11,celsius);
    } 
}