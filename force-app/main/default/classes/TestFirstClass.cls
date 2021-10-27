@isTest
private class TestFirstClass {
    @isTest 
    static void testWarmTemp() {
        Decimal celsius = firstClass.FahrenheitToCelsius(70);
        System.assertEquals(21.11,celsius);
    } 
}