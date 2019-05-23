     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas PM Portfolio Definition Key Fields Display')     *
      *****************************************************************
      *                                                               *
      *  Midas - Portfolio Management Module                          *
      *                                                               *
      *  PMPFDM2DP - Portfolio Definition Key Fields Display         *
      *                                                               *
      *  Function: This module displays the backoffice key fields of  *
      *            the transaction.                                   *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. CSD102             Date 08Jan19               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      *                 AR689705           Date 03Jan11               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.02 -----------------------------------------------*
      *                 CAP033  *CREATE    Date 26Apr99               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD102 - Password Length Extension (Recompile)               *
      *  MD046248 - Finastra Rebranding                               *
      *  AR689705 - Nominal and value settled were missing after      *
      *             enter. Applied fix AR656294 (Child: AR689706)     *
      *  AR656294 - HATS issue                                        *
      *  CAP033 - Conversion of PM inputs into modular structure to   *
      *           use as APIs.                                        *
      *                                                               *
      *****************************************************************
      *
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      *
      ** Key fields input screen
     FPMPFDM2DDFCF   E             WORKSTN
      *
      ** Table of field numbers and names
     FZAFLDNPD  IT   F   15        DISK    INFSR(*pssr)
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * ID F  C  H  L    FUNCTION OF INDICATORS                       *
      *                                                               *
      *     10-13 Field Error - highlight screen fields               *
      *                                                               *
      *       96  Message subfile display control                     *
      *       97  Message subfile end                                 *
      *                                                               *
      *       99  End of file indicator                               *
      *                                                               *
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
      **    True       logical = *on (for indcator processing)
      **    False      logical = *off (for indcator processing)
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
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
      *
      /COPY ZACPYSRC,ERR_ARRAYS
      *
      ** The following /COPY line includes the definitions for fields
      ** required by the message handler.
      *
      /COPY ZACPYSRC,MSGHNDDCL
      *
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
      *
      /COPY ZACPYSRC,APICTLARR
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
     D WZ0             S              1    DIM(60) CTDATA PERRCD(60)
     D WErrInd         S              1    DIM(60)
      *
      ** Review From fields (Customer and Portfolio Reference)
     D DDREVIEW        DS
     D  DDPNP8                 1      6
     D  DDPORT                 7     10
      *
      ** Error indicators (key fields and Review From fields)
     D PMEPMI          DS
     D  OKACTN                 1      1
     D  OKCSNM                 2      2
     D  OKPREF                 3      3
     D  OKVIEW                 4      4
      *
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
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
      ** Main processing
      *
     C                   EXSR      SRMainP
      *
      ** Return
      *
     C     PINKC         IFEQ      '1'
     C                   EVAL      *INLR = *ON
     C                   ENDIF
      *
     C                   RETURN
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRMAINP - Main processing                                    *
      *                                                               *
      *****************************************************************
      *
     C     SRMainP       BEGSR
      *
      ** Move 'OK' flags into array (for checking).
      *
     C                   MOVEA     PMEPMI        WErrInd
      *
      ** Set screen error indicators according to status of 'OK' flags.
      *
     C                   Z-ADD     1             WCnt              2 0
     C                   Z-ADD     10            WCtr              2 0
      *
     C     WCnt          DOUGT     4
      *
     C     WErrInd(WCnt) IFEQ      'N'
     C     WErrInd(WCnt) OREQ      'W'
     C                   MOVEL     '1'           *IN(WCtr)
     C                   ENDIF
      *
     C                   ADD       1             WCnt
     C                   ADD       1             WCtr
     C                   ENDDO
      *
      ** Set up the transaction reference to be used by the message handler.
      *
     C                   MOVEL     DDCSNM        WTRAN            10
     C                   MOVE      DDPREF        WTRAN
     C                   MOVEL     WTRAN         TranRef
     C                   EVAL      ActionCode = DDACTN
      *
      ** The following /COPY line includes processing for the error and
      ** warning messages.
      *
      /COPY ZACPYSRC,MSGHNDDSP1
      *
      ** Write message subfile, details and footer screen.
      *
     C                   WRITE     PMPFDMS0
     C                   TIME                    DDTIME
     C                   WRITE     PMPFDMF1                                                 AR656294
     C                   WRITE     PMPFDMI1
     C**********         WRITE     PMPFDMF1                                                 AR656294
      *
      ** Read details screen.
      *
     C                   READ      PMPFDMI1                               99
      *
      ** Clear message subfile.
      *
     C                   CALL      'ZA0250'
      *
      ** Set screen error indicators off.
      *
     C                   MOVEA     WZ0           *IN(10)
      *
      ** Set return keys.
      *
     C                   MOVE      *INKC         PINKC
     C                   MOVE      *INKG         PINKG
     C                   MOVE      *INKH         PINKH
     C                   MOVE      *INKL         PINKL
     C                   MOVE      *INKP         PINKP
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** The following /COPY line includes the ProcMsgs subroutine
      ** to process error and warning messages.
      *
      /COPY ZACPYSRC,MSGHNDDSP2
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
     C                   PARM                    RetCodeIn
      *
      ** Key fields (Action Code, Customer and Portfolio Reference)
     C                   PARM                    DDACTN
     C                   PARM                    DDCSNM
     C                   PARM                    DDPREF
      *
      ** Review From fields (Customer and Portfolio Reference)
     C                   PARM                    DDREVIEW
      *
      ** OK indicators (key fields and Review From fields)
     C                   PARM                    PMEPMI
      *
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
      *
      ** Warning fields/message Ids/message data (arrays) from/to
      ** caller
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIdArr
     C                   PARM                    WMsgDtaArr
      *
      ** STANDING DATA
      ** =============
      *
      ** SDBANK - System Runday
     C                   PARM                    BJMRDT
      *
      ** OUTPUT
      ** ======
      *
      ** Function keys
     C                   PARM                    PINKC             1
     C                   PARM                    PINKG             1
     C                   PARM                    PINKH             1
     C                   PARM                    PINKL             1
     C                   PARM                    PINKP             1
      *
      ** Initialise the fixed parameters for ZAMSGHNDLE.
      *
     C                   EVAL      ModuleID     = 'PM'
     C                   EVAL      APRPRLOCN    = 'S'
     C                   EVAL      APCNFVALFO   = 'N'
     C                   EVAL      APRespMode   = 'S'
      *
      ** Set up the prime and secondary message files for
      ** finding message IDs.
      *
     C                   EVAL      #MsgFile     = 'PMUSRMSG'
     C                   EVAL      MsgFArray(1) = 'DRSMM'
      *
      ** Message subfile control and program queue initialisation
      *
     C                   MOVE      '1'           *IN97
     C                   MOVEL     '*'           DDPGMQ
      *
      ** Program, module and procedure names for database error processing
      ** =================================================================
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
** WZ0
000000000000000000000000000000000000000000000000000000000000
