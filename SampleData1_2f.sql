insert into league
values ('fifa');

insert into league_season
values (5, 'fifa', '2025-10-01', '2025-10-01');

insert into human (english_name, persian_name, id, is_national_code, nationality)
values (ROW ('Mehrshad', 'Valizadeh'), ROW ('مهرشاد', 'ولیزاده ارجمند'), '0441251013', true, 'IRI');

insert into referee
values (10, '0441251013');

insert into referee_in_season_committee
values (10, 'fifa', 5);

insert into week
values ('fifa', 5, 3);

insert into game (league_name, season, week_number, number_in_week)
values ('fifa', 5, 3, 1);

insert into event (league_name, season, week_number, number_in_week)
values ('fifa', 5, 3, 1);

insert into event (league_name, season, week_number, number_in_week, event_time)
values ('fifa', 5, 3, 1, '19:02:47');

select *
from event;