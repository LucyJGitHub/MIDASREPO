     H DECEDIT(',') DATEDIT(*YMD/)
      *****************************************************************
/*STD *  RPGSQLBND
/*EXI *  TEXT('Midas GL APR Calculation Program')                     *
      *****************************************************************
      *                                                               *
      *  Midas - Dealing, Lending and Retail Modules                  *
      *                                                               *
      *  GL000050 - APR Calculation program                           *
      *                                                               *
      *  (c) Finastra International Limited 2016                      *
      *                                                               *
      *  Last Amend No. CER050  *Create    Date 16Jun19               *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  CER050 - Annualized Percentage Rate (APR)                    *
      *         - This program will only be called if system value    *
      *           APRFormula = 'SPAIN' and corresponding APR api      *
      *           system value(APRRetailAccounts, APRMMDeposits or    *
      *           APRMMLoans, APRLELoans) is set to 'Y'               *
      *                                                               *
      *****************************************************************
      *
     D LDA           E DS           256    EXTNAME(LDA)
      ** Local data area for database error details
      ** *LOCK IN LDA immediately before and OUT LDA immediately
      ** after each database error handling.
      **                                    134 141 DBFILE
      **       Defines:                     142 170 DBKEY
      **                                    171 180 DBPGM
      **                                    181 1830DBASE
      *
     D SCSARD        E DS                  EXTNAME(SCSARDPD)
     D GLAPRC        E DS                  EXTNAME(GLAPRCTD)
      *
      /EJECT
      *
      ** Flows
      *
     DIAMT             S             26  3 DIM(999)
     DIDAY             S              5  0 DIM(999)
     DOAMT             S             26  3 DIM(999)
     DODAY             S              5  0 DIM(999)
      *
      /EJECT
      *****************************************************************
      *                                                               *
      *                     MAIN PROCESSING                           *
      *                                                               *
      *****************************************************************
      *
     C     *ENTRY        PLIST
     C                   PARM                    PAPRC
     C                   PARM                    PBASE             3
      *
      ** Define the LDA for error handling
     C     *DTAARA       DEFINE                  LDA
      *
     C/exec SQL
     C+ select *
     C+ into :SCSARD
     C+ from SCSARDPD
     C+ where SARN = 'CER050'
     C/end-exec

     C     SQLCOD        Ifeq      100
     C                   move      *ON           *INLR
     C                   Return
     C                   Endif
      *
     C                   MOVE      PBASE         BASEN             3 0
      *
      ** Load table
     C                   Z-ADD     0             WI                3 0
     C                   Z-ADD     0             WO                3 0
      *
     C/Exec SQL
     C+ Declare GLAPR cursor for
     C+ Select * from GLAPRCTD
     C/End-Exec

     C/Exec SQL
     C+ Open GLAPR
     C/End-Exec

      ** Handle SQL Error (if not %EOF)
     C                   If        SQLCOD < 0
     C     *LOCK         IN        LDA
     C                   eval      DBASE = 1
     C                   eval      DBFILE = 'SQL STM'
     C                   eval      DBKEY = 'SQLSTT : ' + SQLSTT
     C                                   + ';  SQLCOD : ' + %char(SQLCOD)
     C                   Out       LDA
     C                   Exsr      *PSSR
     C                   EndIf

     C/Exec SQL
     C+ fetch next
     C+   From GLAPR
     C+   into :GLAPRC
     C/End-Exec

     C                   Dow       SQLCode <> 100
      *
     C                   Select
     C     APRTYP        WHENEQ    'I'
     C                   ADD       1             WI
     C                   Z-ADD     APRAMT        IAMT(WI)
     C                   Z-ADD     APRDAY        IDAY(WI)
     C     APRTYP        WHENEQ    'O'
     C                   ADD       1             WO
     C                   Z-ADD     APRAMT        OAMT(WO)
     C                   Z-ADD     APRDAY        ODAY(WO)
     C                   Endsl
      *
     C/Exec SQL
     C+ Fetch next from GLAPR
     C+   into :GLAPRC
     C/End-Exec
     C                   Enddo
      *
      ** Handle SQL Error (if not %EOF)
     C                   If        SQLCode < 100
     C     *LOCK         IN        LDA
     C                   EVAL      DBASE = 2
     C                   EVAL      DBFILE = 'SQL STM'
     C                   EVAL      DBKEY = 'SQLSTT : ' + SQLSTT
     C                                   + ';  SQLCOD : ' + %char(SQLCOD)
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   EndIf
      *
     C/Exec SQL
     C+ Close GLAPR
     C/End-Exec

      *
      ** Start calculations.
     C                   Z-ADD     .01           I                2625
     C                   Z-ADD     0.001         REDI             2625
     C                   Z-ADD     1             COUNTER           2 0
      *
      ** Go through the loop until IN = OUT
     C                   Z-ADD     0             SIN              3015
     C                   Z-ADD     0             SOUT             3015
     C                   Z-ADD     0             SOUTX            26 6
     C                   Z-ADD     0             SINX             26 6
     C                   Z-ADD     0             LOOPCOUNT         3 0
      *
      ** Go until OUT is equal to IN, or the maximum number of decimals
      ** have been used.
     C     IN            Doueq     OUT
     C     LOOPCOUNT     orgt      240
     C                   ADD       1             LOOPCOUNT
      *
      ** Calculate all the INS
     C                   Z-ADD     0             NI                3 0
     C                   Z-ADD     0             IN               26 5
      *
      ** Proceed only if an IN has been processed (i.e. WI is not zero)
      *
     C     WI            Ifne      0
     C     NI            DouEq     WI
     C                   ADD       1             NI
     C                   EVAL      SIN=1/((1+I)**IDAY(NI))
     C     IAMT(NI)      MULT      SIN           SINX
     C                   ADD       SINX          IN
     C                   Enddo
     C                   Endif
      *
      ** Calculate all the OUTS
     C                   Z-ADD     0             NO                3 0
     C                   Z-ADD     0             OUT              26 5
      *
      ** Proceed only if an OUT has been processed (i.e. WO is not zero)
      *
     C     WO            Ifne      0
     C     NO            Doueq     WO
     C                   ADD       1             NO
     C                   EVAL      SOUT=1/((1+I)**ODAY(NO))
     C     OAMT(NO)      MULT      SOUT          SOUTX
     C                   ADD       SOUTX         OUT
     C                   Enddo
     C                   Endif
      *
      ** Reduce I to be 1/10th nine times to get the next level keep
      ** going until OUT is equal to IN.
      *
     C                   Select
     C     OUT           Whengt    IN
     C                   ADD       REDI          I
     C                   Z-ADD     11            COUNTER
     C     OUT           Whenlt    IN
     C                   SUB       REDI          I
     C                   Other
     C                   GOTO      CALC
     C                   Endsl
      *
     C                   ADD       1             COUNTER
     C     COUNTER       Ifgt      11
     C                   Eval      REDI=REDI/10
     C                   Z-ADD     1             COUNTER
     C                   Endif
      *
     C                   Enddo
      *
     C     CALC          TAG
     C                   Z-ADD     0             APR              26 4
     C                   EVAL(H)   APR=((1+I)**BASEN)-1
     C     APR           Ifgt      1
     C                   MOVE      '999999'      PAPRC
     C                   Else
     C     APR           Iflt      0
     C     1             ADD       APR           APR
     C                   MOVE      APR           PAPRC             6
     C                   MOVEL     '-'           PAPRC             6
     C                   Else
     C                   MOVE      APR           PAPRC             6
     C                   Endif
     C                   Endif
      *
     C                   MOVE      '1'           *INLR
      *
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *PSSR: Program exception error routine. Called automatically  *
      *        if a program error occurs, or directly by the program  *
      *        code using EXSR. This subroutine DUMPs the program     *
      *        just once.                                             *
      *                                                               *
      *****************************************************************
      *
     C     *PSSR         BEGSR
      *
     C     @RUN          IFEQ      *BLANKS
      *
     C                   MOVE      'Y'           @RUN              1
      *
     C                   MOVE      *ON           *INU7
     C                   MOVE      *ON           *INU8
     C                   MOVE      *ON           *INLR
      *
     C                   DUMP
      *
     C                   ENDIF
      *
     C                   RETURN
      *
     C                   ENDSR
