     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited. 2003')
      *****************************************************************
/*STD *  RPGBASEBNC                                                   *
/*EXI *  TEXT('Midas UT BUG9020 Utility DLDLDCQD')                    *
      *****************************************************************
      *                                                               *
      *  Midas - Customer Lending Module                              *
      *                                                               *
      *  LE000101 - DLDLDCQD Reconciliation                           *
      *                                                               *
      *  (c) Finastra International Limited. 2003                     *
      *                                                               *
      *  Last Amend No. MD046248           Date 05Feb18               *
      *  Prev Amend No. CDL099             Date 06Oct17               *
      *                 CGL165             Date 17Feb15               *
      *                 CDL096             Date 22Sep14               *
      *                 CDL094             Date 11Jun14               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 BUG9020            Date 13Jan06               *
      *                 XXXXXXX            Date DDMmmYY               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CDL099 - Split Value Date (Recompile)                        *
      *  CGL165 - Dual Withholding Tax (Recompile)                    *
      *  CDL096 - Business Day Conventions on MM Deals                *
      *           (Recompile)                                         *
      *  CDL094 - Enhance  Receive Settlement Instructions            *
      *           (Recompiled)                                        *
      *  BUG9020 - Delete DLDLDBQD records that does not have a       *
      *            record on MMDEALPP and DEALSDC.                    *
      *****************************************************************

     FDLDEALL5  UP  AE           K DISK    INCLUDE(DLDLDCD0)
     FDEALS     IS  AE           K DISK    INCLUDE(DEALSDCF)
     FMMDEALLL  IS  AE           K DISK    INCLUDE(MMDELDP0)
     FQSYSPRT   O    F  132        PRINTER USROPN

     D SDBANK        E DS                  EXTNAME(SDBANKPD)
     D DSFDY         E DS                  EXTNAME(DSFDY)

     IDLDLDCD0      01
     I                                          F1DLNO        L1M1
     IDEALSDCF      02
     I                                          DLNO          L1M1
     IMMDELDP0      03
     I                                          HKDN38        L1M1

     C     *INMR         IFEQ      *OFF
     C                   EXSR      OPNPRTF
     C     *IN01         IFEQ      *ON
     C                   EXCEPT    ERR1
     C                   DELETE    DLDLDCD0                             90
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
     O                                           13 'REF:LE000101U'
     O                                           70 'DLDLDCQD RECONCILIATION'
     O                                           77 'UTILITY'
     O                                          120 'DATE:'
     O                       BJMRDT             128
     O          E            ERR1        1
     O                                           11 'Deal number'
     O                       F1DLNO              18
     O                                           43 'on DLDLDCQD but missing '
     O                                           65 'from DEALSDC/MMDELDPP'
     O                                           74 '- deleted'
     O          E            ERR2        1
     O                                           11 'Deal number'
     O                       DLNO                18
     O               02                          43 'on DEALSDC but missing '
     O               03                          43 'on MMDELDPP but missing '
     O                                           56 'from DLDLDCQD'
     O                                           56 'from DLDLDCQD'

