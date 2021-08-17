create table if not exists talk
(
    id bigserial
        constraint talk_pk
            primary key,
    title   varchar not null,
    speaker varchar not null

);

create table if not exists rating
(
    talk         bigserial,
    talk_key     integer,
    rating_stars varchar,

    foreign key (talk) references talk (id)
)