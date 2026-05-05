const express = require("express");
const router = express.Router();
const db = require("../db");

// =======================
// CREATE patient
// =======================
router.post("/", async (req, res) => {
  const { name, age, condition, status } = req.body;

  try {
    const result = await db.query(
      "INSERT INTO patients (name, age, condition, status) VALUES ($1, $2, $3, $4) RETURNING *",
      [name, age, condition, status]
    );

    res.json(result.rows[0]);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

// =======================
// GET all patients
// =======================
router.get("/", async (req, res) => {
  try {
    const result = await db.query("SELECT * FROM patients ORDER BY id DESC");
    res.json(result.rows);
  } catch (err) {
    console.error("DB ERROR:", err);   // 🔥 ADD THIS
    res.status(500).json({ error: err.message });
  }
});
router.get("/test-db", async (req, res) => {
  try {
    const result = await db.query("SELECT NOW()");
    res.json(result.rows[0]);
  } catch (err) {
    console.error("DB TEST ERROR:", err);
    res.status(500).json({ error: err.message });
  }
});

// =======================
// UPDATE patient status
// =======================
router.put("/:id", async (req, res) => {
  const { id } = req.params;
  const { status } = req.body;

  try {
    const result = await db.query(
      "UPDATE patients SET status = $1 WHERE id = $2 RETURNING *",
      [status, id]
    );

    res.json(result.rows[0]);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

// =======================
// DELETE patient
// =======================
router.delete("/:id", async (req, res) => {
  const { id } = req.params;

  try {
    await db.query("DELETE FROM patients WHERE id = $1", [id]);
    res.json({ message: "Deleted successfully" });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

module.exports = router;