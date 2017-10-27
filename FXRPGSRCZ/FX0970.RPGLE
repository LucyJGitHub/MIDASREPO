     H DEBUG
      *****************************************************************
/********RPGBASEBND****************************************************                      BUG6192
/*STD *  RPGBASEMOD                                                   *                      BUG6192
/*EXI *  TEXT('Midas FX Netted Deals Release')                        *
      *****************************************************************
      *                                                               *
      *  Midas - Dealing Module - Foreign Exchange.                   *
      *                                                               *
      *  FX0970 - Midas FX Netted Deals Release                       *
      *                                                               *
      *  Function:  This program releases FX Deals flagged for        *
      *             Netting if past their cut off time.               *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2004            *
      *                                                               *
      *  Last Amend No. CDL099             Date 06Oct17               *
      *  Prev Amend No. CDL094             Date 11Jun14               *
      *                 CSW212             Date 03May12               *
      *                 CER059             Date 19Jul10               *
      *                 CER043             Date 19May08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD031             Date 10Apr06               *
      *                 CSD027             Date 09Dec05               *
      *                 CDL038             Date 10May05               *
      *                 BUG7034            Date 10May05               *
      *                 BUG6192            Date 24Feb05               *
      *                 CDL025  *CREATE    Date 16Dec04               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CDL099 - Split Value Date (Recompile)                        *
      *  CDL094 - Enhance  Receive Settlement Instructions            *
      *           (Recompiled)                                        *
      *  CSW212 - SWIFT 2012 Changes (Recompile)                      *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER043 - German Features LF041-00 New Fields and Defaulting  *
      *           (Recompile)                                         *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CDL038 - Extended Deal Sub Type (Recompile)                  *
      *  BUG7034- Duplicate Records error (recompile)                 *
      *  BUG6192- Change program to RPGBASEMOD & fix SR/*PSSR.        *
      *           Use COMMIT/ROLLBACK via CLP caller.                 *
      *  CDL025 - FX Netting Payment Generation                       *
      *                                                               *
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
     FFXDEALL3  UF   E           K DISK
     F                                     COMMIT                                            BUG6192
      *  FX transactions by Value date/Customer
 
     FFXNETMPD  UF   E           K DISK
     F                                     COMMIT                                            BUG6192
      *  Midas DL Confirmed nets master file
 
     FFXNETSPD  UF   E           K DISK
     F                                     COMMIT                                            BUG6192
      *  Midas DL Confirmed split nets master file
 
     FFXNTIPL0  IF   E           K DISK
      *  Midas DL Nets in progress master file
 
     FGPZONEL2  IF   E           K DISK
      *  Midas GP Zones by zone system prefix
 
     FSDCTNML2  IF   E           K DISK
      *  Midas SD Currency/Time of Netting
 
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      **
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes (among others) the LDA layout
      ** and the copyright array definition:
     D/COPY ZACPYSRC,STD_D_SPEC
      **--------------------------------------------------------------------------------------------
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes all the defined fields in the
      ** Program Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
      **--------------------------------------------------------------------------------------------
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
     D/COPY ZACPYSRC,ERR_ARRAYS
      **--------------------------------------------------------------------------------------------
 
      ** +--------------------------------------+
      ** ¦ End of automatically included D-specs¦
      ** ¦ =====================================¦
      ** +--------------------------------------+
      *****************************************************************
      /EJECT
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
      ** Externally described DS for bank details
     D SDBANK        E DS                  ExtName(SDBANKPD)
 
      *  Customer Details format for access object pgm
     D SDCUST        E DS                  ExtName(SDCUSTPD)
 
      ** External data structure for Currency Details file
     D SDCURR        E DS                  ExtName(SDCURRPD)
 
      ** External DS for SAR details
     D SCSARD        E DS                  ExtName(SCSARDPD)
 
      ** First DS for access programs, short data structure
     D DSFDY         E DS                  ExtName(DSFDY)
 
     D* Second DS For Access Programs, LONG DATA STRUCTURE
     D DSSDY         E DS                  ExtName(DSSDY)
 
      ** Data Area giving Installation Control Details
     D RUNDAT        E DS                  ExtName(RUNDAT) DtaAra(RUNDAT)
 
      ** SD Data Area
     D SDSTAT        E DS                  ExtName(SDSTAT) DtaAra(SDSTAT)
 
      **  Data Structure: for TIME passed
     D DSTime          DS
     D  W#HH                          2S 0
     D  W#MN                          2S 0
 
      **  Data Structure:  Redefine parameter value date
     D DSYYMD          DS
     D  W#YYYY                 1      4S 0
     D  W#MM                   5      6S 0
     D  W#DD                   7      8S 0
 
      *
      ** +--------------------------------------+
      ** ¦ Variables and Named constants        ¦
      ** ¦ =============================        ¦
      ** +--------------------------------------+
 
      **  Data Structure to redefine Value Date in DDMMYYYY format
      ** Pass Parameters
     D PLTime          S              4A
     D PRtcd           S              7A
     D POptn           S              7A
     D PSARD           S              6A
     D PCurr           S              3A
     D PRDNB           S              5P 0
     D PChgDat         S              8S 0
     D PRtn            S              1A
 
      ** Key Fields
     D K#Time          S                   Like(LTIME)
     D K#DCNO          S                   Like(FHDCNO)
     D K#VDYY          S                   Like(FHVDYY)
     D K#VDMM          S                   Like(FHVDMM)
     D K#VDDD          S                   Like(FHVDDD)
     D K#CCY1          S                   Like(FHCCY1)
     D K#CCY2          S                   Like(FHCCY2)
 
      ** Program Fields
     D CGP009          S              1A
 
     D W#ZODY          S              1S 0 Inz(0)
     D W#ChgDat        S              8A
     D W#NBRF          S                   Like(FHNBRF)
     D W#NSRF          S                   Like(FHNSRF)
     D W#RDNB          S                   Like(BJRDNB)
     D W#UpDate        S               N
     D W#BuyIP         S               N
     D W#SellIP        S               N
 
      /EJECT
      *================================================================
      *  P R O G R A M   S T A R T                                    *
      *================================================================
 
      ** Get Currencies for Netting at this time
     C                   Move      DSTime        K#Time
     C     K#Time        Setll     SDCTNML2
     C     K#Time        ReadE     SDCTNML2
     C                   DoW       Not %Eof(SDCTNML2)
 
      ** Calculate Value Date
     C                   Exsr      SRValDate
 
     C                   Eval      W#UpDate = *Off
     C                   Eval      W#BuyIP = *Off
     C                   Eval      W#SellIP = *Off
 
      ** Set up Key and Retrieve Deals
     C                   Move      LCUST         K#DCNO
     C                   Eval      K#VDYY = W#YYYY
     C                   Eval      K#VDMM = W#MM
     C                   Eval      K#VDDD = W#DD
     C                   Eval      K#CCY1 = LCCY1
     C                   Eval      K#CCY2 = LCCY2
     C     KDEALL3       Setll     FXDEALP0
     C     KDEALL3       ReadE     FXDEALP0
 
      **  Process Deals
     C                   DoW       Not %Eof(FXDEALL3) and
     C                             W#BuyIP = *Off and W#SellIP = *Off
 
      ** Details found
     C                   Eval      W#UpDate = *On
 
      ** Check for Buy Net in Progress
     C     FHNBRF        Setll     FXNTIPL0
 
      **  If Record Found, Then Another User is Netting This Deal.
     C                   If        %Equal(FXNTIPL0)
     C                   Eval      W#BuyIP = *On
     C                   Eval      W#UpDate = *Off
     C                   EndIf
 
      ** Check for Sell Net in Progress
     C     FHNSRF        Setll     FXNTIPL0
 
      **  If Record Found, Then Another User is Netting This Deal.
     C                   If        %Equal(FXNTIPL0)
     C                   Eval      W#SellIP = *On
     C                   Eval      W#UpDate = *Off
     C                   EndIf
 
      ** Remove Net Flags from FXDEALPP if not in Progress
     C                   If        W#BuyIP = *Off and W#SellIP = *Off
     C                   Eval      FHNBUY = 'N'
     C                   Eval      FHNSEL = 'N'
     C                   Eval      FHDLUP = UDay
     C                   Eval      FHMLUP = %Subst(BJMRDT:3:3)
     C                   Eval      FHYLUP = UYear
     C                   Eval      FHCHTP = 'A'
     C                   Time                    FHTLUP
     C                   Eval      FHLCD = BJRDNB
     C                   Eval      FHLUID = PSUser
     C                   Update    FXDEALP0
     C                   EndIf
 
     C     KDEALL3       ReadE     FXDEALP0
     C                   EndDo
 
      ** Update Net References
     C                   If        W#Update = *On
      ** Physical delete of Buy References
     C                   Exsr      SRNetBDel
 
      ** Physical delete of Sell References
     C                   Exsr      SRNetSDel
     C                   EndIf
 
     C     K#Time        ReadE     SDCTNML2
     C                   EndDo
 
      **  End Program and Return.
     C                   Eval      *InLR = *On
     C                   Return
 
      *================================================================
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRValDate - Calc Value Date from Telex Days and Notice days  *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
     C     SRValDate     BEGSR                                                  ***  INIT  ***
 
      ** Retrieve Telex Notice Days For Currency
     C                   Call      'AOCURRR0'
     C                   Parm      '       '     PRtCd
     C                   Parm      '*KEY   '     POptn
     C                   Parm      LCCY1         PCurr
     C     SDCURR        Parm      SDCURR        DSSDY
 
     C                   Eval      W#RDNB = BJRDNB + W#ZODY + A6TXND - LRNTD
 
      ** Convert Midas Day No to YYYYMMDD format for Change Date
     C****************** Call      'ZDATE9'                                                  BUG6192
     C                   Callb     'ZDATE9'                                                  BUG6192
     C                   Parm      W#RDNB        PRDNB
     C                   Parm      0             PChgDat
     C                   Parm                    PRtn
 
     C                   Move      PChgDat       DSYYMD
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRNetBDel - Delate Buy References                            *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
     C     SRNetBDel     BEGSR                                                  ***  INIT  ***
 
      ** Physical delete of Net Master File FXNETMPD
      ** Buy Ref
     C     FHNBRF        Chain     FXNETMPD
     C                   If        %Found(FXNETMPD)
     C                   Eval      AMRECI = 'R'
     C                   Eval      AMDTCH = W#ChgDat
     C                   Time                    AMCHTI
     C                   Eval      AMCHTY = 'R'
     C                   Eval      AMCHUS = PSUser
     C                   Eval      AMCHWS = PSJobName
     C                   Eval      AMEXPF = 'E'
     C                   Update    FXNETMD0
     C                   EndIf
 
      ** Physical delete of Split Net File FXNETSPD
      ** Buy Ref
     C     FHNBRF        Setll     FXNETSPD
     C     FHNBRF        ReadE     FXNETSPD
     C                   DoW       Not %Eof(FXNETSPD)
     C                   Eval      ASDTCH = W#ChgDat
     C                   Time                    ASCHTI
     C                   Eval      ASCHTY = 'R'
     C                   Eval      ASEXPF = 'E'
     C                   Eval      ASCHUS = PSUser
     C                   Eval      ASCHWS = PSJobName
     C                   Update    FXNETSD0
 
     C     FHNBRF        ReadE     FXNETSPD
     C                   EndDo
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRNetSDel - Delete Sell references                           *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
     C     SRNetSDel     BEGSR                                                  ***  INIT  ***
 
      ** Sell Ref
     C     FHNSRF        Chain     FXNETMPD
     C                   If        %Found(FXNETMPD)
     C                   Eval      AMRECI = 'R'
     C                   Eval      AMDTCH = W#ChgDat
     C                   TIME                    AMCHTI
     C                   Eval      AMCHTY = 'R'
     C                   Eval      AMCHUS = PSUser
     C                   Eval      AMCHWS = PSJobName
     C                   Eval      AMEXPF = 'E'
     C                   Update    FXNETMD0
     C                   EndIf
 
 
      ** Sell Ref
     C     FHNSRF        Setll     FXNETSPD
     C     FHNSRF        ReadE     FXNETSPD
     C                   DoW       Not %Eof(FXNETSPD)
     C                   Eval      ASDTCH = W#ChgDat
     C                   Time                    ASCHTI
     C                   Eval      ASCHTY = 'R'
     C                   Eval      ASEXPF = 'E'
     C                   Eval      ASCHUS = PSUser
     C                   Eval      ASCHWS = PSJobName
     C                   Update    FXNETSD0
 
     C     FHNSRF        ReadE     FXNETSPD
     C                   EndDo
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *INZSR - Initial Processing                                  *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR                                                  ***  INIT  ***
 
      *  Entry Parameter List
     C     *Entry        PList
     C                   Parm                    PLTime
 
      **  Key List for access to FXDEALL3
     C     KDEALL3       KList
     C                   KFld                    K#DCNO                         Value Date
     C                   KFld                    K#VDYY                         Value Date
     C                   KFld                    K#VDMM                         Value Date
     C                   KFld                    K#VDDD                         Value Date
     C                   KFld                    K#CCY1                         Value Date
     C                   KFld                    K#CCY2                         Value Date
 
      ** Access bank details.
     C                   Call      'AOBANKR0'
     C                   Parm      *Blanks       PRtcd
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
 
      ** Check if CGP009 is switched *ON.                                                CDL025
     C                   Call      'AOSARDR0'                                            CDL025
     C                   Parm      *Blanks       PRtCd                                   CDL025
     C                   Parm      '*VERIFY'     POptn                                   CDL025
     C                   Parm      'CGP009'      PSARD                                   CDL025
     C     SCSARD        Parm      SCSARD        DSFDY                                   CDL025
      *                                                                                  CDL025
     C                   If        PRtCd <> *Blanks                                      CDL025
     C                   Eval      CGP009 = 'N'                                          CDL025
     C                   Else                                                            CDL025
     C                   Eval      CGP009 = 'Y'                                          CDL025
     C                   EndIf                                                           CDL025
      *                                                                                  CDL025
      ** Convert Midas Day No to YYYYMMDD format for Change Date
     C****************** Call      'ZDATE9'                                                  BUG6192
     C                   Callb     'ZDATE9'                                                  BUG6192
     C                   Parm      BJRDNB        PRDNB
     C                   Parm      0             PChgDat
     C                   Parm                    PRtn
 
     C                   Move      PChgDat       W#ChgDat
 
      ** Initialise Program Name & Time
     C                   Eval      DBPGM = 'FX0970'
     C                   Eval      DSTime = PLTime
 
      ** COB Run ?
     C                   If        PLTime <> *Blanks
      ** Set Time for nearest half hour
     C                   If        W#MN < 10
     C                   Eval      W#MN = 0
     C                   Else
     C                   Eval      W#MN = 30
     C                   EndIf
 
      **  Get SDSTAT
     C                   In        SDSTAT
 
      ** Retrieve time Zone Difference (only if feature on)
     C                   If        CGP009 = 'Y'
     C     LIBR          Chain     GPZONEL2
 
     C                   Eval      W#HH = W#HH + ZOTMDF
      ** Crossed forward to Tomorrow
     C                   If        W#HH > 24
     C                   Eval      W#HH = W#HH - 24
     C                   Eval      W#ZODY = 1
     C                   EndIf
 
      ** Crossed back to yesterday
     C                   If        W#HH < 0
     C                   Eval      W#HH = W#HH + 24
     C                   Eval      W#ZODY = -1
     C                   EndIf
     C                   EndIf
 
     C                   EndIf
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *PSSR  - Program exception error routine                      *
      *          Called automatically if a program error occurs,      *
      *          or directly by the program code using EXSR.          *
      *          This subroutine DUMPs the program just once.         *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     *PSSR         BEGSR
 
     C                   If        RunBefore <> 'Y'                                          BUG6192
     C                   Eval      RunBefore = 'Y'                                           BUG6192
     C                   Dump
     C                   EndIf                                                               BUG6192
 
     C                   Eval      *INU7 = *ON
     C                   Eval      *INU8 = *ON
     C                   Eval      *INLR = *ON
     C                   RETURN                                                              BUG6192
 
     C****************** If        RunBefore <> 'Y'                                          BUG6192
     C****************** Eval      RunBefore = 'Y'                                           BUG6192
      ******************                                                                     BUG6192
      ***Load*RUNDAT****                                                                     BUG6192
     C****************** In        RUNDAT                                                    BUG6192
      ******************                                                                     BUG6192
      ***Load*the*APDUMP*fields                                                              BUG6192
     C******Lock******** In        APDUMP                               99                   BUG6192
      ******************                                                                     BUG6192
      ***If*there*is*an*error*in*reading*the*APDUMP*data*area,*it                            BUG6192
      ** probably*doesn't*exist,*so*call*the*procedure*which*creates*it                      BUG6192
      ** and*try*again.                                                                      BUG6192
     C****************** If        *In99                                                     BUG6192
     C****************** Clear                   PSSRRetCde                                  BUG6192
     C****************** Call      'APCCRTQTO'                                               BUG6192
     C****************** Parm                    PSSRRetCde       10                         BUG6192
      ******************                                                                     BUG6192
     C******Lock******** In        APDUMP                                                    BUG6192
     C****************** EndIF                                                               BUG6192
      ******************                                                                     BUG6192
     C****************** Eval      ARErrMod = PSProcMod                                      BUG6192
     C****************** Out       APDUMP                                                    BUG6192
     C****************** Call      'DBERRCTL'                                                BUG6192
     C****************** EndIf                                                               BUG6192
      ******************                                                                     BUG6192
     C****************** RETURN                                                              BUG6192
 
     C                   ENDSR
      ********************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2004
