     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD Conversion program for CSD009')
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SD0009 - Midas SD Initialisation program for CSD009          *
      *                                                               *
      *  Function:  This module will initialise PF/SDPRFMPD, it will  *
      *             set new fields to asterisks.  This program needs  *
      *             to be run before the new PCA Default Matrix       *
      *             Priorities are defined on the GL ICD Maintenance  *
      *             and are defaulted to zero on SDGELRPD.            *
      *                                                               *
      *  Component of: SDC0009                                        *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.04 -----------------------------------------------*
      *  Last Amend No. CSD009  *CREATE    Date 10Oct00               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD009 - Profit Centre Accounting Default Matrix Enhancement *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *    01         End of file for PF/SDPRFMPD                     *
      *    02         Error in writing/updating record on file.       *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
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
 
     FSDGELRL0  UF   E           K DISK    INFSR(*PSSR)
 
     FSDPRFML1  UF   E           K DISK    INFSR(*PSSR)
 
     FSDFCTLL0  UF   E           K DISK    INFSR(*PSSR)
 
      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ D-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
     D LDA           E DS           256    EXTNAME(LDA)
      *
      ** Externally described DS for SAR details
     D SCSARD        E DS                  EXTNAME(SCSARDPD)
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
     D RUNDAT        E DS                  EXTNAME(RUNDAT)
      *
      ** Data Area giving Installation Control Details
      *
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
 
     D/COPY ZACPYSRC,PSDS
      *
      ** Program Status Data Structure
      *
      ** +-----------------------------------------------------------------+
      ** D specs of the following types should be inserted after the
      ** relevant box.  *** Remove this text afterwards. ***
      ** +-----------------------------------------------------------------+
      *
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
      *
      ** True and False can be used for indicators being on or off.
     D True            C                   *On
     D False           C                   *Off
      *
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
      *
      ** DS for access programs - short data structure
     D DSFDY         E DS                  EXTNAME(DSFDY)
      *
      ** Indicator Array
     D Indicators      DS                  BASED(IndicatorP)
     D  EndOfFile             01     01
     D  ErrOnFile             02     02
      *
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
      *
      ** Field for reseting matrix
     D WStars          S             10A   INZ('**********')
 
     D CSD009          S              1A
 
     D @RUN            S              1A
     D PMode           S              1A
 
     D PSARd           S              6A
     D PRtcd           S              7A
     D POptn           S              7A
      *
      ** Pointer for the indicator Array
     D IndicatorP      S               *   INZ(%Addr(*IN))
 
      *********************************************************************
      /EJECT
      *********************************************************************
      *
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
 
      *********************************************************************
      * MAIN PROCEDURE                                                    *
      *********************************************************************
      *
     C     *DTAARA       DEFINE                  RUNDAT
     C                   IN        RUNDAT
      *
      ** Initialise PCA- Default Matrix file SDPRFMPD.
      *
     C                   IF        CSD009 = 'Y' and PMode <> '3'
     C                   EXSR      SRIntPRFM
     C                   ENDIF
      *
      ** Initialise the fields on the General Ledger ICD SDGELRPD
      *
     C                   IF        CSD009 = 'Y' and PMode <> '3'
     C                   EXSR      SRIntGELR
     C                   ENDIF
      *
      ** Program termination
      *
     C                   EVAL      *INLR = *On
 
     C                   RETURN
      *
      *********************************************************************
      /EJECT
      *********************************************************************
      *                                                                   *
      *  SRIntPRFM - Initialise profit centre default matrix file         *
      *                                                                   *
      *********************************************************************
     C     SRIntPRFM     BEGSR
      *
      ** Access general ledger details for profit center default matrix
      *
     C     *LOVAL        SETLL     @BKREEB
     C                   READ      @BKREEB                                01
      *
      ** Read profit center default matrix file
      *
     C     *LOVAL        SETLL     @BKREEB
     C                   READ      @DWREHF                                01
      *
      ** Do while default matrix record exist
      *
     C                   DOW       EndOfFile = False
      *
      ** Local Industry Code
     C                   IF        BKLICD = '0' or BKLICD = *BLANK
     C                   MOVE      WStars        DWLICD
     C                   ENDIF
      *
      ** Bank/Non-Bank Indicator
     C                   IF        BKBNBI = '0' or BKBNBI = *BLANK
     C                   MOVE      WStars        DWBNBI
     C                   ENDIF
      *
      ** Country of Domicile
     C                   IF        BKCLOC = '0' or BKCLOC = *BLANK
     C                   MOVE      WStars        DWCLOC
     C                   ENDIF
      *
      ** Region of Domicile
     C                   IF        BKRLOC = '0' or BKRLOC = *BLANK
     C                   MOVE      WStars        DWRLOC
     C                   ENDIF
      *
      ** Country of Citizenship
     C                   IF        BKCNCZ = '0' or BKCNCZ = *BLANK
     C                   MOVE      WStars        DWCNCZ
     C                   ENDIF
      *
      ** Region of Citizenship
     C                   IF        BKRNCZ = '0' or BKRNCZ = *BLANK
     C                   MOVE      WStars        DWRNCZ
     C                   ENDIF
      *
      ** Customer Type
     C                   IF        BKCSTY = '0' or BKCSTY = *BLANK
     C                   MOVE      WStars        DWCSTY
     C                   ENDIF
      *
      ** Marketing Group Code 1
     C                   IF        BKGPC1 = '0' or BKGPC1 = *BLANK
     C                   MOVE      WStars        DWGPC1
     C                   ENDIF
      *
      ** Marketing Group Code 2
     C                   IF        BKGPC2 = '0' or BKGPC2 = *BLANK
     C                   MOVE      WStars        DWGPC2
     C                   ENDIF
      *
      ** Marketing Group Code 3
     C                   IF        BKGPC3 = '0' or BKGPC3 = *BLANK
     C                   MOVE      WStars        DWGPC3
     C                   ENDIF
      *
      ** Marketing Group Code 4
     C                   IF        BKGPC4 = '0' or BKGPC4 = *BLANK
     C                   MOVE      WStars        DWGPC4
     C                   ENDIF
      *
      ** Marketing Group Code 5
     C                   IF        BKGPC5 = '0' or BKGPC5 = *BLANK
     C                   MOVE      WStars        DWGPC5
     C                   ENDIF
      *
      ** Update last change type and last change date
      *
     C                   EVAL      DWTYLC = 'A'
     C                   EVAL      DWLCD = AGRDNB
      *
      ** Update file with new default fields reset to asterisks
     C                   UPDATE    @DWREHF                              02
      *
      ** Error occured on update, perform standard dberror processing
     C                   IF        ErrOnFile = True
     C     *LOCK         IN        LDA
     C                   EVAL      DBKey = '*KEY'
     C                   EVAL      DBFile = 'SDPRFMPD'
     C                   Z-ADD     02            DBase
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ** Read next record to process
     C                   READ      @DWREHF                                01
 
     C                   ENDDO
      *
      ** Update audit file with no of amends equal to number of records
      ** processed.
     C                   EVAL       AHFLNM = *BLANKS
     C                   EVAL       AHFLNM = 'SDPRFMPD'
     C     AHFLNM        CHAIN     @AHREAU                            01
      *
     C                   IF        EndofFile = False
     C                   EVAL      AHNOAM = AHNORC
     C                   UPDATE    @AHREAU
     C                   ENDIF
 
     C                   ENDSR
      *
      *********************************************************************
      /EJECT
      *********************************************************************
      *                                                                   *
      *  SRIntPRFM - Initialise profit centre default matrix file         *
      *                                                                   *
      *********************************************************************
     C     SRIntGELR     BEGSR
      *
      ** Access general ledger details for profit center default matrix
      *
     C     *LOVAL        SETLL     @BKREEB
     C                   READ      @BKREEB                                01
      *
      ** Local Industry Code
     C                   IF        BKLICD = *BLANK
     C                   EVAL      BKLICD = '0'
     C                   ENDIF
      *
      ** Bank/Non-Bank Indicator
     C                   IF        BKBNBI = *BLANK
     C                   EVAL      BKBNBI = '0'
     C                   ENDIF
      *
      ** Country of Domicile
     C                   IF        BKCLOC = *BLANK
     C                   EVAL      BKCLOC = '0'
     C                   ENDIF
      *
      ** Region of Domicile
     C                   IF        BKRLOC = *BLANK
     C                   EVAL      BKRLOC = '0'
     C                   ENDIF
      *
      ** Country of Citizenship
     C                   IF        BKCNCZ = *BLANK
     C                   EVAL      BKCNCZ = '0'
     C                   ENDIF
      *
      ** Region of Citizenship
     C                   IF        BKRNCZ = *BLANK
     C                   EVAL      BKRNCZ = '0'
     C                   ENDIF
      *
      ** Customer Type
     C                   IF        BKCSTY = *BLANK
     C                   EVAL      BKCSTY = '0'
     C                   ENDIF
      *
      ** Marketing Group Code 1
     C                   IF        BKGPC1 = *BLANK
     C                   EVAL      BKGPC1 = '0'
     C                   ENDIF
      *
      ** Marketing Group Code 2
     C                   IF        BKGPC2 = *BLANK
     C                   EVAL      BKGPC2 = '0'
     C                   ENDIF
      *
      ** Marketing Group Code 3
     C                   IF        BKGPC3 = *BLANK
     C                   EVAL      BKGPC3 = '0'
     C                   ENDIF
      *
      ** Marketing Group Code 4
     C                   IF        BKGPC4 = *BLANK
     C                   EVAL      BKGPC4 = '0'
     C                   ENDIF
      *
      ** Marketing Group Code 5
     C                   IF        BKGPC5 = *BLANK
     C                   EVAL      BKGPC5 = '0'
     C                   ENDIF
 
     C                   UPDATE    @BKREEB                              02
      *
      ** Error occured on update, perform standard dberror processing
     C                   IF        ErrOnFile = True
     C     *LOCK         IN        LDA
     C                   EVAL      DBKey = '*KEY'
     C                   EVAL      DBFile = 'SDGELRPD'
     C                   Z-ADD     03            DBase
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   ENDSR
      *
      *********************************************************************
      /EJECT
      *********************************************************************
      *                                                                   *
      * *INZSR - Program Initialisation routine                           *
      *                                                                   *
      * Called by: Implicitly on program activation                       *
      *                                                                   *
      * Calls: None                                                       *
      *                                                                   *
      *********************************************************************
 
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
      *
      ** Mode processing
     C                   PARM                    PMode
      *
      ** Read in Installation Data
      *
     C     *DTAARA       DEFINE                  LDA
     C     *LOCK         IN        LDA
     C                   EVAL      DBPGM  =  PSProcPgm
     C                   EVAL      DBMOD  =  PSProcMod
     C                   OUT       LDA
      *
      ** Access SAR file to determine if CSD009 (PCA Default Matrix
      ** enhancement) is installed.
      *
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       PRtcd
     C                   PARM      '*VERIFY'     POptn
     C                   PARM      'CSD009'      PSARd
     C     SCSARD        PARM      SCSARD        DSFDY
      *
      ** An NRF (No Record Found) return code is valid.
      ** Issue database error only for error return codes.
      *
     C                   IF        PRtcd <> *BLANKS AND PRtcd <> '*NRF   '
     C                   EVAL      DBKey = 'CSD009'
     C                   EVAL      DBFile = 'SCSARDPD'
     C                   Z-ADD     01            DBase
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   IF        PRtcd = *BLANK
     C                   EVAL      CSD009 = 'Y'
     C                   ELSE
     C                   EVAL      CSD009 = 'N'
     C                   ENDIF
      *
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
 
     C                   IF        @RUN = *BLANK
 
     C                   EVAL      @RUN = 'Y'
 
     C                   CALLB     'DBERRCTL'
 
     C                   ENDIF
 
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN
 
     C                   ENDSR
      *********************************************************************
      /EJECT
      *********************************************************************
      *
