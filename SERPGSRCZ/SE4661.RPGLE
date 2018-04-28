     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2003')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas SE Statement Processing - Drop Historic')
      *****************************************************************
      *                                                               *
      *  Midas - Securities Strading Module                           *
      *                                                               *
      *  SE4661 - Midas SE Statement Production - Drop                *
      *           Historic details                                    *
      *                                                               *
      *  Called By: SEC4661 - Statement Production - Drop Historic    *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2003            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Last Amend No. CSE040  *CREATE    Date 11Apr03               *
      *  Prev Amend No.                    Date ddmmmyy               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSE040 - Securities Statement Processing                     *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *    XX         Function of Indicator                           *
      *    98         Date Format                                     *
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
 
     FSESTHSL0  UF   E           K DISK
      ** Midas SE Statement History by Message Reference
 
     FSERQSTL0  UF   E           K DISK
      ** Midas SE Request of SE Statement
 
     FSERSTRL0  UF   E           K DISK
      ** Midas SE Request of SE Statement - Status/Reference code
 
      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ D-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
     D LDA           E DS           256    EXTNAME(LDA)
      *
      ** Local data area for database error details
      ** *LOCK IN LDA immediately before and OUT LDA immediately
      ** after each database error handling.
      **
      **                                    134 141 DBFILE
      **       Defines:                     142 170 DBKEY
      **                                    171 180 DBPGM
      **                                    181 1830DBASE
      *
     D RUNDAT        E DS                  EXTNAME(RUNDAT)
      *
      ** Data Area giving Installation Control Details
 
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
 
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
     D SDMGME        E DS                  EXTNAME(SDMGMEPD)
      **  Data structure for message management data.
 
     D DSFDY         E DS                  EXTNAME(DSFDY)
      **  Second DS for access programs, short data structure.
 
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
     D @RUN            S              1
     D WkECDT          S              5  0                                      Event Control Date
 
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
 
      *********************************************************************
      * MAIN PROCEDURE                                                    *
      *********************************************************************
 
      ** Statement Production request
 
     C     *LOVAL        SETLL     SESTHSL0
     C                   READ      SESTHSL0
 
     C                   DOW       NOT %EOF(SESTHSL0)
 
      ** If the preparation date is less than the event control date, delete the record
 
     C                   IF        SHPRDT < WkECDT
     C                   DELETE    SESTHSD0
     C                   ENDIF
 
     C                   READ      SESTHSL0
     C                   ENDDO
 
      ** Request of statement.
 
     C     *LOVAL        SETLL     SERQSTL0
     C                   READ      SERQSTL0
 
     C                   DOW       NOT %EOF(SERQSTL0)
 
      ** If the last change date is less than the event control date (with message reference),
      ** or request has been deleted,
      ** Suppress the request.
 
     C                   IF        RQLCD  < WkECDT AND RQMREF <> *BLANKS
     C                             OR RQCHTP = 'D'
 
      ** Suppress Status/Reference code details
 
     C                   DOU       NOT %FOUND(SERSTRL0)
     C     KlRequest     DELETE    SERSTRD0
     C                   ENDDO
 
      ** Suppress the request
 
     C                   DELETE    SERQSTD0
     C                   ENDIF
 
     C                   READ      SERQSTL0
     C                   ENDDO
 
     C                   EVAL      *INLR = *ON
     C                   RETURN
 
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
 
      ** Read in Installation Data
 
     C     *DTAARA       DEFINE                  RUNDAT
     C     *DTAARA       DEFINE                  LDA
     C                   IN        RUNDAT
 
      ** Set Date Format Indicator *IN98  on if date format is MMDDYY
 
     C                   IF        AGDFF = 'M'
     C                   EVAL      *IN98 = *ON
     C                   END
 
      ** Access SDMGMEPD for message management data.
 
     C                   CALL      'AOMGMER0'                           99
     C                   PARM      *BLANKS       P@RTCD            7            Return Code
     C                   PARM      '*FIRST '     P@OPTN            7            Option
     C     SDMGME        PARM      SDMGME        DSFDY
 
     C                   IF        *IN99
     C                             OR P@RTCD <> *BLANKS
     C                   EVAL      ENDSMN = 31
     C                   ENDIF
 
      ** Retrieve the event control date
 
     C                   EVAL      WkECDT = AGRDNB - ENDSMN
 
      ** Key list to access the Status/Reference code details
 
     C     KlRequest     KLIST
     C                   KFLD                    RQDATE
     C                   KFLD                    RQRSEQ
 
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
      *****************************************************************
      *
     C     *PSSR         BEGSR
      *
     C                   IF        @RUN = *BLANK
     C                   EVAL      @RUN = 'Y'
     C                   DUMP
     C                   ENDIF
      *
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN
      *
     C                   ENDSR
      *
