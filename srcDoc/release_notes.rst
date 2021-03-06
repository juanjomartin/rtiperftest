.. _section-release_notes:

Release Notes
=============

RTI Perftest Master Compatibility
---------------------------------

Using security
~~~~~~~~~~~~~~

Governance and Permission files have been updated to be compatible with
the latest release for *RTI Connext DDS*, and are compatible with *RTI
Connext DDS* 5.2.7 and greater.

If you are compiling *RTI Perftest* against 5.2.5, you will need to get
the certificates from the ``release/2.0`` branch. You can do that by
using the following git command from the top-level directory of your
repository:

::

    git checkout release/2.0 -- resource/secure

Compilation restrictions
~~~~~~~~~~~~~~~~~~~~~~~~

*RTI Perftest* is designed to compile and work against the *RTI Connext
DDS* 5.2.x and 5.3.x releases.

However, certain features are not compatible with all the *RTI Connext
DDS* versions, since the build scripts make use of certain specific
parameters in *Rtiddsgen* that might change or not be present between
releases:

-  The ``--secure`` and ``--openssl-home`` parameters will not work for
   versions previous to *RTI Connext DDS* 5.2.5.

-  Java code generation against *RTI Connext DDS 5.2.0.x* will fail out
   of the box. You can disable this by adding the ``--skip-java-build``
   flag. See the Known issues section for more information and
   alternatives.

-  C# code generation against *RTI Connext DDS 5.2.0.x* is not
   supported. You can disable this by adding the ``--skip-cs-build``
   flag.

Release Notes Master
--------------------

What's New in Master
~~~~~~~~~~~~~~~~~~~~

What's Fixed in Master
~~~~~~~~~~~~~~~~~~~~~~

Release Notes v2.2
------------------

What's New in 2.2
~~~~~~~~~~~~~~~~~

Added command-line parameters "-asynchronous" and "-flowController ``<``\ flow\ ``>``"
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

In previous releases Asynchronous Publishing was only enabled for the
DataWriters when the samples were greater than 63000 bytes and in such
case, RTI Perftest would only use a custom flow controller defined for
1Gbps networks.

This behavior has been modified: Starting with this release,
Asynchronous Publishing will be activated if the samples to send are
bigger than 63000 bytes or if the ``-asynchronous`` command-line
parameter is used. In that case, *RTI Perftest* will use the ``Default``
flow controller. However, now you can change this behavior by specifying
the ``-flowController`` option, which allows you to specify if you want
to use the default flow controller, a 1Gbps flow controller, or a 10Gbps
one.

Improved "-pubRate" command-line parameter capabilities
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

In previous releases the "-pubRate" command-line option would only use
the ``spin`` function to control the publication rate, which could have
negative effects related with high CPU consumption for certain
scenarios. Starting with this release, a new modifier has been added to
this option so it is possible to use the both "spin" and "sleep" as a
way to control the publication rate.

Added command-line parameter to get the CPU consumption of the process
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Starting with this release, it is possible to display the *CPU
consumption* of the *RTI Perftest* process by adding the Command-Line
Parameter ``-cpu``.

Better support for large data samples
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Prior to this release, the maximum sample size allowed by *RTI Perftest*
was set to 131072 bytes. The use of bigger sizes would imply changes in
the ``perftest.idl`` file and source code files. Starting with this
release, the maximum data length that *RTI Perftest* allows has
increased to 2,147,483,135 bytes, which corresponds to 2 Gbytes - 512
bytes - 8 bytes, the maximum data length that *RTI Connext DDS* can
send.

The sample size can be set via the ``-dataLen <bytes>`` command-line
parameter. If this value is larger than 63,000 bytes *RTI Perftest* will
enable the use of *Asynchronous Publishing* and *Unbounded Sequences*.

It is also possible to enable the use of *Unbounded Sequences* or
*Asynchronous Publishing* independently of the sample size by specifying
the command-line parameters ``unbounded <managerMemory>`` and
``-asynchronous``.

Added command-line parameter "-peer" to specify the discovery peers
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

In previous releases the only way to provide the Initial Peers was
either adding them to the QoS XML file or by using the environment
variable ``NDDS_DISCOVERY_PEERS``. Now it is possible to use a new
command-line parameter: ``-peer <address>`` with the peer address.

Now providing RTI Routing Service configuration files to test performance along with RTI Perftest
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

A new configuration file and wrapper script have been added for testing
RTI Perftest using one or several RTI Routing Service applications in
between Publisher and Subscriber. A new section has been added to the
documentation with all the configuration parameters: `Using RTI Perftest
with RTI Routing-Service <routing_service.md>`__.

