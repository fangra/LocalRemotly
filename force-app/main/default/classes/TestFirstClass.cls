@isTest
private class TestFirstClass {
  /* class for TestFirstClass */
    @isTest 
    static void testWarmTemp() {
          /* class for testWarmTemp */
        Decimal celsius = FirstClass.fahrenheitToCelsius(70);
        System.assertEquals(21.11,celsius);
    } 
}