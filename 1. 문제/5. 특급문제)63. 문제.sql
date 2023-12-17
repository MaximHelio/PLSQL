/*
실기2) One SQL로 만드시오. 
인덱스 변경 불가. 
작성자의 변경의도가 잘 보이도록 힌트 작성

T1_63
   TRD   VARCHAR2(8)  <== PK1
   COL1  VARCHAR2(8)  <== PK2
   ACNO  VARCHAR2(8)  <== PK3
   C11   VARCHAR2(50)
   C12   VARCHAR2(50)
   C13   VARCHAR2(50)
   C14   VARCHAR2(50)
   
T2_63
   TRD   VARCHAR2(8),  <== PK1
   COL1  VARCHAR2(8),  <== PK2
   ACNO  VARCHAR2(8),  <== PK3
   COL2  NUMBER,       <== PK4
   C11   VARCHAR2(50),
   C12   VARCHAR2(50),
   C13   VARCHAR2(50),
   C14   VARCHAR2(50),

T1 : TRD  칼럼으로 파티션 되어 있으며 월별 100만건
T2 : TRD 칼럼으로 파티션 되어 있으며 월별 3000만건
PARAM1 = 파라미터로 특정일
PARAM6 = PARAM1의 6개월 전
인덱스)
IX_T1_63 : ACNO+TRD (LOCAL)
PK_T1_63 : TRD+COL1+ACNO (LOCAL)
IX_T2_63 : TRD+ACNO(LOCAL)   
*/

DECLARE

CURSOR CUR_NM IS
  SELECT DISTINCT ACNO FROM T2 WHERE TRD='20171217';

BEGIN
    FOR CUR_NM IN CUR_LIST LOOP
       INSERT INTO T3(............)
       SELECT COL1, COL2, COL3.......
         FROM T1 A
        WHERE A.ACNO = CUR.ACNO
           AND TRD = (SELECT MAX(TRD)
                           FROM T1 X
                          WHERE X.ACNO = CUR.ACNO
                             AND X.TRD >= '20170617'
                             AND X.TRD <  '20171217'                             
                          )
    END LOOP;

END;