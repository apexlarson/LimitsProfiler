public with sharing class LimitsProfilerConfigController
{
    public LimitsProfilerConfig__c config { get; private set; }
    public LimitsProfilerConfigController()
    {
        config = LimitsProfilerConfig__c.getInstance();
    }
    public PageReference save()
    {
        try
        {
            upsert config;
        }
        catch (DmlException d)
        {
            ApexPages.addMessages(d);
            return null;
        }
        return Page.LimitsProfiler;
    }
    public PageReference cancel()
    {
        return Page.LimitsProfiler;
    }
}