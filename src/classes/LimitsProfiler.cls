global abstract class LimitsProfiler
{
    global abstract void execute();
    global virtual void setup() { }
    global virtual void tearDown() { }
    global LimitsSnapshot measure() { return measure(1); }
    global LimitsSnapshot measure(Integer iterations)
    {
        LimitsSnapshot start = LimitsSnapshot.getInstance();
        
        setup();
        for (Integer i = 0; i < iterations; i++) execute();
        tearDown();
        
        return LimitsSnapshot.since(start);
    }
}