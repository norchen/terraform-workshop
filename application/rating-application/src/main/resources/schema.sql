create table if not exists talk
(
    id bigserial
        constraint talk_pk
            primary key,
    title   varchar not null,
    speaker varchar not null,
    rating_stars varchar
);
