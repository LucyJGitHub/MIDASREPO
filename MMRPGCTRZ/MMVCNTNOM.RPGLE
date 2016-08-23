     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas MM Validate Control Nominal Amount')
      *****************************************************************
      *                                                               *
      *  Midas - Money Market Dealing Module                          *
      *                                                               *
      *  MMVCNTNOM  - Validate Control Nominal Amount                 *
      *                                                               *
      *  Function:  This module counts the total nominal value of     *
      *             depot movements as found in the MMTRPDMPD         *
      *             temporary file and checks that it equals the      *
      *             Control Nominal Amount value stored on the Repo   *
      *             trailer file                                      *
      *                                                               *
      *  Component of: SP6MM0003 - MM Core Non-kernel Validation 3    *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      *    This source is centrally supported and must ONLY be        *
      *    amended by Core Development Personnel                      *
      *                                                               *
      *    /COPY, Client or Country amendments must not be            *
      *    applied to this source.                                    *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *  Last Amend No. 256564             Date 17Sep08               *
      *  Prev Amend No. 247785             Date 15May07               *
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD027             Date 09Dec05               *
      * Midas Release 4.01 -------------------------------------------*
      *                 CAP067  *CREATE    Date 24Sep01               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  256564 - Recompile due to PF changes done by fix 256330      *
      *  247785 - Recompile on MMTRPDMPD.                             *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CAP067 - Repurchase Agreements API.                          *
      *                                                               *
      *****************************************************************
 
      *****************************************************************
      ** +----------------------------+
      ** ¦ Manually Included F-Specs  ¦
      ** ¦ =========================  ¦
      ** +----------------------------+
      **
     FMMTRPDML0 IF   E           K DISK    INFSR(*PSSR)
      **
      ** +-----------------------------------+
      ** ¦ End of Manually Included F-Specs  ¦
      ** ¦ ================================  ¦
      ** +-----------------------------------+
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      **
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
 
     D/COPY ZACPYSRC,STD_D_SPEC
 
      ** Include the MM standard declares
     D/COPY ZACPYSRC,STDDECLARE
 
      ** Program Status Data Structure
      ** =============================
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
 
     D/COPY ZACPYSRC,PSDS
 
      ** +--------------------------------------+
      ** ¦ End of automatically included D-specs¦
      ** ¦ =====================================¦
      ** +--------------------------------------+
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ Manually included D-specs            ¦
      ** ¦ =========================            ¦
      ** +--------------------------------------+
     D*
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Error message code 1 received as a parameter
     D Msg1            S                   LIKE(#MsgID)
     D WMsgID1         S                   LIKE(#MsgID)
 
      ** Record with same Front Office Transaction record found
     D RecFound        S              1A
 
      ** Front Office Associated Transaction Reference
     D THFOAS          S             20A
 
      ** Control Nominal Amount (in trailer)
     D THCNTN          S             13A
 
      ** Calling Program
     D CallPgm         S             10A
 
     D @@THCNTN        S             13  4
     D @@AMNP          S             15  0
     D @@DPNA          S             13  4
 
      **
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      **
      *****************************************************************
      /EJECT
      *****************************************************************
 
     C
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
 
      ** Reset the error flag to prevent problems on subsequent calls
     C                   RESET                   ErrorFound
     C                   RESET                   WMsgID1
     C                   RESET                   Msg1
     C                   RESET                   RecFound
 
 
      ** Count the total Nominal Amounts in the Repo Depot Mvt file records
     C
     C                   Z-ADD     *ZERO         @@DPNA
     C     THFOAS        CHAIN     MMTRPDMD0                          98
     C
     C     *IN98         DOWEQ     *OFF
     C                   ADD       DPNA          @@DPNA
     C     THFOAS        READE     MMTRPDMD0                              98
     C                   ENDDO
     C
 
      ** Error if Total of Nominal Amounts doesn't match with Control Nominal on Trailer
 
     C                   Z-ADD     0             @@THCNTN
     C                   EVAL      ZFIELD = *BLANKS
     C                   EVAL      ZAlignOk = *BLANKS
 
     C                   MOVE      THCNTN        ZFIELD
 
     C                   CALLB     'ZALIGN'
     C                   PARM                    ZALIGNok          1
     C                   PARM                    ZFIELD           16
     C                   PARM      4             ZADEC             1 0
     C                   PARM      9             ZADIG             2 0
     C
     C                   MOVE      ZFIELD        @@THCNTN
     C
     C     @@DPNA        IFNE      @@THCNTN
     C
      ** If calling pgm is repair function control nominal mismatch is only a warning
     C                   IF        CallPgm = 'MMREPORPR '
     C                   MOVE      'Y'           WarnFound
     C                   MOVEL     'MMM9021'     WMsgID1
     C                   MOVE      *BLANKS       ErrorFound
     C                   MOVEL     *BLANKS       Msg1
     C                   ELSE
     C                   MOVE      'Y'           ErrorFound
     C                   MOVEL     'MMM9021'     Msg1
     C                   MOVE      *BLANKS       WarnFound
     C                   MOVEL     *BLANKS       WMsgID1
     C                   ENDIF
     C
     C                   ENDIF
     C
      ** Return to calling module
     C
     C                   IF        WarnFound = 'Y'
     C                   EVAL      RetCodeIn = 'Warning'
     C                   ENDIF
     C
     C                   IF        ErrorFound = 'Y'
     C                   EVAL      RetCodeIn = 'Error'
     C                   ENDIF
      *
     C                   RETURN
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      * Called by: Main processing                                    *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     *INZSR        BEGSR
 
     C     *entry        PLIST
     C                   PARM                    RetCodeIn
     C                   PARM                    Msg1
     C                   PARM                    WMsgid1
     C                   PARM                    THFOAS
     C                   PARM                    THCNTN
     C                   PARM                    CallPgm
 
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
 
     C/COPY ZACPYSRC,DBFIELDS
 
     C                   ENDSR                                                  *** InzEnd ***
      *****************************************************************
      /EJECT
      ********************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
**  CPY@
(C) Copyright Misys International Banking Systems Ltd. 2001
