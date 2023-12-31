DROP TABLE YOON.사원;
CREATE TABLE YOON.사원
  (사번  VARCHAR2(2),
   이름  VARCHAR2(50),
   부서코드 VARCHAR2(2),
   직급   VARCHAR2(50)
   
   );
   
create TABLE YOON.부서
   (부서코드   VARCHAR2(2),
    부서명     VARCHAR2(50),
    지역       VARCHAR2(50)
    );
    
CREATE PUBLIC SYNONYM 사원 FOR YOON.사원;
CREATE PUBLIC SYNONYM 부서 FOR YOON.부서;


INSERT INTO 사원 values ('01', 	'홍길동', '01', '부장');
INSERT INTO 사원 values ('02', 	'김길동', '01', '과장');
INSERT INTO 사원 values ('03', 	'이길동', '01', '사원');
INSERT INTO 사원 values ('04', 	'박길동', '02', '부장');
INSERT INTO 사원 values ('05', 	'김성근', '02', '과장');
INSERT INTO 사원 values ('06', 	'홍길동', '02', '사원');
INSERT INTO 사원 values ('07', 	'김길동', '03', '부장');
INSERT INTO 사원 values ('08', 	'이길동', '03', '과장');
INSERT INTO 사원 values ('09', 	'박길동', '03', '사원');
INSERT INTO 사원 values ('00', 	'김성근', '04', '부장');
INSERT INTO 사원 values ('01', 	'홍길동', '04', '과장');
INSERT INTO 사원 values ('02', 	'김길동', '04', '사원');
INSERT INTO 사원 values ('03', 	'이길동', '04', '대리');
INSERT INTO 사원 values ('04', 	'박길동', '04', '차장');

INSERT INTO 부서 VALUES ('01', '인사부', '서울');
INSERT INTO 부서 VALUES ('02', '총무부', '대전');
INSERT INTO 부서 VALUES ('03', '경리부', '대구');
INSERT INTO 부서 VALUES ('04', '구매부', '부산');
INSERT INTO 부서 VALUES ('05', '영업부', '서울');
INSERT INTO 부서 VALUES ('06', '생산부', '서울');

COMMIT;

SELECT  E.사번,  E.이름,  E.직급,
        D.부서코드, D.부서명, D.지역
FROM   부서 D,  사원 E
WHERE  E.부서코드(+)  = D.부서코드
;

SELECT E.사번,  E.이름,  E.직급, 
       D.부서코드, D.부서명, D.지역
FROM 부서 D,  사원 E
WHERE  E.부서코드(+) = D.부서코드
  AND  E.직급(+)     = '부장'
;
