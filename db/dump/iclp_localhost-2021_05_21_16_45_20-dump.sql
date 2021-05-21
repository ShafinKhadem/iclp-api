--
-- PostgreSQL database dump
--

-- Dumped from database version 13.3 (Ubuntu 13.3-1.pgdg20.04+1)
-- Dumped by pg_dump version 13.3 (Ubuntu 13.3-1.pgdg20.04+1)

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: information_schema; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA information_schema;


ALTER SCHEMA information_schema OWNER TO postgres;

--
-- Name: cardinal_number; Type: DOMAIN; Schema: information_schema; Owner: postgres
--

CREATE DOMAIN information_schema.cardinal_number AS integer
	CONSTRAINT cardinal_number_domain_check CHECK ((VALUE >= 0));


ALTER DOMAIN information_schema.cardinal_number OWNER TO postgres;

--
-- Name: character_data; Type: DOMAIN; Schema: information_schema; Owner: postgres
--

CREATE DOMAIN information_schema.character_data AS character varying COLLATE pg_catalog."C";


ALTER DOMAIN information_schema.character_data OWNER TO postgres;

--
-- Name: sql_identifier; Type: DOMAIN; Schema: information_schema; Owner: postgres
--

CREATE DOMAIN information_schema.sql_identifier AS name;


ALTER DOMAIN information_schema.sql_identifier OWNER TO postgres;

--
-- Name: time_stamp; Type: DOMAIN; Schema: information_schema; Owner: postgres
--

CREATE DOMAIN information_schema.time_stamp AS timestamp(2) with time zone DEFAULT CURRENT_TIMESTAMP(2);


ALTER DOMAIN information_schema.time_stamp OWNER TO postgres;

--
-- Name: yes_or_no; Type: DOMAIN; Schema: information_schema; Owner: postgres
--

CREATE DOMAIN information_schema.yes_or_no AS character varying(3) COLLATE pg_catalog."C"
	CONSTRAINT yes_or_no_check CHECK (((VALUE)::text = ANY ((ARRAY['YES'::character varying, 'NO'::character varying])::text[])));


ALTER DOMAIN information_schema.yes_or_no OWNER TO postgres;

--
-- Name: _pg_char_max_length(oid, integer); Type: FUNCTION; Schema: information_schema; Owner: postgres
--

CREATE FUNCTION information_schema._pg_char_max_length(typid oid, typmod integer) RETURNS integer
    LANGUAGE sql IMMUTABLE STRICT PARALLEL SAFE
    AS $_$SELECT
  CASE WHEN $2 = -1 /* default typmod */
       THEN null
       WHEN $1 IN (1042, 1043) /* char, varchar */
       THEN $2 - 4
       WHEN $1 IN (1560, 1562) /* bit, varbit */
       THEN $2
       ELSE null
  END$_$;


ALTER FUNCTION information_schema._pg_char_max_length(typid oid, typmod integer) OWNER TO postgres;

--
-- Name: _pg_char_octet_length(oid, integer); Type: FUNCTION; Schema: information_schema; Owner: postgres
--

CREATE FUNCTION information_schema._pg_char_octet_length(typid oid, typmod integer) RETURNS integer
    LANGUAGE sql IMMUTABLE STRICT PARALLEL SAFE
    AS $_$SELECT
  CASE WHEN $1 IN (25, 1042, 1043) /* text, char, varchar */
       THEN CASE WHEN $2 = -1 /* default typmod */
                 THEN CAST(2^30 AS integer)
                 ELSE information_schema._pg_char_max_length($1, $2) *
                      pg_catalog.pg_encoding_max_length((SELECT encoding FROM pg_catalog.pg_database WHERE datname = pg_catalog.current_database()))
            END
       ELSE null
  END$_$;


ALTER FUNCTION information_schema._pg_char_octet_length(typid oid, typmod integer) OWNER TO postgres;

--
-- Name: _pg_datetime_precision(oid, integer); Type: FUNCTION; Schema: information_schema; Owner: postgres
--

CREATE FUNCTION information_schema._pg_datetime_precision(typid oid, typmod integer) RETURNS integer
    LANGUAGE sql IMMUTABLE STRICT PARALLEL SAFE
    AS $_$SELECT
  CASE WHEN $1 IN (1082) /* date */
           THEN 0
       WHEN $1 IN (1083, 1114, 1184, 1266) /* time, timestamp, same + tz */
           THEN CASE WHEN $2 < 0 THEN 6 ELSE $2 END
       WHEN $1 IN (1186) /* interval */
           THEN CASE WHEN $2 < 0 OR $2 & 65535 = 65535 THEN 6 ELSE $2 & 65535 END
       ELSE null
  END$_$;


ALTER FUNCTION information_schema._pg_datetime_precision(typid oid, typmod integer) OWNER TO postgres;

--
-- Name: _pg_expandarray(anyarray); Type: FUNCTION; Schema: information_schema; Owner: postgres
--

CREATE FUNCTION information_schema._pg_expandarray(anyarray, OUT x anyelement, OUT n integer) RETURNS SETOF record
    LANGUAGE sql IMMUTABLE STRICT PARALLEL SAFE
    AS $_$select $1[s], s - pg_catalog.array_lower($1,1) + 1
        from pg_catalog.generate_series(pg_catalog.array_lower($1,1),
                                        pg_catalog.array_upper($1,1),
                                        1) as g(s)$_$;


ALTER FUNCTION information_schema._pg_expandarray(anyarray, OUT x anyelement, OUT n integer) OWNER TO postgres;

--
-- Name: _pg_index_position(oid, smallint); Type: FUNCTION; Schema: information_schema; Owner: postgres
--

CREATE FUNCTION information_schema._pg_index_position(oid, smallint) RETURNS integer
    LANGUAGE sql STABLE STRICT
    AS $_$
SELECT (ss.a).n FROM
  (SELECT information_schema._pg_expandarray(indkey) AS a
   FROM pg_catalog.pg_index WHERE indexrelid = $1) ss
  WHERE (ss.a).x = $2;
$_$;


ALTER FUNCTION information_schema._pg_index_position(oid, smallint) OWNER TO postgres;

--
-- Name: _pg_interval_type(oid, integer); Type: FUNCTION; Schema: information_schema; Owner: postgres
--

CREATE FUNCTION information_schema._pg_interval_type(typid oid, mod integer) RETURNS text
    LANGUAGE sql IMMUTABLE STRICT PARALLEL SAFE
    AS $_$SELECT
  CASE WHEN $1 IN (1186) /* interval */
           THEN pg_catalog.upper(substring(pg_catalog.format_type($1, $2) from 'interval[()0-9]* #"%#"' for '#'))
       ELSE null
  END$_$;


ALTER FUNCTION information_schema._pg_interval_type(typid oid, mod integer) OWNER TO postgres;

--
-- Name: _pg_numeric_precision(oid, integer); Type: FUNCTION; Schema: information_schema; Owner: postgres
--

CREATE FUNCTION information_schema._pg_numeric_precision(typid oid, typmod integer) RETURNS integer
    LANGUAGE sql IMMUTABLE STRICT PARALLEL SAFE
    AS $_$SELECT
  CASE $1
         WHEN 21 /*int2*/ THEN 16
         WHEN 23 /*int4*/ THEN 32
         WHEN 20 /*int8*/ THEN 64
         WHEN 1700 /*numeric*/ THEN
              CASE WHEN $2 = -1
                   THEN null
                   ELSE (($2 - 4) >> 16) & 65535
                   END
         WHEN 700 /*float4*/ THEN 24 /*FLT_MANT_DIG*/
         WHEN 701 /*float8*/ THEN 53 /*DBL_MANT_DIG*/
         ELSE null
  END$_$;


ALTER FUNCTION information_schema._pg_numeric_precision(typid oid, typmod integer) OWNER TO postgres;

--
-- Name: _pg_numeric_precision_radix(oid, integer); Type: FUNCTION; Schema: information_schema; Owner: postgres
--

CREATE FUNCTION information_schema._pg_numeric_precision_radix(typid oid, typmod integer) RETURNS integer
    LANGUAGE sql IMMUTABLE STRICT PARALLEL SAFE
    AS $_$SELECT
  CASE WHEN $1 IN (21, 23, 20, 700, 701) THEN 2
       WHEN $1 IN (1700) THEN 10
       ELSE null
  END$_$;


ALTER FUNCTION information_schema._pg_numeric_precision_radix(typid oid, typmod integer) OWNER TO postgres;

--
-- Name: _pg_numeric_scale(oid, integer); Type: FUNCTION; Schema: information_schema; Owner: postgres
--

CREATE FUNCTION information_schema._pg_numeric_scale(typid oid, typmod integer) RETURNS integer
    LANGUAGE sql IMMUTABLE STRICT PARALLEL SAFE
    AS $_$SELECT
  CASE WHEN $1 IN (21, 23, 20) THEN 0
       WHEN $1 IN (1700) THEN
            CASE WHEN $2 = -1
                 THEN null
                 ELSE ($2 - 4) & 65535
                 END
       ELSE null
  END$_$;


ALTER FUNCTION information_schema._pg_numeric_scale(typid oid, typmod integer) OWNER TO postgres;

--
-- Name: _pg_truetypid(pg_attribute, pg_type); Type: FUNCTION; Schema: information_schema; Owner: postgres
--

CREATE FUNCTION information_schema._pg_truetypid(pg_attribute, pg_type) RETURNS oid
    LANGUAGE sql IMMUTABLE STRICT PARALLEL SAFE
    AS $_$SELECT CASE WHEN $2.typtype = 'd' THEN $2.typbasetype ELSE $1.atttypid END$_$;


ALTER FUNCTION information_schema._pg_truetypid(pg_attribute, pg_type) OWNER TO postgres;

--
-- Name: _pg_truetypmod(pg_attribute, pg_type); Type: FUNCTION; Schema: information_schema; Owner: postgres
--

CREATE FUNCTION information_schema._pg_truetypmod(pg_attribute, pg_type) RETURNS integer
    LANGUAGE sql IMMUTABLE STRICT PARALLEL SAFE
    AS $_$SELECT CASE WHEN $2.typtype = 'd' THEN $2.typtypmod ELSE $1.atttypmod END$_$;


ALTER FUNCTION information_schema._pg_truetypmod(pg_attribute, pg_type) OWNER TO postgres;

--
-- Name: _pg_foreign_data_wrappers; Type: VIEW; Schema: information_schema; Owner: postgres
--

CREATE VIEW information_schema._pg_foreign_data_wrappers AS
 SELECT w.oid,
    w.fdwowner,
    w.fdwoptions,
    (current_database())::information_schema.sql_identifier AS foreign_data_wrapper_catalog,
    (w.fdwname)::information_schema.sql_identifier AS foreign_data_wrapper_name,
    (u.rolname)::information_schema.sql_identifier AS authorization_identifier,
    ('c'::character varying)::information_schema.character_data AS foreign_data_wrapper_language
   FROM pg_foreign_data_wrapper w,
    pg_authid u
  WHERE ((u.oid = w.fdwowner) AND (pg_has_role(w.fdwowner, 'USAGE'::text) OR has_foreign_data_wrapper_privilege(w.oid, 'USAGE'::text)));


ALTER TABLE information_schema._pg_foreign_data_wrappers OWNER TO postgres;

--
-- Name: _pg_foreign_servers; Type: VIEW; Schema: information_schema; Owner: postgres
--

CREATE VIEW information_schema._pg_foreign_servers AS
 SELECT s.oid,
    s.srvoptions,
    (current_database())::information_schema.sql_identifier AS foreign_server_catalog,
    (s.srvname)::information_schema.sql_identifier AS foreign_server_name,
    (current_database())::information_schema.sql_identifier AS foreign_data_wrapper_catalog,
    (w.fdwname)::information_schema.sql_identifier AS foreign_data_wrapper_name,
    (s.srvtype)::information_schema.character_data AS foreign_server_type,
    (s.srvversion)::information_schema.character_data AS foreign_server_version,
    (u.rolname)::information_schema.sql_identifier AS authorization_identifier
   FROM pg_foreign_server s,
    pg_foreign_data_wrapper w,
    pg_authid u
  WHERE ((w.oid = s.srvfdw) AND (u.oid = s.srvowner) AND (pg_has_role(s.srvowner, 'USAGE'::text) OR has_server_privilege(s.oid, 'USAGE'::text)));


ALTER TABLE information_schema._pg_foreign_servers OWNER TO postgres;

--
-- Name: _pg_foreign_table_columns; Type: VIEW; Schema: information_schema; Owner: postgres
--

CREATE VIEW information_schema._pg_foreign_table_columns AS
 SELECT n.nspname,
    c.relname,
    a.attname,
    a.attfdwoptions
   FROM pg_foreign_table t,
    pg_authid u,
    pg_namespace n,
    pg_class c,
    pg_attribute a
  WHERE ((u.oid = c.relowner) AND (pg_has_role(c.relowner, 'USAGE'::text) OR has_column_privilege(c.oid, a.attnum, 'SELECT, INSERT, UPDATE, REFERENCES'::text)) AND (n.oid = c.relnamespace) AND (c.oid = t.ftrelid) AND (c.relkind = 'f'::"char") AND (a.attrelid = c.oid) AND (a.attnum > 0));


ALTER TABLE information_schema._pg_foreign_table_columns OWNER TO postgres;

--
-- Name: _pg_foreign_tables; Type: VIEW; Schema: information_schema; Owner: postgres
--

CREATE VIEW information_schema._pg_foreign_tables AS
 SELECT (current_database())::information_schema.sql_identifier AS foreign_table_catalog,
    (n.nspname)::information_schema.sql_identifier AS foreign_table_schema,
    (c.relname)::information_schema.sql_identifier AS foreign_table_name,
    t.ftoptions,
    (current_database())::information_schema.sql_identifier AS foreign_server_catalog,
    (s.srvname)::information_schema.sql_identifier AS foreign_server_name,
    (u.rolname)::information_schema.sql_identifier AS authorization_identifier
   FROM pg_foreign_table t,
    pg_foreign_server s,
    pg_foreign_data_wrapper w,
    pg_authid u,
    pg_namespace n,
    pg_class c
  WHERE ((w.oid = s.srvfdw) AND (u.oid = c.relowner) AND (pg_has_role(c.relowner, 'USAGE'::text) OR has_table_privilege(c.oid, 'SELECT, INSERT, UPDATE, DELETE, TRUNCATE, REFERENCES, TRIGGER'::text) OR has_any_column_privilege(c.oid, 'SELECT, INSERT, UPDATE, REFERENCES'::text)) AND (n.oid = c.relnamespace) AND (c.oid = t.ftrelid) AND (c.relkind = 'f'::"char") AND (s.oid = t.ftserver));


ALTER TABLE information_schema._pg_foreign_tables OWNER TO postgres;

--
-- Name: _pg_user_mappings; Type: VIEW; Schema: information_schema; Owner: postgres
--

CREATE VIEW information_schema._pg_user_mappings AS
 SELECT um.oid,
    um.umoptions,
    um.umuser,
    (COALESCE(u.rolname, 'PUBLIC'::name))::information_schema.sql_identifier AS authorization_identifier,
    s.foreign_server_catalog,
    s.foreign_server_name,
    s.authorization_identifier AS srvowner
   FROM (pg_user_mapping um
     LEFT JOIN pg_authid u ON ((u.oid = um.umuser))),
    information_schema._pg_foreign_servers s
  WHERE (s.oid = um.umserver);


ALTER TABLE information_schema._pg_user_mappings OWNER TO postgres;

--
-- Name: applicable_roles; Type: VIEW; Schema: information_schema; Owner: postgres
--

CREATE VIEW information_schema.applicable_roles AS
 SELECT (a.rolname)::information_schema.sql_identifier AS grantee,
    (b.rolname)::information_schema.sql_identifier AS role_name,
    (
        CASE
            WHEN m.admin_option THEN 'YES'::text
            ELSE 'NO'::text
        END)::information_schema.yes_or_no AS is_grantable
   FROM ((pg_auth_members m
     JOIN pg_authid a ON ((m.member = a.oid)))
     JOIN pg_authid b ON ((m.roleid = b.oid)))
  WHERE pg_has_role(a.oid, 'USAGE'::text);


ALTER TABLE information_schema.applicable_roles OWNER TO postgres;

--
-- Name: administrable_role_authorizations; Type: VIEW; Schema: information_schema; Owner: postgres
--

CREATE VIEW information_schema.administrable_role_authorizations AS
 SELECT applicable_roles.grantee,
    applicable_roles.role_name,
    applicable_roles.is_grantable
   FROM information_schema.applicable_roles
  WHERE ((applicable_roles.is_grantable)::text = 'YES'::text);


ALTER TABLE information_schema.administrable_role_authorizations OWNER TO postgres;

--
-- Name: attributes; Type: VIEW; Schema: information_schema; Owner: postgres
--

CREATE VIEW information_schema.attributes AS
 SELECT (current_database())::information_schema.sql_identifier AS udt_catalog,
    (nc.nspname)::information_schema.sql_identifier AS udt_schema,
    (c.relname)::information_schema.sql_identifier AS udt_name,
    (a.attname)::information_schema.sql_identifier AS attribute_name,
    (a.attnum)::information_schema.cardinal_number AS ordinal_position,
    (pg_get_expr(ad.adbin, ad.adrelid))::information_schema.character_data AS attribute_default,
    (
        CASE
            WHEN (a.attnotnull OR ((t.typtype = 'd'::"char") AND t.typnotnull)) THEN 'NO'::text
            ELSE 'YES'::text
        END)::information_schema.yes_or_no AS is_nullable,
    (
        CASE
            WHEN ((t.typelem <> (0)::oid) AND (t.typlen = '-1'::integer)) THEN 'ARRAY'::text
            WHEN (nt.nspname = 'pg_catalog'::name) THEN format_type(a.atttypid, NULL::integer)
            ELSE 'USER-DEFINED'::text
        END)::information_schema.character_data AS data_type,
    (information_schema._pg_char_max_length(information_schema._pg_truetypid(a.*, t.*), information_schema._pg_truetypmod(a.*, t.*)))::information_schema.cardinal_number AS character_maximum_length,
    (information_schema._pg_char_octet_length(information_schema._pg_truetypid(a.*, t.*), information_schema._pg_truetypmod(a.*, t.*)))::information_schema.cardinal_number AS character_octet_length,
    (NULL::name)::information_schema.sql_identifier AS character_set_catalog,
    (NULL::name)::information_schema.sql_identifier AS character_set_schema,
    (NULL::name)::information_schema.sql_identifier AS character_set_name,
    (
        CASE
            WHEN (nco.nspname IS NOT NULL) THEN current_database()
            ELSE NULL::name
        END)::information_schema.sql_identifier AS collation_catalog,
    (nco.nspname)::information_schema.sql_identifier AS collation_schema,
    (co.collname)::information_schema.sql_identifier AS collation_name,
    (information_schema._pg_numeric_precision(information_schema._pg_truetypid(a.*, t.*), information_schema._pg_truetypmod(a.*, t.*)))::information_schema.cardinal_number AS numeric_precision,
    (information_schema._pg_numeric_precision_radix(information_schema._pg_truetypid(a.*, t.*), information_schema._pg_truetypmod(a.*, t.*)))::information_schema.cardinal_number AS numeric_precision_radix,
    (information_schema._pg_numeric_scale(information_schema._pg_truetypid(a.*, t.*), information_schema._pg_truetypmod(a.*, t.*)))::information_schema.cardinal_number AS numeric_scale,
    (information_schema._pg_datetime_precision(information_schema._pg_truetypid(a.*, t.*), information_schema._pg_truetypmod(a.*, t.*)))::information_schema.cardinal_number AS datetime_precision,
    (information_schema._pg_interval_type(information_schema._pg_truetypid(a.*, t.*), information_schema._pg_truetypmod(a.*, t.*)))::information_schema.character_data AS interval_type,
    (NULL::integer)::information_schema.cardinal_number AS interval_precision,
    (current_database())::information_schema.sql_identifier AS attribute_udt_catalog,
    (nt.nspname)::information_schema.sql_identifier AS attribute_udt_schema,
    (t.typname)::information_schema.sql_identifier AS attribute_udt_name,
    (NULL::name)::information_schema.sql_identifier AS scope_catalog,
    (NULL::name)::information_schema.sql_identifier AS scope_schema,
    (NULL::name)::information_schema.sql_identifier AS scope_name,
    (NULL::integer)::information_schema.cardinal_number AS maximum_cardinality,
    (a.attnum)::information_schema.sql_identifier AS dtd_identifier,
    ('NO'::character varying)::information_schema.yes_or_no AS is_derived_reference_attribute
   FROM ((((pg_attribute a
     LEFT JOIN pg_attrdef ad ON (((a.attrelid = ad.adrelid) AND (a.attnum = ad.adnum))))
     JOIN (pg_class c
     JOIN pg_namespace nc ON ((c.relnamespace = nc.oid))) ON ((a.attrelid = c.oid)))
     JOIN (pg_type t
     JOIN pg_namespace nt ON ((t.typnamespace = nt.oid))) ON ((a.atttypid = t.oid)))
     LEFT JOIN (pg_collation co
     JOIN pg_namespace nco ON ((co.collnamespace = nco.oid))) ON (((a.attcollation = co.oid) AND ((nco.nspname <> 'pg_catalog'::name) OR (co.collname <> 'default'::name)))))
  WHERE ((a.attnum > 0) AND (NOT a.attisdropped) AND (c.relkind = 'c'::"char") AND (pg_has_role(c.relowner, 'USAGE'::text) OR has_type_privilege(c.reltype, 'USAGE'::text)));


ALTER TABLE information_schema.attributes OWNER TO postgres;

--
-- Name: character_sets; Type: VIEW; Schema: information_schema; Owner: postgres
--

CREATE VIEW information_schema.character_sets AS
 SELECT (NULL::name)::information_schema.sql_identifier AS character_set_catalog,
    (NULL::name)::information_schema.sql_identifier AS character_set_schema,
    (getdatabaseencoding())::information_schema.sql_identifier AS character_set_name,
    (
        CASE
            WHEN (getdatabaseencoding() = 'UTF8'::name) THEN 'UCS'::name
            ELSE getdatabaseencoding()
        END)::information_schema.sql_identifier AS character_repertoire,
    (getdatabaseencoding())::information_schema.sql_identifier AS form_of_use,
    (current_database())::information_schema.sql_identifier AS default_collate_catalog,
    (nc.nspname)::information_schema.sql_identifier AS default_collate_schema,
    (c.collname)::information_schema.sql_identifier AS default_collate_name
   FROM (pg_database d
     LEFT JOIN (pg_collation c
     JOIN pg_namespace nc ON ((c.collnamespace = nc.oid))) ON (((d.datcollate = c.collcollate) AND (d.datctype = c.collctype))))
  WHERE (d.datname = current_database())
  ORDER BY (char_length((c.collname)::text)) DESC, c.collname
 LIMIT 1;


ALTER TABLE information_schema.character_sets OWNER TO postgres;

--
-- Name: check_constraint_routine_usage; Type: VIEW; Schema: information_schema; Owner: postgres
--

CREATE VIEW information_schema.check_constraint_routine_usage AS
 SELECT (current_database())::information_schema.sql_identifier AS constraint_catalog,
    (nc.nspname)::information_schema.sql_identifier AS constraint_schema,
    (c.conname)::information_schema.sql_identifier AS constraint_name,
    (current_database())::information_schema.sql_identifier AS specific_catalog,
    (np.nspname)::information_schema.sql_identifier AS specific_schema,
    (nameconcatoid(p.proname, p.oid))::information_schema.sql_identifier AS specific_name
   FROM pg_namespace nc,
    pg_constraint c,
    pg_depend d,
    pg_proc p,
    pg_namespace np
  WHERE ((nc.oid = c.connamespace) AND (c.contype = 'c'::"char") AND (c.oid = d.objid) AND (d.classid = ('pg_constraint'::regclass)::oid) AND (d.refobjid = p.oid) AND (d.refclassid = ('pg_proc'::regclass)::oid) AND (p.pronamespace = np.oid) AND pg_has_role(p.proowner, 'USAGE'::text));


ALTER TABLE information_schema.check_constraint_routine_usage OWNER TO postgres;

--
-- Name: check_constraints; Type: VIEW; Schema: information_schema; Owner: postgres
--

CREATE VIEW information_schema.check_constraints AS
 SELECT (current_database())::information_schema.sql_identifier AS constraint_catalog,
    (rs.nspname)::information_schema.sql_identifier AS constraint_schema,
    (con.conname)::information_schema.sql_identifier AS constraint_name,
    ("substring"(pg_get_constraintdef(con.oid), 7))::information_schema.character_data AS check_clause
   FROM (((pg_constraint con
     LEFT JOIN pg_namespace rs ON ((rs.oid = con.connamespace)))
     LEFT JOIN pg_class c ON ((c.oid = con.conrelid)))
     LEFT JOIN pg_type t ON ((t.oid = con.contypid)))
  WHERE (pg_has_role(COALESCE(c.relowner, t.typowner), 'USAGE'::text) AND (con.contype = 'c'::"char"))
