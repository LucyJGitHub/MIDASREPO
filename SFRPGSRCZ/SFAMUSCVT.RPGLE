     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2006')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('User Def + Menu Items Conversion: File to Screen')
      *****************************************************************
      *                                                               *
      *  Midas - Security Profile Function   ILE Module               *
      *                                                               *
      *  SFAMUSCVT - User Definitions and Menu Items Details          *
      *              Conversion: File to Screen                       *
      *                                                               *
      *  Function:  This module converts the fields of the User       *
      *             Maintenance + Menu Items Details from file to     *
      *             screen format                                     *
      *                                                               *
      *  (c) Finastra International Limited 2006                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *  Prev Amend No. CRE026  *CREATE    Date 24May06               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CRE026 - Consumer Banking                                    *
      *                                                               *
      *****************************************************************
 
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      **
      **------------------------------------------------------------------
      ** The following /COPY line includes (among others) the LDA layout
      ** and the copyright array definition:
     D/COPY ZACPYSRC,STD_D_SPEC
      **------------------------------------------------------------------
 
      **------------------------------------------------------------------
      ** The following /COPY includes the MM standard declares:
     D/COPY ZACPYSRC,STDDECLARE
      **------------------------------------------------------------------
 
      **------------------------------------------------------------------
      ** The following /COPY line includes all the defined fields in the
      ** Program Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
      **------------------------------------------------------------------
 
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
 
     D AMUSFilFmt    E DS                  EXTNAME(MUSERDD)
      ** User Maintenance + Menu Items Details in File Format
     D BBRCFilFmt    E DS                  EXTNAME(MBRBSDD)
     D                                     PREFIX(B_)
      ** User Booking Branches Details in File Format
     D OBRCFilFmt    E DS                  EXTNAME(MBROSDD)
     D                                     PREFIX(O_)
      ** User Originating Branches Details in File Format
     D COMPFilFmt    E DS                  EXTNAME(MCMPSDD)
     D                                     PREFIX(C_)
      ** User Companies Details in File Format
 
     D CurTrAMUS     E DS                  EXTNAME(SFAMUSPD)
      ** User Maintenance + Menu Items Details in Screen Format
     D CurTrBBRC     E DS                  EXTNAME(SFBBRCPD)
     D                                     PREFIX(B_)
      ** Booking Branch Details in Screen Format
     D CurTrOBRC     E DS                  EXTNAME(SFOBRCPD)
     D                                     PREFIX(O_)
      ** Originating Branch Details in Screen Format
     D CurTrCOMP     E DS                  EXTNAME(SFCOMPPD)
     D                                     PREFIX(C_)
      ** Companies Details in Screen Format
      *
      ** DS to Access Currency Details
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
      *
 
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** EXTERNAL DS FOR BANK DETAILS
 
     D SCSARD        E DS                  EXTNAME(SCSARDPD)
     D   SCLCD       E                     EXTFLD(LCD)
      ** EXTERNAL DS FOR SAR DETAILS
 
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** FIRST DS FOR ACCESS PROGRAMS, SHORT DATA STRUCTURE
 
     D DSSDY         E DS                  EXTNAME(DSSDY)
      ** SECOND DS FOR ACCESS PROGRAMS, LONG DATA STRUCTURE
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
      * Define work field for Total Length of Variable/Field
     D WLEN            S              3P 0
      * Define work field for Actual Length of Variable/Field
     D Idx             S              3P 0
      ** Parameters for ZSEDIT
     D PFld15          S             15  0
     D PDecs           S              1  0
     D PECode          S              1
     D POut21          S             21
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *****************************************************************
 
 
      **************************************************************
      /EJECT
      **************************************************************
 
      ** Initialisation
     C                   EXSR      INIT
 
      ** Set screen fields
     C                   EXSR      SCREEN
 
      ** Return
     C                   RETURN
 
      *****************************************************************
      /EJECT
      *****************************************************************
      * *INZSR - INITIAL PROCESSING                                   *
      *****************************************************************
     C     *INZSR        BEGSR
      *
      **  Program Parameters
      *
     C     *ENTRY        PLIST
      *
      * Input Parameters
      *
      * Return Code
     C                   PARM                    RetCodeIn
      *
      * User Maintenance + Menu Items Details File Format
     C                   PARM                    AMUSFilFmt
      * Booking Branch Details File Format
     C                   PARM                    BBRCFilFmt
      * Originating Branch Details File Format
     C                   PARM                    OBRCFilFmt
      * Companies Details File Format
     C                   PARM                    COMPFilFmt
      *
 
      * Output Parameters
 
      * User Maintenance + Menu Items Details Screen Format
     C                   PARM                    CurTrAMUS
      * Booking Branch Details Screen Format
     C                   PARM                    CurTrBBRC
      * Originating Branch Details Screen Format
     C                   PARM                    CurTrOBRC
      * Companies Details Screen Format
     C                   PARM                    CurTrCOMP
 
      ** Initialise program name
     C                   EVAL      DBPGM = 'SFAMUSCVT'
 
      ** Access Bank Details
     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANKS       @RTCD             7
     C                   PARM      '*FIRST  '    @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
      *
      * Database Error
      *
     C                   IF        @RTCD <> *BLANK
     C                   EVAL      DBKEY = @OPTN
     C                   EVAL      DBFILE = 'SDBANKPD'
     C                   EVAL      DBASE = 900
     C                   EXSR      *PSSR
     C                   ENDIF
      ** Access Currency Details
     C                   CALL      'AOCURRR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*KEY   '     @OPTN
     C                   PARM                    BJCYCD
     C     SDCURR        PARM      SDCURR        DSSDY
      *
      * Database Error
      *
     C                   IF        @RTCD <> *BLANK
     C                   EVAL      DBKEY = @OPTN
     C                   EVAL      DBFILE = 'SDCURRPD'
     C                   EVAL      DBASE = 901
     C                   EXSR      *PSSR
     C                   ENDIF
      *
 
      ** Program, module and procedure names for dbase error processing
      ** ==============================================================
      ** The following /COPY sets these values.
      /COPY ZACPYSRC,DBFIELDS
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * INIT - Initialisation
      *****************************************************************
     C     INIT          BEGSR
 
      ** Blank outputs (EXCEPT FOR ACTION CODE)
     C                   MOVEL     DDACTN        ##ACTN            1
     C                   MOVEL     *BLANK        CurTrAMUS
     C                   MOVEL     *BLANK        CurTrBBRC
     C                   MOVEL     *BLANK        CurTrOBRC
     C                   MOVEL     *BLANK        CurTrCOMP
     C                   MOVEL     ##ACTN        DDACTN
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      ** SCREEN - SET SCREEN FIELDS
      *****************************************************************
     C     SCREEN        BEGSR
 
      * Convert User Definition + Menu Item Fields
      *
      * User Profile
     C                   EVAL      DDUSRP  = USRP
      * User Profile Name
     C                   EVAL      DDUSER1 = USER1
      * Security Level
     C                   IF        SECL = *ZEROS
     C                   EVAL      DDSECL = *BLANKS
     C                   ELSE
     C                   EVAL      ZFIELD = *BLANKS
     C                   MOVE      SECL          ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        DDSECL
     C                   ENDIF
      * User Language Code
     C                   EVAL      DDMULT = MULT
      * Department
     C                   EVAL      DDDPPT = DPPT
      * Account Officer
     C                   EVAL      DDACFA = ACFA
      * Default Branch
     C                   EVAL      DDDBRN = DBRN
      * Perform Payment Authorisation
     C                   EVAL      DDPAUT = PAUT
      * System Routing Officer
     C                   EVAL      DDROUF = ROUF
      * Auto-refresh for User
     C                   EVAL      DDAURF = AURF
      * Refresh Period
     C                   IF        REFP = *ZEROS
     C                   EVAL      DDREFP = *BLANKS
     C                   ELSE
     C                   EVAL      ZFIELD = *BLANKS
     C                   MOVE      REFP          ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        DDREFP
     C                   ENDIF
      * COB User
     C                   EVAL      DDCOBU = COBAUT
      * Teller ID
     C                   EVAL      DDTLID = TLID
      *
      ** FORMATTING ENTERING/APPROVING/AUTHORISING LIMIT FIELDS
      ** FOR THE SCREEN
     C                   MOVE      A6NBDP        PDecs
     C                   MOVE      'L'           PECode
      *
      **  FORMATTING ENTERING LIMIT FIELD
      *
     C                   Z-ADD     ENTL          PFld15
      *
     C                   CALL      'ZSEDIT'
     C                   PARM                    PFld15
     C                   PARM                    PDecs
     C                   PARM                    PECode
     C                   PARM                    POut21
      *
     C                   MOVE      POut21        DDENTL
      *
      ** FORMATTING APPROVING LIMIT FIELD
      *
     C                   Z-ADD     AUT1          PFld15
      *
     C                   CALL      'ZSEDIT'
     C                   PARM                    PFld15
     C                   PARM                    PDecs
     C                   PARM                    PECode
     C                   PARM                    POut21
      *
     C                   MOVE      POut21        DDAUT1
      *
      ** FORMATTING AUTHORISING LIMIT FIELD
      *
     C                   Z-ADD     AUT2          PFld15
      *
     C                   CALL      'ZSEDIT'
     C                   PARM                    PFld15
     C                   PARM                    PDecs
     C                   PARM                    PECode
     C                   PARM                    POut21
      *
     C                   MOVE      POut21        DDAUT2
      *
      * Choice of Report Output
     C                   EVAL      DDROUT = ROUT
      * Directory ID
     C                   EVAL      DDDIRID = DIRID
      * Directory Address
     C                   EVAL      DDDIRAD = DIRAD
      * Output Queue Name
     C                   EVAL      DDOUTQ = OUTQ
      * Cheque's Output Queue Name
     C                   EVAL      DDCOUTQ = COUTQ
      * Access to multiple User's Report
     C                   EVAL      DDMUREP = MUREP
      * Allow Access to Journal Entry ACOD's
     C                   EVAL      DDJEAA = ALACOD
      * Access to Multiple Branches Report
     C                   EVAL      DDMBREP = MBREP
      * Reference User
     C                   EVAL      DDREFU = REFUSR
      * User Authorisation Level
     C                   EVAL      DDALVL = USRLVL
      * Bank Level Function
     C                   EVAL      DDBANK = BANK
      * Booking Branches
     C                   EVAL      DDBRBS = BRBS
      * Originating Branches
     C                   EVAL      DDBROS = BROS
      * Companies
     C                   EVAL      DDCMPS = CMPS
      *
      * Convert User Booking Branches Fields
      *
      * Booking Branch Selection
     C                   EVAL      WLEN = %LEN(%TRIM(B_VBRX))
     C                   EVAL      WLEN = WLEN/3
     C                   EVAL      Idx = 1
     C                   DOW       Idx <= WLEN
     C                   EVAL      B_DDSLCT = %TRIM(B_DDSLCT) + 'Y'
     C                   EVAL      Idx = Idx + 1
     C                   ENDDO
      * Valid Booking Branches
     C                   EVAL      B_DDVBRX = B_VBRX
      *
      * Convert User Originating Branches Fields
      *
      * Originating Branch Selection
     C                   EVAL      WLEN = %LEN(%TRIM(O_VBRX))
     C                   EVAL      WLEN = WLEN/3
     C                   EVAL      Idx = 1
     C                   DOW       Idx <= WLEN
     C                   EVAL      O_DDSLCT = %TRIM(O_DDSLCT) + 'Y'
     C                   EVAL      Idx = Idx + 1
     C                   ENDDO
      * Valid Originating Branches
     C                   EVAL      O_DDVBRX = O_VBRX
      *
      * Convert User Companies Fields
      *
      * Companies Selection
     C                   EVAL      WLEN = %LEN(%TRIM(C_VCMP))
     C                   EVAL      WLEN = WLEN/3
     C                   EVAL      Idx = 1
     C                   DOW       Idx <= WLEN
     C                   EVAL      C_DDSLCT = %TRIM(C_DDSLCT) + 'Y'
     C                   EVAL      Idx = Idx + 1
     C                   ENDDO
      * Valid Companies
     C                   EVAL      C_DDVCMP = C_VCMP
      *
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * ZDATE2 - Format a date for output                             *
      *                                                               *
      *****************************************************************
     C     ZDATE2        BEGSR
 
     C                   CALLB     'ZDATE2'
     C                   PARM                    ZDAYNO            5 0
     C                   PARM                    BJDFIN
     C                   PARM                    ZDATE             6 0
     C                   PARM                    ZADATE            7
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * ZEDIT - Edit an unsigned field                                *
      *                                                               *
      *****************************************************************
     C     ZEDIT         BEGSR
 
     C                   CALLB     'ZEDIT'
     C                   PARM                    ZFIELD           16
     C                   PARM      0             ZADEC             1 0
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *PSSR  - Program exception error routine                      *
      *          Called automatically if a program error occurs,      *
      *          or directly by the program code using EXSR.          *
      *          This subroutine DUMPs the program, and performs      *
      *          a ROLLBACK.                                          *
      *                                                               *
      *****************************************************************
      ** The following /COPY contains the standard program status
      ** subroutine, including a bound call to the DBERRCTL module.
     C/COPY ZACPYSRC,PSSR_ILE
 
     **  Note: if non-standard processing required, use the PSSR_ILENE
     **  subroutine
      ****************************************************************
      /EJECT
      ****************************************************************
**  CPY@
(c) Finastra International Limited 2006
