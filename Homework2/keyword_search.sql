-- adding bag-of-words represeenation of query into temporary table

--if exists (SELECT * FROM sqlite_master WHERE name ='temp_1' and type='table') 
--    drop table temp_1;
     
CREATE TABLE temp_1 (
docid VARCHAR(255),
term VARCHAR(255),
count int,
PRIMARY KEY(docid, term));


insert INTO temp_1  
Select *
from
(
SELECT * FROM frequency
UNION
SELECT 'q' as docid, 'washington' as term, 1 as [count] 
UNION
SELECT 'q' as docid, 'taxes' as term, 1 as [count]
UNION 
SELECT 'q' as docid, 'treasury' as term, 1 as [count]
);

-- computing similarity score between query and all other documents
--if exists (SELECT * FROM sqlite_master WHERE name ='temp_2' and type='table') 
--    drop table temp_2;

CREATE TABLE temp_2 (
docid VARCHAR(255),
score int);

insert into temp_2
SELECT 
    B.docid as doc,
    SUM(a.[count] * b.[count] ) AS sim_score
from
    temp_1 A
    join temp_1 B on A.term=B.term
where A.docid = 'q'
group by 
    A.docid,
    B.docid
    ;

-- returning maximum similarity score for our query
Select max(score)
from
    temp_2;

--cleaning up
drop table temp_1;
DROP table temp_2;
    