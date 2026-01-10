# Kafka

## 1️⃣ Why Kafka exists (problem it solves)

### Traditional backend problem

Imagine:

* User places an order
* You need to:

  * Save order
  * Send email
  * Send SMS
  * Update inventory
  * Update analytics
  * Notify delivery service

### Without Kafka (tight coupling)

```
Order Service → Email Service
             → SMS Service
             → Inventory Service
             → Analytics Service
```

❌ Problems:

* If **any service is down**, order fails
* Hard to scale
* High latency
* Tight coupling
* Difficult retries

---

### With Kafka (event-driven)

```
Order Service → Kafka → Email Service
                        SMS Service
                        Inventory Service
                        Analytics Service
```

✅ Benefits:

* Loose coupling
* High throughput
* Fault tolerance
* Async processing
* Easy to add new consumers

👉 **Kafka is a distributed event streaming platform**

---

## 2️⃣ What Kafka actually is 

> Kafka is a **distributed commit log** that stores events in order and lets multiple systems read them independently.

Key words:

* **Distributed**
* **Persistent**
* **Ordered**
* **Scalable**
* **Fault-tolerant**

---

## 3️⃣ Core Kafka components 

### 1. Producer

* Sends messages (events) to Kafka
* Example: Order Service

### 2. Consumer

* Reads messages from Kafka
* Example: Email Service

### 3. Topic

* Logical stream of messages
* Example:

  * `order_created`
  * `payment_completed`

Think of **topic = table**, messages = rows

---

### 4. Partition (most important concept)

Each topic is split into **partitions**.

```
Topic: order_created
Partition 0 → msg1 → msg2 → msg3
Partition 1 → msg4 → msg5
Partition 2 → msg6
```

Why partitions?

* Parallelism
* Scalability
* High throughput

👉 **Order is guaranteed only within a partition**

---

### 5. Broker

* A Kafka server
* Stores partitions

Cluster example:

```
Broker 1 → Partition 0
Broker 2 → Partition 1
Broker 3 → Partition 2
```

---

### 6. Offset

* Each message has an offset (like index)

```
Partition 0:
offset 0 → msg
offset 1 → msg
offset 2 → msg
```

Consumers track offsets to know **where they left off**

---

## 4️⃣ Consumer Groups (INTERVIEW FAVORITE)

### What is a consumer group?

* A group of consumers sharing load

Rules:

* **One partition → one consumer in a group**
* Multiple groups can read the same topic independently

```
Topic: order_created (3 partitions)

Consumer Group A:
  C1 → P0
  C2 → P1
  C3 → P2

Consumer Group B:
  C4 → P0
  C5 → P1
  C6 → P2
```

👉 Used for:

* Horizontal scaling
* Independent services

---

## 5️⃣ Message delivery semantics

Kafka supports:

### 1. At-most-once

* No retry
* Fast
* Possible data loss

### 2. At-least-once (most common)

* Retry on failure
* Possible duplicates

### 3. Exactly-once (advanced)

* No loss
* No duplicates
* Needs idempotent producers + transactions

👉 Interview answer:

> Kafka guarantees **at-least-once by default**

---

## 6️⃣ Kafka storage model 

### Kafka writes are:

* **Append-only**
* Sequential disk writes

Disk structure:

```
log-0
log-1
log-2
```

Why fast?

* No random writes
* OS page cache
* Zero-copy (sendfile)

👉 Kafka is disk-based but still extremely fast

---

## 7️⃣ Retention & durability

Kafka does **not delete messages after consumption**

Retention policies:

* Time-based (e.g., 7 days)
* Size-based (e.g., 100GB)

Meaning:

* You can replay events
* New consumers can read old data

---

## 8️⃣ Replication & fault tolerance

Each partition has:

* Leader
* Followers

```
Partition 0:
Leader → Broker 1
Follower → Broker 2
Follower → Broker 3
```

If leader dies:

* Follower becomes leader
* No data loss (if replication factor ≥ 2)

---

## 9️⃣ ZooKeeper vs KRaft (important)

### Old Kafka

* Used ZooKeeper for:

  * Metadata
  * Leader election

### New Kafka (modern)

* Uses **KRaft mode**
* No ZooKeeper dependency

👉 Interview:

> Kafka is moving away from ZooKeeper to KRaft for simplicity and performance

---

## 🔟 Kafka vs traditional message queues

