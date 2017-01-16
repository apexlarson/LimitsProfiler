global class LimitsSnapshot
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
}