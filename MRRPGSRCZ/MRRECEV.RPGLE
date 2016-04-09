/*XBIA*  OVRDBF FILE(MRTREVL0T) TOFILE(MRTREVL0)                      *
/*XBIB*  OVRDBF FILE(MRTREVL0M) TOFILE(MRTREVL0)                      *
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas MR Reconcile Events')
     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2004')
      *****************************************************************
      *                                                               *
      *  Midas - MidasPlus Reporting Module                           *
      *                                                               *
      *  MRRECEV -  Reconcile Events                                  *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2004            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Last Amend No. CMR001             Date 01Sep04               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CMR001 - MidasPlus Reporting                                 *
      *                                                               *
      *****************************************************************
 
     FMRTREVL0T IP  AE           K DISK    INFSR(*PSSR)  RENAME(MRTREVD0:Trans)
     FMRTREVL0M IS  AE           K DISK    INFSR(*PSSR)  RENAME(MRTREVD0:Midas)
     FMRRECEVP1 O    F  132        PRINTER USROPN
     F                                     INFDS(SPOOL1)
 
      ** File Information Data Structure for report
     D SPOOL1          DS
     D  PSFile1               83     92
     D  PSFNum1              123    124B 0
 
      ** Parameters for ZSFILE
     D PSeq            S              5
     D PLevel          S              1
     D PEnty           S              3
     D ZSnum           S              6  0
     D ZSnumU          S              6  0
     D ZSerr           S              1
 
 
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
     ITrans         01
     I                                          EXSUB         L2M8
     I                                          EXTRID        L1M7
     I                                          EXSEQ           M6
     I                                          EXEVDC          M5
     I                                          EXEVAT          M4
     I                                          EXEVAM          M3
     I                                          EXEVCY          M2
     I                                          EXEVDT          M1
 
     IMidas         02
     I                                          EXSUB         L2M8
     I                                          EXTRID        L1M7
     I                                          EXSEQ           M6
     I                                          EXEVDC          M5
     I                                          EXEVAT          M4
     I                                          EXEVAM          M3
     I                                          EXEVCY          M2
     I                                          EXEVDT          M1
 
     C
     C  NMR              EXSR      RPT_DIFF
 
     CLR                 EXSR      FIN_TOTALS
      /SPACE 5
     C**********************************************************************************
     C     RPT_DIFF      BEGSR
 
     C     EXSUB         CABNE     I#SUB         END_RPT_DIFF
 
     C   L1              Z-ADD     1             CHLINE            3 0
     C   L1              EXSR      PAG
     C   L1              EXCEPT    NEWTRAN
 
     C                   Z-ADD     EXEVDT        ZDAYNO
     C                   EXSR      ZDATE2
 
     C                   Z-ADD     1             CHLINE            3 0
     C                   EXSR      PAG
     C                   EXCEPT    EVENT
     C     END_RPT_DIFF  ENDSR
     C**********************************************************************************
      /SPACE 5
     C**********************************************************************************
     C     FIN_TOTALS    BEGSR
     C                   Z-ADD     1             CHLINE            3 0
     C                   EXSR      PAG
     C                   EXCEPT    FINTOTALS
     C                   ENDSR
     C**********************************************************************************
      /SPACE 5
      ********************************************************************
      * Throw page headings (if required)
      ********************************************************************
     C     PAG           BEGSR
 
     C     PAGNUM        IFEQ      0
     C                   OPEN      MRRECEVP1
     C*                  EXSR      RCF
     C                   ENDIF
 
     C                   ADD       CHLINE        LINENO
     C     LINENO        IFGT      59
     C                   ADD       1             PAGNUM
     C                   EXCEPT    PAGEHEAD
     C     5             ADD       CHLINE        LINENO            3 0
     C                   ENDIF
 
     C                   ENDSR
     C********************************************************************
      /SPACE 5
      ********************************************************************
     C     RCF           BEGSR
     C                   EVAL      ZSnum = PSFNum1
     C                   CALL      'ZSFILE'
     C                   PARM                    PSeq
     C                   PARM                    PEnty
     C                   PARM                    PSFile1
     C                   PARM                    ZSnum
     C                   PARM      *BLANKS       ZSErr
     C                   IF        ZSERR = 'Y'
     C                   SETON                                        U7U8LR
     C                   DUMP
     C                   RETURN
     C                   ENDIF
     C                   ENDSR
      ********************************************************************
      /SPACE 5
     C**********************************************************************************
     C     ZDATE2        BEGSR
     C                   CALL      'ZDATE2'
     C                   PARM                    ZDAYNO            5 0          Value date
     C                   PARM      'D'           ZDATFM            1            Date format ind
     C                   PARM      *zero         ZDATE             6 0          Value date
     C                   PARM      *blank        ZADATE            7            Run-date in DDM
     C                   ENDSR
     C**********************************************************************************
      /SPACE 5
     C**********************************************************************************
     C     *PSSR         BEGSR
 
     C     W#RUN         IFEQ      *BLANKS
 
     C                   MOVE      'Y'           W#RUN             1
 
     C                   MOVEL     '*ERROR'      I#RTCD            7
     C                   MOVE      '1'           *INU7
     C                   MOVE      '1'           *INU8
 
     C                   DUMP
      *
      * If no identified cause of error
      *
     C     I#ERMS        IFEQ      *BLANK
     C                   EVAL      I#ERMS = 'UNEXPECTED ERROR'
     C                   ENDIF
      *
      * Log an error on the error log
      *
     C                   CLEAR                   BUFFER
     C                   EVAL      BUFFER = I#ERMS
     C                   CALL      'GPWRTELOG'
     C                   PARM                    BUFFER         4000
 
     C                   SETON                                        LRU7U8
     C                   RETURN
     C                   ENDIF
 
     C                   ENDSR
     C**********************************************************************************
      /SPACE 5
     C**********************************************************************************
     C     *INZSR        BEGSR
     C     *ENTRY        PLIST
     C                   PARM                    I#MOD             2
     C                   PARM                    I#SUB             4
 
      * Access bank details
 
     C                   CALL      'AOBANKR0'
     C                   PARM      '*DBERR  '    @RTCD             7
     C                   PARM      '*FIRST  '    @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
 
      * Output page headings
 
     C                   Z-ADD     99            LINENO
     C                   Z-ADD     0             PAGNUM            5 0
 
     C                   MOVE      *BLANK        I#ERMS           50
     C                   ENDSR
     C**********************************************************************************
     OMRRECEVP1 E            PAGEHEAD         03
     O                                           24 'REFERENCE MRRECEVP1'
1437 O                       BJURPT              89
1438 O                                          104 'DATE'
1439 O                       BJMRDT             112
1440 O                                          122 'PAGE'
1441 O                       PAGNUM             127 '   0 '
     O          E            PAGEHEAD    1
     O                                           70 'EVENT RECONCILIATION '
     O                                           77 'REPORT:'
     O                       I#MOD               79
     O                                           80 '/'
     O                       I#SUB               84
     O          E            PAGEHEAD    1
     O                                            4 'SUB'
     O                                           16 'TRANSACTION'
     O                                           28 'SEQ'
     O                                           35 'DATE'
     O                                           55 'AMOUNT '
     O                                           65 'DtC'
     O                                           70 'AmT'
     O          E            EVENT       1
     O                       EXSUB                4
     O                       EXTRID              25
     O                       EXSEQ               27 '  0'
     O                       ZADATE              35
     O                       EXEVAM              55 '             0 .   -'
     O                       EXEVCY              59
     O                       EXEVDC              64
     O                       EXEVAT              69
     O                     01                    86 'Not in Midas'
     O                     02                    85 'Not in TRAP'
     O          E            NEWTRAN     1
     O                                           26 '--------------------------'
     O                                           52 '--------------------------'
     O                                           78 '--------------------------'
     O                                          104 '--------------------------'
     O                                          130 '--------------------------'
     O          E            FINTOTALS   1
     O                                           74 '* END OF REPORT * '
