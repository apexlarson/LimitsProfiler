@IsTest
class LimitsProfilerTests
{
    class DemoProfiler extends LimitsProfiler
    {
        Integer setupCalls = 0, executeCalls = 0, tearDownCalls = 0;
        public override void setup() { setupCalls += 1;}
        public override void execute() { executeCalls += 1; }
        public override void tearDown() { tearDownCalls += 1; }
    }
    static testMethod void testLimitsProfiler()
    {
        final Integer ITERATIONS = 100;
        
        Test.startTest();
            DemoProfiler profiler = new DemoProfiler();
            profiler.measure(ITERATIONS);
        Test.stopTest();
        
        system.assertEquals(1, profiler.setupCalls,
            'The setup method should be called exactly once');
        system.assertEquals(1, profiler.tearDownCalls,
            'The tearDown method should be called exactly once');
        system.assertEquals(ITERATIONS, profiler.executeCalls,
            'The execute method should be called the specified number of times');
    }
    static testMethod void testLimitsProfiler_DefaultCount()
    {
        Test.startTest();
            DemoProfiler profiler = new DemoProfiler();
            profiler.measure();
        Test.stopTest();
        
        system.assertEquals(1, profiler.executeCalls,
            'The execute method should be called exactly once');
    }
}