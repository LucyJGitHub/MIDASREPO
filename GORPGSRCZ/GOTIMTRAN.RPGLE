     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2010')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  ALWNULL(*USRCTL   )                                          *
/*EXI *  TEXT('Midas GO TI Housekeeping for T_MLMTRAN')               *
      *****************************************************************
      *                                                               *
      *  Midas - Global Processing Module                             *
      *                                                               *
      *  GOTIMTRAN - TI Housekeeping for T_MLMTRAN                    *
      *                                                               *
      *  (c) Finastra International Limited 2010                      *
      *                                                               *
      *  Last Amend No. MD007924           Date 09Oct14               *
      *  Prev Amend No. AR659961           Date 20Oct10               *
      *                 AR318278 *CREATE   Date 12Oct10               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD007924 - GOC0050 component failed due to printer overflow  *
      *  AR659961 - Client requested that the report is sorted by     *
      *             customer instead of transaction reference.        *
      *  AR318278 - TI manual transaction purging process.            *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *    99         Record not found on T_MLMTRAN                   *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      * *PSSR - Error processing                                      *
      * *INZSR - Initialise                                           *
      *                                                               *
      *****************************************************************
     FGO0539P1  O    E             PRINTER INFSR(*PSSR) INFDS(SPOOL)
     FTI_MLMTRANUF   E           K DISK    INFSR(*PSSR)
     FGZSDBRCHL0IF   E           K DISK    INFSR(*PSSR)
     FGZSDBANKL1IF   E           K DISK    INFSR(*PSSR)
      *
     D @RUN            S              1
      *
     D TITLE           S             50A   DIM(3) PERRCD(1) CTDATA
      *                                                                                     AR659961
     DZWDTIN           DS                                                                   AR659961
     DZWDAT                    1      8  0                                                  AR659961
     DZYR                      1      4                                                     AR659961
     DZMON                     5      6                                                     AR659961
     DZDAY                     7      8                                                     AR659961
      *
     DSPOOL            DS
     DSFILE                   83     92
     DSFNUM                  123    124B 0
     DOFLLN1                 188    189B 0
     DPRTLN1                 367    368B 0
      *
     C     TIKEY         KLIST                                                              AR659961
     C                   KFLD                    KCUSTCODE                                  AR659961
     C                   KFLD                    KTIREF                                     AR659961
      *                                                                                     AR659961
     C                   Z-ADD     *ZERO         NOREC             5 0
     C                   Z-ADD     *ZERO         NODET             5 0
     C                   EVAL      PRTLN1 = 0
     C                   EVAL      REPNAME = TITLE(1)
     C                   WRITE     HEADER
     C                   READ      TI_MLMTRAN                             80
      *
     C                   IF        *IN80
     C                   WRITE     NODETS
     C                   EVAL      *INLR = *ON
     C                   RETURN
     C                   ENDIF
      *
     C     *IN80         DOWEQ     *OFF
     C                   MOVEL(P)  CUSTCODE      KCUSTCODE         6                        AR659961
     C                   MOVEL(P)  TIREF         KTIREF            9                        AR659961
      *
      ** Recover the zone attached to the branch
      *
     C     MTBRCHCODE    CHAIN     SDBRCHD0                           99
      *
     C     *IN99         IFEQ      *ON
     C                   EVAL      I#ERMS = 'BRANCH ' + MTBRCHCODE
     C                              + ' NOT IN GLOBAL LAYER'
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ** Only process records in this zone
      *
     C     O#ZONE        IFEQ      A8ZONE
      *
      ** Get the run date
      *
     C     O#ZONE        CHAIN     SDBANKD0                           99
      *
     C     *IN99         IFEQ      *ON
     C                   EVAL      I#ERMS = 'ZONE' + O#ZONE
     C                              + ' NOT IN GLOBAL LAYER'
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ** Reset fields
      *
     C                   EVAL      *IN81 = *OFF
     C                   Z-ADD     *ZERO         BALANCE          23 8
      *
     C     *IN81         DOWEQ     *OFF
      *
     C                   ADD       1             NOREC
     C                   ADD       MTASSETAMT    BALANCE
     C**********         READE     TI_MLMTRAN                             81                AR659961
     C     TIKEY         READE     TI_MLMTRAN                             81                AR659961
      *
     C                   ENDDO
      *
      ** Flag for Deletion
      *
     C     BALANCE       IFEQ      *ZERO
     C*****TIREF         SETLL     TI_MLMTRAN                                               AR659961
     C**********         READE     TI_MLMTRAN                             82                AR659961
     C     TIKEY         SETLL     TI_MLMTRAN                             82                AR659961
     C     TIKEY         READE     TI_MLMTRAN                             82                AR659961
      *
     C     *IN82         DOWNE     *ON
     C     OFLLN1        SUB       PRTLN1        DIFLN1            3 0
     C**********         IF        DIFLN1 <= 4                                              MD007924
     C                   IF        DIFLN1 <= 10                                             MD007924
     C                   WRITE     HEADER
     C                   ENDIF
     C                   EVAL      XTREF = MTREF
     C                   EXSR      DATA                                                     AR659961
     C                   ADD       1             NODET
     C                   WRITE     DETAIL
     C                   MOVEL     'Y'           MTDELETED
     C                   UPDATE    T_MLMTRAN
     C**********         READE     TI_MLMTRAN                             82                AR659961
     C     TIKEY         READE     TI_MLMTRAN                             82                AR659961
     C                   ENDDO
     C                   WRITE     TOTAL
      *
     C                   ENDIF
     C                   ENDIF
      *
     C*****TIREF         SETGT     TI_MLMTRAN                                               AR659961
     C     TIKEY         SETGT     TI_MLMTRAN                                               AR659961
     C                   READ      TI_MLMTRAN                             80
     C                   ENDDO
      *
     C                   WRITE     AUDIT
     C                   EVAL      *INLR = *ON
     C                   RETURN
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * *INZSR - Program Initialisation routine                       *
      *****************************************************************
     C     *INZSR        BEGSR
     C                   MOVEL     *BLANK        I#ERMS           50
      * Get Zone
      /COPY GOCPYSRC,GOGETZONE
     C                   ENDSR
      *****************************************************************
      /SPACE 5                                                                              AR659961
      *****************************************************************                     AR659961
     C     DATA          BEGSR                                                              AR659961
      *                                                                                     AR659961
     C                   EVAL      XTREF = MTREF                                            AR659961
      *                                                                                     AR659961
     C                   MOVEL     *BLANKS       WORKDATE          8                        AR659961
     C                   EVAL      WORKDATE = %CHAR(MTMATDATE:*ISO0)                        AR659961
     C                   MOVEL     WORKDATE      ZWDTIN                                     AR659961
      *                                                                                     AR659961
     C                   IF        ZWDAT = 00010101                                         AR659961
     C                   EVAL      XTMATDATE = '--/--/----'                                 AR659961
     C                   ELSE                                                               AR659961
     C                   EVAL      XTMATDATE = ZDAY + '/' + ZMON + '/' + ZYR                AR659961
     C                   ENDIF                                                              AR659961
      *                                                                                     AR659961
     C                   MOVEL     *BLANKS       WORKDATE                                   AR659961
     C                   EVAL      WORKDATE = %CHAR(MTVALDATE:*ISO0)                        AR659961
     C                   MOVEL     WORKDATE      ZWDTIN                                     AR659961
      *                                                                                     AR659961
     C                   IF        ZWDAT = 00010101                                         AR659961
     C                   EVAL      XTVALDATE = '--/--/----'                                 AR659961
     C                   ELSE                                                               AR659961
     C                   EVAL      XTVALDATE = ZDAY + '/' + ZMON + '/' + ZYR                AR659961
     C                   ENDIF                                                              AR659961
      *                                                                                     AR659961
     C                   ENDSR                                                              AR659961
      *****************************************************************                     AR659961
      /SPACE 5
      *****************************************************************
      *                                                               *
      * *PSSR  - Program exception error routine                      *
      *                                                               *
      *****************************************************************
     C     *PSSR         BEGSR

     C                   IF        @RUN = *BLANK
     C                   EVAL      @RUN = 'Y'
     C                   DUMP
     C                   ENDIF

     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN

     C                   ENDSR
      *****************************************************************
** TITLE
         List of TI Transactions Purged
