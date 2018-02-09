     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2006')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Eq. Holidays to Currency Calendar Holiday Mapping')
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SD000058 - Equation Holidays to Currency Calendar Holidays   *
      *             Mapping                                           *
      *                                                               *
      *  Function:  This program maps Equation Holidays to Currency   *
      *             Calendars Holidays                                *
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
      * Midas Plus 1.4 Base ------------------------------------------*
      *                 BG12014            Date 10Nov06               *
      *                 CRE026  *CREATE    Date 24May06               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  BUG14620C - Consumer Banking Data Migration                  *
      *              Get the branch from SDBRCHPD                     *
      *  BG12014 - Holiday updates are not replicated into equation.  *
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
 
      **  Array
     DW#Arr                           1    DIM(366)
 
      **  Before Image Array                                                                 BG12014
     DW#ArrB                          1    DIM(366)                                          BG12014
                                                                                             BG12014
      ** External DS based on Midas Holidays file
     DAIMG           E DS                  EXTNAME(SDHOLPD)
 
      ** External DS based on Midas Holidays file-Before Image                               BG12014
     DBIMG           E DS                  EXTNAME(SDHOLPD)                                  BG12014
     D                                     PREFIX(B_)                                        BG12014
                                                                                             BG12014
      ** External DS based on Midas user details file
     DSDUSER         E DS                  EXTNAME(MUSERDD)
 
      ** External DS based on Midas currency file
     DSDCURR         E DS                  EXTNAME(SDCURRPD)
 
      ** Second DS for access programs, long data structure
     DDSSDY          E DS                  EXTNAME(DSSDY)
 
      ** Data Structure for input parameter
     DW#DSAIM          DS
     DVFAPP                    1      1
     DVFWSD                    2      5
     DVFRBR                    6      9
     DVFBID                   10     14
     DVFUID                   15     22
     DVFTTP                   23     23
     DVFCCY                   24     26S 0
     DVFHDA                   27    242
     DVFEB1                  243    243
     DVFIND                  244    244
     DVF001                  245   9999
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Work Variables
     D @RTCD           S              7A
     D @OPTN           S              7A
     D DSAIM2          S           9999A
     D DSAIM3          S           9999A
     D DSAIM4          S           9999A
     D DSAIM5          S           9999A
     D DSAIM6          S           9999A
     D DSAIM7          S           9999A
     D DSAIM8          S           9999A
     D DSAIM9          S           9999A
     D DSAIM10         S           9999A
     D DSAIM11         S           9999A
     D DSAIM12         S           9999A
     D W#CTR1          S              3P 0
     D W#CTR2          S              3P 0
     D W#VAL           S            366
     D W#BVAL          S            366                                                      BG12014
     D W#DATE1         S              7A
     D W#DATE2         S               D   DATFMT(*DMY)
     D W#DATEC         S              6A
     D W#DDDC          S              3A
     D W#DDDN          S              3P 0
     D W#YYYYC         S              4A
     D W#YYYYN         S              4P 0
     D W#LEAPYR        S              1A
     D W#VFTTP         S              1A                                                     BG12014
 
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
      ** Equation Calendar  details
 
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
 
     C                   EVAL      VFRBR  = DBRN
 
     C                   ENDIF
 
     C                   ENDIF                                                             BUG14620C
                                                                                           BUG14620C
     C                   EVAL      VFBID  = %SUBST (PSUser : 1 : 5)             Trans. identifier
     C                   EVAL      VFUID  = %SUBST (PSUser : 1 : 8)             User identifier
     C**********         EVAL      VFTTP  = '6'                             Transaction type BG12014
     C                   EVAL      VFTTP  = W#VFTTP                                          BG12014
 
      ** To Retrieve the Currency Number
 
     C                   CALL      'AOCURRR0'
     C                   PARM      *BLANKS       @RTCD                          I/O parameter
     C                   PARM      '*KEY'        @OPTN                          Input parameter
     C                   PARM                    DGCYCD                         Input parameter
     C     SDCURR        PARM      SDCURR        DSSDY                          Output parameter
 
      ** If call ends in error
 
     C                   IF        @RTCD <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE   =  'SDCURRPD'
     C                   EVAL      DBKEY   =  DGCYCD
     C                   EVAL      DBASE   =   002
     C                   EVAL      DBPROC =  'SR/MAIN'
     C                   OUT       LDA
     C                   EXSR      *PSSR
 
     C                   ELSE
 
     C                   EVAL       VFCCY = A6ISON
 
     C                   ENDIF
 
      ** End of Block code 1
 
     C                   EVAL       VFEB1 = X'3B'
 
      ** Indicator
 
     C                   EVAL       VFIND = *BLANKS
 
      ** Filler
 
     C                   EVAL      VF001 = *BLANKS
 
      ** Character Year
 
     C                   EVAL      W#YYYYC = DGYRNB
 
      ** Numeric Year
 
     C                   MOVE      DGYRNB        W#YYYYN
 
      ** Check for Leap Year
 
     C                   IF        ( ( ( %REM(W#YYYYN : 4)  =   0 )  AND
     C                             ( %REM(W#YYYYN : 100)  <>  0 ) )  OR
     C                                 ( %REM(W#YYYYN : 400)   =   0 ) )
     C                   EVAL      W#LEAPYR = 'Y'
 
     C                   ELSE
 
     C                   EVAL      W#LEAPYR = 'N'
 
     C                   ENDIF
 
     C                   IF        VFTTP = '6'                                               BG12014
                                                                                             BG12014
      ** Extract Fields from 17 -  382  positions and store in an Array
 
     C                   EVAL      W#VAL = %SUBST(AIMG : 17 : 366)
     C                   MOVEA     W#VAL         W#ARR
 
      ** Extract Fields from 17 -  382  positions and store in an Array                      BG12014
      ** Before Image                                                                        BG12014
     C                   EVAL      W#BVAL = %SUBST(BIMG : 17 : 366)                          BG12014
     C                   MOVEA     W#BVAL        W#ARRB                                      BG12014
                                                                                             BG12014
     C                   ELSE                                                                BG12014
                                                                                             BG12014
      ** Extract Fields from 17 -  382  positions and store in an Array                      BG12014
                                                                                             BG12014
     C                   EVAL      W#VAL = %SUBST(AIMG : 17 : 366)                           BG12014
     C                   MOVEA     W#VAL         W#ARRB                                      BG12014
                                                                                             BG12014
      ** Extract Fields from 17 -  382  positions and store in an Array                      BG12014
      ** Before Image                                                                        BG12014
     C                   EVAL      W#BVAL = %SUBST(BIMG : 17 : 366)                          BG12014
     C                   MOVEA     W#BVAL        W#ARR                                       BG12014
                                                                                             BG12014
     C                   ENDIF                                                               BG12014
                                                                                             BG12014
      ** Initialize Counters
 
     C                   EVAL      W#CTR1 = 1
     C                   EVAL      W#CTR2 = 1
 
      ** Check each field value extracted from 17 till 382to be 'X'
 
     C                   DOW       W#Ctr1 <= 366
     C**********         IF        W#ARR(W#Ctr1) = 'X'                                       BG12014
     C                   IF        ( W#ARR(W#Ctr1) = 'X') AND                                BG12014
     C                             ( W#ARR(W#Ctr1) <> W#ARRB(W#Ctr1))                        BG12014
 
      ** Store Array Index as Day Number of the Year
 
     C                   EVAL      W#DDDN = W#CTR1
 
      ** If Year is not a Leap Year and Day Number is 60, Increase the
      ** Array Index by 1 and Skip the Value
 
     C                   IF        (W#LEAPYR = 'N') AND (W#DDDN = 60)
     C                   EVAL      W#CTR1 = W#CTR1 + 1
     C                   ITER
     C                   ENDIF
 
      ** If Year is not a Leap Year and Day Number is more
      ** than 60, Decrease Day Number by One
 
     C                   IF        (W#LEAPYR = 'N')  AND (W#DDDN > 60)
     C                   EVAL      W#DDDN = W#DDDN - 1
     C                   ENDIF
 
      ** Character Day Number
 
     C                   MOVE      W#DDDN        W#DDDC
 
      ** Long Julian Date YYYYDDD
 
     C                   EVAL      W#DATE1 = W#YYYYC + W#DDDC
     C
      ** Date in *DMY Format
 
     C                   EVAL      W#DATE2 = %DATE(W#DATE1 : *LONGJUL0)
 
      ** Character Date in DDMMYY format
 
     C                   EVAL      W#DATEC = %SUBST(%CHAR(W#DATE2) : 1 : 2) +
     C                                       %SUBST(%CHAR(W#DATE2) : 4 : 2) +
     C                                       %SUBST(%CHAR(W#DATE2) : 7 : 2)
     C
      ** If less than 36 blocks of DDMMYY, continue in current  Holiday Dates
 
     C                   IF        W#CTR2 <= 36
     C                   EVAL      VFHDA = %TRIM(VFHDA) + W#DATEC
 
      ** Write all previous Holiday Dates in First Blank Output parameter
      ** and initialize Holiday Dates and put current Holiday Date
 
     C                   ELSE
 
     C                   SELECT
     C                   WHEN      DSAIM2 = *BLANKS
     C                   EVAL      DSAIM2 = W#DSAIM
 
     C                   WHEN      DSAIM3 = *BLANKS
     C                   EVAL      DSAIM3 = W#DSAIM
 
     C                   WHEN      DSAIM4 = *BLANKS
     C                   EVAL      DSAIM4 = W#DSAIM
 
     C                   WHEN      DSAIM5 = *BLANKS
     C                   EVAL      DSAIM5 = W#DSAIM
 
     C                   WHEN      DSAIM6 = *BLANKS
     C                   EVAL      DSAIM6 = W#DSAIM
 
     C                   WHEN      DSAIM7 = *BLANKS
     C                   EVAL      DSAIM7 = W#DSAIM
 
     C                   WHEN      DSAIM8 = *BLANKS
     C                   EVAL      DSAIM8 = W#DSAIM
 
     C                   WHEN      DSAIM9 = *BLANKS
     C                   EVAL      DSAIM9 = W#DSAIM
 
     C                   WHEN      DSAIM10 = *BLANKS
     C                   EVAL      DSAIM10 = W#DSAIM
 
     C                   WHEN      DSAIM11 = *BLANKS
     C                   EVAL      DSAIM11 = W#DSAIM
 
     C                   WHEN      DSAIM12 = *BLANKS
     C                   EVAL      DSAIM12 = W#DSAIM
 
     C                   ENDSL
 
      ** Initialize the Holiday Block Counter and Holiday Dates
      ** Block and save current Holiday Date
 
     C                   EVAL      W#CTR2 = 1
     C                   EVAL      VFHDA = *BLANKS
     C                   EVAL      VFHDA = %TRIM(VFHDA) + W#DATEC
 
     C                   ENDIF
 
      ** Increment Holiday Block Counter
 
     C                   EVAL      W#CTR2 = W#CTR2 + 1
 
     C                   ENDIF
 
      ** Increment Field Array Counter
 
     C                   EVAL      W#CTR1 = W#CTR1 + 1
 
     C                   ENDDO
                                                                                             BG12014
     C                   IF        W#CTR2 <= 36                                              BG12014
                                                                                             BG12014
      ** Write all previous Holiday Dates in First Blank Output parameter                    BG12014
      ** and initialize Holiday Dates and put current Holiday Date                           BG12014
                                                                                             BG12014
                                                                                             BG12014
     C                   SELECT                                                              BG12014
     C                   WHEN      DSAIM2 = *BLANKS                                          BG12014
     C                   EVAL      DSAIM2 = W#DSAIM                                          BG12014
                                                                                             BG12014
     C                   WHEN      DSAIM3 = *BLANKS                                          BG12014
     C                   EVAL      DSAIM3 = W#DSAIM                                          BG12014
                                                                                             BG12014
     C                   WHEN      DSAIM4 = *BLANKS                                          BG12014
     C                   EVAL      DSAIM4 = W#DSAIM                                          BG12014
                                                                                             BG12014
     C                   WHEN      DSAIM5 = *BLANKS                                          BG12014
     C                   EVAL      DSAIM5 = W#DSAIM                                          BG12014
                                                                                             BG12014
     C                   WHEN      DSAIM6 = *BLANKS                                          BG12014
     C                   EVAL      DSAIM6 = W#DSAIM                                          BG12014
                                                                                             BG12014
     C                   WHEN      DSAIM7 = *BLANKS                                          BG12014
     C                   EVAL      DSAIM7 = W#DSAIM                                          BG12014
                                                                                             BG12014
     C                   WHEN      DSAIM8 = *BLANKS                                          BG12014
     C                   EVAL      DSAIM8 = W#DSAIM                                          BG12014
                                                                                             BG12014
     C                   WHEN      DSAIM9 = *BLANKS                                          BG12014
     C                   EVAL      DSAIM9 = W#DSAIM                                          BG12014
                                                                                             BG12014
     C                   WHEN      DSAIM10 = *BLANKS                                         BG12014
     C                   EVAL      DSAIM10 = W#DSAIM                                         BG12014
                                                                                             BG12014
     C                   WHEN      DSAIM11 = *BLANKS                                         BG12014
     C                   EVAL      DSAIM11 = W#DSAIM                                         BG12014
                                                                                             BG12014
     C                   WHEN      DSAIM12 = *BLANKS                                         BG12014
     C                   EVAL      DSAIM12 = W#DSAIM                                         BG12014
                                                                                             BG12014
     C                   ENDSL                                                               BG12014
                                                                                             BG12014
      ** Initialize the Holiday Block Counter and Holiday Dates                              BG12014
      ** Block and save current Holiday Date                                                 BG12014
                                                                                             BG12014
     C                   EVAL      W#CTR2 = 1                                                BG12014
     C                   EVAL      VFHDA = *BLANKS                                           BG12014
     C                   EVAL      VFHDA = %TRIM(VFHDA) + W#DATEC                            BG12014
                                                                                             BG12014
     C                   ENDIF                                                               BG12014
 
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
     C                   PARM                    BIMG                                        BG12014
     C                   PARM                    W#VFTTP                                     BG12014
     C                   PARM                    DSAIM2
     C                   PARM                    DSAIM3
     C                   PARM                    DSAIM4
     C                   PARM                    DSAIM5
     C                   PARM                    DSAIM6
     C                   PARM                    DSAIM7
     C                   PARM                    DSAIM8
     C                   PARM                    DSAIM9
     C                   PARM                    DSAIM10
     C                   PARM                    DSAIM11
     C                   PARM                    DSAIM12
 
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
 
     C                   EVAL      DSAIM2 = *Blanks
     C                   EVAL      DSAIM3 = *Blanks
     C                   EVAL      DSAIM4 = *Blanks
     C                   EVAL      DSAIM5 = *Blanks
     C                   EVAL      DSAIM6 = *Blanks
     C                   EVAL      DSAIM7 = *Blanks
     C                   EVAL      DSAIM8 = *Blanks
     C                   EVAL      DSAIM9 = *Blanks
     C                   EVAL      DSAIM10 = *Blanks
     C                   EVAL      DSAIM11 = *Blanks
     C                   EVAL      DSAIM12 = *Blanks
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
**  CPY@
(c) Finastra International Limited 2006
