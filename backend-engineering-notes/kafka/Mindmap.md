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
