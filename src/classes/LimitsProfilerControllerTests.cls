@IsTest
class LimitsProfilerControllerTests
{
    static final Integer ITERATIONS = 100, TRIALS = 25;
    static final String VALID_TYPE = String.valueOf(IsAProfiler.class);
    
    public class NotAProfiler { }
    public class IsAProfiler extends LimitsProfiler
    {
        Integer calls = 0;
        public override void execute() { calls++; }
    }
    
    @TestSetup static void setup()
    {
        LimitsProfilerConfig__c config = LimitsProfilerConfig__c.getInstance(UserInfo.getUserId());
        config.ProfilerType__c = VALID_TYPE;
        config.Iterations__c = 100;
        upsert config;
    }
    
    static testMethod void testConstructor_NullType()
    {
        LimitsProfilerConfig__c config = LimitsProfilerConfig__c.getInstance(UserInfo.getUserId());
        delete config;
        
        Test.startTest();
            LimitsProfilerController controller = new LimitsProfilerController();
        Test.stopTest();
        
        system.assertEquals(false, controller.isTypeDefined,
            'The type should not be defined when no name is provided');
        system.assertEquals(null, controller.profiler,
            'The profiler should not be constructed when no valid name is provided');
    }
    static testMethod void testConstructor_DoesNotExtend()
    {
        final Type GIVEN_TYPE = NotAProfiler.class;
        LimitsProfilerConfig__c config = LimitsProfilerConfig__c.getInstance(UserInfo.getUserId());
        config.ProfilerType__c = String.valueOf(GIVEN_TYPE);
        upsert config;
        
        Test.startTest();
            String profilerTypeName = LimitsProfilerController.getProfilerType();
            Type profilerType = Type.forName(profilerTypeName);
            
            LimitsProfilerController controller = new LimitsProfilerController();
        Test.stopTest();
        
        system.assertEquals(String.valueOf(GIVEN_TYPE), profilerTypeName,
            'A Profiler Type should be specified');
        system.assertEquals(GIVEN_TYPE, profilerType,
            'The correct Profiler Type should be specified');
        
        system.assertEquals(false, controller.isTypeDefined,
            'The type should not be defined when the class does not extend LimitsProfiler');
        system.assertEquals(null, controller.profiler,
            'The profiler should not be constructed when no valid name is provided');
    }
    static testMethod void testConstructor_HappyPath()
    {
        Test.startTest();
            Integer observedIterations = LimitsProfilerController.getIterations();
            String profilerTypeName = LimitsProfilerController.getProfilerType();
            Type profilerType = Type.forName(profilerTypeName);
            
            LimitsProfilerController controller = new LimitsProfilerController();
            controller.measure();
        Test.stopTest();
        
        system.assertEquals(ITERATIONS, observedIterations,
            'An Iteration count should be specified');
        system.assertEquals(VALID_TYPE, profilerTypeName,
            'A Profiler Type should be specified');
        system.assertEquals(IsAProfiler.class, profilerType,
            'A Profiler Type should be specified');
        
        system.assertEquals(true, controller.isTypeDefined,
            'The type should be defined when the class extends LimitsProfiler');
        system.assertNotEquals(null, controller.profiler,
            'The profiler should be constructed when a valid name is provided');
    }
    
    static testMethod void testConfigure()
    {
        LimitsProfilerController controller = new LimitsProfilerController();
        
        Test.startTest();
            PageReference configurePage = controller.configure();
        Test.stopTest();
        
        system.assertNotEquals(null, configurePage,
            'The configure action should redirect to the Config page');
        system.assertEquals(Page.LimitsProfilerConfig.getUrl(), configurePage.getUrl(),
            'The configure action should redirect to the Config page');
    }
    
    static testMethod void testMeasure()
    {
        LimitsProfilerController controller = new LimitsProfilerController();
        
        Test.startTest();
            for (Integer t = 0; t < TRIALS; t++) controller.measure();
        Test.stopTest();
        
        system.assertEquals(TRIALS, controller.diffs.size(),
            'Each trial should have a stored diff');
        
        IsAProfiler profilerInstance = (IsAProfiler)controller.profiler;
        system.assertEquals(TRIALS * ITERATIONS, profilerInstance.calls,
            'The profiler should be called the specified number of iterations');
    }
    
    static testMethod void testGetRecords()
    {
        List<LimitsSnapshot> snapshots = new List<LimitsSnapshot>();
        for (Integer i = 0; i < TRIALS; i++)
            snapshots.add(LimitsSnapshot.getInstance());
        
        Test.startTest();
            List<Limits_Snapshot__c> records = LimitsProfilerController.getRecords(snapshots);
        Test.stopTest();
        
        system.assertEquals(TRIALS, records.size(),
            'There should be a record for each snapshot');
        for (Limits_Snapshot__c record : records)
        {
            system.assertEquals(VALID_TYPE, record.Profiler_Type__c,
                'The profiler type should match the current setting');
            system.assertEquals(ITERATIONS, record.Iterations__c,
                'The iterations should match the current setting');
        }
    }
    
    static testMethod void testSave_Empty()
    {
        LimitsProfilerController controller = new LimitsProfilerController();
        
        Test.startTest();
            controller.save();
        Test.stopTest();
        
        system.assert(!ApexPages.hasMessages(),
            'No success or failure messages should display for an empty collection');
    }
    static testMethod void testSave()
    {
        LimitsProfilerController controller = new LimitsProfilerController();
        
        Test.startTest();
            for (Integer t = 0; t < TRIALS; t++) controller.measure();
            controller.save();
        Test.stopTest();
        
        system.assertNotEquals(0, [SELECT count() FROM Limits_Snapshot__c],
            'The records should save successfully');
        system.assert(ApexPages.hasMessages(ApexPages.Severity.CONFIRM),
            'A success message should display when records are saved');
    }
    static testMethod void testSave_Exception()
    {
        LimitsProfilerController controller = new LimitsProfilerController();
        List<Limits_Snapshot__c> snapshots = new List<Limits_Snapshot__c>
        {
            new Limits_Snapshot__c(Id=SObjectType.Limits_Snapshot__c.getKeyPrefix().rightPad(15, '0'))
        };
        
        Test.startTest();
            controller.safeInsert(snapshots);
        Test.stopTest();
        
        system.assertEquals(0, [SELECT count() FROM Limits_Snapshot__c],
            'The records should fail to save');
        system.assert(ApexPages.hasMessages(ApexPages.Severity.ERROR),
            'An error message should display when records fail to save');
    }
}