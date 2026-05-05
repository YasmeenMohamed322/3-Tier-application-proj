const express = require("express");
const cors = require("cors");

const patientRoutes = require("./routes/patients");

const app = express();

app.use(cors());
app.use(express.json());

// Health check
app.get("/api/health", (req, res) => {
  res.json({ message: "Backend working with PostgreSQL" });
});

// Routes
app.use("/api/patients", patientRoutes);

// Start server
app.listen(5000, () => {
  console.log("Backend running on port 5000");
});