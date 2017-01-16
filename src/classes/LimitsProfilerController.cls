public with sharing class LimitsProfilerController
{
    public Boolean isTypeDefined { get; private set; }
    public List<LimitsSnapshot> diffs { get; private set; }
    
    @TestVisible final LimitsProfiler profiler;
    public LimitsProfilerController()
    {
        diffs = new List<LimitsSnapshot>();
        try
        {
            profiler = (LimitsProfiler)Type.forName(getProfilerType()).newInstance();
            isTypeDefined = true;
        }
        catch (NullPointerException n) { isTypeDefined = false; }
        catch (TypeException t) { isTypeDefined = false; }
    }
    public PageReference configure() { return Page.LimitsProfilerConfig; }
    public String getProfilerType()
    {
        return LimitsProfilerConfig__c.getInstance().ProfilerType__c;
    }
    public Integer getIterations()
    {
        return (Integer)LimitsProfilerConfig__c.getInstance().Iterations__c;
    }
    public void measure()
    {
        diffs.add(profiler.measure(getIterations()));
    }
}