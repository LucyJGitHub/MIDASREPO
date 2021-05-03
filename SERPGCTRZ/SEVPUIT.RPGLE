     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SE Validate Purchased Interest')                 *
      *****************************************************************
      *                                                               *
      *  Midas - Security Trading Module.                             *
      *                                                               *
      *  SEVPUIT    - Validate Purchased Interest.                    *
      *                                                               *
      *  Function:  This module performs the validation for the       *
      *             Purchased Interest input field.                   *
      *                                                               *
      *  Component of: SE0070 - Depot Movements Maintenance           *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *    This source is centrally supported and must ONLY be        *
      *    amended by Core Development Personnel                      *
      *                                                               *
      *    /COPY, Client or Country amendments must not be            *
      *    applied to this source.                                    *
      *                                                               *
      *  Last Amend No. CSD103             Date 10Aug20               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      *                 CRE073             Date 06Dec10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 BUG11193           Date 02May06               *
      *                 CSD027             Date 09Dec05               *
      *                 CSE075             Date 17Nov05               *
      *                 CGL035             Date 01Mar05               *
      *                 CSE074             Date 30Aug05               *
      *                 CSE071             Date 19Jul05               *
      *                 CGL031             Date 05Jul04               *
      *                 CAS006             Date 21Jan03               *
      * Midas Release 4.01 -------------------------------------------*
      *                 CSE031             Date 13Dec01               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *                 CSD006             Date 11Oct00               *
      * Midas DBA 3.03 -----------------------------------------------*
      *                 CAP137             Date 07Feb00               *
      * Midas DBA 3.02 -----------------------------------------------*
      *                 CPB001 *CREATE     DATE 20Aug99               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD103 - LIBOR Deregulation - Common Layer/Standing Data     *
      *             (Recompile)                                       *
      *  MD046248 - Finastra Rebranding                               *
      *  CRE073 - Interest Rate Rounding (Recompile)                  *
      *  BUG11193 - Purchased Interest not calculated on BackValued   *
      *             Trade. (Recompile)                                *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CSE075 - US Enhanced Treasury Upgrade to MidasPlus           *
      *           (Recompile)                                         *
      *  CGL035 - EUSD Upgrade to Midasplus (Recompile)               *
      *  CSE074 - Const. Yld Amort. Upgrade to MidasPlus (Recompile)  *
      *  CSE071 - Multiple Holidays Re Securities (recompile)         *
      *  CGL031 - Taxation of Savings Income (Recompile)              *
      *  CAS006 - Hedge Accounting Phase B (Recompile)                *
      *  CSE031 - Coupon Fixing for Floating Rate Notes.              *
      *           Recompiled due to changes in SECTYD.                *
      *  CSD006 - Recompiled over changed SECTYD.                     *
      *  CAP137 - Conversion of SE Security inputs into modular       *
      *           structure to use as APIs (SECTYD)                   *
      *  CPB001 - 'Private Banking' Module                            *
      *                                                               *
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
     FSECEO     IF   E           K DISK    INFSR(*pssr)
     F                                     RENAME(SEDEVDF:SEDEVDO)
 
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      **
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes (among others) the LDA layout
      ** and the copyright array definition:
     D/COPY ZACPYSRC,STD_D_SPEC
      **--------------------------------------------------------------------------------------------
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY includes the MM standard declares:
     D/COPY ZACPYSRC,STDDECLARE
      **--------------------------------------------------------------------------------------------
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes all the defined fields in the
      ** Program Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
      **--------------------------------------------------------------------------------------------
 
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
 
      ** The maximum size of the appended error arrays
     D XArrayMax       C                   CONST(20)
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
      ** Array of Fields in error.
     D FldNamXAr       S             10A   DIM(XArrayMax)
 
      ** Array of error message IDs
     D MsgIDXAr        S                   DIM(XArrayMax) LIKE(#MsgId)
 
      ** Array of error message data.
     D MsgDtaXAr       S                   DIM(XArrayMax) LIKE(#MsgData)
 
      ** Array of Fields with warnings.
     D WFldNmXAr       S             10A   DIM(XArrayMax)
 
      ** Array of warning message IDs
     D WMsgIDXAr       S                   DIM(XArrayMax) LIKE(#MsgId)
 
      ** Array of warning message data.
     D WMsgDtXAr       S                   DIM(XArrayMax) LIKE(#MsgData)
 
      ** Security Details
     D SecurDtls     E DS                  EXTNAME(SECTYD)
     D                                     PREFIX(SEC_)
     D CDArr                 183    230
     D CRArr                 231    242
 
      ** SECOND DS FOR ACCESS PROGRAMS, SHORT DATA STRUCTURE
     D DSSDY         E DS                  EXTNAME(DSSDY)
 
      ** FIRST DS FOR ACCESS PROGRAMS, SHORT DATA STRUCTURE
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Input fields
      ** ------------
 
      ** Screen Fields
 
     D DDPINT          S             15A
     D DDACIN          S              1A
 
      ** Depot Movement details Input
 
     D DPSS            S             10A
     D DPNA            S             11P 0
     D DPDO            S              5P 0
     D DPMD            S              5P 0
     D DPVD            S              5  0
     D PINT            S             13P 0
 
     ** System Info
 
     D DDDPNAOk        S              1A
     D PBInd           S              1A
     D DfltACIN        S              1A
     D VldtACIN        S              1A
     D Default         S              1A
     D Validate        S              1A
     D PROT            S              1A
     D NomCcyDec       S              1  0
     D BJDFIN          S              1A
 
      ** Output(s) fields
      ** ----------------
 
     D DDPINTSAVE      S             15A
     D DDPINTOk        S              1A
 
      ** Working variable
      ** ----------------
 
     D ZITRA           S             13  0
     D TDCR            S             11P 7
     D ZADIN           S              1A
     D ZCPOVR          S              1A
     D ZTINA           S             13  0
     D DADJN           S              1A
 
      ** Index for arrays of error message ids etc
 
     D Idx             S              3P 0
     D WIx             S              3P 0
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *****************************************************************
      /EJECT
      *****************************************************************
 
 
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *inzsr is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
      *
      ** Initialization
      *
     C                   MOVE      *BLANK        RetCodeIn
 
     C                   MOVE      *BLANK        FldNamXAr
     C                   MOVE      *BLANK        MsgIDXAr
     C                   MOVE      *BLANK        MsgDtaXAr
     C                   Z-ADD     0             Idx
     C                   MOVE      *BLANK        WFldNmXAr
     C                   MOVE      *BLANK        WMsgIDXAr
     C                   MOVE      *BLANK        WMsgDtXAr
     C                   Z-ADD     0             WIx
 
     C                   Z-ADD     0             PINT
      *
      **  Define key list for SECEO (SEDEVDO) Security Diary Events.
      *
     C     KLEVD         KLIST
     C                   KFLD                    SDSN
     C                   KFLD                    SDET
     C                   KFLD                    SDED
 
     C     PBInd         IFEQ      'Y'
      *
      ** DEFAULTING
      *
     C     Default       IFEQ      'Y'
     C     DDPINT        ANDEQ     *BLANK
     C     DPNA          ANDNE     *ZEROS
     C                   EXSR      PINTD
     C                   ENDIF
      *
      ** VALIDATION
      *
     C     Validate      IFEQ      'Y'
     C     DDPINT        ANDNE     *BLANKS
     C                   EXSR      PINTV
     C                   ENDIF
     C                   ENDIF
      *
      ** If an error was found, set the return code appropriately
      *
     C     DDPINTOk      IFEQ      'N'
     C                   EVAL      RetCodeIn = 'Error'
     C                   ENDIF
      *
      ** Return
      *
     C                   RETURN
      *****************************************************************
      /EJECT
      *****************************************************************
      ** PINTV  - PURCHASED INTEREST VALIDATION
      *****************************************************************
     C     PINTV         BEGSR
      *
     C                   IF        DDDPNAOK <> 'Y'
     C                   GOTO      EndVal
     C                   ENDIF
      *
      **  Purchased interest must be a valid amount
      *
     C                   MOVE      *BLANKS       ZFLD17
     C                   MOVEL     DDPINT        ZFLD17
     C     13            SUB       NomCcyDec     ZSDIG
     C                   Z-ADD     NomCcyDec     ZSDEC
     C                   MOVE      *BLANKS       ZSDCSP
 
     C                   CALLB     'ZASIGN'
     C                   PARM                    ZALIGNok          1
     C                   PARM                    ZFLD17           17
     C                   PARM                    ZSDIG             2 0
     C                   PARM                    ZSDEC             1 0
     C                   PARM                    ZSDCSP            1
     C                   PARM                    ZOUT15           15
     C                   PARM                    ZFSIGN            1
 
     C     ZALIGNOk      IFNE      'Y'
      *
      ** Error 103
      *
     C                   MOVE      'N'           DDPINTOk
     C                   ADD       1             Idx
     C                   MOVEL     'DDPINT'      FldNamXar(Idx)
     C                   MOVEL     'MMA0714'     MsgIDXar(Idx)
     C                   GOTO      EndVal
     C                   ENDIF
 
     C                   MOVE      ZOUT15        ZITRA
     C                   Z-ADD     ZITRA         PINT
     C     ZFSIGN        IFEQ      '-'
     C                   Z-SUB     ZITRA         ZITRA
     C                   Z-SUB     ZITRA         PINT
     C                   ENDIF
 
     C                   MOVE      *BLANKS       ZFLD15
     C                   MOVE      ZITRA         ZFLD15
     C                   Z-ADD     NomCcyDec     ZDECS
     C                   MOVE      *BLANKS       ZECODE
     C                   MOVE      *BLANKS       ZECHAR
 
     C                   CALLB     'ZSEDITF'
     C                   PARM                    ZFLD15           15 0
     C                   PARM                    ZDECS             1 0
     C                   PARM                    ZECODE            1
     C                   PARM                    ZECHAR            1
     C                   PARM                    ZOUT21           21
 
     C                   MOVE      ZOUT21        DDPINT
 
     C     EndVal        ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      ** PINTD - PURCHASED INTEREST DEFAULTING
      *****************************************************************
     C     PINTD         BEGSR
      *
      **  Retrieve Depot Value Date
      *
     C                   Z-ADD     0             DPVD
     C                   IF        DPMVType = 'WI'
     C                   Z-ADD     DPMD          DPVD
     C                   ENDIF
      *
     C                   IF        DPMVType = 'WO'
     C                   Z-ADD     DPDO          DPVD
     C                   ENDIF
      *
      **  Not Update Purchased interest if Value Date is not setupped
      *
     C                   IF        DPVD <> 0
      *
      **  Setup Accrued Indicator if this one is blank
      *
     C                   IF        DDACIN = *BLANKS
     C                   MOVE      'Y'           DfltACIN
     C                   MOVE      'Y'           VldtACIN
     C                   EXSR      SetupACIN
     C                   ENDIF
      *
     C                   MOVE      DPSS          SDSN
     C                   MOVE      'IR'          SDET
     C                   Z-ADD     DPVD          SDED
     C     KLEVD         SETLL     SEDEVDO
     C                   READ      SEDEVDO                                33
      *
     C     *IN33         IFEQ      *OFF
     C     SDSN          ANDEQ     DPSS
     C     SDET          ANDEQ     'IR'
     C                   Z-ADD     SDNC          TDCR
     C                   ELSE
     C                   Z-ADD     SEC_CPNR      TDCR
     C                   ENDIF
      *
     C                   MOVE      *BLANK        ZADIN
     C                   MOVE      'N'           ZCPOVR
 
     C                   CALLB     'ZPCINT'
     C                   PARM                    SecurDtls
     C                   PARM                    DADJN
     C                   PARM                    NomCcyDec
     C                   PARM                    PROT
     C                   PARM                    DPNA
     C                   PARM                    DDACIN
     C                   PARM                    SEC_IADJ
     C                   PARM                    ZADIN
     C                   PARM                    TDCR
     C                   PARM                    ZCPOVR
     C                   PARM                    BJDFIN
     C                   PARM                    DPVD
     C                   PARM                    ZITRA
     C                   PARM                    ZTINA
 
     C                   MOVE      ZITRA         PINT
     C                   MOVE      *BLANKS       ZFLD15
     C                   MOVE      ZITRA         ZFLD15
     C                   Z-ADD     NomCcyDec     ZDECS
     C                   MOVE      *BLANKS       ZECODE
     C                   MOVE      *BLANKS       ZECHAR
 
     C                   CALLB     'ZSEDITF'
     C                   PARM                    ZFLD15           15 0
     C                   PARM                    ZDECS             1 0
     C                   PARM                    ZECODE            1
     C                   PARM                    ZECHAR            1
     C                   PARM                    ZOUT21           21
 
     C                   MOVE      ZOUT21        DDPINT
 
     C                   ENDIF
 
     C     EndDft        ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      ** PINTD - PURCHASED INTEREST DEFAULTING
      *****************************************************************
 
     C     SetupACIN     BEGSR
      *
      ** Validate Depot Accrued Indicator
      *
     C                   CALLB     'SEVDOIN'
      *
      * INPUTS
      *
      ** Return Code
     C                   PARM                    RetCodeOut
      *
      ** Default & Validate (Y or N)
     C                   PARM                    DfltACIN          1
     C                   PARM                    VldtACIN          1
      *
      ** Depot Screen fields
     C                   PARM                    DDACIN
      *
      ** Depot Value Date
     C                   PARM                    DPVD
      *
      ** Security Details
      ** Processing Type
     C                   PARM                    SecurDtls
     C                   PARM                    PROT
      *
      ** Date format ind
     C                   PARM                    BJDFIN
      *
      * OUTPUTS
      *
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      *
      ** Accrued Indicator - OK
     C                   PARM                    DDAcinOK          1
      *
      ** Depot Accrued Indicator
      *
     C                   PARM                    ACIN              1
      *
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *inzsr - Program Initialisation routine                       *
      *                                                               *
      * Called by: Implicitly on program activation                   *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     *inzsr        BEGSR
 
     C     *entry        PLIST
      ** Return Code Error Indicator
     C                   PARM                    RetCodeIn
 
      ** Received Parameters
      ** -------------------
 
      ** Screen inputs
      ** Purchased Interest (15A)
      ** Accured Indicator (1A)
     C                   PARM                    DDPINT
     C                   PARM                    DDACIN
 
      ** Depot Movement details Input
      ** Security (10A)
      ** Nominal (11P 0)
      ** Out Date (5P 0)
      ** In Date (5P 0)
      ** Depot Value Date (5P 0)
      ** Depot Movement Type (1A)
      ** Format Date Indicator (1A)
     C                   PARM                    DPSS
     C                   PARM                    DPNA
     C                   PARM                    DPDO
     C                   PARM                    DPMD
     C                   PARM                    DPVD
     C                   PARM                    DPMVType          2
     C                   PARM                    BJDFIN
 
      ** Security Details
      ** Nominal currency details
      ** Processing Tupe (1A)
      ** Purchased interest saved (15A)
      ** Nominal Amount Ok Indicator (1A)
     C                   PARM                    SecurDtls
     C                   PARM                    NomCcyDec
     C                   PARM                    PROT
     C                   PARM                    DDPINTSAVE
     C                   PARM                    DDDPNAOk
 
      ** ICD
      ** System Details
      ** Private Banking Module (1A)
      ** Default (1A)
 
     c                   PARM                    PBInd
     c                   PARM                    Default
     c                   PARM                    Validate
 
      ** Returned parameters
      ** -------------------
 
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
     C                   PARM                    WFldNmXAr
     C                   PARM                    WMsgIDXAr
     C                   PARM                    WMsgDtXAr
 
      ** Purchased Interest Ok Indicator (1A)
     C                   PARM                    DDPINTOk
     C                   PARM                    PINT
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY sets the values of program, module and
      ** procedure names for database error processing.
     C/COPY ZACPYSRC,DBFIELDS
      **--------------------------------------------------------------------------------------------
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      **--------------------------------------------------------------------------------------------
      ** The following /COPY contains the standard program status
      ** subroutine, including a bound call to the DBERRCTL module.
     C/COPY ZACPYSRC,PSSR_ILE
      **--------------------------------------------------------------------------------------------
      ********************************************************************
**  CPY@
(c) Finastra International Limited 2001
