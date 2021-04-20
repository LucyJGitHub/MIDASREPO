     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2004')
      *****************************************************************
/**** *  RPGBASEBND                                                   *                     MD056612
/*STD *  RPGSQLBND                                                    *                     MD056612
/*EXI *  TEXT('Midas SM Update message queues on MXCOMDPD')
      *****************************************************************
      *                                                               *
      *  Midas - Implementation Module                                *
      *                                                               *
      *  SM000058 - Midas SM Update message queues on MXCOMDPD        *
      *                                                               *
      *  (c) Finastra International Limited 2008                      *
      *                                                               *
      *  Last Amend No. MD056612           Date 12Sep20               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 256038  *CREATE    Date 13Aug08               *
      *                                    Date                       *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD056612 - Deliverable Data Split for MX group               *
      *  MD046248 - Finastra Rebranding                               *
      *  256038 - New utility to migrate MXCOMDPD                     *
      *                                                               *
      *****************************************************************
      *
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      *
     F*MXCOMDPD* UF   E             DISK    INFSR(*PSSR)                                    MD056612
      ** MX Composite Message Details file
      *
      ** +--------------------------------------+
      ** ¦ Declared Variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
      *
      ** Program Parameters
     D GlobPrfx        S              2A
      *
     D MsgText         DS
     D  WMsgText               1     23
     D  WMsg1                  1      5    INZ('KTAQ/')
     D  WGlobPref              6      7
     D  WMsg3                  8     23    INZ('GPLIB/MS_MID2MMM')
     D MXCOMD        E DS                  EXTNAME(MXCMDJW0)                                MD056612
      *
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *
      *****************************************************************
      /EJECT
      *
      ** +--------------- Start of Main Processing -------------------+
      ** ¦                                                            ¦
      ** ¦  *INZSR is automatically executed at program activation.   ¦
      ** ¦                                                            ¦
      ** +------------------------------------------------------------+
      *
      * Read MXCOMDPD file.
     C******IN01         DOWEQ     *OFF                                                     MD056612
      **********                                                                            MD056612
     C**********         READ      MXCOMDPD                               01                MD056612
      **********                                                                            MD056612
     C******IN01         IFEQ      *OFF                                                     MD056612
      **********                                                                            MD056612
      *  If Composite ID is one of the following update Message Queue Name:
      *    ISO15022 MESSAGES - DEPOTS               - MSG_DPM
      *    ISO15022 MESSAGES - POSITION SETTLEMENT  - MSG_PST
      *    ISO15022 MESSAGES - TRADES               - MSG_TRD
      *    SETTLEMENT CONFIRMATION - TRADE          - MSGSETTC
      *    REQUEST OF SECURITIES STATEMENTS         - RQ_SEST
      **********                                                                            MD056612
     C*****CDCOMI        IFEQ      'MSG_DPM'                                                MD056612
     C*****CDCOMI        OREQ      'MSG_PST'                                                MD056612
     C*****CDCOMI        OREQ      'MSG_TRD'                                                MD056612
     C*****CDCOMI        OREQ      'MSGSETTC'                                               MD056612
     C*****CDCOMI        OREQ      'RQ_SEST'                                                MD056612
      **********                                                                            MD056612
     C                   EVAL      WGlobPref = GlobPrfx
     C                   EVAL      CDMSGQ = WMsgText
      **********                                                                            MD056612
     C**********         ENDIF                                                              MD056612
      **********                                                                            MD056612
      ***Update*the record.                                                                 MD056612
     C**********         UPDATE    MXCOMDP0                                                 MD056612
      **********                                                                            MD056612
     C**********         ENDIF                                                              MD056612
      **********                                                                            MD056612
     C**********         ENDDO                                                              MD056612
     C/exec SQL                                                                             MD056612
     C+ update MXCMDXTD set                                                                 MD056612
     C+   CDMSGQ = :CDMSGQ                                                                  MD056612
     C+ where CDCOMI = 'MSG_DPM' or CDCOMI = 'MSG_PST' or CDCOMI = 'MSG_TRD' or             MD056612
     C+       CDCOMI = 'MSGSETTC' or CDCOMI = 'RQ_SEST                                      MD056612
     C/end-exec                                                                             MD056612
      *
     C                   EVAL      *INLR = *ON
     C                   RETURN
      /EJECT
      *****************************************************************
      *                                                               *
      *  *INZSR - Program Initialisation Subroutine                   *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR
      *
     C     *ENTRY        PLIST
     C                   PARM                    GlobPrfx
      *
     C                   ENDSR
      /EJECT
      *****************************************************************
      *                                                               *
      *  *PSSR - Program Exception Subroutine                         *
      *                                                               *
      *****************************************************************
     C     *PSSR         BEGSR
      *
     C                   DUMP
      *
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
      *
     C                   RETURN
      *
     C                   ENDSR
