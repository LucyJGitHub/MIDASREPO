     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2004')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas LE Facility Customer Grp. Initialisation Pgm')   *
      *****************************************************************
      *                                                               *
      *  Midas - Customer Lending Module                              *
      *                                                               *
      *  RPGLE/LE000014 - Initialisation Program for CLE025:          *
      *                   Facility Customer Group Initialisation,     *
      *                   Accounts Extension Details Initialisation,  *
      *                   Deals Extension Details Initialisation      *
      *                                                               *
      *  (c) Finastra International Limited 2004                      *
      *                                                               *
      *  Last Amend No. CLE168             Date 26Feb18               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      *                 CLE134             Date 01Aug12               *
      *                 CLE148             Date 23Jul12               *
      *                 CLE147             Date 30Sep11               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD027             Date 09Dec05               *
      *                 CLE042             Date 06Sep05               *
      *                 CLE106             Date 01Aug04               *
      *                 CSW037A            Date 02May05               *
      *                 BUG6198            Date 04Apr05               *
      *                 CLE041             Date 11Oct04               *
      *                 CSD025             Date 11Jan05               *
      *                 CSW037             Date 15Dec04               *
      *                 CSW036             Date 15Dec04               *
      *                 CLE040             Date 05Jul04               *
      *                 BUG3264            Date 16Jun04               *
      *                 CLE025  *CREATE    Date 20Oct03               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CLE168 - Allow Debit of Blocked Account (Recompile)          *
      *  MD046248 - Finastra Rebranding                               *
      *  CLE134 - Past Due Call Loan Processing (Recompile)           *
      *  CLE148 - Alpha Loan Reference (Recompile)                    *
      *  CLE147 - Aggregate Facility (Recompile)                      *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CLE042 - Extended Loan Sub Type (Recompile)                  *
      *  CLE106 - Syndication Manager (Recompile)                     *
      *  CSW037A- Additional Field extended to 40 chars (recompile)   *
      *  BUG6198- Cannot save new Details for CUSD (Recompile)        *
      *  CLE041 - Collateralised Lending Phase 2B (Recompile)         *
      *  CSD025 - Customer De-Activation                              *
      *  CSW037 - Additional Field Data on MT300/MT320                *
      *  CSW036 - Dual SWIFT BIC held on Client Details               *
      *  CLE040 - Collateralised Lending Phase 2 (Recompile)          *
      *  BUG3264 - Data Mapping Error in LE000014                     *
      *  CLE025 - Credit Lines                                        *
      *                                                               *
      *****************************************************************

      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+

      ** LE Facilities Extension File
     FLEFCLTLG  UF A E           K DISK    INFSR(*PSSR)
     F                                     COMMIT

      ** Customer Hierarchy Table by CHID
     FLEGRCHL0  UF A E           K DISK    INFSR(*PSSR)
     F                                     RENAME(T_GRCUSTH:HierTabF)
     F                                     COMMIT

      ** Customer Group Table by CGHYID/CGID
     FLEGRCGL0  UF A E           K DISK    INFSR(*PSSR)
     F                                     RENAME(T_GRCUSTG:GroupTabF)
     F                                     COMMIT

      ** Customer Link Table by CLHYID/CLGRPID/CLID
     FLEGRCLL3  UF   E           K DISK    INFSR(*PSSR)                                      BUG3264
     F                                     RENAME(T_GRCUSTL:LinkTab1)                        BUG3264
     F                                     COMMIT                                            BUG3264
     FLEGRCLL1  UF A E           K DISK    INFSR(*PSSR)
     F                                     RENAME(T_GRCUSTL:LinkTabF)
     F                                     COMMIT

      ** Customer Link Table by CLHYID/CLGRPID/CLID
     FLEGRCLL2  UF A E           K DISK    INFSR(*PSSR)
     F                                     RENAME(T_GRCUSTL:LinkTabW)
     F                                     COMMIT

      ** Customer Link Table by CLHYID/CLGRPID/CLID
     FT_GRCUSTL UF A E             DISK    INFSR(*PSSR)
     F                                     RENAME(T_GRCUSTL:LinkTabX)
     F                                     COMMIT

      ** LE Customer Loans
     FCLOANM    IF   E           K DISK    INFSR(*PSSR)

      ** Facility Details Retrieval Index
     FFCLTYL1   IF   E           K DISK    INFSR(*PSSR)
     F                                     PREFIX(F1)

      ** SD Customer Details File
     FSDCUSTL1  IF   E           K DISK    INFSR(*PSSR)

      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ D-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+

     D LDA           E DS           256    EXTNAME(LDA)
      ** Local data area for database error details
      ** *LOCK IN LDA immediately before and OUT LDA immediately
      ** after each database error handling.
      **
      **                                    134 141 DBFILE
      **       Defines:                     142 170 DBKEY
      **                                    171 180 DBPGM
      **                                    181 1830DBASE

      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes all the defined fields in the
      ** Program Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
      **--------------------------------------------------------------------------------------------

      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+

      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+

     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** External DS for bank details

      ** Short Data Structure for Access programs
     D DSFDY         E DS                  EXTNAME(DSFDY)

      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+

      ** Array containing Copyright statement
     D CPY@            S             80    DIM(1) CTDATA PERRCD(1)

     D PRtCd           S              7A
     D POptn           S              7A

     D*WkFCus***       S              6  0                                                    CSD027
     D WkFCus          S              6                                                       CSD027
     D WkFTyp          S              3  0
     D WkFSeq          S              2  0
     D*WkCNum***       S              6  0                                                    CSD027
     D WkCNum          S              6                                                       CSD027
     D WkCNumA         S              6A
     D WkFCusA         S              6A
     D WkFTypA         S              3A
     D WkFSeqA         S              2A
     D WCNUM           S              6A
     D WFACT           S              3A
     D WFCNO           S              2A

     D KyCNumA         S              6A

     D WRun            S              1A

     D KCHID           S              9S 0
     D KCGID           S             20I 0
     D WrkCHID         S             15

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

      ** Initialise the Facility Customer Group field

     C                   EXSR      SRSetTab

      ** End program

     C                   EVAL      *INLR = *ON
     C                   RETURN

      *****************************************************************
      /EJECT
      *****************************************************************
      * SRSetTab - Subroutine to Set Up the Tables                    *
      *****************************************************************

     C     SRSetTab      BEGSR

     C     *LOVAL        SETLL     CLOANM
     C                   READ      CLOANM                                 60

     C                   DOW       *IN60 = *OFF

     C     KlFclt        CHAIN     FCLTYL1                            61

     C                   IF        *IN61 = *OFF AND F1MCSI = 'Y'

      ** If the current facility is not the same as the previous facility

     C                   IF        FCUS <> WkFCus OR FTYP <> WkFTyp OR
     C                             FSEQ <> WkFSeq

      ** Update the End Id of the previous group, do this if the current
      ** group is not zero

     C                   EVAL      WkCLID = CLID
     C*****KlLink        CHAIN     LEGRCLL1                           62                     BUG3264
     C     KlLink        CHAIN     LEGRCLL3                           62                     BUG3264
     C                   EVAL      CLENDID = WkCLID
     C**********         UPDATE    LinkTabF                                                  BUG3264
     C                   UPDATE    LinkTab1                                                  BUG3264

      ** Generate the Customer Group record

     C                   EVAL      CGHYID = CHID
     C                   EVAL      CGID = CGID + 1

     C                   EVAL      KCHID = CHID
     C                   EVAL      KCGID = CGID

      ** Format fields

     C                   MOVE      FCUS          WkFCusA
     C                   MOVE      FTYP          WkFTypA
     C                   MOVE      FSEQ          WkFSeqA

     C                   EVAL      CGNAME = 'Facility ' +WkFCusA + '-' +WkFTypA
     C                                      + '-' +WkFSeqA
     C                   WRITE     GroupTabF

      ** Generate the Customer Link Table

     C     *HIVAL        SETGT     LEGRCLL2
     C                   READP     LEGRCLL2
     C                   EVAL      CLHYID = CHID
     C                   EVAL      CLID = CLID + 1
     C                   EVAL      CLGRPID = CGID
     C                   EVAL      CLLEVEL = CLLEVEL + 1
     C                   EVAL      CLPARENT = 0
     C                   EVAL      WkParent = CLGRPID
     C                   EVAL      CLCUSTCODE = *BLANKS
     C                   WRITE     LinkTabW

      ** Update the facilities extension table for the Customer Group field

     C                   MOVE      F1CNUM        WCNUM
     C                   MOVE      F1FACT        WFACT
     C                   MOVE      F1FCNO        WFCNO

     C     KlExtF        CHAIN     LEFCLTLG                           62

     C                   IF        *IN62 = *OFF
     C                   EVAL      FCXCGP = CGID
     C                   UPDATE    LEFCLTD0
     C                   ENDIF

      ** Reset stored customer number

     C**********         EVAL      WkCNUM = 0                                                 CSD027
     C                   EVAL      WkCNUM = *BLANKS                                           CSD027

      ** ENDIF for if facility read is not the same as the previous one

     C                   ENDIF

      ** If the customer is not the same as the previous customer or
      ** first customer of the next facility

     C                   IF        CNUM <> WkCNum
     C                   MOVEL     CNUM          KyCNumA

      ** Get branch from the customer file

     C     KyCNumA       CHAIN     SDCUSTL1                           62
     C                   EVAL      CLHYID = CHID
     C                   EVAL      CLID = CLID + 1
     C                   EVAL      CLENDID = CLID
     C                   EVAL      CLPARENT = WkParent
     C                   EVAL      CLGRPID = 0
     C                   MOVE      CNUM          WkCNumA
     C                   EVAL      CLCUSTCODE = BBBRCD + '-' + WkCNumA
     C                   WRITE     LinkTabF
     C                   ENDIF
     C

      ** Save previous facility and customer to work fields

     C                   EVAL      WkFCus = FCUS
     C                   EVAL      WkFTyp = FTYP
     C                   EVAL      WkFSeq = FSEQ
     C                   EVAL      WkCNum = CNUM

      ** ENDIF for if found in FCLTY1

     C                   ENDIF

      ** Read next loan

     C                   READ      CLOANM                                 60

     C                   ENDDO

      ** Update end id of the last group

     C                   EVAL      WkCLID = CLID
     C*****KlLink        CHAIN     LEGRCLL1                                                  BUG3264
     C     KlLink        CHAIN     LEGRCLL3                                                  BUG3264
     C                   EVAL      CLENDID = WkCLID
     C**********         UPDATE    LinkTabF                                                  BUG3264
     C                   UPDATE    LinkTab1                                                  BUG3264

      ** After all the loans have been read, update the End Id of the Top
      ** most group

     C                   EVAL      WkCLID = CLENDID
     C*****1****         SETLL     T_GRCUSTL                                                 BUG3264
     C**********         READ      T_GRCUSTL                              61                 BUG3264
     C     *LOVAL        SETLL     LEGRCLL3                                                  BUG3264
     C                   READ      LEGRCLL3                               61                 BUG3264

     C                   IF        *IN61 = *OFF
     C                   EVAL      CLENDID = WkCLID
     C**********         UPDATE    LinkTabX                                                  BUG3264
     C                   UPDATE    LinkTab1                                                  BUG3264
     C                   ENDIF

     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      * *INZSR - Subroutine for Initial First Cycle processing        *
      *****************************************************************

     C     *INZSR        BEGSR

     C                   MOVEA     CPY@          BIS@             80

      ** Set up Local Data Area (LDA)

     C     *DTAARA       DEFINE                  LDA
     C     *LOCK         IN        LDA
     C                   MOVE      *BLANKS       DBFILE
     C                   MOVE      *BLANKS       DBKEY
     C                   MOVE      *BLANKS       DBPGM
     C                   MOVEL     'LE000014'    DBPGM
     C                   Z-ADD     0             DBASE
     C                   OUT       LDA

      ** Access Bank Details

     C                   CALLB     'AOBANKR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*FIRST '     POPTN
     C     SDBANK        PARM      SDBANK        DSFDY

      ** Database error

     C                   IF        PRTCD <> *BLANKS
     C                   EVAL      DBFILE = 'SDBANKPD'
     C                   EVAL      DBASE = 1
     C                   EVAL      DBKEY = POPTN
     C                   EXSR      *PSSR
     C                   ENDIF

      ** Define key lists

     C     KlFclt        KLIST
     C                   KFLD                    BRCA
     C                   KFLD                    FCUS
     C                   KFLD                    FTYP
     C                   KFLD                    FSEQ

     C     KlExtF        KLIST
     C                   KFLD                    F1BRCA
     C                   KFLD                    WCNUM
     C                   KFLD                    WFACT
     C                   KFLD                    WFCNO

     C     KlLink        KLIST
     C                   KFLD                    KCHID
     C                   KFLD                    KCGID

     C     *LIKE         DEFINE    CLID          WkCLID
     C     *LIKE         DEFINE    CLPARENT      WkParent

      ** Initialise work variables

     C**********         EVAL      WkFCus = 0                                                 CSD027
     C                   EVAL      WkFCus = *BLANKS                                           CSD027
     C                   EVAL      WkFTyp = 0
     C                   EVAL      WkFSeq = 0
     C**********         EVAL      WkCNum = 0                                                 CSD027
     C                   EVAL      WkCNum = *BLANKS                                           CSD027

      ** Set the Customer Hierarchy Table

     C                   EVAL      CHSNAME = 'Customer Lending'
     C                   EVAL      CHNAME = 'Customer Lending'
     C                   WRITE     HierTabF

     C     *HIVAL        SETGT     LEGRCHL0
     C                   READP     LEGRCHL0
     C                   MOVEL     CHID          WrkCHID
     C                   EVAL      CHSNAME = 'Customer Lending' + WrkCHID
     C                   EVAL      CHNAME = 'Customer Lending' + WrkCHID
     C                   UPDATE    HierTabF

      ** Set the Top Level Group for the Customer Group Table

     C                   EVAL      CGID = 1
     C                   EVAL      CGHYID = CHID
     C                   EVAL      CGNAME = 'Facility Customer Group'
     C                   WRITE     GroupTabF

      ** Set the First Group Id for the Customer Link Table

     C                   EVAL      CLHYID = CHID
     C                   EVAL      CLID = 1
     C                   EVAL      CLGRPID = CGID
     C                   EVAL      CLLEVEL = 1
     C                   EVAL      CLPARENT = 0
     C                   EVAL      CLCUSTCODE = *BLANKS
     C                   WRITE     LinkTabF

     C                   EVAL      KCHID = CHID
     C                   EVAL      KCGID = CGID

     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      * *PSSR - Program exception error routine                       *
      *****************************************************************

     C     *PSSR         BEGSR

     C                   IF        WRun = *blanks
     C                   MOVE      'Y'           WRun
     C                   DUMP
     C                   CALL      'DBERRCTL'
     C                   ENDIF

     C                   MOVE      *ON           *INU7
     C                   MOVE      *ON           *INU8
     C                   MOVE      *ON           *INLR
     C                   RETURN

     C                   ENDSR

      *****************************************************************
** CPY@
(c) Finastra International Limited 2004
