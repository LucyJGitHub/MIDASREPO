     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2009')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas SD Initialisation program for CSW209')
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SD000041 - Midas SD Initialisation program for CSW209        *
      *                                                               *
      *  Function:  This program removes records from SDIDTPPD with   *
      *             SWIFT Identification Code = 'IBEI' and update     *
      *             SDFCTLPA with the total number of records and     *
      *             total number of amends in SDIDTPPD                *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2009            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      *  Last Amend No. CSW209  *CREATE    Date 01Apr09               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSW209 - SWIFT 2009 Changes                                  *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *    U7 - Database Error                                        *
      *    U8 - Database Error                                        *
      *    LR - Last record found                                     *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      ** Midas SD Identification Types
     FSDIDTPPD  UF   E             DISK    INFSR(*PSSR)
      ** Midas SD Standing Data Controls
     FSDFCTLL0  UF   E           K DISK    INFSR(*PSSR)
 
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +--------------------------------------+
      ** ¦ D-specs: Arrays and Data Structures  ¦
      ** ¦ =======  ==========================  ¦
      ** +--------------------------------------+
 
      ** Array containing Copyright statement
     D CPY@            S             80    DIM(1) CTDATA PERRCD(1)
 
      ** Local data area for database error details
     D LDA           E DS                  EXTNAME(LDA) DTAARA(LDA)
 
      ** Program Status Data Structure
     D PSDS           SDS
     D  PSProcName       *PROC
     D  PSPgmStat        *STATUS
     D  PSJobName            244    253
     D  PSUser               254    263
     D  PSProcPgm            334    343
     D  PSProcMod            344    353
 
      ** Short Access Object Data Structure
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      ** Bank Details Data Structure
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
 
      ** +--------------------------------------+
      ** ¦ D-specs: Named constants             ¦
      ** ¦ =======  ===============             ¦
      ** +--------------------------------------+
      *
      *
      ** +--------------------------------------+
      ** ¦ D-specs: Declared variables          ¦
      ** ¦ =======  ==================          ¦
      ** +--------------------------------------+
 
      *
      ** Access Object Parameters
     D PRtCd           S              7A
     D POptn           S              7A
     D WRun            S              1A
      *
      ** Work fields
     DCtr1             S              5  0
     DKHFLNM           S             10A
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
      ** ¦ *INZSR is executed at program activation.                  ¦
      ** ¦                                                            ¦
      ** +------------------------------------------------------------+
      *
      *****************************************************************
      * MAIN PROCEDURE                                                *
      *****************************************************************
      *
      ** Update Swift code = 'IBEI' to blanks
      *
     C                   EXSR      CLRCNT
      *
      ** Update trailer file for amended records
      *
     C                   IF        Ctr1 > 0
     C                   EXSR      UPDCNT
     C                   ENDIF
      *
     C                   EVAL      *INLR = *ON
     C                   RETURN
      *****************************************************************
      *  CLRCNT - This subroutine will clear values of IDSWCD if its  *
      *           value = 'IBEI'. This will also count the total      *
      *           number of records in files and total number of      *
      *           amends during program initialisation.               *
      *                                                               *
      *  Calls by : Main Processing                                   *
      *****************************************************************
     C     CLRCNT        BEGSR
     C                   EVAL      Ctr1 = 0
     C     1             SETLL     SDIDTPD0
     C                   READ      SDIDTPD0
     C                   DOW       NOT %EOF
     C                   IF        IDSWCD = 'IBEI'
     C                   EVAL      IDSWCD = *BLANKS
     C                   EVAL      IDCHTP = 'A'
     C                   EVAL      IDLCDT = BJRDNB
     C                   ADD       1             Ctr1
     C                   UPDATE    SDIDTPD0
     C                   ENDIF
     C                   READ      SDIDTPD0
     C                   ENDDO
     C                   ENDSR
      *****************************************************************
      *  UPDCNT - This subroutine will update the values of AHNOAM    *
      *           in SDFCTLPA due to the amendments in SDIDTPPD.      *
      *                                                               *
      *  Calls by : Main Processing                                   *
      *****************************************************************
     C     UPDCNT        BEGSR
     C                   MOVEL     'SDIDTPPD'    KHFLNM
     C     KHFLNM        CHAIN     @AHREAU                            10
     C                   IF        *IN10 = *ON
     C     *LOCK         IN        LDA
     C                   EVAL      DBFile = 'SDFCTLL0'
     C                   EVAL      DBase = 21
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ELSE
     C                   EVAL      AHNOAM = AHNOAM + Ctr1
     C                   UPDATE    @AHREAU
     C                   ENDIF
     C                   ENDSR
      *****************************************************************
      *  P R O G R A M   E N D                                        *
      *****************************************************************
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *PSSR - Program exception error routine                      *
      *                                                               *
      *  Called By: Automatically if a program error occurs,          *
      *             or directly by the program code using EXSR.       *
      *             This subroutine DUMPs the program just once.      *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
      *
     C     *PSSR         BEGSR
      *
     C                   IF        WRun = *BLANKS
      *
     C                   EVAL      WRun = 'Y'
     C                   DUMP
      *
     C                   CALL      'DBERRCTL'
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
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *INZSR - Program Initialisation Subroutine.                  *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR
     C
     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANKS       PRtCd
     C                   PARM      '*FIRST '     POptn
     C     SDBANK        PARM      SDBANK        DSFDY
 
     C                   IF        PRtCd <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFile = 'SDBANKPD'
     C                   EVAL      DBase = 101
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2009
