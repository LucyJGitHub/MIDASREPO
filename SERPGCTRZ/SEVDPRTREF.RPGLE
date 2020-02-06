     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SE Validate portfolio reference')
      *****************************************************************
      *                                                               *
      *  Midas - Security Trading Module.                             *
      *                                                               *
      *  SEVDPRTREF - Validate Portfolio Reference.                   *
      *                                                               *
      *  Function:  This module performs the validation for the       *
      *             Portfolio Reference input field.                  *
      *                                                               *
      *  This module is an ILE/RPG IV conversion of the validation    *
      *  routine for the said field. This routine has been retrieved  *
      *  from SE0070 and has been converted to ILE RPG and copied into*
      *  this member.  Necessary code to make this compileable has    *
      *  been added (entry and exit points and some declares).        *
      *                                                               *
      *  The existing code has not been changed except:               *
      *  - to remove dead lines                                       *
      *  - to convert a couple of EXSRs to CALLBs                     *
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
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      *  Prev Amend No. 245825             Date 22Feb07               *
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD031             Date 10Apr06               *
      *                 CSD027             Date 09Dec05               *
      *                 BUG1034            Date 06Feb06               *
      *                 CSW037A            Date 02May05               *
      *                 CSD025             Date 11Jan05               *
      *                 CSW037             Date 15Dec04               *
      *                 CSW036             Date 15Dec04               *
      *                 CLE025             Date 20Oct03               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.02 -----------------------------------------------*
      *                 CPB001             Date 02Jul99               *
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 CAP003  *CREATE    Date 23Apr98               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  245825 - Fix for BUG10344 did not take in account Private    *
      *           Banking module.                                     *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  BUG10344 - SEC0606F DBerror in SE2400 PG/SDPLCSPD            *
      *  CSW037A- Additional Field extended to 40 chars (recompile)   *
      *  CSD025 - Customer De-Activation                              *
      *  CSW037 - Additional Field Data on MT300/MT320                *
      *  CSW036 - Dual SWIFT BIC held on Client Details               *
      *  CLE025 - Credit Lines (Recompile)                            *
      *  CPB001 - 'Private Banking' Module                            *
      *  CAP003 - Conversion of SE inputs into modular structure to   *
      *           use as APIs.                                        *
      *                                                               *
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
     FPMPORTPD  IF   E           K DISK
     FPMAPOSLL  IF   E           K DISK
     FPMPORTLL  IF   E           K DISK
     F                                     RENAME(PMPORTP0:PMPORTYY)
      ** Customer Positions
     FCPOSC     IF   E           K DISK
     F                                     RENAME(CPOSNDF:CPOSNDF1)
 
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
 
      ** Portfolio Customer Details Via Access Program
     D SDPLCS        E DS                  EXTNAME(SDPLCSPD)
 
      ** Portfolio Definition Details
     D PORTDET       E DS                  EXTNAME(PMPORTPD)
      ** Customer Details Via Access Program                                    CPB001
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)                    CPB001
                                                                                CPB001
      ** SECOND DS FOR ACCESS PROGRAMS, VERY LONG DATA STRUCTURE                CPB001
     D DSLDY         E DS                  EXTNAME(DSLDY)                       CPB001
 
      ** FIRST DS FOR ACCESS PROGRAMS, SHORT DATA STRUCTURE
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Input fields
      ** ------------
 
      ** Screen Fields
 
     D DDDPID          S             10A
     D DDDPOD          S             10A
     D DDPTFR          S              4A
 
      ** Depot Movement details Input
 
     D*DPBN*****       S              6S 0                                                    CSD027
     D DPBN            S              6A                                                      CSD027
     D DPBA            S              3A
     D DPSS            S             10A
     D DPNA            S             11P 0
     D DPDO            S              5P 0
     D BFCLASCus       S              1A
 
     ** System Info
 
     D FCR997          S              4A
     D S01496          S              1A
     D PortPreIn       S              1A
     D PBInd           S              1A                                        CPB001
 
      ** Output(s) fields
      ** ----------------
 
     D DDPTFROk        S              1A
     D DDDPNAOk        S              1A
     D PTFR            S              4A
     D WWPLCS          S              1A
     D WWPBCS          S              1A                                        CPB001
 
      ** Working variable
      ** ----------------
 
     D WWNOML          S             15P 0
     D RES70Y          S              1A
     D WPTFR           S              4A
     D WTVDA           S              1A
     D WWBRCH          S              3A
     D WWCLIN          S             10A
     D*WWCNUM***       S              6P 0                                                    CSD027
     D WWCNUM          S              6A                                                      CSD027
     D WWKY10          S             10A
     D WWOPTN          S              7A
     D WWRTCD          S              7A
     D WWSESN          S             10A
 
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
 
     C                   MOVE      *BLANKS       PTFR
      *
      **  Define KEY LIST for Chaining to PMPORTPD
      *
     C     PORKEY        KLIST
     C                   KFLD                    DPBN
     C                   KFLD                    DDPTFR
 
     C     POSKEY        KLIST
     C                   KFLD                    DPBN
     C                   KFLD                    WPTFR
     C                   KFLD                    DPSS
     C                   KFLD                    WTVDA
     C                   KFLD                    DPDO
      *
      ** Validate
      *
     C                   EXSR      PTFRV
      *
      ** If an error was found, set the return code appropriately
      *
     C     DDPTFROk      IFEQ      'N'
     C                   EVAL      RetCodeIn = 'Error'
     C                   ENDIF
      *
      ** Return
      *
     C                   RETURN
      ********************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * PTFRV - Validate Portfolio Reference entry                    *
      *                                                               *
      * Called by: Main                                               *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     PTFRV         BEGSR
 
     C     PortPreIn     IFEQ      'Y'
     C     PBInd         OREQ      'Y'                                          CPB001
 
     C     DDDPID        IFNE      *BLANKS
     C     DDDPOD        ANDNE     *BLANKS
 
     C     DDPTFR        IFNE      *BLANKS
      *
      ** Error 235
      *
     C                   ADD       1             Idx
     C                   MOVEL     'DDPTFR'      FldNamXAr(Idx)
     C                   MOVEL     'MMA0221'     MsgIdXAr(Idx)
     C                   MOVE      'N'           DDPTFROk
     C                   END
 
     C                   ELSE
 
     C                   MOVEL     DPBN          WWCLIN
     C                   MOVEL     'N'           WWPLCS                         CPB001
     C                   MOVEL     'N'           WWPBCS                         CPB001
 
     C     PortPreIn     IFEQ      'Y'                                          CPB001
     C                   CALLB     'AOPLCSR0'
     C                   PARM      '*MSG    '    WWRTCD
     C                   PARM      '*KEY    '    WWOPTN
     C                   PARM      WWCLIN        WWKY10
     C     SDPLCS        PARM      SDPLCS        DSFDY
      *
      ** Customer is a Portfolio Customer: get default value if blank
      *
     C     WWRTCD        IFEQ      *BLANKS
     C                   MOVEL     'Y'           WWPLCS
     C                   ENDIF                                                  CPB001
     C                   ENDIF                                                  CPB001
      *
     C     PBInd         IFEQ      'Y'                                          CPB001
     C                   CALL      'AOCUSTR1'                                   CPB001
     C                   PARM      '*MSG   '     WWRTCD                         CPB001
     C                   PARM      '*KEY   '     WWOPTN                         CPB001
     C                   PARM      WWCLIN        WWKY10                         CPB001
     C                   PARM      *BLANKS       WWKY7             7            CPB001
     C     SDCUST        PARM      SDCUST        DSLDY                          CPB001
      *                                                                         CPB001
     C     WWRTCD        IFEQ      *BLANKS                                      CPB001
     C     BBPRBA        ANDEQ     'Y'                                          CPB001
     C                   MOVEL     'Y'           WWPBCS                         CPB001
     C                   ENDIF                                                  CPB001
     C                   ENDIF                                                  CPB001
      *                                                                         CPB001
      ** Customer is Portfolio Customer or Private Banking Customer             CPB001
      ** Default Portfolio Reference if necessary                               CPB001
      *                                                                         CPB001
     C     WWPLCS        IFEQ      'Y'                                          CPB001
     C     WWPBCS        OREQ      'Y'                                          CPB001
      *                                                                         CPB001
     C     DDPTFR        IFEQ      *BLANKS
     C     PBInd         IFNE      'Y'                                          CPB001
     C                   MOVE      FCR997        DDPTFR
     C                   ENDIF                                                  CPB001
      *
      ** or check if customer has a defined portfolio reference
      *
     C     DPBN          SETLL     PMPORTLL
     C     DPBN          READE     PMPORTLL                               82
     C     *IN82         IFEQ      '0'
     C                   MOVE      PNPTFR        DDPTFR
     C                   END
 
     C                   END
      *
      ** Customer is not a Portfolio Customer: DDPTFR must be blank
      *
     C                   ELSE
     C***********        MOVEL     'N'           WWPLCS                         CPB001
 
     C     DDPTFR        IFNE      *BLANKS
      *
      ** Error 236
      *
     C                   ADD       1             Idx
     C                   MOVEL     'DDPTFR'      FldNamXAr(Idx)
     C     PBInd         IFEQ      'Y'                                          CPB001
     C                   MOVEL     'MMA0718'     MsgIdXAr(Idx)                  CPB001
     C                   ELSE                                                   CPB001
     C                   MOVEL     'MMA0222'     MsgIdXAr(Idx)
     C                   ENDIF                                                  CPB001
     C                   MOVE      'N'           DDPTFROk
     C                   END
 
     C                   END
      *
      ** Must be a valid Portfolio Reference for Customer
      *
     C     DDPTFROk      IFNE      'N'
     C     DDPTFR        ANDNE     FCR997
     C     DDPTFR        ANDNE     *BLANKS
     C     DDPTFROk      ORNE      'N'                                          CPB001
     C     DDPTFR        ANDNE     *BLANKS                                      CPB001
     C     PBInd         ANDEQ     'Y'                                          CPB001
 
     C     PORKEY        CHAIN     PMPORTPD                           33
 
     C     *IN33         IFEQ      '1'
     C     PNRECI        OREQ      '*'
      *
      ** Error 237
      *
     C                   ADD       1             Idx
     C                   MOVEL     'DDPTFR'      FldNamXAr(Idx)
     C     PBInd         IFEQ      'Y'                                          CPB001
     C                   MOVEL     'MMA0717'     MsgIdXAr(Idx)                  CPB001
     C                   ELSE                                                   CPB001
     C                   MOVEL     'MMA0223'     MsgIdXAr(Idx)
     C                   ENDIF                                                  CPB001
     C                   MOVE      'N'           DDPTFROk
     C                   END
 
     C                   END
      *
      ** If type 'WO', check if nominal amount is acceptable
      *
     C     DDPTFROk      IFNE      'N'
     C     DDDPID        ANDEQ     *BLANKS
     C     DDDPOD        ANDNE     *BLANKS
 
     C     S01496        IFEQ      'Y'
 
     C     BFCLASCus     IFEQ      'S'
     C     BFCLASCus     OREQ      'D'
     C                   MOVE      DPBA          WWBRCH
     C                   MOVE      DPBN          WWCNUM
     C                   MOVE      DPSS          WWSESN
     C                   Z-ADD     DPNA          WWNOML
 
     C                   EXSR      SR70YA
 
     C     RES70Y        IFEQ      '1'
      *
      ** Warning W10
      *
     C                   ADD       1             WIx
     C                   MOVEL     'DDPTFR'      WFldNmXAr(WIx)
     C                   MOVEL     'MMA0224'     WMsgIdXAr(WIx)
     C                   MOVE      'W'           DDDPNAOk
     C                   END
 
     C                   END
     C                   ELSE
     C                   MOVE      'V'           WTVDA
      *
      ** Determine Portfolio Reference to be used for Access of PMAPOSLL
      *
     C     DDPTFR        IFEQ      FCR997
     C     PBInd         ANDNE     'Y'                                          CPB001
     C                   MOVE      '9997'        WPTFR
     C                   ELSE
     C                   MOVE      DDPTFR        WPTFR
     C                   END
      *
     C     POSKEY        SETGT     PMAPOSLL
     C                   READP     PMAPOSLL                               33
      *
     C     *IN33         IFEQ      '1'
     C     DPBN          ORNE      QACNUM
     C     WPTFR         ORNE      QAPTFR
     C     DPSS          ORNE      QATDSS
     C     QATVDA        ORNE      'V'
     C     QANOML        ORLT      DPNA
      *
      ** Warning W10
      *
     C                   ADD       1             WIx
     C                   MOVEL     'DDPTFR'      WFldNmXAr(WIx)
     C                   MOVEL     'MMA0224'     WMsgIdXAr(WIx)
     C                   MOVE      'W'           DDPTFROk
     C                   END
     C                   END
      *
     C                   END
      *
      ** Warning if selected Portfolio has been flagged for closure
      *
     C     DDPTFROk      IFNE      'N'
     C     DDPTFR        ANDNE     *BLANKS
     C     DDPTFR        ANDNE     FCR997
     C     DDPTFR        ANDNE     PTFR
     C     PNDPCL        ANDNE     0
     C     DDPTFROk      ORNE      'N'                                          CPB001
     C     DDPTFR        ANDNE     *BLANKS                                      CPB001
     C     DDPTFR        ANDNE     PTFR                                         CPB001
     C     PBInd         ANDEQ     'Y'                                          CPB001
     C     PNDPCL        ANDNE     0                                            CPB001
      *
      ** Warning W09
      *
     C                   ADD       1             WIx
     C                   MOVEL     'DDPTFR'      WFldNmXAr(WIx)
     C                   MOVEL     'MMA0360'     WMsgIdXAr(WIx)
     C                   MOVE      'W'           DDPTFROk
     C                   END
      *
     C     WWPLCS        IFEQ      'Y'                                                      BUG10344
     C     WWPBCS        OREQ      'Y'                                                        245825
     C     DDPTFR        IFEQ      FCR997
     C     PBInd         ANDNE     'Y'                                          CPB001
     C                   MOVE      '9997'        PTFR
     C                   ELSE
     C                   MOVE      DDPTFR        PTFR
     C                   END
     C                   ELSE                                                               BUG10344
     C                   MOVE      *BLANK        PTFR                                       BUG10344
     C                   ENDIF                                                              BUG10344
      *
     C                   END
 
     C                   END
 
     C                   ENDSR
 
      *****************************************************************
     C/EJECT
      ********************************************************************
      *
      ** SR70YA - SR to test trade making short position
      *
      **  WWBRCH   : BRANCH NO
      **  WWSESN   : SECURITY SHORTNAME
      **  WWCNUM   : CUSTOMER NO
      **  WWNOML   : NOMINAL
      **  RES70Y   : (OUT) '0'= O.K.
      **                   '1'= SHORT POSITION
      *
      *****************************************************************
      *
     C     SR70YA        BEGSR
      *
      ** KLIST for CPOSC
      *
     C     KCPOSC        KLIST
     C                   KFLD                    WWBRCH
     C                   KFLD                    WWCNUM
     C                   KFLD                    WWSESN
      *
      ** Initialization
      *
 
     C                   MOVE      '0'           RES70Y
      *
      ** Find Customer Position Prev. Day
      *
     C     KCPOSC        CHAIN     CPOSNDF1                           44
     C     *IN44         IFEQ      '1'
     C                   MOVE      '1'           RES70Y
     C                   END
      *
      ** Test nominal vs. current position
      *
     C     CSNT          IFGT      0
     C     WWNOML        IFGT      CSNT
     C                   MOVE      '1'           RES70Y
     C                   END
      *
      ** ...Otherwise, if position already short output error showing
      ** that position will go even shorter
      *
     C                   ELSE
     C                   MOVE      '1'           RES70Y
     C                   END
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
      ** In Depot  (10A)
      ** Out Depot (10A)
      ** Portfolio Reference (4A)
     C                   PARM                    DDDPID
     C                   PARM                    DDDPOD
     C                   PARM                    DDPTFR
 
      ** Depot Movement details Input
      ** Beneficiary  (6S 0)
      ** Branch (3A)
      ** Security (10A)
      ** Nominal (11P 0)
      ** Out Date (5P 0)
      ** Customer Classification (1A)
     C                   PARM                    DPBN
     C                   PARM                    DPBA
     C                   PARM                    DPSS
     C                   PARM                    DPNA
     C                   PARM                    DPDO
     C                   PARM                    BFCLASCus
 
      ** ICD
      ** System Details
 
      ** Reference attached to 997 (4A)
      ** S01496 Indicator (1A)
      ** Portfolio module indicator (instead of U4) (1A)
      ** Private Banking module indicator (instead of U4) (1A)                  CPB001
     C                   PARM                    FCR997
     C                   PARM                    S01496
     C                   PARM                    PortPreIn
     c                   PARM                    PBInd                          CPB001
 
      ** Returned parameters
      ** -------------------
 
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
     C                   PARM                    WFldNmXAr
     C                   PARM                    WMsgIDXAr
     C                   PARM                    WMsgDtXAr
 
      ** Portfolio Customer details
     C                   PARM                    SDPLCS
 
      ** Portfolio Definition Details
     C                   PARM                    PORTDET
 
      ** Portfolio Customer indicator
     C                   PARM                    WWPLCS
                                                                                CPB001
      ** Private Banking Customer indicator                                     CPB001
     C                   PARM                    WWPBCS                         CPB001
      ** Portfolio Reference Ok Indicator (1A)
      ** Nominal Amount Ok Indicator (1A)
      ** Portfolio Reference (4A)
     C                   PARM                    DDPTFROk
     C                   PARM                    DDDPNAOk
     C                   PARM                    PTFR
 
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
