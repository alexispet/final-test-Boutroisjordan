import express from 'express';
import mariadb from 'mariadb';
import path from "path";

const app = express();
let port = process.env.PORT || 3000;

// Configurations de la base de données
const pool = mariadb.createPool({
  host: process.env.DB_HOST || "mariadb",
  user: process.env.DB_USER || "usertest",
  password: process.env.DB_PASSWORD || "password",
  database: process.env.DB_DATABASE || "dbtest",
  connectionLimit: 5,
});

app.get("/", async (req, res) => {
  res
    .status(200)
    .json({ message: "Bienvenue à toi sur l'API de votre application" });
});


app.get("/post", async (req, res) => {
  let conn;
  try {
    conn = await pool.getConnection();
    const rows = await conn.query("SELECT * FROM posts");
    res.json(rows);
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: "Erreur lors de la récupération des posts" });
  } finally {
    if (conn) return conn.end();
  }
});

app.get("/page", (req, res) => {
  const htmlContent = `
    <!DOCTYPE html>
    <html lang="en">
    <head>
      <meta charset="UTF-8">
      <meta name="viewport" content="width=device-width, initial-scale=1.0">
      <title>Page HTML</title>
    </head>
    <body>
      <h1>Bienvenue sur la page HTML!</h1>
    </body>
    </html>
  `;

  res.send(htmlContent);
});
function findAvailablePort() {
  return new Promise((resolve, reject) => {
    const server = app.listen(port, () => {
      const foundPort = server.address().port;
      server.close(() => resolve(foundPort));
    });

    server.on('error', (err) => {
      if (err.code === 'EADDRINUSE') {
        port++;
        server.close();
      } else {
        reject(err);
      }
    });
  });
}

// Lancer le serveur en utilisant le port disponible
findAvailablePort()
    .then((availablePort) => {
      port = availablePort;
      app.listen(port, () => {
        console.log(`Serveur en cours d'exécution sur le port ${port}`);
      });
    })
    .catch((err) => {
      console.error('Erreur lors du démarrage du serveur:', err);
    });

export default app;