UNION
 SELECT (current_database())::information_schema.sql_identifier AS constraint_catalog,
    (n.nspname)::information_schema.sql_identifier AS constraint_schema,
    (((((((n.oid)::text || '_'::text) || (r.oid)::text) || '_'::text) || (a.attnum)::text) || '_not_null'::text))::information_schema.sql_identifier AS constraint_name,
    (((a.attname)::text || ' IS NOT NULL'::text))::information_schema.character_data AS check_clause
   FROM pg_namespace n,
    pg_class r,
    pg_attribute a
  WHERE ((n.oid = r.relnamespace) AND (r.oid = a.attrelid) AND (a.attnum > 0) AND (NOT a.attisdropped) AND a.attnotnull AND (r.relkind = ANY (ARRAY['r'::"char", 'p'::"char"])) AND pg_has_role(r.relowner, 'USAGE'::text));


ALTER TABLE information_schema.check_constraints OWNER TO postgres;

--
-- Name: collation_character_set_applicability; Type: VIEW; Schema: information_schema; Owner: postgres
--

CREATE VIEW information_schema.collation_character_set_applicability AS
 SELECT (current_database())::information_schema.sql_identifier AS collation_catalog,
    (nc.nspname)::information_schema.sql_identifier AS collation_schema,
    (c.collname)::information_schema.sql_identifier AS collation_name,
    (NULL::name)::information_schema.sql_identifier AS character_set_catalog,
    (NULL::name)::information_schema.sql_identifier AS character_set_schema,
    (getdatabaseencoding())::information_schema.sql_identifier AS character_set_name
   FROM pg_collation c,
    pg_namespace nc
  WHERE ((c.collnamespace = nc.oid) AND (c.collencoding = ANY (ARRAY['-1'::integer, ( SELECT pg_database.encoding
           FROM pg_database
          WHERE (pg_database.datname = current_database()))])));


ALTER TABLE information_schema.collation_character_set_applicability OWNER TO postgres;

--
-- Name: collations; Type: VIEW; Schema: information_schema; Owner: postgres
--

CREATE VIEW information_schema.collations AS
 SELECT (current_database())::information_schema.sql_identifier AS collation_catalog,
    (nc.nspname)::information_schema.sql_identifier AS collation_schema,
    (c.collname)::information_schema.sql_identifier AS collation_name,
    ('NO PAD'::character varying)::information_schema.character_data AS pad_attribute
   FROM pg_collation c,
    pg_namespace nc
  WHERE ((c.collnamespace = nc.oid) AND (c.collencoding = ANY (ARRAY['-1'::integer, ( SELECT pg_database.encoding
           FROM pg_database
          WHERE (pg_database.datname = current_database()))])));


ALTER TABLE information_schema.collations OWNER TO postgres;

--
-- Name: column_column_usage; Type: VIEW; Schema: information_schema; Owner: postgres
--

CREATE VIEW information_schema.column_column_usage AS
 SELECT (current_database())::information_schema.sql_identifier AS table_catalog,
    (n.nspname)::information_schema.sql_identifier AS table_schema,
    (c.relname)::information_schema.sql_identifier AS table_name,
    (ac.attname)::information_schema.sql_identifier AS column_name,
    (ad.attname)::information_schema.sql_identifier AS dependent_column
   FROM pg_namespace n,
    pg_class c,
    pg_depend d,
    pg_attribute ac,
    pg_attribute ad
  WHERE ((n.oid = c.relnamespace) AND (c.oid = ac.attrelid) AND (c.oid = ad.attrelid) AND (d.classid = ('pg_class'::regclass)::oid) AND (d.refclassid = ('pg_class'::regclass)::oid) AND (d.objid = d.refobjid) AND (c.oid = d.objid) AND (d.objsubid = ad.attnum) AND (d.refobjsubid = ac.attnum) AND (ad.attgenerated <> ''::"char") AND pg_has_role(c.relowner, 'USAGE'::text));


ALTER TABLE information_schema.column_column_usage OWNER TO postgres;

--
-- Name: column_domain_usage; Type: VIEW; Schema: information_schema; Owner: postgres
--

CREATE VIEW information_schema.column_domain_usage AS
 SELECT (current_database())::information_schema.sql_identifier AS domain_catalog,
    (nt.nspname)::information_schema.sql_identifier AS domain_schema,
    (t.typname)::information_schema.sql_identifier AS domain_name,
    (current_database())::information_schema.sql_identifier AS table_catalog,
    (nc.nspname)::information_schema.sql_identifier AS table_schema,
    (c.relname)::information_schema.sql_identifier AS table_name,
    (a.attname)::information_schema.sql_identifier AS column_name
   FROM pg_type t,
    pg_namespace nt,
    pg_class c,
    pg_namespace nc,
    pg_attribute a
  WHERE ((t.typnamespace = nt.oid) AND (c.relnamespace = nc.oid) AND (a.attrelid = c.oid) AND (a.atttypid = t.oid) AND (t.typtype = 'd'::"char") AND (c.relkind = ANY (ARRAY['r'::"char", 'v'::"char", 'f'::"char", 'p'::"char"])) AND (a.attnum > 0) AND (NOT a.attisdropped) AND pg_has_role(t.typowner, 'USAGE'::text));


ALTER TABLE information_schema.column_domain_usage OWNER TO postgres;

--
-- Name: column_options; Type: VIEW; Schema: information_schema; Owner: postgres
--

CREATE VIEW information_schema.column_options AS
 SELECT (current_database())::information_schema.sql_identifier AS table_catalog,
    (c.nspname)::information_schema.sql_identifier AS table_schema,
    (c.relname)::information_schema.sql_identifier AS table_name,
    (c.attname)::information_schema.sql_identifier AS column_name,
    ((pg_options_to_table(c.attfdwoptions)).option_name)::information_schema.sql_identifier AS option_name,
    ((pg_options_to_table(c.attfdwoptions)).option_value)::information_schema.character_data AS option_value
   FROM information_schema._pg_foreign_table_columns c;


ALTER TABLE information_schema.column_options OWNER TO postgres;

--
-- Name: column_privileges; Type: VIEW; Schema: information_schema; Owner: postgres
--

CREATE VIEW information_schema.column_privileges AS
 SELECT (u_grantor.rolname)::information_schema.sql_identifier AS grantor,
    (grantee.rolname)::information_schema.sql_identifier AS grantee,
    (current_database())::information_schema.sql_identifier AS table_catalog,
    (nc.nspname)::information_schema.sql_identifier AS table_schema,
    (x.relname)::information_schema.sql_identifier AS table_name,
    (x.attname)::information_schema.sql_identifier AS column_name,
    (x.prtype)::information_schema.character_data AS privilege_type,
    (
        CASE
            WHEN (pg_has_role(x.grantee, x.relowner, 'USAGE'::text) OR x.grantable) THEN 'YES'::text
            ELSE 'NO'::text
        END)::information_schema.yes_or_no AS is_grantable
   FROM ( SELECT pr_c.grantor,
            pr_c.grantee,
            a.attname,
            pr_c.relname,
            pr_c.relnamespace,
            pr_c.prtype,
            pr_c.grantable,
            pr_c.relowner
           FROM ( SELECT pg_class.oid,
                    pg_class.relname,
                    pg_class.relnamespace,
                    pg_class.relowner,
                    (aclexplode(COALESCE(pg_class.relacl, acldefault('r'::"char", pg_class.relowner)))).grantor AS grantor,
                    (aclexplode(COALESCE(pg_class.relacl, acldefault('r'::"char", pg_class.relowner)))).grantee AS grantee,
                    (aclexplode(COALESCE(pg_class.relacl, acldefault('r'::"char", pg_class.relowner)))).privilege_type AS privilege_type,
                    (aclexplode(COALESCE(pg_class.relacl, acldefault('r'::"char", pg_class.relowner)))).is_grantable AS is_grantable
                   FROM pg_class
                  WHERE (pg_class.relkind = ANY (ARRAY['r'::"char", 'v'::"char", 'f'::"char", 'p'::"char"]))) pr_c(oid, relname, relnamespace, relowner, grantor, grantee, prtype, grantable),
            pg_attribute a
          WHERE ((a.attrelid = pr_c.oid) AND (a.attnum > 0) AND (NOT a.attisdropped))
        UNION
         SELECT pr_a.grantor,
            pr_a.grantee,
            pr_a.attname,
            c.relname,
            c.relnamespace,
            pr_a.prtype,
            pr_a.grantable,
            c.relowner
           FROM ( SELECT a.attrelid,
                    a.attname,
                    (aclexplode(COALESCE(a.attacl, acldefault('c'::"char", cc.relowner)))).grantor AS grantor,
                    (aclexplode(COALESCE(a.attacl, acldefault('c'::"char", cc.relowner)))).grantee AS grantee,
                    (aclexplode(COALESCE(a.attacl, acldefault('c'::"char", cc.relowner)))).privilege_type AS privilege_type,
                    (aclexplode(COALESCE(a.attacl, acldefault('c'::"char", cc.relowner)))).is_grantable AS is_grantable
                   FROM (pg_attribute a
                     JOIN pg_class cc ON ((a.attrelid = cc.oid)))
                  WHERE ((a.attnum > 0) AND (NOT a.attisdropped))) pr_a(attrelid, attname, grantor, grantee, prtype, grantable),
            pg_class c
          WHERE ((pr_a.attrelid = c.oid) AND (c.relkind = ANY (ARRAY['r'::"char", 'v'::"char", 'f'::"char", 'p'::"char"])))) x,
    pg_namespace nc,
    pg_authid u_grantor,
    ( SELECT pg_authid.oid,
            pg_authid.rolname
           FROM pg_authid
        UNION ALL
         SELECT (0)::oid AS oid,
            'PUBLIC'::name) grantee(oid, rolname)
  WHERE ((x.relnamespace = nc.oid) AND (x.grantee = grantee.oid) AND (x.grantor = u_grantor.oid) AND (x.prtype = ANY (ARRAY['INSERT'::text, 'SELECT'::text, 'UPDATE'::text, 'REFERENCES'::text])) AND (pg_has_role(u_grantor.oid, 'USAGE'::text) OR pg_has_role(grantee.oid, 'USAGE'::text) OR (grantee.rolname = 'PUBLIC'::name)));


ALTER TABLE information_schema.column_privileges OWNER TO postgres;

--
-- Name: column_udt_usage; Type: VIEW; Schema: information_schema; Owner: postgres
--

CREATE VIEW information_schema.column_udt_usage AS
 SELECT (current_database())::information_schema.sql_identifier AS udt_catalog,
    (COALESCE(nbt.nspname, nt.nspname))::information_schema.sql_identifier AS udt_schema,
    (COALESCE(bt.typname, t.typname))::information_schema.sql_identifier AS udt_name,
    (current_database())::information_schema.sql_identifier AS table_catalog,
    (nc.nspname)::information_schema.sql_identifier AS table_schema,
    (c.relname)::information_schema.sql_identifier AS table_name,
    (a.attname)::information_schema.sql_identifier AS column_name
   FROM pg_attribute a,
    pg_class c,
    pg_namespace nc,
    ((pg_type t
     JOIN pg_namespace nt ON ((t.typnamespace = nt.oid)))
     LEFT JOIN (pg_type bt
     JOIN pg_namespace nbt ON ((bt.typnamespace = nbt.oid))) ON (((t.typtype = 'd'::"char") AND (t.typbasetype = bt.oid))))
  WHERE ((a.attrelid = c.oid) AND (a.atttypid = t.oid) AND (nc.oid = c.relnamespace) AND (a.attnum > 0) AND (NOT a.attisdropped) AND (c.relkind = ANY (ARRAY['r'::"char", 'v'::"char", 'f'::"char", 'p'::"char"])) AND pg_has_role(COALESCE(bt.typowner, t.typowner), 'USAGE'::text));


ALTER TABLE information_schema.column_udt_usage OWNER TO postgres;

--
-- Name: columns; Type: VIEW; Schema: information_schema; Owner: postgres
--

CREATE VIEW information_schema.columns AS
 SELECT (current_database())::information_schema.sql_identifier AS table_catalog,
    (nc.nspname)::information_schema.sql_identifier AS table_schema,
    (c.relname)::information_schema.sql_identifier AS table_name,
    (a.attname)::information_schema.sql_identifier AS column_name,
    (a.attnum)::information_schema.cardinal_number AS ordinal_position,
    (
        CASE
            WHEN (a.attgenerated = ''::"char") THEN pg_get_expr(ad.adbin, ad.adrelid)
            ELSE NULL::text
        END)::information_schema.character_data AS column_default,
    (
        CASE
            WHEN (a.attnotnull OR ((t.typtype = 'd'::"char") AND t.typnotnull)) THEN 'NO'::text
            ELSE 'YES'::text
        END)::information_schema.yes_or_no AS is_nullable,
    (
        CASE
            WHEN (t.typtype = 'd'::"char") THEN
            CASE
                WHEN ((bt.typelem <> (0)::oid) AND (bt.typlen = '-1'::integer)) THEN 'ARRAY'::text
                WHEN (nbt.nspname = 'pg_catalog'::name) THEN format_type(t.typbasetype, NULL::integer)
                ELSE 'USER-DEFINED'::text
            END
            ELSE
            CASE
                WHEN ((t.typelem <> (0)::oid) AND (t.typlen = '-1'::integer)) THEN 'ARRAY'::text
                WHEN (nt.nspname = 'pg_catalog'::name) THEN format_type(a.atttypid, NULL::integer)
                ELSE 'USER-DEFINED'::text
            END
        END)::information_schema.character_data AS data_type,
    (information_schema._pg_char_max_length(information_schema._pg_truetypid(a.*, t.*), information_schema._pg_truetypmod(a.*, t.*)))::information_schema.cardinal_number AS character_maximum_length,
    (information_schema._pg_char_octet_length(information_schema._pg_truetypid(a.*, t.*), information_schema._pg_truetypmod(a.*, t.*)))::information_schema.cardinal_number AS character_octet_length,
    (information_schema._pg_numeric_precision(information_schema._pg_truetypid(a.*, t.*), information_schema._pg_truetypmod(a.*, t.*)))::information_schema.cardinal_number AS numeric_precision,
    (information_schema._pg_numeric_precision_radix(information_schema._pg_truetypid(a.*, t.*), information_schema._pg_truetypmod(a.*, t.*)))::information_schema.cardinal_number AS numeric_precision_radix,
    (information_schema._pg_numeric_scale(information_schema._pg_truetypid(a.*, t.*), information_schema._pg_truetypmod(a.*, t.*)))::information_schema.cardinal_number AS numeric_scale,
    (information_schema._pg_datetime_precision(information_schema._pg_truetypid(a.*, t.*), information_schema._pg_truetypmod(a.*, t.*)))::information_schema.cardinal_number AS datetime_precision,
    (information_schema._pg_interval_type(information_schema._pg_truetypid(a.*, t.*), information_schema._pg_truetypmod(a.*, t.*)))::information_schema.character_data AS interval_type,
    (NULL::integer)::information_schema.cardinal_number AS interval_precision,
    (NULL::name)::information_schema.sql_identifier AS character_set_catalog,
    (NULL::name)::information_schema.sql_identifier AS character_set_schema,
    (NULL::name)::information_schema.sql_identifier AS character_set_name,
    (
        CASE
            WHEN (nco.nspname IS NOT NULL) THEN current_database()
            ELSE NULL::name
        END)::information_schema.sql_identifier AS collation_catalog,
    (nco.nspname)::information_schema.sql_identifier AS collation_schema,
    (co.collname)::information_schema.sql_identifier AS collation_name,
    (
        CASE
            WHEN (t.typtype = 'd'::"char") THEN current_database()
            ELSE NULL::name
        END)::information_schema.sql_identifier AS domain_catalog,
    (
        CASE
            WHEN (t.typtype = 'd'::"char") THEN nt.nspname
            ELSE NULL::name
        END)::information_schema.sql_identifier AS domain_schema,
    (
        CASE
            WHEN (t.typtype = 'd'::"char") THEN t.typname
            ELSE NULL::name
        END)::information_schema.sql_identifier AS domain_name,
    (current_database())::information_schema.sql_identifier AS udt_catalog,
    (COALESCE(nbt.nspname, nt.nspname))::information_schema.sql_identifier AS udt_schema,
    (COALESCE(bt.typname, t.typname))::information_schema.sql_identifier AS udt_name,
    (NULL::name)::information_schema.sql_identifier AS scope_catalog,
    (NULL::name)::information_schema.sql_identifier AS scope_schema,
    (NULL::name)::information_schema.sql_identifier AS scope_name,
    (NULL::integer)::information_schema.cardinal_number AS maximum_cardinality,
    (a.attnum)::information_schema.sql_identifier AS dtd_identifier,
    ('NO'::character varying)::information_schema.yes_or_no AS is_self_referencing,
    (
        CASE
            WHEN (a.attidentity = ANY (ARRAY['a'::"char", 'd'::"char"])) THEN 'YES'::text
            ELSE 'NO'::text
        END)::information_schema.yes_or_no AS is_identity,
    (
        CASE a.attidentity
            WHEN 'a'::"char" THEN 'ALWAYS'::text
            WHEN 'd'::"char" THEN 'BY DEFAULT'::text
            ELSE NULL::text
        END)::information_schema.character_data AS identity_generation,
    (seq.seqstart)::information_schema.character_data AS identity_start,
    (seq.seqincrement)::information_schema.character_data AS identity_increment,
    (seq.seqmax)::information_schema.character_data AS identity_maximum,
    (seq.seqmin)::information_schema.character_data AS identity_minimum,
    (
        CASE
            WHEN seq.seqcycle THEN 'YES'::text
            ELSE 'NO'::text
        END)::information_schema.yes_or_no AS identity_cycle,
    (
        CASE
            WHEN (a.attgenerated <> ''::"char") THEN 'ALWAYS'::text
            ELSE 'NEVER'::text
        END)::information_schema.character_data AS is_generated,
    (
        CASE
            WHEN (a.attgenerated <> ''::"char") THEN pg_get_expr(ad.adbin, ad.adrelid)
            ELSE NULL::text
        END)::information_schema.character_data AS generation_expression,
    (
        CASE
            WHEN ((c.relkind = ANY (ARRAY['r'::"char", 'p'::"char"])) OR ((c.relkind = ANY (ARRAY['v'::"char", 'f'::"char"])) AND pg_column_is_updatable((c.oid)::regclass, a.attnum, false))) THEN 'YES'::text
            ELSE 'NO'::text
        END)::information_schema.yes_or_no AS is_updatable
   FROM ((((((pg_attribute a
     LEFT JOIN pg_attrdef ad ON (((a.attrelid = ad.adrelid) AND (a.attnum = ad.adnum))))
     JOIN (pg_class c
     JOIN pg_namespace nc ON ((c.relnamespace = nc.oid))) ON ((a.attrelid = c.oid)))
     JOIN (pg_type t
     JOIN pg_namespace nt ON ((t.typnamespace = nt.oid))) ON ((a.atttypid = t.oid)))
     LEFT JOIN (pg_type bt
     JOIN pg_namespace nbt ON ((bt.typnamespace = nbt.oid))) ON (((t.typtype = 'd'::"char") AND (t.typbasetype = bt.oid))))
     LEFT JOIN (pg_collation co
     JOIN pg_namespace nco ON ((co.collnamespace = nco.oid))) ON (((a.attcollation = co.oid) AND ((nco.nspname <> 'pg_catalog'::name) OR (co.collname <> 'default'::name)))))
     LEFT JOIN (pg_depend dep
     JOIN pg_sequence seq ON (((dep.classid = ('pg_class'::regclass)::oid) AND (dep.objid = seq.seqrelid) AND (dep.deptype = 'i'::"char")))) ON (((dep.refclassid = ('pg_class'::regclass)::oid) AND (dep.refobjid = c.oid) AND (dep.refobjsubid = a.attnum))))
  WHERE ((NOT pg_is_other_temp_schema(nc.oid)) AND (a.attnum > 0) AND (NOT a.attisdropped) AND (c.relkind = ANY (ARRAY['r'::"char", 'v'::"char", 'f'::"char", 'p'::"char"])) AND (pg_has_role(c.relowner, 'USAGE'::text) OR has_column_privilege(c.oid, a.attnum, 'SELECT, INSERT, UPDATE, REFERENCES'::text)));


ALTER TABLE information_schema.columns OWNER TO postgres;

--
-- Name: constraint_column_usage; Type: VIEW; Schema: information_schema; Owner: postgres
--

CREATE VIEW information_schema.constraint_column_usage AS
 SELECT (current_database())::information_schema.sql_identifier AS table_catalog,
    (x.tblschema)::information_schema.sql_identifier AS table_schema,
    (x.tblname)::information_schema.sql_identifier AS table_name,
    (x.colname)::information_schema.sql_identifier AS column_name,
    (current_database())::information_schema.sql_identifier AS constraint_catalog,
    (x.cstrschema)::information_schema.sql_identifier AS constraint_schema,
    (x.cstrname)::information_schema.sql_identifier AS constraint_name
   FROM ( SELECT DISTINCT nr.nspname,
            r.relname,
            r.relowner,
            a.attname,
            nc.nspname,
            c.conname
           FROM pg_namespace nr,
            pg_class r,
            pg_attribute a,
            pg_depend d,
            pg_namespace nc,
            pg_constraint c
          WHERE ((nr.oid = r.relnamespace) AND (r.oid = a.attrelid) AND (d.refclassid = ('pg_class'::regclass)::oid) AND (d.refobjid = r.oid) AND (d.refobjsubid = a.attnum) AND (d.classid = ('pg_constraint'::regclass)::oid) AND (d.objid = c.oid) AND (c.connamespace = nc.oid) AND (c.contype = 'c'::"char") AND (r.relkind = ANY (ARRAY['r'::"char", 'p'::"char"])) AND (NOT a.attisdropped))
        UNION ALL
         SELECT nr.nspname,
            r.relname,
            r.relowner,
            a.attname,
            nc.nspname,
            c.conname
           FROM pg_namespace nr,
            pg_class r,
            pg_attribute a,
            pg_namespace nc,
            pg_constraint c
          WHERE ((nr.oid = r.relnamespace) AND (r.oid = a.attrelid) AND (nc.oid = c.connamespace) AND (r.oid =
                CASE c.contype
                    WHEN 'f'::"char" THEN c.confrelid
                    ELSE c.conrelid
                END) AND (a.attnum = ANY (
                CASE c.contype
                    WHEN 'f'::"char" THEN c.confkey
                    ELSE c.conkey
                END)) AND (NOT a.attisdropped) AND (c.contype = ANY (ARRAY['p'::"char", 'u'::"char", 'f'::"char"])) AND (r.relkind = ANY (ARRAY['r'::"char", 'p'::"char"])))) x(tblschema, tblname, tblowner, colname, cstrschema, cstrname)
  WHERE pg_has_role(x.tblowner, 'USAGE'::text);


ALTER TABLE information_schema.constraint_column_usage OWNER TO postgres;

--
-- Name: constraint_table_usage; Type: VIEW; Schema: information_schema; Owner: postgres
--

CREATE VIEW information_schema.constraint_table_usage AS
 SELECT (current_database())::information_schema.sql_identifier AS table_catalog,
    (nr.nspname)::information_schema.sql_identifier AS table_schema,
    (r.relname)::information_schema.sql_identifier AS table_name,
    (current_database())::information_schema.sql_identifier AS constraint_catalog,
    (nc.nspname)::information_schema.sql_identifier AS constraint_schema,
    (c.conname)::information_schema.sql_identifier AS constraint_name
   FROM pg_constraint c,
    pg_namespace nc,
    pg_class r,
    pg_namespace nr
  WHERE ((c.connamespace = nc.oid) AND (r.relnamespace = nr.oid) AND (((c.contype = 'f'::"char") AND (c.confrelid = r.oid)) OR ((c.contype = ANY (ARRAY['p'::"char", 'u'::"char"])) AND (c.conrelid = r.oid))) AND (r.relkind = ANY (ARRAY['r'::"char", 'p'::"char"])) AND pg_has_role(r.relowner, 'USAGE'::text));


ALTER TABLE information_schema.constraint_table_usage OWNER TO postgres;

--
-- Name: domains; Type: VIEW; Schema: information_schema; Owner: postgres
--

