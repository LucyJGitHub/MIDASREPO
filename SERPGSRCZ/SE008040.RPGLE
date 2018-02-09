     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SE PRICED Initialisation Program')               *
      *****************************************************************
      *                                                               *
      *  Midas - Securities Trading Module                            *
      *                                                               *
      *  SE008040 - PRICED and SEPRICPD Bid Price, Offer Price and    *
      *             Closing Price Fiels Setup for CSD010              *
      *                                                               *
      *  Function:  This module sets up the new field Closing Price   *
      *             equal to the Mid Price, and the fields Bid Price  *
      *             and Offer Price equal to zero when CSD010 is      *
      *             switched on.                                      *
      *                                                               *
      *  Component of: SEC008040                                      *
      *                                                               *
      *  (c) Finastra International Limited 2002                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CLE134             Date 01Aug12               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD027             Date 09Dec05               *
      *                 CAS006             Date 21Jan03               *
      * Midas Release 4.01 -------------------------------------------*
      *                 CSD010  *CREATE    Date 03May02               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CLE134 - Past Due Call Loan Processing (Recompile)           *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CAS006 - Hedge Accounting Phase B (Recompile)                *
      *  CSD010 - Collateralised Lending (Securities and FX Pricing)  *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *    XX         Function of indicator                           *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      * *PSSR - Error processing                                      *
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
 
     FPRICED    UF   E             DISK    INFSR(*PSSR)
      ** Midas SE Prices - Detail
 
     FSEPRICPD  UF   E             DISK    INFSR(*PSSR)
     F                                     PREFIX(S_)
      ** Midas SE Price Details
 
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
      **                                    184 193 DBMOD
      **                                    194 203 DBPROC
 
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
      ** Program Status Data Structure
 
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** First DS for Access Programs, short data structure
 
     D SCSARD        E DS                  EXTNAME(SCSARDPD)
     D  SCLCD        E                     EXTFLD(LCD)
      ** Midas Switchable Features Data Structure
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
     D CAC005          S              1A
     D PRetCode        S              7A
     D POption         S              7A
     D PSard           S              6A
 
     D WRun            S              1
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
 
      *****************************************************************
      * MAIN PROCEDURE                                                *
      *****************************************************************
 
      ** Initialize fields for PF/PRICED
 
     C                   READ      PRICED
 
     C                   DOW       NOT %EOF(PRICED)
     C                   EVAL      PRBDPR = *ZEROS
     C                   EVAL      PROFPR = *ZEROS
     C                   EVAL      PRCLPR = PPRC
     C                   UPDATE    PRICEDF
 
     C                   READ      PRICED
 
     C                   ENDDO
 
      ** Initialize fields for PF/SEPRICPD if CAC005 is installed
 
     C                   IF        CAC005 = 'Y'
 
     C                   READ      SEPRICPD
 
     C                   DOW       NOT %EOF(SEPRICPD)
     C                   EVAL      S_PRBDPR = *ZEROS
     C                   EVAL      S_PROFPR = *ZEROS
     C                   EVAL      S_PRCLPR = S_PPRC
     C                   UPDATE    SEPRICD0
 
     C                   READ      SEPRICPD
 
     C                   ENDDO
 
     C                   ENDIF
 
     C                   EVAL      *INLR = *ON
 
      *****************************************************************
      * *INZSR - Initial Processing                                   *
      *****************************************************************
 
     C     *INZSR        BEGSR
 
      ** Check if CAC005 is installed
 
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       PRetCode
     C                   PARM      '*VERIFY'     POption
     C                   PARM      'CAC005'      PSard
     C     SCSARD        PARM      SCSARD        DSFDY
 
     C                   EVAL      CAC005 = 'N'
     C                   IF        PRetCode <> *BLANKS AND
     C                             PRetCode <> '*NRF   '
     C                   EVAL      DBASE = 1
     C                   EVAL      DBKEY = 'CAC005'
     C                   EVAL      DBFILE = 'SCSARDPD'
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   IF        PRetCode = *BLANKS
     C                   EVAL      CAC005 = 'Y'
     C                   ENDIF
 
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
      * Called by: (**calling routines**)                             *
      *                                                               *
      * Calls: None                                                   *
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
