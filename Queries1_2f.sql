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
    season_id   smallint,
    league_name varchar(30),
    start       date not null,
    finish      date not null,
    primary key (league_name, season_id),
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
    foreign key (league_name, season) references league_season (league_name, season_id)
);

create table stadium
(
    name varchar(30),
    city varchar(10),
    address text,
    capacity smallint,
    facilities text ,
    level smallint ,
    ticket_price int ,
    primary key (name)
);

create table week
(
    league_name varchar(30),
    season_period smallint,
    number smallint,
    start date ,
    ending date ,
    primary key (league_name , season_period , number) ,
    foreign key (league_name , season_period) references league_season(league_name , season_id)
);

create table game
(
    league_name varchar(30),
    season_period smallint,
    week_number smallint , /* todo */
    number_in_week smallint ,
    guest_goals smallint ,
    host_goals smallint ,
    guest_id smallint ,
    host_id smallint ,
    primary key (league_name , season_period , week_number , number_in_week) ,
    foreign key (league_name , season_period , week_number) references week(league_name, season_period, number) ,
    foreign key (guest_id) references team(id),
    foreign key (host_id) references team(id), /*todo : summurize it ?*/
    unique(guest_id , host_id)
) ;

create table team_in_game
(
    team_id smallint,
    league_name varchar(30),
    season_period smallint,
    week_number smallint ,
    game_id smallint,
    primary key (team_id , league_name , season_period , week_number , game_id)
)