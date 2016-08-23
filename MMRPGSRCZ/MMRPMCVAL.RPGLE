     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas MM Repo Margin Call Validation')                 *
      *****************************************************************
      *                                                               *
      *  Midas - Money Market Dealing Module                          *
      *                                                               *
      *  MMRPMCVAL - MM Repo Margin Call Validation                   *
      *                                                               *
      *  Function: This Program Validates Repo Margin Calls for       *
      *            input into the Midas Database.                     *
      *            The sequence of validation is based on subroutine  *
      *            #ZI in Midas program MM0028.                       *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      *  Last Amend No. CGL165             Date 15Feb17               *
      *  Prev Amend No. CDL096             Date 22Sep14               *
      *                 CDL094             Date 11Jun14               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD031             Date 10Apr06               *
      *                 CDL049             Date 11Jul06               *
      *                 CSD027             Date 09Dec05               *
      *                 CDL038             Date 10May05               *
      *                 CDL020             Date 03Feb04               *
      *                 CDL019             Date 03Feb04               *
      *                 CDL018             Date 03Feb04               *
      *                 CDL017             Date 03Feb04               *
      *                 CDL016             Date 03Feb04               *
      *                 CGL029             Date 01Sep03               *
      *                 222727             Date 05Nov03               *
      *                 222373             Date 27Oct03               *
      *                 CDL010             Date 02Aug02               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.02 -----------------------------------------------*
      *                 CSE006  *CREATE    Date 27Jul99               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CGL165 - Dual Withholding Tax (Recompile)                    *
      *  CDL096 - Business Day Conventions on MM Deals                *
      *           (Recompile)                                         *
      *  CDL094 - Enhance  Receive Settlement Instructions            *
      *           (Recompiled)                                        *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CDL049 - Addition of a Reference Rate field (recompile)      *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CDL038 - Extended Deal Sub Type (Recompile)                  *
      *  CDL020 - Apply Base Rate at Value Date (Recompile)           *
      *  CDL019 - Allow Base Rate Changes on Fixed Deposits/Loans     *
      *           (Recompile)                                         *
      *  CDL018 - Multiple Settlement Accounts on Loans/Deposits      *
      *           (Recompile)                                         *
      *  CDL017 - Penalty Fee & Early Maturity of Fixed Term Loan/Dep *
      *           (Recompile)                                         *
      *  CDL016 - Automatic rollover of Fixed Term Loans/Deposits     *
      *           (Recompile)                                         *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  222727 - Release 5.0 errors  (Recompile)                     *
      *  222373 - Parameter Mismatch                                  *
      *  CDL010 - Prevent last user that actioned the trade from      *
      *           authorising it.Recompile due to changes in MMDELDPP *
      *           MMDENBPP and MMDENSPP .                             *
      *  CSE006 - Repurchase Agreement Enhancements                   *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      *****************************************************************
 
     FMMDEALLL  IF   E           K DISK    INFSR(*PSSR)
     F                                     INFDS(RECDS)
 
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
 
      ** Include the MM standard declares
     D/COPY ZACPYSRC,STDDECLARE
 
      ** Program Status Data Structure
      ** =============================
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
 
     D/COPY ZACPYSRC,PSDS
      ** The following /COPY line includes definitions for the above fields
      ** as #ProcPgm, #ProcMod and #ProcName.  They are based on the
      ** corresponding fields in the PSDS /COPY member, so that member
      ** must be included where this one is used.
 
     D/COPY ZACPYSRC,PROCPARMS
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
     D/COPY ZACPYSRC,ERR_ARRAYS
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
 
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
     D TranIn        E DS                  EXTNAME(MMRPMCPD)
      ** External DS for Transaction Details
 
     D CrTranIn      E DS                  EXTNAME(MMRPMCPD) PREFIX(C)
      ** External DS for Transaction Details
 
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** EXTERNAL DS FOR BANK DETAILS
 
     D SDDEAL        E DS                  EXTNAME(SDDEALPD)
      ** EXTERNAL DS FOR DEALING DETAILS
 
     D SDGELR        E DS                  EXTNAME(SDGELRPD)
     D  QQACCD1      E                     EXTFLD(QQACCD)                                     CGL029
      ** EXTERNAL DS FOR GENERAL LEDGER DETAILS
 
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
      ** External data structure for currency details
 
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** FIRST DS FOR ACCESS PROGRAMS, SHORT DATA STRUCTURE
 
     D DSSDY         E DS                  EXTNAME(DSSDY)
      ** SECOND DS FOR ACCESS PROGRAMS, LONG DATA STRUCTURE
 
     D ValidEntry    E DS                  EXTNAME(MMVRPMCPD)
      ** Data Structure for valid Format for returned parameter
 
     D RECDS           DS
      **  Data structure for file status of MM deals file.
     D  MMRECORD         *RECORD
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Deal Fiduciary Charge Code parameter                                                 222373
     D IGFCGC          S              2                                                       222373
                                                                                              222373
      ** Deal Fiduciary Charge Description parameter                                          222373
     D IGFCGD          S             20                                                       222373
                                                                                              222373
      ** Deal Fiduciary Charge Amount parameter                                               222373
     D IGFXGA          S             13  0                                                    222373
                                                                                              222373
     ** Warning message code 1 received as a parameter                                        222373
     D WMSGID1         S                   LIKE(#MSGID)                                       222373
                                                                                              222373
      ** Customer from original deal                                                          222373
     D*H@CNUM***       S              6  0                                             222373 CSD027
     D H@CNUM          S              6A                                                      CSD027
                                                                                              222373
      ** Currency from original deal                                                          222373
     D H@CCY           S              3A                                                      222373
                                                                                              222373
      ** Deal Type from original deal                                                         222373
     D H@MTYP          S              2A                                                      222373
                                                                                              222373
      ** Charges on Principal (from SDDEALPD)                                                 222373
     D B@CHPC          S              1A                                                      222373
      ** Error message fields received as parameters
     D     Msg1        S                   LIKE(#MsgID)
     D     Msg2        S                   LIKE(#MsgID)
 
      ** Error message substitution data received as a parameter
     D MSGDATA         S                   LIKE(#MsgData)
 
      ** Index for arrays of of error message ids etc
     D Idx             S              3P 0
      ** Warning Index for arrays of of error message ids etc
     D WIdx            S              3P 0
 
      ** Flags to indicate whether transaction fields are valid
     D OKFlagsDS       DS
     D  DDTypeOK                      1A
     D  DDAmntOK                      1A
     D  DDDlnoOK                      1A
     D  DDCcyOK                       1A
 
      ** Response Mode, received as a parameter from the common header
     D RespMode        S              1A
     D DDDS38          S              3S 0 INZ(0)
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
 
      ** +----------------------------------------+
      ** ¦ Hook for non-core D-specs (all types)  ¦
      ** ¦ also any I-specs (if necessary)        ¦
      ** ¦ =====================================  ¦
      ** +----------------------------------------+
 
      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
 
     C                   RESET                   DDTypeOK
     C                   RESET                   DDAmntOK
     C                   RESET                   MMRECORD
     C                   MOVE      'Y'           DDDlNoOk
 
      ** Get original Deal Details
 
     C                   EXSR      RTVDEALDTL
 
      ** Bypass further validation if Deam does not reference a
      ** valid Deal
 
     C     DDDlnoOK      IFNE      'Y'
     C                   GOTO      EXITMODULE
     C                   END
 
      *  *-------------------*
      *  * Validate Amount   *
      *  *-------------------*
     C                   EXSR      RESETERRS
 
     C** Access no of decimal places of Deal currency
 
     C                   CALLB     'AOCURRR0'
     C                   PARM      *BLANKS       @RTCD             7
     C                   PARM      '*KEY   '     @OPTN             7
     C                   PARM      HKCCY         @AJCD             3
     C     SDCURR        PARM      SDCURR        DSSDY
     C
     C                   IF        @RTCD <> *Blanks
     C                   EVAL      DDCcyOK = 'N'
     C                   ELSE
     C                   EVAL      DDCcyOK = 'Y'
     C                   ENDIF
 
     C*
     C** Update of Deal amount is not allowed in amend mode
     C                   IF        DDACTN = 'A' and DDAMNT <> CDDAMNT
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDAMNT'
     C                   EVAL      MsgIDArr(Idx) = 'MMM0372'
     C                   EVAL      ReturnCode = 'Error'
 
     C                   ELSE
 
     C                   CALLB     'MMVDEAMAMT'
     C                   PARM                    ReturnCode
     C                   PARM                    MSG1
     C                   PARM                    DDTYPE
     C                   PARM                    DDDLNO
     C                   PARM                    DDAMNT
     C                   PARM                    DDVDAT
     C                   PARM                    DDDS38
     C                   PARM                    DDACTN
     C                   PARM                    HKAMNP
     C                   PARM                    A6NBDP
     C                   PARM                    BNDCSP
     C                   PARM                    BJDFIN
     C                   PARM                    DDCcyOK
     C                   PARM                    Idx
     C                   PARM                    IGAMNP
     C                   PARM                    IGFCGC                                       222373
     C                   PARM                    IGFCGD                                       222373
     C                   PARM                    IGFXGA                                       222373
     C                   Parm                    CGL011            1                          222373
     C                   Parm                    Collateral_Ind    1                          222373
     C                   Parm                    WMSGID1                                      222373
      ** Customer from original deal                                                          222373
     C                   PARM                    H@CNUM                                       222373
      ** Currency from original deal                                                          222373
     C                   PARM                    H@CCY                                        222373
      ** Deal Type from original deal                                                         222373
     C                   PARM                    H@MTYP                                       222373
      ** Charges on Principal (from S                                                         222373
     C                   PARM                    B@CHPC                                       222373
 
     C     MSG1          IFNE      *BLANK
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDAMNT'
     C                   EVAL      MsgIDArr(Idx) = MSG1
     C                   ENDIF
     C                   ENDIF
 
      ** Use the return code's value to set the field's OK flag
     C                   CALLB     'ZASETOKFLG'
     C                   PARM                    DDAmntOK
     C                   PARM                    ReturnCode
     C                   PARM                    WarnGlobal
 
      *  *---------------------------*
      *  * Validate Transaction Type *
      *  *---------------------------*
     C                   EXSR      RESETERRS
 
     C                   CALLB     'MMVDLMG'
     C                   PARM                    ReturnCode
     C                   PARM                    MSG1
     C                   PARM                    DDTYPE
 
      /COPY WNCPYSRC,MMDEAMV012
 
     C     MSG1          IFNE      *BLANK
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDTYPE'
     C                   EVAL      MsgIDArr(Idx) = MSG1
     C                   ELSE
     C                   MOVE      DDTYPE        IGTYPE
     C                   ENDIF
 
     C                   IF        DDACTN = 'A' and DDTYPE <> CDDTYPE
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDTYPE'
     C                   EVAL      MsgIDArr(Idx) = 'MMM0502'
     C                   EVAL      ReturnCode = 'Error'
     C                   ENDIF
 
      ** Use the return code's value to set the field's OK flag
     C                   CALLB     'ZASETOKFLG'
     C                   PARM                    DDTypeOK
     C                   PARM                    ReturnCode
     C                   PARM                    WarnGlobal
 
     C     EXITMODULE    TAG
 
     C                   RETURN
 
      * Hook to enable non-core subroutines to be included
      /COPY WNCPYSRC,MMDEAMV018
 
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
 
     C     *ENTRY        PLIST
      * Response mode (1A), from source system common header
     C                   PARM                    RespMode
      * Transaction information (DS) from source system
     C                   PARM                    TranIn
      * Transaction information (DS) from source system
     C                   PARM                    CrTranIn
      * Field OK flags (DS) from/to caller
     C                   PARM                    OKFlagsDS
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
      * Array index (3P0) from/to caller
     C                   PARM                    Idx
      * Warning fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIDArr
     C                   PARM                    WMsgDtaArr
      * Array index (3P0) from/to caller
     C                   PARM                    WIdx
      * Valid Input Returned to calling program
     C                   PARM                    ValidEntry
      **
      **  Move program name into *LDA field.
     C     *LOCK         IN        LDA
     C                   MOVEL     'MMDEAMVAL'   DBPGM
     C                   OUT       LDA
      *
      ** Access Bank details via access program
      *  (database error handling done in access program)
     C                   CALLB     'AOBANKR0'
     C                   PARM      '*DBERR '     @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
      *
      ** Access Dealing details via access program
      *  (database error handling done in access program)
     C**********         CALLB     'AODEALR0'                                                 CGL029
     C                   CALLB     'AODEALR1'                                                 CGL029
     C                   PARM      '*DBERR '     @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C*****SDDEAL        PARM      SDDEAL        DSFDY                                        CGL029
     C     SDDEAL        PARM      SDDEAL        DSSDY                                        CGL029
      *
      ** Access General Ledger details via access program
      *  (database error handling done in access program)
     C**********         CALLB     'AOGELRR0'                                                 CGL029
     C                   CALLB     'AOGELRR1'                                                 CGL029
     C                   PARM      '*DBERR '     @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C*****SDGELR        PARM      SDGELR        DSFDY                                        CGL029
     C     SDGELR        PARM      SDGELR        DSSDY                                        CGL029
      *
      *  Set up the name of the MSGF from which the message handler will
      *   get the messages
     C                   EVAL      #MsgFile = 'DRSMM'
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY sets the values of program, module and
      ** procedure names for database error processing.
     C/COPY ZACPYSRC,DBFIELDS
      **--------------------------------------------------------------------------------------------
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * RTVDEALDTL - Retrieve the original Deal Details of the Deal   *
      *    Amendment and move into common Data Structure              *
      *                                                               *
      *****************************************************************
 
     C     RTVDEALDTL    BEGSR
 
      ** Get Original Deal Details
 
     C                   MOVE      DDDLNO        DealNum           6 0
     C     DealNum       CHAIN     MMDEALLL                           65
 
      ** Check for a valid record.
 
     C     *IN65         IFEQ      '1'
     C     HKDLTF        ORNE      *BLANK
     C     MMRECORD      ANDEQ     'MMDELDP0'
     C     HLDLTF        ORNE      *BLANK
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDDLNO'
     C                   EVAL      MsgIdArr(Idx)   = 'MMM0150'
     C                   MOVE      'N'           DDDlnoOK
     C                   END
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * RESETERRS - Reset error information that is received back     *
      *    from each validation module.                               *
      *                                                               *
      *****************************************************************
 
     C     RESETERRS     BEGSR
 
     C                   RESET                   Msg1
     C                   RESET                   Msg2
 
     C                   RESET                   MSGDATA
 
     C                   EVAL      ReturnCode= *Blanks
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      ********************************************************************
      /COPY ZACPYSRC,DBERREXIT
      /EJECT
      ********************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      /EJECT
      ********************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2001