Changed Announcement QoS profile to use "Transient local" Durability settings
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

In previous releases, the announcement topic DataWriters and DataReaders
were set to have a ``Volatile`` Durability QoS. In certain complex
scenarios, that could result in incorrect communication, which could
cause the RTI Perftest Publisher and Subscribers to get stuck and not
transmit data. By changing this topic to use Transient Local Durability,
these scenarios are avoided.

This should not have any effect on the latency of throughput reported by
RTI Perftest (as the main Throughput and Latency topics still have the
same configuration).

Added new functionality: Content Filtered Topic.
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

In previous releases the only way to provide scalability was by using
multicast and unicast. Now you can also choose which subscriber will
receive the samples by using the parameter ``-cft``. You can also
determine which sample will be sent by the publisher with the parameter
``-writeInstance``.

What's Fixed in 2.2
~~~~~~~~~~~~~~~~~~~

Conflicts when using "-multicast" and "-enableSharedMemory" at the same time
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

In previous releases, using "-multicast" in conjunction with
"-enableSharedMemory" may have caused the middleware to fail while
trying to access multicast resources although it was set to use only
shared memory. This behavior has been fixed.

"-nic" command-line parameter not working when using TCP transport
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

In previous releases the ``-nic`` command-line parameter was not taken
into account when using the TCP transport. This behavior has been fixed.

Batching disabled when sample size was greater than or equal to batch size
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

In previous releases the Batching Parameters were set unconditionally,
now the Batching QoS will be only applied if the Batch size is strictly
greater than the sample size.

Changed name of the "-enableTcp" option
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

In previous releases, the command-line option to use TCP for
communication was named ``-enableTcpOnly``. This is was inconsistent
with other transport options, so the name of the command has been
changed to ``-enableTcp``.

Dynamic Data not working properly when using large samples
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

In previous releases the following error could happen when using the
``-dynamicData`` command-line parameter in conjunction with ``-dataLen``
greater than 63000 bytes:

::

    DDS_DynamicDataStream_assert_array_or_seq_member:!sparsely stored member exceeds 65535 bytes
    DDS_DynamicData_set_octet_array:field bin_data (id=0) not found
    Failed to set uint8_t array

This error has been fixed starting in this release by resetting the
members of the Dynamic Data object before repopulating it.


Release Notes v2.1
------------------

What's New in 2.1
~~~~~~~~~~~~~~~~~

Multicast Periodic Heartbeats when the ``-multicast`` command-line parameter is present
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

In previous releases, the Writer side sent heartbeats via unicast even
if the command-line parameter ``-multicast`` was present. Now heartbeats
will be sent via multicast when ``-multicast`` is used. This change
should not affect one-to-one scenarios, but it will reduce the number of
heartbeats the Publisher side has to send in scenarios with multiple
subscribers.

Added command-line parameter to get the *Pulled Sample Count* in the Publisher side
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

The ``-writerStats`` command-line parameter now enables the some extra
debug log messages shown in the *Publisher* side of *RTI Perftest*.
These messages will contain the total number of samples being "pulled"
by the *Subscriber* side.

Added extra logic to be able to support *RTI Connext DDS 5.2.7* on Windows Systems
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

The names of the solutions generated by *rtiddsgen* for Windows
architectures changed in Code Generator 3.2.6 (included with *RTI
Connext DDS 5.2.7*). The solution name now includes the *rtiddsgen*
version number. Therefore the *RTIPerftest*'s ``build.bat`` script now
must query the *rtiddsgen* version and adjust the name of the generated
solutions it needs to call to compile.

This change should not be noticed by the user, as the script will
automatically handle the task of determining the version of *rtiddsgen*.

Added command-line parameter to avoid loading QoS from xml in C++.
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

If the ``-noXmlQos`` option is provided to *RTI Perftest* it will not
try to load the QoS from the ``xml`` file, instead it will load the QoS
from a string provided in the code. This string contains the same values
the ``xml`` file provides.

This option is only present for the Modern and Traditional C++ PSM API
code.

Note that changes in the ``xml`` will be ignored if this option is
present.

Updated Secure Certificates, Governance and Permission Files
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Governance and Permission files have been updated to be compatible with
the latest release for *RTI Connext DDS*, and are compatible with *RTI
Connext DDS* 5.2.7 and greater.

If you are compiling *RTI Perftest* against 5.2.5, you will need to get
the certificates from the ``release/2.0`` branch. You can do that by
using the following git command from the top-level directory of your
repository:

::

    git checkout release/2.0 -- resource/secure

