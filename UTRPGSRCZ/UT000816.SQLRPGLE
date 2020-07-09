     H DEBUG
     H COPYRIGHT('(c)Finastra International Limited 2018')
      *****************************************************************
/*STD *  RPGSQLBND                                                    *
/*EXI *  TEXT('Midas Data correction for Nostro')                     *
      *****************************************************************
      *                                                               *
      *  Midas - Utility                                              *
      *                                                               *
      *  UT000816 - Midas Data correction for Nostro                  *
      *                                                               *
      *  Function: Synchronizes SDNOSRQD, SDNOST2D and T_GZNOSREX     *
      *                                                               *
      *  (c)Finastra International Limited 2018                       *
      *                                                               *
      *  Last Amend No. MD055908A           Date 03Jul20              *
      *  Prev Amend No. MD052082  *CREATE   Date 11Oct18              *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD055908A - ZDBU failed during installation                  *
      *            - Applied fix for MD-56224                         *
      *  MD052082 - Synchronises SDNOSRQD, SDNOST2D and T_GZNOSREX    *
      *                                                               *
      *****************************************************************

      ** Variables for GOGETZONE

     D PZRTCD          S              7
     D PZERMS          S             50
     D PZFCHK          S              1
     D PZZONE          S             10
     D PZSHTC          S              4
     D PZRDNB          S              5  0
     D PZDNWD          S              5  0
     D PZBCCY          S              3
     D PZNJOB          S              1  0
     D WZONE           S             10

     C                   CALL      'GOGETZONE'
     C                   PARM      *BLANKS       PZRTCD
     C                   PARM      *BLANKS       PZERMS
     C                   PARM      'N'           PZFCHK
     C                   PARM      *BLANKS       PZZONE
     C                   PARM      *BLANKS       PZSHTC
     C                   PARM      *ZERO         PZRDNB
     C                   PARM      *ZERO         PZDNWD
     C                   PARM      *BLANKS       PZBCCY
     C                   PARM      *ZERO         PZNJOB
      *
     C     PZRTCD        IFEQ      *BLANKS
     C                   MOVE      PZZONE        WZONE
     C                   ELSE
      *
     C     PZRTCD        IFEQ      '*ERROR'
     C                   EXSR      *PSSR
     C                   ENDIF
     C                   ENDIF

      ** For SDNOSRQD

     C/EXEC SQL
     C+ Insert into SDNOSRQD
     C+ (DDBRCA, DDCCY, DDACOD, DDACSQ, COFRID, DDCUSN, DDNONB)
     C+ Select A7BRCD, A7CYCD, A7ACCD, digits(A7ACSN), ' ', A7CUST, A7NONB
     C+ from SDNOSTPD
     C+ where a7cycd concat a7nonb
     C+ not in (Select ddccy concat ddnonb from SDNOSRQD)
     C/END-EXEC
     C                   IF        SQLCODE <> 0 AND SQLCODE <> 100
     C                   EXSR      *PSSR
     C                   ENDIF

     C/EXEC SQL
     C+ Delete from SDNOSRQD
     C+ where ddbrca concat trim(ddcusn)
     C+ concat ddccy concat ddacod concat ddacsq
     C+ not in (Select brca concat cnum concat ccy
     C+ concat padacod concat padacsq
     C+ from V_ACCNTNOS)
     C/END-EXEC
     C                   IF        SQLCODE <> 0 AND SQLCODE <> 100
     C                   EXSR      *PSSR
     C                   ENDIF

      ** For SDNOST2D

     C/EXEC SQL
     C+ Insert into SDNOST2D
     C+ (ERCYCD, ERNONB, ERBRCA, ERACCD, ERACSN, ERPOOL)
     C+ Select distinct DDCCY,  DDNONB, DDBRCA, 0, 0,' '
     C+ from SDNOSRQD
     C+ where DDCCY concat DDNONB
     C+ not in (Select distinct ERCYCD concat ERNONB from SDNOST2D)
     C/END-EXEC
     C                   IF        SQLCODE <> 0 AND SQLCODE <> 100
     C                   EXSR      *PSSR
     C                   ENDIF

     C/EXEC SQL
     C+ Delete from SDNOST2D where ERCYCD concat ERNONB not in
     C+ (Select DDCCY concat DDNONB from SDNOSRQD)
     C/END-EXEC
     C                   IF        SQLCODE <> 0 AND SQLCODE <> 100
     C                   EXSR      *PSSR
     C                   ENDIF

      ** For T_GZNOSREX

     C/EXEC SQL
     C+ Insert into T_GZNOSREX
     C+ (DDBRCA, DDCUSN, DDCCY, DDACOD, DDACSQ, DDNONB, DDCYCD, ZONE)
     C*+*Select*DDBRCA,(Select*BBBRCD*from*SDCUSTPD                                        MD055908A
     C*+*where*substr(DDCUSN,1,6)*=*BBCUST)*concat*'-'*concat                              MD055908A
     C*+*substr(DDCUSN,1,6),*DDCCY,*DDACOD,*DDACSQ,*DDNONB,*DDCCY,*:WZONE                  MD055908A
     C*+*from*SDNOSRQD                                                                     MD055908A
     C+ Select A.DDBRCA,(Select BBBRCD from SDCUSTPD                                       MD055908A
     C+ where substr(A.DDCUSN,1,6) = BBCUST) concat '-' concat                             MD055908A
     C+ substr(A.DDCUSN,1,6), A.DDCCY, A.DDACOD, A.DDACSQ, A.DDNONB, A.DDCCY,              MD055908A
     C+ :WZONE from SDNOSRQD A                                                             MD055908A
     C+ where not exists
     C+ (Select * from T_GZNOSREX
     C+ where DDBRCA = A.DDBRCA                                                            MD055908A
     C+ and substr(DDCUSN,5,6) = substr(A.DDCUSN,1,6)                                      MD055908A
     C+ and DDCCY = A.DDCCY and DDACOD = A.DDACOD                                          MD055908A
     C+ and DDACSQ = A.DDACSQ and DDNONB = A.DDNONB)                                       MD055908A
     C*+*where*DDBRCA*=*SDNOSRQD.DDBRCA                                                    MD055908A
     C*+*and*substr(DDCUSN,5,6)*=*substr(SDNOSRQD.DDCUSN,1,6)                              MD055908A
     C*+*and*DDCCY*=*SDNOSRQD.DDCCY*and*DDACOD*=*SDNOSRQD.DDACOD                           MD055908A
     C*+*and*DDACSQ*=*SDNOSRQD.DDACSQ*and*DDNONB*=*SDNOSRQD.DDNONB)                        MD055908A
     C/END-EXEC
     C                   IF        SQLCODE <> 0 AND SQLCODE <> 100
     C                   EXSR      *PSSR
     C                   ENDIF

     C/EXEC SQL
     C+ Delete from T_GZNOSREX A
     C+ where not exists
     C+ (Select * from SDNOSRQD B
     C+ where substr(A.DDCUSN,5,6) = substr(B.DDCUSN,1,6)
     C+ and A.DDBRCA = B.DDBRCA and A.DDCYCD = B.DDCCY
     C+ and A.DDACOD = B.DDACOD and A.DDACSQ = B.DDACSQ
     C+ and A.DDNONB = B.DDNONB)
     C/END-EXEC
     C                   IF        SQLCODE <> 0 AND SQLCODE <> 100
     C                   EXSR      *PSSR
     C                   ENDIF


     C                   EVAL      *INLR = '1'
     C                   RETURN
      *****************************************************************
      *    *PSSR                                                      *
      *****************************************************************
     C     *PSSR         BEGSR

     C                   EVAL      *INU7 = '1'
     C                   EVAL      *INU8 = '1'
     C                   DUMP
     C                   RETURN
     C
     C                   ENDSR
     C*****************************************************************
