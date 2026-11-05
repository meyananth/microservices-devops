const express = require('express');
const app = express();
const PORT = process.env.PORT || 3001;

app.get('/health', (req, res) => {
  res.json({ status: 'UP', service: 'user-service' });
});

app.get('/users', (req, res) => {
  res.json([{ id: 1, name: 'sample-user-1' }, { id: 2, name: 'sample-user-2' }]);
});

app.listen(PORT, () => console.log('user-service listening on port ' + PORT));
