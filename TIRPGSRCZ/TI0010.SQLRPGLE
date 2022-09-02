     H DEBUG
      *****************************************************************
/**** *  RPGBASE                                                      *                     MD058085
/*STD *  RPGSQLBND                                                    *                     MD058085
/*EXI *  TEXT('Midas TI Account opening utility')                     *
      *****************************************************************
      *                                                               *
      *  Midas - Midas/TI Interface                                   *
      *                                                               *
      *  TI0010 - Midas/TI Interface Account Opening Utility          *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD058085           Date 11May21               *
      *  Prev Amend No. CSD103             Date 10Aug20               *
      *                 MD046248           Date 27Oct17               *
      *                 CRE095             Date 25Apr14               *
      *                 CRE090             Date 14Feb14               *
      *                 AR899028           Date 25Jan12               *
      *                 AR847269           Date 09Nov11               *
      *                 CRE073             Date 06Dec10               *
      *                 CER042             Date 11May11               *
      *                 CRE075             Date 06Dec10               *
      *                 CER059             Date 19Jul10               *
      *                 CER047             Date 19May08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      *                 CAP205             Date 04Jan10               *
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 BUG14016           Date 21May07               *
      *                 BUG13929           Date 13May07               *
      *                 BUG13930           Date 11May07               *
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD031             Date 10Apr06               *
      *                 CSD027             Date 09Dec05               *
      *                 BUG6597            Date 04Jul05               *
      *                 CSW037A            Date 02May05               *
      *                 CSD025             Date 11Jan05               *
      *                 CSW037             Date 15Dec04               *
      *                 CSW036             Date 15Dec04               *
      *                 BUG3772            Date 27Jul04               *
      *                 CLE025             Date 20Oct03               *
      *                 CGL029             Date 01Sep03               *
      * Midas Release 4.01 -------------------------------------------*
      *                 CPK015             Date 01Jul02               *
      * Midas Release 4 --------------- Base -------------------------*
      *                 191086             Date 29May01               *
      * Midas DBA 3.05 -----------------------------------------------*
      * Midas DBA 3.04 -----------------------------------------------*
      *                 185144             Date 19Oct00               *
      * Midas DBA 3.03 -----------------------------------------------*
      *                 180464             Date 12Jul00               *
      * Midas DBA 3.02 -----------------------------------------------*
      *                 CTI099  *CREATE    Date 07Jul99               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD058085 - Deliverable Data Split for Standing Data          *
      *  CSD103 - LIBOR Deregulation - Common Layer/Standing Data     *
      *  MD046248 - Finastra Rebranding                               *
      *  CRE095 - Rate Fixing for RE Accounts                         *
      *  CRE090 - Delay Capitalisation of Interest                    *
      *  AR899028 - NOSTRO AMAD System errors occured; applied        *
      *             fix AR847269                                      *
      *  AR847269 - Column F1DACN not in specified tables (Recompile) *
      *  CRE073 - Interest Rate Rounding (Recompile)                  *
      *  CER042 - Interest Scale Report Correspondence                *
      *           (Upgrade of FGE178/179) (Recompile)                 *
      *  CRE075 - Effective Date for Retail Accounts (Recompile)      *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER047 - German Features LF037-00 Reporting §24c KWG         *
      *           (Recompile)                                         *
      *  CAP205 - Teller Related APIs - Account Balance Check         *
      *           (Recompile)                                         *
      *  BUG14016 - Automatic Account opened for TI - missing field   *
      *             Automatic Account opened for TI - missing field   *
      *  BUG13929 - Account Maintenance error in Account code field   *
      *  BUG13930 - Automatic account opening for TI - Account        *
      *             Details incorrect                                 *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  BUG6597 - Ensure value of account suffix is handled properly *
      *            to avoid duplicate key.  Applied fix 230076.       *
      *  CSW037A- Additional Field extended to 40 chars (recompile)   *
      *  CSD025 - Customer De-Activation                              *
      *  CSW037 - Additional Field Data on MT300/MT320                *
      *  CSW036 - Dual SWIFT BIC held on Client Details               *
      *  BUG3772 - Return to main screen after creating accounts.     *
      *  CLE025 - Credit Lines (Recompile)                            *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  CPK015 - Release 4.01 Packaging:                             *
      *           - A default timestamp string is required for WRITE. *
      *  191086 - Expend the field ACCNO to 4 digits.                 *
      *  185144 - Program amended to ADD contents of ACCNO to NINU.   *
      *           Z-ADDing corrupts NINU and causes FCOOB in REC74.   *
      *  180464 - When updating an existing Account, change specified *
      *           fields rather than do a mass update.                *
      *  CTI099 - Utility to open accounts for Midas/TI Interface     *
      *                                                               *
      *****************************************************************
     FACCBR     UF A E           K DISK
     F                                     RENAME(ACCNTABF:ACCNT1)
     F                                     COMMIT                                                 BU
     FACCNTTI   IF   E           K DISK
     F                                     RENAME(ACCNTABF:ACCNT2)
     F*SDTIACL0UF  E           K        DISK                                                MD058085
     FTIOPACL1  IF   E           K DISK    USROPN
     FTIOPACPD  O    E           K DISK    USROPN
     FACCNTAC   UF   E             DISK    USROPN
     FGLACNTQD  O    E             DISK    USROPN                                                 BU
     FTI0010DF  CF   E             WORKSTN
     F*TI0010P1O**E*****        37     PRINTER                                               BUG3772
     FTI0010P1  O    E             PRINTER OFLIND(*IN37)                                           B
     F                                     USROPN
      /EJECT
     D*STAMP*****      S             26    DIM(1) CTDATA PERRCD(1)                          MD058985
      ** Array containing dummy timestamp                                                     CPK015
     D CPY@            S             80    DIM(1) CTDATA PERRCD(1)
     D/COPY WNCPYSRC,TI0010E001
      *
      ** Array containing Copyright statement
      *
     D CMDA            S             80    DIM(1) CTDATA PERRCD(1)
      ** Array containing QCMDEXC commands.
      *
     D STAMP           S             26A   INZ('0001-01-01-00.00.00.000000')                MD058085
     D CUR             S              3    DIM(30)
      ** Array containing currencies
      *
     D ISO             S              3    DIM(30)
      ** Array containing associated ISO currency codes.
      *
     D**********          ACC        30  4                                                    CGL029
     D ACC             S             10    DIM(30)
      ** Array containing Account Codes
      *
     D TIA             S              2    DIM(30)
      ** Array containing TI Account Codes
      *
     D TYP             S              1    DIM(30)
      ** Array containing Account Types
      *
     D SUB             S              1    DIM(30)
      ** Array containing Account Sub-types
      *
     D NAM             S             25    DIM(30)
     D SCREEN          DS                                                                          B
     D  #1BRCH                 1      3                                                            B
     D  #1CUST                 4      9                                                            B
     D  #1CY01                10     12                                                            B
     D  #1CY02                13     15                                                            B
     D  #1CY03                16     18                                                            B
     D  #1CY04                19     21                                                            B
     D  #1CY05                22     24                                                            B
     D  #1CY06                25     27                                                            B
     D  #1CY07                28     30                                                            B
     D  #1CY08                31     33                                                            B
     D  #1CY09                34     36                                                            B
     D  #1CY10                37     39                                                            B
     D  #1CY11                40     42                                                            B
     D  #1CY12                43     45                                                            B
     D  #1CY13                46     48                                                            B
     D  #1CY14                49     51                                                            B
     D  #1CY15                52     54                                                            B
     D  #1CY16                55     57                                                            B
     D  #1CY17                58     60                                                            B
     D  #1CY18                61     63                                                            B
     D  #1CY19                64     66                                                            B
     D  #1CY20                67     69                                                            B
     D  #1CY21                70     72                                                            B
     D  #1CY22                73     75                                                            B
     D  #1CY23                76     78                                                            B
     D  #1CY24                79     81                                                            B
     D  #1CY25                82     84                                                            B
     D  #1CY26                85     87                                                            B
     D  #1CY27                88     90                                                            B
     D  #1CY28                91     93                                                            B
     D  #1CY29                94     96                                                            B
     D  #1CY30                97     99                                                            B
     D  #1AC01               100    109                                                            B
     D  #1AC02               110    119                                                            B
     D  #1AC03               120    129                                                            B
     D  #1AC04               130    139                                                            B
     D  #1AC05               140    149                                                            B
     D  #1AC06               150    159                                                            B
     D  #1AC07               160    169                                                            B
     D  #1AC08               170    179                                                            B
     D  #1AC09               180    189                                                            B
     D  #1AC10               190    199                                                            B
     D  #1AC11               200    209                                                            B
     D  #1AC12               210    219                                                            B
     D  #1AC13               220    229                                                            B
     D  #1AC14               230    239                                                            B
     D  #1AC15               240    249                                                            B
     D  #1AC16               250    259                                                            B
     D  #1AC17               260    269                                                            B
     D  #1AC18               270    279                                                            B
     D  #1AC19               280    289                                                            B
     D  #1AC20               290    299                                                            B
     D  #1AC21               300    309                                                            B
     D  #1AC22               310    319                                                            B
     D  #1AC23               320    329                                                            B
     D  #1AC24               330    339                                                            B
     D  #1AC25               340    349                                                            B
     D  #1AC26               350    359                                                            B
     D  #1AC27               360    369                                                            B
     D  #1AC28               370    379                                                            B
     D  #1AC29               380    389                                                            B
     D  #1AC30               390    399                                                            B
     D SDBRCH        E DS                  EXTNAME(SDBRCHPD)
      **  External data structure for Branch Details
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)
      **  External data structure for Customer Details
     D  QQDFA1       E                     EXTFLD(QQDFAC)
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
      **  External data structure for Currency Details
     D*SDISOC**  E DSSDISOCPD                                                               MD058085
     D SDISOC        E DS                  EXTNAME(SDISOJW0)                                MD058085
     D SDTIAC        E DS                  EXTNAME(SDTIAJW0)                                MD058085
      **  External data structure for ISO/CCY Details
     D SDACOD        E DS                  EXTNAME(SDACODPD)
      **  External data structure for Account Code Details
     D SDTIIN        E DS                  EXTNAME(SDTIINPD)
      **  External data structure for TI A/C ICD Details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      **  External data structure for Bank Details
     D DSFDY         E DS                  EXTNAME(DSFDY)
      **  First data structure for Access Programs, short DS
      *
     D DSSDY         E DS                  EXTNAME(DSSDY)
      **  Second data structure for Access Programs, long DS
     D LDA           E DS           256    EXTNAME(LDA)
      *
      ** Local data area for database error details
      ** *LOCK IN LDA immediately before and OUT LDA immediately
      ** after each database error handling.
      **
      **                                    134 141 DBFILE
      **       Defines:                     142 170 DBKEY
      **                                    171 180 DBPGM
      **                                    181 1830DBASE
      *
     D RUNDAT        E DS                  EXTNAME(RUNDAT)
      *
      ** Data Area giving Installation Control Details
      *
     D PSDS           SDS
      ** Program Status Data Structure
     D  PGM              *PROC
     D  WSID                 244    253
     D  USER                 254    263
      *                                                                                     BUG13930
     D                 DS                                                                         BU
     D  #BRCA                  1      3                                                           BU
     D**********                              4   90#CNUM                                   BUG13930
     D  #CNUM                  4      9                                                           BU
     D  #CCY                  10     12                                                           BU
     D  #ACOD                 13     22  0                                                        BU
     D  WACSQ                 23     24  0                                                        BU
     D  DSACKY                 1     34                                                           BU
      ** Array containing Account Names
      *
      /SPACE 3
     IACCNT1
     I              CCY                         OCCY
     I              ACOD                        OACOD
     I              ACSQ                        OACSQ
     I              A5TIAN                      OTIAN
     I              A5TIAS                      OTIAS
     IACCNT2
     I              RECI                        TRECI                                              B
     I              CNUM                        TCNUM                                              B
     I              CCY                         TCCY
     I              ACOD                        TACOD
     I              ACSQ                        TACSQ
     I              ZZ006                       TZ006                                              B
     I              BRCA                        TBRCA                                              B
     I              ATYP                        TATYP                                              B
     I              STYP                        TSTYP                                              B
     I              MFFQ                        TMFFQ                                              B
     I              ACST                        TACST                                              B
     I              DACO                        TDACO                                              B
     I              DACC                        TDACC                                              B
     I              ANAM                        TANAM                                              B
     I              LDBL                        TLDBL                                              B
     I              CLBL                        TCLBL                                              B
     I              STFQ                        TSTFQ                                              B
     I              STDY                        TSTDY                                              B
     I              LSTD                        TLSTD                                              B
     I              NSTD                        TNSTD                                              B
     I              LSTP                        TLSTP                                              B
     I              CFSB                        TCFSB                                              B
     I              LMVD                        TLMVD                                              B
     I              EPLB                        TEPLB                                              B
     I              EPCB                        TEPCB                                              B
     I              YTDB                        TYTDB                                              B
     I              GLBT                        TGLBT                                              B
     I              ADREF1                      TDREF1                                             B
     I              PRFC                        TPRFC                                              B
     I              ZZ004                       TZ004                                              B
     I              ORED                        TORED                                              B
     I              DLIM                        TDLIM                                              B
     I              LRCR                        TLRCR                                              B
     I              RTCB                        TRTCB                                              B
     I              RTLB                        TRTLB                                              B
     I              DITM                        TDITM                                              B
     I              CITM                        TCITM                                              B
     I              ADREF2                      TDREF2                                             B
     I              ZZ002                       TZ002                                              B
     I              CDIR                        TCDIR                                              B
     I              CCIR                        TCCIR                                              B
     I              ACNO                        TACNO                                              B
     I              RETB                        TRETB                                              B
     I              ODSC                        TODSC                                              B
     I              ODLN                        TODLN                                              B
     I              ODED                        TODED                                              B
     I              DIOD                        TDIOD                                              B
     I              FACT                        TFACT                                              B
     I              FCNO                        TFCNO                                              B
     I              EFAC                        TEFAC                                              B
     I              HELD                        THELD                                              B
     I              MINB                        TMINB                                              B
     I              LACD                        TLACD                                              B
     I              LISP                        TLISP                                              B
     I              RRNM                        TRRNM                                              B
     I              DRIB                        TDRIB                                              B
     I              DRIS                        TDRIS                                              B
     I              DRCD                        TDRCD                                              B
     I              DRIC                        TDRIC                                              B
     I              DRIF                        TDRIF                                              B
     I              DRDY                        TDRDY                                              B
     I              NDID                        TNDID                                              B
     I              LDID                        TLDID                                              B
     I              LDIA                        TLDIA                                              B
     I              SDAP                        TSDAP                                              B
     I              LPAR                        TLPAR                                              B
     I              DIIE                        TDIIE                                              B
     I              DAIC                        TDAIC                                              B
     I              MADI                        TMADI                                              B
     I              GADI                        TGADI                                              B
     I              DDIS                        TDDIS                                              B
     I              DDIA                        TDDIA                                              B
     I              OLDR                        TOLDR                                              B
     I              OLDB                        TOLDB                                              B
     I              OLDS                        TOLDS                                              B
     I              CRIB                        TCRIB                                              B
     I              CRIS                        TCRIS                                              B
     I              CRCD                        TCRCD                                              B
     I              CRIC                        TCRIC                                              B
     I              CRIF                        TCRIF                                              B
     I              CRDY                        TCRDY                                              B
     I              NCID                        TNCID                                              B
     I              LCID                        TLCID                                              B
     I              LCIA                        TLCIA                                              B
     I              SCAP                        TSCAP                                              B
     I              LPAP                        TLPAP                                              B
     I              CIIE                        TCIIE                                              B
     I              CAIC                        TCAIC                                              B
     I              MACI                        TMACI                                              B
     I              GACI                        TGACI                                              B
     I              CDIS                        TCDIS                                              B
     I              DCIA                        TDCIA                                              B
     I              OLCR                        TOLCR                                              B
     I              OLCB                        TOLCB                                              B
     I              OLCS                        TOLCS                                              B
     I              LCD                         TLCD                                               B
     I              CHTP                        TCHTP                                              B
     I              TNLU                        TTNLU                                              B
     I              BRTCA                       TRTCA                                              B
     I              NACSG                       TACSG                                              B
     I              R4ACNT                      TR4AC                                              B
     I              ENOC                        TENOC                                              B
     I              EPNO                        TEPNO                                              B
     I              ECFB                        TECFB                                              B
     I              LTAB                        TLTAB                                              B
     I              LTAC                        TLTAC                                              B
     I              LTAS                        TLTAS                                              B
     I              HCFB                        THCFB                                              B
     I              PTFR                        TPTFR                                              B
     I              HLEX                        THLEX                                              B
     I              A5TIAC                      TTIAC                                              B
     I              A5TIAN                      TTIAN
     I              A5TIAS                      TTIAS
     I              EUSB                        TEUSB                                              B
     I              IBAN                        TIBAN                                              B
     I              IBSEQN                      TSEQN                                              B
     I              FRNT                        TFRNT                                              B
     I              AFRT                        TAFRT                                              B
     I              REPA                        TREPA                                              B
     I              REPI                        TREPI                                              B
      *
     C     KLST1         KLIST
     C                   KFLD                    #BRCA             3
     C**********           KFLD           #CNUM   60                                          CSD027
     C                   KFLD                    #CNUM             6
     C                   KFLD                    #CCY              3
     C*********            KFLD           #ACOD   40                                          CGL029
     C                   KFLD                    #ACOD            10 0
      *
     C     KLST2         KLIST
     C                   KFLD                    #BRCA             3
     C                   KFLD                    #TNUM             6
     C                   KFLD                    #TSUF             3
      *
     C     KLST3         KLIST
     C                   KFLD                    #BRCA             3
     C                   KFLD                    #TNUM             6
      *                                                                                      BUG6597
     C     KLST4         KLIST
     C                   KFLD                    #BRCA             3
     C                   KFLD                    WTIAN             6
     C                   KFLD                    WTIAS             3
      *                                                                                      BUG6597
     C     KLST5         KLIST
     C                   KFLD                    #BRCA             3
     C                   KFLD                    WTIAN             6
      *
      ** Set up copyright parameter
      *
     C                   MOVEA     CPY@          CPY2@            80
      *
      ** Read in Installation Data
     C     *DTAARA       DEFINE                  RUNDAT
     C     *DTAARA       DEFINE                  LDA
     C                   IN        RUNDAT
      *
     C                   MOVEL     'SDUSRMSG'    ZAMSGF
     C                   MOVEL     'TI0010'      ##PGM
      *
      ** Set Date Format Indicator *IN98  on if date format is MMDDYY
     C     AGDFF         IFEQ      'M'
     C                   SETON                                        98
     C                   END
      *
     C                   CALL      'AOBANKR0'
     C                   PARM      '*DBERR  '    @RTCD             7
     C                   PARM      '*FIRST  '    @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
      *
      *
      ** Clear Physical File TIOPACPD
     C                   MOVEA     CMDA(1)       CMD              80
     C                   CALL      'QCMDEXC'
     C                   PARM                    CMD
     C                   PARM      80            CMDLEN           15 5
      *
      * Clear messages from program message queue
     C                   CALL      'Y2CLMSC'
     C                   PARM      ##PGM         ZAPGMQ
     C                   PARM      '*SAME'       ZAPGRL
      *
      * Send information to display file and then display
     C                   MOVEL     USER          SUSER
     C                   MOVEL     WSID          SWSID
      *                                                                                      BUG6597
      ** Initialise counter fields for new accounts                                          BUG6597
      *                                                                                      BUG6597
     C                   Z-ADD     0             @@TIAS            4 0
      *                                                                                      BUG6597
      ** Initialise KLST4 and KLST5 fields.                                                  BUG6597
      *                                                                                      BUG6597
     C                   MOVE      *BLANK        WTIAN
     C                   MOVE      '999'         WTIAS
      *
     C     NXTINP        TAG
     C                   EXSR      RESET
      *                                                                                      BUG3772
     C                   WRITE     #MSGCTL
     C                   EXFMT     TI0010F1
      *
     C     *INKC         DOWEQ     *OFF
      *
     C                   CALL      'AOTIINR0'
     C                   PARM      *BLANKS       WRTCD             7
     C                   PARM      '*FIRST  '    WOPTN             7
     C     SDTIIN        PARM      SDTIIN        DSSDY
     C     WRTCD         IFNE      *BLANKS
     C                   MOVEL     'USR3664'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                          99
      *
     C                   ELSE
      *
      * If TI A/C code and TI Basic are not found sndusrmsg.
     C     TIATYP        IFNE      *BLANKS
     C     TIBCNO        ANDNE     *BLANKS
     C                   MOVEL     TIATYP        WTIACT            2
     C                   MOVEL     TIBCNO        WTIBCN            3
     C                   EXSR      #VBRCH
     C                   EXSR      #VCUST
     C                   EXSR      #VCURR
     C                   EXSR      #VACOD
     C/COPY WNCPYSRC,TI0010C003
      **Snd msg 'No SP101 A/C's will be set up for this customer as only one currency
      **has been entered.'
     C     MSGFLG        IFNE      'Y'
     C     CCYNUM        IFEQ      1
     C     SPACC         ANDNE     *ZEROS
      *
     C                   MOVEL     'USR3650'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        99
     C                   MOVEL     'Y'           MSGFLG            1
      *
     C                   ENDIF
     C                   ENDIF
      *
     C                   ELSE
      * Send message 'SP101 A/C Type and Basic have not been entered on the ICD'
     C                   MOVEL     'USR3649'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                          99
     C*
     C                   ENDIF
     C                   ENDIF
      *
     C     *IN99         IFEQ      *ON
     C                   WRITE     #MSGCTL
     C                   EXFMT     TI0010F1
      * Clear messages from program message queue
     C                   CALL      'Y2CLMSC'
     C                   PARM      ##PGM         ZAPGMQ
     C                   PARM      '*SAME'       ZAPGRL
     C                   SETOFF                                       99
     C                   SETOFF                                       20
     C                   SETOFF                                       21
     C                   MOVEA     '00000000'    *IN(31)
     C                   MOVEA     '00000000'    *IN(39)
     C                   MOVEA     '00000000'    *IN(47)
     C                   MOVEA     '00000000'    *IN(55)
     C                   MOVEA     '00000000'    *IN(63)
     C                   MOVEA     '00000000'    *IN(71)
     C                   MOVEA     '00000000'    *IN(79)
     C                   MOVEA     '0000'        *IN(87)
      *
     C                   ELSE
     C                   MOVEL     '1'           *INKC
     C                   MOVEL     'Y'           F3                1
     C                   ENDIF
      *
     C                   ENDDO
      *
      * Execute Main Subroutine if F3 not entered
     C     *INKC         IFEQ      *ON
     C     F3            ANDEQ     'Y'
     C                   Z-ADD     0             ACCNO
     C                   EXSR      #MAIN
      *
      * Update trailer records in ACCNTAC
     C                   EXSR      #ACCN
      *
      * Execute Subroutine to write to Printer File.
     C                   EXSR      #PRTF
      *                                                                                      BUG3772
      * Clear messages from program message queue for USR0006 to display first.              BUG3772
     C                   CALL      'Y2CLMSC'
     C                   PARM      ##PGM         ZAPGMQ
     C                   PARM      '*SAME'       ZAPGRL
      *                                                                                      BUG3772
     C                   MOVEL     'USR0006'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9928
     C                   MOVEL     'Y'           MSGFLG            1
     C                   WRITE     #MSGCTL
     C                   EXFMT     TI0010F1
      *                                                                                      BUG3772
     C     *INKC         IFEQ      *OFF
     C                   GOTO      NXTINP
     C                   ENDIF
     C                   ENDIF
      *
     C                   SETON                                        LR
     C                   RETURN
      *
      ********************************************************************
      * Main Account Opening Process.
      *
     C     #MAIN         BEGSR
      *
     C                   Z-ADD     1             @X
     C                   Z-ADD     1             @Z
     C                   MOVEL     #1BRCH        #BRCA
     C                   MOVEL     #1CUST        #CNUM
      *
     C                   MOVEA     CUR(@X)       #CCY
      *
     C     #CCY          DOWNE     *BLANKS
      *
     C**********           MOVEAACC,@Z    #1ACOD  4                                           CGL029
     C                   MOVEA     ACC(@Z)       #1ACOD           10
     C                   MOVEL     #1ACOD        #ACOD
      *
     C     #ACOD         DOWNE     *ZEROS
      *
     C     SPACC         IFEQ      #ACOD
     C     INTFLG        ANDEQ     'Y'
     C                   EXSR      #SP101
     C                   ELSE
      *
     C     KLST1         CHAIN     ACCBR                              24
      *
     C     *IN24         IFNE      '1'
      * Account already exists - check for TI Details
     C     INTFLG        IFEQ      'Y'
     C                   EXSR      EXSTA1
     C                   ELSE
     C                   EXSR      EXSTA2
     C                   ENDIF
      *
     C                   ELSE
      * Create New Account with TI Details
     C                   EXSR      NEWACC
      *
     C                   ENDIF
     C                   ENDIF
      *
      * Read the next account code in the array
     C                   ADD       1             @Z
     C     @Z            IFLE      30
     C                   MOVEA     ACC(@Z)       #1ACOD
     C                   MOVEL     #1ACOD        #ACOD
     C                   ELSE
     C                   Z-ADD     *ZEROS        #ACOD
     C                   ENDIF
      *
     C                   ENDDO
      *
      * Reset account code access number for a/c code array.
     C                   Z-ADD     1             @Z
      *
      * Read next currency in the array
     C                   ADD       1             @X
     C     @X            IFLE      30
     C                   MOVEA     CUR(@X)       #CCY
     C                   ELSE
     C                   MOVEL     *BLANKS       #CCY
     C                   ENDIF
      *
     C                   ENDDO
      *
     C                   ENDSR                                                  #MAIN
      ********************************************************************                   BUG3772
      * Reset all fields and indicators for next set of accounts.                            BUG3772
      *                                                                                      BUG3772
     C     RESET         BEGSR
      *                                                                                      BUG3772
      ** Clear Physical File TIOPACPD                                                        BUG3772
     C                   MOVEA     CMDA(1)       CMD              80
     C                   CALL      'QCMDEXC'
     C                   PARM                    CMD
     C                   PARM      80            CMDLEN           15 5
      *                                                                                      BUG3772
      * Clear messages from program message queue                                            BUG3772
     C                   CALL      'Y2CLMSC'
     C                   PARM      ##PGM         ZAPGMQ
     C                   PARM      '*SAME'       ZAPGRL
     C                   SETOFF                                       99
     C                   SETOFF                                       20
     C                   SETOFF                                       21
     C                   SETOFF                                       28
     C                   MOVEA     '00000000'    *IN(31)
     C                   MOVEA     '00000000'    *IN(39)
     C                   MOVEA     '00000000'    *IN(47)
     C                   MOVEA     '00000000'    *IN(55)
     C                   MOVEA     '00000000'    *IN(63)
     C                   MOVEA     '00000000'    *IN(71)
     C                   MOVEA     '00000000'    *IN(79)
     C                   MOVEA     '0000'        *IN(87)
     C                   MOVE      *BLANKS       SCREEN
     C                   MOVEL     '0'           *INKC
     C                   MOVEL     'N'           F3
      *                                                                                      BUG3772
     C                   ENDSR                                                  #RESET
      **************************************************************
      * Determine if TI details have been entered against the existing internal account.
      * If TI details exist write to TIOPACPD otherwise determine what they should be and
      * Update ACCNTAB and write to TIOPACPD.
      *
     C     EXSTA1        BEGSR
      *
      *
      * If TI details don't exist add these to the relevant files.
     C     A5TIAC        IFNE      'Y'
     C                   MOVEL     'B'           TOACTN
      *
     C                   MOVEA     TIA(@Z)       GDC5AT
     C                   SETOFF                                       27
      *
     C*****GDC5AT        CHAIN     SDTIACL0                           27                    MD058085
     C/EXEC SQL                                                                             MD058085
     C+ SELECT *                                                                            MD058085
     C+ into :SDTIAC                                                                        MD058085
     C+ from SDTIAJW0                                                                       MD058085
     C+ where GDC5AT = :GDC5AT                                                              MD058085
     C/END-EXEC                                                                             MD058085
     C                   SETOFF                                       27                    MD058085
     C                   If        SQLCODE = 100                                            MD058085
     C                   SETON                                        27                    MD058085
     C                   ENDIF                                                              MD058085
      *
     C     *IN27         IFEQ      *OFF
      *
     C     GDBCNO        IFEQ      *BLANKS
     C     '99'          CAT       #1ACOD        WCUST1
     C                   MOVEL     WCUST1        GDBCNO
     C                   Z-ADD     AGRDNB        GDLCD
     C                   MOVEL     'A'           GDTYLC
     C**********         UPDATE    @TIACL0                                                  MD058085
     C/EXEC SQL                                                                             MD058085
     C+ update SDTIAXTD set                                                                 MD058085
     C+   GDTYLC = :GDTYLC                                                                  MD058085
     C+  ,GDLCD  = :GDLCD                                                                   MD058085
     C+  ,GDBCNO = :GDBCNO                                                                  MD058085
     C+ where GDC5AT = :GDC5AT                                                              MD058085
     C/END-EXEC                                                                             MD058085
     C                   ELSE
     C                   MOVEL     GDBCNO        WCUST1
     C                   ENDIF
      *
     C                   MOVEL     @X            @Y
     C                   MOVEA     ISO(@Y)       WISOC             3
     C                   MOVEL     WISOC         WSUFFX            3 0
      *
     C                   ELSE
     C                   MOVE      'D'           TOACTN
     C                   ENDIF
      *
     C                   MOVEL     @X            @Y
     C                   MOVEA     ISO(@Y)       WISOC             3
     C                   MOVEL     WISOC         WSUFFX            3 0
      *
     C                   ELSE
      * TI Details exist
     C                   MOVEL     'A'           TOACTN
      * Check what the TI details should be for this account. If they are correct update
      * TIOPACPD with details otherwise report error.
      *
     C                   MOVEL     OTIAN         XCUST1            6
     C                   MOVEL     OTIAS         XSUFFX            3 0
      *
     C                   MOVEA     TIA(@Z)       GDC5AT
     C                   SETOFF                                       27
      *
     C*****GDC5AT        CHAIN     SDTIACL0                           27                    MD058085
     C/EXEC SQL                                                                             MD058085
     C+ SELECT *                                                                            MD058085
     C+ into :SDTIAC                                                                        MD058085
     C+ from SDTIAJW0                                                                       MD058085
     C+ where GDC5AT = :GDC5AT                                                              MD058085
     C/END-EXEC                                                                             MD058085
     C                   SETOFF                                       27                    MD058085
     C                   If        SQLCODE = 100                                            MD058085
     C                   SETON                                        27                    MD058085
     C                   ENDIF                                                              MD058085
      *
     C     *IN27         IFEQ      *OFF
     C                   MOVEL     GDBCNO        WCUST1
     C                   ENDIF
      *
     C                   MOVEL     @X            @Y
     C                   MOVEA     ISO(@Y)       WISOC             3
     C                   MOVEL     WISOC         WSUFFX            3 0
     C                   ENDIF
      *
     C********** XSUFFX    IFEQ WSUFFX                                                       BUG6597
     C********** XCUST1    ANDEQWCUST1                                                       BUG6597
     C     XCUST1        IFEQ      WCUST1
     C     A5TIAC        ANDEQ     'Y'
     C                   MOVEL     OTIAN         WCUST1
     C                   MOVEL     OTIAS         WSUFFX
     C                   ELSE
     C**********           MOVEL'D'       TOACTN                                             BUG6597
     C                   MOVEL     'B'           TOACTN
     C                   MOVEL     WCUST1        WTIAN
     C                   EXSR      SRTIAS
     C                   ENDIF
      *
     C**********           ENDIF                                                             BUG6597
      *
     C                   EXSR      #UPDAT
      *
     C                   ENDSR                                                  EXSTA1
      *
      *
      ********************************************************************
      * Determine if TI details have been entered against the existing external account.
      * If TI details exist write to TIOPACPD otherwise determine what they should be and
      * Update ACCNTAB and write to TIOPACPD.
      *
     C     EXSTA2        BEGSR
      *
     C                   SETOFF                                       2526
      *
     C     A5TIAC        IFNE      'Y'
      * If TI details don't exist add these to the relevant files.
     C                   MOVEL     'B'           TOACTN
     C**********           MOVELWCUST     #TNUM                                              BUG6597
      **********                                                                             BUG6597
     C********** KLST3     SETLLACCNTTI                  25                                  BUG6597
      **********                                                                             BUG6597
     C********** *IN25     IFEQ '1'                                                          BUG6597
     C**********           Z-ADD1         COUNT                                              BUG6597
      **********                                                                             BUG6597
     C********** *IN26     DOUEQ'1'                                                          BUG6597
     C********** KLST3     READEACCNTTI                  26                                  BUG6597
     C********** *IN26     IFEQ '0'                                                          BUG6597
     C**********           MOVELTTIAS     WSUFFX                                             BUG6597
     C********** WSUFFX    IFEQ COUNT                                                        BUG6597
     C**********           ADD  1         COUNT                                              BUG6597
     C**********           ELSE                                                              BUG6597
     C**********           Z-ADDCOUNT     WSUFFX                                             BUG6597
     C**********           SETON                     26                                      BUG6597
     C**********           ENDIF                                                             BUG6597
      **********                                                                             BUG6597
     C**********           ELSE                                                              BUG6597
     C**********           Z-ADDCOUNT     WSUFFX                                             BUG6597
     C**********           ENDIF                                                             BUG6597
     C**********           ENDDO                                                             BUG6597
      **********                                                                             BUG6597
     C********** WSUFFX    IFGT 999                                                          BUG6597
      **Account*cannot*be*opened**as*TI*Suffix*is*greater*than*999.                          BUG6597
     C**********           MOVE 'D'       TOACTN                                             BUG6597
     C**********           ENDIF                                                             BUG6597
      **********                                                                             BUG6597
     C**********           ELSE                                                              BUG6597
      **********                                                                             BUG6597
     C**********           MOVEL'001'     WSUFFX                                             BUG6597
     C**********           ENDIF                                                             BUG6597
     C                   MOVEL     WCUST         WTIAN
     C                   EXSR      SRTIAS
      *
     C                   ELSE
      * TI Details exist
     C                   MOVEL     'A'           TOACTN
     C                   MOVEL     OTIAN         WCUST1
     C                   MOVEL     OTIAS         WSUFFX
     C                   ENDIF
      *
      *
     C                   EXSR      #UPDAT
      *
     C                   ENDSR                                                  EXSTA2
      *
      ***********************************************************************
      * Subroutine to create details for new TI account (for both Internal and
      * External accounts).
      *
     C     NEWACC        BEGSR
      * Create New Account with TI Details
     C                   MOVEL     TYP(@Z)       WACTY             1
     C     WACTY         IFNE      'R'
     C                   MOVEL     'C'           TOACTN
     C                   MOVE      'D'           RECI
      *
      * If internal account use s/r TIDTL1 to calculate TI details otherwise
      * use s/r TIDTL2.
      *
     C     INTFLG        IFEQ      'Y'
     C                   EXSR      TIDTL1
     C**********           ELSE                                                              BUG6597
     C**********           EXSR TIDTL2                                                       BUG6597
     C                   ENDIF
      *                                                                                      BUG6597
     C                   MOVEL     WCUST1        WTIAN
     C                   EXSR      SRTIAS
      *
     C                   EXSR      #NEW
      *
     C                   ELSE
     C                   MOVEL     'D'           TOACTN
     C                   ENDIF
      *
     C                   EXSR      #UPDAT
     C                   ENDSR                                                  NEWACC
      *
      *
      ***********************************************************************
      * Subroutine to creates new details for new TI Accounts
      * (used for both Internal and External and SP101)
      *
     C     #NEW          BEGSR
      *
     C/COPY WNCPYSRC,TI0010C001
      *
     C                   MOVEL     #1CUST        #CNUM
     C**********           MOVEL#1CUST    WCUSTA  60                                          CSD027
     C                   MOVEL     #1CUST        WCUSTA            6
      *
     C     KLST1         SETGT     ACCBR
     C                   READP     ACCBR                                  29
     C     #1BRCH        IFNE      BRCA
     C     WCUSTA        ORNE      CNUM
     C     #CCY          ORNE      OCCY
     C     #ACOD         ORNE      OACOD
     C                   Z-ADD     1             WACSQ             2 0
     C                   ELSE
     C                   Z-ADD     OACSQ         WACSQ
     C     WACSQ         ADD       1             WACSQ
     C                   ENDIF
      *
      *
     C                   MOVEL     #1CUST        CNUM
     C                   MOVEL     #CCY          OCCY
     C                   MOVEL     #ACOD         OACOD
     C                   MOVE      #1BRCH        BRCA
      *
     C                   MOVEL     *BLANKS       ACST
     C                   MOVEA     TYP(@Z)       ATYP
     C                   MOVEA     SUB(@Z)       STYP
     C                   MOVEA     NAM(@Z)       ANAM
      *
     C/COPY WNCPYSRC,TI0010C005
     C                   Z-ADD     AGRDNB        DACO
     C/COPY WNCPYSRC,TI0010C006
     C                   Z-ADD     0             DACC
     C                   Z-ADD     0             LDBL
     C                   Z-ADD     0             CLBL
     C                   MOVE      'M'           STFQ
     C                   Z-ADD     31            STDY
     C                   Z-ADD     AGRDNB        LSTD
      *
      * Calculate number of Days left in Month.
      *
     C     AGDFF         IFEQ      'D'
     C                   MOVEL     AGMRDT        DAY2              2 0
     C                   ELSE
     C                   MOVE      AGMRDT        DAY4              4
     C                   MOVEL     DAY4          DAY2              2 0
     C                   ENDIF
     C     STDY          SUB       DAY2          DAY               2 0
      *
     C     AGRDNB        ADD       DAY           NSTD
     C                   Z-ADD     0             LSTP
     C                   Z-ADD     0             CFSB
     C                   Z-ADD     0             LMVD
     C                   Z-ADD     0             EPLB
     C                   Z-ADD     0             EPCB
     C                   Z-ADD     0             YTDB
     C                   BITOFF    '01234567'    GLBT
     C                   MOVEL     'B'           ADREF1
     C                   Z-ADD     AGRDNB        ORED
     C                   Z-ADD     0             DLIM
     C                   Z-ADD     0             LRCR
     C                   Z-ADD     0             RTCB
     C                   Z-ADD     0             RTLB
     C                   Z-ADD     0             DITM
     C                   Z-ADD     0             CITM
     C                   MOVE      *BLANKS       ADREF2
     C                   Z-ADD     0             CDIR
     C                   Z-ADD     0             CCIR
     C                   Z-ADD     0             ACNO
     C                   BITOFF    '01234567'    RETB
     C                   MOVE      *BLANKS       ODSC
     C                   Z-ADD     0             ODLN
     C                   Z-ADD     0             ODED
      *
     C                   Z-ADD     0             DIOD
     C                   Z-ADD     0             FACT
     C                   Z-ADD     0             FCNO
     C                   Z-ADD     0             EFAC
     C                   Z-ADD     0             HELD
     C                   Z-ADD     0             MINB
     C                   Z-ADD     0             LACD
     C                   Z-ADD     0             LISP
     C                   Z-ADD     0             RRNM
     C**********         Z-ADD     0             DRIB                                         CSD103
     C                   MOVEL     *BLANKS       DRIB                                         CSD103
     C                   Z-ADD     0             DRIS
     C                   Z-ADD     0             DRCD
     C                   Z-ADD     0             DRIC
     C                   MOVEL     *BLANKS       DRIF
     C                   Z-ADD     0             DRDY
     C                   Z-ADD     0             NDID
     C                   Z-ADD     0             LDID
     C                   Z-ADD     0             LDIA
     C                   MOVEL     *BLANKS       SDAP
     C                   Z-ADD     0             LPAR
     C                   Z-ADD     0             DIIE
     C                   Z-ADD     0             DAIC
     C                   Z-ADD     0             MADI
     C                   Z-ADD     0             GADI
     C                   MOVE      *BLANK        DDIS
     C                   Z-ADD     0             DDIA
     C                   Z-ADD     0             OLDR
     C**********         Z-ADD     0             OLDB                                         CSD103
     C                   MOVEL     *BLANKS       OLDB                                         CSD103
     C                   Z-ADD     0             OLDS
     C**********         Z-ADD     0             CRIB                                         CSD103
     C                   MOVEL     *BLANKS       CRIB                                         CSD103
     C                   Z-ADD     0             CRIS
     C                   Z-ADD     0             CRCD
     C                   Z-ADD     0             CRIC
     C                   MOVE      *BLANK        CRIF
     C                   Z-ADD     0             CRDY
     C                   Z-ADD     0             NCID
     C                   Z-ADD     0             LCID
     C                   Z-ADD     0             LCIA
     C                   MOVE      *BLANKS       SCAP
     C                   Z-ADD     0             LPAP
     C                   Z-ADD     0             CIIE
     C                   Z-ADD     0             CAIC
     C                   Z-ADD     0             MACI
     C                   Z-ADD     0             GACI
     C                   MOVE      *BLANK        CDIS
     C                   Z-ADD     0             DCIA
     C                   Z-ADD     0             OLCR
     C**********         Z-ADD     0             OLCB                                         CSD103
     C                   MOVEL     *BLANKS       OLCB                                         CSD103
     C                   Z-ADD     0             OLCS
     C                   Z-ADD     AGRDNB        LCD
     C                   MOVE      'I'           CHTP
     C                   Z-ADD     0             TNLU
     C                   MOVE      *BLANK        BRTCA
     C                   MOVE      'Y'           R4ACNT
     C                   Z-ADD     0             ENOC
     C                   Z-ADD     0             EPNO
     C                   Z-ADD     0             ECFB
     C                   MOVE      *BLANKS       LTAB
     C                   Z-ADD     0             LTAS
     C                   Z-ADD     0             HCFB
     C                   MOVE      TIPRFC        PTFR
     C                   MOVE      *BLANK        HLEX
      *
      * Check to see if CEU013 is on to determine default for EUSB
      *
     C                   CALL      'AOSARDR0'
     C                   PARM      '        '    WRTCD
     C                   PARM      '*VERIFY'     WOPTN
     C                   PARM      'CEU013'      WSARD             6
      *
      * If the return code is blank then CEU013 is *ON.
      *
     C     WRTCD         IFEQ      *BLANKS
     C                   MOVE      'Y'           EUSB
     C                   ELSE
     C                   MOVE      'N'           EUSB
     C                   ENDIF
      *
     C/COPY WNCPYSRC,TI0010C002
      *
     C                   ENDSR                                                  #NEW
      *
      ********************************************************************
      * TI Details for a new internal TI account.
      *
     C     TIDTL1        BEGSR
      * Create TI Details for an Internal Account
     C                   MOVEA     TIA(@Z)       GDC5AT
      *
     C                   SETOFF                                       27
      *
     C*****GDC5AT        CHAIN     SDTIACL0                           27                    MD058085
     C/EXEC SQL                                                                             MD058085
     C+ SELECT *                                                                            MD058085
     C+ into :SDTIAC                                                                        MD058085
     C+ from SDTIAJW0                                                                       MD058085
     C+ where GDC5AT = :GDC5AT                                                              MD058085
     C/END-EXEC                                                                             MD058085
     C                   SETOFF                                       27                    MD058085
     C                   If        SQLCODE = 100                                            MD058085
     C                   SETON                                        27                    MD058085
     C                   ENDIF                                                              MD058085
      *
     C     *IN27         IFEQ      *OFF
      *
     C     GDBCNO        IFEQ      *BLANKS
     C     '99'          CAT       #1ACOD        WCUST1
     C                   MOVEL     WCUST1        GDBCNO
     C                   Z-ADD     AGRDNB        GDLCD
     C                   MOVEL     'A'           GDTYLC
     C**********         UPDATE    @TIACL0                                                  MD058085
     C/EXEC SQL                                                                             MD058085
     C+ update SDTIAXTD set                                                                 MD058085
     C+   GDTYLC = :GDTYLC                                                                  MD058085
     C+  ,GDLCD  = :GDLCD                                                                   MD058085
     C+  ,GDBCNO = :GDBCNO                                                                  MD058085
     C+ where GDC5AT = :GDC5AT                                                              MD058085
     C/END-EXEC                                                                             MD058085
     C                   ELSE
     C                   MOVEL     GDBCNO        WCUST1
     C                   ENDIF
      *
     C                   MOVEL     @X            @Y
     C                   MOVEA     ISO(@Y)       WISOC             3
     C                   MOVEL     WISOC         WSUFFX
     C                   ENDIF
      *
      *
     C                   ENDSR                                                  TIDTL1
      *
      ********************************************************************
      **TI*Details*for*a*new*external*TI*account.**********************                      BUG6597
      **********                                                                             BUG6597
     C********** TIDTL2    BEGSR                                                             BUG6597
     C**********           MOVELWCUST     #TNUM                                              BUG6597
      **********                                                                             BUG6597
     C**********           SETOF                     2526                                    BUG6597
      **********                                                                             BUG6597
     C********** KLST3     SETLLACCNTTI                  25                                  BUG6597
      **********                                                                             BUG6597
     C********** *IN25     IFEQ '1'                                                          BUG6597
     C**********           Z-ADD1         COUNT   30                                         BUG6597
      **********                                                                             BUG6597
     C********** *IN26     DOUEQ'1'                                                          BUG6597
     C********** KLST3     READEACCNTTI                  26                                  BUG6597
     C********** *IN26     IFEQ '0'                                                          BUG6597
     C**********           MOVELTTIAS     WSUFFX                                             BUG6597
     C********** WSUFFX    IFEQ COUNT                                                        BUG6597
     C**********           ADD  1         COUNT                                              BUG6597
     C**********           ELSE                                                              BUG6597
     C**********           Z-ADDCOUNT     WSUFFX                                             BUG6597
     C**********           SETON                     26                                      BUG6597
     C**********           ENDIF                                                             BUG6597
      **********                                                                             BUG6597
     C**********           ELSE                                                              BUG6597
     C**********           Z-ADDCOUNT     WSUFFX                                             BUG6597
     C**********           ENDIF                                                             BUG6597
     C**********           ENDDO                                                             BUG6597
      **********                                                                             BUG6597
     C********** WSUFFX    IFGT 999                                                          BUG6597
      **Account*cannot*be*opened**as*TI*Suffix*is*greater*than*999.****                      BUG6597
     C**********           MOVE 'D'       TOACTN                                             BUG6597
     C**********           ENDIF                                                             BUG6597
      **********                                                                             BUG6597
     C**********           ELSE                                                              BUG6597
      **********                                                                             BUG6597
     C**********           MOVEL'001'     WSUFFX                                             BUG6597
     C**********           ENDIF                                                             BUG6597
      **********                                                                             BUG6597
     C**********           ENDSR                           TIDTL2                            BUG6597
      *
      ********************************************************************
      * Determine TI Details for accounts if Exchange Position Accounts are required
     C     #SP101        BEGSR
      *
     C     CCYNUM        IFGT      1
     C                   Z-ADD     1             @V                2 0
     C                   MOVEA     ISO(@X)       #ISO              3
     C     WTIBCN        CAT       #ISO          XCUST1
     C                   MOVEA     ISO(@V)       ISO1              3
      *
     C     ISO1          DOWNE     *BLANKS
     C     #ISO          IFNE      ISO1
     C                   MOVEL     ISO1          XSUFFX            3 0
      *
     C                   MOVEL     #1BRCH        #BRCA
     C                   MOVEL     XCUST1        #TNUM
     C                   MOVEL     XSUFFX        #TSUF
      *
     C     KLST2         CHAIN     ACCNTTI                            29
      *
      * If Indicator is off then account has been found
      *
     C     *IN29         IFNE      '1'
      *
     C                   MOVEL     'A'           TOACTN
     C                   MOVEL     XCUST1        WCUST1
     C                   MOVEL     XSUFFX        WSUFFX
     C                   ELSE
      * Create new account/check account details.
      *
     C                   MOVEL     'C'           TOACTN
     C                   MOVEL     XCUST1        WCUST1
     C                   MOVEL     XSUFFX        WSUFFX
     C                   EXSR      NEWSP
     C                   ENDIF
      *
     C                   EXSR      #UPDAT
     C                   ENDIF
      *
     C                   ADD       1             @V
     C     @V            IFLE      30
     C                   MOVEA     ISO(@V)       ISO1
     C                   ELSE
     C                   MOVEL     *BLANKS       ISO1
     C                   ENDIF
      *
     C                   ENDDO
      *
     C                   ENDIF
      *
     C                   ENDSR                                                  #SP101
      *
      ********************************************************************
      * Create new Exchange Position Accounts
     C     NEWSP         BEGSR
      *
     C                   MOVE      'D'           RECI
     C                   EXSR      #NEW
      *
     C                   ENDSR                                                  NEWSP
      ********************************************************************
      *
     C     #UPDAT        BEGSR
      *
     C                   MOVEL     #1BRCH        TOBRCH
     C                   MOVEL     #1CUST        TOCUST
     C                   MOVEL     #CCY          TOCCY
     C                   MOVEL     #ACOD         TOACOD
     C                   MOVEL     NAM(@Z)       TOANAM
     C                   MOVEL     'Y'           TOTIAC
     C                   MOVEL     WCUST1        TOTIAN
     C                   MOVEL     WSUFFX        TOTIAS
     C                   MOVEL     DSACKY        A5ACKY
      *
     C                   SELECT
     C     TOACTN        WHENEQ    'A'
     C     INTFLG        IFEQ      'Y'
     C     #ACOD         ANDEQ     SPACC
     C                   MOVEL     TACSQ         TOACSQ
     C                   ELSE
     C                   MOVEL     OACSQ         TOACSQ
     C                   ENDIF
     C                   OPEN      TIOPACPD
     C                   WRITE     TIOPACD0
     C                   CLOSE     TIOPACPD
      *
     C     TOACTN        WHENEQ    'B'
     C                   MOVEL     OACSQ         TOACSQ
     C                   MOVEL     'Y'           A5TIAC
     C                   MOVEL     WCUST1        OTIAN
     C                   MOVEL     WSUFFX        OTIAS
     C* To ensure only TI specific fields are updated use EXCPT with            180464
     C* the fields required on the Output Specs.                                180464
     C*********************UPDATACCNT1                                          180464
     C                   EXCEPT    UPDTIF
     C                   OPEN      TIOPACPD
     C                   WRITE     TIOPACD0
     C                   CLOSE     TIOPACPD
      *
     C     TOACTN        WHENEQ    'C'
     C                   MOVEL     #1BRCH        BRCA
     C                   MOVEL     #1CUST        CNUM
     C                   MOVEL     #CCY          OCCY
     C                   MOVEL     #ACOD         OACOD
     C                   MOVEL     WACSQ         OACSQ
     C                   MOVEL     'Y'           A5TIAC
     C                   MOVEL     WCUST1        OTIAN
     C                   MOVEL     WSUFFX        OTIAS
     C                   MOVEL     WACSQ         TOACSQ
      *
     C**********           ADD  1         ACCNO   20                                          191086
     C                   ADD       1             ACCNO             4 0
      *
     C**********         MOVEA     STAMP(1)      TMST                           Default TimeMD058085
     C                   MOVEL     STAMP         TMST                           Default TimeMD058085
     C                   WRITE     ACCNT1
     C                   COMMIT                                                        BUG14016
      *
     C                   OPEN      TIOPACPD
     C                   WRITE     TIOPACD0
     C                   CLOSE     TIOPACPD
      *
     C     TOACTN        WHENEQ    'D'
     C                   OPEN      TIOPACPD
     C                   WRITE     TIOPACD0
     C                   CLOSE     TIOPACPD
     C                   ENDSL
      *                                                                                     BUG13929
     C     TOACTN        IFNE      *BLANKS
     C                   EXSR      WGLEXT
     C                   ENDIF
      *
     C                   ENDSR                                                  #UPDAT
      *
      ********************************************************************
      *
     C     #PRTF         BEGSR
     C                   Z-ADD     0             CNT1              3 0
     C                   Z-ADD     0             CNT2              3 0
     C                   Z-ADD     0             CNT3              3 0
     C                   Z-ADD     0             CNT4              3 0
     C                   OPEN      TI0010P1
      *
     C                   WRITE     HEADP1
      *
     C                   WRITE     HEADPA
     C                   WRITE     SUBHEAD
     C                   OPEN      TIOPACL1
     C                   READ      TIOPACL1                               29
      *
     C     TOACTN        DOWEQ     'A'
     C     *IN29         ANDNE     *ON
     C                   ADD       1             CNT1
     C     *IN37         IFEQ      *ON
     C                   WRITE     HEADP1
     C                   WRITE     HEADPA
     C                   WRITE     SUBHEAD
     C                   SETOFF                                       37
     C                   ENDIF
     C                   WRITE     DETAIL
     C                   READ      TIOPACL1                               29
     C                   ENDDO
     C     CNT1          IFEQ      0
     C                   WRITE     DETAIL2
     C                   ENDIF
      *
     C     *IN37         IFEQ      *ON
     C                   WRITE     HEADP1
     C                   SETOFF                                       37
     C                   ENDIF
     C                   WRITE     HEADPB
     C                   WRITE     SUBHEAD
     C     TOACTN        DOWEQ     'B'
     C     *IN29         ANDNE     *ON
     C                   ADD       1             CNT2
     C     *IN37         IFEQ      *ON
     C                   WRITE     HEADP1
     C                   WRITE     HEADPB
     C                   WRITE     SUBHEAD
     C                   SETOFF                                       37
     C                   ENDIF
     C                   WRITE     DETAIL
     C                   READ      TIOPACL1                               29
     C                   ENDDO
     C     CNT2          IFEQ      0
     C                   WRITE     DETAIL2
     C                   ENDIF
      *
     C     *IN37         IFEQ      *ON
     C                   WRITE     HEADP1
     C                   SETOFF                                       37
     C                   ENDIF
     C                   WRITE     HEADPC
     C                   WRITE     SUBHEAD
     C     TOACTN        DOWEQ     'C'
     C     *IN29         ANDNE     *ON
     C                   ADD       1             CNT3
     C     *IN37         IFEQ      *ON
     C                   WRITE     HEADP1
     C                   WRITE     HEADPC
     C                   WRITE     SUBHEAD
     C                   SETOFF                                       37
     C                   ENDIF
     C                   WRITE     DETAIL
     C                   READ      TIOPACL1                               29
     C                   ENDDO
     C     CNT3          IFEQ      0
     C                   WRITE     DETAIL2
     C                   ENDIF
      *
     C     *IN37         IFEQ      *ON
     C                   WRITE     HEADP1
     C                   SETOFF                                       37
     C                   ENDIF
     C                   WRITE     HEADPD
     C                   WRITE     SUBHEAD
     C     TOACTN        DOWEQ     'D'
     C     *IN29         ANDNE     *ON
     C                   ADD       1             CNT4
     C     *IN37         IFEQ      *ON
     C                   WRITE     HEADP1
     C                   WRITE     HEADPD
     C                   WRITE     SUBHEAD
     C                   SETOFF                                       37
     C                   ENDIF
     C                   WRITE     DETAIL
     C                   READ      TIOPACL1                               29
     C                   ENDDO
     C     CNT4          IFEQ      0
     C                   WRITE     DETAIL2
     C                   ENDIF
      *
     C     *IN37         IFEQ      *ON
     C                   WRITE     HEADP1
     C                   SETOFF                                       37
     C                   ENDIF
     C                   WRITE     TRAILP1
     C                   CLOSE     TI0010P1
     C                   CLOSE     TIOPACL1
     C                   ENDSR                                                  #PRTF
      *
      ********************************************************************
      *
     C     #ACCN         BEGSR
      * Update trailer records on ACCNTAC
      *
     C     ACCNO         IFGT      *ZERO
     C                   OPEN      ACCNTAC
     C     1             SETLL     ACCNTAC
     C                   READ      ACCNTAC                                30
     C**********           Z-ADDACCNO     NINU                            185144
     C                   ADD       ACCNO         NINU                                          18514
     C     NOAU          ADD       ACCNO         NOAU
     C                   UPDATE    ACCNTACF
     C                   CLOSE     ACCNTAC
     C                   ENDIF
      *
     C                   ENDSR                                                  #ACCN
      *
      ********************************************************************
      *
     C     #VBRCH        BEGSR
      * Validate branch
     C     #1BRCH        IFNE      *BLANK
      *
      * Question mark processing
     C     #1BRCH        IFEQ      '?'
     C     #1BRCH        OREQ      ' ?'
     C     #1BRCH        OREQ      '  ?'
     C                   CALL      'SD0061S'
     C                   PARM      *BLANKS       WRTCD
     C     #1BRCH        PARM      #1BRCH        WBRCD
     C                   ENDIF
      *
     C     WRTCD         IFNE      'Y2U0016'
     C                   CALL      'AOBRCHR1'
     C                   PARM      *BLANKS       WRTCD             7
     C                   PARM      '*KEY    '    WOPTN             7
     C                   PARM      #1BRCH        WBRCD             3
     C     SDBRCH        PARM      SDBRCH        DSSDY
      * If branch is not found
     C     WRTCD         IFNE      *BLANK
      * Send message 'Branch invalid'
     C                   MOVEL     'USR3651'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        2099
     C                   ELSE
      * Check if the branch has been set up as a TI branch
     C     A8TIBR        IFEQ      *ZEROS
      * Send message 'Branch is not set up as a TI branch'
     C                   MOVEL     'USR3652'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        2099
     C                   ELSE
      * Store branch internal customer number
     C                   MOVEL     A8BICN        WBICN             6
     C                   ENDIF
     C                   ENDIF
      *
     C                   ELSE
     C                   SETON                                        2099
     C                   ENDIF
      *
     C                   ELSE
      * Send message 'Branch code must be entered
     C                   MOVEL     'USR3653'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        2099
     C                   ENDIF
      *
      *
     C                   ENDSR                                                  #VBRCH
      *
      *******************************************************************
      *
     C     #VCUST        BEGSR
      *
      ** Validate Customer - Valid Midas Cust and ensure it is flagged as TI Customer.
     C     #1CUST        IFNE      *BLANKS
      *
      * Question mark processing
     C     #1CUST        IFEQ      '?'
     C     #1CUST        OREQ      ' ?'
     C     #1CUST        OREQ      '  ?'
     C     #1CUST        OREQ      '   ?'
     C     #1CUST        OREQ      '    ?'
     C     #1CUST        OREQ      '     ?'
     C                   CALL      'SD0010S'
     C                   PARM      *BLANKS       WRTCD
     C     #1CUST        PARM      #1CUST        WCUST
     C                   ENDIF
      *
     C     WRTCD         IFNE      'Y2U0016'
     C                   CALL      'AOCUSTR0'
     C                   PARM      *BLANKS       WRTCD             7
     C                   PARM      '*KEY    '    WOPTN             7
     C                   PARM      #1CUST        WCUST            10
     C                   PARM      '*ERROR  '    WSTAT             7
     C     SDCUST        PARM      SDCUST        DSSDY
      *
      * If customer is not found
     C     WRTCD         IFNE      *BLANK
      *
      * Send message 'Customer Invalid'
     C                   MOVEL     'USR3654'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        2199
     C                   ELSE
      * Check if the customer has been set up as a TI customer
     C     BBTICS        IFEQ      *BLANKS
     C     BBTICS        OREQ      'N'
      * Send message 'Customer is not set up as a TI Customer'
     C                   MOVEL     'USR3655'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        2199
     C                   ELSE
      **Store Customer Number
     C                   MOVEL     #1CUST        WCUST1            6
     C                   ENDIF
     C                   ENDIF
      *
      ** Check if customer number is equal to branch internal customer number.
     C     WCUST1        IFEQ      WBICN
     C                   MOVE      'Y'           INTFLG            1
     C                   ELSE
     C                   MOVE      'N'           INTFLG
     C                   ENDIF
      *
     C                   ELSE
     C                   SETON                                        2199
     C                   ENDIF
      *
     C                   ELSE
      * Send message 'Customer number must be entered'
     C                   MOVEL     'USR3656'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        2199
     C                   ENDIF
      *
      *
     C                   ENDSR                                                  #VCUST
      *
      ********************************************************************
      *
     C     #VCURR        BEGSR
      ** Validate Currencies - must be valid Midas Ccy's and ensure the ccy has an ISO code if the
      ** branch is an internal customer.
     C                   MOVEA     *BLANKS       CUR
     C                   MOVEA     *BLANKS       ISO
     C                   Z-ADD     0             @W                2 0
     C                   Z-ADD     0             @X                2 0
     C                   Z-ADD     0             @Y                2 0
     C                   Z-ADD     0             CCYNUM            2 0
      *
     C     #1CY01        IFNE      *BLANKS
     C                   MOVEL     #1CY01        WCURR             3
     C                   Z-ADD     31            @W
     C                   EXSR      #VCCY
     C                   MOVEL     WCURR         #1CY01
     C                   ENDIF
     C     #1CY02        IFNE      *BLANKS
     C                   MOVEL     #1CY02        WCURR             3
     C                   Z-ADD     32            @W
     C                   EXSR      #VCCY
     C                   MOVEL     WCURR         #1CY02
     C                   ENDIF
     C     #1CY03        IFNE      *BLANKS
     C                   MOVEL     #1CY03        WCURR             3
     C                   Z-ADD     33            @W
     C                   EXSR      #VCCY
     C                   MOVEL     WCURR         #1CY03
     C                   ENDIF
     C     #1CY04        IFNE      *BLANKS
     C                   MOVEL     #1CY04        WCURR             3
     C                   Z-ADD     34            @W
     C                   EXSR      #VCCY
     C                   MOVEL     WCURR         #1CY04
     C                   ENDIF
     C     #1CY05        IFNE      *BLANKS
     C                   MOVEL     #1CY05        WCURR             3
     C                   Z-ADD     35            @W
     C                   EXSR      #VCCY
     C                   MOVEL     WCURR         #1CY05
     C                   ENDIF
     C     #1CY06        IFNE      *BLANKS
     C                   MOVEL     #1CY06        WCURR             3
     C                   Z-ADD     36            @W
     C                   EXSR      #VCCY
     C                   MOVEL     WCURR         #1CY06
     C                   ENDIF
     C     #1CY07        IFNE      *BLANKS
     C                   MOVEL     #1CY07        WCURR             3
     C                   Z-ADD     37            @W
     C                   EXSR      #VCCY
     C                   MOVEL     WCURR         #1CY07
     C                   ENDIF
     C     #1CY08        IFNE      *BLANKS
     C                   MOVEL     #1CY08        WCURR             3
     C                   Z-ADD     38            @W
     C                   EXSR      #VCCY
     C                   MOVEL     WCURR         #1CY08
     C                   ENDIF
     C     #1CY09        IFNE      *BLANKS
     C                   MOVEL     #1CY09        WCURR             3
     C                   Z-ADD     39            @W
     C                   EXSR      #VCCY
     C                   MOVEL     WCURR         #1CY09
     C                   ENDIF
     C     #1CY10        IFNE      *BLANKS
     C                   MOVEL     #1CY10        WCURR             3
     C                   Z-ADD     40            @W
     C                   EXSR      #VCCY
     C                   MOVEL     WCURR         #1CY10
     C                   ENDIF
     C     #1CY11        IFNE      *BLANKS
     C                   MOVEL     #1CY11        WCURR             3
     C                   Z-ADD     41            @W
     C                   EXSR      #VCCY
     C                   MOVEL     WCURR         #1CY11
     C                   ENDIF
     C     #1CY12        IFNE      *BLANKS
     C                   MOVEL     #1CY12        WCURR             3
     C                   Z-ADD     42            @W
     C                   EXSR      #VCCY
     C                   MOVEL     WCURR         #1CY12
     C                   ENDIF
     C     #1CY13        IFNE      *BLANKS
     C                   MOVEL     #1CY13        WCURR             3
     C                   Z-ADD     43            @W
     C                   EXSR      #VCCY
     C                   MOVEL     WCURR         #1CY13
     C                   ENDIF
     C     #1CY14        IFNE      *BLANKS
     C                   MOVEL     #1CY14        WCURR             3
     C                   Z-ADD     44            @W
     C                   EXSR      #VCCY
     C                   MOVEL     WCURR         #1CY14
     C                   ENDIF
     C     #1CY15        IFNE      *BLANKS
     C                   MOVEL     #1CY15        WCURR             3
     C                   Z-ADD     45            @W
     C                   EXSR      #VCCY
     C                   MOVEL     WCURR         #1CY15
     C                   ENDIF
     C     #1CY16        IFNE      *BLANKS
     C                   MOVEL     #1CY16        WCURR             3
     C                   Z-ADD     46            @W
     C                   EXSR      #VCCY
     C                   MOVEL     WCURR         #1CY16
     C                   ENDIF
     C     #1CY17        IFNE      *BLANKS
     C                   MOVEL     #1CY17        WCURR             3
     C                   Z-ADD     47            @W
     C                   EXSR      #VCCY
     C                   MOVEL     WCURR         #1CY17
     C                   ENDIF
     C     #1CY18        IFNE      *BLANKS
     C                   MOVEL     #1CY18        WCURR             3
     C                   Z-ADD     48            @W
     C                   EXSR      #VCCY
     C                   MOVEL     WCURR         #1CY18
     C                   ENDIF
     C     #1CY19        IFNE      *BLANKS
     C                   MOVEL     #1CY19        WCURR             3
     C                   Z-ADD     49            @W
     C                   EXSR      #VCCY
     C                   MOVEL     WCURR         #1CY19
     C                   ENDIF
     C     #1CY20        IFNE      *BLANKS
     C                   MOVEL     #1CY20        WCURR             3
     C                   Z-ADD     50            @W
     C                   EXSR      #VCCY
     C                   MOVEL     WCURR         #1CY20
     C                   ENDIF
     C     #1CY21        IFNE      *BLANKS
     C                   MOVEL     #1CY21        WCURR             3
     C                   Z-ADD     51            @W
     C                   EXSR      #VCCY
     C                   MOVEL     WCURR         #1CY21
     C                   ENDIF
     C     #1CY22        IFNE      *BLANKS
     C                   MOVEL     #1CY22        WCURR             3
     C                   Z-ADD     52            @W
     C                   EXSR      #VCCY
     C                   MOVEL     WCURR         #1CY22
     C                   ENDIF
     C     #1CY23        IFNE      *BLANKS
     C                   MOVEL     #1CY23        WCURR             3
     C                   Z-ADD     53            @W
     C                   EXSR      #VCCY
     C                   MOVEL     WCURR         #1CY23
     C                   ENDIF
     C     #1CY24        IFNE      *BLANKS
     C                   MOVEL     #1CY24        WCURR             3
     C                   Z-ADD     54            @W
     C                   EXSR      #VCCY
     C                   MOVEL     WCURR         #1CY24
     C                   ENDIF
     C     #1CY25        IFNE      *BLANKS
     C                   MOVEL     #1CY25        WCURR             3
     C                   Z-ADD     55            @W
     C                   EXSR      #VCCY
     C                   MOVEL     WCURR         #1CY25
     C                   ENDIF
     C     #1CY26        IFNE      *BLANKS
     C                   MOVEL     #1CY26        WCURR             3
     C                   Z-ADD     56            @W
     C                   EXSR      #VCCY
     C                   MOVEL     WCURR         #1CY26
     C                   ENDIF
     C     #1CY27        IFNE      *BLANKS
     C                   MOVEL     #1CY27        WCURR             3
     C                   Z-ADD     57            @W
     C                   EXSR      #VCCY
     C                   MOVEL     WCURR         #1CY27
     C                   ENDIF
     C     #1CY28        IFNE      *BLANKS
     C                   MOVEL     #1CY28        WCURR             3
     C                   Z-ADD     58            @W
     C                   EXSR      #VCCY
     C                   MOVEL     WCURR         #1CY28
     C                   ENDIF
     C     #1CY29        IFNE      *BLANKS
     C                   MOVEL     #1CY29        WCURR             3
     C                   Z-ADD     59            @W
     C                   EXSR      #VCCY
     C                   MOVEL     WCURR         #1CY29
     C                   ENDIF
     C     #1CY30        IFNE      *BLANKS
     C                   MOVEL     #1CY30        WCURR             3
     C                   Z-ADD     60            @W
     C                   EXSR      #VCCY
     C                   MOVEL     WCURR         #1CY30
     C                   ENDIF
      *
      **Send message 'At least one Currency code must be entered'
     C     CCYNUM        IFEQ      0
     C                   MOVEL     'USR3663'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        3199
     C                   ENDIF
      *
     C                   ENDSR                                                  #VCURR
      *
      ********************************************************************
      *
     C     #VCCY         BEGSR
      **Subroutine contains common currency validation
     C                   MOVEL     *BLANKS       WRTCD
      **Question mark processing
     C     WCURR         IFEQ      '?'
     C     WCURR         OREQ      ' ?'
     C     WCURR         OREQ      '  ?'
     C                   CALL      'SD0020S'
     C                   PARM      *BLANKS       WRTCD
     C     WCURR         PARM      WCURR         WCCY1
     C                   ENDIF
      *
     C     WRTCD         IFNE      'Y2U0016'
     C                   CALL      'AOCURRR0'
     C                   PARM      *BLANKS       WRTCD             7
     C                   PARM      '*KEY    '    WOPTN             7
     C                   PARM      WCURR         WCCY1             3
     C     SDCURR        PARM      SDCURR        DSSDY
      *
      **If currency is not found
     C     WRTCD         IFNE      *BLANK
      *
      **Send message 'Currency Invalid'
     C                   MOVEL     'USR3644'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                          99
     C                   MOVE      '1'           *IN(@W)
     C                   ELSE
      **Check array for duplicates entries.
     C     WCURR         LOOKUP    CUR                                    22
      *
     C     *IN22         IFEQ      *ON
      **Send message 'Currency already entered - pls reenter another valid currency'
     C                   MOVEL     'USR3657'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                          99
     C                   MOVE      '1'           *IN(@W)
     C                   ELSE
      *
      **Check if the currency has an associated ISO if the customer is the same as the
      * Branch Internal Customer.
     C     INTFLG        IFEQ      'Y'
     C                   CALL      'AOISOCR0'
     C                   PARM      *BLANKS       WRTCD             7
     C                   PARM      '*KEY    '    WOPTN             7
     C                   PARM      WCURR         WCCY1             3
     C     SDISOC        PARM      *BLANKS       DSSDY
      *
     C     WRTCD         IFEQ      '*NRF'
     C     WRTCD         OREQ      '*ERROR'
      **Send message 'Currency must have an associated ISO code.'
     C                   MOVEL     'USR3658'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                          99
     C                   MOVE      '1'           *IN(@W)
     C                   ADD       1             @Y
     C                   MOVE      *ZEROS        ISO(@Y)
     C                   ELSE
      **Store ISO code in the array.
     C                   ADD       1             @Y
     C                   MOVEL     GIISO3        ISO(@Y)
     C                   MOVEL     @Y            ISONUM            2 0
     C                   ENDIF
     C                   ENDIF
      **Store Currency in array CUR
     C                   ADD       1             @X
     C                   MOVEL     WCURR         CUR(@X)
     C                   MOVEL     @X            CCYNUM            2 0
     C                   ENDIF
     C                   ENDIF
      *
     C                   ELSE
     C                   SETON                                        99
     C                   MOVE      *ON           *IN(@W)
     C                   ENDIF
      *
     C                   ENDSR                                                  #VCCY
      *
      **********************************************************************
      *
      ** Validate A/C Codes - must be valid A/C code and have TI A/C type.
      *
     C     #VACOD        BEGSR
      *
     C                   MOVEA     *ZEROS        ACC
     C                   Z-ADD     0             @W
     C                   Z-ADD     0             @Z                2 0
      *
     C     #1AC01        IFNE      *BLANKS
     C**********           MOVEL#1AC01    WACOD   4                                           CGL029
     C                   MOVEL     #1AC01        WACOD            10
     C                   Z-ADD     61            @W
     C                   EXSR      #VACC
     C                   MOVEL     WACOD         #1AC01
     C                   ENDIF
     C     #1AC02        IFNE      *BLANKS
     C                   MOVEL     #1AC02        WACOD
     C                   Z-ADD     62            @W
     C                   EXSR      #VACC
     C                   MOVEL     WACOD         #1AC02
     C                   ENDIF
     C     #1AC03        IFNE      *BLANKS
     C                   MOVEL     #1AC03        WACOD
     C                   Z-ADD     63            @W
     C                   EXSR      #VACC
     C                   MOVEL     WACOD         #1AC03
     C                   ENDIF
     C     #1AC04        IFNE      *BLANKS
     C                   MOVEL     #1AC04        WACOD
     C                   Z-ADD     64            @W
     C                   EXSR      #VACC
     C                   MOVEL     WACOD         #1AC04
     C                   ENDIF
     C     #1AC05        IFNE      *BLANKS
     C                   MOVEL     #1AC05        WACOD
     C                   Z-ADD     65            @W
     C                   EXSR      #VACC
     C                   MOVEL     WACOD         #1AC05
     C                   ENDIF
     C     #1AC06        IFNE      *BLANKS
     C                   MOVEL     #1AC06        WACOD
     C                   Z-ADD     66            @W
     C                   EXSR      #VACC
     C                   MOVEL     WACOD         #1AC06
     C                   ENDIF
     C     #1AC07        IFNE      *BLANKS
     C                   MOVEL     #1AC07        WACOD
     C                   Z-ADD     67            @W
     C                   EXSR      #VACC
     C                   MOVEL     WACOD         #1AC07
     C                   ENDIF
     C     #1AC08        IFNE      *BLANKS
     C                   MOVEL     #1AC08        WACOD
     C                   Z-ADD     68            @W
     C                   EXSR      #VACC
     C                   MOVEL     WACOD         #1AC08
     C                   ENDIF
     C     #1AC09        IFNE      *BLANKS
     C                   MOVEL     #1AC09        WACOD
     C                   Z-ADD     69            @W
     C                   EXSR      #VACC
     C                   MOVEL     WACOD         #1AC09
     C                   ENDIF
     C     #1AC10        IFNE      *BLANKS
     C                   MOVEL     #1AC10        WACOD
     C                   Z-ADD     70            @W
     C                   EXSR      #VACC
     C                   MOVEL     WACOD         #1AC10
     C                   ENDIF
     C     #1AC11        IFNE      *BLANKS
     C                   MOVEL     #1AC11        WACOD
     C                   Z-ADD     71            @W
     C                   EXSR      #VACC
     C                   MOVEL     WACOD         #1AC11
     C                   ENDIF
     C     #1AC12        IFNE      *BLANKS
     C                   MOVEL     #1AC12        WACOD
     C                   Z-ADD     72            @W
     C                   EXSR      #VACC
     C                   MOVEL     WACOD         #1AC12
     C                   ENDIF
     C     #1AC13        IFNE      *BLANKS
     C                   MOVEL     #1AC13        WACOD
     C                   Z-ADD     73            @W
     C                   EXSR      #VACC
     C                   MOVEL     WACOD         #1AC13
     C                   ENDIF
     C     #1AC14        IFNE      *BLANKS
     C                   MOVEL     #1AC14        WACOD
     C                   Z-ADD     74            @W
     C                   EXSR      #VACC
     C                   MOVEL     WACOD         #1AC14
     C                   ENDIF
     C     #1AC15        IFNE      *BLANKS
     C                   MOVEL     #1AC15        WACOD
     C                   Z-ADD     75            @W
     C                   EXSR      #VACC
     C                   MOVEL     WACOD         #1AC15
     C                   ENDIF
     C     #1AC16        IFNE      *BLANKS
     C                   MOVEL     #1AC16        WACOD
     C                   Z-ADD     76            @W
     C                   EXSR      #VACC
     C                   MOVEL     WACOD         #1AC16
     C                   ENDIF
     C     #1AC17        IFNE      *BLANKS
     C                   MOVEL     #1AC17        WACOD
     C                   Z-ADD     77            @W
     C                   EXSR      #VACC
     C                   MOVEL     WACOD         #1AC17
     C                   ENDIF
     C     #1AC18        IFNE      *BLANKS
     C                   MOVEL     #1AC18        WACOD
     C                   Z-ADD     78            @W
     C                   EXSR      #VACC
     C                   MOVEL     WACOD         #1AC18
     C                   ENDIF
     C     #1AC19        IFNE      *BLANKS
     C                   MOVEL     #1AC19        WACOD
     C                   Z-ADD     79            @W
     C                   EXSR      #VACC
     C                   MOVEL     WACOD         #1AC19
     C                   ENDIF
     C     #1AC20        IFNE      *BLANKS
     C                   MOVEL     #1AC20        WACOD
     C                   Z-ADD     80            @W
     C                   EXSR      #VACC
     C                   MOVEL     WACOD         #1AC20
     C                   ENDIF
     C     #1AC21        IFNE      *BLANKS
     C                   MOVEL     #1AC21        WACOD
     C                   Z-ADD     81            @W
     C                   EXSR      #VACC
     C                   MOVEL     WACOD         #1AC21
     C                   ENDIF
     C     #1AC22        IFNE      *BLANKS
     C                   MOVEL     #1AC22        WACOD
     C                   Z-ADD     82            @W
     C                   EXSR      #VACC
     C                   MOVEL     WACOD         #1AC22
     C                   ENDIF
     C     #1AC23        IFNE      *BLANKS
     C                   MOVEL     #1AC23        WACOD
     C                   Z-ADD     83            @W
     C                   EXSR      #VACC
     C                   MOVEL     WACOD         #1AC23
     C                   ENDIF
     C     #1AC24        IFNE      *BLANKS
     C                   MOVEL     #1AC24        WACOD
     C                   Z-ADD     84            @W
     C                   EXSR      #VACC
     C                   MOVEL     WACOD         #1AC24
     C                   ENDIF
     C     #1AC25        IFNE      *BLANKS
     C                   MOVEL     #1AC25        WACOD
     C                   Z-ADD     85            @W
     C                   EXSR      #VACC
     C                   MOVEL     WACOD         #1AC25
     C                   ENDIF
     C     #1AC26        IFNE      *BLANKS
     C                   MOVEL     #1AC26        WACOD
     C                   Z-ADD     86            @W
     C                   EXSR      #VACC
     C                   MOVEL     WACOD         #1AC26
     C                   ENDIF
     C     #1AC27        IFNE      *BLANKS
     C                   MOVEL     #1AC27        WACOD
     C                   Z-ADD     87            @W
     C                   EXSR      #VACC
     C                   MOVEL     WACOD         #1AC27
     C                   ENDIF
     C     #1AC28        IFNE      *BLANKS
     C                   MOVEL     #1AC28        WACOD
     C                   Z-ADD     88            @W
     C                   EXSR      #VACC
     C                   MOVEL     WACOD         #1AC28
     C                   ENDIF
     C     #1AC29        IFNE      *BLANKS
     C                   MOVEL     #1AC29        WACOD
     C                   Z-ADD     89            @W
     C                   EXSR      #VACC
     C                   MOVEL     WACOD         #1AC29
     C                   ENDIF
     C     #1AC30        IFNE      *BLANKS
     C                   MOVEL     #1AC30        WACOD
     C                   Z-ADD     90            @W
     C                   EXSR      #VACC
     C                   MOVEL     WACOD         #1AC30
     C                   ENDIF
      *
      **Send message 'At least one Account Code must be entered'
     C     ACCNUM        IFEQ      0
     C                   MOVEL     'USR3659'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        6199
     C                   ENDIF
      *
     C                   ENDSR                                                  #VACOD
      *
      **********************************************************************
      *
     C     #VACC         BEGSR
      * Validate Accounts as being Valid Midas accounts and ensure that they have a TI A/C type.
      *
      * Subroutine contains common account validation
      *
     C                   MOVEL     *BLANKS       WRTCD             7
      *
      * Question mark processing
     C     WACOD         IFEQ      '?'
     C     WACOD         OREQ      ' ?'
     C     WACOD         OREQ      '  ?'
     C     WACOD         OREQ      '   ?'
     C                   CALL      'SD0031S'
     C                   PARM      *BLANKS       WRTCD
     C********** WACOD     PARM WACOD     WACC1   4                                           CGL029
     C     WACOD         PARM      WACOD         WACC1            10
     C                   ENDIF
      *
     C     WRTCD         IFNE      'Y2U0016'
     C                   CALL      'AOACODR0'
     C                   PARM      *BLANKS       WRTCD             7
     C                   PARM      '*KEY    '    WOPTN             7
     C                   PARM      WACOD         WACC1
     C     SDACOD        PARM      SDACOD        DSSDY
      *
      * If the account code is not found snd err msg otherwise check for duplicate entries.
     C     WRTCD         IFNE      *BLANK
      *
      * Send message 'Account Code is Invalid'
     C                   MOVEL     'USR3660'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                          99
     C                   MOVE      '1'           *IN(@W)
     C                   ELSE
      * Check array for duplicates entries.
     C     WACOD         LOOKUP    ACC                                    23
     C                   ENDIF
      *
     C     *IN23         IFEQ      *ON
      * Send message 'A/C Code already entered - pls reenter another valid A/C code'
     C                   MOVEL     'USR3661'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                          99
     C                   MOVE      '1'           *IN(@W)
     C                   ENDIF
      *
      * Check if the account has an associated TI A/C type.
     C     A5TIAT        IFNE      *BLANKS
      * Store A/C Code in array ACC otherwise send msg to say TI A/C type required, also
      * store A/C type, A/C sub-type and A/C name in relevant Arrays for use later if account
      * is to be created.
     C                   ADD       1             @Z
     C                   MOVEL     WACOD         ACC(@Z)
     C                   MOVEL     A5TIAT        TIA(@Z)
     C                   MOVEL     A5ACTY        TYP(@Z)
     C                   MOVEL     A5ACST        SUB(@Z)
     C                   MOVEL     A5ACCN        NAM(@Z)
     C                   MOVEL     @Z            ACCNUM            2 0
      *
      * If the A/C has the same SP101 as the ICD store Acct Code
     C     A5TIAT        IFEQ      WTIACT
     C**********           MOVELWACOD     SPACC   40                                          CGL029
     C                   MOVEL     WACOD         SPACC            10 0
     C                   ENDIF
     C                   ELSE
      * Send message 'A/C Code does not have an associated TI A/C Code'
     C                   MOVEL     'USR3662'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                          99
     C                   MOVE      '1'           *IN(@W)
     C                   ENDIF
      *
     C                   ELSE
     C                   SETON                                        99
     C                   MOVE      *ON           *IN(@W)
     C                   ENDIF
      *
     C                   ENDSR                                                  #VACC
     C/COPY WNCPYSRC,TI0010C004
      *
      ***************** FOR EACH DATABASE ERROR *************************
      *
      ** Data base error in file (file)
      *
     C*          *LOCK     IN   LDA
     C*                    SETON                       U7U8
     C*                    Z-ADDNNN       DBASE            ***************
     C*                    MOVEL'(file)'  DBFILE           *DB ERROR NNN *
     C*                    MOVEL'(key)'   DBKEY            ***************
     C*                    OUT  LDA
     C*                    EXSR *PSSR
      *
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
     C     *PSSR         BEGSR                                                  ** *PSSR SR **
      *
     C     @RUN          IFEQ      *BLANK
     C                   MOVE      'Y'           @RUN              1
     C                   DUMP
     C                   CALL      'DBERRCTL'
     C                   END
      *
     C                   ENDSR
      *
     CSR   ZASNMS        BEGSR
      *================================================================
      * Send message to program's message queue
      *================================================================
     C     *LIKE         DEFINE    ZAPGMQ        ZADFMF
     C     ZAPGMQ        IFEQ      *BLANK
     C                   MOVEL     ##PGM         ZAPGMQ
     C                   END
      * If no message file specified, use default
     C     ZAMSGF        IFEQ      *BLANK
     C                   MOVEL     ZADFMF        ZAMSGF
     C                   END
     C                   CALL      'Y2SNMGC'
     C                   PARM                    ZAPGMQ           10            Program queue
     C                   PARM                    ZAPGRL            5            Rel queue
     C                   PARM                    ZAMSID            7            Message ID
     C                   PARM                    ZAMSGF           10            Message file
     C                   PARM                    ZAMSDA          132            Message data
     C                   PARM                    ZAMSTP            7            Message type
      * Clear all fields for default mechanism next time
     C                   MOVEL     *BLANK        ZAPGMQ
     C                   MOVEL     *BLANK        ZAPGRL
     C                   MOVEL     *BLANK        ZAMSID
     C*                    MOVEL*BLANK    ZAMSGF
     C                   MOVEL     *BLANK        ZAMSDA
     C                   MOVEL     *BLANK        ZAMSTP
      *================================================================
     CSR   ZAEXIT        ENDSR
      *****************************************************************                      BUG6597
      * Calculate TI Account sequence.                                                       BUG6597
      *****************************************************************                      BUG6597
      *                                                                                      BUG6597
     C     SRTIAS        BEGSR
      *                                                                                      BUG6597
     C     @@TIAS        IFEQ      0
     C     KLST4         SETGT     ACCNTTI
     C     KLST5         READPE    ACCNT2                                 25
     C     *IN25         IFEQ      '1'
     C                   Z-ADD     1             @@TIAS
     C                   ELSE
     C                   MOVE      TTIAS         @@TIAS
     C     @@TIAS        ADD       1             @@TIAS
     C                   ENDIF
      *                                                                                      BUG6597
     C                   ELSE
     C     @@TIAS        ADD       1             @@TIAS
     C                   ENDIF
      *                                                                                      BUG6597
     C     @@TIAS        IFGT      999
      *                                                                                      BUG6597
      ** Account cannot be opened  as TI Suffix is greater than 999.                         BUG6597
      *                                                                                      BUG6597
     C                   MOVE      'D'           TOACTN
     C                   ELSE
     C                   MOVE      @@TIAS        WSUFFX
     C                   ENDIF
      *                                                                                      BUG6597
     C                   ENDSR
      *****************************************************************                     BUG13929
      * Write new record on GL account master file extension                                BUG13929
      *****************************************************************                     BUG13929
      *                                                                                     BUG13929
     C     WGLEXT        BEGSR
     C                   OPEN      GLACNTQD
     C**********           Z-ADD#CNUM     F1CNUM                                            BUG13929
     C                   MOVEL     #CNUM         F1CNUM
     C                   MOVEL     #CCY          F1CCY
     C                   Z-ADD     #ACOD         F1ACOD
     C                   Z-ADD     WACSQ         F1ACSQ
     C                   MOVEL     #BRCA         F1BRCA
     C                   Z-ADD     0             F1FCHD
     C                   Z-ADD     0             F1LFCD
     C                   Z-ADD     0             F1ACBL
     C                   Z-ADD     0             F1TEXO
     C                   Z-ADD     0             F1TEOF
     C                   Z-ADD     0             F1TEOC
     C                   Z-ADD     0             F1DECD
     C                   Z-ADD     0             F1DRFD
     C                   Z-ADD     0             F1DNFD
     C                   Z-ADD     0             F1DNFM
     C                   Z-ADD     0             F1CRFD
     C                   Z-ADD     0             F1CNFD
     C                   Z-ADD     0             F1CNFM
     C                   MOVE      *BLANKS       F1IABC
     C                   MOVE      *BLANKS       F1BCIN
     C                   WRITE     GLACNTD0
     C                   CLOSE     GLACNTQD
     C                   ENDSR
      *****************************************************************                      BUG6597
     C/COPY WNCPYSRC,TI0010C007
      *
      ********************************************************************
     OACCNT1    E            UPDTIF                                                    180464
     O                       A5TIAC                                                    180464
     O                       OTIAN                                                     180464
     O                       OTIAS                                                     180464
**  CPY@
(c) Finastra International Limited 2001
     X/COPY WNCPYSRC,TI0010X001
** CMDA **  QCMDEXC
CLRPFM FILE(TIOPACPD)
