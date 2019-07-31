     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2004')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD EU W/H Tax Acc at Effective Date Drop')
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SD000775 - EU Withholding Tax Accruals at Effective Date Drop*
      *                                                               *
      *  Function:  This program will run at each end of month        *
      *             when CGL031 feature is switched on                *
      *             to drop the records from PF/GLETXAPD              *
      *             that have reached the retention period            *
      *             defined on the Tax Installation Control Data.     *
      *                                                               *
      *  (c) Finastra International Limited 2004                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. CGL031  *CREATE    Date 05Jul04               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CGL031 - Taxation of Savings Income                          *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *    25         Error in reading file SDSTAXL1                  *
      *    26         Error in reading file GLETXAPD                  *
      *    51         End of file for SDSTAXL1                        *
      *    52         End of file for GLETXAPD                        *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      * SRCALDIF - Subroutine to calculate diff of runday number and  *
      *             retention days.                                   *
      * *INZSR  - Initialise                                          *
      * *PSSR   - Error processing                                    *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
     FSDSTAXL1  IF   E           K DISK    INFSR(*PSSR)
 
     FGLETXAPD  UF   E             DISK    INFSR(*PSSR)
 
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
 
      ** Calculate difference of BJRDNB and TXRTNP
 
     C                   EXSR      SRCALDIF
 
      ** Set file pointer to first record and do initial read.
 
     C     1             SETLL     GLETXAPD
     C                   READ      GLETXAPD                               52
 
     C                   DOW       *IN52 = *OFF
 
      ** If the Tax Calculation Date is less than or equal to WDiff
      ** Physically delete record
 
     C                   IF        EAACDT <= WDiff
     C                   DELETE    GLETXAD0
     C                   ENDIF
 
     C                   READ      GLETXAPD                               52
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
      *             of BJRDNB & TXRTNP                                *
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
      ** Retrieve Retention Period
 
     C     *LOVAL        SETLL     SDSTAXL1
     C                   READ      SDSTAXL1                               51
 
      ** Database error if file is empty
 
     C                   IF        *IN51 = *ON
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