CREATE VIEW information_schema.domains AS
 SELECT (current_database())::information_schema.sql_identifier AS domain_catalog,
    (nt.nspname)::information_schema.sql_identifier AS domain_schema,
    (t.typname)::information_schema.sql_identifier AS domain_name,
    (
        CASE
            WHEN ((t.typelem <> (0)::oid) AND (t.typlen = '-1'::integer)) THEN 'ARRAY'::text
            WHEN (nbt.nspname = 'pg_catalog'::name) THEN format_type(t.typbasetype, NULL::integer)
            ELSE 'USER-DEFINED'::text
        END)::information_schema.character_data AS data_type,
    (information_schema._pg_char_max_length(t.typbasetype, t.typtypmod))::information_schema.cardinal_number AS character_maximum_length,
    (information_schema._pg_char_octet_length(t.typbasetype, t.typtypmod))::information_schema.cardinal_number AS character_octet_length,
    (NULL::name)::information_schema.sql_identifier AS character_set_catalog,
    (NULL::name)::information_schema.sql_identifier AS character_set_schema,
    (NULL::name)::information_schema.sql_identifier AS character_set_name,
    (
        CASE
            WHEN (nco.nspname IS NOT NULL) THEN current_database()
            ELSE NULL::name
        END)::information_schema.sql_identifier AS collation_catalog,
    (nco.nspname)::information_schema.sql_identifier AS collation_schema,
    (co.collname)::information_schema.sql_identifier AS collation_name,
    (information_schema._pg_numeric_precision(t.typbasetype, t.typtypmod))::information_schema.cardinal_number AS numeric_precision,
    (information_schema._pg_numeric_precision_radix(t.typbasetype, t.typtypmod))::information_schema.cardinal_number AS numeric_precision_radix,
    (information_schema._pg_numeric_scale(t.typbasetype, t.typtypmod))::information_schema.cardinal_number AS numeric_scale,
    (information_schema._pg_datetime_precision(t.typbasetype, t.typtypmod))::information_schema.cardinal_number AS datetime_precision,
    (information_schema._pg_interval_type(t.typbasetype, t.typtypmod))::information_schema.character_data AS interval_type,
    (NULL::integer)::information_schema.cardinal_number AS interval_precision,
    (t.typdefault)::information_schema.character_data AS domain_default,
    (current_database())::information_schema.sql_identifier AS udt_catalog,
    (nbt.nspname)::information_schema.sql_identifier AS udt_schema,
    (bt.typname)::information_schema.sql_identifier AS udt_name,
    (NULL::name)::information_schema.sql_identifier AS scope_catalog,
    (NULL::name)::information_schema.sql_identifier AS scope_schema,
    (NULL::name)::information_schema.sql_identifier AS scope_name,
    (NULL::integer)::information_schema.cardinal_number AS maximum_cardinality,
    (1)::information_schema.sql_identifier AS dtd_identifier
   FROM (((pg_type t
     JOIN pg_namespace nt ON ((t.typnamespace = nt.oid)))
     JOIN (pg_type bt
     JOIN pg_namespace nbt ON ((bt.typnamespace = nbt.oid))) ON (((t.typbasetype = bt.oid) AND (t.typtype = 'd'::"char"))))
     LEFT JOIN (pg_collation co
     JOIN pg_namespace nco ON ((co.collnamespace = nco.oid))) ON (((t.typcollation = co.oid) AND ((nco.nspname <> 'pg_catalog'::name) OR (co.collname <> 'default'::name)))))
  WHERE (pg_has_role(t.typowner, 'USAGE'::text) OR has_type_privilege(t.oid, 'USAGE'::text));


ALTER TABLE information_schema.domains OWNER TO postgres;

--
-- Name: parameters; Type: VIEW; Schema: information_schema; Owner: postgres
--

CREATE VIEW information_schema.parameters AS
 SELECT (current_database())::information_schema.sql_identifier AS specific_catalog,
    (ss.n_nspname)::information_schema.sql_identifier AS specific_schema,
    (nameconcatoid(ss.proname, ss.p_oid))::information_schema.sql_identifier AS specific_name,
    ((ss.x).n)::information_schema.cardinal_number AS ordinal_position,
    (
        CASE
            WHEN (ss.proargmodes IS NULL) THEN 'IN'::text
            WHEN (ss.proargmodes[(ss.x).n] = 'i'::"char") THEN 'IN'::text
            WHEN (ss.proargmodes[(ss.x).n] = 'o'::"char") THEN 'OUT'::text
            WHEN (ss.proargmodes[(ss.x).n] = 'b'::"char") THEN 'INOUT'::text
            WHEN (ss.proargmodes[(ss.x).n] = 'v'::"char") THEN 'IN'::text
            WHEN (ss.proargmodes[(ss.x).n] = 't'::"char") THEN 'OUT'::text
            ELSE NULL::text
        END)::information_schema.character_data AS parameter_mode,
    ('NO'::character varying)::information_schema.yes_or_no AS is_result,
    ('NO'::character varying)::information_schema.yes_or_no AS as_locator,
    (NULLIF(ss.proargnames[(ss.x).n], ''::text))::information_schema.sql_identifier AS parameter_name,
    (
        CASE
            WHEN ((t.typelem <> (0)::oid) AND (t.typlen = '-1'::integer)) THEN 'ARRAY'::text
            WHEN (nt.nspname = 'pg_catalog'::name) THEN format_type(t.oid, NULL::integer)
            ELSE 'USER-DEFINED'::text
        END)::information_schema.character_data AS data_type,
    (NULL::integer)::information_schema.cardinal_number AS character_maximum_length,
    (NULL::integer)::information_schema.cardinal_number AS character_octet_length,
    (NULL::name)::information_schema.sql_identifier AS character_set_catalog,
    (NULL::name)::information_schema.sql_identifier AS character_set_schema,
    (NULL::name)::information_schema.sql_identifier AS character_set_name,
    (NULL::name)::information_schema.sql_identifier AS collation_catalog,
    (NULL::name)::information_schema.sql_identifier AS collation_schema,
    (NULL::name)::information_schema.sql_identifier AS collation_name,
    (NULL::integer)::information_schema.cardinal_number AS numeric_precision,
    (NULL::integer)::information_schema.cardinal_number AS numeric_precision_radix,
    (NULL::integer)::information_schema.cardinal_number AS numeric_scale,
    (NULL::integer)::information_schema.cardinal_number AS datetime_precision,
    (NULL::character varying)::information_schema.character_data AS interval_type,
    (NULL::integer)::information_schema.cardinal_number AS interval_precision,
    (current_database())::information_schema.sql_identifier AS udt_catalog,
    (nt.nspname)::information_schema.sql_identifier AS udt_schema,
    (t.typname)::information_schema.sql_identifier AS udt_name,
    (NULL::name)::information_schema.sql_identifier AS scope_catalog,
    (NULL::name)::information_schema.sql_identifier AS scope_schema,
    (NULL::name)::information_schema.sql_identifier AS scope_name,
    (NULL::integer)::information_schema.cardinal_number AS maximum_cardinality,
    ((ss.x).n)::information_schema.sql_identifier AS dtd_identifier,
    (
        CASE
            WHEN pg_has_role(ss.proowner, 'USAGE'::text) THEN pg_get_function_arg_default(ss.p_oid, (ss.x).n)
            ELSE NULL::text
        END)::information_schema.character_data AS parameter_default
   FROM pg_type t,
    pg_namespace nt,
    ( SELECT n.nspname AS n_nspname,
            p.proname,
            p.oid AS p_oid,
            p.proowner,
            p.proargnames,
            p.proargmodes,
            information_schema._pg_expandarray(COALESCE(p.proallargtypes, (p.proargtypes)::oid[])) AS x
           FROM pg_namespace n,
            pg_proc p
          WHERE ((n.oid = p.pronamespace) AND (pg_has_role(p.proowner, 'USAGE'::text) OR has_function_privilege(p.oid, 'EXECUTE'::text)))) ss
  WHERE ((t.oid = (ss.x).x) AND (t.typnamespace = nt.oid));


ALTER TABLE information_schema.parameters OWNER TO postgres;

--
-- Name: routines; Type: VIEW; Schema: information_schema; Owner: postgres
--

CREATE VIEW information_schema.routines AS
 SELECT (current_database())::information_schema.sql_identifier AS specific_catalog,
    (n.nspname)::information_schema.sql_identifier AS specific_schema,
    (nameconcatoid(p.proname, p.oid))::information_schema.sql_identifier AS specific_name,
    (current_database())::information_schema.sql_identifier AS routine_catalog,
    (n.nspname)::information_schema.sql_identifier AS routine_schema,
    (p.proname)::information_schema.sql_identifier AS routine_name,
    (
        CASE p.prokind
            WHEN 'f'::"char" THEN 'FUNCTION'::text
            WHEN 'p'::"char" THEN 'PROCEDURE'::text
            ELSE NULL::text
        END)::information_schema.character_data AS routine_type,
    (NULL::name)::information_schema.sql_identifier AS module_catalog,
    (NULL::name)::information_schema.sql_identifier AS module_schema,
    (NULL::name)::information_schema.sql_identifier AS module_name,
    (NULL::name)::information_schema.sql_identifier AS udt_catalog,
    (NULL::name)::information_schema.sql_identifier AS udt_schema,
    (NULL::name)::information_schema.sql_identifier AS udt_name,
    (
        CASE
            WHEN (p.prokind = 'p'::"char") THEN NULL::text
            WHEN ((t.typelem <> (0)::oid) AND (t.typlen = '-1'::integer)) THEN 'ARRAY'::text
            WHEN (nt.nspname = 'pg_catalog'::name) THEN format_type(t.oid, NULL::integer)
            ELSE 'USER-DEFINED'::text
        END)::information_schema.character_data AS data_type,
    (NULL::integer)::information_schema.cardinal_number AS character_maximum_length,
    (NULL::integer)::information_schema.cardinal_number AS character_octet_length,
    (NULL::name)::information_schema.sql_identifier AS character_set_catalog,
    (NULL::name)::information_schema.sql_identifier AS character_set_schema,
    (NULL::name)::information_schema.sql_identifier AS character_set_name,
    (NULL::name)::information_schema.sql_identifier AS collation_catalog,
    (NULL::name)::information_schema.sql_identifier AS collation_schema,
    (NULL::name)::information_schema.sql_identifier AS collation_name,
    (NULL::integer)::information_schema.cardinal_number AS numeric_precision,
    (NULL::integer)::information_schema.cardinal_number AS numeric_precision_radix,
    (NULL::integer)::information_schema.cardinal_number AS numeric_scale,
    (NULL::integer)::information_schema.cardinal_number AS datetime_precision,
    (NULL::character varying)::information_schema.character_data AS interval_type,
    (NULL::integer)::information_schema.cardinal_number AS interval_precision,
    (
        CASE
            WHEN (nt.nspname IS NOT NULL) THEN current_database()
            ELSE NULL::name
        END)::information_schema.sql_identifier AS type_udt_catalog,
    (nt.nspname)::information_schema.sql_identifier AS type_udt_schema,
    (t.typname)::information_schema.sql_identifier AS type_udt_name,
    (NULL::name)::information_schema.sql_identifier AS scope_catalog,
    (NULL::name)::information_schema.sql_identifier AS scope_schema,
    (NULL::name)::information_schema.sql_identifier AS scope_name,
    (NULL::integer)::information_schema.cardinal_number AS maximum_cardinality,
    (
        CASE
            WHEN (p.prokind <> 'p'::"char") THEN 0
            ELSE NULL::integer
        END)::information_schema.sql_identifier AS dtd_identifier,
    (
        CASE
            WHEN (l.lanname = 'sql'::name) THEN 'SQL'::text
            ELSE 'EXTERNAL'::text
        END)::information_schema.character_data AS routine_body,
    (
        CASE
            WHEN pg_has_role(p.proowner, 'USAGE'::text) THEN p.prosrc
            ELSE NULL::text
        END)::information_schema.character_data AS routine_definition,
    (
        CASE
            WHEN (l.lanname = 'c'::name) THEN p.prosrc
            ELSE NULL::text
        END)::information_schema.character_data AS external_name,
    (upper((l.lanname)::text))::information_schema.character_data AS external_language,
    ('GENERAL'::character varying)::information_schema.character_data AS parameter_style,
    (
        CASE
            WHEN (p.provolatile = 'i'::"char") THEN 'YES'::text
            ELSE 'NO'::text
        END)::information_schema.yes_or_no AS is_deterministic,
    ('MODIFIES'::character varying)::information_schema.character_data AS sql_data_access,
    (
        CASE
            WHEN (p.prokind <> 'p'::"char") THEN
            CASE
                WHEN p.proisstrict THEN 'YES'::text
                ELSE 'NO'::text
            END
            ELSE NULL::text
        END)::information_schema.yes_or_no AS is_null_call,
    (NULL::character varying)::information_schema.character_data AS sql_path,
    ('YES'::character varying)::information_schema.yes_or_no AS schema_level_routine,
    (0)::information_schema.cardinal_number AS max_dynamic_result_sets,
    (NULL::character varying)::information_schema.yes_or_no AS is_user_defined_cast,
    (NULL::character varying)::information_schema.yes_or_no AS is_implicitly_invocable,
    (
        CASE
            WHEN p.prosecdef THEN 'DEFINER'::text
            ELSE 'INVOKER'::text
        END)::information_schema.character_data AS security_type,
    (NULL::name)::information_schema.sql_identifier AS to_sql_specific_catalog,
    (NULL::name)::information_schema.sql_identifier AS to_sql_specific_schema,
    (NULL::name)::information_schema.sql_identifier AS to_sql_specific_name,
    ('NO'::character varying)::information_schema.yes_or_no AS as_locator,
    (NULL::timestamp with time zone)::information_schema.time_stamp AS created,
    (NULL::timestamp with time zone)::information_schema.time_stamp AS last_altered,
    (NULL::character varying)::information_schema.yes_or_no AS new_savepoint_level,
    ('NO'::character varying)::information_schema.yes_or_no AS is_udt_dependent,
    (NULL::character varying)::information_schema.character_data AS result_cast_from_data_type,
    (NULL::character varying)::information_schema.yes_or_no AS result_cast_as_locator,
    (NULL::integer)::information_schema.cardinal_number AS result_cast_char_max_length,
    (NULL::integer)::information_schema.cardinal_number AS result_cast_char_octet_length,
    (NULL::name)::information_schema.sql_identifier AS result_cast_char_set_catalog,
    (NULL::name)::information_schema.sql_identifier AS result_cast_char_set_schema,
    (NULL::name)::information_schema.sql_identifier AS result_cast_char_set_name,
    (NULL::name)::information_schema.sql_identifier AS result_cast_collation_catalog,
    (NULL::name)::information_schema.sql_identifier AS result_cast_collation_schema,
    (NULL::name)::information_schema.sql_identifier AS result_cast_collation_name,
    (NULL::integer)::information_schema.cardinal_number AS result_cast_numeric_precision,
    (NULL::integer)::information_schema.cardinal_number AS result_cast_numeric_precision_radix,
    (NULL::integer)::information_schema.cardinal_number AS result_cast_numeric_scale,
    (NULL::integer)::information_schema.cardinal_number AS result_cast_datetime_precision,
    (NULL::character varying)::information_schema.character_data AS result_cast_interval_type,
    (NULL::integer)::information_schema.cardinal_number AS result_cast_interval_precision,
    (NULL::name)::information_schema.sql_identifier AS result_cast_type_udt_catalog,
    (NULL::name)::information_schema.sql_identifier AS result_cast_type_udt_schema,
    (NULL::name)::information_schema.sql_identifier AS result_cast_type_udt_name,
    (NULL::name)::information_schema.sql_identifier AS result_cast_scope_catalog,
    (NULL::name)::information_schema.sql_identifier AS result_cast_scope_schema,
    (NULL::name)::information_schema.sql_identifier AS result_cast_scope_name,
    (NULL::integer)::information_schema.cardinal_number AS result_cast_maximum_cardinality,
    (NULL::name)::information_schema.sql_identifier AS result_cast_dtd_identifier
   FROM (((pg_namespace n
     JOIN pg_proc p ON ((n.oid = p.pronamespace)))
     JOIN pg_language l ON ((p.prolang = l.oid)))
     LEFT JOIN (pg_type t
     JOIN pg_namespace nt ON ((t.typnamespace = nt.oid))) ON (((p.prorettype = t.oid) AND (p.prokind <> 'p'::"char"))))
  WHERE (pg_has_role(p.proowner, 'USAGE'::text) OR has_function_privilege(p.oid, 'EXECUTE'::text));


ALTER TABLE information_schema.routines OWNER TO postgres;

--
-- Name: data_type_privileges; Type: VIEW; Schema: information_schema; Owner: postgres
--

CREATE VIEW information_schema.data_type_privileges AS
 SELECT (current_database())::information_schema.sql_identifier AS object_catalog,
    x.objschema AS object_schema,
    x.objname AS object_name,
    (x.objtype)::information_schema.character_data AS object_type,
    x.objdtdid AS dtd_identifier
   FROM ( SELECT attributes.udt_schema,
            attributes.udt_name,
            'USER-DEFINED TYPE'::text AS text,
            attributes.dtd_identifier
           FROM information_schema.attributes
        UNION ALL
         SELECT columns.table_schema,
            columns.table_name,
            'TABLE'::text AS text,
            columns.dtd_identifier
           FROM information_schema.columns
        UNION ALL
         SELECT domains.domain_schema,
            domains.domain_name,
            'DOMAIN'::text AS text,
            domains.dtd_identifier
           FROM information_schema.domains
        UNION ALL
         SELECT parameters.specific_schema,
            parameters.specific_name,
            'ROUTINE'::text AS text,
            parameters.dtd_identifier
           FROM information_schema.parameters
        UNION ALL
         SELECT routines.specific_schema,
            routines.specific_name,
            'ROUTINE'::text AS text,
            routines.dtd_identifier
           FROM information_schema.routines) x(objschema, objname, objtype, objdtdid);


ALTER TABLE information_schema.data_type_privileges OWNER TO postgres;

--
-- Name: domain_constraints; Type: VIEW; Schema: information_schema; Owner: postgres
--

CREATE VIEW information_schema.domain_constraints AS
 SELECT (current_database())::information_schema.sql_identifier AS constraint_catalog,
    (rs.nspname)::information_schema.sql_identifier AS constraint_schema,
    (con.conname)::information_schema.sql_identifier AS constraint_name,
    (current_database())::information_schema.sql_identifier AS domain_catalog,
    (n.nspname)::information_schema.sql_identifier AS domain_schema,
    (t.typname)::information_schema.sql_identifier AS domain_name,
    (
        CASE
            WHEN con.condeferrable THEN 'YES'::text
            ELSE 'NO'::text
        END)::information_schema.yes_or_no AS is_deferrable,
    (
        CASE
            WHEN con.condeferred THEN 'YES'::text
            ELSE 'NO'::text
        END)::information_schema.yes_or_no AS initially_deferred
   FROM pg_namespace rs,
    pg_namespace n,
    pg_constraint con,
    pg_type t
  WHERE ((rs.oid = con.connamespace) AND (n.oid = t.typnamespace) AND (t.oid = con.contypid) AND (pg_has_role(t.typowner, 'USAGE'::text) OR has_type_privilege(t.oid, 'USAGE'::text)));


ALTER TABLE information_schema.domain_constraints OWNER TO postgres;

--
-- Name: domain_udt_usage; Type: VIEW; Schema: information_schema; Owner: postgres
--

CREATE VIEW information_schema.domain_udt_usage AS
 SELECT (current_database())::information_schema.sql_identifier AS udt_catalog,
    (nbt.nspname)::information_schema.sql_identifier AS udt_schema,
    (bt.typname)::information_schema.sql_identifier AS udt_name,
    (current_database())::information_schema.sql_identifier AS domain_catalog,
    (nt.nspname)::information_schema.sql_identifier AS domain_schema,
    (t.typname)::information_schema.sql_identifier AS domain_name
   FROM pg_type t,
    pg_namespace nt,
    pg_type bt,
    pg_namespace nbt
  WHERE ((t.typnamespace = nt.oid) AND (t.typbasetype = bt.oid) AND (bt.typnamespace = nbt.oid) AND (t.typtype = 'd'::"char") AND pg_has_role(bt.typowner, 'USAGE'::text));


ALTER TABLE information_schema.domain_udt_usage OWNER TO postgres;

--
-- Name: element_types; Type: VIEW; Schema: information_schema; Owner: postgres
--

CREATE VIEW information_schema.element_types AS
 SELECT (current_database())::information_schema.sql_identifier AS object_catalog,
    (n.nspname)::information_schema.sql_identifier AS object_schema,
    x.objname AS object_name,
    (x.objtype)::information_schema.character_data AS object_type,
    (x.objdtdid)::information_schema.sql_identifier AS collection_type_identifier,
    (
        CASE
            WHEN (nbt.nspname = 'pg_catalog'::name) THEN format_type(bt.oid, NULL::integer)
            ELSE 'USER-DEFINED'::text
        END)::information_schema.character_data AS data_type,
    (NULL::integer)::information_schema.cardinal_number AS character_maximum_length,
    (NULL::integer)::information_schema.cardinal_number AS character_octet_length,
    (NULL::name)::information_schema.sql_identifier AS character_set_catalog,
    (NULL::name)::information_schema.sql_identifier AS character_set_schema,
    (NULL::name)::information_schema.sql_identifier AS character_set_name,
    (
        CASE
            WHEN (nco.nspname IS NOT NULL) THEN current_database()
            ELSE NULL::name
        END)::information_schema.sql_identifier AS collation_catalog,
    (nco.nspname)::information_schema.sql_identifier AS collation_schema,
    (co.collname)::information_schema.sql_identifier AS collation_name,
    (NULL::integer)::information_schema.cardinal_number AS numeric_precision,
    (NULL::integer)::information_schema.cardinal_number AS numeric_precision_radix,
    (NULL::integer)::information_schema.cardinal_number AS numeric_scale,
    (NULL::integer)::information_schema.cardinal_number AS datetime_precision,
    (NULL::character varying)::information_schema.character_data AS interval_type,
    (NULL::integer)::information_schema.cardinal_number AS interval_precision,
    (NULL::character varying)::information_schema.character_data AS domain_default,
    (current_database())::information_schema.sql_identifier AS udt_catalog,
    (nbt.nspname)::information_schema.sql_identifier AS udt_schema,
    (bt.typname)::information_schema.sql_identifier AS udt_name,
    (NULL::name)::information_schema.sql_identifier AS scope_catalog,
    (NULL::name)::information_schema.sql_identifier AS scope_schema,
    (NULL::name)::information_schema.sql_identifier AS scope_name,
    (NULL::integer)::information_schema.cardinal_number AS maximum_cardinality,
    (('a'::text || (x.objdtdid)::text))::information_schema.sql_identifier AS dtd_identifier
   FROM pg_namespace n,
    pg_type at,
    pg_namespace nbt,
    pg_type bt,
    (( SELECT c.relnamespace,
            (c.relname)::information_schema.sql_identifier AS relname,
                CASE
                    WHEN (c.relkind = 'c'::"char") THEN 'USER-DEFINED TYPE'::text
                    ELSE 'TABLE'::text
                END AS "case",
            a.attnum,
            a.atttypid,
            a.attcollation
           FROM pg_class c,
            pg_attribute a
          WHERE ((c.oid = a.attrelid) AND (c.relkind = ANY (ARRAY['r'::"char", 'v'::"char", 'f'::"char", 'c'::"char", 'p'::"char"])) AND (a.attnum > 0) AND (NOT a.attisdropped))
        UNION ALL
         SELECT t.typnamespace,
            (t.typname)::information_schema.sql_identifier AS typname,
            'DOMAIN'::text AS text,
            1,
            t.typbasetype,
            t.typcollation
           FROM pg_type t
          WHERE (t.typtype = 'd'::"char")
        UNION ALL
         SELECT ss.pronamespace,
            (nameconcatoid(ss.proname, ss.oid))::information_schema.sql_identifier AS nameconcatoid,
            'ROUTINE'::text AS text,
            (ss.x).n AS n,
            (ss.x).x AS x,
            0
           FROM ( SELECT p.pronamespace,
                    p.proname,
                    p.oid,
                    information_schema._pg_expandarray(COALESCE(p.proallargtypes, (p.proargtypes)::oid[])) AS x
                   FROM pg_proc p) ss
        UNION ALL
         SELECT p.pronamespace,
            (nameconcatoid(p.proname, p.oid))::information_schema.sql_identifier AS nameconcatoid,
            'ROUTINE'::text AS text,
            0,
            p.prorettype,
            0
           FROM pg_proc p) x(objschema, objname, objtype, objdtdid, objtypeid, objcollation)
     LEFT JOIN (pg_collation co
     JOIN pg_namespace nco ON ((co.collnamespace = nco.oid))) ON (((x.objcollation = co.oid) AND ((nco.nspname <> 'pg_catalog'::name) OR (co.collname <> 'default'::name)))))
  WHERE ((n.oid = x.objschema) AND (at.oid = x.objtypeid) AND ((at.typelem <> (0)::oid) AND (at.typlen = '-1'::integer)) AND (at.typelem = bt.oid) AND (nbt.oid = bt.typnamespace) AND ((n.nspname, (x.objname)::name, x.objtype, ((x.objdtdid)::information_schema.sql_identifier)::name) IN ( SELECT data_type_privileges.object_schema,
            data_type_privileges.object_name,
            data_type_privileges.object_type,
            data_type_privileges.dtd_identifier
           FROM information_schema.data_type_privileges)));


