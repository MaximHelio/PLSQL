/*==========================================
    ������ 1��
    
���� SQL�� Ʃ���Ͻÿ�.
  - Ʃ�� �� ��Ʈ�� ���� ���� (��Ƽ�������� �˾Ƽ� ó���ϵ��� �� ��)
  - UNION ALL�� �ٸ� ����ȭ ����� ���� ��쿡�� ����ϵ��� �� ��
  - I/O�� �����̶� �پ��ٸ� INDEX �߰� ����
  - ��, ���ʿ��� INDEX�� ��� ������ ����
==========================================*/

CREATE TABLE YOON.T_TAB64 
  ( CNO    NUMBER         NOT NULL
  , DT     VARCHAR2(8)    NOT NULL
  , SEQ    NUMBER         NOT NULL
  , PRCD   VARCHAR2(7)    NOT NULL
  , ORDQ   NUMBER
  , ORDP   NUMBER
  , DCSSCD VARCHAR2(7)  
  , CLCD   VARCHAR2(7)
  , CONSTRAINT PKT_T_64 PRIMARY KEY(CNO, DT, SEQ, PRCD)
  ) NOLOGGING;
  
/*  DT   : �Ϸ���� 100���� (DT CARDINALITY 1,000,000)
    CNO  : �Ϸ���� 3��
    PRCD : �Ϸ���� 100��
    
�ε��� : PK �� ���� (CNO, DT, SEQ, PRCD)
*/

SELECT O.CNO, O.DT, O.SEQ, O.PRCD, O.ORDQ, O.ORDP
     , (SELECT MAX(DT)
        FROM   T_TAB64
        WHERE  CNO  = O.CNO
         AND   PRCD = O.PRCD
         AND   DCSSCD IN ('D49997', 'D49930')
         AND   DT <= O.DT) PRVLAST
FROM T_TAB64 O
WHERE O.DT  BETWEEN  '20180203' AND '20180205'
 AND  O.PRCD IN ('P000003', 'P000045', 'P000070')
 -- CNO�� ��� �ɼ� ����, ȭ�鼭 CNO ������ �Էµ��� ���� �� ����
 AND (:CNO IS NULL  OR  O.CNO = :CNO)
;