| Feature         | Kafka           | RabbitMQ    |
| --------------- | --------------- | ----------- |
| Throughput      | Very high       | Medium      |
| Persistence     | Yes             | Optional    |
| Replay messages | Yes             | No          |
| Ordering        | Per partition   | Per queue   |
| Use case        | Event streaming | Task queues |

---

## 1️⃣1️⃣ Real-world Kafka use cases (MAANG level)

* Order events
* Payment pipelines
* Clickstream analytics
* Log aggregation
* CDC (Change Data Capture)
* Real-time dashboards
* Microservice communication

Amazon / Netflix / Uber:

* Kafka for **event backbone**
* Services don’t talk directly

---

## 1️⃣2️⃣ Kafka in microservices architecture

```
Service A → Kafka Topic → Service B
                         Service C
                         Service D
```

Benefits:

* Services deployed independently
* Failure isolation
* Async processing

---

## 1️⃣3️⃣ Common interview questions 

### Q1. Why Kafka is fast?

* Sequential disk writes
* Zero-copy
* Partitioning
* Batch processing

### Q2. Ordering guarantee?

* Only within a partition

### Q3. What happens if consumer crashes?

* Offset not committed
* Another consumer resumes

### Q4. Difference between Kafka and SQS?

* Kafka = streaming + replay
* SQS = queue, message removed after consume

### Q5. Can Kafka replace database?

❌ No
Kafka is **not for querying**, it’s for streaming

---

## 1️⃣ Fix the mental model (MongoDB → Kafka mapping)

Think like this:

| MongoDB          | Kafka           |
| ---------------- | --------------- |
| Database         | Kafka Cluster   |
| Collection       | Topic           |
| Document         | Event / Message |
| Insert document  | Produce event   |
| Find / Read      | Consume event   |
| Index            | Partition       |
| Cursor position  | Offset          |
| Multiple readers | Consumer Group  |

👉 **Key difference**:
MongoDB = *pull data when needed*
Kafka = *events are pushed continuously & replayable*

---

## 2️⃣ Where does Kafka actually live?

Kafka is **not a library inside your app**.

Kafka is:

* A **separate distributed system**
* Runs as **Kafka brokers** (processes)
* Stores data on **disk**, not memory

Typical setup:

```
Kafka Cluster
 ├── Broker 1
 ├── Broker 2
 └── Broker 3
```

Each broker:

* Runs on a machine / VM / container
* Stores **topic partitions as files on disk**

---

## 3️⃣ What is a Topic REALLY?

A **topic** is just a **named log**.

Example:

```
Topic: user-signup
```

Internally:

```
user-signup
 ├── Partition 0  (file on disk)
 ├── Partition 1  (file on disk)
 └── Partition 2  (file on disk)
```

Each partition is:

* **Append-only**
* Stored as **segment files on disk**
* Ordered **only within that partition**

👉 **Events are NEVER updated or deleted**
(only expired via retention policy)

---

## 4️⃣ Where are events stored?

**On Kafka broker disks**

Example:

```
/var/lib/kafka/
 └── user-signup-0/
      ├── 000000000000000.log
      ├── 000000000000123.log
      └── ...
```

Each `.log` file contains:

```
[offset][timestamp][key][value]
```

So:

* Kafka is basically a **distributed commit log**
* Not a queue that “removes” messages after consumption

---

## 5️⃣ Who creates WHAT and WHERE?

### ✅ Topic creation

Topics are created:

* **Once**
* By **infra / DevOps / platform team**
* Or automatically (bad practice in prod)

Ways to create topic:

```
kafka-topics.sh --create ...
```

or

```
Admin API
```

You **do NOT create topics inside business logic** usually.

---

### ✅ Partitions

Partitions are:

* Decided **at topic creation time**
* Define **parallelism**
* Define **ordering guarantee**

Rule:

```
More partitions = more parallel consumers
```

You don’t dynamically create partitions per event.

---

### ❌ Partition group

There is **NO such thing** as a "partition group".

You probably mean:

* **Consumer Group**

---

## 6️⃣ What is a Consumer Group (very important)

A **consumer group** is:

* A **logical name**
* Used to coordinate multiple consumers

Example:

```
Consumer Group: email-service
```

Rules:

1. One partition → **only ONE consumer in a group**
2. Multiple groups can read same topic independently

```
Topic: user-signup (3 partitions)

Group: email-service
 ├── Consumer A → Partition 0
 ├── Consumer B → Partition 1
 └── Consumer C → Partition 2

Group: analytics-service
 ├── Consumer X → Partition 0
 ├── Consumer Y → Partition 1
 └── Consumer Z → Partition 2
```

