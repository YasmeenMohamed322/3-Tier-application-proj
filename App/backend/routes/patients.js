const express = require("express");
const router = express.Router();
const Patient = require("../models/patient.js");

// GET all patients
router.get("/", async (req, res) => {
  const data = await Patient.find();
  res.json(data);
});

// ADD patient
router.post("/", async (req, res) => {
  const patient = new Patient(req.body);
  await patient.save();
  res.json(patient);
});

module.exports = router;