What's Fixed in 2.1
~~~~~~~~~~~~~~~~~~~

"--nddshome" Command-Line Option did not Work in ``build.bat`` Script -- Windows Systems Only
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

There was an error in the ``build.sh`` script logic when checking for
the existence of the compiler executable files. This problem has been
resolved.

``build.sh`` script did not make sure executable existed before starting compilation
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Part of the ``build.sh`` script logic to check the existence of the
compiler executable files was not being called properly. This issue is
now fixed.

Incorrect ``high_watermark`` value when ``sendQueueSize`` is set to 1
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Setting the command-line parameter ``-sendQueueSize`` to 1 caused *RTI
Perftest* to fail, since it mistakenly set the ``high_watermark`` value
equal to the ``low_watermark``. This problem has been resolved. Now the
``high_watermark`` is always greater than the ``low_watermark``.

Batching settings not correctly set in the ``C++03`` code
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Settings related to batching in the XML configuration
(``perftest_qos_profiles.xml``) were not being used. This problem has
been resolved.

``dds.transport.shmem.builtin.received_message_count_max`` incorrectly set in Java code
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

The ``dds.transport.shmem.builtin.received_message_count_max`` property
was incorrectly set to 1 in every case. This erroneous behavior, which
was introduced in *RTI Perftest 2.0*, has been resolved.

Command-line parameter for setting the *RTI Connext DDS* verbosity
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

In previous releases of RTI Perftest, the RTI Connext DDS verbosity
could only be modified by using the command-line parameter ``-debug``.
This parameter would set the verbosity to ``STATUS_ALL``, with no option
to select an intermediate verbosity.

This behavior has been modified. The command-line parameter ``-debug``
has been changed to ``-verbosity,`` which can be followed by one of the
verbosity levels (Silent, Error, Warning, or All).

The default verbosity is Error.

Release Notes v2.0
------------------

What's New in 2.0
~~~~~~~~~~~~~~~~~

Platform support and build system
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

*RTI Perftest 2.0* makes use of the *RTI Connext DDS* *Rtiddsgen* tool
in order to generate part of its code and also the makefile/project
files used to compile that code.

Therefore, all the already generated makefiles and *Visual Studio*
solutions have been removed and now the build system depends on 2
scripts: ``build.sh`` for Unix-based systems and ``build.bat`` for
Windows systems.

*RTI Perftest* scripts works for every platform for which *Rtiddsgen*
can generate an example, except for those in which *Rtiddsgen* doesn't
generate regular makefiles or *Visual Studio Solutions* but specific
project files. That is the case of *Android* platforms as well as the
*iOS* ones.

Certain platforms will compile with the out of-the-box code and
configurations, but further tuning could be needed in order to make the
application run in the specific platform. The reason is usually the
memory consumption of the application or the lack of support of the
platform for certain features (like a file system).

Improved directory structure
^^^^^^^^^^^^^^^^^^^^^^^^^^^^

*RTI Perftest 2.0* directory structure has been cleaned up, having now a
much more compact and consistent schema.

Github
^^^^^^

*RTI Perftest* development has been moved to a *GitHub* project. This
will allow more frequently updates and code contributions.

The URL of the project is the following:
`github.com/rticommunity/rtiperftest <github.com/rticommunity/rtiperftest>`__.

Numeration schema
^^^^^^^^^^^^^^^^^

*RTI Perftest* development and releases are now decoupled from *RTI
Connext DDS* ones, therefore, and to avoid future numeration conflicts,
*RTI Perftest* moved to a different numeration schema.

The compatibility between *RTI Perftest* versions and *RTI Connext DDS*
ones will be clearly stated in the release notes of every *RTI Perftest*
release, as well as in the top-level ``README.md`` file.

Documentation
^^^^^^^^^^^^^

Documentation is no longer provided as a PDF document, but as *markdown*
files as well as in *html* format. You will be able to access to the
documentation from the *RTI Community* page, as well as from the
*GitHub* project.

Support for UDPv6
^^^^^^^^^^^^^^^^^

Added command-line parameter to force communication via UDPv6. By
specifying ``-enableUdpv6`` you will only communicate data by using the
UDPv6 transport.

The use of this feature will imply setting the ``NDDS_DISCOVERY_PEERS``
environment variable to (at least) one valid IPv6 address.

Support for Dynamic data
^^^^^^^^^^^^^^^^^^^^^^^^

Added command-line parameter to specify the use of the Dynamic Data API
instead of the regular *Rtiddsgen* generated code use.

Simplified execution in VxWorks kernel mode
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

