     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*OVR *: OVRDBF FILE(SDCUSTLR) TOFILE(SDCUSTL0) SHARE(*NO)          : *
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD Customer details browse')                     *
      *****************************************************************
      *                                                               *
      *  Midas - Customer Details Module                              *
      *                                                               *
      *  SDCUSDBRW - CUSTOMER DETAILS BROWSE                          *
      *                                                               *
      *  Function:  This module runs in two modes:                    *
      *             One display a list of custom.for selection,       *
      *             the other picks off the selection made.           *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      *  Last Amend No. CER059             Date 19Jul10               *
      *  Prev Amend No. BUG23518           Date 30Mar09               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 256564             Date 17Sep08               *
      *                 249076             Date 03Aug07               *
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 BUG11934           Date 21Aug06               *
      *                 BUG11896           Date 14Aug06               *
      *                 BUG11828           Date 13Aug06               *
      *                 BUG11895           Date 12Aug06               *
      *                 BUG11861           Date 10Aug06               *
      *                 BUG11711           Date 17Jul06               *
      *                 CSD031             Date 10Apr06               *
      *                 CSD027             Date 05Jan06               *
      *                 BUG8169            Date 06Sep05               *
      *                 CSD025A            Date 27Apr05               *
      *                 CSW037A            Date 02May05               *
      *                 BUG6198            Date 04Apr05               *
      *                 CSD025             Date 11Jan05               *
      *                 CSW037             Date 15Dec04               *
      *                 CSW036             Date 15Dec04               *
      *                 CLE025             Date 20Oct03               *
      *                 213909             Date 05Feb03               *
      *                 CSD018             Date 27Nov02               *
      * Midas Release 4.01.03 ----------------------------------------*
      * Midas Release 4.01 -------------------------------------------*
      *                 191530             Date 05Jun01               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.04 -----------------------------------------------*
      *                 CSD007             Date 28Aug00               *
      * Midas DBA 3.02 -----------------------------------------------*
      *                 CAP034  *CREATE    Date 05May99               *
      *                                                               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  BUG23518 - Produce Annual Tax Deducted Statement upon        *
      *             Customer Closure                                  *
      *  256564 - Recompile due to PF changes done by fix 256330      *
      *  249076 - Enhance error message S270004 to show character     *
      *           and position that is not allowed in SDSVALPD.       *
      *  BUG11934 - Screen did not move when pressing F8              *
      *  BUG11896 - White field in the list view/acceptance list      *
      *             (Recompile)                                       *
      *  BUG11828 - If CSD031 is on, System Values are defined        *
      *             centrally.                                        *
      *  BUG11895 - Status field is displayed in acceptance list      *
      *             view (Recompile)                                  *
      *  BUG11861 - DB error when accepting customer                  *
      *  BUG11711 - White fields indicated in list view (Recompile)   *
      *  CSD031 - Enhanced Centralised Static Data                    *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  BUG8169 - Option/Action code field should be validated       *
      *            accordingly.                                       *
      *  CSD025A- Inactive status                                     *
      *  CSW037A- Additional Field extended to 40 chars (recompile)   *
      *  BUG6198- Cannot save new Details for CUSD (Recompile)        *
      *  CSD025 - Customer De-Activation                              *
      *  CSW037 - Additional Field Data on MT300/MT320                *
      *  CSW036 - Dual SWIFT BIC held on Client Details               *
      *  CLE025 - Credit Lines                                        *
      *  213909 - Selection at the customer details screen comes back *
      *           at the beginning. Do not blank out the customer     *
      *           field to retain the subfile position at the         *
      *           selected customer.                                  *
      *  CSD018 - Restrict Access to Customers By Branch.             *
      *  191530 - SDCUSDSIN - Unable to send msg RE7105B.  Need to    *
      *           recompile pgm to pick up changes made in cpysrc     *
      *           MSGHNDDATA.                                         *
      *  CSD007 - Customer Closing: new Closure Status fields         *
      *  CAP034 - Conversion of SD inputs into modular structure to   *
      *           use as APIs.                                        *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
     FSDCUSDBDF CF   E             WORKSTN
     F                                     SFILE(SDCUSDS1:@@RRN)
     F                                     SFILE(SDCUSDS3:@@RRN)
     F                                     SFILE(SDCUSDS5:@@RRN)
      * Customer file - by Customer Number
     FSDCUSTLR  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(@BBREBG:CUSDNUM)
 
      * Customer file - by Front Office Id.
     FSDCUSDL0  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(SDCUSTD0:CUSDSFO)
 
      * Customer file - by Customer Shortname
     F***SDCUSTL2  IF   E           K DISK    INFSR(*PSSR)
     F***********                          RENAME(@CUSTD5:CUSDSSN)
     FSDCUSTL6  IF   E           K DISK    INFSR(*PSSR)                                       CSD007
     F                                     RENAME(@CUSTF3:CUSDSSN)                            CSD007
 
     **  Valid Booking Branches by User.                                                      CSD018
     FMBRBS     IF   E           K DISK    INFSR(*PSSR)                                       CSD018
 
      ** Table of field numbers and names
     FZAFLDNPD  IT   F   15        DISK    INFSR(*pssr)
 
      ** Customer Details Acceptance - by Customer Number                                     CSD031
     F***SDACSTL1  IF   E           K DISK    INFSR(*PSSR) USROPN                    CSD031 BUG11861
     FSDACSTL1  IF   E           K DISK    INFSR(*PSSR)                                     BUG11861
     F                                     RENAME(SDCUSTD0:SDACSTD1)                          CSD031
                                                                                              CSD031
      ** Customer Details Acceptance - by Front Office ID                                     CSD031
     F***SDACSTL4  IF   E           K DISK    INFSR(*PSSR) USROPN                    CSD031 BUG11861
     FSDACSTL4  IF   E           K DISK    INFSR(*PSSR)                                     BUG11861
     F                                     RENAME(SDCUSTD0:SDACSTD4)                          CSD031
                                                                                              CSD031
      ** Customer Details Acceptance - by Customer Shortname                                  CSD031
     F***SDACSTL3  IF   E           K DISK    INFSR(*PSSR) USROPN                    CSD031 BUG11861
     FSDACSTL3  IF   E           K DISK    INFSR(*PSSR)                                     BUG11861
     F                                     RENAME(SDCUSTD0:SDACSTD3)                          CSD031
                                                                                              CSD031
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      **
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
      ** Program Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
      **--------------------------------------------------------------------------------------------
      *
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
 
     D*@FTR*****       S             30    DIM(3) CTDATA PERRCD(1)                          BUG23518
     D @FTR            S             79    DIM(6) CTDATA PERRCD(1)                          BUG23518
 
     D WWVBRX          S              3    DIM(900) ASCEND                                    CSD018
                                                                                              CSD018
      ** EXTERNAL DS FOR BANK DETAILS
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
 
      ** Customer Details                                                                     CSD018
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)                                  CSD018
                                                                                              CSD018
      ** External DS for SAR Details                                                          CSD007
     D SCSARD        E DS                  EXTNAME(SCSARDPD)                                  CSD007
                                                                                              CSD007
      ** FIRST DS FOR ACCESS PROGRAMS, SHORT DATA STRUCTURE
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      **  Long DS for access programs
     D DSSDY         E DS                  EXTNAME(DSSDY)
 
      **  Third DS for access programs, very long data structure                              CSD018
     D DSLDY         E DS                  EXTNAME(DSLDY)                                     CSD018
                                                                                              CSD018
     D/COPY WNCPYSRC,SDCUSDBD01
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
                                                                                              CLE025
     D PMode           S              1                                                       CLE025
     D WAccMde         S              1                                                       CSD031
     D WEffDte         S              6                                                       CSD031
     D WAction         S              6                                                       CSD031
     D CSD037          S              1                                                       CSD031
      *
      ** Parameters for calling AOSVALR0 (Midas System Value Access Object)                   CSD027
     D PRetCode        S              7A                                                      CSD027
     D PSysValK1       S             20A                                                      CSD027
     D PSysVal1        S            200A                                                      CSD027
     D PSysValK2       S             20A                                                      CSD027
     D PSysVal2        S            200A                                                      CSD027
     D PSysValK3       S             20A                                                      CSD027
     D PSysVal3        S            200A                                                      CSD027
     D PSysValK4       S             20A                                                      CSD027
     D PSysVal4        S            200A                                                      CSD027
     D PSysValK5       S             20A                                                      CSD027
     D PSysVal5        S            200A                                                      CSD027
     D PSysValK6       S             20A                                                      CSD027
     D PSysVal6        S            200A                                                      CSD027
     D PSysValK7       S             20A                                                      CSD027
     D PSysVal7        S            200A                                                      CSD027
     D PSysValK8       S             20A                                                      CSD027
     D PSysVal8        S            200A                                                      CSD027
     D PSysValK9       S             20A                                                      CSD027
     D PSysVal9        S            200A                                                      CSD027
     D PSysValK10      S             20A                                                      CSD027
     D PSysVal10       S            200A                                                      CSD027
      *                                                                                       CSD027
      * For holding the system values                                                         CSD027
     DWCusAlphaAllow   S            200A                                                      CSD027
     DWCusAlphaSupNum  S            200A                                                      CSD027
      *                                                                                       CSD027
      ** Parameters for calling SDCUSTISO (Validate Customer Number)                          CSD027
     D PCust           S              6A                                                      CSD027
     D PValid          S              6A                                                      CSD027
     D PCheckDigit     S              1A                                                      CSD027
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
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
      *
      ** Set up the customer reference to be used by the message handler
     C                   EVAL      TranRef = DDCUSN
     C                   EVAL      ActionCode = DDACTN
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes processing for the error and
      ** warning messages.
     D/COPY ZACPYSRC,MSGHNDDSP1
      **--------------------------------------------------------------------------------------------
 
      ** Initialization
      *
     C                   EXSR      INIT
      *
      ** Build Sub-file
      *
     C     @BDSFL        IFEQ      'Y'
      *
      **  If First time in or subfile by Midas trade number was previously
      **  being run, then build subfile keyed on Midas trade number.
      **  Stay in loop while F11 toggle key is used.
      *
     C     WCUST         IFNE      'F'
     C     WCUST         ANDNE     'S'
     C                   MOVE      'B'           WCUST
      *
     C                   ENDIF
      *
     C     *INKK         DOUEQ     '0'
      *
      ** On F11, initialize position/select fields
      *
     C     *INKK         IFEQ      '1'
      *
     C                   MOVE      *BLANK        SECUST
     C                   MOVE      *BLANK        SEFODN
     C                   MOVE      *BLANK        SECSSN
     C                   MOVE      *BLANK        SECRNM
     C                   MOVE      *BLANK        SECRTN
     C                   MOVE      *BLANK        SECLST                                       CSD007
     C                   MOVE      *BLANK        SECGDT                                       CSD031
     C                   MOVE      *BLANK        SECEAC                                       CSD031
     C                   MOVE      *BLANK        SECACT                                       CSD031
      *
      * Clear program message queue
     C                   CALL      'ZA0250'
      *
     C                   ENDIF
      *
     C     WCUST         CASEQ     'B'           BLDSFL
     C     WCUST         CASEQ     'F'           BLDSFL2
     C     WCUST         CASEQ     'S'           BLDSFL3
     C                   ENDCS
     C                   ENDDO
      *
     C                   ENDIF
      *
      ** Read Subfile Record
      *
     C     @RDSFL        IFEQ      'Y'
     C                   EXSR      RDSFLR
     C                   END
      *
      ** Close Acceptance files if CSD031 is on                                               CSD031
      *                                                                                       CSD031
     C**********         IF        CSD037 = 'Y'                                      CSD031 BUG11861
     C**********         CLOSE     SDACSTL1                                          CSD031 BUG11861
     C**********         CLOSE     SDACSTL3                                          CSD031 BUG11861
     C**********         CLOSE     SDACSTL4                                          CSD031 BUG11861
     C**********         ENDIF                                                       CSD031 BUG11861
      *
     C                   RETURN
      *
      *****************************************************************
      /EJECT
      ********************************************************************
      * BLDSFL - BUILD SUBFILE
      ********************************************************************
     C     BLDSFL        BEGSR
      *
      ** Check for user Authority to Browse IF NOT MULTI-BRANCHING
      *
     C     BJSBRC        IFNE      *BLANK
     C                   EXSR      CHAUTN
     C                   END
      *
      * Validate Custo Ref (FOR POINTER)
      *
     C                   EXSR      VALCUST
      *
      **  Initialise subfile relative record number.
      *
     C                   Z-ADD     0             @@RRN             5 0
      *
      **  Clear subfile before refilling by writing control record
      **  with SFLCLR active.
      *
     C                   MOVE      '1'           *IN97
     C                   WRITE     SDCUSDS0
     C                   MOVE      '0'           *IN97
      *
      **  Set file pointer on key displayed on screen.
      *
     C                   IF        CSD037 = 'Y' AND                                           CSD031
     C                             WAccMde = 'A'                                              CSD031
     C     @@CUST        SETLL     SDACSTL1                                                   CSD031
      *                                                                                       CSD031
     C     SECUST        IFNE      *BLANK                                                     CSD031
     C     SECUST        SETLL     SDACSTL1                                                   CSD031
     C                   ENDIF                                                                CSD031
     C                   ELSE                                                                 CSD031
     C     @@CUST        SETLL     CUSDNUM
      *
     C     SECUST        IFNE      *BLANK                                                     213909
     C     SECUST        SETLL     CUSDNUM                                                    213909
     C                   ENDIF                                                                213909
      *                                                                                       213909
     C                   ENDIF                                                                CSD031
      *                                                                                       CSD031
      **  Read a Valid Customer
      *
     C                   EXSR      RDCUST
      *
      **  set up message 'no data to display'
      *
     C                   MOVE      *OFF          *IN80
     C     @@EOF         IFEQ      'Y'
     C                   MOVE      *ON           *IN80
     C                   END
      *
      **  Set on ROLLUP indicator to drive initial loop.
      *
     C                   MOVE      '1'           *IN98
      *
      **  Read records from the file into the subfile until a page has
      **  been filled or there are no more records.
      **  Repeat the process until either the end of file, ROLLUP
      **  has not been entered or F3 or F12 is input.
      *
     C     *IN98         DOWEQ     '1'
      *
      **  Initialise count of records written to subfile page.
      *
     C                   Z-ADD     0             @@CNT             3 0
      *
      **  For each record read, write it to the subfile.
      **  Do this until end of file or the subfile page is full.
      *
     C     @@EOF         DOWNE     'Y'
     C     @@CNT         ANDLT     14
     C/COPY WNCPYSRC,SDCUSDBC01
      *
      **  Increment the subfile record no. and records written fields.
      *
     C                   ADD       1             @@RRN
     C                   ADD       1             @@CNT
      *
      **  Format customer fields for output
      *
     C                   EXSR      FMTCUS
      *
      **  Write the customer to the subfile.
      *
      **  If action code or customer number selected is invalid
      **  the subfile postions on the error record and rebuilds
      *
     C                   MOVE      *OFF          *IN92
     C                   MOVE      *OFF          *IN95                                        CSD031
     C     @@RRN         IFNE      1
     C                   MOVE      *BLANK        DDOPT
     C                   ELSE
     C     'DDACTN    '  LOOKUP    FldNameArr                             99
     C     'DDCUSN    '  LOOKUP    FldNameArr                             98
     C     *IN99         IFNE      '1'
     C     *IN98         ANDNE     '1'
     C                   MOVE      *BLANK        DDOPT
     C                   ELSE
     C                   MOVE      *ON           *IN92
     C                   ENDIF
     C                   ENDIF
      *
     C                   Z-ADD     @@RRN         DDSFRN
     C                   WRITE     SDCUSDS1
     C/COPY WNCPYSRC,SDCUSDBC02
      *
      **  Read a valid Customer
      *
     C                   EXSR      RDCUST
     C                   END
      *
      **  Set up footer toggle text and write the footer
      *
     C                   IF        PMode = 'E'                                              BUG23518
     C                   EVAL      TOGLTEXT = @FTR(4)                                       BUG23518
     C                   EVAL      *IN72 = *ON                                              BUG23518
     C                   ELSE                                                               BUG23518
     C                   MOVE      @FTR(1)       TOGLTEXT
     C                   EVAL      *IN72 = *OFF                                             BUG23518
     C                   ENDIF                                                              BUG23518
      *                                                                                     BUG23518
     C                   WRITE     SDCUSDF1
      *
      **  Write the message subfile
      *
     C                   WRITE     SDCUSDM0
      *
      **  If there is no data to display, set on SFLCLR condition and
      **  write the subfile control record
      *
     C     @@CNT         IFEQ      0
     C                   MOVE      '1'           *IN97
     C                   WRITE     SDCUSDS0
     c                   MOVE      '0'           *IN97
     C                   Z-ADD     1             @@RRN
     C                   Z-ADD     1             DDSFRN
      *
      **  write to the subfile with non-display set on
      *
     c                   MOVE      '1'           *IN93
     C                   WRITE     SDCUSDS1
     c                   MOVE      '0'           *IN93
     C                   WRITE     SDCUSDS0
     c                   ELSE
      *
      **  Write the subfile control record to the screen to display
      **  the subfile.
      *
     C                   WRITE     SDCUSDS0
     c                   ENDIF
      *
      **  Read the subfile control record to determine whether records
      **  have been selected or whether ROLLUP is required.
      *
     C                   READ      SDCUSDS0                               99
      *
      ** Clear any messages before processing user input
      *
     C                   MOVEL     *BLANK        FldNameArr
     C                   MOVEL     *BLANK        MsgIdArr
     C                   MOVEL     *BLANK        MsgDtaArr
      *
      **  If F3, bypass further processing.
     C     *INKC         IFEQ      '1'
     C                   MOVEL     '1'           @INKC
     C                   SETON                                        LR
     C                   RETURN
     C                   END
      *
      **  If F9, bypass further processing.
     C     *INKI         IFEQ      '1'
     C                   MOVEL     'I'           @OPSEL
     C                   SETON                                        LR
     C                   RETURN
     C                   END
      *
     C                   END
      *
      * Set indicator ans flag for Midas Front Office I.D. browse key   used
      *
     C     *INKK         IFEQ      '1'
     C                   MOVE      'F'           WCUST             1
     C                   END
      *
      **  If F13, Acceptance screen processing.                                               CSD031
      *                                                                                       CSD031
     C                   IF        *INKM = *ON AND                                            CSD031
     C                             CSD037 = 'Y'                                               CSD031
     C                   EXSR      SRACCP                                                     CSD031
     C                   ENDIF                                                                CSD031
      *                                                                                       CSD031
     C                   ENDSR
      ********************************************************************
      /EJECT
      ********************************************************************
      * BLDSFL2 - BUILD SUBFILE by FRONT OFFICE ID.
      ********************************************************************
 
     C     BLDSFL2       BEGSR
      *
      ** Check for user Authority to Browse IF NOT MULTI-BRANCHING
      *
     C     BJSBRC        IFNE      *BLANK
     C                   EXSR      CHAUTN
     C                   END
      *
      * Validate Customer N(FOR POINTER)
      *
     C                   EXSR      VALCUST
      *
      **  Get Front Office Custo Ref.
      *
     C                   IF        CSD037 = 'Y' AND                                           CSD031
     C                             WAccMde = 'A'                                              CSD031
     C     @@CUST        CHAIN     SDACSTL1                           89                      CSD031
     C                   ELSE                                                                 CSD031
     C     @@CUST        CHAIN     CUSDNUM                            89
     C                   ENDIF                                                                CSD031
     C                   MOVE      BBFRNT        @@FOTD           20
     C     *IN89         IFEQ      '1'
     C                   MOVE      *BLANK        @@FOTD
     C                   END
      *
      **  Initialise subfile relative record number.
      *
     C                   Z-ADD     0             @@RRN
      *
      **  Clear subfile before refilling by writing control record
      **  with SFLCLR active.
      *
     C                   MOVE      '1'           *IN97
     C                   WRITE     SDCUSDS2
     C                   MOVE      '0'           *IN97
      *
      **  Set file pointer on key displayed on screen.
      *
     C                   IF        CSD037 = 'Y' AND                                           CSD031
     C                             WAccMde = 'A'                                              CSD031
     C     @@FOTD        SETLL     SDACSTL4                                                   CSD031
      *                                                                                       CSD031
     C     SEFODN        IFNE      *BLANK                                                     CSD031
     C     SEFODN        SETLL     SDACSTL4                                                   CSD031
     C                   ENDIF                                                                CSD031
     C                   ELSE                                                                 CSD031
     C     @@FOTD        IFNE      *BLANKS                                                    CSD027
     C     @@FOTD        SETLL     CUSDSFO
     C                   ELSE                                                                 CSD027
     C     @@CUST        SETLL     CUSDNUM                                                    CSD027
     C                   END                                                                  CSD027
      *
     C     SEFODN        IFNE      *BLANK                                                     213909
     C     SEFODN        SETLL     CUSDSFO                                                    213909
     C                   ENDIF                                                                213909
      *                                                                                       213909
     C                   ENDIF                                                                CSD031
      *                                                                                       CSD031
      ** Read a Valid Trade
      *
     C                   EXSR      RDCUST
      *
      **  set up message 'no data to display'
      *
     C                   MOVE      *OFF          *IN80
     C     @@EOF         IFEQ      'Y'
     C                   MOVE      *ON           *IN80
     C                   END
      *
      **  Set on ROLLUP indicator to drive initial loop.
      *
     C                   MOVE      '1'           *IN98
      *
      **  Read records from the file into the subfile until a page has
      **  been filled or there are no more records.
      **  Repeat the process until either the end of file, ROLLUP
      **  has not been entered or F3 or F12 is input.
      *
     C     *IN98         DOWEQ     '1'
      *
      **  Initialise count of records written to subfile page.
      *
     C                   Z-ADD     0             @@CNT
      *
      **  For each record read, write it to the subfile.
      **  Do this until end of file or the subfile page is full.
      *
     C     @@EOF         DOWNE     'Y'
     C     @@CNT         ANDLT     14
      *
      **  Increment the subfile record no. and records written fields.
      *
     C                   ADD       1             @@RRN
     C                   ADD       1             @@CNT
      *
      ** Format custo fields for output
      *
     C                   EXSR      FMTCUS
      *
      **  Write the customer to the subfile.
      *
      **  If action code or customer number selected is invalid,
      **  the subfile postions on the error record and rebuilds
      *
     C                   MOVE      *OFF          *IN92
     C                   MOVE      *OFF          *IN95                                        CSD031
     C     @@RRN         IFNE      1
     C                   MOVE      *BLANK        DDOPT
     C                   ELSE
     C     'DDACTN    '  LOOKUP    FldNameArr                             99
     C     'DDCUSN    '  LOOKUP    FldNameArr                             98
     C     *IN99         IFNE      '1'
     C     *IN98         ANDNE     '1'
     C                   MOVE      *BLANK        DDOPT
     C                   ELSE
     C                   MOVE      *ON           *IN92
     C                   MOVE      *ON           *IN95                                        CSD031
     C                   ENDIF
     C                   ENDIF
      *
     C                   Z-ADD     @@RRN         DDSFRN
     C                   WRITE     SDCUSDS3
      *
      ** Read a valid Customer
      *
     C                   EXSR      RDCUST
     C                   END
      *
      **  Set up footer toggle text and write the footer
      *
     C                   IF        PMode = 'E'                                              BUG23518
     C                   EVAL      TOGLTEXT = @FTR(5)                                       BUG23518
     C                   EVAL      *IN72 = *ON                                              BUG23518
     C                   ELSE                                                               BUG23518
     C                   MOVE      @FTR(2)       TOGLTEXT
     C                   EVAL      *IN72 = *OFF                                             BUG23518
     C                   ENDIF                                                              BUG23518
      *                                                                                     BUG23518
     C                   WRITE     SDCUSDF1
      *
      **  Write the message subfile
      *
     C                   WRITE     SDCUSDM0
      *
      **  If there is no data to display, set on SFLCLR condition and
      **  write the subfile control record
      *
     C     @@CNT         IFEQ      0
     c                   MOVE      '1'           *IN97
     C                   WRITE     SDCUSDS2
     c                   MOVE      '0'           *IN97
     C                   Z-ADD     1             @@RRN
     C                   Z-ADD     1             DDSFRN
      *
      **  write to the subfile with non-display set on
      *
     C                   MOVE      '1'           *IN93
     C                   WRITE     SDCUSDS3
     C                   MOVE      '0'           *IN93
     C                   WRITE     SDCUSDS2
     C                   ELSE
      *
      **  Write the subfile control record to the screen to display
      **  the subfile.
      *
     C                   WRITE     SDCUSDS2
     C                   ENDIF
      *
      **  Read the subfile control record to determine whether records
      **  have been selected or whether ROLLUP is required.
      *
     C                   READ      SDCUSDS2                               99
      *
      ** Clear any messages before processing user input
      *
     C                   MOVEL     *BLANK        FldNameArr
     C                   MOVEL     *BLANK        MsgIdArr
     C                   MOVEL     *BLANK        MsgDtaArr
      *
      **  If F3, bypass further processing.
      *
     C     *INKC         IFEQ      '1'
     C                   MOVEL     '1'           @INKC
     C                   SETON                                        LR
     C                   RETURN
     C                   END
      *
      **  If F9, bypass further processing.
     C     *INKI         IFEQ      '1'
     C                   MOVEL     'I'           @OPSEL
     C                   SETON                                        LR
     C                   RETURN
     C                   END
      *
     C                   END
      *
      * Set indicator and flag for Midas (back) office customer number key
      *
     C     *INKK         IFEQ      '1'
     C                   MOVE      'S'           WCUST
     C                   END
      *
      **  If F13, Acceptance screen processing.                                               CSD031
      *                                                                                       CSD031
     C                   IF        *INKM = *ON AND                                            CSD031
     C                             CSD037 = 'Y'                                               CSD031
     C                   EXSR      SRACCP                                                     CSD031
     C                   ENDIF                                                                CSD031
      *                                                                                       CSD031
     C                   ENDSR
      ********************************************************************
      /EJECT
      ********************************************************************
      * BLDSFL3 - BUILD SUBFILE by MIDAS CUSTOMER SHORTNAME
      ********************************************************************
 
     C     BLDSFL3       BEGSR
      *
      ** Check for user Authority to Browse IF NOT MULTI-BRANCHING
      *
     C     BJSBRC        IFNE      *BLANK
     C                   EXSR      CHAUTN
     C                   END
      *
      * Validate Customer N(FOR POINTER)
      *
     C                   EXSR      VALCUST
      *
      **  Get customer shortname reference
      *
     C                   IF        CSD037 = 'Y' AND                                           CSD031
     C                             WAccMde = 'A'                                              CSD031
     C     @@CUST        CHAIN     SDACSTL1                           89                      CSD031
     C                   ELSE                                                                 CSD031
     C     @@CUST        CHAIN     CUSDNUM                            89
     C                   ENDIF                                                                CSD031
     C                   MOVE      BBCSSN        @@CSSN           10
     C     *IN89         IFEQ      '1'
     C                   MOVE      *BLANK        @@CSSN
     C                   END
      *
      **  Initialise subfile relative record number.
      *
     C                   Z-ADD     0             @@RRN
      *
      **  Clear subfile before refilling by writing control record
      **  with SFLCLR active.
      *
     C                   MOVE      '1'           *IN97
     C                   WRITE     SDCUSDS4
     C                   MOVE      '0'           *IN97
      *
      **  Set file pointer on key displayed on screen.
      *
     C                   IF        CSD037 = 'Y' AND                                           CSD031
     C                             WAccMde = 'A'                                              CSD031
     C     @@CSSN        SETLL     SDACSTL3                                                   CSD031
      *                                                                                       CSD031
     C     SECSSN        IFNE      *BLANK                                                     CSD031
     C     SECSSN        SETLL     SDACSTL3                                                   CSD031
     C                   ENDIF                                                                CSD031
     C                   ELSE                                                                 CSD031
     C     @@CSSN        SETLL     CUSDSSN
      *
     C     SECSSN        IFNE      *BLANK                                                     213909
     C     SECSSN        SETLL     CUSDSSN                                                    213909
     C                   ENDIF                                                                213909
      *                                                                                       213909
     C                   ENDIF                                                                CSD031
      *                                                                                       CSD031
      **  Read a Valid customer
      *
     C                   EXSR      RDCUST
      *
      **  set up message 'no data to display'
      *
     C                   MOVE      *OFF          *IN80
     C     @@EOF         IFEQ      'Y'
     C                   MOVE      *ON           *IN80
     C                   END
      *
      **  Set on ROLLUP indicator to drive initial loop.
      *
     C                   MOVE      '1'           *IN98
      *
      **  Read records from the file into the subfile until a page has
      **  been filled or there are no more records.
      **  Repeat the process until either the end of file, ROLLUP
      **  has not been entered or F3 or F12 is input.
      *
     C     *IN98         DOWEQ     '1'
      *
      **  Initialise count of records written to subfile page.
      *
     C                   Z-ADD     0             @@CNT
      *
      **  For each record read, write it to the subfile.
      **  Do this until end of file or the subfile page is full.
      *
     C     @@EOF         DOWNE     'Y'
     C     @@CNT         ANDLT     14
      *
      **  Increment the subfile record no. and records written fields.
      *
     C                   ADD       1             @@RRN
     C                   ADD       1             @@CNT
      *
      **  Format custo fields for output
      *
     C                   EXSR      FMTCUS
      *
      **  Write the customer to the subfile.
      *
      **  If action code or customer number selected is invalid,
      **  the subfile postions on the error record and rebuilds
      *
     C                   MOVE      *OFF          *IN92
     C     @@RRN         IFNE      1
     C                   MOVE      *BLANK        DDOPT
     C                   ELSE
     C     'DDACTN    '  LOOKUP    FldNameArr                             99
     C     'DDCUSN    '  LOOKUP    FldNameArr                             98
     C     *IN99         IFNE      '1'
     C     *IN98         ANDNE     '1'
     C                   MOVE      *BLANK        DDOPT
     C                   ELSE
     C                   MOVE      *ON           *IN92
     C                   ENDIF
     C                   ENDIF
      *
     C                   Z-ADD     @@RRN         DDSFRN
     C                   WRITE     SDCUSDS5
      *
      ** Read a valid Customer
      *
     C                   EXSR      RDCUST
     C                   END
      *
      **  Set up footer toggle text and write the footer
      *
     C                   IF        PMode = 'E'                                              BUG23518
     C                   EVAL      TOGLTEXT = @FTR(6)                                       BUG23518
     C                   EVAL      *IN72 = *ON                                              BUG23518
     C                   ELSE                                                               BUG23518
     C                   MOVE      @FTR(3)       TOGLTEXT
     C                   EVAL      *IN72 = *OFF                                             BUG23518
     C                   ENDIF                                                              BUG23518
      *                                                                                     BUG23518
     C                   WRITE     SDCUSDF1
      *
      **  Write the message subfile
      *
     C                   WRITE     SDCUSDM0
      *
      **  If there is no data to display, set on SFLCLR condition and
      **  write the subfile control record
      *
     C     @@CNT         IFEQ      0
     C                   MOVE      '1'           *IN97
     C                   WRITE     SDCUSDS4
     C                   MOVE      '0'           *IN97
     C                   Z-ADD     1             @@RRN
     C                   Z-ADD     1             DDSFRN
      *
      **  write to the subfile with non-display set on
      *
     C                   MOVE      '1'           *IN93
     C                   WRITE     SDCUSDS5
     C                   MOVE      '0'           *IN93
     C                   WRITE     SDCUSDS4
     C                   ELSE
      *
      **  Write the subfile control record to the screen to display
      **  the subfile.
      *
     C                   WRITE     SDCUSDS4
     C                   ENDIF
      *
      **  Read the subfile control record to determine whether records
      **  have been selected or whether ROLLUP is required.
      *
     C                   READ      SDCUSDS4                               99
      *
      ** Clear any messages before processing user input
      *
     C                   MOVEL     *BLANK        FldNameArr
     C                   MOVEL     *BLANK        MsgIdArr
     C                   MOVEL     *BLANK        MsgDtaArr
      *
      **  If F3, bypass further processing.
      *
     C     *INKC         IFEQ      '1'
     C                   MOVEL     '1'           @INKC
     C                   SETON                                        LR
     C                   RETURN
     C                   END
      *
      **  If F9, bypass further processing.
     C     *INKI         IFEQ      '1'
     C                   MOVEL     'I'           @OPSEL
     C                   SETON                                        LR
     C                   RETURN
     C                   END
      *
     C                   END
      *
      * Set indicator and flag for Midas (back) office customer number key
      *
     C     *INKK         IFEQ      '1'
     C                   MOVE      'B'           WCUST
     C                   END
      *
      **  If F13, Acceptance screen processing.                                               CSD031
      *                                                                                       CSD031
     C                   IF        *INKM = *ON AND                                            CSD031
     C                             CSD037 = 'Y'                                               CSD031
     C                   EXSR      SRACCP                                                     CSD031
     C                   ENDIF                                                                CSD031
      *                                                                                       CSD031
     C                   ENDSR
      ********************************************************************
      /EJECT
      ********************************************************************
      * RDSFLR - READ SUBFILE RECORD
      ********************************************************************
     C     RDSFLR        BEGSR
      *
      **  Read the subfile for selected records
      **  Only process those for which the option field is blank.
      *
     C     *IN99         DOUEQ     '1'
     C     DDOPT         ORNE      *BLANK
     C     WCUST         IFEQ      'B'
     C                   READC     SDCUSDS1                               99
     C                   END
     C     WCUST         IFEQ      'F'
     C                   READC     SDCUSDS3                               99
     C                   END
     C     WCUST         IFEQ      'S'
     C                   READC     SDCUSDS5                               99
     C                   END
     C                   END
      *
      **  Return the selected customer reference and option
      *
     C     *IN99         IFNE      '1'
     C     DDOPT         ANDNE     *BLANK
      *
     C                   IF        WAccMde <> 'A'                                             CSD031
                                                                                              CSD031
     C     DDOPT         IFEQ      'A'
     C     DDOPT         OREQ      'D'
     C     DDOPT         OREQ      'E'                                                       BUG8169
     C     CSD007        OREQ      'Y'                                                        CSD007
     C     DDOPT         ANDEQ     'C'                                                        CSD007
     C     CSD007        OREQ      'Y'                                                        CSD007
     C     DDOPT         ANDEQ     'R'                                                        CSD007
     C/COPY WNCPYSRC,SDH00479
     C                   MOVE      DDOPT         @OPSEL
     C**********         ELSE                                                                BUG8169
     C**********         MOVE      'E'           @OPSEL                                      BUG8169
     C                   END
                                                                                              CSD031
     C                   ELSE                                                                 CSD031
                                                                                              CSD031
     C     DDOPT         IFEQ      'D'                                                        CSD031
     C     DDOPT         OREQ      'E'                                                        CSD031
     C     DDOPT         OREQ      'X'                                                        CSD031
     C                   MOVE      DDOPT         @OPSEL                                       CSD031
     C                   ENDIF                                                                CSD031
                                                                                              CSD031
     C                   ENDIF                                                                CSD031
      *
     C                   MOVE      DDCUS         @CUSEL
      *
     C                   END
      *
     C     EBLDSF        ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * FMTCUS - FORMAT CUSTOMER FOR OUTPUT
      ******************************************************************
     C     FMTCUS        BEGSR
      *
      * Customer reference
     C                   MOVE      BBCUST        DDCUS
     C                   MOVE      BBCSSN        DDCSSN
     C                   MOVE      BBCRNM        DDCRNM
     C                   MOVE      BBCRTN        DDCRTN
                                                                                              CSD007
      ** Customer Closure Status                                                              CSD007
                                                                                              CSD007
     C                   EVAL      DDCLST = *BLANKS                                          CSD025A
                                                                                             CSD025A
     C                   SELECT                                                               CSD007
                                                                                              CSD007
     C                   WHEN      CSD007 <> 'Y'                                              CSD007
     C                   EVAL      DDCLST = *BLANKS                                           CSD007
                                                                                              CSD007
     C                   WHEN      BBDTDL > 0                                                 CSD007
     C                   EVAL      DDCLST = 'DELETED'                                         CSD007
                                                                                              CSD007
     C                   WHEN      BBCLST = 'Y'                                               CSD007
     C                   EVAL      DDCLST = 'CLOSED '                                         CSD007
                                                                                             CSD025A
     C                   WHEN      CSD025 = 'Y' and BBDEAC = 'Y'                             CSD025A
     C                   EVAL      DDCLST = 'INACTIVE'                                       CSD025A
                                                                                              CSD007
     C                   OTHER                                                                CSD007
     C                   EVAL      DDCLST = 'ACTIVE '                                         CSD007
                                                                                              CSD007
     C                   ENDSL                                                                CSD007
      *
      * Front Office Customer number
      *
     C                   MOVE      BBFRNT        DDFODN
      *                                                                                       CSD031
      ** Central Data switchable feature is on                                                CSD031
      *                                                                                       CSD031
     C                   IF        CSD037 = 'Y'                                               CSD031
      *                                                                                       CSD031
      ** Central Data indicator                                                               CSD031
      *                                                                                       CSD031
     C                   IF        *IN59 = *OFF                                               CSD031
     C                   EVAL      DDGPDT = BBGPDT                                            CSD031
     C                   EVAL      DDEACT = *BLANKS                                           CSD031
     C                   ELSE                                                                 CSD031
      *                                                                                       CSD031
      ** Actions                                                                              CSD031
      *                                                                                       CSD031
     C                   SELECT                                                               CSD031
     C                   WHEN      BBTYLC = 'I'                                               CSD031
     C                   EVAL      DDEACT = 'INSERT'                                          CSD031
     C                   WHEN      BBTYLC = 'A'                                               CSD031
     C                   EVAL      DDEACT = 'AMEND '                                          CSD031
     C                   WHEN      BBTYLC = 'D'                                               CSD031
     C                   EVAL      DDEACT = 'DELETE'                                          CSD031
     C                   ENDSL                                                                CSD031
     C                   EVAL      DDGPDT = *BLANK                                            CSD031
      *                                                                                       CSD031
     c                   ENDIF                                                                CSD031
      *                                                                                       CSD031
      ** Effective Date                                                                       CSD031
      *                                                                                       CSD031
     C                   EVAL      ZDAYNO = BBEACC                                            CSD031
     C                   EXSR      ZDATE2                                                     CSD031
     C                   MOVE      ZDATE         DDEACC                                       CSD031
      *                                                                                       CSD031
     C                   ENDIF                                                                CSD031
      *
     C                   ENDSR
      ******************************************************************
      /EJECT
      *****************************************************************
      * RDCUST - READ A CUSTOMER
      *****************************************************************
     C     RDCUST        BEGSR
      *
      **  Reset End of File and skip record indicator
      *
     C                   MOVE      *BLANK        @@EOF             1
      *
      **  Read the file initially - if @@EOF is set on then the end of
      **  the file has been reached.  Read until a valid record is
      **  found or until no more records exist.
      *
     C     @@EOF         DOUEQ     'Y'
     C     BBCUST        ORNE      *BLANKS
     C     @@ERR         ANDEQ     *ZERO
     C*****BBDTDL        ANDEQ     *ZERO                                                      CSD007
     C     WSHOW         ANDEQ     'Y'                                                        CSD007
      *
      **  Read the file for back office MIDAS customer number view
      *
     C     WCUST         IFEQ      'B'
      *
      **  Position according to customer number
      *
     C*****SECUST        IFNE      *BLANK                                                     213909
     C*****SECUST        SETLL     CUSDNUM                            89                      213909
     C**********         READ      CUSDNUM                                96                  213909
     C**********         MOVE      *BLANK        SECUST                                       213909
     C**********         EXSR      SRSHOW                                              CSD007 213909
     C**********         ELSE                                                                 213909
     C                   IF        CSD037 = 'Y' AND                                           CSD031
     C                             WAccMde = 'A'                                              CSD031
     C                   READ      SDACSTL1                               96                  CSD031
     C                   ELSE                                                                 CSD031
     C                   READ      CUSDNUM                                96
     C                   ENDIF                                                                CSD031
     C                   EXSR      SRSHOW                                                     CSD007
     C**********         ENDIF                                                                213909
      *
      ** Select according to customer shortname mask
      *
     C     SECSSN        IFNE      *BLANK
     C                   CALL      'QCLSCAN'
     C                   PARM                    BBCSSN
     C                   PARM      10            LENGTH1           3 0
     C                   PARM      1             START             3 0
     C                   PARM                    SECSSN
     C                   PARM      10            LENGTH2           3 0
     C                   PARM      '1'           TRANSLATE         1
     C                   PARM      '1'           TRIM              1
     C                   PARM      '?'           WILD              1
     C                   PARM                    RESULT            3 0
     C     RESULT        IFLT      1
     C                   MOVE      *BLANK        BBCUST
     C                   ENDIF
     C                   ENDIF
      *
      ** Select according to customer report name mask
      *
     C     SECRNM        IFNE      *BLANK
     C                   CALL      'QCLSCAN'
     C                   PARM                    BBCRNM
     C                   PARM      20            LENGTH1
     C                   PARM      1             START
     C                   PARM                    SECRNM
     C                   PARM      20            LENGTH2
     C                   PARM      '1'           TRANSLATE
     C                   PARM      '1'           TRIM
     C                   PARM      '?'           WILD
     C                   PARM                    RESULT
     C     RESULT        IFLT      1
     C                   MOVE      *BLANK        BBCUST
     C                   ENDIF
     C                   ENDIF
      *
      ** Select according to customer report town mask
      *
     C     SECRTN        IFNE      *BLANK
     C                   CALL      'QCLSCAN'
     C                   PARM                    BBCRTN
     C                   PARM      10            LENGTH1
     C                   PARM      1             START
     C                   PARM                    SECRTN
     C                   PARM      10            LENGTH2
     C                   PARM      '1'           TRANSLATE
     C                   PARM      '1'           TRIM
     C                   PARM      '?'           WILD
     C                   PARM                    RESULT
     C     RESULT        IFLT      1
     C                   MOVE      *BLANK        BBCUST
     C                   ENDIF
     C                   ENDIF
                                                                                              CSD007
      ** Select according to Closure status                                                   CSD007
                                                                                              CSD007
     C     SECLST        IFNE      *BLANKS                                                    CSD007
     C                   SELECT                                                               CSD007
     C     SECLST        WHENEQ    'DELETED'                                                  CSD007
     C     BBDTDL        ANDNE     *ZERO                                                      CSD007
     C     SECLST        WHENEQ    'CLOSED '                                                  CSD007
     C     BBCLST        ANDEQ     'Y'                                                        CSD007
     C     BBDTDL        ANDEQ     *ZERO                                                      CSD007
     C     SECLST        WHENEQ    'ACTIVE '                                                  CSD007
     C     BBCLST        ANDEQ     *BLANK                                                     CSD007
     C     BBDTDL        ANDEQ     *ZERO                                                      CSD007
     C     SECLST        WHENEQ    'INACTIVE'                                                CSD025A
     C     BBDEAC        ANDEQ     'Y'                                                       CSD025A
     C     CSD025        ANDEQ     'Y'                                                       CSD025A
     C                   OTHER                                                                CSD007
     C                   MOVE      *BLANK        BBCUST                                       CSD007
     C                   ENDSL                                                                CSD007
     C                   ENDIF                                                                CSD007
      *                                                                                       CSD031
      ** Validate Additional fields if CSD037 is om                                           CSD031
      *                                                                                       CSD031
     C                   IF        CSD037 = 'Y'                                               CSD031
      *                                                                                       CSD031
      ** Central Data indicator                                                               CSD031
      *                                                                                       CSD031
     C                   IF        SECGDT <> *BLANKS AND                                      CSD031
     C                             SECGDT <> BBGPDT                                           CSD031
     C                   EVAL      BBCUST = *BLANKS                                           CSD031
     C                   ENDIF                                                                CSD031
      *                                                                                       CSD031
      ** Effective Date                                                                       CSD031
      *                                                                                       CSD031
     C                   EVAL      ZDAYNO = BBEACC                                            CSD031
     C                   EXSR      ZDATE2                                                     CSD031
     C                   MOVE      ZDATE         WEffDte                                      CSD031
      *                                                                                       CSD031
     C                   IF        SECEAC <> *BLANKS AND                                      CSD031
     C                             SECEAC <> WEffDte                                          CSD031
     C                   EVAL      BBCUST = *BLANKS                                           CSD031
     C                   ENDIF                                                                CSD031
      *                                                                                       CSD031
      ** Actions                                                                              CSD031
      *                                                                                       CSD031
     C                   SELECT                                                               CSD031
     C                   WHEN      BBTYLC = 'I'                                               CSD031
     C                   EVAL      WAction = 'INSERT'                                         CSD031
     C                   WHEN      BBTYLC = 'A'                                               CSD031
     C                   EVAL      WAction = 'AMEND '                                         CSD031
     C                   WHEN      BBTYLC = 'D'                                               CSD031
     C                   EVAL      WAction = 'DELETE'                                         CSD031
     C                   ENDSL                                                                CSD031
      *                                                                                       CSD031
     C                   IF        SECACT <> *BLANKS AND                                      CSD031
     C                             SECACT <> WAction                                          CSD031
     C                   EVAL      BBCUST = *BLANKS                                           CSD031
     C                   ENDIF                                                                CSD031
      *                                                                                       CSD031
     C                   ENDIF                                                                CSD031
      *
     C                   ENDIF
      *
      **  Read the file for front office ID view
      *
     C     WCUST         IFEQ      'F'
      *
      **  Position according to front office ID
      *
     C*****SEFODN        IFNE      *BLANK                                                     213909
     C*****SEFODN        SETLL     CUSDSFO                            89                      213909
     C**********         READ      CUSDSFO                                96                  213909
     C**********         MOVE      *BLANK        SEFODN                                       213909
     C**********         EXSR      SRSHOW                                              CSD007 213909
     C**********         ELSE                                                                 213909
     C                   IF        CSD037 = 'Y' AND                                           CSD031
     C                             WAccMde = 'A'                                              CSD031
     C                   READ      SDACSTL4                               96                  CSD031
     C                   ELSE                                                                 CSD031
     C     @@FOTD        IFNE      *BLANKS                                                    CSD027
     C                   READ      CUSDSFO                                96
     C                   ELSE                                                                 CSD027
     C                   READ      CUSDNUM                                96                  CSD027
     C                   END                                                                  CSD027
     C                   ENDIF                                                                CSD031
     C                   EXSR      SRSHOW                                                     CSD007
     C**********         ENDIF                                                                213909
      *
      ** Select records according to customer number mask
      *
     C     SECUST        IFNE      *BLANK
     C                   CALL      'QCLSCAN'
     C                   PARM                    BBCUST
     C                   PARM      6             LENGTH1
     C                   PARM      1             START
     C                   PARM                    SECUST
     C                   PARM      6             LENGTH2
     C                   PARM      '1'           TRANSLATE
     C                   PARM      '1'           TRIM
     C                   PARM      '?'           WILD
     C                   PARM                    RESULT
     C     RESULT        IFLT      1
     C                   MOVE      *BLANK        BBCUST
     C                   ENDIF
     C                   ENDIF
      *
      ** Select records according to customer shortname mask
      *
     C     SECSSN        IFNE      *BLANK
     C                   CALL      'QCLSCAN'
     C                   PARM                    BBCSSN
     C                   PARM      10            LENGTH1
     C                   PARM      1             START
     C                   PARM                    SECSSN
     C                   PARM      10            LENGTH2
     C                   PARM      '1'           TRANSLATE
     C                   PARM      '1'           TRIM
     C                   PARM      '?'           WILD
     C                   PARM                    RESULT
     C     RESULT        IFLT      1
     C                   MOVE      *BLANK        BBCUST
     C                   ENDIF
     C                   ENDIF
      *
      ** Select records according to customer report town mask
      *
     C     SECRTN        IFNE      *BLANK
     C                   CALL      'QCLSCAN'
     C                   PARM                    BBCRTN
     C                   PARM      10            LENGTH1
     C                   PARM      1             START
     C                   PARM                    SECRTN
     C                   PARM      10            LENGTH2
     C                   PARM      '1'           TRANSLATE
     C                   PARM      '1'           TRIM
     C                   PARM      '?'           WILD
     C                   PARM                    RESULT
     C     RESULT        IFLT      1
     C                   MOVE      *BLANK        BBCUST
     C                   ENDIF
     C                   ENDIF
                                                                                              CSD007
      ** Select according to Closure status                                                   CSD007
                                                                                              CSD007
     C     SECLST        IFNE      *BLANKS                                                    CSD007
     C                   SELECT                                                               CSD007
     C     SECLST        WHENEQ    'DELETED'                                                  CSD007
     C     BBDTDL        ANDNE     *ZERO                                                      CSD007
     C     SECLST        WHENEQ    'CLOSED '                                                  CSD007
     C     BBCLST        ANDEQ     'Y'                                                        CSD007
     C     BBDTDL        ANDEQ     *ZERO                                                      CSD007
     C     SECLST        WHENEQ    'ACTIVE '                                                  CSD007
     C     BBCLST        ANDEQ     *BLANK                                                     CSD007
     C     BBDTDL        ANDEQ     *ZERO                                                      CSD007
     C     SECLST        WHENEQ    'INACTIVE'                                                CSD025A
     C     BBDEAC        ANDEQ     'Y'                                                       CSD025A
     C     CSD025        ANDEQ     'Y'                                                       CSD025A
     C                   OTHER                                                                CSD007
     C                   MOVE      *BLANK        BBCUST                                       CSD007
     C                   ENDSL                                                                CSD007
     C                   ENDIF                                                                CSD007
      *                                                                                       CSD031
      ** Validate Additional fields if CSD037 is om                                           CSD031
      *                                                                                       CSD031
     C                   IF        CSD037 = 'Y'                                               CSD031
      *                                                                                       CSD031
      ** Central Data indicator                                                               CSD031
      *                                                                                       CSD031
     C                   IF        SECGDT <> *BLANKS AND                                      CSD031
     C                             SECGDT <> BBGPDT                                           CSD031
     C                   EVAL      BBCUST = *BLANKS                                           CSD031
     C                   ENDIF                                                                CSD031
      *                                                                                       CSD031
      ** Effective Date                                                                       CSD031
      *                                                                                       CSD031
     C                   EVAL      ZDAYNO = BBEACC                                            CSD031
     C                   EXSR      ZDATE2                                                     CSD031
     C                   MOVE      ZDATE         WEffDte                                      CSD031
      *                                                                                       CSD031
     C                   IF        SECEAC <> *BLANKS AND                                      CSD031
     C                             SECEAC <> WEffDte                                          CSD031
     C                   EVAL      BBCUST = *BLANKS                                           CSD031
     C                   ENDIF                                                                CSD031
      *                                                                                       CSD031
      ** Actions                                                                              CSD031
      *                                                                                       CSD031
     C                   SELECT                                                               CSD031
     C                   WHEN      BBTYLC = 'I'                                               CSD031
     C                   EVAL      WAction = 'INSERT'                                         CSD031
     C                   WHEN      BBTYLC = 'A'                                               CSD031
     C                   EVAL      WAction = 'AMEND '                                         CSD031
     C                   WHEN      BBTYLC = 'D'                                               CSD031
     C                   EVAL      WAction = 'DELETE'                                         CSD031
     C                   ENDSL                                                                CSD031
      *                                                                                       CSD031
     C                   IF        SECACT <> *BLANKS AND                                      CSD031
     C                             SECACT <> WAction                                          CSD031
     C                   EVAL      BBCUST = *BLANKS                                           CSD031
     C                   ENDIF                                                                CSD031
      *                                                                                       CSD031
     C                   ENDIF                                                                CSD031
      *
     C                   ENDIF
      *
      **  Read the file for customer shortname view
      *
     C     WCUST         IFEQ      'S'
      *
      **  Position according to customer shortname
      *
     C*****SECSSN        IFNE      *BLANK                                                     213909
     C*****SECSSN        SETLL     CUSDSSN                            89                      213909
     C**********         READ      CUSDSSN                                96                  213909
     C**********         MOVE      *BLANK        SECSSN                                       213909
     C**********         EXSR      SRSHOW                                              CSD007 213909
     C**********         ELSE                                                                 213909
     C                   IF        CSD037 = 'Y' AND                                           CSD031
     C                             WAccMde = 'A'                                              CSD031
     C                   READ      SDACSTL3                               96                  CSD031
     C                   ELSE                                                                 CSD031
     C                   READ      CUSDSSN                                96
     C                   ENDIF                                                                CSD031
     C                   EXSR      SRSHOW                                                     CSD007
     C**********         ENDIF                                                                213909
      *
      ** Select records according to customer number mask
      *
     C     SECUST        IFNE      *BLANK
     C                   CALL      'QCLSCAN'
     C                   PARM                    BBCUST
     C                   PARM      6             LENGTH1
     C                   PARM      1             START
     C                   PARM                    SECUST
     C                   PARM      6             LENGTH2
     C                   PARM      '1'           TRANSLATE
     C                   PARM      '1'           TRIM
     C                   PARM      '?'           WILD
     C                   PARM                    RESULT
     C     RESULT        IFLT      1
     C                   MOVE      *BLANK        BBCUST
     C                   ENDIF
     C                   ENDIF
      *
      ** Select records according to customer report name mask
      *
     C     SECRNM        IFNE      *BLANK
     C                   CALL      'QCLSCAN'
     C                   PARM                    BBCRNM
     C                   PARM      20            LENGTH1
     C                   PARM      1             START
     C                   PARM                    SECRNM
     C                   PARM      20            LENGTH2
     C                   PARM      '1'           TRANSLATE
     C                   PARM      '1'           TRIM
     C                   PARM      '?'           WILD
     C                   PARM                    RESULT
     C     RESULT        IFLT      1
     C                   MOVE      *BLANK        BBCUST
     C                   ENDIF
     C                   ENDIF
      *
      ** Select records according to customer report town mask
      *
     C     SECRTN        IFNE      *BLANK
     C                   CALL      'QCLSCAN'
     C                   PARM                    BBCRTN
     C                   PARM      10            LENGTH1
     C                   PARM      1             START
     C                   PARM                    SECRTN
     C                   PARM      10            LENGTH2
     C                   PARM      '1'           TRANSLATE
     C                   PARM      '1'           TRIM
     C                   PARM      '?'           WILD
     C                   PARM                    RESULT
     C     RESULT        IFLT      1
     C                   MOVE      *BLANK        BBCUST
     C                   ENDIF
     C                   ENDIF
                                                                                              CSD007
      ** Select according to Closure status                                                   CSD007
                                                                                              CSD007
     C     SECLST        IFNE      *BLANKS                                                    CSD007
     C                   SELECT                                                               CSD007
     C     SECLST        WHENEQ    'DELETED'                                                  CSD007
     C     BBDTDL        ANDNE     *ZERO                                                      CSD007
     C     SECLST        WHENEQ    'CLOSED '                                                  CSD007
     C     BBCLST        ANDEQ     'Y'                                                        CSD007
     C     BBDTDL        ANDEQ     *ZERO                                                      CSD007
     C     SECLST        WHENEQ    'ACTIVE '                                                  CSD007
     C     BBCLST        ANDEQ     *BLANK                                                     CSD007
     C     BBDTDL        ANDEQ     *ZERO                                                      CSD007
     C     SECLST        WHENEQ    'INACTIVE'                                                CSD025A
     C     BBDEAC        ANDEQ     'Y'                                                       CSD025A
     C     CSD025        ANDEQ     'Y'                                                       CSD025A
     C                   OTHER                                                                CSD007
     C                   MOVE      *BLANK        BBCUST                                       CSD007
     C                   ENDSL                                                                CSD007
     C                   ENDIF                                                                CSD007
      *                                                                                       CSD031
      ** Validate Additional fields if CSD037 is om                                           CSD031
      *                                                                                       CSD031
     C                   IF        CSD037 = 'Y'                                               CSD031
      *                                                                                       CSD031
      ** Central Data indicator                                                               CSD031
      *                                                                                       CSD031
     C                   IF        SECGDT <> *BLANKS AND                                      CSD031
     C                             SECGDT <> BBGPDT                                           CSD031
     C                   EVAL      BBCUST = *BLANKS                                           CSD031
     C                   ENDIF                                                                CSD031
      *                                                                                       CSD031
      ** Effective Date                                                                       CSD031
      *                                                                                       CSD031
     C                   EVAL      ZDAYNO = BBEACC                                            CSD031
     C                   EXSR      ZDATE2                                                     CSD031
     C                   MOVE      ZDATE         WEffDte                                      CSD031
      *                                                                                       CSD031
     C                   IF        SECEAC <> *BLANKS AND                                      CSD031
     C                             SECEAC <> WEffDte                                          CSD031
     C                   EVAL      BBCUST = *BLANKS                                           CSD031
     C                   ENDIF                                                                CSD031
      *                                                                                       CSD031
      ** Actions                                                                              CSD031
      *                                                                                       CSD031
     C                   SELECT                                                               CSD031
     C                   WHEN      BBTYLC = 'I'                                               CSD031
     C                   EVAL      WAction = 'INSERT'                                         CSD031
     C                   WHEN      BBTYLC = 'A'                                               CSD031
     C                   EVAL      WAction = 'AMEND '                                         CSD031
     C                   WHEN      BBTYLC = 'D'                                               CSD031
     C                   EVAL      WAction = 'DELETE'                                         CSD031
     C                   ENDSL                                                                CSD031
      *                                                                                       CSD031
     C                   IF        SECACT <> *BLANKS AND                                      CSD031
     C                             SECACT <> WAction                                          CSD031
     C                   EVAL      BBCUST = *BLANKS                                           CSD031
     C                   ENDIF                                                                CSD031
      *                                                                                       CSD031
     C                   ENDIF                                                                CSD031
      *
     C                   ENDIF
      *
      * End of File
      *
     C     *IN96         IFEQ      '1'
     C                   MOVEL     'Y'           @@EOF
     C                   END
      *
     C                   END
      *
     C     ERDCUST       ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * CHAUTN - CHECK FOR USER AUTHORITY IF NOT MULTI-BRANCHING
      *****************************************************************
     C     CHAUTN        BEGSR
      *
     C                   CALL      'ZVACTU'
     C                   PARM      'E'           ZACTN             1
     C                   PARM                    @@ERR             1 0
      *
      * RETURN ERROR MESSAGE
      *
     C     @@ERR         IFEQ      1
     C                   MOVEL     'FXM0292'     @ERRMS
     C                   RETURN
     C                   END
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * VALCUST - VALIDATE CUSTO REFERENCE POINTER
      *****************************************************************
     C     VALCUST       BEGSR
      *
      **  Validate that the custo reference is numeric or blank.
      *
     C                   TESTN                   DDCUSN               98
     C                   MOVE      DDCUSN        @@TEST            1
     C                   TESTZ                   @@TEST                   99
      *
      ** If Alphanumeric Customer Numbers are enabled                                         CSD027
     C                   If        WCusAlphaAllow = 'Y'                                       CSD027
     C                   Eval      PCust = DDCUSN                                             CSD027
     C                   Eval      PValid = *BLANKS                                           CSD027
     C                   Call(E)   'SDCUSTISO'   P_SDCUSTISO                                  CSD027
      * If Error                                                                              CSD027
     C                   If        %Error Or (*INU7 = *ON And *INU8 = *ON)                    CSD027
     C                   Eval      DBFILE = 'SDCUSTISO'                                       CSD027
     C                   Eval      DBASE = 914                                                CSD027
     C                   Eval      DBKEY = PCust                                              CSD027
     C                   ExSr      *PSSR                                                      CSD027
     C                   EndIf                                                                CSD027
      *                                                                                       CSD027
     C                   EndIf                                                                CSD027
      *                                                                                       CSD027
     C*****DDCUSN        IFEQ      *BLANKS                                                    CSD027
     C******IN98         OREQ      '1'                                                        CSD027
     C******IN99         ANDEQ     '1'                                                        CSD027
     C**********         MOVE      DDCUSN        @@CUST            6                          CSD027
      **********                                                                              CSD027
      * RETURN ERROR MESSAGE                                                                  CSD027
      **********                                                                              CSD027
     C**********         ELSE                                                                 CSD027
     C**********         MOVEL     'MMA0087'     @ERRMS                                       CSD027
     C**********         RETURN                                                               CSD027
     C**********         END                                                                  CSD027
      *                                                                                       CSD027
      * Check if Customer# is valid                                                           CSD027
     C                   If        DDCUSN = *BLANKS                                           CSD027
     C                             Or                                                         CSD027
     C                             (WCusAlphaAllow = 'N' And                                  CSD027
     C                              *IN98 = *ON And *IN99 = *ON)                              CSD027
     C                             Or                                                         CSD027
     C                             (WCusAlphaAllow = 'Y' And                                  CSD027
     C                              WCusAlphaSupNum = 'Y' And                                 CSD027
     C                              *IN98 = *ON And *IN99 = *ON)                              CSD027
     C                             Or                                                         CSD027
     C                             (WCusAlphaAllow = 'Y' And                                  CSD027
     C                              WCusAlphaSupNum = 'N' And                                 CSD027
     C                              PValid = *BLANKS)                                         CSD027
     C                             Or                                                       BUG11934
     C                             (WCusAlphaAllow = 'Y' And                                BUG11934
     C                              WCusAlphaSupNum = 'Y' And                               BUG11934
     C                              PValid = *BLANKS)                                       BUG11934
     C                   Move      DDCUSN        @@CUST            6                          CSD027
      * If invalid Customer#, return error message                                            CSD027
     C                   Else                                                                 CSD027
      *                                                                                       CSD027
     C                   If        WCusAlphaAllow = 'N'                                       CSD027
     C                   Eval      @ERRMS = 'S270003'                                         CSD027
     C                   Else                                                                 CSD027
     C                   Eval      @ERRMS = 'S270004'                                         CSD027
     C                   move      *blanks       @data                                        249076
     C                   movel     @datarcv      @data                                        249076
     C                   EndIf                                                                CSD027
      *                                                                                       CSD027
     C**********         Return                                                      CSD027 BUG11861
     C                   EndIf                                                                CSD027
      *                                                                                       CSD027
     C                   ENDSR
      *****************************************************************
      /EJECT                                                                                  CSD007
      *****************************************************************                       CSD007
      * SRSHOW - Determine if deleted record will be shown                                    CSD007
      *****************************************************************                       CSD007
     C     SRSHOW        BEGSR                                                                CSD007
                                                                                              CSD007
     C     BBDTDL        IFEQ      *ZERO                                                      CSD007
     C                   MOVE      'Y'           WSHOW             1                          CSD007
     C                   ELSE                                                                 CSD007
     C     CSD007        IFEQ      'Y'                                                        CSD007
     C                   MOVE      'Y'           WSHOW                                        CSD007
     C                   ELSE                                                                 CSD007
     C                   MOVE      'N'           WSHOW                                        CSD007
     C                   ENDIF                                                                CSD007
     C                   ENDIF                                                                CSD007
      *                                                                                       CSD018
     C     CSD018        IFEQ      'Y'                                                        CSD018
      *                                                                                       CSD018
      ** When building the sub-file of Customer Details do not                                CSD018
      *  include the record if the branch code of the customer                                CSD018
      *  being processed does not exist for this Midas user on file                           CSD018
      *  MBRBSDD.                                                                             CSD018
      *                                                                                       CSD018
      * Check if the User is authorized to the branch code of the                             CSD018
      * Customer being processed.                                                             CSD018
     C     PsUser        CHAIN     MBRBS                              74                      CSD018
      *                                                                                       CSD018
     C     *IN74         IFEQ      '0'                                                        CSD018
     C     RECI          ANDEQ     'D'                                                        CSD018
     C                   MOVEA     VBRX          WWVBRX                                       CSD018
     C     BBBRCD        LOOKUP    WWVBRX                                 73                  CSD018
     C     *IN73         IFEQ      *OFF                                                       CSD018
     C                   MOVE      'N'           WSHOW                                        CSD018
     C                   ENDIF                                                                CSD018
     C                   ENDIF                                                                CSD018
      *                                                                                       CSD018
     C                   ENDIF                                                                CSD018
     C/COPY WNCPYSRC,SDCUSDBC04
                                                                                              CSD007
     C                   ENDSR                                                                CSD007
      *****************************************************************                       CSD007
      /EJECT                                                                                  CSD031
      *****************************************************************                       CSD031
      * SRACCP - Toggle between the Chang and the Acceptance mode                             CSD031
      *****************************************************************                       CSD031
     C     SRACCP        BEGSR                                                                CSD031
      *                                                                                       CSD031
     C                   IF        WAccMde = 'C'                                              CSD031
     C                   EVAL      *IN57 = *ON                                                CSD031
     C                   EVAL      *IN58 = *OFF                                               CSD031
     C                   EVAL      *IN59 = *ON                                                CSD031
     C                   EVAL      *IN60 = *ON                                                CSD031
     C                   EVAL      SECGDT = *BLANK                                            CSD031
     C                   EVAL      SECEAC = *BLANK                                            CSD031
     C                   EVAL      WAccMde = 'A'                                              CSD031
     C                   ELSE                                                                 CSD031
     C                   EVAL      *IN57 = *OFF                                               CSD031
     C                   EVAL      *IN58 = *ON                                                CSD031
     C                   EVAL      *IN59 = *OFF                                               CSD031
     C                   IF        *IN71 = *ON                                                CSD031
     C                   EVAL      *IN60 = *ON                                                CSD031
     C                   ELSE                                                                 CSD031
     C                   EVAL      *IN60 = *OFF                                               CSD031
     C                   ENDIF                                                                CSD031
     C                   EVAL      SECACT = *BLANKS                                           CSD031
     C                   EVAL      SECEAC = *BLANK                                            CSD031
     C                   EVAL      WAccMde = 'C'                                              CSD031
     C                   ENDIF                                                                CSD031
      *                                                                                       CSD031
     C                   ENDSR                                                                CSD031
      *                                                                                       CSD031
      *****************************************************************                       CSD031
      /EJECT
      *****************************************************************
      * INIT - INITIALIZATION
      *****************************************************************
     C     INIT          BEGSR
      *
      * CLEAR OUTPUTS
      *
     C                   MOVE      *BLANK        @ERRMS
     C                   MOVE      *BLANK        @OPSEL
     C                   MOVE      *BLANK        @CUSEL
     C                   MOVE      '0'           @INKC
      *                                                                                       CSD031
      ** Initialise screen indicators for CSD037 switchable feature                           CSD031
      *                                                                                       CSD031
     C                   EVAL      *IN62 = *OFF                                               CSD031
      *                                                                                       CSD031
      ** Open required files adn set on indicators if CSD037 is on                            CSD031
      *                                                                                       CSD031
     C                   IF        CSD037 = 'Y'                                               CSD031
     C                   EVAL      *IN62 = *ON                                                CSD031
     C**********         OPEN      SDACSTL1                                          CSD031 BUG11861
     C**********         OPEN      SDACSTL3                                          CSD031 BUG11861
     C**********         OPEN      SDACSTL4                                          CSD031 BUG11861
     C                   ENDIF                                                                CSD031
      *
     C                   ENDSR
      /EJECT
      *****************************************************************
      *                                                               *
      * ZEDIT - Edit an unsigned field                                *
      *                                                               *
      *****************************************************************
     C     ZEDIT         BEGSR
 
     C                   CALLB     'ZEDIT'
     C                   PARM                    ZFIELD           16
     C                   PARM                    ZADEC             1 0
 
     C                   ENDSR
      /EJECT
      *****************************************************************
      *                                                               *
      * ZDATE2 - Format a date for output                             *
      *                                                               *
      *****************************************************************
     C     ZDATE2        BEGSR
 
     C                   CALLB     'ZDATE2'
     C                   PARM                    ZDAYNO            5 0
     C                   PARM                    BJDFIN
     C                   PARM                    ZDATE             6 0
     C                   PARM                    ZADATE            7
 
     C                   ENDSR
      ********************************************************************
      /EJECT
      *****************************************************************
      * *INZSR - INITIAL PROCESSING
      *****************************************************************
     C     *INZSR        BEGSR
      *
      * Parameters
      *
     C     *ENTRY        PLIST
      *
      * INPUT PARAMETERS :
      * RETURN CODE
      * ACTION CODE
      * Custo Ref Pointer
      * BUILD SUB-FILE
      * READ SUBFILE RECORD
      * Browse screen
     C                   PARM                    RetCodeIn
     C                   PARM                    DDACTN            1
     C                   PARM                    DDCUSN            6
     C                   PARM                    @BDSFL            1
     C                   PARM                    @RDSFL            1
     C                   PARM                    PMode                                        CLE025
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
     C                   PARM                    CSD037                                       CSD031
      *
      * OUTPUT PARAMETERS :
      * ERROR MESSAGE
      * OPTION SELECTED
      * Custo Ref. selected
     C                   PARM                    @ERRMS            7
     C                   PARM                    @data            45                          249076
     C                   PARM                    @OPSEL            1
     C                   PARM                    @CUSEL            6
      * COMMAND KEYS
     C                   PARM                    @INKC             1
     C                   PARM                    @INKI             1
     C                   PARM                    WAccMde                                      CSD031
      *
      ** Parameter list for calling AOSVALR0                                                  CSD027
     C     P_AOSVALR0    PList                                                                CSD027
      * Return Code (Output)                                                                  CSD027
     C                   Parm                    PRetCode                                     CSD027
      * System Value to be retrieved (Input)                                                  CSD027
     C                   Parm                    PSysValK1                                    CSD027
      * Value returned (Output)                                                               CSD027
     C                   Parm                    PSysVal1                                     CSD027
     C                   Parm                    PSysValK2                                    CSD027
     C                   Parm                    PSysVal2                                     CSD027
     C                   Parm                    PSysValK3                                    CSD027
     C                   Parm                    PSysVal3                                     CSD027
     C                   Parm                    PSysValK4                                    CSD027
     C                   Parm                    PSysVal4                                     CSD027
     C                   Parm                    PSysValK5                                    CSD027
     C                   Parm                    PSysVal5                                     CSD027
     C                   Parm                    PSysValK6                                    CSD027
     C                   Parm                    PSysVal6                                     CSD027
     C                   Parm                    PSysValK7                                    CSD027
     C                   Parm                    PSysVal7                                     CSD027
     C                   Parm                    PSysValK8                                    CSD027
     C                   Parm                    PSysVal8                                     CSD027
     C                   Parm                    PSysValK9                                    CSD027
     C                   Parm                    PSysVal9                                     CSD027
     C                   Parm                    PSysValK10                                   CSD027
     C                   Parm                    PSysVal10                                    CSD027
      *                                                                                       CSD027
      ** Parameter list for calling SDCUSTISO                                                 CSD027
     C     P_SDCUSTISO   PList                                                                CSD027
      ** Customer Number (Input)                                                              CSD027
     C                   Parm                    PCust                                        CSD027
      ** Validity Flags (Output)                                                              CSD027
     C                   Parm                    PValid                                       CSD027
      ** Check Digit (Output)                                                                 CSD027
     C                   Parm                    PCheckDigit                                  CSD027
     C                   Parm                    @datarcv          2                          249076
      *
      ** Initialize program name
     C                   MOVEL     'SDCUSDBRW'   DBPGM
      *
      ** Move workstation ID to screen field.
     C                   MOVEL     PsJobName     DDWID
     C                   MOVEL     PsUser        DDUSER
      *
     C                   MOVE      '1'           *IN94
     C                   MOVEL     '*'           DDPGMQ
     C                   EVAL      WAccMde = 'C'                                              CSD031
     C                   IF        CSD037 = 'Y'                                               CSD031
     C                   EVAL      *IN57 = *OFF                                               CSD031
     C                   EVAL      *IN58 = *ON                                                CSD031
     C                   EVAL      *IN59 = *OFF                                               CSD031
     C                   ELSE                                                                 CSD031
     C                   EVAL      *IN57 = *ON                                                CSD031
     C                   EVAL      *IN58 = *ON                                                CSD031
     C                   ENDIF                                                                CSD031
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
     C/COPY WNCPYSRC,SDCUSDBC03
                                                                                              CSD007
      ** Access SAR details to check if CSD007 is installed                                   CSD007
                                                                                              CSD007
     C                   CALLB     'AOSARDR0'                                                 CSD007
     C                   PARM      *BLANKS       @RTCD                                        CSD007
     C                   PARM      '*VERIFY'     @OPTN                                        CSD007
     C                   PARM      'CSD007'      @SARD             6                          CSD007
     C     SCSARD        PARM      SCSARD        DSFDY                                        CSD007
                                                                                              CSD007
     C     @RTCD         IFNE      *BLANKS                                                    CSD007
     C     @RTCD         ANDNE     '*NRF   '                                                  CSD007
     C                   MOVEL     'SCSARDPD'    DBFILE                                       CSD007
     C                   MOVEL     '902'         DBASE                                        CSD007
     C                   MOVEL     @SARD         DBKEY                                        CSD007
     C                   EXSR      *PSSR                                                      CSD007
     C                   ENDIF                                                                CSD007
                                                                                              CSD007
     C     @RTCD         IFEQ      *BLANKS                                                    CSD007
     C                   MOVEL     'Y'           CSD007            1                          CSD007
     C                   EVAL      *IN71 = *OFF                                               CSD007
     C                   EVAL      *IN60 = *OFF                                               CSD031
     C                   ELSE                                                                 CSD007
     C                   MOVEL     'N'           CSD007                                       CSD007
     C                   EVAL      *IN71 = *ON                                                CSD007
     C                   EVAL      *IN60 = *ON                                                CSD031
     C                   ENDIF                                                                CSD007
      *
      ** Access SAR details to check if CSD018 is installed                                   CSD018
                                                                                              CSD018
     C                   CALLB     'AOSARDR0'                                                 CSD018
     C                   PARM      *BLANKS       @RTCD                                        CSD018
     C                   PARM      '*VERIFY'     @OPTN                                        CSD018
     C                   PARM      'CSD018'      @SARD                                        CSD018
     C     SCSARD        PARM      SCSARD        DSFDY                                        CSD018
                                                                                              CSD018
     C     @RTCD         IFNE      *BLANKS                                                    CSD018
     C     @RTCD         ANDNE     '*NRF   '                                                  CSD018
     C                   MOVEL     'SCSARDPD'    DBFILE                                       CSD018
     C                   MOVEL     '902'         DBASE                                        CSD018
     C                   MOVEL     @SARD         DBKEY                                        CSD018
     C                   EXSR      *PSSR                                                      CSD018
     C                   ENDIF                                                                CSD018
                                                                                              CSD018
     C     @RTCD         IFEQ      *BLANKS                                                    CSD018
     C                   MOVEL     'Y'           CSD018            1                          CSD018
     C                   ELSE                                                                 CSD018
     C                   MOVEL     'N'           CSD018                                       CSD018
     C                   ENDIF                                                                CSD018
                                                                                              CLE025
      ** If called from Customer Details Enquiry (SDCUSDENQ),                                 CLE025
      ** only enquire function is allowed/activated                                           CLE025
                                                                                              CLE025
     C                   IF        PMode = 'E'                                                CLE025
     C                   EVAL      *IN72 = *ON                                                CLE025
     C                   ELSE                                                                 CLE025
     C                   EVAL      *IN72 = *OFF                                               CLE025
     C                   ENDIF                                                                CLE025
      *                                                                                       CSD018
      ** Access SAR details to check if CSD025 is installed                                  CSD025A
                                                                                             CSD025A
     C                   CALLB     'AOSARDR0'                                                CSD025A
     C                   PARM      *BLANKS       @RTCD                                       CSD025A
     C                   PARM      '*VERIFY'     @OPTN                                       CSD025A
     C                   PARM      'CSD025'      @SARD             6                         CSD025A
     C     SCSARD        PARM      SCSARD        DSFDY                                       CSD025A
                                                                                             CSD025A
     C     @RTCD         IFNE      *BLANKS                                                   CSD025A
     C     @RTCD         ANDNE     '*NRF   '                                                 CSD025A
     C                   MOVEL     'SCSARDPD'    DBFILE                                      CSD025A
     C                   MOVEL     '912'         DBASE                                       CSD025A
     C                   MOVEL     @SARD         DBKEY                                       CSD025A
     C                   EXSR      *PSSR                                                     CSD025A
     C                   ENDIF                                                               CSD025A
                                                                                             CSD025A
     C     @RTCD         IFEQ      *BLANKS                                                   CSD025A
     C                   MOVEL     'Y'           CSD025            1                         CSD025A
     C                   ELSE                                                                CSD025A
     C                   MOVEL     'N'           CSD025                                      CSD025A
     C                   ENDIF                                                               CSD025A
     C/COPY WNCPYSRC,SDH00480
 
      * Retrieve System Value 'CustAlphaAllow' & 'CustAlphaSupNumeric'                        CSD027
     C                   Eval      PRetCode = *BLANKS                                         CSD027
     C                   Eval      PSysValK1 = 'CustAlphaAllow'                               CSD027
     C                   Eval      PSysVal1 = *BLANKS                                         CSD027
     C                   Eval      PSysValK2 = 'CustAlphaSupNumeric'                          CSD027
     C                   Eval      PSysVal2 = *BLANKS                                         CSD027
     C**********         CallB(E)  'AOSVALR0'    P_AOSVALR0                          CSD027 BUG11828
                                                                                            BUG11828
     C                   IF        CSD037 = 'Y'                                             BUG11828
     C                   CALL (E)  'GPAOSVALR0'  P_AOSVALR0                                 BUG11828
     C                   ELSE                                                               BUG11828
     C                   CALL (E)  'AOSVALR0'    P_AOSVALR0                                 BUG11828
     C                   ENDIF                                                              BUG11828
      *                                                                                       CSD027
      * If Error retrieving the System value                                                  CSD027
     C                   If        %Error Or PRetCode <> *BLANKS                              CSD027
     C                             Or (*INU7 = *ON And *INU8 = *ON)                           CSD027
     C                   Eval      DBFILE = 'SDSVALPD'                                        CSD027
     C                   Eval      DBASE = 913                                                CSD027
     C                   Eval      DBKEY = 'CustAlpha(Allow/SupNumeric)'                      CSD027
     C                   ExSr      *PSSR                                                      CSD027
     C                   EndIf                                                                CSD027
      *                                                                                       CSD027
     C                   Eval      WCusAlphaAllow  = PSysVal1                                 CSD027
     C                   Eval      WCusAlphaSupNum = PSysVal2                                 CSD027
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line sets up the fixed data for SD *DSP
      ** functions for the message handler, ZAMSGHNDLE.
     D/COPY SDCPYSRC,MSGHNDDATA
      **--------------------------------------------------------------------------------------------
 
     C                   ENDSR
      *****************************************************************
      *
      /EJECT
      ** The following /COPY line includes the ProcMsgs subroutine
      ** to process error and warning messages.
     D/COPY ZACPYSRC,MSGHNDDSP2
      **--------------------------------------------------------------------------------------------
 
      *****************************************************************
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
      ********************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
      ** @FTR changed to display the appropriate footer message                             BUG23518
**  CPY@
(c) Misys International Banking Systems Ltd. 2001
**  @FTR
A=Amend D=Delete E=Enquire F3=Main Menu F9='Add' F11=Toggle Front Office Id
A=Amend D=Delete E=Enquire F3=Main Menu F9='Add' F11=Toggle Customer Shortname
A=Amend D=Delete E=Enquire F3=Main Menu F9='Add' F11=Toggle Customer Number
E=Enquire  F3=Main Menu  F11=Toggle Front Office Id
E=Enquire  F3=Main Menu  F11=Toggle Customer Shortname
E=Enquire  F3=Main Menu  F11=Toggle Customer Number
