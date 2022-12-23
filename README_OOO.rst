.. .. raw:: html
.. 
..     <style> .red {color: red} .redst {color: red; text-decoration: line-through}</style>

.. role:: red
.. role:: redst

==========================
ECE 411: MP4 Documentation
==========================

-----------------------------------------------------
An Out-of-Order Implementation of the RV32I Processor
-----------------------------------------------------

    The software programs described in this document are confidential and proprietary products of
    Altera Corporation and Mentor Graphics Corporation or its licensors. The terms and conditions
    governing the sale and licensing of Altera and Mentor Graphics products are set forth in written
    agreements between Altera, Mentor Graphics and its customers. No representation or other
    affirmation of fact contained in this publication shall be deemed to be a warranty or give rise
    to any liability of Altera and Mentor Graphics whatsoever. Images of software programs in use
    are assumed to be copyright and may not be reproduced.

    This document is for informational and instructional purposes only. The ECE 411 teaching staff
    reserves the right to make changes in specifications and other information contained in this
    publication without prior notice, and the reader should, in all cases, consult the teaching
    staff to determine whether any changes have been made.

.. contents:: Table of Contents
.. section-numbering::


----

Introduction
============

This machine problem involves the design of a pipelined, out-of-order microprocessor. You are
required to implement the RV32I instruction set (with the exception of ``FENCE*``, ``ECALL``,
``EBREAK``, and ``CSRR`` instructions) using the pipelining techniques described in lectures. You
have freedom to vary the exact out-of-order microarchitectural details. This handout is an
incomplete specification to get you started with your design, a portion of this machine problem is
left open ended for you to explore design options that interest you.

You will begin your design by creating a non-speculative out-of-order pipeline that can execute the
RV32I instruction set, and supports in order commit via the reorder buffer (ROB). Then, you will
add support for branch prediction and integrate a basic cache system. After implementing a
functional pipeline that can execute the RV32I ISA, you will have the opportunity to expand your
design with advanced design options of your choosing. Note that you are not required to implement
advanced design features to receive full credit, however they may be useful in improving
performance. You will not compete in the same design competition as in order pipeline groups, but
will be evaluated on a different scale with the baseline and other out-of-order teams. Your main
goal should be functional correctness. 

Getting Started
===============

Working as a Group
------------------

For this assignment, you must work in a group of three people (unless the class size is not a
multiple of three or you have been approved by the course staff). It will be your responsibility to
work on the assignment as a team. Every member should be knowledgeable about all aspects of your
design, so do not silo responsibilities and expect everything to work when you put the parts
together. Good teams will communicate often and discuss issues (either with the
design/implementation or with teamwork) that arise in a timely manner.

