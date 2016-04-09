     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2006')
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
      *  (c) Misys International Banking Systems Ltd. 2006            *
      *                                                               *
      *  Last Amend No. CFB001             Date 12Nov14               *
      *  Prev Amend No. AR805470           Date 27Jul11               *
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
     FMUSER     IF   E           K DISK                                                       246097
     F                                     RENAME(MUSERDDF:MUSERLDF)                          246097
      *
      ** Midas SF Midas users by Department
      *
     FMUSERZZ   IF   E             DISK
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
     FGPMTXTL0  IF   E           K DISK
      *
      ** Global Menu Item Text
      *
     FGZMACBRL2 IF   E           K DISK
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
 
      ** Dummy Data Structures used by Access Programs.
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      ** Dummy Data Structures used by Access Programs.
     D DSSDY         E DS                  EXTNAME(DSSDY)
 
      ** External data structures for Bank Details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
 
      ** External data structures for Switchable features
     D SCSARDPD      E DS                  EXTNAME(SCSARDPD)
 
      ** External data structures for Department codes
     D SDDEPT        E DS                  EXTNAME(SDDEPTPD)
 
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
     D KMHID           S                   LIKE(MHID)
     D KUSER           S             20A
     D KSHNME          S            100A
     D KMLHYD          S                   LIKE(MGHYID)
     D KPRNT           S                   LIKE(MGID)
     D KHID            S                   LIKE(INDX)
     D KIDX            S                   LIKE(MIINDX)
     D KMNHID          S                   LIKE(MLHYID)
     D KMNUCODE        S                   LIKE(MLMENUCODE)
      *
     D WRun            S              1A
     D PSEQ            S              5A
     D RUNTYP          S              1A                                                      244592
     D PUSRP           S                   LIKE(USRP)                                         246097
     D RQDLN1          S              3I 0
     D DIFLN1          S              3I 0
     D SEQ             S              5A
     D SENTY           S              3A
     D ZSERR           S              1A
     D ZSNUM           S              6  0
     D RCOUNT          S              5  0
     D RCTR            S              5  0                                                    247020
     D*PREVITEM*       S                   LIKE(MIINAR)                                       248436
     D PREVITEM        S                   LIKE(SITEMS)                                       248436
     D PREVMENCO       S                   LIKE(MLMENUCODE)                                   248436
     D PREVHIER        S                   LIKE(SHIER)                                        248436
     D PREVDEP         S                   LIKE(DPPT)
     D PREVMN          S                   LIKE(MGNAME)
     D PREVUSR         S                   LIKE(USRP)
     D WSHNAME         S            100A
     D WFIRST          S              1A
     D WRKF1           S              4A
     D WRKF2           S                   LIKE(MLHYID)
     D HIERARR         S                   Dim(999) LIKE(MLHYID)
     D COUNT           S              5U 0 INZ(2)
     D NC              S              5U 0 INZ(2)
     D HIER            S             20A
     D BACOL1          S              1A
     D BACOL2          S              1A
     D BACOL3          S              1A
     D ITMOK           S              1A
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
     C     PUSRP         CHAIN     MUSER                              89                      246097
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
     C                   MOVE      WSHNAME       KSHNME
     C                   ELSE
     C                   EVAL      KSHNME  = 'MAIN'
     C                   ENDIF
      *
      ** Get Hierarchy ID
      *
     C     KSHNME        CHAIN     GPTGRMNUH0
      *
     C                   IF        %FOUND(GPTGRMNUH0)
     C                   EVAL      KMHID  = MHID
     C                   MOVEL     MHNAME        SINITM
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
     C                   WRITE     SF000350H0
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
     C                   WRITE     SF000350H0
     C                   WRITE     SF000350H1
     C                   EVAL      PREVDEP = DPPT
     C                   EVAL      PREVUSR = USRP
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   EVAL      RQDLN1 = 3
     C                   EVAL      DIFLN1 = OFLLN1 - PRTLN1
     C                   IF        DIFLN1 <= RQDLN1
     C                   WRITE     SF000350H0
     C                   ENDIF
      *
     C                   WRITE     SF000350H2
      *
     C                   EVAL      RQDLN1 = 6
     C                   EVAL      DIFLN1 = OFLLN1 - PRTLN1
     C                   IF        DIFLN1 <= RQDLN1
     C                   WRITE     SF000350H0
     C                   ENDIF
      *
     C                   WRITE     SF000350H3
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
     C                   EVAL      NC = 1
     C                   DOW       NC <= 999
     C                   EVAL      KMHID = HIERARR(NC)
     C                   EXSR      SRGTACRT
     C                   EVAL      NC = NC + 1
     C                   ENDDO
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
 
     C                   EVAL      KMNHID = KMHID
     C                   EVAL      KMNUCODE = *LOVAL
     C                   EVAL      PREVMENCO = *BLANKS                                        248436
     C     KMHID         CHAIN     HIDH
     C                   IF        %FOUND
     C                   EVAL      HIER= %TRIM(MHNAME)
     C                   ENDIF
     C     KMNHID        SETLL     GPTGRMNUL0
     C     KMNHID        READE     GPTGRMNUL0                             50
     C                   DOW       *IN50 = *OFF
      *
      ** Read MACBR1
      *
     C     MLMENUCODE    IFNE      PREVMENCO                                                  248436
     C                   EVAL      KUSR = USRP
     C                   MOVE      MLMENUCODE    KHID
     C                   EVAL      KBRC = *LOVAL
     C                   EVAL      BACOL1 = 'N'
     C                   EVAL      BACOL2 = 'N'
     C                   EVAL      BACOL3 = 'N'
     C                   EVAL      ITMOK    = 'N'
      *
     C     KMACBR        SETLL     GZMACBRL2
     C     KMACBRP       READE     GZMACBRL2                              51
 
     C                   DOW       *IN51 = *OFF
      *
      ** Get the menu name
      *
     C                   EVAL      KMLHYD = MLHYID
     C                   EVAL      KPRNT  = MLPARENT
     C     KGRMNG        CHAIN     GPTGRMNUG0
 
      *  If previous menu name the same, hide the item
 
     C                   IF        %FOUND(GPTGRMNUG0) AND
     C                             MGNAME <> PREVMN
     C                   EVAL      PREVMN = MGNAME
     C                   EVAL      SHIER  = HIER
     C**********         EVAL      *IN40  = *ON                                               248436
     C                   ELSE
     C**********         EVAL      *IN40  = *OFF                                              248436
     C                   ENDIF
      *
      ** Get menu items from GPMTXTL0
      *
     C                   MOVE      INDX          KIDX
     C     KIDX          CHAIN     GPMTXTL0
      *
      ** Write the item only in the first instance
      *
     C**********         IF        %FOUND(GPMTXTL0) AND                                       248436
     C**********                   MIINAR <> PREVITEM                                         248436
     C                   IF        %FOUND(GPMTXTL0)                                           248436
     C                   MOVEL     MIINAR        SITEMS
     C**********         EVAL      PREVITEM = MIINAR                                          248436
     C**********         EVAL      *IN41    = *ON                                             248436
     C                   EVAL      ITMOK    = 'Y'
     C                   ELSE
     C**********         EVAL      *IN41    = *OFF                                            248436
     C                   ENDIF
      *
      ** Get the Branch and Access Rights
      *
     C                   EVAL      SHIER = HIER
      *
     C                   IF        BACOL3 = 'N' AND BACOL2 = 'Y'
     C                   EVAL      SBRCH3 = BRCB
     C                   EVAL      ACR21 = ACA1
     C                   EVAL      ACR22 = ACA2
     C                   EVAL      ACR23 = ACA3
     C                   EVAL      ACR24 = ACA4
     C                   EVAL      ACR25 = ACA5
     C                   EVAL      ACR26 = ACA6
     C                   EVAL      ACR27 = ACA7
     C                   EVAL      ACR28 = ACA8
     C                   EVAL      ACR29 = ACA9
     C                   EVAL      ACR30 = ACA10
     C                   EVAL      BACOL3 = 'Y'
     C                   IF        ITMOK = 'Y'
     C                   EVAL      *IN41 = *ON
     C                   EVAL      ITMOK    = 'N'
     C                   ENDIF
     C                   ENDIF
     C                   IF        BACOL2 = 'N' AND BACOL1 = 'Y'
     C                   EVAL      SBRCH2 = BRCB
     C                   EVAL      ACR11 = ACA1
     C                   EVAL      ACR12 = ACA2
     C                   EVAL      ACR13 = ACA3
     C                   EVAL      ACR14 = ACA4
     C                   EVAL      ACR15 = ACA5
     C                   EVAL      ACR16 = ACA6
     C                   EVAL      ACR17 = ACA7
     C                   EVAL      ACR18 = ACA8
     C                   EVAL      ACR19 = ACA9
     C                   EVAL      ACR20 = ACA10
     C                   EVAL      BACOL2 = 'Y'
     C                   ENDIF
     C                   IF        BACOL1 = 'N'
     C                   EVAL      SBRCH = BRCB
     C                   EVAL      ACR1 = ACA1
     C                   EVAL      ACR2 = ACA2
     C                   EVAL      ACR3 = ACA3
     C                   EVAL      ACR4 = ACA4
     C                   EVAL      ACR5 = ACA5
     C                   EVAL      ACR6 = ACA6
     C                   EVAL      ACR7 = ACA7
     C                   EVAL      ACR8 = ACA8
     C                   EVAL      ACR9 = ACA9
     C                   EVAL      ACR10 = ACA10
     C                   EVAL      BACOL1 = 'Y'
     C                   ENDIF
      *
      ** Write the details to the report but check for printer overflow
      *
     C                   EVAL      RQDLN1 = 3
     C                   EVAL      DIFLN1 = OFLLN1 - PRTLN1
     C                   IF        DIFLN1 <= RQDLN1
     C                   WRITE     SF000350H0
     C                   WRITE     SF000350H2
     C                   WRITE     SF000350H3
      *
      ** Redisplay menu and menu items since there has been a page
      ** break.
      *
     C                   EVAL      *IN40 = *ON
     C                   EVAL      *IN41 = *ON
     C                   ENDIF
      *
      *
     C     KMACBRP       READE     GZMACBRL2                              51
      *
     C                   IF        *IN51 = '1'
      *                                                                                       248436
      * Suppress fields if previously written                                                 248436
     C                   IF        SHIER <> PREVHIER OR                                       248436
     C                             PRTLN1 < 16                                                248436
     C                   EVAL      *IN40 = *ON                                                248436
     C                   ELSE                                                                 248436
     C                   EVAL      *IN40 = *OFF                                               248436
     C                   ENDIF                                                                248436
      *                                                                                       248436
     C                   IF        SITEMS <> PREVITEM  OR                                     248436
     C                             PRTLN1 < 16                                                248436
     C                   EVAL      *IN41 = *ON                                                248436
     C                   ELSE                                                                 248436
     C                   EVAL      *IN41 = *OFF                                               248436
     C                   ENDIF                                                                248436
      *                                                                                       248436
     C                   EVAL      *IN42 = *ON                                              AR805470
     C                   WRITE     SF000350D0
     C                   EVAL      BACOL1 = 'N'
     C                   EVAL      BACOL2 = 'N'
     C                   EVAL      BACOL3 = 'N'
     C                   EVAL      PREVMENCO = MLMENUCODE                                     248436
     C                   EVAL      PREVITEM  = SITEMS                                         248436
     C                   EVAL      PREVHIER  = SHIER                                          248436
     C                   ENDIF
      *
     C                   ENDDO
      *
     C                   ENDIF                                                                248436
      *                                                                                       248436
     C     KMNHID        READE     GPTGRMNUL0                             50
     C                   ENDDO
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
     C                   KFLD                    KHID
     C                   KFLD                    KBRC
      *
     C     KMACBRP       KLIST
     C                   KFLD                    KUSR
     C                   KFLD                    KHID
      *
     C     KGRMNG        KLIST
     C                   KFLD                    KMLHYD
     C                   KFLD                    KPRNT
     C     KMNH          KLIST
     C                   KFLD                    KMNHID
     C                   KFLD                    KMNUCODE
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
(c) Misys International Banking Systems Ltd. 2006
