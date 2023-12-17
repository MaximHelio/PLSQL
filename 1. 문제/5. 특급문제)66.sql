/*
����2) �Ʒ� SQL�� ��� ����� �����Ͽ� ����ȭ �ϼ���.
       ��, ���� ������ ������� ����
       
       tab_x, tab_y ��� 500���� �̴�.
*/

CREATE TABLE TAB_66
  (C1      VARCHAR2(10),   -- pk Į��1
   C2      VARCHAR2(10),   -- pk Į��2
   C3      VARCHAR2(10),
   C4      VARCHAR2(10),
   C5      VARCHAR2(10)) ;

ALTER TABLE TAB_66 ADD CONSTRAINT PK_TAB_66 PRIMARY(C1, C2);


INSERT INTO TAB_66
SELECT C1, C2, C3, C4, C5
FROM TAB_X_66
WHERE C4 <> 'KK';

CREATE INDEX IX_TAB_Y_66 ON TAB_Y_66(C1);

UPDATE TAB_66 a
SET C5 = (SELECT C5 FROM TAB_Y_66 WHERE C1 = A.C1)
WHERE EXISTS 
      (SELECT 1 FROM TAB_Y_66 WHERE C1 = A.C1)
;

COMMIT;

DROP INDEX IX_TAB_Y_66;
