const API = "http://localhost:5000/api/patients";

async function loadPatients() {
  const res = await fetch(API);
  const data = await res.json();

  document.getElementById("patients").innerHTML =
    data.map(p => `
      <div class="card">
        <h3>${p.name}</h3>
        <p>Age: ${p.age}</p>
        <p>Condition: ${p.condition}</p>
        <p>
  Status:
  <span class="status ${p.status.replace(" ", "-")}">
    ${p.status}
  </span>
</p>
      </div>
    `).join("");
}

async function addPatient() {
  const patient = {
    name: document.getElementById("name").value,
    age: document.getElementById("age").value,
    condition: document.getElementById("condition").value,
    status: document.getElementById("status").value
  };

  await fetch(API, {
    method: "POST",
    headers: { "Content-Type": "application/json" },
    body: JSON.stringify(patient)
  });

  alert("Patient added successfully!");
}

loadPatients();