     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2006')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Equation Spot Rate Mapping')
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SD000083 - Equation Collateral Location Mapping              *
      *                                                               *
      *  Function:  This program Map the Spot Rate In Equation        *
      *                                                               *
      *                                                               *
      *  Called By: SD000082 - Spot Rate Mapping and update of        *
      *                        Equation Spot Rate File                *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2006            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *  Last Amend No. BUG14132           Date 18Jun07               *
      *  Prev Amend No. CRE026  *CREATE    Date 24May06               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  BUG14132 - New Currency codes do not show when               *
      *             opening  Consumer accounts                        *
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
 
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ D-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
     D CPY@            S             80    DIM(1) CTDATA PERRCD(1)
      *
     D LDA           E DS           256    EXTNAME(LDA)
 
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
 
      ** Second DS for access programs, long data structure
     DDSSDY          E DS                  EXTNAME(DSSDY)
      *
      *  Data Structure based on Midas user details Files
     DSDUSER         E DS                  EXTNAME(MUSERDD)
      *
      *  After Image based on Midas SD currency code
     DAIMG           E DS                  EXTNAME(SDCURRPD)
      *
      *  Data Structure for Input Parameters
     D DSAIM           DS
     D**GZWSID**                      4                                    Workstation id   BUG14132
     D  GZWSID                        4A                                                    BUG14132
     D  GZDIM                         2  0                                      Day in month
     D  GZTIM                         6  0                                      Time; hhmmss
     D  GZSEQ                         7P 0                                      Sequence number
     D**GZIMG***                      1                                    Journal image    BUG14132
     D  GZIMG                         1A                                                    BUG14132
     D**GZCCY***                      3                                  Currency mnemonic  BUG14132
     D  GZCCY                         3A                                                    BUG14132
     D**GZSPT***                      7P 0                            Obsolete - use GZSPE  BUG14132
     D  GZSPT                        13P 7                                                  BUG14132
     D**GZUSR***                      7P 0                            Obsolete - use GZUSE  BUG14132
     D  GZUSR                        13P 7                                                  BUG14132
     D**GZEXR***                      7P 0                            Obsolete - use GZEXT  BUG14132
     D  GZEXR                        13P 7                                                  BUG14132
     D**GZDATC**                      5                                         Date code   BUG14132
     D  GZDATC                        5A                                                    BUG14132
     D  GZDTE                         7  0                                      Database date; cyymm
     D  GZHDLM                        7  0                                      Date last maintained
     D**GZHTIM**                      6                               Time written to HE    BUG14132
     D  GZHTIM                        6  0                                                  BUG14132
     D**GZSPE***                     15P 8                            Spot rate             BUG14132
     D  GZSPE                        15P 9                                                  BUG14132
     D**GZUSE***                      8P 0                                      User rate   BUG14132
     D  GZUSE                        15P 9                                                  BUG14132
     D**GZEXT***                      8P 0                               Premium/Discount   BUG14132
     D  GZEXT                        15P 9                                                  BUG14132
     D**GZNSP***                      8P 0                           Next day's spot rate   BUG14132
     D  GZNSP                        15P 9                                                  BUG14132
      *
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Work Variables
     D P@APRC          S              7
     D P@OPT           S              7
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +--- Start of Main processing -------------------------------+
      ** ¦                                                            ¦
      ** ¦ Initial processing is performed automatically: the *INZSR  ¦
      ** ¦ is executed at program activation.                         ¦
      ** ¦                                                            ¦
      ** +------------------------------------------------------------+
 
      *****************************************************************
      *  MAIN PROCEDURE                                               *
      *****************************************************************
 
      *  Workstation id
     C                   EVAL      GZWSID = 'MIDA'
      *  Day in month
     C                   EVAL      GZDIM = *Zero
      *  Time; hhmmss
     C                   EVAL      GZTIM = *Zero
      *  Sequence number
     C                   EVAL      GZSEQ = *Zero
      *  Journal image
     C                   EVAL      GZIMG = *Blanks
      *  Currency mnemonic
     C                   EVAL      GZCCY = A6CYCD
      *  Obsolete - use GZSPE
     C                   EVAL      GZSPT = *Zero
      *  Obsolete - use GZUSE
     C                   EVAL      GZUSR = *Zero
      *  Obsolete - use GZEXT
     C                   EVAL      GZEXR = *Zero
      *  Date code
     C                   EVAL      GZDATC = *Blanks
      *  Database date; cyymm
     C                   EVAL      GZDTE = *Zero
      *  Date last maintained
     C                   EVAL      GZHDLM = *Zero
      *  Time written to HE f
     C                   EVAL      GZHTIM = *Zero
      *  Spot rate
     C                   EVAL      GZSPE  = A6SPRT
      *  User rate
     C                   EVAL      GZUSE = *Zero
      *  Premium/Discount
     C                   EVAL      GZEXT = *Zero
      *  Next day's spot rate
     C                   EVAL      GZNSP = *Zero
      *
     C                   RETURN
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *PSSR  - Program exception error routine                     *
      *          Called automatically if a program error occurs,      *
      *          or directly by the program code using EXSR.          *
      *          This subroutine DUMPs the program just once.         *
      *                                                               *
      *  Called by: (**calling routines**)                            *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
      *
     C     *PSSR         BEGSR
      *
     C     *LOCK         IN        LDA
     C                   EVAL      DBPGM  =  PSProcPgm
     C                   EVAL      DBMOD  =  PSProcMod
     C                   OUT       LDA
      *
     C                   DUMP
      *
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
      *
     C                   RETURN
     C
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *INZSR - Program Initialisation routine                      *
      *                                                               *
      *  Called by: Implicitly on program activation                  *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
      *
     C     *INZSR        BEGSR
      *
     C     *ENTRY        PLIST
      *
     C                   PARM                    AIMG
     C                   PARM                    DSAIM
      *
     C     *DTAARA       DEFINE                  LDA
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2006
