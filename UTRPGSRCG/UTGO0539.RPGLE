     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2010')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  ALWNULL(*USRCTL   )                                          *
/*EXI *  TEXT('Utility for T_MLMTRAN')                                *
      *****************************************************************
      *                                                               *
      *  Midas - Global Processing Module                             *
      *                                                               *
      *  UTGO0539 - Transaction reference with zero balance           *
      *                                                               *
      *  (c) Finastra International Limited 2010                      *
      *                                                               *
      *  Last Amend No. AR659961           Date 20Oct10               *
      *  Prev Amend No. AR318278 *CREATE   Date 04Oct10               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  AR659961 - Client requested that the report is sorted by     *
      *             customer instead of transaction reference.        *
      *  AR318278 - TI manual transaction exposure reports.           *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      * *PSSR - Error processing                                      *
      * *INZSR - Initialise                                           *
      *                                                               *
      *****************************************************************
     FUTGO0539P1O    E             PRINTER INFSR(*PSSR) INFDS(SPOOL)
     FUTGO0539L1IF   E           K DISK    INFSR(*PSSR)
      *
     D TITLE           S             50A   DIM(3) PERRCD(1) CTDATA
      *
     DZWDTIN           DS
     DZWDAT                    1      8  0
     DZYR                      1      4
     DZMON                     5      6
     DZDAY                     7      8
      *
     DSPOOL            DS
     DSFILE                   83     92
     DSFNUM                  123    124B 0
     DOFLLN1                 188    189B 0
     DPRTLN1                 367    368B 0
      *
     C                   EVAL      PRTLN1 = 0
     C                   READ      UTGO0539L1                             80
     C                   WRITE     HEADER
     C                   Z-ADD     *ZERO         NOREC             5 0
     C                   Z-ADD     *ZERO         NODET             5 0
      *
     C                   IF        *IN80
     C                   WRITE     NODETS
     C                   EVAL      *INLR = *ON
     C                   RETURN
     C                   ENDIF
      *
     C                   DOW       *IN80 = *OFF
      *
      ** Mode A or B
      *
     C                   IF        Mode = 'A' or Mode = 'B'
      *
      ** Reset fields
      *
     C                   EVAL      *IN81 = *OFF
     C                   Z-ADD     *ZERO         BALANCE          23 8
      *
     C*****TIREF         SETLL     UTGO0539L1                                               AR659961
     C*****TIREF         READE     UTGO0539L1                             81                AR659961
     C     TIKEY         SETLL     UTGO0539L1                                               AR659961
     C     TIKEY         READE     UTGO0539L1                             82                AR659961
     C                   MOVEL(P)  CUSTCODE      XCUSTCODE         6                        AR659961
     C                   MOVEL(P)  TIREF         XTIREF            9                        AR659961
     C                   DOW       *IN81 = *OFF
     C                             AND CUSTCODE = XCUSTCODE                                 AR659961
     C                             AND TIREF = XTIREF                                       AR659961
     C                   ADD       1             NOREC
     C                   ADD       MTASSETAMT    BALANCE
     C*****TIREF         READE     UTGO0539L1                             81                AR659961
     C                   READ      UTGO0539L1                             81                AR659961
     C                   ENDDO
      *
     C                   IF        (Mode = 'A' and Balance = 0) or
     C                             (Mode = 'B' and Balance <> 0)
      *
     C                   EVAL      TIREF = XTIREF                                           AR659961
     C                   EVAL      CUSTCODE = XCUSTCODE                                     AR659961
     C*****TIREF         SETLL     UTGO0539L1                                               AR659961
     C*****TIREF         READE     UTGO0539L1                             82                AR659961
     C     TIKEY         SETLL     UTGO0539L1                                               AR659961
     C     TIKEY         READE     UTGO0539L1                             82                AR659961
     C                   MOVE(P)   TIREF         XTIREF                                     AR659961
      *
     C                   DOW       *IN82 = *OFF
     C                             AND CUSTCODE = XCUSTCODE                                 AR659961
     C                             AND TIREF = XTIREF                                       AR659961
      *
     C     OFLLN1        SUB       PRTLN1        DIFLN1            3 0
     C                   IF        DIFLN1 <= 4
     C                   WRITE     HEADER
     C                   ENDIF
      *
     C                   EXSR      DATA
      *
     C                   ADD       1             NODET
     C                   WRITE     DETAIL
     C*****TIREF         READE     UTGO0539L1                             82                AR659961
     C                   READ      UTGO0539L1                             82                AR659961
      *
     C                   ENDDO
      *
     C                   WRITE     TOTAL
     C                   ENDIF
      *
     C                   EVAL      TIREF = XTIREF                                           AR659961
     C                   EVAL      CUSTCODE = XCUSTCODE                                     AR659961
     C*****TIREF         SETGT     UTGO0539L1                                               AR659961
     C     TIKEY         SETGT     UTGO0539L1                                               AR659961
      *
      ** Mode = C
      *
     C                   ELSE
     C                   ADD       1             NOREC
     C     OFLLN1        SUB       PRTLN1        DIFLN1
     C                   IF        DIFLN1 <= 2
     C                   WRITE     HEADER
     C                   ENDIF
     C                   EXSR      DATA
     C                   IF        XTMATDATE = '--/--/----'
     C                   ADD       1             NODET
     C                   WRITE     DETAIL
     C                   ENDIF
     C                   ENDIF
      *
     C                   READ      UTGO0539L1                             80
     C                   ENDDO
      *
     C     OFLLN1        SUB       PRTLN1        DIFLN1
     C                   IF        DIFLN1 <= 4
     C                   WRITE     HEADER
     C                   ENDIF
      *
     C                   WRITE     AUDIT
      *
     C                   EVAL      *INLR = *ON
     C                   RETURN
      /SPACE 5
      *****************************************************************
     C     *INZSR        BEGSR
     C     *Entry        PLIST
     C                   PARM                    MODE              1
      *
     C     TIKEY         KLIST                                                              AR659961
     C                   KFLD                    CUSTCODE                                   AR659961
     C                   KFLD                    TIREF                                      AR659961
      *                                                                                     AR659961
     C                   SELECT
     C                   WHEN      Mode = 'A'
     C                   EVAL      REPNAME = TITLE(1)
     C                   WHEN      Mode = 'B'
     C                   EVAL      REPNAME = TITLE(2)
     C                   WHEN      Mode = 'C'
     C                   EVAL      REPNAME = TITLE(3)
     C                   ENDSL
      *
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
     C     DATA          BEGSR
      *
     C                   EVAL      XTREF = MTREF
      *
     C                   MOVEL     *BLANKS       WORKDATE          8
     C                   EVAL      WORKDATE = %CHAR(MTMATDATE:*ISO0)
     C                   MOVEL     WORKDATE      ZWDTIN
      *
     C                   IF        ZWDAT = 00010101
     C                   EVAL      XTMATDATE = '--/--/----'
     C                   ELSE
     C                   EVAL      XTMATDATE = ZDAY + '/' + ZMON + '/' + ZYR
     C                   ENDIF
      *
     C                   MOVEL     *BLANKS       WORKDATE
     C                   EVAL      WORKDATE = %CHAR(MTVALDATE:*ISO0)
     C                   MOVEL     WORKDATE      ZWDTIN
      *
     C                   IF        ZWDAT = 00010101
     C                   EVAL      XTVALDATE = '--/--/----'
     C                   ELSE
     C                   EVAL      XTVALDATE = ZDAY + '/' + ZMON + '/' + ZYR
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      *****************************************************************
      *                                                               *
      * *PSSR  - Program exception error routine                      *
      *                                                               *
      *****************************************************************
     C     *PSSR         BEGSR
     C                   DUMP
     C                   EVAL      *INLR = *ON
     C                   RETURN
     C                   ENDSR
      *****************************************************************
** TITLE
    TI Transactions Exposure with Zero Balance
  TI Transactions Exposure with Non-zero Balance
  TI Transactions Exposure without Maturity date
