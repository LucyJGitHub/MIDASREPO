     H DEBUG
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas MM Fiduciary takings subfile module')            *
      *****************************************************************
      *                                                               *
      *  Midas - Money Market Dealing Module                          *
      *                                                               *
      *  MMFIDTSFL - MM Fiduciary Takings Subfile Module              *
      *                                                               *
      *  Function:  This program is called by MMLDNISIN when feature  *
      *             CDL006 is activated to allow input of the takings *
      *                                                               *
      *  Called By: MMLDNISIN - LDN Inputs                            *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      *  Last Amend No. CDL096             Date 22Sep14               *
      *  Prev Amend No. CDL094             Date 11Jun14               *
      *                 CRE073             Date 06Dec10               *
      *                 CER059             Date 19Jul10               *
      *                 CER054             Date 07Apr09               *
      *                 CER043             Date 19May08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD031             Date 10Apr06               *
      *                 CDL049             Date 11Jul06               *
      *                 CSD027             Date 09Dec05               *
      *                 237063             Date 20Nov05               *
      *                 CDL038             Date 10May05               *
      *                 BUG7411            Date 01Jun05               *
      *                 CSW037A            Date 02May05               *
      *                 CDL028             Date 07Feb05               *
      *                 229544             Date 15Sep04               *
      *                 CSD025             Date 11Jan05               *
      *                 CSW037             Date 15Dec04               *
      *                 CSW036             Date 15Dec04               *
      *                 CLE025             Date 20Oct03               *
      *                 CDL020             Date 03Feb04               *
      *                 CDL019             Date 03Feb04               *
      *                 CDL018             Date 03Feb04               *
      *                 CDL017             Date 03Feb04               *
      *                 CDL016             Date 03Feb04               *
      *                 CGL029             Date 01Sep03               *
      *                 222727             Date 05Nov03               *
      *                 CDL010             Date 02Aug02               *
      * Midas Release 4.01.02 ----------------------------------------*
      *                 209905             Date 25Sep02               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.04 -----------------------------------------------*
      *                 CSD009             Date 10Oct00               *
      * Midas DBA 3.03 -----------------------------------------------*
      *                 179243             Date 19May00               *
      *                 176659             Date 19May00               *
      * Midas DBA 3.01 -----------------------------------------------*
      *                 CDL006  *CREATE    Date 26Apr99               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CDL096 - Business Day Conventions on MM Deals                *
      *           (Recompile)                                         *
      *  CDL094 - Enhance  Receive Settlement Instructions            *
      *           (Recompiled)                                        *
      *  CRE073 - Interest Rate Rounding (Recompile)                  *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER054 - German Features - Church Tax (Recompile)            *
      *  CER043 - German Features LF041-00 New Fields and Defaulting  *
      *           (Recompile)                                         *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CDL049 - Addition of a Reference Rate field (recompile)      *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  237063 - EU Tax fixes upgrade to MP build 103 (Recompile).   *
      *  CDL038 - Extended Deal Sub Type (Recompile)                  *
      *  BUG7411- CDL028 fields missing from DLGHISPD (Recompile)     *
      *  CSW037A- Additional Field extended to 40 chars (recompile)   *
      *  CDL028 - Automatic Rate Interpolations (Recompile)           *
      *  229544 - Rename TRTP from LF/DEALSALL record format          *
      *           DLCHISD0.                                           *
      *  CSD025 - Customer De-Activation                              *
      *  CSW037 - Additional Field Data on MT300/MT320                *
      *  CSW036 - Dual SWIFT BIC held on Client Details               *
      *  CLE025 - Credit Lines (Recompile)                            *
      *  CDL020 - Apply Base Rate at Value Date (Recompile)           *
      *  CDL019 - Allow Base Rate Changes on Fixed Deposits/Loans     *
      *           (Recompile)                                         *
      *  CDL018 - Multiple Settlement Accounts on Loans/Deposits      *
      *           (Recompile)                                         *
      *  CDL017 - Penalty Fee & Early Maturity of Fixed Term Loan/Dep *
      *           (Recompile)                                         *
      *  CDL016 - Automatic rollover of Fixed Term Loans/Deposits     *
      *           (Recompile)                                         *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  222727 - Release 5.0 errors  (Recompile)                     *
      *  CDL010 - Prevent last user that actioned the trade from      *
      *           authorising it.Recompile due to changes in MMDELDPP *
      *  209905 - Fiduciary API Enhancement                           *
      *  CSD009 - Profit Centre Accounting Default Matrix Enhancement *
      *           Re-compiled due to changes in module AOPRFMR0.      *
      *  179243 - Parameter mismatch on call to ZAVTOTINT, add action *
      *           code parameter.                                     *
     F*  176659 - Rename of field TRTP from file DEALSALL.            *
     F*           Caused by CSE006.                                   *
      *  CDL006 - Dealing Fiduciary                                   *
      *                                                               *
      *****************************************************************
     FMMFIDDSDF CF   E             WORKSTN INFDS(DSPFDS)
     F                                     SFILE(MMFIDDS1:WWRRN)
     F                                     SFILE(MMFIDDS3:WWRRN3)
     FMMDELDL3  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(MMDELDP0:SW8ENQY)
     FMMWFIDDL0 IF   E           K DISK    INFSR(*PSSR)
     FFDDLNMLL  IF   E             DISK    INFSR(*PSSR)
     FDEALSALL  IF   E           K DISK    INFSR(*PSSR)
     FPMPORTLL  IF   E           K DISK    INFSR(*PSSR)
     FACCNT     IF   E           K DISK    INFSR(*PSSR)
     F                                     IGNORE(ACCNTAAF:ACCNTACF)
     FMMWFIDDPD IF A E           K DISK    INFSR(*PSSR)
     F                                     RENAME(MMWFIDDD0:SW8OUTP)
     F                                     COMMIT
     FMMDELDL2  IF   E           K DISK    INFSR(*PSSR)
     FSDCCGRL1  IF   E           K DISK    INFSR(*PSSR)
 
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
 
      ** Program, procedure and module names for parameters
      ** ==================================================
 
      ** +--------------------------------------+
      ** ¦ End of automatically included D-specs¦
      ** ¦ =====================================¦
      ** +--------------------------------------+
 
      ** Message ID
     D MsgID1          S                   LIKE(#MsgID)
 
      **  Input array for ZA0840
 
     D @F              S              1    DIM(16)
     D @G              S              1    DIM(16)
     D ArrDLNO         S              6    DIM(100) ASCEND
     D***Inv_FIDT        S             42    DIM(99)                                   209905 CGL029
     D Inv_FIDT        S             48    DIM(99)                                            CGL029
     D X               S              3  0
     D @SLDS         E DS                  EXTNAME(MMVLDNIPD)
      ** Data structure of the standard deal, Loans/Deposits format.
     D SCSARD        E DS                  EXTNAME(SCSARDPD)
      ** External data structure for switchable features
     D SDACOD        E DS                  EXTNAME(SDACODPD)
      ** External data structure for account code details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** External data structure for bank details
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
      ** External data structure for currency details
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)
      ** External data structure for customer details
     D SDDEAL        E DS                  EXTNAME(SDDEALPD)
     D SDDEALACCD    E                     EXTFLD(QQACCD)                                     CGL029
      ** External data structure for ICD dealing
     D SDMMOD        E DS                  EXTNAME(SDMMODPD)
      ** External data structure for module details
     D SDPLCS        E DS                  EXTNAME(SDPLCSPD)
      ** External data structure for portfolio details
     D SDPORT        E DS                  EXTNAME(SDPORTPD)
      ** External data structure for ICD portfolio
     D SDRETL        E DS                  EXTNAME(SDRETLPD)
     D SDRETLACCD    E                     EXTFLD(QQACCD)                                     CGL029
      ** External data structure for ICD retail
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** First DS for Access Programs, Short Data Structure
     D DSSDY         E DS                  EXTNAME(DSSDY)
      ** Second DS for Access Programs, Long Data Structure
     D DSLDY         E DS                  EXTNAME(DSLDY)
      ** Third DS for Access Programs, Long Data Structure
     D DSPFDS          DS
     D  CPFPOS               378    379B 0
     D WWCUST          DS
     D  SHCNUM                 1      6
     D***SFACOD                 7     10                                                      CGL029
     D***SFACSQ                11     12                                                      CGL029
     D  SFACOD                 7     16                                                       CGL029
     D  SFACSQ                17     18                                                       CGL029
     D ZMUSER          DS            17
     D  ZMBRCA                11     13
     D  ZMDEPT                14     16
 
     D PCYDP           S              1S 0
     D PNTCE           S              3S 0
 
     D NNDCSP          S              1A   IMPORT
     D S01468          S              1A   IMPORT
 
     D InvFIDT         DS                                                                     209905
     D  ISFDLNO                1      6                                                       209905
     D  ISFCNUM                7     16                                                       209905
     D  ISFPTFR               17     20                                                       209905
     D  ISFAMNT               21     35                                                       209905
     D***ISFACOD               36     39                                               209905 CGL029
     D***ISFACSQ               40     41                                               209905 CGL029
     D***ISFTRAS               42     42                                               209905 CGL029
     D  ISFACOD               36     45                                                       CGL029
     D  ISFACSQ               46     47                                                       CGL029
     D  ISFTRAS               48     48                                                       CGL029
                                                                                              209905
     D CDL006          S              1A                                                      209905
     D PRTCD           S              7A                                                      209905
     D POPTN           S              7A                                                      209905
     D PSARD           S              6A                                                      209905
     D ACtr            S              3S 0                                                    209905
     D PFrontId1       S             20A                                                      209905
     D PFrontId2       S             20A                                                      209905
     D PAsocId         S             20A                                                      209905
     D PProtect        S              1A                                                      209905
                                                                                              209905
     ISW8OUTP
     I              IKRCID                      FIRCID
     I              IKDLTF                      FIDLTF
     I              IKDLUP                      FIDLUP
     I              IKMLUP                      FIMLUP
     I              IKYLUP                      FIYLUP
     I              IKTLUP                      FITLUP
     I              IKCHTP                      FICHTP
     I              IKLCD                       FILCD
     I              IKLUID                      FILUID
     I              IKPCDN                      FIPCDN
     I              IKDN38                      FIDN38
     I              IKDADN                      FIDADN
     I              IKBKCD                      FIBKCD
     I              IKCCY                       FICCY
     I              IKCYDP                      FICYDP
     I              IKVDYY                      FIVDYY
     I              IKVDMM                      FIVDMM
     I              IKVDDD                      FIVDDD
     I              IKDTYY                      FIDTYY
     I              IKDTMM                      FIDTMM
     I              IKDTDD                      FIDTDD
     I              IKDDLT                      FIDDLT
     I              IKDSTS                      FIDSTS
     I              IKMTYP                      FIMTYP
     I              IKRBSI                      FIRBSI
     I              IKTYPE                      FITYPE
     I              IKSTYP                      FISTYP
     I              IKCSNM                      FICSNM
     I              IKCNUM                      FICNUM
     I              IKAMNP                      FIAMNP
     I              IKINTR                      FIINTR
     I              IKBRCA                      FIBRCA
     I              IKDBRC                      FIDBRC
     I              IKDDYY                      FIDDYY
     I              IKDDMM                      FIDDMM
     I              IKDDDD                      FIDDDD
     I              IKBRKG                      FIBRKG
     I              IKBKCY                      FIBKCY
     I              IKBCDP                      FIBCDP
     I              IKFEDF                      FIFEDF
     I              IKCDRF                      FICDRF
     I              IKPCTN                      FIPCTN
     I              IKCDRP                      FICDRP
     I              IKLACT                      FILACT
     I              IKTIME                      FITIME
     I              IKDUSC                      FIDUSC
     I              IKAOFR                      FIAOFR
     I              IKLDAT                      FILDAT
     I              IKSLYY                      FISLYY
     I              IKSLMM                      FISLMM
     I              IKSLDD                      FISLDD
     I              IKROBY                      FIROBY
     I              IKSPRD                      FISPRD
     I              IKIIRT                      FIIIRT
     I              IKNIYY                      FINIYY
     I              IKNIMM                      FINIMM
     I              IKNIDD                      FINIDD
     I              IKIPFQ                      FIIPFQ
     I              IKICMT                      FIICMT
     I              IKIPDM                      FIIPDM
     I              IKCPTI                      FICPTI
     I              IKCNTI                      FICNTI
     I              IKACSQ                      FIACSQ
     I              IKNGVI                      FINGVI
     I              IKMTTI                      FIMTTI
     I              IKMTAX                      FIMTAX
     I              IKMCDH                      FIMCDH
     I              IKIAYY                      FIIAYY
     I              IKIAMM                      FIIAMM
     I              IKIADD                      FIIADD
     I              IKBSRC                      FIBSRC
     I              IKDBSR                      FIDBSR
     I              IKMDYY                      FIMDYY
     I              IKMDMM                      FIMDMM
     I              IKMDDD                      FIMDDD
     I              IKNTCE                      FINTCE
     I              IKFCLY                      FIFCLY
     I              IKIMAT                      FIIMAT
     I              IKBRAT                      FIBRAT
     I              IKMMDI                      FIMMDI
     I              IKDORM                      FIDORM
     I              IKORCM                      FIORCM
     I              IKDORI                      FIDORI
     I              IKMORI                      FIMORI
     I              IKDCPI                      FIDCPI
     I              IKMCPI                      FIMCPI
     I              IKDOPM                      FIDOPM
     I              IKMOPM                      FIMOPM
     I              IKDOPI                      FIDOPI
     I              IKMOPI                      FIMOPI
     I              IKDCRI                      FIDCRI
     I              IKMCRI                      FIMCRI
     I              IKDFAC                      FIDFAA
     I              IKMFAO                      FIMFAO
     I              IKSPEC                      FISPEC
     I              IKBOKC                      FIBOKC
     I              IKLNKN                      FILNKN
     I              IKDRID                      FIDRID
     I              IKDDMR                      FIDDMR
     I              IKDVSD                      FIDVSD
     I              IKDDND                      FIDDND
     I              IKNIPD                      FINIPD
     I              IKSLID                      FISLID
     I              IKMATD                      FIMATD
     I              IKRBAT                      FIRBAT
     I              IKRSTM                      FIRSTM
     I              IKRONS                      FIRONS
     I              IKRIBN                      FIRIBN
     I              IKRIBA                      FIRIBA
     I              IKROBN                      FIROBN
     I              IKROCN                      FIROCN
     I              IKPSTM                      FIPSTM
     I              IKPONS                      FIPONS
     I              IKPIBN                      FIPIBN
     I              IKPIBA                      FIPIBA
     I              IKPOBN                      FIPOBN
     I              IKPOCN                      FIPOCN
     I              IKRCRN                      FIRCRN
     I              IKRCRA                      FIRCRA
     I              IKRVNO                      FIRVNO
     I              IKAWBN                      FIAWBN
     I              IKAWBA                      FIAWBA
     I              IKBENN                      FIBENN
     I              IKBENA                      FIBENA
     I              IKDTP1                      FIDTP1
     I              IKDTP2                      FIDTP2
     I              IKDTP3                      FIDTP3
     I              IKDTP4                      FIDTP4
     I              IKDCHG                      FIDCHG
     I              IKBTB1                      FIBTB1
     I              IKBTB2                      FIBTB2
     I              IKBTB3                      FIBTB3
     I              IKBTB4                      FIBTB4
     I              IKBTB5                      FIBTB5
     I              IKBTB6                      FIBTB6
     I              IKORBR                      FIORBR
     I              IKPRFC                      FIPRFC
     I              IKPOBR                      FIPOBR
     I              IKROBR                      FIROBR
     I              IKCVMR                      FICVMR
     I              IKRDFC                      FIRDFC
     I              IKFLID                      FIFLID
     I              IKFUID                      FIFUID
     I              IKAURO                      FIAURO
     I              IKIPDS                      FIIPDS
     I              IKROFQ                      FIROFQ
     I              IKRLDN                      FIRLDN
     I              IKCNNA                      FICNNA
     I              IKIMET                      FIIMET
     I              IKINSA                      FIINSA
     I              IKINOS                      FIINOS
     I              IKWRPI                      FIWRPI
     I              IKPTFR                      FIPTFR
     I              IKFTST                      FIFTST
     I              IKFRN1                      FIFRN1
     I              IKFRN2                      FIFRN2
     I              IKFRN3                      FIFRN3
     I              IKFRN4                      FIFRN4
     I              IKFRNT                      FIFRNT                                        209905
     I              IKAFRT                      FIAFRT                                        209905
 
     IDEALSDCF                                                                  176659
     I              TRTP                        DCTRTP                          176659
     IDLCHISD0                                                                                229544
     I              TRTP                        DHTRTP                                        229544
      *****************************************************************
      *                                                               *
      *    Main Routine                                               *
      *                                                               *
      *****************************************************************
 
     C                   Exsr      #INIT
 
     C                   Exsr      #MAIN
 
     C                   Exsr      #TERM
 
      *****************************************************************
      *                                                               *
      * SR/#INIT : Initial Processing                                 *
      *                                                               *
      * Called By: Main Routine                                       *
      *                                                               *
      * Calls: *PSSR, Y2CLMSC, #HEADR, #FILS, #ENQY                   *
      *                                                               *
      *****************************************************************
 
     C     #INIT         BEGSR
 
      ** Entry List
 
     C     *ENTRY        PList
     C                   Parm                    ##MODE            1
     C                   Parm                    ##DLNO            6
     C                   Parm                    ##LNKN            6 0
     C**********         Parm                    ##CNUM            6 0                        CSD027
     C                   Parm                    ##CNUM            6                          CSD027
     C                   Parm                    ##CCY             3
     C                   Parm                    ##PCPL           15 0
     C                   Parm                    ##INTR           11 7
     C                   Parm                    ##DDAT            5 0
     C                   Parm                    ##VDAT            5 0
     C                   Parm                    ##MDAT            5 0
     C                   Parm                    ##NOTD            3 0
     C                   Parm                    ##DTYP            2
     C                   Parm                    ##DTST            2
     C                   Parm                    ##BRCA            3
     C                   Parm                    PDDNTCE           3
     C                   Parm                    PDDMDAT           6
     C                   Parm                    @SLDS
     C                   Parm                    Inv_FIDT                                     209905
     C                   Parm                    PFrontId1                                    209905
     C                   Parm                    PFrontId2                                    209905
     C                   Parm                    PAsocId                                      209905
     C                   Parm                    PProtect                                     209905
     C                   Parm                    ##RTCD            7
     C                   Parm                    ##TRAS            1
     C                   Parm                    ##NAR1           60
     C                   Parm                    ##NAR2           60
     C                   Parm                    ##NAR3           60
     C                   Parm                    ##NAR4           60
 
      ** Define KLIST to access PMPORTLL
 
     C     WWPORT        KList
     C**********         KFld                    KFCNUM            6 0                        CSD027
     C                   KFld                    KFCNUM            6                          CSD027
     C                   KFld                    KFPTFR            4
 
      ** Define KLIST to access ACCNT
 
     C     WWACCT        KList
     C**********         KFld                    XXCNUM            6 0                        CSD027
     C                   KFld                    XXCNUM            6                          CSD027
     C                   KFld                    DDCCY
     C**********         KFld                    XXACOD            4 0                        CGL029
     C                   KFld                    XXACOD           10 0                        CGL029
     C                   KFld                    XXACSQ            2 0
     C                   KFld                    ##BRCA
 
      ** If deal type is FL allow 100 lines. If DP or LP only one line
 
     C     ##DTYP        IfEq      'FL'
     C                   Z-Add     101           WWFIL             3 0
     C                   Move      *On           *IN51
     C                   Move      *Off          *IN52
     C                   Else
     C                   Z-Add     2             WWFIL
     C                   Move      *On           *IN52
     C                   Move      *Off          *IN51
     C                   EndIf
 
      ** Bank Details
 
     C                   CallB     'AOBANKR0'
     C                   Parm      '*DBERR '     @RTCD
     C                   Parm      '*FIRST '     @OPTN
     C     SDBANK        Parm      SDBANK        DSFDY
 
     C     @RTCD         IfNe      *BLANKS
     C     *LOCK         In        LDA
     C                   Move      *On           *INU7
     C                   Move      *On           *INU8
     C                   Z-Add     001           DBase                          ************
     C                   MoveL     'SDBANKPD'    DBFile                         * DBERR 01 *
     C                   MoveL     '*FIRST'      DBKey                          ************
     C                   Out       LDA
     C                   Exsr      *PSSR
     C                   EndIf
 
      ** Set indicator *IN98 to indicate which date format to use
 
     C     BJDFIN        IfEq      'M'
     C                   Move      *On           *IN98
     C                   EndIf
 
      ** Modules Details
 
     C                   CallB     'AOMMODR0'
     C                   Parm      '*DBERR '     @RTCD
     C                   Parm      '*FIRST '     @OPTN
     C     SDMMOD        Parm      SDMMOD        DSFDY
 
     C     @RTCD         IfNe      *BLANKS
     C     *LOCK         In        LDA
     C                   Move      *On           *INU7
     C                   Move      *On           *INU8
     C                   Z-Add     002           DBase                          ************
     C                   MoveL     'SDMMODPD'    DBFile                         * DBERR 02 *
     C                   MoveL     '*FIRST'      DBKey                          ************
     C                   Out       LDA
     C                   Exsr      *PSSR
     C                   EndIf
 
     C     BGPFMG        IfEq      'Y'
     C                   Move      *Off          *IN81
     C                   Else
     C                   Move      *On           *IN81
     C                   EndIf
 
      ** ICD Dealing
 
     C**********         CallB     'AODEALR0'                                                 CGL029
     C                   CALLB     'AODEALR1'                                                 CGL029
     C                   Parm      '*DBERR '     @RTCD
     C                   Parm      '*FIRST '     @OPTN
     C*****SDDEAL        Parm      SDDEAL        DSFDY                                        CGL029
     C     SDDEAL        PARM      SDDEAL        DSSDY                                        CGL029
 
     C     @RTCD         IfNe      *BLANKS
     C     *LOCK         In        LDA
     C                   Move      *On           *INU7
     C                   Move      *On           *INU8
     C                   Z-Add     003           DBase                          ************
     C                   MoveL     'SDDEALPD'    DBFile                         * DBERR 03 *
     C                   MoveL     '*FIRST'      DBKey                          ************
     C                   Out       LDA
     C                   Exsr      *PSSR
     C                   EndIf
 
      ** ICD Retail
 
     C                   CallB     'AORETLR0'
     C                   Parm      '*DBERR '     @RTCD
     C                   Parm      '*FIRST '     @OPTN
     C     SDRETL        Parm      SDRETL        DSFDY
 
     C     @RTCD         IfNe      *BLANKS
     C     *LOCK         In        LDA
     C                   Move      *On           *INU7
     C                   Move      *On           *INU8
     C                   Z-Add     004           DBase                          ************
     C                   Movel     'SDRETLPD'    DBFile                         * DBERR 04 *
     C                   Movel     '*FIRST'      DBKey                          ************
     C                   Out       LDA
     C                   Exsr      *PSSR
     C                   EndIf
 
      ** ICD Portfolio
 
     C     BGPFMG        IfEq      'Y'
     C                   CallB     'AOPORTR0'
     C                   Parm      '*DBERR '     @RTCD
     C                   Parm      '*FIRST '     @OPTN
     C     SDPORT        Parm      SDPORT        DSFDY
 
     C     @RTCD         IfNe      *BLANKS
     C     *LOCK         In        LDA
     C                   Move      *On           *INU7
     C                   Move      *On           *INU8
     C                   Z-Add     005           DBase                          ************
     C                   MoveL     'SDPORTPD'    DBFile                         * DBERR 05 *
     C                   MoveL     '*FIRST'      DBKey                          ************
     C                   Out       LDA
     C                   Exsr      *PSSR
     C                   EndIf
     C                   EndIf
 
      ** Retrieve Deal Numbers Record
 
     C     1             Chain     FDDLNMLL                           60
 
     C     *IN60         IfEq      *On
     C     NODLTF        OrEq      '*'
     C     *LOCK         In        LDA
     C                   Move      *On           *INU7
     C                   Move      *On           *INU8
     C                   Z-Add     006           DBase                          ************
     C                   MoveL     'FDDLNMLL'    DBFile                         * DBERR 06 *
     C                   MoveL     '*FIRST'      DBKey                          ************
     C                   Out       LDA
     C                   Exsr      *PSSR
     C                   EndIf
 
      ** A Trust Agrement Status must be input for deal type 'DT'/'LT'
      ** and when feature 'fiduciary loans' is on and for fiduciary
      ** loan deal.
 
     C     ##DTYP        IfEq      'DP'
     C     ##DTYP        OrEq      'LP'
 
      ** Feature Fiduciary Loan
 
     C                   CallB     'AOSARDR0'
     C                   Parm      *BLANKS       @RTCD
     C                   Parm      '*VERIFY'     @OPTN
     C                   Parm      'CDL006'      @SARD
     C     SCSARD        Parm      SCSARD        DSFDY
 
      ** If feature is installed
 
     C     @RTCD         IfEq      *BLANKS
     C                   Move      *On           *IN67
     C                   EndIf
     C                   EndIf
                                                                                              209905
      ** Check if CDL006 is installed                                                         209905
                                                                                              209905
     C                   CALL      'AOSARDR0'                                                 209905
     C                   PARM      *BLANKS       PRTCD                                        209905
     C                   PARM      '*VERIFY'     POPTN                                        209905
     C                   PARM      'CDL006'      PSARD                                        209905
     C     SCSARD        PARM      SCSARD        DSFDY                                        209905
                                                                                              209905
     C                   IF        PRTCD = *BLANKS                                            209905
     C                   EVAL      CDL006 = 'Y'                                               209905
     C                   ELSE                                                                 209905
     C                   EVAL      CDL006 = 'N'                                               209905
                                                                                              209905
     C                   IF        PRTCD <> '*NRF'                                            209905
     C     *LOCK         IN        LDA                                                        209905
     C                   EVAL      DBKEY = 'CDL006'                                           209905
     C                   EVAL      DBFILE = 'SCSARDPD'                                        209905
     C                   EVAL      DBASE = 10                                                 209905
     C                   OUT       LDA                                                        209905
     C                   EXSR      *PSSR                                                      209905
     C                   ENDIF                                                                209905
                                                                                              209905
     C                   ENDIF                                                                209905
 
     C                   Move      'Y'           WFIRST            1
 
      ** Clear SFL
 
     C     *IN51         IfEq      *On
     C                   Z-Add     1             WWRRN
     C                   Move      *On           *IN61
     C                   Write     MMFIDDC1
     C                   Move      *Off          *IN61
     C                   Else
     C                   Z-Add     1             WWRRN3
     C                   Move      *On           *IN63
     C                   Write     MMFIDDC3
     C                   Move      *Off          *IN63
     C                   EndIf
 
      ** Select the program MSGQ for error msg.
 
     C                   MoveL     '*'           TOPQ
     C                   MoveL     '*PRV'        TOPRQ
     C                   MoveL     '*'           DDPGMQ
     C                   MoveL     'DRSMM'       PMSGF            10
      *
      ** Fill in fields for subroutine ZASNMS
      *
     C                   MoveL     'MMFIDTSFL'   ZAPGM            10
     C                   MoveL     'DRSMM'       ZAMSGF           10
     C                   MoveL     *BLANK        ZAPGRL            5
     C                   MoveL     *BLANK        ZAMSID            7
     C                   MoveL     *BLANK        ZAMSDA          132
     C                   MoveL     *BLANK        ZAMSTP            7
 
      ** Initialise program message queue
 
     C                   Call      'Y2CLMSC'
     C                   Parm                    TOPQ             10
     C                   Parm                    TOPRQ             5
 
      ** Setup Screen Headings
 
     C                   Exsr      #HEADR
 
      ** Setup SFL
 
     C     ##MODE        IfEq      'I'
     C                   Exsr      #FILS
     C                   Else
     C                   Exsr      #ENQY
     C                   EndIf
 
      ** Read only to allow rename of fields
 
     C                   Read      SW8OUTP                                90
 
     C                   ENDSR
 
      *****************************************************************
      *                                                               *
      * SR/#MAIN : Main Processing                                    *
      *                                                               *
      * Called By: Main Routine                                       *
      *                                                               *
      * Calls: Y2CLMSC, #TERM, #PREV, ENT1                            *
      *                                                               *
      *****************************************************************
 
     C     #MAIN         BEGSR
 
     C     *INLR         DoWEq     *Off
 
     C                   Write     MMFIDDF1
     C                   Write     MMFIDDC0
 
     C     *IN51         IfEq      *On
     C                   Exfmt     MMFIDDC1
     C                   EndIf
     C     *IN52         IfEq      *On
     C                   Exfmt     MMFIDDC3
     C                   EndIf
 
      ** Initialise program message queue
 
     C                   Call      'Y2CLMSC'
     C                   Parm                    TOPQ
     C                   Parm                    TOPRQ
 
     C                   Select
     C                   When      *IN51 and *IN03
     C                   Exsr      #TERM
     C                   When      *IN51 and *IN12
     C                   Exsr      #PREV
     C                   When      *IN51
     C                   Exsr      #ENT1
     C                   When      *IN52 and *IN03
     C                   Exsr      #TERM
     C                   When      *IN52 and *IN12
     C                   Exsr      #PREV
     C                   When      *IN52
     C                   Exsr      #ENT1
     C                   ENDSL
 
     C                   EndDo
 
     C                   ENDSR
 
      *****************************************************************
      *                                                               *
      * SR/#ENT1 : Enter On Screen                                    *
      *                                                               *
      * Called By: #MAIN                                              *
      *                                                               *
      * Calls: #SETP, #DLNO, #CNUM, #PTFR, #AMNT, #ACOD, #ACSQ, #TRAS,*
      *        ZSEDIT, ZASNMS, #PROT, #UPDT                           *
      *                                                               *
      *****************************************************************
 
     C     #ENT1         BEGSR
 
      ** Setup Error Indicator
 
     C                   Exsr      #SETP
 
     C     ##MODE        IfEq      'I'
     C     WFIRST        IfEq      'Y'
 
      ** Read SFL
 
     C                   Z-Add     *ZEROS        WWTNM            15 0
 
     C     *IN51         IfEq      *On
     C                   Z-Add     1             WWRRN
     C                   Z-Add     WWRRN         WWCUR             4 0
     C                   EndIf
     C     *IN52         IfEq      *On
     C                   Z-Add     1             WWRRN3
     C                   Z-Add     WWRRN3        WWCUR
     C                   EndIf
 
      ** Initialize array and index that will contain all valid deal
      ** numbers.
 
     C                   Z-ADD     0             X
     C                   CLEAR                   ARRDLNO
 
     C     WWCUR         DoWLt     WWFIL
 
     C     *IN51         IfEq      *On
     C     WWRRN         Chain     MMFIDDS1                           82
     C                   EndIf
     C     *IN52         IfEq      *On
     C     WWRRN3        Chain     MMFIDDS3                           82
     C                   EndIf
 
     C     SFDLNO        IfEq      *BLANKS
     C     SFCNUM        AndEq     *BLANKS
     C     SFPTFR        AndEq     *BLANKS
     C     SFAMNT        AndEq     *BLANKS
     C     SFACOD        AndEq     *BLANKS
     C     SFACSQ        AndEq     *BLANKS
     C     SFTRAS        AndEq     *BLANKS
     C                   Move      *Off          *IN74
     C                   Move      *Off          *IN76
     C                   Move      *Off          *IN77
     C                   Move      *Off          *IN78
     C                   Move      *Off          *IN79
     C                   Move      *Off          *IN80
 
     C     *IN67         IfEq      *On
     C                   Move      *Off          *IN87
     C                   EndIf
 
      ** Update Flag to indicate which records will be outputed in database
 
     C                   MoveL     *BLANKS       SHFLAG
 
     C     *IN51         IfEq      *On
     C                   Update    MMFIDDS1
     C                   Add       1             WWRRN
     C                   Z-Add     WWRRN         WWCUR
     C                   EndIf
     C     *IN52         IfEq      *On
     C                   Update    MMFIDDS3
     C                   Add       1             WWRRN3
     C                   Z-Add     WWRRN3        WWCUR
     C                   EndIf
 
     C                   Else
 
     C                   Move      *BLANKS       SHDLER
     C                   Move      *BLANKS       SHCNER
     C                   Move      *BLANKS       SHPOER
     C                   Move      *BLANKS       SHAMER
     C                   Move      *BLANKS       SHACER
     C                   Move      *BLANKS       SHSQER
 
     C     *IN52         IfEq      *On
     C                   Move      *BLANKS       SHTAER
     C                   EndIf
 
      ** At least one record processed
 
     C                   Move      *On           *IN86
 
      ** Validation Deal Number
 
     C                   Exsr      #DLNO
     C     *IN74         IfEq      *On
     C                   Move      'E'           SHDLER
     C                   EndIf
 
      ** Validation Customer Number
 
     C                   Exsr      #CNUM
     C     *IN76         IfEq      *On
     C                   Move      'E'           SHCNER
     C                   EndIf
 
      ** Validation Portfolio Reference
 
     C                   Exsr      #PTFR
     C     *IN77         IfEq      *On
     C                   Move      'E'           SHPOER
     C                   EndIf
 
      ** Validation Amount
 
     C                   Exsr      #AMNT
     C     *IN78         IfEq      *On
     C                   Move      'E'           SHAMER
     C                   EndIf
 
      ** Validation Account Code
 
     C                   Exsr      #ACOD
     C     *IN79         IfEq      *On
     C                   Move      'E'           SHACER
     C                   EndIf
 
      ** Validation Account Sequence
 
     C                   Exsr      #ACSQ
     C     *IN79         IfEq      *On
     C     *IN80         AndEq     *On
     C                   Move      'B'           SHSQER
     C                   EndIf
     C     *IN79         IfEq      *Off
     C     *IN80         AndEq     *On
     C                   Move      'E'           SHSQER
     C                   EndIf
 
      ** If fiduciary loan
 
     C     *IN67         IfEq      *On
 
      ** Validation Trust agreement status
 
     C                   Exsr      #TRAS
     C     *IN87         IfEq      *On
     C                   Move      'E'           SHTAER
     C                   EndIf
 
     C                   EndIf
 
      ** Update Flag to indicate which records will be outputed in database
 
     C                   MoveL     'D'           SHFLAG
 
     C     *IN51         IfEq      *On
     C                   Update    MMFIDDS1
     C                   Add       1             WWRRN
     C                   Z-Add     WWRRN         WWCUR
     C                   Z-Add     WWRRN         WWSAVE            4 0
     C                   EndIf
     C     *IN52         IfEq      *On
     C                   Update    MMFIDDS3
     C                   Add       1             WWRRN3
     C                   Z-Add     WWRRN3        WWCUR
     C                   Z-Add     WWRRN3        WWSAVE
     C                   EndIf
 
     C                   EndIf
     C                   EndDo
 
     C     *IN51         IfEq      *On
     C                   Z-Add     1             WWRRN
     C                   EndIf
     C     *IN52         IfEq      *On
     C                   Z-Add     1             WWRRN3
     C                   EndIf
 
      ** Total amounts of takings deals must match the placing deal amount
 
     C     WWTNM         IfNe      ##PCPL
 
     C     *IN51         IfEq      *On
     C                   Z-Add     1             WWRRN
     C                   Z-Add     WWRRN         WWCUR
     C                   EndIf
     C     *IN52         IfEq      *On
     C                   Z-Add     1             WWRRN3
     C                   Z-Add     WWRRN3        WWCUR
     C                   EndIf
 
     C     WWCUR         DoWLt     WWFIL
 
     C     *IN51         IfEq      *On
     C     WWRRN         Chain     MMFIDDS1                           82
     C                   EndIf
     C     *IN52         IfEq      *On
     C     WWRRN3        Chain     MMFIDDS3                           82
     C                   EndIf
 
     C     SHFLAG        IfEq      'D'
     C                   Move      *On           *IN75
     C                   Move      *On           *IN78
     C     SHDLER        IfEq      'E'
     C                   Move      *On           *IN74
     C                   EndIf
     C     SHCNER        IfEq      'E'
     C                   Move      *On           *IN76
     C                   EndIf
     C     SHPOER        IfEq      'E'
     C                   Move      *On           *IN77
     C                   EndIf
     C     SHAMER        IfEq      'E'
     C                   Move      *On           *IN78
     C                   EndIf
     C     SHACER        IfEq      'E'
     C                   Move      *On           *IN79
     C                   EndIf
     C     SHSQER        IfEq      'E'
     C                   Move      *On           *IN80
     C                   EndIf
     C     SHSQER        IfEq      'B'
     C                   Move      *On           *IN80
     C                   Move      *On           *IN79
     C                   EndIf
     C     SHTAER        IfEq      'E'
     C                   Move      *On           *IN87
     C                   EndIf
 
     C     *IN51         IfEq      *On
     C                   Update    MMFIDDS1
     C                   EndIf
     C     *IN52         IfEq      *On
     C                   Update    MMFIDDS3
     C                   EndIf
 
     C                   EndIf
 
     C     *IN51         IfEq      *On
     C                   Add       1             WWRRN
     C                   Z-Add     WWRRN         WWCUR
     C                   EndIf
     C     *IN52         IfEq      *On
     C                   Add       1             WWRRN3
     C                   Z-Add     WWRRN3        WWCUR
     C                   EndIf
 
     C                   EndDo
 
     C     *IN75         IfEq      *On
     C     *IN78         AndEq     *On
 
     C                   MoveL     *BLANKS       ZAMSDA
     C                   Move      *BLANKS       ZFLD15
 
     C                   CallB     'ZSEDIT'
     C                   Parm      WWTNM         ZFLD15
     C                   Parm      ZCDP          ZDECS
     C                   Parm      *BLANKS       ZECODE
     C                   Parm                    ZOUT21
 
     C                   MoveL     ZOUT21        ZAMSDA
     C                   MoveL     'MMA0579'     ZAMSID
     C                   Exsr      ZASNMS
     C                   EndIf
 
     C     WWSAVE        IfEq      *ZEROS
     C                   Z-Add     1             WWSAVE
     C                   EndIf
 
     C     *IN51         IfEq      *On
     C                   Z-Add     WWSAVE        WWRRN
     C                   EndIf
     C     *IN52         IfEq      *On
     C                   Z-Add     1             WWRRN3
     C                   EndIf
 
     C                   EndIf
 
      ** If no error and at least one record redisplay and protect fields
 
     C     *IN75         IfEq      *Off
     C     *IN86         AndEq     *On
     C                   Exsr      #PROT
     C                   Move      *On           *IN83
     C                   Move      *On           *IN85
     C                   Move      'N'           WFIRST
     C                   EndIf
 
     C                   Else
     C                   Exsr      #UPDT
     C                   EndIf
 
     C                   Else
 
      ** Return to MMLDNISIN
 
     C                   Move      *On           *INLR
     C                   Move      *Off          *IN51
     C                   Move      *Off          *IN52
     C                   EndIf
 
     C                   ENDSR
 
      *****************************************************************
      *                                                               *
      * SR/#SETP : Initialise Indicators                              *
      *                                                               *
      * Called By: #ENT1                                              *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     #SETP         BEGSR
 
     C                   Move      *Off          *IN75
     C                   Move      *Off          *IN74
     C                   Move      *Off          *IN76
     C                   Move      *Off          *IN77
     C                   Move      *Off          *IN78
     C                   Move      *Off          *IN79
     C                   Move      *Off          *IN80
 
     C     *IN67         IfEq      *On
     C                   Move      *Off          *IN87
     C                   EndIf
 
     C                   Move      *Off          *IN85
     C                   Move      *Off          *IN86
 
     C                   ENDSR
 
      *****************************************************************
      *                                                               *
      * SR/#DLNO : Validate Deal Number                               *
      *                                                               *
      * Called By: #ENT1                                              *
      *                                                               *
      * Calls: ZASNMS                                                 *
      *                                                               *
      *****************************************************************
 
     C     #DLNO         BEGSR
 
     C                   Select
     C     SFDLNO        WhenNe    *BLANKS
 
      ** Test if deal entered is numeric
 
     C                   TestN                   SFDLNO               62
     C                   Move      SFDLNO        WTEST             1
     C                   TestZ                   WTEST                    73
 
     C     SFDLNO        IfNe      *BLANKS
     C     *IN62         AndEq     *Off
     C     SFDLNO        OrNe      *BLANKS
     C     *IN73         AndEq     *Off
     C                   Move      *On           *IN74
     C                   Move      *On           *IN75
     C                   MoveL     'MMA0568'     ZAMSID
     C                   MoveL     *BLANKS       ZAMSDA
     C                   Exsr      ZASNMS
     C                   Else
 
     C                   Move      SFDLNO        WWDLNO            6 0
     C     WWDLNO        Chain     MMWFIDDL0                          90
 
     C     *IN90         IfEq      *Off
     C                   Move      *On           *IN74
     C                   Move      *On           *IN75
     C                   MoveL     'MMA0569'     ZAMSID
     C                   MoveL     *BLANKS       ZAMSDA
     C                   Exsr      ZASNMS
     C                   Else
 
     C     WWDLNO        SetLL     DEALSALL                               65
 
     C     *IN65         IfEq      *On
     C                   Move      *On           *IN74
     C                   Move      *On           *IN75
     C                   MoveL     'MMA0569'     ZAMSID
     C                   MoveL     *BLANKS       ZAMSDA
     C                   Exsr      ZASNMS
     C                   Else
 
      ** Check that the deal number is in the allowed range.
 
     C     WWDLNO        IfLt      NORDLN
     C     WWDLNO        OrEq      999999
     C                   Move      *On           *IN74
     C                   Move      *On           *IN75
     C                   MoveL     'MMA0570'     ZAMSID
     C                   MoveL     *BLANKS       ZAMSDA
     C                   Exsr      ZASNMS
     C                   Else
 
      ** Deal number cannot be equal
 
     C     SFDLNO        IfEq      DDDLNO
     C                   Move      *On           *IN74
     C                   Move      *On           *IN75
     C                   MoveL     'MMA0582'     ZAMSID
     C                   MoveL     *BLANKS       ZAMSDA
     C                   Exsr      ZASNMS
     C                   EndIf
 
     C                   EndIf
     C                   EndIf
     C                   EndIf
     C                   EndIf
 
      ** Copy deal number to the array after passing the validation
 
     C     *IN74         IFEQ      *OFF
     C     *IN75         ANDEQ     *OFF
     C     SFDLNO        LOOKUP    ARRDLNO                                65
     C     *IN65         IFEQ      *ON
     C                   MOVE      *ON           *IN74
     C                   MOVE      *ON           *IN75
     C                   MOVEL     'MMA0569'     ZAMSID
     C                   MOVEL     *BLANKS       ZAMSDA
     C                   EXSR      ZASNMS
     C                   ELSE
     C                   ADD       1             X
     C                   MOVEA     SFDLNO        ARRDLNO(X)
     C                   ENDIF
     C                   ENDIF
 
     C     SFDLNO        WhenEq    *BLANKS
 
      ** Automatic generation is done in MMFIDTUPF
 
     C                   ENDSL
 
     C                   ENDSR
 
      *****************************************************************
      *                                                               *
      * SR/#CNUM : Validate Customer Number                           *
      *                                                               *
      * Called By: #ENT1                                              *
      *                                                               *
      * Calls: ZASNMS, MMVCUSTFID                                     *
      *                                                               *
      *****************************************************************
 
     C     #CNUM         BEGSR
 
      ** Must be a valid Customer Number
 
     C                   CallB     'AOCUSTR1'
     C                   Parm      *BLANKS       @RTCD
     C                   Parm      '*KEY   '     @OPTN
     C                   Parm      SFCNUM        @KEY1
     C                   Parm      *BLANKS       @KYST
     C     SDCUST        Parm      SDCUST        DSLDY
 
     C     @RTCD         IfNe      *BLANKS
     C                   Move      *On           *IN76
     C                   Move      *On           *IN75
     C                   MoveL     'MMA0571'     ZAMSID
     C                   MoveL     *BLANKS       ZAMSDA
     C                   Exsr      ZASNMS
     C                   Else
 
      ** Validate Customer
 
     C                   SELECT
     C     ##DTYP        WHENEQ    'FL'
     C                   MOVE      'FT'          PDealType
     C     ##DTYP        WHENEQ    'DP'
     C                   MOVE      'DT'          PDealType
     C     ##DTYP        WHENEQ    'LP'
     C                   MOVE      'LT'          PDealType
     C                   ENDSL
 
     C**********         Move      BBCUST        PCustNo           6 0                        CSD027
     C                   Move      BBCUST        PCustNo           6                          CSD027
 
     C                   CallB     'MMVCUSTFID'
     C                   Parm                    PDealType         2
     C                   Parm                    PCustNo
     C                   Parm                    SDCUST
     C**********         Parm                    PReturnCode       7                          209905
     C**********         Parm                    PErrMsgID1        7                          209905
     C**********         Parm                    PErrMsgID2        7                          209905
     C                   Parm      *BLANKS       PReturnCode       7                          209905
     C                   Parm      *BLANKS       PErrMsgID1        7                          209905
     C                   Parm      *BLANKS       PErrMsgID2        7                          209905
     C                   Parm                    PWMsgID1          7
 
     C     PReturnCode   IfNe      *BLANKS
     C                   Move      *On           *IN76
     C                   Move      *On           *IN75
     C                   IF        PErrMsgID1 <> *blanks                                      209905
     C                   MoveL     PErrMsgID1    ZAMSID
     C                   ELSE                                                                 209905
     C                   MoveL     PErrMsgID2    ZAMSID                                       209905
     C                   ENDIF                                                                209905
     C                   MoveL     *BLANKS       ZAMSDA
     C                   Exsr      ZASNMS
     C                   EndIf
     C                   EndIf
 
     C                   Move      BBCUST        SHCNUM
     C                   Move      BBCSSN        SHCSSN
 
     C                   ENDSR
 
      *****************************************************************
      *                                                               *
      * SR/#PTFR : Validate Portfolio Reference                       *
      *                                                               *
      * Called By: #ENT1                                              *
      *                                                               *
      * Calls: ZASNMS                                                 *
      *                                                               *
      *****************************************************************
 
     C     #PTFR         BEGSR
 
      ** Validate only if PM is on otherwise field is not shown
 
     C     BGPFMG        IfEq      'Y'
 
     C                   CallB     'AOPLCSR0'
     C                   Parm      '        '    @RTCD
     C                   Parm      '*KEY    '    @OPTN
     C                   Parm      SFCNUM        @KEY1
     C     SDPLCS        Parm      SDPLCS        DSSDY
 
      ** If Customer not found it must be blanks
 
     C     @RTCD         IfNe      *BLANKS
 
     C     SFPTFR        IfNe      *BLANKS
     C                   Move      *On           *IN77
     C                   Move      *On           *IN75
     C                   MoveL     'MMA0572'     ZAMSID
     C                   MoveL     *BLANKS       ZAMSDA
     C                   Exsr      ZASNMS
     C                   EndIf
 
     C                   Else
     C                   Move      *On           *IN82
 
      ** If reference is not blanks, it must be a valid portfolio
 
     C     SFPTFR        IfNe      *BLANKS
 
     C     SFPTFR        IfNe      FCR997
     C                   Move      BBCUST        KFCNUM
     C                   MoveL     SFPTFR        KFPTFR
     C     WWPORT        Chain     PMPORTLL                           90
 
     C     *IN90         IfEq      *On
     C                   Move      *On           *IN77
     C                   Move      *On           *IN75
     C                   MoveL     'MMA0573'     ZAMSID
     C                   MoveL     *BLANKS       ZAMSDA
     C                   Exsr      ZASNMS
     C                   EndIf
 
     C                   EndIf
 
      ** If portfolio reference is blanks, retrieve the first reference for
      ** this customer on PMPORTPD or setup with SDPORTPD
 
     C                   Else
 
     C**********         Move      BBCUST        ZZCNUM            6 0                        CSD027
     C                   Move      BBCUST        ZZCNUM            6                          CSD027
     C     ZZCNUM        Chain     PMPORTLL                           90
 
     C     *IN90         IfEq      *On
     C                   MoveL     FCR997        SFPTFR
     C                   Else
     C                   MoveL     PNPTFR        SFPTFR
     C                   EndIf
 
     C                   EndIf
     C                   EndIf
     C                   EndIf
 
     C                   ENDSR
 
      *****************************************************************
      *                                                               *
      * SR/#AMNT : Validate Amount                                    *
      *                                                               *
      * Called By: #ENT1                                              *
      *                                                               *
      * Calls: ZASNMS, ZALIGN                                         *
      *                                                               *
      *****************************************************************
 
     C     #AMNT         BEGSR
 
      ** Validate and align Amount
 
     C     SFAMNT        IfEq      *BLANKS
     C                   Move      *On           *IN78
     C                   Move      *On           *IN75
     C                   MoveL     'MMA0574'     ZAMSID
     C                   MoveL     *BLANKS       ZAMSDA
     C                   Exsr      ZASNMS
     C                   Else
 
     C                   Move      *BLANKS       ZFIELD
 
     C                   CallB     'ZALIGN'
     C                   Parm                    ZALIGNOK          1
     C                   Parm      SFAMNT        ZFIELD           16
     C                   Parm      ZCDP          ZADEC             1 0
     C                   Parm      12            ZADIG             2 0
 
     C     ZALIGNOK      IfEq      'N'
     C                   Move      *On           *IN78
     C                   Move      *On           *IN75
     C                   MoveL     'MMA0574'     ZAMSID
     C                   MoveL     *BLANKS       ZAMSDA
     C                   Exsr      ZASNMS
     C                   Else
 
     C                   Move      ZFIELD        SHAMNT
     C     SHAMNT        IfLt      *ZEROS
     C                   Z-Sub     SHAMNT        SHAMNT
     C                   EndIf
 
     C                   Move      ZFIELD        WWTMP            15 0
     C     WWTMP         Add       WWTNM         WWTNM
     C                   EndIf
 
     C                   EndIf
 
     C                   ENDSR
 
      *****************************************************************
      *                                                               *
      * SR/#ACOD : Validate Account Code                              *
      *                                                               *
      * Called By: #ENT1                                              *
      *                                                               *
      * Calls: ZASNMS                                                 *
      *                                                               *
      *****************************************************************
 
     C     #ACOD         BEGSR
 
      ** If blanks, default to account code on SDCUSTPD else must be on
      ** SDACODPD
 
     C     SFACOD        IfEq      *BLANKS
 
     C     BBDFAC        IfNe      0
     C                   Move      BBDFAC        SFACOD
     C                   EndIf
     C                   Else
 
     C                   Call      'AOACODR0'
     C                   Parm      *BLANKS       @RTCD
     C                   Parm      '*KEY   '     @OPTN
     C                   Parm      SFACOD        @KEY1
     C     SDACOD        Parm      SDACOD        DSSDY
 
     C     @RTCD         IfNe      *BLANKS
     C                   Move      *On           *IN79
     C                   Move      *On           *IN75
     C                   MoveL     'MMA0575'     ZAMSID
     C                   MoveL     *BLANKS       ZAMSDA
     C                   Exsr      ZASNMS
     C                   EndIf
 
     C                   EndIf
 
     C                   ENDSR
 
      *****************************************************************
      *                                                               *
      * SR/#ACSQ : Validate Account Sequence                          *
      *                                                               *
      * Called By: #ENT1                                              *
      *                                                               *
      * Calls: ZASNMS, ZALIGN                                         *
      *                                                               *
      *****************************************************************
 
     C     #ACSQ         BEGSR
 
      ** If blanks, default to account code on SDCUSTPD else must be a
      ** live account
 
     C     SFACSQ        IfEq      *BLANKS
 
     C     BBDFAS        IfNe      0
     C                   Move      BBDFAS        SFACSQ
     C                   EndIf
 
      ** Must be a live account
 
     C                   MOVE      BBCUST        XXCNUM
     C                   MOVE      SFACOD        XXACOD
     C                   MOVE      SFACSQ        XXACSQ
 
     C     WWACCT        Chain     ACCNT                              90
 
     C     *IN90         IfEq      *On
     C     RECI          OrEq      'C'
     C                   Move      *On           *IN80
     C                   Move      *On           *IN79
     C                   Move      *On           *IN75
     C                   MoveL     'MMA0577'     ZAMSID
     C                   MoveL     *BLANKS       ZAMSDA
     C                   Exsr      ZASNMS
     C                   EndIf
 
     C                   Else
 
     C                   Move      *BLANKS       ZFIELD
 
     C                   CallB     'ZALIGN'
     C                   Parm                    ZALIGNOK
     C                   Parm      SFACSQ        ZFIELD
     C                   Parm      *ZEROS        ZADEC
     C                   Parm      2             ZADIG
 
     C     ZALIGNOK      IfEq      'N'
     C                   Move      *On           *IN80
     C                   Move      *On           *IN75
     C                   MoveL     'MMA0576'     ZAMSID
     C                   MoveL     *BLANKS       ZAMSDA
     C                   Exsr      ZASNMS
     C                   Else
 
      ** Must be a live account
 
     C                   Move      BBCUST        XXCNUM
     C                   Move      SFACOD        XXACOD
     C                   Move      SFACSQ        XXACSQ
 
     C     WWACCT        Chain     ACCNT                              90
     C     *IN90         IfEq      *On
     C     RECI          OrEq      'C'
     C                   Move      *On           *IN80
     C                   Move      *On           *IN79
     C                   Move      *On           *IN75
     C                   MoveL     'MMA0577'     ZAMSID
     C                   MoveL     *BLANKS       ZAMSDA
     C                   Exsr      ZASNMS
     C                   Else
 
      ** PM must be on and Customer must be a portfolio customer
 
     C     PTFR          IfEq      '9997'
     C                   Move      FCR997        WWPTFR            4
     C                   Else
     C                   Move      PTFR          WWPTFR
     C                   EndIf
 
     C     BGPFMG        IfEq      'Y'
     C     *IN82         AndEq     *On
     C     WWPTFR        AndNe     SFPTFR
     C                   Move      *On           *IN80
     C                   Move      *On           *IN77
     C                   Move      *On           *IN75
     C                   MoveL     'MMA0578'     ZAMSID
     C                   MoveL     *BLANKS       ZAMSDA
     C                   Exsr      ZASNMS
     C                   EndIf
 
     C                   EndIf
     C                   EndIf
 
     C                   EndIf
 
     C                   ENDSR
 
      *****************************************************************
      *                                                               *
      * SR/#TRAS : Validate Trust Agreement Status                    *
      *                                                               *
      * Called By: #ENT1                                              *
      *                                                               *
      * Calls: MMFIDTSTS, #TERM, *PSSR                                *
      *                                                               *
      *****************************************************************
 
     C     #TRAS         BEGSR
 
     C     ##DTYP        IfEq      'LP'
                                                                                              209905
      ** Only blank out screen fields when called from MMLDNISIN                              209905
                                                                                              209905
     C                   IF        PFrontId1 = *BLANK                                         209905
     C                   Move      *BLANKS       ##TRAS
     C                   Move      *BLANKS       ##NAR1
     C                   Move      *BLANKS       ##NAR2
     C                   Move      *BLANKS       ##NAR3
     C                   Move      *BLANKS       ##NAR4
     C                   ENDIF                                                                209905
 
     C                   Move      SFDLNO        WDLNO             6 0
     C**********         Move      BBCUST        WCUST             6 0                        CSD027
     C                   Move      BBCUST        WCUST             6                          CSD027
                                                                                              209905
     C                   IF        ##TRAS <> SFTRAS                                           209905
     C                   EVAL      ##TRAS = SFTRAS                                            209905
     C                   ENDIF                                                                209905
 
     C                   CallB     'MMFIDTSTS'
     C                   Parm                    PSProcName
     C                   Parm                    ##MODE
     C                   Parm                    WDLNO
     C                   Parm                    WCUST
     C                   Parm                    ##TRAS
     C                   Parm                    ##NAR1
     C                   Parm                    ##NAR2
     C                   Parm                    ##NAR3
     C                   Parm                    ##NAR4
     C**********         Parm                    @RTCD                                        209905
     C                   Parm                    PProtect                                     209905
     C                   Parm      *BLANK        @RTCD                                        209905
 
     C     @RTCD         IfEq      *BLANK
     C                   Move      ##TRAS        SFTRAS
     C                   EndIf
 
     C     @RTCD         IfEq      'Y2U9999'
     C                   Move      *On           *IN03
     C                   Exsr      #TERM
     C                   EndIf
 
     C     @RTCD         IfNe      *BLANK
     C     @RTCD         AndNe     'Y2U9999'
     C     @RTCD         AndNe     'USR0790'
     C                   Move      *On           *INU7
     C                   Move      *On           *INU8
     C                   Exsr      *PSSR
     C                   EndIf
 
     C                   EndIf
 
     C                   ENDSR
 
      *****************************************************************
      *                                                               *
      * SR/#ENQY : Build SFL in Enquiry                               *
      *                                                               *
      * Called By: #INIT                                              *
      *                                                               *
      * Calls: ZSEDIT, ZASNMS                                         *
      *                                                               *
      *****************************************************************
 
     C     #ENQY         BEGSR
 
     C                   Move      *On           *IN72
     C                   Move      ##DLNO        ZZLNKN            6 0
     C     ZZLNKN        SetLL     MMDELDL3
     C     ZZLNKN        ReadE     MMDELDL3                               90
 
     C     *IN90         DoWEq     *Off
 
     C     ##MODE        IfEq      'E'
     C     HKTYPE        AndEq     'LT'
     C     ##MODE        OrEq      'E'
     C     HKTYPE        AndEq     'LP'
     C                   Move      *On           *IN67
     C                   EndIf
 
      ** Fill only live records
 
     C     HKDDLT        IfNe      'D'
     C                   MoveL     HKDN38        SFDLNO
     C                   MoveL     HKCNUM        SFCNUM
 
     C     HKPTFR        IfEq      '9997'
     C                   MoveL     FCR997        SFPTFR
     C                   Else
     C                   MoveL     HKPTFR        SFPTFR
     C                   EndIf
 
      ** Swap amount only to display
 
     C     HKAMNP        IfLt      *ZEROS
     C                   Z-Sub     HKAMNP        HKAMNP
     C                   EndIf
 
     C                   Move      *BLANKS       ZFLD15
 
     C                   CallB     'ZSEDIT'
     C                   Parm      HKAMNP        ZFLD15
     C                   Parm      ZCDP          ZDECS
     C                   Parm      *BLANKS       ZECODE
     C                   Parm                    ZOUT21
 
     C                   Move      ZOUT21        SFAMNT
     C                   MoveL     HKDORI        WWCUST
     C                   MoveL     HKCSNM        SFCSSN
     C                   MoveL     *BLANK        SFTRAS
 
     C     *IN67         IfEq      *On
     C     *IN52         AndEq     *On
     C     HKDN38        Chain     MMDELDL2                           89
     C     *IN89         IfEq      *Off
     C                   MoveL     HKFTST        SFTRAS
     C                   EndIf
     C                   EndIf
 
     C                   MoveL     *BLANKS       SHAMNT
     C                   MoveL     *BLANKS       SHFLAG
 
     C     *IN51         IfEq      *On
     C                   Write     MMFIDDS1
     C                   Add       1             WWRRN
     C                   EndIf
     C     *IN52         IfEq      *On
     C                   Write     MMFIDDS3
     C                   Add       1             WWRRN3
     C                   EndIf
 
     C                   EndIf
 
     C     ZZLNKN        ReadE     MMDELDL3                               90
     C                   EndDo
 
      ** Display SFL at Top. If empty display message.
 
     C     *IN51         IfEq      *On
     C     WWRRN         IfEq      1
     C                   Move      *On           *IN64
     C                   MoveL     'MMA0580'     ZAMSID
     C                   MoveL     *BLANKS       ZAMSDA
     C                   Exsr      ZASNMS
     C                   EndIf
     C                   Z-Add     1             WWRRN
     C                   EndIf
     C     *IN52         IfEq      *On
     C     WWRRN3        IfEq      1
     C                   Move      *On           *IN66
     C                   MoveL     'MMA0580'     ZAMSID
     C                   MoveL     *BLANKS       ZAMSDA
     C                   Exsr      ZASNMS
     C                   EndIf
     C                   Z-Add     1             WWRRN3
     C                   EndIf
 
     C                   ENDSR
 
      *****************************************************************
      *                                                               *
      * SR/#FILS : Build SFL at Start                                 *
      *                                                               *
      * Called By: #INIT                                              *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     #FILS         BEGSR
 
     C                   Z-Add     1             WWCOUN            3 0
 
     C     WWCOUN        DoWLt     WWFIL
     C                   IF        WWCOUN > 99                                                209905
     C                   MoveL     *BLANKS       SFDLNO
     C                   MoveL     *BLANKS       SFCNUM
     C                   MoveL     *BLANKS       SFPTFR
     C                   MoveL     *BLANKS       SFAMNT
     C                   MoveL     *BLANKS       SFACOD
     C                   MoveL     *BLANKS       SFACSQ
     C                   MoveL     *BLANKS       SFCSSN
     C                   MoveL     *BLANKS       SFTRAS
     C                   MoveL     *BLANKS       SHAMNT
     C                   MoveL     *BLANKS       SHFLAG
     C                   ELSE                                                                 209905
     C                   EVAL      ACtr = WWCOUN                                              209905
     C                   MOVE      Inv_FIDT(ACtr)InvFIDT                                      209905
     C                   EVAL      SFDLNO = ISFDLNO                                           209905
     C                   EVAL      SFCNUM = ISFCNUM                                           209905
     C                   EVAL      SFPTFR = ISFPTFR                                           209905
     C                   EVAL      SFAMNT = ISFAMNT                                           209905
     C                   EVAL      SFACOD = ISFACOD                                           209905
     C                   EVAL      SFACSQ = ISFACSQ                                           209905
     C                   EVAL      SFTRAS = ISFTRAS                                           209905
     C                   ENDIF                                                                209905
                                                                                              209905
      ** If called from the repair function, protect the subfile screen                       209905
                                                                                              209905
     C                   IF        PProtect = 'Y'                                             209905
     C                   EVAL      *IN84 = *ON                                                209905
     C                   ENDIF                                                                209905
 
     C     *IN51         IfEq      *On
     C                   Write     MMFIDDS1
     C                   Add       1             WWRRN
     C                   EndIf
     C     *IN52         IfEq      *On
     C                   Write     MMFIDDS3
     C                   Add       1             WWRRN3
     C                   EndIf
 
     C                   Add       1             WWCOUN
 
     C                   EndDo
      *
      ** Display SFL at Top
      *
     C     *IN51         IfEq      *On
     C                   Z-Add     1             WWRRN
     C                   EndIf
     C     *IN52         IfEq      *On
     C                   Z-Add     1             WWRRN3
     C                   EndIf
 
     C                   ENDSR
 
      *****************************************************************
      *                                                               *
      * SR/#REFR : Refresh Subfile                                    *
      *                                                               *
      * Called By: #PREV                                              *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     #REFR         BEGSR
 
      ** Display SFL in amend mode
 
     C                   Move      *Off          *IN83
     C                   Move      *Off          *IN85
     C                   Move      'Y'           WFIRST
 
     C                   Z-Add     1             WWCOUN
     C     *IN51         IfEq      *On
     C                   Z-Add     1             WWRRN
     C                   EndIf
     C     *IN52         IfEq      *On
     C                   Z-Add     1             WWRRN3
     C                   EndIf
 
     C     WWCOUN        DoWLt     WWFIL
     C     *IN51         IfEq      *On
     C     WWRRN         Chain     MMFIDDS1                           82
     C                   EndIf
     C     *IN52         IfEq      *On
     C     WWRRN3        Chain     MMFIDDS3                           82
     C                   EndIf
 
     C                   Move      *Off          *IN84
     C     *IN51         IfEq      *On
     C                   Update    MMFIDDS1
     C                   Add       1             WWRRN
     C                   EndIf
     C     *IN52         IfEq      *On
     C                   Update    MMFIDDS3
     C                   Add       1             WWRRN3
     C                   EndIf
 
     C                   Add       1             WWCOUN
     C                   EndDo
 
      ** Display SFL at Top
 
     C     *IN51         IfEq      *On
     C                   Z-Add     1             WWRRN
     C                   EndIf
     C     *IN52         IfEq      *On
     C                   Z-Add     1             WWRRN3
     C                   EndIf
 
     C                   ENDSR
 
      *****************************************************************
      *                                                               *
      * SR/#TERM : Termination                                        *
      *                                                               *
      * Called By: Main Routine, #TRAS                                *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     #TERM         BEGSR
 
      ** End of pgm
 
     C     *IN03         IfEq      *On
     C                   Move      'Y2U9999'     ##RTCD
     C                   Else
     C                   Move      *BLANKS       ##RTCD
     C                   EndIf
 
     C                   Move      *On           *INLR
     C                   Return
 
     C                   ENDSR
 
      *****************************************************************
      *                                                               *
      * SR/#PREV : F12 on SFL                                         *
      *                                                               *
      * Called By: #MAIN                                              *
      *                                                               *
      * Calls: #REFR                                                  *
      *                                                               *
      *****************************************************************
 
     C     #PREV         BEGSR
 
      **   End of pgm, return to MMLDNISIN
 
     C     *IN72         IfEq      *Off
     C     *IN83         AndEq     *Off
     C     PProtect      OREQ      'Y'                                                        209905
     C                   Move      'USR0790'     ##RTCD
     C                   Move      *On           *INLR
     C                   Return
     C                   EndIf
 
      ** F12 pressed when message "Press enter to update" is displayed
 
     C     *IN72         IfEq      *Off
     C     *IN83         AndEq     *On
     C                   Exsr      #REFR
     C                   EndIf
 
     C                   ENDSR
 
      *****************************************************************
      *                                                               *
      * SR/#PROT : Protect SFL in Enquiry Mode                        *
      *                                                               *
      * Called By: #ENT1                                              *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     #PROT         BEGSR
 
      ** Display SFL in protect mode
 
     C                   Z-Add     1             WWCOUN
     C     *IN51         IfEq      *On
     C                   Z-Add     1             WWRRN
     C                   EndIf
     C     *IN52         IfEq      *On
     C                   Z-Add     1             WWRRN3
     C                   EndIf
 
     C     WWCOUN        DoWLt     WWFIL
     C     *IN51         IfEq      *On
     C     WWRRN         Chain     MMFIDDS1                           82
     C                   EndIf
     C     *IN52         IfEq      *On
     C     WWRRN3        Chain     MMFIDDS3                           82
     C                   EndIf
 
     C                   Move      *On           *IN84
     C     *IN51         IfEq      *On
     C                   Update    MMFIDDS1
     C                   Add       1             WWRRN
     C                   EndIf
     C     *IN52         IfEq      *On
     C                   Update    MMFIDDS3
     C                   Add       1             WWRRN3
     C                   EndIf
 
     C                   Add       1             WWCOUN
 
     C                   EndDo
 
      ** Display SFL at Top
 
     C     *IN51         IfEq      *On
     C                   Z-Add     1             WWRRN
     C                   EndIf
     C     *IN52         IfEq      *On
     C                   Z-Add     1             WWRRN3
     C                   EndIf
 
     C                   ENDSR
 
      *****************************************************************
      *                                                               *
      * SR/#HEADR : Setup SFL Header                                  *
      *                                                               *
      * Called By: #INIT                                              *
      *                                                               *
      * Calls: *PSSR, ZSEDIT, ZDATE2                                  *
      *                                                               *
      *****************************************************************
 
     C     #HEADR        BEGSR
 
     C                   MoveL     PSUser        USID
     C                   MoveL     PSJobName     WSID
     C                   MoveL     BJMRDT        DDMRDT
     C                   MoveL     ##DLNO        DDDLNO
     C                   Move      ##CNUM        DDCNUM
 
     C     ##NOTD        IfLe      *ZEROS
     C                   MoveL     *BLANKS       DDNOTD
     C                   Else
     C                   Move      *BLANKS       ZFLD15
     C                   Move      ##NOTD        ZFLD15
 
     C                   CallB     'ZSEDIT'
     C                   Parm                    ZFLD15
     C                   Parm      *ZEROS        ZDECS
     C                   Parm      *BLANKS       ZECODE
     C                   Parm                    ZOUT21
 
     C                   Move      ZOUT21        WDNOTD            4
     C                   MoveL     WDNOTD        DDNOTD
     C                   EndIf
 
     C                   Move      ##BRCA        DDBRCA
     C                   Move      ##DTST        DDSTYP
     C                   Move      ##DTYP        DDTYPE
 
      ** Customer shortname
 
     C                   CallB     'AOCUSTR1'
     C                   Parm      *BLANKS       @RTCD
     C                   Parm      '*KEY   '     @OPTN
     C                   Parm      DDCNUM        @KEY1            10
     C                   Parm      *BLANKS       @KYST             7
     C     SDCUST        Parm      SDCUST        DSLDY
 
     C     @RTCD         IfNe      *BLANKS
     C     *LOCK         In        LDA
     C                   Move      *On           *INU7
     C                   Move      *On           *INU8
     C                   Z-Add     008           DBase                          ************
     C                   MoveL     'SDCUSTPD'    DBFile                         * DBERR 08 *
     C                   Movel     DDCNUM        DBKey                          ************
     C                   Out       LDA
     C                   Exsr      *PSSR
     C                   EndIf
 
     C                   MoveL     BBCSSN        DDCSSN
     C                   MoveL     ##CCY         DDCCY
 
      ** Get Currency Decimal Places
 
     C                   CallB     'AOCURRR0'
     C                   Parm      *BLANKS       @RTCD
     C                   Parm      '*KEY   '     @OPTN
     C                   Parm      DDCCY         @AJCD             3
     C     SDCURR        Parm      SDCURR        DSSDY
 
     C     @RTCD         IfNe      *BLANK
     C     *LOCK         In        LDA
     C                   Move      *On           *INU7
     C                   Move      *On           *INU8
     C                   Z-Add     009           DBase                          ************
     C                   MoveL     'SDCURRPD'    DBFile                         * DBERR 09 *
     C                   MoveL     DDCCY         DBKey                          ************
     C                   Out       LDA
     C                   Exsr      *PSSR
     C                   EndIf
 
     C                   Z-Add     A6NBDP        ZCDP              1 0
 
      ** Swap amount only to display
 
     C     ##PCPL        IfLt      *ZEROS
     C                   Z-Sub     ##PCPL        ##PCPL
     C                   EndIf
 
     C                   Move      *BLANKS       ZFLD15
 
     C                   CallB     'ZSEDIT'
     C                   Parm      ##PCPL        ZFLD15
     C                   Parm      ZCDP          ZDECS
     C                   Parm      *BLANKS       ZECODE
     C                   Parm                    ZOUT21
 
     C                   Move      ZOUT21        DDAMNT
 
      ** Deal Date
 
     C     ##DDAT        IfNe      *ZEROS
     C                   CallB     'ZDATE2'
     C                   Parm      ##DDAT        ZDAYNO            5 0
     C                   Parm                    ZDATFM            1
     C                   Parm                    ZDATE             6 0
     C                   Parm                    ZADATE            7
 
     C                   MoveL     ZDATE         DDDATE
     C                   Else
     C                   Move      *BLANKS       DDDATE
     C                   EndIf
 
      ** Value Date
 
     C     ##VDAT        IfNe      *ZEROS
     C                   CallB     'ZDATE2'
     C                   Parm      ##VDAT        ZDAYNO
     C                   Parm                    ZDATFM
     C                   Parm                    ZDATE
     C                   Parm                    ZADATE
 
     C                   MoveL     ZDATE         DDVDAT
     C                   Else
     C                   Move      *BLANKS       DDVDAT
     C                   EndIf
 
      ** Maturity Date
 
     C     ##MDAT        IfNe      *ZEROS
     C                   CallB     'ZDATE2'
     C                   Parm      ##MDAT        ZDAYNO
     C                   Parm                    ZDATFM
     C                   Parm                    ZDATE
     C                   Parm                    ZADATE
 
     C                   MoveL     ZDATE         DDMDAT
     C                   Else
     C                   Move      *BLANKS       DDMDAT
     C                   EndIf
 
      ** Interest rate
 
     C                   Move      *BLANKS       ZFLD15
     C                   Move      ##INTR        ZFLD15
 
     C                   CallB     'ZSEDIT'
     C                   Parm                    ZFLD15           15 0
     C                   Parm      7             ZDECS             1 0
     C                   Parm      *BLANKS       ZECODE            1
     C                   Parm                    ZOUT21           21
 
     C                   Move      ZOUT21        DDRATE
 
     C                   ENDSR
 
      *****************************************************************
      *                                                               *
      * SR/#UPDT  : Output Record in Work File                        *
      *                                                               *
      * Called By: #ENT1                                              *
      *                                                               *
      * Calls: *PSSR                                                  *
      *                                                               *
      *****************************************************************
 
     C     #UPDT         BEGSR
 
     C                   Z-Add     1             WWCOUN
     C     *IN51         IfEq      *On
     C                   Z-Add     1             WWRRN
     C                   EndIf
     C     *IN52         IfEq      *On
     C                   Z-Add     1             WWRRN3
     C                   EndIf
 
     C     WWCOUN        DoWLt     WWFIL
 
     C     *IN51         IfEq      *On
     C     WWRRN         Chain     MMFIDDS1                           82
     C                   EndIf
     C     *IN52         IfEq      *On
     C     WWRRN3        Chain     MMFIDDS3                           82
     C                   EndIf
 
     C     SHFLAG        IfEq      'D'
     C                   Clear                   SW8OUTP
     C                   MoveL     IKRCID        FIRCID
     C                   MoveL     IKDLTF        FIDLTF
     C                   IF        WWCOUN <= 88                                               209905
     C                   MOVEL     PFrontId1     FIFRNT                                       209905
     C                   ELSE                                                                 209905
     C                   MOVEL     PFrontId2     FIFRNT                                       209905
     C                   ENDIF                                                                209905
     C                   MOVEL     PAsocId       FIAFRT                                       209905
     C                   Z-Add     IKDLUP        FIDLUP
     C                   MoveL     IKMLUP        FIMLUP
     C                   Z-Add     IKYLUP        FIYLUP
     C                   Z-Add     IKTLUP        FITLUP
     C                   MoveL     IKCHTP        FICHTP
     C                   Z-Add     IKLCD         FILCD
     C                   MoveL     IKLUID        FILUID
     C                   Move      SFDLNO        FIDN38
     C                   MoveL     'MAIL'        FIBKCD
     C                   MoveL     DDCCY         FICCY
     C                   Z-Add     IKCYDP        FICYDP
     C                   Z-Add     IKVDYY        FIVDYY
     C                   Z-Add     IKVDMM        FIVDMM
     C                   Z-Add     IKVDDD        FIVDDD
     C                   Z-Add     IKDTYY        FIDTYY
     C                   Z-Add     IKDTMM        FIDTMM
     C                   Z-Add     IKDTDD        FIDTDD
     C                   MoveL     IKDDLT        FIDDLT
     C                   MoveL     IKMTYP        FIMTYP
     C                   MoveL     IKDSTS        FIDSTS
 
     C     DDTYPE        IfEq      'FL'
     C                   MoveL     'FT'          FITYPE
     C                   Else
     C     DDTYPE        IfEq      'DP'
     C                   MoveL     'DT'          FITYPE
     C                   Else
     C     DDTYPE        IfEq      'LP'
     C                   MoveL     'LT'          FITYPE
     C                   EndIf
     C                   EndIf
     C                   EndIf
 
     C                   MoveL     IKSTYP        FISTYP
     C                   MoveL     SHCSSN        FICSNM
     C                   Move      SHCNUM        FICNUM
     C                   Z-Add     SHAMNT        FIAMNP
     C                   Z-Add     IKINTR        FIINTR
     C                   MoveL     IKBRCA        FIBRCA
     C                   MoveL     IKDBRC        FIDBRC
     C                   Z-Add     IKDDYY        FIDDYY
     C                   Z-Add     IKDDMM        FIDDMM
     C                   Z-Add     IKDDDD        FIDDDD
     C                   Z-Add     IKBRKG        FIBRKG
     C                   MoveL     IKFEDF        FIFEDF
     C                   MoveL     IKCDRF        FICDRF
     C                   Z-Add     IKPCTN        FIPCTN
     C                   MoveL     IKCDRP        FICDRP
     C                   MoveL     ##MODE        FILACT
     C                   Z-Add     IKTIME        FITIME
     C                   MoveL     IKDUSC        FIDUSC
     C                   Z-Add     IKLDAT        FILDAT
     C                   MoveL     IKAOFR        FIAOFR
     C                   Z-Add     IKSLYY        FISLYY
     C                   Z-Add     IKSLMM        FISLMM
     C                   Z-Add     IKSLDD        FISLDD
     C                   Z-Add     IKSPRD        FISPRD
     C                   Z-Add     IKIIRT        FIIIRT
     C                   Z-Add     IKNIYY        FINIYY
     C                   Z-Add     IKNIMM        FINIMM
     C                   Z-Add     IKNIDD        FINIDD
     C                   MoveL     IKIPFQ        FIIPFQ
     C                   MoveL     IKICMT        FIICMT
     C                   Z-Add     IKIPDM        FIIPDM
     C                   MoveL     *BLANKS       FICPTI
     C                   MoveL     IKCNTI        FICNTI
     C                   Move      SFACSQ        FIACSQ
     C                   MoveL     'N'           FIMTAX
     C**********         Z-Add     IKMCDH        FIMCDH                                       CSD027
     C                   Eval      FIMCDH = IKMCDH                                            CSD027
     C                   Z-Add     IKIAYY        FIIAYY
     C                   Z-Add     IKIAMM        FIIAMM
     C                   Z-Add     IKIADD        FIIADD
     C                   MoveL     IKBSRC        FIBSRC
     C                   MoveL     IKDBSR        FIDBSR
     C                   Z-Add     IKMDYY        FIMDYY
     C                   Z-Add     IKMDMM        FIMDMM
     C                   Z-Add     IKMDDD        FIMDDD
     C                   Z-Add     IKNTCE        FINTCE
     C                   Z-Add     IKFCLY        FIFCLY
     C                   Z-Add     IKIMAT        FIIMAT
     C                   Z-Add     IKBRAT        FIBRAT
     C                   MoveL     IKMMDI        FIMMDI
     C                   MoveL     'MACC '       FIDORM
     C                   Move      05            FIORCM
     C                   MoveL     WWCUST        FIDORI
     C                   MoveL     WWCUST        FIMORI
     C                   MoveL     'MACC '       FIDOPM
     C                   Move      05            FIMOPM
     C                   MoveL     WWCUST        FIDOPI
     C                   MoveL     WWCUST        FIMOPI
     C                   MoveL     IKBOKC        FIBOKC
     C                   MoveL     IKDRID        FIDRID
     C                   MoveL     IKDDMR        FIDDMR
     C                   Z-Add     IKRBAT        FIRBAT
     C                   Move      05            FIRSTM
     C                   MoveL     WWCUST        FIRONS
     C                   Move      05            FIPSTM
     C                   MoveL     WWCUST        FIPONS
     C                   Z-Add     IKDVSD        FIDVSD
     C                   Z-Add     IKDDND        FIDDND
     C                   Z-Add     IKSLID        FISLID
     C                   Z-Add     IKNIPD        FINIPD
     C                   Z-Add     IKMATD        FIMATD
     C                   MoveL     IKORBR        FIORBR
 
     C                   CallB     'AOPRFMR0'
     C                   Parm      *BLANKS       @RTCD
     C                   Parm      IKBOKC        BOOK              2
     C                   Parm      IKTYPE        TRTP              5
     C                   Parm      IKSTYP        SUTP              2
     C                   Parm      IKBRCA        BRAN              3
     C                   Parm      ZMDEPT        DEPT1             3
     C                   Parm      USID          USER             10
     C                   Parm      BBACOC        ACOF              2
     C                   Parm      BBCUST        CUST              6
     C                   Parm                    PRFC              4
 
     C     @RTCD         IfEq      *BLANKS
     C                   MoveL     PRFC          FIPRFC
     C                   Else
     C                   MoveL     IKPRFC        FIPRFC
     C                   EndIf
 
     C                   MoveL     DDBRCA        FIPOBR
     C                   MoveL     DDBRCA        FIROBR
     C                   MoveL     IKCVMR        FICVMR
     C                   MoveL     IKRDFC        FIRDFC
     C                   MoveL     IKFLID        FIFLID
     C                   MoveL     IKFUID        FIFUID
     C                   MoveL     IKAURO        FIAURO
     C                   MoveL     IKIPDS        FIIPDS
     C                   MoveL     IKROFQ        FIROFQ
     C                   Z-Add     IKRLDN        FIRLDN
     C                   MoveL     IKCNNA        FICNNA
     C                   MoveL     IKIMET        FIIMET
     C                   MoveL     IKINSA        FIINSA
     C                   MoveL     IKINOS        FIINOS
     C                   MoveL     IKWRPI        FIWRPI
     C                   Move      SFTRAS        FIFTST
     C                   Move      ##NAR1        FIFRN1
     C                   Move      ##NAR2        FIFRN2
     C                   Move      ##NAR3        FIFRN3
     C                   Move      ##NAR4        FIFRN4
 
     C     BGPFMG        IfEq      'Y'
     C     SFPTFR        IfEq      FCR997
     C                   Move      '9997'        FIPTFR
     C                   Else
     C                   MoveL     SFPTFR        FIPTFR
     C                   EndIf
     C                   Else
     C                   Move      *BLANKS       FIPTFR
     C                   EndIf
 
      ** Calculate total interest of the taking deal
 
     C                   Z-ADD     FICYDP        PCYDP
     C                   Z-ADD     FINTCE        PNTCE
     C                   CALLB     'ZAVTOTINT'
     C                   PARM      *BLANKS       ReturnCode
     C                   PARM      *BLANKS       MsgID1
      ** Action Code (1A, from caller)                                          179243
     C                   PARM                    ##mode                         179243
      ** Message data (45A)
     C                   PARM      *BLANKS       MSGDATA          45
      ** Total interest amount returned from this module (15,0P)
     C                   PARM      *Zero         FIMTTI
      ** Total interest amount (14A, from transaction)
     C                   PARM      '*'           PTOTI            14
      ** Default interest for CL and CD deals with zero notice days
      ** feature flag (1A, from SCSARDPD)
     C                   PARM                    S01468
      ** Deal notice days (3A, from transaction)
     C                   PARM                    PDDNTCE
      ** Deal type (2A, from transaction)
     C                   PARM                    FITYPE
      ** Interest rate (11,7P,)
     C                   PARM                    FIINTR
      ** Deal amount (15,0P, from caller)
     C                   PARM                    FIAMNP
      ** Interest calculation method (1A, from transaction)
     C                   PARM                    FIICMT
      ** Deal value date in Midas day number format (5,0P, )
     C                   PARM                    FIDVSD
      ** Currency FldNameArr OK flag (1A, )
     C                   PARM      'Y'           DDCcyOK           1
      ** Number of decimal places in deal currency (1,0S, from SDCURRPD)
     C                   PARM                    PCYDP
      ** Value date field OK (1A, )
     C                   PARM      'Y'           DDVDatOK          1
      ** Notice days field OK (1A, )
     C                   PARM      'Y'           DDNtceOK          1
      ** Amount field OK (1A, )
     C                   PARM      'Y'           DDAMNPOK          1
      ** Base Rate field OK (1A, )
     C                   PARM      'Y'           DDBsRCOK          1
      ** Spread/Rate field OK (1A, )
     C                   PARM      'Y'           DDSpRtOK          1
      ** Calculation method field OK (1A, )
     C                   PARM      'Y'           DDICMTOK          1
      ** Maturity date (6A, from transaction)
     C                   PARM                    PDDMDAT
      ** Maturity date in Midas day number format (5,0P, )
     C                   PARM                    FIMATD
      ** Maturity date field OK (1A, )
     C                   PARM      'Y'           DDMDatOK          1
      ** Notice days (3,0S, )
     C                   PARM                    PNTCE
      ** First and last day interest flag (1A, from transaction)
     C                   PARM                    FIFLID
      ** Round-down interest flag (1A, from transaction)
     C                   PARM                    FIRDFC
      ** Decimal separator (1A, from SDDEALPD)
     C                   PARM                    NNDCSP
 
     C     ReturnCode    IfNe      *BLANKS
     C     *LOCK         In        LDA
     C                   Move      *On           *INU7
     C                   Move      *On           *INU8
     C                   Z-Add     007           DBase                          ************
     C                   MoveL     'ZAVTOTINT'   DBFile                         * DBERR 01 *
     C                   Out       LDA
     C                   Exsr      *PSSR
     C                   EndIf
 
      ** Generate the deal number of the placing if it has none yet so
      ** that the associated taking can already be attached to it. Thus,
      ** reducing the possibility of having takings in MMWFIDDPD that
      ** belong to a generic placing, that is, deal '000000'. Make sure
      ** also that the generated deal number is received by the calling
      ** program to avoid re-generation of deal number for the placing.
 
     C     ##DLNO        IFEQ      *BLANKS
     C                   CALLB     'CAGTNXTFID'
     C                   PARM                    ##DTYP
     C                   PARM      *ZERO         PDealNo           6 0
     C                   MOVE      PDealNo       ##DLNO
     C                   ENDIF
     C                   MOVE      ##DLNO        FILNKN
 
     C                   Write     SW8OUTP
 
      ** For fiduciary loan only one record, so use a parameter to pass
      ** the trust agreement status to MMFIDTUPF to setup MMDELDPP
 
     C     *IN67         IfEq      *On
     C                   Move      SFTRAS        ##TRAS
     C                   EndIf
 
     C                   EndIf
 
     C     *IN51         IfEq      *On
     C                   Add       1             WWRRN
     C                   EndIf
     C     *IN52         IfEq      *On
     C                   Add       1             WWRRN3
     C                   EndIf
 
     C                   Add       1             WWCOUN
     C                   EndDo
 
      ** Return to MMLDNISIN
 
     C                   Move      *On           *INLR
     C                   Move      *Off          *IN51
     C                   Move      *Off          *IN52
 
     C                   ENDSR
 
      *****************************************************************
      *                                                               *
      * SR/ZASNMS : Send Message to Message Queue                     *
      *                                                               *
      * Called By: #ENT1, #DLNO, #ACOD, #ACSQ, #PTFR, #CNUM, #AMNT,   *
      *            #ENQY                                              *
      *                                                               *
      * Calls: Y2SNMGC                                                *
      *                                                               *
      *****************************************************************
 
     C     ZASNMS        BEGSR
 
      ** Message file specified is PMSGF
 
     C                   MoveL     PMSGF         ZAMSGF
 
     C                   Call      'Y2SNMGC'
     C                   Parm                    ZAPGM            10
     C                   Parm                    ZAPGRL            5
     C                   Parm                    ZAMSID            7
     C                   Parm                    ZAMSGF           10
     C                   Parm                    ZAMSDA          132
     C                   Parm                    ZAMSTP            7
 
      ** Clear all fields for default mechanism next time.
 
     C                   MoveL     *BLANK        ZAPGM
     C                   MoveL     *BLANK        ZAPGRL
     C                   MoveL     *BLANK        ZAMSDA
     C                   MoveL     *BLANK        ZAMSTP
     C                   MoveL     *BLANK        ZAMSGF
     C                   MoveL     *BLANK        ZAMSID
 
     C                   ENDSR
 
      *****************************************************************
      *                                                               *
      * SR/*PSSR  : Error Handling                                    *
      *                                                               *
      * Called By: #INIT, #TRAS, #UPDT, #HEADR                        *
      *                                                               *
      * Calls: DBERRCTL                                               *
      *                                                               *
      *****************************************************************
 
     C     *PSSR         BEGSR
 
     C                   MoveL     '*ERROR'      ##RTCD
     C                   Call      'DBERRCTL'
     C                   Dump
     C                   Move      *On           *INLR
     C                   Return
 
     C                   ENDSR
 
      ****************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2001
