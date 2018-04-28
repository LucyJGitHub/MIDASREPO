     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2005')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SE Calculate Average Purchased Date(not use)')
      *****************************************************************
      *                                                               *
      *  Midas - Securities Trading Module                            *
      *                                                               *
      *  SEVAPDT - Calculate Average Purchase Date                    *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2005            *
      *                                                               *
      *    This source is centrally supported and must ONLY be        *
      *    amended by Core Development Personnel                      *
      *                                                               *
      *    /COPY, Client or Country amendments must not be            *
      *    applied to this source.                                    *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Last Amend No. CSD027A            Date 05May06               *
      *  Prev Amend No. 236705  *CREATE    Date 18Jun05               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD027A - Conversion Of Customer Number to Alpha             *
      *  236705 - Original Purchase Date should default to average    *
      *           Purchase Date.                                      *
      *                                                               *
      *****************************************************************
 
     FCPOSC     IF   E           K DISK    INFSR(*PSSR)
 
     FCDEPP     IF   E           K DISK    INFSR(*PSSR)
 
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
 
      ** Input Parameters
 
      ** Output Parameters
 
      ** Working Variables
     D*WCust****       S              6S 0                                                   CSD027A
     D WCust           S              6A                                                     CSD027A
 
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
 
      ** Calculation
 
     C                   EXSR      Default
 
      ** Return
 
     C                   RETURN
      *****************************************************************
     C/EJECT
      *****************************************************************
      *                                                               *
      * Default - Calculation for Average Purchase Date               *
      *                                                               *
      *****************************************************************
 
     C     Default       BEGSR
 
      ** Get Customer Position for Close of Business Nominal Amount
 
     C     KEYCP         CHAIN     CPOSC                              34
     C                   IF        *IN34 = *ON
     C                   Z-ADD     0             CSNV
     C                   Z-ADD     0             APDT
     C                   ENDIF
     C                   Z-ADD     APDT          WrkAPDT
 
      ** Get Customer Depot Position for Changes to Nominal Amount Today
 
     C     KEYCP         SETLL     CDEPP
     C     KEYCP         READE     CDEPP                                  35
     C                   Z-ADD     0             WrkNP
     C                   Z-ADD     0             WrkNS
 
     C     *IN35         DOWEQ     '0'
     C                   ADD       SNPT          WrkNP
     C                   ADD       CDST          WrkNS
     C     KEYCP         READE     CDEPP                                  35
     C                   ENDDO
 
      *
      ** Calculation is Sum(Nominal * Date) / Sum(Nominal)
      ** Or (Previous Total Nominal * APDT) + (WAmt * WDate)
      **    ------------------------------------------------
      **                 New Total Nominal
      *
 
     C                   EVAL      PrvNoml = CSNV + WrkNS + WrkNP
      *
      ** Walk Outs and Trade Purchases
      *
     C                   IF        WType = 'WO' OR Wtype = 'TP'
 
     C                   EVAL      NewNoml = PrvNoml - WAmt
      *
      ** If Purchase has reduced the Nominal to zero, reset the date
      *
     C                   IF        NewNoml <= 0
     C                   Z-ADD     0             WrkAPDT
     C                   ENDIF
     C                   ENDIF
      *
      ** Walk Ins and Trade Sales
      *
     C                   IF        WType = 'WI' OR Wtype = 'TS'
 
     C                   EVAL      NewNoml = PrvNoml + WAmt
 
     C                   IF        NewNoml = 0
     C                   Z-ADD     0             WrkAPDT
     C                   ELSE
 
     C                   IF        APDT = 0
     C                   Z-ADD     WDate         WrkAPDT
     C                   ELSE
 
     C                   EVAL      PrvNum = PrvNoml * APDT
     C                   EVAL      TrnNum = WAmt  * WDate
     C                   EVAL      TotNum = PrvNum + TrnNum
 
     C                   EVAL      WrkAPDT = TotNum / NewNoml
 
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDIF
 
     C     EDef          ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      * *INZSR - Program Initialisation routine                       *
      *****************************************************************
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
 
      ** INPUTS
      ** Input Fields
 
     C                   PARM                    WBrca
     C                   PARM                    WCust
     C                   PARM                    WSesn
     C                   PARM                    WType             2
     C                   PARM                    WAmt             11 0
     C                   PARM                    WDate
 
      ** OUTPUTS
      ** Average Purchase Date
 
     C                   PARM                    WrkAPDT
 
      ** Define key list for file
 
     C     KEYCP         KLIST
     C                   KFLD                    WBrca             3
     C                   KFLD                    WCust
     C                   KFLD                    WSesn            10
 
     C     *LIKE         DEFINE    SNPT          WrkNP
     C     *LIKE         DEFINE    CDST          WrkNS
     C     *LIKE         DEFINE    CSNV          PrvNoml
     C     *LIKE         DEFINE    CSNV          NewNoml
     C     *LIKE         DEFINE    CSNV          PrvNum
     C     *LIKE         DEFINE    CSNV          TrnNum
     C     *LIKE         DEFINE    CSNV          TotNum
     C     *LIKE         DEFINE    CSNV          TotNum
     C     *LIKE         DEFINE    CSDA          WDate
     C     *LIKE         DEFINE    CSDA          WrkAPDT
 
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
