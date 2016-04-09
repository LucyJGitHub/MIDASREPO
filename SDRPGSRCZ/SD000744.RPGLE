     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD Hedging ICD Enquiry/Maintenance')
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SD000744 - Hedging ICD Maintenance/Enquiry                   *
      *                                                               *
      *  Function:  This module enables the user to enter, maintain,  *
      *             and enquire upon Hedging ICD data.                *
      *                                                               *
      *  Component of: SD000744                                       *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2002            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Last Amend No. CSD027             Date 09Dec05               *
      *  Prev Amend No. BUG10772           Date 07Mar06               *
      *                 BUG9476            Date 11Dec05               *
      *                 235237             Date 28Jul05               *
      *                 CAS011             Date 16May05               *
      *                 233545             Date 18May05               *
      *                 232348             Date 21Feb05               *
      *                 230116             Date 18Feb05               *
      *                 CAS009             Date 04May04               *
      *                 228948             Date 27Sep04               *
      *                 229596             Date 14Sep04               *
      *                 229418             Date 02Sep04               *
      *                 CAS008             Date 11May04               *
      *                 CAS007             Date 26Apr04               *
      *                 226225             Date 01Apr04               *
      *                 CAAA03             Date 22Mar04               *
      *                 CAS006             Date 21Jan03               *
      * Midas Release 4.01 -------------------------------------------*
      *                 CAS002  *CREATE    Date 14Jan02               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  BUG10772 - Decimal-data on write to SDHEDGPD                 *
      *  BUG9476- Exclued Accrued Interest in Unrealized Profit and   *
      *           Loss should also show even if CAS007 is switched    *
      *           off.                                                *
      *  235237 - Overlap of De Minimis Amount with SE Basis          *
      *  CAS011 - EIR/AC Accounting Upgrade to MP1                    *
      *  233545 - Cut-off Date                                        *
      *  232348 - Introduce cut-off date for non-linear amortisation  *
      *  230116 - To add the 'De Minimis Amount'                      *
      *  CAS009 - Effective Interest Rate/Amortised Cost Accounting   *
      *  228948 - Add 'Exclude Accrued Interest in Unrealized Profit  *
      *           or Loss'.                                           *
      *  229596 - Display '0' on screen when file field is empty.     *
      *  229418 - Should add number of days for hedge effectiveness   *
      *           tolerance.                                          *
      *  CAS008 - Delayed Hedge Assessment                            *
      *  CAS007 - Hedge Accounting Control                            *
      *  226225 - Zero Di Minimis Percentage for Hedge ICD maint      *
      *           is not shown                                        *
      *  CAAA03 - Webfacing Changes (recompile)                       *
      *  CAS006 - Hedge Accounting Phase B                            *
      *  CAS002 - Hedge Strategy/Linkage                              *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *    31         Protect Indicator for Enquiry Mode              *
      *    32         Error Indicator for Override de Minimis         *
      *    33         Error Indicator for Number of Months            *
      *    34         Error Indicator for Trade/Value Date Basis      *
      *    35         Error Indicator for Market Indicator            *
      *    36         Non-Display Indicator if Securities Trading     *
      *               Module is not present                           *
      *    37         Error Indicator for Confidence Level Percentage *                       CAS006
      *    38         Display Indicator if CAS006 is on               *                       CAS006
      *    40         Error Indicator for Number of days for Hedge    *                       229418
      *               Linkage Effectiveness Tolerance                 *                       229418
      *    50         Display Indicator if CAS009 is on               *                       CAS009
      *    51         Non-linear amortisation cut-off date protected  *                       232348
      *    52         Error indicator for non-linear amortisation     *                       232348
      *               cut-off date                                    *                       232348
      *    53         Override De Minimis Amount error                *                       235237
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      * SRProcess - Process initial screen                            *
      * SRMove - Move file fields to screen fields                    *
      * SRDisplay - Display Screen                                    *
      * SRValid - Validate Screen Details                             *
      * SRUpdate - Write/Update Record in file SDHEDGPD               *
      * SRSndErr- Send Error Message                                  *
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
 
     FSD000744DFCF   E             WORKSTN
      ** Hedge Strategy Maintenance Display File
 
     FSDHEDGL1  IF   E           K DISK    INFSR(*PSSR)
      ** Hedging ICD File Retrieval
 
     FSDHEDGL0  UF A E           K DISK    COMMIT
     F                                     INFSR(*PSSR)
     F                                     RENAME(SDHEDGD0:@HEDGD0)
      ** Hedging ICD File Update
 
     FSDFCTLL0  UF   E           K DISK    COMMIT
     F                                     INFSR(*PSSR)
      ** Standing Data Controls Update index
 
     FSCSARPL1  IF   E           K DISK    INFSR(*PSSR)                                       232348
      ** Midas SC Switchable Feature Initialisation PGM index                                 232348
      *                                                                                       232348
      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ D-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
     D LDA           E DS           256    EXTNAME(LDA) DTAARA(LDA)
      *
      ** Local data area for database error details
      ** *LOCK IN LDA immediately before and OUT LDA immediately
      ** after each database error handling.
      **
      **                                    134 141 DBFILE
      **       Defines:                     142 170 DBKEY
      **                                    171 180 DBPGM
      **                                    181 1830DBASE
      **                                    184 193 DBMOD
      **                                    194 203 DBPROC
      *
 
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
 
     D/COPY ZACPYSRC,PSDS
      ** Program Status Data Structure
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
      ** External data structure for Bank Details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
 
      ** External data structure for Midas Modules
     D SDMMOD        E DS                  EXTNAME(SDMMODPD)
 
      ** Securities Trading ICD
     D SDSTRD        E DS                  EXTNAME(SDSTRDPD)
 
      ** First DS for Access Programs, Short Data Structure
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      ** Second DS for Access Programs, Long Data Structure
     D DSSDY         E DS                  EXTNAME(DSSDY)
 
      ** Data Structure for SAR Details                                                       CAS006
     D SCSARD        E DS                  EXTNAME(SCSARDPD)                                  CAS006
                                                                                              CAS006
      ** Data Structure for Screen Fields
     D***#1DBRC*         DS            31                                                     CAS009
     D***#1DBRC*         DS            61                                              CAS009 230116
     D***#1DBRC*         DS            67                                              230116 232348
     D #1DBRC          DS            70                                                       232348
     D @W1DBRC         DS            70                                                       233545
 
      ** Hedging ICD File
     D @1DBRC        E DS                  EXTNAME(SDHEDGL0)
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
     D WError          S              1A
     D WField          S             16A
     D PField          S             16A
     D PDecimals       S              1  0
     D PChkFld         S             16A
     D PDigits         S              2  0
     D PFldOut         S             16A
     D PRetCode        S              7A
     D WSeTrInd        S              1A
     D POption         S              7A
     D PRetCodeIn      S              7A
     D PHedge          S             10A
     D PMode           S              1A
     D WOPCT           S              7  4
     D WOAMT           S             11  0                                                    230116
     D WCLVL           S              3  1                                                    CAS006
     D WNMBU           S              3  0                                                    CAS006
     D WHLTO           S              2  0                                                    229418
     D WNRSV           S             14 12                                                    CAS009
     D WNRNI           S              5  0                                                    CAS009
     D WSB1S           S             14 12                                                    CAS009
     D WSB2S           S             14 12                                                    CAS009
     D WRun            S              1A
     D WRunDay         S              5  0
     D WULCD           S              5  0
     D WNumRec         S              5  0
     D WNumIns         S              5  0
     D WNumAmd         S              5  0
     D WNumDel         S              5  0
     D PMsgFile        S             10A   INZ('GBSDUSRMSG')
     D PMsgID          S             10A
     D PSard           S              6A                                                      CAS006
     D CAS006          S              1A                                                      CAS006
     D PALIGNOK        S              1A                                                      CAS006
     D PZFIELD         S             16A                                                      CAS006
     D PZADEC          S              1  0                                                    CAS006
     D PZADIG          S              2  0                                                    CAS006
     D CAS007          S              1A                                                      CAS007
     D PZADEC2         S              2  0                                                    CAS009
     D CAS009          S              1A                                                      CAS009
     D WNLAC           S              5P 0                                                    232348
     D KSARN           S              6A                                                      232348
     D KPNAM           S             10A                                                      232348
     D WC9InitFlag     S              1A                                                      232348
                                                                                              232348
      ** ZDATE1 parameters                                                                    232348
     D PDateIn         S              6A                                                      232348
     D PDayNoOut       S              5P 0                                                    232348
     D PErrorFlag      S              1A                                                      232348
                                                                                              232348
      ** ZDATE2 parameters                                                                    232348
     D PDayNoIn        S              5  0                                                    232348
     D PDateOut        S              6  0                                                    232348
     D PADate          S              7A                                                      232348
 
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
 
     C                   EXSR      SRProcess
 
     C                   DOU       *INKC = *ON OR WError = 'N'
 
     C                   EXSR      SRDisplay
 
     C                   IF        PMode <> 'E' AND *INKC <> *ON
     C                   EXSR      SRValid
     C                   IF        WError <> 'Y'
     C                   EXSR      SRUpdate
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDDO
 
      ** Terminate program
 
     C                   IF        WError = 'Y'
     C                   ROLBK
     C                   ELSE
     C                   COMMIT
     C                   ENDIF
 
     C                   EVAL      *INLR = *ON
 
     C                   RETURN
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRPocess - Process Initial Screen                            *
      *                                                               *
      *  Called by: Main Processing                                   *
      *                                                               *
      *  Calls    : SRMove, SRSndErr                                  *
      *                                                               *
      *****************************************************************
 
     C     SRProcess     BEGSR
 
      ** Check for existing record
 
     C     PHedge        CHAIN     SDHEDGL1
 
      ** Record does not exist
 
     C                   IF        NOT %FOUND(SDHEDGL1)
     C                   EVAL      WError = 'Y'
 
      ** Send message 'Hedge ICD Not Found'
 
     C                   IF        PMode = 'E'
     C                   EVAL      PMsgID = 'USR9227'
     C                   ELSE
     C                   EVAL      PMsgID = 'USR9234'
     C                   ENDIF
     C                   EXSR      SRSndErr
     C                   ELSE
     C                   EXSR      SRMove
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRMove - Move File Fields to Screen Fields                   *
      *                                                               *
      *  Called by: SR/SRProcess                                      *
      *                                                               *
      *  Calls    : None                                              *
      *                                                               *
      *****************************************************************
 
     C     SRMOVE        BEGSR
 
      ** Override De Minimis Percentage
 
     C                   IF        CAS007 = 'Y'                                               CAS007
     C**********         IF        FSOPCT <> *ZEROS                                           226225
     C                   IF        FSOPCT <> *ZEROS                                           230116
 
      ** Format to Screen Field
 
     C                   EVAL      WField = *BLANKS
     C                   MOVE      FSOPCT        WField
     C                   CALL      'ZEDIT'
     C     WField        PARM      WField        PField
     C                   PARM      4             PDecimals
 
     C                   MOVE      WField        #1OPCT
     C**********         ENDIF                                                                226225
     C                   ENDIF                                                                230116
                                                                                              230116
      ** Override De Minimis Amount                                                           230116
                                                                                              230116
     C                   IF        FSOAMT <> *ZEROS                                           230116
                                                                                              230116
      ** Format to Screen Field                                                               230116
                                                                                              230116
     C                   EVAL      WField = *BLANKS                                           230116
     C                   MOVE      FSOAMT        WField                                       230116
     C                   CALL      'ZEDIT'                                                    230116
     C     WField        PARM      WField        PField                                       230116
     C                   PARM      0             PDecimals                                    230116
                                                                                              230116
     C                   MOVE      WField        #1OAMT                                       230116
     C                   ENDIF                                                                230116
                                                                                              CAS006
      ** Format to Screen Field                                                               CAS006
                                                                                              CAS006
     C                   IF        FSCLVL <> *ZEROS AND CAS006 = 'Y'                          CAS006
                                                                                              CAS006
                                                                                              CAS006
     C                   EVAL      WField = *BLANKS                                           CAS006
     C                   MOVE      FSCLVL        WField                                       CAS006
     C                   CALL      'ZEDIT'                                                    CAS006
     C     WField        PARM      WField        PField                                       CAS006
     C                   PARM      1             PDecimals                                    CAS006
                                                                                              CAS006
     C                   MOVE      WField        #1CLVL                                       CAS006
     C                   ENDIF                                                                CAS006
     C                   ENDIF                                                                CAS007
                                                                                              CAS006
     C                   IF        FSNMBU <> *ZEROS AND CAS006 = 'Y'                          CAS006
                                                                                              CAS006
                                                                                              CAS006
     C                   EVAL      WField = *BLANKS                                           CAS006
     C                   MOVE      FSNMBU        WField                                       CAS006
     C                   CALL      'ZEDIT'                                                    CAS006
     C     WField        PARM      WField        PField                                       CAS006
     C                   PARM      0             PDecimals                                    CAS006
                                                                                              CAS006
     C                   IF        CAS007 = 'Y'                                               CAS007
     C                   MOVE      WField        #1NMBU                                       CAS006
     C                   ELSE                                                                 CAS007
     C                   MOVE      WField        #2NMBU                                       CAS007
     C                   ENDIF                                                                CAS007
     C                   ENDIF                                                                CAS006
      *                                                                                       CAS008
     C                   IF        FSNDDP <> *ZEROS AND CAS008 = 'Y'                          CAS008
                                                                                              CAS008
     C                   EVAL      WField = *BLANKS                                           CAS008
     C                   MOVE      FSNDDP        WField                                       CAS008
     C                   CALL      'ZEDIT'                                                    CAS008
     C     WField        PARM      WField        PField                                       CAS008
     C                   PARM      0             PDecimals                                    CAS008
                                                                                              CAS008
     C                   MOVE      WField        #1NDDP                                       CAS008
     C                   ELSE                                                                 229596
     C                   MOVE      '0'           #1NDDP                                       229596
     C                   ENDIF                                                                CAS008
 
      ** Exclude Accrued Interest in Unrealized Profit or Loss                               BUG9476
                                                                                             BUG9476
     C                   IF        CAS006 = 'Y'                                              BUG9476
                                                                                             BUG9476
      ** Default value to 'N'                                                                BUG9476
     C                   IF        FSEXRL = *Blanks                                          BUG9476
     C                   EVAL      #1EXRL = 'N'                                              BUG9476
     C                   ELSE                                                                BUG9476
     C                   EVAL      #1EXRL = FSEXRL                                           BUG9476
     C                   ENDIF                                                               BUG9476
                                                                                             BUG9476
     C                   IF        CAS007 = 'N'                                              BUG9476
     C                   EVAL      #2EXRL = #1EXRL                                           BUG9476
     C                   ENDIF                                                               BUG9476
     C                   ENDIF                                                               BUG9476
                                                                                             BUG9476
      ** No. of months before dropping hedge.
 
     C                   IF        CAS007 = 'Y'                                               CAS007
     C                   EVAL      #1DROP = FSDROP
 
      ** SE Default Trade/Value Date Basis
 
     C                   EVAL      #1SETV = FSSETV
 
      ** SE Default Market Indicator
 
     C                   EVAL      #1SEMK = FSSEMK
                                                                                              229418
      ** Number of days for Hedge Linkage Effectiveness Tolerance                             229418
                                                                                              229418
     C                   IF        CAS006 = 'Y'                                               229418
     C                   MOVE      FSHLTO        #1HLTO                                       229418
     C                   ENDIF                                                                229418
     C                   ENDIF                                                                CAS007
 
      ***Exclude*Accrued*Interest*in*Unrealized*Profit*or*Loss**                      228948 BUG9476
                                                                                      228948 BUG9476
     C***********        IF        CAS006 = 'Y'                                       228948 BUG9476
                                                                                      228948 BUG9476
      ***Default*value*to*'N'**                                                       228948 BUG9476
     C***********        IF        FSEXRL = *Blanks                                   228948 BUG9476
     C***********        EVAL      #1EXRL = 'N'                                       228948 BUG9476
     C***********        ELSE                                                         228948 BUG9476
     C***********        EVAL      #1EXRL = FSEXRL                                    228948 BUG9476
     C***********        ENDIF                                                        228948 BUG9476
     C***********        ENDIF                                                        228948 BUG9476
      ***********                                                                     228948 BUG9476
     C                   IF        CAS009 = 'Y'                                               CAS009
                                                                                              CAS009
      ** Amortisation Method                                                                  CAS009
                                                                                              CAS009
     C                   IF        CAS007 = 'Y'                                               CAS009
     C                   EVAL      #1AMRM = FSAMRM                                            CAS009
     C                   ELSE                                                                 CAS009
     C                   EVAL      #2AMRM = FSAMRM                                            CAS009
     C                   ENDIF                                                                CAS009
                                                                                              CAS009
      ** Non-linear amortisation cut-off date                                                 232348
                                                                                              232348
     C                   EVAL      #1NLAC = *BLANKS                                           232348
     C                   EVAL      #2NLAC = *BLANKS                                           232348
     C                   IF        FSNLAC <> *ZERO                                            232348
     C                   EVAL      PDayNoIn = FSNLAC                                          232348
     C                   EXSR      SrZDATE2                                                   232348
                                                                                              232348
     C                   IF        CAS007 = 'Y'                                               232348
     C                   MOVE      PDateOut      #1NLAC                                       232348
     C                   ELSE                                                                 232348
     C                   MOVE      PDateOut      #2NLAC                                       232348
     C                   ENDIF                                                                232348
     C                   ENDIF                                                                232348
                                                                                              232348
      ** Newton-Raphson Method Starting Value                                                 CAS009
                                                                                              CAS009
     C                   EVAL      PZFIELD = *BLANKS                                          CAS009
     C                   IF        FSNRSV <> *ZERO                                            CAS009
     C                   MOVE      FSNRSV        PZFIELD                                      CAS009
     C                   CALLB     'ZEDIT2'                                                   CAS009
     C                   PARM                    PZFIELD                                      CAS009
     C                   PARM      12            PZADEC2                                      CAS009
     C                   ENDIF                                                                CAS009
                                                                                              CAS009
     C                   IF        CAS007 = 'Y'                                               CAS009
     C                   MOVE      PZFIELD       #1NRSV                                       CAS009
     C                   ELSE                                                                 CAS009
     C                   MOVE      PZFIELD       #2NRSV                                       CAS009
     C                   ENDIF                                                                CAS009
                                                                                              CAS009
      ** Newton-Raphson Method Number of Iterations                                           CAS009
                                                                                              CAS009
     C                   EVAL      PZFIELD = *BLANKS                                          CAS009
     C                   IF        FSNRNI <> *ZERO                                            CAS009
     C                   MOVE      FSNRNI        PZFIELD                                      CAS009
     C                   CALLB     'ZEDIT2'                                                   CAS009
     C                   PARM                    PZFIELD                                      CAS009
     C                   PARM      0             PZADEC2                                      CAS009
     C                   ENDIF                                                                CAS009
                                                                                              CAS009
     C                   IF        CAS007 = 'Y'                                               CAS009
     C                   MOVE      PZFIELD       #1NRNI                                       CAS009
     C                   ELSE                                                                 CAS009
     C                   MOVE      PZFIELD       #2NRNI                                       CAS009
     C                   ENDIF                                                                CAS009
                                                                                              CAS009
      ** Successive Bisection Method 1st Starting Value                                       CAS009
                                                                                              CAS009
     C                   EVAL      PZFIELD = *BLANKS                                          CAS009
     C                   IF        FSSB1S <> *ZERO                                            CAS009
     C                   MOVE      FSSB1S        PZFIELD                                      CAS009
     C                   CALLB     'ZEDIT2'                                                   CAS009
     C                   PARM                    PZFIELD                                      CAS009
     C                   PARM      12            PZADEC2                                      CAS009
     C                   ENDIF                                                                CAS009
                                                                                              CAS009
     C                   IF        CAS007 = 'Y'                                               CAS009
     C                   MOVE      PZFIELD       #1SB1S                                       CAS009
     C                   ELSE                                                                 CAS009
     C                   MOVE      PZFIELD       #2SB1S                                       CAS009
     C                   ENDIF                                                                CAS009
                                                                                              CAS009
      ** Successive Bisection Method 2nd Starting Value                                       CAS009
                                                                                              CAS009
     C                   EVAL      PZFIELD = *BLANKS                                          CAS009
     C                   IF        FSSB2S <> *ZERO                                            CAS009
     C                   MOVE      FSSB2S        PZFIELD                                      CAS009
     C                   CALLB     'ZEDIT2'                                                   CAS009
     C                   PARM                    PZFIELD                                      CAS009
     C                   PARM      12            PZADEC2                                      CAS009
     C                   ENDIF                                                                CAS009
                                                                                              CAS009
     C                   IF        CAS007 = 'Y'                                               CAS009
     C                   MOVE      PZFIELD       #1SB2S                                       CAS009
     C                   ELSE                                                                 CAS009
     C                   MOVE      PZFIELD       #2SB2S                                       CAS009
     C                   ENDIF                                                                CAS009
                                                                                              CAS009
      ** No of days in a year                                                                 CAS009
     C                   IF        CAS007 = 'Y'                                               CAS009
     C                   EVAL      #1NDAY = FSNDYR                                            CAS009
     C                   ELSE                                                                 CAS009
     C                   EVAL      #2NDAY = FSNDYR                                            CAS009
     C                   ENDIF                                                                CAS009
     C                   ENDIF                                                                CAS009
                                                                                              CAS009
      * Hold existing record image
 
     C                   EVAL      #1DBRC = @1DBRC
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRDisplay - Display and process detail screen                *
      *                                                               *
      *  Called by: Main Processing                                   *
      *                                                               *
      *  Calls    : None                                              *
      *                                                               *
      *****************************************************************
 
     C     SRDisplay     BEGSR
 
     C                   WRITE     SD000744C0
     C**********         EXFMT     SD000744F0                                                 CAS007
     C                   WRITE     SD000744F0                                                 CAS007
     C                   IF        CAS007 = 'Y'                                               CAS007
     C                   EXFMT     SD000744F1                                                 CAS007
     C                   ELSE                                                                 CAS007
     C                   EXFMT     SD000744F2                                                 CAS007
     C                   ENDIF                                                                CAS007
 
      ** Clear messages from program message queue
 
     C                   IF        PMode <> 'E'
     C                   CALL      'ZA0250'
     C                   EVAL      *IN32 = *OFF
     C                   EVAL      *IN33 = *OFF
     C                   EVAL      *IN34 = *OFF
     C                   EVAL      *IN35 = *OFF
     C                   EVAL      *IN37 = *OFF                                               CAS006
     C                   EVAL      *IN39 = *OFF                                               CAS006
     C                   EVAL      *IN42 = *OFF                                               229418
     C                   EVAL      *IN43 = *OFF                                               228948
     C                   EVAL      *IN48 = *OFF                                               CAS009
     C                   EVAL      *IN49 = *OFF                                               CAS009
     C                   EVAL      *IN44 = *OFF                                               CAS009
     C                   EVAL      *IN45 = *OFF                                               CAS009
     C                   EVAL      *IN46 = *OFF                                               CAS009
     C                   EVAL      *IN47 = *OFF                                               CAS009
     C                   EVAL      *IN52 = *OFF                                               232348
 
     C                   ENDIF
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRValid - Validate Details                                   *
      *                                                               *
      *  Called by: Main Processing                                   *
      *                                                               *
      *  Calls    : SRSndErr                                          *
      *                                                               *
      *****************************************************************
 
     C     SRValid       BEGSR
 
     C                   EVAL      WError = 'N'
 
     C                   IF        CAS007 = 'Y'                                               CAS007
                                                                                              CAS007
      ** At least Override De minimis Percentage or Amount must be entered                    230116
                                                                                              230116
     C                   IF        #1OPCT = *BLANKS  AND #1OAMT = *BLANKS                     230116
                                                                                              230116
      ** Send message 'At least Override De Minimis Percentage or Amount must be entered'     230116
                                                                                              230116
     C**********         EVAL      PMsgID = 'USR9269'                                  230116 CAS011
     C                   EVAL      PMsgID = 'CAS0004'                                         CAS011
     C                   EVAL      WError = 'Y'                                               230116
     C                   EVAL      *IN32 = *ON                                                230116
     C**********         EVAL      *IN44 = *ON                                         230116 235237
     C                   EVAL      *IN53 = *ON                                                235237
     C                   EXSR      SRSndErr                                                   230116
                                                                                              230116
     C                   ENDIF                                                                230116
                                                                                              230116
      ** Either Override De minimis Percentage or Amount may be entered                       230116
                                                                                              230116
     C                   IF        #1OPCT <> *BLANKS  AND #1OAMT <> *BLANKS                   230116
                                                                                              230116
      ** Send message 'Either Override De Minimis Percentage or Amount may be entered'        230116
                                                                                              230116
     C**********         EVAL      PMsgID = 'USR9270'                                  230116 CAS011
     C                   EVAL      PMsgID = 'CAS0005'                                         CAS011
     C                   EVAL      WError = 'Y'                                               230116
     C                   EVAL      *IN32 = *ON                                                230116
     C**********         EVAL      *IN44 = *ON                                         230116 235237
     C                   EVAL      *IN53 = *ON                                                235237
     C                   EXSR      SRSndErr                                                   230116
                                                                                              230116
     C                   ENDIF                                                                230116
                                                                                              230116
      ***Override*De*minimis*Percentage.  Mandatory numeric field. (7,4)                      230116
      **********                                                                              230116
     C**********         IF        #1OPCT = *BLANKS                                           230116
      **********                                                                              230116
      ***Send*message*'Override De Minimis Percentage must be entered'                        230116
      **********                                                                              230116
     C**********         EVAL      PMsgID = 'USR9228'                                         230116
     C**********         EVAL      WError = 'Y'                                               230116
     C**********         EVAL      *IN32 = *ON                                                230116
     C**********         EXSR      SRSndErr                                                   230116
      **********                                                                              230116
     C**********         ELSE                                                                 230116
 
      ** Validate Override De minimis Percentage when Amount is blank                         230116
                                                                                              230116
     C                   IF        #1OPCT <> *BLANKS  AND  #1OAMT = *BLANKS                   230116
                                                                                              230116
     C                   EVAL      WField = *BLANKS
     C                   EVAL      WField = #1OPCT
 
      ** Align Screen Field
 
     C                   CALL      'ZALIGN'
     C                   PARM                    PRetCode
     C     WField        PARM      WField        PChkFld
     C                   PARM      4             PDecimals
     C                   PARM      3             PDigits
     C                   PARM                    PFldOut
 
     C     PRetCode      IFNE      *BLANK
     C                   EVAL      WError = 'Y'
     C                   ELSE
     C                   EVAL      WError = 'N'
 
      ** Format Screen Field
 
     C                   CALL      'ZEDIT'
     C     WField        PARM      WField        PField
     C                   PARM      4             PDecimals
 
     C                   ENDIF
 
      ** If Error is Found
 
     C                   IF        WError = 'Y'
 
      ** Send message 'Override De Minimis Percentage must be numeric'
 
     C                   EVAL      PMsgID = 'USR9233'
     C                   EVAL      *IN32 = *ON
     C                   EXSR      SRSndErr
 
     C                   ELSE
 
      ** Save as alpha for screen output and numeric for file output
 
     C                   MOVE      WField        #1OPCT
     C                   MOVE      PFldOut       WOPCT
     C                   ENDIF
 
     C                   ENDIF
 
      ** Validate Override De minimis Amount when Percentage is blank                         230116
                                                                                              230116
     C                   IF        #1OAMT <> *BLANKS  AND  #1OPCT = *BLANKS                   230116
                                                                                              230116
     C                   EVAL      WField = *BLANKS                                           230116
     C                   EVAL      WField = #1OAMT                                            230116
                                                                                              230116
      ** Align Screen Field                                                                   230116
                                                                                              230116
     C                   CALL      'ZALIGN'                                                   230116
     C                   PARM                    PRetCode                                     230116
     C     WField        PARM      WField        PChkFld                                      230116
     C                   PARM      0             PDecimals                                    230116
     C                   PARM      11            PDigits                                      230116
     C                   PARM                    PFldOut                                      230116
                                                                                              230116
     C     PRetCode      IFNE      *BLANK                                                     230116
     C                   EVAL      WError = 'Y'                                               230116
     C                   ELSE                                                                 230116
     C                   EVAL      WError = 'N'                                               230116
                                                                                              230116
      ** Format Screen Field                                                                  230116
                                                                                              230116
     C                   CALL      'ZEDIT'                                                    230116
     C     WField        PARM      WField        PField                                       230116
     C                   PARM      0             PDecimals                                    230116
                                                                                              230116
     C                   ENDIF                                                                230116
                                                                                              230116
      ** If Error is Found                                                                    230116
                                                                                              230116
     C                   IF        WError = 'Y'                                               230116
                                                                                              230116
      ** Send message 'Override De Minimis Amount must be numeric'                            230116
                                                                                              230116
     C**********         EVAL      PMsgID = 'USR9271'                                  230116 CAS011
     C                   EVAL      PMsgID = 'CAS0006'                                         CAS011
     C**********         EVAL      *IN44 = *ON                                         230116 235237
     C                   EVAL      *IN53 = *ON                                                235237
     C                   EXSR      SRSndErr                                                   230116
                                                                                              230116
     C                   ELSE                                                                 230116
                                                                                              230116
      ** Save as alpha for screen output and numeric for file output                          230116
                                                                                              230116
     C                   MOVE      WField        #1OAMT                                       230116
     C                   MOVE      PFldOut       WOAMT                                        230116
     C                   ENDIF                                                                230116
                                                                                              230116
     C                   ENDIF                                                                230116
                                                                                              230116
      ** No. of Months before dropping expired, deleted or discontinued
      ** hedges.  Mandatory numeric field, greater than zero.
 
     C                   IF        #1DROP <= 0
 
      * Send message 'No. of Months before dropping hedges must be GT Zero'
 
     C                   EVAL      PMsgID = 'USR9229'
     C                   EVAL      WError = 'Y'
     C                   EVAL      *IN33 = *ON
     C                   EXSR      SRSndErr
 
     C                   ENDIF
     C                   ENDIF                                                                CAS007
 
      ** Valid entries are 90, 95, 98, 99, 99.9                                               CAS006
                                                                                              CAS006
     C                   IF        CAS006 = 'Y'                                               CAS006
                                                                                              CAS007
     C                   IF        CAS007 = 'Y'                                               CAS007
                                                                                              CAS006
     C                   EVAL      PZFIELD = *BLANKS                                          CAS006
     C                   MOVEL     #1CLVL        PZFIELD                                      CAS006
                                                                                              CAS006
     C                   CALLB     'ZALIGN'                                                   CAS006
     C                   PARM      *BLANKS       PALIGNOK                                     CAS006
     C                   PARM                    PZFIELD                                      CAS006
     C                   PARM      1             PZADEC                                       CAS006
     C                   PARM      2             PZADIG                                       CAS006
                                                                                              CAS006
     C                   IF        PALIGNOK = 'N'                                             CAS006
                                                                                              CAS006
      ** Send message 'Confidence Level Percentage is not valid'                              CAS006
                                                                                              CAS006
     C                   EVAL      PMsgID = 'USR9239'                                         CAS006
     C                   EVAL      WError = 'Y'                                               CAS006
     C                   EVAL      *IN37 = *ON                                                CAS006
     C                   EXSR      SRSndErr                                                   CAS006
                                                                                              CAS006
     C                   ELSE                                                                 CAS006
     C                   MOVE      PZFIELD       WCLVL                                        CAS006
                                                                                              CAS006
     C                   IF        WCLVL <> 90 AND WCLVL <> 95 AND                            CAS006
     C                             WCLVL <> 98 AND WCLVL <> 99 AND                            CAS006
     C                             WCLVL <> 99.9                                              CAS006
                                                                                              CAS006
      ** Send message 'Confidence Level Percentage is not valid'                              CAS006
                                                                                              CAS006
     C                   EVAL      PMsgID = 'USR9237'                                         CAS006
     C                   EVAL      WError = 'Y'                                               CAS006
     C                   EVAL      *IN37 = *ON                                                CAS006
     C                   EXSR      SRSndErr                                                   CAS006
                                                                                              CAS006
     C                   ENDIF                                                                CAS006
                                                                                              CAS006
      ** Format Screen Field                                                                  CAS006
     C                   CALLB     'ZEDIT'                                                    CAS006
     C                   PARM                    PZFIELD                                      CAS006
     C                   PARM      1             PZADEC                                       CAS006
                                                                                              CAS006
     C                   MOVE      PZFIELD       #1CLVL                                       CAS006
                                                                                              CAS006
     C                   ENDIF                                                                CAS006
     C                   ENDIF                                                                CAS007
                                                                                              CAS006
      ** Number of months to backup                                                           CAS006
                                                                                              CAS006
     C                   EVAL      PZFIELD = *BLANKS                                          CAS006
     C                   IF        CAS007 = 'Y'                                               CAS007
     C                   MOVEL     #1NMBU        PZFIELD                                      CAS006
     C                   ELSE                                                                 CAS007
     C                   MOVEL     #2NMBU        PZFIELD                                      CAS007
     C                   ENDIF                                                                CAS007
     C                   EVAL      WNMBU = *ZERO                                              CAS006
                                                                                              CAS006
     C                   CALLB     'ZALIGN'                                                   CAS006
     C                   PARM      *BLANKS       PALIGNOK                                     CAS006
     C                   PARM                    PZFIELD                                      CAS006
     C                   PARM      0             PZADEC                                       CAS006
     C                   PARM      3             PZADIG                                       CAS006
                                                                                              CAS006
     C                   IF        PALIGNOK = 'N'                                             CAS006
                                                                                              CAS006
      ** Send message 'Entry must be numeric'                                                 CAS006
                                                                                              CAS006
     C                   EVAL      PMsgID = 'USR9238'                                         CAS006
     C                   EVAL      WError = 'Y'                                               CAS006
     C                   EVAL      *IN39 = *ON                                                CAS006
     C                   EXSR      SRSndErr                                                   CAS006
     C                   ELSE                                                                 CAS006
                                                                                              CAS006
     C                   MOVE      PZFIELD       WNMBU                                        CAS006
                                                                                              CAS006
      ** Format Screen Field                                                                  CAS006
                                                                                              CAS006
     C                   CALLB     'ZEDIT'                                                    CAS006
     C                   PARM                    PZFIELD                                      CAS006
     C                   PARM      0             PZADEC                                       CAS006
                                                                                              CAS006
     C                   IF        CAS007 = 'Y'                                               CAS007
     C                   MOVE      PZFIELD       #1NMBU                                       CAS006
     C                   ELSE                                                                 CAS007
     C                   MOVE      PZFIELD       #2NMBU                                       CAS007
     C                   ENDIF                                                                CAS007
     C                   ENDIF                                                                CAS006
     C                   ENDIF                                                                CAS006
                                                                                              CAS006
                                                                                             BUG9476
      ** Exclude Accrued Interest in Unrealized Profit/Loss must be 'Y' or 'N'               BUG9476
                                                                                             BUG9476
     C                   IF        CAS006 = 'Y'                                              BUG9476
                                                                                             BUG9476
     C                   IF        #1EXRL <> 'N'  AND                                        BUG9476
     C                             #1EXRL <> 'Y'  AND                                        BUG9476
     C                             CAS007 = 'Y'                                              BUG9476
     C                             OR CAS007 = 'N'                                           BUG9476
     C                             AND #2EXRL <> 'N'  AND                                    BUG9476
     C                             #2EXRL <> 'Y'                                             BUG9476
     C                   EVAL      PMsgID = 'USR0805'                                        BUG9476
     C                   EVAL      WError = 'Y'                                              BUG9476
     C                   EVAL      *IN43 = *ON                                               BUG9476
     C                   EXSR      SRSndErr                                                  BUG9476
     C                   ELSE                                                                BUG9476
                                                                                             BUG9476
     C                   EVAL      FSEXRL = #1EXRL                                           BUG9476
     C                   IF        CAS007 = 'N'                                              BUG9476
     C                   EVAL      FSEXRL = #2EXRL                                           BUG9476
     C                   ENDIF                                                               BUG9476
                                                                                             BUG9476
     C                   ENDIF                                                               BUG9476
     C                   ENDIF                                                               BUG9476
      ** If the Securities Trading Module is present, allow entry of
      ** Default Trade/Value Date Basis and Default Market Indicator.
 
     C                   IF        CAS007 = 'Y'                                               CAS007
                                                                                              CAS007
     C                   IF        WSeTrInd = 'Y'
 
      ** Valid entries are 'T' or 'V'.
 
     C                   IF        #1SETV <> 'T' AND #1SETV <> 'V'
     C                   EVAL      PMsgID = 'USR9230'
     C                   EVAL      WError = 'Y'
     C                   EVAL      *IN34 = *ON
     C                   EXSR      SRSndErr
     C                   ENDIF
 
      ** Must match Unrealised Profit Basis from Securities Trading ICD
      ** unless SE ICD was specified as 'B' (both entries are valid).
 
     C                   IF        BVUPB <> 'B' AND BVUPB <> #1SETV
     C                   EVAL      PMsgID = 'USR9231'
     C                   EVAL      WError = 'Y'
     C                   EVAL      *IN34 = *ON
     C                   EXSR      SRSndErr
     C                   ENDIF
 
      ** Securities Trading Default Market Indicator.
      ** Mandatory field if Securities Trading Module is present.
      ** Valid entries are 'G', 'P' or 'S'.
 
     C                   IF        #1SEMK <> 'G' AND #1SEMK <> 'P'
     C                             AND #1SEMK <> 'S'
     C                   EVAL      PMsgID = 'USR9232'
     C                   EVAL      WError = 'Y'
     C                   EVAL      *IN35 = *ON
     C                   EXSR      SRSndErr
     C                   ENDIF
 
     C                   ENDIF
     C                   ENDIF                                                                CAS007
      *                                                                                       CAS008
      ** Number of days to backup                                                             CAS008
      *                                                                                       CAS008
     C                   IF        CAS008 = 'Y'                                               CAS008
     C                   EVAL      PZFIELD = *BLANKS                                          CAS008
     C                   MOVEL     #1NDDP        PZFIELD                                      CAS008
     C                   MOVE      *ZERO         WNDDP             3 0                        CAS008
     C                   EVAL      *IN40 = *OFF                                               CAS008
                                                                                              CAS008
     C                   CALLB     'ZALIGN'                                                   CAS008
     C                   PARM      *BLANKS       PALIGNOK                                     CAS008
     C                   PARM                    PZFIELD                                      CAS008
     C                   PARM      0             PZADEC                                       CAS008
     C                   PARM      2             PZADIG                                       CAS008
                                                                                              CAS008
     C                   IF        PALIGNOK = 'N'                                             CAS008
      *                                                                                       CAS008
      ** Send message 'Entry must be numeric'                                                 CAS008
      *                                                                                       CAS008
     C**********         EVAL      PMsgID = 'USR9272'                                  CAS008 CAS011
     C                   EVAL      PMsgID = 'CAS0007'                                         CAS011
     C                   EVAL      WError = 'Y'                                               CAS008
     C                   EVAL      *IN40 = *ON                                                CAS008
     C                   EXSR      SRSndErr                                                   CAS008
     C                   ELSE                                                                 CAS008
                                                                                              CAS008
     C                   MOVE      PZFIELD       WNDDP                                        CAS008
                                                                                              CAS008
      ** Format Screen Field                                                                  CAS008
                                                                                              CAS008
     C                   CALLB     'ZEDIT'                                                    CAS008
     C                   PARM                    PZFIELD                                      CAS008
     C                   PARM      0             PZADEC                                       CAS008
                                                                                              CAS008
     C                   MOVE      PZFIELD       #1NDDP                                       CAS008
                                                                                              CAS008
      *                                                                                       CAS008
      ** Delayed Hedge Assessment is only allowed up to 15 working days.                      CAS008
      *                                                                                       CAS008
     C                   IF        WNDDP > 15                                                 CAS008
     C**********         EVAL      PMsgID = 'USR9271'                                  CAS008 CAS011
     C                   EVAL      PMsgID = 'CAS0006'                                         CAS011
     C                   EVAL      WError = 'Y'                                               CAS008
     C                   EVAL      *IN40 = *ON                                                CAS008
     C                   EXSR      SRSndErr                                                   CAS008
     C                   ENDIF                                                                CAS008
     C                   ENDIF                                                                CAS008
      *                                                                                       CAS008
     C                   ENDIF                                                                CAS008
                                                                                              229418
      ** Number of days for Hedge Linkage Effectiveness Tolerance                             229418
      ** must be numeric and positive.                                                        229418
                                                                                              229418
     C                   IF        CAS006 = 'Y'                                               229418
     C                   EVAL      PZFIELD = *BLANKS                                          229418
     C                   EVAL      PZFIELD = #1HLTO                                           229418
     C                   EVAL      WHLTO = *ZERO                                              229418
                                                                                              229418
     C                   CALLB     'ZALIGN'                                                   229418
     C                   PARM      *BLANKS       PALIGNOK                                     229418
     C                   PARM                    PZFIELD                                      229418
     C                   PARM      0             PZADEC                                       229418
     C                   PARM      2             PZADIG                                       229418
                                                                                              229418
     C                   IF        PALIGNOK = 'N'                                             229418
     C                   EVAL      PMsgID = 'USR0822'                                         229418
     C                   EVAL      WError = 'Y'                                               229418
     C                   EVAL      *IN42 = *ON                                                229418
     C                   EXSR      SRSndErr                                                   229418
     C                   ELSE                                                                 229418
                                                                                              229418
      ** Valid value, format screen field                                                     229418
                                                                                              229418
     C                   CALLB     'ZEDIT'                                                    229418
     C                   PARM                    PZFIELD                                      229418
     C                   PARM      0             PZADEC                                       229418
                                                                                              229418
     C                   MOVE      PZFIELD       #1HLTO                                       229418
     C                   MOVE      #1HLTO        WHLTO                                        229418
     C                   ENDIF                                                                229418
     C                   ENDIF                                                                229418
                                                                                              229418
      ***********                                                                     228948 BUG9476
      ***Exclude Accrued Interest in Unrealized Profit/Loss must be 'Y' or 'N'        228948 BUG9476
      ***********                                                                     228948 BUG9476
     C***********        IF        CAS006 = 'Y'                                       228948 BUG9476
      ***********                                                                     228948 BUG9476
     C***********        IF        #1EXRL <> 'N'  AND                                 228948 BUG9476
     C***********                  #1EXRL <> 'Y'                                      228948 BUG9476
     C***********        EVAL      PMsgID = 'USR0805'                                 228948 BUG9476
     C***********        EVAL      WError = 'Y'                                       228948 BUG9476
     C***********        EVAL      *IN43 = *ON                                        228948 BUG9476
     C***********        EXSR      SRSndErr                                           228948 BUG9476
     C***********        ELSE                                                         228948 BUG9476
     C***********        EVAL      FSEXRL = #1EXRL                                    228948 BUG9476
     C***********        ENDIF                                                        228948 BUG9476
     C***********        ENDIF                                                        228948 BUG9476
                                                                                              CAS009
     C                   IF        CAS009 = 'Y'                                               CAS009
                                                                                              CAS009
      ** Amortisation Method                                                                  CAS009
                                                                                              CAS009
     C                   IF        #1AMRM <> 'L' AND                                          CAS009
     C                             #1AMRM <> 'N' AND                                          CAS009
     C                             #1AMRM <> *BLANKS AND                                      CAS009
     C                             CAS007 = 'Y'  OR                                           CAS009
     C                             #2AMRM <> 'L' AND                                          CAS009
     C                             #2AMRM <> 'N' AND                                          CAS009
     C                             #2AMRM <> *BLANKS AND                                      CAS009
     C                             CAS007 <>'Y'                                               CAS009
                                                                                              CAS009
      ** Send message 'Amortisation Method must be 'L', 'N' or ' ''                           CAS009
                                                                                              CAS009
     C**********         EVAL      PMsgID = 'USR9266'                                  CAS009 CAS011
     C                   EVAL      PMsgID = 'CAS0001'                                         CAS011
     C                   EVAL      WError = 'Y'                                               CAS009
     C                   EVAL      *IN48 = *ON                                                CAS009
     C                   EXSR      SRSndErr                                                   CAS009
     C                   ENDIF                                                                CAS009
                                                                                              CAS009
      ** Validate Non-linear Amortisation cut-off date if amortisation                        232348
      ** method is valid and field is not protected.                                          232348
                                                                                              232348
     C                   IF        *IN48 = *OFF AND                                           232348
     C                             *IN51 = *OFF                                               232348
     C                   EVAL      WNLAC = *ZERO                                              232348
     C                   EVAL      PErrorFlag = 'N'                                           232348
     C                   EVAL      PAlignOk = 'Y'                                             232348
     C                   EVAL      PZFIELD = *BLANK                                           232348
     C                   IF        CAS007 = 'Y'                                               232348
     C                   MOVEL     #1NLAC        PZFIELD                                      232348
     C                   ELSE                                                                 232348
     C                   MOVEL     #2NLAC        PZFIELD                                      232348
     C                   ENDIF                                                                232348
                                                                                              232348
     C                   IF        PZFIELD <> *BLANKS                                         232348
     C                   MOVE      *ZERO         PZADEC2                                      232348
     C                   MOVE      6             PZADIG                                       232348
                                                                                              232348
     C                   EXSR      SrALIGN2                                                   232348
                                                                                              232348
     C                   IF        PAlignOk = 'Y'                                             232348
     C                   MOVE      PZFIELD       PDateIn                                      232348
     C                   EXSR      SrZDate1                                                   232348
     C                   ENDIF                                                                232348
     C                   ENDIF                                                                232348
                                                                                              232348
     C                   SELECT                                                               232348
                                                                                              232348
      ** Set message 'Date entered is not in a valid date format.'                            232348
     C                   WHEN      PAlignOk <> 'Y' OR                                         232348
     C                             PErrorFlag = 'Y'                                           232348
     C                   EVAL      *IN52 = *ON                                                232348
     C                   EVAL      PMsgID = 'USR0844'                                         232348
                                                                                              232348
      ** If no errors found, move converted date to work field                                232348
     C                   OTHER                                                                232348
     C                   EVAL      WNLAC = PDayNoOut                                          232348
     C                   ENDSL                                                                232348
                                                                                              232348
      ** Send error message                                                                   232348
     C                   IF        *IN52 = *ON                                                232348
     C                   EVAL      WError = 'Y'                                               232348
     C                   EXSR      SRSndErr                                                   232348
     C                   ENDIF                                                                232348
     C                   ENDIF                                                                232348
                                                                                              232348
      ** Newton-Raphson Method Starting Value                                                 CAS009
                                                                                              CAS009
     C                   IF        #1NRSV = *BLANKS AND                                       CAS009
     C                             CAS007 = 'Y'     OR                                        CAS009
     C                             #2NRSV = *BLANKS AND                                       CAS009
     C                             CAS007 <>'Y'                                               CAS009
                                                                                              CAS009
      ** Send message 'Newton-Raphson Method Starting Value must be entered'                  CAS009
                                                                                              CAS009
     C**********         EVAL      PMsgID = 'USR9267'                                  CAS009 CAS011
     C                   EVAL      PMsgID = 'CAS0002'                                         CAS011
     C                   EVAL      WError = 'Y'                                               CAS009
     C                   EVAL      *IN49 = *ON                                                CAS009
     C                   EXSR      SRSndErr                                                   CAS009
                                                                                              CAS009
     C                   ELSE                                                                 CAS009
                                                                                              CAS009
      ** Align Screen Field                                                                   CAS009
                                                                                              CAS009
     C                   IF        CAS007 = 'Y'                                               CAS009
     C                   EVAL      PZFIELD = #1NRSV                                           CAS009
     C                   ELSE                                                                 CAS009
     C                   EVAL      PZFIELD = #2NRSV                                           CAS009
     C                   ENDIF                                                                CAS009
     C                   CALLB     'ZALIGN2'                                                  CAS009
     C                   PARM      *BLANKS       PALIGNOK                                     CAS009
     C                   PARM                    PZFIELD                                      CAS009
     C                   PARM      12            PZADEC2                                      CAS009
     C                   PARM      2             PZADIG                                       CAS009
                                                                                              CAS009
     C                   IF        PALIGNOK <> 'Y'                                            CAS009
                                                                                              CAS009
      ** Send message 'Newton-Raphson Method Starting Value must be numeric'                  CAS009
                                                                                              CAS009
     C**********         EVAL      PMsgID = 'USR9268'                                  CAS009 CAS011
     C                   EVAL      PMsgID = 'CAS0003'                                         CAS011
     C                   EVAL      WError = 'Y'                                               CAS009
     C                   EVAL      *IN49 = *ON                                                CAS009
     C                   EXSR      SRSndErr                                                   CAS009
                                                                                              CAS009
     C                   ELSE                                                                 CAS009
                                                                                              CAS009
      ** Save as numeric for file output                                                      CAS009
                                                                                              CAS009
     C                   EVAL      WNRSV = *ZERO                                              CAS009
     C                   MOVE      PZFIELD       WNRSV                                        CAS009
                                                                                              CAS009
     C                   IF        WNRSV < 1                                                  CAS009
                                                                                              CAS009
      ** Send message 'Newton-Raphson Method Starting Value must be                           CAS009
      ** greater than or equal to 1'                                                          CAS009
                                                                                              CAS009
     C**********         EVAL      PMsgID = 'USR9269'                                  CAS009 CAS011
     C                   EVAL      PMsgID = 'CAS0004'                                         CAS011
     C                   EVAL      WError = 'Y'                                               CAS009
     C                   EVAL      *IN49 = *ON                                                CAS009
     C                   EXSR      SRSndErr                                                   CAS009
     C                   ENDIF                                                                CAS009
                                                                                              CAS009
      ** Format Screen Field                                                                  CAS009
                                                                                              CAS009
     C                   CALLB     'ZEDIT2'                                                   CAS009
     C                   PARM                    PZFIELD                                      CAS009
     C                   PARM      12            PZADEC2                                      CAS009
                                                                                              CAS009
      ** Save as alpha for screen output                                                      CAS009
                                                                                              CAS009
     C                   IF        CAS007 = 'Y'                                               CAS009
     C                   MOVE      PZFIELD       #1NRSV                                       CAS009
     C                   ELSE                                                                 CAS009
     C                   MOVE      PZFIELD       #2NRSV                                       CAS009
     C                   ENDIF                                                                CAS009
                                                                                              CAS009
     C                   ENDIF                                                                CAS009
                                                                                              CAS009
     C                   ENDIF                                                                CAS009
                                                                                              CAS009
      ** Newton-Raphson Method Number of Iterations                                           CAS009
                                                                                              CAS009
     C                   IF        #1NRNI = *BLANKS AND                                       CAS009
     C                             CAS007 = 'Y'     OR                                        CAS009
     C                             #2NRNI = *BLANKS AND                                       CAS009
     C                             CAS007 <>'Y'                                               CAS009
                                                                                              CAS009
      ** Send message 'Newton-Raphson Method Number of Iterations must be entered'            CAS009
                                                                                              CAS009
     C**********         EVAL      PMsgID = 'USR9270'                                  CAS009 CAS011
     C                   EVAL      PMsgID = 'CAS0005'                                         CAS011
     C                   EVAL      WError = 'Y'                                               CAS009
     C                   EVAL      *IN44 = *ON                                                CAS009
     C                   EXSR      SRSndErr                                                   CAS009
                                                                                              CAS009
     C                   ELSE                                                                 CAS009
                                                                                              CAS009
      ** Align Screen Field                                                                   CAS009
                                                                                              CAS009
     C                   IF        CAS007 = 'Y'                                               CAS009
     C                   EVAL      PZFIELD = #1NRNI                                           CAS009
     C                   ELSE                                                                 CAS009
     C                   EVAL      PZFIELD = #2NRNI                                           CAS009
     C                   ENDIF                                                                CAS009
     C                   CALLB     'ZALIGN2'                                                  CAS009
     C                   PARM      *BLANKS       PALIGNOK                                     CAS009
     C                   PARM                    PZFIELD                                      CAS009
     C                   PARM      0             PZADEC2                                      CAS009
     C                   PARM      5             PZADIG                                       CAS009
                                                                                              CAS009
     C                   IF        PALIGNOK <> 'Y'                                            CAS009
                                                                                              CAS009
      ** Send message 'Newton-Raphson Method Number of Iteraton must be                       CAS009
      ** numeric'                                                                             CAS009
                                                                                              CAS009
     C                   EVAL      PMsgID = 'USR9292'                                         CAS009
     C                   EVAL      WError = 'Y'                                               CAS009
     C                   EVAL      *IN44 = *ON                                                CAS009
     C                   EXSR      SRSndErr                                                   CAS009
                                                                                              CAS009
     C                   ELSE                                                                 CAS009
                                                                                              CAS009
      ** Save as numeric for file output                                                      CAS009
                                                                                              CAS009
     C                   EVAL      WNRNI = *ZERO                                              CAS009
     C                   MOVE      PZFIELD       WNRNI                                        CAS009
                                                                                              CAS009
     C                   IF        WNRNI < *ZERO                                              CAS009
                                                                                              CAS009
      ** Send message 'Newton-Raphson Method Number of Iteration must be                      CAS009
      ** greater or equal to zero'                                                            CAS009
                                                                                              CAS009
     C                   EVAL      PMsgID = 'USR9293'                                         CAS009
     C                   EVAL      WError = 'Y'                                               CAS009
     C                   EVAL      *IN44 = *ON                                                CAS009
     C                   EXSR      SRSndErr                                                   CAS009
     C                   ENDIF                                                                CAS009
                                                                                              CAS009
      ** Format Screen Field                                                                  CAS009
                                                                                              CAS009
     C                   CALLB     'ZEDIT2'                                                   CAS009
     C                   PARM                    PZFIELD                                      CAS009
     C                   PARM      0             PZADEC2                                      CAS009
                                                                                              CAS009
      ** Save as alpha for screen output                                                      CAS009
                                                                                              CAS009
     C                   IF        CAS007 = 'Y'                                               CAS009
     C                   MOVE      PZFIELD       #1NRNI                                       CAS009
     C                   ELSE                                                                 CAS009
     C                   MOVE      PZFIELD       #2NRNI                                       CAS009
     C                   ENDIF                                                                CAS009
                                                                                              CAS009
     C                   ENDIF                                                                CAS009
                                                                                              CAS009
     C                   ENDIF                                                                CAS009
                                                                                              CAS009
      ** Successive Bisection Method 1st Starting Value                                       CAS009
                                                                                              CAS009
     C                   IF        #1SB1S = *BLANKS  AND                                      CAS009
     C                             CAS007 = 'Y'      OR                                       CAS009
     C                             #2SB1S = *BLANKS  AND                                      CAS009
     C                             CAS007 <>'Y'                                               CAS009
                                                                                              CAS009
      ** Send message 'Successive Bisection Method 1st Starting Value                         CAS009
      ** must be entered'                                                                     CAS009
                                                                                              CAS009
     C                   EVAL      PMsgID = 'USR9294'                                         CAS009
     C                   EVAL      WError = 'Y'                                               CAS009
     C                   EVAL      *IN45 = *ON                                                CAS009
     C                   EXSR      SRSndErr                                                   CAS009
                                                                                              CAS009
     C                   ELSE                                                                 CAS009
                                                                                              CAS009
      ** Align Screen Field                                                                   CAS009
                                                                                              CAS009
     C                   IF        CAS007 = 'Y'                                               CAS009
     C                   EVAL      PZFIELD = #1SB1S                                           CAS009
     C                   ELSE                                                                 CAS009
     C                   EVAL      PZFIELD = #2SB1S                                           CAS009
     C                   ENDIF                                                                CAS009
     C                   CALLB     'ZALIGN2'                                                  CAS009
     C                   PARM      *BLANKS       PALIGNOK                                     CAS009
     C                   PARM                    PZFIELD                                      CAS009
     C                   PARM      12            PZADEC2                                      CAS009
     C                   PARM      2             PZADIG                                       CAS009
                                                                                              CAS009
     C                   IF        PALIGNOK <> 'Y'                                            CAS009
                                                                                              CAS009
      ** Send message 'Successive Bisection Method 1st Starting Value                         CAS009
      ** must be numeric'                                                                     CAS009
                                                                                              CAS009
     C**********         EVAL      PMsgID = 'USR9274'                                  CAS009 CAS011
     C                   EVAL      PMsgID = 'CAS0009'                                         CAS011
     C                   EVAL      WError = 'Y'                                               CAS009
     C                   EVAL      *IN45 = *ON                                                CAS009
     C                   EXSR      SRSndErr                                                   CAS009
                                                                                              CAS009
     C                   ELSE                                                                 CAS009
                                                                                              CAS009
      ** Save as numeric for file output                                                      CAS009
                                                                                              CAS009
     C                   EVAL      WSB1S = *ZERO                                              CAS009
     C                   MOVE      PZFIELD       WSB1S                                        CAS009
                                                                                              CAS009
     C                   IF        WSB1S < 1                                                  CAS009
                                                                                              CAS009
      ** Send message 'Successive Bisection Method 1st Starting Value                         CAS009
      ** must be greater than or equal to 1'                                                  CAS009
                                                                                              CAS009
     C**********         EVAL      PMsgID = 'USR9275'                                  CAS009 CAS011
     C                   EVAL      PMsgID = 'CAS0010'                                         CAS011
     C                   EVAL      WError = 'Y'                                               CAS009
     C                   EVAL      *IN45 = *ON                                                CAS009
     C                   EXSR      SRSndErr                                                   CAS009
     C                   ENDIF                                                                CAS009
                                                                                              CAS009
      ** Format Screen Field                                                                  CAS009
                                                                                              CAS009
     C                   CALLB     'ZEDIT2'                                                   CAS009
     C                   PARM                    PZFIELD                                      CAS009
     C                   PARM      12            PZADEC2                                      CAS009
                                                                                              CAS009
      ** Save as alpha for screen output                                                      CAS009
                                                                                              CAS009
     C                   IF        CAS007 = 'Y'                                               CAS009
     C                   MOVE      PZFIELD       #1SB1S                                       CAS009
     C                   ELSE                                                                 CAS009
     C                   MOVE      PZFIELD       #2SB1S                                       CAS009
     C                   ENDIF                                                                CAS009
                                                                                              CAS009
     C                   ENDIF                                                                CAS009
                                                                                              CAS009
     C                   ENDIF                                                                CAS009
                                                                                              CAS009
      ** Successive Bisection Method 2st Starting Value                                       CAS009
                                                                                              CAS009
     C                   IF        #1SB2S = *BLANKS AND                                       CAS009
     C                             CAS007 = 'Y'     OR                                        CAS009
     C                             #2SB2S = *BLANKS AND                                       CAS009
     C                             CAS007 <>'Y'                                               CAS009
                                                                                              CAS009
      ** Send message 'Successive Bisection Method 2nd Starting Value                         CAS009
      ** must be entered'                                                                     CAS009
                                                                                              CAS009
     C**********         EVAL      PMsgID = 'USR9276'                                  CAS009 CAS011
     C                   EVAL      PMsgID = 'CAS0011'                                         CAS011
     C                   EVAL      WError = 'Y'                                               CAS009
     C                   EVAL      *IN46 = *ON                                                CAS009
     C                   EXSR      SRSndErr                                                   CAS009
                                                                                              CAS009
     C                   ELSE                                                                 CAS009
                                                                                              CAS009
      ** Align Screen Field                                                                   CAS009
                                                                                              CAS009
     C                   IF        CAS007 = 'Y'                                               CAS009
     C                   EVAL      PZFIELD = #1SB2S                                           CAS009
     C                   ELSE                                                                 CAS009
     C                   EVAL      PZFIELD = #2SB2S                                           CAS009
     C                   ENDIF                                                                CAS009
     C                   CALLB     'ZALIGN2'                                                  CAS009
     C                   PARM      *BLANKS       PALIGNOK                                     CAS009
     C                   PARM                    PZFIELD                                      CAS009
     C                   PARM      12            PZADEC2                                      CAS009
     C                   PARM      2             PZADIG                                       CAS009
                                                                                              CAS009
     C                   IF        PALIGNOK <> 'Y'                                            CAS009
                                                                                              CAS009
      ** Send message 'Successive Bisection Method 2nd Starting Value                         CAS009
      ** must be numeric'                                                                     CAS009
                                                                                              CAS009
     C**********         EVAL      PMsgID = 'USR9277'                                  CAS009 CAS011
     C                   EVAL      PMsgID = 'CAS0012'                                         CAS011
     C                   EVAL      WError = 'Y'                                               CAS009
     C                   EVAL      *IN46 = *ON                                                CAS009
     C                   EXSR      SRSndErr                                                   CAS009
                                                                                              CAS009
     C                   ELSE                                                                 CAS009
                                                                                              CAS009
      ** Save as numeric for file output                                                      CAS009
                                                                                              CAS009
     C                   EVAL      WSB2S = *ZERO                                              CAS009
     C                   MOVE      PZFIELD       WSB2S                                        CAS009
                                                                                              CAS009
     C                   IF        WSB2S <= WSB1S                                             CAS009
                                                                                              CAS009
      ** Send message 'Successive Bisection Method 2nd Starting Value                         CAS009
      ** must be greater than 1st Starting Value'                                             CAS009
                                                                                              CAS009
     C**********         EVAL      PMsgID = 'USR9278'                                  CAS009 CAS011
     C                   EVAL      PMsgID = 'CAS0013'                                         CAS011
     C                   EVAL      WError = 'Y'                                               CAS009
     C                   EVAL      *IN46 = *ON                                                CAS009
     C                   EXSR      SRSndErr                                                   CAS009
     C                   ENDIF                                                                CAS009
                                                                                              CAS009
      ** Format Screen Field                                                                  CAS009
                                                                                              CAS009
     C                   CALLB     'ZEDIT2'                                                   CAS009
     C                   PARM                    PZFIELD                                      CAS009
     C                   PARM      12            PZADEC2                                      CAS009
                                                                                              CAS009
      ** Save as alpha for screen output                                                      CAS009
                                                                                              CAS009
     C                   IF        CAS007 = 'Y'                                               CAS009
     C                   MOVE      PZFIELD       #1SB2S                                       CAS009
     c                   ELSE                                                                 CAS009
     C                   MOVE      PZFIELD       #2SB2S                                       CAS009
     C                   ENDIF                                                                CAS009
                                                                                              CAS009
     C                   ENDIF                                                                CAS009
                                                                                              CAS009
     C                   ENDIF                                                                CAS009
                                                                                              CAS009
      ** No of days in a year                                                                 CAS009
     C                   IF        CAS007 = 'Y' AND                                           CAS009
     C                             #1NDAY <> *BLANKS AND                                      CAS009
     C                             #1NDAY <> '360' AND                                        CAS009
     C                             #1NDAY <> '365' AND                                        CAS009
     C                             #1NDAY <> '366' OR                                         CAS009
     C                             CAS007 <> 'Y' AND                                          CAS009
     C                             #2NDAY <> *BLANKS AND                                      CAS009
     C                             #2NDAY <> '360' AND                                        CAS009
     C                             #2NDAY <> '365' AND                                        CAS009
     C                             #2NDAY <> '366'                                            CAS009
                                                                                              CAS009
      ** Send message 'Valid values are blank, 360, 365 or 366                                CAS009
                                                                                              CAS009
     C**********         EVAL      PMsgID = 'USR9279'                                  CAS009 CAS011
     C                   EVAL      PMsgID = 'CAS0014'                                         CAS011
     C                   EVAL      WError = 'Y'                                               CAS009
     C                   EVAL      *IN47 = *ON                                                CAS009
     C                   EXSR      SRSndErr                                                   CAS009
     C                   ENDIF                                                                CAS009
                                                                                              CAS009
     C                   ENDIF                                                                CAS009
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRUpdate - Update Record in PF/SDHEDGPD                      *
      *                                                               *
      *  Called by: Main Processing                                   *
      *                                                               *
      *  Calls    : SRSndErr                                          *
      *                                                               *
      *****************************************************************
 
     C     SRUpdate      BEGSR
 
     C     PHedge        CHAIN     SDHEDGL0
 
      ** Write new ICD record
 
     C                   IF        NOT %FOUND(SDHEDGL0)
                                                                                            BUG10772
     C                   CLEAR                   @HEDGD0                                    BUG10772
 
     C                   EVAL      FSHEDG = PHedge
     C                   EVAL      FSOPCT = WOPCT
     C                   EVAL      FSOAMT = WOAMT                                             230116
     C                   EVAL      FSDROP = #1DROP
     C                   EVAL      FSSETV = #1SETV
     C                   EVAL      FSSEMK = #1SEMK
     C                   EVAL      FSLCD = WRunDay
     C                   IF        CAS006 = 'Y'                                               CAS006
     C                   EVAL      FSCLVL = WCLVL                                             CAS006
     C                   EVAL      FSNMBU = WNMBU                                             CAS006
     C                   EVAL      FSHLTO = WHLTO                                             229418
     C                   EVAL      FSEXRL = #1EXRL                                            228948
     C                   IF        CAS007 = 'N'                                              BUG9476
     C                   EVAL      FSEXRL = #2EXRL                                           BUG9476
     C                   ENDIF                                                               BUG9476
      *                                                                                       CAS008
     C                   IF        CAS008 = 'Y'                                               CAS008
     C                   EVAL      FSNDDP = WNDDP                                             CAS008
     C                   ENDIF                                                                CAS008
      *                                                                                       CAS008
     C                   ENDIF                                                                CAS006
                                                                                              CAS009
     C                   IF        CAS009 = 'Y'                                               CAS009
     C                   IF        CAS007 = 'Y'                                               CAS009
     C                   EVAL      FSAMRM = #1AMRM                                            CAS009
     C                   ELSE                                                                 CAS009
     C                   EVAL      FSAMRM = #2AMRM                                            CAS009
     C                   ENDIF                                                                CAS009
     C                   EVAL      FSNLAC = WNLAC                                             232348
     C                   EVAL      FSNRSV = WNRSV                                             CAS009
     C                   EVAL      FSNRNI = WNRNI                                             CAS009
     C                   EVAL      FSSB1S = WSB1S                                             CAS009
     C                   EVAL      FSSB2S = WSB2S                                             CAS009
     C                   EVAL      FSSWDT = BJRDNB                                          BUG10772
     C                   IF        CAS007 = 'Y'                                               CAS009
     C                   EVAL      FSNDYR = #1NDAY                                            CAS009
     C                   ELSE                                                                 CAS009
     C                   EVAL      FSNDYR = #2NDAY                                            CAS009
     C                   ENDIF                                                                CAS009
     C                   ELSE                                                                 CAS009
     C                   EVAL      FSNRSV = *ZERO                                             CAS009
     C                   EVAL      FSNRNI = *ZERO                                             CAS009
     C                   EVAL      FSSB1S = *ZERO                                             CAS009
     C                   EVAL      FSSB2S = *ZERO                                             CAS009
     C                   EVAL      FSSWDT = *ZERO                                           BUG10772
     C                   ENDIF                                                                CAS009
                                                                                              CAS009
     C                   EVAL      FSCHTP = 'I'
 
     C                   WRITE     @HEDGD0
 
      ** Update saved record image
 
     C                   EVAL      #1DBRC = @1DBRC
 
      ** Change Standing Data Controls
 
     C                   Z-ADD     *ZERO         WNumRec
     C                   Z-ADD     1             WNumIns
     C                   Z-ADD     *ZERO         WNumDel
     C                   Z-ADD     *ZERO         WNumAmd
 
     C                   EXSR      SRSDCntrl
 
     C                   ENDIF
 
      ** Update SDHEDGL0
 
     C                   IF        %FOUND(SDHEDGL0)
                                                                                              233545
      ** Move record to 70 field length for later comparison of file and screen format        233545
                                                                                              233545
     C                   EVAL      @W1DBRC = @1DBRC                                           233545
 
      ** Check for changed record
 
     C**********         IF        #1DBRC <> @1DBRC                                           233545
     C                   IF        #1DBRC <> @W1DBRC                                          233545
     C                   EVAL      WError = 'Y'
     C                   EVAL      PMsgID = 'USR9235'
     C                   EXSR      SRSndErr
     C                   UNLOCK    SDHEDGL0
 
     C                   ELSE
 
      ** Update File
 
     C                   EVAL      WULCD = FSLCD
     C                   EVAL      FSHEDG = PHedge
     C                   EVAL      FSOPCT = WOPCT
     C                   EVAL      FSOAMT = WOAMT                                             230116
     C                   EVAL      FSDROP = #1DROP
     C                   EVAL      FSSETV = #1SETV
     C                   EVAL      FSSEMK = #1SEMK
     C                   EVAL      FSLCD = WRunDay
     C                   IF        CAS006 = 'Y'                                               CAS006
     C                   EVAL      FSCLVL = WCLVL                                             CAS006
     C                   EVAL      FSNMBU = WNMBU                                             CAS006
     C                   EVAL      FSHLTO = WHLTO                                             229418
     C                   EVAL      FSEXRL = #1EXRL                                            228948
     C                   IF        CAS007 = 'N'                                              BUG9476
     C                   EVAL      FSEXRL = #2EXRL                                           BUG9476
     C                   ENDIF                                                               BUG9476
      *                                                                                       CAS008
     C                   IF        CAS008 = 'Y'                                               CAS008
     C                   EVAL      FSNDDP = WNDDP                                             CAS008
     C                   ENDIF                                                                CAS008
      *                                                                                       CAS008
     C                   ENDIF                                                                CAS006
                                                                                              CAS009
     C                   IF        CAS009 = 'Y'                                               CAS009
     C                   IF        CAS007 = 'Y'                                               CAS009
     C                   EVAL      FSAMRM = #1AMRM                                            CAS009
     C                   ELSE                                                                 CAS009
     C                   EVAL      FSAMRM = #2AMRM                                            CAS009
     C                   ENDIF                                                                CAS009
     C                   EVAL      FSNRSV = WNRSV                                             CAS009
     C                   EVAL      FSNRNI = WNRNI                                             CAS009
     C                   EVAL      FSSB1S = WSB1S                                             CAS009
     C                   EVAL      FSSB2S = WSB2S                                             CAS009
     C                   IF        CAS007 = 'Y'                                               CAS009
     C                   EVAL      FSNDYR = #1NDAY                                            CAS009
     C                   ELSE                                                                 CAS009
     C                   EVAL      FSNDYR = #2NDAY                                            CAS009
     C                   ENDIF                                                                CAS009
     C                   ENDIF                                                                CAS009
                                                                                              CAS009
     C                   EVAL      FSCHTP = 'A'
 
     C                   UPDATE    @HEDGD0
 
      ** Only update file controls if record has not been updated already
 
     C     WULCD         IFNE      WRunDay
 
     C                   Z-ADD     *ZERO         WNumRec
     C                   Z-ADD     *ZERO         WNumIns
     C                   Z-ADD     *ZERO         WNumDel
     C                   Z-ADD     1             WNumAmd
 
     C                   EXSR      SRSDCntrl
 
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRSDCntrl - Update Standing Data Controls                    *
      *                                                               *
      *  Called by: SR/SRProcess                                      *
      *                                                               *
      *  Calls    : SRWRITE, SRRASC                                   *
      *                                                               *
      *****************************************************************
 
     C     SRSDCntrl     BEGSR
 
      ** Move key fields to @AHREAU
 
     C                   EVAL      AHFLNM = *BLANKS
     C                   EVAL      AHFLNM = 'SDICDRPD'
 
     C     AHFLNM        CHAIN     SDFCTLL0
 
      ** If not found, DB Error
 
     C                   IF        NOT %FOUND(SDFCTLL0)
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'SDFCTLPA'
     C                   EVAL      DBKEY = 'SDICDRPD'
     C                   EVAL      DBASE = 004
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ELSE
 
      ** USER: Processing after DBF read
 
     C                   ADD       AHNORC        WNumRec
     C                   ADD       AHNOIN        WNumIns
     C                   ADD       AHNOAM        WNumAmd
     C                   ADD       AHNODL        WNumDel
 
      ** Move non-key fields to @AHREAU
 
     C                   Z-ADD     WNumRec       AHNORC
     C                   Z-ADD     WNumIns       AHNOIN
     C                   Z-ADD     WNumAmd       AHNOAM
     C                   Z-ADD     WNumDel       AHNODL
 
     C                   UPDATE    @AHREAU
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRSndErr - Send Error Message                                *
      *                                                               *
      *  Called by: SRProcess, SRValid, SRUpdate                      *
      *                                                               *
      *  Calls    : None                                              *
      *                                                               *
      *****************************************************************
 
     C     SRSndErr      BEGSR
 
     C                   CALL      'ZA0340'
     C                   PARM                    PMsgFile
     C                   PARM                    PMsgID
 
     C                   ENDSR
 
      *****************************************************************                       232348
      /EJECT                                                                                  232348
      *****************************************************************                       232348
      *  SrZDate1 - Validate and convert date to day number           *                       232348
      *****************************************************************                       232348
     C     SrZDate1      BEGSR                                                                232348
                                                                                              232348
     C                   CALLB     'ZDATE1'                                                   232348
     C                   PARM                    PDateIn                                      232348
     C                   PARM      *ZEROS        PDayNoOut                                    232348
     C                   PARM                    BJDFIN                                       232348
     C                   PARM      'N'           PErrorFlag                                   232348
                                                                                              232348
     C                   ENDSR                                                                232348
      *****************************************************************                       232348
      /EJECT                                                                                  232348
      *****************************************************************                       232348
      *  SrZDate2 - Convert day number to date                        *                       232348
      *****************************************************************                       232348
     C     SrZDate2      BEGSR                                                                232348
                                                                                              232348
     C                   CALLB     'ZDATE2'                                                   232348
     C                   PARM                    PDayNoIn                                     232348
     C                   PARM                    BJDFIN                                       232348
     C                   PARM      *ZERO         PDateOut                                     232348
     C                   PARM      *BLANK        PADate                                       232348
                                                                                              232348
     C                   ENDSR                                                                232348
      *****************************************************************                       232348
      /EJECT                                                                                  232348
      *****************************************************************                       232348
      *  SrAlign2 - Convert day number to date                        *                       232348
      *****************************************************************                       232348
     C     SrAlign2      BEGSR                                                                232348
                                                                                              232348
     C                   CALLB     'ZALIGN2'                                                  232348
     C                   PARM      *BLANKS       PALIGNOK                                     232348
     C                   PARM                    PZFIELD                                      232348
     C                   PARM                    PZADEC2                                      232348
     C                   PARM                    PZADIG                                       232348
                                                                                              232348
     C                   ENDSR                                                                232348
      **********************************************************************
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
     C                   PARM                    PHedge
     C                   PARM                    PMode
 
      ** The following /COPY sets the program, module and procedure
      ** names for database error processing.
 
     C/COPY ZACPYSRC,DBFIELDS
 
      ** Access bank details
 
     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANKS       PRetCode
     C                   PARM      '*FIRST '     POption
     C     SDBANK        PARM      SDBANK        DSSDY
 
      ** Database error
 
     C     PRetCode      IFNE      *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBASE = 001
     C                   EVAL      DBFile = 'SDBANKPD'
     C                   EVAL      DBKEY = '*FIRST'
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Call Access Program for Midas Modules
 
     C                   CALLB     'AOMMODR0'
     C                   PARM      *BLANKS       PRetCode
     C                   PARM      '*FIRST '     POption
     C     SDMMOD        PARM      SDMMOD        DSFDY
 
     C                   IF        PRetCode <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'SDMMODPD'
     C                   EVAL      DBKEY = POption
     C                   EVAL      DBASE = 002
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Securities Trading Module is present
 
     C                   IF        BGSECS = 'Y'
     C                   EVAL      WSeTrInd = 'Y'
     C                   EVAL      *IN36 = *OFF
 
      ** Access Securities Trading ICD
 
     C                   CALL      'AOSTRDR0'
     C                   PARM      *BLANKS       PRetCode
     C                   PARM      '*FIRST '     POption
     C     SDSTRD        PARM      SDSTRD        DSSDY
 
     C                   IF        PRetCode <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'SDSTRDPD'
     C                   EVAL      DBKEY = POption
     C                   EVAL      DBASE = 003
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   ELSE
     C                   EVAL      WSeTrInd = 'N'
     C                   EVAL      *IN36 = *ON
     C                   ENDIF
 
      ** Move Workstation ID to screen field
 
     C                   EVAL      #0RUNA = BJMRDT
     C                   EVAL      #0USER = PSUser
     C                   EVAL      #0WSID = PSJobName
     C                   EVAL      #0PGMQ = PSProcMod
 
     C                   EVAL      WRunDay = BJRDNB
 
      ** Initialise Work Fields
 
     C                   EVAL      WError = 'Y'
     C                   EVAL      WField = *BLANKS
     C                   EVAL      WULCD = *ZEROS
     C                   EVAL      WNumRec = *ZEROS
     C                   EVAL      WNumIns = *ZEROS
     C                   EVAL      WNumDel = *ZEROS
     C                   EVAL      WNumAMd = *ZEROS
 
     C                   IF        PMode = 'E'
     C                   EVAL      *IN31 = *ON
     C                   ELSE
     C                   EVAL      *IN31 = *OFF
     C                   ENDIF
 
     C                   EVAL      *IN32 = *OFF
     C                   EVAL      *IN33 = *OFF
     C                   EVAL      *IN34 = *OFF
     C                   EVAL      *IN35 = *OFF
     C                   EVAL      *IN37 = *OFF                                               CAS006
     C                   EVAL      *IN39 = *OFF                                               CAS006
     C                   EVAL      *IN42 = *OFF                                               229418
     C                   EVAL      *IN43 = *OFF                                               228948
 
      ** Initialise detail screen
 
     C                   MOVE      *BLANKS       #1OPCT
     C                   MOVE      *BLANKS       #1OAMT                                       230116
     C                   Z-ADD     *ZEROS        #1DROP
     C                   MOVE      *BLANKS       #1SETV
     C                   MOVE      *BLANKS       #1SEMK
     C                   MOVE      *BLANKS       #1CLVL                                       CAS006
     C                   IF        CAS007 = 'Y'                                               CAS007
     C                   MOVE      *BLANKS       #1NMBU                                       CAS006
     C                   ELSE                                                                 CAS007
     C                   MOVE      *BLANKS       #2NMBU                                       CAS007
     C                   ENDIF                                                                CAS007
     C                   MOVE      *BLANKS       #1HLTO                                       229418
     C                   MOVE      *BLANKS       #1NDDP                                       CAS008
 
      ** Check if CAS006 is installed                                                         CAS006
                                                                                              CAS006
     C                   EVAL      CAS006 = 'N'                                               CAS006
     C                   CALLB     'AOSARDR0'                                                 CAS006
     C                   PARM      *BLANKS       PRetCode                                     CAS006
     C                   PARM      '*VERIFY'     POption                                      CAS006
     C                   PARM      'CAS006'      PSard                                        CAS006
     C     SCSARD        PARM      SCSARD        DSFDY                                        CAS006
                                                                                              CAS006
      ** Database error                                                                       CAS006
                                                                                              CAS006
     C                   IF        (PRetCode <> *BLANKS) and                                  CAS006
     C                             (PRetCode <> '*NRF   ')                                    CAS006
     C                   EVAL      DBKEY = 'CAS006'                                           CAS006
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CAS006
     C                   EVAL      DBASE = 4                                                  CAS006
     C                   EXSR      *PSSR                                                      CAS006
     C                   ENDIF                                                                CAS006
                                                                                              CAS006
     C                   IF        PRetCode = *BLANKS                                         CAS006
     C                   EVAL      CAS006 = 'Y'                                               CAS006
     C                   EVAL      *IN38 = *ON                                                CAS006
     C                   ENDIF                                                                CAS006
                                                                                              CAS006
      ** Check if CAS007 is installed                                                         CAS007
                                                                                              CAS007
     C                   EVAL      CAS007 = 'N'                                               CAS007
     C                   CALLB     'AOSARDR0'                                                 CAS007
     C                   PARM      *BLANKS       PRetCode                                     CAS007
     C                   PARM      '*VERIFY'     POption                                      CAS007
     C                   PARM      'CAS007'      PSard                                        CAS007
     C     SCSARD        PARM      SCSARD        DSFDY                                        CAS007
                                                                                              CAS007
      ** Database error                                                                       CAS007
                                                                                              CAS007
     C                   IF        (PRetCode <> *BLANKS) and                                  CAS007
     C                             (PRetCode <> '*NRF   ')                                    CAS007
     C                   EVAL      DBKEY = 'CAS007'                                           CAS007
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CAS007
     C                   EVAL      DBASE = 5                                                  CAS007
     C                   EXSR      *PSSR                                                      CAS007
     C                   ENDIF                                                                CAS007
                                                                                              CAS007
     C                   IF        PRetCode = *BLANKS                                         CAS007
     C                   EVAL      CAS007 = 'Y'                                               CAS007
     C                   ENDIF                                                                CAS007
                                                                                              CAS008
      ** Check if CAS008 is installed                                                         CAS008
                                                                                              CAS008
     C                   EVAL      CAS008 = 'N'                                               CAS008
     C                   CALLB     'AOSARDR0'                                                 CAS008
     C                   PARM      *BLANKS       PRetCode                                     CAS008
     C                   PARM      '*VERIFY'     POption                                      CAS008
     C                   PARM      'CAS008'      PSard                                        CAS008
     C     SCSARD        PARM      SCSARD        DSFDY                                        CAS008
                                                                                              CAS008
      ** Database error                                                                       CAS008
                                                                                              CAS008
     C                   IF        (PRetCode <> *BLANKS) and                                  CAS008
     C                             (PRetCode <> '*NRF   ')                                    CAS008
     C                   EVAL      DBKEY = 'CAS008'                                           CAS008
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CAS008
     C                   EVAL      DBASE = 6                                                  CAS008
     C                   EXSR      *PSSR                                                      CAS008
     C                   ENDIF                                                                CAS008
                                                                                              CAS008
     C                   IF        PRetCode = *BLANKS                                         CAS008
     C                             AND CAS007 = 'Y'                                           CAS008
     C                   MOVE      'Y'           CAS008            1                          CAS008
     C                   EVAL      *IN41 = *ON                                                CAS008
     C                   ENDIF                                                                CAS008
                                                                                              CAS007
      ** Check if CAS009 is installed                                                         CAS009
                                                                                              CAS009
     C                   EVAL      CAS009 = 'N'                                               CAS009
     C                   CALLB     'AOSARDR0'                                                 CAS009
     C                   PARM      *BLANKS       PRetCode                                     CAS009
     C                   PARM      '*VERIFY'     POption                                      CAS009
     C                   PARM      'CAS009'      PSard                                        CAS009
     C     SCSARD        PARM      SCSARD        DSFDY                                        CAS009
                                                                                              CAS009
      ** Database error                                                                       CAS009
                                                                                              CAS009
     C                   IF        PRetCode <> *BLANKS AND                                    CAS009
     C                             PRetCode <> '*NRF   '                                      CAS009
     C                   EVAL      DBKEY = 'CAS009'                                           CAS009
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CAS009
     C                   EVAL      DBASE = 6                                                  CAS009
     C                   EXSR      *PSSR                                                      CAS009
     C                   ENDIF                                                                CAS009
                                                                                              CAS009
     C                   IF        PRetCode = *BLANKS                                         CAS009
     C                   EVAL      CAS009 = 'Y'                                               CAS009
     C                   EVAL      *IN50 = *ON                                                CAS009
     C                   ENDIF                                                                CAS009
                                                                                              CAS009
      ** If CAS009 is switched on, determine if related initialisation                        232348
      ** programs have run already.                                                           232348
                                                                                              232348
     C     KSARP         KLIST                                                                232348
     C                   KFLD                    KSARN                                        232348
     C                   KFLD                    KPNAM                                        232348
                                                                                              232348
     C                   EVAL      *IN51 = *OFF                                               232348
     C                   EVAL      WC9InitFlag = 'N'                                          232348
     C                   IF        CAS009 = 'Y'                                               232348
                                                                                              232348
      ** Check initialisation for LEC000017                                                   232348
     C                   EVAL      KSARN = 'CAS009'                                           232348
     C                   EVAL      KPNAM = 'LEC000017'                                        232348
     C     KSARP         CHAIN     SCSARPL1                                                   232348
                                                                                              232348
     C                   IF        %FOUND(SCSARPL1)                                           232348
     C                   EVAL      WC9InitFlag = AKPRVC                                       232348
     C                   ELSE                                                                 232348
     C     *LOCK         IN        LDA                                                        232348
     C                   EVAL      DBASE = 10                                                 232348
     C                   EVAL      DBFile = 'SCSARPL1'                                        232348
     C                   EVAL      DBKEY = KSARN + KPNAM                                      232348
     C                   OUT       LDA                                                        232348
     C                   EXSR      *PSSR                                                      232348
     C                   ENDIF                                                                232348
                                                                                              232348
      ** Check initialisation for DLC000019                                                   232348
     C                   IF        WC9InitFlag <> 'Y'                                         232348
     C                   EVAL      KPNAM = 'DLC000019'                                        232348
     C     KSARP         CHAIN     SCSARPL1                                                   232348
                                                                                              232348
     C                   IF        %FOUND(SCSARPL1)                                           232348
     C                   EVAL      WC9InitFlag = AKPRVC                                       232348
     C                   ELSE                                                                 232348
     C     *LOCK         IN        LDA                                                        232348
     C                   EVAL      DBASE = 11                                                 232348
     C                   EVAL      DBFile = 'SCSARPL1'                                        232348
     C                   EVAL      DBKEY = KSARN + KPNAM                                      232348
     C                   OUT       LDA                                                        232348
     C                   EXSR      *PSSR                                                      232348
     C                   ENDIF                                                                232348
     C                   ENDIF                                                                232348
                                                                                              232348
      ** Protect non-linear amortisation cut-off date if CAS009                               232348
      ** related initialisation programs have already run.                                    232348
     C                   IF        WC9InitFlag = 'Y'                                          232348
     C                   EVAL      *IN51 = *ON                                                232348
     C                   ENDIF                                                                232348
     C                   ENDIF                                                                232348
                                                                                              232348
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *PSSR - Program exception error routine                      *
      *          Called automatically if a program error occurs,      *
      *          or directly by the program code using EXSR.          *
      *          This subroutine DUMPs the program just once.         *
      *                                                               *
      *****************************************************************
 
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
