     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2008')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD Exemption Threshold Extract')                 *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SD000791 - Midas SD Exemption Threshold Extract              *
      *                                                               *
      *  Function:  This program generate tape file format            *
      *                                                               *
      *  (c) Finastra International Limited 2008                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CER071             Date 01Aug16               *
      *                 CER070             Date 19Aug14               *
      *                 CLE134             Date 01Aug12               *
      *                 CER059             Date 19Jul10               *
      *                 CER045             Date 20Jul09               *
      *                 BUG25416           Date 12Aug09               *
      *                 BUG25045           Date 27Jul09               *
      *                 BUG23732           Date 23Apr09               *
      *                 BUG22879           Date 26Feb09               *
      *                 BUG22529           Date 10Feb09               *
      *                 CER048  *CREATE    Date 19May08               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CER071 - BAIS - Legal Form field (Recompile)                 *
      *  CER070 - BuBa Reporting / BAIS V.1.16.0 (Recompile)          *
      *  CLE134 - Past Due Call Loan Processing (Recompile)           *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER045 - German Features - Reporting Bundesbank (Recompile)  *
      *  BUG25416 - Exemption Threshold Extract does not contain data *
      *             from Previous Tax Year                            *
      *  BUG25045 - Exemption Threshold Extract years says 2009       *
      *  BUG23732 - Joint Account threshold (Recompile)               *
      *  BUG22879 - Component SDC000791 failed                        *
      *  BUG22529 - Global Additional Customer Details (Recompile)    *
      *  CER048 - German Features - Taxes                             *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  F U N C T I O N   O F   I N D I C A T O R S                  *
      *  ===========================================                  *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E   I N D E X                              *
      *  ===============================                              *
      *                                                               *
      *  Printing routines:                                           *
      *  ------------------                                           *
      *  SRWthd - Write Heading branch of the tape file               *
      *  SRWbhd - Write Branch header of treated branch               *
      *  SRWbdt - Write Branch detail (applicant)                     *
      *  SRWbtr - Write branch trailer of treated branch              *
      *  SRDltLbl - Left align field                                  *
      *                                                               *
      *  Printing routines:                                           *
      *  ------------------                                           *
      *  SRRcFau - RCF routine : open SD000791AU spool                *
      *  SRRcFp1 - RCF routine : open SD000791P1 spool                *
      *  SRRcFp2 - RCF routine : open SD000791P2 spool                *
      *  SRAudit - Data base error : print SD000791AU details         *
      *                                                               *
      *  Miscellaneous  routine:                                      *
      *  -----------------------                                      *
      *  SRFlbc - Subroutine to fill array BRCD with all branches     *
      *           of SDBRCHPD                                         *
      *                                                               *
      *  Standard RPG routines:                                       *
      *  ----------------------                                       *
      *  *INZSR - Program Initialisation                              *
      *  *PSSR  - Program Error Processing Subroutine                 *
      *                                                               *
      *****************************************************************
      *
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      *
      ** Customer with active Withholding tax exemption
      *
     FSDCUSTLB  IF   E           K DISK    INFSR(*PSSR)
     F                                     PREFIX(B1)
      *
      ** Customer with active Withholding tax exemption
      *
     FSDACUSL1  IF   E           K DISK    INFSR(*PSSR)
      *                                                                                     BUG22879
      ** Customer with active Withholding tax exemption                                     BUG22879
      *                                                                                     BUG22879
     FSDGELRPD  IF   E             DISK    INFSR(*PSSR)                                     BUG22879
      *
      ** Midas SD History File of DTA
      *
     FSDDTAHL0  UF A E           K DISK
      *
      ** File to write on support
      *
     FSDSADVPD  O    F  450        DISK    USROPN
      *
      ** GWT901 Header file
      *
     FSDINPHL1  IF   E           K DISK
      *
      ** Midas SD Exemption Threshold Extract - Audit
      *
     FSD000791AUO    E             PRINTER INFDS(SPOOLU)
      *
      ** Midas SD Exemption Threshold Extract - Detail
      *
     FSD000791P1O    F  132        PRINTER INFDS(SPOOL1)
     F                                     USROPN
      *
      ** Midas SD Exemption Threshold Extract - Detail
      *
     FSD000791P2O    F  132        PRINTER INFDS(SPOOL2)
     F                                     USROPN
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      *
      ** Standard D-specs
      ** ================
      *
      ** The following /COPY line includes the LDA layout,
      ** the copyright array definition,
      ** and the following named constants:
      **    True       logical = *on (for indcator processing)
      **    False      logical = *off (for indicator processing)
      **    DBErrCtl   10A     = 'DBERRCTL' (the name of the database
      **                                     handler)
      ** and the following variables:
      **    RunBefore  1A (for the PSSR)
      *
     D/COPY ZACPYSRC,STD_D_SPEC
      *
      ** Program Status Data Structure
      ** =============================
      ** The following /COPY line includes all the defined fields in
      ** the PSDS.  They have meaningful names, prefixed by 'PS'.
      *
     D/COPY ZACPYSRC,PSDS
      *
      ** The following /COPY line includes the definitions for error
      ** and warning message arrays.
      *
     D/COPY ZACPYSRC,ERR_ARRAYS
      *
      ** The following /COPY includes the MM standard declares:
      *
     D/COPY ZACPYSRC,STDDECLARE
      *
      ** The following /COPY line includes the definitions for arrays
      ** specific to error handling
      *
     D/COPY ZACPYSRC,ERR_XARRYS
      ** +--------------------------------------+
      ** ¦ End of automatically included D-specs¦
      ** ¦ =====================================¦
      ** +--------------------------------------+
      *
      ** +--------------------------------------+
      ** ¦ D-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      *
     D ArrTmp          S              1A   DIM(70)
      *
      ** Define Arrays for branches code
      *
     D ArrABCD         S              3A   DIM(200)
      *
     D SPOOL1          DS
      *
      ** File Information Data Structure for SD000791P1.
      *
     D  SFile1                83     92
     D  SfNum1               123    124B 0
     D  OfLln1               188    189B 0
     D  PrtLn1               367    368B 0
      *
     D SPOOL2          DS
      *
      ** File Information Data Structure for SD000791P2.
      *
     D  SFile2                83     92
     D  SfNum2               123    124B 0
     D  OfLln2               188    189B 0
     D  PrtLn2               367    368B 0
      *
     D SPOOLU          DS
      *
      ** File Information Data Structure for SD000791AU.
      *
     D  SFileU                83     92
     D  SfNumU               123    124B 0
      *
      ** WORK Parameter
      *
     D PBrch           DS
     D  WhBrcd                 1      3
     D  BRCD                          3    DIM(32)
     D  ZBrcd                  4     99
      *
     D WCrtDat         DS
     D  WCrtDy                 1      4  0
     D  WCrtDm                 5      6  0
     D  WCrtDD                 7      8  0
      *
     D WDate           DS
     D  WDay                   1      2  0
     D  WMonth                 3      4  0
     D  WYear                  5      6  0
      *
      ** WORK DATE IN FORMAT DDMMYYYY
      *
     D WwDMY           DS
     D  WwDMYY                 1      4  0
     D  WwDMYM                 5      6  0
     D  WwDMYD                 7      8  0
      *
      ** BIRTHDAY OF APPLICANT
      *
     D WbDat1          DS
     D  WbDat1Y                1      4  0
     D  WbDat1M                5      6  0
     D  WbDat1D                7      8  0
      *
      ** BIRTHDAY OF APPLICANT'S SPOUSE
      *
     D WbDat2          DS
     D  WbDat2Y                1      4  0
     D  WbDat2M                5      6  0
     D  WbDat2D                7      8  0
      *
      ** User default data structure (DBRN : Default branch)
      *
     D ZMUSER        E DS                  EXTNAME(ZMUSER)
      *
      ** Dummy Data Structures used by Access Programs.
      *
     D DSFDY         E DS                  EXTNAME(DSFDY)
      *
      ** DS for access programs, long data structure
      *
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      *
      ** Location Code Details Data Structure
      *
     D SDLOCN        E DS                  EXTNAME(SDLOCNPD)
      *
      ** External data structures for Bank Details
      *
     D SDBRCH        E DS                  EXTNAME(SDBRCHPD)
      *
      ** Externally described DS for Country code details
      *
     D SDCTRY        E DS                  EXTNAME(SDCTRYPD)
      *
      ** Non-a/c Holder Details Data Structure
      *
     D SDNAHO        E DS                  EXTNAME(SDNAHOPD)
      *
      ** Data Structure for Additional Customer Details
      *
     D SDACUS        E DS                  EXTNAME(SDACUSPD)
     D                                     PREFIX(B2)
      *
      ** Data Structure for Additional Customer Details
      *
     D SDACUS3       E DS                  EXTNAME(SDACUSPD)
     D                                     PREFIX(B3)
      *
      ** Long Data Structure
      *
     D DSLDY         E DS                  EXTNAME(DSLDY)
      *
      ** New Variables
      *
     D PCnCd           S              2A
     D PLocn           S              3A
     D FYEAR           S              5P 0
     D FPYEA           S              5P 0
     D WCpy2           S             80A
     D CntBrc          S              3P 0
     D PRtcd           S              7A
     D POptn           S              7A
     D POption         S              7A
     D PBranch         S              3A
     D PCustNo         S              6A
     D PNaho           S             10A
     D WHbIcn          S              6A
     D PtNAM1          S             70A
     D PtSTR           S             35A
     D PtPLZ           S             10A
     D PtORT           S             35A
     D PCntCus         S              7P 0
     D WdrFrm          S              2P 0
     D KnCust          S              6A
     D WFuUth          S             10P 2
     D WExth           S              5P 0
     D WWistr          S             70A
     D WNam1           S             70A
     D WbMnMs          S             45A
     D WbSnMs          S             70A
     D WbTtLs          S             35A
     D Wn              S              2P 0
     D WWostr          S             70A
     D PSeq            S              5A
     D PRunYe          S              1A
     D PFirsYr         S              5  0                                                  BUG25416
     D KDaty           S              4P 0
     D Kbrc            S              3A
     D KyBrcd          S              3A
     D KyCust          S              6A
     D WrTcd           S              7A
     D WOptn           S              7A
     D KeUsr           S             10A
     D WRqdLn1         S              3P 0
     D WDifLn1         S              3P 0
     D WRqdLn2         S              3P 0
     D WDifLn2         S              3P 0
     D Wi              S              3P 0
     D Wx              S              3P 0
     D ZSnumU          S              6P 0
     D ZSnum           S              6P 0
     D PSeq1           S              5A
     D PSenty          S              3A
     D PSerr           S              1A
     D PageP1          S              7P 0
     D PageP2          S              7P 0
     D WRun            S              1A
     D WDbSp           S              8P 0
     D WDbcus          S              8P 0
     D WBlCd           S              8A   INZ(*BLANKS)
      *
      ** Parameter for ZDATE1
      *
     D PDateIn         S              6A
     D PDayNoOut       S              5P 0
     D PErrorFlag      S              1A
      *
      ** Parameter for ZDATE2
      *
     D PDayNo          S              5P 0
     D PDate           S              6P 0
     D PADate          S              7A
      *                                                                                     BUG25045
      ** BUG25045 Fields                                                                    BUG25045
      *                                                                                     BUG25045
     D WRDNB           S              6A                                                    BUG25045
     D WDNWB           S              6A                                                    BUG25045
     D WETXY           S              6A                                                    BUG25045
     D WYearC          S              2A                                                    BUG25045
     D WYearN          S              2S 0                                                  BUG25045
     D PDtFmt          S              1A                                                    BUG25045
      *
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +--- Start of Main processing -------------------------------+
      ** ¦                                                            ¦
      ** ¦ Initial processing is performed automatically: the         ¦
      ** ¦ *INZSR is executed at program activation.                  ¦
      ** ¦                                                            ¦
      ** +------------------------------------------------------------+
      *
      *****************************************************************
      *          P R O G R A M    S T A R T                           *
      *****************************************************************
      *
     C                   OPEN      SDSADVPD
      *
      ** Reset working field : CNTBRC : Count of branch reported
      *
     C                   EVAL      CntBrc = 0
      *
      ** Access Branch internal customer to Write Tape Header
      *
     C                   EXSR      SRWthd
      *
      ** Access Arrays to know which branch to report
      *
     C     1             DO        Wi            Wx
      *
     C                   MOVE      ArrABCD(Wx)   WuBrcd
      *
      ** Write header for treated branch
      *
     C                   EXSR      SRWbhd
      *
      ** Write details for customers of the branch
      *
     C                   EXSR      SRWbdt
      *
      ** Write trailer of the branch
      *
     C                   EXSR      SRWbtr
      *
     C                   ENDDO
      *
      ** Write tape file trailer
      *
     C                   EXCEPT    SDSADVP10
      *
      ** Write heading branch trailer in summary file SD000791P2
      *
     C                   EVAL      WRqdLn2 = 6
     C                   EVAL      WDifLn2 = OfLln2 - PrtLn2
      *
     C                   IF        WDifLn2 <= WRqdLn2
      *
     C                   EVAL      PageP2 = PageP2 + 1
     C                   EXCEPT    SD000791H1
      *
     C                   ENDIF
      *
     C                   EXCEPT    SD000791T1
      *
      ** Close opened files
      *
     C                   CLOSE     SDSADVPD
     C                   CLOSE     SD000791P1
     C                   CLOSE     SD000791P2
      *
     C                   EVAL      *INLR = *ON
     C                   RETURN
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRWthd - Write Heading branch of the tape file               *
      *                                                               *
      *  Called by : MAIN processing                                  *
      *                                                               *
      *  Calls : *PSSR, SRRcFp2                                       *
      *                                                               *
      *****************************************************************
      *
     C     SRWthd        BEGSR
      *
      ** Access heading branch description to retrieve branch
      ** internal cust.
      *
     C                   CALL      'AOBRCHR0'
     C                   PARM      *BLANKS       PRtcd
     C                   PARM      '*KEY   '     POption
     C                   PARM      WhBrcd        PBranch
     C     SDBRCH        PARM      SDBRCH        DSFDY
      *
     C                   IF        PRtcd <> *BLANKS
      *
     C     *LOCK         IN        LDA
     C                   EVAL      DBASE = 04
     C                   EVAL      DBFILE = 'SDBRCHPD'
     C                   EVAL      DBKEY = 'HEADER ' + WhBrcd
      *
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
      *
     C                   OUT       LDA
     C                   EXSR      *PSSR
      *
     C                   ENDIF
      *
     C                   EVAL      WHbIcn = A8BICN
      *
      ** Get Street and address of the branch
      *
     C                   CALL      'AOACUSR0'
     C                   PARM      *BLANKS       PRtcd
     C                   PARM      '*KEY   '     POption
     C                   PARM      WHbIcn        PCustNo
     C     SDACUS3       PARM      SDACUS3       DSLDY
      *
     C                   IF        PRtcd <> *BLANKS
     C     *LOCK         IN        LDA
      *
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
      *
     C                   EVAL      DBASE = 05
     C                   EVAL      DBFILE = 'SDACUSPD'
     C                   EVAL      DBKEY = WHbIcn
     C                   EVAL      DBPGM = 'SD000791'
     C                   OUT       LDA
     C                   EXSR      *PSSR
      *
     C                   ENDIF
      *
     C                   IF        B3E5CNA1 = *BLANKS AND
     C                             B3E5CNA3 = *BLANKS AND
     C                             B3E5ZIPC = *BLANKS AND
     C                             B3E5BTHT = *BLANKS
      *
     C     *LOCK         IN        LDA
      *
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
      *
     C                   EVAL      DBASE = 06
     C                   EVAL      DBFILE = 'SDACUSPD'
     C                   EVAL      DBKEY = WHbIcn
     C                   EVAL      DBPGM = 'SD000791'
     C                   OUT       LDA
     C                   EXSR      *PSSR
      *
     C                   ENDIF
      *
     C                   EVAL      WCrtDD = UDAY
     C                   EVAL      WCrtDm = UMONTH
      *
      ** Expand UYEAR to a 4-digit year number
      *
     C                   EVAL      WCrtDy = UYEAR
      *
     C                   IF        UYEAR < 50
     C                   EVAL      WCrtDy = WCrtDy + 2000
     C                   ELSE
     C                   EVAL      WCrtDy = WCrtDy + 1900
     C                   ENDIF
      *
     C                   EXCEPT    SDSADVP1
      *
      ** Keep Branch internal customer detail for tape file trailer.
      *
     C                   EVAL      PtNAM1 = B3E5CNA1
     C                   EVAL      PtSTR = B3E5CNA3
     C                   EVAL      PtPLZ = B3E5ZIPC
     C                   EVAL      PtORT = B3E5BTHT
      *
      ** Write Header in summary file SD000791
      *
     C                   EXSR      SRRcFp2
     C                   EXCEPT    SD000791H1
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRWbhd - Write Branch header record                          *
      *           Based on treated branch internal customer           *
      *                                                               *
      *  Called by : MAIN processing                                  *
      *                                                               *
      *  Calls : *PSSR, SRZDate2, SRRcFp1                             *
      *                                                               *
      *****************************************************************
      *
     C     SRWbhd        BEGSR
      *
      ** Access treated branch description to retrieve branch
      ** internal cust.
      *
     C                   CALL      'AOBRCHR0'
     C                   PARM      *BLANK        PRtcd
     C                   PARM      '*KEY   '     POption
     C                   PARM      WuBrcd        PBranch
     C     SDBRCH        PARM      SDBRCH        DSFDY
      *
     C                   IF        PRtcd <> *BLANKS
      *
     C     *LOCK         IN        LDA
     C                   EVAL      DBASE = 7
     C                   EVAL      DBFILE = 'SDBRCHPD'
     C                   EVAL      DBKEY = 'TREATED ' + WuBrcd
      *
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
      *
     C                   OUT       LDA
     C                   EXSR      *PSSR
      *
     C                   ENDIF
      *
      ** Get Street, Zip Code and Place of the branch
      ** currently treated
      *
     C                   CALL      'AOACUSR0'
     C                   PARM      *BLANKS       PRtcd
     C                   PARM      '*KEY   '     POption
     C                   PARM      A8BICN        PCustNo
     C     SDACUS3       PARM      SDACUS3       DSLDY
      *
     C                   IF        PRtcd <> *BLANKS
     C     *LOCK         IN        LDA
      *
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
      *
     C                   EVAL      DBASE = 8
     C                   EVAL      DBFILE = 'SDACUSPD'
     C                   EVAL      DBKEY = A8BICN
     C                   EVAL      DBPGM = 'SD000791'
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C     WuBrcd        SETLL     SDCUSTLB
      *
     C                   EVAL      WBlCd = *BlANKS
     C                   DOU       %EOF(SDCUSTLB)
     C     WuBrcd        READE     SDCUSTLB
     C                   IF        B1BBCUST <> A8BICN
     C                   ITER
     C                   ELSE
     C                   EVAL      WBlCd   = B1BBBLCD
     C     *LOVAL        SETLL     SDCUSTLB
     C                   LEAVE
     C                   ENDIF
     C                   ENDDO
      *
     C                   IF        B3E5CNA1 = *BLANKS AND
     C                             B3E5CNA3 = *BLANKS AND
     C                             B3E5ZIPC = *BLANKS AND
     C                             B3E5BTHT = *BLANKS
      *
     C     *LOCK         IN        LDA
      *
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
      *
     C                   EVAL      DBASE = 9
     C                   EVAL      DBFILE = 'SDACUSPD'
     C                   EVAL      DBKEY = A8BICN
     C                   EVAL      DBPGM = 'SD000791'
     C                   OUT       LDA
     C                   EXSR      *PSSR
      *
     C                   ENDIF
      *
      ** Increment + 1 the branch counter
      *
     C                   EVAL      CntBrc = CntBrc + 1
      *
     C                   EVAL      *IN98 = *OFF
      *
      ** If is not an EOY Run then take Previous EOY
      *
     C                   IF        PRunYe <> 'Y'
     C**********         IF        %Subst(WETXY:1:4) >                             BUG25045 BUG25416
     C**********                   %Subst(WRDNB:1:4)                               BUG25045 BUG25416
     C**********         EVAL      PDayNo = FYEAR                                  BUG24045 BUG25416
     C**********         ELSE                                                      BUG25045 BUG25416
     C**********         EVAL      PDayNo = FPYEA                                           BUG25416
     C**********         ENDIF                                                     BUG25045 BUG25416
      *                                                                                     BUG25416
      ** If not First day, use Current year, otherwise, use Previous yr                     BUG25416
     C                   IF        PFirsYr = BJRDNB                                         BUG25416
     C                   EVAL      PDayNo = FPYEA                                           BUG25416
     C                   ELSE                                                               BUG25416
     C                   EVAL      PDayNo = FYEAR                                           BUG25416
     C                   ENDIF                                                              BUG25416
      *                                                                                     BUG25416
     C                   ELSE
     C**********         EVAL      PDayNo = BJRDNB                                          BUG25416
     C                   EVAL      PDayNo = FYEAR                                           BUG25416
     C                   ENDIF
      *
     C                   EVAL      PDtFmt = BJDFIN                                          BUG25045
     C                   EXSR      SRZDate2
     C                   MOVE      PDate         WDate
      *
      ** Expand date format from yy to yyyy
      *
     C                   EVAL      KDaty = WYear
     C                   IF        WYear > 50
     C                   EVAL      KDaty = KDaty + 1900
     C                   ELSE
     C                   EVAL      KDaty = KDaty + 2000
     C                   ENDIF
      *
     C                   EVAL      Kbrc = WuBrcd
      *
     C     KyKedt        CHAIN     SDDTAHL0
     C                   IF        NOT %FOUND(SDDTAHL0)
      *
     C                   MOVE      KDaty         FHYEAR
     C                   MOVE      Kbrc          FHBRCH
     C                   MOVE      '00'          FHLSEQ
     C                   MOVE      KeUsr         FHUSER
     C                   MOVE      WCrtDat       FHDATE
     C                   WRITE     SDDTAHD0
      *
     C                   ELSE
      *
      ** Find last record
      *
     C     KyKedt        SETGT     SDDTAHL0
     C                   READP     SDDTAHL0
     C                   IF        %EOF(SDDTAHL0)
     C     *LOCK         IN        LDA
      *
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
      *
     C                   EVAL      DBASE = 10
     C                   EVAL      DBFILE = 'SDDTAHL0'
     C                   MOVE      KDaty         DBKEY
     C                   EVAL      DBKEY = DBKEY + ' ' + Kbrc
     C                   EVAL      DBPGM = 'SD000791'
     C                   OUT       LDA
     C                   EXSR      *PSSR
      *
     C                   ELSE
     C                   IF        FHYEAR <> KDaty AND
     C                             FHBRCH <> Kbrc
     C     *LOCK         IN        LDA
      *
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
      *
     C                   EVAL      DBASE = 11
     C                   EVAL      DBFILE = 'SDDTAHL0'
     C                   MOVE      KDaty         DBKEY
     C                   EVAL      DBKEY = DBKEY + ' ' + Kbrc
     C                   EVAL      DBPGM = 'SD000791'
     C                   OUT       LDA
     C                   EXSR      *PSSR
      *
     C                   ELSE
      *
      ** If a record is found go to the last one to obtain
      ** the last seq number and write the new record with
      ** a seq num = last seq num + 1
      *
     C                   EVAL      FHLSEQ = FHLSEQ + 1
     C                   MOVE      KeUsr         FHUSER
     C                   MOVE      WCrtDat       FHDATE
     C                   WRITE     SDDTAHD0
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
      *
     C                   EXCEPT    SDSADVP4
      *
      ** Write header in audit file SD000791P1
      *
     C                   EXSR      SRRcFp1
     C                   EXCEPT    SD000791H0
      *
      ** Write header in summary file SD000791P2
      *
     C                   EVAL      WRqdLn2 = 4
     C                   EVAL      WDifLn2 = OfLln2 - PrtLn2
     C                   IF        WDifLn2 <= WRqdLn2
     C                   EVAL      PageP2 = PageP2 + 1
     C                   EXCEPT    SD000791H1
     C                   ENDIF
      *
     C                   EXCEPT    SD000791B1
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SRWbdt - Write Branch details                                *
      *           Based on customer of the branch                     *
      *                                                               *
      *  Called by : MAIN processing                                  *
      *                                                               *
      *  Calls : *PSSR                                                *
      *                                                               *
      *****************************************************************
      *
     C     SRWbdt        BEGSR
      *
      ** Reset working fields : PCntCus : total of customer treated
      *
     C                   EVAL      PCntCus = 0
      *
     C     WuBrcd        SETLL     SDCUSTLB
      *
     C                   DOU       %EOF(SDCUSTLB)
      *
     C                   EVAL      WbSnMs = *BLANKS
     C                   EVAL      WbMnMs = *BLANKS
     C                   EVAL      WbTtLs = *BLANKS
     C                   EVAL      WDbSp  = *ZEROS
     C                   EVAL      WDbcus = *ZEROS
      *
     C     WuBrcd        READE     SDCUSTLB
      *
     C                   IF        %EOF(SDCUSTLB)
     C                   LEAVE
     C                   ENDIF
      *
     C     B1BBCUST      CHAIN     SDACUSL1
      *
     C                   IF        %FOUND(SDACUSL1)
      *
      ** To report if Maturity date isn't defined or GT Last EOY date
      ** Value date is GT 0 and LE current EOY date
      *
     C                   IF        E5ETXT = 0 AND
     C                             E5EVDT > 0 AND
     C                             E5EVDT <= FYEAR OR
      *
     C                             E5ETXT > FPYEA AND
     C                             E5EVDT > 0 AND
     C                             E5EVDT <= FYEAR OR
      *
      ** In case of Value Date = 0 check if this is a join-Customer
      *
     C                             E5ETXT =  0 AND
     C                             E5EVDT = 0 AND
     C                             E5JATP = 'Y'
      *
     C                   EVAL      PCntCus = PCntCus + 1
     C                   EVAL      WdrFrm = 1
      *
      ** Convert Birth date of applicant
      *
     C                   MOVE      E5DBTH        WwDMY
     C                   MOVE      WwDMYD        WbDat1D
     C                   MOVE      WwDMYM        WbDat1M
     C                   MOVE      WwDMYY        WbDat1Y
      *
      ** Convert Birth date of applicant's spouse
      ** This is to find the spouse date of birth
      *
     C                   IF        E5SHRF  <> *BLANKS
      *
     C                   CALL      'AOACUSR0'
     C                   PARM      *BLANKS       PRtcd
     C                   PARM      '*KEY   '     POption
     C                   PARM      E5SHRF        PCustNo
     C     SDACUS        PARM      SDACUS        DSLDY
      *
     C                   IF        PRtcd <> *BLANKS
     C                             AND PRtcd <> '*NRF'
      *
     C     *LOCK         IN        LDA
     C                   EVAL      DBKey = PCustNo
     C                   EVAL      DBFile = 'SDACUSPD'
     C                   EVAL      DBase = 002
     C                   OUT       LDA
     C                   ELSE
      *
     C                   IF        PRtcd <> '*NRF'
     C                   MOVE      B2E5DBTH      WDbSp
     C                   EVAL      WbMnMs  = B2E5MDNM
     C                   EVAL      WbSnMs  = B2E5CNA1
     C                   EVAL      WbTtLs  = B2E5TITL
      *
     C                   ELSE
      *
      ** Non-account Holder report name
      *
     C                   CALL      'AONAHOR0'
     C                   PARM      *BLANKS       PRtcd
     C                   PARM      '*KEY   '     POption
     C                   PARM      E5SHRF        PNaho
     C     SDNAHO        PARM      SDNAHO        DSLDY
      *
      ** Database error.
      *
     C                   IF        PRtcd <> *BLANKS
     C                             AND PRtcd <> '*NRF'
      *
     C     *LOCK         IN        LDA
     C                   EVAL      DBKey = PCustNo
     C                   EVAL      DBFile = 'SDNAHOL1'
     C                   EVAL      DBase = 013
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ELSE
     C                   IF        PRtcd <> '*NRF'
     C                             AND NHDBTH <> *BLANKS
      *
     C                   MOVE      NHDBTH        WDbSp
     C                   EVAL      WbMnMs  = NHMDNM
     C                   EVAL      WbSnMs  = NHIDE1
     C                   EVAL      WbTtLs  = NHTITL
      *
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   MOVE      WDbSp         WwDMY
     C                   MOVE      WwDMYD        WbDat2D
     C                   MOVE      WwDMYM        WbDat2M
     C                   MOVE      WwDMYY        WbDat2Y
      *
      ** Get the Current Utilisation from Header File
      *
     C                   MOVE      E5CUST        KnCust
     C     KnCust        CHAIN     SDINPHL1
     C                   IF        NOT %FOUND(SDINPHL1)
      *
      ** If its not a Year End run check the First Entry Date
      *
     C                   IF        PRunYe = 'Y'
      *
     C     *LOCK         IN        LDA
      *
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
      *
     C                   EVAL      DBASE = 94
     C                   EVAL      DBFILE = 'SDINPHPD'
     C                   EVAL      DBKEY = E5CUST
     C                   EVAL      DBPGM = 'SD000791'
     C                   OUT       LDA
     C                   EXSR      *PSSR
      *
     C                   ENDIF
      *
     C                   IF        PRunYe <> 'Y'
      *
     C                   IF        FPYEA > B1BBORED
      *
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
      *
     C                   EVAL      DBASE = 95
     C                   EVAL      DBFILE = 'SDINPHPD'
     C                   EVAL      DBKEY = E5CUST
     C                   EVAL      DBPGM = 'SD000791'
     C                   OUT       LDA
     C                   EXSR      *PSSR
      *
     C                   ENDIF
      *
     C                   ENDIF
     C                   EVAL      PCntCus = PCntCus - 1
     C                   ITER
      *
     C                   ELSE
      *
     C                   EVAL      WFuUth = TIUTTH / 100
     C                   Z-ADD(H)  WFuUth        E5EXTH
     C                   ENDIF
      *
     C                   IF        TIUTTH = 0
      *
     C                   EVAL      PCntCus = PCntCus - 1
     C                   ITER
      *
     C                   ENDIF
      *
      ** Convert exemption threshold to 5 numerics
      *
     C                   EVAL      WExth = E5EXTH
     C                   MOVE      E5DBTH        WDbcus
      *
     C                   EXCEPT    SDSADVP6
      *
      ** Write detail in audit file SD000791P1
      *
     C                   EVAL      WRqdLn1 = 8
     C                   EVAL      WDifLn1 = OfLln1 - PrtLn1
     C                   IF        WDifLn1 <= WRqdLn1
     C                   EVAL      PageP1 = PageP1 + 1
     C                   EXCEPT    SD000791H0
     C                   ENDIF
      *
     C                   EXCEPT    SD000791D0
      *
     C                   ENDIF
      *
      ** ENDIF tag for SDACUSL1
      *
     C                   ENDIF
      *
     C                   ENDDO
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SRWbtr - Write Branch trailer                                *
      *                                                               *
      *  Called by : MAIN processing                                  *
      *                                                               *
      *  Calls : SRDltLbl                                             *
      *                                                               *
      *****************************************************************
      *
     C     SRWbtr        BEGSR
      *
     C                   EVAL      WWistr = *BLANKS
     C                   MOVE      B3E5CNA1      WWistr
     C                   EXSR      SRDltLbl
     C                   EVAL      WNam1 = WWostr
     C                   EXCEPT    SDSADVP8
      *
      ** Write branch trailer in Audit file SD000791P1
      *
     C                   EVAL      WRqdLn1 = 5
     C                   EVAL      WDifLn1 = OfLln1 - PrtLn1
     C                   IF        WDifLn1 <= WRqdLn1
     C                   EVAL      PageP1 = PageP1 + 1
     C                   EXCEPT    SD000791H0
     C                   ENDIF
      *
     C                   EXCEPT    SD000791T0
      *
      ** Write branch trailer in summary file SD000791P2
      *
     C                   EVAL      WRqdLn2 = 5
     C                   EVAL      WDifLn2 = OfLln2 - PrtLn2
     C                   IF        WDifLn2 <= WRqdLn2
     C                   EVAL      PageP2 = PageP2 + 1
     C                   EXCEPT    SD000791H1
     C                   ENDIF
      *
     C                   EXCEPT    SD000791B2
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRDltLbl - deletes the leading blanks in a field.            *
      *                                                               *
      *  INPUT  : WWistr   Input string with leading blanks (max. 60) *
      *  OUTPUT : WWostr  Output string without leading blanks        *
      *                                                               *
      *  Called by: SRWbtr                                            *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
      *
     C     SRDltLbl      BEGSR
      *
     C                   EVAL      Wn = 0
     C                   EVAL      ArrTmp = *BLANKS
     C                   EVAL      WWostr = *BLANKS
     C                   MOVEA     WWistr        ArrTmp
      *
      ** Get position (N) of the first non blank character.
      *
     C     ' '           CHECK     WWistr        Wn
     C                   IF        Wn = 0 OR
     C                             Wn > 70
     C                   EVAL      WWostr = WWistr
     C                   ELSE
     C                   MOVEA     ArrTmp(Wn)    WWostr
     C                   ENDIF
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *INZSR - Subroutine to do Program Initialisation.            *
      *                                                               *
      *  Called By: Main Processing                                   *
      *                                                               *
      *  Calls: SRRcFau, *PSSR, SRZDate1, SRFlbc                      *
      *                                                               *
      *****************************************************************
      *
     C     *INZSR        BEGSR
      *
      ** Set up copyright parameter
      *
     C                   MOVEA     CPY@          WCpy2
      *
      ** Receive RCF sequence
      *
     C     *ENTRY        PLIST
     C                   PARM                    PSeq
     C                   PARM                    PBrch
     C                   PARM                    PRunYe
     C                   PARM                    PFirsYr                                    BUG25416
      *
      ** Initialise LDA field.
      *
     C                   EVAL      DBPGM = 'SD000791'
      *
      ** Define SDDTAHL0 key
      *
     C     KyKedt        KLIST
     C                   KFLD                    KDaty
     C                   KFLD                    Kbrc
      *
      ** Define Key to access first customer of the branch
      *
     C     KeySet        KLIST
     C                   KFLD                    KyBrcd
     C                   KFLD                    KyCust
      *
      ** Define Branch code
      *
     C     *LIKE         DEFINE    B1BBBRCD      WuBrcd
      *
      ** RCF Processing
      *
     C                   EXSR      SRRcFau
      *
      ** Call Access Program for Bank Details - Title, Run Date and
      ** Run Day Number.
      *
     C                   CALL      'AOBANKR0'
     C                   PARM      '*MSG   '     WrTcd
     C                   PARM      '*FIRST '     WOptn
     C     SDBANK        PARM      SDBANK        DSFDY
      *
      ** Handle Database Error.
      *
     C                   IF        WrTcd <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'SDBANKPD'
     C                   EVAL      DBASE = 001
     C                   EVAL      DBKEY = *BLANKS
      *
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
      *
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *                                                                                     BUG22879
      * Retrieve Branch Code For Tape Header if WhBrcd = *Blanks                            BUG22879
      *                                                                                     BUG22879
     C                   IF        WhBrcd = *Blanks                                         BUG22879
      *                                                                                     BUG22879
     C                   READ      SDGELRPD                                                 BUG22879
     C                   IF        %EOF(SDGELRPD)                                           BUG22879
     C     *LOCK         IN        LDA                                                      BUG22879
     C                   EVAL      DBASE = 96                                               BUG22879
     C                   EVAL      DBFILE = 'SDGELRPD'                                      BUG22879
      *                                                                                     BUG22879
     C                   OUT       LDA                                                      BUG22879
     C                   EXSR      *PSSR                                                    BUG22879
     C*                                                                                     BUG22879
     C                   ELSE                                                               BUG22879
     C*                                                                                     BUG22879
     C                   EVAL      WhBrcd    =  BKMABR                                      BUG22879
     C*                                                                                     BUG22879
     C                   ENDIF                                                              BUG22879
      *                                                                                     BUG22879
     C                   ENDIF                                                              BUG22879
      *
      ** Access heading branch description to Location code
      *
     C                   CALL      'AOBRCHR0'
     C                   PARM      *BLANKS       PRtcd
     C                   PARM      '*KEY   '     POption
     C                   PARM      WhBrcd        PBranch
     C     SDBRCH        PARM      SDBRCH        DSFDY
      *
     C                   IF        PRtcd <> *BLANKS
      *
     C     *LOCK         IN        LDA
     C                   EVAL      DBASE = 12
     C                   EVAL      DBFILE = 'SDBRCHPD'
     C                   EVAL      DBKEY = 'HEADER ' + WhBrcd
      *
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
      *
     C                   OUT       LDA
     C                   EXSR      *PSSR
      *
     C                   ENDIF
      *
      ** Access Location code to retrieve Country Code
      *
     C                   CALL      'AOLOCNR0'
     C                   PARM      *BLANKS       PRtcd
     C                   PARM      '*KEY   '     POptn
     C                   PARM      A8LCCD        PLocn
     C     SDLOCN        PARM      SDLOCN        DSFDY
      *
     C                   IF        PRtcd <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFile = 'SDLOCNPD'
     C                   EVAL      DBKey = PLocn
     C                   EVAL      DBase = 102
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ** Access Country code to retrieve Tax Enddate
      *
     C                   CALL      'AOCTRYR0'
     C                   PARM      *BLANKS       PRtcd
     C                   PARM      '*KEY   '     POptn
     C                   PARM      DVCNCD        PCnCd
     C     SDCTRY        PARM      SDCTRY        DSFDY
      *
     C                   IF        PRtcd <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFile = 'SDCTRYPD'
     C                   EVAL      DBKey = PCnCd
     C                   EVAL      DBase = 103
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C**********         IF        A4ETXY  = *ZEROS                                         BUG25045
      **********                                                                            BUG25045
     C**********         IF        BJDFIN  = 'D'                                            BUG25045
     C**********         EVAL      PDateIn = '3112' +                                       BUG25045
     C**********                              %SUBST(BJMRDT:6:2)                            BUG25045
      **********                                                                            BUG25045
     C**********         ELSE                                                               BUG25045
      **********                                                                            BUG25045
     C**********         EVAL      PDateIn = '1231' +                                       BUG25045
     C**********                              %SUBST(BJMRDT:6:2)                            BUG25045
     C**********         ENDIF                                                              BUG25045
      **********                                                                            BUG25045
     C**********         ELSE                                                               BUG25045
     C**********         EVAL      PDateIn = %CHAR(A4ETXY) +                                BUG25045
     C**********                              %SUBST(BJMRDT:6:2)                            BUG25045
      **********                                                                            BUG25045
     C                   IF        A4ETXY <> *ZEROS and                                     BUG25045
     C                             BJDFIN = 'D'                                             BUG25045
     C                   MOVEL(P)  A4ETXY        WETXY                                      BUG25045
     C                   EVAL      WETXY = %Subst(WETXY:3:2) +                              BUG25045
     C                                     %Subst(WETXY:1:2)                                BUG25045
     C                   ELSE                                                               BUG25045
     C                   MOVEL(P)  A4ETXY        WETXY                                      BUG25045
     C                   ENDIF
      *                                                                                     BUG25045
      ** convert BJRDNB and BJDNWD to MMDD                                                  BUG25045
      *                                                                                     BUG25045
     C                   EVAL      PDtFmt = 'M'                                             BUG25045
     C                   EVAL      PDayNo = BJRDNB                                          BUG25045
     C                   EXSR      SRZDate2                                                 BUG25045
     C                   MOVE      PDate         WRDNB                                      BUG25045
      *                                                                                     BUG25045
     C                   EVAL      PDayNo = BJDNWD                                          BUG25045
     C                   EXSR      SRZDate2                                                 BUG25045
     C                   MOVE      PDate         WDNWB                                      BUG25045
      *                                                                                     BUG25045
      ** get current year                                                                   BUG25045
      *                                                                                     BUG25045
     C                   MOVE      BJMRDT        WYearN                                     BUG25045
      *                                                                                     BUG25045
     C                   IF        %Subst(WRDNB:1:4) >                                      BUG25045
     C                             %Subst(WETXY:1:4)                                        BUG25045
     C**********         EVAL      WYearN = WYearN + 1                             BUG25045 BUG26416
     C                   MOVE      WYearN        WYearC                                     BUG25045
     C                   EVAL      WYearC = %char(%dec(WYearC:2:0) + 1)                     BUG25416
     C                   EVAL      PDateIn = %trim(WETXY) + WYearC                          BUG25045
     C                   ELSE                                                               BUG25045
     C                   MOVE      WYearN        WYearC                                     BUG25045
     C                   EVAL      PDateIn = %trim(WETXY) + WYearC                          BUG25045
     C                   ENDIF                                                              BUG25045
      *
     C                   EVAL      PDtFmt = 'M'                                             BUG25045
     C                   EXSR      SRZDate1
      *
     C                   EVAL      FYEAR  = PDayNoOut
      *
     C**********         EVALR     %SUBST(PDateIn:5:2) =                                    BUG25045
     C**********                   %CHAR(%INT(%SUBST(PDateIn:5:2)) - 1)                     BUG25045
     C                   IF        %subst(WRDNB:1:4) >                                      BUG25045
     C                             %subst(WETXY:1:4)                                        BUG25045
     C                   MOVE      WYearN        WYearC                                     BUG25045
     C                   EVAL      PDateIn = %trim(WETXY) + WYearC                          BUG25045
     C                   ELSE                                                               BUG25045
     C**********         EVAL      WYearN = WYearN - 1                             BUG25045 BUG25416
     C                   MOVE      WYearN        WYearC                                     BUG25045
     C                   EVALR     WYearC = %char(%dec(WYearC:2:0) - 1)                     BUG25416
     C                   EVAL      PDateIn = %trim(WETXY) + WYearC                          BUG25045
     C                   ENDIF                                                              BUG25045
      *
     C                   EVAL      PDtFmt = 'M'                                             BUG25045
     C                   EXSR      SRZDate1
      *
     C                   EVAL      FPYEA  = PDayNoOut
      *
     C**********         IF        FYEAR >= BJRDNB AND                                      BUG25045
     C**********                   FYEAR <  BJDNWD                                          BUG25045
     C                   IF        %Subst(WETXY:1:4) >= %Subst(WRDNB:1:4) and               BUG25045
     C                             %Subst(WETXY:1:4) <  %Subst(WDNWB:1:4)                   BUG25045
     C                   EVAL      PRunYe = 'Y'
     C                   ENDIF
      *
     C                   EVAL      KeUsr = PSUser
      *
      ** RCF work fields
      *
     C                   EVAL      WRqdLn1 = 0
     C                   EVAL      WDifLn1 = 0
     C                   EVAL      WRqdLn2 = 0
     C                   EVAL      WDifLn2 = 0
      *
      ** The program run during the 'Input Cycle'.
      ** The heading branch previously selected in
      ** SD000792 is the field WhBrcd
      ** The branches previously selected in
      ** SD000792 (array BRCD) will be reported
      *
     C                   IF        ZBrcd = *BLANKS
      *
      ** The user is authorized to all and he has
      ** selected  all branches
      ** ALL branches from SDBRCHPD will be reported
      *
     C                   EXSR      SRFlbc
     C                   ELSE
      *
      ** I: number of branches selected  (1 of 84)
      *
     C                   Z-ADD     1             Wi
     C     '   '         LOOKUP    BRCD(Wi)                               64
     C                   IF        *IN64 = '1'
     C                   EVAL      Wi = Wi - 1
     C                   ELSE
     C                   EVAL      Wi = 32
     C                   ENDIF
     C                   MOVEA     BRCD(1)       ArrABCD(1)
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRFlbc - Subroutine to fill array BRCD with all branches     *
      *           of SDBRCHPD                                         *
      *                                                               *
      *  Called by : *INZSR                                           *
      *                                                               *
      *  Calls: *PSSR                                                 *
      *                                                               *
      *****************************************************************
      *
     C     SRFlbc        BEGSR
      *
      ** Fill arrays  ArrABCD
      *
     C                   CALL      'AOBRCHR0'
     C                   PARM                    PRtcd
     C                   PARM      '*FIRST '     POption
     C                   PARM                    PBranch
     C     SDBRCH        PARM      SDBRCH        DSFDY
      *
     C                   EVAL      Wi = 1
      *
     C                   DOW       PRtcd <> '*EOF   '
      *
     C                   IF        PRtcd <> *BLANKS AND
     C                             PRtcd <> '*EOF'
      *
      ** Data base error occurs during read of sdbrchpd
      *
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'SDBRCHPD'
     C                   EVAL      DBASE = 3
     C     'Prev. BR'    CAT       'ANCH : '     DBKEY
     C                   EVAL      Wi = Wi - 1
     C     DBKEY         CAT       ArrABCD(Wi)   DBKEY
      *
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
      *
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   IF        PRtcd = *BLANKS
     C                   MOVE      A8BRCD        ArrABCD(Wi)
     C                   EVAL      Wi = Wi + 1
     C                   ENDIF
      *
      ** Max 200 branches
      *
     C                   IF        Wi < 200
      *
      ** Access next branch
      *
     C                   CALL      'AOBRCHR0'
     C                   PARM                    PRtcd
     C                   PARM      '*NEXT  '     POption
     C                   PARM                    PBranch
     C     SDBRCH        PARM      SDBRCH        DSFDY
     C                   ELSE
      *
      ** Force exit
      *
     C                   EVAL      PRtcd = '*EOF   '
      *
     C                   ENDIF
      *
     C                   ENDDO
      *
     C                   EVAL      Wi = Wi - 1
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRRcFau - Subroutine to register the AU Printer File via RCF.*
      *                                                               *
      *  Called by : *INZSR                                           *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
      *
     C     SRRcFau       BEGSR
      *
      ** Ensure Audit Spool File recorded by RCF.
      *
     C                   EVAL      ZSnumU = SfNumU
      *
     C                   CALL      'ZSFILE'
     C                   PARM      PSeq          PSeq1
     C                   PARM      *BLANKS       PSenty
     C                   PARM                    SFileU
     C                   PARM                    ZSnumU
     C                   PARM      *BLANKS       PSerr
      *
      ** If Error occurs during ZSFILE processing, then return
      ** to the Calling Program.
      *
     C                   IF        PSerr = 'Y'
      *
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
      *
     C                   RETURN
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRRcFp1 - Subroutine to register the P1 Printer File via RCF.*
      *                                                               *
      *  Called By : SRWbhd                                           *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
      *
     C     SRRcFp1       BEGSR
      *
     C                   CLOSE     SD000791P1
     C                   OPEN      SD000791P1
      *
      ** Ensure Report Spool File recorded by RCF.
      *
     C                   EVAL      ZSnum = SfNum1
     C                   CALL      'ZSFILE'
     C                   PARM      PSeq          PSeq1
     C                   PARM      WuBrcd        PSenty
     C                   PARM                    SFile1
     C                   PARM                    ZSnum
     C                   PARM      *BLANKS       PSerr
      *
      ** If Error occurs during ZSFILE processing, then
      ** return to the Calling Program.
      *
     C                   IF        PSerr = 'Y'
      *
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
      *
     C                   RETURN
     C                   ENDIF
      *
      ** Reset Page Counter
      *
     C                   EVAL      PageP1 = 1
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRRcFp2 - Subroutine to register the P2 Printer File via RCF.*
      *                                                               *
      *  Called By : SRWthd                                           *
      *                                                               *
      *  Calls : None                                                 *
      *                                                               *
      *****************************************************************
      *
     C     SRRcFp2       BEGSR
      *
     C                   OPEN      SD000791P2
      *
      ** Ensure Report Spool File recorded by RCF.
      *
     C                   EVAL      ZSnum = SfNum2
     C                   CALL      'ZSFILE'
     C                   PARM      PSeq          PSeq1
     C                   PARM      WhBrcd        PSenty
     C                   PARM                    SFile2
     C                   PARM                    ZSnum
     C                   PARM      *BLANKS       PSerr
      *
      ** If Error occurs during ZSFILE processing, then
      ** return to the Calling Program.
      *
     C                   IF        PSerr = 'Y'
      *
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
      *
     C                   RETURN
     C                   ENDIF
      *
      ** Reset Page Counter
      *
     C                   EVAL      PageP2 = 1
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRAudit - Subroutine to Output Audit report and End Program. *
      *                                                               *
      *  Called By: *PSSR                                             *
      *                                                               *
      *  Calls: None.                                                 *
      *                                                               *
      *****************************************************************
      *
     C     SRAudit       BEGSR
      *
      ** Output Report Header and File Controls.
      *
     C                   WRITE     SD000791R0
      *
      ** If there is a DB Error, Output the DB Error Information.
      *
     C                   WRITE     SD000791R1
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRZDate1 - Convert Date DDMMYY to Midas Day Number           *
      *                                                               *
      *  Called By : SRWbhd , *INZSR                                  *
      *                                                               *
      *  Calls : None                                                 *
      *                                                               *
      *****************************************************************
      *
     C     SRZDate1      BEGSR
      *
     C                   CALLB     'ZDATE1'
     C                   PARM                    PDateIn
     C                   PARM                    PDayNoOut
     C**********         PARM                    BJDFIN                                     BUG25045
     C                   PARM                    PDtFmt                                     BUG25045
     C                   PARM                    PErrorFlag
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRZDate2 - Convert Midas Day Number into Date (DDMMYY/MMDDYY)*
      *                                                               *
      *  Called By : SRWbhd                                           *
      *                                                               *
      *  Calls : None                                                 *
      *                                                               *
      *****************************************************************
      *
     C     SRZDate2      BEGSR
      *
     C                   CALLB     'ZDATE2'
     C                   PARM                    PDayNo
     C**********         PARM                    BJDFIN                                     BUG25045
     C                   PARM                    PDtFmt                                     BUG25045
     C                   PARM                    PDate
     C                   PARM                    PADate
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *PSSR  - Error control subroutine                            *
      *                                                               *
      *  Called By :                                                  *
      *                                                               *
      *  Calls : SRAudit                                              *
      *                                                               *
      *****************************************************************
      *
     C     *PSSR         BEGSR
      *
      ** Check to see that *PSSR has not already been called.
      *
     C                   IF        WRun = *BLANKS
     C                   EVAL      WRun = 'Y'
      *
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
      *
     C                   EXSR      SRAudit
     C                   DUMP
     C                   ENDIF
      *
      ** If *PSSR already run, then just end
      ** the program here.
      *
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
      *
     C                   RETURN
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      *****************************************************************
      *  O - SPECIFICATION
      *****************************************************************
      *
      ** RECORD 0:  HEADER RECORD OF THE TAPE FILE
      *
     OSDSADVPD  E            SDSADVP1
     O                                            1 '0'
     O                       WCrtDat              9
     O                       B3E5CNA1            79
     O                       B3E5CNA3           114
     O                       B3E5ZIPC           124
     O                       B3E5BTHT           159
      *
      ** RECORD 1:  HEADER RECORD OF THE TAPE FILE
      *
     OSDSADVPD  E            SDSADVP4
     O                                            1 '1'
     O                       WBlCd                9
     O                       B3E5CNA1            79
     O                       B3E5CNA3           114
     O                       B3E5ZIPC           124
     O                       B3E5BTHT           159
     O                       KDaty              163
     O                       WCrtDat            171
     O                       FHLSEQ             173
     O                       WuBrcd             176
      *
      ** RECORD 2:  DETAIL RECORD OF THE APPLICATANT
      *
     OSDSADVPD  E            SDSADVP6
     O                                            1 '2'
     O                                            2 '1'
     O                       WBlCd               10
     O                       B1BBCUST            20
     O                       WdrFrm              22
     O                       E5CNA1              92
     O                       E5MDNM             162
     O                       E5TITL             197
     O                       WbDat1             205
     O                       WbSnMs             250
     O                       WbMnMs             295
     O                       WbTtLs             320
     O                       WbDat2             328
     O                       E5CNA3             363
     O                       E5ZIPC             373
     O                       E5BTHT             408
     O                       KDaty              412
     O                       WExth              417
      *
      ** RECORD 3:  TRAILER RECORD OF THE BANK BRANCH
      *
     OSDSADVPD  E            SDSADVP8
     O                                            1 '3'
     O                       WBlCd                9
     O                       WNam1               79
     O                       B3E5CNA3           114
     O                       B3E5ZIPC           124
     O                       B3E5BTHT           159
     O                       KDaty              163
     O                       PCntCus            170
     O                       WCrtDy             174
     O                       WCrtDm             176
     O                       WCrtDD             178
      *
      ** RECORD 4:  TRAILER RECORD OF THE TAPE FILE
      *
     OSDSADVPD  E            SDSADVP10
     O                                            1 '4'
     O                       WCrtDy               5
     O                       WCrtDm               7
     O                       WCrtDD               9
     O                       PtNAM1              79
     O                       PtSTR              114
     O                       PtPLZ              124
     O                       PtORT              159
     O                       CntBrc             162
      *
      ** Record format for audit file SD000791P1
      *
      ** Page Header
      *
     OSD000791P1E            SD000791H0     1  1
     O                                            5 'REF:'
     O                       PSProcName          17
     O                       BJURPT              92
     O                                          121 'DATE:'
     O                       BJMRDT             130
     O          E            SD000791H0     1
     O                                            6 'USER:'
     O                       PSUser              17
     O                                           60 'GWT AUDIT REPORT OF THE '
     O                                           80 'RELEASE UTILIZATION'
     O                                           98 'DATA CARRIER'
     O                                          121 'PAGE:'
     O                       PageP1        Z    130
     O          E            SD000791H0     1
     O                                           24 '-----------------+
     O                                               -------'
     O                                           48 '-----------------+
     O                                               -------'
     O                                           72 '-----------------+
     O                                               -------'
     O                                           96 '-----------------+
     O                                               -------'
     O                                          120 '-----------------+
     O                                               -------'
     O                                          132 '------------'
      *
      ** RECORD 0:  HEADER RECORD OF THE TAPE FILE
      *
     O          E            SD000791H0     1
     O                                           21 'Record type      +
     O                                               : 0'
     O                                           84 'Creation date    +
     O                                               :'
     O                       WCrtDD              87
     O                                           88 '.'
     O                       WCrtDm              90
     O                                           91 '.'
     O                       WCrtDy              95
     O          E            SD000791H0     1
     O                                           19 'Bank Name        +
     O                                               :'
     O                       PtNAM1              89
     O          E            SD000791H0     1
     O                                           19 'Street           +
     O                                               :'
     O                       PtSTR               54
     O                                           84 'Post.code, Place +
     O                                               :'
     O                       PtPLZ               94
     O                                           95 ','
     O                       PtORT              130
     O          E            SD000791H0     1
     O                                           24 '-----------------+
     O                                               ------'
      *
      **  RECORD 1:  HEADER RECORD OF THE TAPE FILE
      *
     O          E            SD000791H0     1
     O                                           21 'Record type      +
     O                                               : 1'
     O                                           31 'BLZ:'
     O                       WBlCd               41
     O                                           60 'Bank branch      +
     O                                               :'
     O                       B3E5CNA1           130
     O          E            SD000791H0     1
     O                                           19 'Street           +
     O                                               :'
     O                       B3E5CNA3            54
     O                                           84 'Post.code, Place +
     O                                               :'
     O                       B3E5ZIPC            94
     O                                           95 ','
     O                       B3E5BTHT           130
     O          E            SD000791H0     1
     O                                           19 'Report for year  +
     O                                               :'
     O                       KDaty               24
     O                                           84 'Creation date    +
     O                                               :'
     O                       WCrtDD              87
     O                                           88 '.'
     O                       WCrtDm              90
     O                                           91 '.'
     O                       WCrtDy              95
     O                                          127 'Seq. of amend. +
     O                                               delivery:'
     O                       FHLSEQ             130
     O          E            SD000791H0     1
     O                                           24 '-----------------+
     O                                               ------'
      *
      ** RECORD 2:  DETAIL RECORD OF THE APPLICATANT
      *
     OSD000791P1E            SD000791D0     1
     O                                           21 'Record type      +
     O                                               : 2'
     O                                           49 'Customer No.:'
     O                       B1BBCUST            56
     O                                           84 'Legal form       +
     O                                               : 01'
     O                                          101 'BLZ:'
     O                       WBlCd              110
     O                                          130 'Ident.: 1'
     O          E            SD000791D0     1
     O                                           16 'Appl. surname +
     O                                               :'
     O                       E5CNA1              86
     O                                           97 'First name:'
     O                       E5TITL             132
     O          E            SD000791D0     1
     O                                           16 'Appl. Mdn name+
     O                                               :'
     O                       E5MDNM              86
     O                                          101 'D. o .B. Appl.+
     O                                               :'
     O                       WDbcus             112 '    .  .  '
     O          E            SD000791D0     1
     O                                           16 'Spouse surname+
     O                                               :'
     O                       WbSnMs              86
     O                                           97 'First name:'
     O                       WbTtLs             132
     O          E            SD000791D0     1
     O                                           16 'Spse. Mdn name+
     O                                               :'
     O                       WbMnMs              86
     O                                          101 'D. o. B. Spse.+
     O                                               :'
     O                       WDbSp              112 '    .  .  '
     O          E            SD000791D0     1
     O                                           19 'Street           +
     O                                               :'
     O                       E5CNA3              54
     O                                           84 'Post.code,Place  +
     O                                               :'
     O                       E5ZIPC              94
     O                                           95 ','
     O                       E5BTHT             130
     O          E            SD000791D0     1
     O                                           19 'Report for year  +
     O                                               :'
     O                       KDaty               24
     O                                           84 'Utilisation      +
     O                                               :'
     O                       WExth         J     95
     O          E            SD000791D0     1
     O                                           24 '-----------------+
     O                                               ------'
      *
      ** RECORD 3:  TRAILER RECORD OF THE BANK BRANCH
      *
     OSD000791P1E            SD000791T0     1
     O                                           21 'Record type      +
     O                                               : 3'
     O                                           30 'BLZ:'
     O                       WBlCd               40
     O                                           60 'Bank branch      +
     O                                               :'
     O                       B3E5CNA1           130
     O          E            SD000791T0     1
     O                                           19 'Street           +
     O                                               :'
     O                       B3E5CNA3            54
     O                                           84 'Post.code, Place +
     O                                               :'
     O                       B3E5ZIPC            94
     O                                           95 ','
     O                       B3E5BTHT           130
     O          E            SD000791T0     1
     O                                           19 'Report for year  +
     O                                               :'
     O                       KDaty               24
     O                                           84 'Creation date    +
     O                                               :'
     O                       WCrtDD              87
     O                                           88 '.'
     O                       WCrtDm              90
     O                                           91 '.'
     O                       WCrtDy              95
     O          E            SD000791T0     1
     O                                           19 'Cnt type 2 recs. +
     O                                               :'
     O                       PCntCus       3     27
     O          E            SD000791T0     1
     O                                           72 '*****   END OF  +
     O                                              REPORT  '
     O                                              '*****'
      *
      ** Record format for summary file SD000791P2
      *
      ** Page Header
      *
     OSD000791P2E            SD000791H1     1  1
     O                                            5 'REF:'
     O                       PSProcName          17
     O                       BJURPT              92
     O                                          121 'DATE:'
     O                       BJMRDT             130
     O          E            SD000791H1     1
     O                                            6 'USER:'
     O                       PSUser              17
     O                                           60 'GWT AUDIT REPORT OF THE '
     O                                           80 'RELEASE UTILIZATION'
     O                                           98 'DATA CARRIER'
     O                                          121 'PAGE:'
     O                       PageP2        Z    130
     O          E            SD000791H1     1
     O                                           24 '-----------------+
     O                                               -------'
     O                                           48 '-----------------+
     O                                               -------'
     O                                           72 '-----------------+
     O                                               -------'
     O                                           96 '-----------------+
     O                                               -------'
     O                                          120 '-----------------+
     O                                               -------'
     O                                          132 '------------'
      *
      ** RECORD 0:  HEADER RECORD OF THE TAPE FILE
      *
     O          E            SD000791H1     1
     O                                           21 'Record type      +
     O                                               : 0'
     O                                           84 'Creation date    +
     O                                               :'
     O                       WCrtDD              87
     O                                           88 '.'
     O                       WCrtDm              90
     O                                           91 '.'
     O                       WCrtDy              95
     O          E            SD000791H1     1
     O                                           19 'Bank Name        +
     O                                               :'
     O                       PtNAM1              89
     O          E            SD000791H1     1
     O                                           19 'Street           +
     O                                               :'
     O                       PtSTR               54
     O                                           84 'Post.code, Place +
     O                                               :'
     O                       PtPLZ               94
     O                                           95 ','
     O                       PtORT              130
     O          E            SD000791H1     1
     O                                           24 '-----------------+
     O                                               ------'
      *
      ** RECORD 1:  HEADER RECORD OF THE TAPE FILE
      *
     OSD000791P2E            SD000791B1     1
     O                                           21 'Record type      +
     O                                               : 1'
     O                                           30 'BLZ:'
     O                       WBlCd               40
     O                                           60 'Bank branch      +
     O                                               :'
     O                       B3E5CNA1           130
     O          E            SD000791B1     1
     O                                           19 'Street           +
     O                                               :'
     O                       B3E5CNA3            54
     O                                           84 'Post.code, Place +
     O                                               :'
     O                       B3E5ZIPC            94
     O                                           95 ','
     O                       B3E5BTHT           130
     O          E            SD000791B1     1
     O                                           19 'Report for year  +
     O                                               :'
     O                       KDaty               24
     O                                           84 'Creation date    +
     O                                               :'
     O                       WCrtDD              87
     O                                           88 '.'
     O                       WCrtDm              90
     O                                           91 '.'
     O                       WCrtDy              95
     O                                          127 'Seq. of amend. +
     O                                               delivery:'
     O                       FHLSEQ             130
     O          E            SD000791B1     1
     O                                           24 '-----------------+
     O                                               ------'
      *
      ** RECORD 3:  TRAILER RECORD OF THE BANK BRANCH
      *
     OSD000791P2E            SD000791B2     1
     O                                           21 'Record type      +
     O                                               : 3'
     O                                           30 'BLZ:'
     O                       WBlCd               40
     O                                           60 'Bank branch      +
     O                                               :'
     O                       B3E5CNA1           130
     O          E            SD000791B2     1
     O                                           19 'Street           +
     O                                               :'
     O                       B3E5CNA3            54
     O                                           84 'Post.code, Place +
     O                                               :'
     O                       B3E5ZIPC            94
     O                                           95 ','
     O                       B3E5BTHT           130
     O          E            SD000791B2     1
     O                                           19 'Report for year  +
     O                                               :'
     O                       KDaty               24
     O                                           84 'Creation date    +
     O                                               :'
     O                       WCrtDD              87
     O                                           88 '.'
     O                       WCrtDm              90
     O                                           91 '.'
     O                       WCrtDy              95
     O          E            SD000791B2     1
     O                                           19 'Cnt type 2 recs. +
     O                                               :'
     O                       PCntCus       3     27
     O          E            SD000791B2     1
     O                                           24 '-----------------+
     O                                               ------'
      *
      ** RECORD 4:  TRAILER RECORD OF THE TAPE FILE
      *
     OSD000791P2E            SD000791T1     1
     O                                           21 'Record type      +
     O                                               : 4'
     O                                           60 'Bank Name        +
     O                                               :'
     O                       PtNAM1             130
     O          E            SD000791T1     1
     O                                           19 'Street           +
     O                                               :'
     O                       PtSTR               54
     O                                           84 'Post.code, Place +
     O                                               :'
     O                       PtPLZ               94
     O                                           95 ','
     O                       PtORT              130
     O          E            SD000791T1     1
     O                                           19 'Cnt type 1 recs. +
     O                                               :'
     O                       CntBrc        3     23
     O                                           84 'Creation date    +
     O                                               :'
     O                       WCrtDD              87
     O                                           88 '.'
     O                       WCrtDm              90
     O                                           91 '.'
     O                       WCrtDy              95
     O          E            SD000791T1     1
     O                                           24 '-----------------+
     O                                               ------'
     O          E            SD000791T1     1
     O                                           72 '*****   END OF +
     O                                              REPORT  '
     O                                              '*****'
      *****************************************************************
      /TITLE ARRAY
      *****************************************************************
** CPY@
(C) Copyright Finastra International Limited 2008
