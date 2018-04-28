     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2006')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD Update consumer banking journal data area')
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SD91000B - Update Consumer Banking journal data area         *
      *                                                               *
      *  Function:  This program updates Equation Journal data area   *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2006            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *  Last Amend No. BUG13625           Date 23Mar07               *
      *  Prev Amend No. CRE026    *CREATE    Date 24May06             *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  BUG13625 - No proper setup on EJNSTAT (Redeliver)            *
      *  CRE026 - Consumer Banking                                    *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *    U7+U8 -  Database Error                                    *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      *  *PSSR   - Program exception error routine                    *
      *  *INZSR  - Initialisation Subroutine                          *
      *                                                               *
      *  The *INZSR subroutine will only get called automatically     *
      *  on entry to the module the first time it is run              *
      *  (unless you end the program with LR on).  Similarly          *
      *  D-spec initialisation only happens the first time.  Use      *
      *  RESET for subsequent passes.                                 *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
      ** Midas GO Zone
     FGPZONEL0  IF   E           K DISK    INFSR(*PSSR)
 
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ D-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      ** Work Field to hold the value from Data Area KAPUNMNM
     D RetailRcvr      S              8A
     D CPY@            S             80    DIM(1) CTDATA PERRCD(1)
     D I#ERMS          S             20A
      *
     D LDA           E DS           256    EXTNAME(LDA)
     D EJNSTAT       E DS           200    EXTNAME(EJNSTAT)
 
      ** Local data area for database error details
      ** *LOCK IN LDA immediately before and OUT LDA immediately
      ** after each database error handling.
 
      **                                    134 141 DBFILE
      **       Defines:                     142 170 DBKEY
      **                                    171 180 DBPGM
      **                                    181 1830DBASE
 
      ** Program Status Data Structure
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
 
      ** Data Structure for input parameter
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Work Variables
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
 
      *********************************************************************
      * MAIN PROCEDURE                                                    *
      *********************************************************************
 
 
     C     *DTAARA       DEFINE                  EJNSTAT
     C     *LOCK         IN        EJNSTAT
     C                   Eval      ARCV   = RetailRcvr
     C                   Eval      ZZ002A = '01'
     C                   Eval      NRCV   = RetailRcvr
     C                   Eval      ZZ002B = '02'
     C                   Eval      DFRS   = *BLANKS
     C                   Eval      NDRS   = *BLANKS
     C                   Eval      DFBB   = 'TAPE'
     C                   Eval      NDBB   = 'TAP04'
     C                   Eval      DFIC   = 'TAPE'
     C                   Eval      NDIC   = 'TAP04'
     C                   Eval      VNIC   = 'DB001'
     C                   Eval      DRBB   = 'N'
     C                   Eval      RCVP   = 'N'
     C                   Eval      DUAL   = 'N'
     C                   Eval      ZZ003  = *BLANK
     C                   Eval      SUCC   = 'N'
     C                   Eval      VLIC   = *BLANK
     C                   Eval      DSIN   = 'N'
     C                   Eval      RDBV   = 'N'
     C                   Eval      BKPS   = 'P'
     C                   Eval      RCVR   = 'ICRCV000'
     C                   Eval      ZZ002C = *BLANK
     C                   Eval      RCVA   = 'ICRCV000'
     C                   Eval      ZZ002D = *BLANKS
     C                   Eval      PRUN   = 12206
     C                   Eval      AUTR   = '00000'
     C                   Eval      JOBN   = *BLANKS
     C                   Eval      USRN   = *BLANKS
     C                   Eval      JBNB   = *BLANKS
     C                   Eval      RTPT   = *BLANKS
     C                   Eval      LIBID  = ZOMSYS
     C                   Eval      JASP   = '01'
     C                   Eval      RASP   = '01'
     C                   Eval      DDDB   = 'TAP01'
     C                   Eval      VDTB   = 'CBDTA'
     C                   Eval      RSTFSV = 'Y'
     C                   Eval      ZZ029  = *BLANKS
     C                   OUT       EJNSTAT
 
 
      ** End Program and Return to Caller
 
     C                   EVAL      *INLR = *ON
     C                   RETURN
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *PSSR  - Program exception error routine                     *
      *           Called automatically if a program error occurs,     *
      *           or directly by the program code using EXSR.         *
      *           This subroutine DUMPs the program just once.        *
      *                                                               *
      *  Called by: (**calling routines**)                            *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
 
     C     *PSSR         BEGSR
 
      ** Initialise Program and Module names
 
     C     *LOCK         IN        LDA
     C                   EVAL      DBPGM = PSProcPgm
     C                   EVAL      DBMOD = PSProcMod
     C                   OUT       LDA
 
     C                   DUMP
 
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
 
     C                   RETURN
 
     C                   ENDSR
 
      *****************************************************************
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
 
      ** Defining Data Area
 
     C     *DTAARA       DEFINE                  LDA
 
      ** Get zone details
 
      /COPY GOCPYSRC,GOGETZONE
 
     C     O#ZONE        CHAIN     GPZONED0                           99
     C                   IF        *IN99 = '0'
     C                   EVAL      RetailRcvr = 'KRC' + ZOMSYS + '000'
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2006
