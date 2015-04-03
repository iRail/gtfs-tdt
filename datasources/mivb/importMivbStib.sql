SET character_set_database=utf8;
-- DROP SCHEMA
DROP DATABASE if exists `irail-datamivbstib`;

-- RECREATE SCHEMA
CREATE DATABASE `irail-datamivbstib` CHARACTER SET utf8 COLLATE utf8_general_ci;

-- RECREATE TABLES
USE `irail-datamivbstib`;

CREATE TABLE `mivbstibgtfs_translations` (
  `trans_id` varchar(100) NOT NULL,
  `translation` varchar(255) DEFAULT NULL,
  `lang` varchar(10) DEFAULT NULL,
  PRIMARY KEY (`trans_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `mivbstibgtfs_shapes` (
  `shape_id` varchar(100) NOT NULL,
  `shape_pt_lat` varchar(25) DEFAULT NULL,
  `shape_pt_lon` varchar(25) DEFAULT NULL,
  `shape_pt_sequence` varchar(25) DEFAULT NULL,
  PRIMARY KEY (`shape_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `mivbstibgtfs_calendar` (
  `service_id` varchar(100) NOT NULL,
  `monday` int(1) DEFAULT NULL,
  `tuesday` int(1) DEFAULT NULL,
  `wednesday` int(1) DEFAULT NULL,
  `thursday` int(1) DEFAULT NULL,
  `friday` int(1) DEFAULT NULL,
  `saturday` int(1) DEFAULT NULL,
  `sunday` int(1) DEFAULT NULL,
  `start_date` date DEFAULT NULL,
  `end_date` date DEFAULT NULL,
  PRIMARY KEY (`service_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `mivbstibgtfs_agency` (
  `agency_id` varchar(100) NULL,
  `agency_name` varchar(20) NOT NULL,
  `agency_url` varchar(255) NOT NULL,
  `agency_timezone` varchar(100) NOT NULL,
  `agency_lang` varchar(20) NOT NULL,
  `agency_phone` varchar(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `mivbstibgtfs_calendar_dates` (
  `service_id` varchar(100) NOT NULL,
  `date` DATE NOT NULL,
  `exception_type` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `mivbstibgtfs_routes` (
  `route_id` varchar(100) NOT NULL,
  `agency_id` varchar(100) NOT NULL,
  `route_short_name` varchar(10) NOT NULL,
  `route_long_name` varchar(100) NOT NULL,
  `route_desc` varchar(255) NOT NULL,
  `route_type` int(11) NOT NULL,
  `route_url` varchar(255) NOT NULL,
  `route_color` varchar(6) NOT NULL,
  `route_text_color` varchar(6) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `mivbstibgtfs_stop_times` (
  `trip_id` varchar(100) NOT NULL,
  `arrival_time` VARCHAR(9),
  `departure_time` VARCHAR(9),
  arrival_time_t TIME,
  departure_time_t TIME,
  `stop_id` varchar(100) NOT NULL,
  `stop_sequence` int(11) NOT NULL,
  `stop_headsign` int(11),
  `pickup_type` int(11) NOT NULL,
  `drop_off_type` int(11) NOT NULL,
  `shape_dist_traveled` varchar(10) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `mivbstibgtfs_stops` (
  `stop_id` varchar(100) NOT NULL,
  `stop_code` varchar(10) NOT NULL,
  `stop_name` varchar(255) NOT NULL,
  `stop_desc` varchar(10) NOT NULL,
  `stop_lat` varchar(25) NOT NULL,
  `stop_lon` varchar(25) NOT NULL,
  `zone_id` varchar(100),
  `stop_url` varchar(20) NOT NULL,
  `location_type` varchar(10) NOT NULL,
  `parent_station` varchar(20) NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE  TABLE `mivbstibgtfs_trips` (
  `route_id` varchar(100) NOT NULL ,
  `service_id` varchar(100) NOT NULL ,
  `trip_id` varchar(100) NOT NULL ,
  `trip_headsign` VARCHAR(150) NULL ,
  `trip_short_name` VARCHAR(45) NULL ,
  `direction_id` varchar(100) NULL ,
  `block_id` varchar(100) NULL ,
  `shape_id` varchar(100)NULL ,
  PRIMARY KEY (`trip_id`) 
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Primary Keys

-- ALTER TABLE `irail-datamivbstib`.`mivbstibgtfs_agency` 
--  ADD PRIMARY KEY (`agency_id`);

ALTER TABLE `mivbstibgtfs_routes` 
  ADD PRIMARY KEY (`route_id`); 

ALTER TABLE `mivbstibgtfs_stops` 
  ADD PRIMARY KEY (`stop_id`);
  
-- Indexes
  
-- ALTER TABLE `irail-datamivbstib`.`mivbstibgtfs_routes` 
--  ADD INDEX `IND_MIVB_ROUTE_AGENCY_ID` (`agency_id` ASC);

ALTER TABLE `mivbstibgtfs_stop_times` 
  ADD INDEX `IND_MIVB_STOP_TIMES_STOP_ID_IND` (`stop_id` ASC);
  
ALTER TABLE `mivbstibgtfs_stops`  
  ADD INDEX `IND_MIVB_STOPS_STOP_CODE_IND` (`stop_code` ASC);
  
ALTER TABLE `mivbstibgtfs_calendar_dates` 
  ADD INDEX `IND_MIVB_CALENDAR_DATES_SERVICE_ID_IND` (`service_id` ASC) ;
  
ALTER TABLE `mivbstibgtfs_stop_times` 
  ADD INDEX `IND_MIVB_STOP_TIMES_DEPARTURE_TIME_T_IND` (`departure_time_t` ASC) ;
  
ALTER TABLE `mivbstibgtfs_stops` 
  ADD INDEX `MIVB_STOPS_STOP_NAME_IND` (`stop_name` ASC) ;

-- Indexes for Foreign Keys
  
ALTER TABLE `mivbstibgtfs_trips`
  ADD INDEX FK_MIVB_TRIPS_ROUTES_IND (route_id ASC) ;

ALTER TABLE `mivbstibgtfs_trips`
  ADD INDEX `FK_MIVB_TRIPS_CALENDAR_IND` (`service_id` ASC);
  
ALTER TABLE `mivbstibgtfs_stop_times` 
  ADD INDEX `FK_MIVB_STOP_TIMES_TRIPS_IND` (`trip_id` ASC);
  
-- ALTER TABLE `irail-datamivbstib`.`mivbstibgtfs_routes`
--  ADD INDEX `FK_MIVB_ROUTES_AGENCIES` (`agency_id` ASC);
  
ALTER TABLE `mivbstibgtfs_stop_times`
  ADD INDEX `FK_MIVB_STOP_TIMES_STOPS_IND` (`stop_id` ASC);
  

-- DISABLE FK CHECKS
SET foreign_key_checks = 0;  

-- Foreign Keys

ALTER TABLE `mivbstibgtfs_trips`
  ADD CONSTRAINT FK_MIVB_TRIPS_ROUTES
  FOREIGN KEY (route_id )
  REFERENCES `mivbstibgtfs_routes` (route_id )
  ON DELETE NO ACTION
  ON UPDATE NO ACTION;
  
ALTER TABLE `mivbstibgtfs_trips` 
  ADD CONSTRAINT `FK_MIVB_TRIPS_CALENDAR`
  FOREIGN KEY (`service_id` )
  REFERENCES `mivbstibgtfs_calendar` (`service_id` )
  ON DELETE NO ACTION
  ON UPDATE NO ACTION;

ALTER TABLE `mivbstibgtfs_stop_times` 
  ADD CONSTRAINT `FK_MIVB_STOP_TIMES_TRIPS`
  FOREIGN KEY (`trip_id` )
  REFERENCES `mivbstibgtfs_trips` (`trip_id` )
  ON DELETE NO ACTION
  ON UPDATE NO ACTION;

-- ALTER TABLE `irail-datamivbstib`.`mivbstibgtfs_routes` 
--  ADD CONSTRAINT `FK_MIVB_ROUTES_AGENCIES`
--  FOREIGN KEY (`agency_id` )
--  REFERENCES `irail-datamivbstib`.`mivbstibgtfs_agency` (`agency_id` )
--  ON DELETE NO ACTION
--  ON UPDATE NO ACTION;

ALTER TABLE `mivbstibgtfs_stop_times` 
  ADD CONSTRAINT `FK_MIVB_STOP_TIMES_STOPS`
  FOREIGN KEY (`stop_id` )
  REFERENCES `mivbstibgtfs_stops` (`stop_id` )
  ON DELETE NO ACTION
  ON UPDATE NO ACTION;

  -- ENABLE FK CHECKS
SET foreign_key_checks = 1;

-- AGENCY (mivbstib.mivbstibgtfs_agency)
LOAD DATA LOCAL INFILE '/tmp/mivbstib-gtfs/agency.txt' INTO TABLE `mivbstibgtfs_agency` FIELDS TERMINATED BY ',' ENCLOSED BY '"' LINES TERMINATED BY '\r\n' IGNORE 1 LINES (agency_name, agency_url, agency_timezone, agency_lang, agency_phone)
SET agency_id = '1';

-- ROUTES (mivbstib.mivbstibgtfs_routes);
LOAD DATA LOCAL INFILE '/tmp/mivbstib-gtfs/routes.txt' INTO TABLE `mivbstibgtfs_routes` FIELDS TERMINATED BY ',' ENCLOSED BY '"' LINES TERMINATED BY '\r\n' IGNORE 1 LINES (route_id, route_short_name, route_long_name, route_desc, route_type, route_url, route_color, route_text_color)
SET agency_id = '1';

-- CALENDAR_DATES (mivbstib.mivbstibgtfs_calendar_dates)
LOAD DATA LOCAL INFILE '/tmp/mivbstib-gtfs/calendar_dates.txt' INTO TABLE `mivbstibgtfs_calendar_dates` FIELDS TERMINATED BY ',' ENCLOSED BY '"' LINES TERMINATED BY '\r\n' IGNORE 1 LINES (service_id, @date, exception_type)
SET date = STR_TO_DATE(@date, '%Y%m%d');

-- CALENDAR (mivbstib.mivbstibgtfs_calendar) 
LOAD DATA LOCAL INFILE '/tmp/mivbstib-gtfs/calendar.txt' INTO TABLE `mivbstibgtfs_calendar` FIELDS TERMINATED BY ',' ENCLOSED BY '"' LINES TERMINATED BY '\r\n' IGNORE 1 LINES (service_id, monday, tuesday, wednesday, thursday, friday, saturday, sunday, @start_date, @end_date)
SET start_date = STR_TO_DATE(@start_date, '%Y%m%d'),
	end_date = STR_TO_DATE(@end_date, '%Y%m%d');
	
-- TRIPS (mivbstib.mivbstibgtfs_trips)
LOAD DATA LOCAL INFILE '/tmp/mivbstib-gtfs/trips.txt' INTO TABLE `mivbstibgtfs_trips` FIELDS TERMINATED BY ',' ENCLOSED BY '"' LINES TERMINATED BY '\r\n' IGNORE 1 LINES (route_id, service_id, trip_id, trip_headsign, direction_id, block_id, shape_id);

-- STOPS (mivbstib.mivbstibgtfs_stops)
LOAD DATA LOCAL INFILE '/tmp/mivbstib-gtfs/stops.txt' INTO TABLE `mivbstibgtfs_stops` FIELDS TERMINATED BY ',' ENCLOSED BY '"' LINES TERMINATED BY '\r\n' IGNORE 1 LINES (stop_id, stop_code, stop_name, stop_desc, stop_lat, stop_lon, zone_id, stop_url, location_type);

-- STOP_TIMES (dlgtf_stop_times)
LOAD DATA LOCAL INFILE '/tmp/mivbstib-gtfs/stop_times.txt' INTO TABLE `mivbstibgtfs_stop_times` FIELDS TERMINATED BY ',' ENCLOSED BY '"' LINES TERMINATED BY '\r\n' IGNORE 1 LINES (trip_id,@arrival_time,@departure_time,stop_id,stop_sequence,pickup_type,drop_off_type)
SET arrival_time = @arrival_time,
	departure_time = @departure_time,
	arrival_time_t = IF (0+SUBSTR(@arrival_time, 1,2) < 23, 
    STR_TO_DATE(@arrival_time, '%T'), 
    STR_TO_DATE(CONCAT(0+SUBSTR(@arrival_time, 1,2)-23, SUBSTR(@arrival_time, 3)), '%T')),
    departure_time_t = IF (0+SUBSTR(@departure_time, 1,2) < 23, 
    STR_TO_DATE(@departure_time, '%T'), 
    STR_TO_DATE(CONCAT(0+SUBSTR(@departure_time, 1,2)-23, SUBSTR(@departure_time, 3)), '%T'));
	
-- TRANSLATIONS (mivbstib.mivbstibgtfs_translations)
LOAD DATA LOCAL INFILE '/tmp/mivbstib-gtfs/translations.txt' INTO TABLE `mivbstibgtfs_translations` FIELDS TERMINATED BY ',' ENCLOSED BY '"' LINES TERMINATED BY '\r\n' IGNORE 1 LINES (trans_id, translation, lang);

-- SHAPES (mivbstib.mivbstibgtfs_shapes)
LOAD DATA LOCAL INFILE '/tmp/mivbstib-gtfs/shapes.txt' INTO TABLE `mivbstibgtfs_shapes` FIELDS TERMINATED BY ',' ENCLOSED BY '"' LINES TERMINATED BY '\r\n' IGNORE 1 LINES (shape_id, shape_pt_lat, shape_pt_lon, shape_pt_sequence);

