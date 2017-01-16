@IsTest
class LimitsProfilerControllerTests
{
    public class NotAProfiler { }
    public class IsAProfiler extends LimitsProfiler
    {
        Integer calls = 0;
        public override void execute() { calls++; }
    }
	static testMethod void testConstructor_NullType()
    {
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
        LimitsProfilerConfig__c config = LimitsProfilerConfig__c.getInstance(UserInfo.getUserId());
        config.ProfilerType__c = String.valueOf(NotAProfiler.class);
        upsert config;
        
        Test.startTest();
        	LimitsProfilerController controller = new LimitsProfilerController();
        Test.stopTest();
        
        system.assertEquals(config.ProfilerType__c, controller.getProfilerType(),
            'A Profiler Type should be specified');
        system.assertNotEquals(null, Type.forName(controller.getProfilerType()),
            'A Profiler Type should be specified');
        system.assertEquals(false, controller.isTypeDefined,
            'The type should not be defined when the class does not extend LimitsProfiler');
        system.assertEquals(null, controller.profiler,
            'The profiler should not be constructed when no valid name is provided');
    }
    static testMethod void testLimitsProfilerController()
    {
        LimitsProfilerConfig__c config = LimitsProfilerConfig__c.getInstance(UserInfo.getUserId());
        config.ProfilerType__c = String.valueOf(IsAProfiler.class);
        config.Iterations__c = 100;
        upsert config;
        
        Test.startTest();
        	LimitsProfilerController controller = new LimitsProfilerController();
            PageReference configurePage = controller.configure();
            controller.measure();
        Test.stopTest();
        
        system.assertEquals(config.ProfilerType__c, controller.getProfilerType(),
            'A Profiler Type should be specified');
        system.assertEquals(config.Iterations__c, controller.getIterations(),
            'An Iteration count should be specified');
        system.assertNotEquals(null, Type.forName(controller.getProfilerType()),
            'A Profiler Type should be specified');
        system.assertEquals(true, controller.isTypeDefined,
            'The type should be defined when the class extends LimitsProfiler');
        system.assertNotEquals(null, controller.profiler,
            'The profiler should be constructed when a valid name is provided');
        system.assertEquals(config.Iterations__c, ((IsAProfiler)controller.profiler).calls,
            'The profiler should be called the specified number of iterations');
        system.assertNotEquals(null, configurePage,
            'The configure action should redirect to the Config page');
        system.assertEquals(Page.LimitsProfilerConfig.getUrl(), configurePage.getUrl(),
            'The configure action should redirect to the Config page');
    }
}