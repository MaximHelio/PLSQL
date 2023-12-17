[테이블 정보]
* T_MEMBER74                                        -- 회원
    MBR_NO            VARCHAR2(7)    NOT NULL       -- 회원번호  PK
  , MBR_NM            VARCHAR2(50)                  -- 회원명
  , MBR_CD            VARCHAR2(1)                   -- 회원구분코드
  , C1                VARCHAR2(100)
  , C2                VARCHAR2(100)
  , C3                VARCHAR2(100)

* T_BOARD74                                         -- 분류코드 테이블
    BRD_CD            VARCHAR2(2)                   -- 분류코드 PK
  , BRD_NM            VARCHAR2(50)                  -- 분류코드명

* T_ARTICLE74                                       -- 게시판
   ART_NO             VARCHAR2(10)    NOT NULL      -- 게시판번호
 , ART_TIL            VARCHAR2(300)                 -- 제목
 , ART_CONT           VARCHAR2(100)
 , MBR_NO             VARCHAR2(7)                   -- 회원번호 (T_MEMBER74의 FK)
 , BRD_CD             VARCHAR2(3)                   -- 분류코드 (T_BOARD74의 FK)
 , REG_DT             VARCHAR2(8)                   -- 작성일자 
 , C11
 , C12
 , C13

[인덱스]
 PK_T_MEMBER74      (MBR_NO)
 PK_T_BOARD_74      (BRD_CD)
 PK_T_ARTICLE_74    (ART_NO)
 
 IX_ARTICLE_X01     (BRD_CD)
 IX_ARTICLE_X02     (MBR_NO)

[데이터 정보]
T_MEMBER74  : 50만건
T_BOARD74   : 10건
T_ARTICLE74 : 최근 3일 또는 5일 게시글 850여 건

[기존SQL]
바인드변수
var BRD_ID VARCHAR2
exec :BRD_ID := 1; 

SELECT *
FROM
            (SELECT     B.BRD_ID, B.BRD_NM, A.ART_SN, A.ART_TIL
                      , substr(A.ART_CONT,1,3) AS ART_CONT
                      , A.MBR_NO, M.MBR_NM, A.REG_DT
            FROM        BOARD B
                      , ARTICLE A
                      , MEMBER M
            WHERE B.BRD_ID = :BRD_ID
            AND A.BRD_ID = B.BRD_ID
            AND A.MBR_NO = M.MBR_NO
            AND A.REG_DT >= TRUNC(SYSDATE-3)
            ORDER BY A.REG_DT DESC
            )
WHERE ROWNUM <= 5;

SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY_CURSOR(NULL, NULL, 'ADVANCED ALLSTATS LAST'));
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
| Id  | Operation				  | Name	| Starts | E-Rows |E-Bytes| Cost (%CPU)| E-Time   | A-Rows |   A-Time	| Buffers |  OMem |  1Mem | Used-Mem |
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT			  |		|      1 |	  |	  |	7 (100)|	  |	 1 |00:00:00.01 |      10 |	  |   |	     |
|*  1 |  COUNT STOPKEY				  |		|      1 |	  |	  |	       |	  |	 1 |00:00:00.01 |      10 |	  |   |	     |
|   2 |   VIEW					  |		|      1 |	1 |    58 |	7  (15)| 00:00:01 |	 1 |00:00:00.01 |      10 |	  |   |	     |
|*  3 |    SORT ORDER BY STOPKEY		  |		|      1 |	1 |    65 |	7  (15)| 00:00:01 |	 1 |00:00:00.01 |      10 |  2048 |  2048 | 2048  (0)|
|   4 |     NESTED LOOPS			  |		|      1 |	1 |    65 |	6   (0)| 00:00:01 |	 1 |00:00:00.01 |      10 |	  |   |	     |
|   5 |      NESTED LOOPS			  |		|      1 |	1 |    65 |	6   (0)| 00:00:01 |	 1 |00:00:00.01 |	9 |	  |   |	     |
|   6 |       NESTED LOOPS			  |		|      1 |	1 |    53 |	4   (0)| 00:00:01 |	 1 |00:00:00.01 |	6 |	  |   |	     |
|   7 |        TABLE ACCESS BY INDEX ROWID	  | BOARD	|      1 |	1 |	9 |	1   (0)| 00:00:01 |	 1 |00:00:00.01 |	2 |	  |   |	     |
|*  8 | 	INDEX UNIQUE SCAN		  | BOARD_PK	|      1 |	1 |	  |	0   (0)|	  |	 1 |00:00:00.01 |	1 |	  |   |	     |
|*  9 |        TABLE ACCESS BY INDEX ROWID BATCHED| ARTICLE	|      1 |	1 |    44 |	3   (0)| 00:00:01 |	 1 |00:00:00.01 |	4 |	  |   |	     |
|* 10 | 	INDEX RANGE SCAN		  | ARTICLE_X01 |      1 |	1 |	  |	2   (0)| 00:00:01 |	 1 |00:00:00.01 |	3 |	  |   |	     |
|* 11 |       INDEX UNIQUE SCAN 		  | MEMBER_PK	|      1 |	1 |	  |	1   (0)| 00:00:01 |	 1 |00:00:00.01 |	3 |	  |   |	     |
|  12 |      TABLE ACCESS BY INDEX ROWID	  | MEMBER	|      1 |	1 |    12 |	2   (0)| 00:00:01 |	 1 |00:00:00.01 |	1 |	  |   |	     |
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


제 답안
ARTICLE_X01 : BRD_ID + REG_DT DESC
drop index article_x01;
create index article_x01 on article(brd_id, reg_dt desc);

var BRD_ID number;
exec :BRD_ID := 1;
SELECT /*+ gather_plan_statistics leading(AA M) */
            AA.BRD_ID, AA.BRD_NM, AA.ART_SN, AA.ART_TIL
            , substr(AA.ART_CONT,1,3) AS ART_CONT
            , AA.MBR_NO, AA.REG_DT
from
(SELECT
*
FROM
            (SELECT /*+ leading(B A) use_nl(a) index(A ARTICLE_X01) */
            B.BRD_ID, B.BRD_NM, A.ART_SN, A.ART_TIL
            , ART_CONT
            , A.MBR_NO, A.REG_DT
            FROM BOARD B, ARTICLE A 
            WHERE B.BRD_ID = :BRD_ID
            AND A.BRD_ID = B.BRD_ID
            AND A.REG_DT >= TRUNC(SYSDATE-3)
            ORDER BY A.REG_DT DESC
)
WHERE ROWNUM <= 5) AA, MEMBER M
where  AA.MBR_NO = M.MBR_NO
order by AA.REG_DT DESC;
*inner 쪽 batch io로 인한 정렬달라짐을 고려해 제일 바깥에 order by 한번 더 명시