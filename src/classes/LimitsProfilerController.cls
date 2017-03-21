public with sharing class LimitsProfilerController
{
    public String summary { get; set; }
    
    public Boolean isTypeDefined { get; private set; }
    public List<LimitsSnapshot> diffs { get; private set; }
    
    @TestVisible final LimitsProfiler profiler;
    public LimitsProfilerController()
    {
        diffs = new List<LimitsSnapshot>();
        summary = getProfilerType();
        try
        {
            profiler = (LimitsProfiler)Type.forName(getProfilerType()).newInstance();
            isTypeDefined = true;
        }
        catch (NullPointerException n) { isTypeDefined = false; }
        catch (TypeException t) { isTypeDefined = false; }
    }
    public PageReference configure() { return Page.LimitsProfilerConfig; }
    public void measure()
    {
        diffs.add(profiler.measure(getIterations()));
    }
    public void save()
    {
        if (diffs.isEmpty()) return;
        safeInsert(getRecords(diffs));
    }
    @TestVisible void safeInsert(List<Limits_Snapshot__c> records)
    {
        try
        {
            insert records;
            ApexPages.addMessage(new ApexPages.Message(
                ApexPages.Severity.CONFIRM, 'Save successful'
            ));
            diffs.clear();
        }
        catch(DmlException d)
        {
            ApexPages.addMessages(d);
        }
    }
    
    public static String getProfilerType()
    {
        return LimitsProfilerConfig__c.getInstance().ProfilerType__c;
    }
    public static Integer getIterations()
    {
        return (Integer)LimitsProfilerConfig__c.getInstance().Iterations__c;
    }
    public static List<Limits_Snapshot__c> getRecords(List<LimitsSnapshot> snapshots)
    {
        List<Limits_Snapshot__c> records = LimitsSnapshot.getRecords(snapshots);
        for (Limits_Snapshot__c record : records)
        {
            record.Profiler_Type__c = getProfilerType();
            record.Iterations__c = getIterations();
        }
        return records;
    }
}