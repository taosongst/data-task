-- Written in postgresql gramm

select
    array_agg(t1.user_id)                                                   as user_id,
    t1.created_month                                                        as created_month,
    sum(t1.complete_first_month)::double precision / count(t1.user_id)      as complete_ratio
from
(
    select
        t.user_id                                                               as user_id,
        to_char(t.created_at, 'YYYY-MM')                                        as created_month,
        case
            when t.complete_at is null then 0
            when to_char(t.created_at, 'YYYY-MM') = to_char(t.complete_at, 'YYYY-MM') then 1
            else 0
        end                                                                     as complete_first_month
    from
    (
        select
            u.user_id                               as user_id,
            u.created_at                            as created_at,
            min(e.completion_date)                  as complete_at
        from
            users u
        left join
            exercises e
        on
            u.user_id = e.user_id
        group by
            u.user_id
    ) as t(user_id, created_at, complete_at)
) as t1(user_id, created_month, complete_first_month)
group by t1.created_month;

--



--Question 2 

select
    count(t.user_id)							as number_of_users,								
    t.ex_count								as number_of_activities    
from
(
    select 
    	user_id								as user_id,
    	count(exercise_id)						as ex_count
    from exercises
    group by user_id						

) as t(user_id, ex_count)
group by 
    t.ex_count;



--Question 3

select top(5)
    t.organization_id					as organization_id
    count(t.patiend_id)					as num_patients
    
from
(
select
    q.patient_id					as patient_id
    p.provider_id					as provider_id
    p.organization_id					as organization_id
    q.score						as score
from
    Providers p
left join 
    Phq0 q
on
    p.provider_id = q.provider_id
) as t(patient_id, provider_id, organization_id,score)	
order by 
    num_patients desc
where 
    t.score > 19
group by 
    t.organization_id
    







