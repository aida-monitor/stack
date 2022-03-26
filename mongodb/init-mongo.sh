#!/bin/sh

echo "mongo init start --------------------'"

mongo -- "$MONGO_INITDB_DATABASE" <<EOF
  db.createUser(
    {
      user: "$MONGODB_APP_USERNAME",
      pwd: "$MONGODB_APP_PASSWORD",
      roles: [
        {
          role: "readWrite",
          db: "$MONGO_INITDB_DATABASE"
        }
      ]
    }
  )
EOF

exho "mongo init end ----------------------"