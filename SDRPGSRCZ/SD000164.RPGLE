     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2014')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas SD Calculate Account Review Frequency')          *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data module                                 *
      *                                                               *
      *  SD000164 - Midas SD Account Review Calculate Schedule Date   *
      *                                                               *
      *  Function:  This module takes inputs of account review        *
      *             frequency and run day number to calculate and     *
      *             return schedule date                              *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2014            *
      *                                                               *
      *  Last Amend No. MD026502  *CREATE  Date 01May14               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD026502 - Account review generated when a customer is       *
      *             tagged as high value account have incorrect       *
      *             scheduled date                                    *
      *                                                               *
      *****************************************************************
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      **
     D/COPY ZACPYSRC,STD_D_SPEC
 
      ** The following /COPY includes the MM standard declares:
     D/COPY ZACPYSRC,STDDECLARE
 
     D/COPY ZACPYSRC,PSDS
 
     D/COPY ZACPYSRC,ERR_XARRYS
 
      ** +--------------------------------------+
      ** ¦ End of automatically included D-specs¦
      ** ¦ =====================================¦
      ** +--------------------------------------+
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ Manually included D-specs            ¦
      ** ¦ =========================            ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
      ** Second DS for access programs, long data structure
     D DSSDY         E DS                  EXTNAME(DSSDY)
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
      ** Define work field Return code
     D W0RTN           S              7
      ** Define work field Work Screen Date
     D WUWSDT          S              6  0
      ** Define work field Date format flag
     D WUDFF           S              1
      ** Define work field Work File Date
     D WUWFDT          S              5  0
 
      ** Index for arrays of error message ids etc
     D Idx             S              3P 0
 
      ** Index for arrays of warning message ids
     D WIx             S              3P 0
 
     D ZFMD            S              2    DIM(12) CTDATA PERRCD(12)
     D ZYDY            S              4  0 DIM(4) CTDATA PERRCD(4)
     D ZMDY            S              3  0 DIM(13) CTDATA PERRCD(13)
     D ZMNM            S              3    DIM(12) CTDATA PERRCD(12)
     D ZHL             S              1    DIM(366)
     D ZHL1            S              1    DIM(366)
     D WRun            S              1A
     D WDATE           S              6
     D DDACRF          S              1
     D WWDFIN          S              1
     D WWCYCD          S              3
     D WWLCCY          S              3
     D WWSLCD          S              3
     D DFSCDT          S              5P 0
     D WDCOMP          S              1
     D ZADATE          S              7
 
     D ZHOLDS          DS
 
      ** Data structure defined over holiday file fields
      ** Data structure has been copied from ZHOLILE
      ** and some definitions renamed due to naming conflicts
 
     D  DGCYCD                 1      3
     D  DGLCCD                 4      6
     D  DGYRNB                 7     10  0
     D  DGJDNB                11     13P 0
     D  DGDDNB                14     16P 0
     D  ZDS1                  17    202
     D  ZDS2                 203    382
     D  ZHL0                  17    382
 
     D ZVARS           DS
 
      ** Data structure to define variables used in holiday subroutines
 
     D  ZIND                   1      1
     D  ZINDX                  2      4  0
     D  ZDAYNO                 5      7P 0
     D  ZDYNBR                 8     10P 0
     D  ZNRDYS                11     12  0
     D  @ZWRDY                13     14  0
 
     D  ZCCY                  15     17
     D  ZLOC                  18     20
     D  @ZWRKI                15     20
 
     D  ZSCCY                 21     23
     D  ZSLOC                 24     26
     D  ZSWEXX                27     30  0
     D  ZSJAN                 31     33P 0
     D  ZSDCM                 34     36P 0
     D  RTNCD                 37     43
     D  @ZWRKO                21     43
 
     D  ZOPTN                 44     50
     D  ZZCCY                 51     53
     D  ZZLOC                 54     56
     D  ZZDYNO                57     59P 0
     D  ZSRTN                 60     66
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** Initialization
 
     C                   MOVE      *BLANK        ReturnCode
 
 
     C                   EVAL      ZFREQ = DDACRF
     C                   EVAL      ZDAYNO = WWRDNB
     C                   EVAL      ZCCY = WWCYCD
     C                   EVAL      ZLOC = *BLANKS
 
     C                   EXSR      ZNDAR
 
     C                   EVAL      DFSCDT = ZDAYNO
 
      ** Return
 
     C                   RETURN
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      *                                                               *
      *****************************************************************
 
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
 
      ** Return Code
     C                   PARM                    ReturnCode
 
      ** Account Review Frequency
     C                   PARM                    DDACRF
     C                   PARM                    WDCOMP
     C                   PARM                    WWDFIN
     C                   PARM                    WWCYCD
     C                   PARM                    WWLCCY
     C                   PARM                    WWSLCD
      ** Run Day Number
     C                   PARM                    WWRDNB            5 0
      ** Output
     C                   PARM                    DFSCDT
 
     C     WWDFIN        COMP      'M'                                    98
 
     C/COPY ZACPYSRC,DBFIELDS
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
     C/COPY ZSRSRC,ZCHKHLE
     C/COPY ZSRSRC,ZNDAR_ILE
     C/COPY ZSRSRC,ZACCHLE
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *PSSR  - Program exception error routine                     *
      *          Called automatically if a program error occurs,      *
      *          or directly by the program code using EXSR.          *
      *          This subroutine DUMPs the program just once.         *
      *                                                               *
      *  Called by: *INZSR                                            *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
      *
     C     *PSSR         BEGSR
      *
     C                   IF        WRun = *BLANKS
     C                   EVAL      WRun = 'Y'
     C                   EVAL      DBPGM = 'SD000164'
     C                   DUMP
     C                   CALL      'DBERRCTL'
      *
     C                   ENDIF
      *
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
      *
     C                   RETURN
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
**  CPY@
(c) Misys International Banking Systems Ltd. 2014
**   ZFMD  -  NUMBER OF DAYS IN THE MONTH
312831303130313130313031
**   ZYDY - YEARS IN DAYS CUMULATIVE, FOUR YEAR SPAN
0366073110961461
**   ZMDY - MONTHS IN DAYS CUMULATIVE THROUGH YEAR
000031059090120151181212243273304334365
**   ZMNM - MONTHS SHORT NAMES
JANFEBMARAPRMAYJUNJULAUGSEPOCTNOVDEC
