     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2006')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Equation Holidays to Currency Calendars  Mapping')
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SD000057 - Equation Holidays to Currency Calendars Mapping   *
      *                                                               *
      *  Function:  This program maps Equation Holidays to Currency   *
      *             Calendars                                         *
      *                                                               *
      *  Called By: SD000056 - Holiday Mapping and Update of Equation *
      *                        Currency and Branch Calendars          *
      *                                                               *
      *  (c) Finastra International Limited 2006                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *  Prev Amend No. BUG14620C          Date 03Sep07               *
      *                 BUG13704           Date 03May07               *
      *                 CRE026  *CREATE    Date 24May06               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  BUG14620C - Consumer Banking Data Migration                  *
      *              Get the branch from SDBRCHPD                     *
      *  BUG13704 - The trigger program to update the Equation        *
      *             holiday table from the Midas Holiday              *
      *             Maintenance does not appear to work.              *
      *  CRE026 - Consumer Banking                                    *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *  U7+U8 -  Database Error                                      *
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
      *                                                                                    BUG14620C
      ** Midas SD Branch code                                                              BUG14620C
     FSDBRCHPD  IF   E             DISK    INFSR(*PSSR)                                    BUG14620C
 
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
 
      ** External DS based on Midas Holidays file
     DAIMG           E DS                  EXTNAME(SDHOLPD)
 
      ** External DS based on Midas user details file
     DSDUSER         E DS                  EXTNAME(MUSERDD)
 
      ** External DS based on Midas Currency codes file
     DSDCURR         E DS                  EXTNAME(SDCURRPD)
 
      ** Second DS for access programs, long data structure
     DDSSDY          E DS                  EXTNAME(DSSDY)
 
      ** Data Structure for input parameters
     DDSAIM            DS
     DVFAPP                    1      1
     DVFWSD                    2      5
     DVFRBR                    6      9
     DVFBID                   10     14
     DVFUID                   15     22
     DVFTTP                   23     23
     DVFCCY                   24     26S 0
     DVFBMN                   27     27  0
     DVFBTU                   28     28  0
     DVFBWD                   29     29  0
     DVFBTH                   30     30  0
     DVFBFR                   31     31  0
     DVFBST                   32     32  0
     DVFBSN                   33     33  0
     DVFCLY                   34    105
     DVFEB1                  106    106
     DVF001                  107    243
     DVFIND                  244    244
     DVF002                  245   9999
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Work Variables
     D @RTCD           S              7A
     D @OPTN           S              7A
 
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
 
      ** Map Midas-Plus Holidays Details from Input Parameter to
      ** Equation Branch Calendars.
 
     C                   EVAL      VFAPP = 'D'                                  Application code
     C                   EVAL      VFWSD = 'MIDA'                               Wrkstn identifier
 
     C                   IF        *IN79 = *OFF                                            BUG14620C
     C                   EVAL      VFRBR = A8BRCD                                          BUG14620C
     C                   ELSE                                                              BUG14620C
                                                                                           BUG14620C
      ** Populate Input branch number
      ** To find the branch of the user
 
     C                   CALL      'AOUSERR0'
     C                   PARM      *BLANKS       @RTCD                          I/O parameter
     C                   PARM      '*KEY'        @OPTN                          Input parameter
     C                   PARM                    PSUSER                         Input parameter
     C     SDUSER        PARM      SDUSER        DSSDY                          Output parameter
 
     C                   IF        @RTCD  <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'MUSERDD'
     C                   EVAL      DBKEY  = PSUSER
     C                   EVAL      DBASE  = 001
     C                   EVAL      DBPROC = 'SR/MAIN'
     C                   OUT       LDA
     C                   EXSR      *PSSR
 
     C                   ELSE
 
     C                   EVAL      VFRBR  = DBRN                                Input branch number
     C                   ENDIF
 
     C                   ENDIF                                                             BUG14620C
                                                                                           BUG14620C
     C                   EVAL      VFBID  = %SUBST (PSUser : 1 : 5)             Trans. identifier
     C                   EVAL      VFUID  = %SUBST (PSUser : 1 : 8)             User identifier
     C                   EVAL      VFTTP  = '1'                                 Transaction type
 
      ** To Retrieve the Currency Number
 
     C**********         CALL      'AOCURRR0'                                               BUG13704
     C                   CALLB     'AOCURRR0'                                               BUG13704
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*KEY'        @OPTN
     C                   PARM                    DGCYCD
     C     SDCURR        PARM      SDCURR        DSSDY
 
     C                   IF        @RTCD <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE   =  'SDCURRPD'
     C                   EVAL      DBKEY   =  DGCYCD
     C                   EVAL      DBASE   =   002
     C                   EVAL      DBPROC =  'SR/MAIN'
     C                   OUT       LDA
     C                   EXSR      *PSSR
 
     C                   ELSE
 
     C                   EVAL      VFCCY = A6ISON
 
     C                   ENDIF
 
      ** Business Day Indicator - Monday
 
     C                   EVAL      VFBMN = 1
 
      ** Business Day Indicator - Tuesday
 
     C                   EVAL       VFBTU = 1
 
      ** Business Day Indicator - Wednesday
 
     C                   EVAL       VFBWD = 1
 
      ** Business Day Indicator - Thursday
 
     C                   EVAL       VFBTH = 1
 
      ** Business Day Indicator - Friday
 
     C                   EVAL       VFBFR = 1
 
      ** Business Day Indicator - Saturday
 
     C                   EVAL       VFBST = 1
 
      ** Business Day Indicator - Sunday
 
     C**********         EVAL       VFBSN = 1                                               BUG13704
     C                   EVAL       VFBSN = 0                                               BUG13704
 
      ** Calendar years required
 
     C                   EVAL      VFCLY = %SUBST(DGYRNB : 3 : 2)
 
      ** End of Block code 1
 
     C                   EVAL      VFEB1 = X'3B'
 
      ** Filler
 
     C                   EVAL      VF001 = *BLANKS
 
      ** Indicator
 
     C                   EVAL      VFIND = *Blanks
 
      ** Filler
 
     C                   EVAL      VF002 = *Blanks
 
      ** End Program and Return to Caller
 
     C                   EVAL      *INLR = *ON
     C                   RETURN
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
 
 
      ** Define Entry Parameters List
 
     C     *ENTRY        PLIST
     C                   PARM                    AIMG
     C                   PARM                    DSAIM
 
     ** Defining Data Area
 
     C     *DTAARA       DEFINE                  LDA
 
     C     *DTAARA       DEFINE                  PMODEINIT         1                       BUG14620C
     C                   IN        PMODEINIT                            79                 BUG14620C
      ** Read Branch code                                                                  BUG14620C
     C                   IF        *IN79 = *OFF                                            BUG14620C
     C                   READ      SDBRCHPD                                                BUG14620C
     C                   ENDIF                                                             BUG14620C
                                                                                           BUG14620C
      ** Initialize Output Parameters
 
     C                   EVAL      DSAIM = *Blanks
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
**  CPY@
(c) Finastra International Limited 2006
