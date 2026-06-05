const db = db.getSiblingDB("test");

try { db.createCollection("users"); } catch(e) {}
try { db.createCollection("products"); } catch(e) {}

if (db.users.countDocuments() == 0) {
  for (let i = 1; i <= 50; i++) {
    db.users.insertOne({userId: i, name: "User" + i, age: 20 + Math.random() * 40});
  }
}

if (db.products.countDocuments() == 0) {
  for (let i = 1; i <= 50; i++) {
    db.products.insertOne({productId: i, name: "Product" + i, price: Math.random() * 1000});
  }
}

console.log("Load Generator Started");

let iteration = 0;
const startTime = Date.now();

while (true) {
  iteration++;

  db.users.insertOne({userId: 1000 + iteration, name: "NewUser" + iteration, age: Math.random() * 60});
  db.products.insertOne({productId: 1000 + iteration, name: "NewProduct" + iteration, price: Math.random() * 1000});

  db.users.findOne({userId: Math.floor(Math.random() * 50) + 1});
  db.products.findOne({productId: Math.floor(Math.random() * 50) + 1});

  db.users.updateOne({userId: Math.floor(Math.random() * 50) + 1}, {$set: {age: Math.random() * 80}});
  db.products.updateOne({productId: Math.floor(Math.random() * 50) + 1}, {$set: {price: Math.random() * 1000}});

  db.users.aggregate([{$group: {_id: null, avgAge: {$avg: "$age"}, count: {$sum: 1}}}]).toArray();
  db.products.aggregate([{$group: {_id: null, avgPrice: {$avg: "$price"}, count: {$sum: 1}}}]).toArray();

  db.products.deleteOne({productId: 1000 + (iteration - 100)});
  db.users.deleteOne({userId: 1000 + (iteration - 100)});

  if (iteration % 50 == 0) {
    let elapsed = Math.floor((Date.now() - startTime) / 1000);
    let totalOps = iteration * 10;
    let opsPerSecond = (totalOps / elapsed).toFixed(2);
    console.log("Iter: " + iteration + " TotalOps: " + totalOps + " Elapsed: " + elapsed + "s OpsPerSec: " + opsPerSecond);
  }
}