👉 Each group gets **its own offset tracking**

---

## 7️⃣ Where are offsets stored?

Offsets are stored:

* **Inside Kafka itself**
* In a special topic:

```
__consumer_offsets
```

So Kafka tracks:

```
(group, topic, partition) → last_committed_offset
```

This is why consumers can:

* Crash
* Restart
* Resume from exact position

---

## 8️⃣ Producer flow (step-by-step)

When a service produces an event:

```
Service
  |
  | 1. Serialize event
  | 2. Choose topic
  | 3. Choose partition (key-based or round-robin)
  |
Kafka Broker
  |
  | 4. Append to partition file
  | 5. Replicate to other brokers
```

Important:

* Producer **does NOT know consumers**
* Producer **only cares about topic**

---

## 9️⃣ Consumer flow (step-by-step)

When a service consumes:

```
Consumer
  |
  | 1. Join consumer group
  | 2. Kafka assigns partitions
  | 3. Consumer polls data
  | 4. Processes event
  | 5. Commits offset
```

👉 Kafka never “pushes” messages
Consumers **pull** via polling

---

## 🔟 Compare again with MongoDB (clear picture)

### MongoDB

```
Service A → insert into collection
Service B → query collection
Data may be deleted/updated
```

### Kafka

```
Service A → append event to topic
Service B → reads event stream
Service C → reads same stream independently
Data is immutable
```

Kafka = **event log**
MongoDB = **state store**

---

## 1️⃣1️⃣ When should YOU create what?

### As an application developer:

You usually:

* Produce to existing topics
* Consume from existing topics
* Define consumer group name

### Infra / Platform team:

* Create topics
* Decide partitions
* Set retention, replication

---

## 1️⃣2️⃣ One sentence that fixes everything

> **Kafka stores events as immutable, append-only logs on disk, partitioned for parallelism, and consumer groups independently track how much of the log they have read.**

---

# 1️⃣ What exactly is a **Kafka Broker**?

> **A broker is just a Kafka server process running on a machine.**

More concretely:

* A **broker = JVM process**
* Runs Kafka code
* Has **disk**
* Listens on a port (like `9092`)
* Stores topic **partitions as files**

Example:

```
Kafka Cluster
 ├── Broker 1 (machine A)
 ├── Broker 2 (machine B)
 └── Broker 3 (machine C)
```

Each broker:

* Stores **some partitions**
* Handles **produce & consume requests**
* Replicates data to other brokers

👉 Broker ≠ topic
👉 Broker ≠ consumer
👉 Broker ≠ service

---


> “We have Kafka cluster → inside that we have topics → inside topics we have events”

Now we just **insert two missing layers**:

```
Kafka Cluster
 ├── Broker 1
 ├── Broker 2
 └── Broker 3

Topic: order-created
 ├── Partition 0
 ├── Partition 1
 └── Partition 2

Partition
 └── Events (ordered, immutable)
```

---

# 3️⃣ Where do **partitions** fit in?

Partitions solve **2 problems**:

1. **Scalability**
2. **Parallel consumption**

### Without partitions:

* Only one consumer can read at a time
* Throughput is limited

### With partitions:

* Each partition can be processed independently

Think of a topic as:

> **A folder, partitions are files inside it**

---

## Real analogy

```
Topic = Book
Partitions = Chapters
Events = Pages
Offsets = Page numbers
```

---

# 4️⃣ What is an **offset**?

Offset is:

> **The position of an event inside a partition**

Example:

```
Partition 0:
offset 0 → event A
offset 1 → event B
offset 2 → event C
```

Important:

* Offsets are **per-partition**
* Offset is **never reused**
* Offset ≠ global across topic

So:

```
Topic has no offset
Partition has offsets
```

---
## What a consumer group REALLY is

> **A consumer group is NOT a group of services.
> It is a group of CONSUMER INSTANCES reading together.**

Key rules:

1. Consumer group = **string name**
2. Consumers with same group → **cooperate**
3. Each partition → **only one consumer per group**

---

## Example with your 8 services and 5 topics

Assume:

* 8 microservices
* Each service can consume multiple topics
* Each service instance can join multiple consumer groups

### YES — a service CAN belong to multiple consumer groups

But **not automatically** — it depends on code.

Example inside one service:

```js
consumerA → group = email-service
consumerB → group = analytics-service
```

Same service, two different groups.

---

