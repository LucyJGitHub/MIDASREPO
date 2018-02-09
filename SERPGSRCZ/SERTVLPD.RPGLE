     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2005')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SE Retrieve Last Purchase Date')
      *****************************************************************
      *                                                               *
      *  Midas - Securities Trading Module                            *
      *                                                               *
      *  SERTVLPD - Retrieve Last Purchase Date                       *
      *                                                               *
      *  (c) Finastra International Limited 2005                      *
      *                                                               *
      *    This program retrieve the last purchase date from          *
      *    Trade Sale(TS) or Walk-In.                                 *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. 234300             Date 26Sep06               *
      *                 CSD027A            Date 05May06               *
      *                 CGL035             Date 01Mar05               *
      *                 234404             Date 24Jun05               *
      *                 234440  *CREATE    Date 18Jun05               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  234300 - Recompiled over changed in PF/HSTTRD.               *
      *  CSD027A - Conversion Of Customer Number to Alpha (Recompile) *
      *  CGL035 - EUSD Upgrade to Midasplus                           *
      *  234404 - Parameters mismatch                                 *
      *  234440 - Purchase Interest Management                        *
      *                                                               *
      *****************************************************************
 
     F***SETRADL3  IF   E           K DISK    PREFIX(T_)                                      CGL035
     FSETRADL4  IF   E           K DISK    PREFIX(T_)                                         CGL035
     FCPOSN     IF   E           K DISK
 
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
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
     D I_SESN          S                   LIKE(T_TDSS)
     D I_BRCH          S                   LIKE(T_TDBA)
     D*I_CUSN***       S                   LIKE(T_TCNR)                                       234404
     D*I_CUSN***       S              6S 0                                            234404 CSD027A
     D I_CUSN          S              6                                                      CSD027A
     D LPDT            S                   LIKE(T_TDVD)
     D*WCust****       S              6S 0                                                   CSD027A
     D WCust           S              6                                                      CSD027A
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *****************************************************************
     ITRADSDF       81
     IHSTTRDF       81
     IDPTMVDF       82
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
 
      ** Clear output trade fields
 
     C                   Z-ADD     0             LPDT
 
     C                   MOVEL     I_BRCH        WBrca
     C                   MOVEL     I_SESN        WSesn
     C                   MOVEL     I_CUSN        WCust
     C                   MOVE      *HIVAL        WDate
     C                   MOVE      '0'           *IN70
 
     C*****KEYTR1        SETLL     SETRADL3                                                   CGL035
     C*****KEYTR2        READE     SETRADL3                               70                  CGL035
     C     KEYTR1        SETLL     SETRADL4                                                   CGL035
     C     KEYTR2        READE     SETRADL4                               70                  CGL035
 
     C     *IN70         IFEQ      '1'
 
     C     KEYTR2        CHAIN     CPOSN                              70
     C     *IN70         IFEQ      '1'
     C                   Z-ADD     0             LPDT
     C                   MOVE      '*NRF'        RetCodeIn
     C                   ELSE
     C                   Z-ADD     CSDA          LPDT
     C                   END
 
     C                   ELSE
 
     C     *IN81         IFEQ      '1'
     C                   Z-ADD     T_TDVD        LPDT
     C                   ENDIF
 
     C     *IN82         IFEQ      '1'
     C                   Z-ADD     T_DPMD        LPDT
     C                   ENDIF
 
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
      ** Return Code
 
     C                   PARM                    RetCodeIn
 
      ** Input Fields
 
     C                   PARM                    I_SESN
     C                   PARM                    I_BRCH
     C                   PARM                    I_CUSN
 
      ** OUTPUTS
 
      ** Last Purchase Date
 
     C                   PARM                    LPDT
 
      ** Define key list for file
 
     C     KEYTR1        KLIST
     C                   KFLD                    WBrca             3
     C                   KFLD                    WSesn            10
     C                   KFLD                    WCust
     C                   KFLD                    WDate             5 0
 
     C     KEYTR2        KLIST
     C                   KFLD                    WBrca             3
     C                   KFLD                    WSesn            10
     C                   KFLD                    WCust
 
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
