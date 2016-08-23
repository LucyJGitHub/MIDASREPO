     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2006')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Update Midas Events with Equatin Events')
      *****************************************************************
      *                                                               *
      *  Midas - General Ledger Module                                *
      *                                                               *
      *  GL000539 - Transfer Events                                   *
      *                                                               *
      *  Function:  This program Update Midas Events with Equation    *
      *  Events                                                       *
      *                                                               *
      *  Called By: GLC000539 - Transfer Events                       *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2006            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *  Last Amend No. BUG14163           Date 21Jun07               *
      *  Prev Amend No. BUG13737           Date 03May07               *
      *                 BUG12221           Date 20Oct06               *
      *                 CRE026  *CREATE    Date 24May06               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  BUG14163 - Receiver value too small to hold result.          *
      *  BUG13737 - Equation passed an amount (15,0) to a Midas       *
      *             field (13,0)                                      *
      *  BUG12221 - expects report more user-friendly and remove      *
      *             redundant details                                 *
      *  CRE026 - Consumer Banking                                    *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *  U7+U8  -  Database Error                                     *
      *                                                               *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      * SRMAIN    - Main Subroutine                                   *
      * SUBRTN1   - Subroutine for Nostro when App is MM/RL           *
      * SUBRTN2   - Subroutine Non- Nostro when App is MM/RL          *
      * SUBRTN3   - Subroutine Non-Nostro when App is CP              *
      * PROCESS   - Subroutine to generate summary & write event files*
      * MAPPING1  - Mapping Subroutine for Nostro when App is MM/RL   *
      * MAPPING2  - Mapping Subroutine Non- Nostro when App is MM/RL  *
      * MAPPING3  - Mapping Subroutine Non-Nostro when App is CP      *
      * PopCUR1   - Subroutine to Populate current1 file format from  *
      *             populated EVNTXED file fields                     *
      * PopCUR2   - Subroutine to Populate current2 file format from  *
      *             populated EVNTXED file fields                     *
      * PopCUR3   - Subroutine to Populate current3 file format from  *
      *             populated FPVNTDD file fields                     *
      * PopSHDR   - Subroutine to populate work field for Sub Header  *
      * PopDTL    - Subroutine to Populate work field for detail      *
      * PopSMRY   - Subroutine to Populate work field for Summary     *
      * PopFilFld - Subroutine to Populate file fields before writing *
      *             in Event files                                    *
      * SrTrailrE - Subroutine for trailer dealing detail event file &*
      *             Audit report                                      *
      * SrTrailrF - Subroutine for trailer funds transfer payment     *
      *             events file & Audit report                        *
      * SrAUDIT   - Subroutine to output Audit report and end program *
      * SrRCFAU   - RCF Processing for Audit (AU) file                *
      * SrRCFP1   - RCF Processing for Printer (P1) file              *
      * GLZADDE   - Subroutine for Event file                         *
      * GLZSUME   - Subroutine for Event file                         *
      * GLZADDF   - Subroutine for Fund file                          *
      * GLZSUMF   - Subroutine for Fund file                          *
      * PAGHDR    - Header Subroutine                                 *
      * PR_PAGSHDR- Process Sub Header Subroutine                     *
      * PAGSHDR   - Sub Header Subroutine                             *
      * PR_PAGDTL - Process Detail Subroutine                         *
      * PAGDTL    - Detail Subroutine                                 *
      * STOTAL    - Sub Total Subroutine                              *
      * *PSSR     - Error processing Subroutine                       *
      * *INZSR    - Initialise Subroutine                             *
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
 
      *
      ** Audit file for Audit Report
     FGL000539AUO    E             PRINTER INFSR(*PSSR)
     F                                     INFDS(SPOOLU)
      *
      ** Summarized Equation Events Report
     FGL000539P1O    E             PRINTER INFSR(*PSSR)
     F                                     INFDS(SPOOL1)
      *
      ** Midas Dealing Events creation file - detail
     FEVNTXED   O    E             DISK    INFSR(*PSSR)
      *
      ** Midas Dealing Events Creation File - Trailer
     FEVNTXZZ   UF   E             DISK    INFSR(*PSSR)
     F                                     PREFIX(ET_)
      *
      ** Midas Fund Transfer PAYMENT EVENTS DETAIL
     FFPVNTDD   O    E             DISK    INFSR(*PSSR)
     F                                     PREFIX(F_)
      *
      ** Midas Fund Transfer PAYMENT EVENTS Trailer
     FFPVNTZZ   UF   E             DISK    INFSR(*PSSR)
     F                                     PREFIX(FT_)
      ** Equation Movements Logical file extracted by GL000538
     FGLEQEXTL0 IF   E           K DISK
      *
      ** New Branch Extension File
     FSDBRCXL1  IF   E           K DISK
      *
      ** Branch Code retrieval
     FSDBRCHL1  IF   E           K DISK
      *
      ** Interest Status
     FV510LF    IF   E           K DISK
      *
      ** Payment Types
     FN410LF    IF   E           K DISK
      *
      ** Midas FD Deal type/subtype
     FFDDTSTL1  IF   E           K DISK    INFSR(*PSSR)
      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ D-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      *
      ** Local data area for database error details
     D LDA           E DS           256    EXTNAME(LDA)
      ** *LOCK IN LDA immediately before and OUT LDA immediately
      ** after each database error handling.
      **
      **                                    134 141 DBFILE
      **       Defines:                     142 170 DBKEY
      **                                    171 180 DBPGM
      **                                    181 1830DBASE
      *
      ** Data Area DS for Run Date
     D RUNDAT        E DS                  EXTNAME(RUNDAT)
      *
      ** Data Area giving Installation Control Details
 
      ** Program Status Data Structure
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
      *
      * First DS For Access Programs, Short Data Structure
     D DSFDY         E DS                  EXTNAME(DSFDY)
      *
      * Second DS For Access Programs, Short Data Structure
     D DSSDY         E DS                  EXTNAME(DSSDY)
      *
      * Data Structure For Currency Details
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
      *
      * Data Structure For Bank Details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      *
      ** SPOOL Information Data Structure for GL000539P1
     D SPOOL1          DS
     D  SFILE1                83     92
     D  SFNUM1               123    124B 0
      *
      ** SPOOL Information Data Structure for GL000539AU
     D SPOOLU          DS
     D  SFILEU                83     92
     D  SFNUMU               123    124B 0
      *
      ** Midas Old dealing Events in File Format(Format 1)
     D OLD1FilFmt    E DS                  EXTNAME(EVNTXED)
     D                                     PREFIX(O1_)
      *
      ** Midas Old dealing Events in File Format(Format 2).
     D OLD2FilFmt    E DS                  EXTNAME(EVNTXED)
     D                                     PREFIX(O2_)
      *
      ** Midas Old Fund Transfer Payment Events Detail(Format 3)
     D OLD3FilFmt    E DS                  EXTNAME(FPVNTDD)
     D                                     PREFIX(O3_)
      *
      ** Midas Current  dealing Events in File Format(Format 1)
     D CUR1FilFmt    E DS                  EXTNAME(EVNTXED)
     D                                     PREFIX(C1_)
      *
      ** Midas Current  dealing Events in File Format(Format 2)
     D CUR2FilFmt    E DS                  EXTNAME(EVNTXED)
     D                                     PREFIX(C2_)
      *
      ** Midas Current  dealing Events in File Format(Format 3)
     D CUR3FilFmt    E DS                  EXTNAME(FPVNTDD)
     D                                     PREFIX(C3_)
      *
      *
      *Current Group DS
     D CUR_GRP         DS
     D CG_BRCA                 1      3
     D CG_ETYP                 4      7
     D CG_ECCY                 8     10
     D CG_EDAT                11     15P 0
      *
      ** External data structure based on SDDLSTPD file
     D SDDLST        E DS                  EXTNAME(SDDLSTPD)
      *
      ** Array for Equation values.
     D ArrEQ           S              5    DIM(11) CTDATA PERRCD(11)
      *
      ** Array for Event description
     D ArrED           S             25    DIM(11) CTDATA PERRCD(1)
      *
      ** Array for Event type
     D ArrET           S              4    DIM(11) CTDATA PERRCD(11)
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
      * Line Counter
     D LCTR            S              3  0
      *
      * Subroutine Flag
     D SRFLAG          S              1  0
      *
      * Output Count for Dealing Event Trailer
     D OutCnt1         S              5  0
      *
      * Output Count for Fund Trailer
     D OutCnt2         S              5  0
      *
      * Sub Header branch
     D W_BRNCHSH       S              3
      *
      * Sub Header Deal Number
     D W_DLNSH         S             15
      *
      * Sub Header Customer Number
     D W_CUSNSH        S              6
      *
      * Sub Header Event Type
     D W_ETYPSH        S              4
      *
      * Sub Header currency Type
     D W_ECCYSH        S              3
      *
      * Sub Header Event Date
     D W_EDTESH        S              7
      *
      * Rate work field
     D W_RATE          S             13  8
      *
      * Amount work field
     D W_EAMT          S             15  0
      *
      * Count for weighted Avr. Rate calculation.
     D COUNT           S              5  0
      *
      * Weighted Average rate work field
     D W_WARATET       S             13  8
      *
      * Total amount work field.
     D W_EAMTT         S             15  0
     D W_EAMTT2        S             13  0                                                  BUG13737
      *
      * Work field for Detail Branch
     D W_BRNCHD        S              4
      *
      * Work field for Detail Application code
     D W_APPCD         S              2
      *
      * Work field for Detail Deal Number
     D W_DLND          S             13
      *
      * Work field for Detail Customer Number
     D W_CUSND         S              6
      *
      * Work field for Detail Movement Type
     D W_TYPD          S              1
      *
      * Work field for Detail Movement Sub Type
     D W_STYPD         S              1
      *
      * Work field for Detail Loan Deposit
     D W_LNDEPD        S              1
      *
      * Work field for Detail Currency
     D W_CCYD          S              3
      *
      * Work field for Detail Event Date
     D W_DATD          S              7
      *
      * Work field for Detail Pay/Receive
     D W_PAYRD         S              1
      *
      * Work field for Detail Nostro
     D*W_NOSTD**       S              6                                                     BUG12221
     D W_NOSTD         S              7                                                     BUG12221
      *
      * Work field for Detail Rate
     D*W_RATED**       S             11  7                                                  BUG12221
     D W_RATED         S             13  8                                                  BUG12221
      *
      * Work field for Detail Event Amount
     D W_EAMTD         S             15  0
      *                                                                                     BUG12221
      * Converted C1_EDAT to DDMMMYY                                                        BUG12221
     D W_REPDAT1       S              7                                                     BUG12221
      *                                                                                     BUG12221
      * Converted C2_EDAT to DDMMMYY                                                        BUG12221
     D W_REPDAT2       S              7                                                     BUG12221
      *                                                                                     BUG12221
      * Converted C3_EDAT to DDMMMYY                                                        BUG12221
     D W_REPDAT3       S              7                                                     BUG12221
      *                                                                                     BUG12221
      * Rate work field for formatting                                                      BUG12221
     D W_RATEFMT       S             15                                                     BUG12221
      *                                                                                     BUG12221
      * Rate work field for formatting                                                      BUG12221
     D W_RATETFMT      S             15                                                     BUG12221
      *                                                                                     BUG12221
      * Decimal place field for formatting                                                  BUG12221
     D ZDECFMT         S              1  0                                                  BUG12221
      *
     D ZCDPI           S              1  0
      *
     D ZMDI1           S              1
      *
     D ZRATE1          S             13  8
      *
     D ZCDPO           S              1  0
      *
     D ZAMTCO          S             15  0
     D ZAMTCO13        S             13  0                                                  BUG14163
      *
     D ZCDPI2          S              1  0
      *
     D ZMDI12          S              1
      *
     D ZRATE12         S             13  8
      *
     D*T_EAMTE         S             15  3                                                  BUG13737
     D T_EAMTE         S             18  3                                                  BUG13737
      *
     D T_EAMTF         S             15  3
      *
     D W_EDAT1         S              7
      *
     D W_EDAT2         S              6
      *
     D DateIn          S              6
      *
     D DaynoOut        S              5  0
      *
     D ErrorFlag       S              1
      *
     D SubType         S              2
      *
      **Variable to store Concatened String
     D W_CONCT         S             20
      *
      **Work Variable to Store Index
     D Index           S              3  0
      *
      *Work variables to store Branch Name and Dealer Reference.
     D W_MAP3          S             15
     D W_MAP4          S             15
 
     D @RUN            S              1
      *
      *Work variable to store Branch Name
     D W_OMBRNM        S              3
      *
     D W_SUBTYPE       S              2
      *
      *Define the fields used in the key list
      *
     D K02_DTPE11      S              2
      *
     D K02_DLST11      S              2
      *
     D W_DSTC          S              2
      *
     D ErrMsgID        S              7
      *
      *Work variable to store Dealer Number
     D W_DLNO          S              6
      *
     D W#EAMT          S             15P 0
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
 
      *****************************************************************
      * MAIN PROCEDURE                                                *
      *****************************************************************
      *
      ** Read equation movements extract file
      *
     C                   READ      GLEQEXTL0                              98
      *
      ** Execute Header Subroutine for Summarized Equation Report
      *
     C                   EXSR      PAGHDR
      *
      ** Write Header for Audit Report layout
      *
     C                   WRITE     AU_HDR
      *
      ** If no record found in GLEQEXTL0 file
      *
     C                   IF        *IN98 = *ON
      *
      ** Write No Record for Summarized Equation Report
      *
     C                   WRITE     R_NORECFMT
      *
      ** Write No Detail & End of Report for Audit Report layout
      *
     C                   WRITE     AU_NODTL
     C                   WRITE     AU_EORPT
      *
     C                   ELSE
      *
      ** Do while end of file is not reached
      *
     C                   DOW       *IN98 = *OFF
     C                   EXSR      SRMAIN
     C                   READ      GLEQEXTL0                              98
     C                   ENDDO
      *
      ** Execute Subroutine to generate summary & write event files
      *
     C                   EXSR      PROCESS
      *
      ** Subroutine for trailer dealing detail event file & Audit report
      ** will be executed when output count for Dealing Event Trailer
      ** is greater than 1
      *
     C                   IF        OutCnt1 > 0
     C                   EXSR      SrTrailrE
     C                   ENDIF
      *
      ** Subroutine for trailer funds transfer payment events file &Audit
      ** report will be executed when output count for Dealing Fund Trailer
      ** is greater than 1
      *
     C                   IF        OutCnt2 > 0
     C                   EXSR      SrTrailrF
     C                   Endif
      *
      ** Write End of Report for Summarized Equation Report
      *
     C                   WRITE     R_ENDRPT
      *
      ** Execute Subroutine to output Audit report and end program
      *
     C                   EXSR      SrAUDIT
      *
     C                   ENDIF
      *
     C                   EVAL      *INLR = *ON
     C                   RETURN
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRMAIN - Main Subroutine                                      *
      *                                                               *
      *  Called By: MAIN PROCESSING                                   *
      *                                                               *
      *  Calls:     SUBRTN1,SUBRTN2,SUBRTN3                           *
      *****************************************************************
      *
     C     SRMAIN        BEGSR
      *
      ** Processing for Application
      *
     C                   SELECT
      *
      ** Execute Subroutine for Nostro when App is MM/RL
      *
     C                   WHEN      (OMAPP= 'MM' or OMAPP ='RL')
     C                             AND OMNST <> *Blanks
     C                   EXSR      SUBRTN1
      *
      ** Execute Subroutine Non- Nostro when App is MM/RL
      *
     C                   WHEN      (OMAPP= 'MM' or OMAPP ='RL') And OMNST=*Blanks
     C                   EXSR      SUBRTN2
      *
      ** Execute Subroutine Non-Nostro when App is CP
      *
     C                   WHEN      OMAPP = 'CP'
     C                   EXSR      SUBRTN3
      *
     C                   ENDSL
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SUBRTN1- Subroutine for Nostro when App is MM/RL
      *                                                               *
      *  Called By: SRMAIN                                            *
      *                                                               *
      *  Calls:  MAPPING1,PopCUR1,PROCESS,PopDTL,PR_PAGDTL            *
      *****************************************************************
      *
     C     SUBRTN1       BEGSR
      *
      ** Execute Mapping Subroutine for Nostro when App is MM/RL
      *
     C                   EXSR      MAPPING1
      *
      ** Populate current1 file format from populated EVNTXED file fields
      *
     C                   EXSR      PopCUR1
      *
      ** Execute Subroutine generates summary & write event files
      *
     C                   EXSR      PROCESS
      *
      ** Execute subroutine to Populate work field for detail
      *
     C                   EXSR      PopDTL
      *
      ** Process Detail Subroutine
      *
     C                   EXSR      PR_PAGDTL
      *
     C                   EVAL      SRFLAG = 1
     C                   EVAL      OLD1FilFmt = CUR1FilFmt
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SUBRTN2- Subroutine for Non-Nostro when App is MM/RL
      *                                                               *
      *  Called By: SRMAIN                                            *
      *                                                               *
      *  Calls:  MAPPING2,PopCUR2,PROCESS,PopDTL,PR_PAGDTL            *
      *****************************************************************
      ** Subroutine for Non-Nostro when App is MM/RL
      *
     C     SUBRTN2       BEGSR
      *
      ** Execute Mapping Subroutine for Non-Nostro when App is MM/RL
      *
     C                   EXSR      MAPPING2
      *
      ** Populate current2 file format from populated EVNTXED file fields
      *
     C                   EXSR      PopCUR2
      *
      ** Execute Subroutine generates summary & write event files
      *
     C                   EXSR      PROCESS
      *
     C                   IF        OLD2FilFmt = *BLANKS
     C                   EVAL      OLD2FilFmt = Cur2FilFmt
     C                   EVAL      Count = 1
     C                   EVAL      W_RATE = C2_EXRT
     C                   EVAL      W_EAMT = C2_EAMT
     C                   ENDIF
      *
      ** Execute subroutine to Populate work field for detail
      *
     C                   EXSR      PopDTL
      *
      ** Process Detail Subroutine
      *
     C                   EXSR      PR_PAGDTL
     C                   EVAL      SRFLAG = 2
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SUBRTN3- Subroutine Non-Nostro when App is CP.                *
      *                                                               *
      *  Called By: SRMAIN                                            *
      *                                                               *
      *  Calls:  MAPPING3,PopCUR3,PROCESS,PopDTL,PR_PAGDTL            *
      *****************************************************************
      *
     C     SUBRTN3       BEGSR
      *
      ** Execute Mapping Subroutine Non-Nostro when App is CP
      *
     C                   EXSR      MAPPING3
      *
      ** Populate current2 file format from populated EVNTXED file fields
      *
     C                   EXSR      PopCUR3
      *
      ** Execute Subroutine generates summary & write event files
      *
     C                   EXSR      PROCESS
      *
      ** Execute subroutine to Populate work field for detail
      *
     C                   EXSR      PopDTL
      *
      ** Process Detail Subroutine
      *
     C                   EXSR      PR_PAGDTL
      *
     C                   EVAL      SRFLAG = 3
     C                   EVAL      Old3FilFmt = CUR3FilFmt
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * PROCESS- Subroutine to generate summary and write event files *
      *                                                               *
      *  Called By: MAIN PROCEDURE                                    *
      *                                                               *
      *  Calls:  PopSHDR,PR_PAGSHDR,PopSHDR,PopSMRY,STOTAL,PopFilFld  *
      *****************************************************************
      *
     C     PROCESS       BEGSR
      *
     C                   SELECT
     C                   WHEN      SRFLAG = 0
     C                   EXSR      PopSHDR
      *
     C  N98              EXSR      PR_PAGSHDR
      *
     C                   WHEN      SRFLAG = 1
      *
     C                   EXSR      PopSHDR
     C                   EXSR      PopSMRY
     C                   EXSR      STOTAL
     C                   EXSR      PopFilFld
      *
     C                   WRITE     EVNTXEDF
      *
     C                   EVAL      OutCnt1 = OutCnt1+1
     C                   EVAL      T_EAMTE = T_EAMTE + EAMT
      *
     C  N98              EXSR      PR_PAGSHDR
      *
     C                   WHEN      SRFLAG = 2
     C                   IF        (O2_BRCA <> CG_BRCA OR O2_ETYP <> CG_ETYP
     C                             OR O2_ECCY <> CG_ECCY
     C                             OR O2_EDAT <> CG_EDAT) AND *IN98 =*OFF
      *
     C                   EXSR      PopSHDR
     C                   EXSR      PopSMRY
     C                   EXSR      STOTAL
     C                   EXSR      PopFilFld
      *
     C                   WRITE     EVNTXEDF
      *
     C                   EVAL      OutCnt1 = OutCnt1 + 1
     C                   EVAL      T_EAMTE = T_EAMTE + EAMT
      *
     C  N98              EXSR      PR_PAGSHDR
     C                   EVAL      Count = 1
     C                   EVAL      W_RATE = C2_EXRT
     C                   EVAL      W_EAMT = C2_EAMT
     C                   EVAL      Old2FilFmt = CUR2FilFmt
      *
     C                   ELSEIF    *IN98 = *ON
      *
     C                   EXSR      PopSMRY
     C                   EXSR      STOTAL
     C                   EXSR      PopFilFld
      *
     C                   WRITE     EVNTXEDF
      *
     C                   EVAL      OutCnt1 = OutCnt1 + 1
     C                   EVAL      T_EAMTE = T_EAMTE + EAMT
      *
     C                   ELSE
      *
     C                   EVAL      Count = Count + 1
     C                   EVAL      W_RATE = W_RATE + C2_EXRT
     C                   EVAL      W_EAMT = W_EAMT + C2_EAMT
      *
     C                   ENDIF
      *
     C                   WHEN      SRFLAG = 3
     C                   EXSR      PopSHDR
     C                   EXSR      PopSMRY
     C                   EXSR      STOTAL
     C                   EXSR      PopFilFld
     C                   WRITE     FPVNTDDF
     C                   EVAL      OutCnt2 = OutCnt2 + 1
     C                   EVAL      T_EAMTF = T_EAMTF + F_EAMT
      *
     C  N98              EXSR      PR_PAGSHDR
      *
     C                   ENDSL
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * MAPPING1-Mapping Subroutine for Nostro when App is MM/RL      *
      *                                                               *
      *  Called By:  SUBRTN1                                          *
      *                                                               *
      *  Calls:  *PSSR,ZDATE1,AOCURRR0,ZCONV                          *
      *****************************************************************
      *
     C
     C     MAPPING1      BEGSR
     C                   EVAL      RECI = 'D'
     C                   EVAL      W_DLNO = (%SUBST(OMDLR:1:6))
     C                   MOVEL     W_DLNO        DLNO
      *
      ** Check Whether the equation branch exist in the  file SDBRCXL1
      *
     C                   MOVEL     OMBRNM        W_OMBRNM
      *
     C     W_OMBRNM      CHAIN     SDBRCXL1
     C                   IF        %FOUND(SDBRCXL1)
      *
      ** If record exists then check weather Midas branch exist in file SDBRCHL1
      *
     C     BXBRCD        CHAIN     SDBRCHL1
     C                   IF        %FOUND(SDBRCHL1)
     C                   EVAL      CUNR = A8BICN
      *
     C                   ELSE
      *
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'SDBRCHPD'
     C                   EVAL      DBKEY  = OMBRNM
     C                   EVAL      DBASE  =  900
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   ELSE
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'SDBRCHXA'
     C                   EVAL      DBKEY  = OMBRNM
     C                   EVAL      DBASE  =  901
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   EVAL      W_CONCT = OMAPP+OMMVT+OMMVTS+OMTDT
     C                   EVAL      Index = %Lookup(W_CONCT : ArrEQ)
      *
     C                   IF        INDEX <> 0
     C                   IF        (ArrEQ(index) = 'MMPOD' and OMPRF = 'P')
     C                   EVAL      ArrET(index) = '16M4'
     C                   EVAL      R_EDSCSH = 'Principal Decrease'
     C                   ENDIF
      *
     C                   IF        (ArrEQ(index) = 'MMPOD' and OMPRF = 'R')
     C                   EVAL      ArrET(index) = '16V3'
     C                   EVAL      R_EDSCSH = 'Principal Increase'
     C                   ENDIF
      *
      ** Populate Event Type and Event Description
      *
     C                   EVAL      ETYP = ArrET(index)
     C                   EVAL      R_EDSCSH = ArrED(index)
     C                   ENDIF
      *
      ** Convert Movement Date to midas day number by calling ZDATE1
      *
     C                   MOVE      OMDTE         W_EDAT1
     C                   EVAL      W_EDAT2 = %SUBST(W_EDAT1:4:2) +
     C                                       %SUBST(W_EDAT1:6:2) +
     C                                       %SUBST(W_EDAT1:2:2)
      *
     C                   IF        W_EDAT2 = '000000'                                       BUG12221
     C                   EVAL      W_REPDAT1 = 'AT CALL'                                    BUG12221
      *                                                                                     BUG12221
     C                   ELSE                                                               BUG12221
      *                                                                                     BUG12221
     C                   CALLB     'ZDATE1'
     C                   PARM      W_EDAT2       DateIn
     C                   PARM                    DaynoOut
     C                   PARM      'M'           BJDFIN
     C                   PARM                    ErrorFlag
      *
     C                   IF        ErrorFlag = 'Y'
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'GLEQEXTL0'
     C                   EVAL      DBKEY  =  W_EDAT1
     C                   EVAL      DBASE  =  902
     C                   OUT       LDA
     C                   EXSR      *PSSR
      *
     C                   ELSE
      *
     C                   EVAL      EDAT = DaynoOut
      *                                                                                     BUG12221
     C                   CALLB     'ZDATE2'                                                 BUG12221
     C                   PARM      DaynoOut      ZDAYNO            5 0                      BUG12221
     C                   PARM                    BJDFIN                                     BUG12221
     C                   PARM      *ZERO         ZDATE             6 0                      BUG12221
     C                   PARM      *BLANK        ZADATE            7                        BUG12221
     C                   MOVE      ZADATE        W_REPDAT1                                  BUG12221
      *                                                                                     BUG12221
     C                   ENDIF                                                              BUG12221
      *                                                                                     BUG12221
     C                   ENDIF
      *
     C                   IF        OMPRF = 'P'
     C                   EVAL      EAMT = OMNWP
     C                   ENDIF
      *
     C                   IF        OMPRF = 'R'
     C                   EVAL      EAMT = OMNWR
     C                   ENDIF
      *
     C                   EVAL      ECCY = OMCCY
      *
     C                   CALL      'AOCURRR0'
     C                   PARM      '*BLANK'      @RTCD             7
     C                   PARM      '*KEY'        @OPTN             7
     C                   PARM                    OMCCY
     C     SDCURR        PARM      SDCURR        DSSDY
      *
     C                   IF        @RTCD <>*BLANK
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'SDCURRPD'
     C                   EVAL      DBKEY  = OMCCY
     C                   EVAL      DBASE  =  903
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   IF        (@RTCD = *BLANK)
     C                   EVAL      ECSS = A6SSNB
     C                   EVAL      ZCDPI= A6NBDP
     C                   EVAL      ZDECFMT = A6NBDP                                         BUG12221
     C                   EVAL      ZMDI1= A6MDIN
     C                   EVAL      ZRATE1=A6SPRT
     C                   ENDIF
      *
     C                   IF        (OMTDT = 'D')
     C                   EVAL      DTYP = 'CD'
     C                   ENDIF
      *
     C                   IF        (OMTDT = 'L')
     C                   EVAL      DTYP = 'CL'
     C                   ENDIF
      *
     C                   EVAL      DLST = W_SubType
     C                   EVAL      RDLST= *Blanks
      *
     C     W_OMBRNM      CHAIN     SDBRCXL1
     C                   IF        %FOUND(SDBRCXL1)
     C                   EVAL      BRCA = BXBRCD
     C                   EVAL      EBRC = BXBRCD
     C                   ELSE
      *
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'SDBRCHXA'
     C                   EVAL      DBKEY  = OMBRNM
     C                   EVAL      DBASE  =  905
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ** Key list for interest file
      *
     C     KINTST        KLIST
     C                   KFLD                    OMBRNM
     C                   KFLD                    OMDLP
     C                   KFLD                    OMDLR
      *
     C     KINTST        CHAIN     V510LF
     C                   IF        %FOUND(V510LF)
     C                   EVAL      EXRT = V5RAT
      *
     C                   ELSE
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'V510LF'
     C                   EVAL      DBKEY  =  OMBRNM + OMDLP + OMDLR
     C                   EVAL      DBASE  =  907
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   EVAL      NGII = 'N'
     C                   EVAL      NOTD = *ZEROS
     C                   EVAL      OTHD = *ZEROS
     C                   EVAL      OTHA = *ZEROS
     C                   EVAL      OTHC = *BLANKS
     C                   EVAL      DBCE = *ZEROS
      *
     C                   CALL      'AOCURRR0'
     C                   PARM      '*BLANK'      @RTCD             7
     C                   PARM      '*KEY'        @OPTN             7
     C                   PARM                    BJCYCD
     C     SDCURR        PARM      SDCURR        DSSDY
      *
     C                   IF        (@RTCD <>*BLANK)
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'SDCURRPD'
     C                   EVAL      DBKEY  = BJCYCD
     C                   EVAL      DBASE  =  909
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   IF        (@RTCD =*BLANKS)
     C                   EVAL      ZCDPO = A6NBDP
     C                   EVAL      ZDECFMT = A6NBDP                                         BUG12221
     C                   ENDIF
      *
     C                   EVAL      W#EAMT = EAMT
      *
     C                   CALLB     'ZCONV'
     C                   PARM                    W#EAMT
     C                   PARM                    ZRATE1
     C                   PARM                    ZMDI1
     C                   PARM                    ECCY
     C                   PARM                    BJCYCD
     C                   PARM                    ZCDPI
     C                   PARM                    ZCDPO
     C                   PARM                    ZAMTCO
      *
     C                   EVAL      EAMT = W#EAMT
      *
      *
     C**********         EVAL                    BCEQ = ZAMTCO                              BUG14163
     C                   Z-ADD     ZAMTCO        ZAMTCO13                                   BUG14163
     C                   EVAL                    BCEQ = ZAMTCO13                            BUG14163
     C                   EVAL                    DBCR = *ZEROS
     C                   EVAL                    LCEQ = *ZEROS
     C                   EVAL                    SETP = 08
     C                   Eval      OSAC1= %SUBST(OMNST:4:2)
      *
      ** Set all other fields to 0
      *
     C                   EVAL      OSACQQ = *BLANKS
     C                   EVAL      TSEN   = *BLANKS
     C                   EVAL      ZZ003  = *BLANKS
     C                   EVAL      FIPI   = *BLANKS
     C                   EVAL      INOI   = *BLANKS
     C                   EVAL      FCTI   = *BLANKS
     C                   EVAL      RLVI   = *BLANKS
     C                   EVAL      PTNU   = *BLANKS
     C                   EVAL      PARI   = *ZEROS
     C                   EVAL      CRNM   = *BLANKS
     C                   EVAL      CTWN   = *BLANKS
     C                   EVAL      CASK   = *BLANKS
     C                   EVAL      PRNM   = *BLANKS
     C                   EVAL      PTWN   = *BLANKS
     C                   EVAL      PASK   = *BLANKS
     C                   EVAL      CCTZ   = *BLANKS
     C                   EVAL      CLOC   = *BLANKS
     C                   EVAL      REGC   = *BLANKS
     C                   EVAL      DASN   = *ZEROS
     C                   EVAL      FFVD   = *ZEROS
     C                   EVAL      FFIN   = *BLANKS
     C                   EVAL      FACT   = *ZEROS
     C                   EVAL      FCNO   = *ZEROS
     C                   EVAL      FACO   = *BLANKS
     C                   EVAL      SPI    = *BLANKS
     C                   EVAL      CPCN   = *BLANKS
     C                   EVAL      FSLI   = *ZEROS
     C                   EVAL      ICIR   = *ZEROS
     C                   EVAL      ICAM   = *ZEROS
     C                   EVAL      RBDA   = *ZEROS
     C                   EVAL      OCFF   = *BLANKS
     C                   EVAL      ORBR   = *BLANKS
     C                   EVAL      COBB   = *BLANKS
     C                   EVAL      COOB   = *BLANKS
     C                   EVAL      ECPY   = *BLANKS
     C                   EVAL      IBRE   = *BLANKS
     C                   EVAL      ICYE   = *BLANKS
     C                   EVAL      EXEI   = *BLANKS
     C                   EVAL      ELVB   = *BLANKS
     C                   EVAL      ELVC   = *BLANKS
     C                   EVAL      ELVS   = *BLANKS
     C                   EVAL      OSBR   = *BLANKS
     C                   EVAL      RDTYP  = *BLANKS
     C                   EVAL      RDLST  = *BLANKS
     C                   EVAL      RSUPR  = *BLANKS
     C                   EVAL      TAXI   = *BLANKS
     C                   EVAL      FUID   = *BLANKS
     C                   EVAL      RBDN   = *ZEROS
     C                   EVAL      BOKC   = *BLANKS
     C                   EVAL      FLFL   = *BLANKS
     C                   EVAL      PCLI   = *BLANKS
     C                   EVAL      IPSI   = *BLANKS
     C                   EVAL      PTFR   = *BLANKS
     C                   EVAL      PRFC   = *BLANKS
     C                   EVAL      IFXS   = *BLANKS
     C                   EVAL      SIAC   = *BLANKS
     C                   EVAL      CFID   = *BLANKS
     C                   EVAL      CGAMT  = *ZEROS
     C                   EVAL      CMAMT  = *ZEROS
     C                   EVAL      ETAX   = *ZEROS
     C                   EVAL      OSAC2  = *BLANKS
     C                   EVAL      MCAC   = *BLANKS
     C                   EVAL      MCAT   = *ZEROS
     C                   EVAL      MCAS   = *ZEROS
     C                   EVAL      RCLAS  = *BLANKS
     C                   EVAL      CLAS   = *BLANKS
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * MAPPING2- Mapping Subroutine Non- Nostro when App is MM/RL    *
      *                                                               *
      *  Called By:  SUBRTN2                                          *
      *                                                               *
      *  Calls:  *PSSR,ZDATE1,AOCURRR0,ZCONV                          *
      *****************************************************************
      *
     C     MAPPING2      BEGSR
     C                   EVAL      RECI = 'D'
     C                   EVAL      DLNO = 999998
     C                   EVAL      CUNR = A8BICN
      *
     C                   MOVEL     OMBRNM        W_OMBRNM
      *
     C     W_OMBRNM      CHAIN     SDBRCXL1
     C                   IF        %FOUND(SDBRCXL1)
      *
      ** If record exists then check weather Midas branch exist in file SDBRCHL1
      *
     C     BXBRCD        CHAIN     SDBRCHL1
     C                   IF        %FOUND(SDBRCHL1)
     C                   Eval      CUNR = A8BICN
      *
     C                   Else
      *
     C     *LOCK         IN        LDA
     C                   Eval      DBFILE = 'SDBRCHPD'
     C                   EVAL      DBKEY  = OMBRNM
     C                   EVAL      DBASE  =  910
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   ELSE
      *
     C     *LOCK         IN        LDA
     C                   Eval      DBFILE = 'SDBRCHXA'
     C                   EVAL      DBKEY  = OMBRNM
     C                   EVAL      DBASE  =  911
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   EVAL      W_CONCT = OMAPP+OMMVT+OMMVTS+OMTDT
     C                   EVAL      Index = %Lookup(W_CONCT : ArrEQ)
      *
     C                   IF        INDEX <> 0
     C                   IF        (ArrEQ(index) = 'MMPOD' and OMPRF = 'P')
     C                   EVAL      ArrET(index) = '16M4'
     C                   EVAL      R_EDSCSH = 'Principal Decrease'
     C                   ENDIF
      *
     C                   IF        (ArrEQ(index) = 'MMPOD' and OMPRF = 'R')
     C                   EVAL      ArrET(index) = '16V3'
     C                   EVAL      R_EDSCSH = 'Principal Increase'
     C                   ENDIF
      *
      ** Populate Event Type and Event Description
      *
     C                   EVAL      ETYP = ArrET(index)
     C                   EVAL      R_EDSCSH = ArrED(index)
     C                   ENDIF
      *
      ** Convert Movement Date to midas day number by calling ZDATE1
      *
     C                   MOVE      OMDTE         W_EDAT1
     C                   EVAL      W_EDAT2 = %Subst(W_EDAT1:4:2) +
     C                                       %Subst(W_EDAT1:6:2) +
     C                                       %Subst(W_EDAT1:2:2)
      *
     C                   IF        W_EDAT2 = '000000'                                       BUG12221
     C                   EVAL      W_REPDAT2 = 'AT CALL'                                    BUG12221
      *                                                                                     BUG12221
     C                   ELSE                                                               BUG12221
      *                                                                                     BUG12221
     C                   CALLB     'ZDATE1'
     C                   PARM      W_EDAT2       DateIn
     C                   PARM                    DaynoOut
     C                   PARM      'M'           BJDFIN
     C                   PARM                    ErrorFlag
      *
     C                   IF        ErrorFlag = 'Y'
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'GLEQEXTL0'
     C                   EVAL      DBKEY  =  W_EDAT1
     C                   EVAL      DBASE  =  912
     C                   OUT       LDA
     C                   EXSR      *PSSR
      *
     C                   ELSE
      *
     C                   EVAL      EDAT = DaynoOut
      *                                                                                     BUG12221
     C                   CALLB     'ZDATE2'                                                 BUG12221
     C                   PARM      DaynoOut      ZDAYNO                                     BUG12221
     C                   PARM                    BJDFIN                                     BUG12221
     C                   PARM      *ZERO         ZDATE                                      BUG12221
     C                   PARM      *BLANK        ZADATE                                     BUG12221
     C                   MOVE      ZADATE        W_REPDAT2                                  BUG12221
      *                                                                                     BUG12221
     C                   ENDIF                                                              BUG12221
      *                                                                                     BUG12221
     C                   ENDIF
      *
     C                   IF        OMPRF = 'P'
     C                   EVAL      EAMT = OMNWP
     C                   ENDIF
      *
     C                   IF        OMPRF = 'R'
     C                   EVAL      EAMT = OMNWR
     C                   ENDIF
      *
     C                   EVAL      ECCY = OMCCY
      *
     C                   CALL      'AOCURRR0'
     C                   PARM      '*BLANK'      @RTCD             7
     C                   PARM      '*KEY'        @OPTN             7
     C                   PARM                    OMCCY
     C     SDCURR        PARM      SDCURR        DSSDY
      *
     C                   IF        @RTCD <>*BLANK
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'SDCURRPD'
     C                   EVAL      DBKEY  = OMCCY
     C                   EVAL      DBASE  =  913
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   IF        (@RTCD = *BLANK)
     C                   EVAL      ECSS = A6SSNB
     C                   EVAL      ZCDPI= A6NBDP
     C                   EVAL      ZDECFMT = A6NBDP                                         BUG12221
     C                   EVAL      ZMDI1= A6MDIN
     C                   EVAL      ZRATE1=A6SPRT
     C                   ENDIF
      *
     C                   IF        (OMTDT = 'D')
     C                   EVAL      DTYP = 'CD'
     C                   ENDIF
      *
     C                   IF        (OMTDT = 'L')
     C                   EVAL      DTYP = 'CL'
     C                   ENDIF
      *
     C                   EVAL      DLST = W_SubType
     C                   EVAL      RDLST= *Blanks
      *
     C     W_OMBRNM      CHAIN     SDBRCXL1
     C                   IF        %FOUND(SDBRCXL1)
     C                   EVAL      BRCA = BXBRCD
     C                   EVAL      EBRC = BXBRCD
      *
     C                   ELSE
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'SDBRCHXA'
     C                   EVAL      DBKEY  = OMBRNM
     C                   EVAL      DBASE  =  915
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C     KINTST        CHAIN     V510LF
     C                   IF        %FOUND(V510LF)
     C                   EVAL      EXRT = V5RAT
     C                   ELSE
      *
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'V510LF'
     C                   EVAL      DBKEY  = OMBRNM + OMDLP + OMDLR
     C                   EVAL      DBASE  =  917
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   EVAL      NGII = 'N'
     C                   EVAL      NOTD = *ZEROS
     C                   EVAL      OTHD = *ZEROS
     C                   EVAL      OTHA = *ZEROS
     C                   EVAL      OTHC = *BLANKS
     C                   EVAL      DBCE = *ZEROS
      *
     C                   CALL      'AOCURRR0'
     C                   PARM      '*BLANK'      @RTCD             7
     C                   PARM      '*KEY'        @OPTN             7
     C                   PARM                    BJCYCD
     C     SDCURR        PARM      SDCURR        DSSDY
      *
     C                   IF        (@RTCD <>*BLANKS)
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'SDCURRPD'
     C                   EVAL      DBKEY  = BJCYCD
     C                   EVAL      DBASE  =  919
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   IF        (@RTCD =*BLANKS)
     C                   EVAL      ZCDPO = A6NBDP
     C                   EVAL      ZDECFMT = A6NBDP                                         BUG12221
     C                   ENDIF
      *
     C                   EVAL      W#EAMT = EAMT
      *
     C                   CALLB     'ZCONV'
     C                   PARM                    W#EAMT
     C                   PARM                    ZRATE1
     C                   PARM                    ZMDI1
     C                   PARM                    ECCY
     C                   PARM                    BJCYCD
     C                   PARM                    ZCDPI
     C                   PARM                    ZCDPO
     C                   PARM                    ZAMTCO
      *
     C                   EVAL      EAMT = W#EAMT
      *
      *
     C**********         EVAL      BCEQ = ZAMTCO                                            BUG14163
     C                   Z-ADD     ZAMTCO        ZAMTCO13                                   BUG14163
     C                   EVAL                    BCEQ = ZAMTCO13                            BUG14163
     C                   EVAL      DBCR = *ZEROS
     C                   EVAL      LCEQ = *ZEROS
     C                   EVAL      SETP = 00
     C                   EVAL      OSAC1= *BLANKS
      *
      ** All other fields are set to 0
      *
     C                   EVAL      OSACQQ = *BLANKS
     C                   EVAL      TSEN   = *BLANKS
     C                   EVAL      ZZ003  = *BLANKS
     C                   EVAL      FIPI   = *BLANKS
     C                   EVAL      INOI   = *BLANKS
     C                   EVAL      FCTI   = *BLANKS
     C                   EVAL      RLVI   = *BLANKS
     C                   EVAL      PTNU   = *BLANKS
     C                   EVAL      PARI   = *ZEROS
     C                   EVAL      CRNM   = *BLANKS
     C                   EVAL      CTWN   = *BLANKS
     C                   EVAL      CASK   = *BLANKS
     C                   EVAL      PRNM   = *BLANKS
     C                   EVAL      PTWN   = *BLANKS
     C                   EVAL      PASK   = *BLANKS
     C                   EVAL      CCTZ   = *BLANKS
     C                   EVAL      CLOC   = *BLANKS
     C                   EVAL      REGC   = *BLANKS
     C                   EVAL      DASN   = *ZEROS
     C                   EVAL      FFVD   = *ZEROS
     C                   EVAL      FFIN   = *BLANKS
     C                   EVAL      FACT   = *ZEROS
     C                   EVAL      FCNO   = *ZEROS
     C                   EVAL      FACO   = *BLANKS
     C                   EVAL      SPI    = *BLANKS
     C                   EVAL      CPCN   = *BLANKS
     C                   EVAL      FSLI   = *ZEROS
     C                   EVAL      ICIR   = *ZEROS
     C                   EVAL      ICAM   = *ZEROS
     C                   EVAL      RBDA   = *ZEROS
     C                   EVAL      OCFF   = *BLANKS
     C                   EVAL      ORBR   = *BLANKS
     C                   EVAL      COBB   = *BLANKS
     C                   EVAL      COOB   = *BLANKS
     C                   EVAL      ECPY   = *BLANKS
     C                   EVAL      IBRE   = *BLANKS
     C                   EVAL      ICYE   = *BLANKS
     C                   EVAL      EXEI   = *BLANKS
     C                   EVAL      ELVB   = *BLANKS
     C                   EVAL      ELVC   = *BLANKS
     C                   EVAL      ELVS   = *BLANKS
     C                   EVAL      OSBR   = *BLANKS
     C                   EVAL      RDTYP  = *BLANKS
     C                   EVAL      RDLST  = *BLANKS
     C                   EVAL      RSUPR  = *BLANKS
     C                   EVAL      TAXI   = *BLANKS
     C                   EVAL      FUID   = *BLANKS
     C                   EVAL      RBDN   = *ZEROS
     C                   EVAL      BOKC   = *BLANKS
     C                   EVAL      FLFL   = *BLANKS
     C                   EVAL      PCLI   = *BLANKS
     C                   EVAL      IPSI   = *BLANKS
     C                   EVAL      PTFR   = *BLANKS
     C                   EVAL      PRFC   = *BLANKS
     C                   EVAL      IFXS   = *BLANKS
     C                   EVAL      SIAC   = *BLANKS
     C                   EVAL      CFID   = *BLANKS
     C                   EVAL      CGAMT  = *ZEROS
     C                   EVAL      CMAMT  = *ZEROS
     C                   EVAL      ETAX   = *ZEROS
     C                   EVAL      OSAC2  = *BLANKS
     C                   EVAL      MCAC   = *BLANKS
     C                   EVAL      MCAT   = *ZEROS
     C                   EVAL      MCAS   = *ZEROS
     C                   EVAL      RCLAS  = *BLANKS
     C                   EVAL      CLAS   = *BLANKS
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * MAPPING3- Mapping Subroutine Non- Nostro when App is CP       *
      *                                                               *
      *  Called By:  SUBRTN3                                          *
      *                                                               *
      *  Calls:  *PSSR,ZDATE1,AOCURRR0,ZXRATE,ZCONV                   *
      *****************************************************************
      *
      *
     C     MAPPING3      BEGSR
     C                   EVAL      F_RECI = 'D'
     C                   EVAL      W_MAP3 = %SUBST(OMBRNM:1:3)
     C                   EVAL      W_MAP4 = %SUBST(OMDLR:1:12)
     C     W_MAP3        CAT       W_MAP4        F_PREF
      *
     C                   IF        OMAPP = 'CP'
     C*
     C                   IF        OMPRF = 'P'
     C                   EVAL      F_ETYP = '91P1'
     C                   EVAL      R_EDSCSH = 'Outward Payments'
     C                   ENDIF
      *
     C                   IF        OMPRF = 'R'
     C                   EVAL      F_ETYP = '91P2'
     C                   EVAL      R_EDSCSH = 'Inward Payments'
     C                   ENDIF
     C                   ENDIF
      *
      ** Convert Movement Date to midas day number by calling ZDATE1
      *
     C                   MOVE      OMDTE         W_EDAT1
     C                   Eval      W_EDAT2 = %Subst(W_EDAT1:4:2) +
     C                                       %Subst(W_EDAT1:6:2) +
     C                                       %Subst(W_EDAT1:2:2)
      *
     C                   IF        W_EDAT2 = '000000'                                       BUG12221
     C                   EVAL      W_REPDAT3 = 'AT CALL'                                    BUG12221
      *                                                                                     BUG12221
     C                   ELSE                                                               BUG12221
      *                                                                                     BUG12221
     C                   CALLB     'ZDATE1'
     C                   PARM      W_EDAT2       DateIn
     C                   PARM                    DaynoOut
     C                   PARM      'M'           BJDFIN
     C                   PARM                    ErrorFlag
      *
     C                   IF        ErrorFlag = 'Y'
     C     *LOCK         IN        LDA
     C                   Eval      DBFILE = 'GLEQEXTL0'
     C                   Eval      DBKEY  = W_EDAT1
     C                   Eval      DBASE  =  920
     C                   OUT       LDA
     C                   EXSR      *PSSR
      *
     C                   Else
      *
     C                   Eval      F_EDAT = DaynoOut
      *                                                                                     BUG12221
     C                   CALLB     'ZDATE2'                                                 BUG12221
     C                   PARM      DaynoOut      ZDAYNO                                     BUG12221
     C                   PARM                    BJDFIN                                     BUG12221
     C                   PARM      *ZERO         ZDATE                                      BUG12221
     C                   PARM      *BLANK        ZADATE                                     BUG12221
     C                   MOVE      ZADATE        W_REPDAT3                                  BUG12221
      *                                                                                     BUG12221
     C                   ENDIF                                                              BUG12221
      *                                                                                     BUG12221
     C                   Endif
      *
     C                   IF        OMPRF= 'P'
     C                   EVAL      F_EAMT = OMNWP
     C                   ENDIF
      *
     C                   IF        OMPRF= 'R'
     C                   EVAL      F_EAMT = OMNWR
     C                   ENDIF
      *
     C                   EVAL      F_ECCY = OMCCY
      *
     C     OMPYT         CHAIN     N410LF
     C                   IF        %FOUND(N410LF)
     C                   IF        N4IO = '1'
     C                   EVAL      F_PYTP = 'IN'
     C                   EVAL      F_PYSR = 'I'
     C                   ENDIF
     C*
     C                   IF        N4IO = '2'
     C                   EVAL      F_PYTP = 'OP'
     C                   EVAL      F_PYSR = 'O'
     C                   ENDIF
      *
     C                   ELSE
      *
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE =  'N410LF'
     C                   EVAL      DBKEY  = OMPYT
     C                   EVAL      DBASE  =  921
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      *
     C                   EVAL      F_PYST = *BLANKS
     C                   EVAL      F_OTHD = *ZEROS
      *
     C                   IF        OMPRF= 'P'
     C                   EVAL      F_INOI = 'O'
     C                   ENDIF
      *
     C                   IF        OMPRF= 'R'
     C                   EVAL      F_INOI = 'I'
     C                   ENDIF
      *
     C                   IF        OMNST<>*BLANKS
     C                   EVAL      F_STNI = 'Y'
      *
     C                   ELSE
      *
     C                   EVAL      F_STNI = 'N'
     C                   ENDIF
      *
     C                   IF        F_STNI = 'Y'
     C                   EVAL      F_NOSA = %SUBST(OMNST:4:2)
      *
     C                   ELSE
      *
     C                   EVAL      F_NOSA = '00'
     C                   ENDIF
      *
     C                   IF        OMPRF = 'P'
     C                   EVAL      F_OTCY = OMRCCY
     C                   ENDIF
      *
     C                   IF        OMPRF = 'R'
     C                   EVAL      F_OTCY = OMPCCY
     C                   ENDIF
 
      *
      ** Get event currency details by AOCURRR0 Access object as given below
      *
     C                   CALL      'AOCURRR0'
     C                   PARM      '*BLANK'      @RTCD             7
     C                   PARM      '*KEY'        @OPTN             7
     C                   PARM                    F_ECCY
     C     SDCURR        PARM      SDCURR        DSSDY
      *
     C                   IF        (@RTCD <>*BLANKS)
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'SDCURRPD'
     C                   EVAL      DBKEY  = F_ECCY
     C                   EVAL      DBASE  =  924
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   IF        (@RTCD =*BLANKS)
     C                   EVAL      ZCDPI = A6NBDP
     C                   EVAL      ZDECFMT = A6NBDP                                         BUG12221
     C                   EVAL      ZMDI1 = A6MDIN
     C                   EVAL      ZRATE1= A6SPRT
     C                   ENDIF
      *
     C                   CALL      'AOCURRR0'
     C                   PARM      '*BLANK'      @RTCD             7
     C                   PARM      '*KEY'        @OPTN             7
     C                   PARM                    F_OTCY
     C     SDCURR        PARM      SDCURR        DSSDY
      *
     C                   IF        (@RTCD <>*BLANKS)
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'SDCURRPD'
     C                   EVAL      DBKEY  = F_OTCY
     C                   EVAL      DBASE  =  925
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   IF        (@RTCD = *BLANKS)
     C                   EVAL      ZCDPI2 = A6NBDP
     C                   EVAL      ZMDI12 = A6MDIN
     C                   EVAL      ZRATE12= A6SPRT
     C                   ENDIF
      *
     C                   CALL      'ZXRATE'
     C                   PARM                    ZRATE1
     C                   PARM                    ZMDI1
     C                   PARM                    ZRATE12
     C                   PARM                    ZMDI12
     C                   PARM                    ZRATEX           13 8
     C                   PARM                    ZMDIX             1
      *
     C                   EVAL                    F_RATE = ZRATEX
      *
      ** Check Whether the equation branch exist in the  file SDBRCXL1
      *
     C                   MOVEL     OMBRNM        W_OMBRNM
      *
     C     W_OMBRNM      CHAIN     SDBRCXL1
     C                   IF        %FOUND(SDBRCXL1)
     C                   EVAL      F_BRCA = BXBRCD
      *
      ** If record exists then check weather Midas branch exist in file SDBRCHL1
      *
     C     BXBRCD        CHAIN     SDBRCHL1
     C                   IF        %FOUND(SDBRCHL1)
     C                   Eval      F_CUNR = A8BICN
      *
     C                   Else
      *
     C     *LOCK         IN        LDA
     C                   Eval      DBFILE = 'SDBRCHPD'
     C                   EVAL      DBKEY  = OMBRNM
     C                   EVAL      DBASE  =  926
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   ELSE
     C     *LOCK         IN        LDA
     C                   Eval      DBFILE = 'SDBRCHXA'
     C                   EVAL      DBKEY  = OMBRNM
     C                   EVAL      DBASE  =  927
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ** Get Base currency details by AOCURRR0 Access object as given below:
      *
     C                   CALL      'AOCURRR0'
     C                   PARM      '*BLANK'      @RTCD             7
     C                   PARM      '*KEY'        @OPTN             7
     C                   PARM                    BJCYCD
     C     SDCURR        PARM      SDCURR        DSSDY
      *
     C                   IF        (@RTCD <>*BLANKS)
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'SDCURRPD'
     C                   EVAL      DBKEY  = BJCYCD
     C                   EVAL      DBASE  =  928
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   IF        (@RTCD =*BLANKS)
     C                   EVAL      ZCDPO = A6NBDP
     C                   ENDIF
      *
     C                   EVAL      W#EAMT = F_EAMT
      *
      ** Call ZCONV as below for spot rate between Event & Other currency
      *
     C                   CALLB     'ZCONV'
     C                   PARM                    W#EAMT
     C                   PARM                    ZRATE1
     C                   PARM                    ZMDI1
     C                   PARM                    F_ECCY
     C                   PARM                    BJCYCD
     C                   PARM                    ZCDPI
     C                   PARM                    ZCDPO
     C                   PARM                    ZAMTCO
      *
     C                   EVAL      F_EAMT = W#EAMT
      *
      *
     C**********         EVAL      F_DBCE = ZAMTCO                                          BUG14163
     C                   Z-ADD     ZAMTCO        ZAMTCO13                                   BUG14163
     C                   EVAL      F_DBCE = ZAMTCO13                                        BUG14163
      *
      ** Populate all other fields with blanks or zeros
      *
     C                   EVAL      F_ORBR   = *BLANKS
     C                   EVAL      F_COBB   = *BLANKS
     C                   EVAL      F_COOB   = *BLANKS
     C                   EVAL      F_EXEI   = *BLANKS
     C                   EVAL      F_ELVB   = *BLANKS
     C                   EVAL      F_ELVC   = *BLANKS
     C                   EVAL      F_ELVS   = *BLANKS
     C                   EVAL      F_OSBR   = *BLANKS
     C                   EVAL      F_EBRC   = *BLANKS
     C                   EVAL      F_ECPY   = *BLANKS
     C                   EVAL      F_IBRE   = *BLANKS
     C                   EVAL      F_ICYE   = *BLANKS
     C                   EVAL      F_CQSQ   = *ZEROS
     C                   EVAL      F_PRFC   = *BLANKS
     C                   EVAL      F_ECSS   = *ZEROS
     C                   EVAL      F_INCY   = *BLANKS
     C                   EVAL      F_BOKC   = *BLANKS
     C                   ENDSR
      ****************************************************************
      /EJECT
      ****************************************************************
      *                                                               *
      * PopCUR1 - Populate current1 file format from populated EVNTXED*
      *           file fields.                                        *
      *                                                               *
      *  Called By:  SUBRTN1                                          *
      *                                                               *
      *  Calls:  NONE                                                 *
      *****************************************************************
      *
      *
     C     PopCUR1       BEGSR
     C                   EVAL      C1_RECI = RECI
     C                   EVAL      C1_DLNO = DLNO
     C                   EVAL      C1_CUNR = CUNR
     C                   EVAL      C1_ETYP = ETYP
     C                   EVAL      C1_EDAT = EDAT
     C                   EVAL      C1_EAMT = EAMT
     C                   EVAL      C1_ECCY = ECCY
     C                   EVAL      C1_ECSS = ECSS
     C                   EVAL      C1_DTYP = DTYP
     C                   EVAL      C1_DLST = DLST
     C                   EVAL      C1_BRCA = BRCA
     C                   EVAL      C1_EBRC = EBRC
     C                   EVAL      C1_EXRT = EXRT
     C                   EVAL      C1_NGII = NGII
     C                   EVAL      C1_NOTD = NOTD
     C                   EVAL      C1_OTHD = OTHD
     C                   EVAL      C1_OTHA = OTHA
     C                   EVAL      C1_OTHC = OTHC
     C                   EVAL      C1_DBCE = DBCE
     C                   EVAL      C1_BCEQ = BCEQ
     C                   EVAL      C1_DBCR = DBCR
     C                   EVAL      C1_LCEQ = LCEQ
     C                   EVAL      C1_SETP = SETP
     C                   EVAL      C1_OSAC1= OSAC1
      *
      ** Set all other fields to Blanks or Zeros
      *
     C                   EVAL      C1_OSACQQ = *BLANKS
     C                   EVAL      C1_TSEN   = *BLANKS
     C                   EVAL      C1_ZZ003  = *BLANKS
     C                   EVAL      C1_FIPI   = *BLANKS
     C                   EVAL      C1_INOI   = *BLANKS
     C                   EVAL      C1_FCTI   = *BLANKS
     C                   EVAL      C1_RLVI   = *BLANKS
     C                   EVAL      C1_PTNU   = *BLANKS
     C                   EVAL      C1_PARI   = *ZEROS
     C                   EVAL      C1_CRNM   = *BLANKS
     C                   EVAL      C1_CTWN   = *BLANKS
     C                   EVAL      C1_CASK   = *BLANKS
     C                   EVAL      C1_PRNM   = *BLANKS
     C                   EVAL      C1_PTWN   = *BLANKS
     C                   EVAL      C1_PASK   = *BLANKS
     C                   EVAL      C1_CCTZ   = *BLANKS
     C                   EVAL      C1_CLOC   = *BLANKS
     C                   EVAL      C1_REGC   = *BLANKS
     C                   EVAL      C1_DASN   = *ZEROS
     C                   EVAL      C1_FFVD   = *ZEROS
     C                   EVAL      C1_FFIN   = *BLANKS
     C                   EVAL      C1_FACT   = *ZEROS
     C                   EVAL      C1_FCNO   = *ZEROS
     C                   EVAL      C1_FACO   = *BLANKS
     C                   EVAL      C1_SPI    = *BLANKS
     C                   EVAL      C1_CPCN   = *BLANKS
     C                   EVAL      C1_FSLI   = *ZEROS
     C                   EVAL      C1_ICIR   = *ZEROS
     C                   EVAL      C1_ICAM   = *ZEROS
     C                   EVAL      C1_RBDA   = *ZEROS
     C                   EVAL      C1_OCFF   = *BLANKS
     C                   EVAL      C1_ORBR   = *BLANKS
     C                   EVAL      C1_COBB   = *BLANKS
     C                   EVAL      C1_COOB   = *BLANKS
     C                   EVAL      C1_ECPY   = *BLANKS
     C                   EVAL      C1_IBRE   = *BLANKS
     C                   EVAL      C1_ICYE   = *BLANKS
     C                   EVAL      C1_EXEI   = *BLANKS
     C                   EVAL      C1_ELVB   = *BLANKS
     C                   EVAL      C1_ELVC   = *BLANKS
     C                   EVAL      C1_ELVS   = *BLANKS
     C                   EVAL      C1_OSBR   = *BLANKS
     C                   EVAL      C1_RDTYP  = *BLANKS
     C                   EVAL      C1_RDLST  = *BLANKS
     C                   EVAL      C1_RSUPR  = *BLANKS
     C                   EVAL      C1_TAXI   = *BLANKS
     C                   EVAL      C1_FUID   = *BLANKS
     C                   EVAL      C1_RBDN   = *ZEROS
     C                   EVAL      C1_BOKC   = *BLANKS
     C                   EVAL      C1_FLFL   = *BLANKS
     C                   EVAL      C1_PCLI   = *BLANKS
     C                   EVAL      C1_IPSI   = *BLANKS
     C                   EVAL      C1_PTFR   = *BLANKS
     C                   EVAL      C1_PRFC   = *BLANKS
     C                   EVAL      C1_IFXS   = *BLANKS
     C                   EVAL      C1_SIAC   = *BLANKS
     C                   EVAL      C1_CFID   = *BLANKS
     C                   EVAL      C1_CGAMT  = *ZEROS
     C                   EVAL      C1_CMAMT  = *ZEROS
     C                   EVAL      C1_ETAX   = *ZEROS
     C                   EVAL      C1_OSAC2  = *BLANKS
     C                   EVAL      C1_MCAC   = *BLANKS
     C                   EVAL      C1_MCAT   = *ZEROS
     C                   EVAL      C1_MCAS   = *ZEROS
     C                   EVAL      C1_RCLAS  = *BLANKS
     C                   EVAL      C1_CLAS   = *BLANKS
      *
      ** Populate CUR_GRP DS
      *
     C                   EVAL      CG_BRCA   = C1_BRCA
     C                   EVAL      CG_ETYP   = C1_ETYP
     C                   EVAL      CG_ECCY   = C1_ECCY
     C                   EVAL      CG_EDAT   = C1_EDAT
     C                   ENDSR
      ****************************************************************
      /EJECT
      ****************************************************************
      *                                                               *
      * PopCUR2 - Populate current2 file format from populated EVNTXED*
      *           file fields.                                        *
      *                                                               *
      *  Called By:  SUBRTN2                                          *
      *                                                               *
      *  Calls:  NONE                                                 *
      *****************************************************************
      *
      *
     C     PopCUR2       BEGSR
     C                   EVAL      C2_RECI = RECI
     C                   EVAL      C2_DLNO = DLNO
     C                   EVAL      C2_CUNR = CUNR
     C                   EVAL      C2_ETYP = ETYP
     C                   EVAL      C2_EDAT = EDAT
     C                   EVAL      C2_EAMT = EAMT
     C                   EVAL      C2_ECCY = ECCY
     C                   EVAL      C2_ECSS = ECSS
     C                   EVAL      C2_DTYP = DTYP
     C                   EVAL      C2_DLST = DLST
     C                   EVAL      C2_BRCA = BRCA
     C                   EVAL      C2_EBRC = EBRC
     C                   EVAL      C2_EXRT = EXRT
     C                   EVAL      C2_NGII = NGII
     C                   EVAL      C2_NOTD = NOTD
     C                   EVAL      C2_OTHD = OTHD
     C                   EVAL      C2_OTHA = OTHA
     C                   EVAL      C2_OTHC = OTHC
     C                   EVAL      C2_DBCE = DBCE
     C                   EVAL      C2_BCEQ = BCEQ
     C                   EVAL      C2_BCEQ = BCEQ
     C                   EVAL      C2_DBCR = DBCR
     C                   EVAL      C2_BCEQ = BCEQ
     C                   EVAL      C2_LCEQ = LCEQ
     C                   EVAL      C2_SETP = SETP
     C                   EVAL      C2_OSAC1= OSAC1
      *
      ** All other fields are set to 0 or blanks
      *
     C                   EVAL      C2_OSACQQ = *BLANKS
     C                   EVAL      C2_TSEN   = *BLANKS
     C                   EVAL      C2_ZZ003  = *BLANKS
     C                   EVAL      C2_FIPI   = *BLANKS
     C                   EVAL      C2_INOI   = *BLANKS
     C                   EVAL      C2_FCTI   = *BLANKS
     C                   EVAL      C2_RLVI   = *BLANKS
     C                   EVAL      C2_PTNU   = *BLANKS
     C                   EVAL      C2_PARI   = *ZEROS
     C                   EVAL      C2_CRNM   = *BLANKS
     C                   EVAL      C2_CTWN   = *BLANKS
     C                   EVAL      C2_CASK   = *BLANKS
     C                   EVAL      C2_PRNM   = *BLANKS
     C                   EVAL      C2_PTWN   = *BLANKS
     C                   EVAL      C2_PASK   = *BLANKS
     C                   EVAL      C2_CCTZ   = *BLANKS
     C                   EVAL      C2_CLOC   = *BLANKS
     C                   EVAL      C2_REGC   = *BLANKS
     C                   EVAL      C2_DASN   = *ZEROS
     C                   EVAL      C2_FFVD   = *ZEROS
     C                   EVAL      C2_FFIN   = *BLANKS
     C                   EVAL      C2_FACT   = *ZEROS
     C                   EVAL      C2_FCNO   = *ZEROS
     C                   EVAL      C2_FACO   = *BLANKS
     C                   EVAL      C2_SPI    = *BLANKS
     C                   EVAL      C2_CPCN   = *BLANKS
     C                   EVAL      C2_FSLI   = *ZEROS
     C                   EVAL      C2_ICIR   = *ZEROS
     C                   EVAL      C2_ICAM   = *ZEROS
     C                   EVAL      C2_RBDA   = *ZEROS
     C                   EVAL      C2_OCFF   = *BLANKS
     C                   EVAL      C2_ORBR   = *BLANKS
     C                   EVAL      C2_COBB   = *BLANKS
     C                   EVAL      C2_COOB   = *BLANKS
     C                   EVAL      C2_ECPY   = *BLANKS
     C                   EVAL      C2_IBRE   = *BLANKS
     C                   EVAL      C2_ICYE   = *BLANKS
     C                   EVAL      C2_EXEI   = *BLANKS
     C                   EVAL      C2_ELVB   = *BLANKS
     C                   EVAL      C2_ELVC   = *BLANKS
     C                   EVAL      C2_ELVS   = *BLANKS
     C                   EVAL      C2_OSBR   = *BLANKS
     C                   EVAL      C2_RDTYP  = *BLANKS
     C                   EVAL      C2_RDLST  = *BLANKS
     C                   EVAL      C2_RSUPR  = *BLANKS
     C                   EVAL      C2_TAXI   = *BLANKS
     C                   EVAL      C2_FUID   = *BLANKS
     C                   EVAL      C2_RBDN   = *ZEROS
     C                   EVAL      C2_BOKC   = *BLANKS
     C                   EVAL      C2_FLFL   = *BLANKS
     C                   EVAL      C2_PCLI   = *BLANKS
     C                   EVAL      C2_IPSI   = *BLANKS
     C                   EVAL      C2_PTFR   = *BLANKS
     C                   EVAL      C2_PRFC   = *BLANKS
     C                   EVAL      C2_IFXS   = *BLANKS
     C                   EVAL      C2_SIAC   = *BLANKS
     C                   EVAL      C2_CFID   = *BLANKS
     C                   EVAL      C2_CGAMT  = *ZEROS
     C                   EVAL      C2_CMAMT  = *ZEROS
     C                   EVAL      C2_ETAX   = *ZEROS
     C                   EVAL      C2_OSAC2  = *BLANKS
     C                   EVAL      C2_MCAC   = *BLANKS
     C                   EVAL      C2_MCAT   = *ZEROS
     C                   EVAL      C2_MCAS   = *ZEROS
     C                   EVAL      C2_RCLAS  = *BLANKS
     C                   EVAL      C2_CLAS   = *BLANKS
      *
      ** Populate CUR_GRP DS
      *
     C                   EVAL      CG_BRCA   = C2_BRCA
     C                   EVAL      CG_ETYP   = C2_ETYP
     C                   EVAL      CG_ECCY   = C2_ECCY
     C                   EVAL      CG_EDAT   = C2_EDAT
     C                   ENDSR
      ****************************************************************
      /EJECT
      ****************************************************************
      *                                                               *
      * PopCUR3 - Populate current3 file format from populated EVNTXED*
      *           file fields.                                        *
      *                                                               *
      *  Called By:  SUBRTN3                                          *
      *                                                               *
      *  Calls:  NONE                                                 *
      *****************************************************************
      *
     C     PopCUR3       BEGSR
     C                   EVAL      C3_RECI = F_RECI
     C                   EVAL      C3_PREF = F_PREF
     C                   EVAL      C3_ETYP = F_ETYP
     C                   EVAL      C3_EDAT = F_EDAT
     C                   EVAL      C3_EAMT = F_EAMT
     C                   EVAL      C3_ECCY = F_ECCY
     C                   EVAL      C3_PYTP = F_PYTP
     C                   EVAL      C3_PYST = F_PYST
     C                   EVAL      C3_OTHD = F_OTHD
     C                   EVAL      C3_INOI = F_INOI
     C                   EVAL      C3_STNI = F_STNI
     C                   EVAL      C3_NOSA = F_NOSA
     C                   EVAL      C3_RATE = F_RATE
     C                   EVAL      C3_PYSR = F_PYSR
     C                   EVAL      C3_OTCY = F_OTCY
     C                   EVAL      C3_CUNR = F_CUNR
     C                   EVAL      C3_DBCE = F_DBCE
     C                   EVAL      C3_BRCA = F_BRCA
      *
      ** Populate all other fields with blanks or zeros
      *
     C                   EVAL      C3_ORBR   = *BLANKS
     C                   EVAL      C3_COBB   = *BLANKS
     C                   EVAL      C3_COOB   = *BLANKS
     C                   EVAL      C3_EXEI   = *BLANKS
     C                   EVAL      C3_ELVB   = *BLANKS
     C                   EVAL      C3_ELVC   = *BLANKS
     C                   EVAL      C3_ELVS   = *BLANKS
     C                   EVAL      C3_OSBR   = *BLANKS
     C                   EVAL      C3_EBRC   = *ZEROS
     C                   EVAL      C3_ECPY   = *BLANKS
     C                   EVAL      C3_IBRE   = *BLANKS
     C                   EVAL      C3_ICYE   = *BLANKS
     C                   EVAL      C3_CQSQ   = *ZEROS
     C                   EVAL      C3_PRFC   = *BLANKS
     C                   EVAL      C3_ECSS   = *ZEROS
     C                   EVAL      C3_INCY   = *BLANKS
     C                   EVAL      C3_BOKC   = *BLANKS
      *
      ** Populate CUR_GRP DS
      *
     C                   EVAL      CG_BRCA   = C3_BRCA
     C                   EVAL      CG_ETYP   = C3_ETYP
     C                   EVAL      CG_ECCY   = C3_ECCY
     C                   EVAL      CG_EDAT   = C3_EDAT
     C                   ENDSR
      *
      ****************************************************************
      /EJECT
      ****************************************************************
      *                                                               *
      * PopSHDR - Populate work field for Sub Geader                  *
      *           file fields.                                        *
      *                                                               *
      *  Called By:  PROCESS                                          *
      *                                                               *
      *  Calls:  NONE                                                 *
      *****************************************************************
      *
     C     PopSHDR       BEGSR
     C                   SELECT
     C                   WHEN      (OMAPP= 'MM' or OMAPP ='RL')
     C                             AND OMNST<> *BLANKS
      *
     C                   EVAL      W_BRNCHSH = C1_BRCA
     C                   MOVEL     C1_DLNO       W_DLNSH
     C                   EVAL      W_CUSNSH  = C1_CUNR
     C                   EVAL      W_ETYPSH  = C1_ETYP
     C                   EVAL      W_ECCYSH  = C1_ECCY
     C**********         MOVEL     C1_EDAT       W_EDTESH                                   BUG12221
     C                   EVAL      W_EDTESH  = W_REPDAT1                                    BUG12221
     C                   WHEN      (OMAPP= 'MM' or OMAPP ='RL')
     C                             AND OMNST=  *BLANKS
      *
     C                   EVAL      W_BRNCHSH = C2_BRCA
     C                   MOVEL     C2_DLNO       W_DLNSH
     C                   EVAL      W_CUSNSH  = C2_CUNR
     C                   EVAL      W_ETYPSH  =   C2_ETYP
     C                   EVAL      W_ECCYSH  = C2_ECCY
     C**********         MOVEL     C2_EDAT       W_EDTESH                                   BUG12221
     C                   EVAL      W_EDTESH  = W_REPDAT2                                    BUG12221
      *
     C                   WHEN      (OMAPP= 'CP')
     C                   EVAL      W_BRNCHSH = C3_BRCA
     C                   EVAL      W_DLNSH   = C3_PREF
     C                   EVAL      W_CUSNSH  = C3_CUNR
     C                   EVAL      W_ETYPSH  = C3_ETYP
     C                   EVAL      W_ECCYSH  = C3_ECCY
     C**********         MOVEL     C3_EDAT       W_EDTESH                                   BUG12221
     C                   EVAL      W_EDTESH  = W_REPDAT3                                    BUG12221
     C                   ENDSL
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *****************************************************************
      *                                                               *
      * PopDTL - Populate work field for detail                       *
      *          file fields.                                         *
      *                                                               *
      *  Called By:  SUBRTN1,SUBRTN2,SUBRTN3                          *
      *                                                               *
      *  Calls:  NONE                                                 *
      *****************************************************************
      *
     C     POPDTL        BEGSR
     C                   EVAL      W_BRNCHD = OMBRNM
     C                   EVAL      W_APPCD  = OMAPP
     C                   EVAL      W_DLND   = OMDLR
     C                   EVAL      W_CUSND  = OMCUS
     C                   EVAL      W_TYPD   = OMMVT
     C                   EVAL      W_STYPD  = OMMVTS
     C                   EVAL      W_LNDEPD = OMTDT
     C                   EVAL      W_CCYD   = OMCCY
     C**********         MOVEL     OMDTE         W_DATD                                     BUG12221
     C                   EVAL      W_PAYRD  = OMPRF
     C**********         EVAL      W_NOSTD  = OMNST                                         BUG12221
     C                   EVAL      W_NOSTD  = *BLANKS                                       BUG12221
     C                   MOVEL     OMNST         W_NOSTD                                    BUG12221
      *                                                                                     BUG12221
     C                   IF        OMNST = *BLANKS                                          BUG12221
     C                   EVAL      W_NOSTD  = 'Summary'                                     BUG12221
     C                   ENDIF                                                              BUG12221
      *                                                                                     BUG12221
     C                   IF        OMAPP = 'MM' OR OMAPP = 'RL'
     C                   EVAL      W_RATED = V5RAT
      *
      ** Chain to interest status file V510LF with composite key
      *
     C     KINTST        CHAIN     V510LF
     C                   IF        %FOUND(V510LF)
     C                   EVAL      W_RATED = V5RAT
      *
     C                   ELSE
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'V510LF'
     C                   EVAL      DBKEY  = OMBRNM + OMDLP + OMDLR
     C                   EVAL      DBASE  =  930
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
     C                   ENDIF
      *
     C                   IF        OMAPP = 'CP'
     C                   EVAL      W_RATED = C3_RATE
     C                   ENDIF
      *
     C                   IF        OMPRF = 'P'
     C                   EVAL      W_EAMTD = OMNWP
     C                   ENDIF
     C                   IF        OMPRF = 'R'
     C                   EVAL      W_EAMTD = OMNWR
     C                   ENDIF
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *****************************************************************
      *                                                               *
      * PopSMRY- Populate work field for summary                      *
      *          file fields.                                         *
      *                                                               *
      *  Called By:  PROCESS                                          *
      *                                                               *
      *  Calls:  NONE                                                 *
      *****************************************************************
     C     PopSMRY       BEGSR
     C                   SELECT
      *
     C                   WHEN      SRFLAG =  1
     C                   EVAL      W_WARATET = O1_EXRT
     C                   EVAL      W_EAMTT   = O1_EAMT
      *
     C                   WHEN      SRFLAG =  2
     C                   EVAL      W_WARATET = W_RATE/COUNT
     C                   EVAL      W_EAMTT   = W_EAMT
      *
     C                   WHEN      SRFLAG =  3
     C                   EVAL      W_WARATET = O3_RATE
     C                   EVAL      W_EAMTT   = O3_EAMT
      *
     C                   ENDSL
     C                   ENDSR
      ****************************************************************
      /EJECT
      *****************************************************************
      *****************************************************************
      *                                                               *
      * PopFilFld -  Populate file fields before writing in Event     *
      *              files                                            *
      *                                                               *
      *  Called By:  PROCESS                                          *
      *                                                               *
      *  Calls:  NONE                                                 *
      *****************************************************************
      *
     C     PoPFilFld     BEGSR
     C                   IF        SRFLAG = 1
      *
     C                   EVAL      RECI = O1_RECI
     C                   EVAL      DLNO = O1_DLNO
     C                   EVAL      CUNR = O1_CUNR
     C                   EVAL      ETYP = O1_ETYP
     C                   EVAL      EDAT = O1_EDAT
     C                   EVAL      EAMT = W_EAMTT
     C                   EVAL      ECCY = O1_ECCY
     C                   EVAL      ECSS = O1_ECSS
     C                   EVAL      DTYP = O1_DTYP
     C                   EVAL      DLST = O1_DLST
     C                   EVAL      BRCA = O1_BRCA
     C                   EVAL      EBRC = O1_EBRC
     C                   EVAL      EXRT = W_WARATET
     C                   EVAL      NGII = O1_NGII
     C                   EVAL      NOTD = O1_NOTD
     C                   EVAL      OTHD = O1_OTHD
     C                   EVAL      OTHA = O1_OTHA
     C                   EVAL      OTHC = O1_OTHC
     C                   EVAL      DBCE = O1_DBCE
     C                   EVAL      BCEQ = O1_BCEQ
     C                   EVAL      DBCR = O1_DBCR
     C                   EVAL      LCEQ = O1_LCEQ
     C                   EVAL      SETP = O1_SETP
     C                   EVAL      OSAC1 = O1_OSAC1
      *
      ** Populate all other fields with blanks or zeros
      *
     C                   EVAL      OSACQQ = *BLANKS
     C                   EVAL      TSEN   = *BLANKS
     C                   EVAL      ZZ003  = *BLANKS
     C                   EVAL      FIPI   = *BLANKS
     C                   EVAL      INOI   = *BLANKS
     C                   EVAL      FCTI   = *BLANKS
     C                   EVAL      RLVI   = *BLANKS
     C                   EVAL      PTNU   = *BLANKS
     C                   EVAL      PARI   = *ZEROS
     C                   EVAL      CRNM   = *BLANKS
     C                   EVAL      CTWN   = *BLANKS
     C                   EVAL      CASK   = *BLANKS
     C                   EVAL      PRNM   = *BLANKS
     C                   EVAL      PTWN   = *BLANKS
     C                   EVAL      PASK   = *BLANKS
     C                   EVAL      CCTZ   = *BLANKS
     C                   EVAL      CLOC   = *BLANKS
     C                   EVAL      REGC   = *BLANKS
     C                   EVAL      DASN   = *ZEROS
     C                   EVAL      FFVD   = *ZEROS
     C                   EVAL      FFIN   = *BLANKS
     C                   EVAL      FACT   = *ZEROS
     C                   EVAL      FCNO   = *ZEROS
     C                   EVAL      FACO   = *BLANKS
     C                   EVAL      SPI    = *BLANKS
     C                   EVAL      CPCN   = *BLANKS
     C                   EVAL      FSLI   = *ZEROS
     C                   EVAL      ICIR   = *ZEROS
     C                   EVAL      ICAM   = *ZEROS
     C                   EVAL      RBDA   = *ZEROS
     C                   EVAL      OCFF   = *BLANKS
     C                   EVAL      ORBR   = *BLANKS
     C                   EVAL      COBB   = *BLANKS
     C                   EVAL      COOB   = *BLANKS
     C                   EVAL      ECPY   = *BLANKS
     C                   EVAL      IBRE   = *BLANKS
     C                   EVAL      ICYE   = *BLANKS
     C                   EVAL      EXEI   = *BLANKS
     C                   EVAL      ELVB   = *BLANKS
     C                   EVAL      ELVC   = *BLANKS
     C                   EVAL      ELVS   = *BLANKS
     C                   EVAL      OSBR   = *BLANKS
     C                   EVAL      RDTYP  = *BLANKS
     C                   EVAL      RDLST  = *BLANKS
     C                   EVAL      RSUPR  = *BLANKS
     C                   EVAL      TAXI   = *BLANKS
     C                   EVAL      FUID   = *BLANKS
     C                   EVAL      RBDN   = *ZEROS
     C                   EVAL      BOKC   = *BLANKS
     C                   EVAL      FLFL   = *BLANKS
     C                   EVAL      PCLI   = *BLANKS
     C                   EVAL      IPSI   = *BLANKS
     C                   EVAL      PTFR   = *BLANKS
     C                   EVAL      PRFC   = *BLANKS
     C                   EVAL      IFXS   = *BLANKS
     C                   EVAL      SIAC   = *BLANKS
     C                   EVAL      CFID   = *BLANKS
     C                   EVAL      CGAMT  = *ZEROS
     C                   EVAL      CMAMT  = *ZEROS
     C                   EVAL      ETAX   = *ZEROS
     C                   EVAL      OSAC2  = *BLANKS
     C                   EVAL      MCAC   = *BLANKS
     C                   EVAL      MCAT   = *ZEROS
     C                   EVAL      MCAS   = *ZEROS
     C                   EVAL      RCLAS  = *BLANKS
     C                   EVAL      CLAS   = *BLANKS
     C                   ENDIF
      *
     C                   IF        SRFLAG = 2
      *
     C                   EVAL      RECI = O2_RECI
     C                   EVAL      DLNO = O2_DLNO
     C                   EVAL      CUNR = O2_CUNR
     C                   EVAL      ETYP = O2_ETYP
     C                   EVAL      EDAT = O2_EDAT
     C                   Z-ADD     W_EAMTT       W_EAMTT2                                   BUG13737
     C**********         EVAL      EAMT = W_EAMTT                                           BUG13737
     C                   EVAL      EAMT = W_EAMTT2                                          BUG13737
     C                   EVAL      ECCY = O2_ECCY
     C                   EVAL      ECSS = O2_ECSS
     C                   EVAL      DTYP = O2_DTYP
     C                   EVAL      DLST = O2_DLST
     C                   EVAL      BRCA = O2_BRCA
     C                   EVAL      EBRC = O2_EBRC
     C                   EVAL      EXRT = W_WARATET
     C                   EVAL      NGII = O2_NGII
     C                   EVAL      NOTD = O2_NOTD
     C                   EVAL      OTHD = O2_OTHD
     C                   EVAL      OTHA = O2_OTHA
     C                   EVAL      OTHC = O2_OTHC
     C                   EVAL      DBCE = O2_DBCE
     C                   EVAL      BCEQ = O2_BCEQ
     C                   EVAL      DBCR = O2_DBCR
     C                   EVAL      LCEQ = O2_LCEQ
     C                   EVAL      SETP = O2_SETP
     C                   EVAL      OSAC1 = O2_OSAC1
      *
      ** Populate all other fields with blanks or zeros
      *
     C                   EVAL      OSACQQ = *BLANKS
     C                   EVAL      TSEN   = *BLANKS
     C                   EVAL      ZZ003  = *BLANKS
     C                   EVAL      FIPI   = *BLANKS
     C                   EVAL      INOI   = *BLANKS
     C                   EVAL      FCTI   = *BLANKS
     C                   EVAL      RLVI   = *BLANKS
     C                   EVAL      PTNU   = *BLANKS
     C                   EVAL      PARI   = *ZEROS
     C                   EVAL      CRNM   = *BLANKS
     C                   EVAL      CTWN   = *BLANKS
     C                   EVAL      CASK   = *BLANKS
     C                   EVAL      PRNM   = *BLANKS
     C                   EVAL      PTWN   = *BLANKS
     C                   EVAL      PASK   = *BLANKS
     C                   EVAL      CCTZ   = *BLANKS
     C                   EVAL      CLOC   = *BLANKS
     C                   EVAL      REGC   = *BLANKS
     C                   EVAL      DASN   = *ZEROS
     C                   EVAL      FFVD   = *ZEROS
     C                   EVAL      FFIN   = *BLANKS
     C                   EVAL      FACT   = *ZEROS
     C                   EVAL      FCNO   = *ZEROS
     C                   EVAL      FACO   = *BLANKS
     C                   EVAL      SPI    = *BLANKS
     C                   EVAL      CPCN   = *BLANKS
     C                   EVAL      FSLI   = *ZEROS
     C                   EVAL      ICIR   = *ZEROS
     C                   EVAL      ICAM   = *ZEROS
     C                   EVAL      RBDA   = *ZEROS
     C                   EVAL      OCFF   = *BLANKS
     C                   EVAL      ORBR   = *BLANKS
     C                   EVAL      COBB   = *BLANKS
     C                   EVAL      COOB   = *BLANKS
     C                   EVAL      ECPY   = *BLANKS
     C                   EVAL      IBRE   = *BLANKS
     C                   EVAL      ICYE   = *BLANKS
     C                   EVAL      EXEI   = *BLANKS
     C                   EVAL      ELVB   = *BLANKS
     C                   EVAL      ELVC   = *BLANKS
     C                   EVAL      ELVS   = *BLANKS
     C                   EVAL      OSBR   = *BLANKS
     C                   EVAL      RDTYP  = *BLANKS
     C                   EVAL      RDLST  = *BLANKS
     C                   EVAL      RSUPR  = *BLANKS
     C                   EVAL      TAXI   = *BLANKS
     C                   EVAL      FUID   = *BLANKS
     C                   EVAL      RBDN   = *ZEROS
     C                   EVAL      BOKC   = *BLANKS
     C                   EVAL      FLFL   = *BLANKS
     C                   EVAL      PCLI   = *BLANKS
     C                   EVAL      IPSI   = *BLANKS
     C                   EVAL      PTFR   = *BLANKS
     C                   EVAL      PRFC   = *BLANKS
     C                   EVAL      IFXS   = *BLANKS
     C                   EVAL      SIAC   = *BLANKS
     C                   EVAL      CFID   = *BLANKS
     C                   EVAL      CGAMT  = *ZEROS
     C                   EVAL      CMAMT  = *ZEROS
     C                   EVAL      ETAX   = *ZEROS
     C                   EVAL      OSAC2  = *BLANKS
     C                   EVAL      MCAC   = *BLANKS
     C                   EVAL      MCAT   = *ZEROS
     C                   EVAL      MCAS   = *ZEROS
     C                   EVAL      RCLAS  = *BLANKS
     C                   EVAL      CLAS   = *BLANKS
     C                   ENDIF
      *
     C                   IF        SRFLAG = 3
      *
     C                   EVAL      F_RECI = O3_RECI
     C                   EVAL      F_PREF = O3_PREF
     C                   EVAL      F_ETYP =O3_ETYP
     C                   EVAL      F_EDAT =O3_EDAT
     C                   EVAL      F_EAMT =W_EAMTT
     C                   EVAL      F_ECCY =O3_ECCY
     C                   EVAL      F_PYTP =O3_PYTP
     C                   EVAL      F_PYST =O3_PYST
     C                   EVAL      F_OTHD =O3_OTHD
     C                   EVAL      F_INOI =O3_INOI
     C                   EVAL      F_STNI =O3_STNI
     C                   EVAL      F_NOSA =O3_NOSA
     C                   EVAL      F_RATE =O3_RATE
     C                   EVAL      F_PYSR =O3_PYSR
     C                   EVAL      F_OTCY =O3_OTCY
     C                   EVAL      F_CUNR =O3_CUNR
     C                   EVAL      F_DBCE =O3_DBCE
     C                   EVAL      F_BRCA =O3_BRCA
      *
      ** Populate all other fields with blanks or zeros
      *
     C                   EVAL      F_ORBR   = *BLANKS
     C                   EVAL      F_COBB   = *BLANKS
     C                   EVAL      F_COOB   = *BLANKS
     C                   EVAL      F_EXEI   = *BLANKS
     C                   EVAL      F_ELVB   = *BLANKS
     C                   EVAL      F_ELVC   = *BLANKS
     C                   EVAL      F_ELVS   = *BLANKS
     C                   EVAL      F_OSBR   = *BLANKS
     C                   EVAL      F_EBRC   = *ZEROS
     C                   EVAL      F_ECPY   = *BLANKS
     C                   EVAL      F_IBRE   = *BLANKS
     C                   EVAL      F_ICYE   = *BLANKS
     C                   EVAL      F_CQSQ   = *ZEROS
     C                   EVAL      F_PRFC   = *BLANKS
     C                   EVAL      F_ECSS   = *ZEROS
     C                   EVAL      F_INCY   = *BLANKS
     C                   EVAL      F_BOKC   = *BLANKS
     C                   ENDIF
     C                   ENDSR
      ****************************************************************
      /EJECT
      *****************************************************************
      *****************************************************************
      *                                                               *
      * SrTrailrE -  Subroutine for trailer dealing detail event file *
      *              & Audit report                                   *
      *                                                               *
      *  Called By:  Main Procedure                                   *
      *                                                               *
      *  Calls:  GLZADDE,GLZSUME                                      *
      *****************************************************************
      *
     C     SrTrailrE     BEGSR
     C                   EVAL      ZZAMTE = T_EAMTE / 1000
      *
     C                   EXSR      GLZADDE
      *
     C                   READ      EVNTXZZ
     C                   EVAL      AU_NRBE   = ET_NORE
     C                   EVAL      AU_HTRBWNE  = ET_HRWN
     C                   EVAL      AU_HTRBDCE = ET_HRDC
     C                   EVAL      AU_NREE = OutCnt1
     C                   EVAL      AU_HTREWNE = ZZTOTIE
     C                   EVAL      AU_HTREDCE = ZZTOTDE
     C                   EVAL      AU_NRTE = ET_NORE + OutCnt1
     C                   EVAL      ET_NORE = ET_NORE + OutCnt1
     C                   EVAL      ZZAMTIE = ET_HRWN
     C                   EVAL      ZZAMTDE = ET_HRDC
      *
     C                   EXSR      GLZSUME
      *
     C                   EVAL      ET_HRWN = ZZTOTIE
     C                   EVAL      ET_HRDC = ZZTOTDE
     C                   EVAL      AU_HTRTWNE = ZZTOTIE
     C                   EVAL      AU_HTRTDCE = ZZTOTDE
     C                   UPDATE    EVNTXZZF
     C                   ENDSR
      ****************************************************************
      /EJECT
      ****************************************************************
      *****************************************************************
      *                                                               *
      * SrTrailrF -  Subroutine for trailer funds transfer payment    *
      *              events file & Audit report                       *
      *                                                               *
      *  Called By:  Main Procedure                                   *
      *                                                               *
      *  Calls:  GLZADDF,GLZSUMF                                      *
      *****************************************************************
      *
     C     SrTrailrF     BEGSR
     C                   EVAL      ZZAMTF = T_EAMTF / 1000
      *
     C                   EXSR      GLZADDF
      *
     C                   Read      FPVNTZZ
     C                   EVAL      AU_NRBF = FT_NORE1
     C                   EVAL      AU_HTRBWNF = FT_HRWN
     C                   EVAL      AU_HTRBDCF = FT_HRDC
     C                   EVAL      AU_NREF = OutCnt2
     C                   EVAL      AU_HTREWNF = ZZTOTIF
     C                   EVAL      AU_HTREDCF = ZZTOTDF
     C                   EVAL      AU_NRTF = FT_NORE1+ OutCnt2
     C                   EVAL      FT_NORE1 = FT_NORE1 + OutCnt2
     C                   EVAL      ZZAMTIF = FT_HRWN
     C                   EVAL      ZZAMTDF = FT_HRDC
      *
     C                   EXSR      GLZSUMF
      *
     C                   EVAL      AU_HTRTWNF = ZZTOTIF
     C                   EVAL      AU_HTRTDCF = ZZTOTDF
     C                   EVAL      FT_HRWN = ZZTOTIF
     C                   EVAL      FT_HRDC = ZZTOTDF
     C                   UPDATE    FPVNTZZF
      *
     C                   ENDSR
      ****************************************************************
      /EJECT
      ****************************************************************
      *****************************************************************
      *                                                               *
      * SrAUDIT   - Subroutine to output Audit report and end program *
      *                                                               *
      *  Called By:  Main Procedure                                   *
      *                                                               *
      *  Calls:  None                                                 *
      *****************************************************************
      *
 
     C     SrAUDIT       BEGSR
     C                   IF        (*INU7 = *ON)
     C                   WRITE     AU_DBERR
     C                   WRITE     AU_EORPT
      *
     C                   ELSE
     C                   IF        (OutCnt1 = 0 AND OutCnt2 = 0)
     C                   WRITE     AU_NODTL
     C                   WRITE     AU_EORPT
      *
     C                   ELSE
     C                   WRITE     AU_DTL
     C                   WRITE     AU_EORPT
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *****************************************************************
      *                                                               *
      * SrRCFAU   - RCF Processing for Audit (AU) file                *
      *                                                               *
      *  Called By:  INZSR                                            *
      *                                                               *
      *  Calls:  ZSFILE                                               *
      *****************************************************************
      *
     C     SrRCFAU       BEGSR
     C                   Z-ADD     SFNUMU        PZSNUM            6 0
 
     C                   CALL      'ZSFILE'
     C                   PARM      *BLANKS       PSEQ              5
     C                   PARM      *BLANKS       PSENTY            3
     C                   PARM      SFILEU        PSFILE           10
     C                   PARM                    PZSNUM
     C                   PARM      *BLANK        PZSERR            1
      *
      ** If Error occurs during ZSFILE processing, then return to the
      ** Calling Program
      *
     C                   IF        PZSERR = 'Y'
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN
     C                   ENDIF
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *****************************************************************
      *                                                               *
      * SrRCFP1   - RCF Processing for Printer (P1) file              *
      *                                                               *
      *  Called By: *INZSR                                            *
      *                                                               *
      *  Calls:  ZSFILE                                               *
      *****************************************************************
      *
     C     SrRCFP1       BEGSR
     C                   Z-ADD     SFNUM1        PZSNUM
 
     C                   CALL      'ZSFILE'
     C                   PARM      *BLANKS       PSEQ
     C                   PARM      *BLANKS       PSENTY
     C                   PARM      SFILE1        PSFILE
     C                   PARM                    PZSNUM
     C                   PARM      *BLANKS       PZSERR
      *
      ** If Error occurs during ZSFILE processing, then return to the
      ** Calling Program
      *
     C                   IF        PZSERR = 'Y'
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *****************************************************************
      *                                                               *
      * GLZADDE   - Subroutine to add an amount (ZZAMTE) to the total *
      *             (ZZTOTIE,ZZTOTDE) IND '99' is set by an Overflow  *
      *             Error                                             *
      *                                                               *
      *  Called By:  SrTrailrE                                        *
      *                                                               *
      *  Calls:  GLZSUME                                              *
      *****************************************************************
      *
      *
     C     GLZADDE       BEGSR
     C*
     C                   Z-ADD     ZZAMTE        ZZAMTE           15 3    91
     C   91              GOTO      ZZAENDE
      *
      ** Split ZZAMTE into integer and decimal fields
      *
     C                   Z-ADD     ZZAMTE        ZZAMTIE          15 0
     C                   Z-ADD     ZZAMTE        ZZWK1E            3 3
     C                   MOVE      ZZWK1E        ZZAMTDE           3 0
      *
      ** Both ZZAMTIE AND ZZAMTDE contain A 'SIGN' zone now
      *
     C                   EXSR      GLZSUME
     C     ZZAENDE       ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *****************************************************************
      *                                                               *
      * GLZSUME   - Subroutine to carry out the addition for GLZADDE  *
      *             Parameters passed -                               *
      *                     I/P ZZAMTIE ZZAMTDE                       *
      *                     O/P ZZTOTIE ZZTOTDE ZZNEGDE IND 96 IND 99 *
      *  Called By:  SrTrailrE                                        *
      *                                                               *
      *  Calls:  None                                                 *
     ******************************************************************
     C     GLZSUME       BEGSR
     C*
     C                   Z-ADD     ZZTOTIE       ZZTOTIE          15 0
     C                   Z-ADD     ZZTOTDE       ZZTOTDE           3 0
     C                   SETOFF                                       919293
     C                   SETOFF                                       949599
      *
      ** Determine sign of ZZAMTIE & DE,   92 if neg
      *
     C     ZZAMTIE       COMP      0                                    9293
     C   93ZZAMTDE       COMP      0                                    9293
     C   93              GOTO      ZZSEND
      *
      ** Determine sign of ZZTOTIE & DE, 91 if neg.
      *
     C     ZZTOTIE       COMP      0                                    91933
     C   93ZZTOTDE       COMP      0                                    91933
      *
      ** If ZZTOTALE is zero, return ZZAMOUNTE
      *
     C   93              Z-ADD     ZZAMTIE       ZZTOTIE
     C   93              Z-ADD     ZZAMTDE       ZZTOTDE
     C   93              GOTO      ZZSEND
      *
      ** If signs differ bypass overflow checks.
      *
     C   91
     CANN92
     CORN91
     CAN 92              GOTO      ZZOFPS
     C*
     C     ZZAMTDE       ADD       ZZTOTDE       ZZWK2E            4 0
     C     ZZWK2E        COMP      999                                93
     C  N93ZZWK2E        COMP      -999                                 93
     C*
     C   93
     CANN92ZZAMTIE       ADD       1             ZZWK3E           15 0
     C   93
     CAN 92ZZAMTIE       SUB       1             ZZWK3E
     C   93ZZTOTIE       ADD       ZZWK3E        ZZWK3E
     C  N93ZZTOTIE       ADD       ZZAMTIE       ZZWK3E
      *
      ** If the Modulus of ZZWK3E is LT MOD. ZZTOTI Then O/F Has occured
      *
     C  N92ZZWK3E        COMP      ZZTOTIE                              99
     C   92ZZWK3E        COMP      ZZTOTIE                            99
     C  N99              Z-ADD     ZZWK2E        ZZTOTDE
     C  N99              Z-ADD     ZZWK3E        ZZTOTIE
      *
      ** If O/F ZEROIZE ZZAMT , IND '99' Set and ZZTOT Fields left Intact
      *
     C   99              Z-ADD     0             ZZAMTE           15 3
     C                   GOTO      ZZSEND
      *
      ** The 'Signs  are different
      *
     C     ZZOFPS        TAG
      *
      ** IF ZZAMTE was negative, Make it POS. To comp with ZZTOT
      *
     C   92              Z-SUB     ZZAMTIE       ZZAMTIE          15 0
     C   92              Z-SUB     ZZAMTDE       ZZAMTDE           3 0
      *
      ** If ZZTOTE Was negative, Make it POS. to Comp with ZZAMTE
      *
     C   91              Z-SUB     ZZTOTIE       ZZTOTIE
     C   91              Z-SUB     ZZTOTDE       ZZTOTDE
      *
      ** Both ZZAMT And ZZTOT are now positive
      *
     C     ZZTOTIE       COMP      ZZAMTIE                            93  95
     C   95ZZTOTDE       COMP      ZZAMTDE                            93  95
      *
      ** IF ZZTOTE EQ. ZZAMTE Return zero
      *
     C   95              Z-ADD     0             ZZTOTIE
     C   95              Z-ADD     0             ZZTOTDE
     C   95              GOTO      ZZSEND
      *
      ** IF ZZTOTE GT. ZZAMTE
      *
     C   93ZZAMTDE       COMP      ZZTOTDE                            94
     C   93
     CAN 94ZZTOTIE       SUB       1             ZZTOTIE
     C   93
     CAN 94ZZTOTDE       ADD       1000          ZZWK2E
     C   93ZZTOTIE       SUB       ZZAMTIE       ZZTOTIE
     C   93
     CAN 94ZZWK2E        SUB       ZZAMTDE       ZZTOTDE
     C   93
     CANN94ZZTOTDE       SUB       ZZAMTDE       ZZTOTDE
      *
      *
      ** IF ZZAMTE GT. ZZTOTE
      *
     C  N93ZZTOTDE       COMP      ZZAMTDE                            94
     C  N93
     CAN 94ZZAMTIE       SUB       1             ZZWK3E           15 0
     C  N93
     CAN 94ZZAMTDE       ADD       1000          ZZWK2E
     C  N93
     CAN 94ZZWK3E        SUB       ZZTOTIE       ZZTOTIE
     C  N93
     CANN94ZZAMTIE       SUB       ZZTOTIE       ZZTOTIE
     C  N93
     CAN 94ZZWK2E        SUB       ZZTOTDE       ZZTOTDE
     C  N93
     CANN94ZZAMTDE       SUB       ZZTOTDE       ZZTOTDE
      *
      ** Reverse sign of ZZTOTE if larger I/P Fields were negative
      *
     C                   SETOFF                                       94
     C   93
     CAN 91
     CORN93
     CAN 92              SETON                                        94
     C   94              Z-SUB     ZZTOTIE       ZZTOTIE
     C   94              Z-SUB     ZZTOTDE       ZZTOTDE
      *
      ** Restore sign of ZZAMTIE & ZZAMTDE if it was reversed
      *
     C   92              Z-SUB     ZZAMTIE       ZZAMTIE
     C   92              Z-SUB     ZZAMTDE       ZZAMTDE
     C     ZZSEND        TAG
      *
      ** If ZZTOTDE is zero, and ZZTOTIE is neg. set up ZZNEGDE
      *
     C                   SETOFF                                       96
     C     ZZTOTDE       COMP      0                                      91
     C   91ZZTOTIE       COMP      0                                    96
     C   96              MOVE      '.000-'       ZZNEGDE           5
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *****************************************************************
      *                                                               *
      * GLZADDF   - Subroutine to add an amount (ZZAMTF) to the total *
      *             (ZZTOTIF,ZZTOTDF) IND '99' is set by an Overflow  *
      *             Error                                             *
      *                                                               *
      *  Called By:  SrTrailrF                                        *
      *                                                               *
      *  Calls:  GLZSUMF                                              *
      *****************************************************************
      *
     C     GLZADDF       BEGSR
      *
     C                   Z-ADD     ZZAMTF        ZZAMTF           15 3    81
     C   81              GOTO      ZZAENDF
      *
      ** Split ZZAMT Into integer and decimal fields
      *
     C                   Z-ADD     ZZAMTF        ZZAMTIF          15 0
     C                   Z-ADD     ZZAMTF        ZZWK1F            3 3
     C                   MOVE      ZZWK1F        ZZAMTDF           3 0
      *
      ** Both ZZAMTIF and ZZAMTDF contain A 'SIGN' zone now
      *
     C                   EXSR      GLZSUMF
     C     ZZAENDF       ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *****************************************************************
      *                                                               *
      * GLZSUMF   - Subroutine to carry out the addition for GLZADDF  *
      *             Parameters passed -                               *
      *                     I/P ZZAMTIF ZZAMTDF                       *
      *                     O/P ZZTOTIF ZZTOTDF ZZNEGDF IND 86 IND 89 *
      *  Called By:  SrTrailrF                                        *
      *                                                               *
      *  Calls:  None                                                 *
      *****************************************************************
     C     GLZSUMF       BEGSR
      *
     C                   Z-ADD     ZZTOTIF       ZZTOTIF          15 0
     C                   Z-ADD     ZZTOTDF       ZZTOTDF           3 0
     C                   SETOFF                                       818283
     C                   SETOFF                                       848589
      *
      ** Determine Sign of ZZAMTIF & DF,   92 IF NEG
      *
     C     ZZAMTIF       COMP      0                                    8283
     C   83ZZAMTDF       COMP      0                                    8283
     C   83              GOTO      ZZSENDF
      *
      ** Determine Sign of ZZTOTIF & DF, 81 IF NEG.
      *
     C     ZZTOTIF       COMP      0                                    8183
     C   83ZZTOTDF       COMP      0                                    8183
      *
      ** If ZZTOTALF is Zero, Return ZZAMOUNTF
      *
     C   83              Z-ADD     ZZAMTIF       ZZTOTIF
     C   83              Z-ADD     ZZAMTDF       ZZTOTDF
     C   83              GOTO      ZZSENDF
      *
      ** If Signs differ bypass overflow checks
      *
     C   81
     CANN82
     CORN81
     CAN 82              GOTO      ZZOFPSF
      *
     C     ZZAMTDF       ADD       ZZTOTDF       ZZWK2F            4 0
     C     ZZWK2F        COMP      999                                83
     C  N83ZZWK2F        COMP      -999                                 83
      *
     C   83
     CANN82ZZAMTIF       ADD       1             ZZWK3F           15 0
     C   83
     CAN 82ZZAMTIF       SUB       1             ZZWK3F
     C   83ZZTOTIF       ADD       ZZWK3F        ZZWK3F
     C  N83ZZTOTIF       ADD       ZZAMTIF       ZZWK3F
      *
      ** If the modulus of ZZWK3F is LT MOD. ZZTOTIF then O/F Has occured
      *
     C  N82ZZWK3F        COMP      ZZTOTIF                              89
     C   82ZZWK3F        COMP      ZZTOTIF                            89
     C  N89              Z-ADD     ZZWK2F        ZZTOTDF
     C  N89              Z-ADD     ZZWK3F        ZZTOTIF
      *
      ** If O/F ZEROIZF ZZAMTF , IND '89' Set and ZZTOTF fields left intact
      *
     C   89              Z-ADD     0             ZZAMTF           15 3
     C                   GOTO      ZZSENDF
      *
      ** The 'SIGNS' are different
      *
     C     ZZOFPSF       TAG
      *
      ** If ZZAMTF Was negative, Make it POS. to Comp with ZZTOTF
      *
     C   82              Z-SUB     ZZAMTIF       ZZAMTIF          15 0
     C   82              Z-SUB     ZZAMTDF       ZZAMTDF           3 0
      *
      ** If ZZTOT Was negative, make it pos. to comp with ZZAMT
      *
     C   81              Z-SUB     ZZTOTIF       ZZTOTIF
     C   81              Z-SUB     ZZTOTDF       ZZTOTDF
      *
      ** Both ZZAMTF and ZZTOTF are now positive.
      *
     C     ZZTOTIF       COMP      ZZAMTIF                            83  85
     C   95ZZTOTDF       COMP      ZZAMTDF                            83  85
      *
      ** If ZZTOT EQ. ZZAMT return zero
      *
     C   85              Z-ADD     0             ZZTOTIF
     C   85              Z-ADD     0             ZZTOTDF
     C   85              GOTO      ZZSENDF
      *
      ** If ZZTOTF GT. ZZAMTF
      *
     C   83ZZAMTDF       COMP      ZZTOTDF                            84
     C   83
     CAN 84ZZTOTIF       SUB       1             ZZTOTIF
     C   83
     CAN 84ZZTOTDF       ADD       1000          ZZWK2F
     C   83ZZTOTIF       SUB       ZZAMTIF       ZZTOTIF
     C   83
     CAN 84ZZWK2F        SUB       ZZAMTDF       ZZTOTDF
     C   83
     CANN84ZZTOTDF       SUB       ZZAMTDF       ZZTOTDF
      *
      *
      ** If ZZAMTF GT. ZZTOTF
      *
     C  N83ZZTOTDF       COMP      ZZAMTDF                            84
     C  N83
     CAN 84ZZAMTIF       SUB       1             ZZWK3F           15 0
     C  N83
     CAN 84ZZAMTDF       ADD       1000          ZZWK2F
     C  N83
     CAN 84ZZWK3F        SUB       ZZTOTIF       ZZTOTIF
     C  N83
     CANN84ZZAMTIF       SUB       ZZTOTIF       ZZTOTIF
     C  N83
     CAN 84ZZWK2F        SUB       ZZTOTDF       ZZTOTDF
     C  N83
     CANN84ZZAMTDF       SUB       ZZTOTDF       ZZTOTDF
      *
      ** Reverse Sign of ZZTOTF if larger I/P fields were negative
      *
     C                   SETOFF                                       84
     C   83
     CAN 81
     CORN83
     CAN 82              SETON                                        84
     C   84              Z-SUB     ZZTOTIF       ZZTOTIF
     C   84              Z-SUB     ZZTOTDF       ZZTOTDF
      *
      ** Restore sign of ZZAMTIF & ZZAMTDF if it was reversed.
      *
     C   82              Z-SUB     ZZAMTIF       ZZAMTIF
     C   82              Z-SUB     ZZAMTDF       ZZAMTDF
     C     ZZSENDF       TAG
      *
      ** IF ZZTOTDF is zero, and ZZTOTIE is Neg. Set up ZZNEGDE
      *
     C                   SETOFF                                       86
     C     ZZTOTDF       COMP      0                                      81
     C   81ZZTOTIF       COMP      0                                    86
     C   86              MOVE      '.000-'       ZZNEGDF           5
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *****************************************************************
      *                                                               *
      *  PAGHDR - Header Subroutine                                   *
      *                                                               *
      *  Called By:  Main Procedure,PR_PAGSHDR,PR_PAGDTL              *
      *                                                               *
      *  Calls: None                                                  *
      *****************************************************************
      *
     C     PAGHDR        BEGSR
     C                   EVAL      LCTR  = 0
     C                   WRITE     R_HDR
     C                   EVAL      LCTR  = LCTR+9
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *****************************************************************
      *                                                               *
      *  PR_PAGSHDR - Process Sub Header Subroutine                   *
      *                                                               *
      *  Called By:   Process                                         *
      *                                                               *
      *  Calls:        PAGSHDR, PAGHDR                                *
      *****************************************************************
      *
     C     PR_PAGSHDR    BEGSR
     C                   IF        LCTR > 56
     C                   EXSR      PAGHDR
     C                   EXSR      PAGSHDR
     C                   ELSE
     C                   EXSR      PAGSHDR
     C                   ENDIF
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *****************************************************************
      *                                                               *
      *  PAGSHDR    - Sub Header Subroutine                           *
      *               Populate Sub header from work field to report   *
      *               field                                           *
      *                                                               *
      *  Called By:   PR_PAGDTL                                       *
      *                                                               *
      *  Calls:       None                                            *
      *****************************************************************
      *
     C     PAGSHDR       BEGSR
     C                   EVAL      R_BRNCHSH = W_BRNCHSH
     C**********         EVAL      R_DLNSH = W_DLNSH                                        BUG12221
     C                   EVAL      R_CUSNSH = W_CUSNSH
     C                   EVAL      R_ETYPSH = W_ETYPSH
     C                   EVAL      R_ECCYSH  = W_ECCYSH
     C                   EVAL      R_EDTESH = W_EDTESH
     C**********         WRITE     R_SUBHDR                                                 BUG12221
     C**********         EVAL      LCTR = LCTR + 2                                          BUG12221
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *****************************************************************
      *                                                               *
      *  PR_PAGDTL - Process Detail Subroutine                        *
      *                                                               *
      *  Called By:   SUBRTN1,SUBRTN2,SUBRTN3                         *
      *                                                               *
      *  Calls:       PAGHDR,PAGSHDR,PAGDTL                           *
      *****************************************************************
      *
     C     PR_PAGDTL     BEGSR
     C                   IF        LCTR > 56
     C                   EXSR      PAGHDR
     C                   EXSR      PAGSHDR
     C                   EXSR      PAGDTL
     C                   ELSE
     C                   EXSR      PAGDTL
     C                   ENDIF
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *****************************************************************
      *                                                               *
      *  PAGDTL  - Detail Subroutine                                  *
      *                                                               *
      *  Called By: PR_PAGDTL                                         *
      *                                                               *
      *  Calls:       None                                            *
      *****************************************************************
      *
     C     PAGDTL        BEGSR
     C                   EVAL      R_BRNCHD = W_BRNCHD
     C                   EVAL      R_APPCD = W_APPCD
     C                   EVAL      R_DLND = W_DLND
     C                   EVAL      R_CUSND = W_CUSND
     C                   EVAL      R_TYPD = W_TYPD
     C                   EVAL      R_STYPD = W_STYPD
     C**********         EVAL      R_LNDEPD = W_LNDEPD                                      BUG12221
     C**********         EVAL      R_CCYD = W_CCYD                                          BUG12221
     C**********         EVAL      R_DATD = W_DATD                                          BUG12221
     C                   EVAL      R_PAYRD = W_PAYRD
     C                   EVAL      R_NOSTD = W_NOSTD
     C**********         EVAL      R_RATED = W_RATED                                        BUG12221
     C**********         EVAL      R_EAMTD = W_EAMTD                                        BUG12221
     C**********         WRITE     R_DTL                                                    BUG12221
     C**********         EVAL      LCTR = LCTR +1                                           BUG12221
     C                   EVAL      ZDECS= 8                                                 BUG12221
     C                   MOVE      W_RATED       W_RATEFMT                                  BUG12221
     C                   MOVE      W_RATEFMT     ZFLD15                                     BUG12221
     C                   CALLB     'ZSEDIT'                                                 BUG12221
     C                   PARM                    ZFLD15           15 0                      BUG12221
     C                   PARM                    ZDECS             1 0                      BUG12221
     C                   PARM      *BLANKS       ZECODE            1                        BUG12221
     C                   PARM                    ZOUT21           21                        BUG12221
     C                   EVAL      R_RATED = %SUBST(ZOUT21:09:13)                           BUG12221
     C                   CALLB     'ZSEDIT'                                                 BUG12221
     C                   PARM      W_EAMTD       ZFLD15                                     BUG12221
     C                   PARM      ZDECFMT       ZDECS                                      BUG12221
     C                   PARM      'J'           ZECODE                                     BUG12221
     C                   PARM                    ZOUT21                                     BUG12221
     C                   EVAL      R_EAMTD = ZOUT21                                         BUG12221
     C                   WRITE     R_DTLA                                                   BUG12221
     C                   WRITE     R_DTLB                                                   BUG12221
     C                   EVAL      LCTR = LCTR +3                                           BUG12221
     C                   ENDSR
      ****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  STOTAL  - Sub Total Subroutine                               *
      *            Populate Sub Total from work field to report field *
      *                                                               *
      *  Called By: PROCESS                                           *
      *                                                               *
      *  Calls:       None                                            *
      *****************************************************************
      ****************************************************************
      *
     C     STOTAL        BEGSR
     C**********         EVAL      R_WARATET = W_WARATET                                    BUG12221
     C**********         EVAL      R_EAMTT = W_EAMTT                                        BUG12221
     C                   EVAL      ZDECS= 8                                                 BUG12221
     C                   MOVE      W_WARATET     W_RATETFMT                                 BUG12221
     C                   MOVE      W_RATETFMT    ZFLD15                                     BUG12221
     C                   CALLB     'ZSEDIT'                                                 BUG12221
     C                   PARM                    ZFLD15                                     BUG12221
     C                   PARM                    ZDECS                                      BUG12221
     C                   PARM      *BLANKS       ZECODE                                     BUG12221
     C                   PARM                    ZOUT21                                     BUG12221
     C                   EVAL      R_WARATET = %SUBST(ZOUT21:09:13)                         BUG12221
     C                   CALLB     'ZSEDIT'                                                 BUG12221
     C                   PARM      W_EAMTT       ZFLD15                                     BUG12221
     C                   PARM      ZDECFMT       ZDECS                                      BUG12221
     C                   PARM      'J'           ZECODE                                     BUG12221
     C                   PARM                    ZOUT21                                     BUG12221
     C                   EVAL      R_EAMTT = ZOUT21                                         BUG12221
     C                   WRITE     R_STOTAL
     C                   EVAL      LCTR = LCTR +3
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      * Called by: Implicitly on program activation                   *
      *                                                               *
      * Calls: AOBANKR0,AOSVALR0,ZSFILE.                              *
      *                                                               *
      *****************************************************************
 
     C     *INZSR        BEGSR
     C                   EVAL      DBPGM = 'GL000539'
     C                   EVAL      R_PGMNM = PSProcPgm
     C                   EVAL      AU_PGMNM = 'GL000539AU'
      *
     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*FIRST'      @OPTN
     C     SDBANK        PARM      SDBANK        DSFDY
      *
     C                   IF        @RTCD <> *BLANKS
     C     *LOCK         IN        LDA
     C                   Eval      DBFILE = 'SDBANKPD'
     C                   EVAL      DBKEY  = '*FIRST'
     C                   EVAL      DBASE  =  931
     C                   OUT       LDA
     C                   EXSR      *PSSR
      *
     C                   ELSE
     C                   EVAL      R_DATE = BJMRDT
     C                   EVAL      AU_DATE = BJMRDT
     C                   EVAL      R_RPTTL = BJURPT
     C                   EVAL      AU_RPTTL= BJURPT
     C                   ENDIF
      *
     C                   EVAL      P@OP01 = 'EQEventDealSubtype'
     C                   CALL      'AOSVALR0'
     C                   PARM                    P@RTCD            7
     C                   PARM                    P@OP01           20
     C                   PARM                    P@VL01          200
     C                   PARM                    P@OP02           20
     C                   PARM                    P@VL02          200
     C                   PARM                    P@OP03           20
     C                   PARM                    P@VL03          200
     C                   PARM                    P@OP04           20
     C                   PARM                    P@VL04          200
     C                   PARM                    P@OP05           20
     C                   PARM                    P@VL05          200
     C                   PARM                    P@OP06           20
     C                   PARM                    P@VL06          200
     C                   PARM                    P@OP07           20
     C                   PARM                    P@VL07          200
     C                   PARM                    P@OP08           20
     C                   PARM                    P@VL08          200
     C                   PARM                    P@OP09           20
     C                   PARM                    P@VL09          200
     C                   PARM                    P@OP10           20
     C                   PARM                    P@VL10          200
      *
     C                   IF        P@RTCD <> *BLANKS
     C     *LOCK         IN        LDA
     C                   Eval      DBFILE = 'SDSVALPD'
     C                   EVAL      DBKEY  = P@OP01
     C                   EVAL      DBASE  =  904
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   IF        P@RTCD =  *BLANKS
     C                   EVAL      W_SUBTYPE = %SUBST(P@VL01:1:2)
     C                   ENDIF
      *
      ** Processing to validate the 2 - character deal sybtype retreived from the System Value:
      *
      ** Call the Access object based on Deal sub type file.
      ** Check if the Deal sub type is defined on the Deal sub type file
      *
     C                   CALL      'AODLSTR0'
     C                   PARM      *BLANKS       @RTCD             7
     C                   PARM      '*KEY    '    @OPTN             7
     C                   PARM      W_Subtype     @DSTC             2
     C     SDDLST        PARM      SDDLST        DSFDY
      *
      ** If Deal sub type not found on the Midas Deal Sub Type
      ** file then return an error
      *
     C                   IF        @RTCD = '*NRF'
      *
      ** Set up the error fields
      *
     C     *LOCK         IN        LDA
     C                   Eval      DBFILE = 'SDDLSTPD'
     C                   EVAL      DBKEY  = W_Subtype
     C                   EVAL      DBASE  = 908
     C                   OUT       LDA
      *
     C                   EXSR      *PSSR
      *
     C                   ENDIF
      *
      ** Catch all for unprocessed errors
      *
     C                   IF        @RTCD <> *BLANKS
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ** Normal end processing
      ** Get the value of deal subtype if return flag is blank
      *
     C                   EVAL      W_DSTC = ASDSTC
      *
      ** Key list for the Deal type/Sub type file
      *
     C     K02_FDDTSTL1  KList
     C                   KFld                    K02_DTPE11
     C                   KFld                    K02_DLST11
      *
      ** Chain the Deal type/Sub type file using Deal type as 'CL"
      *
     C                   EVAL       K02_DTPE11 = 'CL'
     C                   EVAL       K02_DLST11 =  W_DSTC
      *
     C     K02_FDDTSTL1  CHAIN     FDDTSTL1
     C                   IF        NOT %FOUND(FDDTSTL1)
      *
      ** Set up the error fields
      *
     C     *LOCK         IN        LDA
     C                   Eval      DBFILE = 'FDDTSTPD'
     C                   EVAL      DBKEY  = K02_DTPE11 + K02_DLST11
     C                   EVAL      DBASE  = 905
     C                   OUT       LDA
      *
      ** If record not found in the Deal type/Sub type file
      *
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ** Chain the Deal type/Sub type file using Deal type as 'CD"
      *
     C                   EVAL       K02_DTPE11 = 'CD'
      *
     C     K02_FDDTSTL1  CHAIN     FDDTSTL1
     C                   IF        NOT %FOUND(FDDTSTL1)
      *
      ** Set up the error fields
      *
     C     *LOCK         IN        LDA
     C                   Eval      DBFILE = 'FDDTSTPD'
     C                   EVAL      DBKEY  = K02_DTPE11 + K02_DLST11
     C                   EVAL      DBASE  = 906
     C                   OUT       LDA
      * If record not found in the Deal type/Sub type file
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      /EJECT
      *
     C                   EVAL      OutCnt1= *ZEROS
     C                   EVAL      OutCnt2= *ZEROS
      *
      ** Clear Data Structures
      *
     C                   CLEAR                   OLD1FilFmt
     C                   CLEAR                   OLD2FilFmt
     C                   CLEAR                   OLD3FilFmt
     C                   CLEAR                   CUR1FilFmt
     C                   CLEAR                   CUR2FilFmt
     C                   CLEAR                   CUR3FilFmt
     C                   CLEAR                   CUR_GRP
     C                   EVAL      OLD2FilFmt = *BLANKS
      * Start RCF Processing for Audit File
     C                   EXSR      SrRCFAU
      *
      ** Start RCF Processing for P1 File
      *
     C                   EXSR      SrRCFP1
 
      *
      **  Read in Installation Data
      *
     C     *DTAARA       DEFINE                  RUNDAT
     C     *DTAARA       DEFINE                  LDA
      *
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *PSSR  - Program exception error routine                      *
      *          Called automatically if a program error occurs,      *
      *          or directly by the program code using EXSR.          *
      *          This subroutine DUMPs the program just once.         *
      *                                                               *
      * Called by: (**calling routines**)                             *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
      *
     C     *PSSR         BEGSR
      *
     C                   IF        @RUN = *BLANK
     C                   EVAL      @RUN = 'Y'
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   DUMP
     C                   EXSR      SrAUDIT
      *
     C                   ENDIF
      *
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN
      *
     C                   ENDSR
      *
** ArrEQ
MMPCDMMPMDMMI DMMPODMMPODMMPRDRLPCLRLPRLRLPTLRLI LRLPOL
** ArrED
Deposit Start
Deposit Maturity
Interest
Principal Increase
Principal Decrease
Repayment
Loan Start
Repayment
Repayment
Interest
Principal Increase
** ArrET
16V116M116I216V316M416M415V115M415M415I215V3
