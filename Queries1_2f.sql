create table league
(
    name varchar(30) not null,
    primary key (name)
);

create table team
(
    id         integer,
    name       varchar(30) not null unique,
    foundation date        not null,
    city       varchar(20),
    primary key (id)
);

create table league_season
(
    season   smallint,
    league_name varchar(30),
    start       date not null,
    finish      date not null,
    primary key (league_name, season),
    foreign key (league_name) references league (name)
);

create table team_in_season
(
    team_id     smallint,
    season      smallint,
    league_name varchar(30),
    rank        smallint,
    score       smallint default 0,
    primary key (team_id, season, league_name),
    foreign key (team_id) references team (id),
    foreign key (league_name, season) references league_season (league_name, season)
);

CREATE type stadium_level as enum ('A' , 'B' , 'C') ;

create table stadium
(
    name varchar(30),
    city varchar(10),
    address text,
    capacity smallint,
    facilities text ,
    level stadium_level ,
    ticket_price int ,
    primary key (name)
);

create table week
(
    league_name varchar(30),
    season smallint,
    number smallint,
    start date ,
    ending date ,
    primary key (league_name , season , number) ,
    foreign key (league_name , season) references league_season(league_name , season)
);

create table game /* todo description */
(
    league_name varchar(30),
    season smallint,
    week_number smallint , /* todo */
    number_in_week smallint ,
    guest_id smallint ,
    host_id smallint ,
    stadium varchar(30) ,
    guest_goal smallint ,
    host_goal smallint ,
    data date ,
    time time ,
    primary key (league_name , season , week_number , number_in_week) ,
    foreign key (league_name , season , week_number) references week(league_name, season, number) ,
    foreign key (guest_id) references team(id),
    foreign key (host_id) references team(id), /*todo : summurize it ?*/
    foreign key (stadium) references stadium(name) ,
    unique(guest_id , host_id)
) ;

create type statistics as (
    goals smallint ,
    passes smallint ,
    success_pass smallint ,
    ball_possession numeric(4,2) ,
    opportunities smallint ,
    corners smallint ,
    offside smallint ,
    shoots smallint
    );

create table team_in_game /* todo week entity of two entity*/
(
    team_id smallint,
    league_name varchar(30),
    season smallint,
    week_number smallint ,
    game_id smallint,
    statistics statistics ,
    score smallint ,
    primary key (team_id , league_name , season , week_number , game_id) ,
    foreign key (team_id , league_name , season) references team_in_season(team_id , league_name , season) ,
    foreign key (game_id , week_number) references game(number_in_week , week_number) ,
    /* todo
    how check to this game even exists and how check that a team in season 5 do not playa a game in season 10 */
);

create type full_name as (
    first_name varchar(10) ,
    last_name varchar(15)
);
create table human (
    english_name full_name ,
    persian_name full_name ,
    address text,
    birthday date,
    nationality varchar(15),
    is_national_code boolean ,
    id char(10),
    primary key (id, is_national_code)
) ;

create table player
(
    player_id smallint,
    registration_date date,
    human_id char(10),
    is_national_code boolean,
    primary key (player_id),
    foreign key (human_id, is_national_code) references human(id, is_national_code),
    unique(human_id , is_national_code)
/* TODO: store free intervals) */
);

create table technical_personnel
(
    human_id char(10) ,
    is_national_code boolean,
    primary key (human_id , is_national_code)
) ;

create type side as enum('head_coach' , 'coach' , 'doctor' , 'supervisor' , 'others');

create table technical_sides
(
    personnel_id char(10) ,
    is_national_code boolean ,
    side side ,
    primary key (personnel_id , is_national_code , side) ,
    foreign key (personnel_id , is_national_code) references technical_personnel(human_id, is_national_code)
);

/*change your aggregation*/
create table technical_in_game(
    personnel_id char(10) ,
    is_national_code boolean ,
    side side,
    team_id smallint,
    league_name varchar(30),
    season smallint,
    week_number smallint ,
    game_id smallint,
    primary key (personnel_id , is_national_code , side , team_id , league_name , season , week_number , game_id) ,
    foreign key (personnel_id , is_national_code , side) references technical_sides(personnel_id, is_national_code, side) ,
    foreign key (team_id , league_name , season , week_number , game_id) references
        team_in_game(team_id, league_name, season, week_number, game_id)
);

create table foreign_team (
    foreign_id smallint ,
    country varchar(15) ,
    name varchar(30),
    primary key (foreign_id)
);

/* !!!!!!!!!!!! players agreement */

create table foreign_agreement(
    player smallint ,
    foreign_team smallint ,
    league_name varchar(30),
    season smallint,
    native_team smallint,
    price bigint ,
    is_buying boolean , /* true if native team is buying*/
    date date ,
    primary key (is_buying , player , foreign_team , league_name , season , native_team) ,
    foreign key (player) references player(player_id),
    foreign key (foreign_team) references foreign_team(foreign_id),
    foreign key (league_name , season , native_team) references team_in_season(league_name , season , team_id)
);

create table inner_agreement(
    player smallint ,
    seller smallint ,
    league_name varchar(30),
    season smallint,
    buyer smallint,
    price bigint ,
    date date ,
    primary key (player , seller , league_name , season , buyer) ,
    foreign key (player) references player(player_id),
    foreign key (seller) references team_in_season(team_id),
    foreign key (league_name , season , buyer) references team_in_season(league_name , season , team_id)
);

create table free_players_agreement(
    player smallint ,
    league_name varchar(30),
    season smallint,
    buyer smallint,
    price bigint ,
    date date ,
    primary key (player , league_name , season , buyer) ,
    foreign key (player) references player(player_id),
    foreign key (league_name , season , buyer) references team_in_season(league_name , season , team_id)
);

create table agreement_canceling(
    player smallint,
    league_name varchar(30),
    season smallint,
    buyer smallint,
    cost bigint ,
    date date ,
    primary key (player , league_name , season , buyer) ,
    foreign key (player) references player(player_id),
    foreign key (league_name , season , buyer) references team_in_season(league_name , season , team_id)
);
/* todo : trades at first of leagues */
/* end of trades */

create table referee
(
    id               smallint,
    human_id         char(10),
    is_national_code boolean,
    level            smallint,
    primary key (id),
    foreign key (human_id, is_national_code) references human (id, is_national_code),
    unique (human_id , is_national_code)
);

create table referee_team
(
    league_name varchar(30),
    season smallint,
    week_number smallint , /* todo */
    number_in_week smallint ,
    main_referee smallint ,
    first_assistant smallint ,
    second_assistant smallint ,
    fourth_referee smallint,
    supervisor smallint ,
    primary key (league_name , season , week_number , number_in_week) refrences
);

create type referee_position
as enum ('main referee', 'first assistant referee', 'second assistant referee', 'supervisor');

create table referee_in_league_committee
(
    referee_id int references referee(id),
    league_name varchar(30)
/* TODO */
);