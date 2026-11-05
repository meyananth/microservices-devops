const express = require('express');
const app = express();
const PORT = process.env.PORT || 3003;

app.get('/health', (req, res) => {
  res.json({ status: 'UP', service: 'order-service' });
});

app.get('/orders', (req, res) => {
  res.json([{ id: 1, name: 'sample-order-1' }, { id: 2, name: 'sample-order-2' }]);
});

app.listen(PORT, () => console.log('order-service listening on port ' + PORT));
