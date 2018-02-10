     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas PM Portfolio Charges Amend Checking')
      *****************************************************************
      *                                                               *
      *  Midas - Portfolio Management Module                          *
      *                                                               *
      *  PMPFDM1AD  - Portfolio Charges Details Amend checking        *
      *                                                               *
      *  Function: This module compares the fields of an amended      *
      *            portfolio charges details against those currently  *
      *            held on file.  This program also checks whether    *
      *            all fields amended are amendable, and if not, an   *
      *            error message is sent back to the calling program. *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. CGL029             Date 01Sep03               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.02 -----------------------------------------------*
      *                 CAP033  *CREATE    Date 26Apr99               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CGL029 - Increase Account Code to 10 digits                  *
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
      **    False      logical = *off (for indicator processing)
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
      ** New Portfolio Charges header details - screen format
     D NwChrgScrnH     DS
     D  ADDBCGY                1      3
     D  ADDCSCY                4      6
     D***ADDCUSA                7     18                                                      CGL029
     D***ADDBRCA               19     21                                                      CGL029
     D  ADDCUSA                7     24                                                       CGL029
     D  ADDBRCA               25     27                                                       CGL029
      *
      ** Original Portfolio Charges header details - screen format
     D CrChrgScrnH     DS
     D  DDBCGY                 1      3
     D  DDCSCY                 4      6
     D***DDCUSA                 7     18                                                      CGL029
     D***DDBRCA                19     21                                                      CGL029
     D  DDCUSA                 7     24                                                       CGL029
     D  DDBRCA                25     27                                                       CGL029
      *
      ** Portfolio Charges header fields OK indicators
     D OKChrgH         DS
     D  OKBCGY                 1      1
     D  OKCSCY                 2      2
     D  OKCUSA                 3      3
     D  OKBRCA                 4      4
      *
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
      *
      ** Index for arrays of of error message IDs
     D PIDX            S              3P 0
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
      ** Check if non-amendable fields were amended.
      *
     C                   EXSR      SRComp
      *
      ** If any errors were found, set Amendments OK Indicator to 'N'.
      *
     C     PIDX          IFGT      0
     C                   EVAL      AmendOk  = 'N'
     C                   ELSE
     C                   EVAL      AmendOk  = 'Y'
     C                   ENDIF
      *
      ** If any errors were found and Reset of Fields in Error
      ** required, do this:
      *
     C     PIDX          IFGT      0
     C     PRESETERRS    ANDEQ     'Y'
     C                   EXSR      SRResetFlds
     C                   ENDIF
      *
      ** Return
      *
     C                   RETURN
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRCOMP - Routine to compare fields from file and the amended *
      *           screen fields                                       *
      *                                                               *
      *****************************************************************
      *
     C     SRComp        BEGSR
      *
      ** Bank Charging Currency
      ** - This field is no longer amendable if charges already
      **   written in file (module/RTV).
      *
     C     DDBCGY        IFNE      ADDBCGY
     C     ChrgExists    ANDEQ     'Y'
     C                   ADD       1             PIDX
     C                   EVAL      FldNameArr(PIDX) = 'DDBCGY'
     C                   EVAL      MsgIdArr(PIDX)  = 'PMA1001'
     C                   EVAL      MsgDtaArr(PIDX) = 'Bank Charging Currency'
     C                   EVAL      OKBCGY          = 'N'
     C                   ENDIF
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRRESETFLDS - Reset Fields in Error with their values on     *
      *                file                                           *
      *                                                               *
      *****************************************************************
      *
     C     SRResetFlds   BEGSR
      *
      ** Bank Charging Currency
      *
     C     OKBCGY        IFEQ      'N'
     C                   EVAL      ADDBCGY = DDBCGY
     C                   ENDIF
      *
     C                   ENDSR
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
      ** New Portfolio Charges header details - screen format
     C                   PARM                    NwChrgScrnH
      *
      ** Original Portfolio Charges header details - screen format
     C                   PARM                    CrChrgScrnH
      *
      ** Charge Exists flag
     C                   PARM                    ChrgExists        1
      *
      ** Reset of Fields in Error Required (Y/N)
     C                   PARM                    PRESETERRS        1
      *
      ** OUTPUT
      ** ======
      *
      ** Portfolio Charges header fields OK indicators
     C                   PARM                    OkChrgH
      *
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
      *
      ** Array index (3P0) from/to caller
     C                   PARM                    PIDX
      *
      ** Amendments OK
     C                   PARM                    AmendOk           1
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
