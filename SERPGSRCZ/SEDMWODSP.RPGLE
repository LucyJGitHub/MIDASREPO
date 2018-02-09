     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SE DPMV walk-out transaction display')           *
      *****************************************************************
      *                                                               *
      *  Midas - Securities Tradin Module                             *
      *                                                               *
      *  SEDMWODSP - Depot Movement Walk Out Transaction Display.     *
      *                                                               *
      *  Function:  This module displays the main details screen of   *
      *             the Walk Out Depot Movement screen input function.*
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CSW210             Date 04May10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD027             Date 09Dec05               *
      *                 CAP087             Date 03Aug05               *
      *                 237063             Date 20Nov05               *
      *                 CGL031             Date 05Jul04               *
      *                 216805             Date 21Apr03               *
      *                 211116             Date 31Oct02               *
      *                 CSC022             Date 16Mar04               *
      *                 CGL029             Date 01Sep03               *
      *                 CSE039             Date 21Jan03               *
      * Midas Release 4.01.03 ----------------------------------------*
      *                 211204             Date 11Jan02               *
      * Midas Release 4.01.01 ----------------------------------------*
      *                 207006             Date 18Jun02               *
      * Midas Release 4.01 -------------------------------------------*
      *                 197908             Date 11Jan02               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *                 191092             Date 16Mar01               *
      *                 187544             Date 11Dec00               *
      *                 178695             Date 29Jun00               *
      * Midas DBA 3.02 -----------------------------------------------*
      *                 CSE015             Date 06Dec99               *
      *                 CSE017             Date 20Oct99               *
      *                 CAP033             Date 26Apr99               *
      *                 CPB001             Date 26Aug99               *
      *                 164735             Date 20Oct99               *
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 CAP003  *CREATE    Date 06May98               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CSW210 - SWIFT 2010 Changes (Recompile)                      *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CAP087 - Depot Movement - Java Wrapper in Midasplus.         *
      *           (recompile due to changes in file SEDMWOPD and      *
      *           SEEDMWOPD)                                          *
      *  237063 - EU Tax fixes upgrade to MP build 103.               *
      *  CGL031 - Taxation of Savings Income                          *
      *  216805 - Movement Subtype field only dependent on Private    *
      *           Banking. Fix is to also condition field if Corres-  *
      *           pondence Manager module is on.                      *
      *  211116 - Protect amendment of 'Mvt-Subtype' field for Private*
      *           Banking customer transactions.                      *
      *  CSC022 - Database error occurs. Recompiled only.             *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  CSE039 - Auto-settle of trades.                              *
      *  211204 - Recompile due to change in DSPF/SEDPMVWODF.         *
      *  207006 - Add Counterparty & Market Centre to SSI             *
      *  197908 - Recompile due to change in DSPF/SEDPMVWODF.         *
      *  191092 - SEDPMVSIN - Cursor on a Non Display field           *
      *           added for CSE017 (Cum/EX/Flat)                      *
      *           Recompile for display file change                   *
      *  187544 - Depot Mvts - WI & WO: Review display of some        *
      *           PM/PB fields                                        *
      *  178695 - Protect Amend of Portfolio Reference                *
      *  CSE015 - Forward Valued Depot Movements                      *
      *  CSE017 - Cum/Ex Indicator on Depot Movements                 *
      *  CAP033 - Conversion of PM inputs into modular structure to   *
      *           use as APIs. Recompiled over changes to /COPY       *
      *           MSGHNDDCL.                                          *
      *  CPB001 - 'Private Banking' Module                            *
      *  164735 - Recompile for display file change                   *
      *  CAP003 - Conversion of SE inputs into modular structure to   *
      *           use as APIs.                                        *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
     FSEDPMVWODFCF   E             WORKSTN
 
      ** Table of field numbers and names
     FZAFLDNPD  IT   F   15        DISK    INFSR(*pssr)
                                                                                              CSE039
     FSEMVTSL2  IF   E           K DISK    INFSR(*PSSR)                                       CSE039
     F/COPY WNCPYSRC,SEDMWOXF01
 
      *****************************************************************
      *                                                               *
      * ID F  C  H  L    FUNCTION OF INDICATORS                       *
      *                                                               *
      *     10-59 Field Error - highlight screen fields               *
      *                                                               *
      *       68  Position cursor on action code (if it is blank)     *
      *       69  Protect deal key fields (action code & deal number) *
      *       70  Protect deal detail fields                          *
      *       71  Enable CF07                                         *
      *       72  Enable CF08                                         *
      *       73  Enable CF10                                         *
      *       74  Enable CF14                                         *
      *       75  Enable CF15                                         *
      *       76  Protect 'Mvt-Subtype' field for PB Customer         *         211116
      *       77  Enable CF22                                         *                       CSE039
      *       78  Correspondence Manager                              *                       216805
      *       78  Taxation of Savings Income                          *                       CGL031
      *                                                               *
      *       80  Not multibranching                                  *
      *       81  Originating branch not used                         *
      *       82  Profit centres not used                             *
      *       83  Portfolio management not installed                  *
      *       84  Depot Movement Charge enhancement not installed     *
      *       85  Private Banking Module not installed                *         CPB001
      *       86  Private Banking Field not processed                 *         CPB001
      *       87  Cum/Ex Indicator on Depot Movement is Installed     *                       CSE017
      *       88  Forward Valued Depot Movements is Installed         *                       CSE015
      *       91  CCG015 is enabled                                   *                       237063
      *                                                               *
      *       96  Subfile control                                     *
      *       97  Subfile end                                         *
      ********************************************************************
      /EJECT
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
 
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
      ** Program Status Data Structure.  They have meaningful
      ** names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
      **--------------------------------------------------------------------------------------------
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
     D/COPY ZACPYSRC,ERR_ARRAYS
      **--------------------------------------------------------------------------------------------
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes all the definitions of the error
      ** arrays, including the named constant giving the size of
      ** the arrays.  Note that it uses #MsgID and *MsgData, and so requires
      ** STD_D_SPEC.
     D/COPY ZACPYSRC,FVAL_ARRAY
      **--------------------------------------------------------------------------------------------
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
     D/COPY ZACPYSRC,APICTLARR
      **--------------------------------------------------------------------------------------------
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes the definitions for fields
      ** required by the message handler.
     D/COPY ZACPYSRC,MSGHNDDCL
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
 
     D @Z0             S              1    DIM(60) CTDATA PERRCD(60)
     D @NAR            S             40    DIM(2) CTDATA PERRCD(1)
     D @EI             S              1    DIM(60)
 
      ** External DS for Bank Details
      ** External DS for General Ledger Details
      ** External DS for Midas Module Details
      ** External DS For Switchable Feature Details
      ** Securities Trading Data
 
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
     D SDGELR        E DS                  EXTNAME(SDGELRPD)
     D SDMMOD        E DS                  EXTNAME(SDMMODPD)
     D SCSARD        E DS                  EXTNAME(SCSARDPD)
     D SDSTRD        E DS                  EXTNAME(SDSTRDPD)
     D SDSCOD        E DS                  EXTNAME(SDSCODPD)                                  CSE039
      ** EXTERNAL DS FOR MESSAGE STATUS CODE DETAILS                                          CSE039
 
      ** DS for AccessProgramsS, Short DS
      ** DS for AccessProgramsS, Long DS
     D DSFDY         E DS                  EXTNAME(DSFDY)
     D DSSDY         E DS                  EXTNAME(DSSDY)                       S01117
 
      ** Transaction Details DS
      ** ----------------------
 
     D SEDMScrF      E DS                  EXTNAME(SEDMWOPD)
     D SEErFldF      E DS                  EXTNAME(SEEDMWOPD)
 
     D                 DS
     D  DDFOTX                 1     40
     D  DDSIDN                10     15
 
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
     D CGL031          S              1A                                                      CGL031
                                                                                              CGL031
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
      *
      ** Main processing
      *
      ** Process hidden fields for Portfolio Details
      *
     C                   IF        BGPFMG = 'Y'
     C                             OR BGN4ST = 'Y'                              CPB001
      *
      ** Reset conditioning Indicator
      *
     C                   IF        BGPFMG = 'Y'                                 CPB001
     C                   EVAL      *IN83 = '0'
     C                   ENDIF                                                  CPB001
                                                                                CPB001
     C                   IF        BGN4ST = 'Y'                                 CPB001
     C                   EVAL      *IN85 = '0'                                  CPB001
     C                   EVAL      *IN86 = '0'                                  CPB001
     C                   EVAL      *IN76 = '0'                                  211116
     C                   EVAL      *IN79 = '0'                                  178695
     C                   ENDIF                                                  CPB001
 
     C****               IF        PortCusInd = 'N'
     C****                         AND DDCWDI = *BLANKS                         187544
     C****                         AND DDPTFR = *BLANKS                         187544
     C****                         AND DDCYLD = *BLANKS                         187544
     C****                         AND BGPFMG = 'Y'                       CPB001187544
     C****               EVAL      *IN83 = '1'                                  187544
     C****               END                                                    187544
      ****                                                                      187544
     C****               IF        PBCusInd = 'N'                         CPB001187544
     C****                         AND DDPTFR = *BLANKS                   CPB001187544
     C****                         AND DDPINT = *BLANKS                   CPB001187544
     C****                         AND DDACIN = *BLANKS                   CPB001187544
     C****                         AND DDMSTP = *BLANKS                   CPB001187544
     C****                         AND BGN4ST = 'Y'                       CPB001187544
     C****               EVAL      *IN85 = '1'                            CPB001187544
     C****               ENDIF                                            CPB001187544
      ****                                                                CPB001187544
     C****               IF        PBFieldInd = 'N'                       CPB001187544
     C****                         AND BGN4ST = 'Y'                       CPB001187544
     C****               EVAL      *IN86 = '1'                            CPB001187544
     C****               ENDIF                                            CPB001187544
      ****                                                                CPB001187544
     C     BGN4ST        IFEQ      'Y'                                          178695
     C     PBCusInd      ANDEQ     'Y'                                          178695
     C     DDACTN        ANDEQ     'A'                                          178695
     C                   EVAL      *IN76 = '1'                                  211116
     C                   EVAL      *IN79 = '1'                                  178695
     C                   ENDIF                                                  178695
     C                   END
 
     C                   EXSR      SRMAIN
      *
      ** Return
      *
     C     @INKC         IFEQ      '1'
     C                   SETON                                        LR
     C                   END
     C                   RETURN
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRMAIN - MAIN processing                                      *
      *                                                               *
      * Called By: Main Processing                                    *
      *                                                               *
      * Calls: ProcMsgs                                               *
      *                                                               *
      *****************************************************************
     C     SRMAIN        BEGSR
      *
      ** Move 'OK' Flags into Array
      *
     C                   MOVEA     SEErFldF      @EI
      *
      ** Set Screen error Indicators According to the status of the 'OK' flags
      *
     C                   Z-ADD     1             C                 2 0
     C                   Z-ADD     10            E                 2 0
 
     C     C             DOUGT     60
 
     C     @EI(C)        IFEQ      'N'
     C     @EI(C)        OREQ      'W'
     C                   MOVEL     '1'           *IN(E)
     C                   END
 
     C                   ADD       1             C
     C                   ADD       1             E
     C                   END
                                                                                              237063
     C                   IF        DDFSPROK = 'N' OR                                          237063
     C                             DDFSPROK = 'W'                                             237063
     C                   EVAL      *IN44 = *ON                                                237063
     C                   ENDIF                                                                237063
     C                   IF        DDOPDTOK = 'N' OR                                          237063
     C                             DDOPDTOK = 'W'                                             237063
     C                   EVAL      *IN45 = *ON                                                237063
     C                   ENDIF                                                                237063
     C                   IF        DDOPINOK = 'N' OR                                          237063
     C                             DDOPINOK = 'W'                                             237063
     C                   EVAL      *IN46 = *ON                                                237063
     C                   ENDIF                                                                237063
 
      ** Set up the transaction reference to be used by the message handler
     C                   EVAL      TranRef = DDDPRN
     C                   EVAL      ActionCode = DDACTN
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes processing for the error and
      ** warning messages.
     D/COPY ZACPYSRC,MSGHNDDSP1
      **--------------------------------------------------------------------------------------------
 
 
      ** Position cursor on Action Code if it is blank
      *
     C     DDACTN        COMP      *BLANK                                 68
      *
      ** Enable key fields (Action Code, Reference & Security)
      *
     C     @EKYFD        COMP      'Y'                                6969
      *
      ** Enable detail fields (all fields except Action Code, Reference)
      *
     C     @EDTFD        COMP      'Y'                                7070
      *
      ** Enable function keys
      *
     C     @EINKG        COMP      'Y'                                    71
     C     @EINKH        COMP      'Y'                                    72
     C     @EINKJ        COMP      'Y'                                    73
     C     @EINKN        COMP      'Y'                                    74
     C     @EINKP        COMP      'Y'                                    75
      *
      ** Deal Status
      *
      *
      ** TEXT = successful insert
      *
     C     @SIDN         IFNE      *BLANK
     C                   MOVEL     @NAR(1)       DDFOTX
     C                   MOVEL     @SIDN         DDSIDN
     C                   MOVEL     *BLANK        @SIDN
     C                   ELSE
      *
      ** TEXT = Confirm Delete
      *
     C     @EINKJ        IFEQ      'Y'
     C                   MOVEL     @NAR(2)       DDFOTX
     C                   ELSE
     C                   MOVEL     *BLANK        DDFOTX
     C                   END
     C                   END
     C/COPY WNCPYSRC,SEDMWOXC02
      *
      ** Write Subfile message, Details and Footer screen
      *
     C                   TIME                    DDTIME
      * If CSE039 is ON then access movements file for movement status                        CSE039
      * and display                                                                           CSE039
     C                   MOVE      *BLANKS       DDSWSC                                       CSE039
     C                   MOVE      *BLANKS       DDCDNR                                       CSE039
                                                                                              CSE039
     C     CSE039        IFEQ      'Y'                                                        CSE039
     C     DDACTN        ANDNE     'I'                                                        CSE039
     C                   MOVE      DDDPRN        KTDRF                                        CSE039
     C                   MOVE      'W'           KTRTY                                        CSE039
                                                                                              CSE039
     C     KMVTS         SETLL     SEMVTSD0                                                   CSE039
     C     KMVTS         READE     SEMVTSD0                               90                  CSE039
      *                                                                                       CSE039
      * Obtain Status description                                                             CSE039
     C     *IN90         IFEQ      *OFF                                                       CSE039
     C                   CALLB     'AOSCODR0'                                                 CSE039
     C                   PARM      *Blanks       @RTCD                                        CSE039
     C                   PARM      '*KEY'        @OPTN                                        CSE039
     C                   PARM      TMSWSC        @CCODE            4                          CSE039
     C                   PARM      'S'           @CDTP             1                          CSE039
     C                   PARM      *Blanks       @CDDP             4                          CSE039
     C     SDSCOD        PARM      SDSCOD        DSFDY                                        CSE039
                                                                                              CSE039
      * Move Status and Status description to screen fields.                                  CSE039
     C                   MOVEL     TMSWSC        DDSWSC                                       CSE039
     C                   MOVEL     SRCDNR        DDCDNR                                       CSE039
                                                                                              CSE039
     C                   ENDIF                                                                CSE039
      *                                                                                       CSE039
      * Ensure F22 key is displayed (if called from SIN module)                               CSE039
      * there has not been another program (eg SE4400) calling the                            CSE039
      * SIN module)                                                                           CSE039
     C     DDACTN        IFEQ      'E'                                                        CSE039
     C     DDACTN        OREQ      'A'                                                        CSE039
     C     @INKWDisp     IFEQ      'Y'                                                        CSE039
     C     DDDPRN        ANDNE     *BLANKS                                                    CSE039
     C                   MOVE      '1'           *IN77                                        CSE039
     C                   ENDIF                                                                CSE039
     C                   ENDIF                                                                CSE039
     C                   ENDIF                                                                CSE039
                                                                                              CSE039
     C                   WRITE     SEDMWOS0
     C                   WRITE     SEDMWOD1
     C                   WRITE     SEDMWOF1
      *
      ** Read Details Screen
      ** If not write only
      *
     C     WriteOnly     IFNE      'Y'
     C                   READ      SEDMWOD1                               99    *
     C                   ENDIF
      *
      ** Clear message subfile
      *
     C***** martin       CALL      'ZA0250'
      *
      ** Set screen error indicators OFF
      *
     C                   MOVEA     @Z0           *IN(10)
      *
      ** Set Return Keys
      *
     C                   MOVE      *INKC         @INKC
     C                   MOVE      *INKG         @INKG
     C                   MOVE      *INKH         @INKH
     C                   MOVE      *INKJ         @INKJ
     C                   MOVE      *INKL         @INKL
     C                   MOVE      *INKN         @INKN
     C                   MOVE      *INKP         @INKP
     C                   MOVE      *INKW         @INKW                                        CSE039
 
     C                   ENDSR
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes the ProcMsgs subroutine
      ** to process error and warning messages.
     D/COPY ZACPYSRC,MSGHNDDSP2
      **--------------------------------------------------------------------------------------------
 
     C********************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *InzSR - Initial Processing                                   *
      *                                                               *
      * Called by: During Program Activation                          *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     *INZSR        BEGSR
      *
      ** Parameters
      *
     C     *ENTRY        PLIST
      *
      ** Retrun Code
     C                   PARM                    RetCodeIn
      ** Security                                                                             CSE039
     C                   PARM                    DPMVSety         10                          CSE039
      ** Transaction Number                                                                   CSE039
     C                   PARM                    DPMVTrno          6                          CSE039
 
     ** Received parameters
     ** -------------------
 
     ** Transaction Details
      * Transaction Status
      * Security Status
      * Transaction Screen Format
      * Exchange Rate
      * M/D Indicator
      * Portfolio Customer Indicator
      * Private Banking Customer Indicator                                      CPB001
      * Private Banking Field process Indicator                                 CPB001
      * Fields in Error
     C                   PARM                    DDTranSts
     C                   PARM                    DDSecSts
     C                   PARM                    SEDMScrF
     C                   PARM                    DDSPXR           14
     C                   PARM                    DDSPMD            1
     C                   PARM                    PortCusInd        1
     C                   PARM                    PBCusInd          1            CPB001
     C                   PARM                    PBFieldInd        1            CPB001
     C                   PARM                    SEErFldF
      *
      ** Errors
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
      *
      ** Warnings
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIdArr
     C                   PARM                    WMsgDtaArr
      *
      ** Enabled keys and detail fields
      *
     C                   PARM                    @EKYFD            1
     C                   PARM                    @EDTFD            1
      *
      ** Enabled function keys
      ** KG = COMMAND KEY 07 = READ PREVIOUS
      ** KH = COMMAND KEY 08 = READ NEXT
      ** KJ = COMMAND KEY 10 = CONFIRM DELETE
      ** KN = COMMAND KEY 14 = SETTLEMENT DETAILS
      ** KP = COMMAND KEY 15 = BROWSE
     C                   PARM                    @EINKG            1
     C                   PARM                    @EINKH            1
     C                   PARM                    @EINKJ            1
     C                   PARM                    @EINKN            1
     C                   PARM                    @EINKP            1
      *
      ** Succesful Insert Deal
     C                   PARM                    @SIDN             6
      *
      ** OUTPUT PARAMETERS
      ** -----------------
      *
      ** Function keys
     C                   PARM                    @INKC             1
     C                   PARM                    @INKG             1
     C                   PARM                    @INKH             1
     C                   PARM                    @INKJ             1
     C                   PARM                    @INKL             1
     C                   PARM                    @INKN             1
     C                   PARM                    @INKP             1
     C                   PARM                    @INKW             1                          CSE039
     C                   PARM                    @INKWDisp         1                          CSE039
      *
      ** Write screen with no read indicator
     C                   PARM                    WriteOnly         1
                                                                                              CGL031
      ** CGL031 parameter                                                                     CGL031
                                                                                              CGL031
     C                   PARM                    CGL031                                       CGL031
      *
      ** Initialize program name
      *
     C                   MOVEL     'SEDMWODSP'   DBPGM
      *
      ** Move workstation ID to screen field.
      *
     C                   MOVEL     PsJobName     DDWID
      *
      ** ACCESS BANK DETAILS
      *
     C                   CALL      'AOBANKR0'
     C                   PARM      '*DBERR '     @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
      *
      * DATABASE ERROR
      *
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     'SDBANKPD'    DBFILE
     C                   MOVEL     '901'         DBASE
     C                   MOVEL     @OPTN         DBKEY
     C                   EXSR      *PSSR
     C                   END
 
     C                   MOVE      BJMRDT        RunDate
      *
      ** ACCESS GENERAL LEDGER DETAILS
      *
     C**********         CALL      'AOGELRR0'                                                 CGL029
     C                   CALL      'AOGELRR1'                                                 CGL029
     C                   PARM      '*DBERR '     @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C*****SDGELR        PARM      SDGELR        DSFDY                                        CGL029
     C     SDGELR        PARM      SDGELR        DSSDY                                        CGL029
      *
      ** DATABASE ERROR
      *
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     'SDGELRPD'    DBFILE
     C                   MOVEL     '902'         DBASE
     C                   MOVEL     @OPTN         DBKEY
     C                   EXSR      *PSSR
     C                   END
      *
      ** Access Midas Module Details
      *
     C                   CALL      'AOMMODR0'
     C                   PARM      '*DBERR '     @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C     SDMMOD        PARM      SDMMOD        DSFDY
      *
      ** DATABASE ERROR
      *
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     'SDMMODPD'    DBFILE
     C                   MOVEL     '903'         DBASE
     C                   MOVEL     @OPTN         DBKEY
     C                   EXSR      *PSSR
     C                   END
      *
      ** Access SAR details file to determine if S01445
      ** (Depot Movement Charge Enhancement) is on.
      *
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'S01445'      @SARD
     C     SCSARD        PARM      SCSARD        DSFDY
 
     C     @RTCD         IFNE      *BLANKS
     C     @RTCD         ANDNE     '*NRF   '
     C                   MOVEL     'SCSARDPD'    DBFILE
     C                   MOVEL     '904'         DBASE
     C                   MOVEL     'S01445'      DBKEY
     C                   EXSR      *PSSR
     C                   END
 
     C     @RTCD         IFEQ      *BLANK
     C                   MOVEL     'Y'           S01445            1
     C                   ELSE
     C                   MOVEL     'N'           S01445
     C                   END
      *
      ** Get Securities Trading Data by access object
      *
     C                   CALL      'AOSTRDR0'
     C                   PARM      '*DBERR '     @RTCD
     C                   PARM      '*FIRST '     @OPTN
     C     SDSTRD        PARM      SDSTRD        DSSDY
 
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     'SDSTRDPD'    DBFILE
     C                   MOVEL     '905'         DBASE
     C                   MOVEL     '*FIRST'      DBKEY
     C                   EXSR      *PSSR
     C                   END
      *
      ** Check if CSE039 is installed                                                         CSE039
     C                   CALL      'AOSARDR0'                                                 CSE039
     C                   PARM      *BLANKS       @RTCD             7                          CSE039
     C                   PARM      '*VERIFY'     @OPTN             7                          CSE039
     C                   PARM      'CSE039'      @SARD             6                          CSE039
      *                                                                                       CSE039
     C     @RTCD         IFEQ      *BLANKS                                                    CSE039
     C                   MOVE      'Y'           CSE039            1                          CSE039
     C                   ELSE                                                                 CSE039
     C                   MOVE      'N'           CSE039                                       CSE039
     C                   ENDIF                                                                CSE039
                                                                                              CSE039
      * Message subfile control
      *
     C                   MOVE      '1'           *IN97
     C                   MOVEL     '*'           DDPGMQ
      *
      ** Set screen Protect/Non-display indicators
      *
      *
      * Single-branching (protect booking branch)
      *
     C     BJSBRC        IFNE      *BLANK
     C                   MOVE      '1'           *IN80
     C                   END
      *
      * Originating Branches not used
      *
     C     BKOBRU        IFNE      'Y'
     C     BJSBRC        ORNE      *BLANK
     C                   MOVE      '1'           *IN81
     C                   END
      *
      ** Profit Centres not used (protect profit centre)
      *
     C     BKPRCU        IFNE      'Y'
     C                   MOVE      '1'           *IN82
     C                   END
      *
      ** Portfolio Management not installed (protect portfolio)
      *
     C     BGPFMG        IFNE      'Y'
     C                   MOVE      '1'           *IN83
     C                   END
      *                                                                         CPB001
      ** Private Banking not installed (protect portfolio)                      CPB001
      *                                                                         CPB001
     C     BGN4ST        IFNE      'Y'                                          CPB001
     C                   MOVE      '1'           *IN85                          CPB001
     C                   END                                                    CPB001
      *
      ** Automatic charges and S01445 is installed
      *
     C                   MOVE      '1'           *IN84
 
     C     S01445        IFEQ      'Y'
     C     BVACOP        ANDEQ     'Y'
     C                   MOVE      '0'           *IN84
     C                   END
                                                                                              CGL031
      ** Taxation of Savings Income installed.                                                CGL031
                                                                                              CGL031
     C                   MOVE      *OFF          *IN78                                        CGL031
                                                                                              CGL031
     C                   IF        CGL031 = 'Y'                                               CGL031
     C                   MOVE      *ON           *IN78                                        CGL031
     C                   ENDIF                                                                CGL031
      *                                                                                       CSE017
      ** Access SAR details file to determine if CSE017 is installed                          CSE017
      *                                                                                       CSE017
     C                   CALL      'AOSARDR0'                                                 CSE017
     C                   PARM      *BLANKS       @RTCD                                        CSE017
     C                   PARM      '*VERIFY'     @OPTN                                        CSE017
     C                   PARM      'CSE017'      @SARD                                        CSE017
     C     SCSARD        PARM      SCSARD        DSFDY                                        CSE017
                                                                                              CSE017
     C     @RTCD         IFNE      *BLANKS                                                    CSE017
     C     @RTCD         ANDNE     '*NRF   '                                                  CSE017
     C                   MOVEL     'SCSARDPD'    DBFILE                                       CSE017
     C                   MOVEL     '906'         DBASE                                        CSE017
     C                   MOVEL     'CSE017'      DBKEY                                        CSE017
     C                   EXSR      *PSSR                                                      CSE017
     C                   END                                                                  CSE017
                                                                                              CSE017
     C     @RTCD         IFEQ      *BLANK                                                     CSE017
     C                   MOVEL     'Y'           CSE017            1                          CSE017
     C                   MOVE      *ON           *IN87                                        CSE017
     C                   ELSE                                                                 CSE017
     C                   MOVEL     'N'           CSE017                                       CSE017
     C                   MOVE      *OFF          *IN87                                        CSE017
     C                   END                                                                  CSE017
      *                                                                                       CSE015
      ** Access SAR details file to determine if CSE015 is installed                          CSE015
      *                                                                                       CSE015
     C                   CALL      'AOSARDR0'                                                 CSE015
     C                   PARM      *BLANKS       @RTCD                                        CSE015
     C                   PARM      '*VERIFY'     @OPTN                                        CSE015
     C                   PARM      'CSE015'      @SARD                                        CSE015
     C     SCSARD        PARM      SCSARD        DSFDY                                        CSE015
                                                                                              CSE015
     C     @RTCD         IFNE      *BLANKS                                                    CSE015
     C     @RTCD         ANDNE     '*NRF   '                                                  CSE015
     C                   MOVEL     'SCSARDPD'    DBFILE                                       CSE015
     C                   MOVEL     '907'         DBASE                                        CSE015
     C                   MOVEL     'CSE015'      DBKEY                                        CSE015
     C                   EXSR      *PSSR                                                      CSE015
     C                   END                                                                  CSE015
                                                                                              CSE015
     C     @RTCD         IFEQ      *BLANK                                                     CSE015
     C                   MOVEL     'Y'           CSE015            1                          CSE015
     C                   MOVE      *ON           *IN88                                        CSE015
     C                   ELSE                                                                 CSE015
     C                   MOVEL     'N'           CSE015                                       CSE015
     C                   MOVE      *OFF          *IN88                                        CSE015
     C                   END                                                                  CSE015
     C/COPY WNCPYSRC,SEDMWOXC01
                                                                                              207006
     C                   CALL      'AOSARDR0'                                                 207006
     C                   PARM      *BLANKS       @RTCD                                        207006
     C                   PARM      '*VERIFY'     @OPTN                                        207006
     C                   PARM      'CSE029'      @SARD                                        207006
     C     SCSARD        PARM      SCSARD        DSFDY                                        207006
                                                                                              207006
     C     @RTCD         IFNE      *BLANKS                                                    207006
     C     @RTCD         ANDNE     '*NRF   '                                                  207006
     C                   MOVEL     'SCSARDPD'    DBFILE                                       207006
     C                   MOVEL     '908'         DBASE                                        207006
     C                   MOVEL     'CSE029'      DBKEY                                        207006
     C                   EXSR      *PSSR                                                      207006
     C                   ENDIF                                                                207006
                                                                                              207006
     C     @RTCD         IFEQ      *BLANKS                                                    207006
     C                   MOVEL     'Y'           CSE029            1                          207006
     C                   MOVE      *OFF          *IN89                                        207006
     C                   ELSE                                                                 207006
     C                   MOVEL     'N'           CSE029                                       207006
     C                   MOVE      *ON           *IN89                                        207006
     C                   ENDIF                                                                207006
                                                                                              216805
     C                   CALL      'AOSARDR0'                                                 216805
     C                   PARM      *BLANKS       @RTCD                                        216805
     C                   PARM      '*VERIFY'     @OPTN                                        216805
     C                   PARM      'CCG015'      @SARD                                        216805
     C     SCSARD        PARM      SCSARD        DSFDY                                        216805
                                                                                              216805
     C     @RTCD         IFEQ      *BLANKS                                                    216805
     C**********         MOVE      '1'           *IN78                                 216805 237063
     C                   MOVE      '1'           *IN91                                        237063
     C                   ENDIF                                                                216805
 
     C     KMVTS         KLIST                                                                CSE039
     C                   KFLD                    KTDRF             6                          CSE039
     C                   KFLD                    KTRTY             1                          CSE039
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line sets up the fixed data for SE *DSP
      ** functions for the message handler, ZAMSGHNDLE.
     D/COPY SECPYSRC,MSGHNDDATA
      **--------------------------------------------------------------------------------------------
 
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      ********************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
**  CPY@
(c) Finastra International Limited 2001
** @Z0
000000000000000000000000000000000000000000000000000000000000
** @NAR
Deal No. 999999 successfully inserted.
F10=CONFIRM DELETE
