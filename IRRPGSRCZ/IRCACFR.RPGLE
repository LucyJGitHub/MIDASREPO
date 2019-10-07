     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2003')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas IR Caps/collars/floors retrieve')                *
      *****************************************************************
      *                                                               *
      *  Midas - FRA/IRS Dealing Module                               *
      *                                                               *
      *  IRCACFR   - Caps/Collars/Floors - Retrieve a record          *
      *                                                               *
      *  Function:  This module retrieves a Cap/Collars/Floor deal    *
      *             from the database.  As it does so, it validates   *
      *             the action code, deal number and deal type.       *
      *                                                               *
      *  (c) Finastra International Limited 2003                      *
      *                                                               *
      *  Last Amend No. MD054117           Date 12Sep19               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      *                 MD044506           Date 28Mar17               *
      *                 CSW216             Date 14Mar16               *
      *                 MD031861           Date 12Jan15               *
      *                 CSW214             Date 25Nov14               *
      *                 CDL094             Date 11Jun14               *
      *                 245692             Date 11Dec13               *
      *                 CSW213             Date 03Jun13               *
      *                 CSF011A            Date 28Nov11               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 240240             Date 26Jun06               *
      *                 CSD031             Date 10Apr06               *
      *                 BUG11254           Date 18Apr06               *
      *                 CSD027             Date 09Dec05               *
      *                 BUG8550            Date 05Oct05               *
      *                 BUG7784            Date 30Jun05               *
      *                 BUG5871            Date 20May05               *
      *                 CDL038             Date 10May05               *
      *                 BUG7046            Date 06May05               *
      *                 CLE031             Date 26Apr05               *
      *                 BUG6472            Date 23Apr05               *
      *                 CDL028             Date 07Feb05               *
      *                 BUG6377            Date 11Apr05               *
      *                 BUG6386            Date 23Mar05               *
      *                 BUG6233            Date 10Mar05               *
      *                 BUG5731            Date 15Feb05               *
      *                 BUG5403            Date 10Jan05               *
      *                 BUG5181            Date 16Dec04               *
      *                 CDL018             Date 03Feb04               *
      *                 CAP084  *CREATE    Date 18Aug03               *
      *                                                               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD054117 - Principal change Increase/Decrease capability     *
      *  MD046248 - Finastra Rebranding                               *
      *  MD044506 - MT300 98D trade execution date can not be before  *
      *             value date.                                       *
      *  CSW216 - SWIFT Changes 2016                                  *
      *  MD031861 - Cannot insert transaction due to errors. Correct  *
      *             mapping to include CDL094 fields.                 *
      *  CSW214 - SWIFT Changes 2014                                  *
      *  CDL094 - Enhance Receive Settlement Instructions             *
      *           (Recompile)                                         *
      *  245692 - Incorrect validation of rates when the decimal se-  *
      *           parator in the Dealing ICD was defined as "," ins-  *
      *           tead of ".".                                        *
      *         - Applied for MD23981.                                *
      *  CSW213 - SWIFT Changes 2013                                  *
      *  CSF011A - CCR015: Display Order in Confirmation Pages        *
      *  240240 - Ensure locks don't remain on DLPCSCPD.              *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  BUG11254-Positions of the schedules on the buffer were not   *
      *           changed to cope with impact of CLE031 changes.      *
      *           Also there are no code changes for CDL038 in here.  *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  BUG8550 - Reposition capture of ZMUSER data area             *
      *  BUG7784 - Pass correct date format parameter to ZDATE2       *
      *  BUG5871 - Send deal status to MidasPlus                      *
      *  CDL038 - Extended Deal Sub Type (Recompile)                  *
      *  BUG7046- Retrieve principal change schedules even if         *
      *           next principal change date is blank                 *
      *  CLE031 - Lending Enhancements - Settlement Currency Recompile*
      *  BUG6472- Added a sign field for short term rate              *
      *  CDL028 - Automatic Rate Interpolations                       *
      *  BUG6377 - Need Fixing Dates (Ours and Theirs) ADDED to       *
      *            the confirmation screens                           *
      *  BUG6386 - Principal Change schedules not showing for migrated*
      *            deals                                              *
      *  BUG6233- Principle change amount is 0 when plato is off      *
      *  BUG5731 - Re-initialise variable ReturnCode after executing  *
      *            initialization subroutine.                         *
      *  BUG5403 - Principle Change Schedule missing in CACF          *
      *  BUG5181- Additional parameter added to IRCACFCVT by 219686   *
      *  CDL018 - Multiple Settlement Accounts on Loans/Deposits      *
      *           (Recompile)                                         *
      *  CAP084 - API Wrapper project. This will replace version      *
      *           found in core.                                      *
      *                                                               *
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
      ** Confirmation Matching - Feedback Title from TRAM
     FCFFEEDL0  IF   E           K DISK    INFSR(*PSSR)
     F                                     PREFIX(CF_)
     F*DLPCSCL0**IF***E           K DISK                                             BUG5403  240240
     FDLPCSCL0  IF   E           K DISK    INFSR(*PSSR)                                       240240
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      **
      **-----------------------------------------------------------------------
      ** The following /COPY line includes (among others) the LDA layout
      ** and the copyright array definition:
     D/COPY ZACPYSRC,STD_D_SPEC
      **-----------------------------------------------------------------------
 
      **-----------------------------------------------------------------------
      ** The following /COPY includes the standard API declares:
     D/COPY ZACPYSRC,STDDECLARE
      **-----------------------------------------------------------------------
 
      **-----------------------------------------------------------------------
      ** The following /COPY line includes all the defined fields in the
      ** Program Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
      **-----------------------------------------------------------------------
 
      **-----------------------------------------------------------------------
     D/COPY ZACPYSRC,ERR_ARRAYS
      **-----------------------------------------------------------------------
 
      ** +--------------------------------------+
      ** ¦ End of automatically included D-specs¦
      ** ¦ =====================================¦
      ** +--------------------------------------+
 
      **-----------------------------------------------------------------------
      ** Screen formats
      **-----------------------------------------------------------------------
 
      ** Current Deal in Screen Format
     D CrIRScnFmt    E DS                  EXTNAME(IRCACFPD)
     D                                     PREFIX(@)
 
      ** New Deal in Screen Format
     D NwIRScnFmt    E DS                  EXTNAME(IRCACFPD)
 
      ** Business Day Conventions layout
     D  BsDayConv            205    268
     D  RCcy1                239    268
 
      ** Business Day Conventions layout of NwIRScnFmt
 
     D NwIRScn2Fmt   E DS                  EXTNAME(IRCACF2PD)
      ** New Deal in Work Screen Format
 
      ** Screen Receive Instructions
     D PSRecS        E DS                  EXTNAME(SDESSRPD)
 
      ** Screen Payment Instructions
     D PSPayS        E DS                  EXTNAME(SDESSPPD)
 
      ** Screen FRA/IRS Instructions
     D PSRsIS        E DS                  EXTNAME(SDESSFPD)
      **-----------------------------------------------------------------------
      ** File formats
      **-----------------------------------------------------------------------
 
      ** Current Deal in File Format
     D CrIRFilFmt    E DS                  EXTNAME(DEALSDG)
     D  RPREC                730    784
     D  RPPAY                799   1343
     D  RPIRS               1345   1992
 
      ** File Receive instructions
     D PSRecF        E DS                  EXTNAME(SDESFRPD)
     D  FLREC                 21     75
 
      ** File Payment Instructions
     D PSPayF        E DS                  EXTNAME(SDESFPPD)
     D  FLPAY                 21    575
 
      ** File FRA/IRS Instructions
     D PSRsIF        E DS                  EXTNAME(SDESFFPD)
     D  FLIRS                  1    650
      **-----------------------------------------------------------------------
 
      ** CFFEEDL0 key
     D  WCFKY          DS            16
     D  WTST1                  1      8
     D  WKEY1                  1      2
     D  WKEY2                  3      8
     D  WKEY3                  9     11
 
     D ZMUSER          DS            17
     D  PkDBRC                11     13
 
      **-----------------------------------------------------------------------
 
      ** Index for arrays of of error message ids etc
     D Idx             S              3P 0
 
      ** Index for arrays of warning message ids etc
     D WIdx            S              3P 0
 
      * Error indicators
     D IRECACF       E DS                  EXTNAME(IRECACFPD)
 
     D InfData       E DS                  EXTNAME(IRRPIFPD)
      ** FRA/IRS Interface Non-Screen Data
 
      ** Caps/Collars/Floors Extra Data Layout - File (D/B) format
     D ExtData       E DS                  EXTNAME(IRCPEXPD)
 
      ** Midas DL Dealing Reporting Information file                                          CSW213
     D DLRPIFScn1Fmt E DS                  EXTNAME(DLRIS1PD)                                  CSW213
     D DLRPIFScn2Fmt E DS                  EXTNAME(DLRIS2PD)                                  CSW213
     D DLRPIFScn3Fmt E DS                  EXTNAME(DLRIS3PD)                                  CSW213
     D DLRPIFScn4Fmt E DS                  EXTNAME(DLRIS4PD)                                  CSW214
     D DLRPIFFileFmt E DS                  EXTNAME(DLRPIFPD)                                  CSW213
     D PDlRILkpd     E DS                  EXTNAME(DLRILKPD)                                  CSW213
                                                                                              CSW213
      ** Define data structure for InSwift2013                                                CSW213
     D InSwift2013     DS                                                                     CSW213
     D  DLRPIFS1Fmt                        LIKE(DLRPIFScn1Fmt)                                CSW213
     D  DLRPIFS2Fmt                        LIKE(DLRPIFScn2Fmt)                                CSW213
     D  DLRPIFS3Fmt                        LIKE(DLRPIFScn3Fmt)                                CSW213
     D  DLRPIFS4Fmt                        LIKE(DLRPIFScn4Fmt)                                CSW214
                                                                                              CSW213
      ** Receive / Pay Settlement Method & Nostro
     D PSETIN          DS
     D  PrRSCY                 1      3
     D  PrRSTM                 4      5  0
     D  PrRONS                 6     17
     D  PrPSCY                18     20
     D  PrPSTM                21     22  0
     D  PrPONS                23     34
 
      ** Array for counterparty and broker fields narratives
     D CPBKTxt         S             17    DIM(2) PERRCD(1) CTDATA
 
      ** Array for counterparty and broker status codes/narratives
     D TAB1            S              2  0 DIM(16) PERRCD(1) CTDATA
     D TAB2            S             15    DIM(16) ALT(TAB1)
 
      ** Current Control Indicators for Main Details Screen
     D WDSCurrInd      DS
     D  PEKyFd                 1      1
     D  PEDtFd                 2      2
     D  PEINKG                 3      3
     D  PEINKH                 4      4
     D  PEINKJ                 5      5
     D  PEINKN                 6      6
     D  PEINKP                 7      7
 
      ** Previous Control Indicators for Main Detail Screen
     D WDSPrevInd      DS             7
 
      ** External DS for Bank Details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
 
      ** Midas Modules Details Accessed via Access Program
     D SDMMOD        E DS                  EXTNAME(SDMMODPD)
 
      ** External DS for Dealing Details
     D SDDEAL        E DS                  EXTNAME(SDDEALPD)
 
      ** External DS for SAR Details
     D SCSARD        E DS                  EXTNAME(SCSARDPD)
     D  SCLCD        E                     EXTFLD(LCD)
 
      ** External DS for General Ledger Details
     D SDGELR        E DS                  EXTNAME(SDGELRPD)
     D  QQACC1       E                     EXTFLD(QQACCD)
 
      ** External data structure for FRA/IRS I.C.D. details
     D SDFAIS        E DS                  EXTNAME(SDFAISPD)
 
      ** External DS for Trade Details
     D SDTRAD        E DS                  EXTNAME(SDTRADPD)
     D  QQACC2       E                     EXTFLD(QQACCD)
 
      ** External data structure for Retail details
     D SDRETL        E DS                  EXTNAME(SDRETLPD)
     D  QQACC3       E                     EXTFLD(QQACCD)
 
      ** First DS for Access Programs, short data structure
     D DSFDY         E DS                  EXTNAME(DSFDY)
      **-----------------------------------------------------------------------
      ** Switchable features
     D CDE001          S              1A
     D CEU003          S              1A
     D CIR001          S              1A
     D CIR005          S              1A
     D CIR006          S              1A
     D CIR008          S              1A
     D CAP041          S              1A
     D CAP056          S              1A
     D CSC011          S              1A
     D CIR007          S              1A
     D CCF003          S              1A
     D CSW005          S              1A
 
      ** Other work variables
     D WkScrn          S              1A
     D WkFRun          S              1A
     D WRdNBr          S              1A
     D WPrvScrn        S              1A
     D WPrvDNo         S              6A
     D WPrvACd         S              1A
     D WkMsg1          S              7A
     D WFntKey         S              2A
     D WSavBDC         S             64A
     D PGnDlNo         S              6A
     D PLCcy           S              3A
     D POKFlags        S             25A
     D POKFlags2       S             22A
     D PSucInsDN       S              6A
     D #1STAT          S             24A
     D W#DlNo          S              6  0
     D CANCFM          S              1A
     D E               S              3  0
     D PErrMs          S              7A
 
      ** Mode of operation received from controller
     D ModeOfOp        S              6A
 
      ** Response Mode, passed as a constant parameter to the VAL module
      ** This is always 'S' for Synchronous
     D RespMode        S              1A   INZ('S')
 
      ** Parameters for IRCACFRTV
     D PFOTrId         S             20A
     D PFOAsId         S             20A
 
      ** Parameters for Access Objects
     D POptn           S              7A
     D PSarD           S              6A
 
      ** Parameters for IRCACFRED
     D PRdFwd          S              1A
     D PRdBck          S              1A
     D PDlRed          S              6A
     D PDlTyp          S              2A
     D PSingBrCd       S              3A
      *
     D DSSDY         E DS                  EXTNAME(DSSDY)
      *
     D SDCURR        E DS                  EXTNAME(SDCURRPD)                    BUG5403
      *  Array for Principle change Schedule                                    BUG5403
     D PCSA            S             25A   DIM(600)                             BUG5403
     D PCSAST          S          15000A                                        BUG5403
      *  Principle Change Schedule                                              BUG5403
     D PCHGSCH         DS                                                       BUG5403
     D  PCDATE                        6A                                        BUG5403
     D  PCCHOL                        1A                                        BUG5403
     D  PCAMT                        16A                                        BUG5403
     D  PCIDFLG                       1A                                        BUG5403
     D  PCPDAT                        1A                                        BUG5403
                                                                                BUG5403
     D FORMULAOPC      DS                                                       BUG5403
     D  SFREQFOPC                     1A                                        BUG5403
     D  SFORMOPC                      7A                                        BUG5403
     D  SFORMAMTOPC                  16A                                        BUG5403
     D  SFORMPIDFOPC                  1A                                        BUG5403
                                                                                BUG5403
     D Buffer2         S           3999                                         BUG5403
     D BufferEx2       S           9999                                         BUG5403
                                                                                BUG5403
     D DealNo          S              6  0                                      BUG5403
     D OTInd           S              1                                         BUG5403
     D RatPay          S              1                                         BUG5403
     D ProcDate        S              5  0                                      BUG5403
      ** Array index                                                            BUG5403
     D X               S              3  0                                      BUG5403
     D WONBDP          S                   LIKE(A6NBDP)                         BUG5403
     D WPNBDP          S                   LIKE(A6NBDP)                         BUG5403
     D WRNBDP          S                   LIKE(A6NBDP)                         BUG5403
     D WRSCY           S              3A                                        BUG5403
     D WPSCY           S              3A                                        BUG5403
     D ZFLD15          S             15P 0                                      BUG5403
     D ZDECS           S              1P 0                                      BUG5403
     D ZECODE          S              1                                         BUG5403
     D ZECHAR          S              1                                         BUG5403
     D ZOUT21          S             21                                         BUG5403
     D ZDAYNO          S              5P 0                                                   BUG6377
     D SUINFD          S              6A                                                     BUG6377
     D STINFD          S              6A                                                     BUG6377
                                                                                              CSW213
      ** Work Variables for DLRPIFR                                                           CSW213
     D PRetCode        S             10                                                       CSW213
     D PModeOp         S              6                                                       CSW213
     D PTranRefOK      S              1                                                       CSW213
     D DFOfcrIDOK      S              1                                                       CSW213
     D WNoRepFlag      S              1                                                       CSW213
     D CSW213          S              1                                                       CSW213
      *                                                                                     MD054117
     D PSYSVAL1        C                   CONST('DspPrinInDecInd')                         MD054117
     D PRETURN         S              7A                                                    MD054117
     D POP01           S             20A                                                    MD054117
     D PVL01           S            200A                                                    MD054117
     D POP02           S             20A                                                    MD054117
     D PVL02           S            200A                                                    MD054117
     D POP03           S             20A                                                    MD054117
     D PVL03           S            200A                                                    MD054117
     D POP04           S             20A                                                    MD054117
     D PVL04           S            200A                                                    MD054117
     D POP05           S             20A                                                    MD054117
     D PVL05           S            200A                                                    MD054117
     D POP06           S             20A                                                    MD054117
     D PVL06           S            200A                                                    MD054117
     D POP07           S             20A                                                    MD054117
     D PVL07           S            200A                                                    MD054117
     D POP08           S             20A                                                    MD054117
     D PVL08           S            200A                                                    MD054117
     D POP09           S             20A                                                    MD054117
     D PVL09           S            200A                                                    MD054117
     D POP10           S             20A                                                    MD054117
     D PVL10           S            200A                                                    MD054117
     D PCIDCF          S              1A                                                    MD054117
 
      ** +--- Start of main processing -----------------------------------+
 
     C     *ENTRY        PLIST
     C                   PARM                    AuthComp          1
     C                   PARM                    FwdBck            1
     C                   PARM                    DDDLNO_In         6
     C                   PARM                    Buffer         6000
     C                   PARM                    Buffer2                                     BUG5403
     C                   PARM                    BufferEx2                                   BUG5403
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
     C                   PARM                    MsgFArray
     C                   PARM                    APIRetc           1
 
      ** Get ZMUSER to access default branch                                                 BUG8550
                                                                                             BUG8550
     C     *DTAARA       DEFINE                  ZMUSER                                      BUG8550
     C                   IN        ZMUSER                                                    BUG8550
     C                   UNLOCK    ZMUSER                                                    BUG8550
                                                                                             BUG8550
      * Set up the name of the primary and secondary message files from
      * which the message handler will get the messages
     C                   EVAL      MsgFArray(1) = 'DRSMM'
 
      *  Hook to enable non-core message files to be included
     C/COPY WNCPYSRC,IRCACFM01
      *
     C                   CLEAR                   CrIRFilFmt
     C                   CLEAR                   NwIRScnFmt
     C                   CLEAR                   NwIRScn2Fmt
     C                   CLEAR                   PCSA                           BUG5403
     C                   CLEAR                   PDlRILkpd                                    CSW213
 
      * If the action code is blank, enquire unless authorising
 
     C     #0ACCD        IFEQ      *BLANK
     C     AuthComp      IFEQ      'X'
     C                   MOVEL     'X'           #0ACCD
     C                   ELSE
     C                   MOVEL     'E'           #0ACCD
     C                   ENDIF
     C                   ENDIF
 
     C     FwdBck        IFEQ      'F'
     C                   MOVEL     'Y'           @RDFWD
     C                   MOVEL     'N'           @RDBCK
     C                   ELSE
     C     FwdBck        IFEQ      'B'
     C                   MOVEL     'N'           @RDFWD
     C                   MOVEL     'Y'           @RDBCK
     C                   ELSE
     C                   MOVEL     'N'           @RDFWD
     C                   MOVEL     'N'           @RDBCK
     C                   ENDIF
     C                   ENDIF
 
     C     @RDFWD        IFEQ      'Y'
     C     @RDBCK        OREQ      'Y'
     C                   EXSR      IRCACFRED
     C                   ELSE
     C                   MOVEL     DDDLNO_In     PDlRed
     C                   MOVEL     *BLANK        PErrMs
     C                   ENDIF
      *
      * If deal read and no error message returned
     C                   IF        PErrMs = *BLANK and
     C                             PDlRed <> *Blank
      *
      * Retrieve deal details (all key fields required for call
      * to retrieve module
 
     C                   MOVEL     PDlRed        #0DLNO
 
     C                   EXSR      IRCACFRTV
      *
      * Convert to screen format
     C     Idx           IFEQ      0
     C                   EXSR      IRCACFCVT
     C                   EXSR      ZASETINCVT
      * Calculated Our/Their interest fix dates                                              BUG6377
     C                   EXSR      SrINFDCVT                                                 BUG6377
 
      ** Confirmation matching feedback information
 
     C                   IF        BGCFMT = 'Y' AND CSW005 = 'Y'
     C                             AND CCF003 = 'Y'
     C                   EXSR      SRFEED
     C                   ELSE
     C                   MOVEL     *BLANKS       #0CPTX
     C                   MOVEL     *BLANKS       #0CPST
     C                   MOVEL     *BLANKS       #0BKTX
     C                   MOVEL     *BLANKS       #0BKST
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDIF
                                                                                BUG5403
     C     CIR001        IFEQ      'Y'                                          BUG5403
     C     Idx           ANDEQ     0                                            BUG5403
     C                   EXSR      RetrieveIC                                   BUG5403
     C                   ENDIF                                                  BUG5403
 
     C                   IF        ReturnCode <> *BLANK
     C                   MOVEL     '0'           APIRetc
     C                   MOVEL     '#0DLNO'      FldNameArr(1)
     C                   MOVEL     PErrMs        MsgIDArr(1)
     C                   ENDIF
                                                                                              CSW213
      ** Setup fields in link file if CSW213 is on                                            CSW213
                                                                                              CSW213
     C                   IF        CSW213 = 'Y'                                               CSW213
     C                   EXSR      SRGetRPIF                                                  CSW213
     C                   EVAL      DLRPIFS1Fmt = DLRPIFScn1Fmt                                CSW213
     C                   EVAL      DLRPIFS2Fmt = DLRPIFScn2Fmt                                CSW213
     C                   EVAL      DLRPIFS3Fmt = DLRPIFScn3Fmt                                CSW213
     C                   EVAL      DLRPIFS4Fmt = DLRPIFScn4Fmt                                CSW214
     C                   ENDIF                                                                CSW213
 
     C                   MOVEA     PCSA          PCSAST                         BUG5403
      * Build buffer with required output
     C                   EVAL      Buffer = NwIRScnFmt + NwIRScn2Fmt + InfData
     C                                      + PSRecS + PSPayS
     C**********                            + ExtData + FORMULAOPC + PCSAST     BUG5403      BUG6377
     C                                      + ExtData + SUINFD + STINFD                      BUG6377
     C                                      + #1STAT                                         BUG5871
     C**********                            + FORMULAOPC + PCSAST                     BUG6377 CSW213
     C                                      + FORMULAOPC                                      CSW213
     C                                      + InSwift2013                                     CSW213
     C                                      + PCSAST                                          CSW213
     C**********         EVAL      Buffer2=%SUBST(PCSAST:4857)                  BUG5403      BUG6377
     C**********         EVAL      BufferEx2=%SUBST(PCSAST:7857)                BUG5403      BUG6377
     C**********         EVAL      Buffer2=%SUBST(PCSAST:4845)                         BUG6377CDL028
     C**********         EVAL      BufferEx2=%SUBST(PCSAST:7845)                       BUG6377CDL028
     C**********         EVAL      Buffer2=%SUBST(PCSAST:4801)                        CDL028 BUG6472
     C**********         EVAL      BufferEx2=%SUBST(PCSAST:7801)                      CDL028 BUG6472
     C**********         EVAL      Buffer2=%SUBST(PCSAST:4800)                       BUG6472 BUG5871
     C**********         EVAL      BufferEx2=%SUBST(PCSAST:7800)                     BUG6472 BUG5871
     C**********         EVAL      Buffer2=%SUBST(PCSAST:4776)                      BUG5871 BUG11254
     C**********         EVAL      BufferEx2=%SUBST(PCSAST:7776)                    BUG5871 BUG11254
     C**********         EVAL      Buffer2=%SUBST(PCSAST:4742)                      BUG11254 CSF011A
     C**********         EVAL      BufferEx2=%SUBST(PCSAST:7742)                    BUG11254 CSF011A
     C**********         EVAL      Buffer2=%SUBST(PCSAST:4078)                        CSF011A CSW213
     C**********         EVAL      BufferEx2=%SUBST(PCSAST:8078)                      CSF011A CSW213
     C**********         EVAL      Buffer2=%SUBST(PCSAST:2146)                         CSW213 CSW214
     C**********         EVAL      BufferEx2=%SUBST(PCSAST:6145)                       CSW213 CSW214
     C**********         EVAL      Buffer2=%SUBST(PCSAST:1984)                       CSW214 MD031861
     C**********         EVAL      BufferEx2=%SUBST(PCSAST:5983)                     CSW214 MD031861
     C**********         EVAL      Buffer2=%SUBST(PCSAST:1774)                       MD031861 CSW216
     C**********         EVAL      BufferEx2=%SUBST(PCSAST:5773)                     MD031861 CSW216
     C                   EVAL      Buffer2=%SUBST(PCSAST:1734)                                CSW216
     C                   EVAL      BufferEx2=%SUBST(PCSAST:5733)                              CSW216
 
     C                   SETON                                        LR
     C                   RETURN
      **********************************************************************
     C     IRCACFRED     BEGSR
      *
     C                   CALLB     'IRCACFRED'
 
      ** Input:
      ** Return Code
      ** Action Code
      ** Deal Number pointer
 
     C                   PARM      *BLANK        ReturnCode
     C                   PARM                    #0ACCD
     C                   PARM                    #0DLNO
 
      ** Read Forwards
      ** Read Backwards
      ** Single Branch Code from SDBANKPD
      ** FRA/IRS Deals Authorisation
 
     C                   PARM                    @RDFWD            1
     C                   PARM                    @RDBCK            1
     C                   PARM                    PSingBrCd
     C                   PARM                    CIR008
 
      ** Output:
      ** Error message
      ** Deal read
      ** Deal Type
 
     C                   PARM      *BLANK        PErrMs
     C                   PARM      *BLANK        PDlRed
     C                   PARM      *BLANK        PDlTyp
 
     C                   IF        PDlRed <> *BLANKS
     C                   EVAL      #0DTYP = PDlTyp
     C                   ENDIF
 
     C                   ENDSR
      **********************************************************************
     C     IRCACFRTV     BEGSR
 
     C                   CALLB     'IRCACFRTV'
 
      ** Input:
      ** Return code
      ** Mode = '*FRONT' or *BLANK
      ** Response mode
 
     C                   PARM      *BLANK        ReturnCode
     C                   PARM      '      '      ModeOfOp
     C                   PARM      'S'           RespMode
 
      ** Action Code
      ** Front Office Transaction ID
      ** Front Office Associated Transaction Id
      ** (Midas) Deal Number
      ** (Midas) Associated Deal Number
      ** Booking branch
      ** Deal Type
 
     C                   PARM                    #0ACCD
     C                   PARM                    PFOTrId
     C                   PARM                    PFOAsId
     C                   PARM                    #0DLNO
     C                   PARM                    #0LNKD
     C                   PARM                    #0BRCA
     C                   PARM                    #0DTYP
 
      ** Single Branch Code from SDBANKPD
      ** Default Branch for ZMUSER
      ** Originating Branch/User Validation Required for SDGELRPD
      ** FRA/IRS Authorisation Required
      ** FRA/IRS Re-authorise Amended Deals
      ** FRA/IRS Deals Authorisation
 
     C                   PARM                    BJSBRC
     C                   PARM                    PkDBRC
     C                   PARM                    BKOBUV
     C                   PARM                    BQFIAU
     C                   PARM                    BQFIRA
     C                   PARM                    CIR008
 
      ** Outputs:
      ** Current Deal in File Format
      ** Action Code OK flag
      ** Deal Number OK flag
      ** Deal Type OK flag
 
     C                   PARM                    CrIRFilFmt
     C                   PARM      *BLANK        OKACCD
     C                   PARM      *BLANK        OKDLNO
     C                   PARM      *BLANK        OKBRCA
     C                   PARM      *BLANK        OKDTYP
 
      ** Error arrays
      ** Array index (3P0) from/to caller
 
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
     C                   PARM      *ZERO         Idx
 
 
     C                   ENDSR
      **********************************************************************
     C     IRCACFCVT     BEGSR
 
      * Initialise outputs
 
     C                   MOVEL     *BLANKS       CrIRScnFmt
     C                   MOVEL     *BLANKS       NwIRScnFmt
 
      ** Call program to fill screen fields with data from DEALSDG
 
     C                   CALLB     'IRCACFCVT'
 
      ** -------+
      ** Inputs ¦
      ** -------+
      ** Return Code
      ** Action Code
      ** Transaction record in file format
 
     C                   PARM      *BLANK        ReturnCode
     C                   PARM                    #0ACCD
     C                   PARM                    CrIRFilFmt
 
      ** Business Day Convention
      ** Amortisation of Caps, Collars, Floors and Ind. Compounding Swaps
      ** FRA/IRS Deals Authorisation
 
     C                   PARM                    CIR005
     C                   PARM                    CIR006
     C                   PARM                    CIR008
 
      ** Date Format (from SDBANKPD)
      ** Portfolio Management module (from SDMMODPD)
      ** Decimal Separator (from SDDEALPD)
 
     C                   PARM                    BJDFIN
     C                   PARM                    BGPFMG
     C                   PARM                    BNDCSP
 
      ** --------+
      ** Outputs ¦
      ** --------+
      ** Transaction record in screen format
      ** Deal Status
 
     C                   PARM                    CrIRScnFmt
     C                   PARM      *BLANKS       #1STAT
      ***Sign*of Short Term Rate                                                     BUG5181 BUG6472
     C**********         PARM                    #0SIGN            1                 BUG5181 BUG6472
 
      ** Update 'New' Deal with Deal in Screen Format
 
     C                   MOVEL     CrIRScnFmt    NwIRScnFmt
 
     C                   ENDSR
      **********************************************************************
      /EJECT
      **********************************************************************
     C     ZASETINCVT    BEGSR
 
      ** Set up payment instructions from deal
      ** (on insertions, these fields will be zero/blank)
 
     C                   EVAL      FLPAY = RPPAY
     C                   EVAL      FLPSTM = PSTM
     C                   EVAL      FLPONS = PONS
     C                   EVAL      FLPOBR = POBR
     C                   EVAL      FLCVMR = CVMR
     C                   EVAL      FLPSCY = PSCY
     C                   EVAL      FLIC72 = IC72
 
      ** Set up Receive instructions from deal
      ** (on insertions, these fields will be zero/blank)
 
     C                   EVAL      FLREC = RPREC
     C                   EVAL      FLRSTM = RSTM
     C                   EVAL      FLRONS = RONS
     C                   EVAL      FLROBR = ROBR
     C                   EVAL      FLRSCY = RSCY
 
      ** Set up FRA/IRS specific date
      ** (On insertions, these fields will be zero/blank)
 
     C                   MOVEL     RPIRS         FLIRS
     C                   MOVE      AGVC          FLAGVC
      ** Convert Settlement Details from file to screen format
 
     C                   CALLB     'ZASETINCVT'
 
      ** Inputs:
      ** File Payment Settlement Instruction
      ** File Receipt Settlement Instruction
      ** File FRA/IRS Settlement Instruction
 
     C                   PARM                    PSPayF
     C                   PARM                    PSRecF
     C                   PARM                    PSRsIF
 
      ** Outputs:
      ** Screen Payment Settlement Instruction
      ** Screen Receipt Settlement Instruction
      ** Screen FRA/IRS Settlement Instruction
 
     C                   PARM      *BLANK        PSPayS
     C                   PARM      *BLANK        PSRecS
     C                   PARM      *BLANK        PSRsIS
     C                   PARM      @#0CUCY       INRCCY            3                         CSF011A
     C                   PARM      @#0CUCY       INPCCY            3                         CSF011A
 
      ** Set screen numeric fields to blank, if zero on file
 
     C                   IF        #0ACCD <> 'I'
 
     C                   IF        AGDT = *ZERO
     C                   EVAL      DDAGDT = *BLANKS
     C                   ENDIF
 
     C                   IF        AGVV = *ZERO AND AGVC = *ZERO
     C                   EVAL      DDAGVV = *BLANKS
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDSR
      **********************************************************************
      /EJECT
      *****************************************************************                      BUG6377
      *  SrINFDCVT  - Conversion of calculated interest fix dates     *                      BUG6377
      *****************************************************************                      BUG6377
     C     SrINFDCVT     BEGSR                                                               BUG6377
                                                                                             BUG6377
     C     UINFD         IFNE      0                                                         BUG6377
     C                   EVAL      ZDAYNO =  UINFD                                           BUG6377
     C                   CALLB     'ZDATE2'                                                  BUG6377
     C                   PARM                    ZDAYNO                                      BUG6377
     C                   PARM                    BJDFIN                                      BUG6377
     C                   PARM      *ZEROS        ZDATE                                       BUG6377
     C                   PARM      *BLANKS       ZADATE            7                         BUG6377
     C                   MOVEL     ZDATE         SUINFD                                      BUG6377
     C                   ENDIF                                                               BUG6377
                                                                                             BUG6377
     C     TINFD         IFNE      0                                                         BUG6377
     C                   EVAL      ZDAYNO =  TINFD                                           BUG6377
     C                   CALLB     'ZDATE2'                                                  BUG6377
     C                   PARM                    ZDAYNO                                      BUG6377
     C                   PARM                    BJDFIN                                      BUG6377
     C                   PARM      *ZEROS        ZDATE                                       BUG6377
     C                   PARM      *BLANKS       ZADATE                                      BUG6377
     C                   MOVEL     ZDATE         STINFD                                      BUG6377
     C                   ENDIF                                                               BUG6377
                                                                                             BUG6377
     C                   ENDSR                                                               BUG6377
      *****************************************************************
      *                                                               *
      *  SRFEED - Extract feedback information (Confirmation          *
      *           Matching)                                           *
      *                                                               *
      *****************************************************************
 
     C     SRFEED        BEGSR
 
      ** If Confirmation Matching present, get C/P and Broker Status
 
     C                   EVAL      #0CPTX = *BLANKS
     C                   EVAL      #0CPST = *BLANKS
     C                   EVAL      #0BKTX = *BLANKS
     C                   EVAL      #0BKST = *BLANKS
     C                   EVAL      WKEY1 = 'FI'
     C                   EVAL      WKEY2 = #0DLNO
     C                   EVAL      WKEY3 = '999'
 
     C     WCFKY         SETGT     CFFEEDL0
     C                   READP     CFFEEDL0                               01
 
     C                   MOVEL     CF_IMRF       WTST2             8
 
      ** If no record found or feedback is for different deal, use
      ** default "NO FEEDBACK YET"
 
     C                   IF        *IN01 = *ON
     C                             OR WTST1 <> WTST2
     C                   EVAL      CF_CPSX = *ZERO
     C                   EVAL      CF_BKSX = *ZERO
     C                   ENDIF
 
      ** Counterparty Status
 
     C                   EVAL      #0CPTX = CPBKTxt(1)
     C     CF_CPSX       LOOKUP    TAB1          TAB2                     01
     C                   EVAL      #0CPST = TAB2
 
      ** Broker involved?
 
     C                   IF        #0BRKC <> 'PHON' AND
     C                             #0BRKC <> 'TELX' AND
     C                             #0BRKC <> 'MAIL' AND
     C                             #0BRKC <> 'SWAP'
     C                   EVAL      #0BKTX = CPBKTxt(2)
     C     CF_BKSX       LOOKUP    TAB1          TAB2                     01
     C                   EVAL      #0BKST = TAB2
     C                   ENDIF
 
     C                   ENDSR
      /EJECT                                                                    BUG5403
      *****************************************************************         BUG5403
      *  RetrieveIC - Retrieve IC dates                               *         BUG5403
      *****************************************************************         BUG5403
     C     RetrieveIC    BEGSR                                                  BUG5403
     C                   MOVEL     DDDLNO_In     DealNo                         BUG5403
     C                   EXSR      CheckCurr                                    BUG5403
                                                                                BUG5403
      ** Principle change                                                       BUG5403
     C*****#0ONPCD       IFNE      *BLANKS                                           BUG5403 BUG7046
     C**********         EVAL      OTInd = 'U'                                        BUG5403BUG6386
     C                   EVAL      OTInd = ' '                                               BUG6386
     C                   EVAL      ProcDate = 0                                 BUG5403
     C                   EVAL      X = 1                                        BUG5403
     C     KCFSC         SETLL     DLPCSCD0                                     BUG5403
     C     KCFSCP        READE     DLPCSCD0                               99    BUG5403
     C                   DOW       *IN99 = *OFF                                 BUG5403
     C                   EVAL      PCCHOL = COHO                                BUG5403
     C                   EVAL      PCPDAT = DTPR                                BUG5403
     C                   Z-ADD     0             WAMT             15 0          BUG5403
                                                                                BUG6233
     C**********         IF        BGN2ST = 'Y'                                     BUG6233 MD054117
     C                   IF        PCIDCF = 'Y'                                             MD054117
     C                   IF        CAMT > 0                                     BUG5403
     C                   EVAL      PCIDFLG = 'I'                                BUG5403
     C                   Z-ADD     CAMT          WAMT                           BUG5403
     C                   ELSE                                                   BUG5403
     C                   IF        CAMT < 0                                     BUG5403
     C                   EVAL      PCIDFLG = 'D'                                BUG5403
     C                   Z-SUB     CAMT          WAMT                           BUG5403
     C                   ELSE                                                   BUG5403
     C                   EVAL      PCIDFLG = ' '                                BUG5403
     C                   ENDIF                                                  BUG5403
     C                   ENDIF                                                  BUG5403
     C                   ELSE                                                   BUG6233
     C                   Z-ADD     PAMT          WAMT                           BUG6233
     C                   ENDIF                                                  BUG6233
                                                                                BUG6233
     C                   EVAL      WQ0001 = PRDT                                BUG5403
     C                   EXSR      SRDate2                                      BUG5403
     C                   MOVEL     ZDATE         PCDATE                         BUG5403
     C                   MOVE      WAMT          ZFLD15                         BUG5403
     C                   Z-ADD     21            @@CRET                                       245692
     C**********         CALLB     'ZSEDITF'                                          BUG5403 245692
     C**********         PARM                    ZFLD15                               BUG5403 245692
     C**********         PARM      WONBDP        ZDECS                                BUG5403 245692
     C**********         PARM      *BLANKS       ZECODE                               BUG5403 245692
     C**********         PARM                    ZECHAR                               BUG5403 245692
     C**********         PARM      *BLANKS       ZOUT21                               BUG5403 245692
     C                   CALLB     'ZA1020'                                                   245692
     C                   PARM                    ZFLD15                                       245692
     C                   PARM                    @@CRET            2 0                        245692
     C                   PARM      WONBDP        @@CDP             1 0                        245692
     C                   PARM                    BNDCSP            1                          245692
     C                   PARM                    BNTHSP            1                          245692
     C                   PARM                    ZOUT21           21                          245692
                                                                                BUG5403
     C                   MOVE      ZOUT21        PCAMT                          BUG5403
     C                   EVAL      PCSA(X) = PCHGSCH                            BUG5403
     C                   ADD       1             X                              BUG5403
     C     KCFSCP        READE     DLPCSCD0                               99    BUG5403
     C                   ENDDO                                                  BUG5403
     C**********         ENDIF                                                       BUG5403 BUG7046
     C                   ENDSR                                                  BUG5403
      *****************************************************************         BUG5403
      * CheckCurr - Routine to access currency details                *         BUG5403
      *****************************************************************         BUG5403
     C     CheckCurr     BEGSR                                                  BUG5403
                                                                                BUG5403
      ** Access currency details to get the number of decimal places            BUG5403
     C                   CALL      'AOCURRR0'                                   BUG5403
     C                   PARM      *BLANKS       @RTCD             7            BUG5403
     C                   PARM      '*KEY   '     @OPTN             7            BUG5403
     C                   PARM      #0CUCY        @CYCD             3            BUG5403
     C     SDCURR        PARM      SDCURR        DSSDY                          BUG5403
                                                                                BUG5403
     C                   MOVE      A6NBDP        WONBDP                         BUG5403
      *                                                                         BUG5403
      ** Get decimal places for settlement currencies, if used                  BUG5403
      *                                                                         BUG5403
     C     DDPSCY        IFNE      *BLANK                                       BUG5403
     C                   CALL      'AOCURRR0'                                   BUG5403
     C                   PARM      *BLANKS       @RTCD                          BUG5403
     C                   PARM      '*KEY   '     @OPTN                          BUG5403
     C                   PARM      DDPSCY        @CYCD                          BUG5403
     C     SDCURR        PARM      SDCURR        DSSDY                          BUG5403
                                                                                BUG5403
     C                   MOVE      A6NBDP        WPNBDP                         BUG5403
     C                   MOVE      DDPSCY        WPSCY                          BUG5403
     C                   ELSE                                                   BUG5403
     C                   MOVE      #0CUCY        WPSCY                          BUG5403
     C                   MOVE      WONBDP        WPNBDP                         BUG5403
     C                   ENDIF                                                  BUG5403
      *                                                                         BUG5403
     C     DDRSCY        IFNE      *BLANK                                       BUG5403
     C                   CALL      'AOCURRR0'                                   BUG5403
     C                   PARM      *BLANKS       @RTCD                          BUG5403
     C                   PARM      '*KEY   '     @OPTN                          BUG5403
     C                   PARM      DDRSCY        @CYCD                          BUG5403
     C     SDCURR        PARM      SDCURR        DSSDY                          BUG5403
     C                   MOVE      A6NBDP        WRNBDP                         BUG5403
     C                   MOVE      DDRSCY        WRSCY                          BUG5403
     C                   ELSE                                                   BUG5403
     C                   MOVE      #0CUCY        WRSCY                          BUG5403
     C                   MOVE      WONBDP        WRNBDP                         BUG5403
     C                   ENDIF                                                  BUG5403
      *                                                                         BUG5403
     C                   ENDSR                                                  BUG5403
      *****************************************************************         BUG5403
      *  SRDate2 - Convert date using ZDATE2                          *         BUG5403
      *****************************************************************         BUG5403
     C     SRDate2       BEGSR                                                  BUG5403
                                                                                BUG5403
     C                   CALLB     'ZDATE2'                                     BUG5403
     C                   PARM                    WQ0001            5 0          BUG5403
     C**********         PARM                    ZDATFM            1            BUG5403      BUG7784
     C                   PARM                    BJDFIN                                      BUG7784
     C                   PARM                    ZDATE             6 0          BUG5403
     C                   PARM                    WQ0004            7            BUG5403
                                                                                BUG5403
     C                   ENDSR                                                  BUG5403
 
      *****************************************************************
      /EJECT                                                                                  CSW213
      *****************************************************************                       CSW213
      *                                                               *                       CSW213
      * SRGetRPIF - Set-up Midas DL Transaction Reporting Information *                       CSW213
      *             Link File.                                        *                       CSW213
      *                                                               *                       CSW213
      *****************************************************************                       CSW213
     C     SRGetRPIF     BEGSR                                                                CSW213
                                                                                              CSW213
      ** Set-up input fields                                                                  CSW213
                                                                                              CSW213
     C                   EVAL      PModeOp = ModeofOp                                         CSW213
     C                   EVAL      RLAPID = 'CACF'                                            CSW213
                                                                                              CSW213
     C                   IF        #0ACCD = 'R'                                               CSW213
     C                   EVAL      RLACTN = 'D'                                               CSW213
     C                   ELSE                                                                 CSW213
     C                   EVAL      RLACTN = #0ACCD                                            CSW213
     C                   ENDIF                                                                CSW213
                                                                                              CSW213
     C                   EVAL      RLBRCA = #0BRCA                                            CSW213
     C                   EVAL      RLTRRF = #0DLNO                                            CSW213
     C                   EVAL      RLLTRF = #0LNKD                                            CSW213
     C                   EVAL      RLDTYP = #0DTYP                                            CSW213
     C                   EVAL      RLDLST = #0DLST                                            CSW213
      *                                                                                     MD044506
      ** Change RLVALD from Value Date to Deal Date                                         MD044506
      *                                                                                     MD044506
     C**********         EVAL      RLVALD = #0VDAT                                   CSW213 MD044506
     C                   EVAL      RLVALD = #0DDAT                                          MD044506
      *                                                                                     MD044506
     C                   EVAL      RLCNUM = #0CNUM                                            CSW213
     C                   EVAL      RLBCCY = #0CUCY                                            CSW213
     C                   EVAL      RLSCCY = #0CUCY                                            CSW213
     C                   EVAL      RLFOID = ARFOTRANID                                        CSW213
                                                                                              CSW213
     C                   CALL      'DLRPIFR'                                                  CSW213
                                                                                              CSW213
      ** Return code                                                                          CSW213
                                                                                              CSW213
     C                   PARM      *BLANKS       PRetCode                                     CSW213
                                                                                              CSW213
      ** Mode of operation                                                                    CSW213
                                                                                              CSW213
     C                   PARM                    PModeOp                                      CSW213
                                                                                              CSW213
      ** RPIF Set up fields                                                                   CSW213
                                                                                              CSW213
     C                   PARM                    PDlRILkpd                                    CSW213
                                                                                              CSW213
      ** OUTPUTS                                                                              CSW213
      ** Transaction Reference OK Flag                                                        CSW213
                                                                                              CSW213
     C                   PARM                    PTranRefOK                                   CSW213
                                                                                              CSW213
      ** Front Office ID OK Flag                                                              CSW213
                                                                                              CSW213
     C                   PARM                    DFOfcrIDOK                                   CSW213
                                                                                              CSW213
      ** No Report Information flag                                                           CSW213
                                                                                              CSW213
     C                   PARM                    WNoRepFlag                                   CSW213
                                                                                              CSW213
      ** DLRPIF in File Format                                                                CSW213
                                                                                              CSW213
     C                   PARM                    DLRPIFFileFmt                                CSW213
                                                                                              CSW213
      ** Error fields/message IDs/message data (arrays) from/to caller                        CSW213
                                                                                              CSW213
     C                   PARM                    FldNameArr                                   CSW213
     C                   PARM                    MsgIdArr                                     CSW213
     C                   PARM                    MsgDtaArr                                    CSW213
                                                                                              CSW213
      ** Array index (3P0) from/to caller                                                     CSW213
                                                                                              CSW213
     C                   PARM                    Idx                                          CSW213
                                                                                              CSW213
      ** Warning error fields/message IDs/message data (arrays)                               CSW213
      ** from/to caller                                                                       CSW213
                                                                                              CSW213
     C                   PARM                    WFldNamArr                                   CSW213
     C                   PARM                    WMsgIdArr                                    CSW213
     C                   PARM                    WMsgDtaArr                                   CSW213
                                                                                              CSW213
      ** Warning array index (3P0) from/to caller                                             CSW213
                                                                                              CSW213
     C                   PARM                    WIdx                                         CSW213
                                                                                              CSW213
      ** Report Information File - Screen Format                                              CSW213
                                                                                              CSW213
     C                   PARM                    DLRPIFScn1Fmt                                CSW213
     C                   PARM                    DLRPIFScn2Fmt                                CSW213
     C                   PARM                    DLRPIFScn3Fmt                                CSW213
     C                   PARM                    DLRPIFScn4Fmt                                CSW214
                                                                                              CSW213
     C                   ENDSR                                                                CSW213
      *****************************************************************                       CSW213
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR
 
      ** Initialize program name
 
     C                   MOVEL     'IRCACFR'     DBPGM
 
      ** Get ZMUSER to access default branch
 
     C******DTAARA       DEFINE                  ZMUSER                                      BUG8550
     C**********         IN        ZMUSER                                                    BUG8550
     C**********         UNLOCK    ZMUSER                                                    BUG8550
 
      ** Access Bank Details
 
     C                   CALLB     'AOBANKR0'
     C                   PARM      *BLANKS       ReturnCode
     C                   PARM      '*FIRST '     POptn
     C     SDBANK        PARM      SDBANK        DSFDY
 
     C                   IF        ReturnCode <> *BLANK
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'SDBANKPD'
     C                   EVAL      DBASE  = 1
     C                   EVAL      DBKEY  = POptn
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Access Module Details
      ** (database error handling done in access program)
 
     C                   CALLB     'AOMMODR0'
     C                   PARM      *BLANKS       ReturnCode
     C                   PARM      '*FIRST '     POptn
     C     SDMMOD        PARM      SDMMOD        DSFDY
 
     C                   IF        ReturnCode <> *BLANK
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'SDMMODPD'
     C                   EVAL      DBASE  = 2
     C                   EVAL      DBKEY  = POptn
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Access Dealing Details
      ** (database error handling done in access program)
 
     C                   CALLB     'AODEALR1'
     C                   PARM      *BLANKS       ReturnCode
     C                   PARM      '*FIRST '     POptn
     C     SDDEAL        PARM      SDDEAL        DSSDY
 
     C                   IF        ReturnCode <> *BLANK
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'SDDEALPD'
     C                   EVAL      DBASE  = 3
     C                   EVAL      DBKEY  = POptn
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Access General Ledger details via access program
      ** (database error handling done in access program)
 
     C                   CALLB     'AOGELRR1'
     C                   PARM      *BLANKS       ReturnCode
     C                   PARM      '*FIRST '     POptn
     C     SDGELR        PARM      SDGELR        DSSDY
 
     C                   IF        ReturnCode <> *BLANK
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'SDGELRPD'
     C                   EVAL      DBASE  = 4
     C                   EVAL      DBKEY  = POptn
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Access FRA/IRS ICD details
 
     C                   CALLB     'AOFAISR0'
     C                   PARM      *BLANKS       ReturnCode
     C                   PARM      '*FIRST '     POptn
     C     SDFAIS        PARM      SDFAIS        DSFDY
 
     C                   IF        ReturnCode <> *BLANK
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'SDFAISPD'
     C                   EVAL      DBASE  = 5
     C                   EVAL      DBKEY  = POptn
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Access Tranding Details
 
     C                   CALLB     'AOTRADR0'
     C                   PARM      '*MSG   '     ReturnCode
     C                   PARM      '*FIRST '     POptn
     C     SDTRAD        PARM      SDTRAD        DSFDY
 
     C                   IF        ReturnCode <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'SDTRADPD'
     C                   EVAL      DBASE  = 6
     C                   EVAL      DBKEY  = POptn
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Access Retail details via access program
 
     C                   CALLB     'AORETLR0'
     C                   PARM      *BLANK        ReturnCode
     C                   PARM      '*FIRST '     POptn
     C     SDRETL        PARM      SDRETL        DSFDY
 
     C                   IF        ReturnCode <> *BLANK
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'SDRETLPD'
     C                   EVAL      DBASE  = 7
     C                   EVAL      DBKEY  = POptn
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Access SAR details file to determine EMU Dealing Settlement Ccy
      ** Conversion feature is switched on.
 
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       ReturnCode
     C                   PARM      '*VERIFY'     POptn
     C                   PARM      'CEU003'      PSarD
     C     SCSARD        PARM      SCSARD        DSFDY
 
     C                   IF        ReturnCode <> *BLANKS AND
     C                             ReturnCode <> '*NRF   '
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'SCSARDPD'
     C                   EVAL      DBASE = 8
     C                   EVAL      DBKEY = 'CEU003'
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   IF        ReturnCode = *BLANKS
     C                   EVAL      CEU003 = 'Y'
     C                   ELSE
     C                   EVAL      CEU003 = 'N'
     C                   ENDIF
 
      ** Access SAR details file to determine if Interest Rate Calendar is On
 
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       ReturnCode
     C                   PARM      '*VERIFY'     POptn
     C                   PARM      'CIR001'      PSarD
     C     SCSARD        PARM      SCSARD        DSFDY
 
     C                   IF        ReturnCode <> *BLANKS AND
     C                             ReturnCode <> '*NRF  '
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'SCSARDPD'
     C                   EVAL      DBASE = 9
     C                   EVAL      DBKEY = 'CIR001'
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   IF        ReturnCode = *BLANKS
     C                   EVAL      CIR001 = 'Y'
     C                   ELSE
     C                   EVAL      CIR001 = 'N'
     C                   ENDIF
 
      ** Access SAR details file to determine if FRA/IRS Business Day Convention
      ** is switched on.
 
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       ReturnCode
     C                   PARM      '*VERIFY'     POptn
     C                   PARM      'CIR005'      PSarD
     C     SCSARD        PARM      SCSARD        DSFDY
 
     C                   IF        ReturnCode <> *BLANKS AND
     C                             ReturnCode <> '*NRF  '
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'SCSARDPD'
     C                   EVAL      DBASE = 10
     C                   EVAL      DBKEY = 'CIR005'
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   IF        ReturnCode = *BLANKS
     C                   EVAL      CIR005 = 'Y'
     C                   ELSE
     C                   EVAL      CIR005 = 'N'
     C                   ENDIF
 
      ** Access SAR details file to determine if Amortisation of Caps/Collars/
      ** Floors & Individual Compounding Swaps feature is installed.
 
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       ReturnCode
     C                   PARM      '*VERIFY'     POptn
     C                   PARM      'CIR006'      PSarD
     C     SCSARD        PARM      SCSARD        DSFDY
 
     C                   IF        ReturnCode <> *BLANKS AND
     C                             ReturnCode <> '*NRF  '
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'SCSARDPD'
     C                   EVAL      DBASE = 11
     C                   EVAL      DBKEY = 'CIR006'
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   IF        ReturnCode = *BLANKS
     C                   EVAL      CIR006 = 'Y'
     C                   ELSE
     C                   EVAL      CIR006 = 'N'
     C                   ENDIF
 
      ** Access SAR details file to determine if 24x7 Midas Availability is
      ** switched on
 
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       ReturnCode
     C                   PARM      '*VERIFY'     POptn
     C                   PARM      'CSC011'      PSarD
     C     SCSARD        PARM      SCSARD        DSFDY
 
     C                   IF        ReturnCode <> *BLANKS AND
     C                             ReturnCode <> '*NRF  '
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'SCSARDPD'
     C                   EVAL      DBASE = 12
     C                   EVAL      DBKEY = 'CSC011'
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   IF        ReturnCode = *BLANKS
     C                   EVAL      CSC011 = 'Y'
     C                   ELSE
     C                   EVAL      CSC011 = 'N'
     C                   ENDIF
 
      ** Access SAR details file to determine if CCRM Limits feature is
      ** switched on
 
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       ReturnCode
     C                   PARM      '*VERIFY'     POptn
     C                   PARM      'CDE001'      PSarD
     C     SCSARD        PARM      SCSARD        DSFDY
 
     C                   IF        ReturnCode <> *BLANKS AND
     C                             ReturnCode <> '*NRF  '
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'SCSARDPD'
     C                   EVAL      DBASE = 13
     C                   EVAL      DBKEY = 'CDE001'
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   IF        ReturnCode = *BLANKS
     C                   EVAL      CDE001 = 'Y'
     C                   ELSE
     C                   EVAL      CDE001 = 'N'
     C                   ENDIF
 
      ** Check if APIs for IRS Fees/Buy-Outs/Processing Method/Next
      ** Principal Change Date feature is switched on
 
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       ReturnCode
     C                   PARM      '*VERIFY'     POptn
     C                   PARM      'CAP041'      PSarD
     C     SCSARD        PARM      SCSARD        DSFDY
 
     C                   IF        ReturnCode <> *BLANKS AND
     C                             ReturnCode <> '*NRF  '
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'SCSARDPD'
     C                   EVAL      DBASE = 14
     C                   EVAL      DBKEY = 'CAP041'
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   IF        ReturnCode = *BLANKS
     C                   EVAL      CAP041 = 'Y'
     C                   ELSE
     C                   EVAL      CAP041 = 'N'
     C                   ENDIF
 
      ** Check if FRA/IRS Deals Authorisation is installed
 
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       ReturnCode
     C                   PARM      '*VERIFY'     POptn
     C                   PARM      'CIR008'      PSarD
     C     SCSARD        PARM      SCSARD        DSFDY
 
     C                   IF        ReturnCode <> *BLANKS AND
     C                             ReturnCode <> '*NRF  '
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'SCSARDPD'
     C                   EVAL      DBASE = 15
     C                   EVAL      DBKEY = 'CIR008'
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   IF        ReturnCode = *BLANKS
     C                   EVAL      CIR008 = 'Y'
     C                   ELSE
     C                   EVAL      CIR008 = 'N'
     C                   ENDIF
 
      ** Check if Automatic Authorisation feature is installed
 
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       ReturnCode
     C                   PARM      '*VERIFY'     POptn
     C                   PARM      'CAP056'      PSarD
     C     SCSARD        PARM      SCSARD        DSFDY
 
     C                   IF        ReturnCode <> *BLANKS AND
     C                             ReturnCode <> '*NRF  '
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'SCSARDPD'
     C                   EVAL      DBASE = 16
     C                   EVAL      DBKEY = 'CAP056'
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   IF        ReturnCode = *BLANKS
     C                   EVAL      CAP056 = 'Y'
     C                   ELSE
     C                   EVAL      CAP056 = 'N'
     C                   ENDIF
 
      ** Check if Overnight Index Swaps is installed
 
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       ReturnCode
     C                   PARM      '*VERIFY'     POptn
     C                   PARM      'CIR007'      PSarD
     C     SCSARD        PARM      SCSARD        DSFDY
 
     C                   IF        ReturnCode <> *BLANKS AND
     C                             ReturnCode <> '*NRF  '
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'SCSARDPD'
     C                   EVAL      DBASE = 17
     C                   EVAL      DBKEY = 'CIR007'
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   IF        ReturnCode = *BLANKS
     C                   EVAL      CIR007 = 'Y'
     C                   ELSE
     C                   EVAL      CIR007 = 'N'
     C                   ENDIF
 
      ** Check CSW005
 
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       ReturnCode
     C                   PARM      '*VERIFY'     POptn
     C                   PARM      'CSW005'      PSarD
     C     SCSARD        PARM      SCSARD        DSFDY
 
     C                   IF        ReturnCode = *BLANKS
     C                   EVAL      CSW005 = 'Y'
     C                   ELSE
     C                   EVAL      CSW005 = 'N'
     C                   ENDIF
 
      ** Check CCF003
 
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       ReturnCode
     C                   PARM      '*VERIFY'     POptn
     C                   PARM      'CCF003'      PSarD
     C     SCSARD        PARM      SCSARD        DSFDY
 
     C                   IF        ReturnCode = *BLANKS
     C                   EVAL      CCF003 = 'Y'
     C                   ELSE
     C                   EVAL      CCF003 = 'N'
     C                   ENDIF
                                                                                              CSW213
      ** Check if SWIFT 2013 is on                                                            CSW213
                                                                                              CSW213
     C                   EVAL      CSW213 = *BLANKS                                           CSW213
     C                   CALL      'SWIF2013'                                                 CSW213
     C                   PARM      *BLANKS       ReturnCode                                   CSW213
                                                                                              CSW213
     C                   IF        ReturnCode = 'CSW2013'                                     CSW213
     C                   EVAL      CSW213 = 'Y'                                               CSW213
     C                   ELSE                                                                 CSW213
     C                   EVAL      CSW213 = 'N'                                               CSW213
                                                                                              CSW213
     C                   ENDIF                                                                CSW213
                                                                                              CSW213
                                                                                            MD054117
     C                   CALL      'AOSVALR0'                                               MD054117
     C                   PARM      *BLANKS       PRETURN                                    MD054117
     C                   PARM      PSYSVAL1      POP01                                      MD054117
     C                   PARM      *BLANKS       PVL01                                      MD054117
     C                   PARM      *BLANKS       POP02                                      MD054117
     C                   PARM      *BLANKS       PVL02                                      MD054117
     C                   PARM      *BLANKS       POP03                                      MD054117
     C                   PARM      *BLANKS       PVL03                                      MD054117
     C                   PARM      *BLANKS       POP04                                      MD054117
     C                   PARM      *BLANKS       PVL04                                      MD054117
     C                   PARM      *BLANKS       POP05                                      MD054117
     C                   PARM      *BLANKS       PVL05                                      MD054117
     C                   PARM      *BLANKS       POP06                                      MD054117
     C                   PARM      *BLANKS       PVL06                                      MD054117
     C                   PARM      *BLANKS       POP07                                      MD054117
     C                   PARM      *BLANKS       PVL07                                      MD054117
     C                   PARM      *BLANKS       POP08                                      MD054117
     C                   PARM      *BLANKS       PVL08                                      MD054117
     C                   PARM      *BLANKS       POP09                                      MD054117
     C                   PARM      *BLANKS       PVL09                                      MD054117
     C                   PARM      *BLANKS       POP10                                      MD054117
     C                   PARM      *BLANKS       PVL10                                      MD054117
      *                                                                                     MD054117
     C                   EVAL      PCIDCF = 'N'                                             MD054117
     C                   IF        PRETURN <> *BLANKS                                       MD054117
     C                   EVAL      DBFILE = 'SDSVALPD'                                      MD054117
     C                   EVAL      DBKEY = PSYSVAL1                                         MD054117
     C                   EVAL      DBASE = 18                                               MD054117
     C                   OUT       LDA                                                      MD054117
     C                   EXSR      *PSSR                                                    MD054117
     C                   ENDIF                                                              MD054117
      *                                                                                     MD054117
     C                   MOVEL     PVL01         PCIDCF                                     MD054117
      *                                                                                     MD054117
 
      ** Store local currency
 
     C                   EVAL      PLCcy = BJLCCY
                                                                                BUG5403
      **  Key for DLPCSCPD                                                      BUG5403
     C     KCFSC         KLIST                                                  BUG5403
     C                   KFLD                    DealNo                         BUG5403
     C                   KFLD                    OTInd                          BUG5403
     C                   KFLD                    ProcDate                       BUG5403
      **  Partial Key for DLPCSCPD                                              BUG5403
     C     KCFSCP        KLIST                                                  BUG5403
     C                   KFLD                    DealNo                         BUG5403
     C                   KFLD                    OTInd                          BUG5403
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY sets the values of program, module and
      ** procedure names for database error processing.
      /COPY ZACPYSRC,DBFIELDS
      **--------------------------------------------------------------------------------------------
 
      *  Hook to enable non-core initial processing to be included
      /COPY WNCPYSRC,IRCACFS011
 
      *                                                                                      BUG5731
      ** Initialize ReturnCode prior to exit of *INZSR                                       BUG5731
      *                                                                                      BUG5731
     C                   MOVE      *BLANKS       ReturnCode                                  BUG5731
      *                                                                                      BUG5731
     C                   ENDSR
      *****************************************************************
      ** The following /COPY contains the standard program status
      ** subroutine, excluding a bound call to the DBERRCTL module.
      *********************************************************************
     C/COPY ZACPYSRC,PSSR_ILENE
     C                   RETURN
      *
     C                   ENDSR
      *****************************************************************
**  CPY@
(c) Finastra International Limited 2003
** CPBKTxt - COUNTERPARTY AND BROKER FIELD NARRATIVE
Counterparty Conf
Broker Conf
** (TAB1/TAB2) - COUNTERPARTY AND BROKER STATUS CODES/NARRATIVES
00NO FEEDBACK YET
01WAITING
02TIMED OUT
03SPLIT FM PAIR
50PROPOSED PAIR
51PAIRED ERROR-O
52PAIRED ERROR-T
53PAIRED ERROR-B
54PROPOSED INVEST
55DUPLICATE ERROR
56INVESTIGATION
91CORRECT
92COMPLETE
93CANCEL
97NONE EXPECTED
99PAIRED NO ERROR