ALTER TABLE information_schema.element_types OWNER TO postgres;

--
-- Name: enabled_roles; Type: VIEW; Schema: information_schema; Owner: postgres
--

CREATE VIEW information_schema.enabled_roles AS
 SELECT (a.rolname)::information_schema.sql_identifier AS role_name
   FROM pg_authid a
  WHERE pg_has_role(a.oid, 'USAGE'::text);


ALTER TABLE information_schema.enabled_roles OWNER TO postgres;

--
-- Name: foreign_data_wrapper_options; Type: VIEW; Schema: information_schema; Owner: postgres
--

CREATE VIEW information_schema.foreign_data_wrapper_options AS
 SELECT w.foreign_data_wrapper_catalog,
    w.foreign_data_wrapper_name,
    ((pg_options_to_table(w.fdwoptions)).option_name)::information_schema.sql_identifier AS option_name,
    ((pg_options_to_table(w.fdwoptions)).option_value)::information_schema.character_data AS option_value
   FROM information_schema._pg_foreign_data_wrappers w;


ALTER TABLE information_schema.foreign_data_wrapper_options OWNER TO postgres;

--
-- Name: foreign_data_wrappers; Type: VIEW; Schema: information_schema; Owner: postgres
--

CREATE VIEW information_schema.foreign_data_wrappers AS
 SELECT w.foreign_data_wrapper_catalog,
    w.foreign_data_wrapper_name,
    w.authorization_identifier,
    (NULL::character varying)::information_schema.character_data AS library_name,
    w.foreign_data_wrapper_language
   FROM information_schema._pg_foreign_data_wrappers w;


ALTER TABLE information_schema.foreign_data_wrappers OWNER TO postgres;

--
-- Name: foreign_server_options; Type: VIEW; Schema: information_schema; Owner: postgres
--

CREATE VIEW information_schema.foreign_server_options AS
 SELECT s.foreign_server_catalog,
    s.foreign_server_name,
    ((pg_options_to_table(s.srvoptions)).option_name)::information_schema.sql_identifier AS option_name,
    ((pg_options_to_table(s.srvoptions)).option_value)::information_schema.character_data AS option_value
   FROM information_schema._pg_foreign_servers s;


ALTER TABLE information_schema.foreign_server_options OWNER TO postgres;

--
-- Name: foreign_servers; Type: VIEW; Schema: information_schema; Owner: postgres
--

CREATE VIEW information_schema.foreign_servers AS
 SELECT _pg_foreign_servers.foreign_server_catalog,
    _pg_foreign_servers.foreign_server_name,
    _pg_foreign_servers.foreign_data_wrapper_catalog,
    _pg_foreign_servers.foreign_data_wrapper_name,
    _pg_foreign_servers.foreign_server_type,
    _pg_foreign_servers.foreign_server_version,
    _pg_foreign_servers.authorization_identifier
   FROM information_schema._pg_foreign_servers;


ALTER TABLE information_schema.foreign_servers OWNER TO postgres;

--
-- Name: foreign_table_options; Type: VIEW; Schema: information_schema; Owner: postgres
--

CREATE VIEW information_schema.foreign_table_options AS
 SELECT t.foreign_table_catalog,
    t.foreign_table_schema,
    t.foreign_table_name,
    ((pg_options_to_table(t.ftoptions)).option_name)::information_schema.sql_identifier AS option_name,
    ((pg_options_to_table(t.ftoptions)).option_value)::information_schema.character_data AS option_value
   FROM information_schema._pg_foreign_tables t;


ALTER TABLE information_schema.foreign_table_options OWNER TO postgres;

--
-- Name: foreign_tables; Type: VIEW; Schema: information_schema; Owner: postgres
--

CREATE VIEW information_schema.foreign_tables AS
 SELECT _pg_foreign_tables.foreign_table_catalog,
    _pg_foreign_tables.foreign_table_schema,
    _pg_foreign_tables.foreign_table_name,
    _pg_foreign_tables.foreign_server_catalog,
    _pg_foreign_tables.foreign_server_name
   FROM information_schema._pg_foreign_tables;


ALTER TABLE information_schema.foreign_tables OWNER TO postgres;

--
-- Name: information_schema_catalog_name; Type: VIEW; Schema: information_schema; Owner: postgres
--

CREATE VIEW information_schema.information_schema_catalog_name AS
 SELECT (current_database())::information_schema.sql_identifier AS catalog_name;


ALTER TABLE information_schema.information_schema_catalog_name OWNER TO postgres;

--
-- Name: key_column_usage; Type: VIEW; Schema: information_schema; Owner: postgres
--

CREATE VIEW information_schema.key_column_usage AS
 SELECT (current_database())::information_schema.sql_identifier AS constraint_catalog,
    (ss.nc_nspname)::information_schema.sql_identifier AS constraint_schema,
    (ss.conname)::information_schema.sql_identifier AS constraint_name,
    (current_database())::information_schema.sql_identifier AS table_catalog,
    (ss.nr_nspname)::information_schema.sql_identifier AS table_schema,
    (ss.relname)::information_schema.sql_identifier AS table_name,
    (a.attname)::information_schema.sql_identifier AS column_name,
    ((ss.x).n)::information_schema.cardinal_number AS ordinal_position,
    (
        CASE
            WHEN (ss.contype = 'f'::"char") THEN information_schema._pg_index_position(ss.conindid, ss.confkey[(ss.x).n])
            ELSE NULL::integer
        END)::information_schema.cardinal_number AS position_in_unique_constraint
   FROM pg_attribute a,
    ( SELECT r.oid AS roid,
            r.relname,
            r.relowner,
            nc.nspname AS nc_nspname,
            nr.nspname AS nr_nspname,
            c.oid AS coid,
            c.conname,
            c.contype,
            c.conindid,
            c.confkey,
            c.confrelid,
            information_schema._pg_expandarray(c.conkey) AS x
           FROM pg_namespace nr,
            pg_class r,
            pg_namespace nc,
            pg_constraint c
          WHERE ((nr.oid = r.relnamespace) AND (r.oid = c.conrelid) AND (nc.oid = c.connamespace) AND (c.contype = ANY (ARRAY['p'::"char", 'u'::"char", 'f'::"char"])) AND (r.relkind = ANY (ARRAY['r'::"char", 'p'::"char"])) AND (NOT pg_is_other_temp_schema(nr.oid)))) ss
  WHERE ((ss.roid = a.attrelid) AND (a.attnum = (ss.x).x) AND (NOT a.attisdropped) AND (pg_has_role(ss.relowner, 'USAGE'::text) OR has_column_privilege(ss.roid, a.attnum, 'SELECT, INSERT, UPDATE, REFERENCES'::text)));


ALTER TABLE information_schema.key_column_usage OWNER TO postgres;

--
-- Name: referential_constraints; Type: VIEW; Schema: information_schema; Owner: postgres
--

CREATE VIEW information_schema.referential_constraints AS
 SELECT (current_database())::information_schema.sql_identifier AS constraint_catalog,
    (ncon.nspname)::information_schema.sql_identifier AS constraint_schema,
    (con.conname)::information_schema.sql_identifier AS constraint_name,
    (
        CASE
            WHEN (npkc.nspname IS NULL) THEN NULL::name
            ELSE current_database()
        END)::information_schema.sql_identifier AS unique_constraint_catalog,
    (npkc.nspname)::information_schema.sql_identifier AS unique_constraint_schema,
    (pkc.conname)::information_schema.sql_identifier AS unique_constraint_name,
    (
        CASE con.confmatchtype
            WHEN 'f'::"char" THEN 'FULL'::text
            WHEN 'p'::"char" THEN 'PARTIAL'::text
            WHEN 's'::"char" THEN 'NONE'::text
            ELSE NULL::text
        END)::information_schema.character_data AS match_option,
    (
        CASE con.confupdtype
            WHEN 'c'::"char" THEN 'CASCADE'::text
            WHEN 'n'::"char" THEN 'SET NULL'::text
            WHEN 'd'::"char" THEN 'SET DEFAULT'::text
            WHEN 'r'::"char" THEN 'RESTRICT'::text
            WHEN 'a'::"char" THEN 'NO ACTION'::text
            ELSE NULL::text
        END)::information_schema.character_data AS update_rule,
    (
        CASE con.confdeltype
            WHEN 'c'::"char" THEN 'CASCADE'::text
            WHEN 'n'::"char" THEN 'SET NULL'::text
            WHEN 'd'::"char" THEN 'SET DEFAULT'::text
            WHEN 'r'::"char" THEN 'RESTRICT'::text
            WHEN 'a'::"char" THEN 'NO ACTION'::text
            ELSE NULL::text
        END)::information_schema.character_data AS delete_rule
   FROM ((((((pg_namespace ncon
     JOIN pg_constraint con ON ((ncon.oid = con.connamespace)))
     JOIN pg_class c ON (((con.conrelid = c.oid) AND (con.contype = 'f'::"char"))))
     LEFT JOIN pg_depend d1 ON (((d1.objid = con.oid) AND (d1.classid = ('pg_constraint'::regclass)::oid) AND (d1.refclassid = ('pg_class'::regclass)::oid) AND (d1.refobjsubid = 0))))
     LEFT JOIN pg_depend d2 ON (((d2.refclassid = ('pg_constraint'::regclass)::oid) AND (d2.classid = ('pg_class'::regclass)::oid) AND (d2.objid = d1.refobjid) AND (d2.objsubid = 0) AND (d2.deptype = 'i'::"char"))))
     LEFT JOIN pg_constraint pkc ON (((pkc.oid = d2.refobjid) AND (pkc.contype = ANY (ARRAY['p'::"char", 'u'::"char"])) AND (pkc.conrelid = con.confrelid))))
     LEFT JOIN pg_namespace npkc ON ((pkc.connamespace = npkc.oid)))
  WHERE (pg_has_role(c.relowner, 'USAGE'::text) OR has_table_privilege(c.oid, 'INSERT, UPDATE, DELETE, TRUNCATE, REFERENCES, TRIGGER'::text) OR has_any_column_privilege(c.oid, 'INSERT, UPDATE, REFERENCES'::text));


ALTER TABLE information_schema.referential_constraints OWNER TO postgres;

--
-- Name: role_column_grants; Type: VIEW; Schema: information_schema; Owner: postgres
--

CREATE VIEW information_schema.role_column_grants AS
 SELECT column_privileges.grantor,
    column_privileges.grantee,
    column_privileges.table_catalog,
    column_privileges.table_schema,
    column_privileges.table_name,
    column_privileges.column_name,
    column_privileges.privilege_type,
    column_privileges.is_grantable
   FROM information_schema.column_privileges
  WHERE (((column_privileges.grantor)::name IN ( SELECT enabled_roles.role_name
           FROM information_schema.enabled_roles)) OR ((column_privileges.grantee)::name IN ( SELECT enabled_roles.role_name
           FROM information_schema.enabled_roles)));


ALTER TABLE information_schema.role_column_grants OWNER TO postgres;

--
-- Name: routine_privileges; Type: VIEW; Schema: information_schema; Owner: postgres
--

CREATE VIEW information_schema.routine_privileges AS
 SELECT (u_grantor.rolname)::information_schema.sql_identifier AS grantor,
    (grantee.rolname)::information_schema.sql_identifier AS grantee,
    (current_database())::information_schema.sql_identifier AS specific_catalog,
    (n.nspname)::information_schema.sql_identifier AS specific_schema,
    (nameconcatoid(p.proname, p.oid))::information_schema.sql_identifier AS specific_name,
    (current_database())::information_schema.sql_identifier AS routine_catalog,
    (n.nspname)::information_schema.sql_identifier AS routine_schema,
    (p.proname)::information_schema.sql_identifier AS routine_name,
    ('EXECUTE'::character varying)::information_schema.character_data AS privilege_type,
    (
        CASE
            WHEN (pg_has_role(grantee.oid, p.proowner, 'USAGE'::text) OR p.grantable) THEN 'YES'::text
            ELSE 'NO'::text
        END)::information_schema.yes_or_no AS is_grantable
   FROM ( SELECT pg_proc.oid,
            pg_proc.proname,
            pg_proc.proowner,
            pg_proc.pronamespace,
            (aclexplode(COALESCE(pg_proc.proacl, acldefault('f'::"char", pg_proc.proowner)))).grantor AS grantor,
            (aclexplode(COALESCE(pg_proc.proacl, acldefault('f'::"char", pg_proc.proowner)))).grantee AS grantee,
            (aclexplode(COALESCE(pg_proc.proacl, acldefault('f'::"char", pg_proc.proowner)))).privilege_type AS privilege_type,
            (aclexplode(COALESCE(pg_proc.proacl, acldefault('f'::"char", pg_proc.proowner)))).is_grantable AS is_grantable
           FROM pg_proc) p(oid, proname, proowner, pronamespace, grantor, grantee, prtype, grantable),
    pg_namespace n,
    pg_authid u_grantor,
    ( SELECT pg_authid.oid,
            pg_authid.rolname
           FROM pg_authid
        UNION ALL
         SELECT (0)::oid AS oid,
            'PUBLIC'::name) grantee(oid, rolname)
  WHERE ((p.pronamespace = n.oid) AND (grantee.oid = p.grantee) AND (u_grantor.oid = p.grantor) AND (p.prtype = 'EXECUTE'::text) AND (pg_has_role(u_grantor.oid, 'USAGE'::text) OR pg_has_role(grantee.oid, 'USAGE'::text) OR (grantee.rolname = 'PUBLIC'::name)));


ALTER TABLE information_schema.routine_privileges OWNER TO postgres;

--
-- Name: role_routine_grants; Type: VIEW; Schema: information_schema; Owner: postgres
--

CREATE VIEW information_schema.role_routine_grants AS
 SELECT routine_privileges.grantor,
    routine_privileges.grantee,
    routine_privileges.specific_catalog,
    routine_privileges.specific_schema,
    routine_privileges.specific_name,
    routine_privileges.routine_catalog,
    routine_privileges.routine_schema,
    routine_privileges.routine_name,
    routine_privileges.privilege_type,
    routine_privileges.is_grantable
   FROM information_schema.routine_privileges
  WHERE (((routine_privileges.grantor)::name IN ( SELECT enabled_roles.role_name
           FROM information_schema.enabled_roles)) OR ((routine_privileges.grantee)::name IN ( SELECT enabled_roles.role_name
           FROM information_schema.enabled_roles)));


ALTER TABLE information_schema.role_routine_grants OWNER TO postgres;

--
-- Name: table_privileges; Type: VIEW; Schema: information_schema; Owner: postgres
--

CREATE VIEW information_schema.table_privileges AS
 SELECT (u_grantor.rolname)::information_schema.sql_identifier AS grantor,
    (grantee.rolname)::information_schema.sql_identifier AS grantee,
    (current_database())::information_schema.sql_identifier AS table_catalog,
    (nc.nspname)::information_schema.sql_identifier AS table_schema,
    (c.relname)::information_schema.sql_identifier AS table_name,
    (c.prtype)::information_schema.character_data AS privilege_type,
    (
        CASE
            WHEN (pg_has_role(grantee.oid, c.relowner, 'USAGE'::text) OR c.grantable) THEN 'YES'::text
            ELSE 'NO'::text
        END)::information_schema.yes_or_no AS is_grantable,
    (
        CASE
            WHEN (c.prtype = 'SELECT'::text) THEN 'YES'::text
            ELSE 'NO'::text
        END)::information_schema.yes_or_no AS with_hierarchy
   FROM ( SELECT pg_class.oid,
            pg_class.relname,
            pg_class.relnamespace,
            pg_class.relkind,
            pg_class.relowner,
            (aclexplode(COALESCE(pg_class.relacl, acldefault('r'::"char", pg_class.relowner)))).grantor AS grantor,
            (aclexplode(COALESCE(pg_class.relacl, acldefault('r'::"char", pg_class.relowner)))).grantee AS grantee,
            (aclexplode(COALESCE(pg_class.relacl, acldefault('r'::"char", pg_class.relowner)))).privilege_type AS privilege_type,
            (aclexplode(COALESCE(pg_class.relacl, acldefault('r'::"char", pg_class.relowner)))).is_grantable AS is_grantable
           FROM pg_class) c(oid, relname, relnamespace, relkind, relowner, grantor, grantee, prtype, grantable),
    pg_namespace nc,
    pg_authid u_grantor,
    ( SELECT pg_authid.oid,
            pg_authid.rolname
           FROM pg_authid
        UNION ALL
         SELECT (0)::oid AS oid,
            'PUBLIC'::name) grantee(oid, rolname)
  WHERE ((c.relnamespace = nc.oid) AND (c.relkind = ANY (ARRAY['r'::"char", 'v'::"char", 'f'::"char", 'p'::"char"])) AND (c.grantee = grantee.oid) AND (c.grantor = u_grantor.oid) AND (c.prtype = ANY (ARRAY['INSERT'::text, 'SELECT'::text, 'UPDATE'::text, 'DELETE'::text, 'TRUNCATE'::text, 'REFERENCES'::text, 'TRIGGER'::text])) AND (pg_has_role(u_grantor.oid, 'USAGE'::text) OR pg_has_role(grantee.oid, 'USAGE'::text) OR (grantee.rolname = 'PUBLIC'::name)));


ALTER TABLE information_schema.table_privileges OWNER TO postgres;

--
-- Name: role_table_grants; Type: VIEW; Schema: information_schema; Owner: postgres
--

CREATE VIEW information_schema.role_table_grants AS
 SELECT table_privileges.grantor,
    table_privileges.grantee,
    table_privileges.table_catalog,
    table_privileges.table_schema,
    table_privileges.table_name,
    table_privileges.privilege_type,
    table_privileges.is_grantable,
    table_privileges.with_hierarchy
   FROM information_schema.table_privileges
  WHERE (((table_privileges.grantor)::name IN ( SELECT enabled_roles.role_name
           FROM information_schema.enabled_roles)) OR ((table_privileges.grantee)::name IN ( SELECT enabled_roles.role_name
           FROM information_schema.enabled_roles)));


ALTER TABLE information_schema.role_table_grants OWNER TO postgres;

--
-- Name: udt_privileges; Type: VIEW; Schema: information_schema; Owner: postgres
--

CREATE VIEW information_schema.udt_privileges AS
 SELECT (u_grantor.rolname)::information_schema.sql_identifier AS grantor,
    (grantee.rolname)::information_schema.sql_identifier AS grantee,
    (current_database())::information_schema.sql_identifier AS udt_catalog,
    (n.nspname)::information_schema.sql_identifier AS udt_schema,
    (t.typname)::information_schema.sql_identifier AS udt_name,
    ('TYPE USAGE'::character varying)::information_schema.character_data AS privilege_type,
    (
        CASE
            WHEN (pg_has_role(grantee.oid, t.typowner, 'USAGE'::text) OR t.grantable) THEN 'YES'::text
            ELSE 'NO'::text
        END)::information_schema.yes_or_no AS is_grantable
   FROM ( SELECT pg_type.oid,
            pg_type.typname,
            pg_type.typnamespace,
            pg_type.typtype,
            pg_type.typowner,
            (aclexplode(COALESCE(pg_type.typacl, acldefault('T'::"char", pg_type.typowner)))).grantor AS grantor,
            (aclexplode(COALESCE(pg_type.typacl, acldefault('T'::"char", pg_type.typowner)))).grantee AS grantee,
            (aclexplode(COALESCE(pg_type.typacl, acldefault('T'::"char", pg_type.typowner)))).privilege_type AS privilege_type,
            (aclexplode(COALESCE(pg_type.typacl, acldefault('T'::"char", pg_type.typowner)))).is_grantable AS is_grantable
           FROM pg_type) t(oid, typname, typnamespace, typtype, typowner, grantor, grantee, prtype, grantable),
    pg_namespace n,
    pg_authid u_grantor,
    ( SELECT pg_authid.oid,
            pg_authid.rolname
           FROM pg_authid
        UNION ALL
         SELECT (0)::oid AS oid,
            'PUBLIC'::name) grantee(oid, rolname)
  WHERE ((t.typnamespace = n.oid) AND (t.typtype = 'c'::"char") AND (t.grantee = grantee.oid) AND (t.grantor = u_grantor.oid) AND (t.prtype = 'USAGE'::text) AND (pg_has_role(u_grantor.oid, 'USAGE'::text) OR pg_has_role(grantee.oid, 'USAGE'::text) OR (grantee.rolname = 'PUBLIC'::name)));


ALTER TABLE information_schema.udt_privileges OWNER TO postgres;

--
-- Name: role_udt_grants; Type: VIEW; Schema: information_schema; Owner: postgres
--

CREATE VIEW information_schema.role_udt_grants AS
 SELECT udt_privileges.grantor,
    udt_privileges.grantee,
    udt_privileges.udt_catalog,
    udt_privileges.udt_schema,
    udt_privileges.udt_name,
    udt_privileges.privilege_type,
    udt_privileges.is_grantable
   FROM information_schema.udt_privileges
  WHERE (((udt_privileges.grantor)::name IN ( SELECT enabled_roles.role_name
           FROM information_schema.enabled_roles)) OR ((udt_privileges.grantee)::name IN ( SELECT enabled_roles.role_name
           FROM information_schema.enabled_roles)));


ALTER TABLE information_schema.role_udt_grants OWNER TO postgres;

--
-- Name: usage_privileges; Type: VIEW; Schema: information_schema; Owner: postgres
--

CREATE VIEW information_schema.usage_privileges AS
 SELECT (u.rolname)::information_schema.sql_identifier AS grantor,
    ('PUBLIC'::name)::information_schema.sql_identifier AS grantee,
    (current_database())::information_schema.sql_identifier AS object_catalog,
    (n.nspname)::information_schema.sql_identifier AS object_schema,
    (c.collname)::information_schema.sql_identifier AS object_name,
    ('COLLATION'::character varying)::information_schema.character_data AS object_type,
    ('USAGE'::character varying)::information_schema.character_data AS privilege_type,
    ('NO'::character varying)::information_schema.yes_or_no AS is_grantable
   FROM pg_authid u,
    pg_namespace n,
    pg_collation c
  WHERE ((u.oid = c.collowner) AND (c.collnamespace = n.oid) AND (c.collencoding = ANY (ARRAY['-1'::integer, ( SELECT pg_database.encoding
           FROM pg_database
          WHERE (pg_database.datname = current_database()))])))
UNION ALL
 SELECT (u_grantor.rolname)::information_schema.sql_identifier AS grantor,
    (grantee.rolname)::information_schema.sql_identifier AS grantee,
    (current_database())::information_schema.sql_identifier AS object_catalog,
    (n.nspname)::information_schema.sql_identifier AS object_schema,
    (t.typname)::information_schema.sql_identifier AS object_name,
    ('DOMAIN'::character varying)::information_schema.character_data AS object_type,
    ('USAGE'::character varying)::information_schema.character_data AS privilege_type,
    (
        CASE
            WHEN (pg_has_role(grantee.oid, t.typowner, 'USAGE'::text) OR t.grantable) THEN 'YES'::text
            ELSE 'NO'::text
        END)::information_schema.yes_or_no AS is_grantable
   FROM ( SELECT pg_type.oid,
            pg_type.typname,
            pg_type.typnamespace,
            pg_type.typtype,
            pg_type.typowner,
            (aclexplode(COALESCE(pg_type.typacl, acldefault('T'::"char", pg_type.typowner)))).grantor AS grantor,
            (aclexplode(COALESCE(pg_type.typacl, acldefault('T'::"char", pg_type.typowner)))).grantee AS grantee,
            (aclexplode(COALESCE(pg_type.typacl, acldefault('T'::"char", pg_type.typowner)))).privilege_type AS privilege_type,
            (aclexplode(COALESCE(pg_type.typacl, acldefault('T'::"char", pg_type.typowner)))).is_grantable AS is_grantable
           FROM pg_type) t(oid, typname, typnamespace, typtype, typowner, grantor, grantee, prtype, grantable),
    pg_namespace n,
    pg_authid u_grantor,
    ( SELECT pg_authid.oid,
            pg_authid.rolname
           FROM pg_authid
        UNION ALL
         SELECT (0)::oid AS oid,
            'PUBLIC'::name) grantee(oid, rolname)
  WHERE ((t.typnamespace = n.oid) AND (t.typtype = 'd'::"char") AND (t.grantee = grantee.oid) AND (t.grantor = u_grantor.oid) AND (t.prtype = 'USAGE'::text) AND (pg_has_role(u_grantor.oid, 'USAGE'::text) OR pg_has_role(grantee.oid, 'USAGE'::text) OR (grantee.rolname = 'PUBLIC'::name)))
