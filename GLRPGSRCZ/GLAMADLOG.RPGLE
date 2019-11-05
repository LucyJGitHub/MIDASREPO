     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas GL Accounts Support Log Setup Module')           *
      *****************************************************************
      *                                                               *
      *  Midas - General Ledger Module                                *
      *                                                               *
      *  GLAMADLOG - Accounts Support Log Setup Module                *
      *                                                               *
      *  Function:  This module will convert detail fields of the GL  *
      *             Accounts file into screen format to be used       *
      *             in writing records to the log file.               *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. CSD101             Date 07Dec18               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      *                 CGL165             Date 17Feb15               *
      *                 CSF011A            Date 28Nov11               *
      *                 CER049             Date 06Dec10               *
      *                 CRE073             Date 06Dec10               *
      *                 CER055             Date 06Dec10               *
      *                 CRE075             Date 06Dec10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      *                 CRE015             Date 18Dec09               *
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD027             Date 09Dec05               *
      *                 CAP086             Date 08Jun05               *
      *                 CLE025             Date 20Oct03               *
      * Midas Release 4.01 -------------------------------------------*
      *                 CSC011  *CREATE    Date 18Sep01               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD101 - Password Encryption                                 *
      *  MD046248 - Finastra Rebranding                               *
      *  CGL165 - Dual Withholding Tax (Recompile)                    *
      *  CSF011A - CCR015: Display Order in Confirmation Pages        *
      *            (Recompile)                                        *
      *  CER049 - Stamp Tax (Recompile)                               *
      *  CRE073 - Interest Rate Rounding (Recompile)                  *
      *  CER055 - Penalty Interest on Exceeding Overdraft Limit       *
      *           (Recompile)                                         *
      *  CRE075 - Effective Date for Retail Accounts (Recompile)      *
      *  CRE015 - Retail Term and Notice Accounts                     *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CAP086 - Introduce Auto Authorisation to the API's           *
      *           without it. (Recompile)                             *
      *  CLE025 - Credit Lines (Recompile)                            *
      *  CSC011 - 24x7 Midas Availability                             *
      *                                                               *
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
     FTABTBRE   IF   E             DISK    INFSR(*PSSR)
     F                                     PREFIX(R_)
 
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
 
      **--------------------------------------------------------------+
      ** The following /COPY line includes (among others) the LDA
      ** LDA and the copyright array definition:
     D/COPY ZACPYSRC,STD_D_SPEC
      **--------------------------------------------------------------+
 
      **--------------------------------------------------------------+
      ** The following /COPY line includes all the defined fields in
      ** the Program Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
      **--------------------------------------------------------------+
 
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
 
     D AccnFilFmt    E DS                  EXTNAME(ACCNTAB)
     D                                     PREFIX(AC_)
      ** Midas GL Accounts File
 
     D ExBXFilFmt    E DS                  EXTNAME(ACCNTBXC)
     D                                     PREFIX(BX_)
      ** Midas GL Account details extension
 
     D ExRIFilFmt    E DS                  EXTNAME(REIACD)
     D                                     PREFIX(RI_)
      ** Midas RE Retail Int. and charges detail
 
     D ExCOFilFmt    E DS                  EXTNAME(RECOMD)
     D                                     PREFIX(CO_)
      ** Midas RE Retail Int. and charges detail
 
     D***ExPWFilFmt    E DS                   EXTNAME(REAPWDPD)                               CSD101
     D ExPWFilFmt    E DS                  EXTNAME(GLVAMPWPD)                                 CSD101
     D                                     PREFIX(PW_)
      ** Midas RE Retail Int. and charges detail
 
     D AccScnMast    E DS                  EXTNAME(GLAMADPD)
      ** Midas GL API Account Master Detail definition file
 
     D AccScnDebi    E DS                  EXTNAME(GLAMDIPD)
      ** Midas GL API Acc. Debit Interest/Ov. Definition File
 
     D AccScnCred    E DS                  EXTNAME(GLAMCIPD)
      ** Midas GL API Acc. Credit Int./Chrg. Definition File
 
     D AccScnComm    E DS                  EXTNAME(GLAMCOPD)
      ** Midas GL API Acc. Commission & Ov. Definition File
 
     D AccScnOthe    E DS                  EXTNAME(GLAMODPD)
      ** Midas GL API Account Other Details Definition File
 
     D ExPPFilFmt    E DS                  EXTNAME(REPENAPD)                                  CRE015
     D                                     PREFIX(PR_)                                        CRE015
                                                                                              CRE015
     D AccScnPena    E DS                  EXTNAME(GLAMPPPD)                                  CRE015
      ** Midas GL API Period and Penalty Definition File                                      CRE015
                                                                                              CRE015
     D ExtData       E DS                  EXTNAME(GLAMEXPD)
      ** Midas GL API A/C Maintenance Extra data layout file
 
     D SDMMOD        E DS                  EXTNAME(SDMMODPD)
      ** Midas Module Details
 
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** First DS for access programs, short data structure
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
     D TRANSDTL        S           5800
     D CDE002          S              1
     D DDDACC          S              6
     D DDLINK          S             18
     D DDFAMT          S              8
     D DODRCD          S              6
     D DDPOLC          S              6
     D DDPOLE          S              6
     D DOCRCD          S              6
     D DDCEXA1         S             11
     D DDCEXB1         S             11
     D DDCEXC1         S             11
     D DDCEXD1         S              8
     D DDCEXE1         S              8
     D DDCEXF1         S              8
     D DDCEXG1         S              8
     D DDDRMG1         S             12
     D DDCRMG1         S             12
     D PCommDisp       S              1
     D PRtcd           S              7
     D POptn           S              7
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** Convert file fields into screen format
 
     C                   EXSR      SRPROC
 
     C                   RETURN
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRPROC - Convert file fields into screen format              *
      *                                                               *
      *  Called by: Main                                              *
      *                                                               *
      *  Calls    : GLAMADCVT                                         *
      *                                                               *
      *****************************************************************
 
     C     SRPROC        BEGSR
 
     C                   EVAL      TRANSDTL = *BLANKS
     C                   EVAL      DDACTN = AC_CHTP
 
      ** Call GLAMAD Convert Module
 
     C                   CALLB     'GLAMADCVT'
     C                   PARM                    RetCodeOut
 
      ** Account details in file format
 
     C                   PARM                    AccnFilFmt
     C                   PARM                    ExBXFilFmt
     C                   PARM                    ExRIFilFmt
     C                   PARM                    ExCOFilFmt
     C                   PARM                    ExPWFilFmt
     C                   PARM                    ExPPFilFmt                                   CRE015
 
      ** Commissions
 
     C                   PARM                    PCommDisp
 
      ** CCRM Revenue Analysis
 
     C                   PARM                    CDE002
 
      ** Retail Details
 
     C                   PARM                    R_FACH
     C                   PARM                    R_TSTMC
 
      ** Account details in screen format
 
     C                   PARM                    AccScnMast
     C                   PARM                    AccScnDebi
     C                   PARM                    AccScnCred
     C                   PARM                    AccScnComm
     C                   PARM                    AccScnOthe
     C                   PARM                    AccScnPena                                   CRE015
 
      ** Screen 1 Output
 
     C                   PARM                    DDDACC
     C                   PARM                    DDLINK
     C                   PARM                    DDFAMT
 
      ** Screen 2 Output
 
     C                   PARM                    DODRCD
     C                   PARM                    DDPOLC
     C                   PARM                    DDPOLE
 
      ** Screen 3 Output
 
     C                   PARM                    DOCRCD
 
      ** Screen 4 Output
 
     C                   PARM                    DDCEXA1
     C                   PARM                    DDCEXB1
     C                   PARM                    DDCEXC1
     C                   PARM                    DDCEXD1
     C                   PARM                    DDCEXE1
     C                   PARM                    DDCEXF1
     C                   PARM                    DDCEXG1
     C                   PARM                    DDDRMG1
     C                   PARM                    DDCRMG1
 
     C                   EVAL      TRANSDTL = AccScnMast + AccScnDebi +
     C                                        AccScnCred + AccScnComm +
     C**********                              AccScnOthe + ExtData                            CRE015
     C                                        AccScnOthe + AccScnPena +                       CRE015
     C                                        ExtData                                         CRE015
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *INZSR - Program Initialisation routine                      *
      *                                                               *
      *  Called by: Implicitly on program activation                  *
      *                                                               *
      *  Calls    : None                                              *
      *                                                               *
      *****************************************************************
 
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
 
      ** INPUTS
      ** Return Code
 
     C                   PARM                    RetCodeIn
 
      ** Account in file formats
 
     C                   PARM                    AccnFilFmt
     C                   PARM                    ExBXFilFmt
     C                   PARM                    ExRIFilFmt
     C                   PARM                    ExCOFilFmt
     C                   PARM                    ExPWFilFmt
     C                   PARM                    ExPPFilFmt                                   CRE015
 
      ** CCRM Revenue Analysis
 
     C                   PARM                    CDE002
 
      ** OUTPUT
      ** Transaction Details
 
     C                   PARM                    TRANSDTL
 
      ** Access Module Details
 
     C                   CALLB     'AOMMODR0'
     C                   PARM      *BLANKS       PRtcd
     C                   PARM      '*FIRST '     POptn
     C     SDMMOD        PARM      SDMMOD        DSFDY
 
      ** Database error
 
     C                   IF        PRtcd <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'SDMMODPD'
     C                   EVAL      DBASE = 1
     C                   EVAL      DBKEY = POptn
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   END
 
      ** Access Retail ICD for Commissions
 
     C                   IF        BGNXST='Y' OR BGNYST='Y'
     C     1             SETLL     TABTBRE
     C                   READ      TABTBRE                                80
 
     C                   IF        *IN80 = *ON OR R_RECI <> 'D'
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'TABTBRE'
     C                   EVAL      DBASE = 2
     C                   EVAL      DBKEY = '*FIRST'
     C                   OUT       LDA
     C                   EXSR      *PSSR
 
     C                   ELSE
     C                   IF        R_CDTO='Y' OR R_CHOV='Y' OR R_FXAC='Y'
     C                             OR R_CNDS='Y' OR R_CDRI='Y'
     C                             OR R_CMBL='Y' OR R_CINA='Y'
     C                   EVAL      PCommDisp='Y'
     C                   ELSE
     C                   EVAL      PCommDisp='N'
     C                   ENDIF
     C                   ENDIF
 
     C                   ELSE
     C                   EVAL      PCommDisp='N'
     C                   ENDIF
 
      ** Program, module and procedure names for dbase error processing
      ** ==============================================================
      ** The following /COPY sets these values.
      /COPY ZACPYSRC,DBFIELDS
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      ********************************************************************
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
      ********************************************************************
      /COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
** CPY@
(c) Finastra International Limited 2001
