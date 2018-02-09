     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas DL CLS flag changes report')                     *
      *****************************************************************
      *                                                               *
      *  Midas - Dealing Module                                       *
      *                                                               *
      *  DL6318 - CLS Flag Changes Report Program                     *
      *                                                               *
      *  Function:  This is a report program that shows all FX deals  *
      *  (COB)      whose CLS Settlement field was amended from the   *
      *             original intention/default.                       *
      *                                                               *
      *  Called By: DLC6318 - CLS Flag Changes Report                 *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CDL099             Date 06Oct17               *
      *                 CDL094             Date 01Sep14               *
      *                 263556             Date 19Aug14               *
      *                 CER059             Date 19Jul10               *
      *                 CER043             Date 19May08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD031             Date 10Apr06               *
      *                 CDL049             Date 05Jul06               *
      *                 CSD027             Date 09Dec05               *
      *                 CDL038             Date 10May05               *
      *                 CSW037A            Date 02May05               *
      *                 CSD025             Date 11Jan05               *
      *                 CSW037             Date 15Dec04               *
      *                 CSW036             Date 15Dec04               *
      *                 CLE025             Date 20Oct03               *
      *                 CGL029             Date 01Sep03               *
      *                 CDL010             Date 02Aug02               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *                 190095  *CREATE    Date 16Feb01               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CDL099 - Split Value Date (Recompile)                        *
      *  CDL094 - Enhance  Receive Settlement Instructions            *
      *           (Recompiled)                                        *
      *  263556 - Printer line overflow error.  Fix is to adjust the  *
      *           writing of report break for branch.                 *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER043 - German Features LF041-00 New Fields and Defaulting  *
      *           (Recompile)                                         *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CDL049 - Addition of a Reference Rate field (recompile)      *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CDL038 - Extended Deal Sub Type                              *
      *  CSW037A- Additional Field extended to 40 chars (recompile)   *
      *  CSD025 - Customer De-Activation                              *
      *  CSW037 - Additional Field Data on MT300/MT320                *
      *  CSW036 - Dual SWIFT BIC held on Client Details               *
      *  CLE025 - Credit Lines (Recompile)                            *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  CDL010 - Prevent last user that actioned the trade from      *
      *           authorising it.Recompile due to changes in FXDEALPP.*
      *  190095 - CLS Flag Changes Report                             *
      *           (for CDL008 - Continuous Linked Settlement)         *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *    01         End of file for FXDEALL2                        *
      *    37         Multibranching ON                               *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      * *INZSR     - Initialisation routine                           *
      * *PSSR      - Error processing                                 *
      *  Audit     - Audit processing routine                         *
      *  FmtAmt    - Subroutine for ZSEDIT                            *
      *  FmtDate   - Subroutine for ZDATE2                            *
      *  Print     - Print records                                    *
      *  Process   - Process records                                  *
      *  RcdRCF    - Record printer file via RCF                      *
      *  SetFields - Set values for fields routine                    *
      *  Validate  - Validation routine                               *
      *                                                               *
      *    The *INZSR subroutine will only get called automatically   *
      *    on entry to the module the first time it is run            *
      *    (unless you end the program with LR on).  Similarly        *
      *    D-spec initialisation only happens the first time.  Use    *
      *    RESET for subsequent passes.                               *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+

      ** FX deals file
     FFXDEALL2  IF   E           K Disk    Infsr(*PSSR)

      ** CLS flag changes report - Audit
     FDL6318AU  O    E             Printer Infds(SpoolU)

      ** CLS flag changes report - Detail
     FDL6318P1  O    E             Printer Usropn
     F                                     Infds(Spool1)


      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      **
      **------------------------------------------------------------------------
      ** The following /COPY line includes (among others) the LDA layout
      ** and the copyright array definition:
     D/COPY ZACPYSRC,STD_D_SPEC
      **------------------------------------------------------------------------

      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ D-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+

      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS

      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+

      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+

      ** File Information Data Structure for DL6318AU
     D SpoolU          DS
     D  SFileU                83     92
     D  SFNumU               123    124B 0

      ** File Information Data Structure for DL6318P1
     D Spool1          DS
     D  SFile1                83     92
     D  SFNum1               123    124B 0
     D  Oflln1               188    189B 0
     D  Prtln1               367    368B 0

      ** Data structure for Installation control details
     D Rundat        E DS                  Extname(Rundat)

      ** Data structure for Bank details
     D Sdbank        E DS                  Extname(Sdbankpd)

      ** Data structure for Branch details
     D Sdbrch        E DS                  Extname(Sdbrchpd)

      ** Data structure for Customer details
     D Sdcust        E DS                  Extname(Sdcustpd)
     D SdcustDFAC    E                     Extfld(QQDFAC)                                     CGL029

      ** Data structure for Currency details
     D Sdcurr        E DS                  Extname(Sdcurrpd)

      ** Short dummy data structure for access programs
     D Dsfdy         E DS                  Extname(Dsfdy)

      ** Long dummy data structure for access programs
     D Dssdy         E DS                  Extname(Dssdy)

      ** Very long dummy data structure for access programs
     D Dsldy         E DS                  Extname(Dsldy)

      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+

     D WCLS            S              1A
     D WRcdAU          S              1A
     D WOpenP1         S              1A
     D Rqdln1          S              3  0
     D Difln1          S              3  0
     D WBranch         S              3A
     D WDCNO           S              6A
     D WFile           S             10A

     D PRtcd           S              7A
     D POptn           S              7A
     D Parm3A          S              3A
     D Parm10A         S             10A
     D Parm2N          S              2  0
     D Parm5N          S              5  0
     D PKSts           S              7A
     D FWDNB           S              5  0
     D ZDayNo          S              5  0
     D ZDate           S              6  0
     D ZADate          S              7A
     D ZFld15          S             15  0
     D ZECode          S              1A
     D ZOut21          S             21A
     D ZSNum           S              6  0
     D ZSErr           S              1A

      *****************************************************************
      /EJECT
      *****************************************************************

      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+

      *****************************************************************
      * MAIN PROCEDURE                                                *
      *****************************************************************

     C                   Exsr      Process
     C                   Move      *On           *INLR
     C                   Return

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  Process - Record processing routine                          *
      *            Select records that were inserted or amended today *
      *                                                               *
      *****************************************************************

     C     Process       Begsr

     C     *Loval        SETLL     FXDEALL2
     C                   Read      FXDEALJ0                               01

     C                   DOW       *IN01 = *Off

     C                   If        FHLCD = BJRDNB
     C                   Exsr      Validate
     C                   If        WCLS <> FHCLSS
     C                   Exsr      Print
     C                   Endif
     C                   Endif

     C                   Read      FXDEALJ0                               01
     C                   Enddo

      ** If no records were printed, write No Details to Report

     C                   If        WOpenP1 = 'Y'
     C**********         Write     TrailP1                                                    263556
     C                   Exsr      SRP1END                                                    263556
     C                   Close     DL6318P1
     C                   Else
     C                   Write     HeadAU
     C                   Write     NoDtls
     C                   Endif

     C                   Endsr

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  Validate - Validation routine                                *
      *                                                               *
      *****************************************************************

     C     Validate      Begsr

      ** To determine if CLS settlement flag was originally = 'Y' :

     C                   Eval      WCLS = 'Y'

      ** Customer should be CLS-supported and effective date has been
      ** reached by value date of the deal

     C                   MoveL     FHDCNO        Parm10A
     C                   Call      'AOCUSTR1'
     C                   Parm      *Blanks       PRtcd
     C                   Parm      '*KEY   '     POptn
     C                   Parm                    Parm10A
     C                   Parm      *Blanks       PKSts
     C     Sdcust        Parm      Sdcust        Dsldy

     C                   If        PRtcd <> *Blanks
     C     *LOCK         IN        LDA
     C                   Eval      DBFile = 'SDCUSTPD'
     C                   Eval      DBKey = Parm10A
     C                   Eval      DBPgm = 'DL6318    '
     C                   Eval      DBase = 002
     C                   OUT       LDA
     C                   Exsr      Audit
     C                   Endif

     C                   If        BBCLSS <> 'Y'
     C                             Or BBEFDT > FHVDDN
     C                   Eval      WCLS = 'N'
     C                   Endif

      ** Both buy and sell currencies should be CLS-supported and
      ** effective dates have been reached by value date of the deal

     C                   If        WCLS = 'Y'

     C                   Call      'AOCURRR0'
     C                   Parm      *Blanks       PRtcd
     C                   Parm      '*KEY   '     POptn
     C                   Parm      FHCCY1        Parm3A
     C     Sdcurr        Parm      Sdcurr        Dssdy

     C                   If        PRtcd <> *Blanks
     C     *LOCK         IN        LDA
     C                   Eval      DBFile = 'SDCURRPD'
     C                   Eval      DBKey = Parm3A
     C                   Eval      DBPgm = 'DL6318    '
     C                   Eval      DBase = 003
     C                   OUT       LDA
     C                   Exsr      Audit
     C                   Endif

     C                   If        A6CLSC <> 'Y'
     C                             Or A6EFDT > FHVDDN
     C                   Eval      WCLS = 'N'
     C                   Endif

     C                   Call      'AOCURRR0'
     C                   Parm      *Blanks       PRtcd
     C                   Parm      '*KEY   '     POptn
     C                   Parm      FHCCY2        Parm3A
     C     Sdcurr        Parm      Sdcurr        Dssdy

     C                   If        PRtcd <> *Blanks
     C     *LOCK         IN        LDA
     C                   Eval      DBFile = 'SDCURRPD'
     C                   Eval      DBKey = Parm3A
     C                   Eval      DBPgm = 'DL6318    '
     C                   Eval      DBase = 004
     C                   OUT       LDA
     C                   Exsr      Audit
     C                   Endif

     C                   If        A6CLSC <> 'Y'
     C                             Or A6EFDT > FHVDDN
     C                   Eval      WCLS = 'N'
     C                   Endif

     C                   Endif

      ** Value date should be reached by: original entry date
      ** of the deal + eligible date for CLS deals

     C                   If        WCLS = 'Y'

     C                   Call      'AOBRCHR1'
     C                   Parm      *Blanks       PRtcd
     C                   Parm      '*KEY   '     POptn
     C                   Parm      FHDBRC        Parm3A
     C     Sdbrch        Parm      Sdbrch        Dssdy

     C                   If        PRtcd <> *Blanks
     C     *LOCK         IN        LDA
     C                   Eval      DBFile = 'SDBRCHPD'
     C                   Eval      DBKey = Parm3A
     C                   Eval      DBPgm = 'DL6318    '
     C                   Eval      DBase = 005
     C                   OUT       LDA
     C                   Exsr      Audit
     C                   Endif

     C                   CallB     'ZFWDT'
     C                   Parm      ORED          Parm5N
     C                   Parm      A8EDAT        Parm2N
     C                   Parm      *Zero         FWDNB
     C                   Parm                    BJLCCY
     C                   Parm                    BJSLCD

     C                   If        FHVDDN < FWDNB
     C                   Eval      WCLS = 'N'
     C                   Endif

     C                   Endif

      ** Value date should not be back-valued, as compared to original
      ** entry date of the deal

     C                   If        WCLS = 'Y'
     C                   If        ORED > FHVDDN
     C                   Eval      WCLS = 'N'
     C                   Endif
     C                   Endif

     C                   Endsr

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  Print - Print the record if CLS Settlement flag had been     *
      *          amended from the original intention/default          *
      *                                                               *
      *****************************************************************

     C     Print         Begsr

      ** Report break for Branch

     C                   If        WBranch <> FHDBRC
     C                             And *IN37 = *On

     C                   If        WOpenP1 = 'Y'
     C**********         Write     TrailP1                                                    263556
     C                   Exsr      SRP1END                                                    263556
     C                   Else
     C                   Eval      WOpenP1 = 'Y'
     C                   Open      DL6318P1
     C                   Z-Add     SFNum1        ZSNum
     C                   Move      SFile1        WFile
     C                   Exsr      RcdRCF
     C                   Endif

     C                   Eval      RBRCD = FHDBRC
     C                   Call      'AOBRCHR1'
     C                   Parm      *Blanks       PRtcd
     C                   Parm      '*KEY   '     POptn
     C                   Parm      FHDBRC        Parm3A
     C     Sdbrch        Parm      Sdbrch        Dssdy

     C                   If        PRtcd <> *Blanks
     C     *LOCK         IN        LDA
     C                   Eval      DBFile = 'SDBRCHPD'
     C                   Eval      DBKey = Parm3A
     C                   Eval      DBPgm = 'DL6318    '
     C                   Eval      DBase = 006
     C                   OUT       LDA
     C                   Exsr      Audit
     C                   Endif

     C                   Eval      RBRNM = A8BRNM
     C                   Write     HeadP1
     C                   Eval      WBranch = FHDBRC

      ** No report break for Branch

     C                   Else
     C                   Z-Add     1             Rqdln1
     C     Oflln1        Sub       Prtln1        Difln1
     C                   If        Difln1 <= Rqdln1
     C                   Write     HeadP1
     C                   Endif
     C                   Endif

     C                   Exsr      SetFields
     C                   Write     Detail

     C                   Endsr

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SetFields - Set the value of other report fields             *
      *                                                               *
      *****************************************************************

     C     SetFields     Begsr

     C                   Eval      RCUST = FHDCNO
     C                   Eval      RORBR = FHORBR
     C                   Eval      RDLNO = FHDN38
     C                   Eval      RDLTP = FHTYPE
     C                   Eval      RDLST = FHSTYP
     C                   Eval      RCLAS = FHCLAS                                             CDL038
     C                   Eval      REXCH = FHDXRT
     C                   Eval      RCHTP = FHCHTP
     C                   Eval      RCLSS = FHCLSS
     C                   Eval      RCCY1 = FHCCY1
     C                   Eval      RCCY2 = FHCCY2
     C                   Z-Add     FHDDDN        ZDayNo
     C                   Exsr      FmtDate
     C                   Eval      RDDTE = ZADate
     C                   Z-Add     FHVDDN        ZDayNo
     C                   Exsr      FmtDate
     C                   Eval      RVALD = ZADate

     C                   Call      'AOCURRR0'
     C                   Parm      *Blanks       PRtcd
     C                   Parm      '*KEY   '     POptn
     C                   Parm      FHCCY1        Parm3A
     C     Sdcurr        Parm      Sdcurr        Dssdy

     C                   If        PRtcd <> *Blanks
     C     *LOCK         IN        LDA
     C                   Eval      DBFile = 'SDCURRPD'
     C                   Eval      DBKey = Parm3A
     C                   Eval      DBPgm = 'DL6318    '
     C                   Eval      DBase = 005
     C                   OUT       LDA
     C                   Exsr      Audit
     C                   Endif

     C                   Z-Add     FHDBUY        ZFld15
     C                   Exsr      FmtAmt
     C                   Eval      RAMT1 = ZOut21

     C                   Call      'AOCURRR0'
     C                   Parm      *Blanks       PRtcd
     C                   Parm      '*KEY   '     POptn
     C                   Parm      FHCCY2        Parm3A
     C     Sdcurr        Parm      Sdcurr        Dssdy

     C                   If        PRtcd <> *Blanks
     C     *LOCK         IN        LDA
     C                   Eval      DBFile = 'SDCURRPD'
     C                   Eval      DBKey = Parm3A
     C                   Eval      DBPgm = 'DL6318    '
     C                   Eval      DBase = 006
     C                   OUT       LDA
     C                   Exsr      Audit
     C                   Endif

     C                   Z-Add     FHDSEL        ZFld15
     C                   Exsr      FmtAmt
     C                   Eval      RAMT2 = ZOut21

     C                   Endsr

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  Audit - Print audit report                                   *
      *                                                               *
      *****************************************************************

     C     Audit         Begsr

     C                   If        WRcdAU <> 'Y'
     C                   Eval      WRcdAU = 'Y'
     C                   Z-Add     SFNumU        ZSNum
     C                   Move      SFileU        WFile
     C                   Exsr      RcdRCF
     C                   Endif

     C                   Write     HeadAU
     C                   Write     DBError
     C                   Exsr      *PSSR

     C                   Endsr

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  RcdRCF - Register a printer file via RCF                     *
      *                                                               *
      *****************************************************************

     C     RcdRCF        Begsr

     C                   Call      'ZSFILE'
     C                   Parm                    PSEQ
     C                   Parm                    PENTY
     C                   Parm                    WFile
     C                   Parm                    ZSNum
     C                   Parm                    ZSErr

     C                   If        ZSErr = 'Y'
     C                   Move      *On           *INU7
     C                   Move      *On           *INU8
     C                   Move      *On           *INLR
     C                   Return
     C                   Endif

     C                   Endsr

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  FmtDate - Subroutine for ZDATE2                              *
      *                                                               *
      *****************************************************************

     C     FmtDate       Begsr

     C                   CallB     'ZDATE2'
     C                   Parm                    ZDayNo
     C                   Parm                    BJDFIN
     C                   Parm      *Zero         ZDate
     C                   Parm      *Blanks       ZADate

     C                   Endsr

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  FmtAmt - Subroutine for ZSEDIT                               *
      *                                                               *
      *****************************************************************

     C     FmtAmt        Begsr

     C                   Call      'ZSEDIT'
     C                   Parm                    ZFld15
     C                   Parm                    A6NBDP
     C                   Parm      'J'           ZECode
     C                   Parm      *Blanks       ZOut21

     C                   Endsr

      *****************************************************************
      /EJECT
      *****************************************************************                       263556
      *                                                               *                       263556
      *  SRP1END - Subroutine to Write End of Branch.                 *                       263556
      *                                                               *                       263556
      *****************************************************************                       263556
      *                                                                                       263556
     C     SRP1END       BEGSR                                                                263556
      *                                                                                       263556
      ** Check that sufficient lines remain for the Format. If not,                           263556
      ** write out the Main Headings on a new page.                                           263556
      *                                                                                       263556
     C                   Z-ADD     4             RQDLN1                                       263556
     C     OFLLN1        SUB       PRTLN1        DIFLN1                                       263556
     C     DIFLN1        IFLE      RQDLN1                                                     263556
     C                   WRITE     HEADP1                                                     263556
     C                   ENDIF                                                                263556
      *                                                                                       263556
      ** Write out trailer format.                                                            263556
      *                                                                                       263556
     C                   WRITE     TRAILP1                                                    263556
      *                                                                                       263556
     C                   ENDSR                                                                263556
      *                                                                                       263556
      *****************************************************************                       263556
      /EJECT                                                                                  263556
      *****************************************************************
      *                                                               *
      * *Inzsr - Program Initialisation routine                       *
      *                                                               *
      *****************************************************************

     C     *Inzsr        Begsr

      ** Entry parameters

     C     *Entry        PLIST
     C                   Parm                    PSEQ              5
     C                   Parm                    PLEVL             1
     C                   Parm                    PENTY             3

      ** Multibranching indicator

     C     *Dtaara       Define                  Rundat
     C                   IN        Rundat

     C                   If        AGMBIN = 'Y'
     C                   Move      *On           *IN37
     C                   Endif

      ** Access bank details

     C                   Call      'AOBANKR0'
     C                   Parm      *Blanks       PRtcd
     C                   Parm      '*FIRST '     POptn
     C     Sdbank        Parm      Sdbank        Dsfdy

     C                   If        PRtcd <> *Blanks
     C     *LOCK         IN        LDA
     C                   Eval      DBFile = 'SDBANKPD'
     C                   Eval      DBKey = POptn
     C                   Eval      DBPgm = 'DL6318    '
     C                   Eval      DBase = 001
     C                   OUT       LDA
     C                   Exsr      Audit
     C                   Endif

      ** Initialise work fields

     C                   Eval      Prtln1 = *Zero
     C                   Eval      WRcdAU = 'N'
     C                   Eval      WOpenP1 = 'N'
     C                   Eval      WBranch = *Blanks

     C                   Endsr

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *PSSR  - Program exception error routine                      *
      *                                                               *
      *****************************************************************

     C     *PSSR         Begsr

     C                   Eval      *INU7 = *On
     C                   Eval      *INU8 = *On
     C                   Eval      *INLR = *On

     C                   Close     DL6318AU
     C                   If        WOpenP1 = 'Y'
     C                   Close     DL6318P1
     C                   Endif

     C                   Dump
     C                   Return

     C                   Endsr

      ********************************************************************
**  CPY@
(c) Finastra International Limited 2001
