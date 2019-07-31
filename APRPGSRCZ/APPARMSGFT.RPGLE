     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2007')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas AP Set up Transaction and Settlement Data')      *
      *****************************************************************
      *                                                               *
      *  Midas - API Interface Module  (For Funds Transfer)           *
      *                                                               *
      *  APPARMSGFT - Midas AP Set up Transaction and Settlement Data *
      *                                                               *
      *  Function:  This program sets up the Transaction and          *
      *             Settlement Data Structures.                       *
      *                                                               *
      *  Called By - APINCOMMSG - Process incoming messages           *
      *                                                               *
      *  (c) Finastra International Limited 2007                      *
      *                                                               *
      *  Last Amend No. CSD102             Date 08Jan19               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      *                 CDL094             Date 11Jun14               *
      *                 CFT039             Date 28Sep12               *
      *                 CSF011A            Date 28Nov11               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 248920 *CREATE     Date 05Jul07               *
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD102 - Password Length Extension                           *
      *  MD046248 - Finastra Rebranding                               *
      *  CDL094 - Enhance Receive Settlement Instructions (recompile) *
      *  CFT039 - SWIFT Mapping of Field Ordering Bank                *
      *           Align parameters with FTOPAYCTL                     *
      *           Amendment done to accommodate longer data           *
      *  CSF011A - CCR015: Display Order in Confirmation Pages        *
      *            (Recompile)                                        *
      *  248920 - FT OPAY API buffer is divided into file format      *
      *           lengths with a maximum of 500 wh. is too short for  *
      *           parms 1 and 7 (FTOPY1PD + FTOPY6PD)                 *
      *                                                               *
      *****************************************************************
 
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
      **    True       logical = *on (for indicator processing)
      **    False      logical = *off (for indicator processing)
      **    DBErrCtl   10A     = 'DBERRCTL' (the name of the database error
      **                                    handler)
      ** and the following variables:
      **    RunBefore  1A (for the PSSR)
 
     D/COPY ZACPYSRC,STD_D_SPEC
 
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
 
      ** Data structure for incoming message formats
     D*BUFFER***       DS          6000                                                       CFT039
     D*BUFFER***       DS         12000                                                CFT039 CSD102
     D BUFFER          DS         29997                                                       CSD102
     D  TYPE                   1      8
     D  USERID                33     42
     D**PASSWORD              43     52                                                       CSD102
     D  PASSWORD              43    170                                                       CSD102
 
     D PaySttmt      E DS                  EXTNAME(SDESSPPD)
      * Pay Settlement Instructions
     D RecSttmt      E DS                  EXTNAME(SDESSRPD)
      * Receive Settlement Instructions
     D FRASttmt      E DS                  EXTNAME(SDESSFPD)
      * FRA/IRS Settlement Instructions
 
     D PayStmtV      E DS                  EXTNAME(SDESSPPD)  PREFIX(V)
      * Pay Settlement Instructions
     D RecStmtV      E DS                  EXTNAME(SDESSRPD)  PREFIX(V)
      * Receive Settlement Instructions
 
     D PayStmtM      E DS                  EXTNAME(SDESSPPD)  PREFIX(M)
      * Pay Settlement Instructions
     D RecStmtM      E DS                  EXTNAME(SDESSRPD)  PREFIX(M)
      * Receive Settlement Instructions
     D** Short Data Structure
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** External DS for SAR Details
     D SCSARD        E DS                  EXTNAME(SCSARDPD)
 
      ** Work variables used by CAP067
     D REP1Ln          S              4P 0
     D REP2Ln          S              4P 0
 
      ** Work variables used by CAP055/CAP056
     D CACFLn          S              4P 0
     D CACXLn          S              4P 0
     D IRRSLn          S              4P 0
     D IRRXLn          S              4P 0
     D IRRPLn          S              4P 0
     D IRFALn          S              4P 0
 
      ** Work variable used by CAS001
     D SDYRLn          S              4P 0
     D YRAT1Ln         S              4P 0
     D YRAT2Ln         S              4P 0
     D YRAT3Ln         S              4P 0
     D YRAT4Ln         S              4P 0
     D PRtCd           S              7A
     D POptn           S              7A
     D PSarD           S              6A
     D CAS001          S              1A
 
      ** Work variables used by CDL006
     D WFIDT1Ln        S              4P 0
     D WFIDT2Ln        S              4P 0
     D WFIDT3Ln        S              4P 0
     D WFIDT4Ln        S              4P 0
     D WFIDT5Ln        S              4P 0
     D WFIDT6Ln        S              4P 0
     D WFIDT7Ln        S              4P 0
     D WFIDT8Ln        S              4P 0
     D WFIDT9Ln        S              4P 0
 
      ** Work variable used by CAP043
     D WCFSC1OLn       S              4P 0
     D WCFSC2OLn       S              4P 0
     D WCFSC3OLn       S              4P 0
     D WCFSC4OLn       S              4P 0
     D WPCSC1OLn       S              4P 0
     D WPCSC2OLn       S              4P 0
     D WPCSC3OLn       S              4P 0
     D WPCSC4OLn       S              4P 0
     D WCFSC1TLn       S              4P 0
     D WCFSC2TLn       S              4P 0
     D WCFSC3TLn       S              4P 0
     D WCFSC4TLn       S              4P 0
     D WPCSC1TLn       S              4P 0
     D WPCSC2TLn       S              4P 0
     D WPCSC3TLn       S              4P 0
     D WPCSC4TLn       S              4P 0
     D WTRSCLn         S              4P 0
 
      *  Work variable used by CAS009
     D DLFELn          S              4P 0
     D DFEXLn          S              4P 0
     D CAS009          S              1A
 
     D DLFRHO        E DS                  EXTNAME(DLFRHOPD)
      ** External data structure for the Confirmed Holiday indicators
 
      ** Work variable used by CGL032
     D ACUDLn          S              4P 0
     D ACEXLn          S              4P 0
     D SDNALn          S              4P 0
     D NaEXLn          S              4P 0
     D CCTXLn          S              4P 0
     D NATXLn          S              4P 0
     D JACMLn          S              4P 0
     D OPYALn          S              4P 0                                                    CFT039
     D OPYCLn          S              4P 0                                                    CFT039
     D OPY9Ln          S              4P 0                                                    CFT039
     D OPY10Ln         S              4P 0                                                    CFT039
     D OPY11Ln         S              4P 0                                                    CFT039
     D Trans9A         S           1000A                                                      CFT039
     D Trans9B         S           1000A                                                      CFT039
     D Trans10         S            500A                                                      CFT039
     D Trans11         S            500A                                                      CFT039
 
      ** +--------------------------------------+
      ** ¦ Declared Variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** The following /COPY line includes definitions for the above fields
      ** as #ProcPgm, #ProcMod and #ProcName.  They are based on the
      ** corresponding fields in the PSDS /COPY member, so that member
      ** must be included where this one is used.
     D/COPY ZACPYSRC,PROCPARMS
 
      ** Other Depot Details for Securities Customer.
      ** This totals to 150 additional other depot details from the incoming message.
     D OthDData        S           4755A
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
 
      ****************************************************************
      *                                                              *
      *  Main processing                                             *
      *                                                              *
      ****************************************************************
 
      ** Set up the Transaction & Settlement DS's
 
     C                   EXSR      TRANSETI
 
     C                   SETON                                        LR
     C                   RETURN
      /EJECT
      ****************************************************************
      *                                                              *
      *  Set up Transaction and Settlement Data Structures           *
      *                                                              *
      ****************************************************************
     C     TRANSETI      BEGSR
 
     C                   CLEAR                   TRANS1FT       1000
     C                   CLEAR                   TRANS1          500
     C                   CLEAR                   TRANS1A        1000
     C                   CLEAR                   TRANS2          500
     C                   CLEAR                   TRANS3          500
     C                   CLEAR                   TRANS4          500
     C                   CLEAR                   TRANS5          500
     C                   CLEAR                   TRANS6          500
     C                   CLEAR                   TRANS6FT       1000
     C                   CLEAR                   TRANS7          500
     C                   CLEAR                   TRANS8          500
     C                   CLEAR                   TRANS9          500
     C                   CLEAR                   Trans9A                                 CFT039
     C                   CLEAR                   Trans9B                                 CFT039
     C                   CLEAR                   Trans10                                 CFT039
     C                   CLEAR                   Trans11                                 CFT039
     C                   CLEAR                   PaySttmt
     C                   CLEAR                   RecSttmt
     C                   CLEAR                   FRASttmt
     C                   CLEAR                   PayStmtV
     C                   CLEAR                   RecStmtV
     C                   CLEAR                   PayStmtM
     C                   CLEAR                   RecStmtM
     C                   CLEAR                   ExtData         500
     C                   CLEAR                   InfData         500
     C                   CLEAR                   OthDData
     C                   CLEAR                   RegData         500
     C                   EVAL      Bypass = 'N'
 
      ** Position Buffer pointer to 1st byte after the header data
 
     C     HEADLn        ADD       1             Bfp               4 0
 
      **--- Explanation of BUFFER substringing -----------------------------------------------------
      ** The following select block extracts the transaction data from
      ** the incoming transaction string.  Each WHEN section works as
      ** follows:
      **
      ** 1. The field BUFFER is substringed from position Bfp by the
      **    length of the transaction format definition file, and the
      **    result placed in field TRANS. (Bfp = length of header info
      **    plus 1; the length of the format definition is determined in
      **    *inzsr)
      **
      ** 2. Bfp is incremented by the length of the format definition
      **
      ** 3. The field BUFFER is substringed from the new value of Bfp
      **    by the length of the receive settlement instructions format
      **    definition file, and the result placed in RecSttmt.
      **
      ** 4. Bfp is incremented by the length of the receive
      **    settlements format definition.
      **
      ** 5. Point 3 is repeated for pay settlement instructions, and
      **    the result placed in PaySttmt.
      **
      ** 6. Bfp is incremeted by the length of the pay settlement
      **    instructions.
      **
      ** 7. The field BUFFER is substringed from the new value of Bfp
      **    by the length of the relevant Extra Data file. This file will
      **    be supplied with a 50 byte core field. This is a free format
      **    narrative text field for transferring instructions to the back
      **    office.
      **    Custom data coming from the front office will be added to this
      **    file.
      **
      ** The above applies for most transaction types; FRAs also
      ** extract the FRA settlement instructions, and FF includes
      ** broker and customer settlement instructions in the transaction
      ** structure, and does not have pay or receive settlements.
      ** Other variations may occur in the future, but the same
      ** principles will be followed.
      **--------------------------------------------------------------------------------------------
 
     C                   SELECT
 
      * FT Outgoing Payment
 
     C     TYPE          WHENEQ    'FTOPAY'
 
     C     OPY1Ln        SUBST     BUFFER:Bfp    TRANS1FT
     C                   ADD       OPY1Ln        Bfp
     C     OPY2Ln        SUBST     BUFFER:Bfp    TRANS1A
     C                   ADD       OPY2Ln        Bfp
     C     OPY3Ln        SUBST     BUFFER:Bfp    TRANS2
     C                   ADD       OPY3Ln        Bfp
     C     OPY4Ln        SUBST     BUFFER:Bfp    TRANS3
     C                   ADD       OPY4Ln        Bfp
     C     OPY5Ln        SUBST     BUFFER:Bfp    TRANS4
     C                   ADD       OPY5Ln        Bfp
     C     OPY6Ln        SUBST     BUFFER:Bfp    TRANS5
     C                   ADD       OPY6Ln        Bfp
     C     OPY7Ln        SUBST     BUFFER:Bfp    TRANS6FT
     C                   ADD       OPY7Ln        Bfp
     C     OPY8Ln        SUBST     BUFFER:Bfp    TRANS7
     C                   ADD       OPY8Ln        Bfp
     C     OPYALn        SUBST     BUFFER:Bfp    TRANS9A                                      CFT039
     C                   ADD       OPYALn        Bfp                                          CFT039
     C     OPYCLn        SUBST     BUFFER:Bfp    TRANS9B                                      CFT039
     C                   ADD       OPYCLn        Bfp                                          CFT039
     C     OPY9Ln        SUBST     BUFFER:Bfp    TRANS9                                       CFT039
     C                   ADD       OPY9Ln        Bfp                                          CFT039
     C     OPY10Ln       SUBST     BUFFER:Bfp    TRANS10                                      CFT039
     C                   ADD       OPY10Ln       Bfp                                          CFT039
     C     OPY11Ln       SUBST     BUFFER:Bfp    TRANS11                                      CFT039
     C                   ADD       OPY11Ln       Bfp                                          CFT039
     C     FTORLn        SUBST     BUFFER:Bfp    RegData
     C                   ADD       FTORLn        Bfp
     C     OPEXLn        SUBST     BUFFER:Bfp    ExtData
 
     C/COPY WNCPYSRC,APPARSMMC1
      *
      ** Any unrecognised message types are written to the error file
      *
     C                   OTHER
     C                   EVAL      Bypass = 'Y'
     C                   ENDSL
 
 
     C                   ENDSR
      /EJECT
      ****************************************************************
      *                                                              *
      *  Get Record Lengths of Transaction Data Blocks               *
      *                                                              *
      ****************************************************************
     C     GETRCDLN      BEGSR
 
     C                   CALLB     'UTGETRCDLN'
 
      ** Return code
     C                   PARM                    ReturnCode
      ** Record length
     C                   PARM      *ZERO         RecordLen         5 0
 
      ** File name
     C                   PARM                    FileName         10
      ** File library
     C                   PARM      '*LIBL     '  FileLib          10
 
      ** Clear the file name field to prevent it getting corrupted by
      ** later MOVELs.
     C                   CLEAR                   FileName
 
     C                   ENDSR
      /EJECT
      ****************************************************************
      *                                                              *
      *  Initialisation                                              *
      *                                                              *
      ****************************************************************
     C     *INZSR        BEGSR
 
     C     *entry        PLIST
     C                   PARM                    BUFFER
     C                   PARM                    TRANS1FT
     C                   PARM                    TRANS1A
     C                   PARM                    TRANS2
     C                   PARM                    TRANS3
     C                   PARM                    TRANS4
     C                   PARM                    TRANS5
     C                   PARM                    TRANS6FT
     C                   PARM                    TRANS7
     C                   PARM                    TRANS8
     C                   PARM                    TRANS9
     C                   PARM                    Trans9A                                      CFT039
     C                   PARM                    Trans9B                                      CFT039
     C                   PARM                    Trans10                                      CFT039
     C                   PARM                    Trans11                                      CFT039
     C                   PARM                    PaySttmt
     C                   PARM                    RecSttmt
     C                   PARM                    FRASttmt
     C                   PARM                    PayStmtV
     C                   PARM                    RecStmtV
     C                   PARM                    PayStmtM
     C                   PARM                    RecStmtM
     C                   PARM                    InfData
     C                   PARM                    RegData
     C                   PARM                    ExtData
     C                   PARM                    OthDData
     C                   PARM                    Bypass            1
 
      ** Set up the procedure/module/program names
     C                   EVAL      #ProcPgm  = PSProcPgm
     C                   EVAL      #ProcMod  = PSProcMod
     C                   EVAL      #ProcName = PSProcName
 
      ** Determine API Header record lengths
 
     C                   MOVEL     'APHEADPD'    FileName
     C                   EXSR      GETRCDLN
     C                   Z-ADD     RecordLen     HEADLn            4 0
 
      ** Determine transaction data record lengths
 
      ** FT Outgoing Payment : First, Second, Third and Fourth Details
      **                     : Fifth, Sixth, Seventh and Eighth
 
     C                   MOVEL     'FTOPY1PD'    FileName
     C                   EXSR      GETRCDLN
     C                   Z-ADD     RecordLen     OPY1Ln            4 0
     C                   MOVEL     'FTOPY1APD'   FileName
     C                   EXSR      GETRCDLN
     C                   Z-ADD     RecordLen     OPY2Ln            4 0
     C                   MOVEL     'FTOPY2PD'    FileName
     C                   EXSR      GETRCDLN
     C                   Z-ADD     RecordLen     OPY3Ln            4 0
     C                   MOVEL     'FTOPY3PD'    FileName
     C                   EXSR      GETRCDLN
     C                   Z-ADD     RecordLen     OPY4Ln            4 0
     C                   MOVEL     'FTOPY4PD'    FileName
     C                   EXSR      GETRCDLN
     C                   Z-ADD     RecordLen     OPY5Ln            4 0
     C                   MOVEL     'FTOPY5PD'    FileName
     C                   EXSR      GETRCDLN
     C                   Z-ADD     RecordLen     OPY6Ln            4 0
     C                   MOVEL     'FTOPY6PD'    FileName
     C                   EXSR      GETRCDLN
     C                   Z-ADD     RecordLen     OPY7Ln            4 0
     C                   MOVEL     'FTOPY7PD'    FileName
     C                   EXSR      GETRCDLN
     C                   Z-ADD     RecordLen     OPY8Ln            4 0
     C                   MOVEL     'FTOPYAPD'    FileName                                     CFT039
     C                   EXSR      GETRCDLN                                                   CFT039
     C                   Z-ADD     RecordLen     OPYALn                                       CFT039
     C                   MOVEL     'FTOPYCPD'    FileName                                     CFT039
     C                   EXSR      GETRCDLN                                                   CFT039
     C                   Z-ADD     RecordLen     OPYCLn                                       CFT039
     C                   MOVEL     'FTOPY7APD'   FileName                                     CFT039
     C                   EXSR      GETRCDLN                                                   CFT039
     C                   Z-ADD     RecordLen     OPY9Ln                                       CFT039
     C                   MOVEL     'FTOPY7BPD'   FileName                                     CFT039
     C                   EXSR      GETRCDLN                                                   CFT039
     C                   Z-ADD     RecordLen     OPY10Ln                                      CFT039
     C                   MOVEL     'FTOPIFPD'    FileName                                     CFT039
     C                   EXSR      GETRCDLN                                                   CFT039
     C                   Z-ADD     RecordLen     OPY11Ln                                      CFT039
 
      ** FT Outgoing Payment Extra Data file (50 byte narrative text
      ** plus any custom info)
 
     C                   MOVEL     'FTOPEXPD'    FileName
     C                   EXSR      GETRCDLN
     C                   Z-ADD     RecordLen     OPEXLn            4 0
      *
 
     C                   MOVEL (P) 'FTOPRXPD'    FileName
     C                   EXSR      GETRCDLN
     C                   Z-ADD     RecordLen     FTORLn            4 0
 
 
     C/COPY WNCPYSRC,APPARSMMC2
 
     C                   ENDSR
      /EJECT
      ****************************************************************
      **------------------------------------------------------------------------
      ** The following /COPY contains the standard program status
      ** subroutine, including a bound call to the DBERRCTL module.
     C/COPY ZACPYSRC,PSSR_ILE
      **------------------------------------------------------------------------
      ****************************************************************
      /EJECT
      ****************************************************************
**  CPY@
(c) Finastra International Limited 2007