UNION ALL
 SELECT (u_grantor.rolname)::information_schema.sql_identifier AS grantor,
    (grantee.rolname)::information_schema.sql_identifier AS grantee,
    (current_database())::information_schema.sql_identifier AS object_catalog,
    (''::name)::information_schema.sql_identifier AS object_schema,
    (fdw.fdwname)::information_schema.sql_identifier AS object_name,
    ('FOREIGN DATA WRAPPER'::character varying)::information_schema.character_data AS object_type,
    ('USAGE'::character varying)::information_schema.character_data AS privilege_type,
    (
        CASE
            WHEN (pg_has_role(grantee.oid, fdw.fdwowner, 'USAGE'::text) OR fdw.grantable) THEN 'YES'::text
            ELSE 'NO'::text
        END)::information_schema.yes_or_no AS is_grantable
   FROM ( SELECT pg_foreign_data_wrapper.fdwname,
            pg_foreign_data_wrapper.fdwowner,
            (aclexplode(COALESCE(pg_foreign_data_wrapper.fdwacl, acldefault('F'::"char", pg_foreign_data_wrapper.fdwowner)))).grantor AS grantor,
            (aclexplode(COALESCE(pg_foreign_data_wrapper.fdwacl, acldefault('F'::"char", pg_foreign_data_wrapper.fdwowner)))).grantee AS grantee,
            (aclexplode(COALESCE(pg_foreign_data_wrapper.fdwacl, acldefault('F'::"char", pg_foreign_data_wrapper.fdwowner)))).privilege_type AS privilege_type,
            (aclexplode(COALESCE(pg_foreign_data_wrapper.fdwacl, acldefault('F'::"char", pg_foreign_data_wrapper.fdwowner)))).is_grantable AS is_grantable
           FROM pg_foreign_data_wrapper) fdw(fdwname, fdwowner, grantor, grantee, prtype, grantable),
    pg_authid u_grantor,
    ( SELECT pg_authid.oid,
            pg_authid.rolname
           FROM pg_authid
        UNION ALL
         SELECT (0)::oid AS oid,
            'PUBLIC'::name) grantee(oid, rolname)
  WHERE ((u_grantor.oid = fdw.grantor) AND (grantee.oid = fdw.grantee) AND (fdw.prtype = 'USAGE'::text) AND (pg_has_role(u_grantor.oid, 'USAGE'::text) OR pg_has_role(grantee.oid, 'USAGE'::text) OR (grantee.rolname = 'PUBLIC'::name)))
UNION ALL
 SELECT (u_grantor.rolname)::information_schema.sql_identifier AS grantor,
    (grantee.rolname)::information_schema.sql_identifier AS grantee,
    (current_database())::information_schema.sql_identifier AS object_catalog,
    (''::name)::information_schema.sql_identifier AS object_schema,
    (srv.srvname)::information_schema.sql_identifier AS object_name,
    ('FOREIGN SERVER'::character varying)::information_schema.character_data AS object_type,
    ('USAGE'::character varying)::information_schema.character_data AS privilege_type,
    (
        CASE
            WHEN (pg_has_role(grantee.oid, srv.srvowner, 'USAGE'::text) OR srv.grantable) THEN 'YES'::text
            ELSE 'NO'::text
        END)::information_schema.yes_or_no AS is_grantable
   FROM ( SELECT pg_foreign_server.srvname,
            pg_foreign_server.srvowner,
            (aclexplode(COALESCE(pg_foreign_server.srvacl, acldefault('S'::"char", pg_foreign_server.srvowner)))).grantor AS grantor,
            (aclexplode(COALESCE(pg_foreign_server.srvacl, acldefault('S'::"char", pg_foreign_server.srvowner)))).grantee AS grantee,
            (aclexplode(COALESCE(pg_foreign_server.srvacl, acldefault('S'::"char", pg_foreign_server.srvowner)))).privilege_type AS privilege_type,
            (aclexplode(COALESCE(pg_foreign_server.srvacl, acldefault('S'::"char", pg_foreign_server.srvowner)))).is_grantable AS is_grantable
           FROM pg_foreign_server) srv(srvname, srvowner, grantor, grantee, prtype, grantable),
    pg_authid u_grantor,
    ( SELECT pg_authid.oid,
            pg_authid.rolname
           FROM pg_authid
        UNION ALL
         SELECT (0)::oid AS oid,
            'PUBLIC'::name) grantee(oid, rolname)
  WHERE ((u_grantor.oid = srv.grantor) AND (grantee.oid = srv.grantee) AND (srv.prtype = 'USAGE'::text) AND (pg_has_role(u_grantor.oid, 'USAGE'::text) OR pg_has_role(grantee.oid, 'USAGE'::text) OR (grantee.rolname = 'PUBLIC'::name)))
UNION ALL
 SELECT (u_grantor.rolname)::information_schema.sql_identifier AS grantor,
    (grantee.rolname)::information_schema.sql_identifier AS grantee,
    (current_database())::information_schema.sql_identifier AS object_catalog,
    (n.nspname)::information_schema.sql_identifier AS object_schema,
    (c.relname)::information_schema.sql_identifier AS object_name,
    ('SEQUENCE'::character varying)::information_schema.character_data AS object_type,
    ('USAGE'::character varying)::information_schema.character_data AS privilege_type,
    (
        CASE
            WHEN (pg_has_role(grantee.oid, c.relowner, 'USAGE'::text) OR c.grantable) THEN 'YES'::text
            ELSE 'NO'::text
        END)::information_schema.yes_or_no AS is_grantable
   FROM ( SELECT pg_class.oid,
            pg_class.relname,
            pg_class.relnamespace,
            pg_class.relkind,
            pg_class.relowner,
            (aclexplode(COALESCE(pg_class.relacl, acldefault('r'::"char", pg_class.relowner)))).grantor AS grantor,
            (aclexplode(COALESCE(pg_class.relacl, acldefault('r'::"char", pg_class.relowner)))).grantee AS grantee,
            (aclexplode(COALESCE(pg_class.relacl, acldefault('r'::"char", pg_class.relowner)))).privilege_type AS privilege_type,
            (aclexplode(COALESCE(pg_class.relacl, acldefault('r'::"char", pg_class.relowner)))).is_grantable AS is_grantable
           FROM pg_class) c(oid, relname, relnamespace, relkind, relowner, grantor, grantee, prtype, grantable),
    pg_namespace n,
    pg_authid u_grantor,
    ( SELECT pg_authid.oid,
            pg_authid.rolname
           FROM pg_authid
        UNION ALL
         SELECT (0)::oid AS oid,
            'PUBLIC'::name) grantee(oid, rolname)
  WHERE ((c.relnamespace = n.oid) AND (c.relkind = 'S'::"char") AND (c.grantee = grantee.oid) AND (c.grantor = u_grantor.oid) AND (c.prtype = 'USAGE'::text) AND (pg_has_role(u_grantor.oid, 'USAGE'::text) OR pg_has_role(grantee.oid, 'USAGE'::text) OR (grantee.rolname = 'PUBLIC'::name)));


ALTER TABLE information_schema.usage_privileges OWNER TO postgres;

--
-- Name: role_usage_grants; Type: VIEW; Schema: information_schema; Owner: postgres
--

CREATE VIEW information_schema.role_usage_grants AS
 SELECT usage_privileges.grantor,
    usage_privileges.grantee,
    usage_privileges.object_catalog,
    usage_privileges.object_schema,
    usage_privileges.object_name,
    usage_privileges.object_type,
    usage_privileges.privilege_type,
    usage_privileges.is_grantable
   FROM information_schema.usage_privileges
  WHERE (((usage_privileges.grantor)::name IN ( SELECT enabled_roles.role_name
           FROM information_schema.enabled_roles)) OR ((usage_privileges.grantee)::name IN ( SELECT enabled_roles.role_name
           FROM information_schema.enabled_roles)));


ALTER TABLE information_schema.role_usage_grants OWNER TO postgres;

--
-- Name: schemata; Type: VIEW; Schema: information_schema; Owner: postgres
--

CREATE VIEW information_schema.schemata AS
 SELECT (current_database())::information_schema.sql_identifier AS catalog_name,
    (n.nspname)::information_schema.sql_identifier AS schema_name,
    (u.rolname)::information_schema.sql_identifier AS schema_owner,
    (NULL::name)::information_schema.sql_identifier AS default_character_set_catalog,
    (NULL::name)::information_schema.sql_identifier AS default_character_set_schema,
    (NULL::name)::information_schema.sql_identifier AS default_character_set_name,
    (NULL::character varying)::information_schema.character_data AS sql_path
   FROM pg_namespace n,
    pg_authid u
  WHERE ((n.nspowner = u.oid) AND (pg_has_role(n.nspowner, 'USAGE'::text) OR has_schema_privilege(n.oid, 'CREATE, USAGE'::text)));


ALTER TABLE information_schema.schemata OWNER TO postgres;

--
-- Name: sequences; Type: VIEW; Schema: information_schema; Owner: postgres
--

CREATE VIEW information_schema.sequences AS
 SELECT (current_database())::information_schema.sql_identifier AS sequence_catalog,
    (nc.nspname)::information_schema.sql_identifier AS sequence_schema,
    (c.relname)::information_schema.sql_identifier AS sequence_name,
    (format_type(s.seqtypid, NULL::integer))::information_schema.character_data AS data_type,
    (information_schema._pg_numeric_precision(s.seqtypid, '-1'::integer))::information_schema.cardinal_number AS numeric_precision,
    (2)::information_schema.cardinal_number AS numeric_precision_radix,
    (0)::information_schema.cardinal_number AS numeric_scale,
    (s.seqstart)::information_schema.character_data AS start_value,
    (s.seqmin)::information_schema.character_data AS minimum_value,
    (s.seqmax)::information_schema.character_data AS maximum_value,
    (s.seqincrement)::information_schema.character_data AS increment,
    (
        CASE
            WHEN s.seqcycle THEN 'YES'::text
            ELSE 'NO'::text
        END)::information_schema.yes_or_no AS cycle_option
   FROM pg_namespace nc,
    pg_class c,
    pg_sequence s
  WHERE ((c.relnamespace = nc.oid) AND (c.relkind = 'S'::"char") AND (NOT (EXISTS ( SELECT 1
           FROM pg_depend
          WHERE ((pg_depend.classid = ('pg_class'::regclass)::oid) AND (pg_depend.objid = c.oid) AND (pg_depend.deptype = 'i'::"char"))))) AND (NOT pg_is_other_temp_schema(nc.oid)) AND (c.oid = s.seqrelid) AND (pg_has_role(c.relowner, 'USAGE'::text) OR has_sequence_privilege(c.oid, 'SELECT, UPDATE, USAGE'::text)));


ALTER TABLE information_schema.sequences OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: sql_features; Type: TABLE; Schema: information_schema; Owner: postgres
--

CREATE TABLE information_schema.sql_features (
    feature_id information_schema.character_data,
    feature_name information_schema.character_data,
    sub_feature_id information_schema.character_data,
    sub_feature_name information_schema.character_data,
    is_supported information_schema.yes_or_no,
    is_verified_by information_schema.character_data,
    comments information_schema.character_data
);


ALTER TABLE information_schema.sql_features OWNER TO postgres;

--
-- Name: sql_implementation_info; Type: TABLE; Schema: information_schema; Owner: postgres
--

CREATE TABLE information_schema.sql_implementation_info (
    implementation_info_id information_schema.character_data,
    implementation_info_name information_schema.character_data,
    integer_value information_schema.cardinal_number,
    character_value information_schema.character_data,
    comments information_schema.character_data
);


ALTER TABLE information_schema.sql_implementation_info OWNER TO postgres;

--
-- Name: sql_parts; Type: TABLE; Schema: information_schema; Owner: postgres
--

CREATE TABLE information_schema.sql_parts (
    feature_id information_schema.character_data,
    feature_name information_schema.character_data,
    is_supported information_schema.yes_or_no,
    is_verified_by information_schema.character_data,
    comments information_schema.character_data
);


ALTER TABLE information_schema.sql_parts OWNER TO postgres;

--
-- Name: sql_sizing; Type: TABLE; Schema: information_schema; Owner: postgres
--

CREATE TABLE information_schema.sql_sizing (
    sizing_id information_schema.cardinal_number,
    sizing_name information_schema.character_data,
    supported_value information_schema.cardinal_number,
    comments information_schema.character_data
);


ALTER TABLE information_schema.sql_sizing OWNER TO postgres;

--
-- Name: table_constraints; Type: VIEW; Schema: information_schema; Owner: postgres
--

CREATE VIEW information_schema.table_constraints AS
 SELECT (current_database())::information_schema.sql_identifier AS constraint_catalog,
    (nc.nspname)::information_schema.sql_identifier AS constraint_schema,
    (c.conname)::information_schema.sql_identifier AS constraint_name,
    (current_database())::information_schema.sql_identifier AS table_catalog,
    (nr.nspname)::information_schema.sql_identifier AS table_schema,
    (r.relname)::information_schema.sql_identifier AS table_name,
    (
        CASE c.contype
            WHEN 'c'::"char" THEN 'CHECK'::text
            WHEN 'f'::"char" THEN 'FOREIGN KEY'::text
            WHEN 'p'::"char" THEN 'PRIMARY KEY'::text
            WHEN 'u'::"char" THEN 'UNIQUE'::text
            ELSE NULL::text
        END)::information_schema.character_data AS constraint_type,
    (
        CASE
            WHEN c.condeferrable THEN 'YES'::text
            ELSE 'NO'::text
        END)::information_schema.yes_or_no AS is_deferrable,
    (
        CASE
            WHEN c.condeferred THEN 'YES'::text
            ELSE 'NO'::text
        END)::information_schema.yes_or_no AS initially_deferred,
    ('YES'::character varying)::information_schema.yes_or_no AS enforced
   FROM pg_namespace nc,
    pg_namespace nr,
    pg_constraint c,
    pg_class r
  WHERE ((nc.oid = c.connamespace) AND (nr.oid = r.relnamespace) AND (c.conrelid = r.oid) AND (c.contype <> ALL (ARRAY['t'::"char", 'x'::"char"])) AND (r.relkind = ANY (ARRAY['r'::"char", 'p'::"char"])) AND (NOT pg_is_other_temp_schema(nr.oid)) AND (pg_has_role(r.relowner, 'USAGE'::text) OR has_table_privilege(r.oid, 'INSERT, UPDATE, DELETE, TRUNCATE, REFERENCES, TRIGGER'::text) OR has_any_column_privilege(r.oid, 'INSERT, UPDATE, REFERENCES'::text)))
UNION ALL
 SELECT (current_database())::information_schema.sql_identifier AS constraint_catalog,
    (nr.nspname)::information_schema.sql_identifier AS constraint_schema,
    (((((((nr.oid)::text || '_'::text) || (r.oid)::text) || '_'::text) || (a.attnum)::text) || '_not_null'::text))::information_schema.sql_identifier AS constraint_name,
    (current_database())::information_schema.sql_identifier AS table_catalog,
    (nr.nspname)::information_schema.sql_identifier AS table_schema,
    (r.relname)::information_schema.sql_identifier AS table_name,
    ('CHECK'::character varying)::information_schema.character_data AS constraint_type,
    ('NO'::character varying)::information_schema.yes_or_no AS is_deferrable,
    ('NO'::character varying)::information_schema.yes_or_no AS initially_deferred,
    ('YES'::character varying)::information_schema.yes_or_no AS enforced
   FROM pg_namespace nr,
    pg_class r,
    pg_attribute a
  WHERE ((nr.oid = r.relnamespace) AND (r.oid = a.attrelid) AND a.attnotnull AND (a.attnum > 0) AND (NOT a.attisdropped) AND (r.relkind = ANY (ARRAY['r'::"char", 'p'::"char"])) AND (NOT pg_is_other_temp_schema(nr.oid)) AND (pg_has_role(r.relowner, 'USAGE'::text) OR has_table_privilege(r.oid, 'INSERT, UPDATE, DELETE, TRUNCATE, REFERENCES, TRIGGER'::text) OR has_any_column_privilege(r.oid, 'INSERT, UPDATE, REFERENCES'::text)));


ALTER TABLE information_schema.table_constraints OWNER TO postgres;

--
-- Name: tables; Type: VIEW; Schema: information_schema; Owner: postgres
--

CREATE VIEW information_schema.tables AS
 SELECT (current_database())::information_schema.sql_identifier AS table_catalog,
    (nc.nspname)::information_schema.sql_identifier AS table_schema,
    (c.relname)::information_schema.sql_identifier AS table_name,
    (
        CASE
            WHEN (nc.oid = pg_my_temp_schema()) THEN 'LOCAL TEMPORARY'::text
            WHEN (c.relkind = ANY (ARRAY['r'::"char", 'p'::"char"])) THEN 'BASE TABLE'::text
            WHEN (c.relkind = 'v'::"char") THEN 'VIEW'::text
            WHEN (c.relkind = 'f'::"char") THEN 'FOREIGN'::text
            ELSE NULL::text
        END)::information_schema.character_data AS table_type,
    (NULL::name)::information_schema.sql_identifier AS self_referencing_column_name,
    (NULL::character varying)::information_schema.character_data AS reference_generation,
    (
        CASE
            WHEN (t.typname IS NOT NULL) THEN current_database()
            ELSE NULL::name
        END)::information_schema.sql_identifier AS user_defined_type_catalog,
    (nt.nspname)::information_schema.sql_identifier AS user_defined_type_schema,
    (t.typname)::information_schema.sql_identifier AS user_defined_type_name,
    (
        CASE
            WHEN ((c.relkind = ANY (ARRAY['r'::"char", 'p'::"char"])) OR ((c.relkind = ANY (ARRAY['v'::"char", 'f'::"char"])) AND ((pg_relation_is_updatable((c.oid)::regclass, false) & 8) = 8))) THEN 'YES'::text
            ELSE 'NO'::text
        END)::information_schema.yes_or_no AS is_insertable_into,
    (
        CASE
            WHEN (t.typname IS NOT NULL) THEN 'YES'::text
            ELSE 'NO'::text
        END)::information_schema.yes_or_no AS is_typed,
    (NULL::character varying)::information_schema.character_data AS commit_action
   FROM ((pg_namespace nc
     JOIN pg_class c ON ((nc.oid = c.relnamespace)))
     LEFT JOIN (pg_type t
     JOIN pg_namespace nt ON ((t.typnamespace = nt.oid))) ON ((c.reloftype = t.oid)))
  WHERE ((c.relkind = ANY (ARRAY['r'::"char", 'v'::"char", 'f'::"char", 'p'::"char"])) AND (NOT pg_is_other_temp_schema(nc.oid)) AND (pg_has_role(c.relowner, 'USAGE'::text) OR has_table_privilege(c.oid, 'SELECT, INSERT, UPDATE, DELETE, TRUNCATE, REFERENCES, TRIGGER'::text) OR has_any_column_privilege(c.oid, 'SELECT, INSERT, UPDATE, REFERENCES'::text)));


ALTER TABLE information_schema.tables OWNER TO postgres;

--
-- Name: transforms; Type: VIEW; Schema: information_schema; Owner: postgres
--

CREATE VIEW information_schema.transforms AS
 SELECT (current_database())::information_schema.sql_identifier AS udt_catalog,
    (nt.nspname)::information_schema.sql_identifier AS udt_schema,
    (t.typname)::information_schema.sql_identifier AS udt_name,
    (current_database())::information_schema.sql_identifier AS specific_catalog,
    (np.nspname)::information_schema.sql_identifier AS specific_schema,
    (nameconcatoid(p.proname, p.oid))::information_schema.sql_identifier AS specific_name,
    (l.lanname)::information_schema.sql_identifier AS group_name,
    ('FROM SQL'::character varying)::information_schema.character_data AS transform_type
   FROM (((((pg_type t
     JOIN pg_transform x ON ((t.oid = x.trftype)))
     JOIN pg_language l ON ((x.trflang = l.oid)))
     JOIN pg_proc p ON (((x.trffromsql)::oid = p.oid)))
     JOIN pg_namespace nt ON ((t.typnamespace = nt.oid)))
     JOIN pg_namespace np ON ((p.pronamespace = np.oid)))
UNION
 SELECT (current_database())::information_schema.sql_identifier AS udt_catalog,
    (nt.nspname)::information_schema.sql_identifier AS udt_schema,
    (t.typname)::information_schema.sql_identifier AS udt_name,
    (current_database())::information_schema.sql_identifier AS specific_catalog,
    (np.nspname)::information_schema.sql_identifier AS specific_schema,
    (nameconcatoid(p.proname, p.oid))::information_schema.sql_identifier AS specific_name,
    (l.lanname)::information_schema.sql_identifier AS group_name,
    ('TO SQL'::character varying)::information_schema.character_data AS transform_type
   FROM (((((pg_type t
     JOIN pg_transform x ON ((t.oid = x.trftype)))
     JOIN pg_language l ON ((x.trflang = l.oid)))
     JOIN pg_proc p ON (((x.trftosql)::oid = p.oid)))
     JOIN pg_namespace nt ON ((t.typnamespace = nt.oid)))
     JOIN pg_namespace np ON ((p.pronamespace = np.oid)))
  ORDER BY 1, 2, 3, 7, 8;


ALTER TABLE information_schema.transforms OWNER TO postgres;

--
-- Name: triggered_update_columns; Type: VIEW; Schema: information_schema; Owner: postgres
--

CREATE VIEW information_schema.triggered_update_columns AS
 SELECT (current_database())::information_schema.sql_identifier AS trigger_catalog,
    (n.nspname)::information_schema.sql_identifier AS trigger_schema,
    (t.tgname)::information_schema.sql_identifier AS trigger_name,
    (current_database())::information_schema.sql_identifier AS event_object_catalog,
    (n.nspname)::information_schema.sql_identifier AS event_object_schema,
    (c.relname)::information_schema.sql_identifier AS event_object_table,
    (a.attname)::information_schema.sql_identifier AS event_object_column
   FROM pg_namespace n,
    pg_class c,
    pg_trigger t,
    ( SELECT ta0.tgoid,
            (ta0.tgat).x AS tgattnum,
            (ta0.tgat).n AS tgattpos
           FROM ( SELECT pg_trigger.oid AS tgoid,
                    information_schema._pg_expandarray(pg_trigger.tgattr) AS tgat
                   FROM pg_trigger) ta0) ta,
    pg_attribute a
  WHERE ((n.oid = c.relnamespace) AND (c.oid = t.tgrelid) AND (t.oid = ta.tgoid) AND ((a.attrelid = t.tgrelid) AND (a.attnum = ta.tgattnum)) AND (NOT t.tgisinternal) AND (NOT pg_is_other_temp_schema(n.oid)) AND (pg_has_role(c.relowner, 'USAGE'::text) OR has_column_privilege(c.oid, a.attnum, 'INSERT, UPDATE, REFERENCES'::text)));


ALTER TABLE information_schema.triggered_update_columns OWNER TO postgres;

--
-- Name: triggers; Type: VIEW; Schema: information_schema; Owner: postgres
--

