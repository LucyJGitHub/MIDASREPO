     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2006')
     H ALWNULL(*USRCTL)
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas SF Users Access Rights Report')                  *
      *****************************************************************
      *                                                               *
      *  Midas - Security Profile Facility                            *
      *                                                               *
      *  SF000350 - MidasPlus Users Access Rights Report              *
      *                                                               *
      *  Function:  This program will list each MidasPlus user sorted *
      *             by department.                                    *
      *                                                               *
      ** +---------------------------------------------------------+ **
      *                                                               *
      *  Component of: SFC00350                                       *
      *                                                               *
      *  (c) Finastra International Limited 2006                      *
      *                                                               *
      *  Last Amend No. MD061410           Date 23May23               *
      *  Prev Amend No. MD026939           Date 18May23               *
      *                 MD048072           Date 18May23               *
      *                 AR996504           Date 18May23               *
      *                 AR635878           Date 14Jul22               *
      *                 MD050150           Date 12Oct18               *
      *                 MD046248           Date 27Oct17               *
      *                 CFB001             Date 12Nov14               *
      *                 AR805470           Date 27Jul11               *
      *                 262341             Date 22Oct09               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 256564             Date 17Sep08               *
      *                 248436             Date 24Jun07               *
      *                 246097             Date 17Apr07               *
      *                 247020             Date 13Apr07               *
      *                 244592             Date 07Mar07               *
      *                 235634             Date 26Jul06               *
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 239898 *CREATE     Date 29May06               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD061410 - Issue on Language Code Retrieval                  *
      *  MD026939 - Issues in SF000350P1. Make sure Initial Menu and  *
      *             User's Language Preference values are correct.    *
      *  MD048072 - SFC000350 is on MSGW due to printer overflow.     *
      *           - Corrected required line when printing D42332B     *
      *             record format in order to handle overflow issue.  *
      *  AR996504 - Changed the report layout.  Report should cater   *
      *             for more than 3 branches.  Applied GEMS 249995/A, *
      *             249240/A, 249239.  (Child: AR996505)              *
      *  AR635878 - Request to apply fix SC263737 and AR576681.       *
      *  AR576681 - User not printed consistently on a specific line  *
      *             (for optical reporting): Skip a line when Dep't   *
      *             is not to be printed                              *
      *             Users with no initial menu are not printed: Use   *
      *             MAIN                                              *
      *             Some menus are not printed because items appear   *
      *             identical given 13 and 32 characters in the       *
      *             report: Extend field lengths                      *
      *  263737 - Overlapping in 'Initial Menu' field in SF000350P1.  *
      *  MD050150 - Rename 'FusionBanking Midas' to 'Fusion Midas'    *
      *             (Recompile)                                       *
      *  MD046248 - Finastra Rebranding                               *
      *  CFB001 - FusionBanking Midas Rebranding (Recompile)          *
      *  AR805470 - SF00350P1 - no header when no details to report.  *
      *             Applied GEMS 256313. (Child: AR805471)            *
      *  262341 - Component SFC000350 sequence 00001 failed during    *
      *           COB. Ensure that only live users are counted for the*
      *           audit report. Applied core fix 254503.              *
      *  254503 - Count live records only.                            *
      *           Also rename RECI from MUSERDD.                      *
      *  256564 - Recompile due to PF changes done by fix 256330      *
      *  248436 - SF000350P1 - Missing Menu Items on Report. Apply    *
      *           fix 235634A.  Also added condition not to generate  *
      *           Audit Report when report is requested for single    *
      *           user only.                                          *
      *  246097 - Enable report to be produced for a single user      *
      *  247020 - FOOB in SF000350 due to incorrect calculated number *
      *           of records in this program after incorp of 244592.  *
      *           Partially applied fix for reopen of 246247.         *
      *  244592 - Amended program to produce an audit report in COB   *
      *           if a user has been inserted, amended or deleted.    *
      *  235634   - Apply fix BUG11032                                *
      *  239898 - Applied core fix BUG11032.                          *
      *  BUG11032 - Reporting About Users                             *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *   40    - Toggle of SMENU printer field                       *
      *   41    - Toggle of SITEMS printer field                      *
      *   42    - 'No Details to Report' indicator                    *                     AR805470
      *   50    - GPTGRMNUL0 EOF indicator                            *
      *   51    - MACBR EOF indicator                                 *
      *   89    - MUSERL5 EOF indicator                               *
      *   U7+U8 - Database Error                                      *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      *  PROCES - Detail Processing                                   *
      *  REPORT - Process Report Lines                                *
      *  WP1END - Write End of Report                                 *
      *  AUDIT  - Produce Audit Report and End Program                *
      *  RCFP1  - RCF Processing for P1 Report                        *
      *  RCFAU  - RCF Processing for Audit Report                     *
      *                                                               *
      * *PSSR - Error processing                                      *
      * *INZSR - Initialise                                           *
      *                                                               *
      *    The *INZSR subroutine will only get called automatically   *
      *    on entry to the module the first time it is run            *
      *    (unless you end the program with LR on).  Similarly        *
      *    D-spec initialisation only happens the first time.  Use    *
      *    RESET for subsequent passes.                               *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+

     FMUSERL5   IF   E           K DISK
     F                                     RENAME(MUSERDDF:MUSER5DF)
     FMUSERL7   IF   E           K DISK                                                       244592
     F                                     RENAME(MUSERDDF:MUSER6DF)                          244592
     F***MUSER**   IF   E           K DISK                                           246097 AR996504
     FMUSER     UF   E           K DISK                                                     AR996504
     F                                     RENAME(MUSERDDF:MUSERLDF)                          246097
      *
      ** Midas SF Midas users by Department
      *
     FMUSERZZ   IF   E             DISK
     FMBRBS     IF   E           K DISK                                                     AR996504
     FMBROS     IF   E           K DISK                                                     AR996504
     FMCMPS     IF   E           K DISK                                                     AR996504
     F***SDLANGL0  IF   E             DISK                                         AR996504 MD026939
     FSDLANGL0  IF   E           K DISK                                                     MD026939
      *
      ** Midas SF users Trailer
      *
     FGPTUSRMNU0IF   E           K DISK
      *
      ** Midas GZ Menu items of Users
      *
     FGPTGRMNUH0IF   E           K DISK
      *
      ** Midas GP Menu group Header
      *
     FGPTGRMNUH1IF   E           K DISK    RENAME(T_GRMENUH:HIDH)
      *
      ** Midas GP Menu group Header by hierarchy id
      *
     FGPTGRMNUL0IF   E           K DISK
      *
      ** Midas GP Menu group Header
      *
     FGPTGRMNUG0IF   E           K DISK
      *
      ** Midas GP Menu Subgroup by hierarchy and name
      *
     FGPTUSRLNG0IF   E           K DISK                                                     MD026939
      *                                                                                     MD026939
      ** Midas GZ User Preference Set Up                                                    MD026939
      *                                                                                     MD026939
     FGPMTXTL0  IF   E           K DISK
      *
      ** Global Menu Item Text
      *
     F***GZMACBRL2 IF   E           K DISK                                                  AR996504
     FGZMACBRL3 IF   E           K DISK                                                     AR996504
     FSFMENUL0  IF   E           K DISK                                                     AR996504
     FGPMENUL0  IF   E           K DISK    RENAME(SFMENUD0:SFMENUP0)                        AR996504
      *
      ** Midas SF Valid action codes
      *
     FSF000350AUO    E             PRINTER INFDS(SPOOLU)
      *
      ** Access Rights of MidasPlus users Audit Report
      *

     FSF000350P1O    E             PRINTER INFDS(SPOOL1)
     F                                     USROPN
      *
      ** Access Rights of MidasPlus users Report
      *
      *****************************************************************
      /EJECT
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
      **    DBErrCtl   10A     = 'DBERRCTL' (the name of the database
      **                               error handler)
      ** and the following variables:
      **    RunBefore  1A (for the PSSR)

     D/COPY ZACPYSRC,STD_D_SPEC

      ** The following /COPY line includes all the defined fields in
      ** the PSDS.  They have meaningful names, prefixed by 'PS'.

      ** Program Status Data Structure
     D/COPY ZACPYSRC,PSDS

      **  Array For ZEDIT And ZALIGN
     D/COPY ZSRSRC,ZALIGNZ1LE

      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+

      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
      *
      ** File Information Data Structure for SF00350P1
     D SPOOL1          DS
     D  SFILE1                83     92
     D  SFNUM1               123    124B 0
     D  OFLLN1               188    189B 0
     D  PRTLN1               367    368B 0

      ** File Information Data Structure for SF00350AU
     D SPOOLU          DS
     D  SFILEU                83     92
     D  SFNUMU               123    124B 0
                                                                                            AR996504
      ** External data structures for Branches                                              AR996504
     D SDBRCH        E DS                  EXTNAME(SDBRCHPD)                                AR996504
                                                                                            AR996504
      ** External data structures for Companies                                             AR996504
     D SDCOMP        E DS                  EXTNAME(SDCOMPPD)                                AR996504

      ** Dummy Data Structures used by Access Programs.
     D DSFDY         E DS                  EXTNAME(DSFDY)

      ** Dummy Data Structures used by Access Programs.
     D DSSDY         E DS                  EXTNAME(DSSDY)

      ** External data structures for Bank Details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)

      ** External data structures for Switchable features
     D SCSARDPD      E DS                  EXTNAME(SCSARDPD)

      ** External data structures for Midas Module                                          AR996504
     D SDMMODPD      E DS                  EXTNAME(SDMMODPD)                                AR996504
                                                                                            AR996504
      ** External data structures for Department codes
     D SDDEPT        E DS                  EXTNAME(SDDEPTPD)

      ** Rundate data area                                                                  AR996504
     D RUNDAT        E DS                  EXTNAME(RUNDAT)                                  AR996504
                                                                                            AR996504
                                                                                            AR996504
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
      *
      ** Parameters used
      *
     D PRTCD           S              7
     D POPTN           S              7
     D PSARD           S              6
     D PDPCD           S              3
      *
      ** Key fields
      *
     D KUSR            S                   LIKE(USRP)
     D KBRC            S                   LIKE(BRCB)
     D PRBRCB          S                   LIKE(BRCB)                                       AR996504
     D KMHID           S                   LIKE(MHID)
     D KUSER           S             20A
     D KSHNME          S            100A
     D*KMLHYD***       S                   LIKE(MGHYID)                                     AR996504
     D*KPRNT****       S                   LIKE(MGID)                                       AR996504
     D KHID            S                   LIKE(INDX)
     D*KIDX*****       S                   LIKE(MIINDX)                                     AR996504
     D KMNHID          S                   LIKE(MLHYID)
     D*KMNUCODE*       S                   LIKE(MLMENUCODE)                                 AR996504
      *
     D CTR             S              4S 0                                                  AR996504
     D CTR2            S              4S 0                                                  AR996504
     D BRCNT           S              2S 0                                                  AR996504
     D X               S              2S 0                                                  AR996504
     D I               S              5S 0                                                  AR996504
     D ARRSHCD         S             30A   DIM(999) ASCEND                                  AR996504
     D BRARR           S              3A   DIM(99) ASCEND                                   AR996504
     D ACTARR          S              1A   DIM(10)                                          AR996504
     D ACRARR          S              1A   DIM(10)                                          AR996504
     D WRun            S              1A
     D PSEQ            S              5A
     D RUNTYP          S              1A                                                      244592
     D PUSRP           S                   LIKE(USRP)                                         246097
     D USRP2           S                   LIKE(USRP)                                       AR996504
     D USRPZ           S                   LIKE(USRP)                                       AR996504
     D RQDLN1          S              3I 0
     D DIFLN1          S              3I 0
     D SEQ             S              5A
     D SENTY           S              3A
     D ZSERR           S              1A
     D ZSNUM           S              6  0
     D RCOUNT          S              5  0
     D RCTR            S              5  0                                                    247020
     D*PREVITEM*       S                   LIKE(MIINAR)                                       248436
     D*PREVITEM*       S                   LIKE(SITEMS)                              248436 AR996504
     D PREVMENCO       S                   LIKE(MLMENUCODE)                                   248436
     D*PREVHIER*       S                   LIKE(SHIER)                               248436 AR996504
     D PREVDEP         S                   LIKE(DPPT)
     D*PREVMN***       S                   LIKE(MGNAME)                                     AR996504
     D PREVUSR         S                   LIKE(USRP)
     D PREVINDX        S                   LIKE(INDX)                                       AR576681
     D WSHNAME         S            100A
     D WFIRST          S              1A
     D WRKF1           S              4A
     D WRKF2           S                   LIKE(MLHYID)
     D HIERARR         S                   Dim(999) LIKE(MLHYID)
     D COUNT           S              5U 0 INZ(2)
     D NC              S              5U 0 INZ(2)
     D*HIER*****       S             20A                                                    AR996504
     D*BACOL1***       S              1A                                                    AR996504
     D*BACOL2***       S              1A                                                    AR996504
     D*BACOL3***       S              1A                                                    AR996504
     D*ITMOK****       S              1A                                                    AR996504
     D NEWBRCH         S               N   INZ(*OFF)                                        AR996504
      *                                                                                     AR996504
     D BRU             S              3    DIM(900) ASCEND                                  AR996504
     D BRU2            S              3    DIM(100) ASCEND                                  AR996504
      *                                                                                     AR996504
     D Centered        S                   LIKE(GRPP) INZ                                   MD026939
     D Y               S              3P 0 INZ                                              MD026939
     IMUSER6DF                                                                                244592
      ** Rename field                                                                         244592
     I              RECI                        #RECI                                         254503
     I              LCD                         L6LCD                                         244592
     IMUSER5DF                                                                                254503
      *                                                                                       254503
      ** Rename field                                                                         254503
      *                                                                                       254503
     I              RECI                        #RECI                                         254503
     IMUSERLDF                                                                                254503
      *                                                                                       254503
      ** Rename field                                                                         254503
      *                                                                                       254503
     I              RECI                        #RECI                                         254503
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
      * MAIN PROCEDURE                                                *
      *****************************************************************
      *
      ** Perform Detail Processing.
      *
     C                   EXSR      PROCES
      *
      ** Output Audit Report and End Program.
      *
     C                   EXSR      AUDIT
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * PROCES - SR to do the detail processing                       *
      *                                                               *
      * Called by: Main processing                                    *
      *                                                               *
      * Calls:                                                        *
      *  AUDIT  - Produce audit report and end program                *
      *  RCFP1  - Record P1 spool file on RCF                         *
      *  REPORT - Process Report Lines                                *
      *  WP1END - Write end of report                                 *
      *                                                               *
      *****************************************************************
      *
     C     PROCES        BEGSR
      *
     C                   EVAL      RCOUNT = 0
     C                   EVAL      RCTR = 0                                                   247020
     C                   EVAL      WFIRST = 'Y'
      *
     C     PUSRP         IFEQ      *BLANK                                                     246097
     C     RUNTYP        IFEQ      'L'                                                        244592
     C     *LOVAL        SETLL     MUSERL5
     C                   READ      MUSERL5                                89
     C                   ELSE                                                                 244592
      *                                                                                       244592
      ** Use logical file MUSERL7 if Audit to include the deleted users                       244592
      *                                                                                       244592
     C     *LOVAL        SETLL     MUSERL7                                                    244592
     C                   READ      MUSERL7                                89                  244592
     C                   ENDIF                                                                244592
      *
      ** If EOF report no records
      *
     C                   IF        *IN89 = *on
     C                   EXSR      AUDIT
     C                   ELSE
      *
      ** If record read, ensure spool file P1 recorded by RCF
      *
     C                   EXSR      RCFP1
     C                   ENDIF
      *
      ** Main Process
      *
     C                   DOW       *IN89 = *OFF
      *
      ** Process report detail lines.
      *
     C     L6LCD         IFEQ      BJRDNB                                                     244592
     C     RUNTYP        OREQ      'L'                                                        244592
     C                   EXSR      REPORT
     C                   ENDIF                                                                244592

     C                   IF        #RECI = 'D'                                                254503
     C                   EVAL      RCTR = RCTR + 1                                            247020
     C                   ENDIF                                                                254503
                                                                                              254503
     C     RUNTYP        IFEQ      'L'                                                        244592
     C                   READ      MUSERL5                                89
     C                   ELSE                                                                 244592
     C                   READ      MUSERL7                                89                  244592
     C                   ENDIF                                                                244592
     C                   ENDDO
      *                                                                                       246097
     C                   ELSE                                                                 246097
     C*****PUSRP         CHAIN     MUSER                              89             246097 AR996504
     C     PUSRP         CHAIN(N)  MUSER                              89                    AR996504
     C                   IF        *IN89 = *OFF                                               246097
     C                   EXSR      RCFP1                                                      246097
     C                   EXSR      REPORT                                                     246097
     C                   ELSE                                                                 246097
     C                   EXSR      AUDIT                                                      246097
     C                   ENDIF                                                                246097
     C                   ENDIF                                                                246097
      *
      ** Write final records and totals to report
      *
     C                   EXSR      WP1END
      *                                                                                     AR996504
     C     *DTAARA       DEFINE                  RUNDAT                                     AR996504
     C                   IN        RUNDAT                                                   AR996504
     C                   ENDSR
      *
     ******************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * REPORT - Process Report Lines                                 *
      *                                                               *
      * Called by: PROCES                                             *
      *                                                               *
      * Calls: SRGTACRT - Get access rights                           *
      *                                                               *
      *                                                               *
      *****************************************************************
      *
     C     REPORT        BEGSR
     C                   MOVE      *BLANKS       HIERARR
     C                   EVAL      COUNT = 2
     C                   EVAL      NC = 2
      *
      ** Retrieve record from GPTUSRMNU0
      *
     C                   MOVEL     USRP          KUSER
     C     KUSER         CHAIN     GPTUSRMNU0
      *
     C                   IF        %FOUND(GPTUSRMNU0)
     C                   MOVEL     *BLANKS       WSHNAME
     C                   MOVEL     SHNAME        WSHNAME
     C                   EVAL      WSHNAME = %TRIM(WSHNAME)
     C                   IF        WSHNAME = *BLANKS                                        AR576681
     C                   EVAL      WSHNAME = 'MAIN'                                         AR576681
     C                   ENDIF                                                              AR576681
     C                   MOVE      WSHNAME       KSHNME
     C     GRPP          IFEQ      *BLANKS                                                  MD026939
     C                   MOVEL     SHNAME        GRPP                                       MD026939
     C                   EXSR      CtrGRPP                                                  MD026939
     C                   ENDIF                                                              MD026939
     C                   ELSE
     C                   EVAL      KSHNME  = 'MAIN'
     C     GRPP          IFEQ      *BLANKS                                                  MD026939
     C                   MOVEL     'MAIN'        GRPP                                       MD026939
     C                   EXSR      CtrGRPP                                                  MD026939
     C                   ENDIF                                                              MD026939
     C                   ENDIF
      *
      ** Get Hierarchy ID
      *
     C     KSHNME        CHAIN     GPTGRMNUH0
      *
     C                   IF        %FOUND(GPTGRMNUH0)
     C                   EVAL      KMHID  = MHID
     C**********         MOVEL     MHNAME        SINITM                                       263737
     C                   MOVEL(P)  MHNAME        SINITM                                       263737
      *
     C                   EVAL      RQDLN1 = 1
     C                   EVAL      DIFLN1 = OFLLN1 - PRTLN1
     C                   IF        DIFLN1 <= RQDLN1
     C                   WRITE     SF000350H0
     C                   ENDIF
      *
      ** Get department name
      *
     C                   EXSR      SRGETDP
     C                   EVAL      DEPT = DPPT
     C                   EVAL      DEPTN  = AEDPNM
     C                   EVAL      USRPRF = USRP
     C                   EVAL      USRPRN = USER1
     C                   EVAL      EMPNM  = EMPNO
      *
      ** If first pass, print the header
      *
     C                   IF        WFIRST = 'Y'
     C                   EVAL      *IN42 = *ON                                              AR576681
     C                   WRITE     SF000350H0
     C                   EXSR      USERINFO                                                 AR996504
     C                   EVAL      *IN42 = *OFF                                             AR576681
     C                   WRITE     SF000350H1
     C                   EVAL      WFIRST = 'N'
     C                   EVAL      PREVDEP = DPPT
     C                   EVAL      PREVUSR = USRP
     C                   ELSE
      *
      ** Page break if there is a change in the department
      ** Print department heading if there is a change in department
      *
     C                   IF        DPPT <> PREVDEP or
     C                             USRP <> PREVUSR
     C                   EVAL      *IN42 = *ON                                              AR576681
     C                   WRITE     SF000350H0
     C                   IF        USRP <> PREVUSR                                          AR996504
     C                   EXSR      USERINFO                                                 AR996504
     C                   ENDIF                                                              AR996504
     C                   EVAL      *IN42 = *OFF                                             AR576681
     C                   WRITE     SF000350H1
     C                   EVAL      PREVDEP = DPPT
     C                   EVAL      PREVUSR = USRP
     C                   ENDIF
      *
     C                   ENDIF
      *
     C**********         EVAL      RQDLN1 = 3                                               AR996504
     C**********         EVAL      DIFLN1 = OFLLN1 - PRTLN1                                 AR996504
     C**********         IF        DIFLN1 <= RQDLN1                                         AR996504
     C**********         WRITE     SF000350H0                                               AR996504
     C**********         ENDIF                                                              AR996504
      *
     C**********         WRITE     SF000350H2                                               AR996504
      *
     C**********         EVAL      RQDLN1 = 6                                               AR996504
     C**********         EVAL      DIFLN1 = OFLLN1 - PRTLN1                                 AR996504
     C**********         IF        DIFLN1 <= RQDLN1                                         AR996504
     C**********         WRITE     SF000350H0                                               AR996504
     C**********         ENDIF                                                              AR996504
      *
     C**********         WRITE     SF000350H3                                               AR996504
      *
      ** Count the number of users processed
      *
     C                   EVAL      RCOUNT = RCOUNT + 1
      *
      ** Clear detail lines
      *
     C                   CLEAR                   SF000350D0
      *
      ** Retrieve and print the access rights
      *
     C                   EVAL      HIERARR(1) = KMHID
     C                   EXSR      SRGETHIR
     C                   DOW       NC <= COUNT
     C                   EVAL      KMHID = HIERARR(NC)
     C                   EXSR      SRGETHIR
     C                   EVAL      NC= NC + 1
     C                   ENDDO
     C**********         EVAL      NC = 1                                                   AR996504
     C**********         DOW       NC <= 999                                                AR996504
     C**********         EVAL      KMHID = HIERARR(NC)                                      AR996504
     C                   EXSR      SRGTACRT
     C**********         EVAL      NC = NC + 1                                              AR996504
     C**********         ENDDO                                                              AR996504
     C                   ENDIF
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRGETHIR - SR get all hierarchies referenced by initial menu  *
      *                                                               *
      *****************************************************************
     C     SRGETHIR      BEGSR

     C                   EVAL      KMNHID = KMHID
     C     KMNHID        SETLL     GPTGRMNUL0
     C     KMNHID        READE     GPTGRMNUL0                             50
     C                   DOW       *IN50 = *OFF
     C                   IF        %SUBST(MLMENUCODE:1:3) = '*SS'
     C                   EVAL      WRKF1= %TRIM(%SUBST(MLMENUCODE:4:6))
     C                   EVAL      WRKF2= %DEC(WRKF1:9:0)
     C     WRKF2         LOOKUP    HIERARR                                90
     C                   IF        NOT *IN90
     C                   MOVEA     WRKF2         HIERARR(COUNT)
     C                   EVAL      COUNT = COUNT + 1
     C                   ENDIF
     C                   ENDIF
     C                   IF        %SUBST(MLMENUCODE:1:3) = '*SN'
     C                   EVAL      WRKF1= %TRIM(%SUBST(MLMENUCODE:4:6))
     C                   EVAL      WRKF2= %DEC(WRKF1:9:0)
     C     WRKF2         LOOKUP    HIERARR                                90
     C                   IF        NOT *IN90
     C                   MOVEA     WRKF2         HIERARR(COUNT)
     C                   EVAL      COUNT = COUNT + 1
     C                   ENDIF
     C                   ENDIF
     C     KMNHID        READE     GPTGRMNUL0                             50
     C                   ENDDO
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRGTACRT - SR to get the access rights                        *
      *                                                               *
      *****************************************************************
     C     SRGTACRT      BEGSR
      *                                                                                     AR996504
      ** Determine all branches for the user                                                AR996504
      *                                                                                     AR996504
     C     USRP          SETLL     GZMACBRL3                                                AR996504
     C     USRP          READE     GZMACBRL3                                                AR996504
      *                                                                                     AR996504
     C                   EVAL      PRBRCB = *BLANKS                                         AR996504
     C                   EVAL      BRCNT = 0                                                AR996504
     c                   CLEAR                   BRARR                                      AR996504
     C                   DOW       NOT %EOF (GZMACBRL3)                                     AR996504
     C                   IF        PRBRCB <> BRCB                                           AR996504
     C                   EVAL      PRBRCB = BRCB                                            AR996504
     C                   EVAL      BRCNT = BRCNT + 1                                        AR996504
     C                   EVAL      BRARR(BRCNT) = BRCB                                      AR996504
     C                   ENDIF                                                              AR996504
     C     USRP          READE     GZMACBRL3                                                AR996504
     C                   ENDDO                                                              AR996504
      *                                                                                     AR996504
      ** By branch, by submenu                                                              AR996504
      *                                                                                     AR996504
     C                   EVAL      NEWBRCH = *ON                                            AR996504
     C                   FOR       X = 1 TO BRCNT                                           AR996504
     C                   EVAL      SBRCH = BRARR(X)                                         AR996504
      *                                                                                     AR996504
     C                   FOR       I = 1 TO NC                                              AR996504
     C                   EVAL      *IN40 = *ON                                              AR996504
     C                   EVAL      KMNHID = HIERARR(I)                                      AR996504
     C                   EVAL      KMHID = HIERARR(I)                                       AR996504
     C                   EVAL      PREVMENCO = *BLANKS                                      AR996504
     C     KMNHID        SETLL     T_GRMENUL                                                AR996504
     C     KMNHID        READE     T_GRMENUL                                                AR996504
     C                   CLEAR                   ARRSHCD                                    AR996504
     C                   EVAL      CTR = 0                                                  AR996504
      *                                                                                     AR996504
      ** Retrieve all the menu items under the submenu (hier)                               AR996504
      *                                                                                     AR996504
     C                   DOW       NOT %EOF (GPTGRMNUL0)                                    AR996504
      *                                                                                     AR996504
     C     MLMENUCODE    IFNE      PREVMENCO                                                AR996504
     C                   EVAL      KUSR = USRP                                              AR996504
     C                   EVAL      KHID = MLMENUCODE                                        AR996504
     C                   EVAL      KBRC = BRARR(X)                                          AR996504
     C     *LOVAL        SETLL     GZMACBRL3                                                AR996504
     C     KMACBR        CHAIN     GZMACBRL3                                                AR996504
      *                                                                                     AR996504
     C                   IF        %FOUND (GZMACBRL3)                                       AR996504
     C     INDX          CHAIN     GPMTXTD0                                                 AR996504
      *                                                                                     AR996504
     C                   IF        %FOUND (GPMTXTL0)                                        AR996504
     C                   EVAL      CTR = CTR + 1                                            AR996504
     C                   EVAL      ARRSHCD(CTR) = MISNAM + MIINDX                           AR996504
     C                   ENDIF                                                              AR996504
      *                                                                                     AR996504
     C                   ENDIF                                                              AR996504
      *                                                                                     AR996504
     C                   EVAL      PREVMENCO = MLMENUCODE                                   AR996504
     C                   ENDIF                                                              AR996504
      *                                                                                     AR996504
     C     KMNHID        READE     T_GRMENUL                                                AR996504
     C                   ENDDO                                                              AR996504
      *                                                                                     AR996504
      ** Sort ascendingly the menu items by menu short code                                 AR996504
      *                                                                                     AR996504
     C                   IF        CTR > 0                                                  AR996504
     C                   SORTA     ARRSHCD                                                  AR996504
     C                   ENDIF                                                              AR996504
      *                                                                                     AR996504
      ** Get the submenu text                                                               AR996504
      *                                                                                     AR996504
     C     KMHID         CHAIN     HIDH                                                     AR996504
     C                   IF        %FOUND                                                   AR996504
     C                   EVAL      SHIER= %TRIM(MHNAME)                                     AR996504
     C                   ELSE                                                               AR996504
     C                   EVAL      SHIER = *BLANKS                                          AR996504
     C                   ENDIF                                                              AR996504
      *                                                                                     AR996504
      ** Write the records for each submenu                                                 AR996504
      *                                                                                     AR996504
     C                   EVAL      CTR2 = 1000 - CTR                                        AR996504
     C                   FOR       CTR = CTR2 TO 999                                        AR996504
     C                   MOVE      ARRSHCD(CTR)  KHID                                       AR996504
     C                   EVAL      KBRC = BRARR(X)                                          AR996504
     C     KMACBR        CHAIN     GZMACBRL3                                                AR996504
     C                   IF        %FOUND (GZMACBRL3)                                       AR996504
      *                                                                                     AR996504
      ** Access Rights                                                                      AR996504
      *                                                                                     AR996504
     C                   CLEAR                   ACRARR                                     AR996504
     C                   EVAL      ACRARR(1) = ACA1                                         AR996504
     C                   EVAL      ACRARR(2) = ACA2                                         AR996504
     C                   EVAL      ACRARR(3) = ACA3                                         AR996504
     C                   EVAL      ACRARR(4) = ACA4                                         AR996504
     C                   EVAL      ACRARR(5) = ACA5                                         AR996504
     C                   EVAL      ACRARR(6) = ACA6                                         AR996504
     C                   EVAL      ACRARR(7) = ACA7                                         AR996504
     C                   EVAL      ACRARR(8) = ACA8                                         AR996504
     C                   EVAL      ACRARR(9) = ACA9                                         AR996504
     C                   EVAL      ACRARR(10) = ACA10                                       AR996504
     C                   MOVEA     ACRARR        ACCRYT                                     AR996504
      *                                                                                     AR996504
      ** Menu description and shortcode                                                     AR996504
      *                                                                                     AR996504
     C     KHID          CHAIN     GPMTXTD0                                                 AR996504
     C                   IF        %FOUND (GPMTXTL0)                                        AR996504
     C                   EVAL      SITEMS = MIINAR                                          AR996504
     C                   EVAL      SISNAM = MISNAM                                          AR996504
     C                   ENDIF                                                              AR996504
      *                                                                                     AR996504
      ** Available action codes                                                             AR996504
      *                                                                                     AR996504
     C                   CLEAR                   ACTARR                                     AR996504
     C     KHID          CHAIN     SFMENUL0                                                 AR996504
     C                   IF        NOT %FOUND (SFMENUL0)                                    AR996504
     C     KHID          CHAIN     GPMENUL0                                                 AR996504
     C                   ENDIF                                                              AR996504
     C                   IF        %FOUND (SFMENUL0) OR                                     AR996504
     C                             %FOUND (GPMENUL0)                                        AR996504
     C                   EVAL      ACTARR(1) = MIAAC1                                       AR996504
     C                   EVAL      ACTARR(2) = MIAAC2                                       AR996504
     C                   EVAL      ACTARR(3) = MIAAC3                                       AR996504
     C                   EVAL      ACTARR(4) = MIAAC4                                       AR996504
     C                   EVAL      ACTARR(5) = MIAAC5                                       AR996504
     C                   EVAL      ACTARR(6) = MIAAC6                                       AR996504
     C                   EVAL      ACTARR(7) = MIAAC7                                       AR996504
     C                   EVAL      ACTARR(8) = MIAAC8                                       AR996504
     C                   EVAL      ACTARR(9) = MIAAC9                                       AR996504
     C                   EVAL      ACTARR(10) = MIAAC10                                     AR996504
     C                   ENDIF                                                              AR996504
     C                   MOVEA     ACTARR        VALACT                                     AR996504
      *                                                                                     AR996504
      ** Write the details to the report but check for printer overflow                     AR996504
      ** or if it is a new branch                                                           AR996504
      *                                                                                     AR996504
     C                   EVAL      RQDLN1 = 3                                               AR996504
     C                   EVAL      DIFLN1 = OFLLN1 - PRTLN1                                 AR996504
     C                   IF        DIFLN1 <= RQDLN1                                         AR996504
     C                             OR NEWBRCH = *ON                                         AR996504
     C                   WRITE     SF000350H0                                               AR996504
     C                   WRITE     SF000350H2                                               AR996504
     C                   WRITE     SF000350H3                                               AR996504
     C                   EVAL      NEWBRCH = *OFF                                           AR996504
      *                                                                                     AR996504
      ** Redisplay menu and menu items since there has been a page                          AR996504
      ** break.                                                                             AR996504
      *                                                                                     AR996504
     C                   EVAL      *IN40 = *ON                                              AR996504
     C                   ENDIF                                                              AR996504
      *                                                                                     AR996504
     C                   WRITE     SF000350D0                                               AR996504
     C                   EVAL      *IN40 = *OFF                                             AR996504
     C                   ENDIF                                                              AR996504
     C                   ENDFOR                                                             AR996504
      *                                                                                     AR996504
     C                   ENDFOR                                                             AR996504
      *                                                                                     AR996504
     C                   EVAL      NEWBRCH = *ON                                            AR996504
     C                   ENDFOR                                                             AR996504

     C**********         EVAL      KMNHID = KMHID                                           AR996504
     C**********         EVAL      KMNUCODE = *LOVAL                                        AR996504
     C**********         EVAL      PREVMENCO = *BLANKS                               248436 AR996504
     C*****KMHID         CHAIN     HIDH                                                     AR996504
     C**********         IF        %FOUND                                                   AR996504
     C**********         EVAL      HIER= %TRIM(MHNAME)                                      AR996504
     C**********         ENDIF                                                              AR996504
     C*****KMNHID        SETLL     GPTGRMNUL0                                               AR996504
     C*****KMNHID        READE     GPTGRMNUL0                             50                AR996504
     C**********         DOW       *IN50 = *OFF                                             AR996504
      *
      ***Read*MACBR1***************************************************                     AR996504
      *
     C*****MLMENUCODE    IFNE      PREVMENCO                                         248436 AR996504
     C**********         EVAL      KUSR = USRP                                              AR996504
     C**********         MOVE      MLMENUCODE    KHID                                       AR996504
     C**********         EVAL      KBRC = *LOVAL                                            AR996504
     C**********         EVAL      BACOL1 = 'N'                                             AR996504
     C**********         EVAL      BACOL2 = 'N'                                             AR996504
     C**********         EVAL      BACOL3 = 'N'                                             AR996504
     C**********         EVAL      ITMOK    = 'N'                                           AR996504
      *
     C*****KMACBR        SETLL     GZMACBRL2                                                AR996504
     C*****KMACBRP       READE     GZMACBRL2                              51                AR996504

     C**********         DOW       *IN51 = *OFF                                             AR996504
      *
      ***Get*the*menu*name*********************************************                     AR996504
      *
     C**********         EVAL      KMLHYD = MLHYID                                          AR996504
     C**********         EVAL      KPRNT  = MLPARENT                                        AR996504
     C*****KGRMNG        CHAIN     GPTGRMNUG0                                               AR996504

      ***If*previous*menu*name*the*same,*hide*the*item*****************                     AR996504

     C**********         IF        %FOUND(GPTGRMNUG0) AND                                   AR996504
     C**********                   MGNAME <> PREVMN                                         AR996504
     C**********         EVAL      PREVMN = MGNAME                                          AR996504
     C**********         EVAL      SHIER  = HIER                                            AR996504
     C**********         EVAL      *IN40  = *ON                                      248436 AR996504
     C**********         ELSE                                                               AR996504
     C**********         EVAL      *IN40  = *OFF                                     248436 AR996504
     C**********         ENDIF                                                              AR996504
      *
      ***Get*menu*items*from*GPMTXTL0**********************************                     AR996504
      *
     C**********         MOVE      INDX          KIDX                                       AR996504
     C*****KIDX          CHAIN     GPMTXTL0                                                 AR996504
      *
      ***Write*the*item*only*in*the*first*instance*********************                     AR996504
      *
     C**********         IF        %FOUND(GPMTXTL0) AND                              248436 AR996504
     C**********                   MIINAR <> PREVITEM                                248436 AR996504
     C**********         IF        %FOUND(GPMTXTL0)                                  248436 AR996504
     C**********         MOVEL     MIINAR        SITEMS                                     AR996504
     C**********         EVAL      PREVITEM = MIINAR                                 248436 AR996504
     C**********         EVAL      *IN41    = *ON                                    248436 AR996504
     C**********         EVAL      ITMOK    = 'Y'                                           AR996504
     C**********         ELSE                                                               AR996504
     C**********         EVAL      *IN41    = *OFF                                   248436 AR996504
     C**********         ENDIF                                                              AR996504
      *
      ***Get*the*Branch*and*Access*Rights******************************                     AR996504
      *
     C**********         EVAL      SHIER = HIER                                             AR996504
      *
     C**********         IF        BACOL3 = 'N' AND BACOL2 = 'Y'                            AR996504
     C**********         EVAL      SBRCH3 = BRCB                                            AR996504
     C**********         EVAL      ACR21 = ACA1                                             AR996504
     C**********         EVAL      ACR22 = ACA2                                             AR996504
     C**********         EVAL      ACR23 = ACA3                                             AR996504
     C**********         EVAL      ACR24 = ACA4                                             AR996504
     C**********         EVAL      ACR25 = ACA5                                             AR996504
     C**********         EVAL      ACR26 = ACA6                                             AR996504
     C**********         EVAL      ACR27 = ACA7                                             AR996504
     C**********         EVAL      ACR28 = ACA8                                             AR996504
     C**********         EVAL      ACR29 = ACA9                                             AR996504
     C**********         EVAL      ACR30 = ACA10                                            AR996504
     C**********         EVAL      BACOL3 = 'Y'                                             AR996504
     C**********         IF        ITMOK = 'Y'                                              AR996504
     C**********         EVAL      *IN41 = *ON                                              AR996504
     C**********         EVAL      ITMOK    = 'N'                                           AR996504
     C**********         ENDIF                                                              AR996504
     C**********         ENDIF                                                              AR996504
     C**********         IF        BACOL2 = 'N' AND BACOL1 = 'Y'                            AR996504
     C**********         EVAL      SBRCH2 = BRCB                                            AR996504
     C**********         EVAL      ACR11 = ACA1                                             AR996504
     C**********         EVAL      ACR12 = ACA2                                             AR996504
     C**********         EVAL      ACR13 = ACA3                                             AR996504
     C**********         EVAL      ACR14 = ACA4                                             AR996504
     C**********         EVAL      ACR15 = ACA5                                             AR996504
     C**********         EVAL      ACR16 = ACA6                                             AR996504
     C**********         EVAL      ACR17 = ACA7                                             AR996504
     C**********         EVAL      ACR18 = ACA8                                             AR996504
     C**********         EVAL      ACR19 = ACA9                                             AR996504
     C**********         EVAL      ACR20 = ACA10                                            AR996504
     C**********         EVAL      BACOL2 = 'Y'                                             AR996504
     C**********         ENDIF                                                              AR996504
     C**********         IF        BACOL1 = 'N'                                             AR996504
     C**********         EVAL      SBRCH = BRCB                                             AR996504
     C**********         EVAL      ACR1 = ACA1                                              AR996504
     C**********         EVAL      ACR2 = ACA2                                              AR996504
     C**********         EVAL      ACR3 = ACA3                                              AR996504
     C**********         EVAL      ACR4 = ACA4                                              AR996504
     C**********         EVAL      ACR5 = ACA5                                              AR996504
     C**********         EVAL      ACR6 = ACA6                                              AR996504
     C**********         EVAL      ACR7 = ACA7                                              AR996504
     C**********         EVAL      ACR8 = ACA8                                              AR996504
     C**********         EVAL      ACR9 = ACA9                                              AR996504
     C**********         EVAL      ACR10 = ACA10                                            AR996504
     C**********         EVAL      BACOL1 = 'Y'                                             AR996504
     C**********         ENDIF                                                              AR996504
      *
      ***Write*the*details*to*the*report*but*check*for*printer*overflow*                    AR996504
      *
     C**********         EVAL      RQDLN1 = 3                                               AR996504
     C**********         EVAL      DIFLN1 = OFLLN1 - PRTLN1                                 AR996504
     C**********         IF        DIFLN1 <= RQDLN1                                         AR996504
     C**********         WRITE     SF000350H0                                               AR996504
     C**********         WRITE     SF000350H2                                               AR996504
     C**********         WRITE     SF000350H3                                               AR996504
      *
      ***Redisplay*menu*and*menu*items*since*there*has*been*a*page*****                     AR996504
      ***break.********************************************************                     AR996504
      *
     C**********         EVAL      *IN40 = *ON                                              AR996504
     C**********         EVAL      *IN41 = *ON                                              AR996504
     C**********         EVAL      *IN43 = *ON                                     AR576681 AR996504
     C**********         ELSE                                                      AR576681 AR996504
     C**********         EVAL      *IN40 = *OFF                                    AR576681 AR996504
     C**********         EVAL      *IN41 = *OFF                                    AR576681 AR996504
     C**********         ENDIF
      *
      *
     C*****KMACBRP       READE     GZMACBRL2                              51                AR996504
      *
     C**********         IF        *IN51 = '1'                                              AR996504
     C**********                   OR BACOL3 = 'Y'                                 AR576681 AR996504
      *                                                                                       248436
      **Suppress*fields*if*previously*written*****************************           248436 AR996504
     C**********         IF        SHIER <> PREVHIER OR                              248436 AR576681
     C**********                   PRTLN1 < 16                                       248436 AR576681
     C**********         EVAL      *IN40 = *ON                                       248436 AR576681
     C**********         ELSE                                                        248436 AR576681
     C**********         EVAL      *IN40 = *OFF                                      248436 AR576681
     C**********         ENDIF                                                       248436 AR576681
      *                                                                                       248436
     C**********         IF        SITEMS <> PREVITEM  OR                            248436 AR576681
     C**********                   PRTLN1 < 16                                       248436 AR576681
     C**********         EVAL      *IN41 = *ON                                       248436 AR576681
     C**********         ELSE                                                        248436 AR576681
     C**********         EVAL      *IN41 = *OFF                                      248436 AR576681
     C**********         ENDIF                                                       248436 AR576681
     C**********         IF        SHIER <> PREVHIER                               AR576681 AR996504
     C**********                    OR *IN43 = *ON                                 AR576681 AR996504
     C**********         EVAL      *IN40 = *ON                                     AR576681 AR996504
     C**********         ENDIF                                                     AR576681 AR996504
     C**********         IF        INDX <> PREVINDX                                AR576681 AR996504
     C**********                    OR *IN43 = *ON                                 AR576681 AR996504
     C**********         EVAL      *IN41 = *ON                                     AR576681 AR996504
     C**********         ENDIF                                                     AR576681 AR996504
      *                                                                                       248436
     C**********         EVAL      *IN42 = *ON                                     AR805470 AR996504
     C**********         WRITE     SF000350D0                                               AR996504
     C**********         EVAL      BACOL1 = 'N'                                             AR996504
     C**********         EVAL      BACOL2 = 'N'                                             AR996504
     C**********         EVAL      BACOL3 = 'N'                                             AR996504
     C**********         EVAL      PREVMENCO = MLMENUCODE                            248436 AR996504
     C**********         EVAL      PREVITEM  = SITEMS                                248436 AR996504
     C**********         EVAL      PREVINDX  = INDX                                AR576681 AR996504
     C**********         EVAL      PREVHIER  = SHIER                                 248436 AR996504
     C**********         EVAL      *IN43 = *OFF                                    AR576681 AR996504
     C**********         CLEAR                   SF000350D0                        AR576681 AR996504
     C**********         ENDIF                                                              AR996504
      *
     C**********         ENDDO                                                              AR996504
      *
     C**********         ENDIF                                                       248436 AR996504
      *                                                                                       248436
     C*****KMNHID        READE     GPTGRMNUL0                             50                AR996504
     C**********         ENDDO                                                              AR996504
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * WP1END - SR to write End of Report                            *
      *                                                               *
      * Called by: PROCES                                             *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
      *
     C     WP1END        BEGSR
      *
     C                   EVAL      RQDLN1 = 4
     C                   EVAL      DIFLN1 = OFLLN1 - PRTLN1
     C                   IF        DIFLN1 <= RQDLN1
     C                   WRITE     SF000350H0
     C                   ENDIF
      *
      ** Write out Total Format
      *
     C                   IF        *IN42 = *ON                                              AR805470
     C                   WRITE     SF000350F1
      *                                                                                     AR805470
      ** Write Header when No Details to Report                                             AR805470
      *                                                                                     AR805470
     C                   ELSE                                                               AR805470
     C                   WRITE     SF000350H0                                               AR805470
     C                   WRITE     SF0000350N                                               AR805470
     C                   ENDIF                                                              AR805470
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * AUDIT - SR to output audit report and end program             *
      *                                                               *
      * Called by: Main, PROCES, *PSSR                                *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
      *
     C     AUDIT         BEGSR
      *                                                                                       248436
      ** Generate Audit Report only when not requested for Single User                        248436
      *                                                                                       248436
     C                   IF        PUSRP = *BLANKS                                            248436
      *
      ** Output Report Header
      *
     C                   WRITE     SF000350A0
      *
      ** If there is a DB error, output the DB error information.
      *
     C                   IF        *INU7 = *on
     C                   WRITE     DBERROR
     C                   ELSE
      *
      ** Or, if no records read, output "No Details" message.
      *
     C                   IF        RCOUNT = 0
     C                   WRITE     NODTLS
     C                   ELSE
      *
      ** Retrieve trailer record
      *
     C                   READ      MUSERZZ
      *
      ** Write the report controls
      *
     C                   MOVE      NORE          TNUMBR
     C**********         MOVE      RCOUNT        TCALCN                                       247020
     C                   MOVE      RCTR          TCALCN                                       247020
     C                   WRITE     SF000350A1
     C**********         IF        RCOUNT <> NORE                                             247020
     C                   IF        RCTR <> NORE                                               247020
     C                   SETON                                        U7                      247020
     C                   SETON                                        U8
     C                   WRITE     SF000350A2
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF                                                                248436
      *
      ** End Program and Return.
      *
     C                   EVAL      *INLR = *on
     C                   RETURN
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * RCFP1 - SR to register the P1 PRTF via RCF.                   *
      *                                                               *
      * Called by: PROCES                                             *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
      *
     C     RCFP1         BEGSR

     C                   OPEN      SF000350P1
      *
      ** Ensure Report Spool File recorded by RCF.
      *
     C                   EVAL      ZSNUM = SFNUM1
      *
     C                   CALL      'ZSFILE'
     C                   PARM      PSEQ          SEQ
     C                   PARM                    SENTY
     C                   PARM                    SFILE1
     C                   PARM                    ZSNUM
     C                   PARM      *BLANK        ZSERR
      *
      ** If error occurs during ZSFILE processing, then return to the
      ** calling program.
      *
     C                   IF        ZSERR = 'Y'
     C                   EVAL      *INU7 = *on
     C                   EVAL      *INU8 = *on
     C                   EVAL      *INLR = *on
     C                   RETURN
     C                   ENDIF
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * RCFAU - SR to register the AU PRTF via RCF.                   *
      *                                                               *
      * Called by: *INZSR                                             *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
      *
     C     RCFAU         BEGSR
      *
      ** Ensure Audit Spool File recorded by RCF.
      *
     C                   EVAL      ZSNUM = SFNUMU
     C                   EVAL      ZSERR = 'N'
      *
     C                   CALL      'ZSFILE'
     C                   PARM      PSEQ          SEQ
     C                   PARM                    SENTY
     C                   PARM                    SFILEU
     C                   PARM                    ZSNUM
     C                   PARM      *BLANK        ZSERR
      *
      ** If error occurs during ZSFILE processing, then return to the
      ** calling program.
      *
     C                   IF        ZSERR = 'Y'
     C                   EVAL      *INU7 = *on
     C                   EVAL      *INU8 = *on
     C                   EVAL      *INLR = *on
     C                   RETURN
     C                   ENDIF
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRGETDP - Get department name.                                *
      *                                                               *
      * Called by: REPORT                                             *
      *                                                               *
      * Calls: AODEPTR0                                               *
      *                                                               *
      *****************************************************************
      *
     C     SRGETDP       BEGSR
      *
     C                   CALL      'AODEPTR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*KEY'        POPTN
     C                   PARM      DPPT          PDPCD
     C     SDDEPT        PARM      SDDEPT        DSFDY
      *
     C                   IF        PRTCD = '*NRF'
     C                   EVAL      DEPT   = *BLANKS
     C                   EVAL      AEDPNM = *BLANKS
     C                   ENDIF
      *
     C                   ENDSR
      /EJECT                                                                                AR996504
      *****************************************************************                     AR996504
      *                                                               *                     AR996504
      * USERINFO - Print the user profile details                     *                     AR996504
      *                                                               *                     AR996504
      *****************************************************************                     AR996504
     C     USERINFO      BEGSR                                                              AR996504
                                                                                            AR996504
      *                                                                                     AR996504
     C                   IF        CHTP  = 'D'                                              AR996504
     C                   EVAL      *IN81 = *on                                              AR996504
     C                   EVAL      *IN82 = *off                                             AR996504
     C                   EVAL      *IN83 = *off                                             AR996504
     C                   IF        RUNTYP= 'A'                                              AR996504
     C     USRP          CHAIN     MUSER                              10                    AR996504
     C                   IF        *IN10 = *OFF                                             AR996504
     C                   DELETE    MUSERLDF                                                 AR996504
     C                   ENDIF                                                              AR996504
     C                   ENDIF                                                              AR996504
     C                   ENDIF                                                              AR996504
      *                                                                                     AR996504
     C                   IF        CHTP  = 'A'                                              AR996504
     C                   EVAL      *IN82 = *on                                              AR996504
     C                   EVAL      *IN81 = *off                                             AR996504
     C                   EVAL      *IN83 = *off                                             AR996504
     C                   ENDIF                                                              AR996504
     C                   IF        CHTP  = 'I'                                              AR996504
     C                   EVAL      *IN83 = *on                                              AR996504
     C                   EVAL      *IN81 = *off                                             AR996504
     C                   EVAL      *IN82 = *off                                             AR996504
     C                   ENDIF                                                              AR996504
      *                                                                                     AR996504
     C                   WRITE     H12332                                                   AR996504
     C                   WRITE     D12332                                                   AR996504
      *                                                                                     AR996504
     C                   CALL      'AOMMODR0'                                               AR996504
     C                   PARM      *BLANKS       PRTCD                                      AR996504
     C                   PARM      '*KEY'        POPTN                                      AR996504
     C     SDMMODPD      PARM      SDMMODPD      DSFDY                                      AR996504
      *                                                                                     AR996504
     C                   IF        PRTCD = *BLANKS                                          AR996504
     C                   IF        BGFDTR= 'Y'                                              AR996504
     C                   EVAL      *IN90 = *on                                              AR996504
     C                   ENDIF                                                              AR996504
      *                                                                                     AR996504
     C                   IF        BGMSDL= 'Y'                                              AR996504
     C                   EVAL      *IN92 = *on                                              AR996504
     C                   ENDIF                                                              AR996504
      * Check FRA/IRS if *on                                                                AR996504
     C                   IF        BGFIIN= 'Y'                                              AR996504
     C                   EVAL      *IN94 = *on                                              AR996504
     C                   ENDIF                                                              AR996504
     C                   ENDIF                                                              AR996504
      *                                                                                     AR996504
     C                   CALL      'AOSARDR0'                                               AR996504
     C                   PARM      *BLANKS       PRTCD                                      AR996504
     C                   PARM      '*KEY'        POPTN                                      AR996504
     C                   PARM      'CAAA01'      PSARD                                      AR996504
     C     SCSARDPD      PARM      SCSARDPD      DSFDY                                      AR996504
     C                   IF        PRTCD <> '*NRF'                                          AR996504
     C                   EVAL      *IN35  = *on                                             AR996504
     C                   ENDIF                                                              AR996504
      *                                                                                     AR996504
     C                   IF        *IN90 = *on                                              AR996504
     C                   IF        PAUT  = 'Y'                                              AR996504
     C                   EVAL      *IN91  = *on                                             AR996504
     C                   ELSE                                                               AR996504
     C                   EVAL      *IN91  = *off                                            AR996504
     C                   ENDIF                                                              AR996504
     C                   ENDIF                                                              AR996504
     C                                                                                      AR996504
     C                   IF        ROUF  = 'Y'                                              AR996504
     C                   EVAL      *IN93  = *on                                             AR996504
     C                   ELSE                                                               AR996504
     C                   EVAL      *IN93  = *off                                            AR996504
     C                   ENDIF                                                              AR996504
     C                                                                                      AR996504
     C                   IF        *IN94 = *on                                              AR996504
     C                   IF        AURF  = 'Y'                                              AR996504
     C                   EVAL      *IN95  = *on                                             AR996504
     C                   ELSE                                                               AR996504
     C                   EVAL      *IN95  = *off                                            AR996504
     C                   ENDIF                                                              AR996504
     C                   ENDIF                                                              AR996504
      *                                                                                     AR996504
     C     USRP          CHAIN     GPTUSRLNG0                         20                    MD026939
     C     *IN20         IFEQ      '0'                                                      MD026939
     C**********         MOVE      USRLANG       USLG              2               MD026939 MD061410
     C                   MOVE      *BLANKS       USLG              2                        MD061410
     C                   EVAL      USLG = %TRIM(%SUBST(USRLANG:3:2))                        MD061410
     C     USLG          CHAIN     SDLANGL0                           80                    MD026939
     C     *IN80         IFEQ      '1'                                                      MD026939
     C                   READ      SDLANGL0                               80                MD026939
     C                   ENDIF                                                              MD026939
     C                   ELSE                                                               MD026939
     C                   READ      SDLANGL0                               80                AR996504
     C                   ENDIF                                                              MD026939
      *                                                                                     MD026939
     C                   IF        *IN80 = *off                                             AR996504
     C                   WRITE     D82332C                                                  AR996504
     C                   ENDIF                                                              AR996504
     C                   WRITE     D82332B                                                  AR996504
      *                                                                                     AR996504
     C                   IF        ROUT  = 'N'                                              AR996504
     C                   EVAL      *IN86  = *on                                             AR996504
     C                   ELSE                                                               AR996504
     C                   EVAL      *IN86  = *off                                            AR996504
     C                   ENDIF                                                              AR996504
      *                                                                                     AR996504
     C                   IF        MUREP = 'N'                                              AR996504
     C                   EVAL      *IN87  = *on                                             AR996504
     C                   ELSE                                                               AR996504
     C                   EVAL      *IN87  = *off                                            AR996504
     C                   ENDIF                                                              AR996504
     C                   CALL      'AOSARDR0'                                               AR996504
     C                   PARM      *BLANKS       PRTCD                                      AR996504
     C                   PARM      '*KEY'        POPTN                                      AR996504
     C                   PARM      'CGL008'      PSARD                                      AR996504
     C     SCSARDPD      PARM      SCSARDPD      DSFDY                                      AR996504
     C                   IF        PRTCD = *BLANKS                                          AR996504
     C                   EVAL      *IN45  = *on                                             AR996504
     C                   ENDIF                                                              AR996504
     C                                                                                      AR996504
      *                                                                                     AR996504
     C                   IF        BGMBIN= 'Y'                                              AR996504
     C                   EVAL      *IN55  = *on                                             AR996504
     C                   IF        BANK  = 'N'                                              AR996504
     C                   EVAL      *IN88  = *on                                             AR996504
     C                   ELSE                                                               AR996504
     C                   EVAL      *IN88  = *off                                            AR996504
     C                   ENDIF                                                              AR996504
     C                   IF        MBREP = 'N'                                              AR996504
     C                   EVAL      *IN84  = *on                                             AR996504
     C                   ELSE                                                               AR996504
     C                   EVAL      *IN84  = *off                                            AR996504
     C                   ENDIF                                                              AR996504
     C                   ENDIF                                                              AR996504
      *                                                                                     AR996504
     C                   WRITE     D92332B                                                  AR996504
     C                   EXSR      BACCESS                                                  AR996504
     C                   EXSR      OACCESS                                                  AR996504
     C                   EXSR      CACCESS                                                  AR996504
     C                                                                                      AR996504
     C                   ENDSR                                                              AR996504
                                                                                            AR996504
      /EJECT                                                                                AR996504
      *****************************************************************                     AR996504
      *                                                               *                     AR996504
      * BACCESS  - Check the users access in booking branches         *                     AR996504
      *                                                               *                     AR996504
      *****************************************************************                     AR996504
     C     BACCESS       BEGSR                                                              AR996504
     C                                                                                      AR996504
     C                   EVAL      RQDLN1 = 2                                               AR996504
     C                   EVAL      DIFLN1 = OFLLN1 - PRTLN1                                 AR996504
     C                   IF        BRBS  = 'Y'  AND *IN55 = *on                             AR996504
     C                   EVAL      RECI  = *BLANKS                                          AR996504
     C                   EVAL      USRP2 = USRP                                             AR996504
     C     USRP2         CHAIN     MBRBS                              99                    AR996504
     C                   IF        *IN99 = *OFF AND RECI = 'D'                              AR996504
     C                             AND VBRX <> *BLANKS                                      AR996504
     C                   EVAL      USRPY = USRP2                                            AR996504
     C                   EVAL      *IN76 = *off                                             AR996504
     C                   ELSE                                                               AR996504
     C                   EVAL      USRPX = USRP2                                            AR996504
     C                   EVAL      *IN76 = *on                                              AR996504
     C                   ENDIF                                                              AR996504
     C                   ENDIF                                                              AR996504
      *                                                                                     AR996504
     C                   IF        BRBS  = 'N' AND *IN55 = *on                              AR996504
     C                   EVAL      USRPX = USRP2                                            AR996504
     C                   EVAL      *IN76 = *on                                              AR996504
     C                   ENDIF                                                              AR996504
     C                   IF        DIFLN1 <= RQDLN1                                         AR996504
     C                   WRITE     SF000350H0                                               AR996504
     C                   ENDIF                                                              AR996504
     C                   WRITE     D22332B                                                  AR996504
                                                                                            AR996504
     C                   IF        *IN76 = *off                                             AR996504
     C                   IF        NOBR <> 0                                                AR996504
     C                   MOVEA     VBRX          BRU                                        AR996504
     C                   Z-ADD     1             B                 4 0                      AR996504
      *                                                                                     AR996504
     C     '   '         LOOKUP    BRU(B)                             10                    AR996504
      *                                                                                     AR996504
     C                   IF        *IN10 = *on                                              AR996504
     C     B             DOWLE     900                                                      AR996504
      *                                                                                     AR996504
      ** CALL A/O                                                                           AR996504
      *                                                                                     AR996504
     C                   CALL      'AOBRCHR1'                                               AR996504
     C                   PARM      *BLANK        PRTCD             7                        AR996504
     C                   PARM      '*KEY    '    POPTN             7                        AR996504
     C                   PARM      BRU(B)        PDPCD             3                        AR996504
     C     SDBRCH        PARM      SDBRCH        DSFDY                                      AR996504
      *                                                                                     AR996504
     C     PRTCD         IFNE      *BLANK                                                   AR996504
     C     *LOCK         IN        LDA                                                      AR996504
     C                   EVAL      DBKey  = BRU(B)                                          AR996504
     C                   EVAL      DBFile = 'SDBRCHPD'                                      AR996504
     C                   EVAL      Dbase = 002                                              AR996504
     C                   OUT       LDA                                                      AR996504
     C                   EXSR      *PSSR                                                    AR996504
     C                   MOVE      '1'           *IN75                                      AR996504
     C                   ENDIF                                                              AR996504
      *                                                                                     AR996504
     C                   EVAL      RQDLN1 = 2                                               AR996504
     C                   EVAL      DIFLN1 = OFLLN1 - PRTLN1                                 AR996504
     C     *IN75         IFEQ      '0'                                                      AR996504
     C                   EVAL      SBRCA = BRU(B)                                           AR996504
     C                   EVAL      SBRNM = A8BRNM                                           AR996504
     C                   ENDIF                                                              AR996504
     C                   EVAL      USRPZ = USRP2                                            AR996504
     C                   IF        DIFLN1 <= RQDLN1                                         AR996504
     C                   WRITE     SF000350H0                                               AR996504
     C                   ENDIF                                                              AR996504
     C                   WRITE     D22332C                                                  AR996504
     C                   EVAL      B = B + 1                                                AR996504
     C                   ENDDO                                                              AR996504
     C                   ENDIF                                                              AR996504
     C                   ENDIF                                                              AR996504
     C                   ENDIF                                                              AR996504
      *                                                                                     AR996504
     C                   ENDSR                                                              AR996504
      *                                                                                     AR996504
      /EJECT                                                                                AR996504
      *****************************************************************                     AR996504
      *                                                               *                     AR996504
      * OACCESS  - Check the users access in originating branches     *                     AR996504
      *                                                               *                     AR996504
      *****************************************************************                     AR996504
     C     OACCESS       BEGSR                                                              AR996504
     C                                                                                      AR996504
     C                   EVAL      RQDLN1 = 3                                               AR996504
     C                   EVAL      DIFLN1 = OFLLN1 - PRTLN1                                 AR996504
     C                   IF        BROS  = 'Y'  AND *IN55 = *on                             AR996504
     C                   EVAL      RECI  = *BLANKS                                          AR996504
     C                   EVAL      USRP2 = USRP                                             AR996504
     C     USRP2         CHAIN     MBROS                              99                    AR996504
     C                   IF        *IN99 = *OFF AND RECI = 'D'                              AR996504
     C                             AND VBRX <> *BLANKS                                      AR996504
     C                   EVAL      USRPY = USRP2                                            AR996504
     C                   EVAL      *IN76 = *off                                             AR996504
     C                   ELSE                                                               AR996504
     C                   EVAL      USRPX = USRP2                                            AR996504
     C                   EVAL      *IN76 = *on                                              AR996504
     C                   ENDIF                                                              AR996504
     C                   ENDIF                                                              AR996504
      *                                                                                     AR996504
     C                   IF        BROS  = 'N' AND *IN55 = *on                              AR996504
     C                   EVAL      USRPX = USRP2                                            AR996504
     C                   EVAL      *IN76 = *on                                              AR996504
     C                   ENDIF                                                              AR996504
     C                   IF        DIFLN1 <= RQDLN1                                         AR996504
     C                   WRITE     SF000350H0                                               AR996504
     C                   ENDIF                                                              AR996504
     C                   WRITE     D32332B                                                  AR996504
     C                   IF        *IN76 = *off                                             AR996504
     C                   IF        NOBR <> 0                                                AR996504
     C                   MOVEA     VBRX          BRU                                        AR996504
     C                   Z-ADD     1             B                 4 0                      AR996504
      *                                                                                     AR996504
     C     '   '         LOOKUP    BRU(B)                             10                    AR996504
      *                                                                                     AR996504
     C                   IF        *IN10 = *on                                              AR996504
     C     B             DOWLE     900                                                      AR996504
      *                                                                                     AR996504
      ** CALL A/O                                                                           AR996504
      *                                                                                     AR996504
     C                   CALL      'AOBRCHR1'                                               AR996504
     C                   PARM      *BLANK        PRTCD             7                        AR996504
     C                   PARM      '*KEY    '    POPTN             7                        AR996504
     C                   PARM      BRU(B)        PDPCD             3                        AR996504
     C     SDBRCH        PARM      SDBRCH        DSFDY                                      AR996504
      *                                                                                     AR996504
     C     PRTCD         IFNE      *BLANK                                                   AR996504
     C     *LOCK         IN        LDA                                                      AR996504
     C                   EVAL      DBKey  = BRU(B)                                          AR996504
     C                   EVAL      DBFile = 'SDBRCHPD'                                      AR996504
     C                   EVAL      Dbase = 002                                              AR996504
     C                   OUT       LDA                                                      AR996504
     C                   EXSR      *PSSR                                                    AR996504
     C                   MOVE      '1'           *IN75                                      AR996504
     C                   ENDIF                                                              AR996504
      *                                                                                     AR996504
     C                   EVAL      RQDLN1 = 2                                               AR996504
     C                   EVAL      DIFLN1 = OFLLN1 - PRTLN1                                 AR996504
     C     *IN75         IFEQ      '0'                                                      AR996504
     C                   EVAL      SBRCA = BRU(B)                                           AR996504
     C                   EVAL      SBRNM = A8BRNM                                           AR996504
     C                   ENDIF                                                              AR996504
     C                   EVAL      USRPZ = USRP2                                            AR996504
     C                   IF        DIFLN1 <= RQDLN1                                         AR996504
     C                   WRITE     SF000350H0                                               AR996504
     C                   ENDIF                                                              AR996504
     C                   WRITE     D22332C                                                  AR996504
     C                   EVAL      B = B + 1                                                AR996504
     C                   ENDDO                                                              AR996504
     C                   ENDIF                                                              AR996504
     C                   ENDIF                                                              AR996504
     C                   ENDIF                                                              AR996504
                                                                                            AR996504
     C                   ENDSR                                                              AR996504
      *                                                                                     AR996504
      /EJECT                                                                                AR996504
      *****************************************************************                     AR996504
      *                                                               *                     AR996504
      * CACCESS  - Check the users access in companies lists          *                     AR996504
      *                                                               *                     AR996504
      *****************************************************************                     AR996504
     C     CACCESS       BEGSR                                                              AR996504
      *                                                                                     AR996504
     C**********         EVAL      RQDLN1 = 2                                      AR996504 MD048072
     C                   EVAL      RQDLN1 = 3                                               MD048072
     C                   EVAL      DIFLN1 = OFLLN1 - PRTLN1                                 AR996504
     C                   IF        CMPS  = 'Y' AND *IN55 = *on                              AR996504
     C                   EVAL      RECI  = *BLANKS                                          AR996504
     C                   EVAL      USRP2 = USRP                                             AR996504
     C     USRP2         CHAIN     MCMPS                              99                    AR996504
     C                   IF        *IN99 = *OFF AND RECI = 'D'                              AR996504
     C                             AND VCMP <> *BLANKS                                      AR996504
     C                   EVAL      USRPY = USRP2                                            AR996504
     C                   EVAL      *IN76 = *off                                             AR996504
     C                   ELSE                                                               AR996504
     C                   EVAL      USRPX = USRP2                                            AR996504
     C                   EVAL      *IN76 = *on                                              AR996504
     C                   ENDIF                                                              AR996504
     C                   ENDIF                                                              AR996504
      *                                                                                     AR996504
     C                   IF        CMPS  = 'N'  AND *IN55 = *on                             AR996504
     C                   EVAL      USRPX = USRP2                                            AR996504
     C                   EVAL      *IN76 = *on                                              AR996504
     C                   ENDIF                                                              AR996504
     C                   IF        DIFLN1 <= RQDLN1                                         AR996504
     C                   WRITE     SF000350H0                                               AR996504
     C                   ENDIF                                                              AR996504
     C                   WRITE     D42332B                                                  AR996504
     C                   IF        *IN76 = *off                                             AR996504
     C                   IF        NOOC <> 0                                                AR996504
     C                   MOVEA     VCMP          BRU2                                       AR996504
     C                   Z-ADD     1             B                 4 0                      AR996504
      *                                                                                     AR996504
     C     '   '         LOOKUP    BRU2(B)                            10                    AR996504
      *                                                                                     AR996504
     C                   IF        *IN10 = *on                                              AR996504
     C     B             DOWLE     100                                                      AR996504
      *                                                                                     AR996504
      ** CALL A/O                                                                           AR996504
      *                                                                                     AR996504
     C                   CALL      'AOCOMPR0'                                               AR996504
     C                   PARM      *BLANK        PRTCD             7                        AR996504
     C                   PARM      '*KEY    '    POPTN             7                        AR996504
     C                   PARM      BRU2(B)       PDPCD             3                        AR996504
     C     SDCOMP        PARM      SDCOMP        DSFDY                                      AR996504
      *                                                                                     AR996504
     C     PRTCD         IFNE      *BLANK                                                   AR996504
     C     *LOCK         IN        LDA                                                      AR996504
     C                   EVAL      DBKey  = BRU2(B)                                         AR996504
     C                   EVAL      DBFile = 'SDCOMPPD'                                      AR996504
     C                   EVAL      Dbase = 003                                              AR996504
     C                   OUT       LDA                                                      AR996504
     C                   EXSR      *PSSR                                                    AR996504
     C                   MOVE      '1'           *IN75                                      AR996504
     C                   ENDIF                                                              AR996504
      *                                                                                     AR996504
     C                   EVAL      RQDLN1 = 2                                               MD048072
     C                   EVAL      RQDLN1 = RQDLN1 + 2                                      AR996504
     C                   EVAL      DIFLN1 = OFLLN1 - PRTLN1                                 AR996504
     C     *IN75         IFEQ      '0'                                                      AR996504
     C                   EVAL      SBRCA = BRU2(B)                                          AR996504
     C                   EVAL      SBRNM = APCMNM                                           AR996504
     C                   ENDIF                                                              AR996504
     C                   EVAL      USRPZ = USRP2                                            AR996504
     C                   IF        DIFLN1 <= RQDLN1                                         AR996504
     C                   WRITE     SF000350H0                                               AR996504
     C                   ENDIF                                                              AR996504
     C                   WRITE     D22332C                                                  AR996504
     C                   EVAL      B = B + 1                                                AR996504
     C                   ENDDO                                                              AR996504
     C                   ENDIF                                                              AR996504
     C                   ENDIF                                                              AR996504
     C                   ENDIF                                                              AR996504
                                                                                            AR996504
     C                   ENDSR                                                              AR996504
      /EJECT                                                                                AR996504
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      * Called by: Implicitly on program activation                   *
      *                                                               *
      * Calls: SR/RCFAU                                               *
      *                                                               *
      *****************************************************************
      *
     C     *INZSR        BEGSR
      *
      ** Receive Parameter List
      *
     C     *ENTRY        PLIST
     C                   PARM                    PSEQ
     C                   PARM                    RUNTYP                                       244592
     C                   PARM                    PUSRP                                        246097
      *
      ** Key Lists
     C     KMACBR        KLIST
     C                   KFLD                    KUSR
     C**********         KFLD                    KHID                                       AR996504
     C                   KFLD                    KBRC
     C                   KFLD                    KHID                                       AR996504
      *
     C*****KMACBRP       KLIST                                                              AR996504
     C**********         KFLD                    KUSR                                       AR996504
     C**********         KFLD                    KHID                                       AR996504
      *
     C*****KGRMNG        KLIST                                                              AR996504
     C**********         KFLD                    KMLHYD                                     AR996504
     C**********         KFLD                    KPRNT                                      AR996504
     C*****KMNH*         KLIST                                                              AR996504
     C**********         KFLD                    KMNHID                                     AR996504
     C**********         KFLD                    KMNUCODE                                   AR996504
      *
      ** Initialise LDA field.
      *
     C     *LOCK         IN        LDA
     C                   EVAL      DBPGM  =  PSProcPgm
     C                   OUT       LDA
      *
      ** Call Access Program for Bank Details - Title, Run Date and
      ** Run Day Number.
      *
     C                   CALL      'AOBANKR0'
     C                   PARM      '*MSG   '     PRTCD
     C                   PARM      '*FIRST '     POPTN
     C     SDBANK        PARM      SDBANK        DSFDY
      *
      ** Handle Database Error.
      *
     C                   IF        PRTCD <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBKey = POPTN
     C                   EVAL      DBFile = 'SDBANKPD'
     C                   EVAL      DBase = 001
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ** RCF Processing for Audit File.
      *
     C                   EXSR      RCFAU
      *
      ** Report Work fields.
      *
     C                   EVAL      RQDLN1 = 0
     C                   EVAL      DIFLN1 = 0
     C                   EVAL      PRTLN1 = 0
     C                   EVAL      *IN42 = *OFF                                             AR805470
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************                     MD026939
      *                                                               *                     MD026939
      * CtrGRPP = Center field GRPP on report.                        *                     MD026939
      *                                                               *                     MD026939
      *****************************************************************                     MD026939
     C     CtrGRPP       BEGSR                                                              MD026939
      *                                                                                     MD026939
     C                   EVAL      Y=(%LEN(GRPP)-%LEN(%TRIM(GRPP)))/2+1                     MD026939
     C                   EVAL      %SUBST(Centered:Y)=GRPP                                  MD026939
     C                   EVAL      GRPP = Centered                                          MD026939
      *                                                                                     MD026939
     C                   ENDSR                                                              MD026939
      /EJECT                                                                                MD026939
      *****************************************************************
      *                                                               *
      * *PSSR  - Program exception error routine                      *
      *          Called automatically if a program error occurs,      *
      *          or directly by the program code using EXSR.          *
      *          This subroutine DUMPs the program just once.         *
      *                                                               *
      *****************************************************************
      *
     C     *PSSR         BEGSR
      *
     C                   IF        WRun = *BLANK
     C                   EVAL      WRun = 'Y'
     C                   DUMP
     C                   ENDIF
      *
     C                   CALL      'DBERRCTL'
      *
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
      *
     C                   EXSR      AUDIT
      *
     C                   RETURN
      *
     C                   ENDSR
      *
      /EJECT
      *****************************************************************
** CPY@
(c) Finastra International Limited 2006
