     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2003')
      *****************************************************************
/*STD *  RPGBASEBNC                                                   *
/*EXI *  TEXT('Midas LE GLCOLLQD Reconciliation Report')              *
      *****************************************************************
      *                                                               *
      *  Midas - Customer Lending Module                              *
      *                                                               *
      *  LE000105 - GLCOLLQD Reconciliation                           *
      *                                                               *
      *  (c) Finastra International Limited 2003                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CLE148             Date 23Jul12               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD027             Date 09Dec05               *
      *                 BUG3830 *CREATE    Date 17Jun04               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CLE148 - Alpha Loan Reference (Recompile)                    *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  BUG3830 - Credit Lines Extension Files Reconciliation        *
      *                                                               *
      *****************************************************************
 
     FGLCOLLQ0  IP  AE           K DISK    INCLUDE(GLCOLQD0)
     FGLCOLLLD  IS  AE           K DISK    INCLUDE(GLCOLLD0)
     FQSYSPRT   O    F  132        PRINTER USROPN
 
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
     IGLCOLQD0      01
     I                                          CDXBRC        L1M2
     I                                          CDXREF        L1M1
     IGLCOLLD0      02
     I                                          CDBRCA        L1M2
     I                                          CDCREF        L1M1
     I              CDXREF                      XXXX
 
     C     *INMR         IFEQ      *OFF
     C                   EXSR      OPNPRTF
     C     *IN01         IFEQ      *ON
     C                   MOVE      *BLANK        Colatrl          14
     C                   EVAL      Colatrl = CDXBRC + '/' + CDXREF
     C                   EXCEPT    ERR1
     C                   ELSE
     C                   MOVE      *BLANK        Colatrl          14
     C                   EVAL      Colatrl = CDBRCA + '/' + CDCREF
     C                   EXCEPT    ERR2
     C                   ENDIF
     C                   ENDIF
     C/SPACE 5
      *********************************************************************
      * OPNPRTF - OPEN PRINTER FILE
      *********************************************************************
     C     OPNPRTF       BEGSR
     C     PrintOpen     IFNE      'Y'
     C                   MOVE      'Y'           PrintOpen         1
     C                   SETON                                          U7U8
     C                   OPEN      QSYSPRT
     C                   EXCEPT    HEADINGS
     C                   ENDIF
     C                   ENDSR
      *********************************************************************
     C/SPACE 5
      *********************************************************************
      * *PSSR  --- ABNORMAL ERROR CONDITIONS
      *********************************************************************
     C     *PSSR         BEGSR
     C     RunBefore     IFEQ      *BLANKS
     C                   MOVE      'Y'           RunBefore         1
     C                   DUMP
     C                   SETON                                        LRU7U8
     C                   ENDIF
     C                   RETURN
     C                   ENDSR
      *********************************************************************
     C/SPACE 5
      *********************************************************************
      * *INZSR --- INITIAL PROCESSING
      *********************************************************************
     C     *INZSR        BEGSR
     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANKS       PRTCD             7
     C                   PARM      '*FIRST '     POPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
     C                   ENDSR
      *********************************************************************
     OQSYSPRT   E            HEADINGS       1 03
     O                                           12 'REF:LE000105'
     O                                           70 'GLCOLLQD RECONCILIATION'
     O                                           77 'REPORT'
     O                                          120 'DATE:'
     O                       BJMRDT             128
     O          E            ERR1        1
     O                                           10 'Collateral'
     O                       Colatrl             25
     O                                           50 'on GLCOLLQD but missing '
     O                                           63 'from GLCOLLPD'
     O          E            ERR2        1
     O                                           10 'Collateral'
     O                       Colatrl             25
     O                                           50 'on GLCOLLPD but missing '
     O                                           63 'from GLCOLLQD'