CREATE VIEW information_schema.triggers AS
 SELECT (current_database())::information_schema.sql_identifier AS trigger_catalog,
    (n.nspname)::information_schema.sql_identifier AS trigger_schema,
    (t.tgname)::information_schema.sql_identifier AS trigger_name,
    (em.text)::information_schema.character_data AS event_manipulation,
    (current_database())::information_schema.sql_identifier AS event_object_catalog,
    (n.nspname)::information_schema.sql_identifier AS event_object_schema,
    (c.relname)::information_schema.sql_identifier AS event_object_table,
    (rank() OVER (PARTITION BY (n.nspname)::information_schema.sql_identifier, (c.relname)::information_schema.sql_identifier, em.num, ((t.tgtype)::integer & 1), ((t.tgtype)::integer & 66) ORDER BY t.tgname))::information_schema.cardinal_number AS action_order,
    (
        CASE
            WHEN pg_has_role(c.relowner, 'USAGE'::text) THEN (regexp_match(pg_get_triggerdef(t.oid), '.{35,} WHEN \((.+)\) EXECUTE FUNCTION'::text))[1]
            ELSE NULL::text
        END)::information_schema.character_data AS action_condition,
    ("substring"(pg_get_triggerdef(t.oid), ("position"("substring"(pg_get_triggerdef(t.oid), 48), 'EXECUTE FUNCTION'::text) + 47)))::information_schema.character_data AS action_statement,
    (
        CASE ((t.tgtype)::integer & 1)
            WHEN 1 THEN 'ROW'::text
            ELSE 'STATEMENT'::text
        END)::information_schema.character_data AS action_orientation,
    (
        CASE ((t.tgtype)::integer & 66)
            WHEN 2 THEN 'BEFORE'::text
            WHEN 64 THEN 'INSTEAD OF'::text
            ELSE 'AFTER'::text
        END)::information_schema.character_data AS action_timing,
    (t.tgoldtable)::information_schema.sql_identifier AS action_reference_old_table,
    (t.tgnewtable)::information_schema.sql_identifier AS action_reference_new_table,
    (NULL::name)::information_schema.sql_identifier AS action_reference_old_row,
    (NULL::name)::information_schema.sql_identifier AS action_reference_new_row,
    (NULL::timestamp with time zone)::information_schema.time_stamp AS created
   FROM pg_namespace n,
    pg_class c,
    pg_trigger t,
    ( VALUES (4,'INSERT'::text), (8,'DELETE'::text), (16,'UPDATE'::text)) em(num, text)
  WHERE ((n.oid = c.relnamespace) AND (c.oid = t.tgrelid) AND (((t.tgtype)::integer & em.num) <> 0) AND (NOT t.tgisinternal) AND (NOT pg_is_other_temp_schema(n.oid)) AND (pg_has_role(c.relowner, 'USAGE'::text) OR has_table_privilege(c.oid, 'INSERT, UPDATE, DELETE, TRUNCATE, REFERENCES, TRIGGER'::text) OR has_any_column_privilege(c.oid, 'INSERT, UPDATE, REFERENCES'::text)));


ALTER TABLE information_schema.triggers OWNER TO postgres;

--
-- Name: user_defined_types; Type: VIEW; Schema: information_schema; Owner: postgres
--

CREATE VIEW information_schema.user_defined_types AS
 SELECT (current_database())::information_schema.sql_identifier AS user_defined_type_catalog,
    (n.nspname)::information_schema.sql_identifier AS user_defined_type_schema,
    (c.relname)::information_schema.sql_identifier AS user_defined_type_name,
    ('STRUCTURED'::character varying)::information_schema.character_data AS user_defined_type_category,
    ('YES'::character varying)::information_schema.yes_or_no AS is_instantiable,
    (NULL::character varying)::information_schema.yes_or_no AS is_final,
    (NULL::character varying)::information_schema.character_data AS ordering_form,
    (NULL::character varying)::information_schema.character_data AS ordering_category,
    (NULL::name)::information_schema.sql_identifier AS ordering_routine_catalog,
    (NULL::name)::information_schema.sql_identifier AS ordering_routine_schema,
    (NULL::name)::information_schema.sql_identifier AS ordering_routine_name,
    (NULL::character varying)::information_schema.character_data AS reference_type,
    (NULL::character varying)::information_schema.character_data AS data_type,
    (NULL::integer)::information_schema.cardinal_number AS character_maximum_length,
    (NULL::integer)::information_schema.cardinal_number AS character_octet_length,
    (NULL::name)::information_schema.sql_identifier AS character_set_catalog,
    (NULL::name)::information_schema.sql_identifier AS character_set_schema,
    (NULL::name)::information_schema.sql_identifier AS character_set_name,
    (NULL::name)::information_schema.sql_identifier AS collation_catalog,
    (NULL::name)::information_schema.sql_identifier AS collation_schema,
    (NULL::name)::information_schema.sql_identifier AS collation_name,
    (NULL::integer)::information_schema.cardinal_number AS numeric_precision,
    (NULL::integer)::information_schema.cardinal_number AS numeric_precision_radix,
    (NULL::integer)::information_schema.cardinal_number AS numeric_scale,
    (NULL::integer)::information_schema.cardinal_number AS datetime_precision,
    (NULL::character varying)::information_schema.character_data AS interval_type,
    (NULL::integer)::information_schema.cardinal_number AS interval_precision,
    (NULL::name)::information_schema.sql_identifier AS source_dtd_identifier,
    (NULL::name)::information_schema.sql_identifier AS ref_dtd_identifier
   FROM pg_namespace n,
    pg_class c,
    pg_type t
  WHERE ((n.oid = c.relnamespace) AND (t.typrelid = c.oid) AND (c.relkind = 'c'::"char") AND (pg_has_role(t.typowner, 'USAGE'::text) OR has_type_privilege(t.oid, 'USAGE'::text)));


ALTER TABLE information_schema.user_defined_types OWNER TO postgres;

--
-- Name: user_mapping_options; Type: VIEW; Schema: information_schema; Owner: postgres
--

CREATE VIEW information_schema.user_mapping_options AS
 SELECT um.authorization_identifier,
    um.foreign_server_catalog,
    um.foreign_server_name,
    (opts.option_name)::information_schema.sql_identifier AS option_name,
    (
        CASE
            WHEN (((um.umuser <> (0)::oid) AND ((um.authorization_identifier)::name = CURRENT_USER)) OR ((um.umuser = (0)::oid) AND pg_has_role((um.srvowner)::name, 'USAGE'::text)) OR ( SELECT pg_authid.rolsuper
               FROM pg_authid
              WHERE (pg_authid.rolname = CURRENT_USER))) THEN opts.option_value
            ELSE NULL::text
        END)::information_schema.character_data AS option_value
   FROM information_schema._pg_user_mappings um,
    LATERAL pg_options_to_table(um.umoptions) opts(option_name, option_value);


ALTER TABLE information_schema.user_mapping_options OWNER TO postgres;

--
-- Name: user_mappings; Type: VIEW; Schema: information_schema; Owner: postgres
--

CREATE VIEW information_schema.user_mappings AS
 SELECT _pg_user_mappings.authorization_identifier,
    _pg_user_mappings.foreign_server_catalog,
    _pg_user_mappings.foreign_server_name
   FROM information_schema._pg_user_mappings;


ALTER TABLE information_schema.user_mappings OWNER TO postgres;

--
-- Name: view_column_usage; Type: VIEW; Schema: information_schema; Owner: postgres
--

CREATE VIEW information_schema.view_column_usage AS
 SELECT DISTINCT (current_database())::information_schema.sql_identifier AS view_catalog,
    (nv.nspname)::information_schema.sql_identifier AS view_schema,
    (v.relname)::information_schema.sql_identifier AS view_name,
    (current_database())::information_schema.sql_identifier AS table_catalog,
    (nt.nspname)::information_schema.sql_identifier AS table_schema,
    (t.relname)::information_schema.sql_identifier AS table_name,
    (a.attname)::information_schema.sql_identifier AS column_name
   FROM pg_namespace nv,
    pg_class v,
    pg_depend dv,
    pg_depend dt,
    pg_class t,
    pg_namespace nt,
    pg_attribute a
  WHERE ((nv.oid = v.relnamespace) AND (v.relkind = 'v'::"char") AND (v.oid = dv.refobjid) AND (dv.refclassid = ('pg_class'::regclass)::oid) AND (dv.classid = ('pg_rewrite'::regclass)::oid) AND (dv.deptype = 'i'::"char") AND (dv.objid = dt.objid) AND (dv.refobjid <> dt.refobjid) AND (dt.classid = ('pg_rewrite'::regclass)::oid) AND (dt.refclassid = ('pg_class'::regclass)::oid) AND (dt.refobjid = t.oid) AND (t.relnamespace = nt.oid) AND (t.relkind = ANY (ARRAY['r'::"char", 'v'::"char", 'f'::"char", 'p'::"char"])) AND (t.oid = a.attrelid) AND (dt.refobjsubid = a.attnum) AND pg_has_role(t.relowner, 'USAGE'::text));


ALTER TABLE information_schema.view_column_usage OWNER TO postgres;

--
-- Name: view_routine_usage; Type: VIEW; Schema: information_schema; Owner: postgres
--

CREATE VIEW information_schema.view_routine_usage AS
 SELECT DISTINCT (current_database())::information_schema.sql_identifier AS table_catalog,
    (nv.nspname)::information_schema.sql_identifier AS table_schema,
    (v.relname)::information_schema.sql_identifier AS table_name,
    (current_database())::information_schema.sql_identifier AS specific_catalog,
    (np.nspname)::information_schema.sql_identifier AS specific_schema,
    (nameconcatoid(p.proname, p.oid))::information_schema.sql_identifier AS specific_name
   FROM pg_namespace nv,
    pg_class v,
    pg_depend dv,
    pg_depend dp,
    pg_proc p,
    pg_namespace np
  WHERE ((nv.oid = v.relnamespace) AND (v.relkind = 'v'::"char") AND (v.oid = dv.refobjid) AND (dv.refclassid = ('pg_class'::regclass)::oid) AND (dv.classid = ('pg_rewrite'::regclass)::oid) AND (dv.deptype = 'i'::"char") AND (dv.objid = dp.objid) AND (dp.classid = ('pg_rewrite'::regclass)::oid) AND (dp.refclassid = ('pg_proc'::regclass)::oid) AND (dp.refobjid = p.oid) AND (p.pronamespace = np.oid) AND pg_has_role(p.proowner, 'USAGE'::text));


ALTER TABLE information_schema.view_routine_usage OWNER TO postgres;

--
-- Name: view_table_usage; Type: VIEW; Schema: information_schema; Owner: postgres
--

CREATE VIEW information_schema.view_table_usage AS
 SELECT DISTINCT (current_database())::information_schema.sql_identifier AS view_catalog,
    (nv.nspname)::information_schema.sql_identifier AS view_schema,
    (v.relname)::information_schema.sql_identifier AS view_name,
    (current_database())::information_schema.sql_identifier AS table_catalog,
    (nt.nspname)::information_schema.sql_identifier AS table_schema,
    (t.relname)::information_schema.sql_identifier AS table_name
   FROM pg_namespace nv,
    pg_class v,
    pg_depend dv,
    pg_depend dt,
    pg_class t,
    pg_namespace nt
  WHERE ((nv.oid = v.relnamespace) AND (v.relkind = 'v'::"char") AND (v.oid = dv.refobjid) AND (dv.refclassid = ('pg_class'::regclass)::oid) AND (dv.classid = ('pg_rewrite'::regclass)::oid) AND (dv.deptype = 'i'::"char") AND (dv.objid = dt.objid) AND (dv.refobjid <> dt.refobjid) AND (dt.classid = ('pg_rewrite'::regclass)::oid) AND (dt.refclassid = ('pg_class'::regclass)::oid) AND (dt.refobjid = t.oid) AND (t.relnamespace = nt.oid) AND (t.relkind = ANY (ARRAY['r'::"char", 'v'::"char", 'f'::"char", 'p'::"char"])) AND pg_has_role(t.relowner, 'USAGE'::text));


ALTER TABLE information_schema.view_table_usage OWNER TO postgres;

--
-- Name: views; Type: VIEW; Schema: information_schema; Owner: postgres
--

CREATE VIEW information_schema.views AS
 SELECT (current_database())::information_schema.sql_identifier AS table_catalog,
    (nc.nspname)::information_schema.sql_identifier AS table_schema,
    (c.relname)::information_schema.sql_identifier AS table_name,
    (
        CASE
            WHEN pg_has_role(c.relowner, 'USAGE'::text) THEN pg_get_viewdef(c.oid)
            ELSE NULL::text
        END)::information_schema.character_data AS view_definition,
    (
        CASE
            WHEN ('check_option=cascaded'::text = ANY (c.reloptions)) THEN 'CASCADED'::text
            WHEN ('check_option=local'::text = ANY (c.reloptions)) THEN 'LOCAL'::text
            ELSE 'NONE'::text
        END)::information_schema.character_data AS check_option,
    (
        CASE
            WHEN ((pg_relation_is_updatable((c.oid)::regclass, false) & 20) = 20) THEN 'YES'::text
            ELSE 'NO'::text
        END)::information_schema.yes_or_no AS is_updatable,
    (
        CASE
            WHEN ((pg_relation_is_updatable((c.oid)::regclass, false) & 8) = 8) THEN 'YES'::text
            ELSE 'NO'::text
        END)::information_schema.yes_or_no AS is_insertable_into,
    (
        CASE
            WHEN (EXISTS ( SELECT 1
               FROM pg_trigger
              WHERE ((pg_trigger.tgrelid = c.oid) AND (((pg_trigger.tgtype)::integer & 81) = 81)))) THEN 'YES'::text
            ELSE 'NO'::text
        END)::information_schema.yes_or_no AS is_trigger_updatable,
    (
        CASE
            WHEN (EXISTS ( SELECT 1
               FROM pg_trigger
              WHERE ((pg_trigger.tgrelid = c.oid) AND (((pg_trigger.tgtype)::integer & 73) = 73)))) THEN 'YES'::text
            ELSE 'NO'::text
        END)::information_schema.yes_or_no AS is_trigger_deletable,
    (
        CASE
            WHEN (EXISTS ( SELECT 1
               FROM pg_trigger
              WHERE ((pg_trigger.tgrelid = c.oid) AND (((pg_trigger.tgtype)::integer & 69) = 69)))) THEN 'YES'::text
            ELSE 'NO'::text
        END)::information_schema.yes_or_no AS is_trigger_insertable_into
   FROM pg_namespace nc,
    pg_class c
  WHERE ((c.relnamespace = nc.oid) AND (c.relkind = 'v'::"char") AND (NOT pg_is_other_temp_schema(nc.oid)) AND (pg_has_role(c.relowner, 'USAGE'::text) OR has_table_privilege(c.oid, 'SELECT, INSERT, UPDATE, DELETE, TRUNCATE, REFERENCES, TRIGGER'::text) OR has_any_column_privilege(c.oid, 'SELECT, INSERT, UPDATE, REFERENCES'::text)));


ALTER TABLE information_schema.views OWNER TO postgres;

--
-- Data for Name: sql_features; Type: TABLE DATA; Schema: information_schema; Owner: postgres
--

