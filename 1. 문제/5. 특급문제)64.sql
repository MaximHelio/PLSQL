/*==========================================
    서술형 1번
    
다음 SQL을 튜닝하시오.
  - 튜닝 시 힌트를 주지 말것 (옵티마이저가 알아서 처리하도록 할 것)
  - UNION ALL은 다른 최적화 방안이 없는 경우에만 사용하도록 할 것
  - I/O가 조금이라도 줄어든다면 INDEX 추가 가능
  - 단, 불필요한 INDEX의 경우 감점이 있음
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
  
/*  DT   : 하루평균 100만건 (DT CARDINALITY 1,000,000)
    CNO  : 하루평균 3건
    PRCD : 하루평균 100건
    
인덱스 : PK 만 존재 (CNO, DT, SEQ, PRCD)
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
 -- CNO의 경우 옵션 조건, 화면서 CNO 조건이 입력되지 않을 수 있음
 AND (:CNO IS NULL  OR  O.CNO = :CNO)
;
