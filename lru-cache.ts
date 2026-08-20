class LRUCacheNode {
  key: number;
  value: number;
  prev: LRUCacheNode | null;
  next: LRUCacheNode | null;

  constructor(key: number, value: number) {
    this.key = key;
    this.value = value;
    this.prev = null;
    this.next = null;
  }
}

export class LRUCache {
  private capacity: number;
  private cache: Map<number, LRUCacheNode>;
  private head: LRUCacheNode;
  private tail: LRUCacheNode;

  constructor(capacity: number) {
    if (capacity <= 0) {
      throw new Error("Invalid capacity");
    }
    this.capacity = capacity;
    this.cache = new Map();

    this.head = new LRUCacheNode(0, 0);
    this.tail = new LRUCacheNode(0, 0);
    this.head.next = this.tail;
    this.tail.prev = this.head;
  }

  get(key: number): number {
    const node = this.cache.get(key);
    if (!node) {
      return -1;
    }
    this.moveToHead(node);
    return node.value;
  }

  put(key: number, value: number): void {
    const existingNode = this.cache.get(key);

    if (existingNode) {
      existingNode.value = value;
      this.moveToHead(existingNode);
    } else {
      const newNode = new LRUCacheNode(key, value);
      this.cache.set(key, newNode);
      this.addToHead(newNode);

      if (this.cache.size > this.capacity) {
        const removed = this.removeTail();
        if (removed) {
          this.cache.delete(removed.key);
        }
      }
    }
  }

  size(): number {
    return this.cache.size;
  }

  private addToHead(node: LRUCacheNode): void {
    node.prev = this.head;
    node.next = this.head.next;
    this.head.next!.prev = node;
    this.head.next = node;
  }

  private removeNode(node: LRUCacheNode): void {
    node.prev!.next = node.next;
    node.next!.prev = node.prev;
  }

  private moveToHead(node: LRUCacheNode): void {
    this.removeNode(node);
    this.addToHead(node);
  }

  private removeTail(): LRUCacheNode | null {
    if (this.tail.prev === this.head) {
      return null;
    }
    const lastNode = this.tail.prev!;
    this.removeNode(lastNode);
    return lastNode;
  }
}