COPY information_schema.sql_features (feature_id, feature_name, sub_feature_id, sub_feature_name, is_supported, is_verified_by, comments) FROM stdin;
B011	Embedded Ada			NO	\N	
B012	Embedded C			YES	\N	
B013	Embedded COBOL			NO	\N	
B014	Embedded Fortran			NO	\N	
B015	Embedded MUMPS			NO	\N	
B016	Embedded Pascal			NO	\N	
B017	Embedded PL/I			NO	\N	
B021	Direct SQL			YES	\N	
B031	Basic dynamic SQL			NO	\N	
B032	Extended dynamic SQL			NO	\N	
B032	Extended dynamic SQL	01	<describe input statement>	NO	\N	
B033	Untyped SQL-invoked function arguments			NO	\N	
B034	Dynamic specification of cursor attributes			NO	\N	
B035	Non-extended descriptor names			NO	\N	
B041	Extensions to embedded SQL exception declarations			NO	\N	
B051	Enhanced execution rights			NO	\N	
B111	Module language Ada			NO	\N	
B112	Module language C			NO	\N	
B113	Module language COBOL			NO	\N	
B114	Module language Fortran			NO	\N	
B115	Module language MUMPS			NO	\N	
B116	Module language Pascal			NO	\N	
B117	Module language PL/I			NO	\N	
B121	Routine language Ada			NO	\N	
B122	Routine language C			NO	\N	
B123	Routine language COBOL			NO	\N	
B124	Routine language Fortran			NO	\N	
B125	Routine language MUMPS			NO	\N	
B126	Routine language Pascal			NO	\N	
B127	Routine language PL/I			NO	\N	
B128	Routine language SQL			NO	\N	
B200	Polymorphic table functions			NO	\N	
B201	More than one PTF generic table parameter			NO	\N	
B202	PTF Copartitioning			NO	\N	
B203	More than one copartition specification			NO	\N	
B204	PRUNE WHEN EMPTY			NO	\N	
B205	Pass-through columns			NO	\N	
B206	PTF descriptor parameters			NO	\N	
B207	Cross products of partitionings			NO	\N	
B208	PTF component procedure interface			NO	\N	
B209	PTF extended names			NO	\N	
B211	Module language Ada: VARCHAR and NUMERIC support			NO	\N	
B221	Routine language Ada: VARCHAR and NUMERIC support			NO	\N	
E011	Numeric data types			YES	\N	
E011	Numeric data types	01	INTEGER and SMALLINT data types	YES	\N	
E011	Numeric data types	02	REAL, DOUBLE PRECISION, and FLOAT data types	YES	\N	
E011	Numeric data types	03	DECIMAL and NUMERIC data types	YES	\N	
E011	Numeric data types	04	Arithmetic operators	YES	\N	
E011	Numeric data types	05	Numeric comparison	YES	\N	
E011	Numeric data types	06	Implicit casting among the numeric data types	YES	\N	
E021	Character data types			YES	\N	
E021	Character string types	01	CHARACTER data type	YES	\N	
E021	Character string types	02	CHARACTER VARYING data type	YES	\N	
E021	Character string types	03	Character literals	YES	\N	
E021	Character string types	04	CHARACTER_LENGTH function	YES	\N	trims trailing spaces from CHARACTER values before counting
E021	Character string types	05	OCTET_LENGTH function	YES	\N	
E021	Character string types	06	SUBSTRING function	YES	\N	
E021	Character string types	07	Character concatenation	YES	\N	
E021	Character string types	08	UPPER and LOWER functions	YES	\N	
E021	Character string types	09	TRIM function	YES	\N	
E021	Character string types	10	Implicit casting among the character string types	YES	\N	
E021	Character string types	11	POSITION function	YES	\N	
E021	Character string types	12	Character comparison	YES	\N	
E031	Identifiers			YES	\N	
E031	Identifiers	01	Delimited identifiers	YES	\N	
E031	Identifiers	02	Lower case identifiers	YES	\N	
E031	Identifiers	03	Trailing underscore	YES	\N	
E051	Basic query specification			YES	\N	
E051	Basic query specification	01	SELECT DISTINCT	YES	\N	
E051	Basic query specification	02	GROUP BY clause	YES	\N	
E051	Basic query specification	04	GROUP BY can contain columns not in <select list>	YES	\N	
E051	Basic query specification	05	Select list items can be renamed	YES	\N	
E051	Basic query specification	06	HAVING clause	YES	\N	
E051	Basic query specification	07	Qualified * in select list	YES	\N	
E051	Basic query specification	08	Correlation names in the FROM clause	YES	\N	
E051	Basic query specification	09	Rename columns in the FROM clause	YES	\N	
E061	Basic predicates and search conditions			YES	\N	
E061	Basic predicates and search conditions	01	Comparison predicate	YES	\N	
E061	Basic predicates and search conditions	02	BETWEEN predicate	YES	\N	
E061	Basic predicates and search conditions	03	IN predicate with list of values	YES	\N	
E061	Basic predicates and search conditions	04	LIKE predicate	YES	\N	
E061	Basic predicates and search conditions	05	LIKE predicate ESCAPE clause	YES	\N	
E061	Basic predicates and search conditions	06	NULL predicate	YES	\N	
E061	Basic predicates and search conditions	07	Quantified comparison predicate	YES	\N	
E061	Basic predicates and search conditions	08	EXISTS predicate	YES	\N	
E061	Basic predicates and search conditions	09	Subqueries in comparison predicate	YES	\N	
E061	Basic predicates and search conditions	11	Subqueries in IN predicate	YES	\N	
E061	Basic predicates and search conditions	12	Subqueries in quantified comparison predicate	YES	\N	
E061	Basic predicates and search conditions	13	Correlated subqueries	YES	\N	
E061	Basic predicates and search conditions	14	Search condition	YES	\N	
E071	Basic query expressions			YES	\N	
E071	Basic query expressions	01	UNION DISTINCT table operator	YES	\N	
E071	Basic query expressions	02	UNION ALL table operator	YES	\N	
E071	Basic query expressions	03	EXCEPT DISTINCT table operator	YES	\N	
E071	Basic query expressions	05	Columns combined via table operators need not have exactly the same data type	YES	\N	
E071	Basic query expressions	06	Table operators in subqueries	YES	\N	
E081	Basic Privileges			YES	\N	
E081	Basic Privileges	01	SELECT privilege	YES	\N	
E081	Basic Privileges	02	DELETE privilege	YES	\N	
E081	Basic Privileges	03	INSERT privilege at the table level	YES	\N	
E081	Basic Privileges	04	UPDATE privilege at the table level	YES	\N	
E081	Basic Privileges	05	UPDATE privilege at the column level	YES	\N	
E081	Basic Privileges	06	REFERENCES privilege at the table level	YES	\N	
E081	Basic Privileges	07	REFERENCES privilege at the column level	YES	\N	
E081	Basic Privileges	08	WITH GRANT OPTION	YES	\N	
E081	Basic Privileges	09	USAGE privilege	YES	\N	
E081	Basic Privileges	10	EXECUTE privilege	YES	\N	
E091	Set functions			YES	\N	
E091	Set functions	01	AVG	YES	\N	
E091	Set functions	02	COUNT	YES	\N	
E091	Set functions	03	MAX	YES	\N	
E091	Set functions	04	MIN	YES	\N	
E091	Set functions	05	SUM	YES	\N	
E091	Set functions	06	ALL quantifier	YES	\N	
E091	Set functions	07	DISTINCT quantifier	YES	\N	
E101	Basic data manipulation			YES	\N	
E101	Basic data manipulation	01	INSERT statement	YES	\N	
E101	Basic data manipulation	03	Searched UPDATE statement	YES	\N	
E101	Basic data manipulation	04	Searched DELETE statement	YES	\N	
E111	Single row SELECT statement			YES	\N	
E121	Basic cursor support			YES	\N	
E121	Basic cursor support	01	DECLARE CURSOR	YES	\N	
E121	Basic cursor support	02	ORDER BY columns need not be in select list	YES	\N	
E121	Basic cursor support	03	Value expressions in ORDER BY clause	YES	\N	
E121	Basic cursor support	04	OPEN statement	YES	\N	
E121	Basic cursor support	06	Positioned UPDATE statement	YES	\N	
E121	Basic cursor support	07	Positioned DELETE statement	YES	\N	
E121	Basic cursor support	08	CLOSE statement	YES	\N	
E121	Basic cursor support	10	FETCH statement implicit NEXT	YES	\N	
E121	Basic cursor support	17	WITH HOLD cursors	YES	\N	
E131	Null value support (nulls in lieu of values)			YES	\N	
E141	Basic integrity constraints			YES	\N	
E141	Basic integrity constraints	01	NOT NULL constraints	YES	\N	
E141	Basic integrity constraints	02	UNIQUE constraints of NOT NULL columns	YES	\N	
E141	Basic integrity constraints	03	PRIMARY KEY constraints	YES	\N	
E141	Basic integrity constraints	04	Basic FOREIGN KEY constraint with the NO ACTION default for both referential delete action and referential update action	YES	\N	
E141	Basic integrity constraints	06	CHECK constraints	YES	\N	
E141	Basic integrity constraints	07	Column defaults	YES	\N	
E141	Basic integrity constraints	08	NOT NULL inferred on PRIMARY KEY	YES	\N	
E141	Basic integrity constraints	10	Names in a foreign key can be specified in any order	YES	\N	
E151	Transaction support			YES	\N	
E151	Transaction support	01	COMMIT statement	YES	\N	
E151	Transaction support	02	ROLLBACK statement	YES	\N	
E152	Basic SET TRANSACTION statement			YES	\N	
E152	Basic SET TRANSACTION statement	01	SET TRANSACTION statement: ISOLATION LEVEL SERIALIZABLE clause	YES	\N	
E152	Basic SET TRANSACTION statement	02	SET TRANSACTION statement: READ ONLY and READ WRITE clauses	YES	\N	
E153	Updatable queries with subqueries			YES	\N	
E161	SQL comments using leading double minus			YES	\N	
E171	SQLSTATE support			YES	\N	
E182	Host language binding			YES	\N	
F021	Basic information schema			YES	\N	
F021	Basic information schema	01	COLUMNS view	YES	\N	
F021	Basic information schema	02	TABLES view	YES	\N	
F021	Basic information schema	03	VIEWS view	YES	\N	
F021	Basic information schema	04	TABLE_CONSTRAINTS view	YES	\N	
F021	Basic information schema	05	REFERENTIAL_CONSTRAINTS view	YES	\N	
F021	Basic information schema	06	CHECK_CONSTRAINTS view	YES	\N	
F031	Basic schema manipulation			YES	\N	
F031	Basic schema manipulation	01	CREATE TABLE statement to create persistent base tables	YES	\N	
F031	Basic schema manipulation	02	CREATE VIEW statement	YES	\N	
F031	Basic schema manipulation	03	GRANT statement	YES	\N	
F031	Basic schema manipulation	04	ALTER TABLE statement: ADD COLUMN clause	YES	\N	
F031	Basic schema manipulation	13	DROP TABLE statement: RESTRICT clause	YES	\N	
F031	Basic schema manipulation	16	DROP VIEW statement: RESTRICT clause	YES	\N	
F031	Basic schema manipulation	19	REVOKE statement: RESTRICT clause	YES	\N	
F032	CASCADE drop behavior			YES	\N	
F033	ALTER TABLE statement: DROP COLUMN clause			YES	\N	
F034	Extended REVOKE statement			YES	\N	
F034	Extended REVOKE statement	01	REVOKE statement performed by other than the owner of a schema object	YES	\N	
F034	Extended REVOKE statement	02	REVOKE statement: GRANT OPTION FOR clause	YES	\N	
F034	Extended REVOKE statement	03	REVOKE statement to revoke a privilege that the grantee has WITH GRANT OPTION	YES	\N	
F041	Basic joined table			YES	\N	
F041	Basic joined table	01	Inner join (but not necessarily the INNER keyword)	YES	\N	
F041	Basic joined table	02	INNER keyword	YES	\N	
F041	Basic joined table	03	LEFT OUTER JOIN	YES	\N	
F041	Basic joined table	04	RIGHT OUTER JOIN	YES	\N	
F041	Basic joined table	05	Outer joins can be nested	YES	\N	
F041	Basic joined table	07	The inner table in a left or right outer join can also be used in an inner join	YES	\N	
F041	Basic joined table	08	All comparison operators are supported (rather than just =)	YES	\N	
F051	Basic date and time			YES	\N	
F051	Basic date and time	01	DATE data type (including support of DATE literal)	YES	\N	
F051	Basic date and time	02	TIME data type (including support of TIME literal) with fractional seconds precision of at least 0	YES	\N	
F051	Basic date and time	03	TIMESTAMP data type (including support of TIMESTAMP literal) with fractional seconds precision of at least 0 and 6	YES	\N	
F051	Basic date and time	04	Comparison predicate on DATE, TIME, and TIMESTAMP data types	YES	\N	
F051	Basic date and time	05	Explicit CAST between datetime types and character string types	YES	\N	
F051	Basic date and time	06	CURRENT_DATE	YES	\N	
F051	Basic date and time	07	LOCALTIME	YES	\N	
F051	Basic date and time	08	LOCALTIMESTAMP	YES	\N	
F052	Intervals and datetime arithmetic			YES	\N	
F053	OVERLAPS predicate			YES	\N	
F054	TIMESTAMP in DATE type precedence list			NO	\N	
F081	UNION and EXCEPT in views			YES	\N	
F111	Isolation levels other than SERIALIZABLE			YES	\N	
F111	Isolation levels other than SERIALIZABLE	01	READ UNCOMMITTED isolation level	YES	\N	
F111	Isolation levels other than SERIALIZABLE	02	READ COMMITTED isolation level	YES	\N	
F111	Isolation levels other than SERIALIZABLE	03	REPEATABLE READ isolation level	YES	\N	
F121	Basic diagnostics management			NO	\N	
F121	Basic diagnostics management	01	GET DIAGNOSTICS statement	NO	\N	
F121	Basic diagnostics management	02	SET TRANSACTION statement: DIAGNOSTICS SIZE clause	NO	\N	
F122	Enhanced diagnostics management			NO	\N	
F123	All diagnostics			NO	\N	
F131	Grouped operations			YES	\N	
F131	Grouped operations	01	WHERE, GROUP BY, and HAVING clauses supported in queries with grouped views	YES	\N	
F131	Grouped operations	02	Multiple tables supported in queries with grouped views	YES	\N	
F131	Grouped operations	03	Set functions supported in queries with grouped views	YES	\N	
F131	Grouped operations	04	Subqueries with GROUP BY and HAVING clauses and grouped views	YES	\N	
F131	Grouped operations	05	Single row SELECT with GROUP BY and HAVING clauses and grouped views	YES	\N	
F171	Multiple schemas per user			YES	\N	
F181	Multiple module support			YES	\N	
F191	Referential delete actions			YES	\N	
F200	TRUNCATE TABLE statement			YES	\N	
F201	CAST function			YES	\N	
F202	TRUNCATE TABLE: identity column restart option			YES	\N	
F221	Explicit defaults			YES	\N	
F222	INSERT statement: DEFAULT VALUES clause			YES	\N	
F231	Privilege tables			YES	\N	
F231	Privilege tables	01	TABLE_PRIVILEGES view	YES	\N	
F231	Privilege tables	02	COLUMN_PRIVILEGES view	YES	\N	
F231	Privilege tables	03	USAGE_PRIVILEGES view	YES	\N	
F251	Domain support			YES	\N	
F261	CASE expression			YES	\N	
F261	CASE expression	01	Simple CASE	YES	\N	
F261	CASE expression	02	Searched CASE	YES	\N	
F261	CASE expression	03	NULLIF	YES	\N	
F261	CASE expression	04	COALESCE	YES	\N	
F262	Extended CASE expression			YES	\N	
F263	Comma-separated predicates in simple CASE expression			NO	\N	
F271	Compound character literals			YES	\N	
F281	LIKE enhancements			YES	\N	
F291	UNIQUE predicate			NO	\N	
F301	CORRESPONDING in query expressions			NO	\N	
F302	INTERSECT table operator			YES	\N	
F302	INTERSECT table operator	01	INTERSECT DISTINCT table operator	YES	\N	
F302	INTERSECT table operator	02	INTERSECT ALL table operator	YES	\N	
F304	EXCEPT ALL table operator			YES	\N	
F311	Schema definition statement			YES	\N	
F311	Schema definition statement	01	CREATE SCHEMA	YES	\N	
F311	Schema definition statement	02	CREATE TABLE for persistent base tables	YES	\N	
F311	Schema definition statement	03	CREATE VIEW	YES	\N	
F311	Schema definition statement	04	CREATE VIEW: WITH CHECK OPTION	YES	\N	
F311	Schema definition statement	05	GRANT statement	YES	\N	
F312	MERGE statement			NO	\N	consider INSERT ... ON CONFLICT DO UPDATE
F313	Enhanced MERGE statement			NO	\N	
F314	MERGE statement with DELETE branch			NO	\N	
F321	User authorization			YES	\N	
F341	Usage tables			NO	\N	no ROUTINE_*_USAGE tables
F361	Subprogram support			YES	\N	
F381	Extended schema manipulation			YES	\N	
F381	Extended schema manipulation	01	ALTER TABLE statement: ALTER COLUMN clause	YES	\N	
F381	Extended schema manipulation	02	ALTER TABLE statement: ADD CONSTRAINT clause	YES	\N	
F381	Extended schema manipulation	03	ALTER TABLE statement: DROP CONSTRAINT clause	YES	\N	
F382	Alter column data type			YES	\N	
F383	Set column not null clause			YES	\N	
F384	Drop identity property clause			YES	\N	
F385	Drop column generation expression clause			YES	\N	
F386	Set identity column generation clause			YES	\N	
F391	Long identifiers			YES	\N	
F392	Unicode escapes in identifiers			YES	\N	
F393	Unicode escapes in literals			YES	\N	
F394	Optional normal form specification			YES	\N	
F401	Extended joined table			YES	\N	
F401	Extended joined table	01	NATURAL JOIN	YES	\N	
F401	Extended joined table	02	FULL OUTER JOIN	YES	\N	
F401	Extended joined table	04	CROSS JOIN	YES	\N	
F402	Named column joins for LOBs, arrays, and multisets			YES	\N	
F403	Partitioned joined tables			NO	\N	
F404	Range variable for common column names			NO	\N	
F411	Time zone specification			YES	\N	differences regarding literal interpretation
F421	National character			YES	\N	
F431	Read-only scrollable cursors			YES	\N	
F431	Read-only scrollable cursors	01	FETCH with explicit NEXT	YES	\N	
F431	Read-only scrollable cursors	02	FETCH FIRST	YES	\N	
F431	Read-only scrollable cursors	03	FETCH LAST	YES	\N	
F431	Read-only scrollable cursors	04	FETCH PRIOR	YES	\N	
F431	Read-only scrollable cursors	05	FETCH ABSOLUTE	YES	\N	
F431	Read-only scrollable cursors	06	FETCH RELATIVE	YES	\N	
F441	Extended set function support			YES	\N	
F442	Mixed column references in set functions			YES	\N	
F451	Character set definition			NO	\N	
F461	Named character sets			NO	\N	
F471	Scalar subquery values			YES	\N	
F481	Expanded NULL predicate			YES	\N	
F491	Constraint management			YES	\N	
F492	Optional table constraint enforcement			NO	\N	
F501	Features and conformance views			YES	\N	
F501	Features and conformance views	01	SQL_FEATURES view	YES	\N	
F501	Features and conformance views	02	SQL_SIZING view	YES	\N	
F502	Enhanced documentation tables			YES	\N	
F521	Assertions			NO	\N	
F531	Temporary tables			YES	\N	
F555	Enhanced seconds precision			YES	\N	
F561	Full value expressions			YES	\N	
F571	Truth value tests			YES	\N	
F591	Derived tables			YES	\N	
F611	Indicator data types			YES	\N	
F641	Row and table constructors			YES	\N	
F651	Catalog name qualifiers			YES	\N	
F661	Simple tables			YES	\N	
F671	Subqueries in CHECK			NO	\N	intentionally omitted
F672	Retrospective check constraints			YES	\N	
F673	Reads SQL-data routine invocations in CHECK constraints			NO	\N	
F690	Collation support			YES	\N	but no character set support
F692	Extended collation support			YES	\N	
F693	SQL-session and client module collations			NO	\N	
F695	Translation support			NO	\N	
F696	Additional translation documentation			NO	\N	
F701	Referential update actions			YES	\N	
F711	ALTER domain			YES	\N	
F721	Deferrable constraints			NO	\N	foreign and unique keys only
F731	INSERT column privileges			YES	\N	
F741	Referential MATCH types			NO	\N	no partial match yet
F751	View CHECK enhancements			YES	\N	
F761	Session management			YES	\N	
F762	CURRENT_CATALOG			YES	\N	
F763	CURRENT_SCHEMA			YES	\N	
F771	Connection management			YES	\N	
F781	Self-referencing operations			YES	\N	
F791	Insensitive cursors			YES	\N	
F801	Full set function			YES	\N	
F812	Basic flagging			NO	\N	
F813	Extended flagging			NO	\N	
F821	Local table references			NO	\N	
F831	Full cursor update			NO	\N	
F831	Full cursor update	01	Updatable scrollable cursors	NO	\N	
F831	Full cursor update	02	Updatable ordered cursors	NO	\N	
F841	LIKE_REGEX predicate			NO	\N	
F842	OCCURRENCES_REGEX function			NO	\N	
F843	POSITION_REGEX function			NO	\N	
F844	SUBSTRING_REGEX function			NO	\N	
F845	TRANSLATE_REGEX function			NO	\N	
F846	Octet support in regular expression operators			NO	\N	
F847	Nonconstant regular expressions			NO	\N	
F850	Top-level <order by clause> in <query expression>			YES	\N	
F851	<order by clause> in subqueries			YES	\N	
F852	Top-level <order by clause> in views			YES	\N	
F855	Nested <order by clause> in <query expression>			YES	\N	
F856	Nested <fetch first clause> in <query expression>			YES	\N	
F857	Top-level <fetch first clause> in <query expression>			YES	\N	
F858	<fetch first clause> in subqueries			YES	\N	
F859	Top-level <fetch first clause> in views			YES	\N	
F860	<fetch first row count> in <fetch first clause>			YES	\N	
F861	Top-level <result offset clause> in <query expression>			YES	\N	
F862	<result offset clause> in subqueries			YES	\N	
F863	Nested <result offset clause> in <query expression>			YES	\N	
F864	Top-level <result offset clause> in views			YES	\N	
F865	<offset row count> in <result offset clause>			YES	\N	
F866	FETCH FIRST clause: PERCENT option			NO	\N	
F867	FETCH FIRST clause: WITH TIES option			YES	\N	
R010	Row pattern recognition: FROM clause			NO	\N	
R020	Row pattern recognition: WINDOW clause			NO	\N	
R030	Row pattern recognition: full aggregate support			NO	\N	
S011	Distinct data types			NO	\N	
S011	Distinct data types	01	USER_DEFINED_TYPES view	NO	\N	
S023	Basic structured types			NO	\N	
S024	Enhanced structured types			NO	\N	
S025	Final structured types			NO	\N	
S026	Self-referencing structured types			NO	\N	
S027	Create method by specific method name			NO	\N	
S028	Permutable UDT options list			NO	\N	
S041	Basic reference types			NO	\N	
S043	Enhanced reference types			NO	\N	
S051	Create table of type			NO	\N	partially supported
S071	SQL paths in function and type name resolution			YES	\N	
S081	Subtables			NO	\N	
S091	Basic array support			NO	\N	partially supported
S091	Basic array support	01	Arrays of built-in data types	NO	\N	
S091	Basic array support	02	Arrays of distinct types	NO	\N	
S091	Basic array support	03	Array expressions	NO	\N	
S092	Arrays of user-defined types			YES	\N	
S094	Arrays of reference types			NO	\N	
S095	Array constructors by query			YES	\N	
S096	Optional array bounds			YES	\N	
S097	Array element assignment			NO	\N	
S098	ARRAY_AGG			YES	\N	
S111	ONLY in query expressions			YES	\N	
S151	Type predicate			NO	\N	
S161	Subtype treatment			NO	\N	
S162	Subtype treatment for references			NO	\N	
S201	SQL-invoked routines on arrays			YES	\N	
S201	SQL-invoked routines on arrays	01	Array parameters	YES	\N	
S201	SQL-invoked routines on arrays	02	Array as result type of functions	YES	\N	
S202	SQL-invoked routines on multisets			NO	\N	
S211	User-defined cast functions			YES	\N	
S231	Structured type locators			NO	\N	
S232	Array locators			NO	\N	
S233	Multiset locators			NO	\N	
S241	Transform functions			NO	\N	
S242	Alter transform statement			NO	\N	
S251	User-defined orderings			NO	\N	
S261	Specific type method			NO	\N	
S271	Basic multiset support			NO	\N	
S272	Multisets of user-defined types			NO	\N	
S274	Multisets of reference types			NO	\N	
S275	Advanced multiset support			NO	\N	
S281	Nested collection types			NO	\N	
S291	Unique constraint on entire row			NO	\N	
S301	Enhanced UNNEST			YES	\N	
S401	Distinct types based on array types			NO	\N	
S402	Distinct types based on distinct types			NO	\N	
S403	ARRAY_MAX_CARDINALITY			NO	\N	
S404	TRIM_ARRAY			NO	\N	
T011	Timestamp in Information Schema			NO	\N	
T021	BINARY and VARBINARY data types			NO	\N	
T022	Advanced support for BINARY and VARBINARY data types			NO	\N	
T023	Compound binary literal			NO	\N	
T024	Spaces in binary literals			NO	\N	
T031	BOOLEAN data type			YES	\N	
T041	Basic LOB data type support			NO	\N	
T041	Basic LOB data type support	01	BLOB data type	NO	\N	
T041	Basic LOB data type support	02	CLOB data type	NO	\N	
T041	Basic LOB data type support	03	POSITION, LENGTH, LOWER, TRIM, UPPER, and SUBSTRING functions for LOB data types	NO	\N	
T041	Basic LOB data type support	04	Concatenation of LOB data types	NO	\N	
T041	Basic LOB data type support	05	LOB locator: non-holdable	NO	\N	
T042	Extended LOB data type support			NO	\N	
T043	Multiplier T			NO	\N	
T044	Multiplier P			NO	\N	
T051	Row types			NO	\N	
T053	Explicit aliases for all-fields reference			NO	\N	
T061	UCS support			NO	\N	
T071	BIGINT data type			YES	\N	
T076	DECFLOAT data type			NO	\N	
T101	Enhanced nullability determination			NO	\N	
T111	Updatable joins, unions, and columns			NO	\N	
T121	WITH (excluding RECURSIVE) in query expression			YES	\N	
T122	WITH (excluding RECURSIVE) in subquery			YES	\N	
T131	Recursive query			YES	\N	
T132	Recursive query in subquery			YES	\N	
T141	SIMILAR predicate			YES	\N	
T151	DISTINCT predicate			YES	\N	
T152	DISTINCT predicate with negation			YES	\N	
T171	LIKE clause in table definition			YES	\N	
T172	AS subquery clause in table definition			YES	\N	
T173	Extended LIKE clause in table definition			YES	\N	
T174	Identity columns			YES	\N	
T175	Generated columns			NO	\N	mostly supported
T176	Sequence generator support			NO	\N	supported except for NEXT VALUE FOR
T177	Sequence generator support: simple restart option			YES	\N	
T178	Identity columns:  simple restart option			YES	\N	
T180	System-versioned tables			NO	\N	
T181	Application-time period tables			NO	\N	
T191	Referential action RESTRICT			YES	\N	
T201	Comparable data types for referential constraints			YES	\N	
T211	Basic trigger capability			NO	\N	
T211	Basic trigger capability	01	Triggers activated on UPDATE, INSERT, or DELETE of one base table	YES	\N	
T211	Basic trigger capability	02	BEFORE triggers	YES	\N	
T211	Basic trigger capability	03	AFTER triggers	YES	\N	
T211	Basic trigger capability	04	FOR EACH ROW triggers	YES	\N	
T211	Basic trigger capability	05	Ability to specify a search condition that must be true before the trigger is invoked	YES	\N	
T211	Basic trigger capability	06	Support for run-time rules for the interaction of triggers and constraints	NO	\N	
T211	Basic trigger capability	07	TRIGGER privilege	YES	\N	
T211	Basic trigger capability	08	Multiple triggers for the same event are executed in the order in which they were created in the catalog	NO	\N	intentionally omitted
T212	Enhanced trigger capability			YES	\N	
T213	INSTEAD OF triggers			YES	\N	
T231	Sensitive cursors			YES	\N	
T241	START TRANSACTION statement			YES	\N	
T251	SET TRANSACTION statement: LOCAL option			NO	\N	
T261	Chained transactions			YES	\N	
T271	Savepoints			YES	\N	
T272	Enhanced savepoint management			NO	\N	
T281	SELECT privilege with column granularity			YES	\N	
T285	Enhanced derived column names			YES	\N	
T301	Functional dependencies			NO	\N	partially supported
T312	OVERLAY function			YES	\N	
T321	Basic SQL-invoked routines			NO	\N	
T321	Basic SQL-invoked routines	01	User-defined functions with no overloading	YES	\N	
T321	Basic SQL-invoked routines	02	User-defined stored procedures with no overloading	YES	\N	
T321	Basic SQL-invoked routines	03	Function invocation	YES	\N	
T321	Basic SQL-invoked routines	04	CALL statement	YES	\N	
T321	Basic SQL-invoked routines	05	RETURN statement	NO	\N	
T321	Basic SQL-invoked routines	06	ROUTINES view	YES	\N	
T321	Basic SQL-invoked routines	07	PARAMETERS view	YES	\N	
T322	Declared data type attributes			NO	\N	
T323	Explicit security for external routines			YES	\N	
T324	Explicit security for SQL routines			NO	\N	
T325	Qualified SQL parameter references			YES	\N	
T326	Table functions			NO	\N	
T331	Basic roles			YES	\N	
T332	Extended roles			NO	\N	mostly supported
T341	Overloading of SQL-invoked functions and procedures			YES	\N	
T351	Bracketed SQL comments (/*...*/ comments)			YES	\N	
T431	Extended grouping capabilities			YES	\N	
T432	Nested and concatenated GROUPING SETS			YES	\N	
T433	Multiargument GROUPING function			YES	\N	
T434	GROUP BY DISTINCT			NO	\N	
T441	ABS and MOD functions			YES	\N	
T461	Symmetric BETWEEN predicate			YES	\N	
T471	Result sets return value			NO	\N	
T472	DESCRIBE CURSOR			NO	\N	
T491	LATERAL derived table			YES	\N	
T495	Combined data change and retrieval			NO	\N	different syntax
T501	Enhanced EXISTS predicate			YES	\N	
T502	Period predicates			NO	\N	
T511	Transaction counts			NO	\N	
T521	Named arguments in CALL statement			YES	\N	
T522	Default values for IN parameters of SQL-invoked procedures			NO	\N	supported except DEFAULT key word in invocation
T523	Default values for INOUT parameters of SQL-invoked procedures			YES	\N	
X300	XMLTable			NO	\N	XPath 1.0 only
T524	Named arguments in routine invocations other than a CALL statement			YES	\N	
T525	Default values for parameters of SQL-invoked functions			YES	\N	
T551	Optional key words for default syntax			YES	\N	
T561	Holdable locators			NO	\N	
T571	Array-returning external SQL-invoked functions			NO	\N	
T572	Multiset-returning external SQL-invoked functions			NO	\N	
T581	Regular expression substring function			YES	\N	
T591	UNIQUE constraints of possibly null columns			YES	\N	
T601	Local cursor references			NO	\N	
T611	Elementary OLAP operations			YES	\N	
T612	Advanced OLAP operations			YES	\N	
T613	Sampling			YES	\N	
T614	NTILE function			YES	\N	
T615	LEAD and LAG functions			YES	\N	
T616	Null treatment option for LEAD and LAG functions			NO	\N	
T617	FIRST_VALUE and LAST_VALUE function			YES	\N	
T618	NTH_VALUE function			NO	\N	function exists, but some options missing
T619	Nested window functions			NO	\N	
T620	WINDOW clause: GROUPS option			YES	\N	
T621	Enhanced numeric functions			YES	\N	
T622	Trigonometric functions			YES	\N	
T623	General logarithm functions			YES	\N	
T624	Common logarithm functions			YES	\N	
T625	LISTAGG			NO	\N	
T631	IN predicate with one list element			YES	\N	
T641	Multiple column assignment			NO	\N	only some syntax variants supported
T651	SQL-schema statements in SQL routines			YES	\N	
T652	SQL-dynamic statements in SQL routines			NO	\N	
T653	SQL-schema statements in external routines			YES	\N	
T654	SQL-dynamic statements in external routines			NO	\N	
T655	Cyclically dependent routines			YES	\N	
T811	Basic SQL/JSON constructor functions			NO	\N	
T812	SQL/JSON: JSON_OBJECTAGG			NO	\N	
T813	SQL/JSON: JSON_ARRAYAGG with ORDER BY			NO	\N	
T814	Colon in JSON_OBJECT or JSON_OBJECTAGG			NO	\N	
T821	Basic SQL/JSON query operators			NO	\N	
T822	SQL/JSON: IS JSON WITH UNIQUE KEYS predicate			NO	\N	
T823	SQL/JSON: PASSING clause			NO	\N	
T824	JSON_TABLE: specific PLAN clause			NO	\N	
T825	SQL/JSON: ON EMPTY and ON ERROR clauses			NO	\N	
T826	General value expression in ON ERROR or ON EMPTY clauses			NO	\N	
T827	JSON_TABLE: sibling NESTED COLUMNS clauses			NO	\N	
T828	JSON_QUERY			NO	\N	
T829	JSON_QUERY: array wrapper options			NO	\N	
T830	Enforcing unique keys in SQL/JSON constructor functions			NO	\N	
T831	SQL/JSON path language: strict mode			YES	\N	
T832	SQL/JSON path language: item method			YES	\N	
T833	SQL/JSON path language: multiple subscripts			YES	\N	
T834	SQL/JSON path language: wildcard member accessor			YES	\N	
T835	SQL/JSON path language: filter expressions			YES	\N	
T836	SQL/JSON path language: starts with predicate			YES	\N	
T837	SQL/JSON path language: regex_like predicate			YES	\N	
T838	JSON_TABLE: PLAN DEFAULT clause			NO	\N	
T839	Formatted cast of datetimes to/from character strings			NO	\N	
M001	Datalinks			NO	\N	
M002	Datalinks via SQL/CLI			NO	\N	
M003	Datalinks via Embedded SQL			NO	\N	
M004	Foreign data support			NO	\N	partially supported
M005	Foreign schema support			NO	\N	
M006	GetSQLString routine			NO	\N	
M007	TransmitRequest			NO	\N	
M009	GetOpts and GetStatistics routines			NO	\N	
M010	Foreign data wrapper support			NO	\N	different API
M011	Datalinks via Ada			NO	\N	
M012	Datalinks via C			NO	\N	
M013	Datalinks via COBOL			NO	\N	
M014	Datalinks via Fortran			NO	\N	
M015	Datalinks via M			NO	\N	
M016	Datalinks via Pascal			NO	\N	
M017	Datalinks via PL/I			NO	\N	
M018	Foreign data wrapper interface routines in Ada			NO	\N	
M019	Foreign data wrapper interface routines in C			NO	\N	different API
M020	Foreign data wrapper interface routines in COBOL			NO	\N	
M021	Foreign data wrapper interface routines in Fortran			NO	\N	
M022	Foreign data wrapper interface routines in MUMPS			NO	\N	
M023	Foreign data wrapper interface routines in Pascal			NO	\N	
M024	Foreign data wrapper interface routines in PL/I			NO	\N	
M030	SQL-server foreign data support			NO	\N	
M031	Foreign data wrapper general routines			NO	\N	
X010	XML type			YES	\N	
X011	Arrays of XML type			YES	\N	
X012	Multisets of XML type			NO	\N	
X013	Distinct types of XML type			NO	\N	
X014	Attributes of XML type			YES	\N	
X015	Fields of XML type			NO	\N	
X016	Persistent XML values			YES	\N	
X020	XMLConcat			YES	\N	
X025	XMLCast			NO	\N	
X030	XMLDocument			NO	\N	
X031	XMLElement			YES	\N	
X032	XMLForest			YES	\N	
X034	XMLAgg			YES	\N	
X035	XMLAgg: ORDER BY option			YES	\N	
X036	XMLComment			YES	\N	
X037	XMLPI			YES	\N	
X038	XMLText			NO	\N	
X040	Basic table mapping			YES	\N	
X041	Basic table mapping: nulls absent			YES	\N	
X042	Basic table mapping: null as nil			YES	\N	
X043	Basic table mapping: table as forest			YES	\N	
X044	Basic table mapping: table as element			YES	\N	
X045	Basic table mapping: with target namespace			YES	\N	
X046	Basic table mapping: data mapping			YES	\N	
X047	Basic table mapping: metadata mapping			YES	\N	
X048	Basic table mapping: base64 encoding of binary strings			YES	\N	
X049	Basic table mapping: hex encoding of binary strings			YES	\N	
X050	Advanced table mapping			YES	\N	
X051	Advanced table mapping: nulls absent			YES	\N	
X052	Advanced table mapping: null as nil			YES	\N	
X053	Advanced table mapping: table as forest			YES	\N	
X054	Advanced table mapping: table as element			YES	\N	
X055	Advanced table mapping: with target namespace			YES	\N	
X056	Advanced table mapping: data mapping			YES	\N	
X057	Advanced table mapping: metadata mapping			YES	\N	
X058	Advanced table mapping: base64 encoding of binary strings			YES	\N	
X059	Advanced table mapping: hex encoding of binary strings			YES	\N	
X060	XMLParse: character string input and CONTENT option			YES	\N	
X061	XMLParse: character string input and DOCUMENT option			YES	\N	
X065	XMLParse: BLOB input and CONTENT option			NO	\N	
X066	XMLParse: BLOB input and DOCUMENT option			NO	\N	
X068	XMLSerialize: BOM			NO	\N	
X069	XMLSerialize: INDENT			NO	\N	
X070	XMLSerialize: character string serialization and CONTENT option			YES	\N	
X071	XMLSerialize: character string serialization and DOCUMENT option			YES	\N	
X072	XMLSerialize: character string serialization			YES	\N	
X073	XMLSerialize: BLOB serialization and CONTENT option			NO	\N	
X074	XMLSerialize: BLOB serialization and DOCUMENT option			NO	\N	
X075	XMLSerialize: BLOB serialization			NO	\N	
X076	XMLSerialize: VERSION			NO	\N	
X077	XMLSerialize: explicit ENCODING option			NO	\N	
X078	XMLSerialize: explicit XML declaration			NO	\N	
X080	Namespaces in XML publishing			NO	\N	
X081	Query-level XML namespace declarations			NO	\N	
X082	XML namespace declarations in DML			NO	\N	
X083	XML namespace declarations in DDL			NO	\N	
X084	XML namespace declarations in compound statements			NO	\N	
X085	Predefined namespace prefixes			NO	\N	
X086	XML namespace declarations in XMLTable			NO	\N	
X090	XML document predicate			YES	\N	
X091	XML content predicate			NO	\N	
X096	XMLExists			NO	\N	XPath 1.0 only
X100	Host language support for XML: CONTENT option			NO	\N	
X101	Host language support for XML: DOCUMENT option			NO	\N	
X110	Host language support for XML: VARCHAR mapping			NO	\N	
X111	Host language support for XML: CLOB mapping			NO	\N	
X112	Host language support for XML: BLOB mapping			NO	\N	
X113	Host language support for XML: STRIP WHITESPACE option			NO	\N	
X114	Host language support for XML: PRESERVE WHITESPACE option			NO	\N	
X120	XML parameters in SQL routines			YES	\N	
X121	XML parameters in external routines			YES	\N	
X131	Query-level XMLBINARY clause			NO	\N	
X132	XMLBINARY clause in DML			NO	\N	
X133	XMLBINARY clause in DDL			NO	\N	
X134	XMLBINARY clause in compound statements			NO	\N	
X135	XMLBINARY clause in subqueries			NO	\N	
X141	IS VALID predicate: data-driven case			NO	\N	
X142	IS VALID predicate: ACCORDING TO clause			NO	\N	
X143	IS VALID predicate: ELEMENT clause			NO	\N	
X144	IS VALID predicate: schema location			NO	\N	
X145	IS VALID predicate outside check constraints			NO	\N	
X151	IS VALID predicate with DOCUMENT option			NO	\N	
X152	IS VALID predicate with CONTENT option			NO	\N	
X153	IS VALID predicate with SEQUENCE option			NO	\N	
X155	IS VALID predicate: NAMESPACE without ELEMENT clause			NO	\N	
X157	IS VALID predicate: NO NAMESPACE with ELEMENT clause			NO	\N	
X160	Basic Information Schema for registered XML Schemas			NO	\N	
X161	Advanced Information Schema for registered XML Schemas			NO	\N	
X170	XML null handling options			NO	\N	
X171	NIL ON NO CONTENT option			NO	\N	
X181	XML(DOCUMENT(UNTYPED)) type			NO	\N	
X182	XML(DOCUMENT(ANY)) type			NO	\N	
X190	XML(SEQUENCE) type			NO	\N	
X191	XML(DOCUMENT(XMLSCHEMA)) type			NO	\N	
X192	XML(CONTENT(XMLSCHEMA)) type			NO	\N	
X200	XMLQuery			NO	\N	
X201	XMLQuery: RETURNING CONTENT			NO	\N	
X202	XMLQuery: RETURNING SEQUENCE			NO	\N	
X203	XMLQuery: passing a context item			NO	\N	
X204	XMLQuery: initializing an XQuery variable			NO	\N	
X205	XMLQuery: EMPTY ON EMPTY option			NO	\N	
X206	XMLQuery: NULL ON EMPTY option			NO	\N	
X211	XML 1.1 support			NO	\N	
X221	XML passing mechanism BY VALUE			YES	\N	
X222	XML passing mechanism BY REF			NO	\N	parser accepts BY REF but ignores it; passing is always BY VALUE
X231	XML(CONTENT(UNTYPED)) type			NO	\N	
X232	XML(CONTENT(ANY)) type			NO	\N	
X241	RETURNING CONTENT in XML publishing			NO	\N	
X242	RETURNING SEQUENCE in XML publishing			NO	\N	
X251	Persistent XML values of XML(DOCUMENT(UNTYPED)) type			NO	\N	
X252	Persistent XML values of XML(DOCUMENT(ANY)) type			NO	\N	
X253	Persistent XML values of XML(CONTENT(UNTYPED)) type			NO	\N	
X254	Persistent XML values of XML(CONTENT(ANY)) type			NO	\N	
X255	Persistent XML values of XML(SEQUENCE) type			NO	\N	
X256	Persistent XML values of XML(DOCUMENT(XMLSCHEMA)) type			NO	\N	
X257	Persistent XML values of XML(CONTENT(XMLSCHEMA)) type			NO	\N	
X260	XML type: ELEMENT clause			NO	\N	
X261	XML type: NAMESPACE without ELEMENT clause			NO	\N	
X263	XML type: NO NAMESPACE with ELEMENT clause			NO	\N	
X264	XML type: schema location			NO	\N	
X271	XMLValidate: data-driven case			NO	\N	
X272	XMLValidate: ACCORDING TO clause			NO	\N	
X273	XMLValidate: ELEMENT clause			NO	\N	
X274	XMLValidate: schema location			NO	\N	
X281	XMLValidate with DOCUMENT option			NO	\N	
X282	XMLValidate with CONTENT option			NO	\N	
X283	XMLValidate with SEQUENCE option			NO	\N	
X284	XMLValidate: NAMESPACE without ELEMENT clause			NO	\N	
X286	XMLValidate: NO NAMESPACE with ELEMENT clause			NO	\N	
X301	XMLTable: derived column list option			YES	\N	
X302	XMLTable: ordinality column option			YES	\N	
X303	XMLTable: column default option			YES	\N	
X304	XMLTable: passing a context item			YES	\N	must be XML DOCUMENT
X305	XMLTable: initializing an XQuery variable			NO	\N	
X400	Name and identifier mapping			YES	\N	
X410	Alter column data type: XML type			YES	\N	
\.


