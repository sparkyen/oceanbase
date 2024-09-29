explain extended SELECT * FROM t1
WHERE  c1 in (SELECT c1 FROM t2 WHERE t2.c2 = t1.c2)
AND c1 in (SELECT c1 FROM t2 WHERE t2.c2 = t1.c2 AND t2.c3 > 1);