global with sharing class LimitsSnapshot
{
    global static LimitsSnapshot getInstance()
    {
        return new LimitsSnapshot(
            Limits.getAggregateQueries(), Limits.getAsyncCalls(), Limits.getCallouts(),
            Limits.getDMLRows(), Limits.getDMLStatements(), Limits.getEmailInvocations(),
            Limits.getFutureCalls(), Limits.getMobilePushApexCalls(), Limits.getQueries(),
            Limits.getQueryLocatorRows(), Limits.getQueryRows(), Limits.getQueueableJobs(),
            Limits.getSoslQueries(), Limits.getHeapSize(), Limits.getCpuTime(),
            Datetime.now().getTime()
        );
    }
    global static LimitsSnapshot since(LimitsSnapshot start) { return diff(start, getInstance()); }
    global static LimitsSnapshot diff(LimitsSnapshot a, LimitsSnapshot b)
    {
        return new LimitsSnapshot(
            b.aggregateQueries - a.aggregateQueries, b.asyncCalls - a.asyncCalls,
            b.callouts - a.callouts, b.dmlRows - a.dmlRows, b.dmlStatements - a.dmlStatements,
            b.emailInvocations - a.emailInvocations, b.futureCalls - a.futureCalls,
            b.mobilePushApexCalls - a.mobilePushApexCalls, b.queries - a.queries,
            b.queryLocatorRows - a.queryLocatorRows, b.queryRows - a.queryRows,
            b.queueableJobs - a.queueableJobs, b.soslQueries - a.soslQueries,
            b.heapSize - a.heapSize, b.cpuTime - a.cpuTime, b.rawTime - a.rawTime
        );
    }
    global static List<Limits_Snapshot__c> getRecords(List<LimitsSnapshot> snapshots)
    {
        List<Limits_Snapshot__c> records = new List<Limits_Snapshot__c>();
        for (LimitsSnapshot snapshot : snapshots) records.add(snapshot.newSObject());
        return records;
    }
    
    global Integer aggregateQueries { get; private set; }
    global Integer asyncCalls { get; private set; }
    global Integer callouts { get; private set; }
    global Integer cpuTime { get; private set; }
    global Integer dmlRows { get; private set; }
    global Integer dmlStatements { get; private set; }
    global Integer emailInvocations { get; private set; }
    global Integer futureCalls { get; private set; }
    global Integer heapSize { get; private set; }
    global Integer mobilePushApexCalls { get; private set; }
    global Integer queries { get; private set; }
    global Integer queryLocatorRows { get; private set; }
    global Integer queryRows { get; private set; }
    global Integer queueableJobs { get; private set; }
    global Integer soslQueries { get; private set; }
    global Long rawTime { get; private set; }
    LimitsSnapshot(
        Integer aggregateQueries, Integer asyncCalls, Integer callouts, Integer dmlRows,
        Integer dmlStatements, Integer emailInvocations, Integer futureCalls,
        Integer mobilePushApexCalls, Integer queries, Integer queryLocatorRows, Integer queryRows,
        Integer queueableJobs, Integer soslQueries, Integer heapSize, Integer cpuTime, Long rawTime
    ){
        this.aggregateQueries = aggregateQueries;
        this.asyncCalls = asyncCalls;
        this.callouts = callouts;
        this.dmlRows = dmlRows;
        this.dmlStatements = dmlStatements;
        this.emailInvocations = emailInvocations;
        this.futureCalls = futureCalls;
        this.mobilePushApexCalls = mobilePushApexCalls;
        this.queries = queries;
        this.queryLocatorRows = queryLocatorRows;
        this.queryRows = queryRows;
        this.queueableJobs = queueableJobs;
        this.soslQueries = soslQueries;
        this.heapSize = heapSize;
        this.cpuTime = cpuTime;
        this.rawTime = rawTime;
    }
    global Limits_Snapshot__c newSObject()
    {
        return new Limits_Snapshot__c(
            Aggregate_Queries__c = aggregateQueries, Async_Calls__c = asyncCalls,
            Callouts__c = callouts, CPU_Time__c = cpuTime, DML_Rows__c = dmlRows,
            DML_Statements__c = dmlStatements, Email_Invocations__c = emailInvocations,
            Future_Calls__c = futureCalls, Heap_Size__c = heapSize, Elapsed_ms__c = rawTime,
            Mobile_Push_Apex_Calls__c = mobilePushApexCalls, Queries__c = queries,
            Query_Locator_Rows__c = queryLocatorRows, Query_Rows__c = queryRows,
            Queueable_Jobs__c = queueableJobs, SOSL_Queries__c = soslQueries
        );
    }
}