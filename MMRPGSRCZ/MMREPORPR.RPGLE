     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas MM Invalid repos repair')                        *
      *****************************************************************
      *                                                               *
      *  Midas - Money Market Dealing Module                          *
      *                                                               *
      *  MMREPORPR - Invalid Repos Repair                             *
      *                                                               *
      *  Function:  This function allows invalid loans/deposits to be *
      *             'repaired' and applied to the Midas database.     *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD031031           Date 24Feb15               *
      *  Prev Amend No. MD054028           Date 05Sep19               *
      *                 CER050             Date 16Jun19               *
      *                 MD046248           Date 27Oct17               *
      *                 AR701789           Date 26Sep16               *
      *                 MD036070           Date 19Oct15               *
      *                 CGL165             Date 23Feb15               *
      *                 CDL096             Date 22Sep14               *
      *                 CDL094             Date 11Jun14               *
      *                 CSD095             Date 08Apr14               *
      *                 CSF011A            Date 28Nov11               *
      *                 CRE073             Date 06Dec10               *
      *                 CSW210             Date 04May10               *
      *                 CER059             Date 19Jul10               *
      *                 CER020             Date 19May08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      *                 244860             Date 15Feb07               *
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 256564             Date 17Sep08               *
      *                 248773             Date 28Jun07               *
      *                 247888             Date 18May07               *
      *                 247785             Date 15May07               *
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 240659             Date 21Aug06               *
      *                 CDL049             Date 11Jul06               *
      *                 CSD027             Date 09Dec05               *
      *                 CAP087             Date 22Aug05               *
      *                 233352             Date 06May05               *
      *                 CLE031             Date 26Apr05               *
      *                 CDL038             Date 10May05               *
      *                 CMM105             Date 22Jun04               *
      *                 BUG2876            Date 28May04               *
      *                 BUG2804            Date 20May04               *
      *                 CGL014             Date 20Oct03               *
      *                 CDL020             Date 03Feb04               *
      *                 CDL019             Date 03Feb04               *
      *                 CDL018             Date 03Feb04               *
      *                 CDL017             Date 03Feb04               *
      *                 CDL016             Date 03Feb04               *
      *                 CGL029             Date 01Sep03               *
      *                 222727             Date 05Nov03               *
      *                 222373             Date 24Oct03               *
      *                 CAS005             Date 16Dec02               *
      *                 216200             Date 24Mar03               *
      *                 CAS004             Date 26Jun02               *
      * Midas Release 4.01 -------------------------------------------*
      *                 CAS001             Date 23May02               *
      *                 CAP067  *CREATE    Date 24Sep01               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD031031 - F1DLNO missing in DLDLDnQD file for LDNI, NASP,   *
      *             NASS, FRA, CIRS and SIRS. Write to extension file *
      *             whether CLE025 is *ON or *OFF.                    *
      *  MD054028 - Encountered issues in MQ Testing due to XML not   *
      *             being updated                                     *
      *  CER050 - Annualised Percentage Rate (Recompile)              *
      *  MD046248 - Finastra Rebranding                               *
      *  AR701789 - Unable to reject a deal amendment. Add a new      *
      *             parameter to indicate reject transaction.         *
      *             Applied for MD041482                              *
      *  MD036070 - No way to go back to main deal details screen     *
      *             after reaching settlement screen.  Introduce new  *
      *             function key F11.                                 *
      *  CGL165 - Dual Withholding Tax (Recompile)                    *
      *  CDL096 - Business Day Conventions on MM Deals                *
      *           (Recompile)                                         *
      *  CDL094 - Enhance Receive Settlement Instructions             *
      *           (Recompile)                                         *
      *  CSD095 - Allow Deal Sub-Type and Branch for MM and FX SSIs   *
      *  CSF011A - CCR015: Display Order in Confirmation Pages        *
      *  CRE073 - Interest Rate Rounding (Recompile)                  *
      *  CSW210 - SWIFT 2010 Changes (Recompile)                      *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER020 - Enhanced Rollover Window: Upgrade FGE089 to         *
      *           Midas Plus (Recompile)                              *
      *  244860 - ERZ135 changes missing.                             *
      *  256564 - Recompile due to PF changes done by fix 256330      *
      *  248773 - Decimal data error when Repo is repaired. Recompile.*
      *  247888 - Missing record in CLE025 files.                     *
      *  247785 - Recompile on MMTRPLNPD and MMTRPDMPD.               *
      *           Review Pay/Receive Settlement data structures.      *
      *  240659 - Cannot repair DELETE action.                        *
      *  CDL049 - Addition of a Reference Rate field (recompile)      *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CAP087 - Depot Movement API - Java Wrapper in Midasplus.     *
      *           Change due to additional parameter added to         *
      *           call MMRPDLUPD.                                     *
      *  233352 - Problem in REPO API (Recompile)                     *
      *  CLE031 - Lending Enhancements - Settlement Currency Recompile*
      *  CDL038 - Extended Deal Sub Type (Recompile)                  *
      *  CMM105 - Core changes for GBO005                             *
      *         - Fixed Deposits Held Under Lien                      *
      *         - Upgrade to Midasplus                                *
      *           Core hooks added:MMREPORD01,MMREPORC01,MMREPORC02,  *
      *                            MMREPORC03                         *
      *  BUG2876- Parameter mismatch in MMLDNIDSP caused by CDL016    *
      *  BUG2804- Parameter mismatch in MMLDNIRTV caused by CDL016    *
      *  CGL014 - Collaterals Processing (Recompile)                  *
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
      *  CAS005 - Enhancements to CAS001, CAS002 and CAS004           *
      *           (Recompile)                                         *
      *  216200 - Variable PAVAIL not defined during compilation      *
      *  CAS004 - Hedge Accounting Phase A                            *
      *  CAS001 - Net Present Value (NPV) Accounting (Recompile)      *
      *  CAP067 - Repurchase Agreements API.                          *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
     FZATRNERRL0IF   E           K DISK    INFSR(*PSSR)
 
     FMMIRPLDL2 IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(MMIRPLDD0 : MMIRPLDX0)
     F                                     PREFIX(DD:2)
 
     FAPIDSETL0 IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(APIDSETD0:APIDSETX0)
     FAPIDSETL1 UF   E           K DISK    INFSR(*PSSR)
     F                                     COMMIT
 
     FZAFLDNPD  IT   F   15        DISK    INFSR(*pssr)
 
      ** FX/MM/FRA/IRS Extension files                                                        247888
     FDLDEALL5  UF A E           K DISK    PREFIX(DX_)                                        247888
     F                                     INFSR(*pssr)                                       247888
     F                                     COMMIT                                             247888
                                                                                              247888
      * Hook to enable non-core files to be included
      */C*PY*WNCPYSRC,MMLDNIR009***************************************                       216200
      /COPY WNCPYSRC,MMREPOR011                                                               216200
 
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
 
     D ##CN1           S              1    DIM(81) CTDATA PERRCD(81)
     D ##CT1           S              1    DIM(81) CTDATA PERRCD(81)
     D ##OX1           S              1    DIM(78) CTDATA PERRCD(78)
     D ##OX2           S              1    DIM(78) CTDATA PERRCD(78)
     D ##OX3           S              1    DIM(68) CTDATA PERRCD(68)
     D ##OX4           S              1    DIM(68) CTDATA PERRCD(68)
     D ##OX5           S              1    DIM(68) CTDATA PERRCD(68)
     D ##OX6           S              1    DIM(68) CTDATA PERRCD(68)
     D ##OX7           S              1    DIM(68) CTDATA PERRCD(68)
     D ##OX8           S              1    DIM(71) CTDATA PERRCD(71)
     D ##OX9           S              1    DIM(71) CTDATA PERRCD(71)
 
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
     D @EI             S              1    DIM(60)
 
 
     D CrDlFilFmt    E DS                  EXTNAME(MMDELDPP)
      * Current Deal in File Format
 
     D CrDlScnFmt    E DS                  EXTNAME(MMLDNIPD)
      * (Current) Deal in Screen Format
     D                                     PREFIX(@)
 
     D NwDlFilFmt    E DS                  EXTNAME(MMVLDNIPD)
      * New Deal in File Format
     D QQDOR1        E                     EXTFLD(QQDORI)                                     CGL029
     D QQMOR1        E                     EXTFLD(QQMORI)                                     CGL029
     D QQDOP1        E                     EXTFLD(QQDOPI)                                     CGL029
     D QQMOP1        E                     EXTFLD(QQMOPI)                                     CGL029
     D QQRON1        E                     EXTFLD(QQRONS)                                     CGL029
     D QQPON1        E                     EXTFLD(QQPONS)                                     CGL029
     D QQINS1        E                     EXTFLD(QQINSA)                                     CGL029
     D**IKREC**              456    524                                                       CGL029
     D**IKPAY**              525   1083                                                       CGL029
     D  IKREC                470    524                                                       CGL029
     D  IKPAY                539   1083                                                       CGL029
     D**IKRECEx*************1741   1758                                                 CGL029247785
     D  IKRECEx             1756   1773                                                       247785
     D**IKPAYEx*************1759   1776                                                 CGL029247785
     D  IKPAYEx             1774   1791                                                       247785
 
     D NwDlScnFmt    E DS                  EXTNAME(MMLDNIPD)
      * New Deal in Screen Format
 
     D MMELDNI       E DS                  EXTNAME(MMELDNIPD)
      * Error indicators
 
     D MMIRPTR       E DS                  EXTNAME(MMIRPTRPD)
      * Error indicators
 
     D ##RECF        E DS                  EXTNAME(SDESFRPD)
      ** FILE RECEIVE INSTRUCTIONS
     D**FLREC**                1     69                                                       CGL029
     D  FLREC                 21     75                                                       CGL029
 
     D ##PAYF        E DS                  EXTNAME(SDESFPPD)
      *** FILE PAYMENT INSTRUCTIONS
     D**FLPAY**                1    559                                                       CGL029
     D  FLPAY                 21    565                                                       CGL029
 
     D ##FRIF        E DS                  EXTNAME(SDESFFPD)
      ** FILE FRA/IRS INSTRUCTIONS
 
     D ##RECS        E DS                  EXTNAME(SDESSRPD)
      ** SCREEN RECEIVE INSTRUCTIONS
 
     D ##PAYS        E DS                  EXTNAME(SDESSPPD)
      ** SCREEN PAYMENT INSTRUCTIONS
 
     D ##FRIS        E DS                  EXTNAME(SDESSFPD)
      ** SCREEN FRA/IRS INSTRUCTIONS
 
     D**  Data structure of Temporary Depot Movement Extension File
     D SEDX1         E DS                  EXTNAME(DPTMVDY1) PREFIX(Y)
 
     D**  Data structure of Temporary Depot Movement Extension File
     D SEDX2         E DS                  EXTNAME(DPTMVDY2) PREFIX(Y)
 
     D**  Data structure of Temporary Repo Loan/Deposits file
     D MMTRPLN       E DS                  EXTNAME(MMTRPLNPD) PREFIX(T1)
 
     D**  Data structure of Temporary Repo Depot Movements file
     D MMTRPDM       E DS                  EXTNAME(MMTRPDMPD) PREFIX(T2)
 
     D**  Data structure of Depot Movement File                                               CAP087
     D DPTXX         E DS                  EXTNAME(DPTMVDL1) PREFIX(D)                        CAP087
                                                                                              CAP087
     D @SETIN          DS
      ** Receive / Pay Settlement Currency, Method & Nostro
     D  @@RSCY                 1      3
     D  @@RSTM                 4      5  0
     D**@@RONS*                6     17                                                       CGL029
     D**@@PSCY*               18     20                                                       CGL029
     D**@@PSTM*               21     22  0                                                    CGL029
     D**@@PONS*               23     34                                                       CGL029
     D  @@RONS                 6     23                                                       CGL029
     D  @@PSCY                24     26                                                       CGL029
     D  @@PSTM                27     28  0                                                    CGL029
     D  @@PONS                29     46                                                       CGL029
 
     D                 DS
      **  Data structure for date in, to change format.
     D  DateIn                 1      8  0
     D  @@YY                   1      4  0
     D  @@MM                   5      6  0
     D  @@DD                   7      8  0
 
     D @MORPI          DS
      ** Midas Our Receive / Pay  Instructions (for Settl Meth = 04 )
     D**@@MORI*                1     12                                                       CGL029
     D**@@MOPI*               13     24                                                       CGL029
     D  @@MORI                 1     18                                                       CGL029
     D  @@MOPI                19     36                                                       CGL029
 
 
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** EXTERNAL DS FOR BANK DETAILS
 
     D SDMMOD        E DS                  EXTNAME(SDMMODPD)
      ** MIDAS MODULES DETAILS ACCESSED VIA ACCESS PROGRAM
 
     D SCSARD        E DS                  EXTNAME(SCSARDPD)
      ** EXTERNAL DS FOR SAR DETAILS
 
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** FIRST DS FOR ACCESS PROGRAMS, SHORT DATA STRUCTURE
 
     D InfData       E DS                  EXTNAME(MMLDIFPD)
     D                                     PREFIX(IF_)
      * MM (LDNI) Extra Data - File (D/B) format
 
     D ExtData       E DS                  EXTNAME(MMLDEXPD)
      * MM (LDNI) Extra Data - File (D/B) format
 
     D/COPY QWINDSRC,MMLDNISDTA
 
     D/COPY ZACPYSRC,APICTLARR
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      **   Timestamp selected
     D @TMESTPSEL      S             26Z
 
      **   Old Maturity Date
     D OLD_MATD        S              5P 0
 
      ** Response Mode, passed as a constant parameter to the VAL module
      ** This is always 'S' for Synchronous
     D RespMode        S              1A   INZ('S')
 
      ** -------------------------------------------------------------------
      ** Fields for getting the starting field number from file (parameters
      ** to ZAGETFLDNO, plus the offset to the requested field).
     D Format          S             10A   INZ('MMLDNIPD')
 
     D Field           S             10A   INZ('DDACTN')
 
     D FieldNo         S              5P 0
 
     D FldOffset       S              5P 0
 
      ** End of fields for getting starting field number
      ** -------------------------------------------------------------------
 
      ** Message type field for chaining to APIDSETPD; defined in terms
      ** of the file field when the file field was changed.
     D @MSGTYPE        S                   LIKE(DDMSGTYPE)
 
     D** Mode used when updating Temporary Loan/Deposit file
     D RPLNMode        S              1A
 
     D** Mode used when updating Temporary Depot Movements file
     D RPDMMode        S              1A
 
     D** Associated Front Office Transaction ID Number
     D @@AFRT          S             20A
 
     D RepoFlag        S              1A
                                                                                              CAP087
      ** Flag to indicate caller of MMRPDLUPD                                                 CAP087
      ** 'Y' - called from Securities module                                                  CAP087
      ** 'N' - called from Money Markey module                                                CAP087
     D DepotPos        S              1A                                                      CAP087
                                                                                              CAP087
      *
      ** Backup arrays for error messages on Depot screen
     D GFldNameAr      S                   Dim(ArrayMax)
     D                                     Like (FldNameArr)
     D GMsgIdAr        S                   Dim(ArrayMax)
     D                                     Like (MsgIdArr)
                                                                                              CSD095
     D BlankSTYP       S              2A                                                      CSD095
     D BlankBRCA       S              3A                                                      CSD095
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
 
      ** +----------------------------------------+
      ** ¦ Hook for non-core D-specs (all types)  ¦
      ** ¦ also any I-specs (if necessary)        ¦
      ** ¦ =====================================  ¦
      ** +----------------------------------------+
     D/COPY WNCPYSRC,MMREPORD01
                                                                                              CGL029
     IMMIRPLDX0                                                                               CGL029
     I              QQINSA                      QQINS2                                        CGL029
                                                                                              CGL029
      /COPY WNCPYSRC,MMREPOR010
 
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
 
      /COPY WNCPYSRC,MMREPOR001
 
 
      * DO SCREEN: BROWSE INVALID DEALS
     C     @SCRN         IFEQ      'B'
     C                   EXSR      SCRN@B
     C                   ENDIF
 
 
      /COPY WNCPYSRC,MMREPOR002
 
      * READ NEXT BROWSE SUBFILE RECORD
     C     @SCRN         IFEQ      'R'
     C                   EXSR      RDNBRW
     C                   ENDIF
 
 
      /COPY WNCPYSRC,MMREPOR003
 
      * DO WHILE SCREEN: MAIN DETAILS
     C     @SCRN         DOWEQ     'M'
     C                   EXSR      SCRN@M
     C                   ENDDO
 
 
      /COPY WNCPYSRC,MMREPOR004
 
      * SCREEN: WINDOW
     C     @SCRN         IFEQ      'W'
     C                   EXSR      WINDOW
     C                   ENDIF
 
 
      /COPY WNCPYSRC,MMREPOR005
 
      * DO WHILE SCREEN: SETTLEMENT DETAILS
     C     @SCRN         DOWEQ     'S'
     C                   EXSR      SCRN@S
     C                   ENDDO
 
 
      /COPY WNCPYSRC,MMREPOR006
 
      * INSERT LOAN/DEPOSIT IN TEMP FILE
     C     @SCRN         IFEQ      '1'
     C                   EXSR      TLDNI
     C                   ENDIF
 
 
      /COPY WNCPYSRC,MMREPOR007
 
      * PROCESS DEPOT MOVEMENT
     C     @SCRN         IFEQ      'D'
     C                   EXSR      PDPMT
     C                   ENDIF
 
 
      /COPY WNCPYSRC,MMREPOR008
 
      * DO FILE UPDATES TO THE PERMANENT FILES
     C     @SCRN         IFEQ      'U'
     C                   EXSR      UPDATS
     C                   ENDIF
 
 
      /COPY WNCPYSRC,MMREPOR009
 
      * TERMINATE PROGRAM
     C     @SCRN         IFEQ      'T'
     C                   EXSR      TERM
     C                   ENDIF
 
      * Hook to enable non-core subroutines to be included
      /COPY WNCPYSRC,MMREPOR010
 
      /EJECT
      *****************************************************************
      * SCRN@B - BROWSE INVALID DEALS
      *****************************************************************
     C     SCRN@B        BEGSR
      *
      * RESET READ NEXT BROWSE SUBFILE RECORD
      *
     C                   MOVEL     *BLANK        @RDNB             1
      *
      * BUILD BROWSE SUBFILE
      *
     C                   CALLB     'MMREPORPB'
      *
      * INPUT PARAMETERS
      *
      * RETURN CODE
     C                   PARM      *BLANK        RetCodeOut
      *
      * BUILD SUB-FILE
     C                   PARM      'Y'           @BDSFL            1
      *
      * READ SUBFILE RECORD
     C                   PARM      *BLANK        @RDSFL            1
      *
      * Error in update of previous deal
     C                   PARM                    @ERRUP            1
      *
      * OUTPUT PARAMETERS
      *
      ** Successfully Inserted Deal Number
      *
     C                   PARM                    @SIDN             6
      *
      * ERROR MESSAGE
     C                   PARM      *BLANK        @ERRMS            7
      *
      * OPTION SELECTED
     C                   PARM                    @OPSEL            1
      *
      * ACTION SELECTED
     C                   PARM                    @ACSEL            1
      *
      * FO TRANSACTION ID SELECTED
     C                   PARM                    @FOTRANSEL       20
      *
      * FO ASSOCIATED TRANSACTION ID SELECTED
     C                   PARM                    @FOASOCSEL       20
      *
      * TIMESTAMP OF TRANSACTION SELECTED
     C                   PARM                    @TMESTPSEL
      *
      * COMMAND KEYS
     C                   PARM      '0'           @INKC             1
     C                   PARM      '0'           @INKL             1
      *
      *
      * If error set on external switches
      *
     C     @ERRMS        IFNE      *BLANK
     C                   MOVE      '1'           *INU6
     C                   ENDIF
      *
      * If CK/3 or CK/12 taken in browse, or error message
      * End program
      *
     C     @INKC         IFEQ      '1'
     C     @INKL         OREQ      '1'
     C     @ERRMS        ORNE      *BLANK
     C                   EXSR      ENDP
     C                   GOTO      ESCRN@B
     C                   ENDIF
      *
      * Read next browse subfile record
      *
     C                   MOVE      'Y'           @RDNB
     C                   MOVE      'R'           @SCRN
      *
     C     ESCRN@B       ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * RDNBRW - READ NEXT BROWSE SUBFILE RECORD
      *****************************************************************
     C     RDNBRW        BEGSR
      *
      * READ NEXT SUBFILE RECORD
      *
     C                   CALLB     'MMREPORPB'
      *
      * INPUT PARAMETERS
      *
      * RETURN CODE
     C                   PARM      *BLANK        RetCodeOut
      *
      * BUILD SUB-FILE
     C                   PARM      *BLANK        @BDSFL            1
      *
      * READ SUBFILE RECORD
     C                   PARM      'Y'           @RDSFL            1
      *
      * Error in update of previous deal
     C                   PARM                    @ERRUP            1
      *
      * OUTPUT PARAMETERS
      *
      ** Successfully Inserted Deal Number
      *
     C                   PARM                    @SIDN             6
      *
      * ERROR MESSAGE
     C                   PARM      *BLANK        @ERRMS            7
      *
      * OPTION SELECTED
     C                   PARM      *BLANK        @OPSEL            1
      *
      * ACTION SELECTED
     C                   PARM      *BLANK        @ACSEL            1
      *
      * FO TRANSACTION ID SELECTED
     C                   PARM      *BLANK        @FOTRANSEL       20
      *
      * FO ASSOCIATED TRANSACTION ID SELECTED
     C                   PARM      *BLANK        @FOASOCSEL       20
      *
      * TIMESTAMP OF TRANSACTION SELECTED
     C                   PARM                    @TMESTPSEL
      *
      * COMMAND KEYS
     C                   PARM      '0'           @INKC             1
     C                   PARM      '0'           @INKL             1
      *
      * Store value of Associated FO ID
     C                   EVAL      @@AFRT = @FOASOCSEL
      *
      * If CK/3 taken within invalid transaction deletion function,
      * End program
      *
     C     @INKC         IFEQ      '1'
     C                   EXSR      ENDP
     C                   GOTO      ERDNBRW
     C                   ENDIF
      *
      * READ FROM SUBFILE IF INVALID DEAL CHOSEN
      *
     C     @OPSEL        IFNE      *BLANK
      *
      * BLANK THE MAIN DETAILS SCREEN
      *
     C                   MOVEL     *BLANK        NwDlScnFmt
     C                   MOVEL     *BLANK        DDSTS
      *
      * RESET ERRORS
      *
     C                   MOVE      *ALL'Y'       MMELDNI
     C                   MOVEL     *BLANK        FldNameArr
     C                   MOVEL     *BLANK        MsgIdArr
     C                   MOVEL     *BLANK        MsgDtaArr
     C                   MOVEL     *BLANK        WFldNamArr
     C                   MOVEL     *BLANK        WMsgIdArr
     C                   MOVEL     *BLANK        WMsgDtaArr
     C                   MOVEL     *BLANK        GFldNameAr
     C                   MOVEL     *BLANK        GMsgIdAr
      *
      * Retrieve deal details
      *
     C                   MOVEL     @ACSEL        DDACTN
     C                   MOVEL     @FOTRANSEL    FOTRID
     C                   MOVEL     @FOASOCSEL    FOASID
      *
      *
      * Make sure Invalid transaction's  details are passed to 'Retrieve'
      * module for SPF checking .
      *
     C     ZATRNKX0      CHAIN     MMIRPLDX0                          99
      *
      *
      *  If INSERT
      *Set retrieve mode to '*FRONT' (Access using Front Office ID)
      *  IF NOT Insert and Midas transaction ID is not present
      *Set retrieve mode to blank  (Access using Midas transaction ID).
      *
     C     DDACTN        IFEQ      'I'
     C                   MOVEL     '*FRONT'      @@MODE
     C                   ELSE
     C     DDDLNO        IFEQ      *BLANK
     C                   MOVEL     '*FRONT'      @@MODE
     C                   ELSE
     C                   MOVEL     '      '      @@MODE
     C                   ENDIF
     C                   ENDIF
      *
     C                   EXSR      RTVDEL
      *
      * If deal details were successfully retrieved
      * Put the deal on the main details screen
      * (If an insert is coming through there's no retrieved deal to put up)
      *
     C     HKRCID        IFNE      *BLANK
     C     DDACTN        ANDNE     'I'
     C                   EXSR      PUTD@M
     C                   ENDIF
                                                                                              240659
     C     DDACTN        IFNE      'D'                                                        240659
                                                                                              240659
      *
      * Now overwrite the fields on main details screen with those
      * on the invalid deals file
      *
      * (except for the Midas deal number and Midas assoc. deal number
      *  retrieved above using front office trans. and assoc. trans. IDs)
      *
      * Access invalid deal with timestamp and front office transaction ID.
      *
     C                   MOVEL     DDDLNO        ##DDDLNO          6
     C                   MOVEL     DDDADN        ##DDDADN          6
      *
     C     ZATRNKX0      CHAIN     MMIRPLDX0                          99
      *
     C     HKRCID        IFNE      *BLANK
     C     DDACTN        ANDNE     'I'
     C                   MOVEL     ##DDDLNO      DDDLNO
     C                   MOVEL     ##DDDADN      DDDADN
     C                   ENDIF
      *
      * Access invalid deal settlement instructions
      *
     C                   CLEAR                   ##PAYS
     C                   CLEAR                   ##RECS
     C     APDSETKX      CHAIN     APIDSETX0                          99
                                                                                              240659
     C                   ENDIF                                                                240659
      *
      * If action code, or deal number were NOT OK
      * blank out action code so that the input cannot proceed
      *
     C     OKACTN        IFEQ      'N'
     C     OKDLNO        OREQ      'N'
     C                   MOVEL     *BLANK        DDACTN
     C                   ENDIF
      *
      * Send the deals error messages to the main details screen
      *
     C                   EXSR      SNDM@M
      *
      * GO TO MAIN DETAILS SCREEN
      *
     C                   MOVE      'M'           @SCRN
      *
      * ELSE IF NO INVALID DEAL WAS READ FROM SUBFILE (@OPSEL is blank)
      *
     C                   ELSE
      *
      * GO TO BROWSE SCREEN
      *
     C                   MOVE      'B'           @SCRN
     C                   ENDIF
      *
     C     ERDNBRW       ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SNDM@M - SEND A MESSAGE TO MAIN DETAILS SCREEN
      *****************************************************************
     C     SNDM@M        BEGSR
 
     C                   Z-ADD     Idx           E                 3 0
      *
      ** If there are fundamental errors in this transaction
      ** Identify this fact.
      *
     C     OKACTN        IFEQ      'N'
     C     OKDLNO        OREQ      'N'
     C                   ADD       1             E
     C                   MOVEL     '*ANY'        FldNameArr(E)
     C                   MOVEL     'APM0110'     MsgIdArr(E)
     C                   ENDIF
      *
      ** Initialize error indicators
      *
     C                   MOVEA     MMELDNI       @EI
     C                   Z-ADD     0             G                 1 0
      *
      ** Read error messages for deal
      *
     C     ZATRNKD0      SETLL     ZATRNERRD0
     C     ZATRNKD0      READE     ZATRNERRD0                             99    *
      *
      ** Add error message to array passed to detail screen
      ** and set OK flag for field to 'N'
      *
     C     *IN99         DOWEQ     '0'
 
     C     ABFIELDNAM    LOOKUP    FieldArr                               20
 
     C                   IF        *IN20 = '0'
 
     C                   ADD       1             G
     C                   MOVEL     ABFIELDNAM    GFldNameAr(G)
     C                   MOVEL     ABMSGID       GMsgIdAr(G)
 
     C                   ELSE
 
     C                   ADD       1             E
     C                   MOVEL     ABFIELDNAM    FldNameArr(E)
     C                   MOVEL     ABMSGID       MsgIdArr(E)
     C                   Z-ADD     ABFIELDID     F                 3 0
     C                   SUB       FldOffset     F
     C     F             IFLT      1
     C     F             ORGT      60
     C                   Z-ADD     1             F
     C                   ENDIF
     C                   MOVE      'N'           @EI(F)
 
     C                   ENDIF
 
     C     ZATRNKD0      READE     ZATRNERRD0                             99    *
     C                   ENDDO
      *
     C                   MOVEA     @EI           MMELDNI
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SCRN@M - PROCESS SCREEN: MAIN DETAILS
      *****************************************************************
     C     SCRN@M        BEGSR
      *
      * Issue rollback to clear any possible updates in window function
      *
     C     BGWDPR        IFEQ      'Y'
     C                   ROLBK
     C                   ENDIF
      *
      * Enable/disable editing of detail fields on main details screen
      * if changes to the data are allowed (i.e. update of an insert/amend transation)
      *
     C     DDACTN        IFEQ      'I'
     C     @OPSEL        ANDEQ     'U'
     C     DDACTN        OREQ      'A'
     C     @OPSEL        ANDEQ     'U'
     C                   MOVEL     'Y'           @EDTFD
     C                   ELSE
     C                   MOVEL     'N'           @EDTFD
     C                   ENDIF
      *
      * (key fields = action code & deal number)
      * (detail fields = rest)
      * (Action code can only be 'I', 'A', 'D', or 'X')
      *
      * KJ = COMMAND KEY 10 = CONFIRM DELETE
      *
     C     DDACTN        IFEQ      'D'
     C     @OPSEL        ANDEQ     'U'
     C                   MOVEL     'Y'           @EINKJ
     C                   ELSE
     C                   MOVEL     'N'           @EINKJ
     C                   ENDIF
      *
      * WRITE/READ DISPLAY SCREEN
      *
     C                   CALLB     'MMLDNIDSP'
      *
      * INPUT PARAMETERS
      *
      * RETURN CODE
     C                   PARM      *BLANK        RetCodeOut
      *
      * DEAL (IN SCREEN FORMAT)
     C                   PARM                    NwDlScnFmt
      *
      * DEAL STATUS
     C                   PARM                    DDSTS            24
      *
      ** Collateral Status
     C                   PARM                    DDCSTS           10
      *
      * FIELDS IN ERROR
     C                   PARM                    MMELDNI
      *
      * ERRORS
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
      *
      * WARNINGS
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIdArr
     C                   PARM                    WMsgDtaArr
      *
      * ENABLED KEY & DETAIL FIELDS
      *
     C                   PARM      'N'           @EKYFD            1
     C                   PARM                    @EDTFD            1
      *
      * ENABLED FUNCTION KEYS
     C                   PARM      'N'           @EINKG            1
     C                   PARM      'N'           @EINKH            1
     C                   PARM                    @EINKJ            1
     C                   PARM      'N'           @EINKN            1
     C                   PARM      'N'           @EINKP            1
     C                   PARM      'N'           @EINKT            1
      *
      * SUCCESFUL INSERT DEAL
     C                   PARM                    @SIDN             6
      *
      * CALLING PGM
     C                   PARM      'MMREPORPR '  CPGM             10
      *                                                                                      BUG2876
      ** Blocked/Unblock Action                                                              BUG2876
     C                   PARM                    BUACT                                       BUG2876
      *
      * OUTPUT PARAMETERS
      *
      * FUNCTION KEYS
     C                   PARM      '0'           @INKC             1
     C                   PARM      '0'           @INKG             1
     C                   PARM      '0'           @INKH             1
     C                   PARM      '0'           @INKJ             1
     C                   PARM      '0'           @INKL             1
     C                   PARM      '0'           @INKN             1
     C                   PARM      '0'           @INKP             1
     C                   PARM      '0'           @INKT             1
     C                   PARM      'N'           WriteOnly         1
     C                   PARM      'Y'           RepoFlag          1
     C/COPY WNCPYSRC,MMLDNIXC05                                                               244860
      *
      * CK/3 - END PROGRAM
      *
     C     @INKC         CASEQ     '1'           ENDP
      *
      * CK/12 - CANCEL ON MAIN DETAILS SCREEN
      *
     C     @INKL         CASEQ     '1'           CANC@M
      *
      * VALIDATE INPUT TO MAIN DETAILS SCREEN
      *
     C                   CAS                     VAL@M
     C                   ENDCS
      *
     C                   ENDSR
      /EJECT
      *****************************************************************
      * VAL@M  - VALIDATE INPUT TO MAIN DETAILS SCREEN
      *****************************************************************
     C     VAL@M         BEGSR
      *
     C                   IF        @OPSEL = 'U'
 
     C     'APM0110'     LOOKUP    MsgIdArr                               20
 
     C                   IF        *IN20 = '0'
     C                   EXSR      VALM
     C                   ENDIF
 
     C                   ELSE
     C                   MOVEL     'D'           @SCRN
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * VALM  - PERFORM VALIDATION TO INPUT TO MAIN DETAILS SCREEN
      *****************************************************************
     C     VALM          BEGSR
      *
      * Retrieve deal details
      *
     C                   MOVEL     '      '      @@MODE
     C                   EXSR      RTVDEL
      *
      * If action code, or deal number are NOT OK
      * Re-output screen with error messages on it
      *
     C     OKACTN        IFEQ      'N'
     C     OKDLNO        OREQ      'N'
     C                   GOTO      EVAL@M
     C                   ENDIF
      *
      * RESET ERRORS
      *
     C                   MOVE      *ALL'Y'       MMELDNI
     C                   MOVEL     *BLANK        FldNameArr
     C                   MOVEL     *BLANK        MsgIdArr
     C                   MOVEL     *BLANK        MsgDtaArr
     C                   MOVEL     *BLANK        WFldNamArr
     C                   MOVEL     *BLANK        WMsgIdArr
     C                   MOVEL     *BLANK        WMsgDtaArr
      *
      *----------------------------------------------------------------
      * IF DELETE
      *
     C     DDACTN        IFEQ      'D'
      *
      * Update Deal in File Format
      *
     C                   MOVEL     CrDlFilFmt    NwDlFilFmt
      *
      * IF CK/10 TAKEN, GO ONTO UPDATES
      *
     C     @INKJ         IFEQ      '1'
 
     C                   MOVEL     'U'           @SCRN
      *
      **Delete*depot*movements*************************************************************** 240659
     C**********         CALLB     'MMRPDMRPR'                                                240659
     C**********         PARM      *BLANKS       RCODE             7                          240659
     C**********         PARM                    @OPSEL                                       240659
     C**********         PARM                    NwDlScnFmt                                   240659
     C**********         PARM                    @@AFRT                                       240659
      **********                                                                              240659
      **ERRORS******************************************************************************* 240659
     C**********         PARM      *BLANKS       GFldNameAr                                   240659
     C**********         PARM      *BLANKS       GMsgIdAr                                     240659
      *                                                                                       240659
      ** Delete depot movements.                                                              240659
      *                                                                                       240659
     C                   CALLB     'MMRPDLSFL'                                                240659
     C                   PARM                    NwDlScnFmt                                   240659
     C                   PARM      *BLANKS       OldDlNo           6                          240659
     C                   PARM      *BLANKS       ReturnCode                                   240659
 
     C                   ENDIF
 
     C                   GOTO      EVAL@M
 
     C                   ENDIF
      *
      *----------------------------------------------------------------
      * IF AUTHORIZE
      *
     C     DDACTN        IFEQ      'X'
      *
      * Update Deal in File Format
      *
     C                   MOVEL     CrDlFilFmt    NwDlFilFmt
      *
      * If windows processing on, call window routine
      * otherwise, continue to settlements screen
      *
     C     BGWDPR        IFEQ      'Y'
     C                   MOVEL     'W'           @SCRN
     C                   ELSE
     C                   MOVEL     'S'           @SCRN
     C                   ENDIF
      *
     C                   GOTO      EVAL@M
     C                   ENDIF
      *
      *----------------------------------------------------------------
      * IF INSERT OR AMEND
      *
     C     DDACTN        IFEQ      'I'
     C     DDACTN        OREQ      'A'
      *
      * Prior to validation, initialize error indicators as 'OK'
      * and clear Deal in File Format
      *
     C                   MOVE      *ALL'Y'       MMELDNI
     C                   CLEAR                   NwDlFilFmt
     C                   Z-ADD     *ZERO         Idx               3 0
     C                   Z-ADD     *ZERO         WIdx              3 0
     C                   Z-ADD     *ZERO         IKRSTM
     C**********         Z-ADD     *ZERO         IKROBN                                       CSD027
     C**********         Z-ADD     *ZERO         IKROCN                                       CSD027
     C                   EVAL      IKROBN = *BLANKS                                           CSD027
     C                   EVAL      IKROCN = *BLANKS                                           CSD027
     C                   Z-ADD     *ZERO         IKPSTM
     C**********         Z-ADD     *ZERO         IKPOBN                                       CSD027
     C**********         Z-ADD     *ZERO         IKPOCN                                       CSD027
     C                   EVAL      IKPOBN = *BLANKS                                           CSD027
     C                   EVAL      IKPOCN = *BLANKS                                           CSD027
      *
      * IF AMEND
      *
     C     DDACTN        IFEQ      'A'
      *
      * Update Deal in File Format
      * (then store IKMATD, the maturity date in NwDlFilFmt, into 'Old Mat. Date field')
      *
     C                   MOVEL     CrDlFilFmt    NwDlFilFmt
     C                   Z-ADD     IKMATD        OLD_MATD
      *
      * Validate whether non-amenable fields have been changed
      *
     C                   CALLB     'MMLDNIAMD'
      *
      * INPUTS
      *
      * Return Code
     C                   PARM      *BLANK        RetCodeOut
      *
      * New Deal in Screen Format
     C                   PARM                    NwDlScnFmt
      *
      * Current Deal in Screen Format
     C                   PARM                    CrDlScnFmt
      *
      * Current Deal in file format
     C                   PARM                    CrDlFilFmt
      *
      * OUTPUTS
      *
      * Field OK flags (DS) from/to caller
     C                   PARM                    MMELDNI
      *
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
      *
      * Array index (3P0) from/to caller
     C                   PARM                    Idx
      *
      * Amendments OK
     C                   PARM                    @@AMOK            1
      *
      * Reset of Fields in Error Required (Y/N)
     C                   PARM      'Y'           @@RSTE            1
      *
     C                   ENDIF
 
 
      * Validate deal details
      *
     C                   CALLB     'MMLDNIVAL'
     C                   PARM                    RespMode
     C                   PARM                    NwDlScnFmt
     C                   PARM                    ACTRJ                                      AR701789
     C                   PARM                    InfData
     C                   PARM      IKSTCY        @@RSCY
     C                   PARM      IKRSTM        @@RSTM
     C                   PARM      IKRONS        @@RONS
     C                   PARM      IKSTCY        @@PSCY
     C                   PARM      IKPSTM        @@PSTM
     C                   PARM      IKPONS        @@PONS
     C                   PARM      IKFRNT        @@FRNT           20
     C                   PARM                    ExtData
     C                   PARM                    DDAPRC            1                        MD054028
     C                   PARM                    DDAPRR            8                        MD054028
     C                   PARM                    MMELDNI
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
     C                   PARM                    Idx
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIdArr
     C                   PARM                    WMsgDtaArr
     C                   PARM                    WIdx
     C                   PARM                    NwDlFilFmt
     C                   PARM      'Y'           RepoFlag
     C/COPY WNCPYSRC,MMREPORC01
      *
      * If errors returned
      *
     C     Idx           IFNE      0
     C                   GOTO      EVAL@M
     C                   ENDIF
      *
      * Setup Breakdown fiels on the Valid file
     C     CDL007        IFEQ      'Y'
     C     DDACTN        ANDEQ     'A'
     C                   MOVEL     DDBUSR        IKBUSR
     C                   IF        IKMATD < OLD_MATD
     C                             AND DDTYPE = 'TD'
     C                             OR IKMATD < OLD_MATD
     C                             AND DDTYPE = 'TI'
     C                   EVAL      IKOMDT = OLD_MATD
     C                   EVAL      IKPRIN = *BLANKS
     C                   ENDIF
     C                   ENDIF
      *
      * Setup Automatic Authorisation flag on the Valid file
     C     CAP051        IFEQ      'Y'
     C                   EVAL      IKAUTH = DDAUTH
     C                   ENDIF
      *
      * If windows processing on, call window routine
      * otherwise, continue to settlements screen
      *
     C     BGWDPR        IFEQ      'Y'
     C                   MOVEL     'W'           @SCRN
     C                   ELSE
     C                   MOVEL     'S'           @SCRN
     C                   ENDIF
      *
     C                   ENDIF
      *----------------------------------------------------------------
     C     EVAL@M        ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * WINDOW - CALL WINDOW MANAGER
      *****************************************************************
     C     WINDOW        BEGSR
      *
      * Reset erros
      *
     C                   MOVE      *ALL'Y'       MMELDNI
     C                   MOVEL     *BLANK        FldNameArr
     C                   MOVEL     *BLANK        MsgIdArr
     C                   MOVEL     *BLANK        MsgDtaArr
     C                   MOVEL     *BLANK        WFldNamArr
     C                   MOVEL     *BLANK        WMsgIdArr
     C                   MOVEL     *BLANK        WMsgDtaArr
      *
      * Write out screen to remove error messages
      *
     C                   CALLB     'MMLDNIDSP'
      *
      * INPUT PARAMETERS
      *
      * RETURN CODE
     C                   PARM      *BLANK        RetCodeOut
      *
      * DEAL (IN SCREEN FORMAT)
     C                   PARM                    NwDlScnFmt
      *
      * DEAL STATUS
     C                   PARM                    DDSTS            24
      *
      ** Collateral Status
     C                   PARM                    DDCSTS           10
      *
      * FIELDS IN ERROR
     C                   PARM                    MMELDNI
      *
      * ERRORS
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
      *
      * WARNINGS
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIdArr
     C                   PARM                    WMsgDtaArr
      *
      * ENABLED KEY & DETAIL FIELDS
      *
     C                   PARM                    @EKYFD
     C                   PARM                    @EDTFD
      *
      * ENABLED FUNCTION KEYS
     C                   PARM                    @EINKG
     C                   PARM                    @EINKH
     C                   PARM                    @EINKJ
     C                   PARM                    @EINKN
     C                   PARM                    @EINKP
     C                   PARM      'N'           @EINKT            1
      *
      * SUCCESFUL INSERT DEAL
     C                   PARM                    @SIDN
      *
      * CALLING PGM
     C                   PARM      'MMREPORPR '  CPGM             10
      *                                                                                      BUG2876
      ** Blocked/Unblock Action                                                              BUG2876
     C                   PARM                    BUACT                                       BUG2876
      *
      * OUTPUT PARAMETERS
      *
      * FUNCTION KEYS
     C                   PARM      '0'           @INKC
     C                   PARM      '0'           @INKG
     C                   PARM      '0'           @INKH
     C                   PARM      '0'           @INKJ
     C                   PARM      '0'           @INKL
     C                   PARM      '0'           @INKN
     C                   PARM      '0'           @INKP
     C                   PARM      '0'           @INKT
     C                   PARM      'Y'           WriteOnly         1
     C                   PARM      'Y'           RepoFlag
     C/COPY WNCPYSRC,MMLDNIXC05                                                               244860
      *
      * IF DEAL NUMBER NOT DEFINED (ON INSERT),
      * GET NEXT AVAILABLE DEAL NUMBER
      *
     C     DDDLNO        IFEQ      *BLANK
     C                   CALLB     'CAGETNXTDL'
     C                   PARM      *BLANKS       RetCodeOut
     C                   PARM      *BLANKS       @@MSG1            7
     C                   PARM                    I#DDDLNO          6
     C                   PARM      *ZERO         IKDN38
      *
      * DATABASE ERROR
      *
     C     @@MSG1        IFNE      *BLANK
     C                   MOVEL     'CAGTNXDL'    DBFILE                         ************
     C                   MOVEL     '001'         DBASE                          * DBERR 001*
     C                   MOVEL     DDDLNO        DBKEY                          ************
     C                   EXSR      *PSSR
     C                   ENDIF
     C                   ENDIF
      *
     C*C*PY*QWINDSRC,MMLDNISMV1*************************************                          CAP087
     C/COPY WNCPYSRC,MMLDNISMV1                                                               CAP087
      *
     C                   CALL      'WN0010'
     C                   PARM      'MMREPORPR'   #PGM             10
     C                   PARM                    FKEY              2
     C                   PARM      DDACTN        ACTION            1
     C                   PARM                    DATA
     C                   PARM      *BLANKS       #RTRN             7
     C                   PARM                    SPAREW          256
      *
      * Process returned command keys
      *
     C     #RTRN         IFEQ      'Y2U9999'
     C                   EXSR      ENDP
     C                   ELSE
      *
      *  If Cmd12 pressed, or in enquiry, return to main details screen;
      *  otherwise, go to settlements screen
      *
     C     #RTRN         IFEQ      'USR0790'
     C     DDACTN        OREQ      'E'
     C     @RDNB         IFEQ      'Y'
     C                   EVAL      @SCRN = 'R'
     C                   ELSE
     C                   EVAL      @SCRN = 'M'
     C                   ENDIF
     C                   ELSE
     C                   EVAL      @SCRN = 'S'
     C                   ENDIF
     C                   ENDIF
      *
     C     WIND          ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * RTVDEL - RETRIEVE DEAL
      *****************************************************************
     C     RTVDEL        BEGSR
      *
      * RETRIEVE DEAL
      *
     C                   CALLB     'MMLDNIRTV'
      *
      * INPUTS
      *
      * Return code
     C                   PARM      *BLANK        RetCodeOut
      *
      * Mode = '*FRONT' (FRONT OFFICE TRANSACTION INTERFACE)
      * MODE = '      ' (NOT FRONT OFFICE TRANSACTION INTERFACE)
      *
     C                   PARM                    @@MODE            6
      *
      * Response mode
     C                   PARM      'S'           @@RSMD            1
      *
      * Action Code
     C                   PARM                    DDACTN
      *
      * Front Office Transaction ID
     C                   PARM                    FOTRID           20
      *
      * Front Office Associated Transaction Id
     C                   PARM                    FOASID           20
      *
      * (Midas) Deal Number
     C                   PARM                    DDDLNO
      * (Midas) Depot Movement Reference                                                      222373
     C                   PARM                    DDDDMR                                       222373
      *
      * (Midas) Associated Deal Number
     C                   PARM                    DDDADN
      *
      * Booking branch
     C                   PARM                    DDBRCA
      *
      * REPO Flag
     C                   PARM      'Y'           RepoFlag
      * OUTPUTS
      *
      * (Current) deal in file format
     C                   PARM                    CrDlFilFmt
      *                                                                                     AR701789
     C                   PARM                    ACTRJ             1                        AR701789
      *
      * OK - Action code
     C                   PARM      *BLANK        OKACTN
      *
      * OK - Deal Number
     C                   PARM      *BLANK        OKDLNO
      *
      * OK - Booking branch
     C                   PARM      *BLANK        OKBRCA
      ** Blocked/Unblock Action                                                              BUG2804
     C                   PARM                    BUACT             1                         BUG2804
      *
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
      *
      * Array index (3P0) from/to caller
     C                   PARM      *ZERO         Idx
                                                                                              CAS004
      ** Warning flds/message IDs/message data (arrays) from/to caller                        CAS004
                                                                                              CAS004
     C                   PARM                    WFldNamArr                                   CAS004
     C                   PARM                    WMsgIdArr                                    CAS004
     C                   PARM                    WMsgDtaArr                                   CAS004
                                                                                              CAS004
      ** Array index (3P0) from/to caller                                                     CAS004
                                                                                              CAS004
     C                   PARM                    WIdx                                         CAS004
     C/COPY WNCPYSRC,MMREPORC03
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * PUTD@M - PUT A DEAL ON THE MAIN DETAILS SCREEN
      *****************************************************************
     C     PUTD@M        BEGSR
      *
      * Call program to fill screen fields with data from MMDELDPP (ie file format)
      *
     C                   CALLB     'MMLDNICVT'
      *
      * INPUTS
      *
      * Return Code
     C                   PARM      *BLANK        RetCodeOut
      *
      * Deal in file format
     C                   PARM                    CrDlFilFmt
      *
     C                   PARM                    DDAPRC            1                        MD054028
     C                   PARM                    DDAPRR            8                        MD054028
      *                                                                                     MD054028
      * OUTPUTS
      *
      * Deal in screen format
     C                   PARM                    NwDlScnFmt
      *
      * Deal Status
     C                   PARM                    DDSTS            24
      *
      ** Collateral Status
     C                   PARM                    DDCSTS           10
      *
      * Update 'Current' Deal with Deal in Screen Format
      *
     C                   MOVEL     NwDlScnFmt    CrDlScnFmt
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * CANC@M - CANCEL ON MAIN DETAILS SCREEN
      *****************************************************************
     C     CANC@M        BEGSR
      *
      * IF RECORDS ARE STILL TO BE READ FROM THE SUBFILE, READ THEM
      *
     C     @RDNB         IFEQ      'Y'
     C                   MOVEL     'R'           @SCRN
     C                   ELSE
      *
      * ELSE, RETURN TO THE BROWSE SCREEN
      *
     C                   MOVEL     'B'           @SCRN
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SCRN@S - PROCESS SCREEN: SETTLEMENT DETAILS
      *          EVOKED FOR INSERTS, AMENDS, ENQUIRIES & AUTHORIZATIONS
      *****************************************************************
     C     SCRN@S        BEGSR
      *
      ** DETERMINE IF LOAN OR DEPOSIT
      *
     C     DDTYPE        IFEQ      'IP'
     C     DDTYPE        OREQ      'TI'
     C     DDTYPE        OREQ      'LN'
     C     DDTYPE        OREQ      'CL'
     C     DDTYPE        OREQ      'DL'
     C                   MOVEL     'L'           ##LOD             1
     C                   ELSE
     C                   MOVEL     'D'           ##LOD
     C                   ENDIF
      *
      ** PAYMENT DATE = VALUE DATE FOR LOAN, MATURITY DATE FOR DEPOSIT
      *
     C     ##LOD         IFEQ      'L'
     C                   Z-ADD     IKDVSD        ##DATP
     C                   ELSE
     C     IKMATD        IFEQ      0
     C                   Z-ADD     99999         ##DATP
     C                   ELSE
     C                   Z-ADD     IKMATD        ##DATP
     C                   ENDIF
     C                   ENDIF
      *
      ** RECEIVE DATE = MATURITY DATE FOR LOAN, VALUE DATE FOR DEPOSIT
      *
     C     ##LOD         IFEQ      'L'
     C     IKMATD        IFEQ      0
     C                   Z-ADD     99999         ##DATR
     C                   ELSE
     C                   Z-ADD     IKMATD        ##DATR
     C                   ENDIF
     C                   ELSE
     C                   Z-ADD     IKDVSD        ##DATR
     C                   ENDIF
      *
      * IF FIRST TIME FOR ACTION CODE, DEAL NUMBER, CURRENCY OR CUSTOMER
      *
     C     DDACTN        IFNE      ##ACTN
     C     DDDLNO        ORNE      ##DLNO
     C     DDCCY         ORNE      ##PCCY
     C     DDCUST        ORNE      ##CSNM
      *
      * DETERMINE PARAMETERS FOR SETTLEMENT DETAILS INPUT
      *
     C                   EXSR      DETP@S
     C                   ENDIF
      *
      * If no changes are allowed, protect (but still validate)
      * all instructions by passing action code 'X' to ZASETINSIN
      *
     C     @OPSEL        IFEQ      'N'
     C                   MOVEL     'X'           ##ACTN
     C                   ELSE
     C                   MOVEL     DDACTN        ##ACTN
     C                   ENDIF
      *
      * SETTLEMENT INSTRUCTIONS INPUT
      *
     C                   CALLB     'ZASETINSIN'
      *
      * INPUTS
      *
      * Return Code
     C                   PARM      *BLANK        ##RTCD           10
      *
      * Action code
     C                   PARM                    ##ACTN            1
      *
      * Deal number
     C                   PARM      DDDLNO        ##DLNO            6
      *
      * Protect Payment
     C                   PARM                    ##PPAY            1
      *
      * Protect Receive
     C                   PARM                    ##PREC            1
      *
      * Calling program
     C                   PARM      'LDNI'        ##CALP            4
      *
      * Payment currency
     C                   PARM      DDCCY         ##PCCY            3
      *
      * Receive currency
     C                   PARM      DDCCY         ##RCCY            3
      *
      * Customer shortname
     C                   PARM      DDCUST        ##CSNM           10
      *
      * Transaction Type
     C                   PARM      DDTYPE        ##TTYP            2
      *
      * Federal Funds Ind.
     C                   PARM      DDFEDF        ##FFND            1
      *
      * Booking branch
     C                   PARM      DDBRCA        ##BRCA            3
      *
      * Receipt Date
     C                   PARM                    ##DATR            5 0
      *
      * Payment Date
     C                   PARM                    ##DATP            5 0
      *
      * Payment instructions
     C                   PARM                    ##PAYS
      *
      * Receive instructions
     C                   PARM                    ##RECS
      *
      * FRA/IRS instructions
     C                   PARM                    ##FRIS
      *
      * OUTPUTS
      *
      * Payment instructions
     C                   PARM                    ##PAYF
      *
      * Receive instructions
     C                   PARM                    ##RECF
      *
      * FRA/IRS instructions
     C                   PARM                    ##FRIF
      *
      * FUNCTION KEYS
     C                   PARM      '0'           @INKC             1
     C                   PARM      '0'           @INKK             1                        MD036070
     C                   PARM      '0'           @INKL             1
      **********                                                                              222373
      **MIDAS*Our Receive/ Pay Instructions (for Settlm Meth = 04 )                           222373
     C**********         PARM                    @MORPI                                       222373
      *
      * CK/3 - END PROGRAM
      *
     C     @INKC         CASEQ     '1'           ENDP
      *
      * CK/12 - CANCEL ON SETTLEMENT DETAILS
      *
     C     @INKK         CASEQ     '1'           CANC@S                                     MD036070
     C     @INKL         CASEQ     '1'           CANC@S
      *
      * EXIT FROM SETTLEMENT DETAILS
      *
     C                   CAS                     EXIT@S
     C                   ENDCS
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * DETP@S - DETERMINE PARAMETERS FOR SETTLEMENT DETAILS SCREEN
      *****************************************************************
     C     DETP@S        BEGSR
      *
      * DETERMINE IF LOAN OR DEPOSIT
      *
     C     DDTYPE        IFEQ      'IP'
     C     DDTYPE        OREQ      'TI'
     C     DDTYPE        OREQ      'LN'
     C     DDTYPE        OREQ      'CL'
     C     DDTYPE        OREQ      'DL'
     C                   MOVEL     'L'           ##LOD             1
     C                   ELSE
     C                   MOVEL     'D'           ##LOD
     C                   ENDIF
      *
      * PAYMENT DATE = VALUE DATE FOR LOAN, MATURITY DATE FOR DEPOSIT
      *
     C     ##LOD         IFEQ      'L'
     C                   Z-ADD     IKDVSD        ##DATP
     C                   ELSE
     C     IKMATD        IFEQ      0
     C                   Z-ADD     99999         ##DATP
     C                   ELSE
     C                   Z-ADD     IKMATD        ##DATP
     C                   ENDIF
     C                   ENDIF
      *
      * RECEIVE DATE = MATURITY DATE FOR LOAN, VALUE DATE FOR DEPOSIT
      *
     C     ##LOD         IFEQ      'L'
     C     IKMATD        IFEQ      0
     C                   Z-ADD     99999         ##DATR
     C                   ELSE
     C                   Z-ADD     IKMATD        ##DATR
     C                   ENDIF
     C                   ELSE
     C                   Z-ADD     IKDVSD        ##DATR
     C                   ENDIF
      *
      * Convert Transaction Date to a Midas Day Number
      *
     C                   Z-ADD     IKDTYY        @@YY
     C                   Z-ADD     IKDTMM        @@MM
     C                   Z-ADD     IKDTDD        @@DD
     C     DateIn        IFEQ      0
     C                   Z-ADD     BJRDNB        TransDate
     C                   ELSE
     C                   CALLB     'ZDATE10'
     C                   PARM                    DateIn
     C                   PARM                    ZZMDNO            5 0
     C                   MOVE      ZZMDNO        TransDate         5 0
     C                   ENDIF
      *
      * PROTECT PAYMENT/RECEIVE INSTRUCTIONS IF DATES
      * ARE IN THE PAST AND THE DEAL WAS NOT DONE TODAY
      *
     C     ##DATP        IFLT      BJRDNB
     C     TransDate     ANDNE     BJRDNB
     C                   MOVEL     'Y'           ##PPAY
     C                   ELSE
     C                   MOVEL     'N'           ##PPAY
     C                   ENDIF
     C     ##DATR        IFLT      BJRDNB
     C     TransDate     ANDNE     BJRDNB
     C                   MOVEL     'Y'           ##PREC
     C                   ELSE
     C                   MOVEL     'N'           ##PREC
     C                   ENDIF
      *
      * IF PAYMENT OR RECEIPT INSTRUCTIONS ALREADY PRESENT (ON INVALID
      * DEAL SETTLEMENT INSTRUCTIONS FILE) THEN BYPASS DEFAULTING
      *
     C     ##PAYS        IFNE      *blank
     C     ##RECS        ORNE      *blank
     C                   GOTO      EDETP@S
     C                   ENDIF
      *
      * SET UP PAYMENT INSTRUCTIONS FROM DEAL
      * (ON INSERTIONS, THESE FIELDS WILL BE ZERO/BLANK)
      *
     C                   MOVEL     IKPSTM        FLPSTM                                       CGL029
     C                   MOVEL     IKPAYEx       FLPONS                                       CGL029
     C                   MOVEL     IKPAY         FLPAY
     C                   MOVEL     IKPOBR        FLPOBR
     C                   MOVEL     IKCVMR        FLCVMR
     C                   MOVEL     IKSTCY        FLPSCY
     C                   MOVEL     IKIC72        FLIC72
      *
      * SET UP RECEIVE INSTRUCTIONS FROM DEAL
      * (ON INSERTIONS, THESE FIELDS WILL BE ZERO/BLANK)
      *
     C                   MOVEL     IKRSTM        FLRSTM                                       CGL029
     C                   MOVEL     IKRECEx       FLRONS                                       CGL029
     C                   MOVEL     IKREC         FLREC
     C                   MOVEL     IKROBR        FLROBR
     C                   MOVEL     IKSTCY        FLRSCY
      *
      * IF SETTLEMENT INSTRUCTIONS ARE NOT DEFINED,
      * AND PAYMENT/RECEIPT DATES ARE NOT IN THE PAST, DEFAULT THEM
      *
     C     FLPSTM        IFEQ      *ZERO
     C     ##PPAY        ANDNE     'Y'
     C     FLRSTM        ANDEQ     *ZERO
     C     ##PREC        ANDNE     'Y'
      *
     C                   CALLB     'ZASETINDFT'
      *
      * INPUTS
      *
      * Calling program
     C                   PARM      'LDNI'        ##CALP            4
      *
      * Payment currency
     C                   PARM      DDCCY         ##PCCY            3
      *
      * Receive currency
     C                   PARM      DDCCY         ##RCCY            3
      *
      * Customer shortname
     C                   PARM      DDCUST        ##CSNM           10
      *
      * Transaction Type
     C                   PARM      DDTYPE        ##TTYP            2
      *
      * Federal Funds Ind.
     C                   PARM      DDFEDF        ##FFND            1
      *
      ** Version of ISDA Rules govern
     C                   PARM                    BQISDA            4
      *
      ** Type of ISDA agreement
     C                   PARM                    BQAGTY            6
      *
      ** Date of ISDA Agreement
     C                   PARM                    BQAGDT            6
      *
      ** Version of ISDA Agreement
     C                   PARM                    BQAGVV            2
      ** Version of ISDA Agreement century
     C                   PARM                    Blank2            2
                                                                                              CSD095
      ** Deal Subtype                                                                         CSD095
     C                   PARM      *BLANK        BlankSTYP                                    CSD095
                                                                                              CSD095
      ** Branch                                                                               CSD095
     C                   PARM      *BLANK        BlankBRCA                                    CSD095
      *
      ** OUTPUTS
      *
      * Payment instructions
     C                   PARM                    ##PAYF
      *
      * Receive instructions
     C                   PARM                    ##RECF
      *
      * FRA/IRS instructions
     C                   PARM                    ##FRIF
      *
     C                   ENDIF
      *
      * CONVERT SETTLEMENT DETAILS FROM FILE TO SCREEN FORMAT
      *
     C                   CALLB     'ZASETINCVT'
      *
      ** INPUTS
      *
      ** File Payment Settlement Instruction
     C                   PARM                    ##PAYF
      *
      ** File Receipt Settlement Instruction
     C                   PARM                    ##RECF
      *
      ** File FRA/IRS Settlement Instruction
     C                   PARM      *BLANK        ##FRIF
      *
      ** OUTPUTS
      ** Screen Payment Settlement Instruction
     C                   PARM      *BLANK        ##PAYS
      *
      ** Screen Receipt Settlement Instruction
     C                   PARM      *BLANK        ##RECS
      *
      ** Screen FRA/IRS Settlement Instruction
     C                   PARM      *BLANK        ##FRIS
     C                   PARM      DDCCY         ##RCCY                                      CSF011A
     C                   PARM      DDCCY         ##PCCY                                      CSF011A
      *
     C     EDETP@S       ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * CANC@S - CANCEL ON SETTLEMENT DETAILS SCREEN
      *****************************************************************
     C     CANC@S        BEGSR
      *
      * Return to Main Details Screen
      *
     C                   MOVEL     'M'           @SCRN
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * EXIT@S - EXIT FROM SETTLEMENT DETAILS SCREEN
      *****************************************************************
     C     EXIT@S        BEGSR
      *
      * If Settlement Details invalid, return to main details screen
      *
     C     ##RTCD        IFEQ      '*ERRORS'
     C                   MOVEL     'M'           @SCRN
      *
     C                   ELSE
     C                   MOVEL     '1'           @SCRN
      *
      * UPDATE VALID DEAL: PAYMENT SETTLEMENT INSTRUCTIONS
      *
     C                   MOVEL     FLPSTM        IKPSTM                                       CGL029
     C                   MOVEL     FLPONS        IKPAYEx                                      CGL029
     C                   MOVEL     FLPAY         IKPAY
     C                   MOVEL     FLPOBR        IKPOBR
     C                   MOVEL     FLCVMR        IKCVMR
      *
      * For Settlement method 04 , move the required part of  the
      * DataStructure  into the  correspondent  file  field  .
      *
     C     DDPSTM        IFEQ      '04'
     C                   MOVE      @@MOPI        IKMOPI
     C                   ENDIF
      *
      * UPDATE VALID DEAL: RECEIPT SETTLEMENT INSTRUCTIONS
      *
     C                   MOVEL     FLRSTM        IKRSTM                                       CGL029
     C                   MOVEL     FLRONS        IKRECEx                                      CGL029
     C                   MOVEL     FLREC         IKREC
     C                   MOVEL     FLROBR        IKROBR
      *
      * For Settlement method 04 , move the required part of  the
      * DataStructure  into the  correspondent  file  field  .
      *
     C     DDRSTM        IFEQ      '04'
     C                   MOVE      @@MORI        IKMORI
     C                   ENDIF
      *
      * UPDATE VALID DEAL: SETTLEMENT CURRENCY & 'IN' CCY IN FIELD 72
      *
     C                   MOVEL     FLPSCY        IKSTCY
     C                   MOVEL     FLIC72        IKIC72
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * CANC@C - CANCEL ON CONFIRMATION SCREEN
      *****************************************************************
     C     CANC@C        BEGSR
      *
      * RETURN TO MAIN DETAILS SCREEN
      *
     C                   MOVEL     'M'           @SCRN
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * EXIT@C - EXIT FROM CONFIRMATION SCREEN
      *****************************************************************
     C     EXIT@C        BEGSR
      *
      * IF NO ERRORS IN VALIDATION
      *
     C     Idx           IFEQ      *ZERO
      *
      * STORE THE LOAN/DEPOSIT INTO TEMPORARY STORAGE FILE
      *
     C                   MOVEL     '1'           @SCRN
      *
      * ELSE, RETURN TO MAIN DETAILS SCREEN
      *
     C                   ELSE
     C                   MOVEL     'M'           @SCRN
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * UPDATS - UPDATES
      *****************************************************************
     C     UPDATS        BEGSR
      *
      **************************
      * REPO LOAN/DEPOSIT UPDATE
      **************************
      *
      *Retrieve Loan/Deposit deal
      *
     C                   IF        DDACTN <> 'D'
     C                   CALLB     'MMRPLNTRD'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM                    @@AFRT
     C                   PARM                    NwDlFilFmt
     C                   ENDIF
      *
      * If Deal Number not Defined (on insert),
      * Get next available deal number
      *
     C     DDACTN        IFEQ      'A'
     C     DDDLNO        ANDEQ     *BLANK
     C                   MOVE      ##DDDLNO      DDDLNO
     C                   ENDIF
      *
     C     DDDLNO        IFEQ      *BLANK
      *
     C     I#DDDLNO      IFNE      *BLANK
     C                   MOVEL     I#DDDLNO      DDDLNO
     C                   ELSE
     C                   CALLB     'CAGETNXTDL'
     C                   PARM      *BLANKS       RetCodeOut
     C                   PARM      *BLANKS       @@MSG1            7
     C                   PARM                    DDDLNO
     C                   PARM      *ZERO         IKDN38
      *
      * DATABASE ERROR
      *
     C     @@MSG1        IFNE      *BLANK
     C                   MOVEL     'CAGTNXDL'    DBFILE                         ************
     C                   MOVEL     '002'         DBASE                          * DBERR 002*
     C                   MOVEL     DDDLNO        DBKEY                          ************
     C                   EXSR      *PSSR
     C                   ENDIF
     C                   ENDIF
     C                   MOVEL     DDDLNO        @SIDN
     C                   ENDIF
      *
      * Deal Number
     C                   MOVEL     DDDLNO        IKDN38
      *
      * Last Action Code
     C                   MOVEL     DDACTN        IKLACT
      *
      * Money Market Database Update
      *
     C                   CALLB     'MMLDNIUPM'
     C                   PARM      *BLANK        @RTCD             7
     C                   PARM                    NwDlFilFmt
     C/COPY WNCPYSRC,MMREPORC02
      *
      * DEALS UPDATES
      *
     C     @RTCD         IFEQ      *BLANK
 
     C                   CALLB     'MMLDNIUPD'
     C                   PARM                    @RTCD
     C                   PARM                    NwDlFilFmt
      *
      ******************************
      * REPO DELIVERY DETAILS UPDATE
      ******************************
      *
      * Copy Depo Movements to SEDMRPXX temporary Update File
      *
     C                   IF        DDACTN <> 'D'
     C                   CALLB     'MMRPDMTFL'
     C                   PARM                    @RTCD
     C                   PARM                    @@AFRT
     C                   ENDIF
      *
      * Override SECRTNTPPD to QTEMP/SECRTNTPPD
      *
     C                   Z-ADD     78            MESLEN           15 5
     C                   CALL      'QCMDEXC'                            9999    *
     C                   PARM                    ##OX1
     C                   PARM                    MESLEN
      *
      * Override SECRTTTPPD to QTEMP/SECRTTTPPD
      *
     C                   Z-ADD     78            MESLEN           15 5
     C                   CALL      'QCMDEXC'                            9999    *
     C                   PARM                    ##OX2
     C                   PARM                    MESLEN
      *
      * Override DPTMVDL1 to DPTMVDL1 SHARE(*NO)
      *
     C                   Z-ADD     68            MESLEN           15 5
     C                   CALL      'QCMDEXC'                            9999    *
     C                   PARM                    ##OX3
     C                   PARM                    MESLEN
      *
      * Override DPTMVDY1 to DPTMVDY1 SHARE(*NO)
      *
     C                   Z-ADD     68            MESLEN           15 5
     C                   CALL      'QCMDEXC'                            9999    *
     C                   PARM                    ##OX4
     C                   PARM                    MESLEN
      *
      * Override DPTMVDY2 to DPTMVDY2 SHARE(*NO)
      *
     C                   Z-ADD     68            MESLEN           15 5
     C                   CALL      'QCMDEXC'                            9999    *
     C                   PARM                    ##OX5
     C                   PARM                    MESLEN
      *
      * Override SEDMRPX1 to SEDMRPX1 SHARE(*NO)
      *
     C                   Z-ADD     68            MESLEN           15 5
     C                   CALL      'QCMDEXC'                            9999    *
     C                   PARM                    ##OX6
     C                   PARM                    MESLEN
      *
      * Override SEDMRPX2 to SEDMRPX2 SHARE(*NO)
      *
     C                   Z-ADD     68            MESLEN           15 5
     C                   CALL      'QCMDEXC'                            9999    *
     C                   PARM                    ##OX7
     C                   PARM                    MESLEN
      *
      * Override SECRTNL1 to SECRTNL1 SHARE(*NO)
      *
     C                   Z-ADD     71            MESLEN           15 5
     C                   CALL      'QCMDEXC'                            9999    *
     C                   PARM                    ##OX8
     C                   PARM                    MESLEN
      *
      * Override SECRTTL1 to SECRTTL1 SHARE(*NO)
      *
     C                   Z-ADD     71            MESLEN           15 5
     C                   CALL      'QCMDEXC'                            9999    *
     C                   PARM                    ##OX9
     C                   PARM                    MESLEN
     C
     C     @RTCD         IFEQ      *BLANK
     C                   CALLB     'MMRPDLUPD'
     C                   PARM                    @RTCD
     C                   PARM                    NwDlFilFmt
     C                   PARM                    DPTXX                                        CAP087
     C                   PARM      'N'           DepotPos                                     CAP087
     C                   ENDIF
 
     C                   ENDIF
      *
      *
      * IF THERE WERE ANY ERRORS IN THE UPDATE FUNCTIONS, ROLLBACK ANY
      * UPDATES AND END THIS PROGRAM.
      * OTHERWISE DELETE THE INVALID MM DEAL ACTIONED & COMMIT THE UPDATES
      *
     C     @RTCD         IFNE      *BLANK
     C                   ROLBK
     C     @RTCD         IFNE      '*RECUPD'
     C                   EXSR      *PSSR
     C                   ENDIF
     C
     C                   ELSE
                                                                                              247888
      ** Insert DLDLDCQD record for CLE025 processing                                         247888
     C**********         IF        DDACTN = 'I' AND CLE025 = 'Y'                     247888 MD031031
     C                   IF        DDACTN = 'I'                                             MD031031
     C     DDDLNO        CHAIN     DLDLDCD0                           12                      247888
     C     *IN12         IFEQ      *ON                                                        247888
     C                   EVAL      DX_F1DLNO = DDDLNO                                         247888
     C                   EVAL      DX_F1BRCA = DDBRCA                                         247888
     C                   WRITE     DLDLDCD0                                                   247888
     C                   ENDIF                                                                247888
     C                   ENDIF                                                                247888
                                                                                              247888
     C                   COMMIT
      *
      *  Clear down the MMTRPLNPD Temp Loan file
     C                   CLEAR                   MMTRPLN
     C                   MOVE      @@AFRT        T1IKAFRT
     C
     C                   CALLB     'MMRPLNTUP'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      'D'           RPLNMode
     C                   PARM                    MMTRPLN
     C
      *  Clear down the MMTRPDMPD file
     C                   CLEAR                   MMTRPDM
     C                   MOVE      @@AFRT        T2DMAFRT
      *
     C                   CALLB     'MMRPDMTUP'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      'D'           RPDMMode
     C                   PARM                    MMTRPDM
     C
      * Delete deal from the invalid files
     C                   CALLB     'MMREPOIDL'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM                    @@AFRT
     C                   PARM                    @TMESTPSEL
     C
      * Delete Settlement Instructions
     C     APDSETK0      CHAIN     APIDSETD0                          99
     C  N99              DELETE    APIDSETD0
                                                                                            240659
      * Make sure this deletion is committed                                                240659
     C                   COMMIT                                                             240659
     C
     C                   ENDIF
      *
      * If error occurred in updating last transaction set on flag to
      * display message on 'browse' screen.
     C     @RTCD         IFEQ      '*RECUPD'
     C                   MOVE      'Y'           @ERRUP
     C                   ELSE
     C                   MOVE      'N'           @ERRUP
     C                   ENDIF
     C
     C
      * IF RECORDS ARE STILL TO BE READ FROM THE SUBFILE, READ THEM
      *
     C     @RDNB         IFEQ      'Y'
     C                   MOVEL     'R'           @SCRN
     C                   ELSE
      *
      * ELSE, RETURN TO THE BROWSE SCREEN
      *
     C                   MOVEL     'B'           @SCRN
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * TLDNI - STORE LOAN/DEPOSIT IN TEMPORARY LOCATION
      *****************************************************************
     C     TLDNI         BEGSR
     C
     C                   MOVE      DDFOTRANID    IKFRNT
     C                   MOVE      DDFOASOCID    IKAFRT
     C
     C                   CALLB     'MMRPLNTUP'
     C                   PARM      *BLANKS       RetCodeOut
     C                   PARM      'I'           RPLNMode
     C                   PARM                    NwDlFilFmt
     C
     C                   IF        RetCodeOut = *blanks
     C                   MOVE      'D'           @SCRN
     C                   ENDIF
     C
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * PDPMT - PROCESS DEPOT MOVEMENT
      *****************************************************************
     C     PDPMT         BEGSR
     C
      *
     C                   CALLB     'MMRPDMRPR'
      *Return Code
      *Option selected by Back Office Repair user from subfile
      *Loan/deposit in MMLDNIPD format
      *Associated Front Office ID
     C                   PARM      *BLANKS       RCODE             7
     C                   PARM                    @OPSEL
     C                   PARM                    NwDlScnFmt
     C                   PARM                    @@AFRT
      *
      **ERRORS
     C                   PARM                    GFldNameAr
     C                   PARM                    GMsgIdAr
 
     C                   SELECT
 
     C                   WHEN      RCODE = 'UPD'
     C                   MOVE      'U'           @SCRN
 
      *Go back to the loans screen
     C                   WHEN      RCODE = 'F12'
     C                   MOVE      'M'           @SCRN
 
      *Terminate Program
     C                   WHEN      RCODE = 'F3'
     C                   MOVE      'T'           @SCRN
 
      *Back to Browse subfile
     C                   WHEN      RCODE = 'SFL'
     C                   MOVE      'R'           @SCRN
 
      *Error on call
     C                   OTHER
     C                   EXSR      *PSSR
 
     C                   ENDSL
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * ENDP - END PROGRAM
      *****************************************************************
     C     ENDP          BEGSR
     C
     C                   MOVEL     'T'           @SCRN
     C
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * TERM - TERMINATE THE PROGRAM
      *****************************************************************
     C     TERM          BEGSR
     C
     C                   MOVE      IKAFRT        @@AFRT
     C
      *  Clear down the MMTRPLNPD Temp Loan file
     C                   CLEAR                   MMTRPLN
     C                   MOVE      @@AFRT        T1IKAFRT
     C
     C                   CALLB     'MMRPLNTUP'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      'D'           RPLNMode
     C                   PARM                    MMTRPLN
     C
      *  Clear down the MMTRPDMPD file
     C                   CLEAR                   MMTRPDM
     C                   MOVE      @@AFRT        T2DMAFRT
      *
     C                   CALLB     'MMRPDMTUP'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      'D'           RPDMMode
     C                   PARM                    MMTRPDM
     C
     C                   MOVE      '1'           *INLR
     C
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * *INZSR - INITIAL PROCESSING
      *****************************************************************
     C     *INZSR        BEGSR
      *
      ** Initialize program name
      *
     C                   MOVEL     'MMREPORPR'   DBPGM
      *
      * Create SEDMRPXX temporary Depot Movement file (as used by MMRPDLUPD)
      *
     C                   CALLB     'SEDMRPCRT'
      *
      * Create SECRTNTPPD in QTEMP
      *
     C                   Z-ADD     81            MESLEN           15 5
     C                   CALL      'QCMDEXC'                            9999    *
     C                   PARM                    ##CN1
     C                   PARM                    MESLEN
      *
      * Create SECRTTTPPD in QTEMP
      *
     C                   Z-ADD     81            MESLEN           15 5
     C                   CALL      'QCMDEXC'                            9999    *
     C                   PARM                    ##CT1
     C                   PARM                    MESLEN
      *
      ** ACCESS BANK DETAILS
      *
     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANKS       @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
      *
      * DATABASE ERROR
      *
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     'SDBANKPD'    DBFILE                         ************
     C                   MOVEL     '901'         DBASE                          * DBERR 901*
     C                   MOVEL     @OPTN         DBKEY                          ************
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ** Access Module Details
      *
     C                   CALL      'AOMMODR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*FIRST '     @OPTN
     C     SDMMOD        PARM      SDMMOD        DSFDY
      *
      * DATABASE ERROR
      *
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     'SDMMODPD'    DBFILE                         ************
     C                   MOVEL     '902'         DBASE                          * DBERR 902*
     C                   MOVEL     @OPTN         DBKEY                          ************
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      * Key Lists
      *
     C     ZATRNKD0      KLIST
     C                   KFLD                    @FOTRANSEL
     C                   KFLD                    @TMESTPSEL
     C     ZATRNKX0      KLIST
     C                   KFLD                    @FOASOCSEL
     C                   KFLD                    @TMESTPSEL
     C     APDSETK0      KLIST
     C                   KFLD                    @MSGTYPE
     C                   KFLD                    @FOTRANSEL
     C                   KFLD                    @TMESTPSEL
     C     APDSETKX      KLIST
     C                   KFLD                    @MSGTYPE
     C                   KFLD                    @TMESTPSEL
     C                   KFLD                    @FOTRANSEL
 
      ** Message Type
     C                   MOVEL     'MMRPLD'      @MSGTYPE
 
      ** Get the field number for the action code field; the screen fields
      ** start from that number.  Subtract one from it to give the value
      ** to subtract from each field's number.
     C                   CALLB     'ZACGTFLDNO'
     C                   PARM                    ReturnCode
     C                   PARM                    Format
     C                   PARM                    Field
     C                   PARM                    FieldNo
 
     C                   IF        ReturnCode = *blank
     C                   EVAL      FldOffset = FieldNo - 1
 
      ** If there was an error default the offset to 13
     C                   ELSE
     C                   EVAL      FldOffset = 13
     C                   ENDIF
      *
      * Start on Browse Screen
      *
     C                   MOVEL     'B'           @SCRN             1
      *
      ** Access SAR details file to determine if CDL007 is on.
      ** (Deposit Breakdown Penalty)
      *
     C                   MOVEL     'N'           CDL007
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CDL007'      @SARD             6
     C     SCSARD        PARM      SCSARD        DSFDY
      *
     C     @RTCD         IFEQ      *BLANKS
     C                   MOVEL     'Y'           CDL007            1
     C                   ENDIF
      *
      ** Access SAR details file to determine if CAP051 is on.
      ** (Automatic Authorisation (MM Part))
      *
     C                   MOVEL     'N'           CAP051
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CAP051'      @SARD             6
     C     SCSARD        PARM      SCSARD        DSFDY
      *
     C     @RTCD         IFEQ      *BLANKS
     C                   MOVEL     'Y'           CAP051            1
     C                   ENDIF
 
                                                                                              247888
      ** Check if CLE025 is installed                                                         247888
                                                                                              247888
     C                   CALL      'AOSARDR0'                                                 247888
     C                   PARM      *BLANKS       @RTCD                                        247888
     C                   PARM      '*VERIFY'     @OPTN                                        247888
     C                   PARM      'CLE025'      @SARD                                        247888
     C     SCSARD        PARM      SCSARD        DSFDY                                        247888
                                                                                              247888
     C     @RTCD         IFEQ      *BLANK                                                     247888
     C                   MOVEL     'Y'           CLE025            1                          247888
     C                   ELSE                                                                 247888
     C                   MOVEL     'N'           CLE025                                       247888
     C                   ENDIF                                                                247888
                                                                                              247888
      *  Hook to enable non-core initial processing to be included
      */C*PY*WNCPYSRC,MMLDNIR012***************************************                       216200
      /COPY WNCPYSRC,MMREPOR012                                                               216200
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
      ********************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
**  CPY@
(c) Finastra International Limited 2001
** ##CN1
CPYF FROMFILE(SECRTNTPPD) TOFILE(QTEMP/SECRTNTPPD) CRTFILE(*YES) MBROPT(*REPLACE)
** ##CT1
CPYF FROMFILE(SECRTTTPPD) TOFILE(QTEMP/SECRTTTPPD) CRTFILE(*YES) MBROPT(*REPLACE)
** ##OX1
OVRDBF FILE(SECRTNTPPD) TOFILE(QTEMP/SECRTNTPPD) OVRSCOPE(*CALLLVL) SHARE(*NO)
** ##OX2
OVRDBF FILE(SECRTTTPPD) TOFILE(QTEMP/SECRTTTPPD) OVRSCOPE(*CALLLVL) SHARE(*NO)
** ##OX3
OVRDBF FILE(DPTMVDL1) TOFILE(DPTMVDL1) OVRSCOPE(*CALLLVL) SHARE(*NO)
** ##OX4
OVRDBF FILE(DPTMVDY1) TOFILE(DPTMVDY1) OVRSCOPE(*CALLLVL) SHARE(*NO)
** ##OX5
OVRDBF FILE(DPTMVDY2) TOFILE(DPTMVDY2) OVRSCOPE(*CALLLVL) SHARE(*NO)
** ##OX6
OVRDBF FILE(SEDMRPX1) TOFILE(SEDMRPX1) OVRSCOPE(*CALLLVL) SHARE(*NO)
** ##OX7
OVRDBF FILE(SEDMRPX2) TOFILE(SEDMRPX2) OVRSCOPE(*CALLLVL) SHARE(*NO)
** ##OX8
OVRDBF FILE(SECRTNL1) TOFILE(SECRTNL1) OVRSCOPE(*CALLLVL) SHARE(*NO)
** ##OX9
OVRDBF FILE(SECRTTL1) TOFILE(SECRTTL1) OVRSCOPE(*CALLLVL) SHARE(*NO)
