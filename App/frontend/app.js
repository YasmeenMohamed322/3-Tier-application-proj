const API = "/api/patients";

async function addPatient() {
  const name = document.getElementById("name").value;
  const age = document.getElementById("age").value;
  const condition = document.getElementById("condition").value;
  const status = document.getElementById("status").value;

  await fetch(API, {
    method: "POST",
    headers: { "Content-Type": "application/json" },
    body: JSON.stringify({ name, age, condition, status })
  });

  loadPatients();
}

async function loadPatients() {
  try {
    const res = await fetch(API);
    const data = await res.json();

    const container = document.getElementById("patients");
    container.innerHTML = "";

    data.forEach(p => {
      container.innerHTML += `
        <div>
          <b>${p.name}</b> | ${p.age} | ${p.condition} | ${p.status}
        </div>
      `;
    });
  } catch (err) {
    console.error("Backend not reachable:", err);
  }
}

loadPatients();
