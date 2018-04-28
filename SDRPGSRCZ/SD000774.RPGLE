     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2004')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD EU Withholding Tax Customer Income Drop')     *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SD000774 - EU Withholding Tax Customer Income Drop           *
      *                                                               *
      *  Function:  This program will run at each end of month        *
      *             when CGL032 feature is switched on                *
      *             to drop the records from PF/SDCSINPD              *
      *             that have reached the retention period            *
      *             defined on the Tax Installation Control Data.     *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2004            *
      *                                                               *
      *  Last Amend No. CER059             Date 19Jul10               *
      *  Prev Amend No. CER054             Date 07Apr09               *
      *                 BUG23123           Date 09Mar09               *
      *                 CER048             Date 19May08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD027A            Date 03May06               *
      *                 CGL032  *CREATE    Date 05Jul04               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER054 - German Features - Church Tax (Recompile)            *
      *  BUG23123 - Report: Does not show Retail Account Number       *
      *                     Date is not Midas Standard Date           *
      *                     Period should be actual int. calc. period *
      *                     Secondary Tax amount is not printed       *
      *                     Added field TSSLID                        *
      *                     (Recompile)                               *
      *  CER048 - German Features - Taxes (Recompile)                 *
      *  CSD027A - Conversion of customer number to alpha (post       *
      *            build 103). Recompiled.                            *
      *  CGL032 - Automatic Exchange of Information                   *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      * SRCALDIF - Subroutine to calculate difference                 *
      * *INZSR  - Initialise                                          *
      * *PSSR   - Error processing                                    *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
     FSDSTAXL1  IF   E           K DISK    INFSR(*PSSR)
 
     FSDCSINPD  UF   E             DISK    INFSR(*PSSR)
 
      ** +--------------------------------------+
      ** ¦ D-specs: Arrays and Data Structures  ¦
      ** ¦ =======  ==========================  ¦
      ** +--------------------------------------+
      ** Local data area for database error details
     D LDA           E DS           256    EXTNAME(LDA)
      ** The following fields are defined in the external file:
      **                                    134 141 DBFile
      **                                    142 170 DBKey
      **                                    171 180 DBPgm
      **                                    181 1830DBase
      **                                    184 193 DBMod
      **                                    194 203 DBProc
 
      ** External DS for Bank Details
     D SDBANK        E DS                  Extname(SDBANKPD)
 
      **  Short DS for access programs
     D DSFDY         E DS                  Extname(DSFDY)
 
      ** +--------------------------------------+
      ** ¦ D-specs: Declared variables          ¦
      ** ¦ =======  ==================          ¦
      ** +--------------------------------------+
 
      ** Parameters for access object programs
     D PRtcd           S              7
     D POptn           S              7
 
      ** Other fields used
     D WRun            S              1
     D WDiff           S              5  0 INZ(0)
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--- Start of Main processing -------------------------------+
      ** ¦                                                            ¦
      ** ¦ *INZSR is executed at program activation.                  ¦
      ** ¦                                                            ¦
      ** +------------------------------------------------------------+
      *****************************************************************
      * MAIN PROCEDURE                                                *
      *****************************************************************
 
      ** Calculate difference of BJRDNB and WRTNP
 
     C                   EXSR      SRCALDIF
 
      ** Set file pointer to first record and do initial read.
 
     C     1             SETLL     SDCSINPD
     C                   READ      SDCSINPD
 
      ** Read until a record is not found
 
     C                   DOW       NOT %EOF(SDCSINPD)
 
      ** If the Tax Calculation Date is less than or equal to WDiff
 
     C                   IF        TSEDAT <= WDiff
     C                   DELETE    SDCSIND0
     C                   ENDIF
 
     C                   READ      SDCSINPD
     C                   ENDDO
 
     C                   MOVE      *ON           *INLR
     C                   RETURN
      *****************************************************************
      *  P R O G R A M   E N D                                        *
      *****************************************************************
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRCALDIF - Subroutine to calculate difference                *
      *             of BJRDNB & WRTNP                                 *
      *                                                               *
      *  Called by:      Main processing                              *
      *                                                               *
      *  Calls:          None                                         *
      *                                                               *
      *****************************************************************
     C     SRCALDIF      BEGSR
 
     C                   EVAL      WDiff = BJRDNB - (TXRTNP * 30)
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *INZSR - Program Initialisation routine                      *
      *                                                               *
      *  Called by:      Implicitly on program activation             *
      *                                                               *
      *  Calls:          None                                         *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR
 
     C     *DTAARA       DEFINE                  LDA
 
      ** Access Bank details
      ** Retrieve Run day number
 
     C                   CALL      'AOBANKR0'
     C                   PARM      *Blanks       PRtcd
     C                   PARM      '*FIRST '     POptn
     C     SDBANK        PARM      SDBANK        DSFDY
 
      ** Database error 001
 
     C                   IF        PRtcd <> *Blanks
     C     *LOCK         IN        LDA
     C                   EVAL      DBKey = POptn
     C                   EVAL      DBFile = 'SDBANKPD'
     C                   EVAL      DBase = 001
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Set file pointer to first record and do initial read.
 
     C     *LOVAL        SETLL     SDSTAXL1
 
      ** Retrieve Retention Period
 
     C                   READ      SDSTAXL1
 
      ** Database error 003
 
     C                   IF        %EOF(SDSTAXL1)
     C     *LOCK         IN        LDA
     C                   MOVEL     'SDSTAXL1'    DBFILE
     C                   MOVEL     '*FIRST'      DBKEY
     C                   Z-ADD     002           DBASE
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
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
      *  Called by:      (**calling routines**)                       *
      *                                                               *
      *  Calls:          None                                         *
      *                                                               *
      *****************************************************************
     C     *PSSR         BEGSR
 
     C                   IF        WRun = *Blanks
     C                   MOVEL     'Y'           WRun
     C                   DUMP
     C                   ENDIF
 
     C                   MOVE      *ON           *INU7
     C                   MOVE      *ON           *INU8
     C                   MOVE      *ON           *INLR
     C                   RETURN
 
     C                   ENDSR
      *****************************************************************
