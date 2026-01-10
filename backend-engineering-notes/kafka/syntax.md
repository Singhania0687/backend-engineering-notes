# Kafka Generic Syntax
---

# 1️⃣ Kafka Producer – General Syntax 

### Producer flow (always the same)

```
1. Create Kafka client
2. Create producer
3. Connect producer
4. Send message(s)
5. Disconnect (optional for long-running apps)
```

### Generic Producer Pseudocode

```
kafka = new Kafka(config)
producer = kafka.createProducer()

producer.connect()

producer.send(
  topic,
  key,
  value,
  headers
)

producer.disconnect()
```

---

## Producer – Key things you must remember

* **topic** → where the event goes
* **key** → decides partition (ordering guarantee)
* **value** → actual event payload (usually JSON)
* **producer is fire-and-forget by default**, unless you wait for ACKs

---

# 2️⃣ Kafka Consumer – General Syntax (Mental Model)

### Consumer flow (always the same)

```
1. Create Kafka client
2. Create consumer (with groupId)
3. Connect consumer
4. Subscribe to topic
5. Poll messages continuously
6. Process message
7. Commit offset
```

### Generic Consumer Pseudocode

```
kafka = new Kafka(config)
consumer = kafka.createConsumer(groupId)

consumer.connect()

consumer.subscribe(topic)

while (true):
  records = consumer.poll()
  for record in records:
    process(record)
    commitOffset()
```

---

## Consumer – Key things to remember

* **groupId** → enables load balancing
* **offset** → what you have processed
* **commit offset only after successful processing**
* Kafka **does not push** messages → consumer **polls**

---

# 3️⃣ Real Node.js Template (KafkaJS)

## 🔹 Producer Template (copy & reuse)

```js
const { Kafka } = require("kafkajs");

const kafka = new Kafka({
  clientId: "my-producer",
  brokers: ["localhost:9092"],
});

const producer = kafka.producer();

async function produce() {
  await producer.connect();

  await producer.send({
    topic: "my-topic",
    messages: [
      {
        key: "entity-id",
        value: JSON.stringify({ event: "SOMETHING_HAPPENED" }),
      },
    ],
  });

  // keep connection open in real apps
  await producer.disconnect();
}

produce();
```

---

## 🔹 Consumer Template (copy & reuse)

```js
const { Kafka } = require("kafkajs");

const kafka = new Kafka({
  clientId: "my-consumer",
  brokers: ["localhost:9092"],
});

const consumer = kafka.consumer({ groupId: "my-group" });

async function consume() {
  await consumer.connect();
  await consumer.subscribe({ topic: "my-topic", fromBeginning: false });

  await consumer.run({
    eachMessage: async ({ message, partition }) => {
      const value = message.value.toString();
      console.log("Consumed:", value);

      // process business logic here
    },
  });
}

consume();
```

---

# 4️⃣ Ultra-important interview defaults (MEMORIZE)

### Producer side

* Always set **key** for ordering
* Prefer **JSON** payload
* Think in **events**, not DB rows
* Producer should be **stateless**

---

### Consumer side

* One consumer group = one logical app
* Multiple consumers = parallelism
* Commit offsets **after processing**
* Consumers should be **idempotent**

---

# 5️⃣ One-line templates (very powerful)

### Producer one-liner

> Create → connect → send(topic, key, value) → disconnect

### Consumer one-liner

> Create → connect → subscribe → poll → process → commit offset

---

# 6️⃣ What interviewers secretly test

If they ask Kafka and you say:

* ❌ “Kafka pushes messages”
* ❌ “Kafka stores state”
* ❌ “Kafka guarantees exactly-once by default”

You’re out.

If you say:

* ✅ “Consumers poll Kafka”
* ✅ “Kafka stores immutable events”
* ✅ “Exactly-once requires careful config + idempotency”

You’re in.

---
