SET character_set_database=utf8;
-- DROP SCHEMA
DROP database if exists `irail-datatec`;

-- RECREATE SCHEMA
CREATE database `irail-datatec` CHARACTER SET utf8 COLLATE utf8_general_ci;

-- Recreate Table Structure
use 'irail-datatec';

CREATE TABLE `tecgtfs_agency` (
  `agency_id` INT(11) NOT NULL,
  `agency_name` VARCHAR(20) NOT NULL,
  `agency_url` VARCHAR(255) NOT NULL,
  `agency_timezone` VARCHAR(55) NOT NULL,
  `agency_phone` VARCHAR(20) NOT NULL,
  `agency_lang` VARCHAR(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `tecgtfs_calendar_dates` (
  `service_id` VARCHAR(20) NOT NULL,
  `date` DATE NOT NULL,
  `exception_type` INT(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `tecgtfs_routes` (
  `route_id` VARCHAR(20) NOT NULL,
  `agency_id` INT(11) NOT NULL,
  `route_short_name` VARCHAR(10) NOT NULL,
  `route_long_name` VARCHAR(100) NOT NULL,
  `route_desc` VARCHAR(255) NOT NULL,
  `route_type` INT(11) NOT NULL,
  `route_color` VARCHAR(6) NOT NULL,
  `route_text_color` VARCHAR(6) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `tecgtfs_stop_times` (
  `trip_id` VARCHAR(20) NOT NULL,
  `stop_sequence` INT(11) NOT NULL,
  `stop_id` VARCHAR(20) NOT NULL,
  `stop_headsign` INT(11),
  `arrival_time` TIME,
  `departure_time` TIME,
  `pickup_type` INT(11) NOT NULL,
  `drop_off_type` INT(11) NOT NULL,
  `timepoint` INT(11) NOT NULL,
  `shape_dist_traveled` VARCHAR(10) NOT NULL,
  `fare_units_traveled` VARCHAR(10) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `tecgtfs_stops` (
  `stop_id` VARCHAR(20) NOT NULL,
  `stop_code` VARCHAR(10) NOT NULL,
  `stop_name` VARCHAR(255) NOT NULL,
  `stop_lat` VARCHAR(25) NOT NULL,
  `stop_lon` VARCHAR(25) NOT NULL,
  `location_type` VARCHAR(10) NOT NULL,
  `parent_station` VARCHAR(20) NOT NULL,
  `stop_timezone` VARCHAR(20) NOT NULL,
  `wheelchair_boarding` VARCHAR(10) NOT NULL,
  `platform_code` VARCHAR(20) NOT NULL,
  `zone_id` INT(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `tecgtfs_trips` (
  `route_id` VARCHAR(20) NOT NULL,
  `service_id` VARCHAR(20) NOT NULL,
  `trip_id` VARCHAR(20) NOT NULL,
  `trip_headsign` VARCHAR(150) NULL,
  `trip_short_name` VARCHAR(45) NULL,
  `trip_long_name`  VARCHAR(150) NULL,
  `direction_id` VARCHAR(30) NOT NULL,
  `block_id` INT(11) NOT NULL,
  `shape_id` INT(11) NOT NULL,
  `wheelchair_accessible` INT(1) NOT NULL,
  `bikes_allowed` INT(1) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `tecgtfs_feed_info` (
  `feed_publisher_name` VARCHAR(20) NOT NULL,
  `feed_publisher_url` VARCHAR(20) NOT NULL,
  `feed_lang` VARCHAR(10) NOT NULL,
  `feed_start_date` VARCHAR(20) NOT NULL,
  `feed_end_date` VARCHAR(20) NOT NULL,
  `feed_version` INT(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Primary Keys

ALTER TABLE `tecgtfs_agency` 
  ADD PRIMARY KEY (`agency_id`);

ALTER TABLE `tecgtfs_routes` 
  ADD PRIMARY KEY (`route_id`); 

ALTER TABLE `tecgtfs_stops` 
  ADD PRIMARY KEY (`stop_id`);

ALTER TABLE `tecgtfs_trips` 
  ADD PRIMARY KEY (`trip_id`);
  
-- Indexes
  
ALTER TABLE `tecgtfs_routes` 
  ADD INDEX `IND_ROUTE_AGENCY_ID` (`agency_id` ASC);

ALTER TABLE `tecgtfs_stop_times` 
  ADD INDEX `IND_STOP_TIMES_STOP_ID` (`stop_id` ASC);
  
ALTER TABLE `tecgtfs_stops`  
  ADD INDEX `IND_STOPS_STOP_CODE` (`stop_code` ASC);
  
ALTER TABLE `tecgtfs_calendar_dates` 
  ADD INDEX `IND_CALENDAR_DATES_SERVICE_ID` (`service_id` ASC);
  
ALTER TABLE `tecgtfs_stop_times` 
  ADD INDEX `IND_STOP_TIMES_DEPARTURE_TIME` (`departure_time` ASC);

ALTER TABLE `tecgtfs_stops` 
  ADD INDEX `DL_STOPS_STOP_NAME_IND` (`stop_name` ASC);

-- Indexes for Foreign Keys
  
ALTER TABLE `tecgtfs_trips`
  ADD INDEX `FK_TRIPS_ROUTES` (`route_id` ASC) ;

ALTER TABLE `tecgtfs_trips`
  ADD INDEX `FK_TRIPS_CALENDAR` (`service_id` ASC);
  
ALTER TABLE `tecgtfs_stop_times` 
  ADD INDEX `FK_STOP_TIMES_TRIPS` (`trip_id` ASC);
  
ALTER TABLE `tecgtfs_routes`
  ADD INDEX `FK_ROUTES_AGENCIES` (`agency_id` ASC);
  
ALTER TABLE `tecgtfs_stop_times`
  ADD INDEX `FK_STOP_TIMES_STOPS` (`stop_id` ASC);
  
-- Foreign Keys

ALTER TABLE `tecgtfs_trips`
  ADD CONSTRAINT `FK_TRIPS_ROUTES`
  FOREIGN KEY (`route_id`)
  REFERENCES `tecgtfs_routes` (`route_id`)
  ON DELETE NO ACTION
  ON UPDATE NO ACTION;
  
ALTER TABLE `tecgtfs_trips`
  ADD CONSTRAINT `FK_TRIPS_CALENDAR`
  FOREIGN KEY (`service_id`)
  REFERENCES `tecgtfs_calendar_dates` (`service_id` )
  ON DELETE NO ACTION
  ON UPDATE NO ACTION;

ALTER TABLE `tecgtfs_stop_times` 
  ADD CONSTRAINT `FK_STOP_TIMES_TRIPS`
  FOREIGN KEY (`trip_id`)
  REFERENCES `tecgtfs_trips` (`trip_id` )
  ON DELETE NO ACTION
  ON UPDATE NO ACTION;

ALTER TABLE `tecgtfs_routes` 
  ADD CONSTRAINT `FK_ROUTES_AGENCIES`
  FOREIGN KEY (`agency_id`)
  REFERENCES `tecgtfs_agency` (`agency_id` )
  ON DELETE NO ACTION
  ON UPDATE NO ACTION;

ALTER TABLE `tecgtfs_stop_times` 
  ADD CONSTRAINT `FK_STOP_TIMES_STOPS`
  FOREIGN KEY (`stop_id`)
  REFERENCES `tecgtfs_stops` (`stop_id`)
  ON DELETE NO ACTION
  ON UPDATE NO ACTION;

-- AGENCY (tec.tecgtfs_agency)
LOAD DATA LOCAL INFILE '/tmp/gtfs-tec/agency.txt' INTO TABLE `tecgtfs_agency` CHARACTER SET utf8 FIELDS TERMINATED BY ',' IGNORE 1 LINES (agency_id, agency_name, agency_url, agency_timezone, agency_phone, agency_lang);

-- ROUTES (tec.tecgtfs_routes);
LOAD DATA LOCAL INFILE '/tmp/gtfs-tec/routes.txt' INTO TABLE `tecgtfs_routes` CHARACTER SET utf8 FIELDS TERMINATED BY ',' IGNORE 1 LINES (route_id, agency_id, route_short_name, route_long_name, route_desc, route_type, route_color, route_text_color);

-- CALENDAR_DATES (tec.tecgtfs_calendar_dates)
LOAD DATA LOCAL INFILE '/tmp/gtfs-tec/calendar_dates.txt' INTO TABLE `tecgtfs_calendar_dates` CHARACTER SET utf8 FIELDS TERMINATED BY ',' IGNORE 1 LINES (service_id, @date, exception_type)
SET date = STR_TO_DATE(@date, '%Y%m%d');

-- TRIPS (tec.tecgtfs_trips)
LOAD DATA LOCAL INFILE '/tmp/gtfs-tec/trips.txt' INTO TABLE `tecgtfs_trips` CHARACTER SET utf8 FIELDS TERMINATED BY ',' IGNORE 1 LINES (route_id, service_id, trip_id, trip_headsign, trip_short_name, trip_long_name, direction_id, @block_id, @shape_id, wheelchair_accessible, bikes_allowed)
SET block_id = 0+@block_id, 
	shape_id = 0+@shape_id;

-- -- STOPS (tec.tecgtfs_stops)
LOAD DATA LOCAL INFILE '/tmp/gtfs-tec/stops.txt' INTO TABLE `tecgtfs_stops` CHARACTER SET utf8 FIELDS TERMINATED BY ',' IGNORE 1 LINES (stop_id, stop_code, stop_name, stop_lat, stop_lon, location_type, parent_station, stop_timezone, wheelchair_boarding, platform_code, @zone_id)
SET zone_id = 0+@zone_id;

-- -- STOP_TIMES (tecgtf_stop_times)
LOAD DATA LOCAL INFILE '/tmp/gtfs-tec/stop_times.txt' INTO TABLE `tecgtfs_stop_times` CHARACTER SET utf8 FIELDS TERMINATED BY ',' IGNORE 1 LINES (trip_id, stop_sequence, stop_id, stop_headsign, arrival_time, departure_time, pickup_type, drop_off_type, timepoint, shape_dist_traveled, fare_units_traveled);

-- FEED_FINO (tec.tecgtfs_feed_info)
LOAD DATA LOCAL INFILE '/tmp/gtfs-tec/feed_info.txt' INTO TABLE `tecgtfs_feed_info` CHARACTER SET utf8 FIELDS TERMINATED BY ',' IGNORE 1 LINES (feed_publisher_name,feed_publisher_url,feed_lang,@feed_start_date,@feed_end_date,feed_version)
SET feed_start_date = STR_TO_DATE(@feed_start_date, '%Y%m%d'),
    feed_end_date = STR_TO_DATE(@feed_end_date, '%Y%m%d');

