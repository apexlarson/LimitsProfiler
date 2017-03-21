global abstract class LimitsProfiler
{
    global abstract void execute();
    global virtual void setup() { }
    global virtual void start() { }
    global virtual void finish() { }
    global virtual void tearDown() { }
    global LimitsSnapshot measure() { return measure(1); }
    global LimitsSnapshot measure(Integer iterations)
    {
        setup();
        LimitsSnapshot start = LimitsSnapshot.getInstance();
        
        start();
        for (Integer i = 0; i < iterations; i++) execute();
        finish();
        
        LimitsSnapshot consumed = LimitsSnapshot.since(start);
        tearDown();
        return consumed;
    }
}