--
-- Data for Name: sql_implementation_info; Type: TABLE DATA; Schema: information_schema; Owner: postgres
--

COPY information_schema.sql_implementation_info (implementation_info_id, implementation_info_name, integer_value, character_value, comments) FROM stdin;
10003	CATALOG NAME	\N	Y	\N
10004	COLLATING SEQUENCE	\N	\N	\N
23	CURSOR COMMIT BEHAVIOR	1	\N	close cursors and retain prepared statements
2	DATA SOURCE NAME	\N		\N
17	DBMS NAME	\N	PostgreSQL	\N
26	DEFAULT TRANSACTION ISOLATION	2	\N	READ COMMITTED; user-settable
28	IDENTIFIER CASE	3	\N	stored in mixed case - case sensitive
85	NULL COLLATION	0	\N	nulls higher than non-nulls
13	SERVER NAME	\N		\N
94	SPECIAL CHARACTERS	\N		all non-ASCII characters allowed
46	TRANSACTION CAPABLE	2	\N	both DML and DDL
18	DBMS VERSION	\N	13.03.0000)	\N
\.


--
-- Data for Name: sql_parts; Type: TABLE DATA; Schema: information_schema; Owner: postgres
--

COPY information_schema.sql_parts (feature_id, feature_name, is_supported, is_verified_by, comments) FROM stdin;
1	Framework (SQL/Framework)	NO	\N	
2	Foundation (SQL/Foundation)	NO	\N	
3	Call-Level Interface (SQL/CLI)	NO	\N	
4	Persistent Stored Modules (SQL/PSM)	NO	\N	
9	Management of External Data (SQL/MED)	NO	\N	
10	Object Language Bindings (SQL/OLB)	NO	\N	
11	Information and Definition Schema (SQL/Schemata)	NO	\N	
13	Routines and Types Using the Java Programming Language (SQL/JRT)	NO	\N	
14	XML-Related Specifications (SQL/XML)	NO	\N	
15	Multi-Dimensional Arrays (SQL/MDA)	NO	\N	
\.


--
-- Data for Name: sql_sizing; Type: TABLE DATA; Schema: information_schema; Owner: postgres
--

COPY information_schema.sql_sizing (sizing_id, sizing_name, supported_value, comments) FROM stdin;
97	MAXIMUM COLUMNS IN GROUP BY	0	\N
99	MAXIMUM COLUMNS IN ORDER BY	0	\N
100	MAXIMUM COLUMNS IN SELECT	1664	\N
101	MAXIMUM COLUMNS IN TABLE	1600	\N
1	MAXIMUM CONCURRENT ACTIVITIES	0	\N
0	MAXIMUM DRIVER CONNECTIONS	\N	\N
20000	MAXIMUM STATEMENT OCTETS	0	\N
20001	MAXIMUM STATEMENT OCTETS DATA	0	\N
20002	MAXIMUM STATEMENT OCTETS SCHEMA	0	\N
106	MAXIMUM TABLES IN SELECT	0	\N
25000	MAXIMUM CURRENT DEFAULT TRANSFORM GROUP LENGTH	\N	\N
25001	MAXIMUM CURRENT TRANSFORM GROUP LENGTH	\N	\N
25002	MAXIMUM CURRENT PATH LENGTH	0	\N
25003	MAXIMUM CURRENT ROLE LENGTH	\N	\N
34	MAXIMUM CATALOG NAME LENGTH	63	Might be less, depending on character set.
30	MAXIMUM COLUMN NAME LENGTH	63	Might be less, depending on character set.
31	MAXIMUM CURSOR NAME LENGTH	63	Might be less, depending on character set.
10005	MAXIMUM IDENTIFIER LENGTH	63	Might be less, depending on character set.
32	MAXIMUM SCHEMA NAME LENGTH	63	Might be less, depending on character set.
35	MAXIMUM TABLE NAME LENGTH	63	Might be less, depending on character set.
107	MAXIMUM USER NAME LENGTH	63	Might be less, depending on character set.
25004	MAXIMUM SESSION USER LENGTH	63	Might be less, depending on character set.
25005	MAXIMUM SYSTEM USER LENGTH	63	Might be less, depending on character set.
\.


--
-- Name: SCHEMA information_schema; Type: ACL; Schema: -; Owner: postgres
--

GRANT USAGE ON SCHEMA information_schema TO PUBLIC;


--
-- Name: TABLE applicable_roles; Type: ACL; Schema: information_schema; Owner: postgres
--

GRANT SELECT ON TABLE information_schema.applicable_roles TO PUBLIC;


--
-- Name: TABLE administrable_role_authorizations; Type: ACL; Schema: information_schema; Owner: postgres
--

GRANT SELECT ON TABLE information_schema.administrable_role_authorizations TO PUBLIC;


--
-- Name: TABLE attributes; Type: ACL; Schema: information_schema; Owner: postgres
--

GRANT SELECT ON TABLE information_schema.attributes TO PUBLIC;


--
-- Name: TABLE character_sets; Type: ACL; Schema: information_schema; Owner: postgres
--

GRANT SELECT ON TABLE information_schema.character_sets TO PUBLIC;


--
-- Name: TABLE check_constraint_routine_usage; Type: ACL; Schema: information_schema; Owner: postgres
--

GRANT SELECT ON TABLE information_schema.check_constraint_routine_usage TO PUBLIC;


--
-- Name: TABLE check_constraints; Type: ACL; Schema: information_schema; Owner: postgres
--

GRANT SELECT ON TABLE information_schema.check_constraints TO PUBLIC;


--
-- Name: TABLE collation_character_set_applicability; Type: ACL; Schema: information_schema; Owner: postgres
--

GRANT SELECT ON TABLE information_schema.collation_character_set_applicability TO PUBLIC;


--
-- Name: TABLE collations; Type: ACL; Schema: information_schema; Owner: postgres
--

GRANT SELECT ON TABLE information_schema.collations TO PUBLIC;


--
-- Name: TABLE column_column_usage; Type: ACL; Schema: information_schema; Owner: postgres
--

GRANT SELECT ON TABLE information_schema.column_column_usage TO PUBLIC;


--
-- Name: TABLE column_domain_usage; Type: ACL; Schema: information_schema; Owner: postgres
--

GRANT SELECT ON TABLE information_schema.column_domain_usage TO PUBLIC;


--
-- Name: TABLE column_options; Type: ACL; Schema: information_schema; Owner: postgres
--

GRANT SELECT ON TABLE information_schema.column_options TO PUBLIC;


--
-- Name: TABLE column_privileges; Type: ACL; Schema: information_schema; Owner: postgres
--

GRANT SELECT ON TABLE information_schema.column_privileges TO PUBLIC;


--
-- Name: TABLE column_udt_usage; Type: ACL; Schema: information_schema; Owner: postgres
--

GRANT SELECT ON TABLE information_schema.column_udt_usage TO PUBLIC;


--
-- Name: TABLE columns; Type: ACL; Schema: information_schema; Owner: postgres
--

GRANT SELECT ON TABLE information_schema.columns TO PUBLIC;


--
-- Name: TABLE constraint_column_usage; Type: ACL; Schema: information_schema; Owner: postgres
--

GRANT SELECT ON TABLE information_schema.constraint_column_usage TO PUBLIC;


--
-- Name: TABLE constraint_table_usage; Type: ACL; Schema: information_schema; Owner: postgres
--

GRANT SELECT ON TABLE information_schema.constraint_table_usage TO PUBLIC;


--
-- Name: TABLE domains; Type: ACL; Schema: information_schema; Owner: postgres
--

GRANT SELECT ON TABLE information_schema.domains TO PUBLIC;


--
-- Name: TABLE parameters; Type: ACL; Schema: information_schema; Owner: postgres
--

GRANT SELECT ON TABLE information_schema.parameters TO PUBLIC;


--
-- Name: TABLE routines; Type: ACL; Schema: information_schema; Owner: postgres
--

GRANT SELECT ON TABLE information_schema.routines TO PUBLIC;


--
-- Name: TABLE data_type_privileges; Type: ACL; Schema: information_schema; Owner: postgres
--

GRANT SELECT ON TABLE information_schema.data_type_privileges TO PUBLIC;


--
-- Name: TABLE domain_constraints; Type: ACL; Schema: information_schema; Owner: postgres
--

GRANT SELECT ON TABLE information_schema.domain_constraints TO PUBLIC;


--
-- Name: TABLE domain_udt_usage; Type: ACL; Schema: information_schema; Owner: postgres
--

GRANT SELECT ON TABLE information_schema.domain_udt_usage TO PUBLIC;


--
-- Name: TABLE element_types; Type: ACL; Schema: information_schema; Owner: postgres
--

GRANT SELECT ON TABLE information_schema.element_types TO PUBLIC;


--
-- Name: TABLE enabled_roles; Type: ACL; Schema: information_schema; Owner: postgres
--

GRANT SELECT ON TABLE information_schema.enabled_roles TO PUBLIC;


--
-- Name: TABLE foreign_data_wrapper_options; Type: ACL; Schema: information_schema; Owner: postgres
--

GRANT SELECT ON TABLE information_schema.foreign_data_wrapper_options TO PUBLIC;


--
-- Name: TABLE foreign_data_wrappers; Type: ACL; Schema: information_schema; Owner: postgres
--

GRANT SELECT ON TABLE information_schema.foreign_data_wrappers TO PUBLIC;


--
-- Name: TABLE foreign_server_options; Type: ACL; Schema: information_schema; Owner: postgres
--

GRANT SELECT ON TABLE information_schema.foreign_server_options TO PUBLIC;


--
-- Name: TABLE foreign_servers; Type: ACL; Schema: information_schema; Owner: postgres
--

GRANT SELECT ON TABLE information_schema.foreign_servers TO PUBLIC;


--
-- Name: TABLE foreign_table_options; Type: ACL; Schema: information_schema; Owner: postgres
--

GRANT SELECT ON TABLE information_schema.foreign_table_options TO PUBLIC;


--
-- Name: TABLE foreign_tables; Type: ACL; Schema: information_schema; Owner: postgres
--

GRANT SELECT ON TABLE information_schema.foreign_tables TO PUBLIC;


--
-- Name: TABLE information_schema_catalog_name; Type: ACL; Schema: information_schema; Owner: postgres
--

GRANT SELECT ON TABLE information_schema.information_schema_catalog_name TO PUBLIC;


--
-- Name: TABLE key_column_usage; Type: ACL; Schema: information_schema; Owner: postgres
--

GRANT SELECT ON TABLE information_schema.key_column_usage TO PUBLIC;


--
-- Name: TABLE referential_constraints; Type: ACL; Schema: information_schema; Owner: postgres
--

GRANT SELECT ON TABLE information_schema.referential_constraints TO PUBLIC;


--
-- Name: TABLE role_column_grants; Type: ACL; Schema: information_schema; Owner: postgres
--

GRANT SELECT ON TABLE information_schema.role_column_grants TO PUBLIC;


--
-- Name: TABLE routine_privileges; Type: ACL; Schema: information_schema; Owner: postgres
--

GRANT SELECT ON TABLE information_schema.routine_privileges TO PUBLIC;


--
-- Name: TABLE role_routine_grants; Type: ACL; Schema: information_schema; Owner: postgres
--

GRANT SELECT ON TABLE information_schema.role_routine_grants TO PUBLIC;


--
-- Name: TABLE table_privileges; Type: ACL; Schema: information_schema; Owner: postgres
--

GRANT SELECT ON TABLE information_schema.table_privileges TO PUBLIC;


--
-- Name: TABLE role_table_grants; Type: ACL; Schema: information_schema; Owner: postgres
--

GRANT SELECT ON TABLE information_schema.role_table_grants TO PUBLIC;


--
-- Name: TABLE udt_privileges; Type: ACL; Schema: information_schema; Owner: postgres
--

GRANT SELECT ON TABLE information_schema.udt_privileges TO PUBLIC;


--
-- Name: TABLE role_udt_grants; Type: ACL; Schema: information_schema; Owner: postgres
--

GRANT SELECT ON TABLE information_schema.role_udt_grants TO PUBLIC;


--
-- Name: TABLE usage_privileges; Type: ACL; Schema: information_schema; Owner: postgres
--

GRANT SELECT ON TABLE information_schema.usage_privileges TO PUBLIC;


--
-- Name: TABLE role_usage_grants; Type: ACL; Schema: information_schema; Owner: postgres
--

GRANT SELECT ON TABLE information_schema.role_usage_grants TO PUBLIC;


--
-- Name: TABLE schemata; Type: ACL; Schema: information_schema; Owner: postgres
--

GRANT SELECT ON TABLE information_schema.schemata TO PUBLIC;


--
-- Name: TABLE sequences; Type: ACL; Schema: information_schema; Owner: postgres
--

GRANT SELECT ON TABLE information_schema.sequences TO PUBLIC;


--
-- Name: TABLE sql_features; Type: ACL; Schema: information_schema; Owner: postgres
--

GRANT SELECT ON TABLE information_schema.sql_features TO PUBLIC;


--
-- Name: TABLE sql_implementation_info; Type: ACL; Schema: information_schema; Owner: postgres
--

GRANT SELECT ON TABLE information_schema.sql_implementation_info TO PUBLIC;


--
-- Name: TABLE sql_sizing; Type: ACL; Schema: information_schema; Owner: postgres
--

GRANT SELECT ON TABLE information_schema.sql_sizing TO PUBLIC;


--
-- Name: TABLE table_constraints; Type: ACL; Schema: information_schema; Owner: postgres
--

GRANT SELECT ON TABLE information_schema.table_constraints TO PUBLIC;


--
-- Name: TABLE tables; Type: ACL; Schema: information_schema; Owner: postgres
--

GRANT SELECT ON TABLE information_schema.tables TO PUBLIC;


--
-- Name: TABLE triggered_update_columns; Type: ACL; Schema: information_schema; Owner: postgres
--

GRANT SELECT ON TABLE information_schema.triggered_update_columns TO PUBLIC;


--
-- Name: TABLE triggers; Type: ACL; Schema: information_schema; Owner: postgres
--

GRANT SELECT ON TABLE information_schema.triggers TO PUBLIC;


--
-- Name: TABLE user_defined_types; Type: ACL; Schema: information_schema; Owner: postgres
--

GRANT SELECT ON TABLE information_schema.user_defined_types TO PUBLIC;


--
-- Name: TABLE user_mapping_options; Type: ACL; Schema: information_schema; Owner: postgres
--

GRANT SELECT ON TABLE information_schema.user_mapping_options TO PUBLIC;


--
-- Name: TABLE user_mappings; Type: ACL; Schema: information_schema; Owner: postgres
--

GRANT SELECT ON TABLE information_schema.user_mappings TO PUBLIC;


--
-- Name: TABLE view_column_usage; Type: ACL; Schema: information_schema; Owner: postgres
--

GRANT SELECT ON TABLE information_schema.view_column_usage TO PUBLIC;


--
-- Name: TABLE view_routine_usage; Type: ACL; Schema: information_schema; Owner: postgres
--

GRANT SELECT ON TABLE information_schema.view_routine_usage TO PUBLIC;


--
-- Name: TABLE view_table_usage; Type: ACL; Schema: information_schema; Owner: postgres
--

GRANT SELECT ON TABLE information_schema.view_table_usage TO PUBLIC;


--
-- Name: TABLE views; Type: ACL; Schema: information_schema; Owner: postgres
--

GRANT SELECT ON TABLE information_schema.views TO PUBLIC;


--
-- PostgreSQL database dump complete
--