# 6️⃣ Consumer group ≠ AWS IAM group (important difference)

AWS group:

* Permission grouping
* Static
* Security-based

Kafka consumer group:

* **Load balancing mechanism**
* Runtime coordination
* Offset tracking

So:
❌ Not permission based
❌ Not organizational
✅ Processing-based

---

# 7️⃣ Visualize consumer groups correctly

### Topic: `user-created` (3 partitions)

```
Partition 0
Partition 1
Partition 2
```

### Group: `email-service`

```
EmailConsumer-1 → Partition 0
EmailConsumer-2 → Partition 1
EmailConsumer-3 → Partition 2
```

### Group: `fraud-service`

```
FraudConsumer-1 → Partition 0
FraudConsumer-2 → Partition 1
FraudConsumer-3 → Partition 2
```

Same data
Different offsets
Independent processing

---

# 8️⃣ Who owns offsets?

Offsets belong to:

```
(consumer group + topic + partition)
```

Stored in Kafka:

```
__consumer_offsets topic
```

So Kafka knows:

```
email-service, user-created, partition 1 → offset 42
```

---

# 9️⃣ Where partitions live physically?

Partitions are **distributed across brokers**.

Example:

```
Broker 1 → user-created-0
Broker 2 → user-created-1
Broker 3 → user-created-2
```

Plus replicas for fault tolerance.

So:

* Topic is logical
* Partition is physical
* Broker stores partitions

---

# 🔟 Final correct mental model (lock this)

```
Kafka Cluster
 ├── Brokers (machines/processes)
 │    └── Store partitions (files on disk)
 │
 └── Topics
      └── Partitions
           └── Events (with offsets)

Producers → append to partitions
Consumers → read partitions via consumer groups
Offsets → track progress per group
```

---

# 1️⃣1️⃣ One line that should click now

> **Topics organize events, partitions scale them, brokers store them, consumer groups process them, and offsets remember progress.**


# ✅ First, confirm brokers 

> **Broker = running Kafka server process (instance) inside the cluster**

Now forget brokers for a moment.
Let’s focus only on **topic → partitions → consumer groups**.

---

# 1️⃣ What is a PARTITION 

> **A partition is just a numbered bucket inside a topic.**

Topic:

```
orders
```

With 3 partitions:

```
orders
 ├── bucket-0
 ├── bucket-1
 └── bucket-2
```

Each bucket:

* Stores events **in order**
* Events are added **only at the end**
* Nothing is removed when read

---

## Why partitions exist (simple reason)

Without partitions:

* Only **1 consumer** can read at a time

With partitions:

* **Multiple consumers** can read **in parallel**

👉 **Partitions = parallelism + scalability**

---

# 2️⃣ What exactly is stored inside a partition?

Inside ONE partition:

```
offset 0 → event A
offset 1 → event B
offset 2 → event C
offset 3 → event D
```

Key rules:

* Offset starts from 0
* Offset increases forever
* Offset is **local to that partition**
* Order is guaranteed **only inside a partition**

---

# 3️⃣ What is a CONSUMER GROUP (ultra-simple)

> **A consumer group is a team of consumers that SHARE the work.**

They read:

* Same topic
* Same partitions
* But **split the partitions among themselves**

---

## Simple rule (MOST IMPORTANT)

> **Inside one consumer group, one partition can be read by ONLY ONE consumer.**

That’s it.
Everything else comes from this rule.

---

# 4️⃣ Example (no jargon yet)

### Topic: `orders`

### Partitions: 3

```
Partition 0
Partition 1
Partition 2
```

### Consumer group: `payment-service`

Case 1️⃣ — 1 consumer:

```
Consumer A → P0, P1, P2
```

Case 2️⃣ — 3 consumers:

```
Consumer A → P0
Consumer B → P1
Consumer C → P2
```

Case 3️⃣ — 5 consumers:

```
Consumer A → P0
Consumer B → P1
Consumer C → P2
Consumer D → idle
Consumer E → idle
```

👉 Consumers > partitions = **idle consumers**

---

# 5️⃣ Why consumer groups exist (simple)

Consumer groups exist to answer **one question**:

> “Do we want multiple consumers to SHARE work or do SAME work?”

---

## Case A: SHARE work (same group)

```
order-processing-service (group)
 ├── instance 1
 ├── instance 2
 └── instance 3
```

Each event processed **once**

---

## Case B: SAME work (different groups)

```
email-service (group)
fraud-service (group)
analytics-service (group)
```

