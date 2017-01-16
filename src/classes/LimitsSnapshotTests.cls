@IsTest
class LimitsSnapshotTests
{
    class EmptyMock implements HttpCalloutMock
    {
        public HttpResponse respond(HttpRequest request) { return new HttpResponse(); }
    }
    static testMethod void testGetInstance_HeapSize()
    {
        Test.startTest();
            String a = 'a';
            LimitsSnapshot snapshot = LimitsSnapshot.getInstance();
        Test.stopTest();
        
        system.assertNotEquals(0, snapshot.heapSize, 'Some heap should be consumed');
    }
    static testMethod void testGetInstance_Callouts()
    {
        Test.startTest();
            Test.setMock(HttpCalloutMock.class, new EmptyMock());
            new Http().send(new HttpRequest());
            LimitsSnapshot snapshot = LimitsSnapshot.getInstance();
        Test.stopTest();
        
        system.assertEquals(1, snapshot.callouts, 'A callout should be consumed');
    }
    static testMethod void testGetInstance_Queries()
    {
        Test.startTest();
            List<User> data = [SELECT (SELECT Id FROM ManagedUsers) FROM User];
            LimitsSnapshot snapshot = LimitsSnapshot.getInstance();
        Test.stopTest();
        
        system.assertEquals(1, snapshot.queries, 'A query should be consumed');
        system.assertEquals(1, snapshot.aggregateQueries, 'An aggregate query should be consumed');
    }
    
    static testMethod void testDiff_CpuTime()
    {
        Test.startTest();
            LimitsSnapshot start = LimitsSnapshot.getInstance();
            List<String> data = new List<String>();
            for (Integer i = 0; i < 1000; i++)
                data.add('a'.repeat(1000));
            LimitsSnapshot diff = LimitsSnapshot.since(start);
        Test.stopTest();
        
        system.assertNotEquals(0, diff.cpuTime, 'Some CPU Time should be consumed');
    }
}