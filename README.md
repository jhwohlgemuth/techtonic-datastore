#Data Services for Development
&nbsp;[![MongoDB](http://images.jhwohlgemuth.com/logo/tech/mongodb.png "MongoDB")](#using-mongodb)
&nbsp;[![redis](http://images.jhwohlgemuth.com/logo/tech/redis.png "redis")](#using-redis)
&nbsp;[![CouchDB](http://images.jhwohlgemuth.com/logo/tech/couchdb.png "CouchDB")](#using-couchdb)

###Requirements
- [Node.js](https://nodejs.org/) is installed
- [Virtualbox](https://www.virtualbox.org/wiki/Downloads) is installed
- [Vagrant](https://www.vagrantup.com/) is installed
- vagrant hostmanager plugin is installed ```vagrant plugin install vagrant-hostmanager```

###Using [MongoDB](http://docs.mongodb.org/manual/)

**&#x02713;** Set ```inline``` to ```$install_mongo``` on [line 27](Vagrantfile#L27).

**&#x02713;** Execute ```vagrant up```

**&#x02713;** [Install Mongo for windows](https://github.com/jhwohlgemuth/techtonic/wiki#mongodb-setup-on-windows)

**&#x02713;** In a mongo console, execute ```mongo db.server```

> **Tip:** The default port for MongoDB is 27017.  It can be changed by editing ```/etc/mongod.conf```.

###Using [redis](http://redis.io/documentation/)

**&#x02713;** Set ```inline``` to ```$install_redis``` on [line 27](Vagrantfile#L27).

**&#x02713;** Execute ```vagrant up```

**&#x02713;** Install a redis client.  I like [Redis Commander](https://joeferner.github.io/redis-commander/).

> Install Redis Commander with ```npm install redis-commander --global```

**&#x02713;** Start Redis Commander with ```redis-commander --redis-host db.server```

**&#x02713;** Open your favorite browser and navigate to [localhost:8081](http://localhost:8081)

> **Tip** The default port for redis is 6379.  It can be changed by editing ```/etc/redis/redis.conf```.

###Using [CouchDB](http://docs.couchdb.org/en/1.6.1/)
**&#x02713;** Set  ```inline``` to ```$install_couch``` on [line 27](Vagrantfile#L27).

**&#x02713;** Execute ```vagrant up```

**&#x02713;** Create a ssh tunnel on your host machine (input ```yes```, then ```vagrant```):

    ssh -f -L localhost:5984:127.0.0.1:5984 vagrant@db.server -N

**&#x02713;** Open your favorite browser and navigate to [localhost:5984/_utils](http://localhost:5984/_utils)

> **Tip:** The default port for CouchDB is 5984.  It can be changed by editing ```/etc/couchdb/local.ini```

#Tools, References & Resources
- See wiki page, [Front-end Link Library](https://github.com/jhwohlgemuth/techtonic/wiki/Front-end-Link-Library)
