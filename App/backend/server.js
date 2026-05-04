const express = require("express");
const cors = require("cors");
const connectDB = require("./db");
const patientRoutes = require("./routes/patients");

const app = express();
app.use(cors());
app.use(express.json());

connectDB();

app.get("/api/health", (req, res) => {
  res.json({ message: "Backend working" });
});

app.use("/api/patients", patientRoutes);

app.listen(5000, () => {
  console.log("Backend running on port 5000");
});