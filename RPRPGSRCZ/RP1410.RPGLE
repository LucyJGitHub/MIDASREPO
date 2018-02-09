     H DEBUG
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas RP PB RE Interests & charges  - COB changes')    *
      *****************************************************************
      *                                                               *
      *  Private Banking Module                                       *
      *                                                               *
      *  RP1410 - Retail Interests and Charges - COB Changes -        *
      *               Reset/Reports.                                  *
      *                                                               *
      *  Function:     This program resets Retail Interests & Charges *
      *             Replication Indicator field for records that have *
      *             been changed during previous COB and data of      *
      *             which have been passed to remote systems by       *
      *             change the Replication field to 'C' (like COB).   *
      *                Basic informations of records, that have been  *
      *             changed during current COB, are printed on report *
      *                These two functions are mutually exclusive and *
      *             conditionned by external indicator U1.            *
      *                                                               *
      *  (phase(s)) Close of Business.                                *
      *                                                               *
      *  Component of: RP1410 - Retail Interests/Charges - COB Changes*
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CER049             Date 06Dec10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD031             Date 10Apr06               *
      *                 CSD027             Date 09Dec05               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *                 CPB002   *CREATE   Date 01Jun99               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CER049 - Stamp Tax (Recompile)                               *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CPB002 - Meridian DBA Middleware Replication Customization.  *
      *           Midas/TOF interface.                                *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
      **  Retail Interests and Charges.
     FREIACD    UF   E           K Disk
     F                                     Infsr(*Pssr)
 
      **  PB Retail Int. & Chgs. COB changes replication report.
     FRP1410P1  O    E             Printer Infds(Spool1)
     F                                     Infsr(*Pssr)
     F                                     Usropn
 
      **  PB Retail Int. & Chgs. COB changes replication audit report.
     FRP1410AU  O    E             PRINTER Infds(SpoolU)
     F                                     Infsr(*Pssr)
      /Eject
      *****************************************************************
      *                                                               *
      *          F U N C T I O N   O F   I N D I C A T O R S          *
      *          -------------------------------------------          *
      *                                                               *
      *  U1  -  Print on report / reset flag                          *
      *                                                               *
      *  81  -  End of file REIACD.                                   *
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
      *       * 61   62   63   64   65   66   67   68   69   70 *     *
      *       * 71   72   73   74   75   76   77   78   79   80 *     *
      *       * xx   82   83   84   85   86   87   88   89   90 *     *
      *       * 91   92   93   94   95   96   97   98   99      *     *
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
 
      **  File Information Data Structure for printer file RP1410P1.
     D Spool1          DS
     D  Sfile1                83     92
     D  Sfnum1               123    124B 0
     D  Oflln1               188    189B 0
     D  Prtln1               367    368B 0
 
      **  File Information Data Structure for printer file RP1410AU.
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
 
      **  External data structure for Bank Details.
     D Sdbank        E DS                  Extname(SDBANKPD)
 
      **  External data structure for Currency Details.
     D Sdcurr        E DS                  Extname(SDCURRPD)
 
      **  Data structure for access programs, long data structure.
     D Dssdy         E DS                  Extname(DSSDY)
 
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
 
      **  Work Field used to produce only one dump.
     D W_RunBefore     S              1A
 
      **  Work Field used to open P1 printer file only once.
     D W_OpenP1        S              1A
 
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
 
      **  Read first Retail Interests and Charges.
     C                   Read      REIACD                                 81
 
      **  Do while Retail Int. & Chgs. to be processed.
     C     *in81         Doweq     False                                        Begin Do_W_N81
 
      **  If Replication field has to be reset.
     C     *inu1         Ifeq      False                                        Begin *inu1
 
      **  Update Replication Indicator field.
     C                   Eval      REPI = *blank
 
      **  Update Retail Int. & Chgs record.
     C                   Update    REIACDF
 
      **  If printing of reports required.
     C                   Else                                                   Else *inu1
 
      **  Update Replication Indicator field.
     C                   Eval      REPI = 'C'
 
      **  Update Retail Int. & Chgs record.
     C                   Update    REIACDF
 
      **  Print Retail Int. & Chgs. informations on report.
     C                   Exsr      #Report
 
     C                   Endif                                                  End *inu1
     C                   Eval      RCOUNT = RCOUNT + 1
 
      **  Read next Retail Int. & Chgs.
     C                   Read      REIACD                                 81
 
     C                   Enddo                                                  End Do_W_N81
 
      **  If printing of reports required.
     C     *inu1         Ifeq      True                                         Begin *inu1
 
      **  If at least one line has been printed.
     C     RCOUNT        Ifgt      0                                            Begin RCOUNT
     C                   Write     ENDPAG1
 
      **  Check that sufficient lines remain for the Format. If not,
      **  write out the Main Headings on a new page.
     C                   Eval      Rqdln1 = 4
     C                   Eval      Difln1 = Oflln1 - Prtln1
     C     Difln1        Ifle      Rqdln1                                       Begin Difln1
     C                   Write     HEADP1
 
     C                   Endif                                                  End Difln1
 
      **  Write out Trailer Format.
     C                   Write     TRAILP1
 
      **  Close Retail Ints. & Chgs COB changes Report printer file.
     C                   Close     RP1410P1
 
     C                   Endif                                                  End RCOUNT
 
     C                   Endif                                                  End *inu1
 
      **  Print Audit Report.
     C                   Exsr      #Audit
 
      **  End Program and Return.
     C                   Eval      *inlr = True
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
      *
     C     #Report       Begsr                                                  ** #Report SR **
 
      **  Insure Audit Report Spool File was recorded by RCF.
     C     W_OpenP1      Ifeq      *blank                                       Begin W_OpenP1
     C                   Eval      W_OpenP1 = 'Y'
     C                   Open      RP1410P1
     C                   Exsr      #RCFP1
 
      **  Force header format printing.
     C                   Eval      Prtln1 =  Oflln1
 
     C                   Endif                                                  End W_OpenP1
 
      **  Set up report printer file fields.
     C                   Eval      P1BRCA = BRCA                                Branch code
     C                   Move      CNUM          P1CNUM                         Customer number
     C                   Eval      P1CCY  = CCY                                 Currency code
     C                   Move      ACOD          P1ACOD                         Account code
     C                   Move      ACSQ          P1ACSQ                         Account sequence
 
      **  Set up Debit Interests Calculation Type.
     C                   Move      *blanks       P1DICT
     C     DICT          Ifne      *zeros                                       Begin DICT
     C                   Move      DICT          P1DICT                         Dr. Int. Calc. Type
 
     C                   Endif                                                  End DICT
 
      **  Set up Debit Interests Calculation Sub Type.
     C                   Move      *blanks       P1DCST
     C     DCST          Ifne      *zeros                                       Begin DCST
     C                   Move      DCST          P1DCST                         Dr. Int. Calc. Sub T
 
     C                   Endif                                                  End DCST
 
     C                   Eval      P1DACP = DACP                                A/C to post Dr. Int.
 
      **  Set up Credit Interests Calculation Type.
     C                   Move      *blanks       P1CICT
     C     CICT          Ifne      *zeros                                       Begin CICT
     C                   Move      CICT          P1CICT                         Cr. Int. Calc. Type
 
     C                   Endif                                                  End CICT
 
      **  Set up Credit Interests Calculation Sub Type.
     C                   Move      *blanks       P1CCST
     C     CCST          Ifne      *zeros                                       Begin CCST
     C                   Move      CCST          P1CCST                         Cr. Int. Calc. Sub T
 
     C                   Endif                                                  End CCST
 
     C                   Eval      P1CACP = CACP                                A/C to post Cr. Int.
 
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
      *
     C                   Endsr
      *
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
      *
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
     C                   Eval      *inu7 = True
     C                   Eval      *inu8 = True
     C                   Eval      *inlr = True
     C                   Return
      *
     C                   Endif                                                  End Zserr
      *
     C                   Endsr
      *
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
      *
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
     C                   Eval      *inu7 = True
     C                   Eval      *inu8 = True
     C                   Eval      *inlr = True
     C                   Return
      *
     C                   Endif                                                  End Zserr
      *
     C                   Endsr
      *
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
      *
     C     #Audit        Begsr                                                  ** #Audit SR **
 
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
 
     C                   Endsr
      *
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
      *
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
      *
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
      *
     C     *Inzsr        Begsr                                                  ** *Inzsr SR **
 
      **  Access Bank details by using access program.
     C                   Callb     'AOBANKR0'
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
 
      **  Set on indicator to print appropriate audit report header.
     C     *inu1         Ifeq      True                                         Begin *inu1
     C                   Eval      *in30 = True
 
     C                   Endif                                                  End *inu1
 
     C                   Endsr
     C/Eject
      *****************************************************************
**Ctdata Cpy@
(c) Finastra International Limited 2001
