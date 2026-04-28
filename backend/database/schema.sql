-- Run this as postgres superuser or cluster admin:
-- CREATE DATABASE ims_db;
-- CREATE USER ims_user WITH ENCRYPTED PASSWORD 'ims_password_123';
-- GRANT ALL PRIVILEGES ON DATABASE ims_db TO ims_user;
-- \c ims_db;
-- GRANT ALL ON SCHEMA public TO ims_user;

CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- Suppliers Table
CREATE TABLE suppliers (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    vendor_id VARCHAR(50) UNIQUE NOT NULL,
    name VARCHAR(255) NOT NULL,
    status VARCHAR(50) DEFAULT 'ACTIVE',
    contact_name VARCHAR(255),
    phone VARCHAR(50),
    email VARCHAR(255),
    lead_time_days INTEGER,
    moq INTEGER,
    contract_status VARCHAR(100),
    categories TEXT[],
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Parts / Inventory Table
CREATE TABLE parts (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    sku VARCHAR(100) UNIQUE NOT NULL,
    oem_number VARCHAR(100),
    name VARCHAR(255) NOT NULL,
    category VARCHAR(100),
    location VARCHAR(100),
    quantity_on_hand INTEGER DEFAULT 0,
    reorder_point INTEGER DEFAULT 0,
    unit_cost NUMERIC(10, 2) DEFAULT 0.00,
    material VARCHAR(100),
    weight_kg NUMERIC(10, 2),
    dimensions VARCHAR(100),
    primary_supplier_id UUID REFERENCES suppliers(id) ON DELETE SET NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Compatible Vehicles (Many-to-Many via Join Table if needed, or structured JSON/Array)
-- For simplicity, keeping it as a separate table linked to parts
CREATE TABLE part_vehicles (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    part_id UUID REFERENCES parts(id) ON DELETE CASCADE,
    vehicle_name VARCHAR(255) NOT NULL,
    years VARCHAR(100),
    trims VARCHAR(255),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Stock Movements Table
CREATE TABLE stock_movements (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    part_id UUID REFERENCES parts(id) ON DELETE CASCADE,
    transaction_type VARCHAR(50) NOT NULL CHECK (transaction_type IN ('inbound', 'outbound', 'adjustment')),
    quantity INTEGER NOT NULL,
    balance_after INTEGER NOT NULL,
    movement_date TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    reason TEXT,
    user_ref VARCHAR(100),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Triggers for updated_at timestamps
CREATE OR REPLACE FUNCTION trigger_set_timestamp()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER set_timestamp_suppliers
BEFORE UPDATE ON suppliers
FOR EACH ROW
EXECUTE PROCEDURE trigger_set_timestamp();

CREATE TRIGGER set_timestamp_parts
BEFORE UPDATE ON parts
FOR EACH ROW
EXECUTE PROCEDURE trigger_set_timestamp();
