# LimitsProfiler

## Purpose

While it may be true that premature optimization is the root of all evil, at a certain point it becomes necessary. Especially if we aim to write streamlined utility classes that will be referenced hundreds or even thousands of times, we should strive for code that performs optimally.

One problem with using scripts in `Execute Anonymous` to assess performance is that logging levels themselves affect performance! Because of that, any robust solution must include a method to persist the data, so that profiling can be run with logging turned off completely. 

## Usage

### Version 1.0

At the most basic level, this version allows you to see current limits usage with a `LimitsSnapshot`.

    system.debug(LimitsSnapshot.getInstance());

The above script will yield output something like the following:

> LimitsSnapshot:[aggregateQueries=0, asyncCalls=0, callouts=0, cpuTime=2, dmlRows=0, dmlStatements=0, emailInvocations=0, futureCalls=0, heapSize=1682, mobilePushApexCalls=0, queries=0, queryLocatorRows=0, queryRows=0, queueableJobs=0, rawTime=1484534149238, soslQueries=0]

This version introduces a basic framework (the `LimitsProfiler` class) which can be used in `Execute Anonymous` scripts. Here is a basic example:

```apex
static List<Integer> data = new List<Integer>();
for (Integer i = 0; i < 1000000; i++) data.add(i);

class IsEmptyProfiler extends LimitsProfiler
{
    public override void execute()
    {
        Boolean isEmpty = data.isEmpty();
    }
}
class SizeProfiler extends LimitsProfiler
{
    public override void execute()
    {
        Boolean isEmpty = data.size() == 0;
    }
}

system.debug(new IsEmptyProfiler().measure(1000));
system.debug(new SizeProfiler().measure(1000));
```

### Version 1.1

This version introduces a configurable `Visualforce` UI that can run arbitrary extensions of the `LimitsProfiler` class. By default, it displays `CPU Time`, `Heap Size`, and `Raw Time`. As an example of how to use it, you can set `ProfilerType__c` to `Profilers.SerializationProfiler` and define the following class:

```apex
public with sharing class Profilers
{
    public class SerializationProfiler extends LimitsProfiler
    {
        final List<String> data;
        public SerializationProfiler()
        {
            data = new List<String>();
            for (Integer i = 0; i < 1000; i++)
                data.add('a'.repeat(1000));
        }
        public override void execute()
        {
            String payload = JSON.serialize(data);
        }
    }
}
```

Try running this profiler with various logging levels and you will see just how much performance can vary based on your settings. Even with the conservative example above there can be a difference of over 3x from the lowest to the highest logging level.

More significant than logging levels, however, is that each run constitutes a separate transaction. This benefit has important implications, such as allowing you to run trials which in aggregate consume more than 10s CPU Time. It also means that when you profile triggers which access lazy loaded data (for example), the code will re-initialize each time. To be able to provide a consistent measurement without context switching was not possible using `Execute Anonymous` alone.

### Version 1.2

This version introduces a `Limits_Snapshot__c` object which allows you to persist data from profiling runs. It tracks all limits usage and can be generated directly from a `LimitsSnapshot` instance in `Apex` using the `newSObject()` method:

```apex
Limits_Snaphsot__c record = LimitsSnapshot.getInstance().newSObject();
```

The Visualforce UI also now includes a `Save` button, which saves the diffs already measured.

This version also introduces the `LimitsProfilerConfig__c` hierarchy setting to the repository so it can be pulled directly into an org without requiring any package installation.

## Install Links

**Production**

- **[Version 1.2](https://login.salesforce.com/packaging/installPackage.apexp?p0=04t41000002RXGo)** - Persistent objects make it possible to store and track performance.
- **[Version 1.1](https://login.salesforce.com/packaging/installPackage.apexp?p0=04t410000022Gc1)** - Configurable Visualforce UI makes profiling possible with logging turned off.	
- **[Version 1.0](https://login.salesforce.com/packaging/installPackage.apexp?p0=04t410000022FLP)** - LimitsSnapshot and LimitsProfiler classes enable basic profiling via anonymous scripts

**Sandbox**

- **[Version 1.2](https://test.salesforce.com/packaging/installPackage.apexp?p0=04t41000002RXGo)** - Persistent objects make it possible to store and track performance.
- **[Version 1.1](https://test.salesforce.com/packaging/installPackage.apexp?p0=04t410000022Gc1)** - Configurable Visualforce UI makes profiling possible with logging turned off.	
- **[Version 1.0](https://test.salesforce.com/packaging/installPackage.apexp?p0=04t410000022FLP)** - LimitsSnapshot and LimitsProfiler classes enable basic profiling via anonymous scripts
