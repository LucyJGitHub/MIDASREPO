     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2003')
      *****************************************************************
/*STD *  RPGBASEBNC                                                   *
/*EXI *  TEXT('Midas UT BUG9020 Utility DLDLDBQD')                    *
      *****************************************************************
      *                                                               *
      *  Midas - Customer Lending Module                              *
      *                                                               *
      *  LE00010U - DLDLDBQD Reconciliation                           *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2003            *
      *                                                               *
      *  Last Amend No. CDL099             Date 06Oct17               *
      *  Prev Amend No. CGL165             Date 17Feb15               *
      *                 CDL096             Date 22Sep14               *
      *                 CDL094             Date 11Jun14               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 BUG9020  *CREATE   Date 13Jan06               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CDL099 - Split Value Date (Recompile)                        *
      *  CGL165 - Dual Withholding Tax (Recompile)                    *
      *  CDL096 - Business Day Conventions on MM Deals                *
      *           (Recompile)                                         *
      *  CDL094 - Enhance  Receive Settlement Instructions            *
      *           (Recompiled)                                        *
      *  BUG9020 - LEC000100 failed due to missing recs in DLDLDBQD/  *
      *            DEALSDB and DLDLDGQD but missing from DEALSDG      *
      *                                                               *
      *****************************************************************
 
     FDLDEALL5  UP  AE           K DISK    INCLUDE(DLDLDBD0)
     FDEALS     IS  AE           K DISK    INCLUDE(DEALSDBF)
     FFXDEALLL  IS  AE           K DISK    INCLUDE(FXDEALP0)
     FQSYSPRT   O    F  132        PRINTER USROPN
 
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
     IDLDLDBD0      01
     I                                          F1DLNO        L1M1
     IDEALSDBF      02
     I                                          DLNO          L1M1
     IFXDEALP0      03
     I                                          FHDN38        L1M1
 
     C     *INMR         IFEQ      *OFF
     C                   EXSR      OPNPRTF
     C     *IN01         IFEQ      *ON
     C                   EXCEPT    ERR1
     C                   DELETE    DLDLDBD0                             90
     C                   ELSE
     C                   EXCEPT    ERR2
     C                   MOVE      *ON           *INU7
     C                   MOVE      *ON           *INU8
     C                   ENDIF
     C                   ENDIF
 
      *********************************************************************
     C/SPACE 5
      *********************************************************************
      * OPNPRTF - OPEN PRINTER FILE
      *********************************************************************
 
     C     OPNPRTF       BEGSR
 
     C     PrintOpen     IFNE      'Y'
     C                   MOVE      'Y'           PrintOpen         1
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
     C                   MOVE      *ON           *INU7
     C                   MOVE      *ON           *INU8
     C                   MOVE      *ON           *INLR
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
     O                                           12 'REF:LE00010U'
     O                                           70 'DLDLDBQD RECONCILIATION'
     O                                           77 'UTILTY'
     O                                          120 'DATE:'
     O                       BJMRDT             128
     O          E            ERR1        1
     O                                           11 'Deal number'
     O                       F1DLNO              18
     O                                           43 'on DLDLDBQD but missing '
     O                                           64 'from DEALSDB/FXDEALPP'
     O                                           74 '- deleted'
     O          E            ERR2        1
     O                                           11 'Deal number'
     O                       DLNO                18
     O               02                          43 'on DEALSDB but missing '
     O               03                          44 'on FXDEALPP but missing '
     O                                           56 'from DLDLDBQD'
 
