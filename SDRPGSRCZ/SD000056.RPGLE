     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2006')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Holiday Map and upd of Eq. Curr.and Br.Calendars')
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SD000056 - Holiday Mapping and Update of Equation Currency   *
      *             and Branch Calendars                              *
      *                                                               *
      *  Function:  This program maps and Update Equation tables for  *
      *             Currency and Branch Calendars                     *
      *                                                               *
      *  Called By: SDC000072 - Update Equation with consumer Banking *
      *                         Standing Data Details Control         *
      *                                                               *
      *  (c) Finastra International Limited 2006                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *  Prev Amend No. BUG14620D          Date 04Sep07               *
      *                 BUG14620C          Date 03Sep07               *
      *                 BUG14024           Date 21May07               *
      *                 BUG13704           Date 03May07               *
      *                 BG12014            Date 10Nov06               *
      *                 CRE026  *CREATE    Date 24May06               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  BUG14620D - Consumer Banking Data Migration                  *
      *              Validate Holiday when date is rundate or         *
      *              next working date. Set tran type to blank        *
      *  BUG14620C - Consumer Banking Data Migration                  *
      *              Get the branch from SDBRCHPD                     *
      *  BUG14024 - When deleting currency holiday in MidasPlus,      *
      *             nothing happened in Equation side                 *
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
      *    U7+U8 -  Database Error                                    *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      *  *PSSR   - Program exception error routine                    *
      *  *INZSR  - Initialisation Subroutine                          *
      *  CALLAPI - Subroutine to Call Equation API driver program     *
      *            H56H1R                                             *
      *  SETPARM - Subroutine to set input parameters for calling     *
      *            Equation API driver program 'H56H1R'               *
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
 
      ** Valid Equation Message File
     FSDVALEQPD O    E             DISK    INFSR(*PSSR)
 
      ** Exception Equation Message File
     FSDEXCPEQPDO    E             DISK    INFSR(*PSSR)
 
                                                                                            BUG13704
      ** Equation Currency File                                                             BUG13704
     FC801LF    IF   E           K DISK    INFSR(*PSSR)                                     BUG13704
      ** SDHOLPD File                                                                       BUG13704
     FSDHOLL0   IF   E           K DISK    INFSR(*PSSR)                                     BUG13704
                                                                                            BUG13704
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ D-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
     D CPY@            S             80    DIM(1) CTDATA PERRCD(1)
      *                                                                                    BUG14620D
     D @@MTH           S              3    DIM(12) CTDATA PERRCD(12)                       BUG14620D
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
 
      ** External DS based on Midas user details file
     DSDUSER         E DS                  EXTNAME(MUSERDD)
 
      ** External DS based on Midas bank details file                                      BUG14620D
     DSDBANK         E DS                  EXTNAME(SDBANKPD)                               BUG14620D
                                                                                           BUG14620D
      ** First DS for access program, short data structure                                 BUG14620D
     DDSFDY          E DS                  EXTNAME(DSFDY)                                  BUG14620D
                                                                                           BUG14620D
      ** External DS based on Midas Holidays file
     DBIMG           E DS                  EXTNAME(SDHOLPD)
     D                                     PREFIX(B_)
 
      ** External DS based on Midas Holidays file
     DAIMG           E DS                  EXTNAME(SDHOLPD)
     D                                     PREFIX(A_)
 
      ** Data Structure for input parameter
     DPARM1            DS
     DSOURCE                   1      4
     DPFLNAME                  5     14
     DMBRNAME                 25     34
     DTRGEVENT                35     35
     DBOFF                    53     56B 0
     DBLEN                    57     60B 0
     DAOFF                    69     72B 0
     DALEN                    73     76B 0
     DEntryData              121   9999A
      *                                                                                    BUG14620D
     D                 DS                                                                  BUG14620D
     DWRddmmyy                 1      8  0                                                 BUG14620D
     D WCC                     1      2  0                                                 BUG14620D
     D WYY                     3      4  0                                                 BUG14620D
     D WMM                     5      6  0                                                 BUG14620D
     D WDD                     7      8  0                                                 BUG14620D
      *                                                                                    BUG14620D
     D                 DS                                                                  BUG14620D
     DWMRDT                    1      7                                                    BUG14620D
     D @@DD                    1      2  0                                                 BUG14620D
     D @@MMM                   3      5                                                    BUG14620D
     D @@YY                    6      7  0                                                 BUG14620D
      *                                                                                    BUG14620D
     D                 DS                                                                  BUG14620D
     DWIVALDAT1                1      8  0                                                 BUG14620D
     D WICC1                   1      2  0                                                 BUG14620D
     D WIYY1                   3      4  0                                                 BUG14620D
     D WIMM1                   5      6  0                                                 BUG14620D
     D WIDD1                   7      8  0                                                 BUG14620D
      *                                                                                    BUG14620D
     D                 DS                                                                  BUG14620D
     DWIVALDAT                 1      6  0                                                 BUG14620D
     D WIDD                    1      2  0                                                 BUG14620D
     D WIMM                    3      4  0                                                 BUG14620D
     D WIYY                    5      6  0                                                 BUG14620D
      *                                                                                    BUG14620D
     D                 DS                                                                  BUG14620D
     D WDSAIMDATST             1      6                                                    BUG14620D
     D WDSAIMDAT2S             2      2                                                    BUG14620D
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Work Variables
     D OffSet          S              5P 0
     D DSAIM1          S           9999A
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
     D W#DSAIM         S           9999A
     D W#VFAPP         S              1A
     D W#VFTTP         S              1A                                                     BG12014
     D W#CTR           S              4P 0
     D W#FLAG          S              1A
     D @RPGM           S             10A
     D @BRNM           S              4A
     D @USID           S              4A
     D @WSID           S              4A
     D @JTT            S              1A
     D DSAIM           S           9999A
     D @RREC           S              1A
     D @RMES7          S             37A
     D @AOW            S            740A
     D @ETK            S              4A
     D*@ETN****        S              7S 0                                                   BG12014
     D @ETN            S              7P 0                                                   BG12014
     D @AEXT           S              1A
     D @AREC           S              1A
     D @RTNC           S             10A
     D @MSG            S            132A
     D @MSGID          S              7A
     D @MSGF           S             10A
     D @RTCD           S              7A
     D @OPTN           S              7A
     D @PRMEQ          S              1A                                                     BG12014
     D WYR             S              3  0                                                  BUG13704
     D WPOS            S              3  0                                                  BUG13704
     D WDSAIMD         S           9999A                                                    BUG14024
     D #A              S              3  0                                                 BUG14620D
     D #X              S              2  0                                                 BUG14620D
     D #Y              S              3  0                                                 BUG14620D
     D #T              S              3  0                                                 BUG14620D
     D #U              S              3  0                                                 BUG14620D
     D DSAIMVAL        S           9999A                                                   BUG14620D
     D WDSAIMDATDS     S           1000A                                                   BUG14620D
     D WDSAIMDAT       S              6                                                    BUG14620D
     D DATE1           S               D                                                   BUG14620D
     D DATE2           S               D                                                   BUG14620D
 
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
 
      ** Recover Before & After Image
 
     C                   CALLB     'AOBANKR0'                                              BUG14620D
     C                   PARM      '*MSG    '    @RTCD             7                       BUG14620D
     C                   PARM      '*FIRST  '    @OPTN             7                       BUG14620D
     C     SDBANK        PARM      SDBANK        DSFDY                                     BUG14620D
                                                                                           BUG14620D
     C                   IF        @RTCD <> *BLANKS                                        BUG14620D
     C     *LOCK         IN        LDA                                                     BUG14620D
     C                   EVAL      DBFILE   =  'SDBANKPD'                                  BUG14620D
     C                   EVAL      DBKEY   =  PSUSER                                       BUG14620D
     C                   EVAL      DBASE   =   009                                         BUG14620D
     C                   EVAL      DBPROC =  'SR/MAIN'                                     BUG14620D
     C                   OUT       LDA                                                     BUG14620D
     C                   EXSR      *PSSR                                                   BUG14620D
     C                   ElSE                                                              BUG14620D
     C                   MOVE      BJMRDT        WMRDT                                     BUG14620D
     C                   Z-ADD     1             #X                                        BUG14620D
     C     @@MMM         LOOKUP    @@MTH(#X)                              99               BUG14620D
     C                   Eval      WDD = @@DD                                              BUG14620D
     C                   Eval      WMM = #X                                                BUG14620D
     C                   Eval      WYY = @@YY                                              BUG14620D
     C                   Eval      WDD = WDD + 2                                           BUG14620D
     C                   IF        WYY > 40                                                BUG14620D
     C                   EVAL      WCC = 19                                                BUG14620D
     C                   ELSE                                                              BUG14620D
     C                   EVAL      WCC = 20                                                BUG14620D
     C                   ENDIF                                                             BUG14620D
     C                   ENDIF                                                             BUG14620D
                                                                                           BUG14620D
     C                   EVAL      OffSet = BOFF + 5
     C                   EVAL      BIMG = %SUBST(PARM1:OffSet:BLEN)
 
      ** Recover After Image
 
     C                   EVAL      OffSet = AOFF + 5
     C                   EVAL      AIMG = %SUBST(PARM1:OffSet:ALEN)
 
      ** Set Before image to blank if insert
     C                   IF        (TRGEVENT = '1')
     C                   EVAL      BIMG = *BLANKS
     C                   ENDIF
 
      ** Set After image to blank if Delete:
     C                   IF        (TRGEVENT = '2')
     C                   EVAL      AIMG = *BLANKS
     C                   ENDIF
                                                                                            BUG14024
     C                   IF        (TRGEVENT = '2') And                                     BUG14024
     C                             B_DGLCCD = '***'                                         BUG14024
     C                   EVAL      AIMG = BIMG                                              BUG14024
     C                   ENDIF                                                              BUG14024
     C                   IF        (TRGEVENT = '3' or TRGEVENT = '2') and                   BUG14024
     C                             A_DGLCCD = '***'                                         BUG14024
     C                   EVAL      WDSAIMD = BIMG                                           BUG14024
     C                   EVAL      BIMG = *Blanks                                           BUG14024
     C                   ENDIF                                                              BUG14024
 
      ** If Location Code in After Image is Blanks then Call
      ** program to setup the Equation details of the
      ** Currency Calendar
 
     C                   IF        A_DGLCCD = '***'
     C                   CALL      'SD000057'                           90
     C                   PARM                    AIMG                           Input Parmmeter
     C                   PARM                    DSAIM1                         Output Parmmeter
 
      ** If call ends in error
 
     C                   IF        *IN90 = *ON
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE   =  '*CALL'
     C                   EVAL      DBKEY   =   'SD000057'
     C                   EVAL      DBASE   =   001
     C                   EVAL      DBPROC =  'SR/MAIN'
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Populate parameters for Equation API
 
     C                   IF        (TRGEVENT = '2' or TRGEVENT = '3') and                   BUG14024
     C                             B_DGLCCD = '***'                                         BUG14024
     C                   EVAL      %SUBST(DSAIM : 33 : 1 ) = '1'                            BUG14024
     C                   ENDIF                                                              BUG14024
     C                   EVAL      W#DSAIM = DSAIM1
     C                   EVAL      W#Flag = 'C'
     C                   EXSR      SETPARM
 
      ** Call Equation API
 
     C                   EXSR      CALLAPI
 
      ** Call program to setup Equation Currency Calendar Holidays
      ** Details
      ** (Adding Holidays)                                                                   BG12014
 
     C                   CALL      'SD000058'                           90
     C                   PARM                    AIMG
     C                   PARM                    BIMG                                        BG12014
     C                   PARM      '6'           W#VFTTP                                     BG12014
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
 
      ** If call ends in error(database error)
 
     C                   IF        *IN90 = *ON
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE  = '*CALL  '
     C                   EVAL      DBKEY = 'SD000058'
     C                   EVAL      DBASE = 002
     C                   EVAL      DBPROC = 'SR/MAIN'
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ***Check*each output DSAIMx and Call Equation API driver                               BG12014
      ***program 'H56H1R' if output application code field                                   BG12014
      ***is*non-blank                                                                        BG12014
      **********                                                                             BG12014
     C**********         EVAL      W#Ctr = 1                                                 BG12014
      **********                                                                             BG12014
     C**********         DOW       W#Ctr <= 11                                               BG12014
     C**********         SELECT                                                              BG12014
     C**********         WHEN      W#Ctr = 1                                                 BG12014
     C**********         EVAL      W#DSAIM = DSAIM2                                          BG12014
      **********                                                                             BG12014
     C**********         WHEN      W#Ctr = 2                                                 BG12014
     C**********         EVAL      W#DSAIM = DSAIM3                                          BG12014
      **********                                                                             BG12014
     C**********         WHEN      W#Ctr = 3                                                 BG12014
     C**********         EVAL      W#DSAIM = DSAIM4                                          BG12014
      **********                                                                             BG12014
     C**********         WHEN      W#Ctr = 4                                                 BG12014
     C**********         EVAL      W#DSAIM = DSAIM5                                          BG12014
      **********                                                                             BG12014
     C**********         WHEN      W#Ctr = 5                                                 BG12014
     C**********         EVAL      W#DSAIM = DSAIM6                                          BG12014
      **********                                                                             BG12014
     C**********         WHEN      W#Ctr = 6                                                 BG12014
     C**********         EVAL      W#DSAIM = DSAIM7                                          BG12014
      **********                                                                             BG12014
     C**********         WHEN      W#Ctr = 7                                                 BG12014
     C**********         EVAL      W#DSAIM = DSAIM8                                          BG12014
      **********                                                                             BG12014
     C**********         WHEN      W#Ctr = 8                                                 BG12014
     C**********         EVAL      W#DSAIM = DSAIM9                                          BG12014
      **********                                                                             BG12014
     C**********         WHEN      W#Ctr = 9                                                 BG12014
     C**********         EVAL      W#DSAIM = DSAIM10                                         BG12014
      **********                                                                             BG12014
     C**********         WHEN      W#Ctr = 10                                                BG12014
     C**********         EVAL      W#DSAIM = DSAIM11                                         BG12014
      **********                                                                             BG12014
     C**********         WHEN      W#Ctr = 11                                                BG12014
     C**********         EVAL      W#DSAIM = DSAIM12                                         BG12014
      **********                                                                             BG12014
     C**********         ENDSL                                                               BG12014
      **********                                                                             BG12014
     C**********         EVAL      W#VFAPP = %SUBST(W#DSAIM : 1 : 1)                         BG12014
      **********                                                                             BG12014
     C**********         IF        (W#VFAPP <> *Blank) AND                                   BG12014
     C**********                   (%SUBST(W#DSAIM:27:216) <> *Blank)                        BG12014
      **********                                                                             BG12014
      ***Populate parameters for Equation API                                                BG12014
      **********                                                                             BG12014
     C**********         EXSR      SETPARM                                                   BG12014
      **********                                                                             BG12014
      ***Call*Equation API                                                                   BG12014
      **********                                                                             BG12014
     C**********         EXSR      CALLAPI                                                   BG12014
      **********                                                                             BG12014
     C**********         ENDIF                                                               BG12014
      **********                                                                             BG12014
     C**********         EVAL      W#Ctr = W#Ctr + 1                                         BG12014
     C**********         ENDDO                                                               BG12014
                                                                                             BG12014
      ** Check each output DSAIMx                                                            BG12014
     C                   EXSR      CHKDSAIM                                                  BG12014
                                                                                             BG12014
      ** Setup Delete Parameter when delete from midas occurs                               BUG14024
     C                   IF        TRGEVENT = '2' And                                       BUG14024
     C                             A_DGLCCD = '***'                                         BUG14024
     C                   EVAL      %SUBST(AIMG : 17 : 366) = *BLANKS                        BUG14024
     C                   ENDIF                                                              BUG14024
                                                                                            BUG14024
     C                   IF        TRGEVENT = '3' or TRGEVENT = '2'                         BUG14024
     C                   EVAL      BIMG = WDSAIMD                                           BUG14024
     C                   ENDIF                                                              BUG14024
      ** Call program to setup Equation Currency Calendar Holidays                           BG12014
      ** Details for REMOVING HOLIDAYS                                                       BG12014
                                                                                             BG12014
     C                   CALL      'SD000058'                           90                   BG12014
     C                   PARM                    AIMG                                        BG12014
     C                   PARM                    BIMG                                        BG12014
     C                   PARM      '7'           W#VFTTP                                     BG12014
     C                   PARM                    DSAIM2                                      BG12014
     C                   PARM                    DSAIM3                                      BG12014
     C                   PARM                    DSAIM4                                      BG12014
     C                   PARM                    DSAIM5                                      BG12014
     C                   PARM                    DSAIM6                                      BG12014
     C                   PARM                    DSAIM7                                      BG12014
     C                   PARM                    DSAIM8                                      BG12014
     C                   PARM                    DSAIM9                                      BG12014
     C                   PARM                    DSAIM10                                     BG12014
     C                   PARM                    DSAIM11                                     BG12014
     C                   PARM                    DSAIM12                                     BG12014
                                                                                             BG12014
      ** If call ends in error(database error)                                               BG12014
                                                                                             BG12014
     C                   IF        *IN90 = *ON                                               BG12014
     C     *LOCK         IN        LDA                                                       BG12014
     C                   EVAL      DBFILE  = '*CALL  '                                       BG12014
     C                   EVAL      DBKEY = 'SD000058'                                        BG12014
     C                   EVAL      DBASE = 008                                               BG12014
     C                   EVAL      DBPROC = 'SR/MAIN'                                        BG12014
     C                   OUT       LDA                                                       BG12014
     C                   EXSR      *PSSR                                                     BG12014
     C                   ENDIF                                                               BG12014
                                                                                             BG12014
      ** Check each output DSAIMx                                                            BG12014
     C                   EXSR      CHKDSAIM                                                  BG12014
                                                                                             BG12014
     C                   ENDIF
 
      ** If Location Code in After Image is Not Blanks then Call
      ** program to setup the Equation details of the Branch
      ** Calendar
 
     C                   IF        A_DGLCCD <> '***'
 
     C                   IF        TRGEVENT = '1'                                           BUG13704
     C                   CALL      'SD000059'                           90
     C                   PARM                    AIMG                           Input Parameter
     C                   PARM                    DSAIM1                         Output Parameter
     C                   ELSE                                                               BUG13704
     C                   CALL      'SD000059'                           90                  BUG13704
     C                   PARM                    BIMG                       Input Parameter BUG13704
     C                   PARM                    DSAIM1                     Output ParameterBUG13704
     C                   ENDIF                                                              BUG13704
 
      ** If Call fails produce Database Error
 
     C                   IF        *IN90 = *ON
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE  = '*CALL  '
     C                   EVAL      DBKEY = 'SD000059'
     C                   EVAL      DBASE = 003
     C                   EVAL      DBPROC = 'SR/MAIN'
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Populate parameters for Equation API
 
     C                   EVAL      W#DSAIM = DSAIM1
     C                   EVAL      W#Flag = 'B'
     C                   EXSR      SETPARM
 
      ** Call Equation API
      ** for Branch Calendar Year Only in Case of INSERT                                     BG12014
                                                                                             BG12014
     C**********         IF        TRGEVENT = '1'                                   BG12014 BUG13704
     C                   IF        TRGEVENT = '1' or TRGEVENT = '2'                         BUG13704
 
     C                   IF        A_DGLCCD <> '***' and TRGEVENT = '1'                     BUG13704
     C                   EVAL      %subst(dsaim:26:3) = A_DGCYCD                            BUG13704
     C                   ELSE                                                               BUG13704
     C                   EVAL      %subst(dsaim:26:1) = 'D'                                 BUG13704
     C                   EVAL      %subst(dsaim:29:2) = *blanks                             BUG13704
     C     B_DGCYCD      CHAIN     SDHOLL0                                                  BUG13704
     C                   IF        %FOUND(SDHOLL0)                                          BUG13704
     C                   DOU       *IN90 = *ON                                              BUG13704
     C                   EVAL      WYR = %INT(%SUBST(DGYRNB:3:2))                           BUG13704
     C                   IF        %SUBST(DGYRNB:1:2) = '20'                                BUG13704
     C                   EVAL      WYR = WYR + 100                                          BUG13704
     C                   ENDIF                                                              BUG13704
     C                   EVAL      WPOS = WYR + 84                                          BUG13704
     C                   EVAL      %SUBST(dsaim:WPOS:1) = 'Y'                               BUG13704
     C     B_DGCYCD      READE     SDHOLL0                                90                BUG13704
     C                   ENDDO                                                              BUG13704
     C                   ENDIF                                                              BUG13704
     C                   ENDIF                                                              BUG13704
     C                   EXSR      CALLAPI
 
     C                   ENDIF                                                               BG12014
                                                                                             BG12014
      ** Call program to setup Equation Branch Calendar Holidays
      ** Details
      ** (Adding Holidays)                                                                   BG12014
 
     C                   CALL      'SD000060'                           90
     C                   PARM                    AIMG                           Input Parameter
     C                   PARM                    BIMG                                        BG12014
     C                   PARM                    DSAIM2                         Output Parameter
     C                   PARM                    DSAIM3                         Output Parameter
     C                   PARM                    DSAIM4                         Output Parameter
     C                   PARM                    DSAIM5                         Output Parameter
     C                   PARM                    DSAIM6                         Output Parameter
     C                   PARM                    DSAIM7                         Output Parameter
     C                   PARM                    DSAIM8                         Output Parameter
     C                   PARM                    DSAIM9                         Output Parameter
     C                   PARM                    DSAIM10                        Output Parameter
     C                   PARM                    DSAIM11                        Output Parameter
     C                   PARM                    DSAIM12                        Output Parameter
 
      ** If Call fails produce Database Error
 
     C                   IF        *IN90 = *ON
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE  = '*CALL  '
     C                   EVAL      DBKEY = 'SD000060'
     C                   EVAL      DBASE = 004
     C                   EVAL      DBPROC = 'SR/MAIN'
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Check each output DSAIMx and Call Equation API driver
      ** program 'H56H1R' if output application code field is
      ** non-blank
 
     C                   EVAL      W#Ctr = 1
 
     C                   DOW       W#Ctr <= 11
     C                   SELECT
     C                   WHEN      W#Ctr = 1
     C                   EVAL      W#DSAIM = DSAIM2
 
     C                   WHEN      W#Ctr = 2
     C                   EVAL      W#DSAIM = DSAIM3
 
     C                   WHEN      W#Ctr = 3
     C                   EVAL      W#DSAIM = DSAIM4
 
     C                   WHEN      W#Ctr = 4
     C                   EVAL      W#DSAIM = DSAIM5
 
     C                   WHEN      W#Ctr = 5
     C                   EVAL      W#DSAIM = DSAIM6
 
     C                   WHEN      W#Ctr = 6
     C                   EVAL      W#DSAIM = DSAIM7
 
     C                   WHEN      W#Ctr = 7
     C                   EVAL      W#DSAIM = DSAIM8
 
     C                   WHEN      W#Ctr = 8
     C                   EVAL      W#DSAIM = DSAIM9
 
     C                   WHEN      W#Ctr = 9
     C                   EVAL      W#DSAIM = DSAIM10
 
     C                   WHEN      W#Ctr = 10
     C                   EVAL      W#DSAIM = DSAIM11
 
     C                   WHEN      W#Ctr = 11
     C                   EVAL      W#DSAIM = DSAIM12
 
     C                   ENDSL
 
     C                   EVAL      W#VFAPP = %SUBST(W#DSAIM : 1 : 1)
 
     C**********         IF        W#VFAPP <> *Blank
     C                   IF        (W#VFAPP <> *Blank) AND                                   BG12014
     C                             (%SUBST(W#DSAIM:26:432) <> *Blank)                        BG12014
 
      ** Populate parameters for Equation API
 
     C                   EXSR      SETPARM
 
      ** Change @RPGM for Branch Holidays                                                    BG12014
                                                                                             BG12014
     C                   EVAL      @RPGM = 'C23MRR'                                          BG12014
                                                                                             BG12014
      ** Set Function type as 'M' for Insert for Branch Holidays                             BG12014
                                                                                             BG12014
     C                   IF        TRGEVENT = '1'                                            BG12014
     C                   EVAL      @JTT = 'M'                                                BG12014
     C                   ENDIF                                                               BG12014
                                                                                             BG12014
      ** Call Equation API
 
     C                   EXSR      CALLAPI
 
     C                   ENDIF
 
     C                   EVAL      W#Ctr = W#Ctr + 1
 
     C                   ENDDO
     C                   ENDIF
 
      ** End Program and Return to Caller
 
     C                   EVAL      *INLR = *ON
     C                   RETURN
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *   SETPARM - Subroutine to set input parameters for calling    *
      *             Equation API driver program 'H56H1R'              *
      *                                                               *
      *   Called by: Called in the Main Processing, CHKDSAIM          *
      *                                                               *
      *   Calls: AOUSERR0                                             *
      *                                                               *
      *****************************************************************
 
     C     SETPARM       BEGSR
 
      ** Function Identifier
 
     C                   IF        W#Flag = 'C'
     C                   EVAL      @RPGM = 'H48FRR'
     C                   ELSE
     C**********         EVAL      @RPGM = 'C23MRR'                                          BG12014
      **                                                                                    BUG13704
     C                   SELECT                                                             BUG13704
     C                   WHEN      TRGEVENT = '1'                                           BUG13704
     C                   EVAL      @RPGM = 'C26ARR'                                          BG12014
                                                                                            BUG13704
     C                   WHEN      TRGEVENT = '2'                                           BUG13704
     C                   EVAL      @RPGM = 'C25MRR'                                         BUG13704
                                                                                            BUG13704
     C                   WHEN      TRGEVENT = '3'                                           BUG13704
     C                   EVAL      @RPGM = 'C23MRR'                                         BUG13704
     C                   ENDSL                                                              BUG13704
     C                   ENDIF
 
     C                   IF        *IN79 = *OFF                                            BUG14620C
     C                   EVAL      @BRNM = A8BRCD                                          BUG14620C
     C                   ELSE                                                              BUG14620C
                                                                                           BUG14620C
      ** Access Job User's Default Branch and setup as Input Branch
 
     C                   CALL      'AOUSERR0'
     C                   PARM      *Blanks       @RTCD                          I/O Parameter
     C                   PARM      '*KEY'        @OPTN                          Input Parameter
     C                   PARM                    PSUSER                         Input Parameter
     C     SDUSER        PARM      SDUSER        DSSDY                          Output Parameter
 
     C                   IF        @RTCD <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE   =  'MUSERDD'
     C                   EVAL      DBKEY   =  PSUSER
     C                   EVAL      DBASE   =   005
     C                   EVAL      DBPROC =  'SR/SETPARM'
     C                   OUT       LDA
     C                   EXSR      *PSSR
 
     C                   ELSE
 
     C                   EVAL      @BRNM = DBRN
     C                   ENDIF
 
     C                   ENDIF                                                             BUG14620C
                                                                                           BUG14620C
      ** User Identifier
 
     C                   EVAL      @USID = %SUBST (PSUser:1:4)
 
      ** Workstation Identifier
     C
     C                   EVAL      @WSID = 'MIDA'
 
      ** Set Function type as 'A' for Insert or 'D for Delete or 'M'
      ** for Modify based on Trigger Event
 
     C                   IF        TRGEVENT = '1'
     C                   EVAL      @JTT = 'A'
     C                   ENDIF
 
     C                   IF        TRGEVENT = '2'
     C                   EVAL      @JTT = 'D'
     C                   ENDIF
 
     C                   IF        TRGEVENT = '3'
     C                   EVAL      @JTT = 'M'
     C                   ENDIF
 
      ** Transaction serialisation
 
     C                   EVAL      DSAIM = W#DSAIM
 
      ** Return Code
 
     C                   EVAL      @RREC = *Blanks
 
      ** Error Message
 
     C                   EVAL      @RMES7 = *Blanks
 
      ** Warning Messages
 
     C                   EVAL      @AOW = *Blanks
 
      ** Enigma Transaction
 
     C                   EVAL      @ETK = *Blanks
 
      ** Enigma Transaction number
 
     C**********         EVAL      @ETN = *Zeros                                             BG12014
     C                   Z-ADD     0             @ETN                                        BG12014
 
      ** Apply transaction during external input
 
     C                   EVAL      @AEXT = 'N'
 
      ** Apply transaction during recovery
 
     C                   EVAL      @AREC = 'N'
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *   CALLAPI - Subroutine to Call Equation API driver program    *
      *             H56H1R                                            *
      *                                                               *
      *   Called by: Called in the Main Processing, CHKDSAIM          *
      *                                                               *
      *   Calls: H56H1R                                               *
      *                                                               *
      *****************************************************************
 
     C     CALLAPI       BEGSR
 
     C**********         IF        (TRGEVENT = '3') and                           BUG13704  BUG14024
     C                   IF        (TRGEVENT = '2' or TRGEVENT = '3') and                   BUG14024
     C                             A_DGLCCD = '***'                                         BUG13704
     C                                                                                      BUG13704
     C     @KCCY         KLIST                                                              BUG13704
     C                   KFLD                    A_DGCYCD                                   BUG13704
                                                                                            BUG13704
     C     @KCCY         CHAIN     C801LF                                                   BUG13704
                                                                                            BUG13704
     C                   IF        %FOUND(C801LF)                                           BUG13704
     C                   Eval      %SUBST(DSAIM:24:3) = C8CCYN                              BUG13704
     C                   ENDIF                                                              BUG13704
     C                   ENDIF                                                              BUG13704
     C                   EVAL      @PRMEQ = *BLANKS                                          BG12014
                                                                                             BG12014
     C                   CALL      'UTM83C'                             90                   BG12014
     C                   PARM                    @PRMEQ                                      BG12014
                                                                                             BG12014
      ** If Call fails produce Database Error                                                BG12014
                                                                                             BG12014
     C                   IF        *IN90 = *ON                                               BG12014
     C     *LOCK         IN        LDA                                                       BG12014
     C                   EVAL      DBFILE  = '*CALL  '                                       BG12014
     C                   EVAL      DBKEY = 'UTM83C'                                          BG12014
     C                   EVAL      DBASE = 007                                               BG12014
     C                   EVAL      DBPROC = 'SR/CALLAPI'                                     BG12014
     C                   OUT       LDA                                                       BG12014
     C                   EXSR      *PSSR                                                     BG12014
     C                   ENDIF                                                               BG12014
                                                                                             BG12014
     C                   IF        TRGEVENT = '2' and                                       BUG14024
     C                             B_DGLCCD = '***'                                         BUG14024
     C                   EVAL      @JTT = 'M'                                               BUG14024
     C                   ENDIF                                                              BUG14024
                                                                                            BUG14024
     C                   CALL      'H56H1R'                             90
     C                   PARM                    @RPGM
     C                   PARM                    @BRNM
     C                   PARM                    @USID
     C                   PARM                    @WSID
     C                   PARM                    @JTT
     C                   PARM                    DSAIM
     C                   PARM                    @RREC
     C                   PARM                    @RMES7
     C                   PARM                    @AOW
     C                   PARM                    @ETK
     C                   PARM                    @ETN
     C                   PARM                    @AEXT
     C                   PARM                    @AREC
 
      ** If Call fails produce Database Error
 
     C                   IF        *IN90 = *ON
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE  = '*CALL  '
     C                   EVAL      DBKEY = 'H56H1R'
     C                   EVAL      DBASE = 006
     C                   EVAL      DBPROC = 'SR/CALLAPI'
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
     C
     C     @RREC         IFEQ      'F'                                                       BG12014
     C     @RMES7        ANDEQ     'KSM0503'                                                 BG12014
     C                   EVAL      @RREC = 'R'                                               BG12014
     C                   EVAL      @RMES7 = *BLANKS                                          BG12014
     C                   ENDIF                                                               BG12014
      *                                                                                      BG12014
      ** If successful, Output a record to valid message file
 
     C                   IF        @RREC = 'R'
 
     C                   EVAL      VESRC = SOURCE
     C                   EVAL      VEFLN = PFLNAME
     C                   EVAL      VEMBRN = MBRNAME
     C                   EVAL      VETRGE = TRGEVENT
     C                   EVAL      VEBOFF = BOFF
     C                   EVAL      VEBLEN = BLEN
     C                   EVAL      VEAOFF = AOFF
     C                   EVAL      VEALEN = ALEN
     C                   EVAL      VEETYD = EntryData
 
     C                   WRITE     SDVALEQD0
 
     C                   ENDIF
 
      ** If Unsuccessful, Output a record to invalid message file
 
     C                   IF        (@RREC = 'F')
 
     C                   EVAL      IESRC = SOURCE
     C                   EVAL      IEFLN = PFLNAME
     C                   EVAL      IEMBRN = MBRNAME
     C                   EVAL      IETRGE = TRGEVENT
     C                   EVAL      IEBOFF = BOFF
     C                   EVAL      IEBLEN = BLEN
     C                   EVAL      IEAOFF = AOFF
     C                   EVAL      IEALEN = ALEN
     C                   EVAL      IEETYD = EntryData
 
     C                   WRITE     SDEXCPEQD0
 
      ** Set parameters and Send Message to System Operator
 
     C                   EVAL      @RTNC = *Blanks
     C                   EVAL      @MSG = @RMES7
     C                   EVAL      @MSGID = *Blanks
     C                   EVAL      @MSGF = *Blanks
 
     C                   CALLB     'ZAMSGTOOPR'
     C                   PARM                    @RTNC                          Output Parameter
     C                   PARM                    @MSG                           Input Parameter
     C                   PARM                    @MSGID                         Input Parameter
     C                   PARM                    @MSGF                          Input Parameter
 
     C                   DUMP
 
     C                   RETURN
     C                   ENDIF
                                                                                            BUG13704
     C***********        IF        TRGEVENT = '1' and                              BUG13704 BUG14024
     C***********                  A_DGLCCD = '***' or                             BUG13704 BUG14024
     C***********                  TRGEVENT = '2' and                              BUG13704 BUG14024
     C                   IF        TRGEVENT = '2' and                                       BUG14024
     C                             A_DGLCCD <> '***'                                        BUG13704
     C                   RETURN                                                             BUG13704
     C                   ENDIF                                                              BUG13704
     C                   IF        TRGEVENT = '1' and                                       BUG14024
     C                             A_DGLCCD = '***'                                         BUG14024
     C                   EVAL      TRGEVENT = '3'                                           BUG14024
     C                   ELSE                                                               BUG14024
     C                   ENDIF                                                              BUG14024
 
     C                   ENDSR
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
 
 
      ** Define Entry Parameters List
 
     C     *ENTRY        PLIST
     C                   PARM                    PARM1
 
      ** Defining Data Area
 
     C     *DTAARA       DEFINE                  LDA
 
     C     *DTAARA       DEFINE                  PMODEINIT         1                       BUG14620C
     C                   IN        PMODEINIT                            79                 BUG14620C
      ** Read Branch code                                                                  BUG14620C
     C                   IF        *IN79 = *OFF                                            BUG14620C
     C                   READ      SDBRCHPD                                                BUG14620C
     C                   ENDIF                                                             BUG14620C
                                                                                           BUG14620C
     C                   ENDSR
      *****************************************************************                      BG12014
      /EJECT                                                                                 BG12014
      *****************************************************************                      BG12014
      *                                                               *                      BG12014
      * CHKDSAIM - Check each output DSAIMx and Call Equation API     *                      BG12014
      *            driver program 'H56H1R' if output application code *                      BG12014
      *            Field is non-blank and position 27-242 of DSAIM    *                      BG12014
      *            are Non-Blank                                      *                      BG12014
      *                                                               *                      BG12014
      * Called by: MAIN                                               *                      BG12014
      *                                                               *                      BG12014
      * Calls: None                                                   *                      BG12014
      *                                                               *                      BG12014
      *****************************************************************                      BG12014
                                                                                             BG12014
     C     CHKDSAIM      BEGSR                                                               BG12014
                                                                                             BG12014
     C                   EVAL      W#Ctr = 1                                                 BG12014
                                                                                             BG12014
     C                   DOW       W#Ctr <= 11                                               BG12014
     C                   SELECT                                                              BG12014
     C                   WHEN      W#Ctr = 1                                                 BG12014
     C**********         EVAL      W#DSAIM = DSAIM2                                BG12014 BUG14620D
     C                   EXSR      VALIDATE                                                BUG14620D
                                                                                             BG12014
     C                   WHEN      W#Ctr = 2                                                 BG12014
     C**********         EVAL      W#DSAIM = DSAIM3                                BG12014 BUG14620D
     C                   EXSR      VALIDATE                                                BUG14620D
                                                                                             BG12014
     C                   WHEN      W#Ctr = 3                                                 BG12014
     C**********         EVAL      W#DSAIM = DSAIM4                                BG12014 BUG14620D
     C                   EXSR      VALIDATE                                                BUG14620D
                                                                                             BG12014
     C                   WHEN      W#Ctr = 4                                                 BG12014
     C**********         EVAL      W#DSAIM = DSAIM5                                BG12014 BUG14620D
     C                   EXSR      VALIDATE                                                BUG14620D
                                                                                             BG12014
     C                   WHEN      W#Ctr = 5                                                 BG12014
     C**********         EVAL      W#DSAIM = DSAIM6                                BG12014 BUG14620D
     C                   EXSR      VALIDATE                                                BUG14620D
                                                                                             BG12014
     C                   WHEN      W#Ctr = 6                                                 BG12014
     C**********         EVAL      W#DSAIM = DSAIM7                                BG12014 BUG14620D
     C                   EXSR      VALIDATE                                                BUG14620D
                                                                                             BG12014
     C                   WHEN      W#Ctr = 7                                                 BG12014
     C**********         EVAL      W#DSAIM = DSAIM8                                BG12014 BUG14620D
     C                   EXSR      VALIDATE                                                BUG14620D
                                                                                             BG12014
     C                   WHEN      W#Ctr = 8                                                 BG12014
     C**********         EVAL      W#DSAIM = DSAIM9                                BG12014 BUG14620D
     C                   EXSR      VALIDATE                                                BUG14620D
                                                                                             BG12014
     C                   WHEN      W#Ctr = 9                                                 BG12014
     C**********         EVAL      W#DSAIM = DSAIM10                               BG12014 BUG14620D
     C                   EXSR      VALIDATE                                                BUG14620D
                                                                                             BG12014
     C                   WHEN      W#Ctr = 10                                                BG12014
     C**********         EVAL      W#DSAIM = DSAIM11                               BG12014 BUG14620D
     C                   EXSR      VALIDATE                                                BUG14620D
                                                                                             BG12014
     C                   WHEN      W#Ctr = 11                                                BG12014
     C**********         EVAL      W#DSAIM = DSAIM12                               BG12014 BUG14620D
     C                   EXSR      VALIDATE                                                BUG14620D
                                                                                             BG12014
     C                   ENDSL                                                               BG12014
                                                                                             BG12014
     C                   EVAL      W#VFAPP = %SUBST(W#DSAIM : 1 : 1)                         BG12014
                                                                                             BG12014
     C                   IF        (W#VFAPP <> *Blank) AND                                   BG12014
     C                             (%SUBST(W#DSAIM:27:216) <> *Blank)                        BG12014
                                                                                             BG12014
      ** Populate parameters for Equation API                                                BG12014
                                                                                             BG12014
     C                   EXSR      SETPARM                                                   BG12014
                                                                                             BG12014
      ** Call Equation API                                                                   BG12014
                                                                                             BG12014
     C                   EXSR      CALLAPI                                                   BG12014
                                                                                             BG12014
     C                   ENDIF                                                               BG12014
                                                                                             BG12014
     C                   EVAL      W#Ctr = W#Ctr + 1                                         BG12014
     C                   ENDDO                                                               BG12014
                                                                                             BG12014
     C                   ENDSR                                                               BG12014
      *****************************************************************
      /EJECT
      *****************************************************************
     C     VALIDATE      BEGSR                                                             BUG14620D
      ** Check Ctr number                                                                  BUG14620D
                                                                                           BUG14620D
     C                   SELECT                                                            BUG14620D
     C                   WHEN      W#Ctr = 1                                               BUG14620D
     C                   EVAL      DSAIMVAL = DSAIM2                                       BUG14620D
                                                                                           BUG14620D
                                                                                           BUG14620D
     C                   WHEN      W#Ctr = 2                                               BUG14620D
     C                   EVAL      DSAIMVAL = DSAIM3                                       BUG14620D
                                                                                           BUG14620D
     C                   WHEN      W#Ctr = 3                                               BUG14620D
     C                   EVAL      DSAIMVAL = DSAIM4                                       BUG14620D
                                                                                           BUG14620D
     C                   WHEN      W#Ctr = 4                                               BUG14620D
     C                   EVAL      DSAIMVAL = DSAIM5                                       BUG14620D
                                                                                           BUG14620D
     C                   WHEN      W#Ctr = 5                                               BUG14620D
     C                   EVAL      DSAIMVAL = DSAIM6                                       BUG14620D
                                                                                           BUG14620D
     C                   WHEN      W#Ctr = 6                                               BUG14620D
     C                   EVAL      DSAIMVAL = DSAIM7                                       BUG14620D
                                                                                           BUG14620D
     C                   WHEN      W#Ctr = 7                                               BUG14620D
     C                   EVAL      DSAIMVAL = DSAIM8                                       BUG14620D
                                                                                           BUG14620D
     C                   WHEN      W#Ctr = 8                                               BUG14620D
     C                   EVAL      DSAIMVAL = DSAIM9                                       BUG14620D
                                                                                           BUG14620D
     C                   WHEN      W#Ctr = 9                                               BUG14620D
     C                   EVAL      DSAIMVAL = DSAIM10                                      BUG14620D
                                                                                           BUG14620D
     C                   WHEN      W#Ctr = 10                                              BUG14620D
     C                   EVAL      DSAIMVAL = DSAIM11                                      BUG14620D
                                                                                           BUG14620D
     C                   WHEN      W#Ctr = 11                                              BUG14620D
     C                   EVAL      DSAIMVAL = DSAIM12                                      BUG14620D
                                                                                           BUG14620D
     C                   ENDSL                                                             BUG14620D
      *                                                                                    BUG14620D
     C                   Eval      #Y = 6                                                  BUG14620D
     C                   Eval      #A = 27                                                 BUG14620D
     C                   Eval      #T = 1                                                  BUG14620D
     C                   EVAl      WDSAIMDAT = %SUBST(DSAIMVAL:#A:#Y)                      BUG14620D
     C                   EVAL      WDSAIMDATST = WDSAIMDAT                                 BUG14620D
      *                                                                                    BUG14620D
     C                   DOU       WDSAIMDAT = *BLANKS OR WDSAIMDAT2S = *BLANK             BUG14620D
     C                   IF        WDSAIMDAT <> *BLANKS                                    BUG14620D
     C                   MOVE      WDSAIMDAT     WIVALDAT                                  BUG14620D
     C                   Eval      WIDD1 = WIDD                                            BUG14620D
     C                   Eval      WIMM1 = WIMM                                            BUG14620D
     C                   Eval      WIYY1 = WIYY                                            BUG14620D
     C                   IF        WIYY1 > 40                                              BUG14620D
     C                   EVAL      WICC1 = 19                                              BUG14620D
     C                   ELSE                                                              BUG14620D
     C                   EVAL      WICC1 = 20                                              BUG14620D
     C                   ENDIF                                                             BUG14620D
     C                   Eval      DATE1 = %DATE(WIVALDAT1)                                BUG14620D
     C                   Eval      DATE2 = %DATE(WRDDMMYY)                                 BUG14620D
     C                   IF        DATE1 >= DATE2                                          BUG14620D
     C                   Eval      %SUBST(WDSAIMDATDS:#T:#Y) = WDSAIMDAT                   BUG14620D
     C                   Eval      #T = #T + #Y                                            BUG14620D
     C                   ENDIF                                                             BUG14620D
     C                   Eval      #A = #A + #Y                                            BUG14620D
     C                   EVAl      WDSAIMDAT = %SUBST(DSAIMVAL:#A:#Y)                      BUG14620D
     C                   EVAL      WDSAIMDATST = WDSAIMDAT                                 BUG14620D
     C                   ENDIF                                                             BUG14620D
     C                   ENDDO                                                             BUG14620D
      *                                                                                    BUG14620D
     C                   Eval      %SUBST(DSAIMVAL:27:216) = WDSAIMDATDS                   BUG14620D
     C                   Eval      W#DSAIM = DSAIMVAL                                      BUG14620D
      *                                                                                    BUG14620D
     C                   ENDSR                                                             BUG14620D
      *****************************************************************                    BUG14620D
      /EJECT                                                                               BUG14620D
      *****************************************************************                    BUG14620D
**  CPY@
(c) Finastra International Limited 2006
**  @@MTH
JANFEBMARAPRMAYJUNJULAUGSEPOCTNOVDEC