To aid collaboration, we provide a private Github repository [#]_ that you can use to share code
within your team and with your TA.

Part of working well as a team is being courteous to the rest of the team, even when you plan to
drop the class. We ask that you let TAs and the rest of your team know as soon as possible if you
plan to drop ECE 411, so we can reassign other people and minimize the number of issues later in
the semester.

.. [#] Your repository may not be immediately available as team assignments need to be finalized,
   and then the repositories are all created manually. You will be able to find the repository in
   the same location as your MP repository when it is ready.

Mentor TAs
----------

Given that every group's design will be different in MP4, it is often difficult for a TA unfamiliar
with your group to answer all of your questions. In order to make sure that each group has someone
who is knowledgeable about their design, each group will be assigned a mentor TA. You will have
regular meetings with your mentor TA, so that they know how your project is doing and any major
hurdles you have encountered along the way. You must meet with your mentor TA at least once every
week. Scheduling these meetings is *your* responsibility. Check with your mentor TA for their
preferred scheduling method/availability. In the past, some teams skipped the meetings without
contacting mentor TAs in advance, and we have received course feedback asking that they be made
mandatory.

Your first meeting with your mentor TA will be not only to review your paper design for your basic
pipeline, but also to discuss your goals for the project. Before meeting with your mentor TA, you
should have discussed in detail with your team about what design options you plan to explore. Your
mentor TA may advise against certain options, but you are free to work on whatever you like. As the
project progresses, you may find that your goals and your design change. This is normal and you are
free to take the project in a direction that interests you. However, you must keep your mentor TA
up to date about any changes you have made or plan to make.

In order to get the most out of your relationship with your mentor TA, you should approach the
relationship as if your group has been hired into a company and given the MP4 design as a job
assignment. A senior engineer has been assigned to help you stay on schedule and not get
overwhelmed by tool problems or design problems. *Do not* think of the TA as an obstacle or hostile
party. *Do not* try to "protect" your design from the TA by not allowing him or her to see defects
or problem areas. *Do not* miss appointments or engage in any other unprofessional conduct. If you
plan to make a late submission, your mentor TA should know as soon as possible, so they can make
sure you are still on track. Your mentor TA should be a consulting member of your team, not an
external bureaucrat.

Testing
-------

Throughout the MP, you will need to generate your own test code and verification strategy. This is
extremely important as untested components may lead to failing the final test code and competition
benchmark altogether. Out-of-order CPUs are significantly more complex than in order ones.
Verifying full correctness can take time. You cannot just test that your processor executes each of
the instructions correctly in isolation. You should try to generate test code to test as many
corner cases as you can think of. In addition, we strongly encourage that you use the verification
techniques that you have learned so far in class to generate additional tests.

Due to the flexibility of your design, we cannot provide a ready-to-go instantiation of the RVFI
monitor as we have in the past. You will need to figure out how to hook the monitor up on your
own.

Teams looking to design a non-superscalar processor with single commits should be able to use the
given RVFI monitor to verify their design. However, due to the flexibility of your design, we
cannot provide a ready-to-go instantiation of the RVFI monitor as we have in the past. You will
need to figure out how to hook the monitor up on your own. For help, you can visit the RVFI
Monitor's `GitHub page <https://github.com/SymbioticEDA/riscv-formal>`_.

Teams looking to design a superscalar OoO processor or a processor supporting multiple simultaneous
commits may find it easier to create a golden software model that can execute instructions
perfectly. In comparison to the RVFI monitor, which aims to be synthesizable, your golden software
model only needs to run in simulation, allowing you to execute multiple instructions within a
single cycle using the outputs of the previously executed instruction as inputs to the next
instruction being executed. This model can be written in SystemVerilog or another language. Every
time your out-of-order CPU commits an instruction, the software model should also commit an
instruction. At this point the architectural state of the model and CPU can be checked for
consistency. If there is a difference between the two architectural states, a fatal error can be
thrown describing the difference in state as well as the incorrectly executed instruction. This is
an effective way to ensure functional correctness of your design (although this method will not
catch performance bugs or memory issues).

As always, we expect you to fully read through all provided code and documentation before starting
your design. There may be requirements not explicitly mentioned in this documentation but are made
clear through a basic reading of the provided code. The TAs will make every effort to ensure
completeness of the documentation, but please read the provided code as well.

Tomasulo Algorithm
==================

We recommend that all OoO teams implement their processors with the Tomasulo Algorithm, which is the
same algorithm taught in this class's lecture. While you are free to implement your processor using
a different design (e.g. scoreboarding), the TA's may not be able to offer as much assistance in
your design and debugging stages.

Front End
---------

The front end consists of your instruction fetch, instruction queue, instruction decode, and
instruction issue. Even with OoO processors, instructions are fetched and issued in order. Your
processor's front end will be very similar to an in order team's front end.

Your instruction fetch will need to request the data for the next instruction from the instruction
cache based on the current PC, then put that instruction onto the instruction queue. It will also
need to perform any branch prediction to find and update the next PC value (for branches, JAL, and
JALR instructions). From the perspective of the instruction fetch, an instruction can be
considered "executed" as soon as it gets put onto the instruction queue. This means your PC
register will be "ahead" of whatever instruction is currently actually being executed and retired
by the later stages.

The purpose of the instruction queue is to provide a buffer between the instruction fetch and the
execution unit(s). While your execution units might be stalled waiting on a dependency to resolve,
your instruction fetch can still add new instructions to the queue. Likewise, while your
instruction fetch stalls because of an instruction cache miss, your execution unit(s) can still be
issued new instructions.

The instruction issue is the stage where an instruction is taken out of the instruction queue, any
register dependencies are checked (e.g. checking the regfile for a ROB tag), and data is loaded
into the reservation station(s).

When designing your front end, keep in mind the different stall conditions and flush conditions. For
example, if there are no more instructions left on the instruction queue, you must stall the
instruction issue to avoid issuing garbage data to your reservation stations. Similarly, if the
instruction queue fills up, you must temporarily stall the instruction fetch stage since there is
nowhere to put the newly fetched data.

Execution
---------

The execution stage primarily consists of your reservation station(s) and load/store queue.

Because dependencies between instructions are automatically handled by the algorithm with ROB tags,
it is trivial to add additional reservation stations and execution units. For example, you can
design your processor with multiple ALUs to concurrently execute instructions as their dependencies
get satisfied. For simplicity, you may also choose to attach an ALU to every single reservation
station.

The load/store queue is responsible for handling any memory instructions such as ``lw``, ``lh``,
``lb``, ``sw``, ``sh``, ``sb``, etc. We recommend that most teams handle all memory operations in
an in order fashion, which means creating a single queue for both loads and stores. While it is
possible to execute memory operations out-of-order, it adds significant complexity to your
processor's logic and flushing mechanisms and won't be covered in this document. Trying to handle
memory operations out-of-order would mean needing to perform dynamic memory disambiguation or
memory dependence speculation.

Commit/Retire
-------------

To allow for the speculative execution of instructions, all instructions need to be placed in your
reorder buffer (ROB) during instruction issue. While instructions may be executed out-of-order,
they should only be retired in order. This means your processor should not perform a memory write
or change the regfile until an instruction is ready to be retired.

Upon discovery of a branch misprediction, you will need to flush parts of your processor including
the instruction queue, reservation station(s), load/store queue, and reorder buffer. You can choose
to flush either as soon as a branch misprediction is detected, or you can wait until the
misprediction reaches the head of the ROB and is ready to be retired.

In the former case, the process of flushing is slightly more complicated, but you will see better
performance as you are not unnecessarily executing instructions. Since the branch misprediction is
not at the head of the ROB, you will need to perform a "selective flush" on your ROB, load/store
queue, and reservation stations. This is because these data structures constains instructions from
both before the branch and after the branch -- we only want to flush the instructions that were
issued after the branch. In some instances, this can completely eliminate the misprediction penalty
of a branch instruction (e.g. when there is a long memory operation that needs to commit before the
branch).

In the latter case, the process of flushing is simpler since all instructions issued before the
branch have already been committed (since the branch is at the head of the ROB). Therefore, we can
simply flush the entire ROB, the entire load/store queue, and all reservation station(s).


Project Milestones
==================

MP4 is divided into several submissions to help you manage your progress. The dates for submissions
are provided in the class schedule. Late work will be based on the deadlines for each individual
milestone, with each part of a checkpoint submission evaluated separately. (For example, submitting
a paper design late will result in penalties for that paper design only.) Out-of-order checkpoints
have different requirements than in order checkpoints, but the deadlines are the same unless
specified by your TA.

Checkpoints
-----------

There will be four checkpoints to keep you on track for this MP. For each checkpoint, you will be
required to have implemented a certain amount of the functionality for your processor design. In
addition, at each checkpoint, you must meet, as a team, with your mentor TA and provide him or her
with the following information in writing:

- A brief report detailing progress made since the previous checkpoint. This should include what
  functionality you implemented and tested as well as how each member of the group contributed.
- A roadmap for what you will be implementing for the following checkpoint. The roadmap should
  include a breakdown of who will be responsible for what and paper designs for all design options
  that you are planning to implement for the next checkpoint.
  
Refer to the `Progress Report and Roadmaps`_ section for more details on writing these reports.

Besides helping the TAs check your progress on the MP, the checkpoints are an opportunity for you to
get answers to any questions that may have come up during the design process. You should use this
time to get clarifications or advice from your mentor TA.

Note that the checkpoint requirements outline the minimum amount of work that should have been
completed since the start of the project. You should work ahead where possible to have more time to
complete advanced design options.

Checkpoint 1: Initial Progress
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

By checkpoint 1, you should have at least one module (e.g. instruction queue, load/store queue,
reorder buffer, reservation station, etc.) completed and fully verified with a unit testbench. We
recommend starting with the instruction queue. **Your instruction queue must be parameterized!**

While you only need to submit one completed module, we recommend you start working on additional
modules if you have extra time. You should give yourself as much time as possible to debug your
processor before checkpoints 2 and 3.

Checkpoint 2: RV32I ISA and Basic OoO
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

By checkpoint 2, you should have a basic out-of-order machine that can handle all of the RV32I
instructions (with the exception of ``FENCE*``, ``ECALL``, ``EBREAK``, and ``CSRR`` instructions).
The test code will contain NOPs to allow the processor to work without branch prediction. For this
checkpoint you can use a dual-port "magic" memory that always sets ``mem_resp`` high immediately,
so that you do not have to handle cache misses or memory stalls.

By the end of this checkpoint, you must provide your mentor TA with paper designs for branch
prediction if not already present in the initial design, as well as a design for your arbiter to
interface your instruction and data cache with the CPU and main memory.

Checkpoint 3: L1 caches, arbiter and static branch prediction
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

By checkpoint 3, your CPU should be able to do static-not-taken branch prediction. This includes
adding logic to flush incorrect instructions on branch miss predictions.

You must also have an arbiter implemented and integrated, such that both split caches (I-Cache and
D-Cache) connect to the arbiter, which interfaces with memory. Since main memory only has a single
port, your arbiter determines the priority on which cache request will be served first in the case
when both caches miss and need to access memory on the same cycle.

For groups who do not have a fully functional cache available, we will be providing a small cache
for the purposes of this checkpoint. We encourage groups to use their own designs if available, on
this checkpoint or when moving forward to your advanced design features.

At this point, you do not need to provide your mentor TA with proposals for advanced features. Since
you are working on an out-of-order processor, you already have all 20 points of your advanced
feature design points, any extra advanced feature designs you choose to work on will be considered
extra credit (capped at a limit set by the TAs). However, you may still choose to submit a report
with advanced feature designs for your mentor TA to review. These may be as detailed as you deem
necessary -- anything from a written description to a hardware paper design. Your TA may have
feedback on implementation details or potential challenges, so the more detail you provide now, the
more helpful your TA can be.

Checkpoint 4: design competition
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

By checkpoint 4, you must have your final, optimized design ready for the competition. This means
that you should have a fully functional design that can run all provided test code and competition
code.

While implementing advanced features will help you earn extra design points, you should be designing
with performance in mind. In order to motivate performance-centric thinking, part of your CP4 grade
will be determined by your design's best execution time on the competition test codes we provide.
Your score in the competition will be based on your relative performance to other out-of-order
teams in the class. Scoring for out-of-order groups will not be on the same curve as in order
groups. Please consult your TA for details about the scoring of the competition as this may be
dependent on the number of out-of-order groups and the nature of your design. In order to be
eligible for these points, you should:

- Ensure that your code works correctly. **Designs which cannot 100% correctly execute the
  competition code will receive 0 points for the performance part.**
- You *may* use a separate design for advanced feature grading and for the competition (i.e., you do
  not have to be timed with you advanced features if they cause a performance hit on the
  competition codes).

Final Submission
~~~~~~~~~~~~~~~~

Checkpoint 4 marks the end of this MP. Your final submission should include all design,
verification, and testcode files used for your CP4 design. You can choose to demo your final
submission with your TA to receive extra credit for any advanced features and competition. If your
designs are different, this is where you may show the changes.

For the final demo, your design should have the CPU and any optional advanced features working
correctly. You should be able to demonstrate any advanced features that you expect to get extra
design points for, with your own test codes. You should also know how different feature affects the
performance of your machine (including design paramters, module sizes, advanced features, etc).

Presentation and Report
-----------------------

At the conclusion of the project, you will give a short presentation to the course staff (and fellow
students) about your design. In addition, you need to collect your checkpoint progress reports
and paper designs together as a final report that documents your accomplishments. **More information
about both the presentation and report will be released closer to the deadline.**


Grading
=======

MP4 will be graded out of 120 points, plus 18 points for extra credit. Out of the 120 + 18 points,
60 points are allocated for regularly meeting with your TA, for submitting paper designs of various
parts of your design, for a final presentation given to the course staff, and for documenting your
design with a final report. For each checkpoint, you must meet with your mentor TA in order to
showcase the functionality of your design and your verification methods. Implementation points will
NOT be given otherwise.

A breakdown of points for MP4 is given in `Table 1`_. Points are organized into two categories
across six submissions. Note that the number of points you can attain depends on what additional
advanced design options you wish to pursue.


.. _Table 1:


+--------------+-----------------------------------------+-----------------------------------------+
|              | Implementation [60+18]                  | Documentation [60]                      |
+==============+=========================================+=========================================+
| Design [7]   |                                         | - TA Meeting [2]                        |
|              |                                         | - Basic RV32I OoO design [5]            |
+--------------+-----------------------------------------+-----------------------------------------+
| CP 1 [14]    | - One module completed and verified [8] | - TA Meeting [2]                        |
|              |                                         | - Progress report [2]                   |
|              |                                         | - Roadmap [2]                           |
+--------------+-----------------------------------------+-----------------------------------------+
| CP 2 [19+3]  | - Basic OoO datapath [8]                | - TA Meeting [2]                        |
|              | - Competition code comp1.s runs [+1]    | - Progress report [2]                   |
|              | - Competition code comp2_i.s runs [+1]  | - Roadmap [2]                           |
|              | - Competition code comp3.s runs [+1]    | - Arbiter & branch predictor design [5] |
+--------------+-----------------------------------------+-----------------------------------------+
| CP 3 [38+15] | - Complete functional OoO datapath [20] | - TA Meeting [2]                        |
|              | - Integration of L1 caches [2]          | - Progress report [2]                   |
|              | - Arbiter [3]                           | - Roadmap [2]                           |
|              | - Static branch predictor [7]           |                                         |
|              | - Extra advanced design options [+15]   |                                         |
|              |                                         |                                         |
+--------------+-----------------------------------------+-----------------------------------------+
| CP 4 [42]    | - Design competition [12]               | - Presentation [10]                     |
|              |                                         | - Report [20]                           |
+--------------+-----------------------------------------+-----------------------------------------+


Table 1: MP4 point breakdown for OoO teams. Points for each item are enclosed in brackets. Point
numbers after "+" signs are extra credits.

The late penalty of this course will apply to work you submit late, so if you have something ready
by the deadline, be sure to show it to your TA.

Additionally, there will be a small penalty for having independently functional design units that
are not successfully integrated. If you can demonstrate to your TA that each item works on its own,
you will receive full credit for that unit. Rather than deducting all of the implementation points,
failure to integrate design units will result in a 30% penalty. You may recover half of the lost
points by demonstrating full integration at a later date.

Progress Report and Roadmaps
----------------------------

You are responsible for submitting a progress report and a roadmap for each checkpoint. While these
may not seem like many points, they are instrumental in helping you and your mentor TA track your
progress, and can help address any issues you may have before they blow up.

Your progress report should mention, at minimum, the following:

- who worked on each part of the design 

- the functionalities you implemented

- the testing strategy you used to verify these functionalities

You should be both implementing and verifying the design as you progress through the assignment. It
will also be useful for you to include an updated datapath with each progress report, as your
design will inevitably change as you complete the assignment. Making sure your datapath is
up-to-date will help both you and your mentor TA track changes in your design and identify possible
issues. Additionally, a complete datapath will be required in your final report. 

The roadmap should lay out the plan for the next checkpoint: 

- who is going to implement and verify each feature or functionality you must complete

- what are those features or functionalities

It is also useful to think through specific issues you may run into, and have a plan for resolving
the issues.

These are not intended to be very long. A single page (single-spaced) will be more than sufficient
for both the progress report and the roadmap. Be sure to check with your mentor TA, as they may
have other details to include on your progress report and roadmap.

Advanced Features
-----------------

Of the 60 implementation points, 28 will come from the implementation of the basic pipeline and
memory hierarchy. Up to 20 points will be given for the implementation of advanced design options.
Up to 12 points will come from your group's performance in the design contest. To receive any
points for the advanced design features, you must have numerical data which shows a change to your
design's performance as compared to not having implemented the feature. The best way to provide
this data is using performance counters. For each advanced design option, points will be awarded
based on the three criteria below:

- Design and implementation: Your group has a clear understanding of what is to be built and how to
  go about building it, and is able to produce a working implementation.

- Testing strategy: The design is thoroughly tested with test code and/or test benchmarks that you
  have written. Corner cases are considered and accounted for and you can prove that your design
  works as expected.

- Performance analysis: A summary of how the advanced design impacts the performance of your
  processor. Does it improve or degrade performance? How is the performance impact vary across
  different workloads? Why does the design improve or degrade performance?

A list of advanced design options along with their point values are provided in the `Advanced Design
Options`_ section.

Design Competition
------------------

The design competition will be scored based on two metrics of your processor design for each of the
test codes we provide. These metrics are energy and delay. A design with lower energy consumption
and better performance will get your team ranked higher.  

For each test code, your processor will be assigned a score calculated as ``PD² * (100/Fmax)²``, or
``energy * (delay * 100/Fmax)²`` [#]_. The power used by your design is acquired through Quartus
using an activity factor generated by Modelsim. The factor of 100/Fmax is used to adjust the
simulation time based on your processor's maximum speed. Your final benchmark score will be the
geometric mean of your score on each test code.

To get full credit, you must exceed the baseline set by the TAs (announced at a later date). If you
are unable to exceed the baseline, and have proper justification for why, the majority of points
can still be earned. Because of the variability of out-of-order designs, it is up to you to
determine why your design may be functionally correct, and sufficiently complex, but less perfomant
than a simple in order design. You may earn makeup points (up to 10) based on your better
performance on these two scales:`

- The first scale is a straight linear scale ranking all of the teams in the design competition.
  First place will receive full points, and non-functional designs will receive no points.
- The second scale is a linear scale between the score of the best performing design and a baseline
  MP4 CP3 design. The best score will receive full points, and the baseline design will receive no
  points.
- Your grade will be determined by the higher of these two scales. This ensures that very high
  performing designs in a competitive class are not penalized unfairly.

.. [#] The exact formula may be changed for out-of-order groups depending on numbers.


Group Evaluations
-----------------

At the end of the project, each group member will submit feedback on how well the group worked
together and how each member contributed to the project. The evaluation, along with feedback
provided at TA meetings throughout the semester, will be used to judge individual contribution to
the project. Up to 30 points may be deducted from a group member's score if it is evident that he
or she did not contribute to the project.

Although the group evaluation occurs at the end of the project, this should *not* be the first time
your mentor TA hears about problems that might be occurring. If there are major problems with
collaboration, the problems should be reflected in your TA meetings and progress reports. The
responses on the group evaluation should not come as a surprise to anyone.


Design Guidelines
=================

Basic Design
------------

You must complete an out-of-order pipelined RV32I design which consists of the following:

- **Datapath**

  - Out-of-order machine which implements the full RV32I ISA (less excluded instructions) [8]
  - Static branch prediction [7]

- **Cache**

  - Integration of instruction and data caches [2]
  - Arbiter [3]

Advanced Design Options
-----------------------

The following sections describe some common advanced design options. Each design option is assigned
a point value (listed in brackets). Also note that based on design effort, your mentor TA can
decide to take off or add points to a design option. To obtain full points for a design option, you
must satisfy all the requirements given in the `Advanced Features`_ grading section. If you would
like to add a feature to this list, you may work with your mentor TA to assign it a point value.

- `Cache organization and design options`_

  - `L2+ cache system`_ [2] (Additional points up to TA discretion)
  - `4-way set associative cache`_ [2] (8+ way will be worth more points; up to TA discretion)
  - `Parameterized cache`_ [points up to TA discretion]
  - Alternative replacement policies [points up to TA discretion] [#]_

- `Advanced cache options`_ 

  - `Eviction write buffer`_ [4]
  - `Victim cache`_ [6]
  - `Pipelined L1 caches`_ [6]
  - `Non-blocking L1 cache`_ [8]
  - `Banked L1 or L2 cache`_ [5]

- `Branch prediction options`_ 

  - `Local branch history table`_ [2]
  - `Global 2-level branch history table`_ [3]
  - `Tournament branch predictor`_ [5]
  - LTAGE branch predictor [8]
  - Alternative branch predictor [points up to TA discretion] [#]_
  - `Software branch predictor model`_ [2]
  - Branch target buffer, support for jumps [1]
  - 4-way set associative or higher BTB [3]
  - `Return address stack`_ [2]

- `Prefetch design options`_

  - `Basic hardware prefetching`_ [4]
  - `Advanced hardware prefetching`_ [6]

- `Difficult design options`_ 

  - `RISC-V M Extension`_: A basic multiplier design is worth [3] while an
    advanced muliplier is worth [5]
  - `RISC-V C Extension`_ [8]

- `Superscalar design options`_ 

  - `Multiple issue`_ [15]

.. [#] For example, `<http://old.gem5.org/Replacement_policy.html>`_
.. [#] For example, Bi-Mode, TAGE, and Neural Branch Predictor

----

.. _Cache organization and design options:

**Cache organization and design options**

.. _L2+ cache system:

- **L2+ cache system**

  Your L1 cache system is constrained to respond within 1 cycle on a hit in order to facilitate your
  pipeline (unless you implement `Pipelined L1 caches`_). Therefore, your L1 caches cannot be too
  large without forming a large critical path, affecting your Fmax. This can be alleviated by
  adding additional levels of caches, which may respond in more than one cycle. Having additional
  caches can greatly speed up your design by keeping your Fmax high while also mitigating the
  affects of memory stalling.

  More complicated cache systems will be eligible for more advanced design feature points, feel free
  to discuss your ideas/solutions with your mentor TA. 

.. _4-way set associative cache:

- **4-way set associative cache**

  If 2-way in your caches is not enough, you can choose to implement a 4-way set associative cache
  for any of your caches. The baseline is the pseudo-LRU replacement policy discussed in lectures.
  You may choose to implement additional ways (8+) as well as any other replacement policy, both of
  which will be eligible for additional points based on TA discretion.
  
.. _Parameterized cache:

- **Parameterized cache**:

  Instead of having statically sized caches, you can parameterize your cache to be able to use the
  same cache module in different parts of your design. You can parameterize the size and the number
  of sets, or also the number of ways or how many cycles it responds in. This feature will be
  largely dependent on how much effort you take and how many factors are parameterized and will be
  up to TA discretion.

.. _Advanced cache options:

**Advanced Cache Options**

.. _Eviction write buffer:

- **Eviction Write Buffer**

  On a dirty block eviction, a cache will normally need to first write the block to the next cache
  level, then fetch the missed address. An eviction write buffer is meant to hold dirty evicted
  blocks between cache levels and allow the subsequent missed address be processed first, and when
  the next level is free, proceed to write back the evicted block. This allows the CPU to receive
  the missed data faster, instead of waiting for the dirty block to be written first.

  The slightly more difficult version is a victim cache, which holds both dirty and clean evictions
  (detailed below).

.. _Victim cache:

- **Victim Cache**

  This is a version of the eviction write buffer on steroids. The buffer is expanded to be fully
  associative with multiple entries (typically 8-16), it is filled with data even on clean
  evictions, and is not necessarily written back to DRAM immediately. This enables a direct-mapped
  cache to appear to have higher associativity by using the victim buffer only when conflict misses
  occur. This is only recommended for groups who love cache.

.. _Pipelined L1 caches:

- **Pipelined L1 Caches**

  Switching the two cycle hit caches from MP3 to a single cycle hit for MP4 can create a long
  critical path and may affect your ability to meet timing. In addition, doing so precludes the
  use of BRAM for your L1 caches. As opposed to switching to a single cycle hit, you may retain
  the two cycle hits and have your caches process two requests at once. Your caches will recieve
  a request in the first stage, and respond with the data in the second stage. While responding,
  your cache should be able to process a new request in the first stage. This option must not
  stall your pipeline on a hit, but may stall the pipeline on a miss.

.. _Non-blocking L1 cache:

- **Non-Blocking L1 Cache**

  While a blocking cache serve a miss, no other cache accesses can be served, even if there is
  a hit. A non-blocking cache instead has the ability to queue misses in MSHRs (miss status holding
  registers) while continuing to serve hits. To make this ability useful, the
  processor must be able to support either out-of-order execution or memory-stage leapfrogging.

.. _Banked L1 or L2 cache:

- **Banked L1 or L2 Cache**

  A banked cache further divides each cache way into banks, which hold separate chunks of addresses.
  Each bank can be accessed in parallel, so that multiple memory accesses can begin services at once
  if there is no "bank conflict"; that is, each request is directed to a different bank. This option
  is useful for L1 for groups with a multiple-issue processor, and for L2 in the case of having both
  an i-cache and d-cache miss.


.. _Branch prediction options:

**Branch Prediction Options**

All branch prediction options require an accuracy of 80% or higher on all test codes. If you fail
to achieve this accuracy, you will not get any points for the branch predictor. On the off chance
the TAs release a competition code which performs poorly using a branch predictor, this requirement
may be waived for that test code by the TAs.

.. _Local branch history table:

- **Local Branch History Table**

  This is conceptually the simplest dynamic branch prediction scheme. It contains
  a table of 2-bit predictors indexed by a combination of the PC values and the history of
  conditional branches at those PC values.

.. _Global 2-level branch history table:

- **Global 2-Level Branch History Table**

  A global branch history register records the outcomes of the last N branches, which it then
  combines with (some bits of) the PC to form a history table index. From there, it works the same
  as the local BHT. By recording the past few branches, this scheme is able to to take advantage of
  correlations between branches in order to boost the prediction accuracy.

.. _Tournament branch predictor:

- **Tournament Branch Predictor**

  A tournament branch predictor chooses between two different branch prediction schemes based on
  which is more likely to be correct. You must maintain two different branch predictors (e.g., both
  a local and a global predictor), and then add the tournament predictor to select between which of
  the two is the best predictor to use for a branch. This predictor should use the two bit counter
  method to make its selection, and should update on a per-branch basis.

.. _Software branch predictor model:

- **Software Branch Predictor Model**

  To evaluate whether your branch predictor is performing as expected, you need to know its
  expectation. To accomplish that, you can create a systemverilog model of your core and branch
  predictor. This model comes with the added benefit of helping you verify the rest of your core as
  well. Your branch predictor's accuracy must match the model's accuracy for points. If you do not
  implement a dynamic branch prediction model, this option is only worth a single point.

.. _Return address stack:

- **Return Address Stack**

  A return address stack leverages the calling convention to better predict the target of a jump.
  Refer to the RISC-V specification document for a description of the return address stack hints.
  Intuitively, ``PC+4`` should be pushed onto the stack when it looks like there is a call
  instruction, and an instruction that looks like a function return should pop the (predicted)
  return address off of the stack. This improves the BTB, since a BTB would give false predictions
  for a return instruction whenever the function is called from a different call site.


.. _Prefetch design options:

**Prefetch Design Options**

Prefetching is a technique that helps us avoid cache misses. Rather than waiting for a cache miss to
perform a memory fetch, prefetching anticipates such misses and issues a fetch to the memory system
in advance of the actual memory reference. This prefetch proceeds in parallel with normal
instructions' execution, allowing the memory system to transfer the desired data to cache. Here are
several options of implementing prefetching.

.. _Basic hardware prefetching:

- **Basic Hardware Prefetching**

  One block lookahead (OBL) prefetch, one of the sequential prefetching scheme that takes advantage
  of spatial locality. It is easy to implement. This approach initiates a prefetch for line ``i+1``
  whenever line ``i`` is accessed and results in a cache miss. If ``i+1`` is already cached, no
  memory access is initiated.

.. _Advanced hardware prefetching:

- **Advanced Hardware Prefetching**

  PC based strided prefetching. This prefetching scheme is based on following idea:

  - Record the distance between the memory addresses referenced by a load instruction (i.e., stride
    of the load) as well as the last address referenced by the load.
  - Next time the same load instruction is fetched, prefetch last address + stride.

  For more detail, refer to Baer and Chen, "An effective on-chip preloading scheme to reduce data
  access penalty," SC 1991.


.. _Difficult design options:

**Difficult Design Options**

.. _RISC-V M Extension:

- **RISC-V M Extension**

  The RISC-V M extension specifies integer multiplication and division instructions.[#]_ The
  standard competition codes call library functions which emulate integer multiplication and
  division, since RV32I does not support these instructions. You will be provided with an alternate
  version of the competition code compiled for RV32IM which will leverage your hardware
  implementations of these operations. You are not allowed to simply use the SystemVerilog
  operators, you must implement these operations explicitly in logic, exploring the trade-off
  between frequency and cycles. You are not allowed to use IPs for this but you may use IPs for
  other aspects of your design with the permission of your mentor TA. You must come up with your
  own tests to convince your mentor TA that you have adequately tested each of the instructions in
  this extension, since the compiled competition codes would not exercise each instruction
  thoroughly.

  If you use the add-shift multiplier from MP1, or a similarly "simple" to implement multiplier, you
  will not recieve full credit for the M extension and will only get [3] points. Implementing a
  more advanced multiplier (like a Wallace Tree) will earn [5] points. The final determination of
  what is "simple" will be made by your mentor TA, so work with them in advance to fully understand
  how many advanced feature points your design is eligible for.

.. _RISC-V C Extension:

- **RISC-V C Extension**

  The RISC-V C extension specifies compressed 16-bit instruction formats for many common instruction
  occurrences. [#]_ Note that many of the instruction formats specified are for extensions that we
  are not using, so they can be ignored. As with the M extension, we will provide alternate
  versions of the competition codes compiled for RV32IC and RV32IMC, and you must provide your own
  test codes which adequately demonstrate the functionality of each instruction format specified in
  this extension.


.. _Superscalar design options:

**Superscalar Design Options**

.. _Multiple issue:

- **Multiple issue**

  A multiple issue processor is capable of dispatching and committing multiple instructions in a
  single cycle. 


  This requires modifications to several major structures in your pipeline. First, you must be
  capable of fetching multiple instructions from your i-cache in a single cycle. You also must
  expand your register file ports to accommodate operand fetching and simultaneous writes. Your
  forwarding and hazard detection logic need to detect dependencies between in-flight instructions
  in the same as well as different pipeline stages. In order to obtain the most performance
  improvement for this option, you can implement it in conjunction with banked caches.

.. [#] M Extension Spec: `<https://content.riscv.org/wp-content/uploads/2017/05/riscv-spec-v2.2.pdf#page=47>`_
.. [#] C Extension Spec: `<https://content.riscv.org/wp-content/uploads/2017/05/riscv-spec-v2.2.pdf#page=79>`_


Design Considerations
=====================

One of the challenges in designing an OoO processor is fitting your design to the constraints of the
hardware. For example, the common data bus (CDB) connects multiple components together and can
easily create a long critical path if not carefully implemented. While we did not have you
synthesize your MP3 designs, you should be able to fully synthesisze your MP4 CPU implementation.
It is important to keep an eye on your FMAX and resource usage throughout the design process, since
trying to meet timing and resource constraints the night before the final checkpoint deadline is
never fun.

Some helpful tips when implementing your processor in SystemVerilog:

- Use efficient structures. For structures like your instruction queue, load/store queue, and
  reorder buffer, use circular queues instead of a chained FIFO shift register structure. This
  ensures that you are not shifting data around unnecessarily, which will help your processor save
  a bit of power.

- Know what operators to avoid. In particular, operations like ``/`` (division) and ``%`` (mod) can
  be very expensive when synthesized into hardware. Frequently using these operators can cause
  large amounts of combinational logic that create a long critical path. Instead, try using the
  natural properties of binary numbers. For example, instead of having a queue of size 7 and
  needing to ``index % 7``, use a power-of-two to take advantage of the automatic modulo property
  as binary numbers overflow.

- Choose your data representations wisely. You may find that the Tomasulo Algorithm described in
  lecture or the textbooks is not the most efficient implementation. For example, using a 1-indexed
  ROB tag with ``0`` being a special "not present" flag value can mean needing to perform addition
  and/or subtraction in multiple places when working with these tags. Depending on your design, it
  may be more efficient to have a separate ``valid`` bit instead of trying to incorporate such
  metadata into the tag itself.

- Parameterize your design. It might take a little longer, but having parameters to define critical
  parts of your design is essential during the competition optimization process. For example, it's
  a good idea to have a central location where you can define parameters such as the number of
  entries in your instruction queue, the number of execution units present, the number of ROB
  entries, etc. You will find that changing a single number is much easier and less error-prone
  than trying to change a dozen different logic signals and constants.

- Use interfaces and modports. When you have a group of signals that needs to be passed between
  various modules, its a good idea to use an interface with modports to keep your design clean.
  Examples of good places to use interfaces are memory signals (``mem_addr``, ``mem_rdata``,
  ``mem_wdata``, ``mem_read``, ``mem_write``, ``mem_byte_enable`` ...) or the signals coming from
  your instruction decode.

- Unit test your design. Because of the complexity of an OoO processor, you'll have more modules to
  complete before you have the chance to start running testcode. It's crucial to unit test your
  modules as you make them, or else trying to debug the entire processor at once will be a lot more
  difficult than debugging individual modules.


FAQs
====

- **Can we use state machines for our MP4 design?**

  Only in the cache hierarchy and advanced features, nowhere else. A non-pipelined cache or
  multicycle functional unit (i.e., multiplier) may use a state machine as its controller.


Advice from Past Students
=========================

- On starting early:

  - "Start early. Have everything that you have implemented also in a diagram, updating while you
     go."
  - "START EARLY. take the design submission for next checkpoint during TA meetings seriously. it
     will save you a lot of time. Front-load your advanced design work or sufferrrrr"
  - "start early and ask your TA for help.""
  - "Finish 3 days before it's due. You will need those 3 days (at least) to debug, which should
     involve the creation and execution of your own tests!"
  - "Make the work you do in the early checkpoints bulletproof and it will make your life WAY easier
     in the later stages of MP3."
  - Don't let a passed checkpoint stop you from working ahead. The checkpoints aren't exactly a
    perfect balance of work.
  - (In an end-of-semester survey, most students responded that they spent 10-20 hours per week
    working on ECE 411 assignments.)

- Implementation tips:

  - "Don't trust the TA provided hazard test code, just because it works doesn't mean your code can
     handle all data and control hazards."
  - "Also, it was very good to test the cache interface with the MP 2 cache, and test the bigger
     cache you do (L2 cache, more ways, 8-way pseudo LRU) on the MP 2 datapath. This just makes it
     easier to stay out of each other's hair."
  - "Run timing analyses along the way so you're not trying to meet the 100 MHz requirement on the
     last night."
  - "Write your own test code for every case. Check for regressions."
  - "Don't pass the control bits down the pipeline separately, pass the *entire* control word down
     the pipeline. Also, pass the opcode and PC down. These are essential when debugging."
  - "Check your sensitivity lists!!"
  - "Hook up the debug utilities, shadow memory and RVFI monitor, early. It helps so much later."
  - "RISC-V MONITOR please start using it at CHECKPOINT 1!"  (TA note: we suggest using RVFI Monitor
     beginning with CP3.)
  - "Performance counters might seem unnecessary at first, but they totally saved our competition
     score. Make a lot of them, and use them!!"

- Possible difficulties:

  - "Implement forwarding from the start, half of our bugs were in this. Take the paper design
     seriously, we eliminated a lot of bugs before we started."
  - "Integration is by far the most difficult part of this MP. Just because components work on their
     own does not mean they will work together.''
  - "The hard part about mp3 is 1) integrating components of your design together and 2) edge cases.
     Really try to think of all edge cases/bugs before you starting coding. Also, be patient when
     debugging."
  - "You might think it makes sense to gate the clock in certain circumstances. You are almost
     certainly wrong. Don't gate the clock."
  - "The TAs might seem nice, but they don't give you very good testcode. Make sure to write your
     own."

- On teamwork:

  - "Try to split up the work into areas you like -- cache vs datapath, etc. You will be in the lab
     a lot, so you might as well be doing a part of the project you enjoy more than other parts"
  - "Don't get overwhelmed, it is a lot of work but not as much as it seems actually. As long as you
     start at least a paper design ASAP, you should finish each checkpoint with no problems."
  - "Come up with a naming convention and *stick to it*. Don't just name signals ``opcode1``,
     ``opcode2``, etc. For example, prepend every signal for a specific stage with a tag to specify
     where that signal originates from (``EX_Opcode``, ``MEM\_Opcode``)."
  - "Label all your components and signals as specific as possible, your team will thank you and you
     will thank yourself when you move into the debugging stages!"
  - "Learn how to use Github well! It is very difficult to get through MP3 without this knowledge."
  - "If you put in the work, you'll get results. All the tools you need for debugging are at your
     disposal, nothing is impossible to figure out."
  - "Split up the work and plan out which parts everyone will work on each checkpoint. You can
     always help each other out, but make sure you know who is responsible for each part."
  - "You need to be able to read each other's code. Agree on a style head of time, and don't rely on
     others all the time. Not being able to read code makes debugging unnecessarily difficult."
