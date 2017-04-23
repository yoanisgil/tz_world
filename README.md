# Generate a Docker image with the TZ_World shapefile information

- Download the TZ World shapefile from [here](http://efele.net/maps/tz/world/tz_world.zip)
- Unzip the file:
    
        # unzip tz_world.zip
        Archive:  tz_world.zip
          inflating: world/index.html
          inflating: world/tz_world.png
          inflating: world/tz_world.prj
          inflating: world/tz_world.shp
          inflating: world/tz_world.shx
          inflating: world/tz_world.dbf

- Launch a Postgres (with PostGIS support) container: 

        # docker run -v $(pwd)/pgdata:/var/lib/postgresql/data -v $(pwd)/world:/tmp/world --name tz_world --rm -p 5555:5432 -e POSTGRES_DB=tz_world -e POSTGRES_PASSWORD=thepassword  mdillon/postgis:9.5-alpine
        
- Import the `tz_world` shapefile into a Postgres database:
        
        # docker exec -ti tz_world bash
        # shp2pgsql -I -s 4326 /tmp/world/tz_world.shp | psql -U postgres -d tz_world

At this point you have a working `tz_world` database which contains a `tz_world` table with the following information:

        tzworld=# \d tz_world;
        Table "public.tz_world"
         Column |            Type             |                       Modifiers
        --------+-----------------------------+-------------------------------------------
         gid    | integer                     | not null default nextval('tz_world_gid_seq'::regclass)
         tzid   | character varying(30)       |
         geom   | geometry(MultiPolygon,4326) |
        Indexes:
            "tz_world_pkey" PRIMARY KEY, btree (gid)
            "tz_world_geom_idx" gist (geom)
            
            
# Generating a Docker Image

Though not compliacated, the steps above might be too of a time consuming task, specially if you want to reuse the `tz_world` database for different projects. And since the `TZ_World` shapefile should not change that often, a Docker image could be built an updated only when required:

    - docker build -t tz_world .
    
and then to run the container based on that image:

    - docker run --rm -p 5555:5432  tz_world
    
To connect to PostgresSQL server, just do:

    - psql  -U postgres -W -d tz_world  # The password is thepassword