The execution in *VxWorks OS kernel mode* has been simplified for the
user. Now the user can make use of ``subscriber_main()`` and
``publisher_main()`` and modify its content with all the parameters
required for the tests.

Decreased Memory Requirements for Latency Performance Test
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

The default number of iterations (samples sent by the performance test
publisher side) when performing a latency test has been updated. Before,
the default value was ``100,000,000``. This value was used to internally
allocate certain buffers, which imposed large memory requirements. The
new value is ``10,000,000`` (10 times less).

What's Fixed in 2.0
~~~~~~~~~~~~~~~~~~~

RTI Perftest behavior when using multiple publishers
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

The previous behavior specified that an *RTI Perftest Subscriber* in a
scenario with multiple *RTI Perftest Publishers* would stop receiving
samples and exit after receiving the last sample from the *RTI Perftest*
Publisher with ``pid=0``. This behavior could lead into an hang state if
some *RTI Perftest Publishers* with different ``pid`` were still missing
to send new samples.

The new behavior makes the *RTI Perftest Subscriber* wait until all the
Perftest Publishers finish sending all their samples and then exit.

Possible ``std::bad_alloc`` and Segmentation Fault in Latency Test in case of insufficient memory
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

When performing a latency performance test with traditional or modern
C++, the test tries to allocate certain arrays of unsigned longs. These
arrays can be quite large. On certain embedded platforms, due to memory
limitations, this caused a ``std::bad_alloc`` error that was not
properly captured, and a segmentation fault. This problem has been
resolved. Now the performance test will inform you of the memory
allocation issue and exit properly.

Default Max Number of Instances on Subscriber Side Changed to ``DDS_LENGTH_UNLIMITED``
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

In the previous release, if you did not set the maximum number of
instances on the subscriber side, it would default to one instance.
Therefore the samples for all instances except the first one were lost.

The new default maximum number of instances on the subscriber side has
been changed from one to ``DDS_LENGTH_UNLIMITED``. You can change this
limit manually by setting the Parameter ``-instances <number>``.

Error when using Shared Memory and Large Samples
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

When using *RTI Perftest* with large samples and enabling shared memory
we could get into the following error:

::

    Large data settings enabled (-dataLen > 63000).
    [D0001|ENABLE]NDDS_Transport_Shmem_Property_verify:received_message_count_max < 1
    [D0001|ENABLE]NDDS_Transport_Shmem_newI:Invalid transport properties.

Known Issues
------------

Building RTI Perftest Java API against RTI Connext DDS 5.2.0.x
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Due to the changes added in order to support larger data sizes, *RTI
Perftest* now makes use of *Unbounded Sequences*. This feature was not
added to *RTI Connext DDS* in *5.2.0.x*, so the following error will be
reported when trying to compile the Java API:

::

    [INFO]: Generating types and makefiles for java.
    [INFO]: Command: "/home/test/nevada/bin/rtiddsgen" -language java -unboundedSupport -replace -package com.rti.perftest.gen -d "/home/test/test-antonio/srcJava" "/home/test/test-antonio/srcIdl/perftest.idl"
    ERROR com.rti.ndds.nddsgen.Main Fail:  -unboundedSupport is only supported with C, C++, C++/CLI, or C# code generation
    rtiddsgen version 2.3.0
    Usage: rtiddsgen [-help]
    . . .
    INFO com.rti.ndds.nddsgen.Main Done (failures)
    [ERROR]: Failure generating code for java.

In order to avoid this compilation error, 2 changes are needed:

-  In the ``build.sh`` or ``build.bat`` scripts, modify the call for
   *Rtiddsgen* and remove the ``-unboundedSupport`` flag.

-  In the ``srcIdl/perftest.idl`` file, modify the ``TestDataLarge_t``
   and ``TestDataLargeKeyed_t`` types and add a bound to the
   ``bin_data`` member: ``sequence<octet,LIMIT> bin_data;``.

Publication rate precision on Windows Systems when using "sleep" instead of "spin"
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

When using the ``-pubRate <#>:sleep`` or ``-sleep`` command-line
parameters on Windows Systems the ``sleep()`` precision will be accurate
up to 10 milliseconds. This means that for publication rates of more
than 10000 samples per second we recommend using the "<#>:spin" option
instead.

Compiling manually on Windows Systems when using the *RTI Security* plugin
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

*rtiddsgen* generated solutions for Windows Systems allow 4 different
configurations:

-  Debug
-  Debug DLL
-  Release
-  Release DLL

However, the new *RTI Perftest* build system is focused on only
compiling one of those modes at a time. To choose the compilation mode,
use the ``-debug`` and ``-dynamic`` flags.
