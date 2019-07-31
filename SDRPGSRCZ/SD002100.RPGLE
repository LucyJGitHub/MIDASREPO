     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2012')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas SD Initialisation program for CMG003')           *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SD002100 - Midas SD Initialisation program for CMG003        *
      *                                                               *
      *  Function:  This program provides the default values of       *
      *             Commodity details                                 *
      *                                                               *
      *  (c) Finastra International Limited 2012                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CMG003  *CREATE    Date 04Oct12               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CMG003 - SWIFT MT600 Message Generation                      *
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
 
     FSDCURRPD  UF   E             DISK    INFSR(*PSSR)
      ** Midas SD Currency Codes File
 
     FSDCMDTL0  UF A E           K DISK    INFSR(*PSSR)
      ** Midas SD Commodity Details File Update
 
     FSDCMTPPD  IF   E           K DISK
      ** Midas SD Commodity Types File
 
     FSDPMRTPD  IF   E           K DISK
      ** Midas SD Precious Metal Currencies File
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +--------------------------------------+
      ** ¦ D-specs: Arrays and Data Structures  ¦
      ** ¦ =======  ==========================  ¦
      ** +--------------------------------------+
 
     D LDA           E DS                  EXTNAME(LDA) DTAARA(LDA)
      ** Local data area for database error details
 
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** External DS for Bank details
 
     D DSFDY         E DS                  EXTNAME(DSFDY)
     ** First DS for access programs, Short Data Structure
 
     D RUNDAT        E DS                  EXTNAME(RUNDAT)
     D                                     DTAARA(RUNDAT)
 
     D #1COMM        E DS                  EXTNAME(SDCMDTL0)
     D #2COMM        E DS                  EXTNAME(SDCMDTL0) PREFIX(#2)
 
     D PSDS           SDS
     D PSProcName        *PROC
     D PSJobName             244    253
     D PSUser                254    263
     D PSJobNo               264    269S 0
 
      ** +--------------------------------------+
      ** ¦ D-specs: Named constants             ¦
      ** ¦ =======  ===============             ¦
      ** +--------------------------------------+
      *
      ** +--------------------------------------+
      ** ¦ D-specs: Declared variables          ¦
      ** ¦ =======  ==================          ¦
      ** +--------------------------------------+
 
     D WRun            S              1A
     D PTimestamp      S               Z
     D PRtcd           S              7A
     D POptn           S              7A
     D #1PMTL          S              1A   INZ('N')
      *
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
 
      ** Read Currency Codes File
 
     C                   READ      SDCURRPD                               50
 
     C                   DOW       *IN50 = *OFF
 
      ** Initialise commodity details for Currencey code
      ** with Precious Metal Indicator set to Y and SWIFT
      ** Currency Code is equal to XAU, XAG, XPT and XPD
 
     C                   EVAL      #1PMTL = 'N'
     C     A6SWCY        SETLL     SDPMRTPD                           51
     C     A6SWCY        CHAIN     SDPMRTPD                           51
     C                   IF        *IN51 = '0'
     C                   EVAL      #1PMTL = 'Y'
     C                   ENDIF
 
     C                   IF        #1PMTL = 'Y' OR A6PMRT = 'Y'
 
     C                   IF        A6PMRT = 'N'
     C                   EVAL      A6PMRT = 'Y'
     C                   UPDATE    SDCURRD0
     C                   ENDIF
 
     C                   EXSR      SRINIT
     C                   EVAL      A6CMSN = A6CYCD + '-' + A6SWCY
 
     C     A6CMSN        SETLL     SDCMDTD0
     C     A6CMSN        CHAIN     SDCMDTL0                           51
 
     C                   EVAL      #2COMM = #1COMM
     C                   EVAL      A6CMCC = A6CYCD
     C                   EVAL      A6CMSC = A6SWCY
 
     C                   IF        A6CMTP = *BLANKS AND #1PMTL = 'Y'
     C                   EVAL      A6CMTP = A7CTYP
     C                   ENDIF
 
     C     A6CMTP        SETLL     SDCMTPPD                           90
     C     A6CMTP        CHAIN     SDCMTPPD                           90
     C                   IF        *IN90 = *OFF
     C                   EVAL      A6CMTD = A7CMTD
     C                   ENDIF
 
     C                   IF        A6CMUN = *BLANKS
     C                   EVAL      A6CMUN = 'LOT'
     C                   EVAL      A6CMUT = 'Lot'
     C                   ENDIF
 
      ** Write or Update Commodity details file
 
     C                   IF        %FOUND(SDCMDTL0)
     C                   IF        #1COMM <> #2COMM
     C                   EVAL      A6CMLT = 'A'
     C                   EXSR      SRCOMD
     C                   UPDATE    SDCMDTD0
     C                   ENDIF
     C                   ELSE
     C                   EVAL      A6CMLT = 'I'
     C                   EVAL      A6CMDN = *BLANKS
     C                   EVAL      A6CMFM = *BLANKS
     C                   EVAL      A6CMUD = *BLANKS
     C                   EVAL      A6CMFT = *BLANKS
     C                   EXSR      SRCOMD
     C                   WRITE     SDCMDTD0
     C                   ENDIF
     C                   ENDIF
 
     C                   READ      SDCURRPD                               50
     C
     C                   ENDDO
 
     C                   EVAL      *INLR = *ON
     C                   RETURN
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRINIT - Initialise Commodity detail fields                  *
      *                                                               *
      *****************************************************************
      *
     C     SRINIT        BEGSR
 
     C                   EVAL      A6CMSN = *BLANKS
     C                   EVAL      A6CMCC = *BLANKS
     C                   EVAL      A6CMSC = *BLANKS
     C                   EVAL      A6CMTP = *BLANKS
     C                   EVAL      A6CMTD = *BLANKS
     C                   EVAL      A6CMDN = *BLANKS
     C                   EVAL      A6CMFM = *BLANKS
     C                   EVAL      A6CMUN = *BLANKS
     C                   EVAL      A6CMUT = *BLANKS
     C                   EVAL      A6CMUD = *BLANKS
     C                   EVAL      A6CMFT = *BLANKS
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRCOMD - Commodity Other details                             *
      *                                                               *
      *****************************************************************
     C     SRCOMD        BEGSR
 
     C                   CALL      'ZAGENTS'
     C                   PARM                    PTimestamp
     C                   EVAL      A6CMTS = PTimestamp
     C                   EVAL      A6CMLD = AGRDNB
     C                   EVAL      A6CMJN = %CHAR(PSJobNo)
     C                   EVAL      A6CMJM = PSJobName
     C                   EVAL      A6CMJU = PSUser
     C                   EVAL      A6CZON = BJZONE
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *INZSR - Initial Processing                                  *
      *                                                               *
      *****************************************************************
      *
     C     *INZSR        BEGSR
 
     C                   CALL      'AOBANKR0'
     C                   PARM      '*DBERR '     PRtcd
     C                   PARM      '*FIRST '     POptn
     C     SDBANK        PARM      SDBANK        DSFDY
 
     C                   IN        RUNDAT
     C                   ENDSR
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
 
     C                   IF        WRun = *BLANKS
 
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
      /EJECT
      *****************************************************************
