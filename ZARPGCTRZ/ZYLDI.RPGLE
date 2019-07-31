     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas ZS Output yield as % of price')                  *
      *****************************************************************
      *                                                               *
      *      Midas - Copy Source converted into ILE procedures.       *
      *                                                               *
      *      ZYLDI - Module to output YIELD as percentage price.      *
      *                                                               *
      *  This module is an ILE/RPG IV conversion of the ZYLDI         *
      *  subroutine. The subroutine consists of one /COPY members.    *
      *  Each of these has been converted to ILE RPG and copied into  *
      *  this member.  Necessary code to make this compileable has    *
      *  been added (entry and exit points and some declares).        *
      *                                                               *
      *  The existing code has not been changed except:               *
      *  - to remove dead lines                                       *
      *  - to convert a couple of EXSRs to CALLBs                     *
      *                                                               *
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
      *  Component of: SE0050                                         *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *    This source is centrally supported and must ONLY be        *
      *    amended by Core Development Personnel                      *
      *                                                               *
      *    /COPY, Client or Country amendments must not be            *
      *    applied to this source.                                    *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CRE073             Date 06Dec10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD027             Date 09Dec05               *
      *                 CSE075             Date 17Nov05               *
      *                 210327             Date 04Oct02               *
      *                 198688             Date 04Oct02               *
      *                 CSE035             Date 22Apr02               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 CAP002  *CREATE    Date 11Feb98               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CRE073 - Interest Rate Rounding (Recompile)                  *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CSE075 - US Enhanced Treasury Upgrade to MidasPlus           *
      *           (Recompile)                                         *
      *  210327 - Coordinate the passing of parameters from ZYLDI to  *
      *           ZYLD with the receiving of parameters in ZYLD.      *
      *  198688 - Correct parameters list transmit and receive.       *
      *           to be consistent with ZYLD. Pass SECTYD record fmt. *
      *  CSE035 - NX/NNX Coupon Payment Processing.                   *
      *  CAP002 - Conversion of SE inputs into modular structure to   *
      *           use as APIs.                                        *
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
 
      ** Include the MM standard declares
     D/COPY ZACPYSRC,STDDECLARE
 
      ** Program Status Data Structure
      ** =============================
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
 
     D/COPY ZACPYSRC,PSDS
 
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
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
     D ZPARMS          DS
     D  PRCYLD                 1      1
     D  METHOD                 2      3
     D  SEMANN                 4      4
     D  ErrInd                 5      5
     D  PRICEC                 6     13P 9
     D  YIELDC                14     21P 9
     D  CPRTE                 22     27P 7
     D  NMAT                  28     29P 0
     D  FMAT                  30     35P 9
     D  KPRICE                36     43P 9
     D  YISVAL                44     50P 9
     D  ACCRCY                51     51P 0
     D  CPYEAR                52     53P 0
     D  DYLSTC                54     55P 0
     D  PERIOD                56     57P 0
     D  PAYYRS                58     64P 9
     D  PAYDYS                65     67P 0
     D  VALDTE                68     70P 0
     D  NCPDTE                71     73P 0
     D  MATDTE                74     76P 0
     D  CPTOMT                77     78P 0
     D  PURINT                79     86P 9
     D  DSFCTM                87     88P 0
     D  DYSTNC                89     90P 0
     D  CUMEXF                91     91
     D  COMFRQ                92     93P 0
     D  DSCBSS                94     94
     D  DLCOUP                95     95
                                                                                              CSE035
     D  ISSDTE                96     98P 0                                                    CSE035
     D  WBENCD                99    101P 0                                                    CSE035
                                                                                              CSE035
     D SCSARD        E DS                  EXTNAME(SCSARDPD)                                  CSE035
     D SAR_LCD       E                     EXTFLD(LCD)                                        CSE035
     D DSFDY         E DS                  EXTNAME(DSFDY)                                     CSE035
      ** FIRST DS FOR ACCESS PROGRAMS, SHORT DATA STRUCTURE                                   CSE035
 
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Input Fields **
      *
     D SECTY         E DS                  EXTNAME(SECTYD)                                    198688
     D ZFDATE          S              5P 0
     D ECD             S              5P 0
     D*MATY*****       S              5P 0                                                    198688
     D*SESN*****       S             10A                                                      198688
     D*DYBS*****       S              1A                                                      198688
     D*DVBS*****       S              1A                                                      198688
     D*LCPN*****       S              5P 0                                                    198688
     D*ITLD*****       S              5P 0                                                    198688
     D*IADJ*****       S              3P 0                                                    198688
     D ZDATFM          S              1A
     D CDArr           S             48A
     D CRArr           S             12A
     D*FCPN*****       S              5P 0                                                    198688
     D*ISSD*****       S              5P 0                                                    198688
     D*CFCT*****       S             10P 9                                                    198688
     D*CPDP*****       S             15P 0                                                    198688
     D ZPRCIN          S             15P 8
     D*PPDI*****       S              1A                                                      198688
     D ZPRC            S             16P 0
     D PROT            S              1A
     D*NMDP*****       S              1P 0                                                    198688
     D ZCDP            S              1P 0
     D*CPNR*****       S             11P 7                                                    198688
     D ZNOML           S             15P 0
     D*SPBS*****       S              1A                                                      198688
     D*SYBS*****       S              2A                                                      198688
     D ZECD            S              5P 0
     D*CMFQ*****       S              2P 0                                                    198688
     D*DSCB*****       S              1A                                                      198688
     D*DSLC*****       S              1A                                                      198688
     D NCDP            S              1P 0
     D SCUMEX          S              1A
     D*SFPP*****       S             15P 0                                                    198688
     D WRKPI           S             15P 9
 
      ** Output **
 
     D ZYLDOk          S              1A
     D ZYLDOT          S             15P 8
 
      ** WORKING VARIABLES **
 
     D CTYPE           S              1A
     D PPARM           S             15P 9
     D YPARM           S             15P 9
     D VDATE           S              5P 0
 
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
      *
      ** +--- The converted ZYLDIZ1 starts here ---------------------------+
      *
     C                   MOVE      'I'           CTYPE
     C                   Z-ADD     ZPRCIN        YPARM                                         E1582
     C                   Z-ADD     *ZERO         PPARM                                         E1582
     C                   Z-ADD     ZFDATE        VDATE
      *
     C                   CALLB     'ZYLD'
     C                   PARM                    CTYPE
     C                   PARM                    PPARM
     C                   PARM                    YPARM
     C                   PARM                    VDATE
     C**********         PARM                    ECD                                          198688
     C**********         PARM                    MATY                                         198688
     C**********         PARM                    SESN                                         198688
     C**********         PARM                    DYBS                                         198688
     C**********         PARM                    DVBS                                         198688
     C**********         PARM                    LCPN                                         198688
     C**********         PARM                    ITLD                                         198688
     C**********         PARM                    IADJ                                         198688
     C**********         PARM                    ZDATFM                                       198688
     C**********         PARM                    CDArr                                        198688
     C**********         PARM                    CRArr                                        198688
     C**********         PARM                    FCPN                                         198688
     C**********         PARM                    ISSD                                         198688
     C**********         PARM                    CFCT                                         198688
     C**********         PARM                    CPDP                                         198688
     C**********         PARM                    ZPRCIN                                       198688
     C**********         PARM                    PPDI                                         198688
     C**********         PARM                    PROT                                         198688
     C**********         PARM                    NMDP                                         198688
     C**********         PARM                    ZCDP                                         198688
     C**********         PARM                    CPNR                                         198688
     C**********         PARM                    ZNOML                                        198688
     C**********         PARM                    SPBS                                         198688
     C**********         PARM                    SYBS                                         198688
     C**********         PARM                    ZECD                                         198688
     C**********         PARM                    ZFDATE                                       198688
     C**********         PARM                    CMFQ                                         198688
     C**********         PARM                    DSCB                                         198688
     C**********         PARM                    DSLC                                         198688
     C**********         PARM                    NCDP                                         198688
     C                   PARM                    SECTY                                        198688
     C                   PARM                    IADJ                                         198688
     C                   PARM                    NMDP                                         198688
     C                   PARM                    PROT                                         198688
     C                   PARM                    ZNOML                                        198688
     C**********         PARM                    SCUMEX                                       210327
     C**********         PARM                    SFPP                                         198688
     C                   PARM                    WRKPI
     C                   PARM                    SCUMEX                                       210327
     C                   PARM                    BJDFIN                                       210327
      *
      ** Output
      *
     C                   PARM                    ZYLDOk
     C                   PARM                    ZPARMS
      *
     C                   Z-ADD     PRICEC        ZYLDOT
      *
      ** +--- The converted ZYLDIZ1 ends here -----------------------------+
      *
     C                   RETURN
      *
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
 
      ** Event Control Date  (5P 0)
     C                   PARM                    ECD
      *                                                                                       198688
      ***Maturity*Date**(5P*0)*****************************************                       198688
     C**********         PARM                    MATY                                         198688
      ** Security Shortame  (10A)
     C**********         PARM                    SESN                                         198688
     C                   PARM                    SECTY                                        198688
      ***Day*basis*(1A)************************************************                       198688
     C**********         PARM                    DYBS                                         198688
      ***Divisor*basis*(1A)********************************************                       198688
     C**********         PARM                    DVBS                                         198688
      ***Last*coupon*(5P*0)********************************************                       198688
     C**********         PARM                    LCPN                                         198688
      ***Initial*Date*(5P*0)*******************************************                       198688
     C**********         PARM                    ITLD                                         198688
      ***Interest*Adjustment*Date*(3P*0)*******************************                       198688
     C**********         PARM                    IADJ                                         198688
      ** Date format (1A)
     C                   PARM                    ZDATFM
      ** Coupon Dates Array (48A)
     C                   PARM                    CDArr
      ** Coupon Rate INdicator array (12A)
     C                   PARM                    CRArr
      ***First*Coupon*date*(5P*0)**************************************                       198688
     C**********         PARM                    FCPN                                         198688
      ***Issue*Date*(5P*0)*********************************************                       198688
     C**********         PARM                    ISSD                                         198688
      ***Current Factor*(10P*9)****************************************                       198688
     C**********         PARM                    CFCT                                         198688
      ***Currently*partly*paid*price*(15P*0)***************************                       198688
     C**********         PARM                    CPDP                                         198688
      ** Yield to be converted to % price (15P 3)
     C                   PARM                    ZPRCIN
      ***Partly*paid*indicator*(1A)************************************                       198688
     C**********         PARM                    PPDI                                         198688
      ** Processing type (1A)
     C                   PARM                    PROT
      ***Nominal*Decimal*position**(1P*0)******************************                       198688
     C**********         PARM                    NMDP                                         198688
      ** Currency Decimal position  (1P 0)
     C                   PARM                    ZCDP
      ***Coupon*Rate*(11P*7)*******************************************                       198688
     C**********         PARM                    CPNR                                         198688
      ** Nominal (15P 0)
     C                   PARM                    ZNOML
      ***Price*Basis*(1A)**********************************************                       198688
     C**********         PARM                    SPBS                                         198688
      ***Yield*Basis*(2A)**********************************************                       198688
     C**********         PARM                    SYBS                                         198688
      ** Processed Event control date (5P 0)
     C                   PARM                    ZECD
      ** Yield Effective Date   (5P 0)
     C                   PARM                    ZFDATE
      ***Compounding*frequency*(2P*0)**********************************                       198688
     C**********         PARM                    CMFQ                                         198688
      ***Discount*basis**(1A)******************************************                       198688
     C**********         PARM                    DSCB                                         198688
      ***Discount*Last*Coupon**((1A)***********************************                       198688
     C**********         PARM                    DSLC                                         198688
      ** Currecy decimal places  (1P 0)
     C                   PARM                    NCDP
      ** CUM/Ex-coupon indicator (1A)
     C                   PARM                    SCUMEX
      ***Fully*paid*price*(15P*0)**************************************                       198688
     C**********         PARM                    SFPP                                         198688
      ** Purchased interest working variable (15P 9)
     C                   PARM                    WRKPI
      *                                                                                       198688
      ** Date format (1A)                                                                     198688
      *                                                                                       198688
     C                   PARM                    BJDFIN            1                          198688
      *
      ** Output
      *
     C                   PARM                    ZYLDOk
     C                   PARM                    ZYLDOT
      *                                                                                       CSE035
     C                   CALLB     'AOSARDR0'                                                 CSE035
     C                   PARM      *BLANKS       @RTCD             7                          CSE035
     C                   PARM      '*VERIFY'     @OPTN             7                          CSE035
     C                   PARM      'CSE035'      @SARD             6                          CSE035
     C     SCSARD        PARM      SCSARD        DSFDY                                        CSE035
      *                                                                                       CSE035
     C     @RTCD         IFEQ      *BLANK                                                     CSE035
     C                   MOVEL     'Y'           CSE035            1                          CSE035
     C                   ELSE                                                                 CSE035
     C                   MOVEL     'N'           CSE035                                       CSE035
     C                   END                                                                  CSE035
 
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values
 
     C/COPY ZACPYSRC,DBFIELDS
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
**  CPY@
(c) Finastra International Limited 2001
