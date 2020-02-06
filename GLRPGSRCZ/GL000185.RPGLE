     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas GL Additional Information Maintenance')          *
      *****************************************************************
      *                                                               *
      *  Midas - General Ledger Module                                *
      *                                                               *
      *  GL000185 - Additional Information Maintenance                *
      *                                                               *
      *  Function:  This module will be called from GL0121M and       *
      *             GL0181M whenever a 'Y' is entered on the          *
      *             Additional Information field.  It will show all   *
      *             posting details input and allow the maintenance   *
      *             of the additional information.                    *
      *                                                               *
      *  (c) Finastra International Limited 2002                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. MD039326           Date 15Jun16               *
      *                 AR877000           Date 08Dec11               *
      *                 AR872671           Date 29Nov11               *
      *                 AR853053           Date 24Oct11               *
      *                 CLE134             Date 01Aug12               *
      *                 CER059             Date 19Jul10               *
      *                 BUG25438           Date 25Aug09               *
      *                 BUG24339A          Date 21Jul09               *
      *                 BUG23742           Date 09May09               *
      *                 BUG22527           Date 29Jan09               *
      *                 CER030             Date 09Jul08               *
      *                 CER043             Date 19May08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 256564             Date 17Sep08               *
      *                 246418             Date 15Mar07               *
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CGL029             Date 01Sep03               *
      *                 CGL013  *CREATE    Date 29Mar02               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  MD039326 - Serious MIdas Error occurred when inserting via   *
      *             Intellimatch. %SCAN on a position greater than    *
      *             actual string length. Add preventive fix.         *
      *  AR877000 - Extended narratives enquired are not the          *
      *             expected values (Child:AR877001)                  *
      *  AR872671 - Add german DTA special characters in the valid    *
      *             list of SWIFT char (Child:AR872672)               *
      *  AR853053 - Not allowed to enter German characters in 6X65A   *
      *             (Child:AR853054). Applied GEMS fix 263253.        *
      *  CLE134 - Past Due Call Loan Processing (Recompile)           *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *         - LT091: Error for Line Length is occuring even if    *
      *         - the Addiotional info and multicash tab are blanks   *
      *  BUG25438 - Batch was accepted when 2 EN tabs are filled out  *
      *  BUG24339A - Extended Narrative fields are unavailable        *
      *  BUG23742 - Improper handling of Ext Narr from Batch          *
      *             Interface Input                                   *
      *  BUG22527 - Additional Information for Batch legs disappears  *
      *           after insert                                        *
      *  CER030 - Multicash German Feature                            *
      *  CER043 - German Features LF041-00 New Fields and Defaulting  *
      *           (recompile)                                         *
      *  256564 - Recompile due to PF changes done by fix 256330      *
      *  246418 - CGL013 changes for Midas Plus                       *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  CGL013 - MT94x Messages Generation                           *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *    28         Protect Input Fields - Enquiry Mode             *
      *    29         CHECK Indicator                                 *
      *    30         Error Indicator                                 *
      *    31         Error Indicator Additional Information 1        *
      *    32         Error Indicator Additional Information 2        *
      *    33         Error Indicator Additional Information 3        *
      *    34         Error Indicator Additional Information 4        *
      *    35         Error Indicator Additional Information 5        *
      *    36         Error Indicator Additional Information 6        *
      *    37         Error Indicator ERI Information Indicator       *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      * SRMove - Move File Fields to Screen Fields                    *
      * SRFormat - Format Fields to Screen Fields                     *
      * SRValidate - Validate Additional Information                  *
      * SRERIIndi - Validate ERI Information Indicator                *
      * SRERIInfo - Validate ERI Information                          *
      * SRCurrency- Validate Currency                                 *
      * SRUpdate - Update PF/GLJENXPD                                 *
      * SRDelete - Delete from PF/GLJENXPD if amend and additional    *
      *            information fields are blanks                      *
      * SRSndErr - Send Error Message                                 *
      * *PSSR - Error processing                                      *
      * *INZSR - Initialise                                           *
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
 
     F*****GL000185DFCF***E             WORKSTN INFSR(*PSSR)                                  246418
     FGL000185DFCF   E             WORKSTN INFSR(*PSSR) USROPN                                246418
      ** Additional Information Maintenance Display File
 
     FGLJENXL2  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(GLJENXD0:@LJENXD0)
      ** RTV: Midas GL Journal Entry File - Additional Information
 
     FGLJENXL4  UF A E           K DISK    INFSR(*PSSR) COMMIT
      ** UPD: Midas GL Journal Entry File - Additional Information
 
     FSDCURRLD  IF   E           K DISK
      ** Midas SD Currencies field by SWIFT currency code
 
     FSDCODEL1  IT   F   20        DISK
      ** Midas SD SWIFT codewords retrieval
 
      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ D-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
     D*LDA******     E DS           256    EXTNAME(LDA) DTAARA(LDA)                           246418
      **********                                                                              246418
      ***Local*data area for database error details                                           246418
      ****LOCK*IN LDA immediately before and OUT LDA immediately                              246418
      ***after*each database error handling.                                                  246418
      **********                                                                              246418
      **********                            134 141 DBFILE                                    246418
      *********Defines:                     142 170 DBKEY                                     246418
      **********                            171 180 DBPGM                                     246418
      **********                            181 1830DBASE                                     246418
      **********                            184 193 DBMOD                                     246418
      **********                            194 203 DBPROC                                    246418
      **********                                                                              246418
     D RUNDAT        E DS                  EXTNAME(RUNDAT)
      *
      ** Data Area giving Installation Control Details
      *                                                                                       246418
      ** The following /COPY line includes the LDA layout,                                    246418
      ** the copyright array definition,                                                      246418
      ** and the following named constants:                                                   246418
      **    True       logical = *on (for indcator processing)                                246418
      **    False      logical = *off (for indcator processing)                               246418
      **    DBErrCtl   10A     = 'DBERRCTL' (the name of the database error                   246418
      **                                    handler)                                          246418
      ** and the following variables:                                                         246418
      **    RunBefore  1A (for the PSSR)                                                      246418
      *                                                                                       246418
      /COPY ZACPYSRC,STD_D_SPEC                                                               246418
      *                                                                                       246418
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
 
     D/COPY ZACPYSRC,PSDS
      *
      ** Program Status Data Structure
      *                                                                                       246418
      ** The following /COPY line includes the definitions for error and                      246418
      ** warning message arrays.                                                              246418
      *                                                                                       246418
      /COPY ZACPYSRC,ERR_ARRAYS                                                               246418
      *                                                                                       246418
      ** The following /COPY line includes all the definitions of the                         246418
      ** appended error arrays, including the named constant giving the size                  246418
      ** of the arrays.                                                                       246418
      *                                                                                       246418
      /COPY ZACPYSRC,ERR_XARRYS                                                               246418
 
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
      ** Valid Swift Characters
     D SwiftXSet       C                   'ABCDEFGHIJKLMNOPQRSTUVWXYZ-
     D                                     abcdefghijklmnopqrstuvwxyz-
     D**********                           0123456789 /-?:().,''+'                            263253
     D**********                           0123456789 /-?:().,+-                     263253 AR872671
     D**********                           äÄöÖüÜß'                                  263253 AR872671
     D                                     0123456789 /-?:().,''+-                          AR872671
     D                                     äÄöÖüÜß&*$%'                                     AR872671
 
      ** Upper Case Letter
     D Up              C                   'ABCDEFGHIJKLMNOPQRSTUVWXYZ'
 
      ** Lower Case Letter
     D Lo              C                   'abcdefghijklmnopqrstuvwxyz'
 
      ** Numeric character
      *
     D Numeric         C                   '0123456789'
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
      ** External data structure for Bank Details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
 
      ** External data structures for Switchable Features Details
     D SCSARD        E DS                  EXTNAME(SCSARDPD)
 
      ** First DS for Access Programs, Short Data Structure
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      ** Data Structure for Screen Fields
     D #1DBRC          DS           400
 
      ** Additional Information Data Structure
     D @1DBRC        E DS                  EXTNAME(GLJENXL4)
 
      ** Valid JE Item Additional Information (DS)                                            246418
     D PVBITPX       E DS                  EXTNAME(GLVBIPXPD)                                 246418
                                                                                              246418
     D***PPostDetails    DS           109                                                     CGL029
     D*PPostDetails    DS           118                                              CGL029 BUG23742
     D PPostDetails    DS           119                                                     BUG23742
     D  #0BTNB                 1      3
     D  #0BINB                 4      6
     D  WBranch                7      9
     D  WCNum                 10     15
     D  WCurr                 16     18
     D***WACode*               19     22                                                      CGL029
     D  WACodeQQ              19     22                                                       CGL029
     D  WASeq                 23     24
     D  #0RACN                25     34
     D  #0PTAM                35     48
     D  #0DCIN                49     49
     D  #0NRDC                50     79
     D  WValDate              80     85
     D  #0TRTY                86     90
     D  #0TSTY                91    100
     D  #0CQNB               101    108
     D  WACode               109    118                                                       CGL029
     D  PEdit                119    119                                                     BUG23742
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Valid SWIFT Keywords
     D Keywords        S             20    DIM(999) FROMFILE(SDCODEL1) PERRCD(1)
 
      ** Input/Output Parameters
     D PRetCodeIn      S              7
     D PAdditional     S              1
     D PMode           S              1
     D PRtCd           S              7
     D POption         S              7
     D PSard           S              6A
     D PInputDate      S              5  0
     D PAInput         S              7A
     D PNInput         S              6  0
     D PDate           S              6
     D PDateFormat     S              1
     D PError          S              1
 
      ** Work Fields
     D WRun            S              1
     D WError          S              1
     D KABTNB          S              3
     D KABINB          S              3  0
     D W               S              2  0
     D WkAddInf        S             65
     D WCurrency       S             33
     D WSwiftCCY       S              3
     D WBlanks         S             65
     D WERIErr         S              1
     D WERIInf         S              1
     D WAllow          S              1                                                     BUG25438
     D WDetails        S           1000                                                     BUG25438
 
     D PosOCMT         S              5U 0
     D EndOCMT         S              5U 0
     D PosCHGS         S              5U 0
     D EndCHGS         S              5U 0
 
     D CSW020          S              1    INZ('N')                             SWIFT Decimal Places
 
     D X               S              5U 0
     D Y               S              5U 0
     D WrkField20      S             20
                                                                                              246418
     D ApiMode         S              1A                                                      246418
     D ScnField        S             10A                                                      246418
      *                                                                                       246418
      ** Index for arrays of error message ids, etc.                                          246418
     D Idx             S              3P 0                                                    246418
                                                                                              246418
      ** Fields used for Message Files
     D PMsgFile        S             10A   INZ('GLUSRMSG')
     D PMsgID          S             10A
     D PMsgText        S             80A
      *                                                                                       CER030
      ** Fields defined for CER030                                                            CER030
      *                                                                                       CER030
     D POptn           S              7A                                                      CER030
     D PNwrk           S              6A                                                      CER030
     D PMsgTyp         S              3A                                                      CER030
     D PBrca           S              3A                                                      CER030
     D*PCusno***       S              6P 0                                             CER030 CER059
     D PCusno          S              6                                                       CER059
     D PCcy            S              3A                                                      CER030
     D PAccd           S             10S 0                                                    CER030
     D PAcsq           S              2S 0                                                    CER030
     D PDCin           S              1A                                                      CER030
     D PTrtp           S              5A                                                      CER030
     D PNarr1          S             65A                                                      CER030
     D PNarr2          S             65A                                                      CER030
     D PNarr3          S             65A                                                      CER030
     D PNarr4          S             65A                                                      CER030
     D PNarr5          S             65A                                                      CER030
     D PNarr6          S             65A                                                      CER030
     D PRtFln1         S             70A                                                      CER030
     D PRtFln2         S             70A                                                      CER030
     D PRtFln3         S             70A                                                      CER030
     D PRtFln4         S             70A                                                      CER030
     D PRtFln5         S             70A                                                      CER030
     D PRtFln6         S             70A                                                      CER030
     D PRtFln7         S             70A                                                      CER030
     D PRtFln8         S             70A                                                      CER030
     D PRtFln9         S             70A                                                      CER030
     D PRtFln10        S             70A                                                      CER030
     D PRtFln11        S             70A                                                      CER030
     D PRtFln12        S             70A                                                      CER030
     D PRtFln13        S             70A                                                      CER030
     D PRtFln14        S             70A                                                      CER030
     D PRtFln15        S             70A                                                      CER030
     D PRtFln16        S             70A                                                      CER030
     D PRtFln17        S             70A                                                      CER030
     D PRtFln18        S             70A                                                      CER030
     D PRtFln19        S             70A                                                      CER030
     D PRtFln20        S             70A                                                      CER030
      *                                                                                       CER030
     D CER030          S              1A                                                      CER030
     D CER031          S              1A                                                      CER030
     D CGL013          S              1A                                                      CER030
      *                                                                                       CER030
     D WIdx            S              2S 0                                                    CER030
     D WPos            S              3S 0                                                    CER030
     D PExit           S              1A                                                    BUG23742
     D PCancel         S              1A                                                    BUG23742
                                                                                            MD039326
     D WStrLen         S              3S 0                                                  MD039326
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
 
     C                   IF        ApiMode = 'Y'                                              246418
     C                   EXSR      SRFilScr                                                   246418
     C                   ELSE                                                                 246418
     C                   OPEN      GL000185DF                                                 246418
     C                   ENDIF                                                                246418
                                                                                              246418
     C                   SELECT
 
      ** Validate only
 
     C                   WHEN      PMode = 'V'
     C                   IF        ApiMode <> 'Y'                                             246418
     C                   EXSR      SRMove
     C                   ENDIF                                                                246418
     C                   EXSR      SRValidate
 
     C                   WHEN      PMode = 'U'                                                246418
     C                   EXSR      SRValidate                                                 246418
     C                   IF        (WError = 'N' and #0ADI1 <> *BLANKS) or                    246418
     C                             (WError = 'N' and #0ADI1 = *BLANKS and                     246418
     C                             #0AERI <> 'N')                                             246418
     C                   EXSR      SRUpdate                                                   246418
     C                   ENDIF                                                                246418
     C                   IF        WError = 'N' and #0ADI1 = *BLANKS                          246418
     C                             and #0AERI = 'N'                                           246418
     C                   EXSR      SRDelete                                                   246418
     C                   ENDIF                                                                246418
      ** Otherwise, execute maintenance display file
 
     C                   OTHER
 
     C                   IF        PMode = 'E'
     C                   EVAL      *IN28 = *ON
     C                   ELSE
     C                   EVAL      *IN28 = *OFF
     C                   ENDIF
      *                                                                                     BUG23742
     C                   EXSR      SRMove                                                   BUG25438
     C                   IF        CER030 = 'Y' AND                                         BUG23742
     C                             PEDIT = 'N' AND                                          BUG23742
     C                             ApiMode <> 'Y'                                           BUG23742
     C                   IF        WAllow = 'Y'                                             BUG25438
     C                   EVAL      *IN28 = *OFF                                             BUG25438
     C                   ELSE                                                               BUG25438
     C                   EVAL      *IN28 = *ON                                              BUG23742
     C                   EVAL      PMsgID = 'GLX1003'                                       BUG23742
     C                   EXSR      SRSndErr                                                 BUG23742
     C                   ENDIF                                                              BUG25438
     C                   ENDIF                                                              BUG23742
 
     C                   EXSR      SRFormat
     C**********         EXSR      SRMove                                                   BUG25438
 
     C                   DOU       *INKL = *ON or WError = 'N'
     C                   EVAL      WError = 'N'
     C                   EVAL      WERIErr = 'N'
 
     C                   IF        PEDIT = 'N'                                              BUG25438
     C                   EXSR      SRValidate                                               BUG25438
     C                   IF        WDetails <> *BLANKS                                      BUG25438
     C                   EVAL      PMsgId = 'USR9375'                                       BUG25438
     C                   EXSR      SRSndErr                                                 BUG25438
     C                   ENDIF                                                              BUG25438
     C                   ENDIF                                                              BUG25438
                                                                                            BUG25438
     C                   WRITE     GL000185C0
     C                   EXFMT     GL000185F0
 
     C                   CALL      'ZA0250'
     C                   MOVEA     '0000000'     *IN(31)
 
     C                   IF        PMode = 'M' and *INKL = *OFF
     C                   EXSR      SRValidate
 
     C                   IF        (WError = 'N' and #0ADI1 <> *BLANKS) or
     C                             (WError = 'N' and #0ADI1 = *BLANKS and
     C                             #0AERI <> 'N')
     C                   EXSR      SRUpdate
     C                   ENDIF
 
     C                   IF        WError = 'N' and #0ADI1 = *BLANKS
     C                             and #0AERI = 'N'
     C                   EXSR      SRDelete
     C                   ENDIF
 
     C                   ENDIF
      *                                                                                     BUG23742
      ** If Cancel or Exit requested                                                        BUG23742
      *                                                                                     BUG23742
     C                   IF        *INKL = *ON                                              BUG23742
      *                                                                                     BUG23742
     C                   IF        #0ADI1 <> *BLANKS OR                                     BUG23742
     C                             (#0ADI1 = *BLANKS AND #0AERI <> 'N')                     BUG23742
     C                   EVAL      PAdditional = 'Y'                                        BUG23742
     C                   ENDIF                                                              BUG23742
      *                                                                                     BUG23742
     C                   EVAL      PCancel = '1'                                            BUG23742
      *                                                                                     BUG23742
     C                   ENDIF                                                              BUG23742
      *                                                                                     BUG23742
     C                   IF        *INKC = *ON                                              BUG23742
     C                   EVAL      PExit = '1'                                              BUG23742
     C                   ENDIF                                                              BUG23742
 
     C                   ENDDO
 
     C                   ENDSL
 
     C                   EVAL      *INLR = *ON
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRMove - Move File Fields to Screen Fields                    *
      *                                                               *
      * Called by: Main Processing                                    *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     SRMove        BEGSR
 
     C                   EVAL      KABTNB = #0BTNB
     C                   MOVEL     #0BINB        KABINB
     C                   EVAL      WAllow = 'N'                                             BUG25438
     C                   MOVE      WValDate      WValDateP         5 0                      AR877000
 
     C     KJENX         CHAIN     GLJENXL2
     C                   IF        %FOUND(GLJENXL2)
     C                             AND BAPTDT = WValDateP                                   AR877000
     C                   EVAL      #0ADI1 = BAADI1
     C                   EVAL      #0ADI2 = BAADI2
     C                   EVAL      #0ADI3 = BAADI3
     C                   EVAL      #0ADI4 = BAADI4
     C                   EVAL      #0ADI5 = BAADI5
     C                   EVAL      #0ADI6 = BAADI6
     C                   EVAL      #0AERI = BAAERI
     C                   IF        PEDIT ='N'                                               BUG25438
     C                   EVAL      WAllow = 'Y'                                             BUG25438
     C                   ENDIF                                                              BUG25438
     C                   ELSE
     C                   IF        B3ADI1 <> *BLANKS                                       BUG24339A
     C                             AND PMode = 'E'                                         BUG24339A
     C                   EXSR      SRFilScr                                                BUG24339A
     C                   ELSE                                                              BUG24339A
     C                   EVAL      #0ADI1 = *BLANKS
     C                   EVAL      #0ADI2 = *BLANKS
     C                   EVAL      #0ADI3 = *BLANKS
     C                   EVAL      #0ADI4 = *BLANKS
     C                   EVAL      #0ADI5 = *BLANKS
     C                   EVAL      #0ADI6 = *BLANKS
     C                   EVAL      #0AERI = 'N'
     C                   ENDIF                                                             BUG24339A
     C                   ENDIF
 
     C                   EVAL      #1DBRC = @1DBRC
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRFormat - Format Fields to Screen Fields                     *
      *                                                               *
      * Called by: Main Processing                                    *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     SRFormat      BEGSR
 
      ** Format Account Number
 
     C                   EVAL      #0ACCN = WBranch + WCNum + WCurr +
     C                                      WACode + WASeq
 
      ** Format Value Date to DDMMMYY
 
     C                   MOVE      WValDate      PDate
     C                   CALLB     'ZDATE1'
     C                   PARM                    PDate
     C                   PARM                    PInputDate
     C                   PARM                    PDateFormat
     C                   PARM      *BLANKS       PError
     C
     C                   CALL      'ZDATE2'
     C                   PARM                    PInputDate
     C                   PARM                    PDateFormat
     C                   PARM      *ZEROS        PNInput
     C                   PARM      *BLANKS       PAInput
 
     C                   EVAL      #0VLDT = PAInput
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRValidate - Validate Additional Information                  *
      *                                                               *
      * Called by: Main Processing                                    *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     SRValidate    BEGSR
 
     C                   EVAL      WDetails = #0ADI1 + #0ADI2 + #0ADI3+                     BUG25438
     C                             #0ADI4 + #0ADI5 + #0ADI6                                 BUG25438
      *                                                                                     BUG25438
      ** Additional Information 1
      ** Cannot be blank if subsequent lines are not blank
 
     C                   IF        #0ADI1 = *Blanks AND
     C                             (#0ADI2 <> *Blanks OR #0ADI3 <> *Blanks OR
     C                              #0ADI4 <> *Blanks OR #0ADI5 <> *Blanks OR
     C                              #0ADI6 <> *Blanks)
     C                   IF        PMode <> 'V'
     C                             or ApiMode = 'Y'                                           246418
     C                   EVAL      ScnField = 'DDADI1'                                        246418
     C                   EVAL      PMsgId = 'GLM0241'
     C                   EVAL      *IN31 = *ON
     C                   EVAL      WError = 'Y'
     C                   EXSR      SRSndErr
     C                   ELSE
     C                   EVAL      PRetCodeIn = '*ERROR '
     C                   GOTO      ENDVALD
     C                   ENDIF
     C                   ENDIF
 
      ** The field can only contain characters allowed by SWIFT
 
     C                   IF        #0ADI1 <> *Blanks
     C     SwiftXSet     CHECK     #0ADI1                                 29
     C                   IF        *IN29 = *ON
     C                   IF        PMode <> 'V'
     C                             or ApiMode = 'Y'                                           246418
     C                   EVAL      ScnField = 'DDADI1'                                        246418
     C                   EVAL      PMsgId = 'GLM0242'
     C                   EVAL      *IN31 = *ON
     C                   EVAL      WError = 'Y'
     C                   EXSR      SRSndErr
     C                   ELSE
     C                   EVAL      PRetCodeIn = '*ERROR '
     C                   GOTO      ENDVALD
     C                   ENDIF
     C                   ELSE
     C                   EVAL      WkAddInf = #0ADI1
     C                   EXSR      SRERIInfo
     C                   ENDIF
     C                   ENDIF
     C                   EXSR      SRERIIndi
 
      ** Additional Information 2
 
     C                   IF        #0ADI2 = *Blanks AND
     C                             (#0ADI3 <> *Blanks OR #0ADI4 <> *Blanks OR
     C                              #0ADI5 <> *Blanks OR #0ADI6 <> *Blanks)
     C                   IF        PMode <> 'V'
     C                             or ApiMode = 'Y'                                           246418
     C                   EVAL      ScnField = 'DDADI2'                                        246418
     C                   EVAL      PMsgId = 'GLM0243'
     C                   EVAL      *IN32 = *ON
     C                   EVAL      WError = 'Y'
     C                   EXSR      SRSndErr
     C                   ELSE
     C                   EVAL      PRetCodeIn = '*ERROR '
     C                   GOTO      ENDVALD
     C                   ENDIF
     C                   ENDIF
 
      ** The field can only contain characters allowed by SWIFT
 
     C                   IF        #0ADI2 <> *Blanks
     C     SwiftXSet     CHECK     #0ADI2                                 29
     C                   IF        *IN29 = *ON
     C                   IF        PMode <> 'V'
     C                             or ApiMode = 'Y'                                           246418
     C                   EVAL      ScnField = 'DDADI2'                                        246418
     C                   EVAL      PMsgId = 'GLM0242'
     C                   EVAL      *IN32 = *ON
     C                   EVAL      WError = 'Y'
     C                   EXSR      SRSndErr
     C                   ELSE
     C                   EVAL      PRetCodeIn = '*ERROR '
     C                   GOTO      ENDVALD
     C                   ENDIF
     C                   ELSE
     C                   EVAL      WkAddInf = #0ADI2
     C                   EXSR      SRERIInfo
     C                   ENDIF
     C                   ENDIF
     C                   EXSR      SRERIIndi
 
      ** Additional Information 3
 
     C                   IF        #0ADI3 = *Blanks AND
     C                             (#0ADI4 <> *Blanks OR #0ADI5 <> *Blanks OR
     C                              #0ADI6 <> *Blanks)
     C                   IF        PMode <> 'V'
     C                             or ApiMode = 'Y'                                           246418
     C                   EVAL      ScnField = 'DDADI3'                                        246418
     C                   EVAL      PMsgId = 'GLM0244'
     C                   EVAL      *IN33 = *ON
     C                   EVAL      WError = 'Y'
     C                   EXSR      SRSndErr
     C                   ELSE
     C                   EVAL      PRetCodeIn = '*ERROR '
     C                   GOTO      ENDVALD
     C                   ENDIF
     C                   ENDIF
 
      ** The field can only contain characters allowed by SWIFT
 
     C                   IF        #0ADI3 <> *Blanks
     C     SwiftXSet     CHECK     #0ADI3                                 29
     C                   IF        *IN29 = *ON
     C                   IF        PMode <> 'V'
     C                             or ApiMode = 'Y'                                           246418
     C                   EVAL      ScnField = 'DDADI3'                                        246418
     C                   EVAL      PMsgId = 'GLM0242'
     C                   EVAL      *IN33 = *ON
     C                   EVAL      WError = 'Y'
     C                   EXSR      SRSndErr
     C                   ELSE
     C                   EVAL      PRetCodeIn = '*ERROR '
     C                   GOTO      ENDVALD
     C                   ENDIF
     C                   ELSE
     C                   EVAL      WkAddInf = #0ADI3
     C                   EXSR      SRERIInfo
     C                   ENDIF
     C                   ENDIF
     C                   EXSR      SRERIIndi
 
      ** Additional Information 4
 
     C                   IF        #0ADI4 = *Blanks AND
     C                             (#0ADI5 <> *Blanks OR #0ADI6 <> *Blanks)
     C                   IF        PMode <> 'V'
     C                             or ApiMode = 'Y'                                           246418
     C                   EVAL      ScnField = 'DDADI4'                                        246418
     C                   EVAL      PMsgId = 'GLM0245'
     C                   EVAL      *IN34 = *ON
     C                   EVAL      WError = 'Y'
     C                   EXSR      SRSndErr
     C                   ELSE
     C                   EVAL      PRetCodeIn = '*ERROR '
     C                   GOTO      ENDVALD
     C                   ENDIF
     C                   ENDIF
 
      ** The field can only contain characters allowed by SWIFT
 
     C                   IF        #0ADI4 <> *Blanks
     C     SwiftXSet     CHECK     #0ADI4                                 29
     C                   IF        *IN29 = *ON
     C                   IF        PMode <> 'V'
     C                             or ApiMode = 'Y'                                           246418
     C                   EVAL      ScnField = 'DDADI4'                                        246418
     C                   EVAL      PMsgId = 'GLM0242'
     C                   EVAL      *IN34 = *ON
     C                   EVAL      WError = 'Y'
     C                   EXSR      SRSndErr
     C                   ELSE
     C                   EVAL      PRetCodeIn = '*ERROR '
     C                   GOTO      ENDVALD
     C                   ENDIF
     C                   ELSE
     C                   EVAL      WkAddInf = #0ADI4
     C                   EXSR      SRERIInfo
     C                   ENDIF
     C                   ENDIF
     C                   EXSR      SRERIIndi
 
      ** Additional Information 5
 
     C                   IF        #0ADI5 = *Blanks AND #0ADI6 <> *Blanks
     C                   IF        PMode <> 'V'
     C                             or ApiMode = 'Y'                                           246418
     C                   EVAL      ScnField = 'DDADI5'                                        246418
     C                   EVAL      PMsgId = 'GLM0246'
     C                   EVAL      *IN35 = *ON
     C                   EVAL      WError = 'Y'
     C                   EXSR      SRSndErr
     C                   ELSE
     C                   EVAL      PRetCodeIn = '*ERROR '
     C                   GOTO      ENDVALD
     C                   ENDIF
     C                   ENDIF
 
      ** The field can only contain characters allowed by SWIFT
 
     C                   IF        #0ADI5 <> *Blanks
     C     SwiftXSet     CHECK     #0ADI5                                 29
     C                   IF        *IN29 = *ON
     C                   IF        PMode <> 'V'
     C                             or ApiMode = 'Y'                                           246418
     C                   EVAL      ScnField = 'DDADI5'                                        246418
     C                   EVAL      PMsgId = 'GLM0242'
     C                   EVAL      *IN35 = *ON
     C                   EVAL      WError = 'Y'
     C                   EXSR      SRSndErr
     C                   ELSE
     C                   EVAL      PRetCodeIn = '*ERROR '
     C                   GOTO      ENDVALD
     C                   ENDIF
     C                   ELSE
     C                   EVAL      WkAddInf = #0ADI5
     C                   EXSR      SRERIInfo
     C                   ENDIF
     C                   ENDIF
     C                   EXSR      SRERIIndi
 
      ** Additional Information 6
 
      ** The field can only contain characters allowed by SWIFT
 
     C                   IF        #0ADI6 <> *Blanks
     C     SwiftXSet     CHECK     #0ADI6                                 29
     C                   IF        *IN29 = *ON
     C                   IF        PMode <> 'V'
     C                             or ApiMode = 'Y'                                           246418
     C                   EVAL      ScnField = 'DDADI6'                                        246418
     C                   EVAL      PMsgId = 'GLM0242'
     C                   EVAL      *IN36 = *ON
     C                   EVAL      WError = 'Y'
     C                   EXSR      SRSndErr
     C                   ELSE
     C                   EVAL      PRetCodeIn = '*ERROR '
     C                   GOTO      ENDVALD
     C                   ENDIF
     C                   ELSE
     C                   EVAL      WkAddInf = #0ADI6
     C                   EXSR      SRERIInfo
     C                   ENDIF
     C                   ENDIF
     C                   EXSR      SRERIIndi
                                                                                            BUG22527
      ** If no errors, continue with Extended Narrative Validation                          BUG22527
                                                                                            BUG22527
     C                   IF        WError = 'N'                                             BUG22527
      *                                                                                       CER030
      ** Call Extended Narrative Validation Program                                           CER030
      *                                                                                       CER030
     C                   IF        CGL013 = 'Y' OR CER030 = 'Y'                               CER030
     C                             OR CER031 = 'Y'                                            CER030
      *                                                                                       CER030
     C                   EVAL      PNwrk = *BLANKS                                            CER030
     C                   EVAL      PBrca = WBranch                                            CER030
     C**********         MOVEL     WCNum         PCusno                                CER030 CER059
     C                   MOVE      WCNum         PCusno                                       CER059
     C                   EVAL      PCcy = WCURR                                               CER030
     C                   MOVEL     WACode        PAccd                                        CER030
     C                   MOVEL     WASeq         PAcsq                                        CER030
     C                   EVAL      PNarr1 = #0ADI1                                            CER030
     C                   EVAL      PNarr2 = #0ADI2                                            CER030
     C                   EVAL      PNarr3 = #0ADI3                                            CER030
     C                   EVAL      PNarr4 = #0ADI4                                            CER030
     C                   EVAL      PNarr5 = #0ADI5                                            CER030
     C                   EVAL      PNarr6 = #0ADI6                                            CER030
     C                   EVAL      POptn = '*VALID'                                           CER030
      *                                                                                       CER030
     C                   CALL      'MG001900'                                                 CER030
     C                   PARM      *BLANKS       PRtcd                                        CER030
     C                   PARM                    POptn                                        CER030
     C                   PARM                    PNwrk                                        CER030
     C                   PARM                    PMsgTyp                                      CER030
     C                   PARM                    PBrca                                        CER030
     C                   PARM                    PCusno                                       CER030
     C                   PARM                    PCcy                                         CER030
     C                   PARM                    PAccd                                        CER030
     C                   PARM                    PAcsq                                        CER030
     C                   PARM                    PDCin                                        CER030
     C                   PARM                    PTrtp                                        CER030
     C                   PARM                    PNarr1                                       CER030
     C                   PARM                    PNarr2                                       CER030
     C                   PARM                    PNarr3                                       CER030
     C                   PARM                    PNarr4                                       CER030
     C                   PARM                    PNarr5                                       CER030
     C                   PARM                    PNarr6                                       CER030
     C                   PARM                    PRtFln1                                      CER030
     C                   PARM                    PRtFln2                                      CER030
     C                   PARM                    PRtFln3                                      CER030
     C                   PARM                    PRtFln4                                      CER030
     C                   PARM                    PRtFln5                                      CER030
     C                   PARM                    PRtFln6                                      CER030
     C                   PARM                    PRtFln7                                      CER030
     C                   PARM                    PRtFln8                                      CER030
     C                   PARM                    PRtFln9                                      CER030
     C                   PARM                    PRtFln10                                     CER030
     C                   PARM                    PRtFln11                                     CER030
     C                   PARM                    PRtFln12                                     CER030
     C                   PARM                    PRtFln13                                     CER030
     C                   PARM                    PRtFln14                                     CER030
     C                   PARM                    PRtFln15                                     CER030
     C                   PARM                    PRtFln16                                     CER030
     C                   PARM                    PRtFln17                                     CER030
     C                   PARM                    PRtFln18                                     CER030
     C                   PARM                    PRtFln19                                     CER030
     C                   PARM                    PRtFln20                                     CER030
     C                   PARM      *ZEROS        Idx                                          CER030
     C                   PARM      *BLANKS       FldNamXAr                                    CER030
     C                   PARM      *BLANKS       MsgIDXAr                                     CER030
     C                   PARM      *BLANKS       MsgDtaXAr                                    CER030
     C                   PARM                    WFldNmXAr                                    CER030
     C                   PARM                    WMsgIDXAr                                    CER030
     C                   PARM                    WMsgDtXAr                                    CER030
      *                                                                                       CER030
     C                   IF        PRtcd = '*ERROR'                                           CER030
     C                   EVAL      WError = 'Y'                                               CER030
      *                                                                                       CER030
     C                   IF        PMode <> 'V'                                               CER030
     C                             OR ApiMode = 'Y'                                           CER030
      *                                                                                       CER030
      ** Return values from error array                                                       CER030
      *                                                                                       CER030
     C                   EVAL      WPos = %LOOKUP('ADDI1':FldNamXAr)                          CER030
     C                   IF        WPos <> *ZEROS                                             CER030
     C                   EVAL      FldNamXAr(WPos) = 'DDADI1'                                 CER030
     C                   EVAL      *IN31 = '1'                                                CER030
     C                   ENDIF                                                                CER030
      *                                                                                       CER030
     C                   EVAL      WPos = %LOOKUP('ADDI2':FldNamXAr)                          CER030
     C                   IF        WPos <> *ZEROS                                             CER030
     C                   EVAL      FldNamXAr(WPos) = 'DDADI2'                                 CER030
     C                   EVAL      *IN32 = '1'                                                CER030
     C                   ENDIF                                                                CER030
      *                                                                                       CER030
     C                   EVAL      WPos = %LOOKUP('ADDI3':FldNamXAr)                          CER030
     C                   IF        WPos <> *ZEROS                                             CER030
     C                   EVAL      FldNamXAr(WPos) = 'DDADI3'                                 CER030
     C                   EVAL      *IN33 = '1'                                                CER030
     C                   ENDIF                                                                CER030
      *                                                                                       CER030
     C                   EVAL      WPos = %LOOKUP('ADDI4':FldNamXAr)                          CER030
     C                   IF        WPos <> *ZEROS                                             CER030
     C                   EVAL      FldNamXAr(WPos) = 'DDADI4'                                 CER030
     C                   EVAL      *IN34 = '1'                                                CER030
     C                   ENDIF                                                                CER030
      *                                                                                       CER030
     C                   EVAL      WPos = %LOOKUP('ADDI5':FldNamXAr)                          CER030
     C                   IF        WPos <> *ZEROS                                             CER030
     C                   EVAL      FldNamXAr(WPos) = 'DDADI5'                                 CER030
     C                   EVAL      *IN35 = '1'                                                CER030
     C                   ENDIF                                                                CER030
      *                                                                                       CER030
     C                   EVAL      WPos = %LOOKUP('ADDI6':FldNamXAr)                          CER030
     C                   IF        WPos <> *ZEROS                                             CER030
     C                   EVAL      FldNamXAr(WPos) = 'DDADI6'                                 CER030
     C                   EVAL      *IN36 = '1'                                                CER030
     C                   ENDIF                                                                CER030
      *                                                                                       CER030
     C                   EVAL      WPos = %LOOKUP(' ':MsgIDXAr)                               CER030
     C                   EVAL      WIdx = 1                                                   CER030
      *                                                                                       CER030
     C                   DOW       WIdx < WPos                                                CER030
      *                                                                                       CER030
     C                   EVAL      PMsgID = MsgIDXAr(WIdx)                                    CER030
     C                   EXSR      SRSndErr                                                   CER030
     C                   EVAL      WIdx = WIdx + 1                                            CER030
      *                                                                                       CER030
     C                   ENDDO                                                                CER030
      *                                                                                       CER030
     C                   ELSE                                                                 CER030
     C                   EVAL      PRetCodeIn = '*ERROR '                                     CER030
      *                                                                                       CER030
     C                   ENDIF                                                                CER030
      *                                                                                       CER030
     C                   ENDIF                                                                CER030
      *                                                                                       CER030
     C                   ENDIF                                                                CER030
 
     C                   ENDIF                                                              BUG22527
                                                                                            BUG22527
     C     ENDVALD       ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRERIIndi - Validate ERI Information Indicator                *
      *                                                               *
      * Called by: Main Processing                                    *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     SRERIIndi     BEGSR
 
      ** Validate ERI Information Indicator
 
      ** If blank, set the default
 
     C                   IF        #0AERI = *BLANKS
     C                   EVAL      #0AERI = 'N'
     C                   ENDIF
 
      ** Valid ERI Information Indicator values are '1','A','M','N'
 
     C                   IF        #0AERI <> 'N' and #0AERI <> '1' and
     C                             #0AERI <> 'A' and #0AERI <> 'M'
     C                   IF        PMode <> 'V'
     C                             or ApiMode = 'Y'                                           246418
     C                   EVAL      ScnField = 'DDAERI'                                        246418
     C                   EVAL      *IN37 = *ON
     C                   EVAL      PMsgId = 'GLM0248'
     C                   EVAL      WError = 'Y'
     C                   EXSR      SRSndErr
     C                   ELSE
     C                   EVAL      PRetCodeIn = '*ERROR '
     C                   GOTO      ENDERI
     C                   ENDIF
     C                   ENDIF
 
      ** If Additional Information fields are blank, and ERI is 'M'
 
     C                   IF        #0ADI1 = *BLANKS and #0AERI = 'M'
     C                   IF        PMode <> 'V'
     C                             or ApiMode = 'Y'                                           246418
     C                   EVAL      ScnField = 'DDAERI'                                        246418
     C                   EVAL      *IN37 = *ON
     C                   EVAL      PMsgId = 'GLM0250'
     C                   EVAL      WError = 'Y'
     C                   EXSR      SRSndErr
     C                   ELSE
     C                   EVAL      PRetCodeIn = '*ERROR '
     C                   GOTO      ENDERI
     C                   ENDIF
     C                   ENDIF
 
 
      ** If ERI Indicator is 'A' or 'N', ERI Information may not be
      ** entered in the Additional Information field
 
     C                   IF        (#0AERI = 'N' and WERIErr = 'N' and
     C                             WERIInf = 'Y') or
     C                             (#0AERI = 'A' and WERIErr = 'N' and
     C                             WERIInf = 'Y') or
     C                             (#0AERI = '1' and WERIErr = 'N' and
     C                             WERIInf = 'Y')
     C                   IF        PMode <> 'V'
     C                             or ApiMode = 'Y'                                           246418
     C                   EVAL      ScnField = 'DDAERI'                                        246418
     C                   EVAL      *IN37 = *ON
     C                   EVAL      PMsgId = 'GLM0252'
     C                   EVAL      WError = 'Y'
     C                   EXSR      SRSndErr
     C                   ELSE
     C                   EVAL      PRetCodeIn = '*ERROR '
     C                   GOTO      ENDERI
     C                   ENDIF
     C                   ENDIF
 
      ** If ERI Indicator is 'M', Additional Information field may
      ** only contain ERI Information
 
     C                   IF        #0AERI = 'M' and WERIErr = 'Y'
     C                   IF        PMode <> 'V'
     C                             or ApiMode = 'Y'                                           246418
     C                   EVAL      ScnField = 'DDAERI'                                        246418
     C                   EVAL      *IN37 = *ON
     C                   EVAL      PMsgId = 'GLM0253'
     C                   EVAL      WError = 'Y'
     C                   EXSR      SRSndErr
     C                   ELSE
     C                   EVAL      PRetCodeIn = '*ERROR '
     C                   GOTO      ENDERI
     C                   ENDIF
     C                   ENDIF
 
     C     ENDERI        ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRERIInfo - Validate ERI Information                          *
      *                                                               *
      * Called by: Main Processing                                    *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     SRERIInfo     BEGSR
 
      ** Retrieve the ERI Keywords
 
     C                   EVAL      PosOCMT = %SCAN('OCMT':WkAddInf  :1)
     C                   EVAL      EndOCMT = 0
     C                   EVAL      PosCHGS = %SCAN('CHGS':WkAddInf  :1)
     C                   EVAL      EndCHGS = 0
 
      ** The keyword OCMT must be present if #0AERI = 'M'
 
     C                   IF        #0AERI = 'M'
     C                   IF        PosOCMT = 0
     C                   EVAL      WERIErr = 'Y'
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        PosOCMT = 0 and PosCHGS = 0
     C                   EVAL      WERIInf = 'N'
     C                   ELSE
     C                   EVAL      WERIInf = 'Y'
     C                   ENDIF
 
      ** The keyword OCMT & CHGS should be between '/'
 
     C                   IF        PosOCMT > 0
     C                   IF        PosOCMT = 1
     C                             OR PosOCMT = 62 OR
     C                             %SUBST(WkAddInf  :PosOCMT-1:1) <> '/'
     C                             OR %SUBST(WkAddInf  :PosOCMT+4:1) <> '/'
     C                   EVAL      WERIErr = 'Y'
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        PosCHGS > 0
     C                   IF        PosCHGS = 1
     C                             OR PosCHGS = 62
     C                             OR %SUBST(WkAddInf  :PosCHGS-1:1) <> '/'
     C                             OR %SUBST(WkAddInf  :PosCHGS+4:1) <> '/'
     C                   EVAL      WERIErr = 'Y'
     C                   ENDIF
     C                   ENDIF
 
      ** The keyword /CHGS/ is valid only if /OCMT/ is present and prior.
 
     C                   IF        PosOCMT = 0 AND PosCHGS > 0
     C                             OR PosCHGS <> 0 AND PosCHGS < PosOCMT
     C                   EVAL      WERIErr = 'Y'
     C                   ENDIF
 
      ** Validate the currency for keyword /OCMT/
 
     C                   If        PosOCMT > 0
 
     C                   EVAL      WCurrency = *BLANKS
 
     C                   EVAL      WStrLen = %LEN(%TRIMR(WkAddInf))                         MD039326
                                                                                            MD039326
     C                   IF        (PosOCMT+5) <= WStrLen                                   MD039326
                                                                                            MD039326
      ** Retrieve the currency
 
     C                   EVAL      EndOCMT = %SCAN('/':WkAddInf  :PosOCMT+5)
     C                   IF        EndOCMT > 0
     C                   EVAL      WCurrency = %SUBST(WkAddInf  :PosOCMT+5:
     C                                              EndOCMT-PosOCMT-4)
     C                   ENDIF
                                                                                            MD039326
     C                   ENDIF                                                              MD039326
 
      ** Validate the currency
 
     C                   EXSR      SRCurrency
     C                   ENDIF
 
      ** Validate the currency keyword /CHGS/
 
     C                   If        PosCHGS > 0
 
     C                   EVAL      WCurrency = *BLANKS
 
     C                   EVAL      WStrLen = %LEN(%TRIMR(WkAddInf))                         MD039326
                                                                                            MD039326
     C                   IF        (PosCHGS+5) <= WStrLen                                   MD039326
                                                                                            MD039326
      ** Retrtieve the currency and the amount
 
     C                   EVAL      EndCHGS = %SCAN('/':WkAddInf  :PosCHGS+5)
     C                   IF        EndCHGS > 0
     C                   EVAL      WCurrency = %SUBST(WkAddInf  :PosCHGS+5:
     C                                              EndCHGS-PosCHGS-4)
     C                   ENDIF
                                                                                            MD039326
     C                   ENDIF                                                              MD039326
 
      ** Validate the currency
 
     C                   EXSR      SRCurrency
     C                   ENDIF
 
      ** The first '/' of /CHGS/ keyword could not be the last '/' of /OCMT/ detail
      ** Example: /OCMT/EUR100,/CHGS/EUR10,/ => ERROR
      **          /OCMT/EUR100,//CHGS/EUR10,/ => OK
 
     C                   IF        PosCHGS > 0
     C                             AND EndOCMT = (PosCHGS-1)
     C                   EVAL      WERIErr = 'Y'
     C                   ENDIF
 
      ** Only one keyword /OCMT/ or /CHGS/ is allowed by line.
 
     C                   IF        (PosOCMT+5+4)<%len(WkAddInf)
     C                             AND %SCAN('OCMT':WkAddInf:PosOCMT+5) > 0
     C                   EVAL      WERIErr = 'Y'
     C                   ENDIF
 
     C                   IF        (PosCHGS+5+4)<%len(WkAddInf)
     C                             AND %SCAN('CHGS':WkAddInf:PosCHGS+5) > 0
     C                   EVAL      WERIErr = 'Y'
     C                   ENDIF
 
      ** The keywords /OCMT/ or /CHGS/ should be in upper case letter.
 
     C                   IF        %SCAN('ocmt':WkAddInf:1) > 0
     C                             OR %SCAN('chgs':WkAddInf:1) > 0
     C                   EVAL      WERIErr = 'Y'
     C                   ENDIF
 
      ** Only keywords /OCMT/ or /CHGS/ are allowed.
 
     C                   EVAL      X = 1
 
      ** For each existing SWIFT Keywords
 
     C                   DOW       X <= 999
     C                             AND Keywords(X) <> *BLANKS
 
      ** Exclude keywords /OCMT/ and /CHGS/
 
     C                   IF        Keywords(X) <> '/OCMT/'
     C                             AND Keywords(X) <> '/CHGS/'
 
      ** Convert keywords in lower case
 
     C     Up:Lo         XLATE     Keywords(X)   WrkField20
 
      ** Check if the SWIFT keyword has been inserted.
 
     C                   IF        %SCAN(%TRIM(Keywords(X)):WkAddInf:1) > 0
     C                             OR %SCAN(%TRIM(WrkField20):WkAddInf:1) > 0
     C                   EVAL      WERIErr = 'Y'
     C                   ENDIF
     C                   ENDIF
 
      ** Next SWIFT Keywords
 
     C                   EVAL      X = X+1
     C                   ENDDO
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRCurrency- Validate Currency                                 *
      *                                                               *
      * Called by: Main Processing                                    *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     SRCurrency    BEGSR
 
      ** The currency should be a valid SWIFT currency code.
 
     C                   EVAL      WSwiftCCY = %SUBST(WCurrency:1:3)
     C     WSwiftCCY     CHAIN     SDCURRLD
     C                   IF        NOT %FOUND(SDCURRLD)
     C                   EVAL      WERIErr = 'Y'
     C                   LEAVESR
     C                   ENDIF
 
      ** Amount
 
      ** -- The amount can only contains numeric value till the comma.
 
     C     Numeric       CHECK     WCurrency:4   X
     C                   IF        %SUBST(WCurrency:X:1) <> ','
     C                   EVAL      WERIErr = 'Y'
     C                   LEAVESR
     C                   ENDIF
 
      ** -- The decimal part of amount can only contains numeric value till the slash.
 
     C                   EVAL      X = X + 1
     C     Numeric       CHECK     WCurrency:X   Y
     C                   IF        %SUBST(WCurrency:Y:1) <> '/'
     C                   EVAL      WERIErr = 'Y'
     C                   LEAVESR
     C                   ENDIF
 
      ** -- The number of decimal digit should be less or equal to the number of decimal
      **    places of the currency.
 
     C                   IF        CSW020 = 'N'
     C                             And (Y - X) > A6NBDP
     C                             OR CSW020 = 'Y'
     C                             And (Y - X) > A6SWDP
     C                   EVAL      WERIErr = 'Y'
     C                   ENDIF
      *
      ** End Amount
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRUpdate - Update PF/GLJENXPD                                 *
      *                                                               *
      * Called by: Main Processing                                    *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     SRUpdate      BEGSR
 
     C                   EVAL      KABTNB = #0BTNB
     C                   MOVEL     #0BINB        KABINB
 
     C     KJENX         CHAIN     GLJENXL4
     C                   IF        %FOUND(GLJENXL4)
 
      ** Update File
 
     C**********         IF        #1DBRC <> @1DBRC                                           246418
     C**********         EVAL      WError = 'Y'                                               246418
     C**********         EVAL      PMsgId = 'GLM0249'                                         246418
     C**********         EXSR      SRSndErr                                                   246418
     C**********         UNLOCK    GLJENXL4                                                   246418
     C**********         ELSE                                                                 246418
     C                   EVAL      BAADI1 = #0ADI1
     C                   EVAL      BAADI2 = #0ADI2
     C                   EVAL      BAADI3 = #0ADI3
     C                   EVAL      BAADI4 = #0ADI4
     C                   EVAL      BAADI5 = #0ADI5
     C                   EVAL      BAADI6 = #0ADI6
     C                   EVAL      BAAERI = #0AERI
     C                   UPDATE    GLJENXD0
     C                   EVAL      PAdditional = 'Y'
     C                   EVAL      #1DBRC = @1DBRC
     C**********         ENDIF                                                                246418
 
      ** Write New Record
 
     C                   ELSE
     C                   IF        #0ADI1 <> *BLANKS
     C                             OR #0AERI <> *BLANKS
     C                   EVAL      BAPTDT = BJRDNB
     C                   EVAL      BABTNB = #0BTNB
     C                   MOVEL     #0BINB        BABINB
     C                   EVAL      BAADI1 = #0ADI1
     C                   EVAL      BAADI2 = #0ADI2
     C                   EVAL      BAADI3 = #0ADI3
     C                   EVAL      BAADI4 = #0ADI4
     C                   EVAL      BAADI5 = #0ADI5
     C                   EVAL      BAADI6 = #0ADI6
     C                   EVAL      BAAERI = #0AERI
     C                   WRITE     GLJENXD0
     C                   EVAL      PAdditional = 'Y'
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRDelete - Delete from PF/GLJENXPD if amend and additional    *
      *            information fields are blanks                      *
      *                                                               *
      * Called by: Main Processing                                    *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     SRDelete      BEGSR
 
     C                   EVAL      KABTNB = #0BTNB
     C                   MOVEL     #0BINB        KABINB
 
     C     KJENX         CHAIN     GLJENXL4
     C                   IF        %FOUND(GLJENXL4)
 
      ** Delete File
 
     C                   DELETE    GLJENXD0
     C                   EVAL      PAdditional = 'N'
     C                   ENDIF
 
     C                   ENDSR
 
      **********************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRSndErr - Send Error Message                                 *
      *                                                               *
      * Called by: Main Processing                                    *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     SRSndErr      BEGSR
 
     C                   IF        ApiMode <> 'Y'                                             246418
                                                                                              246418
     C                   CALL      'ZA0340'
     C                   PARM                    PMsgFile
     C                   PARM                    PMsgID
                                                                                              246418
     C                   ELSE                                                                 246418
                                                                                              246418
     C                   ADD       1             Idx                                          246418
     C                   MOVEL     PMsgID        MsgIdXAr(Idx)                                246418
     C                   MOVEL     ScnField      FldNamXAr(Idx)                               246418
                                                                                              246418
     C                   ENDIF                                                                246418
 
     C                   ENDSR
 
      **********************************************************************                  246418
      /EJECT                                                                                  246418
      *****************************************************************                       246418
      *                                                               *                       246418
      * SRFilScr - Convert valid file fields into screen fields       *                       246418
      *            for validation                                     *                       246418
      *                                                               *                       246418
      * Called by: Main Processing                                    *                       246418
      *                                                               *                       246418
      * Calls: None                                                   *                       246418
      *                                                               *                       246418
      *****************************************************************                       246418
                                                                                              246418
     C     SRFilScr      BEGSR                                                                246418
                                                                                              246418
     C**********         EVAL      #0BTNB = B3BTNB                                            246418
     C**********         MOVEL     B3BINB        #0BINB                                       246418
     C                   EVAL      #0ADI1 = B3ADI1                                            246418
     C                   EVAL      #0ADI2 = B3ADI2                                            246418
     C                   EVAL      #0ADI3 = B3ADI3                                            246418
     C                   EVAL      #0ADI4 = B3ADI4                                            246418
     C                   EVAL      #0ADI5 = B3ADI5                                            246418
     C                   EVAL      #0ADI6 = B3ADI6                                            246418
     C                   EVAL      #0AERI = B3AERI                                            246418
                                                                                              246418
     C                   ENDSR                                                                246418
                                                                                              246418
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      * Called by: Implicitly on program activation                   *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
     C                   PARM                    PRetCodeIn
     C                   PARM                    PPostDetails
     C                   PARM                    PAdditional
     C                   PARM                    PMode
     C                   PARM                    PExit                                      BUG23742
     C                   PARM                    PCancel                                    BUG23742
     C                   PARM                    PVBITPX                                      246418
     C                   PARM                    ApiMode                                      246418
     C                   PARM                    FldNamXAr                                    246418
     C                   PARM                    MsgIDXAr                                     246418
     C                   PARM                    MsgDtaXAr                                    246418
 
      ** The following /COPY sets the program, module and procedure
      ** names for database error processing.
 
     C/COPY ZACPYSRC,DBFIELDS
 
      ** Access bank details
 
     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANKS       PRtCd
     C                   PARM      '*FIRST '     POption
     C     SDBANK        PARM      SDBANK        DSFDY
 
      ** Database error
 
     C     PRtCd         IFNE      *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBASE = 1
     C                   EVAL      DBFile = 'SDBANKPD'
     C                   EVAL      DBKEY = '*FIRST'
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Check if feature CSW020 'SWIFT Decimal Places' is present.
 
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       PRtCd
     C                   PARM      '*KEY   '     POption
     C                   PARM      'CSW020'      PSard
     C     SCSARD        PARM      SCSARD        DSFDY
      *
     C     PRtCd         IFEQ      *BLANKS
     C                   MOVE      'Y'           CSW020
     C                   ENDIF
 
      ** Move Workstation ID to screen field
 
     C                   EVAL      #0RUNA = BJMRDT
     C                   EVAL      #0USER = PSUser
     C                   EVAL      #0WSID = PSJobName
     C                   EVAL      #0PGMQ = PSProcMod
 
      ** Initialise Work Fields
 
     C                   EVAL      PDateFormat = BJDFIN
     C**********         EVAL      WError = 'Y'                                               246418
     C                   EVAL      WError = 'N'                                               246418
 
      ** KLIST for GLJENXL2
 
     C     KJENX         KLIST
     C                   KFLD                    KABTNB
     C                   KFLD                    KABINB
 
      ** Protect Input Fields if Enquiry Mode
 
      *                                                                                       CER030
      ** Check the switchable feature CER030                                                  CER030
      *                                                                                       CER030
     C                   EVAL      CER030 = 'N'                                               CER030
      *                                                                                       CER030
     C                   CALLB     'AOSARDR0'                                                 CER030
     C                   PARM      *BLANKS       PRtCd                                        CER030
     C                   PARM      '*VERIFY'     POptn                                        CER030
     C                   PARM      'CER030'      PSard                                        CER030
     C     SCSARD        PARM      SCSARD        DSFDY                                        CER030
      *                                                                                       CER030
     C                   IF        PRtcd = *BLANKS                                            CER030
     C                   EVAL      CER030 = 'Y'                                               CER030
     C                   ELSEIF    PRtcd <> '*NRF'                                            CER030
      *                                                                                       CER030
     C     *LOCK         IN        LDA                                                        CER030
     C                   EVAL      DBASE = 2                                                  CER030
     C                   EVAL      DBFile = 'AOSARDR0'                                        CER030
     C                   EVAL      DBKEY = '*VERIFY'                                          CER030
     C                   OUT       LDA                                                        CER030
     C                   EXSR      *PSSR                                                      CER030
      *                                                                                       CER030
     C                   ENDIF                                                                CER030
      *                                                                                       CER030
      ** Check the switchable feature CER031                                                  CER030
      *                                                                                       CER030
     C                   EVAL      CER031 = 'N'                                               CER030
      *                                                                                       CER030
     C                   CALLB     'AOSARDR0'                                                 CER030
     C                   PARM      *BLANKS       PRtCd                                        CER030
     C                   PARM      '*VERIFY'     POptn                                        CER030
     C                   PARM      'CER031'      PSard                                        CER030
     C     SCSARD        PARM      SCSARD        DSFDY                                        CER030
      *                                                                                       CER030
     C                   IF        PRtcd = *BLANKS                                            CER030
     C                   EVAL      CER031 = 'Y'                                               CER030
     C                   ELSEIF    PRtcd <> '*NRF'                                            CER030
      *                                                                                       CER030
     C     *LOCK         IN        LDA                                                        CER030
     C                   EVAL      DBASE = 3                                                  CER030
     C                   EVAL      DBFile = 'AOSARDR0'                                        CER030
     C                   EVAL      DBKEY = '*VERIFY'                                          CER030
     C                   OUT       LDA                                                        CER030
     C                   EXSR      *PSSR                                                      CER030
      *                                                                                       CER030
     C                   ENDIF                                                                CER030
      *                                                                                       CER030
      ** Check the switchable feature CGL013                                                  CER030
      *                                                                                       CER030
     C                   EVAL      CGL013 = 'N'                                               CER030
      *                                                                                       CER030
     C                   CALLB     'AOSARDR0'                                                 CER030
     C                   PARM      *BLANKS       PRtCd                                        CER030
     C                   PARM      '*VERIFY'     POptn                                        CER030
     C                   PARM      'CGL013'      PSard                                        CER030
     C     SCSARD        PARM      SCSARD        DSFDY                                        CER030
      *                                                                                       CER030
     C                   IF        PRtcd = *BLANKS                                            CER030
     C                   EVAL      CGL013 = 'Y'                                               CER030
     C                   ELSEIF    PRtcd <> '*NRF'                                            CER030
      *                                                                                       CER030
     C     *LOCK         IN        LDA                                                        CER030
     C                   EVAL      DBASE = 4                                                  CER030
     C                   EVAL      DBFile = 'AOSARDR0'                                        CER030
     C                   EVAL      DBKEY = '*VERIFY'                                          CER030
     C                   OUT       LDA                                                        CER030
     C                   EXSR      *PSSR                                                      CER030
      *                                                                                       CER030
     C                   ENDIF                                                                CER030
 
     C                   ENDSR
 
      *********************************************************************
      /EJECT
      *********************************************************************
      *                                                                   *
      * *PSSR  - Program exception error routine                          *
      *          Called automatically if a program error occurs,          *
      *          or directly by the program code using EXSR.              *
      *          This subroutine DUMPs the program just once.             *
      *                                                                   *
      * Called by: (**calling routines**)                                 *
      *                                                                   *
      * Calls: None                                                       *
      *                                                                   *
      *********************************************************************
 
     C     *PSSR         BEGSR
 
     C                   DUMP
 
     C                   IF        WRun = *BLANK
     C                   EVAL      WRun = 'Y'
 
     C                   CALLB     'DBERRCTL'
 
     C                   ENDIF
 
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN
 
     C                   ENDSR
 
      ********************************************************************
