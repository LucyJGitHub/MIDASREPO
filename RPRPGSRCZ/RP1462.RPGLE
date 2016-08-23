     H DEBUG
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas RP PB Security Details             - take on')   *
      *****************************************************************
      *                                                               *
      *  Private Banking Module                                       *
      *                                                               *
      *  RP1462 - Security Details take on.                           *
      *                                                               *
      *  Function:    This module updates Security Details            *
      *            Replication Indicator field so that record would   *
      *            be processed by Meridian Replication functions,    *
      *            for take on purpose.                               *
      *                                                               *
      *  Component of: RPC1462 - Security Details take on.            *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      *  Last Amend No. CRE073             Date 06Dec10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. CSD031             Date 10Apr06               *
      *                 CSD027             Date 09Dec05               *
      *                 CSE075             Date 17Nov05               *
      *                 CSE071             Date 19Jul05               *
      *                 CAS006             Date 21Jan03               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *                 CSD006             Date 12Jan01               *
      *                 CPB002  *CREATE    Date 01Jun99               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CRE073 - Interest Rate Rounding (Recompile)                  *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CSE075 - US Enhanced Treasury Upgrade to MidasPlus           *
      *           (Recompile)                                         *
      *  CSE071 - Multiple Holidays Re Securities (recompile)         *
      *  CAS006 - Hedge Accounting Phase B (Recompile)                *
      *  CSD006 - Recompiled over changed SECTYD.                     *
      *  CPB002 - Meridian DBA Middleware Replication Customization.  *
      *           Midas/TOF interface.                                *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
      **  SE Security Details.
     FSECTY     UF   E           K Disk
     F                                     Infsr(*Pssr)
     F                                     Commit
 
      **  PB Security Details take on report.
     FRP1462P1  O    E             Printer Infds(Spool1)
     F                                     Infsr(*Pssr)
     F                                     Usropn
 
      **  PB Security Details take on audit report.
     FRP1462AU  O    E             PRINTER Infds(SpoolU)
     F                                     Infsr(*Pssr)
     F                                     Usropn
      /Eject
      *****************************************************************
      *                                                               *
      *          F U N C T I O N   O F   I N D I C A T O R S          *
      *          -------------------------------------------          *
      *                                                               *
      *  70  -  Redisplay screen.                                     *
      *                                                               *
      *  81  -  End of file SECTY.                                    *
      *                                                               *
      *  98  -  Date format MMDDYY.                                   *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *                  *************************                    *
      *                  ** INDICATORS NOT USED **                    *
      *                  *************************                    *
      *                                                               *
      *       ***************************************************     *
      *       * 01   02   03   04   05   06   07   08   09   10 *     *
      *       * 11   12   13   14   15   16   17   18   19   20 *     *
      *       * 21   22   23   24   25   26   27   28   29   30 *     *
      *       * 31   32   33   34   35   36   37   38   39   40 *     *
      *       * 41   42   43   44   45   46   47   48   49   50 *     *
      *       * 51   52   53   54   55   56   57   58   59   60 *     *
      *       * 61   62   63   64   65   66   67   68   69   xx *     *
      *       * 71   72   73   74   75   76   77   78   79   80 *     *
      *       * xx   82   83   84   85   86   87   88   89   90 *     *
      *       * 91   92   93   94   95   96   97   xx   99      *     *
      *       ***************************************************     *
      *                                                               *
      *****************************************************************
      /Space 3
      *****************************************************************
      *                                                               *
      *                S U B R O U T I N E   I N D E X                *
      *                -------------------------------                *
      *                                                               *
      *  #Report - Subroutine to print details of processed record.   *
      *  #Rcfp1  - Subroutine to register the P1 Printer File via RCF *
      *  #Rcfau  - Subroutine to register the AU Printer File via RCF *
      *  #Audit  - Subroutine to Output Audit report.                 *
      *  #Init   - Initialization subroutine.                         *
      *  *Pssr   - Program exception error routine                    *
      *  *inzsr  - Program Initialization routine.                    *
      *                                                               *
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes all the defined fields in the
      ** Program Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
      **--------------------------------------------------------------------------------------------
 
      ** +--------------------------------------+
      ** ¦ End of automatically included D-specs¦
      ** ¦ =====================================¦
      ** +--------------------------------------+
 
      /Eject
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ Manually included D-specs            ¦
      ** ¦ =========================            ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
      **  Array containing Copyright statement.
     D Cpy@            S             80    Dim(1) Ctdata Perrcd(1)
 
      **  Array used to align all amounts on decimal point.
     D ARR_Amount      S              1    Dim(25)
 
      **  File Information Data Structure for printer file RP1462P1.
     D Spool1          DS
     D  Sfile1                83     92
     D  Sfnum1               123    124B 0
     D  Oflln1               188    189B 0
     D  Prtln1               367    368B 0
 
      **  File Information Data Structure for printer file RP1462AU.
     D Spoolu          DS
     D  Sfileu                83     92
     D  Sfnumu               123    124B 0
 
      **  External Data structure for Local data area (database error details).
     D LDA           E DS           256    Extname(LDA) Dtaara(LDA)
      ** The following fields are defined in the external file:
      **                                    134 141 DBFile
      **                                    142 170 DBKey
      **                                    171 180 DBPgm
      **                                    181 1830DBase
      **                                    184 193 DBMod
      **                                    194 203 DBProc
 
      **  Customer Selection Data Area.
     D RPCust        E DS                  Extname(RPCUST) DTAARA(RPCUST)
 
      **  External data structure for Bank Details.
     D Sdbank        E DS                  Extname(SDBANKPD)
 
      **  External data structure for Currency Details.
     D Sdcurr        E DS                  Extname(SDCURRPD)
 
      **  Data structure for access programs, long data structure.
     D Dssdy         E DS                  Extname(DSSDY)
 
      **  Data structure for access programs, short data structure.
     D Dsfdy         E DS                  Extname(DSFDY)
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** --------- Start of fields used by access programs ----------**
      **  Return code.
     D P_RtCd          S              7A
      **  Option.
     D P_Optn          S              7A
      **  Currency.
     D P_Curr          S              3A
      ** ---------- End of fields used by access programs -----------**
 
      **  True and False can be used for indicators being on or off.
     D True            C                   *On
     D False           C                   *Off
 
      **  Fields used to check that sufficient lines remain for the
      **  printer file record format.
     D Difln1          S              2  0
     D Rqdln1          S              2  0
 
      **  Work Field used to open P1 printer file only once.
     D W_OpenP1        S              1A
 
      **  Work Field used to change value of field SECTYDF/REPI.
     D W_REPI          S              1  0
 
      **  Work Field used to produce only one dump.
     D W_RunBefore     S              1A
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
 
      /EJECT
      *****************************************************************
     C     Start         Tag
 
      ** Note: the above tag is only there to force the first comments in
      ** the C-specs to appear after the D- or I-specs in compiled listings.
 
      *****************************************************************
      *                                                               *
      *                  M A I N  P R O C E S S I N G                 *
      **   +------------------------------------------------------+   *
      **   ¦                                                      ¦   *
      **   ¦ Initial processing is performed automatically: the   ¦   *
      **   ¦ *inzsr is executed at program activation.            ¦   *
      **   ¦                                                      ¦   *
      **   +------------------------------------------------------+   *
      *                                                               *
      *****************************************************************
 
      **  Perform initialization subroutine as program remains in memory.
     C                   Exsr      #Init
 
      **  Read first Security.
     C                   Read      SECTY                                  81
 
      **  Do while Security to process.
     C     *in81         Doweq     False                                        Begin Do_W_N81
 
      **  Process only live Securities.
     C     RECI          Ifeq      'D'                                          Begin RECI
 
      **  Update Replication Indicator field.
     C                   Testn                   REPI                 77
 
      **  If Replication Indicator is numeric.
     C     *in77         Ifeq      True                                         Begin *in77
     C                   Move      REPI          W_REPI
     C                   Add       1             W_REPI
 
      **  If Replication Indicator is not numeric.
     C                   Else                                                   Else *in77
     C                   Eval      W_REPI = 1
 
     C                   Endif                                                  End *in77
     C                   Move      W_REPI        REPI
 
      **  Update Security Details file record.
     C                   Update    SECTYDF
 
      **  Print Security Details informations on report.
     C                   Exsr      #Report
 
     C                   Endif                                                  End RECI
 
      **  Read next Security Details record.
     C                   Read      SECTY                                  81
 
     C                   Enddo                                                  End Do_W_N81
 
      **  Commit.
     C                   COMMIT
 
      **  If at least one line has been printed.
     C     RCOUNT        Ifgt      0                                            Begin RCOUNT
 
      **  Check that sufficient lines remain for the Format. If not,
      **  write out the Main Headings on a new page.
     C                   Eval      Rqdln1 = 2
     C                   Eval      Difln1 = Oflln1 - Prtln1
     C     Difln1        Ifle      Rqdln1                                       Begin Difln1
 
     C                   Write     HEADP1
 
     C                   Endif                                                  End Difln1
 
      **  Write out Trailer Format.
     C                   Write     ENDPAG1
      **  Check that sufficient lines remain for the Format. If not,
      **  write out the Main Headings on a new page.
     C                   Eval      Rqdln1 = 4
     C                   Eval      Difln1 = Oflln1 - Prtln1
     C     Difln1        Ifle      Rqdln1                                       Begin Difln1
 
     C                   Write     HEADP1
 
     C                   Endif                                                  End Difln1
 
     C                   Write     TRAILP1
 
      **  Close Security Details take on Report printer file.
     C                   Close     RP1462P1
 
     C                   Endif                                                  End RCOUNT
 
      **  Print Audit Report.
     C                   Exsr      #Audit
 
      **  End Program and Return.
     C                   Return
 
      /Eject
      *****************************************************************
      /Title SR/#Report
      *****************************************************************
      *                                                               *
      *  #Report - Subroutine to print details of processed record.   *
      *                                                               *
      *  Called By: Main processing                                   *
      *                                                               *
      *  Calls:     None                                              *
      *                                                               *
      *****************************************************************
 
     C     #Report       Begsr                                                  ** #Report SR **
 
      **  Insure Audit Report Spool File was recorded by RCF.
     C     W_OpenP1      Ifeq      *blank                                       Begin W_OpenP1
     C                   Eval      W_OpenP1 = 'Y'
     C                   Open      RP1462P1
     C                   Exsr      #RCFP1
 
      **  Force header format printing.
     C                   Eval      Prtln1 =  Oflln1
 
     C                   Endif                                                  End W_OpenP1
 
      **  Set up report printer file fields.
     C                   Eval      P1SESN = SESN                                Security shortname
     C                   Eval      P1NMCY = NMCY                                Nominal Currency
     C                   Eval      P1SMCC = SMCC                                Market Center
 
      **  Format Maturity Date.
     C                   Callb     'ZDATE2'
     C                   Parm      MATY          ZDayno            5 0          I:Value date
     C                   Parm      BJDFIN        Zdfin             1            I:Date format ind.
     C                   Parm                    ZDate             6 0          O:Value date
     C                   Parm                    Zadate            7            O:Date DDMMMYY
 
     C                   Eval      P1MATY = Zadate                              Maturity date
 
      **  Check that sufficient lines remain for the Format. If not,
      **  write out the Main Headings on a new page.
     C                   Eval      Rqdln1 = 2
     C                   Eval      Difln1 = Oflln1 - Prtln1
     C     Difln1        Ifle      Rqdln1                                       Begin Difln1
 
      **  If end of page, print relevant record format.
     C     RCOUNT        Ifgt      0                                            Begin RCOUNT
     C                   Write     ENDPAG1
 
     C                   Endif                                                  End RCOUNT
 
     C                   Write     HEADP1
 
     C                   Endif                                                  End Difln1
 
      ** Write record details.
     C                   Write     DETAIL1
     C                   Eval      RCOUNT = RCOUNT + 1
 
     C                   Endsr
 
      /Eject
      *****************************************************************
      /Title SR/#Rcfp1
      *****************************************************************
      *                                                               *
      *  #Rcfp1  - Subroutine to register the P1 Printer File via RCF *
      *                                                               *
      *  Called by: Main processing                                   *
      *                                                               *
      *  Calls:     pgm ZSFILE                                        *
      *                                                               *
      *****************************************************************
 
     C     #Rcfp1        Begsr                                                  ** #Rcfp1 SR **
 
      **  Ensure Report Spool File recorded by RCF.
 
     C                   Eval      Zsnum1 = Sfnum1
     C                   Move      Sfnum1        Zsnum1
 
     C                   Call      'ZSFILE'
     C                   Parm      *Blanks       Seq               5
     C                   Parm                    Senty             3
     C                   Parm                    Sfile1
     C                   Parm                    Zsnum1            6 0
     C                   Parm                    Zserr             1
 
      **  If any Error occurred during ZSFILE processing, then return to the
      **  Calling Program.
     C     Zserr         Ifeq      'Y'                                          Begin Zserr
     C     *lock         In        RPCust
     C                   Eval      CSRetnCode = 'ZSRP1462P1'
     C                   Out       RPCust
     C                   Eval      *inu7 = True
     C                   Eval      *inu8 = True
     C                   Eval      *inlr = True
     C                   Return
 
     C                   Endif                                                  End Zserr
 
     C                   Endsr
 
      /Eject
      *****************************************************************
      /Title SR/#Rcfau
      *****************************************************************
      *                                                               *
      *  #Rcfau  - Subroutine to register the AU Printer File via RCF *
      *                                                               *
      *  Called by: #Audit                                            *
      *                                                               *
      *  Calls:     ZSFILE                                            *
      *                                                               *
      *****************************************************************
 
     C     #Rcfau        Begsr                                                  ** #Rcfau SR **
 
      **  Ensure Audit Spool File recorded by RCF.
     C                   move      Sfnumu        Zsnumu
 
     C                   Call      'ZSFILE'
     C                   Parm      *Blanks       Seq
     C                   Parm      *Blanks       Senty
     C                   Parm                    Sfileu
     C                   Parm                    Zsnumu            6 0
     C                   Parm      *Blank        Zserr
 
      **  If Error occurs during ZSFILE processing, then return to the
      **  Calling Program.
     C     Zserr         Ifeq      'Y'                                          Begin Zserr
     C     *lock         In        RPCust
     C                   Eval      CSRetnCode = 'ZSRP1462AU'
     C                   Out       RPCust
     C                   Eval      *inu7 = True
     C                   Eval      *inu8 = True
     C                   Eval      *inlr = True
     C                   Return
 
     C                   Endif                                                  End Zserr
 
     C                   Endsr
 
      /Eject
      *****************************************************************
      /Title SR/#Audit
      *****************************************************************
      *                                                               *
      *  #Audit - Subroutine to output Audit report.                  *
      *                                                               *
      *  Called By: Main Processing                                   *
      *                                                               *
      *  Calls:     None                                              *
      *                                                               *
      *****************************************************************
 
     C     #Audit        Begsr                                                  ** #Audit SR **
 
      **  Open Audit Report printer file.
     C                   Open      RP1462AU                             99
 
      **  Ensure Audit Report Spool File Recorded by RCF.
     C                   Exsr      #Rcfau
 
      **  Output Report Header and File Controls.
     C                   Write     HEADAU
     C                   Write     CONTROL
 
      **  If there is a DB Error, output the DB Error Information.
     C     *inu7         Ifeq      *on                                          Begin *inu7
     C                   Write     DBERROR
 
     C                   Else                                                   Else *inu7
 
      **  Or, if no records read, output "No Details" message.
     C     RCOUNT        Ifeq      0                                            Begin RCOUNT
     C                   Write     NODTLS
 
     C                   Endif                                                  End RCOUNT
 
     C                   Endif                                                  End *inu7
 
      **  Close Audit Report printer file.
     C                   Close     RP1462AU
 
     C                   Endsr
 
      /Eject
      *****************************************************************
      /Title SR/#Init
      *****************************************************************
      *                                                               *
      *  *Init - Initialization subroutine.                           *
      *                                                               *
      *  Called By: Main processing                                   *
      *                                                               *
      *  Calls:     None                                              *
      *                                                               *
      *****************************************************************
 
     C     #Init         Begsr                                                  ** #Init SR **
 
      **  Reset work fields.
     C                   Reset                   W_OpenP1
     C                   Reset                   RCOUNT
 
      **  Open Audit Report printer file.
     C                   Open      RP1462AU                             99
 
     C                   Endsr
      /Eject
      *****************************************************************
      /Title SR/*Pssr
      *****************************************************************
      *                                                               *
      * *Pssr  - Program exception error routine                      *
      *          Called automatically if a program error occurs,      *
      *          or directly by the program code using EXSR.          *
      *          This subroutine DUMPs the program just once.         *
      *                                                               *
      * Called by: (**calling routines**)                             *
      *                                                               *
      * Calls:     None                                               *
      *                                                               *
      *****************************************************************
 
     C     *Pssr         Begsr                                                  ** *Pssr SR **
 
     C     W_RunBefore   Ifne      'Y'                                          Begin W_RunBefore
     C                   Eval      W_RunBefore = 'Y'
 
     C                   Eval      *inu7 = True
     C                   Eval      *inu8 = True
 
     C                   Dump
     C                   Callb     'DBERRCTL'
 
      **  Ouput Audit Report.
     C                   Exsr      #Audit
 
     C                   Endif                                                  End W_RunBefore
 
     C                   Eval      *inlr = True
     C                   Return
 
     C                   Endsr
 
      /Eject
      *****************************************************************
      /Title SR/*Inzsr
      *****************************************************************
      *                                                               *
      *  *Inzsr  - Program Initialization routine.                    *
      *                                                               *
      *  Called By: Implicitly on program activation.                 *
      *                                                               *
      *  Calls:     None                                              *
      *                                                               *
      *****************************************************************
 
     C     *Inzsr        Begsr                                                  ** *Inzsr SR **
 
      **  Access Bank details by using access program.
     C                   Call      'AOBANKR0'
     C                   Parm      *blanks       P_Rtcd
     C                   Parm      '*FIRST '     P_optn
     C     Sdbank        Parm      Sdbank        Dssdy
 
      **  If Bank details do not exist, handle database error.
     C     P_Rtcd        Ifne      *blanks                                      Begin P_Rtcd
     C     *lock         In        Lda
     C                   Eval      Dbpgm  = PSProcName
     C                   Eval      Dbfile = 'SDBANKPD'                          ***************
     C                   Eval      Dbase  = 01                                  * Db Error 01 *
     C                   Eval      Dbkey  = '*first'                            ***************
     C                   Out       LDA
     C                   Exsr      *Pssr
 
     C                   Endif                                                  End  P_Rtcd
 
     C                   Endsr
      /Eject
      *****************************************************************
**Ctdata Cpy@
(c) Misys International Banking Systems Ltd. 2001
