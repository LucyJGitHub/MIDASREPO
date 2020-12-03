     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas FT Validate IP SWIFT ref and sequence number')   *
      *****************************************************************
      *                                                               *
      *  Midas - Funds Transfer Module                                *
      *                                                               *
      *  FTVISWSQ - Validate SWIFT Reference and Sequence             *
      *             Number                                            *
      *                                                               *
      *  Component of: FTIPAYSIN                                      *
      *                FTIPAYCTL                                      *
      *                FTIPAYRPR                                      *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *    This source is centrally supported and must ONLY be        *
      *    amended by Core Development Personnel.                     *
      *                                                               *
      *    /COPY, Client or Country amendments must not be            *
      *    applied to this source.                                    *
      *                                                               *
      *  Last Amend No. AR1088819          Date 03Jun20               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      *                 CER059             Date 19Jul10               *
      *                 CER030             Date 09Jul08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 256564             Date 17Sep08               *
      *                 255522             Date 18Jul08               *
      *                 247277             Date 24May07               *
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CDL049             Date 06Jul06               *
      *                 CAP084             Date 25Aug03               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *                 CFT009             Date 13Jan01               *
      * Midas DBA 3.03 -----------------------------------------------*
      *                 CAP136  *CREATE    Date 15Nov99               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  AR1088819 - Issue on job names during SSL enabling of JDBC   *
      *              calls                                            *
      *            - Applied for MD050405                             *
      *  MD046248 - Finastra Rebranding                               *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER030 - Multicash German Feature (Recompile)                *
      *  256564 - Recompile due to PF changes done by fix 256330      *
      *  255522 - Properly populate SWIFT Reference and display it in *
      *           JAVA screen.                                        *
      *  247277 - Allow for native JDBC driver as well as toolbox.    *
      *  CDL049 - Addition of a Reference Rate field (recompile)      *
      *  CAP084 - Thin Client API Wrappers                            *
      *           Do not allow swift reference to be equal to '?'     *
      *           if called from MidasPlus interface.                 *
      *  CFT009 - Funds Transfer Fees and Charges (recompile)         *
      *  CAP136 - Conversion of FT Incoming Payment inputs into       *
      *           modular structure to use as APIs.                   *
      *                                                               *
      *****************************************************************
      *
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      *
      ** Standard D-specs
      ** ================
      **
      ** The following /COPY line includes the LDA layout,
      ** the copyright array definition,
      ** and the following named constants:
      **    True       logical = *On (for indicator processing)
      **    False      logical = *Off (for indicator processing)
      **    DBErrCtl   10A     = 'DBERRCTL' (the name of the database error
      **                                    handler)
      ** and the following variables:
      **    RunBefore  1A (for the PSSR)
      *
      /COPY ZACPYSRC,STD_D_SPEC
      *
      ** Program Status Data Structure
      ** =============================
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
      *
      /COPY ZACPYSRC,PSDS
      *
      ** The following /COPY line includes all the definitions of the
      ** appended error arrays, including the named constant giving the size
      ** of the arrays.
      *
      /COPY ZACPYSRC,ERR_XARRYS
      *
      ** +--------------------------------------+
      ** ¦ End of automatically included D-specs¦
      ** ¦ =====================================¦
      ** +--------------------------------------+
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +--------------------------------------+
      ** ¦ Manually included D-specs            ¦
      ** ¦ =========================            ¦
      ** +--------------------------------------+
      *
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
      *
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
      *
      ** Incoming Payments for file update - file format
     D NwIPFilFmt    E DS                  EXTNAME(FTVIPAYPD)
      *
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
      *
      ** Index for arrays of error message ids, etc.
     D IDx             S              3P 0
      *
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +--- Start of Main processing -------------------------------+
      ** ¦                                                            ¦
      ** ¦ *INZSR is executed at program activation.                  ¦
      ** ¦                                                            ¦
      ** +------------------------------------------------------------+
      *
      ** Initialise work variables.
      *
     C                   EVAL      Idx = 0
     C                   Z-ADD     0             WSEQNO            2 0
     C                   MOVE      *BLANK        W_SEQNO           1
      *
      ** Validate SWIFT Reference and Sequence Number.
      *
     C                   EXSR      SRValSwtR
      *
      ** If an error has been found, set return code appropriately.
      *
     C                   IF        OKSWTN = 'N' or
     C                             OKSEQNO = 'N'
     C                   EVAL      RetCodeIn = 'ERROR'
     C                   ENDIF
      *
      ** Update of Valid File fields will be done in subroutine
      ** SREISWFT in module FTIPAYSIN.
      *
     C                   IF        OKSWTN <> 'N'                                              255522
     C                   MOVE      DDSWTN        IPMIR                                        255522
     C                   ENDIF                                                                255522
     C                   IF        OKSEQNO <> 'N'                                             255522
     C                   MOVE      DDSEQNO       IPISEQ                                       255522
     C                   ENDIF                                                                255522
     C                   RETURN
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRVALSWTR - SWIFT Reference and Sequence No. Validation      *
      *                                                               *
      *****************************************************************
      *
     C     SRValSwtR     BEGSR
      *****************************************************************                       255522
      ***Entry*for*SWIFT*Reference*is*allowed*in*insertion*mode*only.**                       255522
      *****************************************************************                       255522
     C**********         IF        DDSWTN <> *Blanks and                                      255522
     C**********                   DDACTN <> 'I'                                              255522
     C**********         MOVE      'N'           OKSWTN                                       255522
     C**********         ADD       1             Idx                                          255522
     C**********         MOVEL     'DDSWTN'      FldNamXAr(Idx)                               255522
     C**********         MOVEL     'FTA0086'     MsgIdXAr(Idx)                                255522
     C**********         GOTO      EValSwtR                                                   255522
     C**********         ENDIF                                                                255522
                                                                                              CAP084
      ** Entry for SWIFT Reference cannot be '?'                                              CAP084
                                                                                              CAP084
     C                   IF        DDSWTN = '?' AND                                           CAP084
     C                             PSJobName = 'QZDASOINIT'                                   CAP084
     C                             OR DDSWTN = '?' AND                                        247277
     C                             PSJobName = 'QSQSRVR'                                      247277
     C                             OR DDSWTN = '?' AND                                     AR1088819
     C                             PSJobName = 'QZDASSINIT'                                AR1088819
     C                   MOVE      'N'           OKSWTN                                       CAP084
     C                   ADD       1             Idx                                          CAP084
     C                   MOVEL     'DDSWTN'      FldNamXAr(Idx)                               CAP084
     C                   MOVEL     'FTA9000'     MsgIdXAr(Idx)                                CAP084
     C                   ENDIF                                                                CAP084
      *
      ** SWIFT Sequence Number should not be > 10.
      *
     C                   IF        DDSEQNO <> *Blanks
      *
     C                   TESTN                   DDSEQNO              0102
     C                   MOVE      DDSEQNO       W_SEQNO
     C                   TESTZ                   W_SEQNO                  03
      *
     C     *IN01         IFEQ      '1'
     C     *IN03         ANDEQ     '1'
     C     *IN02         OREQ      '1'
     C     *IN03         ANDEQ     '1'
      *
     C                   MOVE      DDSEQNO       WSEQNO
      *
     C     WSEQNO        IFLT      0
     C     WSEQNO        ORGT      10
     C                   MOVE      'N'           OKSEQNO
     C                   ADD       1             Idx
     C                   MOVEL     'DDSEQNO'     FldNamXAr(Idx)
     C                   MOVEL     'FTA0087'     MsgIdXAr(Idx)
     C                   GOTO      EValSwtR
     C                   ENDIF
      *
     C                   ELSE
      *
     C                   MOVE      'N'           OKSEQNO
     C                   ADD       1             Idx
     C                   MOVEL     'DDSEQNO'     FldNamXAr(Idx)
     C                   MOVEL     'FTA0087'     MsgIdXAr(Idx)
     C                   GOTO      EValSwtR
      *
     C                   ENDIF
      *
     C                   ENDIF
      *
      ** Sequence Number must be blank or equal to zero if
      ** SWIFT Reference has not been entered.
      *
     C                   IF        DDSEQNO <> *Blanks and
     C                             WSEQNO  <> 0
      *
     C                   IF        DDSWTN = *Blanks
     C                   MOVE      'N'           OKSEQNO
     C                   ADD       1             Idx
     C                   MOVEL     'DDSEQNO'     FldNamXAr(Idx)
     C                   MOVEL     'FTA0088'     MsgIdXAr(Idx)
     C                   ENDIF
      *
     C                   ENDIF
      *
     C     EValSwtR      ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *INZSR - Program Initialisation                              *
      *         - This subroutine runs automatically for program      *
      *           initialisation.                                     *
      *                                                               *
      *****************************************************************
      *
     C     *INZSR        BEGSR
      *
     C     *ENTRY        PLIST
      *
      ** INPUT
      ** =====
      *
      ** Return Code
     C                   PARM                    RetCodeIn
      *
      ** SWIFT Reference
     C                   PARM                    DDSWTN           28
      *
      ** Sequence Number
     C                   PARM                    DDSEQNO           2
      *
      ** Action Code
     C                   PARM                    DDACTN            1
      *
      ** OUTPUT
      ** ======
      *
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      *
      ** OK SWIFT Reference
     C                   PARM                    OKSWTN            1
      *
      ** OK Sequence No.
     C                   PARM                    OKSEQNO           1
      *
      ** Incoming Payments for file update - file format
     C                   PARM                    NwIPFilFmt
      *
      ** Program, module and procedure names for dbase error processing
      ** ==============================================================
      ** The following /COPY sets these values.
      *
      /COPY ZACPYSRC,DBFIELDS
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** The following /COPY contains the standard program status
      ** subroutine, including a bound call to the DBERRCTL module.
      *
      /COPY ZACPYSRC,PSSR_ILE
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
**  CPY@
(c) Finastra International Limited 2001
