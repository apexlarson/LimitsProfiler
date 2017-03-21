@IsTest
class LimitsProfilerTests
{
    virtual class SimpleProfiler extends LimitsProfiler
    {
        Integer executeCalls = 0;
        Integer startCalls = 0, finishCalls = 0;
        Integer setupCalls = 0, tearDownCalls = 0;
        public override void execute() { executeCalls += 1; }
    }
    static testMethod void testLimitsProfiler_DefaultCount()
    {
        Test.startTest();
            SimpleProfiler profiler = new SimpleProfiler();
            profiler.measure();
        Test.stopTest();
        
        system.assertEquals(0, profiler.setupCalls,
            'The setup method should not be overriden');
        system.assertEquals(0, profiler.startCalls,
            'The start method should not be overriden');
        system.assertEquals(1, profiler.executeCalls,
            'The execute method should be called exactly once');
        system.assertEquals(0, profiler.finishCalls,
            'The finish method should not be overriden');
        system.assertEquals(0, profiler.tearDownCalls,
            'The tearDown method should not be overriden');
    }

    class DemoProfiler extends SimpleProfiler
    {
        public override void setup() { setupCalls += 1; }
        public override void start() { startCalls += 1; }
        public override void finish() { finishCalls += 1; }
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
        system.assertEquals(1, profiler.startCalls,
            'The tearDown method should be called exactly once');
        system.assertEquals(ITERATIONS, profiler.executeCalls,
            'The execute method should be called the specified number of times');
        system.assertEquals(1, profiler.finishCalls,
            'The setup method should be called exactly once');
        system.assertEquals(1, profiler.tearDownCalls,
            'The tearDown method should be called exactly once');
    }
}