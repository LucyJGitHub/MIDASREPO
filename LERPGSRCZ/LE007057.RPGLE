     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2013')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas LE Manual utilisation - PDCL rerun')             *
      *****************************************************************
      *                                                               *
      *  Midas - Customer Lending Module                              *
      *                                                               *
      *  LE007057 - Midas LE Manual facility utilisation rerun        *
      *                                                               *
      *  Function:  This module will update FCLTYFN for existing MFUs.*
      *  (COB)      During rerun of LE0491 (called on LEC06A) CAMD,   *
      *             PEXP, CEXP and OAM,x are recalculated for each    *
      *             facilities. Since LE0495 is no longer called on   *
      *             PDCL components, MFU's are not considered on the  *
      *             new facility exposure or availability.            *
      *             - This program is based on LE0495 and will only   *
      *             update FCLTYFN.                                   *
      *                                                               *
      *  Called By: LEC0609A - Midas LE Events File Creation          *
      *                                                               *
      *  (c) Finastra International Limited 2013                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. AR1042505 *CREATE  Date 19Mar13               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  AR1042505 - MFU is not included on rebuild of fclty exposure.*
      *              Create a new function to update FCLTYFN for MFU  *
      *              events. This will be called on rerun of Lending  *
      *              components for PDCL processing.(Child: AR1042506)*
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *    01         Read LEMFUXPD                                   *
      *    02         Chain FCLTYFM                                   *
      *    03         Chain FCLTYFN                                   *
      *    04         Read HISUPD/FACHISA                             *
      *    71-72      LOOKUP indicator                                *
      *    U7-U8      Error found                                     *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      * SRDETL - Process MFU records                                  *
      * SRAVAI - Compute for facility exposure                        *
      * SRCAAV - Compute for Credit agreement exposure                *
      * SRCURR - Get currency details                                 *
      * *PSSR  - Error processing                                     *
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
      **   F-specs
      **   =======
      ** +--------------------------------------+
 
     FLEMFUXPD  IF   E             DISK    INFSR(*PSSR)
     F                                     PREFIX(MF_)
 
     FFCLTY     UF   E           K DISK    INFSR(*PSSR)
     F                                     IGNORE(FCLTYHHF)
     F                                     IGNORE(FCLTYZZF)
 
     FPEFCLFL1  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(FCLTYFMF:PEFCLFLF)
 
     FHISUPD    IF   E           K DISK    INFSR(*PSSR)
     F                                     IGNORE(HISACTF)
     F                                     PREFIX(H_)
 
      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--------------------------------------+
      **   D-specs
      **   =======
      ** +--------------------------------------+
     D POWR            S              7  3 DIM(7) CTDATA PERRCD(1)
     D WOAM            S             13  0 DIM(10)
      *
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
      ** Data Area giving Installation Control Details
 
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      **  External DS for Bank Details
      *
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
      **  External DS for Currency Details
      *
     D SDGELR        E DS                  EXTNAME(SDGELRPD)
      **  External DS for General Ledger Details
      *
     D SCSARD        E DS                  EXTNAME(SCSARDPD)
      ** SAR file details accessed via access program AOSARDR0
      *
     D DSFDY         E DS                  EXTNAME(DSFDY)
      **  First DS for access programs, short data structure
      *
     D DSSDY         E DS                  EXTNAME(DSSDY)
      **  Second DS for access programs, long data structure
      *
 
      ** The following /COPY line includes all the defined fields in
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
      ** Program Status Data Structure
 
      ** +--------------------------------------+
      **   Arrays and Data Structures
      **   ==========================
      ** +--------------------------------------+
 
     D  WKEY1                  1     11
     D  K1CNUM                 1      6
     D  K1FACT                 7      9  0
     D  K1FCNO                10     11  0
     D  K1FCTY                 7     11  0
 
     D                 DS
     D  RUN0                   1      3P 0
     D  RUN1                   4      6P 0
     D  RUN2                   7      9P 0
     D  RUN3                  10     12P 0
     D  RUN4                  13     15P 0
     D  RUN5                  16     18P 0
     D  RUN6                  19     21P 0
     D  RUN7                  22     24P 0
     D  RUN8                  25     27P 0
     D  RUN9                  28     30P 0
     D  RUNS                   1     30P 0
     D                                     DIM(10) ASCEND
 
     D                 DS
     D  OAM1                   1      7P 0
     D  OAM2                   8     14P 0
     D  OAM3                  15     21P 0
     D  OAM4                  22     28P 0
     D  OAM5                  29     35P 0
     D  OAM6                  36     42P 0
     D  OAM7                  43     49P 0
     D  OAM8                  50     56P 0
     D  OAM9                  57     63P 0
     D  OA10                  64     70P 0
     D  OAM                    1     70P 0
     D                                     DIM(10)
 
 
      ** +--------------------------------------+
      **   Declared variables
      **   ==================
      ** +--------------------------------------+
 
     D @RUN            S              1
     D CLE014          S              1
     D CLE023          S              1
     D WECD            S              5  0
     D ACTAMT          S             13P 0
     D WFCCY           S              3
     D WCACY           S              3
     D WCMDI           S              1
     D WCAXR           S             13  8
     D WRVCR           S              1
     D WBASE           S              3  0
     D WCCY            S              3
     D WBKEY           S             29
     D FCDP            S              1  0
     D K1BRCA          S              3
     D K1RCTP          S              1
     D WSCNUM          S              6
     D WSFACT          S              3  0
     D WSFCNO          S              2  0
 
     D ZRATE1          S             13P 8
     D ZMDI1           S              1
     D ZRATE2          S             13P 8
     D ZMDI2           S              1
     D ZRATEX          S             13P 8
     D ZMDIX           S              1
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--- Start of Main processing -------------------------------+
      **
      **   Initial processing is performed automatically: *INZSR is
      **   executed at program activation.
      **
      ** +------------------------------------------------------------+
 
      *****************************************************************
      * MAIN PROCEDURE                                                *
      *****************************************************************
 
     C                   READ      LEMFUXPD                               01
 
     C                   DOW       *IN01 = '0'
      *
      ** Perform Detail and Update Processing.
      *
     C                   IF        MF_RECI = 'D' or
     C                             (MF_RECI = 'R' and MF_ORED <> BJRDNB)
     C                   EXSR      SRDETL
     C                   ENDIF
      *
     C                   READ      LEMFUXPD                               01
     C                   ENDDO
 
     C                   EVAL      *INLR = '1'
     C                   RETURN
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRDETL - Detail processing                                    *
      *                                                               *
      *****************************************************************
     C     SRDETL        BEGSR
 
     C                   MOVEA     *ZEROS        WOAM
     C                   EVAL      K1BRCA = MF_BRCA
     C                   EVAL      K1CNUM = MF_CNUM
     C                   EVAL      K1FACT = MF_FACT
     C                   EVAL      K1FCNO = MF_FCNO
      *
      ** Retrieve the facility details used by manual utilisation.
      *
     C     K#KY01        CHAIN     FCLTYFMF                           02
      *
     C                   IF        *IN02 = '1'
     C     K#KY03        CHAIN     PEFCLFLF                           02
     C                   ENDIF
      *
     C                   IF        *IN02 = '1'
     C                   MOVEL     'FCLTY'       DBFILE
     C                   Z-ADD     003           DBASE
     C                   MOVEL     WKEY1         DBKEY
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ** Only process MFU records that are not equal to 'R'.
      *
     C                   IF        MF_RECI <> 'R'
      *
      ** Update Availability arrays.
      *
     C                   EXSR      SRAVAI
      *
     C                   IF        TRCA = 'TR'
      *
     C                   EVAL      K1CNUM = CANM
     C                   EVAL      K1FACT = CAFT
     C                   EVAL      K1FCNO = CAFN
     C                   EVAL      WFCCY  = FCCY
     C                   EVAL      WCACY  = CACY
     C                   EVAL      WCAXR  = CAXR
     C                   EVAL      WCMDI  = CMDI
      *
      ** Save the revolving credit indicator of the tranche.
      *
     C                   EVAL      WRVCR = RVCR
      *
      ** Update Credit Agreement Availability.
      *
     C                   EXSR      SRCAAV
     C                   ENDIF
      *
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRAVAI - Update Availability Processing                       *
      *                                                               *
      *****************************************************************
     C     SRAVAI        BEGSR
 
     C                   IF        MF_UCCY <> FCCY
      *
      ** Convert utilisation amount using utilisation exchange rate
      ** if Utilisation Currency is not equal to Facility Currency
      *
      ** Obtain decimal places of the two currencies.
      *
     C                   EVAL      WCCY = FCCY
     C                   EVAL      WBASE = 16
     C                   MOVEL     FCCY          WBKEY
     C                   EXSR      SRCURR
 
     C                   EVAL      FCDP = A6NBDP
      *
      ** If CLE023 is installed, save currency spot rate for update of
      ** Current Exposure.
      *
     C                   IF        CLE023 = 'Y'
     C                   EVAL      ZMDI2  = A6MDIN
     C                   EVAL      ZRATE2 = A6SPRT
     C                   ENDIF
      *
     C                   EVAL      WCCY = MF_UCCY
     C                   EVAL      WBASE = 17
     C                   MOVEL     MF_UCCY       WBKEY
     C                   EXSR      SRCURR
      *
      ** If CLE023 is installed, save currency spot rate for update of
      ** Current Exposure.
      *
     C                   IF        CLE023 = 'Y'
     C                   EVAL      ZMDI1  = A6MDIN
     C                   EVAL      ZRATE1 = A6SPRT
     C                   ENDIF
      *
     C     FCDP          SUB       A6NBDP        DP                1 0
     C                   ADD       4             DP
     C     MF_UXID       IFEQ      'D'
     C     MF_UXRT       DIV(H)    POWR(DP)      FUXRT            15 9
     C     1             DIV       FUXRT         FUXRT
     C                   ELSE
     C     MF_UXRT       MULT(H)   POWR(DP)      FUXRT
     C                   ENDIF
     C     MF_UAMT       MULT(H)   FUXRT         CONAMT           13 0
      *
      ** If CLE023 is installed, calculate utilisation amount based
      ** on spot rate.
      *
     C                   IF        CLE023 = 'Y'
      *
      ** Get cross exchange rate of utilisation ccy and facility ccy.
      *
     C                   CALL      'ZXRATE'
     C                   PARM                    ZRATE1
     C                   PARM                    ZMDI1
     C                   PARM                    ZRATE2
     C                   PARM                    ZMDI2
     C                   PARM                    ZRATEX
     C                   PARM                    ZMDIX
      *
      ** If MFU is in base currency, use facility ccy spot rate.
      *
     C                   IF        MF_UCCY = BJCYCD
     C                   EVAL      ZRATEX = ZRATE2
     C                   IF        ZMDI2 = 'D'
     C                   EVAL      ZMDIX = 'M'
     C                   ELSE
     C                   EVAL      ZMDIX = 'D'
     C                   ENDIF
     C                   ENDIF
      *
      ** Compute equivalent UAMT in currencies' spot rates.
      *
     C     ZMDIX         IFEQ      'D'
     C     ZRATEX        DIV(H)    POWR(DP)      WUXRT            15 9
     C     1             DIV       WUXRT         WUXRT
     C                   ELSE
     C     ZRATEX        MULT(H)   POWR(DP)      WUXRT
     C                   ENDIF
     C     MF_UAMT       MULT(H)   WUXRT         WCNAMT           13 0
      *
     C                   ENDIF
      *
      ** If the same currencies:
      *
     C                   ELSE
     C                   EVAL      CONAMT = MF_UAMT
      *
     C                   IF        CLE023 = 'Y'
     C                   EVAL      WCNAMT = MF_UAMT
     C                   ENDIF
      *
     C                   ENDIF
      *
      ** Do update of FCLTYFN.
      *
     C                   EVAL      K1CNUM = MF_CNUM
     C                   EVAL      K1FACT = MF_FACT
     C                   EVAL      K1FCNO = MF_FCNO
     C                   EVAL      K1RCTP = 'B'
     C     K#KY02        CHAIN     FCLTYFNF                           03
      *
     C                   IF        *IN03 = '0'
      *
     C                   Z-ADD     1             X                 2 0
     C     MF_STDT       LOOKUP    RUNS(X)                            71  71
     C     *IN71         IFEQ      '1'
     C     X             DOWLE     10
     C                   ADD       CONAMT        WOAM(X)
     C                   ADD       1             X
     C                   ENDDO
     C                   ENDIF
      *
     C                   Z-ADD     1             X
     C     MF_EXDT       IFNE      0
     C     MF_EXDT       LOOKUP    RUNS(X)                            72  72
     C     *IN72         IFEQ      '1'
     C     RVCR          ANDEQ     'Y'
     C     *IN72         OREQ      '1'
     C     MF_EXDT       ANDLE     WECD
     C     X             DOWLE     10
     C                   SUB       CONAMT        WOAM(X)
     C                   ADD       1             X
     C                   ENDDO
     C                   ENDIF
     C                   ENDIF
      *
     C                   Z-ADD     1             X
     C     X             DOWLE     10
     C                   ADD       WOAM(X)       OAM(X)
     C                   ADD       1             X
     C                   ENDDO
      *
     C                   IF        MF_EXDT > BJDNWD
     C                             and MF_STDT <= BJDNWD
     C                             OR (MF_EXDT = 0 and MF_STDT <= BJDNWD)
     C                   EVAL      CAMD += CONAMT
      *
      ** If CLE023 is installed, update Current Exposure field.
      *
     C                   IF        CLE023 = 'Y'
     C                   EVAL      CEXP += WCNAMT
     C                   ENDIF
      *
     C                   ENDIF
      *
      ** This block of codes is to get the amount from FACHISA for
      ** update of PEXP. In LE0495 if MFU start date is less than
      ** rundate, recalculation is always triggered in FACHISH.
      ** In LER032, PEXP is updated with the recalculated FADRAM
      ** provided that FACACT exist.
      *
     C                   IF        MF_STDT < BJRDNB and CLE023 = 'Y'
     C     K#KY04        SETGT     HISUPD
     C     K#KY04        READPE    HISUPD                                 04
     C                   IF        *IN04 = '0'
     C                   Z-ADD     H_FADRAM      PEXP
     C                   ENDIF
     C                   ENDIF
      *
     C                   UPDATE    FCLTYFNF
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRCAAV - Credit Agreement Availability Processing             *
      *                                                               *
      *****************************************************************
     C     SRCAAV        BEGSR
 
     C     K#KY01        CHAIN     FCLTYFMF                           02
      *
     C                   IF        *IN02 = '1'
     C                   MOVEL     'FCLTY'       DBFILE
     C                   Z-ADD     009           DBASE
     C                   MOVEL     WKEY1         DBKEY
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   EVAL      K1BRCA = BRCA
     C                   EVAL      WSCNUM = CNUM
     C                   EVAL      WSFACT = FACT
     C                   EVAL      WSFCNO = FCNO
      *
     C                   IF        WFCCY <> WCACY
      *
     C                   IF        MF_UCCY = WCACY
     C                   EVAL      CONCAA = MF_UAMT
     C                   ELSE
      *
      ** Convert CONAMT using Credit Agreement Exchange Rate.
      *
     C                   EVAL      WCCY = WFCCY
     C                   EVAL      WBASE = 10
     C                   MOVEL     WFCCY         WBKEY
     C                   EXSR      SRCURR
      *
     C                   EVAL      FCDP = A6NBDP
      *
      ** If CLE023 is installed, save currency spot rate for update of
      ** Current Exposure.
      *
     C                   IF        CLE023 = 'Y'
     C                   EVAL      ZMDI1  = A6MDIN
     C                   EVAL      ZRATE1 = A6SPRT
     C                   ENDIF
      *
     C                   EVAL      WCCY = WCACY
     C                   EVAL      WBASE = 11
     C                   MOVEL     WCACY         WBKEY
     C                   EXSR      SRCURR
      *
      ** If CLE023 is installed, save currency spot rate for update of
      ** Current Exposure.
      *
     C                   IF        CLE023 = 'Y'
     C                   EVAL      ZMDI2  = A6MDIN
     C                   EVAL      ZRATE2 = A6SPRT
     C                   ENDIF
      *
     C     A6NBDP        SUB       FCDP          DP
     C                   ADD       4             DP
     C     WCMDI         IFEQ      'D'
     C     WCAXR         DIV(H)    POWR(DP)      FCAXR            15 9
     C     1             DIV       FCAXR         FCAXR
     C                   ELSE
     C     WCAXR         MULT(H)   POWR(DP)      FCAXR
     C                   ENDIF
     C     CONAMT        MULT(H)   FCAXR         CONCAA           13 0
      *
      ** If CLE023 is installed, calculate utilisation amount based
      ** on spot rate.
      *
     C                   IF        CLE023 = 'Y'
      *
      ** Get cross exchange rate of utilisation ccy and facility ccy.
      *
     C                   CALL      'ZXRATE'
     C                   PARM                    ZRATE1
     C                   PARM                    ZMDI1
     C                   PARM                    ZRATE2
     C                   PARM                    ZMDI2
     C                   PARM                    ZRATEX
     C                   PARM                    ZMDIX
      *
      ** If Tranche is in base currency, use CA ccy spot rate.
      *
     C                   IF        WFCCY  = BJCYCD
     C                   EVAL      ZRATEX = ZRATE2
     C                   IF        ZMDI2 = 'D'
     C                   EVAL      ZMDIX = 'M'
     C                   ELSE
     C                   EVAL      ZMDIX = 'D'
     C                   ENDIF
     C                   ENDIF
      *
     C     ZMDIX         IFEQ      'D'
     C     ZRATEX        DIV(H)    POWR(DP)      WFXRT
     C     1             DIV(H)    WFXRT         WFXRT
     C                   ELSE
     C     ZRATEX        MULT(H)   POWR(DP)      WFXRT            15 9
     C                   ENDIF
     C     CONAMT        MULT(H)   WFXRT         WCNCAA           13 0
     C                   ENDIF
      *
     C                   ENDIF
      *
      ** If the same currency:
      *
     C                   ELSE
     C                   EVAL      CONCAA = CONAMT
      *
     C                   IF        CLE023 = 'Y'
     C                   EVAL      WCNCAA = CONAMT
     C                   ENDIF
      *
     C                   ENDIF
     C                   MOVEA     *ZEROS        WOAM
      *
      ** Do update of CA FCLTYFN.
      *
     C                   EVAL      K1CNUM = WSCNUM
     C                   EVAL      K1FACT = WSFACT
     C                   EVAL      K1FCNO = WSFCNO
     C                   EVAL      K1RCTP = 'B'
     C     K#KY02        CHAIN     FCLTYFNF                           03
      *
     C                   IF        *IN03 = '0'
      *
     C                   Z-ADD     1             X
     C     STDT          LOOKUP    RUNS(X)                            71  71
     C     *IN71         IFEQ      '1'
     C     X             DOWLE     10
     C                   ADD       CONCAA        WOAM(X)
     C                   ADD       1             X
     C                   ENDDO
     C                   ENDIF
      *
     C                   Z-ADD     1             X
     C     MF_EXDT       IFNE      0
     C     MF_EXDT       LOOKUP    RUNS(X)                            72  72
     C     *IN72         IFEQ      '1'
     C     RVCR          ANDEQ     'Y'
     C     *IN72         OREQ      '1'
     C     RVCR          ANDEQ     'T'
     C     WRVCR         ANDEQ     'Y'
     C     *IN72         OREQ      '1'
     C     MF_EXDT       ANDLE     WECD
     C     X             DOWLE     10
     C                   SUB       CONCAA        WOAM(X)
     C                   ADD       1             X
     C                   ENDDO
     C                   ENDIF
     C                   ENDIF
      *
      ** Move updated drawn amounts into OAM fields.
      *
     C                   Z-ADD     1             X
     C     X             DOWLE     10
     C                   ADD       WOAM(X)       OAM(X)
     C                   ADD       1             X
     C                   ENDDO
      *
     C                   IF        MF_EXDT > BJDNWD
     C                             and MF_STDT <= BJDNWD
     C                             OR (MF_EXDT = 0 and MF_STDT <= BJDNWD)
     C                   EVAL      CAMD += CONCAA
      *
      ** If CLE023 is installed, update Current Exposure field.
      *
     C                   IF        CLE023 = 'Y'
     C                   EVAL      CEXP += WCNCAA
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   IF        MF_STDT < BJRDNB and CLE023 = 'Y'
     C     K#KY04        SETGT     HISUPD
     C     K#KY04        READPE    HISUPD                                 04
     C                   IF        *IN04 = '0'
     C                   Z-ADD     H_FADRAM      PEXP
     C                   ENDIF
     C                   ENDIF
      *
     C                   UPDATE    FCLTYFNF
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRCURR - Access Currency Details                              *
      *                                                               *
      *****************************************************************
     C     SRCURR        BEGSR
      *
     C                   CALL      'AOCURRR0'
     C                   PARM      '*MSG   '     PRTCD
     C                   PARM      '*KEY   '     POPTN
     C                   PARM      WCCY          @AJCD             3
     C     SDCURR        PARM      SDCURR        DSSDY
      *
     C     PRTCD         IFNE      *BLANKS
     C                   MOVEL     'SDCURRPD'    DBFILE
     C                   Z-ADD     WBASE         DBASE
     C                   MOVEL     WBKEY         DBKEY
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      ********************************************************************
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      * Called by: Implicitly on program activation                   *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR
 
      *
      ** Define data areas.
      *
     C     *DTAARA       DEFINE                  LDA
     C                   IN        RUNDAT
      *
      **  Access RUNDAT.
      *
     C     *DTAARA       DEFINE                  RUNDAT
     C     *LOCK         IN        LDA
     C                   MOVEL     'LE07057'     DBPGM
     C                   OUT       LDA
      *
      ** Access Bank Details.
      *
     C                   CALL      'AOBANKR0'
     C                   PARM      '*MSG   '     PRTCD             7
     C                   PARM      '*FIRST '     POPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
      *
     C     PRTCD         IFNE      *BLANKS
     C                   MOVEL     'SDBANKPD'    DBFILE
     C                   Z-ADD     001           DBASE
     C                   MOVEL     '*FIRST'      DBKEY
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ** Access General Ledger details.
      *
     C                   CALL      'AOGELRR1'
     C                   PARM      '*MSG   '     PRTCD
     C                   PARM      '*FIRST '     POPTN
     C     SDGELR        PARM      SDGELR        DSSDY
      *
     C     PRTCD         IFNE      *BLANKS
     C                   MOVEL     'SDGELRPD'    DBFILE
     C                   Z-ADD     002           DBASE
     C                   MOVEL     '*FIRST'      DBKEY
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ** Set up event control date.
      *
     C                   EVAL      WECD = BJDNWD
     C                   EVAL      WECD -= 1
      *
     C                   IF        BKAPDT < WECD
     C                   EVAL      WECD = BKAPDT
     C                   ENDIF
      *
      ** Determine if CLE014 is installed.
      *
     C                   CALL      'AOSARDR0'
     C                   PARM      '       '     PRTCD
     C                   PARM      '*VERIFY'     POPTN
     C                   PARM      'CLE014'      PSARD             6
     C     SCSARD        PARM      SCSARD        DSSDY
      *
     C     PRTCD         IFNE      *BLANKS
     C     PRTCD         ANDNE     '*NRF   '
     C     *LOCK         IN        LDA
     C                   MOVE      'SCSARDPD'    DBFILE
     C                   MOVEL     PSARD         DBKEY
     C                   Z-ADD     19            DBASE
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ** CLE014 is installed.
      *
     C     PRTCD         IFEQ      *BLANKS
     C                   EVAL      CLE014 = 'Y'
     C                   ELSE
     C                   EVAL      CLE014 = 'N'
     C                   ENDIF
      *
      ** Determine if CLE023 is installed.
      *
     C                   CALL      'AOSARDR0'
     C                   PARM      '       '     PRTCD
     C                   PARM      '*VERIFY'     POPTN
     C                   PARM      'CLE023'      PSARD
     C     SCSARD        PARM      SCSARD        DSSDY
      *
     C     PRTCD         IFNE      *BLANKS
     C     PRTCD         ANDNE     '*NRF   '
     C     *LOCK         IN        LDA
     C                   MOVE      'SCSARDPD'    DBFILE
     C                   MOVEL     PSARD         DBKEY
     C                   Z-ADD     19            DBASE
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ** CLE023 is installed.
      *
     C     PRTCD         IFEQ      *BLANKS
     C                   EVAL      CLE023 = 'Y'
     C                   ELSE
     C                   EVAL      CLE023 = 'N'
     C                   ENDIF
      *
     C                   EVAL      RUNS  = *ZEROS
     C                   EVAL      OAM   = *ZEROS
     C                   EVAL      WBASE = *ZEROS
     C                   EVAL      WCCY  = *BLANKS
     C                   EVAL      WBKEY = *BLANKS
      *
      ** Chain to LEMFUXPD.
      *
     C     K#KY01        KLIST
     C                   KFLD                    K1CNUM
     C                   KFLD                    K1FACT
     C                   KFLD                    K1FCNO
      *
      ** Chain to FCLTY.
      *
     C     K#KY02        KLIST
     C                   KFLD                    K1CNUM
     C                   KFLD                    K1FACT
     C                   KFLD                    K1FCNO
     C                   KFLD                    K1RCTP
      *
      ** Chain to PFCLFL1.
      *
     C     K#KY03        KLIST
     C                   KFLD                    K1BRCA
     C                   KFLD                    K1CNUM
     C                   KFLD                    K1FACT
     C                   KFLD                    K1FCNO
 
      *
      ** Read to HISUPD/FACHISAF.
      *
     C     K#KY04        KLIST
     C                   KFLD                    K1BRCA
     C                   KFLD                    K1CNUM
     C                   KFLD                    K1FCTY
 
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
 
     C                   IF        @RUN = *BLANK
     C                   EVAL      @RUN = 'Y'
     C                   DUMP
     C                   ENDIF
 
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN
 
     C                   ENDSR
      ********************************************************************
**  POWR   **      POWERS OF TEN
0000001
0000010
0000100
0001000
0010000
0100000
1000000
