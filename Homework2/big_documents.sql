SELECT count(*)
from
(
Select 
    docid
    ,SUM([count]) as cnt
from
    frequency
group BY 
    docid
having SUM([count]) > 300);