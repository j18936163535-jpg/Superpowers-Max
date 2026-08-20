class ListNode {
  key: number;
  value: number;
  prev: ListNode | null;
  next: ListNode | null;

  constructor(key: number, value: number) {
    this.key = key;
    this.value = value;
    this.prev = null;
    this.next = null;
  }
}

class LRUCache {
  private capacity: number;
  private cache: Map<number, ListNode>;
  private head: ListNode | null;
  private tail: ListNode | null;

  constructor(capacity: number) {
    if (capacity <= 0) {
      throw new Error("Invalid capacity");
    }
    this.capacity = capacity;
    this.cache = new Map();
    this.head = null;
    this.tail = null;
  }

  private removeNode(node: ListNode): void {
    if (node.prev) {
      node.prev.next = node.next;
    } else {
      this.head = node.next;
    }
    if (node.next) {
      node.next.prev = node.prev;
    } else {
      this.tail = node.prev;
    }
  }

  private addToHead(node: ListNode): void {
    node.prev = null;
    node.next = this.head;
    if (this.head) {
      this.head.prev = node;
    }
    this.head = node;
    if (!this.tail) {
      this.tail = node;
    }
  }

  private moveToHead(node: ListNode): void {
    this.removeNode(node);
    this.addToHead(node);
  }

  private removeTail(): ListNode | null {
    if (!this.tail) return null;
    const tailNode = this.tail;
    this.removeNode(tailNode);
    return tailNode;
  }

  get(key: number): number {
    const node = this.cache.get(key);
    if (!node) return -1;
    this.moveToHead(node);
    return node.value;
  }

  put(key: number, value: number): void {
    const existingNode = this.cache.get(key);
    if (existingNode) {
      existingNode.value = value;
      this.moveToHead(existingNode);
      return;
    }

    const newNode = new ListNode(key, value);
    this.cache.set(key, newNode);
    this.addToHead(newNode);

    if (this.cache.size > this.capacity) {
      const lruNode = this.removeTail();
      if (lruNode) {
        this.cache.delete(lruNode.key);
      }
    }
  }

  size(): number {
    return this.cache.size;
  }
}


function assertEqual(actual: unknown, expected: unknown, label: string): void {
  if (actual !== expected) {
    console.error(`FAIL: ${label} — expected ${expected}, got ${actual}`);
    process.exit(1);
  } else {
    console.log(`PASS: ${label}`);
  }
}

// === 示例测试 ===
const cache = new LRUCache(2);

cache.put(1, 1);          // [1]
assertEqual(cache.size(), 1, "size after put(1,1)");

cache.put(2, 2);          // [1,2]
assertEqual(cache.size(), 2, "size after put(2,2)");

assertEqual(cache.get(1), 1, "get(1) returns 1");  // [2,1]

cache.put(3, 3);          // 淘汰2 → [1,3]
assertEqual(cache.size(), 2, "size after put(3,3) evicts 2");

assertEqual(cache.get(2), -1, "get(2) returns -1 (evicted)");
assertEqual(cache.get(3), 3, "get(3) returns 3");  // [1,3] → [3,1]

cache.put(4, 4);          // 淘汰1 → [3,4]
assertEqual(cache.get(1), -1, "get(1) returns -1 (evicted)");
assertEqual(cache.get(3), 3, "get(3) returns 3");
assertEqual(cache.get(4), 4, "get(4) returns 4");

// === 额外测试 ===
// 更新已存在 key
const c2 = new LRUCache(3);
c2.put(1, 10);
c2.put(2, 20);
c2.put(1, 100);  // 更新 key=1
assertEqual(c2.get(1), 100, "update existing key value");
assertEqual(c2.size(), 2, "size unchanged after update");

// 容量为1的边界情况
const c3 = new LRUCache(1);
c3.put(1, 1);
c3.put(2, 2);
assertEqual(c3.get(1), -1, "capacity=1: first key evicted");
assertEqual(c3.get(2), 2, "capacity=1: second key present");

// Invalid capacity
try {
  new LRUCache(0);
  console.error("FAIL: should throw on capacity=0");
  process.exit(1);
} catch (e: unknown) {
  assertEqual((e as Error).message, "Invalid capacity", "throws on capacity=0");
}

try {
  new LRUCache(-5);
  console.error("FAIL: should throw on capacity=-5");
  process.exit(1);
} catch (e: unknown) {
  assertEqual((e as Error).message, "Invalid capacity", "throws on capacity=-5");
}

// get 命中后顺序验证
const c4 = new LRUCache(2);
c4.put(1, "a".charCodeAt(0));
c4.put(2, "b".charCodeAt(0));
c4.get(1);        // 1 变最近使用，淘汰时应淘汰 2
c4.put(3, "c".charCodeAt(0));
assertEqual(c4.get(2), -1, "get(1) then put(3): key 2 evicted");
assertEqual(c4.get(1), "a".charCodeAt(0), "key 1 still present after being accessed");

// 未命中 get 不改顺序
const c5 = new LRUCache(2);
c5.put(1, 1);
c5.put(2, 2);
c5.get(999);       // 未命中，不改变顺序
c5.put(3, 3);      // 应淘汰 1
assertEqual(c5.get(1), -1, "get(miss) doesn't change order, LRU evicted");
assertEqual(c5.get(2), 2, "key 2 still present");
assertEqual(c5.get(3), 3, "key 3 present");

// 大量操作的压力测试
const c6 = new LRUCache(1000);
for (let i = 0; i < 10000; i++) {
  c6.put(i, i * 2);
  assertEqual(c6.get(i), i * 2, `stress test get(${i})`);
}
assertEqual(c6.size(), 1000, "stress test size stays at capacity");

console.log("\n✅ All tests passed!");