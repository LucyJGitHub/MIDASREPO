     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2005')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SE EU Saving Tax Customer Position Retrieve')
      *****************************************************************
      *                                                               *
      *  Midas - Securities Trading Module                            *
      *                                                               *
      *  SEETCPRTV - Retrieve EU Tax Customer Position                *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2005            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Last Amend No. CSD027A            Date 05May06               *
      *  Prev Amend No. 235997             Date 13Sep05               *
      *                 234552             Date 29Jun05               *
      *                 234440  *CREATE    Date 22Jun05               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD027A - Conversion Of Customer Number to Alpha             *
      *  235997 - Wrong position recovered                            *
      *  234552 - Wrong position receovered                           *
      *  234440 - Purchase Interest Management                        *
      *                                                               *
      *****************************************************************
 
     FETCPOSL4  IF   E           K DISK    INFSR(*PSSR) PREFIX(C_)
 
     FETCPOSL0  IF   E           K DISK    INFSR(*PSSR) PREFIX(C0_)
     F                                     RENAME(ETCPOSNDF:ETCPOSL0F)
 
      *****************************************************************
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
 
      ** Include the SE standard declares
     D/COPY SECPYSRC,STDDECLARE
 
      ** Program Status Data Structure
      ** =============================
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
 
     D/COPY ZACPYSRC,PSDS
 
      ** The following /COPY line includes all the definitions of the
      ** appended error arrays, including the named constant giving the size
      ** of the arrays.
     D/COPY ZACPYSRC,ERR_XARRYS
 
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
 
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
     D ETCPOSND      E DS                  EXTNAME(ETCPOSND)
     D                                     PREFIX(C_)
     D ETCPOSNDC0    E DS                  EXTNAME(ETCPOSND)                                  234552
     D                                     PREFIX(C0_)                                        234552
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Input Parameters
 
      ** Output Parameters
 
      ** Working Variables
     D*WCust****       S              6S 0                                                   CSD027A
     D WCust           S              6                                                      CSD027A
     D KTmst           S             26Z
 
      ** Index for arrays of of error message ids etc
     D Idx             S              3P 0
 
      ** Index for arrays of of warning message ids etc
     D WIx             S              3P 0
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
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
 
      ** Initialization
 
     C                   MOVE      *BLANK        RetCodeIn
 
     C                   MOVE      *BLANK        FldNamXAr
     C                   MOVE      *BLANK        MsgIDXAr
     C                   MOVE      *BLANK        MsgDtaXAr
     C                   Z-ADD     0             Idx
     C                   MOVE      *BLANK        WFldNmXAr
     C                   MOVE      *BLANK        WMsgIDXAr
     C                   MOVE      *BLANK        WMsgDtXAr
     C                   Z-ADD     0             WIx
 
      * Get current position (RECI=D)
 
     C     KEYCP4        CHAIN     ETCPOSL4                           40
 
     ** If date on current record is prior to or at request date
      * or if request date = 0 (means get current position)
     **   Use current position
 
     C     *IN40         IFEQ      '0'
     C     C_CSDA        IFLE      RequestDate
     C     RequestDate   OREQ      *ZERO
     C                   MOVE      *BLANK        RetCodeIn
     C                   ELSE
 
      ** If live record is after request date, get record for request date
 
     C                   Z-ADD     RequestDate   WDate
     C     KEYCP0        SETGT     ETCPOSL0
     C                   READP     ETCPOSL0                               50
     C     *IN50         IFEQ      '0'
     C*****WBrca         ANDEQ     C_CSBA                                                     235997
     C*****WSesn         ANDEQ     C_CSSC                                                     235997
     C*****WCust         ANDEQ     C_CSCN                                                     235997
     C*****WMrk          ANDEQ     C_CSMK                                                     235997
     C*****WPtfr         ANDEQ     C_PTFR                                                     235997
     C     WBrca         ANDEQ     C0_CSBA                                                    235997
     C     WSesn         ANDEQ     C0_CSSC                                                    235997
     C     WCust         ANDEQ     C0_CSCN                                                    235997
     C     WMrk          ANDEQ     C0_CSMK                                                    235997
     C     WPtfr         ANDEQ     C0_PTFR                                                    235997
     C                   MOVE      *BLANK        RetCodeIn
     C                   EVAL      ETCPOSND = ETCPOSNDC0                                      234552
     C                   ELSE
     C                   MOVEL     '*NRF'        RetCodeIn
     C                   CLEAR                   ETCPOSND
     C                   ENDIF
     C                   ENDIF
 
     C                   ELSE
     C                   MOVEL     '*NRF'        RetCodeIn
     C                   CLEAR                   ETCPOSND
     C                   ENDIF
 
      ** Return
 
     C                   RETURN
      *****************************************************************
     C/EJECT
      *****************************************************************
      * *INZSR - Program Initialisation routine                       *
      *****************************************************************
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
 
      ** INPUTS
      ** Input Fields
 
     C                   PARM                    RetCodeIn
     C                   PARM                    WBrca             3
     C                   PARM                    WCust
     C                   PARM                    WSesn            10
     C                   PARM                    WPtfr             4
     C                   PARM                    WMrk              1
     C                   PARM                    RequestDate       5 0
 
      ** OUTPUTS
 
     C                   PARM                    ETCPOSND
 
      ** Define key list for file
 
     C     KEYCP4        KLIST
     C                   KFLD                    WBrca
     C                   KFLD                    WCust
     C                   KFLD                    WSesn
     C                   KFLD                    WMrk
     C                   KFLD                    WPtfr
 
     C     KEYCP0        KLIST
     C                   KFLD                    WBrca
     C                   KFLD                    WCust
     C                   KFLD                    WSesn
     C                   KFLD                    WMrk
     C                   KFLD                    WPtfr
     C                   KFLD                    WDate
 
 
     C     *LIKE         DEFINE    C_CSDA        WDate
 
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
 
     C/COPY ZACPYSRC,DBFIELDS
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      ********************************************************************
      /COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2005
