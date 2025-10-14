DROP TABLE nc_persistent_host_application;

CREATE TABLE nc_persistent_host_application
(
  persistent_host_id bigint NOT NULL,
  application_id bigint,
  ports text,
  last_seen timestamp with time zone,
  CONSTRAINT foreign_key_01 FOREIGN KEY (persistent_host_id)
      REFERENCES nc_persistent_host (persistent_host_id) MATCH SIMPLE
      ON UPDATE CASCADE ON DELETE CASCADE
)
WITH (
  OIDS=FALSE
);
ALTER TABLE nc_persistent_host_application
  OWNER TO ironwood;
GRANT ALL ON TABLE nc_persistent_host_application TO ironwood;
GRANT SELECT ON TABLE nc_persistent_host_application TO readonly;

-- Index: nc_persistent_host_application_i1

-- DROP INDEX nc_persistent_host_application_i1;

CREATE INDEX nc_persistent_host_application_i1
  ON nc_persistent_host_application
  USING btree
  (persistent_host_id);

-- Index: nc_persistent_host_application_i2

-- DROP INDEX nc_persistent_host_application_i2;

CREATE INDEX nc_persistent_host_application_i2
  ON nc_persistent_host_application
  USING btree
  (application_id);

-- Index: nc_persistent_host_application_i3

-- DROP INDEX nc_persistent_host_application_i3;

CREATE INDEX nc_persistent_host_application_i3
  ON nc_persistent_host_application
  USING btree
  (last_seen);

