     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2006')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Equation Holidays to Branch Calendars  Mapping')
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SD000059 - Equation Holidays to Currency Calendars Mapping   *
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
      *  Prev Amend No. BG12014            Date 16Nov06               *
      *                 CRE026  *CREATE    Date 24May06               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
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
 
      ** External DS based on Midas Holidays file
     DAIMG           E DS                  EXTNAME(SDHOLPD)
 
      ** External DS based on Midas user details file
     DSDUSER         E DS                  EXTNAME(MUSERDD)
 
      ** External DS based on Midas currency file
     DSDCURR         E DS                  EXTNAME(SDCURRPD)
 
      ** Second DS for access programs, long data structure
     DDSSDY          E DS                  EXTNAME(DSSDY)
 
      ** Data Structure
     DDSAIM            DS
     D***VFAPP**                  1      1                                                   BG12014
     D***VFWSD**                  2      5                                                   BG12014
     D***VFRBR**                  6      9                                                   BG12014
     D***VFBID**                 10     14                                                   BG12014
     D***VFUID**                 15     22                                                   BG12014
     D***VFTTP**                 23     23                                                   BG12014
     D***GZWSID*                 24     27                                                   BG12014
     D***GZDIM**                 28     29S 0                                                BG12014
     D***GZTIM**                 30     35S 0                                                BG12014
     D***GZSEQ**                 36     39P 0                                                BG12014
     D***GZIMG**                 40     40                                                   BG12014
     D***GZBRNM*                 41     44                                                   BG12014
     D***GZREG**                 45     47                                                   BG12014
     D***GZALL**                 48     48                                                   BG12014
     D***GZCCY**                 49     51                                                   BG12014
     D***VFCLY**                 52    123                                                   BG12014
     D***VF001**                124   9999                                                   BG12014
                                                                                             BG12014
     D GZWSID                  1      4                                                      BG12014
     D GZDIM                   5      6S 0                                                   BG12014
     D GZTIM                   7     12S 0                                                   BG12014
     D GZSEQ                  13     16P 0                                                   BG12014
     D GZIMG                  17     17                                                      BG12014
     D GZBRNM                 18     21                                                      BG12014
     D GZREG                  22     24                                                      BG12014
     D GZALL                  25     25                                                      BG12014
     D GZCCY                  26     28                                                      BG12014
     D VFCLY                  29     30                                                      BG12014
     D VF001                  31   9999                                                      BG12014
 
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
     C**********         EVAL      VFRBR  = DBRN                         Input branch number BG12014
     C**********         ENDIF                                                               BG12014
      **********                                                                             BG12014
     C**********         EVAL      VFBID  = %SUBST (PSUser : 1 : 5)      Trans. identifier   BG12014
     C**********         EVAL      VFUID  = %SUBST (PSUser : 1 : 8)      User identifier     BG12014
     C**********         EVAL      VFTTP  = 'BLANKS'                     Transaction type    BG12014
     C**********         EVAL      VFTTP  = *BLANKS                                          BG12014
     C                   EVAL      GZWSID = 'MIDA'                              Wrkstn Identifier
     C                   EVAL      GZDIM  = 0                                   Day in Month
     C                   EVAL      GZTIM  = 0                                   Time(hhmmss)
     C                   EVAL      GZSEQ  = 0                                   Number Sequence
     C                   EVAL      GZIMG  = *BLANKS                             Journal Image
     C                   EVAL      GZDIM  = *ZEROS                              Branch Mnemonic
     C                   EVAL      GZREG  = DGLCCD                              Region Code
     C                   EVAL      GZALL  = 'N'                                 All Branches
 
      ***To*Retrieve the Currency Number                                                     BG12014
      **********                                                                             BG12014
     C**********         CALL      'AOCURRR0'                                                BG12014
     C**********         PARM      *BLANKS       @RTCD                                       BG12014
     C**********         PARM      '*KEY'        @OPTN                                       BG12014
     C**********         PARM                    DGCYCD                                      BG12014
     C*****SDCURR        PARM      SDCURR        DSSDY                                       BG12014
      **********                                                                             BG12014
     C**********         IF        @RTCD <> *BLANKS                                          BG12014
     C******LOCK         IN        LDA                                                       BG12014
     C**********         EVAL      DBFILE   =  'SDCURRPD'                                    BG12014
     C**********         EVAL      DBKEY   =  DGCYCD                                         BG12014
     C**********         EVAL      DBASE   =   002                                           BG12014
     C**********         EVAL      DBPROC =  'SR/MAIN'                                       BG12014
     C**********         OUT       LDA                                                       BG12014
     C**********         EXSR      *PSSR                                                     BG12014
      **********                                                                             BG12014
     C**********         ELSE                                                                BG12014
      **********                                                                             BG12014
     C**********         MOVE      A6ISON        GZCCY                                       BG12014
      **********                                                                             BG12014
     C**********         ENDIF                                                               BG12014
                                                                                             BG12014
      ** Currency Mnemonic                                                                   BG12014
     C                   EVAL      GZCCY = *BLANKS                                           BG12014
 
      ** Calendar years required
 
     C                   EVAL      VFCLY = %SUBST(DGYRNB : 3 : 2)
 
      ** Filler
 
     C                   EVAL      VF001 = *BLANKS
 
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
 
      ** Initialize Output Parameter
     C                   EVAL      DSAIM = *BLANKS
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
**  CPY@
(c) Finastra International Limited 2006
