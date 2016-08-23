     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2003')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas SD Collateralised Lending Initialisation Pgm')
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SD000006 - Collateralised Lending Initialisation Program     *
      *                                                               *
      *  Function:  This program defaults the value of the new fields *
      *             introduced by CLE025 in files SDPLINPD and        *
      *             SDCUSTPD.                                         *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2003            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Last Amend No. CSD031             Date 10Apr06               *
      *  Prev Amend No. CSW037A            Date 02May05               *
      *                 CSD025             Date 11Jan05               *
      *                 CSW037             Date 15Dec04               *
      *                 CSW036             Date 15Dec04               *
      *                 BUG3644            Date 12Jul04               *
      *                 BUG4544            Date 19Oct04               *
      *                 CLE025  *CREATE    Date 20Oct03               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSW037A- Additional Field extended to 40 chars (recompile)   *
      *  CSD025 - Customer De-Activation                              *
      *  CSW037 - Additional Field Data on MT300/MT320                *
      *  CSW036 - Dual SWIFT BIC held on Client Details               *
      *  BUG3644 - Serious Error in Collateralised Lending (Recompile)*
      *  BUG4544 - LEC000030 failed due to length of string operation *
      *            out of range                                       *
      *  CLE025 - Credit Lines                                        *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *    XX         Function of Indicator                           *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      *  SRProcess - Process files                                    *
      *  *INZSR    - Initialise                                       *
      *  *PSSR     - Error processing                                 *
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
 
      ** Instrument Types file
     FSDPLINPD  UF   E             DISK    INFSR(*PSSR)
 
      ** Customer Details file
     FSDCUSTPD  UF   E             DISK    INFSR(*PSSR)
 
      ** Collateral & Credit Control ICD file
     FSDCOCCPD  UF A E             DISK    INFSR(*PSSR)
 
      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ D-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
      ** Local data area for database error details
      ** *LOCK IN LDA immediately before and OUT LDA immediately
      ** after each database error handling.
      **                                    134 141 DBFILE
      **       Defines:                     142 170 DBKEY
      **                                    171 180 DBPGM
      **                                    181 1830DBASE
     D LDA           E DS           256    EXTNAME(LDA) DTAARA
 
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
 
      ** External DS for bank details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
                                                                                             BUG4544
      ** External DS for Switchable features file                                            BUG4544
     D SCSARD        E DS                  EXTNAME(SCSARDPD)                                 BUG4544
 
      ** First DS for access programs (short)
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
     D PRetCode        S              7
     D POption         S              7
     D WRun            S              1
     D PSar            S              6                                                      BUG4544
     D CGL014          S              1                                                      BUG4544
     D CFX001          S              1                                                      BUG4544
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--- Start of Main processing -------------------------------+
      ** ¦                                                            ¦
      ** ¦ Initial processing is performed automatically: the *INZSR  ¦
      ** ¦ is executed at program activation.                         ¦
      ** ¦                                                            ¦
      ** +------------------------------------------------------------+
 
      ** Process files
 
     C                   EXSR      SRProcess
 
      ** End program
 
     C                   EVAL      *INLR = *ON
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRProcess - Process files                                    *
      *                                                               *
      *****************************************************************
 
     C     SRProcess     BEGSR
 
      ** Set Facility Mandatory, Include Offsets, and Marginable
      ** flags to 'N' in SDPLINPD
 
     C                   READ      SDPLINPD
 
     C                   DOW       NOT %EOF(SDPLINPD)
 
     C                   EVAL      PDFCMF = 'N'
     C                   EVAL      PDINOF = 'N'
     C                   EVAL      PDMARG = 'N'
     C                   EVAL      PDIOPC = 'N'
 
     C                   UPDATE    SDPLINP0
 
     C                   READ      SDPLINPD
     C                   ENDDO
 
      ** Set Facility Mandatory and Include Offsets
      ** flags to 'N' in SDCUSTPD
 
     C                   READ      SDCUSTPD
 
     C                   DOW       NOT %EOF(SDCUSTPD)
 
     C                   EVAL      BBFCMF = 'N'
     C                   EVAL      BBINOF = 'N'
 
     C                   UPDATE    SDCUSTD0
 
     C                   READ      SDCUSTPD
     C                   ENDDO
 
      ** If no record found, write ICD record in SDCOCCPD
 
     C                   READ      SDCOCCPD
 
     C                   IF        %EOF(SDCOCCPD)
 
     C                   EVAL      CCCOCC = 'COCC'
     C**********         EVAL      CCFVFN = 'N'                                              BUG4544
     C                   EVAL      CCFVFN = 'Y'                                              BUG4544
     C                   EVAL      CCMCDO = *BLANK
     C                   EVAL      CCDCPS = *BLANK
     C                   EVAL      CCICED = *BLANK
     C                   EVAL      CCCAKG = *BLANK
     C                   EVAL      CCLCD  = BJRDNB
     C                   EVAL      CCTYLC = 'I'
                                                                                             BUG4544
     C                   IF        CGL014 = 'Y'                                              BUG4544
     C                   EVAL      CCDCPS = 'M'                                              BUG4544
     C                   EVAL      CCICED = 'Y'                                              BUG4544
     C                   EVAL      CCCAKG = 'Y'                                              BUG4544
     C                   ENDIF                                                               BUG4544
                                                                                             BUG4544
     C                   IF        CFX001 = 'Y'                                              BUG4544
     C                   EVAL      CCMCDO = 'Y'                                              BUG4544
     C                   ENDIF                                                               BUG4544
 
     C                   WRITE     SDCOCCD0
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *INZSR - Program Initialisation routine                      *
      *                                                               *
      *****************************************************************
 
     C     *INZSR        BEGSR
 
      ** Access bank details
 
     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANKS       PRetCode
     C                   PARM      '*FIRST '     POption
     C     SDBANK        PARM      SDBANK        DSFDY
 
      ** Database error
 
     C                   IF        PRetCode <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'SDBANKPD'
     C                   EVAL      DBKEY  = '*FIRST'
     C                   EVAL      DBASE  = 1
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
                                                                                             BUG4544
      ** Check if Collaterals Processing is installed                                        BUG4544
                                                                                             BUG4544
     C                   CALL      'AOSARDR0'                                                BUG4544
     C                   PARM      *BLANKS       PRetCode                                    BUG4544
     C                   PARM      '*VERIFY '    POption                                     BUG4544
     C                   PARM      'CGL014'      PSar                                        BUG4544
     C     SCSARD        PARM      SCSARD        DSFDY                                       BUG4544
                                                                                             BUG4544
     C                   IF        PRetCode = *BLANKS                                        BUG4544
     C                   EVAL      CGL014 = 'Y'                                              BUG4544
     C                   ELSE                                                                BUG4544
     C                   IF        PRetCode <> '*NRF   '                                     BUG4544
     C     *LOCK         IN        LDA                                                       BUG4544
     C                   EVAL      DBFILE = 'SCSARDPD'                                       BUG4544
     C                   EVAL      DBKEY  = 'CGL014'                                         BUG4544
     C                   EVAL      DBASE  = 2                                                BUG4544
     C                   OUT       LDA                                                       BUG4544
     C                   EXSR      *PSSR                                                     BUG4544
     C                   ENDIF                                                               BUG4544
     C                   ENDIF                                                               BUG4544
                                                                                             BUG4544
      ** Check if CFX001 is installed                                                        BUG4544
                                                                                             BUG4544
     C                   CALL      'AOSARDR0'                                                BUG4544
     C                   PARM      *BLANKS       PRetCode                                    BUG4544
     C                   PARM      '*VERIFY '    POption                                     BUG4544
     C                   PARM      'CFX001'      PSar                                        BUG4544
     C     SCSARD        PARM      SCSARD        DSFDY                                       BUG4544
                                                                                             BUG4544
     C                   IF        PRetCode = *BLANKS                                        BUG4544
     C                   EVAL      CFX001 = 'Y'                                              BUG4544
     C                   ELSE                                                                BUG4544
     C                   IF        PRetCode <> '*NRF   '                                     BUG4544
     C     *LOCK         IN        LDA                                                       BUG4544
     C                   EVAL      DBFILE = 'SCSARDPD'                                       BUG4544
     C                   EVAL      DBKEY  = 'CFX001'                                         BUG4544
     C                   EVAL      DBASE  = 3                                                BUG4544
     C                   OUT       LDA                                                       BUG4544
     C                   EXSR      *PSSR                                                     BUG4544
     C                   ENDIF                                                               BUG4544
     C                   ENDIF                                                               BUG4544
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *PSSR  - Program exception error routine                     *
      *           Called automatically if a program error occurs,     *
      *           or directly by the program code using EXSR.         *
      *           This subroutine DUMPs the program just once.        *
      *                                                               *
      *****************************************************************
 
     C     *PSSR         BEGSR
 
     C                   IF        WRun = *BLANK
     C                   EVAL      WRun = 'Y'
     C                   DUMP
     C                   CALL      'DBERRCTL'
     C                   ENDIF
 
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
 
     C                   RETURN
 
     C                   ENDSR
 
      *****************************************************************
