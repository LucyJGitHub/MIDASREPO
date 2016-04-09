     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2004')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas DL SSI Warning Report')                          *
      *****************************************************************
      *                                                               *
      *  Midas - Dealing Module                                       *
      *                                                               *
      *  DL0950 - Midas DL SSI Warning Report                         *
      *                                                               *
      *  Called By: DLC0950                                           *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2004            *
      *                                                               *
      *  Last Amend No. CGL165             Date 17Feb15               *
      *  Prev Amend No. CDL096             Date 22Sep14               *
      *                 CDL094             Date 11Jun14               *
      *                 CSD095             Date 08Apr14               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD031             Date 10Apr06               *
      *                 CSD027             Date 09Dec05               *
      *                 CDL038             Date 10May05               *
      *                 BUG7234            Date 23May05               *
      *                 BUG7163            Date 16May05               *
      *                 BUG6456            Date 04Apr05               *
      *                 CDL031  *CREATE    Date 01Dec04               *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  CGL165 - Dual Withholding Tax (Recompile)                    *
      *  CDL096 - Business Day Conventions on MM Deals                *
      *           (Recompile)                                         *
      *  CDL094 - Enhance  Receive Settlement Instructions            *
      *           (Recompiled)                                        *
      *  CSD095 - Allow Deal Sub-Type and Branch for MM and FX SSIs   *
      *           (Recompile)                                         *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CDL038 - Extended Deal Sub Type                              *
      *  BUG7234- SSI Warning report not showing Deleted details      *
      *  BUG7163- RCF not sending report to OUTQ                      *
      *  BUG6456- Report DL0950P1 does not display correct details    *
      *  CDL031 - Effective Date on Extended SSI                      *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      *  *INZSR        -  Program Initialisation Routine              *
      *  SRDelete      -  Delete all records flagged for delete       *
      *  *PSSR         -  Delete all records flagged for delete       *
      *                                                               *
      *****************************************************************
      /EJECT
 
      ** SD Extended Settlements
     FSDEXSTPD  IP   E           K Disk    InfSR(*PSSR)
 
      ** SD Extended Settlements                                                             BUG6456
     FSDEXSTL0  IF   E           K Disk    InfSR(*PSSR)                                      BUG6456
     F                                     Prefix(XX:2)                                      BUG6456
                                                                                             BUG6456
      ** All Non Matured Deals
     FDEALSL5   IF   E           K Disk    InfSR(*PSSR)
 
      ** All Non Matured Deals
     FDL0950P1  O    E             Printer InfDs(Spool1)
     F                                     OFLInd(OverFlow)
     F                                     UsrOpn
 
      *****************************************************************
      /EJECT
      *****************************************************************
      **------------------------------------------------------------------------------------------
      ** The following /COPY line includes (among others) the LDA layout
      ** and the copyright array definition:
     D/COPY ZACPYSRC,STD_D_SPEC
      **------------------------------------------------------------------------------------------
 
      **------------------------------------------------------------------------------------------
      ** The following /COPY line includes all the defined fields in the
      ** Program Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
      **------------------------------------------------------------------------------------------
      /EJECT
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
      ** Externally described DS for bank details
     D SDBANK        E DS                  ExtName(SDBANKPD)
 
      *  Customer Details format for access object pgm
     D SDCUST        E DS                  ExtName(SDCUSTPD)
 
     D* Second DS For Access Programs, Long Data Structure
     D DSSDY         E DS                  ExtName(DSSDY)
 
      ** First DS for access programs, short data structure
     D DSFDY         E DS                  ExtName(DSFDY)
 
      **  File Information Data Structure for SE0385P1.
     D Spool1          DS
     D  SFile                 83     92
     D  SFNum                123    124B 0
     D  OFLLn                188    189B 0
     D  PRTLn                367    368B 0
      *
 
      ** +--------------------------------------+
      ** ¦ Variables and Named constants        ¦
      ** ¦ =============================        ¦
      ** +--------------------------------------+
 
     D Deleted         C                   Const('*** DELETED ***')
     D Amended         C                   Const('*** AMENDED ***')
 
     D @RUN            S              1
     D W#TRTY          S                   Like(BYTRTY)                                      BUG6456
 
      ** Define Key Fields
     D*K#CUST*******   S                   Like(CNUM)                                        BUG6456
     D K#CNUM          S                   Like(CNUM)                                        BUG6456
     D K#CUST          S                   Like(BYCUST)                                      BUG6456
     D K#CYCD          S                   Like(CCY)
     D K#TRTY          S                   Like(DTYP)                                        BUG6456
 
      ** Define Pass Parameters
     D PRtCd           S              7A
     D POptn           S              7A
     D PCust           S             10A
     D PKySt           S              7A
     D PEDat           S              7A
 
     D*PSeq************S************* 5S 0                                                   BUG7163
     D*PNum************S************* 6S 0                                                   BUG7163
     D PSeq            S              5A                                                     BUG7163
     D PNum            S              6  0                                                   BUG7163
     D PEnty           S              3A
     D PErr            S              1A
 
     D DBFlag          S               N   Inz(*Off)                                         BUG6456
     D DCFlag          S               N   Inz(*Off)                                         BUG6456
     D DGFlag          S               N   Inz(*Off)                                         BUG6456
     D NoDetl          S               N   Inz(*Off)
     D OverFlow        S               N
     D ATFlag          S               N   Inz(*Off)                                         BUG7234
 
      /EJECT
      *****************************************************************
      *
      ** Main Program
      ** Retrieve Customer Short Name
     C                   Eval      PCust = BYCUST
     C                   Call      'AOCUSTR0'
     C                   Parm      *Blanks       PRtcd
     C                   Parm      '*KEY   '     POptn
     C                   Parm                    PCust
     C                   Parm                    PKySt
     C     SDCUST        Parm      SDCUST        DSSDY
 
     C                   Eval      P#CSSN = BBCSSN
 
      ** Convert Effective Date report format
     C                   Call      'ZDATE2'
     C                   Parm                    BYEFFD
     C                   Parm                    BJDFIN
     C                   Parm      *Zero         P#EFFD
     C                   Parm      *Blank        PEDat
 
      ** Set Description
     C                   If        BYRECI = '*'
     C                   Eval      P#DESC = Deleted
     C                   Else
     C                   Eval      P#DESC = Amended
     C                   EndIf
      ** Set Key Fields
     C                   Move      BYCUST        K#CUST
     C                   Move      BYCUST        K#CNUM                                      BUG6456
     C                   Eval      K#CYCD = BYCYCD
     C************       Eval      K#TRTY = BYTRTY                                           BUG6456
 
     C                   Eval      ATFlag = *Off                                             BUG7234
                                                                                             BUG7234
     C                   Select                                                              BUG6456
     C                   When      BYTRTY = 'FX'                                             BUG6456
      ** Midas DL Foreign exchange deals file
     C                   Exsr      SRDealsDB
 
     C                   When      BYTRTY = 'MM'                                             BUG6456
      ** Midas DL Money market & loans deals
     C                   Exsr      SRDealsDC
 
      ***Midas*DL*Negt.*Assets*Purchased************                                         BUG6456
     C***********        Exsr      SRDealsDD                                                 BUG6456
 
      ***Midas*DL*Negt.*Assets*Sold*****************                                         BUG6456
     C***********        Exsr      SRDealsDE                                                 BUG6456
 
     C                   When      BYTRTY = 'FR' or BYTRTY = 'RS' or                         BUG6456
     C                             BYTRTY = 'RX'                                             BUG6456
      ** Midas DL Fwd rate agreements/int. rate swaps
     C                   Exsr      SRDealsDG
 
     C                   When      BYTRTY = 'DV'                                             BUG6456
      ** Midas DL Fwd rate agreements/int. rate swaps                                        BUG6456
      * FR Deals                                                                             BUG6456
     C                   Eval      W#TRTY = 'FR'                                             BUG6456
     C                   Exsr      SRDealsDG                                                 BUG6456
      * RS Deals                                                                             BUG6456
     C                   Eval      W#TRTY = 'RS'                                             BUG6456
     C                   Exsr      SRDealsDG                                                 BUG6456
      * RX Deals                                                                             BUG6456
     C                   Eval      W#TRTY = 'RX'                                             BUG6456
     C                   Exsr      SRDealsDG                                                 BUG6456
                                                                                             BUG6456
     C                   When      BYTRTY = 'AT'                                             BUG6456
     C                   Eval      ATFlag = *On                                              BUG7234
      ** Midas DL Foreign exchange deals file                                                BUG6456
     C                   Exsr      SRDealsDB                                                 BUG6456
      ** Midas DL Money market & loans deals                                                 BUG6456
     C                   Exsr      SRDealsDC                                                 BUG6456
      ** Midas DL Negt. Assets Purchased                                                     BUG6456
     C                   Exsr      SRDealsDD                                                 BUG6456
      ** Midas DL Negt. Assets Sold                                                          BUG6456
     C                   Exsr      SRDealsDE                                                 BUG6456
      ** Midas DL Fwd rate agreements/int. rate swaps                                        BUG6456
     C                   Exsr      SRDealsDG                                                 BUG6456
      ** Midas DL Fwd rate agreements/int. rate swaps                                        BUG6456
     C                   Eval      K#TRTY = 'DV'                                             BUG6456
     C     KeySD         Chain     SDEXSTL0                                                  BUG6456
     C                   If        Not %Found                                                BUG6456
      * FR Deals                                                                             BUG6456
     C                   Eval      W#TRTY = 'FR'                                             BUG6456
     C                   Exsr      SRDealsDG                                                 BUG6456
      * RS Deals                                                                             BUG6456
     C                   Eval      W#TRTY = 'RS'                                             BUG6456
     C                   Exsr      SRDealsDG                                                 BUG6456
      * RX Deals                                                                             BUG6456
     C                   Eval      W#TRTY = 'RX'                                             BUG6456
     C                   Exsr      SRDealsDG                                                 BUG6456
     C                   EndIf                                                               BUG6456
                                                                                             BUG6456
     C                   EndSl                                                               BUG6456
                                                                                             BUG6456
     CLR                 If        NoDetl = *Off
     CLR                 Write     NoDetail
     CLR                 EndIf
     CLR                 Write     Trailer
      *****************************************************************
 
      /EJECT
      *****************************************************************
      *                                                               *
      * SRDealsDB - Midas DL Foreign exchange deals file              *
      *                                                               *
      * Called by: Main routine                                       *
      *                                                               *
      * Calls    : None                                               *
      *                                                               *
      *****************************************************************
     C     SRDealsDB     BegSr
 
     C                   Reset                   DBFlag                                      BUG6456
     C                   If        BYTRTY = 'AT'                                             BUG6456
     C                   Eval      K#TRTY = 'MM'                                             BUG6456
     C     KeySD         Chain     SDEXSTL0                                                  BUG6456
     C                   If        %Found                                                    BUG6456
     C                   Eval      DBFlag = *On                                              BUG6456
     C                   EndIf                                                               BUG6456
     C                   EndIf                                                               BUG6456
                                                                                             BUG6456
     C                   If        DBFlag = *Off                                             BUG6456
     C     KeyDL         Setll     DEALSDBF
     C     KeyDL         ReadE     DEALSDBF
      ** Write out Sub header if Deals Found
     C                   If        Not %Eof
 
      ** OverFlow ?
     C                   If        OverFlow = *On
     C                   Write     Header
     C                   Eval      OverFlow = *Off
     C                   EndIf
 
      ** Details printed ?
     C                   If        NoDetl = *Off
     C                   Eval      NoDetl = *On
     C                   EndIf
 
     C                   Eval      P#CUST = BYCUST
     C                   Eval      P#CYCD = BYCYCD
     C                   Eval      P#TRTY = BYTRTY
     C                   If        BYTRTY <> 'AT'                                          BUG7234
     C                             Or BYTRTY = 'AT' and ATFLAG = *On                       BUG7234
     C                   Eval      ATFlag = *Off                                           BUG7234
     C                   Write     Detail1
     C                   EndIf                                                             BUG7324
     C                   EndIf
 
      ** Process Deal Records
     C                   Dow       Not %Eof
 
      ** Print if Value/Maturity..date >= Eff Date
     C                   If        VDAT >= BYEFFD
      ** OverFlow ?
     C                   If        OverFlow = *On
     C                   Write     Header
     C                   Write     Detail1
     C                   Eval      OverFlow = *Off
     C                   EndIf
 
     C                   Eval      P#DLNO = DLNO
     C                   Eval      P#DTYP = DTYP
     C                   Eval      P#DLST = DLST
     C                   Eval      P#CLAS = CLAS                                              CDL038
     C                   Write     Detail2
     C                   EndIf
 
     C     KeyDL         ReadE     DEALSDBF
     C                   EndDo
                                                                                             BUG6456
     C                   EndIf                                                               BUG6456
 
     C                   EndSr
      /EJECT
      *****************************************************************
      *                                                               *
      * SRDealsDC - Midas DL Money market & loans deals               *
      *                                                               *
      * Called by: Main routine                                       *
      *                                                               *
      * Calls    : None                                               *
      *                                                               *
      *****************************************************************
     C     SRDealsDC     BegSr
 
     C                   Reset                   DCFlag                                      BUG6456
     C                   If        BYTRTY = 'AT'                                             BUG6456
     C                   Eval      K#TRTY = 'FX'                                             BUG6456
     C     KeySD         Chain     SDEXSTL0                                                  BUG6456
     C                   If        %Found                                                    BUG6456
     C                   Eval      DCFlag = *On                                              BUG6456
     C                   EndIf                                                               BUG6456
     C                   EndIf                                                               BUG6456
                                                                                             BUG6456
     C                   If        DCFlag = *Off                                             BUG6456
     C     KeyDL         Setll     DEALSDCF
     C     KeyDL         ReadE     DEALSDCF
      ** Write out Sub header if Deals Found
     C                   If        Not %Eof
      ** OverFlow ?
     C                   If        OverFlow = *On
     C                   Write     Header
     C                   Eval      OverFlow = *Off
     C                   EndIf
 
      ** Details printed ?
     C                   If        NoDetl = *Off
     C                   Eval      NoDetl = *On
     C                   EndIf
 
     C                   Eval      P#CUST = BYCUST
     C                   Eval      P#CYCD = BYCYCD
     C                   Eval      P#TRTY = BYTRTY
     C                   If        BYTRTY <> 'AT'                                          BUG7234
     C                             Or BYTRTY = 'AT' and ATFLAG = *On                       BUG7234
     C                   Eval      ATFlag = *Off                                           BUG7234
     C                   Write     Detail1
     C                   EndIf                                                             BUG7234
     C                   EndIf
 
      ** Process Deal Records
     C                   Dow       Not %Eof
      ** Print if Value/Maturity..date >= Eff Date
     C                   If        VDAT >= BYEFFD or MDAT >= BYEFFD
     C                             or NIDT >= BYEFFD
      ** OverFlow ?
     C                   If        OverFlow = *On
     C                   Write     Header
     C                   Write     Detail1
     C                   Eval      OverFlow = *Off
     C                   EndIf
 
     C                   Eval      P#DLNO = DLNO
     C                   Eval      P#DTYP = DTYP
     C                   Eval      P#DLST = DLST
     C                   Eval      P#CLAS = CLAS                                              CDL038
     C                   Write     Detail2
     C                   EndIf
 
     C     KeyDL         ReadE     DEALSDCF
     C                   EndDo
 
     C                   EndIf                                                               BUG6456
                                                                                             BUG6456
     C                   EndSr
      /EJECT
      *****************************************************************
      *                                                               *
      * SRDealsDD - Midas DL Negt. Assets Purchased                   *
      *                                                               *
      * Called by: Main routine                                       *
      *                                                               *
      * Calls    : None                                               *
      *                                                               *
      *****************************************************************
     C     SRDealsDD     BegSr
 
     C     KeyDL         Setll     DEALSDDF
     C     KeyDL         ReadE     DEALSDDF
      ** Write out Sub header if Deals Found
     C                   If        Not %Eof
      ** OverFlow ?
     C                   If        OverFlow = *On
     C                   Write     Header
     C                   Eval      OverFlow = *Off
     C                   EndIf
 
      ** Details printed ?
     C                   If        NoDetl = *Off
     C                   Eval      NoDetl = *On
     C                   EndIf
 
     C                   Eval      P#CUST = BYCUST
     C                   Eval      P#CYCD = BYCYCD
     C                   Eval      P#TRTY = BYTRTY
     C                   If        BYTRTY <> 'AT'                                          BUG7234
     C                             Or BYTRTY = 'AT' and ATFLAG = *On                       BUG7234
     C                   Eval      ATFlag = *Off                                           BUG7234
     C                   Write     Detail1
     C                   EndIf                                                             BUG7234
     C                   EndIf
 
      ** Process Deal Records
     C                   Dow       Not %Eof
      ** Print if Value/Maturity..date >= Eff Date
     C                   If        VDAT >= BYEFFD or MDAT >= BYEFFD
     C                             or NIDT >= BYEFFD
      ** OverFlow ?
     C                   If        OverFlow = *On
     C                   Write     Header
     C                   Write     Detail1
     C                   Eval      OverFlow = *Off
     C                   EndIf
 
     C                   Eval      P#DLNO = DLNO
     C                   Eval      P#DTYP = DTYP
     C                   Eval      P#DLST = DLST
     C                   Eval      P#CLAS = CLAS                                              CDL038
     C                   Write     Detail2
     C                   EndIf
 
     C     KeyDL         ReadE     DEALSDDF
     C                   EndDo
 
     C                   EndSr
      /EJECT
      *****************************************************************
      *                                                               *
      * SRDealsDE - Midas DL Negt. Assets Sold                        *
      *                                                               *
      * Called by: Main routine                                       *
      *                                                               *
      * Calls    : None                                               *
      *                                                               *
      *****************************************************************
     C     SRDealsDE     BegSr
 
     C     KeyDL         Setll     DEALSDEF
     C     KeyDL         ReadE     DEALSDEF
      ** Write out Sub header if Deals Found
     C                   If        Not %Eof
      ** OverFlow ?
     C                   If        OverFlow = *On
     C                   Write     Header
     C                   Eval      OverFlow = *Off
     C                   EndIf
 
      ** Details printed ?
     C                   If        NoDetl = *Off
     C                   Eval      NoDetl = *On
     C                   EndIf
 
     C                   Eval      P#CUST = BYCUST
     C                   Eval      P#CYCD = BYCYCD
     C                   Eval      P#TRTY = BYTRTY
     C                   If        BYTRTY <> 'AT'                                          BUG7234
     C                             Or BYTRTY = 'AT' and ATFLAG = *On                       BUG7234
     C                   Eval      ATFlag = *Off                                           BUG7234
     C                   Write     Detail1
     C                   EndIf                                                             BUG7234
     C                   EndIf
 
      ** Process Deal Records
     C                   Dow       Not %Eof
      ** Print if Value/Maturity..date >= Eff Date
     C                   If        VDAT >= BYEFFD
      ** OverFlow ?
     C                   If        OverFlow = *On
     C                   Write     Header
     C                   Write     Detail1
     C                   Eval      OverFlow = *Off
     C                   EndIf
 
     C                   Eval      P#DLNO = DLNO
     C                   Eval      P#DTYP = DTYP
     C                   Eval      P#DLST = DLST
     C                   Eval      P#CLAS = CLAS                                              CDL038
     C                   Write     Detail2
     C                   EndIf
 
     C     KeyDL         ReadE     DEALSDEF
     C                   EndDo
 
     C                   EndSr
      /EJECT
      *****************************************************************
      *                                                               *
      * SRDealsDG - Midas DL Fwd rate agreements/int. rate swaps      *
      *                                                               *
      * Called by: Main routine                                       *
      *                                                               *
      * Calls    : None                                               *
      *                                                               *
      *****************************************************************
     C     SRDealsDG     BegSr
 
     C                   Reset                   DGFlag                                      BUG6456
     C                   If        BYTRTY = 'DV' or BYTRTY = 'AT'                            BUG6456
     C                   Eval      K#TRTY = W#TRTY                                           BUG6456
     C     KeySD         Chain     SDEXSTL0                                                  BUG6456
     C                   If        %Found                                                    BUG6456
     C                   Eval      DGFlag = *On                                              BUG6456
     C                   EndIf                                                               BUG6456
     C                   EndIf                                                               BUG6456
                                                                                             BUG6456
     C                   If        DGFlag = *Off                                             BUG6456
     C*****KeyDL*****    Setll     DEALSDGF                                                  BUG6456
     C*****KeyDL*****    ReadE     DEALSDGF                                                  BUG6456
     C     KeyDLT        Setll     DEALSDGF                                                  BUG6456
     C     KeyDLT        ReadE     DEALSDGF                                                  BUG6456
      ** Write out Sub header if Deals Found
     C                   If        Not %Eof
      ** OverFlow ?
     C                   If        OverFlow = *On
     C                   Write     Header
     C                   Eval      OverFlow = *Off
     C                   EndIf
 
      ** Details printed ?
     C                   If        NoDetl = *Off
     C                   Eval      NoDetl = *On
     C                   EndIf
 
     C                   Eval      P#CUST = BYCUST
     C                   Eval      P#CYCD = BYCYCD
     C                   Eval      P#TRTY = BYTRTY
     C                   If        BYTRTY <> 'AT'                                          BUG7234
     C                             Or BYTRTY = 'AT' and ATFLAG = *On                       BUG7234
     C                   Eval      ATFlag = *Off                                           BUG7234
     C                   Write     Detail1
     C                   EndIf                                                             BUG7234
     C                   EndIf
 
      ** Process Deal Records
     C                   Dow       Not %Eof
      ** Print if Value/Maturity Date or next Interest Payment >= Eff date
     C                   If        VDAT >= BYEFFD or MDAT >= BYEFFD
     C                             or TNIPD >= BYEFFD
      ** OverFlow ?
     C                   If        OverFlow = *On
     C                   Write     Header
     C                   Write     Detail1
     C                   Eval      OverFlow = *Off
     C                   EndIf
 
     C                   Eval      P#DLNO = DLNO
     C                   Eval      P#DTYP = DTYP
     C                   Eval      P#DLST = DLST
     C                   Eval      P#CLAS = CLAS                                              CDL038
     C                   Write     Detail2
     C                   EndIf
 
     C*****KeyDL******   ReadE     DEALSDGF                                                  BUG6456
     C     KeyDLT        ReadE     DEALSDGF                                                  BUG6456
     C                   EndDo
 
     C                   EndIf                                                               BUG6456
                                                                                             BUG6456
     C                   EndSr
      /EJECT
      *****************************************************************
      *                                                               *
      *  RCFP1  - Subroutine to register the Printer File via RCF.    *
      *                                                               *
      *****************************************************************
      *
     C     RCFP1         BegSr
      *
      ** Ensure Report Spool File recorded by RCF.
      *
     C                   Open      DL0950P1
     C                   eval      PNum = SFNUM
      *
     C                   Call      'ZSFILE'
     C                   Parm                    PSeq
     C                   Parm      *Blanks       PEnty
     C                   Parm                    SFile
     C                   Parm                    PNum
     C                   Parm                    PErr
 
      ** If Error occurs during ZSFILE processing, then return to the
      ** Calling Program.
     C                   If        PErr = 'Y'
     C                   Eval      *InU7 = *On
     C                   Eval      *InU8 = *On
     C                   Eval      *InLR = *On
     C                   Return
     C                   EndIf
 
     C                   EndSr
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation Routine                       *
      *                                                               *
      *  Called by: Implicitly on program activation                  *
      *                                                               *
      *  Calls    : AOBANKR0 - Access Bank Details                    *
      *             *PSSR                                             *
      *                                                               *
      *****************************************************************
     C     *InzSr        BegSr
 
      ** Entry Parameters
     C     *Entry        Plist
     C                   Parm                    PSeq
 
      ** Define LDA
     C     *Lock         In        LDA
     C                   Eval      DBPGM = 'DL0950'
     C                   Eval      DBFILE = *BLANKS
     C                   Eval      DBKEY =  *BLANKS
     C                   Eval      DBASE = 0
     C                   Out       LDA
 
      ** Initialise Key Lists
     C     KeyDL         KList
     C                   KFld                    K#CNUM
     C                   KFld                    K#CYCD
     C**********         KFld                    K#TRTY                                      BUG6456
 
     C     KeyDLT        KList                                                               BUG6456
     C                   KFld                    K#CNUM                                      BUG6456
     C                   KFld                    K#CYCD                                      BUG6456
     C                   KFld                    K#TRTY                                      BUG6456
                                                                                             BUG6456
     C     KeySD         KList                                                               BUG6456
     C                   KFld                    K#CYCD                                      BUG6456
     C                   KFld                    K#CUST                                      BUG6456
     C                   KFld                    K#TRTY                                      BUG6456
                                                                                             BUG6456
      ** Access bank details.
     C                   Call      'AOBANKR0'
     C                   Parm      *BLANKS       PRtcd
     C                   Parm      '*FIRST '     POptn
     C     SDBANK        Parm      SDBANK        DSFDY
 
      ** Database error
     C                   If        PRtcd <> *BLANK
     C     *Lock         In        LDA
     C                   Eval      DBFILE= 'SDBANKPD'
     C                   Eval      DBKEY = POptn
     C                   Eval      DBASE = 001
     C                   Out       LDA
     C                   Exsr      *PSSR
     C                   EndIf
 
      * Open and Register Print
     C                   If        Not %Open(DL0950P1)
     C                   Exsr      RCFP1
     C                   EndIf
 
     C                   Write     Header
 
     C                   EndSr
      /EJECT
      *****************************************************************
      *                                                               *
      *  *PSSR   -  Error Handling Subroutine                         *
      *                                                               *
      *  Called by: Various                                           *
      *                                                               *
      *  Calls    : DBERRCTL - Database Error Control                 *
      *                                                               *
      *****************************************************************
     C     *PSSR         BegSr
 
     C                   Dump
 
     C                   If        @RUN = *BLANK
     C                   Eval      @RUN = 'Y'
     C                   Call      'DBERRCTL'
     C                   EndIf
      *
     C                   Eval      *InU7 = *ON
     C                   Eval      *InU8 = *ON
     C                   Eval      *InLR = *ON
     C                   Return
 
     C                   EndSr
      /EJECT
      *****************************************************************
** CPY@
(c) Misys International Banking Systems Ltd. 2004
