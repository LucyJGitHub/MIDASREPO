     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2006')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('DL Exchange Rate Expected Report')
      *****************************************************************
      *                                                               *
      *  Midas - Dealing Module                                       *
      *                                                               *
      *  DL000060 - Exchange Rate Expected Audit Report               *
      *                                                               *
      *  Function: This report program will list all cross currency   *
      *            interest rate swap deals that are within 5 working *
      *            days of their interest payment date and that are   *
      *            also flagged for automatic principal revaluation.  *
      *                                                               *
      *  Called By: DLC000060 - DL Exchange Rate Expected Report      *
      *                                                               *
      *  (c) Finastra International Limited 2006                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. CIR014  *CREATE    Date 11May06               *
      *                 XNNNNN             Date DDMmmYY               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CIR014 - Mark to Market Cross-currency Interest Rate Swaps   *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *    01         End of file for DLDGRXJ0                        *
      *    37         Multibranching ON                               *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      *  SrInit    - Initialisation routine                           *
      * *PSSR      - Error processing                                 *
      *  SrProc    - Detail Processing routine                        *
      *  Validate  - Validation routine                               *
      *  Print     - Print records                                    *
      *  SetFields - Set values for fields routine                    *
      *  SrFreq    - Get Frequency Value                              *
      *  Audit     - Audit report routine                             *
      *  SrTerm    - Termination routine                              *
      *  FmtDate   - Subroutine for ZDATE2                            *
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
 
      ** Midas DL Deals file
     FDLDGRXL1  IF   E           K Disk    Infsr(*PSSR)
 
      ** Midas DL Deals Extension File
     FDLDEALL5  IF   E           K Disk    Infsr(*PSSR)
     F                                     IGNORE(DLDLDBD0)
     F                                     IGNORE(DLDLDCD0)
 
      ** Exchange Rate Expected Audit Report
     FDL000060AUO    E             Printer Infds(SpoolU)
 
      ** Exchange Rate Expected Detail Report
     FDL000060P1O    E             Printer Usropn
     F                                     Infds(Spool1)
 
 
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      **
      **------------------------------------------------------------------+
      ** The following /COPY line includes (among others) the LDA layout  ¦
      ** and the copyright array definition:                              ¦
     D/COPY ZACPYSRC,STD_D_SPEC                                           ¦
      **------------------------------------------------------------------+
 
      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ D-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
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
 
      ** File Information Data Structure for DL000060AU
     D SpoolU          DS
     D  SFileU                83     92
     D  SFNumU               123    124B 0
 
      ** File Information Data Structure for DL000060P1
     D Spool1          DS
     D  Oflln1               188    189B 0
     D  Prtln1               367    368B 0
 
      ** Data structure for Installation control details
     D Rundat        E DS                  Extname(Rundat)
 
      ** Data structure for Bank details
     D Sdbank        E DS                  Extname(Sdbankpd)
 
      ** Data structure for Branch details
     D Sdbrch        E DS                  Extname(Sdbrchpd)
 
      ** Data structure for Currency details
     D Sdcurr        E DS                  Extname(Sdcurrpd)
 
      ** Short dummy data structure for access programs
     D Dsfdy         E DS                  Extname(Dsfdy)
 
      ** Long dummy data structure for access programs
     D Dssdy         E DS                  Extname(Dssdy)
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
     D WRcdAU          S              1A
     D WOpenP1         S              1A
     D Rqdln1          S              3  0
     D Difln1          S              3  0
     D WBranch         S              3A
     D OTTCY           S              3A
     D OTCCY           S              3A
     D LOCTN           S              3A
     D DEALN           S              6A
     D FREQ1           S              1A
     D FREQ11          S             11A
     D NIPD            S              5  0
 
     D PRtcd           S              7A
     D POptn           S              7A
     D Parm3A          S              3A
     D Parm2N          S              2  0
     D Parm5N          S              5  0
     D PKSts           S              7A
     D ZDayNo          S              5  0
     D ZDate           S              6  0
     D ZADate          S              7A
     D ZFld15          S             15  0
     D ZECode          S              1A
     D ZOut21          S             21A
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
 
      *****************************************************************
      * MAIN PROCEDURE                                                *
      *****************************************************************
 
     C                   Exsr      SrInit
     C                   Exsr      SrProc
     C                   Exsr      SrTerm
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrProc - Record processing routine                           *
      *           Select records that are within 5 working days of    *
      *           their interest payment date                         *
      *                                                               *
      *****************************************************************
 
     C     SrProc        Begsr
 
     C     *Loval        SETLL     DLDGRXL1
     C                   Read      DEALSDGF                               01
 
     C                   DOW       *IN01 = *Off
 
     C                   Move      DLNO          DEALN
     C     DEALN         Chain     DLDLDGD0
 
     C                   If        %FOUND(DLDEALL5) And
     C                             F1PRVI <> *Blanks
 
     C                   Exsr      Validate
 
     C                   If        F1PRVI = 'O'
     C                   Eval      NIPD = UNIPD
     C                   Else
     C                   Eval      NIPD = TNIPD
     C                   EndIf
 
     C                   If        NIPD >= AGRDNB And
     C                             NIPD <= Parm5N
     C                   Exsr      Print
     C                   Endif
 
     C                   Endif
 
     C                   Read      DEALSDGF                               01
     C                   Enddo
 
      ** If no records were printed, write No Details to Report
 
     C                   If        WOpenP1 = 'Y'
     C                   Write     TrailP1
     C                   Write     TrailP2
     C                   Close     DL000060P1
     C                   Else
     C                   Write     HeadAU
     C                   Write     NoDtls
     C                   Endif
 
     C                   Endsr
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  Validate - Validation routine                                *
      *                                                               *
      *****************************************************************
 
     C     Validate      Begsr
 
      ** To Calculate Working Days Forward
 
     C                   If        F1PRVI = 'O'
     C                   Eval      OTCCY = UCUCY
     C                   Else
     C                   Eval      OTCCY = TCUCY
     C                   End
 
     C                   Call      'ZFWDT'
     C                   Parm                    AGRDNB
     C                   Parm      5             Parm2N
     C                   Parm      *Zero         Parm5N
     C                   Parm                    OTCCY
     C                   Parm      *Blanks       LOCTN
 
     C                   Endsr
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  Print - Print the record if interest next payment date is    *
      *          less than the rundate                                *
      *                                                               *
      *****************************************************************
 
     C     Print         Begsr
 
      ** Report break for Branch
 
     C                   If        WBranch <> BRCA
     C                             And *IN37 = *On
 
     C                   If        WOpenP1 = 'Y'
     C                   Write     TrailP1
     C                   Else
     C                   Eval      WOpenP1 = 'Y'
     C                   Open      DL000060P1
     C                   Endif
 
     C                   Eval      RBRCD = BRCA
     C                   Call      'AOBRCHR1'
     C                   Parm      *Blanks       PRtcd
     C                   Parm      '*KEY   '     POptn
     C                   Parm      BRCA          Parm3A
     C     Sdbrch        Parm      Sdbrch        Dssdy
 
     C                   If        PRtcd <> *Blanks
     C     *LOCK         IN        LDA
     C                   Eval      DBFile = 'SDBRCHPD'
     C                   Eval      DBKey = Parm3A
     C                   Eval      DBPgm = 'DL000060  '
     C                   Eval      DBase = 006
     C                   OUT       LDA
     C                   Exsr      Audit
     C                   Endif
 
     C                   Eval      RBRNM = A8BRNM
     C                   Write     HeadP1
     C                   Eval      WBranch = BRCA
 
      ** No report break for Branch
 
     C                   Else
     C                   Z-Add     1             Rqdln1
     C     Oflln1        Sub       Prtln1        Difln1
     C                   If        Difln1 <= Rqdln1
     C                   Write     HeadP1
     C                   Endif
     C                   Endif
 
     C                   Exsr      SetFields
     C                   Write     Detail
 
     C                   Endsr
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SetFields - Set the value of other report fields             *
      *                                                               *
      *****************************************************************
 
     C     SetFields     Begsr
 
     C                   Eval      RDLNO = DLNO
     C                   Eval      RDLTP = DTYP
     C                   Eval      RDLST = DLST
     C                   Eval      RPRNI = F1PRVI
 
     C                   Eval      ZDayNo = VDAT
     C                   Exsr      FmtDate
     C                   Eval      RVALD = ZADate
     C                   Eval      ZDayNo = MDAT
     C                   Exsr      FmtDate
     C                   Eval      RMATD = ZADate
 
     C                   If        F1PRVI = 'O'
     C                   Eval      ROTCY = UCUCY
     C                   Eval      RDAY  = UIPFD
     C                   Eval      ZFLD15 = UPAMT
 
     C                   Eval      FREQ1 = UIPFR
     C                   Exsr      SrFreq
     C                   Eval      RFREQ = FREQ11
 
     C                   Eval      RDAYB = UNIPD - AGRDNB
     C                   Eval      ZDayNo = UNIPD
     C                   Exsr      FmtDate
     C                   Eval      RNXTD = ZADate
 
     C                   Else
     C                   Eval      ROTCY = TCUCY
     C                   Eval      RDAY  = TIPFD
     C                   Eval      ZFLD15 = TPAMT
 
     C                   Eval      FREQ1 = TIPFR
     C                   Exsr      SrFreq
     C                   Eval      RFREQ = FREQ11
 
     C                   Eval      RDAYB = TNIPD - AGRDNB
     C                   Eval      ZDayNo = TNIPD
     C                   Exsr      FmtDate
     C                   Eval      RNXTD = ZADate
     C                   Endif
 
      ** Both buy and sell currencies should be CLS-supported and
      ** effective dates have been reached by value date of the deal
 
     C                   Call      'AOCURRR0'
     C                   Parm      *Blanks       PRtcd
     C                   Parm      '*KEY   '     POptn
     C                   Parm      ROTCY         Parm3A
     C     Sdcurr        Parm      Sdcurr        Dssdy
 
     C                   If        PRtcd <> *Blanks
     C     *LOCK         IN        LDA
     C                   Eval      DBFile = 'SDCURRPD'
     C                   Eval      DBKey = Parm3A
     C                   Eval      DBPgm = 'DL000060  '
     C                   Eval      DBase = 005
     C                   OUT       LDA
     C                   Exsr      Audit
     C                   Endif
 
     ** Format Our/Their Principal Amount
 
     C                   CALL      'ZSEDIT'
     C                   PARM                    ZFLD15           15 0
     C                   PARM      A6NBDP        ZDECS             1 0
     C                   PARM      'J'           ZECODE            1
     C                   PARM      *BLANKS       ZOUT21           21
     C                   MOVE      ZOUT21        RPAMT
 
     C                   Endsr
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrFreq - Get Frequency Value                                 *
      *                                                               *
      *****************************************************************
 
     C     SrFreq        Begsr
 
     C                   Select
     C     Freq1         WhenEq    'M'
     C                   Eval      Freq11 = '  Monthly  '
     C     Freq1         WhenEq    'Q'
     C                   Eval      Freq11 = ' Quarterly '
     C     Freq1         WhenEq    'X'
     C                   Eval      Freq11 = 'Semi-Annual'
     C     Freq1         WhenEq    'Y'
     C                   Eval      Freq11 = '  Yearly   '
     C     Freq1         WhenEq    'M'
     C                   Eval      Freq11 = ' Irregular '
     C     Freq1         WhenEq    'M'
     C                   Eval      Freq11 = 'Cash Pymnts'
     C                   EndSl
 
     C                   Endsr
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  Audit - Print audit report                                   *
      *                                                               *
      *****************************************************************
 
     C     Audit         Begsr
 
     C                   If        WRcdAU <> 'Y'
     C                   Eval      WRcdAU = 'Y'
     C                   Endif
 
     C                   Write     HeadAU
     C                   Write     DBError
     C                   Exsr      *PSSR
 
     C                   Endsr
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrTerm - Termination routine                                 *
      *                                                               *
      *****************************************************************
 
     C     SrTerm        Begsr
 
     C                   Move      *On           *INLR
     C                   Return
 
     C                   Endsr
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  FmtDate - Subroutine for ZDATE2                              *
      *                                                               *
      *****************************************************************
 
     C     FmtDate       Begsr
 
     C                   Call      'ZDATE2'
     C                   Parm                    ZDayNo
     C                   Parm                    BJDFIN
     C                   Parm      *Zero         ZDate
     C                   Parm      *Blanks       ZADate
 
     C                   Endsr
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrInit - Program Initialisation routine                       *
      *                                                               *
      *****************************************************************
 
     C     SrInit        Begsr
 
      ** Entry parameters
 
     C     *Entry        PLIST
     C                   Parm                    PSEQ              5
 
      ** Multibranching indicator
 
     C     *Dtaara       Define                  Rundat
     C                   IN        Rundat
 
     C                   If        AGMBIN = 'Y'
     C                   Move      *On           *IN37
     C                   Endif
 
      ** Access bank details
 
     C                   Call      'AOBANKR0'
     C                   Parm      *Blanks       PRtcd
     C                   Parm      '*FIRST '     POptn
     C     Sdbank        Parm      Sdbank        Dsfdy
 
     C                   If        PRtcd <> *Blanks
     C     *LOCK         IN        LDA
     C                   Eval      DBFile = 'SDBANKPD'
     C                   Eval      DBKey = POptn
     C                   Eval      DBPgm = 'DL000060  '
     C                   Eval      DBase = 001
     C                   OUT       LDA
     C                   Exsr      Audit
     C                   Endif
 
      ** Initialise work fields
 
     C                   Eval      Prtln1 = *Zero
     C                   Eval      WRcdAU = 'N'
     C                   Eval      WOpenP1 = 'N'
     C                   Eval      WBranch = *Blanks
 
     C                   Endsr
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *PSSR  - Program exception error routine                      *
      *                                                               *
      *****************************************************************
 
     C     *PSSR         Begsr
 
     C                   Eval      *INU7 = *On
     C                   Eval      *INU8 = *On
     C                   Eval      *INLR = *On
 
     C                   Close     DL000060AU
     C                   If        WOpenP1 = 'Y'
     C                   Close     DL000060P1
     C                   Endif
 
     C                   Dump
     C                   Return
 
     C                   Endsr
      ********************************************************************
**  CPY@
(c) Finastra International Limited 2001
