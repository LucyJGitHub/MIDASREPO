     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2004')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas SM Update message queues on MXCOMDPD')
      *****************************************************************
      *                                                               *
      *  Midas - Implementation Module                                *
      *                                                               *
      *  SM000058 - Midas SM Update message queues on MXCOMDPD        *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2008            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *  Last Amend No. 256038  *CREATE    Date 13Aug08               *
      *  Prev Amend No.                    Date                       *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  256038 - New utility to migrate MXCOMDPD                     *
      *                                                               *
      *****************************************************************
      *
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      *
     FMXCOMDPD  UF   E             DISK    INFSR(*PSSR)
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
     C     *IN01         DOWEQ     *OFF
      *
     C                   READ      MXCOMDPD                               01
      *
     C     *IN01         IFEQ      *OFF
      *
      *  If Composite ID is one of the following update Message Queue Name:
      *    ISO15022 MESSAGES - DEPOTS               - MSG_DPM
      *    ISO15022 MESSAGES - POSITION SETTLEMENT  - MSG_PST
      *    ISO15022 MESSAGES - TRADES               - MSG_TRD
      *    SETTLEMENT CONFIRMATION - TRADE          - MSGSETTC
      *    REQUEST OF SECURITIES STATEMENTS         - RQ_SEST
      *
     C     CDCOMI        IFEQ      'MSG_DPM'
     C     CDCOMI        OREQ      'MSG_PST'
     C     CDCOMI        OREQ      'MSG_TRD'
     C     CDCOMI        OREQ      'MSGSETTC'
     C     CDCOMI        OREQ      'RQ_SEST'
      *
     C                   EVAL      WGlobPref = GlobPrfx
     C                   EVAL      CDMSGQ = WMsgText
      *
     C                   ENDIF
      *
      *  Update the record.
     C                   UPDATE    MXCOMDP0
      *
     C                   ENDIF
      *
     C                   ENDDO
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
