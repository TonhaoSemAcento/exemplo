SELECT MD5('string')

CREATE EXTENSION pgcrypto;

CREATE TABLE users (
  id SERIAL PRIMARY KEY,
  email TEXT NOT NULL UNIQUE,
  password TEXT NOT NULL
);

INSERT INTO users (email, password) VALUES (
  'antonio@samcorp.com.br',
  crypt('senha', gen_salt('bf'))
);

SELECT * FROM users;

SELECT id 
  FROM users
 WHERE email = 'antonio@samcorp.com.br' 
   AND password = crypt('senha', password);

SELECT id 
  FROM users
 WHERE email = 'antonio@samcorp.com.br' 
   AND password = crypt('senhaerrada', password);
     