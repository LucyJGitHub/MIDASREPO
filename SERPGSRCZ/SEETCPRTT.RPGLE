     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2005')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SE EU Saving Tax Customer Position Retrieval')
      *****************************************************************
      *                                                               *
      *  Midas - Securities Trading Module                            *
      *                                                               *
      *  SEETCPRTT - Retrieve EU Tax Customer Position (for a trade)  *
      *                                                               *
      *  (c) Finastra International Limited 2005                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. CSD027A            Date 05May06               *
      *                 235546             Date 09Aug05               *
      *                 234577             Date 29Jun05               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CSD027A - Conversion Of Customer Number to Alpha             *
      *  235546 - Due to back valuations, need to return the last     *
      *           record for the requested date if a new transaction  *
      *  234577 - Error in position retieved                          *
      *                                                               *
      *****************************************************************
 
     FETCPOSL3  IF   E           K DISK    INFSR(*PSSR) PREFIX(C_)
 
     FETCPOSL4  IF   E           K DISK    INFSR(*PSSR) PREFIX(C_)
     F                                     RENAME(ETCPOSNDF:ETCPOSL4F)
 
     FETCPOSL0  IF   E           K DISK    INFSR(*PSSR) PREFIX(C_)
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
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Input Parameters
 
      ** Output Parameters
 
      ** Working Variables
     D*WCust****       S              6S 0                                                   CSD027A
     D WCust           S              6                                                      CSD027A
 
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
 
      * Determine if trade present
      * If trade is not present get current position
      * else if trade is present get position prior to trade
 
     C     TRADEK        CHAIN     ETCPOSL3                           40
     C     *IN40         IFEQ      *ON
     C                   EXSR      Acs_CurrPosn
     C                   ELSE
     C                   EXSR      Acs_PriorPosn
     C                   ENDIF
 
      ** Return
 
     C                   RETURN
     C/EJECT
      *****************************************************************
      * Access Current Position                                       *
      *****************************************************************
     C     Acs_CurrPosn  BEGSR
 
     C     CURRPOSK      CHAIN     ETCPOSL4                           40
 
     C     *IN40         IFEQ      *ON
     C                   MOVEL     '*NRF'        RetCodeIn
     C                   CLEAR                   ETCPOSND
     C                   ELSE                                                                 235546
 
      * Check if Current Position is the record required by checking
      * date
 
     C     C_CSDA        IFLE      RequestDate                                                235546
     C     RequestDate   OREQ      0                                                          235546
     C                   MOVEL     *BLANKS       RetCodeIn                                    235546
     C                   ELSE                                                                 235546
     C                   EXSR      Acs_PriorDate                                              235546
     C                   ENDIF                                                                235546
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      * Access Prior Position to Trade (using trade record details)   *
      *****************************************************************
     C     Acs_PriorPosn BEGSR
 
     C     B4TRADEK      SETLL     ETCPOSL0
     C     CURRPOSK      READPE    ETCPOSL0                               40
 
     C     *IN40         IFEQ      *ON
     C                   MOVEL     '*NRF'        RetCodeIn
     C                   CLEAR                   ETCPOSND
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
     C/EJECT                                                                                  235546
      *****************************************************************                       235546
      * Access Prior Position to Date                                 *                       235546
      *****************************************************************                       235546
     C     Acs_PriorDate BEGSR                                                                235546
                                                                                              235546
     C     B4TRADDT      SETGT     ETCPOSL0                                                   235546
     C     CURRPOSK      READPE    ETCPOSL0                               40                  235546
                                                                                              235546
     C     *IN40         IFEQ      *ON                                                        235546
     C                   MOVEL     '*NRF'        RetCodeIn                                    235546
     C                   CLEAR                   ETCPOSND                                     235546
     C                   ENDIF                                                                235546
                                                                                              235546
     C                   ENDSR                                                                235546
      *****************************************************************                       235546
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
     C                   PARM                    WTransType        1
     C                   PARM                    WTradeRef         6
     C                   PARM                    RequestDate       5 0                        235546
 
      ** OUTPUTS
 
     C                   PARM                    ETCPOSND
 
      ** Define key list for file
 
     C     TRADEK        KLIST
     C                   KFLD                    WTransType
     C                   KFLD                    WTradeRef
 
     C     B4TRADEK      KLIST
     C                   KFLD                    C_CSBA
     C                   KFLD                    C_CSCN
     C                   KFLD                    C_CSSC
     C                   KFLD                    C_CSMK
     C                   KFLD                    C_PTFR
     C                   KFLD                    C_CSDA
     C                   KFLD                    C_TMST
                                                                                              235546
     C     B4TRADDT      KLIST                                                                235546
     C                   KFLD                    WBrca                                        235546
     C                   KFLD                    WCust                                        235546
     C                   KFLD                    WSesn                                        235546
     C                   KFLD                    WMrk                                         235546
     C                   KFLD                    WPtfr                                        235546
     C                   KFLD                    RequestDate                                  235546
 
     C     CURRPOSK      KLIST
     C                   KFLD                    WBrca
     C                   KFLD                    WCust
     C                   KFLD                    WSesn
     C                   KFLD                    WMrk
     C                   KFLD                    WPtfr
 
 
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
(c) Finastra International Limited 2005
