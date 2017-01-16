@IsTest
class LimitsProfilerConfigControllerTests
{
	static testMethod void testLimitsProfilerConfigController()
    {
        Test.startTest();
        	LimitsProfilerConfigController controller = new LimitsProfilerConfigController();
        	controller.config.ProfilerType__c = 'Populated';
        	PageReference saveRedirect = controller.save();
        	PageReference cancelRedirect = controller.cancel();
        Test.stopTest();
        
        system.assertEquals(UserInfo.getUserId(), controller.config.SetupOwnerId,
            'Config should be specific to the running user');
        system.assert(!ApexPages.hasMessages(), ApexPages.getMessages());
        system.assertNotEquals(null, controller.config.Id,
            'Config should be inserted');
        
        system.assertNotEquals(null, saveRedirect,
            'Should redirect to the profiler page');
        system.assertEquals(Page.LimitsProfiler.getUrl(), saveRedirect.getUrl(),
            'Should redirect to the profiler page');
        
        system.assertNotEquals(null, cancelRedirect,
            'Should redirect to the profiler page');
        system.assertEquals(Page.LimitsProfiler.getUrl(), cancelRedirect.getUrl(),
            'Should redirect to the profiler page');
    }
	static testMethod void testLimitsProfilerConfigController_DmlException()
    {
        Test.startTest();
        	LimitsProfilerConfigController controller = new LimitsProfilerConfigController();
        	controller.config.Id = SObjectType.LimitsProfilerConfig__c.getKeyPrefix().rightPad(15, '0');
        	PageReference saveRedirect = controller.save();
        Test.stopTest();
        
        system.assertEquals(UserInfo.getUserId(), controller.config.SetupOwnerId,
            'Config should be specific to the running user');
        system.assert(ApexPages.hasMessages(), 'There should be an error');
        system.assertNotEquals(null, controller.config.Id,
            'Config should be inserted');
        system.assertEquals(null, saveRedirect,
            'Should not redirect on error');
    }
}