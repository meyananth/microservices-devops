const express = require('express');
const app = express();
const PORT = process.env.PORT || 3002;

app.get('/health', (req, res) => {
  res.json({ status: 'UP', service: 'product-service' });
});

app.get('/products', (req, res) => {
  res.json([{ id: 1, name: 'sample-product-1' }, { id: 2, name: 'sample-product-2' }]);
});

app.listen(PORT, () => console.log('product-service listening on port ' + PORT));
