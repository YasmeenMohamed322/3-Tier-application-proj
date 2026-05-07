CREATE TABLE patients (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    age INT NOT NULL,
    condition TEXT NOT NULL,
    status VARCHAR(20) CHECK (status IN ('stable', 'not stable')) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);