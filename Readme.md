42 wants your database files and WordPress files to stay saved even if containers stop or are deleted.
Normally, Docker containers lose data when deleted.
So we use Docker volumes connected to folders on your VM.

/home/mhoushma/data/wordpress
/home/mhoushma/data/mariadb

So even if containers are deleted:

✅ your website survives
✅ your database survives
