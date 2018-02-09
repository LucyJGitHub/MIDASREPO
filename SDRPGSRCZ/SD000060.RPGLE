     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2006')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Equation Holidays to Br.Calendar Holidays mapping')
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SD000060 - Equation Holidays to Branch Calendar Holidays     *
      *             Mapping                                           *
      *                                                               *
      *  Function:  This program maps Equation Holidays to Branch     *
      *             Calendar Holidays                                 *
      *                                                               *
      *  Called By: SD000056 - Holiday Mapping and Update of Equation *
      *                        Currency and Branch Calendars          *
      *                                                               *
      *  (c) Finastra International Limited 2006                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *  Prev Amend No. BUG13704           Date 03May07               *
      *                 BG12014            Date 13Nov06               *
      *                 CRE026  *CREATE    Date 24May06               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  BUG13704 - The trigger program to update the Equation        *
      *             holiday table from the Midas Holiday              *
      *             Maintenance does not appear to work.              *
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
 
      **  Array definition
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
 
      ** Second DS for access programs, long data structure
     DDSSDY          E DS                  EXTNAME(DSSDY)
 
      ** Data Structure for input parameter
     DW#DSAIM          DS
     D***VFAPP**                  1      1                                                  BG12014
     D***VFWSD**                  2      5                                                  BG12014
     D***VFRBR**                  6      9                                                  BG12014
     D***VFBID**                 10     14                                                  BG12014
     D***VFUID**                 15     22                                                  BG12014
     D***VFTTP**                 23     23                                                  BG12014
     D***GZWSID*                 24     27                                                  BG12014
     D***GZDIM**                 28     29S 0                                               BG12014
     D***GZTIM**                 30     35S 0                                               BG12014
     D***GZSEQ**                 36     39P 0                                               BG12014
     D***GZIMG**                 40     40                                                  BG12014
     D***GZBRNM*                 41     44                                                  BG12014
     D***GZREG**                 45     47                                                  BG12014
     D***GZALL**                 48     48                                                  BG12014
     D***VZHDA**                 49    264                                                  BG12014
     D***VZSDA**                265    480                                                  BG12014
     D***VF001**                481   9999                                                  BG12014
                                                                                            BG12014
     D GZWSID                  1      4                                                     BG12014
     D GZDIM                   5      6S 0                                                  BG12014
     D GZTIM                   7     12S 0                                                  BG12014
     D GZSEQ                  13     16P 0                                                  BG12014
     D GZIMG                  17     17                                                     BG12014
     D GZBRNM                 18     21                                                     BG12014
     D GZREG                  22     24                                                     BG12014
     D GZALL                  25     25                                                     BG12014
     D VZHDA                  26    241                                                     BG12014
     D VZSDA                 242    457                                                     BG12014
     D VF001                 458   9999                                                     BG12014
 
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
 
     C**********         EVAL      VFAPP = 'D'                             Application code  BG12014
     C**********         EVAL      VFWSD = 'MIDA'                          Wrkstn identifier BG12014
      **********                                                                             BG12014
      ***Populate Input branch number                                                        BG12014
      ***To*find the branch of the user                                                      BG12014
      **********                                                                             BG12014
     C**********         CALL      'AOUSERR0'                                                BG12014
     C**********         PARM      *BLANKS       @RTCD                     I/O parameter     BG12014
     C**********         PARM      '*KEY'        @OPTN                     Input parameter   BG12014
     C**********         PARM                    PSUSER                    Input parameter   BG12014
     C*****SDUSER        PARM      SDUSER        DSSDY                     Output parameter  BG12014
      **********                                                                             BG12014
     C**********         IF        @RTCD  <> *BLANKS                                         BG12014
     C******LOCK         IN        LDA                                                       BG12014
     C**********         EVAL      DBFILE = 'MUSERDD'                                        BG12014
     C**********         EVAL      DBKEY  = PSUSER                                           BG12014
     C**********         EVAL      DBASE  = 001                                              BG12014
     C**********         EVAL      DBPROC = 'SR/MAIN'                                        BG12014
     C**********         OUT       LDA                                                       BG12014
     C**********         EXSR      *PSSR                                                     BG12014
      **********                                                                             BG12014
     C**********         ELSE                                                                BG12014
      **********                                                                             BG12014
     C**********         EVAL      VFRBR  = DBRN                                             BG12014
      **********                                                                             BG12014
     C**********         ENDIF                                                               BG12014
      **********                                                                             BG12014
     C**********         EVAL      VFBID  = %SUBST (PSUser : 1 : 5)        Trans. identifier BG12014
     C**********         EVAL      VFUID  = %SUBST (PSUser : 1 : 8)        User identifier   BG12014
     C**********         EVAL      VFTTP  = *BLANKS                        Transaction type  BG12014
     C                   EVAL      GZWSID = 'MIDA'                              Wrkstn Identifier
     C                   EVAL      GZDIM  = 0                                   Day in Month
     C                   EVAL      GZTIM  = 0                                   Time(hhmmss)
     C                   EVAL      GZSEQ  = 0                                   Number Sequence
     C                   EVAL      GZIMG  = *BLANKS                             Journal Image
     C                   EVAL      GZDIM  = *ZEROS                              Branch Mnemonic
     C                   EVAL      GZREG  = DGLCCD                              Region Code
     C                   EVAL      GZBRNM = *Blanks                             Branch Code  BG12014
     C                   EVAL      GZALL  = 'N'                                 All Branches
     C**********         EVAL      VZSDA = *ZEROS                       Business Dates(36x6) BG12014
     C                   EVAL      VZHDA = *BLANKS                              Holidays Dt. BG12014
     C                   EVAL      VZSDA = *BLANKS                              Business Dt. BG12014
     C                   EVAL      VF001 = *BLANKS                              Filler
 
      ** Character Year
 
     C                   IF        B_DGYRNB = *BLANKS                                       BUG13704
     C                   EVAL      W#YYYYC = DGYRNB
     C                   ELSE                                                               BUG13704
     C                   EVAL      W#YYYYC = B_DGYRNB                                       BUG13704
     C                   ENDIF                                                              BUG13704
 
      ** Numeric Year
 
     C                   IF        B_DGYRNB = *BLANKS                                       BUG13704
     C                   MOVE      DGYRNB        W#YYYYN
     C                   ELSE                                                               BUG13704
     C                   MOVE      B_DGYRNB      W#YYYYN                                    BUG13704
     C                   ENDIF                                                              BUG13704
 
      ** Check for Leap Year
 
     C                   IF        ( ( ( %REM(W#YYYYN : 4)  =   0 )  AND
     C                             ( %REM(W#YYYYN : 100)  <>  0 ) )  OR
     C                                 ( %REM(W#YYYYN : 400)   =   0 ) )
     C                   EVAL      W#LEAPYR = 'Y'
 
     C                   ELSE
 
     C                   EVAL      W#LEAPYR = 'N'
 
     C                   ENDIF
 
      ** Extract Fields from 17 -  382  positions and store in an Array
 
     C                   EVAL      W#VAL = %SUBST(AIMG : 17 : 366)
     C                   MOVEA     W#VAL         W#ARR
 
      ** Extract Fields from 17 -  382  positions and store in an Array                      BG12014
      ** Before Image                                                                        BG12014
     C                   EVAL      W#BVAL = %SUBST(BIMG : 17 : 366)                          BG12014
     C                   MOVEA     W#BVAL        W#ARRB                                      BG12014
                                                                                             BG12014
      ** Initialize Counters
 
     C                   EVAL      W#CTR1 = 1
     C                   EVAL      W#CTR2 = 1
 
      ** Check each field value extracted from 17 till 382to be 'X'
 
     C                   DOW       W#Ctr1 <= 366
     C**********         IF        W#ARR(W#Ctr1) = 'X'                                       BG12014
     C                   IF        ((W#ARR(W#Ctr1) = 'X') OR                                 BG12014
     C                              (W#ARRB(W#Ctr1) = 'X')) AND                              BG12014
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
                                                                                             BG12014
     C                   IF        (W#ARR(W#Ctr1) = 'X')                                     BG12014
     C                   EVAL      VZHDA = %TRIM(VZHDA) + W#DATEC
     C                   ENDIF                                                               BG12014
                                                                                             BG12014
     C                   IF        (W#ARRB(W#Ctr1) = 'X')                                    BG12014
     C                   EVAL      VZSDA = %TRIM(VZSDA) + W#DATEC                            BG12014
     C                   ENDIF                                                               BG12014
 
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
     C                   IF        (W#ARR(W#Ctr1) = 'X')                                     BG12014
     C                   EVAL      VZHDA = *BLANKS
     C                   EVAL      VZHDA = %TRIM(VZHDA) + W#DATEC
     C                   ENDIF                                                               BG12014
                                                                                             BG12014
     C                   IF        (W#ARRB(W#Ctr1) = 'X')                                    BG12014
     C                   EVAL      VZSDA = *BLANKS                                           BG12014
     C                   EVAL      VZSDA = %TRIM(VZSDA) + W#DATEC                            BG12014
     C                   ENDIF                                                               BG12014
 
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
     C**********         EVAL      W#CTR2 = 1                                       BG12014 BUG13704
     C                   EVAL      W#CTR1 = 1                                               BUG13704
                                                                                             BG12014
     C                   IF        (W#ARR(W#Ctr1) = 'X')                                     BG12014
     C                   EVAL      VZHDA = *BLANKS                                           BG12014
     C                   EVAL      VZHDA = %TRIM(VZHDA) + W#DATEC                            BG12014
     C                   ENDIF                                                               BG12014
                                                                                             BG12014
     C                   IF        (W#ARRB(W#Ctr1) = 'X')                                    BG12014
     C                   EVAL      VZSDA = *BLANKS                                           BG12014
     C                   EVAL      VZSDA = %TRIM(VZSDA) + W#DATEC                            BG12014
     C                   ENDIF                                                               BG12014
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
 
     C     *DTAARA       DEFINE                  LDA
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
**  CPY@
(c) Finastra International Limited 2006