Each group gets **all events**

---

# 6️⃣ Very important clarification (your confusion)

You asked:

> “We group services under one and create such groups that is consumer group?”

❌ Not exactly

Correct understanding:

> **Consumer group groups CONSUMER INSTANCES, not services logically.**

Same service can:

* Join **multiple consumer groups**
* Consume **multiple topics**
* Have **multiple consumers inside it**

---

# 7️⃣ Where do OFFSETS fit in? (simple)

> **Offset = “how far a consumer group has read”**

Example:

```
Group: payment-service
Partition 1
Last committed offset = 42
```

Means:

* Events up to 42 are processed
* Next read starts from 43

Important:

* Offset is tracked **per group per partition**
* Different groups have different offsets

---

# 8️⃣ Now connect ALL pieces (simple picture)

```
Topic: orders
 ├── Partition 0 (offsets 0,1,2...)
 ├── Partition 1 (offsets 0,1,2...)
 └── Partition 2 (offsets 0,1,2...)

Consumer Group: payment-service
 ├── Consumer A → Partition 0
 ├── Consumer B → Partition 1
 └── Consumer C → Partition 2

Consumer Group: email-service
 ├── Consumer X → Partition 0
 ├── Consumer Y → Partition 1
 └── Consumer Z → Partition 2
```

Same data
Different offsets
Independent processing

---

# 9️⃣ Now a LITTLE jargon 

| Simple word       | Kafka term     |
| ----------------- | -------------- |
| Bucket            | Partition      |
| Team of readers   | Consumer Group |
| Position          | Offset         |
| Event             | Record         |
| Read              | Poll           |
| Remember position | Commit offset  |

---

# 🔟 One sentence that should make it click forever

> **A topic is split into partitions so work can be parallelized, and consumer groups decide whether consumers share that work or all do it independently.**

---

# Importnace of Consumer Group
1.  **Multiple consumer instances are not for more concurrency than partitions — they are for reliability, scalability, and isolation.**

Concurrency is capped by partitions.
Instances solve *other problems*.

---

2. What creating multiple instances actually achieves

### ✅ 1. Parallel processing (up to partition count)

You already know this:

```
Partitions = 3
Instances = 3
→ true parallel consumption
```

But that’s **only the first benefit**.

---

### ✅ 2. Fault tolerance (VERY important)

If you have **only one instance**:

```
Instance A → P0, P1, P2
```

If it crashes:

* Entire service stops
* No processing happens

---

With multiple instances:

```
Instance A → P0
Instance B → P1
Instance C → P2
```

If **Instance B dies**:

* Kafka rebalances
* Another instance picks up P1
* Processing resumes

👉 **No single point of failure**

---

### ✅ 3. Horizontal scalability (real-world reason)

Traffic grows:

* Events per second ↑
* Processing cost per event ↑

You can:

* Increase partitions (infra decision)
* Increase instances (app decision)

Instances give you **runtime flexibility**.

---

### ✅ 4. Deployment safety (rolling deployments)

In production:

```
Instance A (old version)
Instance B (old version)
Instance C (old version)
```

Deploy new version:

* Restart one instance at a time
* Others keep processing

👉 **Zero downtime**

---

### ✅ 5. Load isolation inside the service

Even if:

* One instance is slow (GC pause, CPU spike)
* Others keep processing their partitions

Kafka **isolates impact** per partition.

---

### ✅ 6. Backpressure handling

If:

* One partition gets heavy data
* One instance is overloaded

Kafka won’t block the whole topic.
Only that partition lags.

---

## 3️⃣ Important clarification

> **More instances than partitions does NOT increase throughput.**

```
Partitions = 3
Instances = 10
Active = 3
Idle = 7
```

Extra instances = **standby capacity**

---

## 4️⃣ Why not just rely on partitions then?

Because partitions:

* Are fixed at topic level
* Expensive to change in prod
* Affect ordering guarantees

Instances:

* Cheap to add/remove
* App-level control
* No data reshuffling

---
### Partitions = lanes on a highway

### Consumer instances = cars

* More lanes → more cars can move in parallel
* More cars than lanes → some wait
* If one car breaks → others keep moving

---

## 6️⃣ One-line answer 

> “Partitions define the maximum parallelism, while multiple consumer instances provide fault tolerance, horizontal scalability, and operational safety without increasing partition count.”

---

## 7️⃣ Final takeaway (burn this in)

> **Partitions give capacity.
> Instances give resilience.**



