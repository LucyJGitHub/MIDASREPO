     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas ZA Calc no of interest days between 2 dates')    *
      *****************************************************************
      *                                                               *
      *  Midas - Copy Source converted into ILE procedures            *
      *                                                               *
      *  ZINTDY - Calculate the number of interest days between       *
      *           two dates.                                          *
      *                                                               *
      *  Function:  This module calculates the number of interest     *
      *             days between two days in the Midas day number     *
      *             format                                            *
      *                                                               *
      *  This module is an ILE/RPG IV conversion of the ZINTDY        *
      *  subroutine.  The subroutine consists of two /COPY members.   *
      *  Each of these has been converted to ILE RPG and copied into  *
      *  this member.  Necessary code to make this compileable has    *
      *  been added (entry and exit points and some declares).        *
      *                                                               *
      *  The existing code has not been changed except:               *
      *  - to remove dead lines                                       *
      *  - to convert a couple of EXSRs to CALLBs                     *
      *  The boundaries of the original /COPY members have been       *
      *  marked, to facilitated future maintenance of both the old    *
      *  members and this one.                                        *
      *                                                               *
      *  If this member has to change, the changes should ALMOST      *
      *  CERTAINLY be implemented by changing the old /COPY member,   *
      *  reconverting it using CVTRPGSRC, and copying it into this    *
      *  member, replacing the existing section and re-changing the   *
      *  EXSRs to CALLBs.                                             *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *    This source is centrally supported and must ONLY be        *
      *    amended by Core Development Personnel                      *
      *                                                               *
      *    /COPY, Client or Country amendments must not be            *
      *    applied to this source.                                    *
      *                                                               *
      *  Last Amend No. MD053295           Date 13Apr19               *
      *  Prev Amend No. MD028207           Date 13Apr19               *
      *                 MD046248           Date 05Feb18               *
      *                 MD047993           Date 23Sep17               *
      *                 MD035545           Date 11Sep15               *
      *                 AR996895           Date 25Nov12               *
      *                 263666             Date 01Feb10               *
      *                 CER059             Date 19Jul10               *
      *                 CER016A            Date 19May08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 256564             Date 17Sep08               *
      *                 246141             Date 26Mar07               *
      *                 164847             Date 30Nov06               *
      *                 BUG12990           Date 05Jan07               *
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 242286             Date 25Sep06               *
      *                 CIR013             Date 07Apr05               *
      * Midas Release 4.01 -------------------------------------------*
      *                 191870             Date 28Nov01               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.03 -----------------------------------------------*
      *                 CIR004             Date 20Jan00               *
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 CAP002  *CREATE    Date 01Aug97               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD053295 - Lending loan with Interest Calculation Basis      *
      *             method 3 (30/360) has wrong interest payment      *
      *             amount for month of March                         *
      *  MD028207 - Incorrect treatment for calc basis 3 and February.*
      *           - Re-apply cancelled fix MD022792 + MD027042A       *
      *           - Applied for MD053295.                             *
      *  MD046248 - Finastra Rebranding                               *
      *  MD047993 - Modified MD035545. Removed dependency on Accrue   *
      *             on Last Day indicator.                            *
      *  MD035545 - LE: Interest Calculation in Leap year. Consider   *
      *             Accrue on Last Day Indicator for method 6.        *
      *  AR996895 - Incorrect accrual interest calculation            *
      *             (Child:AR996897)                                  *
      *  263666 - Missing a ZZMM1 = 2 condition on processing calc.   *
      *           method 3, ZZDD1 = 1, & ZZDD2 = 28 or 29.            *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER016A - German Interest Calculation: Upgarde of FGE059     *
      *           to Midas Plus                                       *
      *  256564 - Recompile due to PF changes done by fix 256330      *
      *  246141 - Incorrect calculation for method 7 (30E/360).       *
      *           Corrected the calculation to follow Eurobond basis. *
      *  164847 - Interest Calculation method 3 change:               *
      *           For leap year: 01Feb to 29Feb should be 29 days     *
      *                          (including 30Feb)                    *
      *           For non-leap year: 01Feb to 28Feb should be 29 days *
      *                          (including 29Feb and 30Feb)          *
      *  BUG12990 - Subtraction of 1 day from the date range when     *
      *             the end day is 31st should only be applicable to  *
      *             method 3.                                         *
      *  242286 - Enhance computation for calc basis 6.               *
      *  CIR013 - Additional Calculation Method for FRA/IRS/CCF       *
      *  191870 - Calculation Basis 6 processing.                     *
      *  CIR004 - Dealing Calculation Method Change                   *
      *  CAP002 - Conversion of Midas inputs to modular API structure *
      *                                                               *
      *****************************************************************

      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      **
      ** Standard D-specs
      ** ================
      **
      ** The following /COPY line includes the LDA layout,
      ** the copyright array definition,
      ** and the following named constants:
      **    True       logical = *on (for indcator processing)
      **    False      logical = *off (for indcator processing)
      **    DBErrCtl   10A     = 'DBERRCTL' (the name of the database error
      **                                    handler)
      ** and the following variables:
      **    RunBefore  1A (for the PSSR)

     D/COPY ZACPYSRC,STD_D_SPEC

      ** Program Status Data Structure
      ** =============================
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.

     D/COPY ZACPYSRC,PSDS

      **
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
     D*SDGELR***     E DS                  EXTNAME(SDGELRPD)                       MD035545 MD047993

      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
                                                                                              CIR004
     D SCSARD        E DS                  EXTNAME(SCSARDPD)                                  CIR004
      ** External DS for SAR Details                                                          CIR004
                                                                                              CIR004
     D DSFDY         E DS                  EXTNAME(DSFDY)                                     CIR004
      ** Second DS for Access Programs, Long Data Structure                                   CIR004
     D*DSSDY****     E DS                  EXTNAME(DSSDY)                          MD035545 MD047993
      ***Short*Data*Structure*for*Access*Programs**********************            MD035545 MD047993

      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+

      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
     D*PRtrnCode       S              7A                                           MD035545 MD047993
     D*POptn****       S              7A                                           MD035545 MD047993
     D WCALC6          S              1A                                                    MD035545

      ** +-----------------------------------------------------------------+
      ** Declares for variables that were defined externally for the
      ** original copy members
      ** +-----------------------------------------------------------------+

      ** Return code for the ZDATE9 call
     D @@RTN           S              1A

      ** Date returned from ZDATE9
     D  @@VDT          S              8S 0
                                                                                              CIR013
     D                 DS                                                                     CIR013
     D  @@VDTZ                 1      8  0                                                    CIR013
     D  @@YR                   1      4  0                                                    CIR013
     D  @@Z71M                 5      6  0                                                    CIR013
     D  @@Z71D                 7      8  0                                                    CIR013
                                                                                              CIR013
                                                                                              191870
      ** Define Fields for ZDATE10                                                            191870
     D ZZMDNO          S              5P 0                                                    191870
     D ZZDTIN          S              8S 0                                                    191870

      ** +--- The converted ZINTDYZ1 starts here --------------------------+

     D**  DATA STRUCTURE FOR SR. ZINTDY - DATE FIELD YYYYMMDD.
     D                 DS
     D  ZZDATA                 1      8  0
     D  ZZYY1                  1      4  0
     D  ZZMM1                  5      6  0
     D  ZZDD1                  7      8  0
     D*
     D**  DATA STRUCTURE FOR SR. ZINTDY - DATE FIELD YYYYMMDD.
     D                 DS
     D  ZZDATB                 1      8  0
     D  ZZYY2                  1      4  0
     D  ZZMM2                  5      6  0
     D  ZZDD2                  7      8  0
                                                                                            MD035545
     D WPARML          S             20A   INZ('LECalcBasis6LeapYear')                      MD035545

      ** +--- The converted ZINTDYZ1 ends here ----------------------------+

      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *****************************************************************
      /EJECT
      *****************************************************************

     C
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+

      ** Calculate the number of interest days between two dates in the
      **  five-digiot day number format (5,0)
     C                   EXSR      ZINTDY

     C                   IF        ErrorFound = 'Y'
     C                   EVAL      RetCodeIn = 'Error'
     C                   ENDIF

     C                   RETURN

     C/EJECT

      ** +--- The converted ZINTDYZ2 starts here --------------------------+

     C*****************************************************************
     C     ZINTDY        BEGSR

     C     *IN80         IFEQ      '1'
     C                   MOVE      '1'           IN80SV            1
     C                   ELSE
     C                   MOVE      '0'           IN80SV
     C                   END
     C                   MOVE      ZZBEG         ZZBEG             5 0
     C                   MOVE      ZZEND         ZZEND             5 0
     C                   MOVE      ZZCALC        ZZCALC            1
     C                   Z-ADD     *ZEROS        ZZINDY            5 0
     C                   Z-ADD     *ZEROS        ZZLPNM            5 0
     C*
     C**  FIND NUMBER OF DAYS DIFFERENCE BETWEEN DATES
     C     ZZEND         SUB       ZZBEG         ZZWDAT            5 0
     C*
     C****FOR*CALCULATION*METHODS*3,4*OR*5****************************                        191870
      ****For*Calculation*methods*3,4,5*or*6**************************                 191870 CIR013
      ****For*Calculation*methods*3,4,5,*6*or*7*&*CIR004*or*9                         CIR013 CER016A
      **  For Calculation methods 3,4,5, 6 or 7 & CIR004 or 9 or 0                           CER016A
     C     ZZCALC        IFEQ      '3'
     C     ZZCALC        OREQ      '4'
     C     ZZCALC        OREQ      '5'
     C     ZZCALC        OREQ      '6'                                                        191870
     C     ZZCALC        OREQ      '7'                                                        CIR004
     C     CIR004        ANDEQ     'Y'                                                        CIR004
     C     ZZCALC        OREQ      '9'                                                        CIR013
     C     ZZCALC        OREQ      '0'                                                       CER016A
     C*
     C                   Z-ADD     ZZBEG         @@DAYN            5 0

      ** +--- The converted ZINTDYZ2 changes here -------------------------+

     C                   CALLB     'ZDATE9'
     C                   PARM                    @@DAYN
     C                   PARM                    @@VDT
     C                   PARM                    @@RTN

      ** +--- The converted ZINTDYZ2 continues here -----------------------+

     C                   Z-ADD     @@VDT         ZZDATA
     C*
     C                   Z-ADD     ZZEND         @@DAYN

      ** +--- The converted ZINTDYZ2 changes here -------------------------+

     C                   CALLB     'ZDATE9'
     C                   PARM                    @@DAYN
     C                   PARM                    @@VDT
     C                   PARM                    @@RTN

      ** +--- The converted ZINTDYZ2 continues here -----------------------+

     C                   Z-ADD     @@VDT         ZZDATB
     C                   END                                                                  191870
     C*                                                                                       CIR013
     C* Check for the existence of any February 29th within the dates                         CIR013
     C     ZZCALC        IFEQ      '9'                                                        CIR013
     C* ZZDATA (start date) and ZZDATB (end date) are in YYYYMMDD format                      CIR013
     C*                                                                                       CIR013
     C* #29FEB - Flag to represent the existence of a 29th Feb. between                       CIR013
     C*          the start and end dates                                                      CIR013
     C                   MOVE      'N'           #29FEB            1                          CIR013
     C*                                                                                       CIR013
     C* ZZYY1 - start year from data structure over ZZDATA in ZINTDYZ1                        CIR013
     C* #29WKY = incremental year initially at start year                                     CIR013
     C                   Z-ADD     ZZYY1         #29WKY            4 0                        CIR013
     C*                                                                                       CIR013
     C* Move to subfields of @@VDT - data structure from ZDATE9 - 8,0                         CIR013
     C                   Z-ADD     ZZYY1         @@YR                                         CIR013
     C                   Z-ADD     2             @@Z71M                                       CIR013
     C                   Z-ADD     29            @@Z71D                                       CIR013
     C* #29YA - 29/02/start year (fixed workfield)                                            CIR013
     C                   Z-ADD     @@VDTZ        #29YA             8 0                        CIR013
     C* ZZYY2 - end year from data structure over ZZDATB in ZINTDYZ1                          CIR013
     C                   Z-ADD     ZZYY2         @@YR                                         CIR013
     C* #29YB - 29/02/end year (fixed workfield)                                              CIR013
     C                   Z-ADD     @@VDTZ        #29YB             8 0                        CIR013
     C*                                                                                       CIR013
      * Loop round incrementing the year from start to end                                    CIR013
     C     #29WKY        DOUGT     ZZYY2                                                      CIR013
     C* Check to see whether 29/02/xx is a valid date by checking                             CIR013
     C* to see whether any of the years falling between the two dates                         CIR013
     C* are leap years.                                                                       CIR013
     C     ZZDATA        IFLE      #29YA                                                      CIR013
     C     #29WKY        ANDEQ     ZZYY1                                                      CIR013
     C     ZZDATB        ANDGE     #29YA                                                      CIR013
     C     #29WKY        ORGT      ZZYY1                                                      CIR013
     C     #29WKY        ANDLT     ZZYY2                                                      CIR013
     C     ZZDATB        ORGE      #29YB                                                      CIR013
     C     #29WKY        ANDEQ     ZZYY2                                                      CIR013
     C     ZZDATA        ANDLE     #29YB                                                      CIR013
     C*                                                                                       CIR013
     C     #29WKY        DIV       4             ZLYR30            3 0                        CIR013
     C                   MVR                     ZLY               1 0                        CIR013
     C* Leap year                                                                             CIR013
     C     ZLY           IFEQ      0                                                          CIR013
     C                   MOVE      'Y'           #29FEB                                       CIR013
     C                   LEAVE                                                                CIR013
     C                   ENDIF                                                                CIR013
     C                   ENDIF                                                                CIR013
     C*                                                                                       CIR013
     C                   ADD       1             #29WKY                                       CIR013
     C                   ENDDO                                                                CIR013
     C                   ENDIF                                                                CIR013
     C*                                                                                       CIR013
     C     ZZCALC        IFEQ      '3'                                                        191870
     C     ZZCALC        OREQ      '4'                                                        191870
     C     ZZCALC        OREQ      '5'                                                        191870
     C*****ZZCALC        OREQ      '7'                                                 191870 246141
     C*****CIR004        ANDEQ     'Y'                                                 191870 246141
     C     ZZCALC        OREQ      '9'                                                        CIR013
     C     #29FEB        ANDEQ     'N'                                                        CIR013
     C     ZZCALC        OREQ      '0'                                                       CER016A
      *                                                                                       191870
     C*
     C**  IF IN SAME MONTH
     C     ZZYY1         IFEQ      ZZYY2
     C     ZZMM1         IFEQ      ZZMM2
     C     ZZDD2         SUB       ZZDD1         ZZINDY                         - LOAD OUTPT
     C     ZZCALC        IFEQ      '3'                                                      BUG12990
     C     ZZDD2         IFEQ      31
     C     ZZDD1         ANDNE     ZZDD2
     C                   SUB       1             ZZINDY
     C                   END
     C                   ENDIF                                                              BUG12990
      *                                                                                       164847
      ***If*calculation*method*3*and*start*day*of*February                            164847 CER016A
      ** If calculation method 3 or 0 and CER016 is on                                       CER016A
      ** and start day of February                                                           CER016A
      *                                                                                       164847
     C     ZZCALC        IFEQ      '3'                                                        164847
     C     ZZMM1         ANDEQ     2                                                          263666
     C*****ZZDD1         ANDEQ     1                                                 164847 MD028207
     C     ZZMM2         ANDEQ     2                                                        MD028207
     C     ZZCALC        OREQ      '0'                                                       CER016A
     C     CER016        ANDEQ     'N'                                                       CER016A
     C     ZZMM1         ANDEQ     2                                                          263666
     C     ZZDD1         ANDEQ     1                                                         CER016A
      *                                                                                       164847
      ** Test if Leap Year                                                                    164847
      *                                                                                       164847
     C     ZZYY1         DIV       4             ZZWN5                                        164847
     C                   MVR                     ZZWN5                    80                  164847
      *                                                                                       164847
      ** Leap year and last day of the month is 29                                            164847
      *                                                                                       164847
     C     *IN80         IFEQ      '1'                                                        164847
     C     ZZDD2         ANDEQ     29                                                         164847
     C     ZZDD1         ANDNE     ZZDD2                                                    MD028207
      *                                                                                       164847
      ** Not a leap year and the last day of the month is 28                                  164847
      *                                                                                       164847
     C     *IN80         OREQ      '0'                                                        164847
     C     ZZDD2         ANDEQ     28                                                         164847
     C     ZZDD1         ANDNE     ZZDD2                                                    MD028207
      *                                                                                       164847
      ** Start day of Feb to last day Feb should be 29 days                                   164847
      ** (30Feb - 01Feb)                                                                      164847
      *                                                                                       164847
     C**********         Z-ADD     29            ZZINDY                              164847 MD028207
     C     30            SUB       ZZDD1         ZZINDY                                     MD028207
     C                   ENDIF                                                                164847
      *                                                                                       164847
     C                   ENDIF                                                                164847
      *                                                                                       164847
     C                   GOTO      ZINTD9                                       ----------->
     C                   END
     C                   END
     C*
     C                   ELSE
      *                                                                                       191870
     C     ZZCALC        IFEQ      '6'                                                        191870
     C     ZZCALC        OREQ      '9'                                                        CIR013
     C     #29FEB        ANDEQ     'Y'                                                        CIR013
      *                                                                                       191870
     C                   Z-ADD     0             LEAP50            5 0                        191870
     C                   Z-ADD     0             NLEAP             5 0                        191870
      *                                                                                       191870
     C     ZZYY1         IFEQ      ZZYY2                                                      191870
     C     ZZYY1         DIV       4             ZZWN5                                        191870
     C                   MVR                     ZZWN5                                        191870
     C     ZZWN5         IFNE      0                                                          191870
     C                   ADD       ZZWDAT        NLEAP                                        191870
     C                   ELSE                                                                 191870
     C                   ADD       ZZWDAT        LEAP50                                       191870
     C                   END                                                                  191870
      *                                                                                       191870
     C                   ELSE                                                                 191870
      *                                                                                       191870
     C                   Z-ADD     ZZDATB        DATBSV            8 0                        191870
     C                   Z-ADD     ZZYY2         YY2SAV            4 0                        191870
      *                                                                                       191870
      ***Get*Midas*day*number*for*1st*Jan*of*year*after*start*date*****            MD035545 MD047993
      ***when*accrue*on*last*day*is*'N';*get*midas*day*number*for*31***            MD035545 MD047993
      ***dec*of*the*start*date*year*when*accrue*on*last*day*is*Y*******            MD035545 MD047993
      ***and*LECalcBasis6LeapYear*=*'Y'********************************            MD035545 MD047993
      ** Get Midas Day Number for 31 Dec of the start date year when                        MD047993
      ** LECalcBasis6LeapYear = 'Y'                                                         MD047993
      *                                                                                     MD035545
     C     WCALC6        IFEQ      'Y'                                                      MD035545
     C                   Z-ADD     ZZYY1         ZZYY2                                      MD035545
     C                   MOVE      '12'          ZZMM2                                      MD035545
     C                   MOVE      '31'          ZZDD2                                      MD035545
     C                   ELSE                                                               MD035545
     C     ZZYY1         ADD       1             ZZYY2                                        191870
      *                                                                                       191870
     C                   MOVE      '01'          ZZMM2                                        191870
     C                   MOVE      '01'          ZZDD2                                        191870
     C                   ENDIF                                                              MD035545
     C                   MOVE      ZZDATB        ZZDTIN                                       191870
      *                                                                                       191870
     C                   CALLB     'ZDATE10'                                                  191870
     C                   PARM                    ZZDTIN                                       191870
     C                   PARM      *ZERO         ZZMDNO                                       191870
      *                                                                                       191870
     C                   Z-ADD     ZZMDNO        ZZENDW            5 0                        191870
     C     ZZENDW        SUB       ZZBEG         ZZWDAT                                       191870
      *                                                                                       191870
     C     ZZYY1         DIV       4             ZZWN5                                        191870
     C                   MVR                     ZZWN5                                        191870
     C     ZZWN5         IFNE      0                                                          191870
     C                   ADD       ZZWDAT        NLEAP                                        191870
     C                   ELSE                                                                 191870
     C                   ADD       ZZWDAT        LEAP50                                       191870
     C                   END                                                                  191870
      *                                                                                     MD035545
      ***Add*1*to*start*date*year*when*accrue*on*last*day*is*'Y'*since*            MD035545 MD047993
      ***1st*period*is*already*computed.*When*accrue*on*last*day*is****            MD035545 MD047993
      ***'N'*the*year*is*already*start*date*+*1.***********************            MD035545 MD047993
      ** Add 1 to start date year since 1st period is already computed                      MD047993
      ** when LECalcBasis6LeapYear = 'Y'                                                    MD047993
      *                                                                                     MD035545
     C     WCALC6        IFEQ      'Y'                                                      MD035545
     C                   ADD       1             ZZYY2                                      MD035545
     C                   ENDIF                                                              MD035545
      *                                                                                       191870
     C     ZZYY2         DOWLT     YY2SAV                                                     191870
      *                                                                                       191870
     C     ZZYY2         DIV       4             ZZWN5                                        191870
     C                   MVR                     ZZWN5                                        191870
     C     ZZWN5         IFNE      0                                                          191870
     C                   ADD       365           NLEAP                                        191870
     C                   ELSE                                                                 191870
     C                   ADD       366           LEAP50                                       191870
     C                   END                                                                  191870
      *                                                                                       191870
     C                   ADD       1             ZZYY2                                        191870
     C                   ENDDO                                                                191870
      *                                                                                       191870
      ***Get*Midas*day*number*for*1st*Jan*of*year*after*start*date*****            MD035545 MD047993
      ***when*accrue*on*last*day*is*'N';*get*midas*day*number*for*31***            MD035545 MD047993
      ***dec*of*the*start*date*year*when*accrue*on*last*day*is*Y*******            MD035545 MD047993
      ***and*LECalcBasis6LeapYear*=*'Y'********************************            MD035545 MD047993
      ** Get Midas Day Number for 31 Dec of the start date year when                        MD047993
      ** LECalcBasis6LeapYear = 'Y'                                                         MD047993
      *                                                                                     MD035545
     C     WCALC6        IFEQ      'Y'                                                      MD035545
     C                   MOVE      '12'          ZZMM2                                      MD035545
     C                   MOVE      '31'          ZZDD2                                      MD035545
     C     ZZYY2         SUB       1             ZZYY2                                      MD035545
     C                   ELSE                                                               MD035545
     C                   MOVE      '01'          ZZMM2                                        191870
     C                   MOVE      '01'          ZZDD2                                        191870
     C                   ENDIF                                                              MD035545
     C                   MOVE      ZZDATB        ZZDTIN                                       191870
      *                                                                                       191870
     C                   CALLB     'ZDATE10'                                                  191870
     C                   PARM                    ZZDTIN                                       191870
     C                   PARM      *ZERO         ZZMDNO                                       191870
      *                                                                                       191870
     C                   Z-ADD     ZZMDNO        ZZBEG                                        191870
     C     ZZEND         SUB       ZZBEG         ZZWDAT                                       191870
      *                                                                                       191870
      ** Set the year back to current year since it was set to                              MD035545
      ** previous year when LECalcBasis6LeapYear = 'Y'                                      MD047993
      ***previous*year*when*accrue*on*last*indicator*=*'Y'*************            MD035545 MD047993
      ***and*LECalcBasis6LeapYear*=*'Y'********************************            MD035545 MD047993
      *                                                                                     MD035545
     C     WCALC6        IFEQ      'Y'                                                      MD035545
     C     ZZYY2         ADD       1             ZZYY2                                      MD035545
     C                   ENDIF                                                              MD035545
     C     ZZYY2         DIV       4             ZZWN5                                        191870
     C                   MVR                     ZZWN5                                        191870
     C     ZZWN5         IFNE      0                                                          191870
     C                   ADD       ZZWDAT        NLEAP                                        191870
     C                   ELSE                                                                 191870
     C                   ADD       ZZWDAT        LEAP50                                       191870
     C                   END                                                                  191870
      *                                                                                       191870
     C                   END                                                                  191870
      *                                                                                       191870
      * Factoring of non-leap year days is not required for method 9                          CIR013
     C     ZZCALC        IFEQ      '9'                                                        CIR013
     C                   Z-ADD     NLEAP         WNLP2                                        CIR013
     C                   ELSE                                                                 CIR013
     C     NLEAP         MULT      366           WNLP1            15 0                        191870
     C*****WNLP1         DIV(H)    365           WNLP2            15 7                 191870 242286
     C     WNLP1         DIV(H)    365           WNLP2            15 9                        242286
     C                   ENDIF                                                                CIR013
      *                                                                                       191870
     C*****LEAP50        ADD(H)    WNLP2         INT6DY           15 7                 191870 242286
     C     LEAP50        ADD(H)    WNLP2         INT6DY           15 9                        242286
      *                                                                                       191870
     C                   ELSE                                                                 191870
      *                                                                                       246141
     C     ZZCALC        IFEQ      '7'                                                        246141
     C     CIR004        ANDEQ     'Y'                                                        246141
      *                                                                                       246141
      ** If the day1 or day 2 is 31, change to 30.                                            246141
      *                                                                                       246141
     C     ZZDD1         IFEQ      31                                                         246141
     C                   Z-ADD     30            ZZDD1                                        246141
     C                   ENDIF                                                                246141
      *                                                                                       246141
     C     ZZDD2         IFEQ      31                                                         246141
     C                   Z-ADD     30            ZZDD2                                        246141
     C                   ENDIF                                                                246141
      *                                                                                       246141
      ** Get the number of days from the year.                                                246141
      *                                                                                       246141
     C     ZZYY2         SUB       ZZYY1         ZZP1                                         246141
     C     ZZP1          MULT      360           ZZP1                                         246141
     C     ZZMM2         SUB       ZZMM1         ZZP2                                         246141
     C     ZZP2          MULT      30            ZZP2                                         246141
     C     ZZDD2         SUB       ZZDD1         ZZP3                                         246141
      *                                                                                       246141
     C     ZZP1          ADD       ZZP2          ZZINDY                                       246141
     C                   ADD       ZZP3          ZZINDY                                       246141
     C                   GOTO      ZINTD9                                                     246141
      *                                                                                       246141
     C                   ELSE                                                                 246141
     C*
     C**  IF NOT 3,4 OR 5 EXIT PROCESSING
      ** or 7 when enhancement CIR004 is on.                                                  CIR004
                                                                                              CIR004
      ** or 9                                                                                 CIR013
      *                                                                                       CIR013
      ** or 0                                                                                CER016A
      *                                                                                      CER016A
     C                   Z-ADD     ZZWDAT        ZZINDY                         - LOAD OUTPT
     C                   GOTO      ZINTD9                                       ----------->
     C*
     C                   ENDIF                                                                246141
     C                   END
     C                   END                                                                  191870
     C*
     C     ZZCALC        IFEQ      '3'
     C*****ZZCALC        OREQ      '7'                                                 CIR004 246141
     C*****CIR004        ANDEQ     'Y'                                                 CIR004 246141
     C     ZZCALC        OREQ      '0'                                                       CER016A
     C*
     C**  CALC NO. DAYS IN FIRST MONTH
     C     ZZCALC        IFEQ      '3'                                                       CER016A
     C     ZZCALC        OREQ      '0'                                                       CER016A
     C     CER016        ANDEQ     'N'                                                       CER016A
     C*****************************************************************                     AR996895
     C****FOR*FEB*TEST*IF*DAY*EQUAL*TO*END*OF*MONTH********************                     AR996895
     C*****ZZMM1         IFEQ      2                                                        AR996895
     C*****************************************************************                     AR996895
     C****TEST*IF*LEAP*YEAR********************************************                     AR996895
     C*****ZZYY1         DIV       4             ZZWN5                                      AR996895
      *                                                                                     MD053295
      ** FOR FEB TEST IF DAY EQUAL TO END OF MONTH                                          MD053295
      *                                                                                     MD053295
     C     ZZMM1         IFEQ      2                                                        MD053295
      *                                                                                     MD053295
      ** TEST IF LEAP YEAR                                                                  MD053295
      *                                                                                     MD053295
     C     ZZYY1         DIV       4             ZZWN5                                      MD053295
     C**********         MVR                     ZZWN5                                       CER016A
     C**********         MVR                     ZZWN5                    80        CER016A AR996895
     C*****************************************************************                     AR996895
     C****STORE*DAY*NUMBER*********************************************                     AR996895
     C**********         Z-ADD     ZZDD1         ZZSTO1            5 0                      AR996895
     C*****************************************************************                     AR996895
     C****FOR*LAST*DAY*OF*MONTH*--->*INITIALISE*WITH*30****************                     AR996895
     C******IN80         IFEQ      '1'                                                      AR996895
     C*****************************************************************                     AR996895
     C*****ZZDD1         IFEQ      29                                                       AR996895
     C**********         Z-ADD     30            ZZDD1                                      AR996895
     C**********         END                                                                AR996895
     C*****************************************************************                     AR996895
     C**********         ELSE                                                               AR996895
     C*****************************************************************                     AR996895
     C*****ZZDD1         IFEQ      28                                                       AR996895
     C**********         Z-ADD     30            ZZDD1                                      AR996895
     C**********         END                                                                AR996895
     C*****************************************************************                     AR996895
     C**********         END                                                                AR996895
     C*****************************************************************                     AR996895
     C**********         END                                                                AR996895
     C                   MVR                     ZZWN5                    80                MD053295
      *                                                                                     MD053295
      ** STORE DAY NUMBER                                                                   MD053295
     C                   Z-ADD     ZZDD1         ZZSTO1            5 0                      MD053295
      *                                                                                     MD053295
      ** FOR LAST DAY OF MONTH ---> INITIALISE WITH 30                                      MD053295
     C     *IN80         IFEQ      '1'                                                      MD053295
      *                                                                                     MD053295
     C     ZZDD1         IFEQ      29                                                       MD053295
     C                   Z-ADD     30            ZZDD1                                      MD053295
     C                   ENDIF                                                              MD053295
      *                                                                                     MD053295
     C                   ELSE                                                               MD053295
      *                                                                                     MD053295
     C     ZZDD1         IFEQ      28                                                       MD053295
     C                   Z-ADD     30            ZZDD1                                      MD053295
     C                   ENDIF                                                              MD053295
      *                                                                                     MD053295
     C                   ENDIF                                                              MD053295
      *                                                                                     MD053295
     C                   ENDIF                                                              MD053295
      *                                                                                      CER016A
     C                   ENDIF                                                               CER016A
     C*
     C     30            SUB       ZZDD1         ZZP1              5 0  80
     C*
     C**  IF < 0, INITIALISE TO 0
     C     *IN80         IFEQ      '1'
     C                   Z-ADD     *ZEROS        ZZP1
     C                   END
     C*
     C****RESTORE*START*DATE*DAY*NUMBER********************************                     AR996895
     C*****ZZMM1         IFEQ      2                                                        AR996895
     C**********         Z-ADD     ZZSTO1        ZZDD1                                      AR996895
     C**********         END                                                                AR996895
      *                                                                                     MD053295
      ** RESTORE START DATE DAY NUMBER                                                      MD053295
      *                                                                                     MD053295
     C     ZZMM1         IFEQ      2                                                        MD053295
     C                   Z-ADD     ZZSTO1        ZZDD1                                      MD053295
     C                   ENDIF                                                              MD053295
     C*
     C**  CALC NO. DAYS IN LAST MONTH
     C     ZZDD2         IFLE      30
     C                   Z-ADD     ZZDD2         ZZP2              5 0
     C                   ELSE
     C                   Z-ADD     30            ZZP2
     C                   END
      *                                                                                      CER016A
     C     ZZCALC        IFEQ      '3'                                                       CER016A
     C     ZZCALC        OREQ      '0'                                                       CER016A
     C     CER016        ANDEQ     'N'                                                       CER016A
     C*
     C**  FOR FEB TEST IF DAY EQUAL TO END OF MONTH
     C     ZZMM2         IFEQ      2
     C*
     C**  TEST IF LEAP YEAR
     C     ZZYY2         DIV       4             ZZWN5
     C                   MVR                     ZZWN5                    80
     C*
     C**  INTIALISE WITH NUMBER OF DAYS IN LAST MONTH
     C                   Z-ADD     ZZDD2         ZZP2
     C*
     C**  IF END OF MONTH CONSIDER 30 DAYS
     C     *IN80         IFEQ      '1'
     C*
     C     ZZDD2         IFEQ      29
     C     ZZCALC        ANDEQ     '3'                                                        CIR004
     C     ZZDD2         OREQ      29                                                        CER016A
     C     ZZCALC        ANDEQ     '0'                                                       CER016A
     C                   Z-ADD     30            ZZP2
     C                   END
     C*
     C                   ELSE
     C*
     C     ZZDD2         IFEQ      28
     C     ZZCALC        ANDEQ     '3'                                                        CIR004
     C     ZZDD2         OREQ      28                                                        CER016A
     C     ZZCALC        ANDEQ     '0'                                                       CER016A
     C                   Z-ADD     30            ZZP2
     C                   END
     C*
     C                   END
     C*
     C                   END
      *                                                                                      CER016A
     C                   ENDIF                                                               CER016A
     C*
     C**  CALC NO. DAYS IN INTERVENING MONTHS
     C     ZZYY2         IFEQ      ZZYY1
     C*
     C     ZZMM2         SUB       ZZMM1         ZZP3              5 0
     C                   SUB       1             ZZP3
     C                   MULT      30            ZZP3
     C*
     C                   ELSE
     C*
     C**  FIND NO. OF DAYS FOR THE COMPLETE YEARS
     C     ZZYY2         SUB       ZZYY1         ZZP3
     C                   SUB       1             ZZP3
     C                   MULT      360           ZZP3
     C*
     C**  FIND NO. OF MONTHS FOR THE TWO PARTIAL YEARS
     C     12            SUB       ZZMM1         ZZWN5A            5 0
     C                   MULT      30            ZZWN5A
     C*
     C     ZZMM2         SUB       1             ZZWN5
     C     ZZWN5         MULT      30            ZZWN5
     C*
     C**  ACCUMULATE
     C     ZZWN5A        ADD       ZZWN5         ZZWN5A
     C     ZZP3          ADD       ZZWN5A        ZZP3
     C*
     C                   END
     C*
     C**  FINAL SUM
     C     ZZP1          ADD       ZZP2          ZZINDY
     C                   ADD       ZZP3          ZZINDY
     C*
     C                   END
     C*
     C****FOR*METHODS*4*AND*5**                                                               CIR013
     C**  FOR METHODS 4 AND 5  or 9                                                           CIR013
     C     ZZCALC        IFEQ      '4'
     C     ZZCALC        OREQ      '5'
     C     ZZCALC        OREQ      '9'                                                        CIR013
     C     #29FEB        ANDEQ     'N'                                                        CIR013
     C*
     C**  CALC NO. OF LEAP YEARS BETWEEN START AND END DATES
     C     ZZYY1         DIV       4             ZZWN5             5 0
     C                   MVR                     ZZWN5                    80
     C*
     C**  CHECK WHETHER START YEAR IS AFFECTED BY LEAP YEAR
     C     ZZYY1         IFEQ      ZZYY2
     C*
     C     ZZMM1         IFLE      2
     C     ZZMM2         ANDGT     2
     C     *IN80         ANDEQ     '1'
     C                   ADD       1             ZZLPNM
     C                   END
     C*
     C                   ELSE
     C*
     C     ZZMM1         IFLE      2
     C     *IN80         ANDEQ     '1'
     C                   ADD       1             ZZLPNM
     C                   END
     C*
     C                   END
     C*
     C**  LOOP TO CALCULATE NO. LEAP YEARS
     C     ZZYY1         DOWLT     ZZYY2
     C*
     C**  INCREMENT START YEAR
     C                   ADD       1             ZZYY1
     C*
     C     ZZYY1         IFEQ      ZZYY2
     C*
     C     ZZMM2         IFGT      2
     C     ZZYY2         DIV       4             ZZWN5
     C                   MVR                     ZZWN5                    80
     C*
     C**  ADD 1 IF LEAP YEAR
     C     *IN80         IFEQ      '1'
     C                   ADD       1             ZZLPNM
     C                   END
     C*
     C                   END
     C*
     C                   ELSE
     C*
     C     ZZYY1         DIV       4             ZZWN5
     C                   MVR                     ZZWN5                    80
     C*
     C**  ADD 1 IF LEAP YEAR
     C     *IN80         IFEQ      '1'
     C                   ADD       1             ZZLPNM
     C                   END
     C*
     C                   END
     C*
     C                   END
     C*
     C**  DEDUCT NO. OF LEAP YEARS CALCULATED BETWEEN START
     C**  AND END DATES
     C     ZZWDAT        SUB       ZZLPNM        ZZINDY                         - LOAD OUTPT
     C*
     C                   END
     C     ZINTD9        TAG
     C     IN80SV        IFEQ      '1'
     C                   MOVE      '1'           *IN80
     C                   ELSE
     C                   MOVE      '0'           *IN80
     C                   END

     C                   ENDSR
     C*****************************************************************

      ** +--- The converted ZINTDYZ2 ends here ----------------------------+


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

     C     *entry        PLIST
      ** Incoming return code (10A, returned to caller)
     C                   PARM                    RetCodeIn
      ** Number of interest days (5,0P, returned to caller)
     C                   PARM                    ZZINDY
      ** Beginning date (5,0P, from caller)
     C                   PARM                    ZZBEG
      ** Ending date (5,0P, from caller)
     C                   PARM                    ZZEND
      ** Calculation method (1A, from caller)
     C                   PARM                    ZZCALC
      ** Number of interest days (15,7P, returned to caller)                                  191870
     C                   PARM                    INT6DY                                       191870

      ** Access Switchable Features File                                                      CIR004
                                                                                              CIR004
     C                   CallB     'AOSARDR0'                                                 CIR004
     C                   Parm      *Blanks       PRtcd             7                          CIR004
     C                   Parm      '*VERIFY '    POptn             7                          CIR004
     C                   Parm      'CIR004'      PSard             6                          CIR004
     C     SCSARD        Parm      SCSARD        Dsfdy                                        CIR004
                                                                                              CIR004
     C                   Move      'N'           CIR004            1                          CIR004
     C                   If        PRtcd = *Blanks                                            CIR004
     C                   Eval      CIR004 = 'Y'                                               CIR004
     C                   Endif                                                                CIR004
                                                                                             CER016A
     C                   CallB     'AOSARDR0'                                                CER016A
     C                   Parm      *Blanks       PRtcd                                       CER016A
     C                   Parm      '*VERIFY '    POptn                                       CER016A
     C                   Parm      'CER016'      PSard                                       CER016A
     C     SCSARD        Parm      SCSARD        Dsfdy                                       CER016A
                                                                                             CER016A
     C                   Move      'N'           CER016            1                         CER016A
     C                   If        PRtcd = *Blanks                                           CER016A
     C                   Eval      CER016 = 'Y'                                              CER016A
     C                   Endif                                                               CER016A
      *                                                                                     MD035545
     C**********         CALL      'AOGELRR1'                                      MD035545 MD047993
     C**********         PARM      '*DBERR '     PRtrnCode                         MD035545 MD047993
     C**********         PARM      '*FIRST '     POptn                             MD035545 MD047993
     C*****SDGELR        PARM      SDGELR        DSSDY                             MD035545 MD047993
      *                                                                                     MD035545
      ** Check System Value:                                                                MD035545
      *                                                                                     MD035545
     C                   EVAL      SVALK1 = WPARML                                          MD035545
      ** Call Access Object                                                                 MD035545
     C                   CALL      'AOSVALR0'                                               MD035545
     C                   PARM                    RTNCDE            7                        MD035545
     C                   PARM                    SVALK1           20                        MD035545
     C                   PARM                    SVAL1           200                        MD035545
     C                   PARM                    SVALK2           20                        MD035545
     C                   PARM                    SVAL2           200                        MD035545
     C                   PARM                    SVALK3           20                        MD035545
     C                   PARM                    SVAL3           200                        MD035545
     C                   PARM                    SVALK4           20                        MD035545
     C                   PARM                    SVAL4           200                        MD035545
     C                   PARM                    SVALK5           20                        MD035545
     C                   PARM                    SVAL5           200                        MD035545
     C                   PARM                    SVALK6           20                        MD035545
     C                   PARM                    SVAL6           200                        MD035545
     C                   PARM                    SVALK7           20                        MD035545
     C                   PARM                    SVAL7           200                        MD035545
     C                   PARM                    SVALK8           20                        MD035545
     C                   PARM                    SVAL8           200                        MD035545
     C                   PARM                    SVALK9           20                        MD035545
     C                   PARM                    SVAL9           200                        MD035545
     C                   PARM                    SVALK0           20                        MD035545
     C                   PARM                    SVAL10          200                        MD035545
      * If the system value is not found then default value to 'N'                          MD035545
     C     RTNCDE        IFNE      '        '                                               MD035545
     C                   MOVE      'N'           WCALC6                                     MD035545
     C                   ELSE                                                               MD035545
     C                   MOVEL     SVAL1         WCALC6                                     MD035545
     C*****WCALC6        IFEQ      'Y'                                             MD035545 MD047993
     C*****BKALDI        ANDEQ     'Y'                                             MD035545 MD047993
     C**********         MOVE      'Y'           WCALC6                            MD035545 MD047993
     C**********         ELSE                                                      MD035545 MD047993
     C**********         MOVE      'N'           WCALC6                            MD035545 MD047993
     C**********         ENDIF                                                     MD035545 MD047993
     C                   ENDIF                                                              MD035545
      *
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values

     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
**  CPY@
(c) Finastra International Limited 2001
