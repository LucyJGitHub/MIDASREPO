     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2006')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Equation Industry Codes Mapping')
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SD000085 - Equation Industry Code Mapping                    *
      *                                                               *
      *  Function:  This program Map the Industry Codes In Equation   *
      *                                                               *
      *  Called By: SD000084 - Industry Mapping and update of         *
      *                        Equation P5 User Codes File            *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2006            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *  Last Amend No. BUG14129           Date 13Jun07               *
      *  Prev Amend No. CRE026  *CREATE    Date 24May06               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  BUG14129 - Industry codes do not show in Consumer-Universal  *
      *             customer screens                                  *
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
 
      ** External DS based on Midas users details file
     DSDUSER         E DS                  EXTNAME(MUSERDD)
 
      ** External DS based on Midas Local industry codes
     DAIMG           E DS                  EXTNAME(SDINDSPD)
 
      ** Data Structure
     DDSAIM            DS
     DVFAPP                    1      1
     DVFWSD                    2      5
     DVFRBR                    6      9
     DVFBID                   10     14
     DVFUID                   15     22
     DVFTTP                   23     23
     DVFBBN                   24     27
     DVFKCD                   28     32
     DVFINB                   33     44
     DSPARE1                  45     49
     DVFUFD                   50     79
     DVFEB1                   80     80
     DSPARE2                  81    243
     DVFIND                  244    244
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Work Variables
     D P@APRC          S              7A
     D P@OPT           S              7A
 
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
 
      ** Mapping for Equation
 
     C                   EVAL      VFAPP = 'D'                                  Application code
     C                   EVAL      VFWSD = 'MIDA'                               Wrkstn identifier
 
      ** Populate Input branch
      ** To find the branch of the user
 
     C                   CALL      'AOUSERR0'
     C                   PARM      *BLANKS       P@APRC
     C                   PARM      '*KEY'        P@OPT
     C                   PARM                    PSUser
     C     SDUSER        PARM      SDUSER        DSSDY
 
     C                   IF        P@APRC <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = ' MUSERDD '
     C                   EVAL      DBKEY  = P@OPT
     C                   EVAL      DBASE  = 001
     C                   EVAL      DBPROC = 'SR/ MAIN '
     C                   OUT       LDA
     C                   EXSR      *PSSR
 
     C                   ELSE
 
     C                   EVAL      VFRBR  = DBRN                                Input branch number
     C                   ENDIF
 
     C                   EVAL      VFBID  = PSUser                              Trans. identifier
     C                   EVAL      VFUID  = PSUser                              User identifier
     C                   EVAL      VFTTP  = 'B'                                 Parameter type - B
     C**********         EVAL      VFBBN  = '000'                            Reserve number BUG14129
     C                   EVAL      VFBBN  = '0000'                                          BUG14129
     C                   EVAL      VFKCD  = 'P5' + AOLICD                       KeyCode P5/Ind. code
     C                   EVAL      VFINB  = *BLANKS                             4x3 byte indi.maint.
     C                   EVAL      SPARE1 = *BLANKS                             Spare
     C                   EVAL      VFUFD  = AOLINA                              User field descrip.
     C                   EVAL      VFEB1  = X'3B'                               End of block code 1
     C                   EVAL      SPARE2 = *BLANKS                             SPARE
     C                   EVAL      VFIND  = *BLANKS                             Indicator
 
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
     C                   EVAL      DBPGM  =  PSProcPgm
     C                   EVAL      DBMOD  =  PSProcMod
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
 
     C     *ENTRY        PLIST
     C                   PARM                    AIMG
     C                   PARM                    DSAIM
 
      ** Define Local Data Area
 
     C     *DTAARA       DEFINE                  LDA
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2006
