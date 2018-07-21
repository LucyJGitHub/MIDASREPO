     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2002')
     H FTRANS
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas RE I/C Zero Bal/Sweeping Msg Generation')        *
      *****************************************************************
      *                                                               *
      *  Midas - Retail Module                                        *
      *                                                               *
      *  RE101303 - I/C Zero Balancing/Sweeping Message Generation    *
      *                                                               *
      *  Function:  This program formats                              *
      *             the MT101, MT103 or Cover MT202 for external      *
      *             Zero Balancing/Sweeping                           *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2002            *
      *                                                               *
      *  Last Amend No. CSW218             Date 20Jun18               *
      *  Prev Amend No. CSW215             Date 06Apr15               *
      *                 AR972805           Date 27Feb13               *
      *                 AR960455           Date 25Feb13               *
      *                 CRE075             Date 06Dec10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      *                 BUG24998           Date 17Jul09               *
      *                 CSW209             Date 01Apr09               *
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 BUG15202A          Date 09Nov07               *
      *                 BUG15202           Date 31Oct07               *
      *                 BUG14934           Date 03Oct07               *
      *                 CSW207             Date 15Jun07               *
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD031             Date 10Apr06               *
      *                 CSD027             Date 09Dec05               *
      *                 CSW037A            Date 02May05               *
      *                 BUG6198            Date 04Apr05               *
      *                 CSD025             Date 11Jan05               *
      *                 CSW037             Date 15Dec04               *
      *                 CSW036             Date 15Dec04               *
      *                 CLE025             Date 20Oct03               *
      *                 CGL029             Date 01Sep03               *
      *                 222373             Date 24Oct03               *
      *                 215205             Date 01May04               *
      *                 217196             Date 23Apr03               *
      *                 216421             Date 06Apr03               *
      *                 213196             Date 17Mar03               *
      *                 213569             Date 07Feb03               *
      *                 214360             Date 03Feb03               *
      *                 211499             Date 24Jan03               *
      *                 212836             Date 24Jan03               *
      *                 213930             Date 21Jan03               *
      *                 213572             Date 07Jan03               *
      *                 211499             Date 07Jan03               *
      *                 212316             Date 06Dec02               *
      *                 CRE008  *CREATE    Date 19Feb02               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSW218 - SWIFT Changes 2018                                  *
      *  CSW215 - SWIFT Changes 2015                                  *
      *  AR972805 - Remove equate translation as done externally.     *
      *             Recompile over FTCPYSRC,FTSWIFTRAN.               *
      *             (Child: AR972806)                                 *
      *  AR960455 - Account line missing on 50K seqB MT202Cov         *
      *             Account number not shown in field 50.             *
      *             (Child: AR960457)                                 *
      *  CRE075 - Effective Date for Retail Accounts (Recompile)      *
      *  BUG24998 - Bank operation code is missing (Recompile)        *
      *  CSW209 - SWIFT 2009 Changes                                  *
      *  BUG15202A - Parameters for FT001000 has been set with value  *
      *  BUG15202 - DB error should be remove after calling FT001000  *
      *  BUG14934 - Error in parameter (length of PAccount should be  *
      *             34)                                               *
      *  CSW207 - SWIFT 2007 Changes                                  *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CSW037A- Additional Field extended to 40 chars (recompile)   *
      *  BUG6198- Cannot save new Details for CUSD (Recompile)        *
      *  CSD025 - Customer De-Activation                              *
      *  CSW037 - Additional Field Data on MT300/MT320                *
      *  CSW036 - Dual SWIFT BIC held on Client Details               *
      *  CLE025 - Credit Lines (Recompile)                            *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  222373 - Parameter Mismatch                                  *
      *  215205 - Deferred posting values dates not set correctly     *
      *  217196 - Outgoing MT103's from a Master ac do not map amount *
      *           to field 33B                                        *
      *  216421 - External tops are back-valued                       *
      *  213196 - Holidays are not checked for top/sweeps             *
      *  213569 - Charges                                             *
      *  214360 - Cash Management Deferred Posting                    *
      *  211499 - Outgoing MT101:                                     *
      *           50H - Include Ac no. and name only (drop address)   *
      *           50L - Include name only (drop address)              *
      *           59  - Include Ac no. and name only (drop address)   *
      *           Outgoing MT103 (direct sweep):                      *
      *           59  - Include Ac no. and name only (drop address)   *
      *  212836 - Outgoing MT103 fld 50 should only be output with    *
      *           option K and not with A.                            *
      *  213930 - Drop 9th character of Branch TID before formatting  *
      *           to MT101 fld 57A                                    *
      *  213572 - Outgoing message fields not set correctly           *
      *  211499 - Option included to exclude address part in Name and *
      *           Address option fields                               *
      *  212316 - MT101/103 SWIFT mapping: problem w/ fld 57A,Tran ref*
      *  CRE008 - Cash Management                                     *
      *                                                               *
      *****************************************************************
 
     FREICSDL1  UF   E           K DISK    INFSR(*PSSR)
     F                                     COMMIT
     FSDCUSTL7  IF   E           K DISK    INFSR(*PSSR)
     FMSIXI2L2  IF   E           K DISK    INFSR(*PSSR)
     F                                     PREFIX(MS_)
     FMEINCRL2  IF   E           K DISK    INFSR(*PSSR)
     FRETBDSL0  IF   E           K DISK    INFSR(*PSSR)
     FRETBDDL1  IF   E           K DISK    INFSR(*PSSR)
     FMGOREFL0  IF   E           K DISK    INFSR(*PSSR)                         216421
     F                                     RENAME(MGOREFD0:MGOREFSQ)            216421
     F                                     PREFIX(M_)                           216421
     FMGOREFPD  O    E             DISK    INFSR(*PSSR)
     F                                     COMMIT
     FMGOMSGPD  O    E             DISK    INFSR(*PSSR)
     F                                     COMMIT
     FREICSLPD  O  A E             DISK    INFSR(*PSSR)
     FRE101303AUO    E             PRINTER INFDS(SPOOLU)
     F                                     INFSR(*PSSR)
 
      *****************************************************************
      * Standard D Specifications
     D/COPY ZACPYSRC,RECMSTDD
      * Program Status Data Structure
     D/COPY ZACPYSRC,PSDS
      * ME1100 present message data structure
     D/COPY MECPYSRC,ME1100_ILE
     D/COPY FTCPYSRC,FT0010D001                                                 213569
      *****************************************************************
 
      ** File Information Data Structure for RE101303AU
     D SPOOLU          DS
     D  PSFileU               83     92
     D  PSFNumU              123    124B 0
 
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** External DS for BANK details
     D SDBRCH        E DS                  EXTNAME(SDBRCHPD)
      ** External DS for branch details
     D SDMGME        E DS                  EXTNAME(SDMGMEPD)
      **  Data structure for Message Management file
     D SDCMAN        E DS                  EXTNAME(SDCMANPD)
      ** External DS for CM   details
     D SDNOST        E DS                  EXTNAME(SDNOSTPD)
      * External DS for Nostro details
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)
     D  QQDFA1       E                     EXTFLD (QQDFAC)                                    CGL029
      ** Customer details
     D SDRETL        E DS                  EXTNAME(SDRETLPD)
     D  QQACD1       E                     EXTFLD (QQACCD)                                    CGL029
      ** Retail ICD details
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
      ** Customer details
     D ACCNT         E DS                  EXTNAME(ACCNTAB)
      ** Externally described DS for account details
     D O_CMHD        E DS                  EXTNAME(RECMHDPD)
      ** Externally described DS CM Hierarchy Details
     D O_ZSHD        E DS                  EXTNAME(REZSHDPD)
      ** Externally described DS for Zero Balancing/Sweeping Details
     D O_GAHD        E DS                  EXTNAME(REGAHDPD)
      ** Externally described DS for Group Account Details
 
     D DSFDY         E DS                  EXTNAME(DSFDY)
      * Short Data Structure
     D DSSDY         E DS                  EXTNAME(DSSDY)
      * Short Data Structure
     D MULT            DS                  OCCURS(5000)
     D  MTAG                   1      5
     D  MFLD                   6     55
      * Multiple ocurrence data structure
 
     D P@In            DS           256
     D  I@SNBR                 1      3
     D  I@DSCN                 4      9
     D  I@MTPY                10     12
     D  I@SETT                13     14  0
     D  I@CONC                15     15
     D  I@FTCS                16     16
     D  I@MMOD                17     18
      ** Data structure for input parameter
 
     D P@Out           DS           256
     D**O@CNSN**               1      6  0                                                    CSD027
     D  O@CNSN                 1      6                                                       CSD027
     D  O@SWSN                 7     18
     D  O@NWSN                19     38
     D  O@SWDS                39     49
     D  W@96CN                46     46
     D  W@BIC                 47     49
     D  O@NWDS                50     69
     D  O@NWRK                70     75
     D  O@MGSG                76     76
     D  O@MGST                77     80
     D  O@PAIN                81     81
     D  O@PCNB                82     87
     D  O@SPRS                88     90
     ** Data structure for ouput parameter
 
     D REFERENCE       DS
     D  IDLINK                 1      9  0
     D  IDSNUM                10     11  0
                                                                                216421
     D                 DS                                                       216421
     D  MsgSeq                 1      2  0                                      216421
     D  MsgSeqA                1      2                                         216421
 
     D WDCA            DS
     D  WDate                  1      6
     D  WCcy                   7      9
     D  WAmt                  10     24
     D  WCA                    7     24
 
     D WComponent      DS
     D  WComp1                 1     10
     D  WComp2                11     20
     D  WComp3                21     30
     D  WComp4                31     40
 
     D                 DS
     D  MapTag                 1      5
     D  MapHeader              6      6
     D  MapLookup              1      6
 
     D WMap            DS
     D  WMapLine1              1     50
     D  WMapLine2             51    100
     D  WMapLine3            101    150
     D  WMapLine4            151    200
     D  WMapLine5            201    250
     D  WMapLine6            251    300
 
     D**ChildAccount    DS            18                                                      CGL029
     D ChildAccount    DS            24                                                       CGL029
     D  IDCBRC                 1      3
     D**IDCCUS**               4      9  0                                                    CSD027
     D  IDCCUS                 4      9                                                       CSD027
     D  IDCCCY                10     12
     D**IDCACD**              13     16  0                                                    CGL029
     D**IDCASN**              17     18  0                                                    CGL029
     D  IDCACD                13     22  0                                                    CGL029
     D  IDCASN                23     24  0                                                    CGL029
 
     D                 DS
     D TbMT101                       54    DIM(36) CTDATA PERRCD(1)
     D    TbTag                       6    Overlay(TbMT101)
     D    TbDSF                       5    Overlay(TbMT101:*NEXT)
     D    TbDCA                       3    Overlay(TbMT101:*NEXT)
     D    TbComp                     40    Overlay(TbMT101:*NEXT)
     D ALINE           S             35    dim(5)
 
      ** Parameters for AOACCTR0
     D WRetl           S             10
     D WCusN           S              6
     D WCur            S              3
     D**WAcctCde        S              4                                                      CGL029
     D WAcctCde        S             10                                                       CGL029
     D WAcctSeq        S              2
     D WBrch           S              3
 
      ** Work fields
     D*SavDECN**       S              6  0                                                    CSD027
     D SavDECN         S              6                                                       CSD027
     D SavTrno         S             16
     D SavDate         S              6
     D SavAmount       S             15
     D Sav32A          S             24
     D Sav54L1         S             35
     D Sav54L2         S             35
     D Sav54L3         S             35
     D Sav54L4         S             35
     D Sav54L5         S             35
     D Sav54Tag        S              5
     D GenerateMsg     S              4
     D SecondCall      S              1
     D Q               S              4  0
     D Reply103        S              1
     D WMapFound       S              1
     D WDest           S             11
     D KDest           S             11
     D KTag            S              5
     D FldCmp          S             35
     D TblCmp          S             35
     D N               S              1  0
     D Z               S              2  0
     D ChgAmount       S             15  0
     D Wacnum          S             34                                                     AR960455
     D Wacnum2         S             35                                                     AR960455
 
      ** Swift installed flag                                                                 CSW207
     D CSW207          S              1                                                       CSW207
     D CSW209          S              1                                                       CSW209
                                                                                              CSW207
      ** Parameters for AOBAGRV0                                                              CSW209
     D @BTYP           S             10                                                       CSW209
     D @NTWK           S              6                                                       CSW209
     D @MTYP           S              3                                                       CSW209
     D @VALF           S              8                                                       CSW209
     D @SSWID          S             11                                                       CSW209
     D @RSWID          S             11                                                       CSW209
     D @ORDB           S            256                                                       CSW209
     D @SDRV           S            256                                                       CSW209
     D @SNCO           S            256                                                       CSW209
     D @RVCO           S            256                                                       CSW209
                                                                                              CSW209
      ** Work fields to be used in MT202 COV                                                  CSW209
      ** Work fields for tag :50a: details                                                    CSW209
     D PRC50A          S              5                                                       CSW209
     D MTAG50A         S              5                                                       CSW209
     D ADD50A1         S             50                                                       CSW209
     D ADD50A2         S             50                                                       CSW209
     D ADD50A3         S             50                                                       CSW209
     D ADD50A4         S             50                                                       CSW209
     D ADD50A5         S             50                                                       CSW209
      ** Work fields for tag :52a: details                                                    CSW209
     D MTAG52X         S              5                                                       CSW209
     D ADD52X1         S             50                                                       CSW209
     D ADD52X2         S             50                                                       CSW209
     D ADD52X3         S             50                                                       CSW209
     D ADD52X4         S             50                                                       CSW209
     D ADD52X5         S             50                                                       CSW209
      ** Work fields for tag :56a: details                                                    CSW209
     D MTAG56X         S              5                                                       CSW209
     D ADD56X1         S             50                                                       CSW209
     D ADD56X2         S             50                                                       CSW209
     D ADD56X3         S             50                                                       CSW209
     D ADD56X4         S             50                                                       CSW209
     D ADD56X5         S             50                                                       CSW209
      ** Work fields for tag :57a: details                                                    CSW209
     D MTAG57X         S              5                                                       CSW209
     D ADD57X1         S             50                                                       CSW209
     D ADD57X2         S             50                                                       CSW209
     D ADD57X3         S             50                                                       CSW209
     D ADD57X4         S             50                                                       CSW209
     D ADD57X5         S             50                                                       CSW209
      ** Work fields for tag :59a: details                                                    CSW209
     D MTAG59X         S              5                                                       CSW209
     D ADD59X1         S             50                                                       CSW209
     D ADD59X2         S             50                                                       CSW209
     D ADD59X3         S             50                                                       CSW209
     D ADD59X4         S             50                                                       CSW209
     D ADD59X5         S             50                                                       CSW209
     D Save59          S             50                                                       CSW209
     D ADD591          S             35                                                       CSW209
     D T59MAP          S              1                                                       CSW209
      ** Work fields for tag :70: details                                                     CSW209
     D Save70          S             50                                                       CSW209
     D Save701         S             50                                                       CSW209
     D ADD70X1         S             50                                                       CSW209
     D ADD70X2         S             50                                                       CSW209
     D ADD70X3         S             50                                                       CSW209
     D ADD70X4         S             50                                                       CSW209
     D ADD70X5         S             50                                                       CSW209
     D T70MAP          S              1                                                       CSW209
      ** Work fields for tag :72: details                                                     CSW209
     D ADD72X1         S             50                                                       CSW209
     D ADD72X2         S             50                                                       CSW209
     D ADD72X3         S             50                                                       CSW209
     D ADD72X4         S             50                                                       CSW209
     D ADD72X5         S             50                                                       CSW209
     D ADD72X6         S             50                                                       CSW209
      ** Work fields for message data mappings of MT202 COV                                   CSW209
     D MAPLN1          S             50                                                       CSW209
     D MAPLN2          S             50                                                       CSW209
     D MAPLN3          S             50                                                       CSW209
     D MAPLN4          S             50                                                       CSW209
     D MAPLN5          S             50                                                       CSW209
      ** Work fields for tag :33B: details                                                    CSW209
     D Sav33B          S             50                                                       CSW209
     D MT103R          S              1                                                       CSW209
     D CSW215          S              1                                                       CSW215
     D Wrk59F          S              1                                                       CSW215
     D PCallFr         S              4                                                       CSW215
     D PInpParm1       S             35                                                       CSW215
     D PInpParm2       S             35                                                       CSW215
     D PInpParm3       S             35                                                       CSW215
     D PInpParm4       S             35                                                       CSW215
     D PInpParm5       S             35                                                       CSW215
     D PNetWrk         S              6                                                       CSW215
     D PMsgTyp         S              3                                                       CSW215
     D PMsgTag         S              5                                                       CSW215
     D PBranch         S              3                                                       CSW215
     D PCount          S              2                                                       CSW215
     D PCurr           S              3                                                       CSW215
     D PNost           S              2                                                       CSW215
     D POutParm1       S             35                                                       CSW215
     D POutParm2       S             35                                                       CSW215
     D POutParm3       S             35                                                       CSW215
     D POutParm4       S             35                                                       CSW215
     D POutParm5       S             35                                                       CSW215
     D PMsID           S              7                                                       CSW215
     D PErrType        S              1                                                       CSW215
     D WMsgType        S              3                                                       CSW215
     D CSW218          S              1                                                       CSW218
     D PUUID           S             50                                                       CSW218
      *********************************************************************
      * MAIN PROCEDURE                                                    *
      *********************************************************************
 
     C                   EXSR      SRINIT
 
     C                   EXSR      SRPROC
 
     C                   EXSR      SREND
 
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRINIT - Initialisation                                       *
      *****************************************************************
     C     SRINIT        BEGSR
 
      ** Initialise workfields
 
     C                   EVAL      COUNT101 = 0
     C                   EVAL      COUNT103 = 0
     C                   EVAL      COUNT202 = 0
      *
      **  Initialise constant fields
      *
     C                   MOVE      *LOVAL        CR                1
     C                   BITON     '457'         CR
     C                   MOVE      *LOVAL        LF                1
     C                   BITON     '257'         LF
     C                   MOVEL     CR            CRLF              2
     C                   MOVE      LF            CRLF
 
      * Check if CSW024 is installed
 
     C                   Movel     'N'           CSW024            1
     C                   CALL      'AOSARDR0'
     C                   PARM      '       '     PRTCD             7
     C                   PARM      '*VERIFY'     POPTN             7
     C                   PARM      'CSW024'      PSARD             6
 
     C                   If        @RTCD <> *Blanks
     C                   Z-ADD     27            DBASE                            * * * * * * *
     C                   MOVEL     '*CALL  '     DBKEY                            * DBERR 027 *
     C                   MOVEL     'AOSARDR0'    DBFILE                           * * * * * * *
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   Else
     C                   Movel     'Y'           CSW024
     C                   Endif
 
      ** Check if SWIFT 2007 is installed                                                     CSW207
                                                                                              CSW207
     C                   CALL      'SWIF2007'                                                 CSW207
     C                   PARM      *BLANKS       PRtCd                                        CSW207
                                                                                              CSW207
     C                   IF        PRtCd = 'CSW2007'                                          CSW207
     C                   EVAL      CSW207 = 'Y'                                               CSW207
     C                   ELSE                                                                 CSW207
     C                   EVAL      CSW207 = 'N'                                               CSW207
     C                   ENDIF                                                                CSW207
                                                                                              CSW207
      ** Check if SWIFT 2009 is installed                                                     CSW209
                                                                                              CSW209
     C                   CALL      'SWIF2009'                                                 CSW209
     C                   PARM      *BLANKS       PRtCd                                        CSW209
                                                                                              CSW209
     C                   IF        PRtCd = 'CSW2009'                                          CSW209
     C                   EVAL      CSW209 = 'Y'                                               CSW209
     C                   ELSE                                                                 CSW209
     C                   EVAL      CSW209 = 'N'                                               CSW209
     C                   ENDIF                                                                CSW209
                                                                                              CSW209
     C                   Eval      Q = 5000
     C                   EXSR      SRClear
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRPROC - Generate Messages                                    *
      *****************************************************************
     C     SRPROC        BEGSR
      *
     C     *LOVAL        SETLL     REICSDL1
     C                   READ      REICSDL1                               60
 
     C                   DOW       *IN60 = *OFF
 
     C                   Exsr      GetHierDet
     C                   Exsr      GetAcctDet
 
     C                   Eval      SecondCall = 'N'
     C                   Exsr      SrRout
 
     C                   If        GenerateMsg = '*YES'
                                                                                213196
      * Check if today is a working day in the account currency                 213196
      * (External topping and sweeping messages are only generated:             213196
      * i. On working days                                                      213196
      * ii.On non-working days only if holidays included & the msg is a 103)    213196
                                                                                213196
     C                   Exsr      Det_WrkDay                                   213196
 
      * Check if this is a reply to a received MT101, if so check for
      * translation record.
 
     C                   Exsr      Det_Reply103
 
     C                   If        IDTPSW = 'T'
     C     Ac_Ccy_WrkDay IFEQ      'Y'                                          213196
     C                   EXSR      SRMT101
     C                   Endif                                                  213196
     C                   Else
 
      * if this is a reply MT103, perform formatting using the translation table
     C                   If        Reply103 = 'Y'
     C                   EXSR      SRMT103R
     C                   Else
     C     Ac_Ccy_WrkDay IFEQ      'Y'                                          213196
     C     ZDSHOC        OREQ      'I'                                          213196
     C     IDR3RF        ORNE      *BLANK                                       216421
     C                   EXSR      SRMT103
     C                   Endif                                                  213196
     C                   Endif
 
     C                   Endif
     C                   Endif
 
     C                   READ      REICSDL1                               60
 
     C                   Enddo
 
     C                   Endsr
      *****************************************************************
      /EJECT
      *****************************************************************
      * SREND  - Subroutine to End Program                            *
      *****************************************************************
     C     SREND         BEGSR
 
      **   Output Report Header
 
     C                   Write     HEADAU
 
      **   If there is a DB Error, Output the DB Error Information.
     C                   If        *INU7 = *ON
     C                   Write     DBERROR
     C                   Else
     C     COUNT101      IFGT      0                                            213196
     C     COUNT103      ORGT      0                                            213196
     C     COUNT202      ORGT      0                                            213196
     C                   EXSR      LOGEVENT
     C                   ENDIF                                                  213196
     C                   Write     HASRUN
     C                   Endif
 
      *  End program
     C                   Seton                                        LR
     C                   Return
 
     C                   Endsr
      *****************************************************************
      /EJECT
      *****************************************************************
      * SrRout  - Determine Message Routing                           *
      *****************************************************************
     C     SRRout        BEGSR
      *
      * Determine message to be routed
     C                   If        IDTPSW = 'T'
     C                   Eval      I@MTPY = '101'
     C                   Else
     C                   Eval      I@MTPY = '103'
     C                   Endif
      *
      *  Specify '202' if called for the second time to generate MT202.
     C                   If        SecondCall = 'Y'
     C                   Eval      I@MTPY = '202'
     C                   Endif
      *
     C                   Eval      I@SNBR = CDBRCA
      *
      * Get Destination Customer number
     C                   Exsr      GetDestCno
     C                   Movel     SavDECN       I@DSCN
      *
     C                   Eval      I@CONC = 'N'
     C                   Eval      I@SETT = 8
     C                   Eval      I@FTCS = *blanks
     C                   Eval      I@MMOD = 'RE'
      *
      *###################################################################
      *                                                                  #
      * Below are two copy sources intended for setting up the custom    #
      * parameter (P@ZZ) in the call to f sdbrch                         #
      * One (MG9900CILE) is in ALL ILE MG generation programs and is for #
      * use when a change is required to all of them. This /COPY is      #
      * the ILE version of MG9900CALL.                                   #
      * The other is only in this program.                               #
     C/COPY WNCPYSRC,MG9900CILE                                          #
     C/COPY WNCPYSRC,RE1001303R                                          #
      *                                                                  #
      *###################################################################
      *
      *  Call MG9900 if Destination Customer is found.  It will not be present
      *  If Destination is of type 'S' and SWIFT Id isnot in SDCUSTPD.
      *
     C                   Eval      PCountry  = *Blanks                                     BUG15202A
     C*****SavDecn       IFNE      0                                                          CSD027
     C     SavDecn       IFNE      *BLANKS                                                    CSD027
      *
     C                   CALL      'MG9900'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM                    P@In
     C                   PARM      *BLANKS       P@Out
     C                   PARM                    P@ZZ            256
      *
     C                   If        @RTCD <> *Blanks
     C                   Z-ADD     1             DBASE                            * * * * * * *
     C                   MOVEL     '*CALL  '     DBKEY                            * DBERR 001 *
     C                   MOVEL     'MG9900'      DBFILE                           * * * * * * *
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   Endif
      * Check if message to be suppressed for destination
      *
     C                   Movel     SavDECN       PKEY1
     C                   CALL      'AOCUSTR0'
     C                   PARM      *BLANKS       PRTCD             7
     C                   PARM      '*KEY   '     POPTN             7
     C                   PARM                    PKEY1            10
     C                   PARM      *BLANK        PKYST             7
     C     SDCUST        PARM      SDCUST        DSSDY
      ** Error on call
     C     @RTCD         IFNE      *BLANK
     C     *LOCK         IN        LDA
     C                   Z-ADD     2             DBASE                            * * * * * * *
     C                   MOVEL     A7CUST        DBKEY                            * DBERR 002 *
     C                   MOVEL     'SDCUSTPD'    DBFILE                           * * * * * * *
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
                                                                                           BUG15202A
     C                   Eval      PCountry = BBCOLC                                       BUG15202A
     C
      *   Suppress message if defined on destination customer details
     C                   If        BBNG01 = I@MTPY  or
     C                             BBNG02 = I@MTPY  or
     C                             BBNG03 = I@MTPY  or
     C                             BBNG04 = I@MTPY  or
     C                             BBNG05 = I@MTPY  or
     C                             BBNG06 = I@MTPY  or
     C                             BBNG07 = I@MTPY  or
     C                             BBNG08 = I@MTPY  or
     C                             BBNG09 = I@MTPY  or
     C                             BBNG10 = I@MTPY  or
     C                             BBNG11 = I@MTPY  or
     C                             BBNG12 = I@MTPY  or
     C                             BBNG13 = I@MTPY  or
     C                             BBNG14 = I@MTPY  or
     C                             BBNG15 = I@MTPY
     C                   Eval      GenerateMsg = '*NO '
     C                   Else
     C                   Eval      GenerateMsg = '*YES'
     C                   Endif
      *
     C                   MOVE      O@NWRK        NWRK
     C**********         Z-ADD     O@CNSN        SECN                                         CSD027
     C                   EVAL      SECN = O@CNSN                                              CSD027
     C                   MOVE      O@NWSN        NWSN
     C**********         Z-ADD     SavDECN       DECN                                         CSD027
     C                   EVAL      DECN = SavDECN                                             CSD027
     C                   MOVE      O@NWDS        NWDS
     C                   End
      *
      *  Default
     C**********         If        SavDecn = 0                                                CSD027
     C                   If        SavDecn = *BLANKS                                          CSD027
     C                   Eval      GenerateMsg = '*YES'
     C                   MOVE      'SWIFT '      NWRK
      * Sender is Branch Internal Customer Number
     C                   CALLB     'ZAACSBRCH'
     C                   PARM      CDBRCA        PBRCA             3
     C                   PARM                    SDBRCH
     C                   Movel     A8BICN        SECN
     C                   MOVEL     A8BTID        NWSN
     C**********         Z-ADD     SavDECN       DECN                                         CSD027
     C                   EVAL      DECN = SavDECN                                             CSD027
     C                   Movel     IDDEST        NWDS
     C                   End
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRMT101  - Format MT101 Message details (External Topping)    *
      *****************************************************************
     C     SRMT101       BEGSR
 
      * Re-initialise work fields
     C                   Exsr      SRClear
 
      * = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =
      *                    M E S S A G E     D A T A
 
      * Field :20:  = 'RE' + Link Reference (last 6 only) + Rund in YYMMDD + Sequence
     C                   Eval      Q = 1
     C     Q             Occur     MULT
      *  Determine Message Seq                                                  216421
     C                   EXSR      DET_MSGSEQ                                   216421
     C                   Eval      MTAG = ':20:'
     C                   Eval      SavTrno = 'RE' + %SUBST(Reference:4:6) +
     C                                       WMgde + MsgSeqA                    216421
     C***************************************WMgde + %SUBST(Reference:10:2)     216421
     C                   Eval      MFLD    = SavTrno
 
      * Field :21R:
     C                   Eval      Q = Q + 1
     C     Q             Occur     MULT
     C                   Eval      MTAG = ':21R:'
     C     IDENAR        ifne      'CMX'
     C                   Eval      MFLD = IDENAR
     C                   else
     C                   If        IDSTYP = 'Z'                                 212316
     C*******************Eval      MFLD = 'CMZ' +'/'+%subst(IDEXA1:2:34) 212316 213572
     C                   Eval      MFLD = 'CMZ' + '/' + WAccount                213572
     C                   Else                                                   212316
     C*******************Eval      MFLD = 'CMT' +'/'+%subst(IDEXA1:2:34) 212316 213572
     C                   Eval      MFLD = 'CMT' + '/' + WAccount                213572
     C                   Endif                                                  212316
     C*******************Eval      MFLD = 'NONREF'                              212316
     C                   endif
 
      * Field :28D:
     C                   Eval      Q = Q + 1
     C     Q             Occur     MULT
     C                   Eval      MTAG = ':28D:'
     C                   Eval      MFLD = '00001/00001'
 
     C**********         IF        CSW207 = 'Y' AND                                 CSW207 BUG15202A
     C**********                   (%SUBST(IDEXA1:1:5) = 'ARNU/' OR                 CSW207 BUG15202A
     C**********                   %SUBST(IDEXA1:1:5) = 'CCPT/' OR                  CSW207 BUG15202A
     C**********                   %SUBST(IDEXA1:1:5) = 'CUST/' OR                  CSW207 BUG15202A
     C**********                   %SUBST(IDEXA1:1:5) = 'DRLC/' OR                  CSW207 BUG15202A
     C**********                   %SUBST(IDEXA1:1:5) = 'EMPL/' OR                  CSW207 BUG15202A
     C**********                   %SUBST(IDEXA1:1:5) = 'IBEI/' OR                  CSW207 BUG15202A
     C**********                   %SUBST(IDEXA1:1:5) = 'NIDN/' OR                  CSW207 BUG15202A
     C**********                   %SUBST(IDEXA1:1:5) = 'SOSE/' OR                  CSW207 BUG15202A
     C**********                   %SUBST(IDEXA1:1:5) = 'TXID/')                    CSW207 BUG15202A
     C                   IF        CSW207 = 'Y'                                            BUG15202A
                                                                                              CSW207
     C                   EVAL      PMsgType = '101'                                           CSW207
      * Set Parameter for MT101                                                            BUG15202A
     C                   Eval      PInp1 = IDEXA1                                          BUG15202A
     C                   Eval      PInp2 = IDEXA2                                          BUG15202A
     C                   Eval      PInp3 = IDEXA3                                          BUG15202A
     C                   Eval      PInp4 = IDEXA4                                          BUG15202A
     C                   Eval      PInp5 = IDEXA5                                          BUG15202A
     C                   Eval      PAcctType = 'A'                                         BUG15202A
     C                   Eval      PAccount  = *Blanks                                     BUG15202A
     C                   EVAL      PCustNo   = *Blanks                                     BUG15202A
     C                   Eval      PNonAcctHldr = *Blanks                                  BUG15202A
     C                   Eval      PNetwork  = NWRK                                        BUG15202A
     C                   Eval      PMsgField = ':50F:'                                     BUG15202A
     C                   Eval      PBrchCode = CDBRCA                                      BUG15202A
     C                   Eval      PCurrCode = IDCCCY                                      BUG15202A
     C                   Eval      PNostro   = *Blanks                                     BUG15202A
     C                   Eval      PModi     = 'RE'                                        BUG15202A
                                                                                              CSW207
     C                   CALL      'FT001000'                                                 CSW207
                                                                                              CSW207
      ** Input Parameters                                                                     CSW207
      ** Return Code                                                                          CSW207
     C                   PARM      *BLANKS       PRtnCode          7                          CSW207
      ** Message ID                                                                           CSW207
     C                   PARM      *BLANKS       PMsgID            7                          CSW207
      ** Error Type                                                                           CSW207
     C                   PARM      *BLANK        PErTyp            1                          CSW207
      ** Validation Type                                                                      CSW207
     C                   PARM      'FRMT'        PVTyp             4                          CSW207
      ** 5X35 input line                                                                      CSW207
     C                   PARM                    PInp1            35                          CSW207
     C                   PARM                    PInp2            35                          CSW207
     C                   PARM                    PInp3            35                          CSW207
     C                   PARM                    PInp4            35                          CSW207
     C                   PARM                    PInp5            35                          CSW207
      ** Account Type                                                                         CSW207
     C                   PARM                    PAcctType         1                          CSW207
      ** Account                                                                              CSW207
     C**********         PARM                    PAccount         24                 CSW207 BUG14934
     C                   PARM                    PAccount         34                        BUG14934
      ** Customer Number                                                                      CSW207
     C**********         PARM      IDPCCY        PCustNo           6                CSW207 BUG15202A
     C                   PARM                    PCustNo           6                       BUG15202A
      ** Non Account Holder                                                                   CSW207
     C                   PARM                    PNonAcctHldr     10                          CSW207
      ** Network                                                                              CSW207
     C                   PARM                    PNetwork          6                          CSW207
      ** Message Type                                                                         CSW207
     C                   PARM                    PMsgType          3                          CSW207
      ** Message Tag                                                                          CSW207
     C                   PARM                    PMsgField         5                          CSW207
      ** Country                                                                              CSW207
     C                   PARM                    PCountry          2                          CSW207
      ** Branch Code                                                                          CSW207
     C                   PARM                    PBrchCode         3                          CSW207
      ** Currency Code                                                                        CSW207
     C                   PARM                    PCurrCode         3                          CSW207
      ** Nostro Flag                                                                          CSW207
     C                   PARM                    PNostro           2                          CSW207
      ** Module Indicator                                                                     CSW207
     C                   PARM                    PModI             2                          CSW207
                                                                                              CSW207
      ** Output Parameters                                                                    CSW207
      ** Message Line 1                                                                       CSW207
     C                   PARM                    PMsgLine01       35                          CSW207
      ** Message Line 2                                                                       CSW207
     C                   PARM                    PMsgLine02       35                          CSW207
      ** Message Line 3                                                                       CSW207
     C                   PARM                    PMsgLine03       35                          CSW207
      ** Message Line 4                                                                       CSW207
     C                   PARM                    PMsgLine04       35                          CSW207
      ** Message Line 5                                                                       CSW207
     C                   PARM                    PMsgLine05       35                          CSW207
                                                                                              CSW207
     C                   IF        PRtnCode = *BLANKS                                         CSW207
                                                                                              CSW207
     C                   Eval      Q = Q + 1                                                  CSW207
     C     Q             Occur     MULT                                                       CSW207
     C                   Eval      MTag = ':50F:'                                             CSW207
     C                   Eval      MFLD = PMsgLine01                                          CSW207
     C                   Eval      Q = Q + 1                                                  CSW207
     C     Q             Occur     MULT                                                       CSW207
     C**********         Eval      MTag = ':50F:'                                   CSW207 BUG15202A
     C                   Eval      MFLD = PMsgLine02                                          CSW207
     C                   Eval      Q = Q + 1                                                  CSW207
     C     Q             Occur     MULT                                                       CSW207
     C**********         Eval      MTag = ':50F:'                                   CSW207 BUG15202A
     C                   Eval      MFLD = PMsgLine03                                          CSW207
     C                   Eval      Q = Q + 1                                                  CSW207
     C     Q             Occur     MULT                                                       CSW207
     C**********         Eval      MTag = ':50F:'                                   CSW207 BUG15202A
     C                   Eval      MFLD = PMsgLine04                                          CSW207
     C                   Eval      Q = Q + 1                                                  CSW207
     C     Q             Occur     MULT                                                       CSW207
     C**********         Eval      MTag = ':50F:'                                   CSW207 BUG15202A
     C                   Eval      MFLD = PMsgLine05                                          CSW207
                                                                                              CSW207
     C                   ELSE                                                                 CSW207
                                                                                              CSW207
      * Field :50H: = Ordering Customer                                                       CSW207
                                                                                              CSW207
     C                   Eval      Q = Q + 1                                                  CSW207
     C     Q             Occur     MULT                                                       CSW207
     C                   Eval      MTAG = ':50H:'                                             CSW207
     C                   Eval      MFLD = IDEXA1                                              CSW207
                                                                                              CSW207
     C                   Eval      Q = Q + 1                                                  CSW207
     C     Q             Occur     MULT                                                       CSW207
     C                   Eval      ZSADD1 = IDEXA2                                            CSW207
     C                   Eval      ZSADD2 = *blank                                            CSW207
     C                   Eval      ZSADD3 = *blank                                            CSW207
     C                   Eval      ZSADD4 = *blank                                            CSW207
     C                   Exsr      SWADF                                                      CSW207
     C                   ENDIF                                                                CSW207
                                                                                              CSW207
     C                   ELSE                                                                 CSW207
                                                                                              CSW207
      * Field :50H: = Ordering Customer
 
     C                   Eval      Q = Q + 1
     C     Q             Occur     MULT
     C                   Eval      MTAG = ':50H:'
     C                   Eval      MFLD = IDEXA1
 
     C                   Eval      Q = Q + 1
     C     Q             Occur     MULT
     C                   Eval      ZSADD1 = IDEXA2
     C***********        Eval      ZSADD2 = IDEXA3                              211499
     C***********        Eval      ZSADD3 = IDEXA4                              211499
     C***********        Eval      ZSADD4 = IDEXA5                              211499
     C                   Eval      ZSADD2 = *blank                              211499
     C                   Eval      ZSADD3 = *blank                              211499
     C                   Eval      ZSADD4 = *blank                              211499
     C                   Exsr      SWADF
     C                   ENDIF                                                                CSW207
 
      * Field :30: Requested Execution Date
     C                   Eval      Q = Q + 1
     C     Q             Occur     MULT
     C                   Eval      MTAG = ':30:'
      *
      *  Adjust value date                                                      216421
     C                   EXSR      ADJ_VALD                                     216421
     C                   Eval      ZMDAY = AdjValDate                           215205
     C*******************Eval      ZMDAY = IDVALD                               215205
     C                   CALL      'ZM0060'                             15
     C                   PARM                    ZMDAY
     C                   PARM                    ZMDATE
      *
     C                   Eval      SavDate = ZMDATE
      *
      ** If the program ends in error.
      *
     C     *IN15         IFEQ      '1'
     C     *LOCK         IN        LDA
     C                   Z-ADD     3             DBASE                            * * * * * * *
     C                   MOVEL     '       '     DBKEY                            * DBERR 003 *
     C                   MOVEL     'ZM0060'      DBFILE                           * * * * * * *
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   END
      *
     C                   Movel     ZMDATE        MFLD
 
      * Field :21:
     C                   Eval      Q = Q + 1
     C     Q             Occur     MULT
     C                   Eval      MTAG = ':21:'
     C     IDENAR        ifne      'CMX'
     C                   Eval      MFLD = IDENAR
     C                   else
     C                   If        IDSTYP = 'Z'                                 212316
     C*******************Eval      MFLD = 'CMZ' +'/'+%subst(IDEXA1:2:34) 212316 213572
     C                   Eval      MFLD = 'CMZ' + '/' + WAccount                213572
     C                   Else                                                   212316
     C*******************Eval      MFLD = 'CMT' +'/'+%subst(IDEXA1:2:34) 212316 213572
     C                   Eval      MFLD = 'CMT' + '/' + WAccount                213572
     C                   Endif                                                  212316
     C*******************Eval      MFLD = 'NONREF'                              212316
     C                   endif
 
      * Field :23E:  Instruction Code
     C                   Eval      Q = Q + 1
     C     Q             Occur     MULT
     C                   Eval      MTAG = ':23E:'
     C                   Eval      MFLD = IDINCD
 
      * Field :32B:  Currency and Top amount
     C                   Eval      Q = Q + 1
     C     Q             Occur     MULT
     C                   Eval      MTAG = ':32B:'
     C
     C                   MOVE      IDCCCY        ZCCY
     C                   Z-add     IDSWFA        ZAMNT
     C                   CALL      'ZM0040'                             15
     C                   PARM                    ZAMNT            13 0
     C                   PARM                    ZCCY              3
     C                   PARM                    ZSAMNT           15
     C                   PARM                    ZSCCY             3
     C                   PARM                    ZERR              1
     C                   PARM                    ZSWDPC            1                          222373
      *
      ** If the program ends in error.
      *
     C     *IN15         IFEQ      '1'
     C     ZERR          OREQ      '1'
     C     *LOCK         IN        LDA
     C                   Z-ADD     4             DBASE                            * * * * * * *
     C                   MOVEL     '       '     DBKEY                            * DBERR 004 *
     C                   MOVEL     'ZM0040'      DBFILE                           * * * * * * *
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   END
 
     C                   Eval      MFLD = ZSCCY + ZSAMNT
     C                   Eval      SavAmount = ZSAMNT
 
      * Field :50L: = Instructing Party
 
     C                   Eval      Q = Q + 1
     C     Q             Occur     MULT
     C
     C                   MOVEL     IDCCUS        ZDEST
     C                   CALL      'ZM0055'                             15
     C                   PARM                    ZDEST            12
     C                   PARM                    ZSADD1           35
     C                   PARM                    ZSADD2           35
     C                   PARM                    ZSADD3           35
     C                   PARM                    ZSADD4           35
     C                   PARM                    ZERR
      ** If the program ends in error.
      *
     C     *IN15         IFEQ      '1'
     C     ZERR          OREQ      '1'
     C     *LOCK         IN        LDA
     C                   Z-ADD     5             DBASE                            * * * * * * *
     C                   MOVEL     '       '     DBKEY                            * DBERR 005 *
     C                   MOVEL     'ZM0055'      DBFILE                           * * * * * * *
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   END
 
     C                   Eval      MTAG = ':50L:'
     C                   Eval      ZSADD2 = *blanks                             211499
     C                   Eval      ZSADD3 = *blanks                             211499
     C                   Eval      ZSADD4 = *blanks                             211499
     C                   Exsr      SWADF
 
      * Field :57A: Account with Bank = Sender's BIC
     C                   Eval      Q = Q + 1
     C     Q             Occur     MULT
     C                   Eval      MTAG = ':57A:'
     C***********        Eval      MFLD = O@NWSN                                213930
     C                   Eval      MFLD = %SUBST(O@NWSN:1:8) +                  213930
     C                                    %SUBST(O@NWSN:10:3)                   213930
 
      * Field :59: Beneficiary
     C
                                                                                              CSW215
      ** If CSW215 is installed, check if Beneficiary is in 59F format                        CSW215
                                                                                              CSW215
     C                   EVAL      Wrk59F = 'N'                                               CSW215
     C                   IF        CSW215 = 'Y'                                               CSW215
     C                   EXSR      SRInit59F                                                  CSW215
     C                   MOVEL     IDCCUS        PInpParm1                                    CSW215
     C                   EVAL      PMsgtyp = '101'                                            CSW215
     C                   EXSR      SRFormat59F                                                CSW215
     C                   ENDIF                                                                CSW215
                                                                                              CSW215
     C                   IF        Wrk59F = 'Y'                                               CSW215
     C                   EVAL      WMsgType = '101'                                           CSW215
     C                   EXSR      SROut59F                                                   CSW215
     C                   ELSE                                                                 CSW215
                                                                                              CSW215
     C                   MOVEL     IDCCUS        ZDEST
     C                   CALL      'ZM0055'                             15
     C                   PARM                    ZDEST            12
     C                   PARM                    ZSADD1           35
     C                   PARM                    ZSADD2           35
     C                   PARM                    ZSADD3           35
     C                   PARM                    ZSADD4           35
     C                   PARM                    ZERR
      ** If the program ends in error.
      *
     C     *IN15         IFEQ      '1'
     C     ZERR          OREQ      '1'
     C     *LOCK         IN        LDA
     C                   Z-ADD     6             DBASE                            * * * * * * *
     C                   MOVEL     '       '     DBKEY                            * DBERR 006 *
     C                   MOVEL     'ZM0055'      DBFILE                           * * * * * * *
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   END
 
     C                   Eval      Q = Q + 1
     C     Q             Occur     MULT
     C                   Eval      MTAG = ':59:'
     C                   Eval      MFLD = '/' + WAccount
 
     C                   Eval      Q = Q + 1
     C     Q             Occur     MULT
     C                   Eval      ZSADD2 = *blanks                             211499
     C                   Eval      ZSADD3 = *blanks                             211499
     C                   Eval      ZSADD4 = *blanks                             211499
     C                   Exsr      SWADF
     C                   ENDIF                                                                CSW215
 
      * Field :70:
     C                   Eval      Q = Q + 1
     C     Q             Occur     MULT
     C                   Eval      MTAG = ':70:'
     C                   If        IDSTYP = 'Z'
     C                   Eval      MFLD = 'CMZ' + '/' + %subst(IDEXA1:2:34)
     C                   Else
     C                   Eval      MFLD = 'CMT' + '/' + %subst(IDEXA1:2:34)
     C                   Endif
 
     C*******************If        IDENAR <> 'CMX'                              213572
     C                   If        IDTNAR <> 'CMX'                              213572
     C                   Eval      Q = Q + 1
     C     Q             Occur     MULT
     C                   Eval      MFLD = '/' + IDTNAR                          213572
     C*******************Eval      MFLD = '/' + IDENAR                          213572
     C                   Endif
 
      * Field :71A:  Details  of Charges
     C                   Eval      Q = Q + 1
     C     Q             Occur     MULT
     C                   Eval      MTAG = ':71A:'
     C                   Eval      MFLD = IDCHGR
 
 
      * = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =
      *                    F I L E    O U T P U T
 
      * Output formatted message to MGOMSGPD
     C                   EXSR      WriteMGOMSG
 
      * Write MGOREFPD record
     C                   Eval      MTPY = '101'
     C                   EXSR      WriteMGOREF
 
      * Update REICSDPD file
     C                   Eval      IDMSGT = MGTM
     C                   Eval      IDMSGP = 'Y'
     C                   Eval      IDOMSR = SavTrno
     C                   Eval      IDSNDR = NWSN
     C                   Update    REICSDD0
 
     C                   COMMIT
 
      * = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =
     C                   EVAL      COUNT101 = COUNT101 + 1
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRMT103  - Format  MT103 Message details (External Sweeping)  *
      *            Or Reply to received MT101 but translation  not    *
      *            defined in MT101/MT103 translation table           *
      *****************************************************************
     C     SRMT103       BEGSR
 
      * Re-initialise work fields
     C                   Exsr      SRClear
     C                   IF        CSW209 = 'Y'                                               CSW209
     C                   MOVEL     *BLANKS       MT103R                                       CSW209
     C                   ENDIF                                                                CSW209
 
 
      * = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =
      *                    M E S S A G E     D A T A
      *                                                                                       CSW218
      ** Field :121: - UETR (Unique End-to-end Transaction Reference)                         CSW218
      *                                                                                       CSW218
     C                   IF        CSW218 = 'Y'                                               CSW218
     C                   CALL      'MGC001802'                                                CSW218
     C                   PARM      *BLANKS       PUUID                                        CSW218
     C                   EVAL      Q = 1                                                      CSW218
     C     Q             OCCUR     MULT                                                       CSW218
     C                   EVAL      MTAG = ':121:'                                             CSW218
     C                   EVAL      MFLD = PUUID                                               CSW218
     C                   ENDIF                                                                CSW218
      *                                                                                       CSW218
 
      * Field :20:  = 'RE' + Link Reference (last 6 only) + Rund in YYMMDD + Sequence
     C                   IF        CSW218 = 'Y'                                               CSW218
     C                   EVAL      Q = Q +1                                                   CSW218
     C                   ELSE                                                                 CSW218
     C                   Eval      Q = 1
     C                   ENDIF                                                                CSW218
     C     Q             Occur     MULT
     C                   EVAL      MsgSeqA = %SUBST(Reference:10:2)             216421
      *  Determine Message Seq (if not a reply 103 generated by RE102002)       216421
     C     IDR3RF        IFEQ      *BLANK                                       216421
     C                   EXSR      DET_MSGSEQ                                   216421
     C                   ENDIF                                                  216421
     C                   Eval      MTAG = ':20:'
     C                   Eval      SavTrno = 'RE' + %SUBST(Reference:4:6) +
     C                                       WMgde + MsgSeqA                    216421
     C***************************************WMgde + %SUBST(Reference:10:2)     216421
     C                   Eval      MFLD    = SavTrno
 
      * Field :23B:
     C                   Eval      Q = Q + 1
     C     Q             Occur     MULT
     C                   Eval      MTAG = ':23B:'
     C                   Eval      MFLD = IDBOCD
 
      * Field :23E:
     C                   Eval      Q = Q + 1
     C     Q             Occur     MULT
     C                   Eval      MTAG = ':23E:'
     C                   Eval      MFLD = IDINCD
 
      * Field :32A:
     C                   Eval      Q = Q + 1
     C     Q             Occur     MULT
     C                   Eval      MTAG = ':32A:'
      *
      *  Adjust value date (if not a reply 103 generated by RE102002)           216421
     C     IDR3RF        IFEQ      *BLANK                                       216421
     C                   EXSR      ADJ_VALD                                     216421
     C                   Eval      ZMDAY = AdjValDate                           215205
     C                   ELSE                                                   215205
     C*******************ENDIF                                           216421 215205
     C                   Eval      ZMDAY = IDVALD
     C                   ENDIF                                                  215205
     C                   CALL      'ZM0060'                             15
     C                   PARM                    ZMDAY             5 0
     C                   PARM                    ZMDATE            6
      *
     C                   Eval      SavDate = ZMDATE
      *
      ** If the program ends in error.
      *
     C     *IN15         IFEQ      '1'
     C     *LOCK         IN        LDA
     C                   Z-ADD     7             DBASE                            * * * * * * *
     C                   MOVEL     '       '     DBKEY                            * DBERR 007 *
     C                   MOVEL     'ZM0060'      DBFILE                           * * * * * * *
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   END
     C
     C                   MOVE      IDCCCY        ZCCY
     C                   Z-add     IDSWFA        ZAMNT
      *
     C* Subtract charges if 'BEN'
     C* Swift Amount is yet to be deducted with the charge amount (in
     C* RE100608)
     C                   If        IDCHGR = 'BEN' And
     C                             IDCACT = *blank
     C*********          Eval      ZAMNT = ZAMNT - IDCAMT                       213569
     C                   Exsr      Det_ChgAmt                                   213569
     C                   Eval      ZAMNT = ZAMNT - ChgAmount                    213569
     C                   Endif
      *
     C                   CALL      'ZM0040'                             15
     C                   PARM                    ZAMNT            13 0
     C                   PARM                    ZCCY              3
     C                   PARM                    ZSAMNT
     C                   PARM                    ZSCCY             3
     C                   PARM                    ZERR              1
     C                   PARM                    ZSWDPC                                       222373
      *
     C                   Eval      SavAmount = ZSAMNT
      *
      ** If the program ends in error.
      *
     C     *IN15         IFEQ      '1'
     C     ZERR          OREQ      '1'
     C     *LOCK         IN        LDA
     C                   Z-ADD     8             DBASE                            * * * * * * *
     C                   MOVEL     '       '     DBKEY                            * DBERR 008 *
     C                   MOVEL     'ZM0040'      DBFILE                           * * * * * * *
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   END
     C
     C                   Eval      Sav32A = SavDate + ZSCCY + ZSAMNT
     C                   Eval      MFLD   = Sav32A
     C
      * Field :33B: = Currency and Amount of 32A
     C                   Eval      Q = Q + 1
     C     Q             Occur     MULT
     C                   Eval      MTAG = ':33B:'
      *
     C                   Z-add     IDSWFA        ZAMNT
     C                   CALL      'ZM0040'                             15
     C                   PARM                    ZAMNT            13 0
     C                   PARM                    ZCCY              3
     C                   PARM                    ZSAMNT
     C                   PARM                    ZSCCY             3
     C                   PARM                    ZERR              1
     C                   PARM                    ZSWDPC                                       222373
      *
      ** If the program ends in error.
      *
     C     *IN15         IFEQ      '1'
     C     ZERR          OREQ      '1'
     C     *LOCK         IN        LDA
     C                   Z-ADD     9             DBASE                            * * * * * * *
     C                   MOVEL     '       '     DBKEY                            * DBERR 009 *
     C                   MOVEL     'ZM0040'      DBFILE                           * * * * * * *
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   END
     C                   Eval      MFLD = ZSCCY + ZSAMNT
                                                                                              CSW209
     C                   IF        CSW209 = 'Y'                                               CSW209
      * Save :33B: message data to be used in MT202 COV                                       CSW209
     C                   MOVEL     MFLD          Sav33B                                       CSW209
     C                   ENDIF                                                                CSW209
 
      * Field :50a: = Ordering Customer
     C                   IF        CSW209 = 'Y'                                               CSW209
                                                                                              CSW209
     C                   EVAL      PMsgType = '103'                                           CSW209
      * Set Parameter for MT103                                                               CSW209
     C                   MOVEL     IDCCUS        PCustNo                                      CSW209
     C                   MOVEL     IDCCUS        PInp1                                        CSW209
     C                   EVAL      PInp2 = *Blanks                                            CSW209
     C                   EVAL      PInp3 = *Blanks                                            CSW209
     C                   EVAL      PInp4 = *Blanks                                            CSW209
     C                   EVAL      PInp5 = *Blanks                                            CSW209
     C                   EVAL      PAcctType = 'C'                                            CSW209
     C                   EVAL      PAccount  = *Blanks                                        CSW209
     C                   EVAL      PNonAcctHldr = *Blanks                                     CSW209
     C                   EVAL      PNetwork  = NWRK                                           CSW209
     C                   EVAL      PMsgField = ':50F:'                                        CSW209
     C                   EVAL      PBrchCode = CDBRCA                                         CSW209
     C                   EVAL      PCurrCode = IDCCCY                                         CSW209
     C                   EVAL      PNostro   = *Blanks                                        CSW209
     C                   EVAL      PModi     = 'RE'                                           CSW209
                                                                                              CSW209
     C                   CALL      'FT001000'                                                 CSW209
                                                                                              CSW209
      ** Input Parameters                                                                     CSW209
      ** Return Code                                                                          CSW209
     C                   PARM      *BLANKS       PRtnCode                                     CSW209
      ** Message ID                                                                           CSW209
     C                   PARM      *BLANKS       PMsgID                                       CSW209
      ** Error Type                                                                           CSW209
     C                   PARM      *BLANK        PErTyp                                       CSW209
      ** Validation Type                                                                      CSW209
     C                   PARM      'FRMT'        PVTyp                                        CSW209
      ** 5X35 input line                                                                      CSW209
     C                   PARM                    PInp1                                        CSW209
     C                   PARM                    PInp2                                        CSW209
     C                   PARM                    PInp3                                        CSW209
     C                   PARM                    PInp4                                        CSW209
     C                   PARM                    PInp5                                        CSW209
      ** Account Type                                                                         CSW209
     C                   PARM                    PAcctType                                    CSW209
      ** Account                                                                              CSW209
     C                   PARM                    PAccount                                     CSW209
      ** Customer Number                                                                      CSW209
     C                   PARM                    PCustNo                                      CSW209
      ** Non Account Holder                                                                   CSW209
     C                   PARM                    PNonAcctHldr                                 CSW209
      ** Network                                                                              CSW209
     C                   PARM                    PNetwork                                     CSW209
      ** Message Type                                                                         CSW209
     C                   PARM                    PMsgType                                     CSW209
      ** Message Tag                                                                          CSW209
     C                   PARM                    PMsgField                                    CSW209
      ** Country                                                                              CSW209
     C                   PARM                    PCountry                                     CSW209
      ** Branch Code                                                                          CSW209
     C                   PARM                    PBrchCode                                    CSW209
      ** Currency Code                                                                        CSW209
     C                   PARM                    PCurrCode                                    CSW209
      ** Nostro Flag                                                                          CSW209
     C                   PARM                    PNostro                                      CSW209
      ** Module Indicator                                                                     CSW209
     C                   PARM                    PModI                                        CSW209
                                                                                              CSW209
      ** Output Parameters                                                                    CSW209
      ** Message Line 1                                                                       CSW209
     C                   PARM                    PMsgLine01                                   CSW209
      ** Message Line 2                                                                       CSW209
     C                   PARM                    PMsgLine02                                   CSW209
      ** Message Line 3                                                                       CSW209
     C                   PARM                    PMsgLine03                                   CSW209
      ** Message Line 4                                                                       CSW209
     C                   PARM                    PMsgLine04                                   CSW209
      ** Message Line 5                                                                       CSW209
     C                   PARM                    PMsgLine05                                   CSW209
                                                                                              CSW209
     C                   MOVEL     *BLANKS       PRC50A                                       CSW209
     C                   IF        PRtnCode = *BLANKS                                         CSW209
     C                   MOVEL     ':50F:'       PRC50A                                       CSW209
     C                   ELSE                                                                 CSW209
     C                   MOVEL     ':50K:'       PRC50A                                       CSW209
     C                   ENDIF                                                                CSW209
                                                                                              CSW209
     C                   ENDIF                                                                CSW209
                                                                                              CSW209
     C     CSW209        IFEQ      'Y'                                                        CSW209
     C     PRC50A        ANDEQ     ':50F:'                                                    CSW209
     C                   EVAL      Q = Q + 1                                                  CSW209
     C     Q             OCCUR     MULT                                                       CSW209
     C                   EVAL      MTag = ':50F:'                                             CSW209
     C                   EVAL      MFLD = PMsgLine01                                          CSW209
     C                   IF        PMsgLine02 <> *BLANKS                                      CSW209
     C                   EVAL      Q = Q + 1                                                  CSW209
     C     Q             OCCUR     MULT                                                       CSW209
     C                   EVAL      MFLD = PMsgLine02                                          CSW209
     C                   ENDIF                                                                CSW209
     C                   IF        PMsgLine03 <> *BLANKS                                      CSW209
     C                   EVAL      Q = Q + 1                                                  CSW209
     C     Q             OCCUR     MULT                                                       CSW209
     C                   EVAL      MFLD = PMsgLine03                                          CSW209
     C                   ENDIF                                                                CSW209
     C                   IF        PMsgLine04 <> *BLANKS                                      CSW209
     C                   EVAL      Q = Q + 1                                                  CSW209
     C     Q             OCCUR     MULT                                                       CSW209
     C                   EVAL      MFLD = PMsgLine04                                          CSW209
     C                   ENDIF                                                                CSW209
     C                   IF        PMsgLine05 <> *BLANKS                                      CSW209
     C                   EVAL      Q = Q + 1                                                  CSW209
     C     Q             OCCUR     MULT                                                       CSW209
     C                   EVAL      MFLD = PMsgLine05                                          CSW209
     C                   ENDIF                                                                CSW209
                                                                                              CSW209
      * Save :50F: message data to be used in MT202 COV                                       CSW209
     C                   MOVEL     ':50F:'       MTAG50A                                      CSW209
     C                   MOVEL     PMsgLine01    ADD50A1                                      CSW209
     C                   MOVEL     PMsgLine02    ADD50A2                                      CSW209
     C                   MOVEL     PMsgLine03    ADD50A3                                      CSW209
     C                   MOVEL     PMsgLine04    ADD50A4                                      CSW209
     C                   MOVEL     PMsgLine05    ADD50A5                                      CSW209
                                                                                              CSW209
     C                   ELSE                                                                 CSW209
     C                   MOVEL     IDCCUS        ZDEST
     C***********        CALL      'ZM0050'                             15      212836
     C***********        PARM                    ZDEST            12            212836
     C***********        PARM                    ZSADD1           35            212836
     C***********        PARM                    ZSADD2           35            212836
     C***********        PARM                    ZSADD3           35            212836
     C***********        PARM                    ZSADD4           35            212836
     C***********        PARM                    ZSTAG             1            212836
     C***********        PARM                    ZSTYPE            1            212836
     C***********        PARM                    ZERR                           212836
     C***********        PARM      *blank        ZDBEI             1            212836
      ***If*the*program ends in error.                                          212836
      ***********                                                               212836
     C******IN15*        IFEQ      '1'                                          212836
     C*****ZERR**        OREQ      '1'                                          212836
     C******LOCK*        IN        LDA                                          212836
     C***********        Z-ADD     10            DBASE                          212836
     C***********        MOVEL     '       '     DBKEY                          212836
     C***********        MOVEL     'ZM0050'      DBFILE                         212836
     C***********        OUT       LDA                                          212836
     C***********        EXSR      *PSSR                                        212836
     C***********        END                                                    212836
      ***********                                                               212836
     C***********        Eval      Q = Q + 1                                    212836
     C*****Q*****        Occur     MULT                                         212836
      ***********                                                               212836
     C*****ZSTAG*        IFEQ      'A'                                          212836
      ***********                                                               212836
     C***********        Eval      MTAG = ':50A:'                               212836
      ***********                                                               212836
      **Check*further if SWIFT Id is not an agent Id                            212836
      ***********                                                               212836
     C***********        If        CSW024 = 'Y'                                 212836
     C***********        Movel     IDCCUS        PKEY1                          212836
     C***********        CALL      'AOCUSTR0'                                   212836
     C***********        PARM      *BLANKS       PRTCD             7            212836
     C***********        PARM      '*KEY   '     POPTN             7            212836
     C***********        PARM                    PKEY1            10            212836
     C***********        PARM      *BLANK        PKYST             7            212836
     C*****SDCUST        PARM      SDCUST        DSSDY                          212836
      ***Error*on call                                                          212836
     C*****@RTCD*        IFNE      *BLANK                                       212836
     C******LOCK*        IN        LDA                                          212836
     C***********        Z-ADD     28            DBASE                          21*8*6* * * * *
     C***********        MOVEL     A7CUST        DBKEY                          21*8DBERR 028 *
     C***********        MOVEL     'SDCUSTPD'    DBFILE                         21*8*6* * * * *
     C***********        OUT       LDA                                          212836
     C***********        EXSR      *PSSR                                        212836
     C***********        ENDIF                                                  212836
      ***********                                                               212836
     C***********        If        BBCORP = 'Y'                                 212836
     C***********        If        BBCBEI <> *blank                             212836
     C***********        Eval      MTAG = ':50A:'                               212836
     C***********        Eval      ZSADD1 = BBCBEI                              212836
     C***********        Else                                                   212836
     C***********        Eval      MTAG = ':50K:'                               212836
     C***********        Eval      ZSADD1 = BBCNA1                              212836
     C***********        Eval      ZSADD2 = BBCNA2                              212836
     C***********        Eval      ZSADD3 = BBCNA3                              212836
     C***********        Eval      ZSADD4 = BBCNA4                              212836
     C***********        Endif                                                  212836
     C***********        Endif                                                  212836
      ***********                                                               212836
     C***********        Endif                                                  212836
      ***********                                                               212836
     C***********        ELSE                                                   212836
      ***********                                                               212836
     C***********        Eval      MTAG = ':50K:'                               212836
      ***********                                                               212836
     C***********        Endif                                                  212836
      ***********                                                               212836
     C                   Eval      Q = Q + 1                                    214360
     C     Q             Occur     MULT                                         214360
     C                   CALL      'ZM0055'                             15      212836
     C                   PARM                    ZDEST            12            212836
     C                   PARM                    ZSADD1           35            212836
     C                   PARM                    ZSADD2           35            212836
     C                   PARM                    ZSADD3           35            212836
     C                   PARM                    ZSADD4           35            212836
     C                   PARM                    ZERR                           212836
      ** If the program ends in error.                                          212836
      *                                                                         212836
     C     *IN15         IFEQ      '1'                                          212836
     C     ZERR          OREQ      '1'                                          212836
     C     *LOCK         IN        LDA                                          212836
     C                   Z-ADD     10            DBASE                          212836
     C                   MOVEL     '       '     DBKEY                          212836
     C                   MOVEL     'ZM0055'      DBFILE                         212836
     C                   OUT       LDA                                          212836
     C                   EXSR      *PSSR                                        212836
     C                   END                                                    212836
                                                                                212836
     C                   Eval      MTAG = ':50K:'                               212836
     C                   IF        Wacnum <> *BLANKS                                        AR960455
     C                   MOVE      *BLANK        WRK34            34                        AR960455
     C                   MOVEL     WAcnum        WRK34                                      AR960455
     C                   EXSR      FormAccnt                                                AR960455
     C                   ELSE                                                               AR960455
     C                   Exsr      SWADF
     C                   ENDIF                                                              AR960455
                                                                                              CSW209
     C                   IF        CSW209 = 'Y'                                               CSW209
      * Save :50K: message data to be used in MT202 COV                                       CSW209
     C                   IF        WRK34  <> *BLANKS                                        AR960455
     C                   MOVE      *BLANK        Wacnum2                                    AR960455
     C                   MOVEL     '/'           Wacnum2                                    AR960455
     C                   MOVE      WRK34         Wacnum2                                    AR960455
     C                   MOVEL     ':50K:'       MTAG50A                                    AR960455
     C                   MOVEL     Wacnum2       ADD50A1                                    AR960455
     C                   MOVEL     ZSADD1        ADD50A2                                    AR960455
     C                   MOVEL     ZSADD2        ADD50A3                                    AR960455
     C                   MOVEL     ZSADD3        ADD50A4                                    AR960455
     C                   MOVEL     ZSADD4        ADD50A5                                    AR960455
     C                   ELSE                                                               AR960455
     C                   MOVEL     ':50K:'       MTAG50A                                      CSW209
     C                   MOVEL     ZSADD1        ADD50A1                                      CSW209
     C                   MOVEL     ZSADD2        ADD50A2                                      CSW209
     C                   MOVEL     ZSADD3        ADD50A3                                      CSW209
     C                   MOVEL     ZSADD4        ADD50A4                                      CSW209
     C                   ENDIF                                                              AR960455
     C                   ENDIF                                                                CSW209
 
     C                   ENDIF                                                                CSW209
                                                                                              CSW209
      * Field :53a:
     C                   If        IDSNDC <> *blanks
     C                   CALL      'AONOSTR0'
     C                   PARM      *BLANK        @RTCD             7
     C                   PARM      '*KEY   '     @OPTN             7
     C                   PARM      *BLANK        @CUST             6
     C                   PARM      IDCCCY        @CYCD             3
     C**********         PARM      *BLANK        @ACCD             4                          CGL029
     C                   PARM      *BLANK        @ACCD            10                          CGL029
     C                   PARM      *BLANK        @ACSN             2
     C                   PARM      IDSNDC        @NONB             2
     C                   PARM      *BLANK        @BRCD             3
     C                   PARM      *BLANK        @CSSN            10
     C                   PARM      *BLANK        @PNOI             1
     C     SDNOST        PARM      SDNOST        DSFDY
 
      ** Error on call
 
     C     @RTCD         IFNE      *BLANK
     C     *LOCK         IN        LDA
     C                   Z-ADD     11            DBASE                            * * * * * * *
     C                   MOVEL     '*KEY '       DBKEY                            * DBERR 011 *
     C                   MOVEL     'SDNOSTPD'    DBFILE                           * * * * * * *
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   Eval      PKEY1 = A7CUST
     C                   CALL      'AOCUSTR0'
     C                   PARM      *BLANKS       PRTCD             7
     C                   PARM      '*KEY   '     POPTN             7
     C                   PARM                    PKEY1            10
     C                   PARM      *BLANK        PKYST             7
     C     SDCUST        PARM      SDCUST        DSSDY
      ** Error on call
     C     @RTCD         IFNE      *BLANK
     C     @RTCD         OREQ      *BLANK
     C     BBCSID        ANDEQ     *BLANK
     C     *LOCK         IN        LDA
     C                   Z-ADD     12            DBASE                            * * * * * * *
     C                   MOVEL     A7CUST        DBKEY                            * DBERR 012 *
     C                   MOVEL     'SDCUSTPD'    DBFILE                           * * * * * * *
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   Eval      Q = Q + 1
     C     Q             Occur     MULT
     C                   Eval      MTAG = ':53A:'
     C                   Eval      MFLD = BBCSID
      *Save customer number and swift ID for MT202 cover
     C                   Move      BBCUST        W202Decn
     C                   Move      BBCSID        W202Nwds
     C                   Endif
 
      * Field :54a:
     C                   If        IDRCVC <> *blanks
     C                   Eval      Q = Q + 1
     C     Q             Occur     MULT
     C                   Eval      MTAG = ':54A:'
     C                   Eval      MFLD = IDRCVC
     C                   Eval      Sav54L1 = MFLD
     C                   Eval      Sav54L2 = *blanks
     C                   Eval      Sav54L3 = *blanks
     C                   Eval      Sav54L4 = *blanks
     C                   Eval      Sav54L5 = *blanks
     C                   Eval      Sav54Tag = MTAG
     C                   Endif
 
      * Field :59: = Beneficiary
 
     C                   EXSR      SRMT103F                                                   CSW215
                                                                                              CSW215
     C                   IF        Wrk59F = 'Y'                                               CSW215
     C                   EVAL      WMsgType = '103'                                           CSW215
     C                   EXSR      SROut59F                                                   CSW215
     C                   ELSE                                                                 CSW215
                                                                                              CSW215
     C                   Eval      Q = Q + 1
     C     Q             Occur     MULT
     C                   Eval      MTAG = ':59:'
     C                   Eval      MFLD = IDEXA1
                                                                                              CSW209
     C                   IF        CSW209 = 'Y'                                               CSW209
      * Save :59: message data to be used in MT202 COV                                        CSW209
     C                   MOVEL     MFLD          Save59                                       CSW209
     C                   ENDIF                                                                CSW209
                                                                                              CSW209
     C                   Eval      Q = Q + 1
     C     Q             Occur     MULT
 
     C                   Eval      ZSADD1 = IDEXA2
     C***********        Eval      ZSADD2 = IDEXA3                              211499
     C***********        Eval      ZSADD3 = IDEXA4                              211499
     C***********        Eval      ZSADD4 = IDEXA5                              211499
     C                   Eval      ZSADD2 = *blank                              211499
     C                   Eval      ZSADD3 = *blank                              211499
     C                   Eval      ZSADD4 = *blank                              211499
     C                   Exsr      SWADF
                                                                                              CSW209
     C                   IF        CSW209 = 'Y'                                               CSW209
      * Save :59: message data to be used in MT202 COV                                        CSW209
     C                   MOVEL     ZSADD1        ADD591                                       CSW209
     C                   ENDIF                                                                CSW209
     C                   ENDIF                                                                CSW215
 
      * Field :70:
     C                   Eval      Q = Q + 1
     C     Q             Occur     MULT
     C                   Eval      MTAG = ':70:'
     C                   If        IDSTYP = 'Z'
     C                   Eval      MFLD = 'CMZ' + '/' + WAccount
     C                   Else
     C                   Eval      MFLD = 'CMS' + '/' + WAccount
     C                   Endif
                                                                                              CSW209
     C                   IF        CSW209 = 'Y'                                               CSW209
      * Save :70: message data to be used in MT202 COV                                        CSW209
     C                   MOVEL     MFLD          Save70                                       CSW209
     C                   ENDIF                                                                CSW209
 
     C                   If        IDENAR <> 'CMX'
     C                   Eval      Q = Q + 1
     C     Q             Occur     MULT
     C                   Eval      MFLD = '/' + IDENAR
                                                                                              CSW209
     C                   IF        CSW209 = 'Y'                                               CSW209
      * Save :70: message data to be used in MT202 COV                                        CSW209
     C                   MOVEL     MFLD          Save701                                      CSW209
     C                   ENDIF                                                                CSW209
                                                                                              CSW209
     C                   Endif
 
      * Field :71A:
     C                   Eval      Q = Q + 1
     C     Q             Occur     MULT
     C                   Eval      MTAG = ':71A:'
     C                   Eval      MFLD = IDCHGR
 
      * Field :71F:
     C                   If        IDCHGR = 'BEN'
     C                   Eval      Q = Q + 1
     C     Q             Occur     MULT
     C                   Eval      MTAG = ':71F:'
     C*******************Z-add     IDCAMT        ZAMNT                          213569
     C     IDCACT        IFEQ      *BLANK                                       213569
     C                   Z-add     IDCAMT        ZAMNT                          213569
     C                   Else                                                   213569
     C                   Z-add     0             ZAMNT                          213569
     C                   Endif                                                  213569
     C                   CALL      'ZM0040'                             15
     C                   PARM                    ZAMNT            13 0
     C                   PARM                    ZCCY              3
     C                   PARM                    ZSAMNT
     C                   PARM                    ZSCCY             3
     C                   PARM                    ZERR              1
     C                   PARM                    ZSWDPC                                       222373
      *
      ** If the program ends in error.
      *
     C     *IN15         IFEQ      '1'
     C     ZERR          OREQ      '1'
     C     *LOCK         IN        LDA
     C                   Z-ADD     13            DBASE                            * * * * * * *
     C                   MOVEL     '       '     DBKEY                            * DBERR 013 *
     C                   MOVEL     'ZM0040'      DBFILE                           * * * * * * *
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   Endif
 
     C***********        Eval      MFLD = ZSAMNT                                213569
     C                   Eval      MFLD = ZSCCY + ZSAMNT                        213569
     C                   Endif
 
      * = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =
      *                    F I L E   O U T P U T
 
      * Output formatted message to MGOMSGPD
     C                   EXSR      WriteMGOMSG
 
      * Write MGOREFPD record
     C                   Eval      MTPY = '103'
     C                   EXSR      WriteMGOREF
 
      * Update REICSDPD file
     C                   Eval      IDMSGT = MGTM
     C                   Eval      IDMSGP = 'Y'
     C                   Eval      IDOMSR = SavTrno
     C                   Eval      IDSNDR = NWSN
     C                   Update    REICSDD0
 
      * = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =
      *                    M T 2 0 2     G E N E R A T I O N
 
      * Call Cover MT202 extraction if Cover Message Required
     C                   If        IDMCMR = 'Y'
      *  Save MT103 destination address  for MT202 beneficiary
     C                   Movel     NWDS          Sav103Dest       11
     C                   Eval      SecondCall = 'Y'
     C                   Exsr      SRRout
     C                   Exsr      SRMT202
     C                   Endif
 
     C                   COMMIT
 
      * = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =
 
     C                   EVAL      COUNT103 = COUNT103 + 1
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRMT202 -- Format Cover MT202 Message                         *
      *****************************************************************
     C     SRMT202       BEGSR
 
      * Re-initialise work fields
     C                   Exsr      SRClear
 
      * = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =
      *                    M E S S A G E     D A T A
 
     C                   IF        CSW209 = 'Y'                                               CSW209
      *                                                                                       CSW209
      * Test if a MT202 or MT202 COV has to be created                                        CSW209
      *                                                                                       CSW209
     C                   EVAL      @SNCO = *BLANKS                                            CSW209
     C                   EVAL      @RVCO = *BLANKS                                            CSW209
     C                   EVAL      @SSWID = *BLANKS                                           CSW209
     C                   EVAL      @RSWID = *BLANKS                                           CSW209
     C                   EVAL      @SNCO = IDCCCY + IDSNDC                                    CSW209
     C                   MOVEL     NWSN          @SSWID                                       CSW209
     C                   MOVEL     NWDS          @RSWID                                       CSW209
     C                   MOVEL     IDRCVC        @RVCO                                        CSW209
      *                                                                                       CSW209
     C                   CALL      'AOBAGRV0'                                                 CSW209
     C                   PARM      *Blanks       @RTCD                                        CSW209
     C                   PARM      'SCT_C202'    @BTYP                                        CSW209
     C                   PARM                    CDBRCA                                       CSW209
     C                   PARM      'SWIFT'       @NTWK                                        CSW209
     C                   PARM      '103'         @MTYP                                        CSW209
     C                   PARM                    IDCCCY                                       CSW209
     C                   PARM                    IDCCCY                                       CSW209
     C                   PARM                    @SSWID                                       CSW209
     C                   PARM                    @RSWID                                       CSW209
     C                   PARM      *Blanks       @VALF                                        CSW209
     C                   PARM      *Blanks       @ORDB                                        CSW209
     C                   PARM      *Blanks       @SDRV                                        CSW209
     C                   PARM                    @SNCO                                        CSW209
     C                   PARM                    @RVCO                                        CSW209
                                                                                              CSW209
     C     @RTCD         IFEQ      '*CRTCOV'                                                  CSW209
                                                                                              CSW209
      * Field :119: is cover information                                                      CSW209
     C                   EVAL      Q = 1                                                      CSW209
     C     Q             OCCUR     MULT                                                       CSW209
     C                   EVAL      MTAG = ':119:'                                             CSW209
     C                   EVAL      MFLD =  'COV'                                              CSW209
      *                                                                                       CSW209
     C                   ENDIF                                                                CSW209
      *                                                                                       CSW209
     C                   ENDIF                                                                CSW209
      *                                                                                       CSW218
      ** Field :121: - UETR (Unique End-to-end Transaction Reference)                         CSW218
      *                                                                                       CSW218
     C                   IF        CSW218 = 'Y'                                               CSW218
     C                   EVAL      Q = Q + 1                                                  CSW218
     C     Q             OCCUR     MULT                                                       CSW218
     C                   IF        @RTCD = '*CRTCOV'                                          CSW218
     C                   EVAL      MTAG = ':121:'                                             CSW218
     C                   EVAL      MFLD = PUUID                                               CSW218
     C                   ELSE                                                                 CSW218
     C                   CALL      'MGC001802'                                                CSW218
     C                   PARM      *BLANKS       PUUID                                        CSW218
     C                   EVAL      MTAG = ':121'                                              CSW218
     C                   EVAL      MFLD = PUUID                                               CSW218
     C                   ENDIF                                                                CSW218
     C                   ENDIF                                                                CSW218
                                                                                              CSW209
      * Field :20:  is TRNO of MT202 prefixed by 'RC'
     C     CSW209        IFEQ      'Y'                                                        CSW209
     C     @RTCD         ANDEQ     '*CRTCOV'                                                  CSW209
     C                   EVAL      Q = Q + 1                                                  CSW209
     C                   ELSEIF    CSW218 = 'Y'                                               CSW218
     C                   EVAL      Q = Q + 1                                                  CSW218
     C                   ELSE                                                                 CSW209
     C                   Eval      Q = 1
     C                   ENDIF                                                                CSW209
     C     Q             Occur     MULT
     C                   Eval      MTAG = ':20:'
     C                   Eval      MFLD =  SavTrno
     C                   Movel     'RC'          MFLD
 
      * Field :21: As MT103 TRNO
     C                   Eval      Q = Q + 1
     C     Q             Occur     MULT
     C                   Eval      MTAG = ':21:'
     C                   Eval      MFLD = SavTrno
 
      * Field :32A: As field 32A in MT103
     C                   If        Sav32A <> *Blanks
     C                   Eval      Q = Q + 1
     C     Q             Occur     MULT
     C                   Eval      MTAG = ':32A:'
     C                   Eval      MFLD = Sav32A
     C                   Endif
 
      * Field :57a: As field 54a in MT103
     C                   If        Sav54L1 <> *Blanks
     C                   Eval      Q = Q + 1
     C     Q             Occur     MULT
     C                   Eval      MTAG = Sav54Tag
     C                   MoveL     ':57'         MTAG
     C                   Eval      MFLD = Sav54L1
     C                   If        Sav54L2 <> *Blanks
     C                   Eval      Q = Q + 1
     C     Q             Occur     MULT
     C                   Eval      MFLD = Sav54L2
     C                   Endif
     C                   If        Sav54L3 <> *Blanks
     C                   Eval      Q = Q + 1
     C     Q             Occur     MULT
     C                   Eval      MFLD = Sav54L3
     C                   Endif
     C                   If        Sav54L4 <> *Blanks
     C                   Eval      Q = Q + 1
     C     Q             Occur     MULT
     C                   Eval      MFLD = Sav54L4
     C                   Endif
     C                   If        Sav54L5 <> *Blanks
     C                   Eval      Q = Q + 1
     C     Q             Occur     MULT
     C                   Eval      MFLD = Sav54L5
     C                   Endif
     C                   Endif
 
      * Field :58A: As MT103 Destination
     C                   Eval      Q = Q + 1
     C     Q             Occur     MULT
     C                   Eval      MTAG = ':58A:'
     C                   Eval      MFLD = Sav103Dest
      *                                                                                       CSW209
      ** Generate MT202 cover info if CSW209 = 'Y'                                            CSW209
      *                                                                                       CSW209
     C     CSW209        IFEQ      'Y'                                                        CSW209
     C     @RTCD         ANDEQ     '*CRTCOV'                                                  CSW209
      *                                                                                       CSW209
      * Field :50a: = Ordering Customer                                                       CSW209
     C                   EVAL      Q = Q + 1                                                  CSW209
     C     Q             OCCUR     MULT                                                       CSW209
     C                   MOVEL     MTAG50A       MTAG                                         CSW209
     C                   MOVEL     ADD50A1       MAPLN1                                       CSW209
     C                   MOVEL     ADD50A2       MAPLN2                                       CSW209
     C                   MOVEL     ADD50A3       MAPLN3                                       CSW209
     C                   MOVEL     ADD50A4       MAPLN4                                       CSW209
     C                   MOVEL     ADD50A5       MAPLN5                                       CSW209
     C                   EXSR      MAPLN                                                      CSW209
                                                                                              CSW209
      * Field :52a:                                                                           CSW209
     C                   IF        MT103R = 'Y'                                               CSW209
     C                   EVAL      Q = Q + 1                                                  CSW209
     C     Q             OCCUR     MULT                                                       CSW209
     C                   MOVEL     MTAG52X       MTAG                                         CSW209
     C                   MOVEL     ADD52X1       MAPLN1                                       CSW209
     C                   MOVEL     ADD52X2       MAPLN2                                       CSW209
     C                   MOVEL     ADD52X3       MAPLN3                                       CSW209
     C                   MOVEL     ADD52X4       MAPLN4                                       CSW209
     C                   MOVEL     ADD52X5       MAPLN5                                       CSW209
     C                   EXSR      MAPLN                                                      CSW209
     C                   ENDIF                                                                CSW209
                                                                                              CSW209
      * Field :56a:                                                                           CSW209
     C                   IF        MT103R = 'Y'                                               CSW209
     C                   EVAL      Q = Q + 1                                                  CSW209
     C     Q             OCCUR     MULT                                                       CSW209
     C                   MOVEL     MTAG56X       MTAG                                         CSW209
     C                   MOVEL     ADD56X1       MAPLN1                                       CSW209
     C                   MOVEL     ADD56X2       MAPLN2                                       CSW209
     C                   MOVEL     ADD56X3       MAPLN3                                       CSW209
     C                   MOVEL     ADD56X4       MAPLN4                                       CSW209
     C                   MOVEL     ADD56X5       MAPLN5                                       CSW209
     C                   EXSR      MAPLN                                                      CSW209
     C                   ENDIF                                                                CSW209
                                                                                              CSW209
      * Field :57a:                                                                           CSW209
     C                   IF        MT103R = 'Y'                                               CSW209
     C                   EVAL      Q = Q + 1                                                  CSW209
     C     Q             OCCUR     MULT                                                       CSW209
     C                   MOVEL     MTAG57X       MTAG                                         CSW209
     C                   MOVEL     ADD57X1       MAPLN1                                       CSW209
     C                   MOVEL     ADD57X2       MAPLN2                                       CSW209
     C                   MOVEL     ADD57X3       MAPLN3                                       CSW209
     C                   MOVEL     ADD57X4       MAPLN4                                       CSW209
     C                   MOVEL     ADD57X5       MAPLN5                                       CSW209
     C                   EXSR      MAPLN                                                      CSW209
     C                   ENDIF                                                                CSW209
                                                                                              CSW209
      * Field :59: = Beneficiary                                                              CSW209
     C                   IF        T59MAP = 'Y'                                               CSW209
     C                             OR Wrk59F = 'Y'                                            CSW215
     C                   EVAL      Q = Q + 1                                                  CSW209
     C     Q             OCCUR     MULT                                                       CSW209
     C                   MOVEL     MTAG59X       MTAG                                         CSW209
     C                   MOVEL     ADD59X1       MAPLN1                                       CSW209
     C                   MOVEL     ADD59X2       MAPLN2                                       CSW209
     C                   MOVEL     ADD59X3       MAPLN3                                       CSW209
     C                   MOVEL     ADD59X4       MAPLN4                                       CSW209
     C                   MOVEL     ADD59X5       MAPLN5                                       CSW209
     C                   EXSR      MAPLN                                                      CSW209
     C                   ELSE                                                                 CSW209
     C                   EVAL      Q = Q + 1                                                  CSW209
     C     Q             OCCUR     MULT                                                       CSW209
     C                   EVAL      MTAG = ':59:'                                              CSW209
     C                   EVAL      MFLD = Save59                                              CSW209
     C                   EVAL      Q = Q + 1                                                  CSW209
     C     Q             OCCUR     MULT                                                       CSW209
                                                                                              CSW209
     C                   EVAL      ZSADD1 = ADD591                                            CSW209
     C                   EVAL      ZSADD2 = *blank                                            CSW209
     C                   EVAL      ZSADD3 = *blank                                            CSW209
     C                   EVAL      ZSADD4 = *blank                                            CSW209
     C                   EXSR      SWADF                                                      CSW209
     C                   ENDIF                                                                CSW209
                                                                                              CSW209
      * Field :70:                                                                            CSW209
     C                   EVAL      Q = Q + 1                                                  CSW209
     C     Q             OCCUR     MULT                                                       CSW209
     C                   MOVEL     ':70:'        MTAG                                         CSW209
     C                   IF        T70MAP = 'Y'                                               CSW209
     C                   MOVEL     ADD70X1       MAPLN1                                       CSW209
     C                   MOVEL     ADD70X2       MAPLN2                                       CSW209
     C                   MOVEL     ADD70X3       MAPLN3                                       CSW209
     C                   MOVEL     ADD70X4       MAPLN4                                       CSW209
     C                   MOVEL     ADD70X5       MAPLN5                                       CSW209
     C                   EXSR      MAPLN                                                      CSW209
     C                   ELSE                                                                 CSW209
     C                   EVAL      MFLD = Save70                                              CSW209
                                                                                              CSW209
     C                   IF        IDENAR <> 'CMX'                                            CSW209
     C                   EVAL      Q = Q + 1                                                  CSW209
     C     Q             OCCUR     MULT                                                       CSW209
     C                   EVAL      MFLD = Save701                                             CSW209
     C                   ENDIF                                                                CSW209
     C                   ENDIF                                                                CSW209
                                                                                              CSW209
      * Field :72a:                                                                           CSW209
     C                   IF        MT103R = 'Y'                                               CSW209
     C                   EVAL      Q = Q + 1                                                  CSW209
     C     Q             OCCUR     MULT                                                       CSW209
     C                   EVAL      MTAG = ':72:'                                              CSW209
     C                   MOVEL     ADD72X1       MAPLN1                                       CSW209
     C                   MOVEL     ADD72X2       MAPLN2                                       CSW209
     C                   MOVEL     ADD72X3       MAPLN3                                       CSW209
     C                   MOVEL     ADD72X4       MAPLN4                                       CSW209
     C                   MOVEL     ADD72X5       MAPLN5                                       CSW209
     C                   EXSR      MAPLN                                                      CSW209
     C                   IF        ADD72X6 <> *BLANKS                                         CSW209
     C                   EVAL      Q = Q + 1                                                  CSW209
     C     Q             OCCUR     MULT                                                       CSW209
     C                   EVAL      MFLD = ADD72X6                                             CSW209
     C                   ENDIF                                                                CSW209
     C                   ENDIF                                                                CSW209
                                                                                              CSW209
      * Field :33B: = Currency and Amount of 32A                                              CSW209
     C                   EVAL      Q = Q + 1                                                  CSW209
     C     Q             OCCUR     MULT                                                       CSW209
     C                   EVAL      MTAG = ':33B:'                                             CSW209
     C                   EVAL      MFLD = Sav33B                                              CSW209
                                                                                              CSW209
     C                   ENDIF                                                                CSW209
 
      * = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =
      *                    F I L E   O U T P U T
 
      * Output formatted message to MGOMSGPD
     C                   EXSR      WriteMGOMSG
 
      * Write MGOREFPD record
     C                   Eval      MTPY = '202'
     C                   EXSR      WriteMGOREF
 
      * = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =
     C                   EVAL      COUNT202 = COUNT202 + 1
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRMT103R - Format  Reply MT103 to received MT101              *
      *****************************************************************
     C     SRMT103R      BEGSR
 
      * Re-initialise work fields
     C                   Exsr      SRClear
     C                   IF        CSW209 = 'Y'                                               CSW209
     C                   MOVEL     'Y'           MT103R                                       CSW209
     C                   ENDIF                                                                CSW209
 
 
      * = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =
      *                    M E S S A G E     D A T A
 
      * Field :20:
      *      'RE' + Link Reference (last 6 only) + Rund in YYMMDD + Sequence
      *      This field cannt be mapped from MT101
     C                   Eval      Q = 1
     C     Q             Occur     MULT
     C                   Eval      MTAG = ':20:'
     C                   Eval      SavTrno = 'RE' + %SUBST(Reference:4:6) +
     C                                       WMgde + %SUBST(Reference:10:2)
     C                   Eval      MFLD    = SavTrno
 
      * Field :23B:
     C***********        Eval      Q = Q + 1                                    217196
     C*****Q*****        Occur     MULT                                         217196
     C***********        Eval      MTAG = ':23B:'                               217196
     C                   Eval      KTag = ':23B:'
     C                   EXSR      SRTrans
 
     C                   If        WMapFound= 'Y'
     C                   Eval      Q = Q + 1                                    217196
     C     Q             Occur     MULT                                         217196
     C                   Eval      MTAG = ':23B:'                               217196
     C                   Eval      MFLD = WMapLine1
     C                   Else
     C                   If        *IN71 = *OFF And
     C                             TDSDEF = 'Y'
     C                   Eval      Q = Q + 1                                    217196
     C     Q             Occur     MULT                                         217196
     C                   Eval      MTAG = ':23B:'                               217196
     C                   Eval      MFLD = IDBOCD
     C                   Endif
     C                   Endif
 
      * Field :23E:
 
     C***********        Eval      Q = Q + 1                                    217196
     C*****Q*****        Occur     MULT                                         217196
     C***********        Eval      MTAG = ':23E:'                               217196
 
     C                   Eval      KTag = ':23E:'
     C                   EXSR      SRTrans
 
     C                   If        WMapFound= 'Y'
     C                   Eval      Q = Q + 1                                    217196
     C     Q             Occur     MULT                                         217196
     C                   Eval      MTAG = ':23E:'                               217196
     C                   Eval      MFLD = WMapLine1
     C                   Else
     C                   If        *IN71 = *OFF And
     C                             TDSDEF = 'Y'
     C                   Eval      Q = Q + 1                                    217196
     C     Q             Occur     MULT                                         217196
     C                   Eval      MTAG = ':23E:'                               217196
     C                   Eval      MFLD = IDINCD
     C                   Endif
     C                   Endif
 
      * Field :32A:
     C***********        Eval      Q = Q + 1                                    217196
     C*****Q*****        Occur     MULT                                         217196
     C***********        Eval      MTAG = ':32A:'                               217196
      *
     C                   Eval      KTag = ':32A:'
     C                   EXSR      SRTrans
 
     C                   If        WMapFound= 'Y'
     C                   Eval      Q = Q + 1                                    217196
     C     Q             Occur     MULT                                         217196
     C                   Eval      MTAG = ':32A:'                               217196
     C                   Eval      MFLD = WMapLine1
     C                   Movel     MFLD          Sav32A
     C                   Else
 
     C                   If        *IN71 = *OFF And
     C                             TDSDEF = 'Y'
     C                   Eval      Q = Q + 1                                    217196
     C     Q             Occur     MULT                                         217196
     C                   Eval      MTAG = ':32A:'                               217196
     C                   Eval      ZMDAY = IDVALD
     C                   CALL      'ZM0060'                             15
     C                   PARM                    ZMDAY             5 0
     C                   PARM                    ZMDATE            6
      *
     C                   Eval      SavDate = ZMDATE
      *
      ** If the program ends in error.
      *
     C     *IN15         IFEQ      '1'
     C     *LOCK         IN        LDA
     C                   Z-ADD     7             DBASE                            * * * * * * *
     C                   MOVEL     '       '     DBKEY                            * DBERR 007 *
     C                   MOVEL     'ZM0060'      DBFILE                           * * * * * * *
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   END
     C
     C                   MOVE      IDCCCY        ZCCY
     C                   Z-add     IDSWFA        ZAMNT
      *
     C* Subtract charges if 'BEN'
     C                   If        IDCHGR = 'BEN'   And
     C                             IDCACT = *blank
     C                   Eval      ZAMNT = ZAMNT - IDCAMT
     C                   Endif
      *
     C                   CALL      'ZM0040'                             15
     C                   PARM                    ZAMNT            13 0
     C                   PARM                    ZCCY              3
     C                   PARM                    ZSAMNT
     C                   PARM                    ZSCCY             3
     C                   PARM                    ZERR              1
     C                   PARM                    ZSWDPC                                       222373
      *
     C                   Eval      SavAmount = ZSAMNT
      *
      ** If the program ends in error.
      *
     C     *IN15         IFEQ      '1'
     C     ZERR          OREQ      '1'
     C     *LOCK         IN        LDA
     C                   Z-ADD     8             DBASE                            * * * * * * *
     C                   MOVEL     '       '     DBKEY                            * DBERR 008 *
     C                   MOVEL     'ZM0040'      DBFILE                           * * * * * * *
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   END
     C
     C                   Eval      Sav32A = SavDate + ZSCCY + ZSAMNT
     C                   Eval      MFLD   = Sav32A
     C                   Endif
     C                   Endif
     C
      * Field :33B:
     C***********        Eval      Q = Q + 1                                    217196
     C*****Q*****        Occur     MULT                                         217196
     C***********        Eval      MTAG = ':33B:'                               217196
      *
     C                   Eval      KTag = ':33B:'
     C                   EXSR      SRTrans
 
     C                   If        WMapFound= 'Y'
     C                   Eval      Q = Q + 1                                    217196
     C     Q             Occur     MULT                                         217196
     C                   Eval      MTAG = ':33B:'                               217196
     C                   Eval      MFLD = WMapLine1
                                                                                              CSW209
     C                   IF        CSW209 = 'Y'                                               CSW209
      * Save :33B: message data to be used in MT202 COV                                       CSW209
     C                   MOVEL     WMapLine1     Sav33B                                       CSW209
     C                   ENDIF                                                                CSW209
                                                                                              CSW209
     C                   Else
 
     C                   If        *IN71 = *OFF And
     C                             TDSDEF = 'Y'
 
     C                   Eval      Q = Q + 1                                    217196
     C     Q             Occur     MULT                                         217196
     C                   Eval      MTAG = ':33B:'                               217196
 
     C                   Z-add     IDSWFA        ZAMNT
 
     C                   CALL      'ZM0040'                             15
     C                   PARM                    ZAMNT            13 0
     C                   PARM                    ZCCY              3
     C                   PARM                    ZSAMNT
     C                   PARM                    ZSCCY             3
     C                   PARM                    ZERR              1
     C                   PARM                    ZSWDPC                                       222373
      *
      ** If the program ends in error.
      *
     C     *IN15         IFEQ      '1'
     C     ZERR          OREQ      '1'
     C     *LOCK         IN        LDA
     C                   Z-ADD     9             DBASE                            * * * * * * *
     C                   MOVEL     '       '     DBKEY                            * DBERR 009 *
     C                   MOVEL     'ZM0040'      DBFILE                           * * * * * * *
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   END
     C                   Eval      MFLD = ZSCCY + ZSAMNT
                                                                                              CSW209
     C                   IF        CSW209 = 'Y'                                               CSW209
      * Save :33B: message data to be used in MT202 COV                                       CSW209
     C                   MOVEL     MFLD          Sav33B                                       CSW209
     C                   ENDIF                                                                CSW209
                                                                                              CSW209
     C                   Endif
     C                   Endif
     C
      * Field :36:
     C                   Eval      KTag = ':36:'
     C                   EXSR      SRTrans
     C                   If        WMapFound= 'Y'
     C                   Eval      Q = Q + 1
     C     Q             Occur     MULT
     C                   Eval      MTag = ':36:'
     C                   Eval      MFLD = WMapLine1
     C                   Else
     C                   If        *IN71 = *OFF And
     C                             TDSDEF = 'Y'
     C* no system defined values  can be retrieved.  Transaction and Instructed Currencies
     C* are always the same so this field will always get a rate of 1, in which case it does
     C* not need to be output.
     C                   Endif
     C                   Endif
 
      * Field :50a:
      *    First, Field :50A:
     C                   Eval      KTag = ':50A:'
     C                   EXSR      SRTrans
     C                   If        WMapFound= 'Y'
     C                   Eval      Q = Q + 1                                    217196
     C     Q             Occur     MULT
     C                   Eval      MTag = ':50A:'
     C                   Eval      MFLD = WMapLine1
     C                   If        WMapLine2 <> *Blank
     C                   Eval      Q = Q + 1
     C     Q             Occur     MULT
     C                   Eval      MFLD = WMapLine2
     C                                                                                        CSW209
     C                   IF        CSW209 = 'Y'                                               CSW209
      * Save :50A: message data to be used in MT202 COV                                       CSW209
     C                   MOVEL     ':50A:'       MTAG50A                                      CSW209
     C                   MOVEL     WMapLine1     ADD50A1                                      CSW209
     C                   MOVEL     WMapLine2     ADD50A2                                      CSW209
     C                   ENDIF                                                                CSW209
     C                                                                                        CSW209
     C                   Endif
     C                   Else
     C                   If        *IN71 = *OFF And
     C                             TDSDEF = 'Y'
     C                   Goto      Proc50
     C                   Endif
     C                   Endif
 
      *    Then try field :50F:                                                               CSW207
     C                   IF        CSW207 = 'Y'                                               CSW207
     C                   EVAL      KTag = ':50F:'                                             CSW207
     C                   EXSR      SRTrans                                                    CSW207
     C                   IF        WMapFound= 'Y'                                             CSW207
     C                   EVAL      Q = Q + 1                                                  CSW207
     C     Q             OCCUR     MULT                                                       CSW207
     C                   EVAL      MTag = ':50F:'                                             CSW207
     C                   EVAL      MFLD = WMapLine1                                           CSW207
     C                   IF        WMapLine2 <> *Blank                                        CSW207
     C                   EVAL      Q = Q + 1                                                  CSW207
     C     Q             OCCUR     MULT                                                       CSW207
     C                   EVAL      MFLD = WMapLine2                                           CSW207
     C                   ENDIF                                                                CSW207
     C                   IF        WMapLine3 <> *Blank                                        CSW207
     C                   EVAL      Q = Q + 1                                                  CSW207
     C     Q             OCCUR     MULT                                                       CSW207
     C                   EVAL      MFLD = WMapLine3                                           CSW207
     C                   ENDIF                                                                CSW207
     C                   IF        WMapLine4 <> *Blank                                        CSW207
     C                   EVAL      Q = Q + 1                                                  CSW207
     C     Q             OCCUR     MULT                                                       CSW207
     C                   EVAL      MFLD = WMapLine4                                           CSW207
     C                   ENDIF                                                                CSW207
     C                   IF        WMapLine5 <> *Blank                                        CSW207
     C                   EVAL      Q = Q + 1                                                  CSW207
     C     Q             OCCUR     MULT                                                       CSW207
     C                   EVAL      MFLD = WMapLine5                                           CSW207
     C                   ENDIF                                                                CSW207
                                                                                              CSW209
     C                   IF        CSW209 = 'Y'                                               CSW209
      * Save :50F: message data to be used in MT202 COV                                       CSW209
     C                   MOVEL     ':50F:'       MTAG50A                                      CSW209
     C                   MOVEL     WMapLine1     ADD50A1                                      CSW209
     C                   MOVEL     WMapLine2     ADD50A2                                      CSW209
     C                   MOVEL     WMapLine3     ADD50A3                                      CSW209
     C                   MOVEL     WMapLine4     ADD50A4                                      CSW209
     C                   MOVEL     WMapLine5     ADD50A5                                      CSW209
     C                   ENDIF                                                                CSW209
                                                                                              CSW209
     C                   ELSE                                                                 CSW207
     C                   IF        *IN71 = *OFF And                                           CSW207
     C                             TDSDEF = 'Y'                                               CSW207
     C                   GOTO      Proc50                                                     CSW207
     C                   ENDIF                                                                CSW207
     C                   ENDIF                                                                CSW207
     C                   ENDIF                                                                CSW207
                                                                                              CSW207
      *    Then try field :50K:
     C                   Eval      KTag = ':50K:'
     C                   EXSR      SRTrans
     C                   If        WMapFound= 'Y'
     C                   Eval      Q = Q + 1
     C     Q             Occur     MULT
     C                   Eval      MTag = ':50K:'
     C                   Eval      MFLD = WMapLine1
     C                   If        WMapLine2 <> *Blank
     C                   Eval      Q = Q + 1
     C     Q             Occur     MULT
     C                   Eval      MFLD = WMapLine2
     C                   Endif
     C                   If        WMapLine3 <> *Blank
     C                   Eval      Q = Q + 1
     C     Q             Occur     MULT
     C                   Eval      MFLD = WMapLine3
     C                   Endif
     C                   If        WMapLine4 <> *Blank
     C                   Eval      Q = Q + 1
     C     Q             Occur     MULT
     C                   Eval      MFLD = WMapLine4
     C                   Endif
     C                   If        WMapLine5 <> *Blank
     C                   Eval      Q = Q + 1
     C     Q             Occur     MULT
     C                   Eval      MFLD = WMapLine5
     C                   Endif
                                                                                              CSW209
     C                   IF        CSW209 = 'Y'                                               CSW209
      * Save :50K: message data to be used in MT202 COV                                       CSW209
     C                   MOVEL     ':50K:'       MTAG50A                                      CSW209
     C                   MOVEL     WMapLine1     ADD50A1                                      CSW209
     C                   MOVEL     WMapLine2     ADD50A2                                      CSW209
     C                   MOVEL     WMapLine3     ADD50A3                                      CSW209
     C                   MOVEL     WMapLine4     ADD50A4                                      CSW209
     C                   MOVEL     WMapLine5     ADD50A4                                      CSW209
     C                   ENDIF                                                                CSW209
                                                                                              CSW209
     C                   Endif
 
     C     Proc50        Tag
 
     C                   If        *IN71 = *OFF And
     C                             TDSDEF = 'Y'
      ** Check 50F                                                                         BUG15202A
     C                   If        CSW207 = 'Y'                                            BUG15202A
     C                   Eval      PMsgType = '103'                                        BUG15202A
     C                   Eval      PInp1 = *Blanks                                         BUG15202A
     C                   Move      IDCCUS        PInp1                                     BUG15202A
     C                   Eval      PInp2 = *Blanks                                         BUG15202A
     C                   Eval      PInp3 = *Blanks                                         BUG15202A
     C                   Eval      PInp4 = *Blanks                                         BUG15202A
     C                   Eval      PInp5 = *Blanks                                         BUG15202A
     C                   Eval      PAcctType = 'C'                                         BUG15202A
     C                   Eval      PAccount  = *Blanks                                     BUG15202A
     C                   Move      IDCCUS        PCustNo                                   BUG15202A
     C                   Eval      PNonAcctHldr = *Blanks                                  BUG15202A
     C                   Eval      PNetwork  = NWRK                                        BUG15202A
     C                   Eval      PMsgField = ':50F:'                                     BUG15202A
     C                   Eval      PBrchCode = CDBRCA                                      BUG15202A
     C                   Eval      PCurrCode = IDCCCY                                      BUG15202A
     C                   Eval      PNostro   = *Blanks                                     BUG15202A
     C                   Eval      PModi     = 'RE'                                        BUG15202A
                                                                                           BUG15202A
     C                   CALL      'FT001000'                                              BUG15202A
                                                                                           BUG15202A
      ** Input Parameters                                                                  BUG15202A
      ** Return Code                                                                       BUG15202A
     C                   PARM      *BLANKS       PRtnCode                                  BUG15202A
      ** Message ID                                                                        BUG15202A
     C                   PARM      *BLANKS       PMsgID                                    BUG15202A
      ** Error Type                                                                        BUG15202A
     C                   PARM      *BLANK        PErTyp                                    BUG15202A
      ** Validation Type                                                                   BUG15202A
     C                   PARM      'FRMT'        PVTyp                                     BUG15202A
      ** 5X35 input line                                                                   BUG15202A
     C                   PARM                    PInp1                                     BUG15202A
     C                   PARM                    PInp2                                     BUG15202A
     C                   PARM                    PInp3                                     BUG15202A
     C                   PARM                    PInp4                                     BUG15202A
     C                   PARM                    PInp5                                     BUG15202A
      ** Account Type                                                                      BUG15202A
     C                   PARM                    PAcctType                                 BUG15202A
      ** Account                                                                           BUG15202A
     C                   PARM                    PAccount                                  BUG15202A
     C                   PARM                    PCustNo                                   BUG15202A
      ** Non Account Holder                                                                BUG15202A
     C                   PARM                    PNonAcctHldr                              BUG15202A
      ** Network                                                                           BUG15202A
     C                   PARM                    PNetwork                                  BUG15202A
      ** Message Type                                                                      BUG15202A
     C                   PARM                    PMsgType                                  BUG15202A
      ** Message Tag                                                                       BUG15202A
     C                   PARM                    PMsgField                                 BUG15202A
      ** Country                                                                           BUG15202A
     C                   PARM                    PCountry                                  BUG15202A
      ** Branch Code                                                                       BUG15202A
     C                   PARM                    PBrchCode                                 BUG15202A
      ** Currency Code                                                                     BUG15202A
     C                   PARM                    PCurrCode                                 BUG15202A
      ** Nostro Flag                                                                       BUG15202A
     C                   PARM                    PNostro                                   BUG15202A
      ** Module Indicator                                                                  BUG15202A
     C                   PARM                    PModI                                     BUG15202A
                                                                                           BUG15202A
      ** Output Parameters                                                                 BUG15202A
      ** Message Line 1                                                                    BUG15202A
     C                   PARM                    PMsgLine01                                BUG15202A
      ** Message Line 2                                                                    BUG15202A
     C                   PARM                    PMsgLine02                                BUG15202A
      ** Message Line 3                                                                    BUG15202A
     C                   PARM                    PMsgLine03                                BUG15202A
      ** Message Line 4                                                                    BUG15202A
     C                   PARM                    PMsgLine04                                BUG15202A
      ** Message Line 5                                                                    BUG15202A
     C                   PARM                    PMsgLine05                                BUG15202A
                                                                                           BUG15202A
     C                   EndIf                                                             BUG15202A
                                                                                           BUG15202A
     C                   If        PRtnCode = *BLANKS                                      BUG15202A
     C                             And CSW207 = 'Y'                                        BUG15202A
     C                   Eval      Q = Q + 1                                               BUG15202A
     C     Q             Occur     MULT                                                    BUG15202A
     C                   Eval      MTag = ':50F:'                                          BUG15202A
     C                   Eval      MFLD = PMsgLine01                                       BUG15202A
     C                   Eval      Q = Q + 1                                               BUG15202A
     C     Q             Occur     MULT                                                    BUG15202A
     C                   Eval      MFLD = PMsgLine02                                       BUG15202A
     C                   Eval      Q = Q + 1                                               BUG15202A
     C     Q             Occur     MULT                                                    BUG15202A
     C                   Eval      MFLD = PMsgLine03                                       BUG15202A
     C                   Eval      Q = Q + 1                                               BUG15202A
     C     Q             Occur     MULT                                                    BUG15202A
     C                   Eval      MFLD = PMsgLine04                                       BUG15202A
     C                   Eval      Q = Q + 1                                               BUG15202A
     C     Q             Occur     MULT                                                    BUG15202A
     C                   Eval      MFLD = PMsgLine05                                       BUG15202A
                                                                                           BUG15202A
     C                   IF        CSW209 = 'Y'                                               CSW209
      * Save :50F: message data to be used in MT202 COV                                       CSW209
     C                   MOVEL     ':50F:'       MTAG50A                                      CSW209
     C                   MOVEL     PMsgLine01    ADD50A1                                      CSW209
     C                   MOVEL     PMsgLine02    ADD50A2                                      CSW209
     C                   MOVEL     PMsgLine03    ADD50A3                                      CSW209
     C                   MOVEL     PMsgLine04    ADD50A4                                      CSW209
     C                   MOVEL     PMsgLine05    ADD50A5                                      CSW209
     C                   ENDIF                                                                CSW209
                                                                                              CSW209
     C                   Else                                                              BUG15202A
                                                                                           BUG15202A
     C***********                  And %SUBST(Ktag:4:1) = 'A'            212836 217196
     C                   If        %SUBST(Ktag:4:1) = 'A'                       217196
     C*                                                                         217196
     C* Ordering Customer is the Top account defined on the Zero Balancing/Sweeping Details
     C                   MOVEL     IDCCUS        ZDEST
     C                   CALL      'ZM0050'                             15
     C                   PARM                    ZDEST            12
     C                   PARM                    ZSADD1           35
     C                   PARM                    ZSADD2           35
     C                   PARM                    ZSADD3           35
     C                   PARM                    ZSADD4           35
     C                   PARM                    ZSTAG             1
     C                   PARM                    ZSTYPE            1
     C                   PARM                    ZERR
     C                   PARM      *blank        ZDBEI             1
      ** If the program ends in error.
      *
     C     *IN15         IFEQ      '1'
     C     ZERR          OREQ      '1'
     C     *LOCK         IN        LDA
     C                   Z-ADD     10            DBASE                            * * * * * * *
     C                   MOVEL     '       '     DBKEY                            * DBERR 010 *
     C                   MOVEL     'ZM0050'      DBFILE                           * * * * * * *
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   END
 
     C                   Eval      Q = Q + 1
     C     Q             Occur     MULT
 
     C     ZSTAG         IFEQ      'A'
 
     C                   Eval      MTAG = ':50A:'
 
     C                   IF        CSW209 = 'Y'                                               CSW209
      * Save :50A: message data to be used in MT202 COV                                       CSW209
     C                   MOVEL     ':50A:'       MTAG50A                                      CSW209
     C                   ENDIF                                                                CSW209
     C                                                                                        CSW209
      * Check further if SWIFT Id is not an agent Id
 
     C                   If        CSW024 = 'Y'
     C                   Movel     IDCCUS        PKEY1
     C                   CALL      'AOCUSTR0'
     C                   PARM      *BLANKS       PRTCD             7
     C                   PARM      '*KEY   '     POPTN             7
     C                   PARM                    PKEY1            10
     C                   PARM      *BLANK        PKYST             7
     C     SDCUST        PARM      SDCUST        DSSDY
      ** Error on call
     C     @RTCD         IFNE      *BLANK
     C     *LOCK         IN        LDA
     C                   Z-ADD     28            DBASE                            * * * * * * *
     C                   MOVEL     A7CUST        DBKEY                            * DBERR 028 *
     C                   MOVEL     'SDCUSTPD'    DBFILE                           * * * * * * *
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   If        BBCORP = 'Y'
     C                   If        BBCBEI <> *blank
     C                   Eval      MTAG = ':50A:'
     C                   Eval      ZSADD1 = BBCBEI
                                                                                              CSW209
     C                   IF        CSW209 = 'Y'                                               CSW209
      * Save :50A: message data to be used in MT202 COV                                       CSW209
     C                   MOVEL     ':50A:'       MTAG50A                                      CSW209
     C                   MOVEL     BBCBEI        ADD50A1                                      CSW209
     C                   ENDIF                                                                CSW209
     C                                                                                        CSW209
     C                   Else
     C                   Eval      MTAG = ':50K:'
     C                   Eval      ZSADD1 = BBCNA1
     C                   Eval      ZSADD2 = BBCNA2
     C                   Eval      ZSADD3 = BBCNA3
     C                   Eval      ZSADD4 = BBCNA4
                                                                                              CSW209
     C                   IF        CSW209 = 'Y'                                               CSW209
      * Save :50K: message data to be used in MT202 COV                                       CSW209
     C                   MOVEL     ':50K:'       MTAG50A                                      CSW209
     C                   MOVEL     BBCNA1        ADD50A1                                      CSW209
     C                   MOVEL     BBCNA2        ADD50A2                                      CSW209
     C                   MOVEL     BBCNA3        ADD50A3                                      CSW209
     C                   MOVEL     BBCNA4        ADD50A4                                      CSW209
     C                   ENDIF                                                                CSW209
     C                                                                                        CSW209
     C                   Endif
     C                   Endif
 
     C                   Endif
 
     C                   ELSE                                                   If ZSTAG = 'A'
 
     C                   Eval      MTAG = ':50K:'
 
     C                   IF        CSW209 = 'Y'                                               CSW209
      * Save :50K: message data to be used in MT202 COV                                       CSW209
     C                   MOVEL     ':50K:'       MTAG50A                                      CSW209
     C                   ENDIF                                                                CSW209
     C                                                                                        CSW209
     C                   Endif
 
     C                   IF        Wacnum <> *BLANKS AND MTAG = ':50K'                      AR960455
     C                   EXSR      FormAccnt                                                AR960455
     C                   ELSE                                                               AR960455
     C                   Exsr      SWADF
     C                   ENDIF                                                              AR960455
 
     C                   Else                                                   212836
     C* Requested tag option is 'K'                                             212836
     C                   MOVEL     IDCCUS        ZDEST                          212836
     C                   CALL      'ZM0055'                             15      212836
     C                   PARM                    ZDEST            12            212836
     C                   PARM                    ZSADD1           35            212836
     C                   PARM                    ZSADD2           35            212836
     C                   PARM                    ZSADD3           35            212836
     C                   PARM                    ZSADD4           35            212836
     C                   PARM                    ZERR                           212836
      ** If the program ends in error.                                          212836
      *                                                                         212836
     C     *IN15         IFEQ      '1'                                          212836
     C     ZERR          OREQ      '1'                                          212836
     C     *LOCK         IN        LDA                                          212836
     C                   Z-ADD     29            DBASE                          212836
     C                   MOVEL     '       '     DBKEY                          212836
     C                   MOVEL     'ZM0055'      DBFILE                         212836
     C                   OUT       LDA                                          212836
     C                   EXSR      *PSSR                                        212836
     C                   END                                                    212836
                                                                                212836
     C                   Eval      Q = Q + 1                                    217196
     C     Q             Occur     MULT                                         217196
     C                   Eval      MTAG = ':50K:'                               212836
                                                                                              CSW209
     C**********         IF        CSW209 = 'Y'                                      CSW209 AR960455
      **Save*:50K:*message*data*to*be*used*in*MT202*COV****************              CSW209 AR960455
     C**********         MOVEL     ':50K:'       MTAG50A                             CSW209 AR960455
     C**********         MOVEL     ZSADD1        ADD50A1                             CSW209 AR960455
     C**********         MOVEL     ZSADD2        ADD50A2                             CSW209 AR960455
     C**********         MOVEL     ZSADD3        ADD50A3                             CSW209 AR960455
     C**********         MOVEL     ZSADD4        ADD50A4                             CSW209 AR960455
     C**********         ENDIF                                                       CSW209 AR960455
     C                                                                                        CSW209
     C                   IF        Wacnum <> *BLANKS                                        AR960455
     C                   MOVE      *BLANK        WRK34            34                        AR960455
     C                   MOVEL     WAcnum        WRK34                                      AR960455
     C                   EXSR      FormAccnt                                                AR960455
     C                   ELSE                                                               AR960455
     C                   Exsr      SWADF                                        212836
     C                   ENDIF                                                              AR960455
     C                   IF        CSW209 = 'Y'                                             AR960455
      * Save :50K: message data to be used in MT202 COV                                     AR960455
     C                   IF        WRK34  <> *BLANKS                                        AR960455
     C                   MOVE      *BLANK        Wacnum2                                    AR960455
     C                   MOVEL     '/'           Wacnum2                                    AR960455
     C                   MOVE      WRK34         Wacnum2                                    AR960455
     C                   MOVEL     ':50K:'       MTAG50A                                    AR960455
     C                   MOVEL     Wacnum2       ADD50A1                                    AR960455
     C                   MOVEL     ZSADD1        ADD50A2                                    AR960455
     C                   MOVEL     ZSADD2        ADD50A3                                    AR960455
     C                   MOVEL     ZSADD3        ADD50A4                                    AR960455
     C                   MOVEL     ZSADD4        ADD50A5                                    AR960455
     C                   ELSE                                                               AR960455
     C                   MOVEL     ':50K:'       MTAG50A                                    AR960455
     C                   MOVEL     ZSADD1        ADD50A1                                    AR960455
     C                   MOVEL     ZSADD2        ADD50A2                                    AR960455
     C                   MOVEL     ZSADD3        ADD50A3                                    AR960455
     C                   MOVEL     ZSADD4        ADD50A4                                    AR960455
     C                   ENDIF                                                              AR960455
     C                   ENDIF                                                              AR960455
     C                   Endif                                                  217196
                                                                                           BUG15202A
     C                   EndIf                                                             BUG15202A
      **********                                                                    CSW207 BUG15202A
     C**********         IF        %SUBST(KTag:4:1) = 'F'                           CSW207 BUG15202A
      **********                                                                    CSW207 BUG15202A
     C**********         EVAL      PMsgType = '103'                                 CSW207 BUG15202A
      **********                                                                    CSW207 BUG15202A
     C**********         CALL      'FT001000'                                       CSW207 BUG15202A
      **********                                                                    CSW207 BUG15202A
      ***Input*Parameters                                                           CSW207 BUG15202A
      ***Return*Code                                                                CSW207 BUG15202A
     C**********         PARM      *BLANKS       PRtnCode                           CSW207 BUG15202A
      ***Message*ID                                                                 CSW207 BUG15202A
     C**********         PARM      *BLANKS       PMsgID                             CSW207 BUG15202A
      ***Error*Type                                                                 CSW207 BUG15202A
     C**********         PARM      *BLANK        PErTyp                             CSW207 BUG15202A
      ***Validation*Type                                                            CSW207 BUG15202A
     C**********         PARM      'FRMT'        PVTyp                              CSW207 BUG15202A
      ***5X35*input*line                                                            CSW207 BUG15202A
     C**********         PARM                    PInp1                              CSW207 BUG15202A
     C**********         PARM                    PInp2                              CSW207 BUG15202A
     C**********         PARM                    PInp3                              CSW207 BUG15202A
     C**********         PARM                    PInp4                              CSW207 BUG15202A
     C**********         PARM                    PInp5                              CSW207 BUG15202A
      ***Account*Type                                                               CSW207 BUG15202A
     C**********         PARM                    PAcctType                          CSW207 BUG15202A
      ***Account                                                                    CSW207 BUG15202A
     C**********         PARM                    PAccount                           CSW207 BUG15202A
      ***Customer*Number                                                            CSW207 BUG15202A
     C**********         PARM      IDPCCY        PCustNo                            CSW207 BUG15202A
      ***Non*Account*Holder                                                         CSW207 BUG15202A
     C**********         PARM                    PNonAcctHldr                       CSW207 BUG15202A
      ***Networ*                                                                    CSW207 BUG15202A
     C**********         PARM                    PNetwork                           CSW207 BUG15202A
      ***Message*Type                                                               CSW207 BUG15202A
     C**********         PARM                    PMsgType                           CSW207 BUG15202A
      ***Message*Tag                                                                CSW207 BUG15202A
     C**********         PARM                    PMsgField                          CSW207 BUG15202A
      ***Country                                                                    CSW207 BUG15202A
     C**********         PARM                    PCountry                           CSW207 BUG15202A
      ***Branch*Code                                                                CSW207 BUG15202A
     C**********         PARM                    PBrchCode                          CSW207 BUG15202A
      ***Currency Code                                                              CSW207 BUG15202A
     C**********         PARM                    PCurrCode                          CSW207 BUG15202A
      ***Nostro*Flag                                                                CSW207 BUG15202A
     C**********         PARM                    PNostro                            CSW207 BUG15202A
      ***Module*Indicator                                                           CSW207 BUG15202A
     C**********         PARM                    PModI                              CSW207 BUG15202A
      **********                                                                    CSW207 BUG15202A
      ***Output*Parameters                                                          CSW207 BUG15202A
      ***Message*Line*1                                                             CSW207 BUG15202A
     C**********         PARM                    PMsgLine01                         CSW207 BUG15202A
      ***Message*Line*2                                                             CSW207 BUG15202A
     C**********         PARM                    PMsgLine02                         CSW207 BUG15202A
      ***Message*Line*3                                                             CSW207 BUG15202A
     C**********         PARM                    PMsgLine03                         CSW207 BUG15202A
      ***Message*Line*4                                                             CSW207 BUG15202A
     C**********         PARM                    PMsgLine04                         CSW207 BUG15202A
      ***Message*Line*5                                                             CSW207 BUG15202A
     C**********         PARM                    PMsgLine05                         CSW207 BUG15202A
      **********                                                                    CSW207 BUG15202A
     C**********         IF        PRtnCode <> *BLANKS                               CSW207 BUG15202
     C******LOCK         IN        LDA                                               CSW207 BUG15202
     C**********         Z-ADD     30            DBASE                               CSW207 BUG15202
     C**********         MOVEL     '*CALL'       DBKEY                               CSW207 BUG15202
     C**********         MOVEL     'FT001000'    DBFILE                              CSW207 BUG15202
     C**********         OUT       LDA                                               CSW207 BUG15202
     C**********         EXSR      *PSSR                                             CSW207 BUG15202
     C**********         ENDIF                                                       CSW207 BUG15202
      **********                                                                    CSW207 BUG15202A
     C**********         Eval      Q = Q + 1                                        CSW207 BUG15202A
     C*****Q****         Occur     MULT                                             CSW207 BUG15202A
     C**********         Eval      MTag = ':50F:'                                   CSW207 BUG15202A
     C**********         Eval      MFLD = PMsgLine01                                CSW207 BUG15202A
     C**********         Eval      Q = Q + 1                                        CSW207 BUG15202A
     C*****Q****         Occur     MULT                                             CSW207 BUG15202A
     C**********         Eval      MTag = ':50F:'                                   CSW207 BUG15202A
     C**********         Eval      MFLD = PMsgLine02                                CSW207 BUG15202A
     C**********         Eval      Q = Q + 1                                        CSW207 BUG15202A
     C*****Q****         Occur     MULT                                             CSW207 BUG15202A
     C**********         Eval      MTag = ':50F:'                                   CSW207 BUG15202A
     C**********         Eval      MFLD = PMsgLine03                                CSW207 BUG15202A
     C**********         Eval      Q = Q + 1                                        CSW207 BUG15202A
     C*****Q****         Occur     MULT                                             CSW207 BUG15202A
     C**********         Eval      MTag = ':50F:'                                   CSW207 BUG15202A
     C**********         Eval      MFLD = PMsgLine04                                CSW207 BUG15202A
     C**********         Eval      Q = Q + 1                                        CSW207 BUG15202A
     C*****Q****         Occur     MULT                                             CSW207 BUG15202A
     C**********         Eval      MTag = ':50F:'                                   CSW207 BUG15202A
     C**********         Eval      MFLD = PMsgLine05                                CSW207 BUG15202A
     C**********         ENDIF                                                      CSW207 BUG15202A
      **********                                                                    CSW207 BUG15202A
     C                   Endif
 
      * Field :51A:
      *    First, Field :51A:
     C                   Eval      KTag = ':51A:'
     C                   EXSR      SRTrans
     C                   If        WMapFound= 'Y'
     C                   Eval      Q = Q + 1                                    217196
     C     Q             Occur     MULT
     C                   Eval      MTag = ':51A:'
     C                   Eval      MFLD = WMapLine1
     C                   If        WMapLine2 <> *Blank
     C                   Eval      Q = Q + 1
     C     Q             Occur     MULT
     C                   Eval      MFLD = WMapLine2
     C                   Endif
     C                   Else
     C                   If        *IN71 = *OFF And
     C                             TDSDEF = 'Y'
     C* no system defined values  can be retrieved for this field.
     C                   Endif
     C                   Endif
 
      * Field :52a:
      *    First, Field :52A:
     C                   Eval      KTag = ':52A:'
     C                   EXSR      SRTrans
     C                   If        WMapFound= 'Y'
     C                   Eval      Q = Q + 1
     C     Q             Occur     MULT
     C                   Eval      MTag = ':52A:'
     C                   Eval      MFLD = WMapLine1
     C                   If        WMapLine2 <> *Blank
     C                   Eval      Q = Q + 1
     C     Q             Occur     MULT
     C                   Eval      MFLD = WMapLine2
     C                   Endif
     C                                                                                        CSW209
     C                   IF        CSW209 = 'Y'                                               CSW209
      * Save :52A: message data to be used in MT202 COV                                       CSW209
     C                   MOVEL     ':52A:'       MTAG52X                                      CSW209
     C                   MOVEL     WMapLine1     ADD52X1                                      CSW209
     C                   MOVEL     WMapLine2     ADD52X2                                      CSW209
     C                   ENDIF                                                                CSW209
     C                   Else
     C                   If        *IN71 = *OFF And
     C                             TDSDEF = 'Y'
     C                   Goto      Proc52
     C                   Endif
     C                   Endif
     C
      *    Then try field :52D:
     C                   Eval      KTag = ':52D:'
     C                   EXSR      SRTrans
     C                   If        WMapFound= 'Y'
     C                   Eval      Q = Q + 1
     C     Q             Occur     MULT
     C                   Eval      MTag = ':52D:'
     C                   Eval      MFLD = WMapLine1
     C                   If        WMapLine2 <> *Blank
     C                   Eval      Q = Q + 1
     C     Q             Occur     MULT
     C                   Eval      MFLD = WMapLine2
     C                   Endif
     C                   If        WMapLine3 <> *Blank
     C                   Eval      Q = Q + 1
     C     Q             Occur     MULT
     C                   Eval      MFLD = WMapLine3
     C                   Endif
     C                   If        WMapLine4 <> *Blank
     C                   Eval      Q = Q + 1
     C     Q             Occur     MULT
     C                   Eval      MFLD = WMapLine4
     C                   Endif
     C                   If        WMapLine5 <> *Blank
     C                   Eval      Q = Q + 1
     C     Q             Occur     MULT
     C                   Eval      MFLD = WMapLine5
     C                   Endif
     C                                                                                        CSW209
     C                   IF        CSW209 = 'Y'                                               CSW209
      * Save :52D: message data to be used in MT202 COV                                       CSW209
     C                   MOVEL     ':52D:'       MTAG52X                                      CSW209
     C                   MOVEL     WMapLine1     ADD52X1                                      CSW209
     C                   MOVEL     WMapLine2     ADD52X2                                      CSW209
     C                   MOVEL     WMapLine3     ADD52X3                                      CSW209
     C                   MOVEL     WMapLine4     ADD52X4                                      CSW209
     C                   MOVEL     WMapLine5     ADD52X5                                      CSW209
     C                   ENDIF                                                                CSW209
     C                                                                                        CSW209
     C                   Endif
 
     C     Proc52        Tag
 
     C                   If        *IN71 = *OFF And
     C                             TDSDEF = 'Y'
     C* No system defined values can be retrieved for Ordering Institution
     C                   Endif
 
 
      * Field :53a:
      *    First, Field :53A:
     C                   Eval      KTag = ':53A:'
     C                   EXSR      SRTrans
     C                   If        WMapFound= 'Y'
     C                   Eval      Q = Q + 1
     C     Q             Occur     MULT
     C                   Eval      MTag = ':53A:'
     C                   Eval      MFLD = WMapLine1
     C                   If        WMapLine2 <> *Blank
     C                   Eval      Q = Q + 1
     C     Q             Occur     MULT
     C                   Eval      MFLD = WMapLine2
     C                   Endif
     C                   Else
     C                   If        *IN71 = *OFF And
     C                             TDSDEF = 'Y'
     C                   Goto      Proc53
     C                   Endif
     C                   Endif
     C
      *    Then try field :53B:
     C                   Eval      KTag = ':53B:'
     C                   EXSR      SRTrans
     C                   If        WMapFound= 'Y'
     C                   Eval      Q = Q + 1
     C     Q             Occur     MULT
     C                   Eval      MTag = ':53B:'
     C                   Eval      MFLD = WMapLine1
     C                   If        WMapLine2 <> *Blank
     C                   Eval      Q = Q + 1
     C     Q             Occur     MULT
     C                   Eval      MFLD = WMapLine2
     C                   Endif
     C                   Else
     C                   If        *IN71 = *OFF And
     C                             TDSDEF = 'Y'
     C                   Goto      Proc53
     C                   Endif
     C                   Endif
     C
      *    Then try field :53D:
     C                   Eval      KTag = ':53D:'
     C                   EXSR      SRTrans
     C                   If        WMapFound= 'Y'
     C                   Eval      Q = Q + 1
     C     Q             Occur     MULT
     C                   Eval      MTag = ':53D:'
     C                   Eval      MFLD = WMapLine1
     C                   If        WMapLine2 <> *Blank
     C                   Eval      Q = Q + 1
     C     Q             Occur     MULT
     C                   Eval      MFLD = WMapLine2
     C                   Endif
     C                   If        WMapLine3 <> *Blank
     C                   Eval      Q = Q + 1
     C     Q             Occur     MULT
     C                   Eval      MFLD = WMapLine3
     C                   Endif
     C                   If        WMapLine4 <> *Blank
     C                   Eval      Q = Q + 1
     C     Q             Occur     MULT
     C                   Eval      MFLD = WMapLine4
     C                   Endif
     C                   If        WMapLine5 <> *Blank
     C                   Eval      Q = Q + 1
     C     Q             Occur     MULT
     C                   Eval      MFLD = WMapLine5
     C                   Endif
     C                   Endif
 
     C     Proc53        Tag
 
     C                   If        *IN71 = *OFF And
     C                             TDSDEF = 'Y'
     C* Sender's Correspondent is that defined on the Zero Balancing/Sweeping Details
     C                   If        IDSNDC <> *blanks
     C                   CALL      'AONOSTR0'
     C                   PARM      *BLANK        @RTCD             7
     C                   PARM      '*KEY   '     @OPTN             7
     C                   PARM      *BLANK        @CUST             6
     C                   PARM      IDCCCY        @CYCD             3
     C**********         PARM      *BLANK        @ACCD             4                          CGL029
     C                   PARM      *BLANK        @ACCD            10                          CGL029
     C                   PARM      *BLANK        @ACSN             2
     C                   PARM      IDSNDC        @NONB             2
     C                   PARM      *BLANK        @BRCD             3
     C                   PARM      *BLANK        @CSSN            10
     C                   PARM      *BLANK        @PNOI             1
     C     SDNOST        PARM      SDNOST        DSFDY
 
      ** Error on call
 
     C     @RTCD         IFNE      *BLANK
     C     *LOCK         IN        LDA
     C                   Z-ADD     11            DBASE                            * * * * * * *
     C                   MOVEL     '*KEY '       DBKEY                            * DBERR 011 *
     C                   MOVEL     'SDNOSTPD'    DBFILE                           * * * * * * *
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   Eval      PKEY1 = A7CUST
     C                   CALL      'AOCUSTR0'
     C                   PARM      *BLANKS       PRTCD             7
     C                   PARM      '*KEY   '     POPTN             7
     C                   PARM                    PKEY1            10
     C                   PARM      *BLANK        PKYST             7
     C     SDCUST        PARM      SDCUST        DSSDY
      ** Error on call
     C     @RTCD         IFNE      *BLANK
     C     @RTCD         OREQ      *BLANK
     C     BBCSID        ANDEQ     *BLANK
     C     *LOCK         IN        LDA
     C                   Z-ADD     12            DBASE                            * * * * * * *
     C                   MOVEL     A7CUST        DBKEY                            * DBERR 012 *
     C                   MOVEL     'SDCUSTPD'    DBFILE                           * * * * * * *
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   Eval      Q = Q + 1
     C     Q             Occur     MULT
     C                   Eval      MTAG = ':53A:'
     C                   Eval      MFLD = BBCSID
      *Save customer number and swift ID for MT202 cover
     C                   Move      BBCUST        W202Decn
     C                   Move      BBCSID        W202Nwds
     C                   Endif
     C                   Endif
 
      * Field :54a:
      *    First, Field :54A:
     C                   Eval      KTag = ':54A:'
     C                   EXSR      SRTrans
     C                   If        WMapFound= 'Y'
     C                   Eval      Q = Q + 1
     C     Q             Occur     MULT
     C                   Eval      MTag = ':54A:'
     C                   Eval      Sav54Tag = MTAG
     C                   Eval      MFLD = WMapLine1
     C                   Eval      Sav54L1 = MFLD
     C                   If        WMapLine2 <> *Blank
     C                   Eval      Q = Q + 1
     C     Q             Occur     MULT
     C                   Eval      MFLD = WMapLine2
     C                   Eval      Sav54L2 = MFLD
     C                   Eval      Sav54L3 = *blanks
     C                   Eval      Sav54L4 = *blanks
     C                   Eval      Sav54L5 = *blanks
     C                   Endif
     C                   Else
     C                   If        *IN71 = *OFF And
     C                             TDSDEF = 'Y'
     C                   Goto      Proc54
     C                   Endif
     C                   Endif
     C
      *    Then try field :54B:
     C                   Eval      KTag = ':54B:'
     C                   EXSR      SRTrans
     C                   If        WMapFound= 'Y'
     C                   Eval      Q = Q + 1
     C     Q             Occur     MULT
     C                   Eval      MTag = ':54B:'
     C                   Eval      Sav54Tag = MTAG
     C                   Eval      MFLD = WMapLine1
     C                   Eval      Sav54L1 = MFLD
     C                   If        WMapLine2 <> *Blank
     C                   Eval      Q = Q + 1
     C     Q             Occur     MULT
     C                   Eval      MFLD = WMapLine2
     C                   Eval      Sav54L2 = MFLD
     C                   Eval      Sav54L3 = *blanks
     C                   Eval      Sav54L4 = *blanks
     C                   Eval      Sav54L5 = *blanks
     C                   Endif
     C                   Else
     C                   If        *IN71 = *OFF And
     C                             TDSDEF = 'Y'
     C                   Goto      Proc54
     C                   Endif
     C                   Endif
     C
      *    Then try field :54D:
     C                   Eval      KTag = ':54D:'
     C                   EXSR      SRTrans
     C                   If        WMapFound= 'Y'
     C                   Eval      Q = Q + 1
     C     Q             Occur     MULT
     C                   Eval      MTag = ':54D:'
     C                   Eval      Sav54Tag = MTAG
     C                   Eval      MFLD = WMapLine1
     C                   Eval      Sav54L1 = MFLD
     C                   If        WMapLine2 <> *Blank
     C                   Eval      Q = Q + 1
     C     Q             Occur     MULT
     C                   Eval      MFLD = WMapLine2
     C                   Eval      Sav54L2 = MFLD
     C                   Endif
     C                   If        WMapLine3 <> *Blank
     C                   Eval      Q = Q + 1
     C     Q             Occur     MULT
     C                   Eval      MFLD = WMapLine3
     C                   Eval      Sav54L3 = MFLD
     C                   Endif
     C                   If        WMapLine4 <> *Blank
     C                   Eval      Q = Q + 1
     C     Q             Occur     MULT
     C                   Eval      MFLD = WMapLine4
     C                   Eval      Sav54L4 = MFLD
     C                   Endif
     C                   If        WMapLine5 <> *Blank
     C                   Eval      Q = Q + 1
     C     Q             Occur     MULT
     C                   Eval      MFLD = WMapLine5
     C                   Eval      Sav54L5 = MFLD
     C                   Endif
     C                   Endif
 
     C     Proc54        Tag
 
     C                   If        *IN71 = *OFF And
     C                             TDSDEF = 'Y'
     C* Receiver's Correspondent is that defined on the Zero Balancing/Sweeping Details
     C                   If        IDRCVC <> *blanks
     C                   Eval      Q = Q + 1
     C     Q             Occur     MULT
     C                   Eval      MTAG = ':54A:'
     C                   Eval      Sav54Tag = MTAG
     C                   Eval      MFLD = IDRCVC
     C                   Eval      Sav54L1 = MFLD
     C                   Eval      Sav54L2 = *blanks
     C                   Eval      Sav54L3 = *blanks
     C                   Eval      Sav54L4 = *blanks
     C                   Eval      Sav54L5 = *blanks
     C                   Endif
     C                   Endif
 
      * Field :55a:
      *    First, Field :55A:
     C                   Eval      KTag = ':55A:'
     C                   EXSR      SRTrans
     C                   If        WMapFound= 'Y'
     C                   Eval      Q = Q + 1
     C     Q             Occur     MULT
     C                   Eval      MTag = ':55A:'
     C                   Eval      MFLD = WMapLine1
     C                   If        WMapLine2 <> *Blank
     C                   Eval      Q = Q + 1
     C     Q             Occur     MULT
     C                   Eval      MFLD = WMapLine2
     C                   Endif
     C                   Else
     C                   If        *IN71 = *OFF And
     C                             TDSDEF = 'Y'
     C                   Goto      Proc55
     C                   Endif
     C                   Endif
     C
      *    Then try field :55B:
     C                   Eval      KTag = ':55B:'
     C                   EXSR      SRTrans
     C                   If        WMapFound= 'Y'
     C                   Eval      Q = Q + 1
     C     Q             Occur     MULT
     C                   Eval      MTag = ':55B:'
     C                   Eval      MFLD = WMapLine1
     C                   If        WMapLine2 <> *Blank
     C                   Eval      Q = Q + 1
     C     Q             Occur     MULT
     C                   Eval      MFLD = WMapLine2
     C                   Endif
     C                   Else
     C                   If        *IN71 = *OFF And
     C                             TDSDEF = 'Y'
     C                   Goto      Proc55
     C                   Endif
     C                   Endif
     C
      *    Then try field :55D:
     C                   Eval      KTag = ':55D:'
     C                   EXSR      SRTrans
     C                   If        WMapFound= 'Y'
     C                   Eval      Q = Q + 1
     C     Q             Occur     MULT
     C                   Eval      MTag = ':55D:'
     C                   Eval      MFLD = WMapLine1
     C                   If        WMapLine2 <> *Blank
     C                   Eval      Q = Q + 1
     C     Q             Occur     MULT
     C                   Eval      MFLD = WMapLine2
     C                   Endif
     C                   If        WMapLine3 <> *Blank
     C                   Eval      Q = Q + 1
     C     Q             Occur     MULT
     C                   Eval      MFLD = WMapLine3
     C                   Endif
     C                   If        WMapLine4 <> *Blank
     C                   Eval      Q = Q + 1
     C     Q             Occur     MULT
     C                   Eval      MFLD = WMapLine4
     C                   Endif
     C                   If        WMapLine5 <> *Blank
     C                   Eval      Q = Q + 1
     C     Q             Occur     MULT
     C                   Eval      MFLD = WMapLine5
     C                   Endif
     C                   Endif
 
     C     Proc55        Tag
 
     C                   If        *IN71 = *OFF And
     C                             TDSDEF = 'Y'
     C* No system defined values can be retrieved for Third Reimbursement Institution
     C                   Endif
 
      * Field :56a:
      *    First, Field :56A:
     C                   Eval      KTag = ':56A:'
     C                   EXSR      SRTrans
     C                   If        WMapFound= 'Y'
     C                   Eval      Q = Q + 1
     C     Q             Occur     MULT
     C                   Eval      MTag = ':56A:'
     C                   Eval      MFLD = WMapLine1
     C                   If        WMapLine2 <> *Blank
     C                   Eval      Q = Q + 1
     C     Q             Occur     MULT
     C                   Eval      MFLD = WMapLine2
     C                   Endif
     C                                                                                        CSW209
     C                   IF        CSW209 = 'Y'                                               CSW209
      * Save :56A: message data to be used in MT202 COV                                       CSW209
     C                   MOVEL     ':56A:'       MTAG56X                                      CSW209
     C                   MOVEL     WMapLine1     ADD56X1                                      CSW209
     C                   MOVEL     WMapLine2     ADD56X2                                      CSW209
     C                   ENDIF                                                                CSW209
     C                                                                                        CSW209
     C                   Else
     C                   If        *IN71 = *OFF And
     C                             TDSDEF = 'Y'
     C                   Goto      Proc56
     C                   Endif
     C                   Endif
     C
      *    Then try field :56C:
     C                   Eval      KTag = ':56C:'
     C                   EXSR      SRTrans
     C                   If        WMapFound= 'Y'
     C                   Eval      Q = Q + 1
     C     Q             Occur     MULT
     C                   Eval      MTag = ':56C:'
     C                   Eval      MFLD = WMapLine1
     C                                                                                        CSW209
     C                   IF        CSW209 = 'Y'                                               CSW209
      * Save :56C: message data to be used in MT202 COV                                       CSW209
     C                   MOVEL     ':56C:'       MTAG56X                                      CSW209
     C                   MOVEL     WMapLine1     ADD56X1                                      CSW209
     C                   ENDIF                                                                CSW209
     C                                                                                        CSW209
     C                   Else
     C                   If        *IN71 = *OFF And
     C                             TDSDEF = 'Y'
     C                   Goto      Proc56
     C                   Endif
     C                   Endif
     C
      *    Then try field :56D:
     C                   Eval      KTag = ':56D:'
     C                   EXSR      SRTrans
     C                   If        WMapFound= 'Y'
     C                   Eval      Q = Q + 1
     C     Q             Occur     MULT
     C                   Eval      MTag = ':56D:'
     C                   Eval      MFLD = WMapLine1
     C                   If        WMapLine2 <> *Blank
     C                   Eval      Q = Q + 1
     C     Q             Occur     MULT
     C                   Eval      MFLD = WMapLine2
     C                   Endif
     C                   If        WMapLine3 <> *Blank
     C                   Eval      Q = Q + 1
     C     Q             Occur     MULT
     C                   Eval      MFLD = WMapLine3
     C                   Endif
     C                   If        WMapLine4 <> *Blank
     C                   Eval      Q = Q + 1
     C     Q             Occur     MULT
     C                   Eval      MFLD = WMapLine4
     C                   Endif
     C                   If        WMapLine5 <> *Blank
     C                   Eval      Q = Q + 1
     C     Q             Occur     MULT
     C                   Eval      MFLD = WMapLine5
     C                   Endif
     C                                                                                        CSW209
     C                   IF        CSW209 = 'Y'                                               CSW209
      * Save :56D: message data to be used in MT202 COV                                       CSW209
     C                   MOVEL     ':56D:'       MTAG56X                                      CSW209
     C                   MOVEL     WMapLine1     ADD56X1                                      CSW209
     C                   MOVEL     WMapLine2     ADD56X2                                      CSW209
     C                   MOVEL     WMapLine3     ADD56X3                                      CSW209
     C                   MOVEL     WMapLine4     ADD56X4                                      CSW209
     C                   MOVEL     WMapLine5     ADD56X5                                      CSW209
     C                   ENDIF                                                                CSW209
     C                                                                                        CSW209
     C                   Endif
 
     C     Proc56        Tag
 
     C                   If        *IN71 = *OFF And
     C                             TDSDEF = 'Y'
     C* No system defined values can be retrieved for Intermediary Bank
     C                   Endif
 
      * Field :57a:
      *    First, Field :57A:
     C                   Eval      KTag = ':57A:'
     C                   EXSR      SRTrans
     C                   If        WMapFound= 'Y'
     C                   Eval      Q = Q + 1
     C     Q             Occur     MULT
     C                   Eval      MTag = ':57A:'
     C                   Eval      MFLD = WMapLine1
     C                   If        WMapLine2 <> *Blank
     C                   Eval      Q = Q + 1
     C     Q             Occur     MULT
     C                   Eval      MFLD = WMapLine2
     C                   Endif
     C                                                                                        CSW209
     C                   IF        CSW209 = 'Y'                                               CSW209
      * Save :57A: message data to be used in MT202 COV                                       CSW209
     C                   MOVEL     ':57A:'       MTAG57X                                      CSW209
     C                   MOVEL     WMapLine1     ADD57X1                                      CSW209
     C                   MOVEL     WMapLine2     ADD57X2                                      CSW209
     C                   ENDIF                                                                CSW209
     C                                                                                        CSW209
     C                   Else
     C                   If        *IN71 = *OFF And
     C                             TDSDEF = 'Y'
     C                   Goto      Proc57
     C                   Endif
     C                   Endif
     C
      *    First, Field :57B:
     C                   Eval      KTag = ':57B:'
     C                   EXSR      SRTrans
     C                   If        WMapFound= 'Y'
     C                   Eval      Q = Q + 1
     C     Q             Occur     MULT
     C                   Eval      MTag = ':57B:'
     C                   Eval      MFLD = WMapLine1
     C                   If        WMapLine2 <> *Blank
     C                   Eval      Q = Q + 1
     C     Q             Occur     MULT
     C                   Eval      MFLD = WMapLine2
     C                   Endif
     C                                                                                        CSW209
     C                   IF        CSW209 = 'Y'                                               CSW209
      * Save :57B: message data to be used in MT202 COV                                       CSW209
     C                   MOVEL     ':57B:'       MTAG57X                                      CSW209
     C                   MOVEL     WMapLine1     ADD57X1                                      CSW209
     C                   MOVEL     WMapLine2     ADD57X2                                      CSW209
     C                   ENDIF                                                                CSW209
     C                                                                                        CSW209
     C                   Else
     C                   If        *IN71 = *OFF And
     C                             TDSDEF = 'Y'
     C                   Goto      Proc57
     C                   Endif
     C                   Endif
     C
      *    Then try field :57C:
     C                   Eval      KTag = ':57C:'
     C                   EXSR      SRTrans
     C                   If        WMapFound= 'Y'
     C                   Eval      Q = Q + 1
     C     Q             Occur     MULT
     C                   Eval      MTag = ':57C:'
     C                   Eval      MFLD = WMapLine1
     C                                                                                        CSW209
     C                   IF        CSW209 = 'Y'                                               CSW209
      * Save :57C: message data to be used in MT202 COV                                       CSW209
     C                   MOVEL     ':57C:'       MTAG57X                                      CSW209
     C                   MOVEL     WMapLine1     ADD57X1                                      CSW209
     C                   ENDIF                                                                CSW209
     C                                                                                        CSW209
     C                   Else
     C                   If        *IN71 = *OFF And
     C                             TDSDEF = 'Y'
     C                   Goto      Proc57
     C                   Endif
     C                   Endif
     C
      *    Then try field :57D:
     C                   Eval      KTag = ':57D:'
     C                   EXSR      SRTrans
     C                   If        WMapFound= 'Y'
     C                   Eval      Q = Q + 1
     C     Q             Occur     MULT
     C                   Eval      MTag = ':57D:'
     C                   Eval      MFLD = WMapLine1
     C                   If        WMapLine2 <> *Blank
     C                   Eval      Q = Q + 1
     C     Q             Occur     MULT
     C                   Eval      MFLD = WMapLine2
     C                   Endif
     C                   If        WMapLine3 <> *Blank
     C                   Eval      Q = Q + 1
     C     Q             Occur     MULT
     C                   Eval      MFLD = WMapLine3
     C                   Endif
     C                   If        WMapLine4 <> *Blank
     C                   Eval      Q = Q + 1
     C     Q             Occur     MULT
     C                   Eval      MFLD = WMapLine4
     C                   Endif
     C                   If        WMapLine5 <> *Blank
     C                   Eval      Q = Q + 1
     C     Q             Occur     MULT
     C                   Eval      MFLD = WMapLine5
     C                   Endif
     C                                                                                        CSW209
     C                   IF        CSW209 = 'Y'                                               CSW209
      * Save :57D: message data to be used in MT202 COV                                       CSW209
     C                   MOVEL     ':57D:'       MTAG57X                                      CSW209
     C                   MOVEL     WMapLine1     ADD57X1                                      CSW209
     C                   MOVEL     WMapLine2     ADD57X2                                      CSW209
     C                   MOVEL     WMapLine3     ADD57X3                                      CSW209
     C                   MOVEL     WMapLine4     ADD57X4                                      CSW209
     C                   MOVEL     WMapLine5     ADD57X5                                      CSW209
     C                   ENDIF                                                                CSW209
     C                                                                                        CSW209
     C                   Endif
 
     C     Proc57        Tag
 
     C                   If        *IN71 = *OFF And
     C                             TDSDEF = 'Y'
     C* No system defined values can be retrieved for Account with Bank
     C                   Endif
 
      * Field :59:
 
      *    First, try field :59A:
     C                   Eval      KTag = ':59A:'
     C                   EXSR      SRTrans
     C                   If        WMapFound= 'Y'
     C                   Eval      Q = Q + 1
     C     Q             Occur     MULT
     C                   Eval      MTag = ':59A:'
     C                   Eval      MFLD = WMapLine1
     C                   If        WMapLine2 <> *Blank
     C                   Eval      Q = Q + 1
     C     Q             Occur     MULT
     C                   Eval      MFLD = WMapLine2
     C                   Endif
     C                                                                                        CSW209
     C                   IF        CSW209 = 'Y'                                               CSW209
      * Save :59A: message data to be used in MT202 COV                                       CSW209
     C                   MOVEL     'Y'           T59MAP                                       CSW209
     C                   MOVEL     ':59A:'       MTAG59X                                      CSW209
     C                   MOVEL     WMapLine1     ADD59X1                                      CSW209
     C                   MOVEL     WMapLine2     ADD59X2                                      CSW209
     C                   ENDIF                                                                CSW209
     C                                                                                        CSW209
     C                   Else
     C                   If        *IN71 = *OFF And
     C                             TDSDEF = 'Y'
     C                   Goto      Proc59
     C                   Endif
     C                   Endif
     C
                                                                                              CSW215
      ** Then try field :59F:                                                                 CSW215
                                                                                              CSW215
     C                   IF        CSW215 = 'Y'                                               CSW215
     C                   EVAL      KTag = ':59F:'                                             CSW215
     C                   EXSR      SRTrans                                                    CSW215
     C                   IF        WMapFound = 'Y'                                            CSW215
     C                   EXSR      SRInit59F                                                  CSW215
     C                   EVAL      POutParm1 = WMapLine1                                      CSW215
     C                   EVAL      POutParm2 = WMapLine2                                      CSW215
     C                   EVAL      POutParm3 = WMapLine3                                      CSW215
     C                   EVAL      POutParm4 = WMapLine4                                      CSW215
     C                   EVAL      POutParm5 = WMapLine5                                      CSW215
     C                   EVAL      WMsgType = '103'                                           CSW215
     C                   EVAL      T59MAP = 'Y'                                               CSW215
     C                   EXSR      SROut59F                                                   CSW215
     C                   GOTO      Proc59                                                     CSW215
     C                   ELSE                                                                 CSW215
     C                   IF        *IN71 = *OFF And                                           CSW215
     C                             TDSDEF = 'Y'                                               CSW215
     C                   GOTO      Proc59                                                     CSW215
     C                   ENDIF                                                                CSW215
     C                   ENDIF                                                                CSW215
     C                   ENDIF                                                                CSW215
                                                                                              CSW215
      *    Then try field :59:
     C                   Eval      KTag = ':59:'
     C                   EXSR      SRTrans
     C                   If        WMapFound= 'Y'
     C                   Eval      Q = Q + 1
     C     Q             Occur     MULT
     C                   Eval      MTag = ':59:'
     C                   Eval      MFLD = WMapLine1
     C                   If        WMapLine2 <> *Blank
     C                   Eval      Q = Q + 1
     C     Q             Occur     MULT
     C                   Eval      MFLD = WMapLine2
     C                   Endif
     C                   If        WMapLine3 <> *Blank
     C                   Eval      Q = Q + 1
     C     Q             Occur     MULT
     C                   Eval      MFLD = WMapLine3
     C                   Endif
     C                   If        WMapLine4 <> *Blank
     C                   Eval      Q = Q + 1
     C     Q             Occur     MULT
     C                   Eval      MFLD = WMapLine4
     C                   Endif
     C                   If        WMapLine5 <> *Blank
     C                   Eval      Q = Q + 1
     C     Q             Occur     MULT
     C                   Eval      MFLD = WMapLine5
     C                   Endif
     C                                                                                        CSW209
     C                   IF        CSW209 = 'Y'                                               CSW209
      * Save :59: message data to be used in MT202 COV                                        CSW209
     C                   MOVEL     'Y'           T59MAP                                       CSW209
     C                   MOVEL     ':59:'        MTAG59X                                      CSW209
     C                   MOVEL     WMapLine1     ADD59X1                                      CSW209
     C                   MOVEL     WMapLine2     ADD59X2                                      CSW209
     C                   MOVEL     WMapLine3     ADD59X3                                      CSW209
     C                   MOVEL     WMapLine4     ADD59X4                                      CSW209
     C                   MOVEL     WMapLine5     ADD59X5                                      CSW209
     C                   ENDIF                                                                CSW209
     C                                                                                        CSW209
     C                   Endif
 
     C     Proc59        Tag
 
     C                   If        *IN71 = *OFF And
     C                             TDSDEF = 'Y'
                                                                                              CSW215
     C                   EXSR      SRMT103F                                                   CSW215
                                                                                              CSW215
     C                   IF        Wrk59F = 'Y'                                               CSW215
     C                   EVAL      WMsgType = '103'                                           CSW215
     C                   EVAL      T59MAP = 'Y'                                               CSW215
     C                   EXSR      SRout59F                                                   CSW215
     C                   ELSE                                                                 CSW215
                                                                                              CSW215
     C* Beneficiary is the External Account from the ZB/S Details
     C                   Eval      Q = Q + 1
     C     Q             Occur     MULT
     C                   Eval      MTAG = ':59:'
     C                   Eval      MFLD = IDEXA1
     C                                                                                        CSW209
     C                   IF        CSW209 = 'Y'                                               CSW209
      * Save :59: message data to be used in MT202 COV                                        CSW209
     C                   MOVEL     'N'           T59MAP                                       CSW209
     C                   MOVEL     ':59:'        MTAG59X                                      CSW209
     C                   MOVEL     IDEXA1        Save59                                       CSW209
     C                   ENDIF                                                                CSW209
     C                                                                                        CSW209
     C                   Eval      Q = Q + 1
     C     Q             Occur     MULT
 
     C                   Eval      ZSADD1 = IDEXA2
     C***********        Eval      ZSADD2 = IDEXA3                              211499
     C***********        Eval      ZSADD3 = IDEXA4                              211499
     C***********        Eval      ZSADD4 = IDEXA5                              211499
     C                   Eval      ZSADD2 = *blank                              211499
     C                   Eval      ZSADD3 = *blank                              211499
     C                   Eval      ZSADD4 = *blank                              211499
                                                                                              CSW209
     C                   IF        CSW209 = 'Y'                                               CSW209
      * Save :59: message data to be used in MT202 COV                                        CSW209
     C                   MOVEL     IDEXA2        ADD591                                       CSW209
     C                   ENDIF                                                                CSW209
                                                                                              CSW209
     C                   Exsr      SWADF
     C                   ENDIF                                                                CSW215
     C                   Endif
 
      * Field :70:
     C                   Eval      KTag = ':70:'
     C                   EXSR      SRTrans
     C                   If        WMapFound= 'Y'
     C                   Eval      Q = Q + 1
     C     Q             Occur     MULT
     C                   Eval      MTag = ':70:'
     C                   Eval      MFLD = WMapLine1
     C                   If        WMapLine2 <> *Blank
     C                   Eval      Q = Q + 1
     C     Q             Occur     MULT
     C                   Eval      MFLD = WMapLine2
     C                   Endif
     C                   If        WMapLine3 <> *Blank
     C                   Eval      Q = Q + 1
     C     Q             Occur     MULT
     C                   Eval      MFLD = WMapLine3
     C                   Endif
     C                   If        WMapLine4 <> *Blank
     C                   Eval      Q = Q + 1
     C     Q             Occur     MULT
     C                   Eval      MFLD = WMapLine4
     C                   Endif
                                                                                              CSW209
     C                   IF        CSW209 = 'Y'                                               CSW209
      * Save :70: message data to be used in MT202 COV                                        CSW209
     C                   MOVEL     'Y'           T70MAP                                       CSW209
     C                   MOVEL     WMapLine1     ADD70X1                                      CSW209
     C                   MOVEL     WMapLine2     ADD70X2                                      CSW209
     C                   MOVEL     WMapLine3     ADD70X3                                      CSW209
     C                   MOVEL     WMapLine4     ADD70X4                                      CSW209
     C                   MOVEL     WMapLine5     ADD70X5                                      CSW209
     C                   ENDIF                                                                CSW209
                                                                                              CSW209
     C                   Else
 
     C                   If        *IN71 = *OFF And
     C                             TDSDEF = 'Y'
     C                   Eval      Q = Q + 1
     C     Q             Occur     MULT
     C                   Eval      MTAG = ':70:'
     C                   If        IDSTYP = 'Z'
     C                   Eval      MFLD = 'CMZ' + '/' + WAccount
     C                   Else
     C                   Eval      MFLD = 'CMT' + '/' + WAccount
     C                   Endif
                                                                                              CSW209
     C                   IF        CSW209 = 'Y'                                               CSW209
      * Save :70: message data to be used in MT202 COV                                        CSW209
     C                   MOVEL     'N'           T70MAP                                       CSW209
     C                   MOVEL     MFLD          Save70                                       CSW209
     C                   ENDIF                                                                CSW209
 
     C                   If        IDENAR <> 'CMX'
     C                   Eval      Q = Q + 1
     C     Q             Occur     MULT
     C                   Eval      MFLD = '/' + IDENAR
                                                                                              CSW209
     C                   IF        CSW209 = 'Y'                                               CSW209
      * Save :70: message data to be used in MT202 COV                                        CSW209
     C                   MOVEL     MFLD          Save701                                      CSW209
     C                   ENDIF                                                                CSW209
                                                                                              CSW209
     C                   Endif
     C                   Endif
     C                   Endif
 
      * Field :71A:
     C                   Eval      KTag = ':71A:'
     C                   EXSR      SRTrans
     C                   If        WMapFound= 'Y'
     C                   Eval      Q = Q + 1
     C     Q             Occur     MULT
     C                   Eval      MTag = ':71A:'
     C                   Eval      MFLD = WMapLine1
     C                   Else
 
     C                   If        *IN71 = *OFF And
     C                             TDSDEF = 'Y'
     C                   Eval      Q = Q + 1
     C     Q             Occur     MULT
     C                   Eval      MTAG = ':71A:'
     C                   Eval      MFLD = IDCHGR
     C                   Endif
     C                   Endif
     C                   Movel     MFLD          @DETC             3
 
      * Field :71F:
     C                   Eval      KTag = ':71F:'
     C                   EXSR      SRTrans
     C                   If        WMapFound= 'Y'
     C                   Eval      Q = Q + 1
     C     Q             Occur     MULT
     C                   Eval      MTag = ':71F:'
     C                   Eval      MFLD = WMapLine1
     C                   Else
 
     C                   If        *IN71 = *OFF And
     C                             TDSDEF = 'Y'
     C                             OR @DETC  = 'BEN'                            213569
     C                   If        IDCHGR = 'BEN'
     C                             OR @DETC  = 'BEN'                            213569
     C                   Eval      Q = Q + 1
     C     Q             Occur     MULT
     C                   Eval      MTAG = ':71F:'
     C*******************Z-add     IDCAMT        ZAMNT                          213569
     C     IDCACT        IFEQ      *BLANK                                       213569
     C                   Z-add     IDCAMT        ZAMNT                          213569
     C                   Else                                                   213569
     C                   Z-add     0             ZAMNT                          213569
     C                   Endif                                                  213569
     C                   CALL      'ZM0040'                             15
     C                   PARM                    ZAMNT            13 0
     C                   PARM                    ZCCY              3
     C                   PARM                    ZSAMNT
     C                   PARM                    ZSCCY             3
     C                   PARM                    ZERR              1
     C                   PARM                    ZSWDPC                                       222373
      *
      ** If the program ends in error.
      *
     C     *IN15         IFEQ      '1'
     C     ZERR          OREQ      '1'
     C     *LOCK         IN        LDA
     C                   Z-ADD     13            DBASE                            * * * * * * *
     C                   MOVEL     '       '     DBKEY                            * DBERR 013 *
     C                   MOVEL     'ZM0040'      DBFILE                           * * * * * * *
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   Endif
 
     C***********        Eval      MFLD = ZSAMNT                                213569
     C                   Eval      MFLD = ZSCCY + ZSAMNT                        213569
     C                   Endif
     C                   Endif
     C                   Endif
 
      * Field :71G:
     C                   Eval      KTag = ':71G:'
     C                   EXSR      SRTrans
     C                   If        WMapFound= 'Y'
     C                   Eval      Q = Q + 1
     C     Q             Occur     MULT
     C                   Eval      MTag = ':71G:'
     C                   Eval      MFLD = WMapLine1
     C                   Else
 
     C                   If        *IN71 = *OFF And
     C                             TDSDEF = 'Y'
     C***********        If        IDCHGR = 'BEN'                                             213569
     C                   If        IDCHGR = 'OUR' And                                         213569
     C                             IDCAMT <> 0                                                213569
     C                   Eval      Q = Q + 1
     C     Q             Occur     MULT
     C                   Eval      MTAG = ':71G:'
     C                   Z-add     IDCAMT        ZAMNT
     C                   CALL      'ZM0040'                             15
     C                   PARM                    ZAMNT            13 0
     C                   PARM                    ZCCY              3
     C                   PARM                    ZSAMNT
     C                   PARM                    ZSCCY             3
     C                   PARM                    ZERR              1
     C                   PARM                    ZSWDPC                                       222373
      *
      ** If the program ends in error.
      *
     C     *IN15         IFEQ      '1'
     C     ZERR          OREQ      '1'
     C     *LOCK         IN        LDA
     C                   Z-ADD     13            DBASE                            * * * * * * *
     C                   MOVEL     '       '     DBKEY                            * DBERR 013 *
     C                   MOVEL     'ZM0040'      DBFILE                           * * * * * * *
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   Endif
 
     C***********        Eval      MFLD = ZSAMNT                                213569
     C                   Eval      MFLD = ZSCCY + ZSAMNT                        213569
     C                   Endif
     C                   Endif
     C                   Endif
     C
      * Field :72:
     C                   Eval      KTag = ':72:'
     C                   EXSR      SRTrans
     C                   If        WMapFound= 'Y'
     C                   Eval      Q = Q + 1
     C     Q             Occur     MULT
     C                   Eval      MTag = ':72:'
     C                   Eval      MFLD = WMapLine1
     C                   If        WMapLine2 <> *Blank
     C                   Eval      Q = Q + 1
     C     Q             Occur     MULT
     C                   Eval      MFLD = WMapLine2
     C                   Endif
     C                   If        WMapLine3 <> *Blank
     C                   Eval      Q = Q + 1
     C     Q             Occur     MULT
     C                   Eval      MFLD = WMapLine3
     C                   Endif
     C                   If        WMapLine4 <> *Blank
     C                   Eval      Q = Q + 1
     C     Q             Occur     MULT
     C                   Eval      MFLD = WMapLine4
     C                   Endif
     C                   If        WMapLine5 <> *Blank
     C                   Eval      Q = Q + 1
     C     Q             Occur     MULT
     C                   Eval      MFLD = WMapLine5
     C                   Endif
     C                   If        WMapLine6 <> *Blank
     C                   Eval      Q = Q + 1
     C     Q             Occur     MULT
     C                   Eval      MFLD = WMapLine6
     C                   Endif
                                                                                              CSW209
     C                   IF        CSW209 = 'Y'                                               CSW209
      * Save :72: message data to be used in MT202 COV                                        CSW209
     C                   MOVEL     WMapLine1     ADD72X1                                      CSW209
     C                   MOVEL     WMapLine2     ADD72X2                                      CSW209
     C                   MOVEL     WMapLine3     ADD72X3                                      CSW209
     C                   MOVEL     WMapLine4     ADD72X4                                      CSW209
     C                   MOVEL     WMapLine5     ADD72X5                                      CSW209
     C                   MOVEL     WMapLine6     ADD72X6                                      CSW209
     C                   ENDIF                                                                CSW209
                                                                                              CSW209
     C                   Else
     C                   If        *IN71 = *OFF And
     C                             TDSDEF = 'Y'
     C* no system defined values  can be retrieved.
     C                   Endif
     C                   Endif
     C
      * Field :77B:
     C                   Eval      KTag = ':77B:'
     C                   EXSR      SRTrans
     C                   If        WMapFound= 'Y'
     C                   Eval      Q = Q + 1
     C     Q             Occur     MULT
     C                   Eval      MTag = ':77B:'
     C                   Eval      MFLD = WMapLine1
     C                   If        WMapLine2 <> *Blank
     C                   Eval      Q = Q + 1
     C     Q             Occur     MULT
     C                   Eval      MFLD = WMapLine2
     C                   Endif
     C                   If        WMapLine3 <> *Blank
     C                   Eval      Q = Q + 1
     C     Q             Occur     MULT
     C                   Eval      MFLD = WMapLine3
     C                   Endif
     C                   Else
     C                   If        *IN71 = *OFF And
     C                             TDSDEF = 'Y'
     C* no system defined values  can be retrieved.
     C                   Endif
     C                   Endif
 
      * = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =
      *                    F I L E   O U T P U T
 
      * Output formatted message to MGOMSGPD
     C                   EXSR      WriteMGOMSG
 
      * Write MGOREFPD record
     C                   Eval      MTPY = '103'
     C                   EXSR      WriteMGOREF
 
      * Update REICSDPD file
     C                   Eval      IDMSGT = MGTM
     C                   Eval      IDMSGP = 'Y'
     C                   Eval      IDOMSR = SavTrno
     C                   Eval      IDSNDR = NWSN
     C                   Update    REICSDD0
 
      * = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =
      *                    M T 2 0 2     G E N E R A T I O N
 
      * Call Cover MT202 extraction if Cover Message Required
     C                   If        IDMCMR = 'Y'
      *  Save MT103 destination address  for MT202 beneficiary
     C                   Movel     NWDS          Sav103Dest       11
     C                   Eval      SecondCall = 'Y'
     C                   Exsr      SRRout
     C                   Exsr      SRMT202
     C                   Endif
 
     C                   COMMIT
 
      * = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =
 
     C                   EVAL      COUNT103 = COUNT103 + 1
 
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      ********************************************************************
      * WriteMGOMSG - Write formatted message to MGOMSGPD                *
      ********************************************************************
     C     WriteMGOMSG   BEGSR
      *
      **  Fill in Transaction Number
     C                   Eval      TRNO = SavTRNO
     C                   If        I@MTPY = '202'
     C                   Eval      %Subst(TRNO : 1 : 2) = 'RC'
     C                   Endif
     C                   Eval      CTRC = CRLF
      *
      **  Write multiple occurrence data structure to MGOMSGPD
     C                   Z-ADD     1             X                 4 0          190200
     C     X             OCCUR     MULT
      *
     C                   Dow       X <= Q
     C                   Write     MGOMSGD0                             42
      *
      **  Error on write to PF/MGOMSGPD (message data file)
      *
     C                   If        *IN42
     C     *LOCK         IN        LDA
     C                   Z-Add     14            DBASE                          * * * * * * * *
     C                   Movel     '       '     DBKEY                          *  DBERR 014  *
     C                   Movel     'MGOMSGPD'    DBFILE                         * * * * * * * *
     C                   OUT       LDA
     C                   Exsr      *PSSR
     C                   Endif
      *
     C                   Eval      X = X + 1
     C     X             OCCUR     MULT
     C                   Enddo
      *
     C                   Endsr
      ********************************************************************
      /SPACE 5
      ********************************************************************
      * WriteMGOREF - Write record to MGOREFPD                           *
      ********************************************************************
     C     WriteMGOREF   BEGSR
     C
     C                   Eval      SYTM = *Blanks
     C                   Eval      MODI = 'RE'
     C
     C                   Eval      TRNF = *BLANKS
     C                   Eval      TRNM = *Blanks
     C                   Eval      MTRN = %SUBST(SavTRNO:3:14)                  213572
     C*******************Movel     SavTRNO       MTRN                           213572
     C                   Eval      TNTP = *Blank
     C                   Eval      SBTP = *Blank
     C                   Eval      EVTP = *Blanks
 
     C                   Movel     *Blanks       NWBN
     C                   Select
     C                   When      MTPY = '101'
     C                   Movel     IDCCUS        NWBN
     C                   When      MTPY = '103'
     C                   Movel     *blanks       NWBN
     C                   When      MTPY = '202'
     C                   Eval      NWBN =  Sav103Dest
     C                   Endsl
 
     C                   Call      'AOCURRR0'
     C                   Parm      '*DBERR'      @RTCD             7
     C                   Parm      '*KEY   '     @OPTN             7
     C                   Parm      IDCCCY        @CCY              3
     C     SDCURR        Parm      SDCURR        DSSDY
 
      ** Error on call
     C     @RTCD         IFNE      *BLANK
     C     *LOCK         IN        LDA
     C                   Z-ADD     15            DBASE                            * * * * * * *
     C                   MOVEL     IDCCCY        DBKEY                            * DBERR 015 *
     C                   MOVEL     'SDCURRPD'    DBFILE                           * * * * * * *
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   If        A6DPRU = 'Y'
     C                   Eval      MPRY = 'U'
     C                   Else
     C                   Eval      MPRY = 'N'
     C                   End
 
     C                   If        MTPY = '101'
     C                   Eval      MGST = CM101S
     C                   Else
     C                   Eval      MGST = CM103S
     C                   Endif
     C
     C                   If        MGST = 'RSND'
     C                   Eval      MGSG = '2'
     C                   Else
     C                   Eval      MGSG = '1'
     C                   Endif
     C
     C                   Eval      LSCC =  *Blanks
     C                   Eval      F57U =  *Blanks
     C                   Eval      PTST =  *Blanks
     C                   Eval      CARQ =  *Blanks
     C                   Eval      MPDE =  *Blanks
     C                   Eval      HRDT =  @HRDT
 
     C                   TIME                    MGTM
     C                   Move      BJMRDT        LADT
     C                   Move      MGTM          LATM
 
     C                   If        MGST = 'RSND'
     C                   Move      BJMRDT        RELD
     C                   Eval      RELT = MGTM
     C                   Else
     C                   Move      *Blanks       RELD
     C                   Eval      RELT = 0
     C                   End
 
     C                   Eval      RUSR = *blanks
     C                   Eval      RWSN = *blanks
     C                   Movel     SavAmount     AMTX
     C                   Movel     SavAmount     AMTS
     C                   Movel     SavDate       SVDT
     C                   Move      IDCCCY        CCY
 
     C                   Select
     C                   When      MTPY = '103'  And
     C                             IDDSTT = 'N'
     C                   Movel     IDDEST        NSNO
     C                   When      MTPY = '103'
     C                   Movel     IDSNDC        NSNO
     C                   Other
     C                   Eval      NSNO = 0
     C                   Endsl
 
     C                   Move      *blanks       SACN
     C                   Move      *blanks       AORR
     C                   Move      *blanks       DESI
     C                   Move      CDBRCA        BRCA
     C                   Move      *blanks       OTHB
     C                   Move      *blanks       RCBR
     C                   Move      *blanks       OTHT
     C                   Move      *blanks       NETI
 
     C                   If        A6NDWR = 'Y'
     C                   If        A6DNOR = 'Y'
     C                   Eval      DELC = '3'
     C                   Else
     C                   Eval      DELC = '1'
     C                   Endif
      *
     C                   Else
     C                   If        A6DNOR = 'Y'
     C                   Eval      DELC = '2'
     C                   Else
     C                   Eval      DELC = *Blanks
     C                   Endif
     C                   Endif
      *
      ** Ensure message priority and delivery notification valid
      ** MPRY = 'U' DELC = '1' or '3',
      ** MPRY = 'N' DELC = ' ' or '2'.
     C     MPRY          IFEQ      'U'
     C     DELC          ANDEQ     ' '
     C     MPRY          OREQ      'U'
     C     DELC          ANDEQ     '2'
     C                   MOVEL     '1'           DELC
     C                   END
      *
     C     MPRY          IFEQ      'N'
     C     DELC          ANDEQ     '1'
     C     MPRY          OREQ      'N'
     C     DELC          ANDEQ     '3'
     C                   MOVEL     '2'           DELC
     C                   END
 
     C                   Move      *blanks       DYST
     C                   Move      *blanks       RSID
     C                   Move      *blanks       MSE1
     C                   Move      *blanks       ELIN
     C                   Move      *blanks       SSAC
     C                   Move      *blanks       MIR
     C                   Eval      TSKS = 'Y'
     C                   Eval      TSKY = *Blanks
     C                   Eval      TSEQ = *Zeros
     C                   Eval      CFPF = *Blanks
     C                   Eval      PT210 = *Zeros
     C                   Eval      AVDT = *Zeros
     C                   Eval      ASEQ = *Zeros
     C                   Eval      TODY = *Blanks
      *
      ** Set-up Message Generation Century flag
      *
     C                   Movel     MGDE          YY                2 0
     C                   If        YY < 72
     C                   Eval      CIND = '2'
     C                   Else
     C                   Eval      CIND = '1'
     C                   Endif
     C                   Eval      CINDV = *Blanks
     C                   Move      *Blanks       CLSS
 
     C                   Write     MGOREFD0                             41
 
     C                   If        *IN41 = *ON
     C                   Z-ADD     1             DBASE                            * * * * * * *
     C                   MOVEL     'Write  '     DBKEY                            * DBERR 001 *
     C                   MOVEL     'MGOREFPD'    DBFILE                           * * * * * * *
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   Endif
 
     C                   ENDSR
      ********************************************************************
      /SPACE 5
      ********************************************************************
      * GetHierDet - Get Heirarchy Details                               *
      ********************************************************************
     C     GetHierDet    BEGSR
 
      ** Access hierarchy detail group detail record
 
     C                   CALLB     'RE100601'
      * Return code
      * Error Message
     C                   PARM                    X_RTCD
     C                   PARM                    X_ERMS
      * Option
     C*******************PARM      '*ONLYCM'     X_OPTN                         215205
     C                   PARM      '*ALL   '     X_OPTN                         215205
      * Hierarchy ID
     C                   PARM      IDHIER        I_HIER            9 0
      * Hierarchy Type
     C                   PARM                    I_HTYP            2
 
     C                   PARM                    O_CMHD
     C                   PARM                    O_ZSHD
     C                   PARM                    O_GAHD
 
      ** Database error if record not found
     C                   IF        X_RTCD = '*NOREC'
     C                   Z-ADD     16            DBASE                            * * * * * * *
     C                   MOVEL     '*CALL  '     DBKEY                            * DBERR 016 *
     C                   MOVEL     'RE101303'    DBFILE                           * * * * * * *
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   Endif
 
     C                   ENDSR
      *******************************************************************
      /SPACE 5
      *******************************************************************
      * GetAcctDet - Get Heirarchy Details                              *
      *******************************************************************
     C     GetAcctDet    BEGSR
 
     C                   MOVE      IDCCUS        WCusN
     C                   MOVE      IDCCCY        WCur
     C                   MOVE      IDCACD        WAcctCde
     C                   MOVE      IDCASN        WAcctSeq
     C                   MOVE      IDCBRC        WBrch
 
     C                   CALL      'AOACCTR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*KEY    '    POPTN
     C                   PARM                    WRetl
     C                   PARM                    WCusN
     C                   PARM                    WCur
     C                   PARM                    WAcctCde
     C                   PARM                    WAcctSeq
     C                   PARM                    WBrch
     C     ACCNT         PARM      ACCNT         DSSDY
 
      ** Error on call
 
     C     @RTCD         IFNE      *BLANK
     C     *LOCK         IN        LDA
     C                   Z-ADD     17            DBASE                            * * * * * * *
     C                   MOVEL     '*KEY '       DBKEY                            * DBERR 017 *
     C                   MOVEL     'ACCNTAB '    DBFILE                           * * * * * * *
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
     C
     C                   IF        ACNO <> 0
     C**********         Movel     ACNO          WAccount         18                          CGL029
     C                   Movel     ACNO          WAccount         24                          CGL029
     C                   Else
     C**********         Movel     ChildAccount  WAccount         18                          CGL029
     C                   Movel     ChildAccount  WAccount                                     CGL029
     C                   Endif
      *                                                                                     AR960455
      ** Save account number for tag 50K                                                    AR960455
      *                                                                                     AR960455
     C                   MOVE      *BLANKS       Wacnum                                     AR960455
     C                   IF        ACNO <> 0                                                AR960455
     C                   MOVEL     ACNO          Wacnum                                     AR960455
     C                   ENDIF                                                              AR960455
      *                                                                                     AR960455
     C
     C                   ENDSR
      ********************************************************************
      /SPACE 5                                                                  213196
      ********************************************************************      213196
      * Det_WrkDay - Determine if today is a working day in a/c currency *      213196
      ********************************************************************      213196
     C     Det_WrkDay    BEGSR                                                  213196
                                                                                213196
     C                   CALLB     'ZCHKH'                                      213196
     C                   PARM      BJRDNB        ZDAYNO            5 0          213196
     C                   PARM      IDCCCY        ZCCY              3            213196
     C                   PARM      *BLANK        ZLOC              3            213196
     C                   PARM      *BLANK        ZHOLID            1            213196
     C     ZHOLID        IFEQ      'H'                                          213196
     C                   MOVEL     'N'           Ac_Ccy_WrkDay     1            213196
     C                   ELSE                                                   213196
     C                   MOVEL     'Y'           Ac_Ccy_WrkDay                  213196
     C                   ENDIF                                                  213196
                                                                                213196
     C                   ENDSR                                                  213196
      ********************************************************************      213196
      /SPACE 5
      ********************************************************************
      * Det_Reply103  - Determine if this is a Reply to a received MT103 *
      *                 and if so, check if translation is present       *
      ********************************************************************
     C     Det_Reply103  BEGSR
      *
     C                   Move      *blanks       Reply103
      *  This is a reply to received MT101 if Incoming message reference
      *  is a MT101
     C     IDSMIR        Chain     MSIXI2L2                           70
      *
     C                   If        *IN70 = *Off And
     C                             MS_MTPY = '101'
      *
      *  Check translation record is present
     C                   Eval      WDest = %subst(IDDEST:1:11)
      *
     C     WDest         Chain     RETBDSL0                           70
      *
     C                   If        *IN70 = *ON
     C                   Select
     C                   When      %subst(WDest:9:3) = *blank
     C                   Eval      %subst(WDest:9:3) = 'XXX'
     C                   When      %subst(WDest:9:3) = 'XXX'
     C                   Eval      %subst(WDest:9:3) = *blank
     C                   Endsl
     C     WDest         Chain     RETBDSL0                           70
     C                   Endif
 
     C                   If        *IN70 = *Off
     C                   Movel     'Y'           Reply103
     C                   Endif
 
     C                   Endif
 
     C                   ENDSR
      *******************************************************************
      /SPACE 5
      *******************************************************************
      * GetDestCno - Get Destination  Customer Number                   *
      *******************************************************************
     C     GetDestCno    BEGSR
 
     C                   Select
      * Destination is Retail, get account number
     C                   When      I@MTPY <> '202'  And
     C                             IDDSTT = 'R'
 
     C                   MOVEL     IDDEST        WRetl
 
     C                   CALL      'AOACCTR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*KEY    '    POPTN
     C                   PARM                    WRetl
     C                   PARM      *blanks       WCusN
     C                   PARM      *blanks       WCur
     C                   PARM      *blanks       WAcctCde
     C                   PARM      *blanks       WAcctSeq
     C                   PARM      *blanks       WBrch
     C     ACCNT         PARM      ACCNT         DSSDY
 
      ** Error on call
 
     C     @RTCD         IFNE      *BLANK
     C     *LOCK         IN        LDA
     C                   Z-ADD     18            DBASE                            * * * * * * *
     C                   MOVEL     '*KEY '       DBKEY                            * DBERR 018 *
     C                   MOVEL     'ACCNTAB '    DBFILE                           * * * * * * *
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
     C
     C                   Movel     CNUM          SavDECN                        212316
     C*******************Movel     BBCUST        SavDECN                        212316
     C
     C* Destination is a Nostro
     C                   When      I@MTPY <> '202'  And
     C                             IDDSTT = 'N'
     C
     C                   Movel     IDDEST        @NONB
     C                   CALL      'AONOSTR0'
     C                   PARM      *BLANK        @RTCD             7
     C                   PARM      '*KEY   '     @OPTN             7
     C                   PARM      *BLANK        @CUST             6
     C                   PARM      IDCCCY        @CYCD             3
     C**********         PARM      *BLANK        @ACCD             4                          CGL029
     C                   PARM      *BLANK        @ACCD            10                          CGL029
     C                   PARM      *BLANK        @ACSN             2
     C                   PARM                    @NONB             2
     C                   PARM      *BLANK        @BRCD             3
     C                   PARM      *BLANK        @CSSN            10
     C                   PARM      *BLANK        @PNOI             1
     C     SDNOST        PARM      SDNOST        DSFDY
 
      ** Error on call
 
     C     @RTCD         IFNE      *BLANK
     C     *LOCK         IN        LDA
     C                   Z-ADD     19            DBASE                            * * * * * * *
     C                   MOVEL     '*KEY '       DBKEY                            * DBERR 019 *
     C                   MOVEL     'SDNOSTPD'    DBFILE                           * * * * * * *
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
     C
     C                   Movel     A7CUST        SavDECN
     C
     C
     C* Destination is a SWIFT Id, check if it can be attached w/ a cust no.
     C                   When      I@MTPY <> '202'  And
     C                             IDDSTT = 'S'
     C
     C                   MOVEL     IDDEST        WSwiftId         12
     C     WSwiftId      Chain     @CUSTGE                            44
     C*   Try removing branch 'XXX' if fails the first time.
     C                   If        *IN44 = *ON And
     C                             %Subst(WSwiftId : 9 : 3) = 'XXX'
     C                   Eval      %Subst(WSwiftId : 9 : 3) = '   '
     C     WSwiftId      Chain     @CUSTGE                            44
     C                   Endif
     C                   If        *IN44 = *OFF
     C                   Movel     BBCUST        SavDECN
     C                   Else
     C**********         Eval      SavDECN = 0                                                CSD027
     C                   Eval      SavDECN = *BLANKS                                          CSD027
     C                   Endif
     C
     C* Destination is nostro for Cover MT202s
     C                   When      I@MTPY = '202'
     C                   CALL      'AONOSTR0'
     C                   PARM      *BLANK        @RTCD             7
     C                   PARM      '*KEY   '     @OPTN             7
     C                   PARM      *BLANK        @CUST             6
     C                   PARM      IDCCCY        @CYCD             3
     C**********         PARM      *BLANK        @ACCD             4                          CGL029
     C                   PARM      *BLANK        @ACCD            10                          CGL029
     C                   PARM      *BLANK        @ACSN             2
     C                   PARM      IDSNDC        @NONB             2
     C                   PARM      *BLANK        @BRCD             3
     C                   PARM      *BLANK        @CSSN            10
     C                   PARM      *BLANK        @PNOI             1
     C     SDNOST        PARM      SDNOST        DSFDY
 
      ** Error on call
 
     C     @RTCD         IFNE      *BLANK
     C     *LOCK         IN        LDA
     C                   Z-ADD     20            DBASE                            * * * * * * *
     C                   MOVEL     '*KEY '       DBKEY                            * DBERR 020 *
     C                   MOVEL     'SDNOSTPD'    DBFILE                           * * * * * * *
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
     C
     C                   Movel     A7CUST        SavDECN
     C
     C                   ENDSL
     C
     C                   ENDSR
      ********************************************************************
      /SPACE 5
      ********************************************************************
      * SRClear -- Initialise workfields                                 *
      ********************************************************************
     C     SRClear       BEGSR
 
      *  Clear workfiels
     C**********         Move      *blanks       W202Decn          6 0                        CSD027
     C                   Move      *blanks       W202Decn          6                          CSD027
     C                   Move      *blanks       W202Nwds         20
 
      *  Clear Multiple Data structure
     C                   Eval      X = 1
     C                   Dow       X <= Q
     C     X             Occur     MULT
     C                   Eval      MTAG = *Blanks
     C                   Eval      MFLD = *Blanks
     C                   Eval      X = X + 1
     C                   Enddo
 
      * Key lists
 
     C                   ENDSR
      *******************************************************************
      /SPACE 5
      ********************************************************************
      * SRTrans-- Translate Reply MT103 field from MT101 field           *
      ********************************************************************
     C     SRTrans       BEGSR
      *
     C                   Eval      WMapFound  = 'N'
     C                   Eval      WMap = *blanks
     C                   Eval      KDest = WDest
      *
     C     KTBDD         Chain     RETBDDL1                           71
      *
     C                   If        *IN71 = *ON
     C                   Goto      EndSRTrans
      *
     C                   Else
      *
      *  If no transalation available do not proceed with this process  (TDSDEF is blank if
      *  translation is defined)
     C                   If        TDSDEF <> *BLANK
     C                   Goto      EndSRTrans
     C                   Endif
      *
      **  Get Message Unique Reference from MEINCRPD
      *
     C     IDSMIR        Chain     MEINCRL2                           72
      *
     C                   If        *IN72 = *ON Or
     C                             *IN72 = *Off And
     C                             CRDUPF='DUP'
     C                   Goto      EndSRTrans
      *
     C                   Else
      *
     C                   Eval      PHMSGR = CRMSGR
      *  Only one part is expected so default part to 1.
     C                   Eval      PHPART = 1
      *
      ** Call ME1100 to translate the data of the messages for FT
      ** fields.
      *
     C                   CALL      'ME1100'                             0101
     C                   Parm      '*TRANS  '    PACTD             8
     C                   PARM                    PHEAD
     C                   PARM      *BLANKS       PDATA
     C                   PARM      *BLANKS       PDAT2                                        CSW209
     C                   PARM      *BLANKS       PRTN              7
      *
      ** If call to program resulted in an error, then end program.
      *
     C     PRTN          IFEQ      '*ERROR*'
     C     *IN01         ANDEQ     *ON
     C                   Z-ADD     1             DBASE                            * * * * * * *
     C                   MOVEL     '*CALL  '     DBKEY                            * DBERR 001 *
     C                   MOVEL     'ME1100'      DBFILE                           * * * * * * *
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   Endif
      *
     C                   Eval      X = 1
      *
      * Proceed with mapping
      ** Fld 1
     C                   Eval      MapTag = TDMTG1
     C                   Eval      MapHeader = TDMTH1
     C                   Eval      FldCmp = TDFLD1
     C                   Exsr      SRMap
      *
     C                   If        WMapFound = 'Y'
     C                   Goto      EndSRTrans
     C                   Endif
      *
      ** Fld 2
      *
     C                   If        TDMTG2 <> *blank
     C                   Eval      MapTag = TDMTG2
     C                   Eval      MapHeader = TDMTH2
     C                   Eval      FldCmp = TDFLD2
     C                   Exsr      SRMap
     C                   If        WMapFound = 'Y'
     C                   Goto      EndSRTrans
     C                   Endif
     C                   Endif
      *
      ** Fld 3
      *
     C                   If        TDMTG3 = 'Y'
     C                   Eval      MapTag = TDMTG3
     C                   Eval      MapHeader = TDMTH3
     C                   Eval      FldCmp = TDFLD3
     C                   Exsr      SRMap
     C                   If        WMapFound = 'Y'
     C                   Goto      EndSRTrans
     C                   Endif
     C                   Endif
      *
      ** Fld 4
      *
     C                   If        TDMTG4 = 'Y'
     C                   Eval      MapTag = TDMTG4
     C                   Eval      MapHeader = TDMTH4
     C                   Eval      FldCmp = TDFLD4
     C                   Exsr      SRMap
     C                   If        WMapFound = 'Y'
     C                   Goto      EndSRTrans
     C                   Endif
     C                   Endif
      *
      ** Fld 5
      *
     C                   If        TDMTG5 = 'Y'
     C                   Eval      MapTag = TDMTG5
     C                   Eval      MapHeader = TDMTH5
     C                   Eval      FldCmp = TDFLD5
     C                   Exsr      SRMap
     C                   If        WMapFound = 'Y'
     C                   Goto      EndSRTrans
     C                   Endif
     C                   Endif
      *
      ** Fld 6
      *
     C                   If        TDMTG6 = 'Y'
     C                   Eval      MapTag = TDMTG6
     C                   Eval      MapHeader = TDMTH6
     C                   Eval      FldCmp = TDFLD6
     C                   Exsr      SRMap
     C                   If        WMapFound = 'Y'
     C                   Goto      EndSRTrans
     C                   Endif
     C                   Endif
      *
     C                   Endif
      *
     C                   Endif
      *
     C     EndSRTrans    ENDSR
      ********************************************************************
      /SPACE 5
      ********************************************************************
      * SRMap  -- Map specific field                                     *
      ********************************************************************
     C     SRMap         BEGSR
      *
     C                   Move      *Blanks       WMap
      *
     C                   Select
      *
      * MT103 :23E: Instruction Code
      * MT103 :26T: Transaction Type Code
      * MT103 :50F: Ordering Customer                                                         CSW207
      * MT103 :71A: Details of Charges
     C                   When      TDMT3T = ':23E:'  Or
     C                             TDMT3T = ':26T:'  Or
     C                             TDMT3T = ':50F:'  Or                                       CSW207
     C                             TDMT3T = ':71A:'
     C                   Eval      Z=1
     C     MapLookup     Lookup    TbTag(Z)                               73
     C                   If        *In73 = *Off
     C                   Goto      EndSRMap
     C                   Else
     C                   Exsr      SRDSTRAN
     C                   Movel     TMLIN         WMapLine1
     C                   Eval      WMapFound = 'Y'
     C                   Endif
      *
      * MT103 :32A: Value Date/Ccy/Interbank Settlement Amount
      *     Here, find 3 components: *DATE, *CCY and *AMT
      *
     C                   When      TDMT3T = ':32A:'
     C                   Eval      Z=1
     C     MapLookup     Lookup    TbTag(Z)                               73
     C
     C                   If        *In73 = *Off
     C                   Goto      EndSRMap
     C                   Else
     C
     C                   Exsr      SRDSTRAN
     C                   Movel     TbComp(Z)     TblCmp
     C
     C     '*DATE'       Scan      FldCmp                                 74
     C                   If        *In74 = *On Or
     C                             FldCmp = *Blank
     C     '*DATE'       Scan      TblCmp:1                               74
     C                   If        *IN74 = *On
     C                   If        TbDCA(Z) = 'D  '  Or
     C                             TbDCA(Z) = 'DCA'
     C                   Movel     TVVDAT        WDate
     C                   Endif
     C                   Endif
     C                   Endif
     C
     C     '*CCY'        Scan      FldCmp                                 74
     C                   If        *In74 = *On Or
     C                             FldCmp = *Blank
     C     '*CCY '       Scan      TblCmp:1                               74
     C                   If        *IN74 = *On
     C                   Select
     C                   When      TbDCA(Z) = 'CA '
     C                   Eval      WCcy = TTCA
     C                   When      TbDCA(Z) = 'DCA'
     C                   Eval      WCcy = TVCCY
     C                   Endsl
     C                   Endif
     C                   Endif
     C
     C     '*AMT'        Scan      FldCmp                                 74
     C                   If        *In74 = *On Or
     C                             FldCmp = *Blank
     C     '*AMT'        Scan      TblCmp:1                               74
     C                   If        *IN74 = *On
     C                   Select
     C                   When      TbDCA(Z) = 'CA '
     C                   Eval      WAmt = TTAMT
     C                   When      TbDCA(Z) = 'DCA'
     C                   Eval      WAmt = TVAMT
     C                   Endsl
     C                   Endif
     C                   Endif
     C
     C                   Endif
     C
     C                   If        Wdate <> *Blank And
     C                             WCcy  <> *Blank And
     C                             WAmt  <> *Blank
     C                   Movel     WDCA          WmapLine1
     C                   Eval      WMapFound = 'Y'
     C                   Endif
      *
      * MT103 :33B: Ccy/Instructed Amount
      * MT103 :71F: Sender's Charges
      * MT103 :71G: Receiver's Charges
      *
      *     Here, find 2 components:  *CCY and *AMT
     C
     C                   When      TDMT3T = ':33B:' Or
     C                             TDMT3T = ':71F:' Or
     C                             TDMT3T = ':71G:'
     C                   Eval      Z=1
     C     MapLookup     Lookup    TbTag(Z)                               73
     C
     C                   If        *In73 = *Off
     C                   Goto      EndSRMap
     C                   Else
     C
     C                   Exsr      SRDSTRAN
     C                   Movel     TbComp(Z)     TblCmp
     C                   Movel     TMLIN         WMapLine1
     C
     C     '*CCY'        Scan      FldCmp                                 74
     C                   If        *In74 = *On Or
     C                             FldCmp = *Blank
     C     '*CCY '       Scan      TblCmp:1                               74
     C                   If        *IN74 = *On
     C                   Select
     C                   When      TbDCA(Z) = 'CA '
     C                   Eval      WCcy = TTCA
     C                   When      TbDCA(Z) = 'DCA'
     C                   Eval      WCcy = TVCCY
     C                   Endsl
     C                   Endif
     C                   Endif
     C
     C     '*AMT'        Scan      FldCmp                                 74
     C                   If        *In74 = *On Or
     C                             FldCmp = *Blank
     C     '*AMT '       Scan      TblCmp:1                               74
     C                   If        *IN74 = *On
     C                   Select
     C                   When      TbDCA(Z) = 'CA '
     C                   Eval      WAmt = TTAMT
     C                   When      TbDCA(Z) = 'DCA'
     C                   Eval      WAmt = TVAMT
     C                   Endsl
     C                   Endif
     C                   Endif
     C
     C                   Endif
     C
     C                   If        WCcy  <> *Blank And
     C                             WAmt  <> *Blank
     C                   Movel     WCA           WmapLine1
     C                   Eval      WMapFound = 'Y'
     C                   Endif
      *
      * MT103 :50a: Ordering Customer
      * MT103 :52a: Ordering Institution
      * MT103 :53a: Sender's Correspondent
      * MT103 :54a: Receiver's Correspondent
      * MT103 :55a: Receiver's Correspondent
      * MT103 :56a: Receiver's Correspondent
      * MT103 :57a: Receiver's Correspondent
      * MT103 :59a: Receiver's Correspondent
      *     Option A, find 2 components: *ACLIN and *BIC
      *     Option D/K/blank find 2 components: *ACLIN and *NAMAD
      *     or alternatively, the *NAME (without the address part)              211499
     C
     C                   When      TDMT3T = ':50A:'  Or
     C                             TDMT3T = ':50K:'  Or
     C                             TDMT3T = ':51A:'  Or
     C                             TDMT3T = ':52A:'  Or
     C                             TDMT3T = ':52D:'  Or
     C                             TDMT3T = ':53A:'  Or
     C                             TDMT3T = ':52D:'  Or
     C                             TDMT3T = ':54A:'  Or
     C                             TDMT3T = ':54D:'  Or
     C                             TDMT3T = ':56A:'  Or
     C                             TDMT3T = ':56C:'  Or
     C                             TDMT3T = ':56D:'  Or
     C                             TDMT3T = ':57A:'  Or
     C                             TDMT3T = ':57C:'  Or
     C                             TDMT3T = ':57D:'  Or
     C                             TDMT3T = ':59A:'  Or
     C                             TDMT3T = ':59F:'  OR                                       CSW215
     C                             TDMT3T = ':59:'
     C
     C                   Eval      Z=1
     C     MapLookup     Lookup    TbTag(Z)                               73
     C
     C                   If        *In73 = *Off
     C                   Goto      EndSRMap
     C                   Else
     C
     C                   Exsr      SRDSTRAN
     C                   Movel     TbComp(Z)     TblCmp
     C
     C     '*ACLIN'      Scan      FldCmp                                 74
     C                   If        *In74 = *On Or
     C                             FldCmp = *Blank
     C     '*ACLIN'      Scan      TblCmp:1                               74
     C                   If        *IN74 = *On And
     C                             %subst(TMLIN1:1:1) = '/'
     C                   Eval      WMapLine1 = TMLIN1
     C                   Endif
     C                   Endif
 
     C                   If        TDMT3T = ':56C:' OR
     C                             TDMT3T = ':57C:'
     C                   Eval      WMapFound = 'Y'
     C                   Endif
     C
     C                   If        TDMT3T= ':50A:'  Or
     C                             TDMT3T= ':51A:'  Or
     C                             TDMT3T= ':52A:'  Or
     C                             TDMT3T= ':53A:'  Or
     C                             TDMT3T= ':54A:'  Or
     C                             TDMT3T= ':56A:'  Or
     C                             TDMT3T= ':57A:'  Or
     C                             TDMT3T= ':59A:'
 
     C     '*BIC'        Scan      FldCmp                                 74
     C                   If        *In74 = *On Or
     C                             FldCmp = *Blank
     C     '*BIC'        Scan      TblCmp:1                               74
     C
     C                   If        *IN74 = *On   And
     C                             %subst(TMLIN1:1:1) <> '/'
     C                   If        WMapLine1 = *Blank
     C                   Eval      WMapLine1 = TMLIN1
     C                   Else
     C                   Eval      WMapLine2 = TMLIN1
     C                   Endif
     C                   Eval      WMapFound = 'Y'
     C                   Endif
     C
     C                   If        *IN74 = *On   And
     C                             %subst(TMLIN1:1:1) = '/'
     C                   If        WMapLine1 = *Blank
     C                   Eval      WMapLine1 = TMLIN2
     C                   Else
     C                   Eval      WMapLine2 = TMLIN2
     C                   Endif
     C                   Eval      WMapFound = 'Y'
     C                   Endif
     C                   Endif
     C
     C                   Endif
     C
     C                   IF        CSW215 = 'Y' AND                                           CSW215
     C                             TDMT3T = ':59F:'                                           CSW215
     C                   EVAL      WMapLine1 = TMLIN1                                         CSW215
     C                   EVAL      WMapLine2 = TMLIN2                                         CSW215
     C                   EVAL      WMapLine3 = TMLIN3                                         CSW215
     C                   EVAL      WMapLine4 = TMLIN4                                         CSW215
     C                   EVAL      WMapLine5 = TMLIN5                                         CSW215
     C                   EVAL      WMapFound = 'Y'                                            CSW215
     C                   ENDIF                                                                CSW215
                                                                                              CSW215
     C                   If        TDMT3T= ':50K:' Or
     C                             TDMT3T= ':52D:' Or
     C                             TDMT3T= ':53D:' Or
     C                             TDMT3T= ':54D:' Or
     C                             TDMT3T= ':56D:' Or
     C                             TDMT3T= ':57D:' Or
     C                             TDMT3T= ':59:'
     C                                                                          211499
     C     '*NAME'       Scan      FldCmp                                 74    211499
     C                   If        *In74 = *On Or                               211499
     C                             FldCmp = *Blank                              211499
     C     '*NAME'       Scan      TblCmp:1                               74    211499
     C                                                                          211499
     C                   If        *IN74 = *On   And                            211499
     C                             %subst(TMLIN1:1:1) <> '/'                    211499
     C                   If        WMapLine1 = *Blank                           211499
     C                   Eval      WMapLine1 = TMLIN1                           211499
     C                   Else                                                   211499
     C                   Eval      WMapLine2 = TMLIN1                           211499
     C                   Endif                                                  211499
     C                   Eval      WMapFound = 'Y'                              211499
     C                   Endif                                                  211499
     C                                                                          211499
     C                   If        *IN74 = *On   And                            211499
     C                             %subst(TMLIN1:1:1) = '/'                     211499
     C                   If        WMapLine1 = *Blank                           211499
     C                   Eval      WMapLine1 = TMLIN2                           211499
     C                   Else                                                   211499
     C                   Eval      WMapLine2 = TMLIN2                           211499
     C                   Endif                                                  211499
     C                   Eval      WMapFound = 'Y'                              211499
     C                   Endif                                                  211499
     C                   Endif                                                  211499
 
     C     '*NAMAD'      Scan      FldCmp                                 74
     C                   If        *In74 = *On Or
     C                             FldCmp = *Blank
     C     '*NAMAD'      Scan      TblCmp:1                               74
     C
     C                   If        *IN74 = *On   And
     C                             %subst(TMLIN1:1:1) <> '/'
     C                   If        WMapLine1 = *Blank
     C                   Eval      WMapLine1 = TMLIN1
     C                   Eval      WMapLine2 = TMLIN2
     C                   Eval      WMapLine3 = TMLIN3
     C                   Eval      WMapLine4 = TMLIN4
     C                   Else
     C                   Eval      WMapLine2 = TMLIN1
     C                   Eval      WMapLine3 = TMLIN2
     C                   Eval      WMapLine4 = TMLIN3
     C                   Eval      WMapLine5 = TMLIN4
     C                   Endif
     C                   Eval      WMapFound = 'Y'
     C                   Endif
     C
     C                   If        *IN74 = *On   And
     C                             %subst(TMLIN1:1:1) = '/'
     C                   If        WMapLine1 = *Blank
     C                   Eval      WMapLine1 = TMLIN2
     C                   Eval      WMapLine2 = TMLIN3
     C                   Eval      WMapLine3 = TMLIN4
     C                   Eval      WMapLine4 = TMLIN5
     C                   Else
     C                   Eval      WMapLine2 = TMLIN2
     C                   Eval      WMapLine3 = TMLIN3
     C                   Eval      WMapLine4 = TMLIN4
     C                   Eval      WMapLine5 = TMLIN5
     C                   Endif
     C                   Eval      WMapFound = 'Y'
     C                   Endif
     C                   Endif
     C
     C                   Endif
      *
     C                   Endif
      *
      * MT103 :70: Details of Payment
      * MT103 :72: Bank to Bank Information
      * MT103 :77B: Regulatory Reporting
      *
      *      Find 4 components, *LINE1-4
     C
     C                   When      TDMT3T = ':70:' Or
     C                             TDMT3T = ':72:' Or
     C                             TDMT3T = ':77B:'
     C
     C                   Eval      Z=1
     C     MapLookup     Lookup    TbTag(Z)                               73
     C
     C                   If        *In73 = *Off
     C                   Goto      EndSRMap
     C                   Else
     C
     C                   Exsr      SRDSTRAN
     C                   Eval      N = 1
     C                   MoveA     *BLANKS       ALINE
     C
     C     '*LINE1'      Scan      FldCmp                                 74
     C                   If        *In74 = *On Or
     C                             FldCmp = *Blank
     C                   If        TMLIN1 <> *Blank
     C                   Eval      ALINE(N) = TMLIN1
     C                   Eval      WMapLine1= ALINE(N)
     C                   Eval      N = N+1
     C                   Endif
     C                   Endif
     C
     C     '*LINE2'      Scan      FldCmp                                 74
     C                   If        *In74 = *On Or
     C                             FldCmp = *Blank
     C                   If        TMLIN2 <> *Blank
     C                   Eval      ALINE(N) = TMLIN2
     C                   Eval      WMapLine2= ALINE(N)
     C                   Eval      N = N+1
     C                   Endif
     C                   Endif
     C
     C     '*LINE3'      Scan      FldCmp                                 74
     C                   If        *In74 = *On Or
     C                             FldCmp = *Blank
     C                   If        TMLIN3 <> *Blank
     C                   Eval      ALINE(N) = TMLIN3
     C                   Eval      WMapLine3= ALINE(N)
     C                   Eval      N = N+1
     C                   Endif
     C                   Endif
     C
     C     '*LINE4'      Scan      FldCmp                                 74
     C                   If        *In74 = *On Or
     C                             FldCmp = *Blank
     C                   If        TMLIN4 <> *Blank
     C                   Eval      ALINE(N) = TMLIN4
     C                   Eval      WMapLine4= ALINE(N)
     C                   Eval      N = N+1
     C                   Endif
     C                   Endif
     C
     C                   Movel     'Y'           WMapFound
     C                   Endif
     C
     C                   Endsl
      *
     C     EndSRMap      ENDSR
      ********************************************************************
      /SPACE 5
      ********************************************************************
      * SRWADF  -- Format SWIFT Address                                  *
      ********************************************************************
     C     SWADF         BEGSR
      *
      **  Address 1
     C     ZSADD1        IFNE      *blanks
     C                   MOVEL     ZSADD1        MFLD
     C                   END
      **  Abdress 2
     C     ZSADD2        IFNE      *blanks
     C                   ADD       1             Q
     C     Q             Occur     MULT
     C                   MOVEL     ZSADD2        MFLD
     C                   END
      **  Address 3
     C     ZSADD3        IFNE      *blanks
     C                   ADD       1             Q
     C     Q             Occur     MULT
     C                   MOVEL     ZSADD3        MFLD
     C                   END
      **  Address 4
     C     ZSADD4        IFNE      *blanks
     C                   ADD       1             Q
     C     Q             Occur     MULT
     C                   MOVEL     ZSADD4        MFLD
     C                   END
      *
     C                   ENDSR
      ********************************************************************
      /SPACE 5
      ********************************************************************                    CSW209
      * MAPLN  -- Message Data Mappings for MT202 COV                    *                    CSW209
      ********************************************************************                    CSW209
     C     MAPLN         BEGSR                                                                CSW209
      *                                                                                       CSW209
      **  Line 1                                                                              CSW209
     C     MAPLN1        IFNE      *blanks                                                    CSW209
     C                   MOVEL     MAPLN1        MFLD                                         CSW209
     C                   END                                                                  CSW209
      **  Line 2                                                                              CSW209
     C     MAPLN2        IFNE      *blanks                                                    CSW209
     C                   ADD       1             Q                                            CSW209
     C     Q             Occur     MULT                                                       CSW209
     C                   MOVEL     MAPLN2        MFLD                                         CSW209
     C                   END                                                                  CSW209
      **  Line 3                                                                              CSW209
     C     MAPLN3        IFNE      *blanks                                                    CSW209
     C                   ADD       1             Q                                            CSW209
     C     Q             Occur     MULT                                                       CSW209
     C                   MOVEL     MAPLN3        MFLD                                         CSW209
     C                   END                                                                  CSW209
      **  Line 4                                                                              CSW209
     C     MAPLN4        IFNE      *blanks                                                    CSW209
     C                   ADD       1             Q                                            CSW209
     C     Q             Occur     MULT                                                       CSW209
     C                   MOVEL     MAPLN4        MFLD                                         CSW209
     C                   END                                                                  CSW209
      **  Line 5                                                                              CSW209
     C     MAPLN5        IFNE      *blanks                                                    CSW209
     C                   ADD       1             Q                                            CSW209
     C     Q             Occur     MULT                                                       CSW209
     C                   MOVEL     MAPLN5        MFLD                                         CSW209
     C                   END                                                                  CSW209
      *                                                                                       CSW209
     C                   ENDSR                                                                CSW209
      ********************************************************************                    CSW209
      /SPACE 5                                                                                CSW209
      ********************************************************************
      * SRDSTRAN - Move MT101 field contents to DS/DSTRAN                *
      ********************************************************************
     C     SRDSTRAN      BEGSR
      *
     C                   Select
      *
     C                   When      TbDSF(Z) = 'PH20 '
     C                   Movel     PH20          DSTRAN
      *
     C                   When      TbDSF(Z) = 'PH21R'
     C                   Movel     PH21R         DSTRAN
      *
     C                   When      TbDSF(Z) = 'PH50L'
     C                   Movel     PH21R         DSTRAN
      *
     C                   When      TbDSF(Z) = 'PH50 '
     C                   Movel     PH50          DSTRAN
      *
     C                   When      TbDSF(Z) = 'PH52 '
     C                   Movel     PH52          DSTRAN
      *
     C                   When      TbDSF(Z) = 'PH51A'
     C                   Movel     PH51A         DSTRAN
      *
     C                   When      TbDSF(Z) = 'PH30 '
     C                   Movel     PH30          DSTRAN
      *
     C                   When      TbDSF(Z) = 'PH25 '
     C                   Movel     PH25          DSTRAN
      *
     C                   When      TbDSF(Z) = 'P21  '
     C                   Movel     P21           DSTRAN
      *
     C                   When      TbDSF(Z) = 'P21F '
     C                   Movel     P21F          DSTRAN
      *
     C                   When      TbDSF(Z) = 'P23E '
     C                   Movel     P23E          DSTRAN
      *
     C                   When      TbDSF(Z) = 'P32B '
     C                   Movel     P32B          DSTRAN
      *
     C                   When      TbDSF(Z) = 'P50L '
     C                   Movel     P50L          DSTRAN
      *
     C                   When      TbDSF(Z) = 'P50  '
     C                   Movel     P50           DSTRAN
      *
     C                   When      TbDSF(Z) = 'P52  '
     C                   Movel     P52           DSTRAN
      *
     C                   When      TbDSF(Z) = 'P56  '
     C                   Movel     P56           DSTRAN
      *
     C                   When      TbDSF(Z) = 'P57  '
     C                   Movel     P57           DSTRAN
      *
     C                   When      TbDSF(Z) = 'P59  '
     C                   Movel     P59           DSTRAN
      *
     C                   When      TbDSF(Z) = 'P70  '
     C                   Movel     P70           DSTRAN
      *
     C                   When      TbDSF(Z) = 'P77B '
     C                   Movel     P77B          DSTRAN
      *
     C                   When      TbDSF(Z) = 'P33B '
     C                   Movel     P33B          DSTRAN
      *
     C                   When      TbDSF(Z) = 'P71  '
     C                   Movel     P71           DSTRAN
      *
     C                   When      TbDSF(Z) = 'P25A '
     C                   Movel     P25A          DSTRAN
      *
     C                   When      TbDSF(Z) = 'P36  '
     C                   Movel     P36           DSTRAN
      *
     C                   Endsl
      *
     C                   ENDSR
      ********************************************************************
      /SPACE 5                                                                  216421
      ********************************************************************      216421
      * Determine Message Sequence No. (for messages generated by RE100608)     216421
      ********************************************************************      216421
     C     DET_MSGSEQ    BEGSR                                                  216421
     C                   Z-ADD     1             MsgSeq                         216421
     C                   Eval      M_Trno = 'RE' + %SUBST(Reference:4:6) +      216421
     C                                       WMgde + MsgSeqA                    216421
     C     M_Trno        CHAIN     MGOREFSQ                           99        216421
     C     *in99         DOWEQ     '0'                                          216421
     C                   ADD       1             MsgSeq                         216421
     C                   MOVE      MsgSeqA       M_Trno                         216421
     C     M_Trno        CHAIN     MGOREFSQ                           99        216421
     C                   ENDDO                                                  216421
     C                   ENDSR                                                  216421
      *******************************************************************       216421
      /SPACE 5                                                                  216421
      ********************************************************************      216421
      * Adjust value date (for messages generated by RE100608)                  216421
      ********************************************************************      216421
     C     ADJ_VALD      BEGSR                                                  216421
                                                                                216421
      * If a top (credit) to the top a/c, value date = today             101    216421
      * If a sweep (debit) from the top a/c, value date = today + offset 103    216421
      *   (If deferred posting use value date from REICSDPD as                  215205
      *    start date for calculations. Otherwise use run date.)                215205
                                                                                216421
     C     IDTPSW        IFEQ      'T'                                          216421
     C     ZDDEFP        IFEQ      'Y'                                          215205
     C                   Z-ADD     IDVALD        AdjValDate        5 0          215205
     C                   ELSE                                                   215205
     C                   Z-ADD     BJRDNB        AdjValDate                     215205
     C                   ENDIF                                                  215205
     C*******************Z-ADD     BJRDNB        IDVALD                  216421 215205
     C                   ELSE                                                   216421
     C     ZDDEFP        IFEQ      'Y'                                          215205
     C                   Z-ADD     IDVALD        ZDAYNO                         215205
     C                   ELSE                                                   215205
     C                   Z-ADD     BJRDNB        ZDAYNO                         215205
     C                   ENDIF                                                  215205
     C                   Z-ADD     *ZERO         ZNRDYS                         216421
     C                   MOVE      ZDMVDO        ZNRDYS                         216421
     C                   CALLB     'ZFWDT'                                      216421
     C*******************PARM      BJRDNB        ZDAYNO            5 0   216421 215205
     C                   PARM                    ZDAYNO            5 0          215205
     C                   PARM                    ZNRDYS            2 0          216421
     C                   PARM      *ZERO         ZDYNBR            5 0          216421
     C                   PARM      BJLCCY        ZCCY              3            216421
     C                   PARM      BJSLCD        ZLOC              3            216421
     C                   Z-ADD     ZDYNBR        AdjValDate                     215205
     C*******************Z-ADD     ZDYNBR        IDVALD                  216421 215205
     C                   ENDIF                                                  216421
                                                                                216421
     C                   ENDSR                                                  216421
      *******************************************************************       216421
      /SPACE 5
      ********************************************************************
      * Log an event
      ********************************************************************
     C     LOGEVENT      BEGSR
 
      * 'Cash management input cycle sweeping - message(s) generated'
     C                   EVAL      #MSGID = 'RE75428 '
 
      * Get the message details
 
     C                   CALLB     'ZAMSGRTVMS'
     C                   PARM      *BLANK        ReturnCode       10
     C                   PARM      *BLANK        CompMsg        3000
     C                   PARM                    #MSGID
     C                   PARM                    #MSGDT          256
     C                   PARM      'GBREUSRMSG'  #MSGF            10
     C                   PARM      '*LIBL  '     #MSGFL           10
     C                   PARM      '0'           Level             1
 
      * Write an INFORMATION record to the input cycle sweeps log file
 
     C                   Z-ADD     PSRunDate     ILDATE
     C                   TIME                    CurTIME           6 0
     C                   Z-ADD     CurTIME       ILTIME
     C                   MOVE      'I'           ILTYPE
     C                   MOVEL     CompMsg       ILNARR
     C                   MOVEL     PSJobName     ILJBNM
     C                   MOVEL     PSUser        ILJBUS
     C                   MOVEL     PSJobNo       ILJBNO
     C                   WRITE     REICSLD0
 
     C                   ENDSR
      ********************************************************************
      * Determine Charge Amount                                                 213569
      ********************************************************************      213569
     C     Det_ChgAmt    BEGSR                                                  213569
      *                                                                         213569
     C                   EVAL      ChgAmount = IDCAMT                           213569
      *                                                                         213569
      * Convert if  charge amount is in a different currency                    213569
      * (This happens when the MT101/3 Charge account is defined and it         213569
      * is in a different currency than that of the hierarchy's)                213569
     C                   If        %Subst(IDCACT : 10: 3) <> IDCCCY             213569
     C                             And IDCAMT <> 0                              213569
     C                             And IDCACT <> *blank                         213569
     C                   CLEAR                   P#0010                         213569
     C                   Eval      P#FRCY = %subst(IDCACT:10:3)                 213569
     C                   Z-ADD     IDCAMT        P#FRAM                         213569
     C                   MOVEL     IDCCCY        P#TOCY                         213569
                                                                                213569
     C                   CALL      'FT0010'                                     213569
     C                   PARM                    P#0010                         213569
                                                                                213569
     C                   If        P#RTCD <> *blanks                            213569
     C     *LOCK         IN        LDA                                          213569
     C                   Z-ADD     29            DBASE                          213569
     C                   MOVEL     '*CALL'       DBKEY                          213569
     C                   MOVEL     'FT0010'      DBFILE                         213569
     C                   OUT       LDA                                          213569
     C                   EXSR      *PSSR                                        213569
     C                   Else                                                   213569
     C                   Z-add     P#TOAM        ChgAmount                      213569
     C                   ENDIF                                                  213569
     C                   ENDIF                                                  213569
                                                                                213569
     C                   Endsr                                                  213569
      ********************************************************************                    CSW215
      * SrFormat59F - Format Beneficiary with 59F                                             CSW215
      ********************************************************************                    CSW215
     C     SrFormat59F   BEGSR                                                                CSW215
     C                   CALL      'MG001001'                                                 CSW215
     C                   PARM      *BLANKS       PRTCD                                        CSW215
     C                   PARM      'FRMT'        PCallFr                                      CSW215
     C                   PARM                    PInpParm1                                    CSW215
     C                   PARM                    PInpParm2                                    CSW215
     C                   PARM                    PInpParm3                                    CSW215
     C                   PARM                    PInpParm4                                    CSW215
     C                   PARM                    PInpParm5                                    CSW215
     C                   PARM      NWRK          PNetWrk                                      CSW215
     C                   PARM                    PMsgTyp                                      CSW215
     C                   PARM      ':59F:'       PMsgTag                                      CSW215
     C                   PARM      CDBRCA        PBranch                                      CSW215
     C                   PARM      PCountry      PCount                                       CSW215
     C                   PARM      IDCCCY        PCurr                                        CSW215
     C                   PARM      *BLANKS       PNost                                        CSW215
     C                   PARM      *BLANKS       PoutParm1                                    CSW215
     C                   PARM      *BLANKS       PoutParm2                                    CSW215
     C                   PARM      *BLANKS       PoutParm3                                    CSW215
     C                   PARM      *BLANKS       PoutParm4                                    CSW215
     C                   PARM      *BLANKS       PoutParm5                                    CSW215
     C                   PARM      *BLANKS       PMsID                                        CSW215
     C                   PARM      *BLANKS       PErrType                                     CSW215
                                                                                              CSW215
     C                   IF        PRTCD = *BLANKS                                            CSW215
     C                   EVAL      Wrk59F = 'Y'                                               CSW215
     C                   ENDIF                                                                CSW215
     C                   ENDSR                                                                CSW215
      ********************************************************************                    CSW215
      * SRInit59F - Initialise Input parameters for 59F                                       CSW215
      ********************************************************************                    CSW215
     C     SRInit59F     BEGSR                                                                CSW215
     C                   EVAL      PInpParm1 = *BLANKS                                        CSW215
     C                   EVAL      PInpParm2 = *BLANKS                                        CSW215
     C                   EVAL      PInpParm3 = *BLANKS                                        CSW215
     C                   EVAL      PInpParm4 = *BLANKS                                        CSW215
     C                   EVAL      PInpParm5 = *BLANKS                                        CSW215
     C                   ENDSR                                                                CSW215
      ********************************************************************                    CSW215
      * SRMT103F - Process MT103 checking if in 59F Format                                    CSW215
      ********************************************************************                    CSW215
     C     SRMT103F      BEGSR                                                                CSW215
     C                   EVAL      Wrk59F = 'N'                                               CSW215
     C                   IF        CSW215 = 'Y'                                               CSW215
     C                   EXSR      SRInit59F                                                  CSW215
     C                   EVAL      PInpParm1 = IDEXA1                                         CSW215
     C                   EVAL      PInpParm2 = IDEXA2                                         CSW215
     C                   EVAL      PInpParm3 = IDEXA3                                         CSW215
     C                   EVAL      PInpParm4 = IDEXA4                                         CSW215
     C                   EVAL      PInpParm5 = IDEXA5                                         CSW215
     C                   IF        (%SUBST(PInpParm1:1:1) = '/'                               CSW215
     C                             AND %SUBST(PInpParm2:1:2) = '1/')                          CSW215
     C                             OR %SUBST(PInpParm1:1:2) = '1/'                            CSW215
     C                   EVAL      Wrk59F = 'Y'                                               CSW215
     C                   EVAL      POutParm1 = PInpParm1                                      CSW215
     C                   EVAL      POutParm2 = PInpParm2                                      CSW215
     C                   EVAL      POutParm3 = PInpParm3                                      CSW215
     C                   EVAL      POutParm4 = PInpParm4                                      CSW215
     C                   EVAL      POutParm5 = PInpParm5                                      CSW215
     C                   ELSE                                                                 CSW215
     C                   EVAL      PMsgTyp = '103'                                            CSW215
     C                   EXSR      SrFormat59F                                                CSW215
     C                   ENDIF                                                                CSW215
     C                   ENDIF                                                                CSW215
     C                   ENDSR                                                                CSW215
      ********************************************************************                    CSW215
      * SROut59F - Output Beneficiary in 59F format                                           CSW215
      ********************************************************************                    CSW215
     C     SROut59F      BEGSR                                                                CSW215
     C                   EVAL      Q = Q + 1                                                  CSW215
     C     Q             OCCUR     MULT                                                       CSW215
     C                   EVAL      MTAG = ':59F:'                                             CSW215
     C                   EVAL      MFLD = POutParm1                                           CSW215
                                                                                              CSW215
     C                   IF        POutParm2 <> *BLANKS                                       CSW215
     C                   EVAL      Q = Q + 1                                                  CSW215
     C     Q             OCCUR     MULT                                                       CSW215
     C                   EVAL      MFLD = POutParm2                                           CSW215
     C                   ENDIF                                                                CSW215
     C                   IF        POutParm3 <> *BLANKS                                       CSW215
     C                   EVAL      Q = Q + 1                                                  CSW215
     C     Q             OCCUR     MULT                                                       CSW215
     C                   EVAL      MFLD = POutParm3                                           CSW215
     C                   ENDIF                                                                CSW215
     C                   IF        POutParm4 <> *BLANKS                                       CSW215
     C                   EVAL      Q = Q + 1                                                  CSW215
     C     Q             OCCUR     MULT                                                       CSW215
     C                   EVAL      MFLD = POutParm4                                           CSW215
     C                   ENDIF                                                                CSW215
     C                   IF        POutParm5 <> *BLANKS                                       CSW215
     C                   EVAL      Q = Q + 1                                                  CSW215
     C     Q             OCCUR     MULT                                                       CSW215
     C                   EVAL      MFLD = POutParm5                                           CSW215
     C                   ENDIF                                                                CSW215
                                                                                              CSW215
     C                   IF        WMsgType = '103'                                           CSW215
     C                   EVAL      MTAG59X = ':59F:'                                          CSW215
     C                   EVAL      ADD59X1 = POutParm1                                        CSW215
     C                   EVAL      ADD59X2 = POutParm2                                        CSW215
     C                   EVAL      ADD59X3 = POutParm3                                        CSW215
     C                   EVAL      ADD59X4 = POutParm4                                        CSW215
     C                   EVAL      ADD59X5 = POutParm5                                        CSW215
     C                   ENDIF                                                                CSW215
     C                   ENDSR                                                                CSW215
      ********************************************************************                    CSW215
      /SPACE 5
      ********************************************************************
      * *INZSR --- INITIAL PROCESSING                                    *
      ********************************************************************
     C     *INZSR        BEGSR
 
      *  Access Bank Details
 
     C                   CALL      'AOBANKR0'
     C                   PARM      '*DBERR  '    @RTCD             7
     C                   PARM      '*FIRST  '    @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
      *
      ** If no record is found on SDBANKPD.
      *
     C     @RTCD         IFNE      *BLANKS
     C     *LOCK         IN        LDA
     C                   Z-ADD     21            DBASE                            * * * * * * *
     C                   MOVEL     'FIRST'       DBKEY                            * DBERR 021 *
     C                   MOVEL     'SDBANKPD'    DBFILE                           * * * * * * *
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   END
      *
      **  Access SDMGMEPD for drop SWIFT msg. no. days
      *
     C                   CALL      'AOMGMER0'
     C                   PARM      '*DBERR '     @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C     SDMGME        PARM      SDMGME        DSFDY
      *
      ** If no record is found on SDMGMEPD.
      *
     C     @RTCD         IFNE      *BLANKS
     C     *LOCK         IN        LDA
     C                   Z-ADD     22            DBASE                            * * * * * * *
     C                   MOVEL     'FIRST'       DBKEY                            * DBERR 022 *
     C                   MOVEL     'SDMGMEPD'    DBFILE                           * * * * * * *
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   END
 
      *  Access Cash Management Details
 
     C                   CALLB     'AOCMANR0'
     C                   PARM      '*DBERR  '    @RTCD             7
     C                   PARM      '*FIRST  '    @OPTN             7
     C     SDCMAN        PARM      SDCMAN        DSSDY
      *
      ** If no record is found on SDCMANPD.
      *
     C     @RTCD         IFNE      *BLANKS
     C     *LOCK         IN        LDA
     C                   Z-ADD     23            DBASE                            * * * * * * *
     C                   MOVEL     'FIRST'       DBKEY                            * DBERR 023 *
     C                   MOVEL     'SDCMANPD'    DBFILE                           * * * * * * *
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   END
 
      *  Access Retail Details
 
     C                   CALL      'AORETLR0'
     C                   PARM      '*DBERR  '    @RTCD             7
     C                   PARM      '*FIRST  '    @OPTN             7
     C     SDRETL        PARM      SDRETL        DSFDY
      *
      ** If no record is found on SDRETLPD.
      *
     C     @RTCD         IFNE      *BLANKS
     C     *LOCK         IN        LDA
     C                   Z-ADD     24            DBASE                            * * * * * * *
     C                   MOVEL     'FIRST'       DBKEY                            * DBERR 024 *
     C                   MOVEL     'SDRETLPD'    DBFILE                           * * * * * * *
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   END
      *
      **  Convert history retention date to YYMMDD
      *
     C     BJRDNB        ADD       ENDSMN        ZMDAY
     C                   CALL      'ZM0060'                             15
     C                   PARM                    ZMDAY             5 0
     C                   PARM                    ZMDATE            6
      *
      ** If the program ends in error.
      *
     C     *IN15         IFEQ      '1'
     C     *LOCK         IN        LDA
     C                   Z-ADD     25            DBASE                            * * * * * * *
     C                   MOVEL     '       '     DBKEY                            * DBERR 025 *
     C                   MOVEL     'ZM0060'      DBFILE                           * * * * * * *
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   END
     C                   MOVE      ZMDATE        @HRDT             6
      *
     C                   Eval      ZMDAY = BJRDNB
     C                   CALL      'ZM0060'                             15
     C                   PARM                    ZMDAY
     C                   PARM                    ZMDATE
      *
      ** If the program ends in error.
      *
     C     *IN15         IFEQ      '1'
     C     *LOCK         IN        LDA
     C                   Z-ADD     26            DBASE                            * * * * * * *
     C                   MOVEL     '       '     DBKEY                            * DBERR 026 *
     C                   MOVEL     'ZM0060'      DBFILE                           * * * * * * *
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   END
     C                   MOVE      ZMDATE        MGDE
     C                   MOVE      ZMDATE        Wmgde             6
 
     C     KTBDD         Klist
     C                   Kfld                    KDest
     C                   Kfld                    KTag
 
      ** Check if SWIFT 2015 is installed                                                     CSW215
                                                                                              CSW215
     C                   EVAL      CSW215 = 'N'                                               CSW215
     C                   CALL      'SWIF2015'                                                 CSW215
     C                   PARM      *BLANKS       PRTCD                                        CSW215
                                                                                              CSW215
     C                   IF        PRTCD = 'CSW2015'                                          CSW215
     C                   EVAL      CSW215 = 'Y'                                               CSW215
     C                   ENDIF                                                                CSW215
                                                                                              CSW215
      ** Check if SWIFT 2018 is installed                                                     CSW218
      *                                                                                       CSW218
     C                   EVAL      CSW218 = 'N'                                               CSW218
     C                   CALL      'SWIF2018'                                                 CSW218
     C                   PARM      *BLANKS       PRTCD                                        CSW218
                                                                                              CSW218
     C                   IF        PRTCD = 'CSW2018'                                          CSW218
     C                   EVAL      CSW218 = 'Y'                                               CSW218
     C                   ENDIF                                                                CSW218
                                                                                              CSW218
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * *PSSR  - Program exception error routine                      *
      *          Called automatically if a program error occurs,      *
      *          or directly by the program code using EXSR.          *
      *          This subroutine DUMPs the program just once.         *
      *****************************************************************
     C     *PSSR         BEGSR
 
     C                   DUMP
 
     C                   IF        RunBefore = *BLANK
     C                   EVAL      RunBefore = 'Y'
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   ENDIF
 
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   EXSR      SREND
 
     C                   ENDSR
      /EJECT                                                                                AR960455
      *****************************************************************                     AR960455
      * FormAccnt - This will format tag 50K                          *                     AR960455
      *                                                               *                     AR960455
      *****************************************************************                     AR960455
     C     FormAccnt     BEGSR                                                              AR960455
     C                   MOVEL     '/'           Wacnum2                                    AR960455
     C                   MOVE      Wacnum        Wacnum2                                    AR960455
     C                   MOVEL     Wacnum2       MFLD                                       AR960455
      **  Address 1                                                                         AR960455
     C                   If        ZSADD1 <> *BLANKS                                        AR960455
     C                   ADD       1             Q                                          AR960455
     C     Q             Occur     MULT                                                     AR960455
     C                   MOVEL     ZSADD1        MFLD                                       AR960455
     C                   Endif                                                              AR960455
      **  Address 2                                                                         AR960455
     C                   If        ZSADD2 <> *BLANKS                                        AR960455
     C                   ADD       1             Q                                          AR960455
     C     Q             Occur     MULT                                                     AR960455
     C                   MOVEL     ZSADD2        MFLD                                       AR960455
     C                   Endif                                                              AR960455
      **  Address 3                                                                         AR960455
     C                   If        ZSADD3 <> *BLANKS                                        AR960455
     C                   ADD       1             Q                                          AR960455
     C     Q             Occur     MULT                                                     AR960455
     C                   MOVEL     ZSADD3        MFLD                                       AR960455
     C                   Endif                                                              AR960455
      **  Address 4                                                                         AR960455
     C                   If        ZSADD4 <> *BLANKS                                        AR960455
     C                   ADD       1             Q                                          AR960455
     C     Q             Occur     MULT                                                     AR960455
     C                   MOVEL     ZSADD4        MFLD                                       AR960455
     C                   Endif                                                              AR960455
      *                                                                                     AR960455
     C                   ENDSR                                                              AR960455
      *****************************************************************
      /COPY FTCPYSRC,FTSWIFTRAN
**  TbTag / TbDSF /TbDCA /TbComp   Tag/ Data Structure Field/DCA/Components
:20: YPH20
:21R:YPH21R
:50C:YPH50L   *BIC
:50L:YPH50L
:50G:YPH50    *ACLIN    *BIC
:50H:YPH50    *ACLIN    *NAMAD    *NAME                                         211499
:52A:YPH52    *ACLIN    *BIC
:52C:YPH52    *ACLIN
:51A:YPH51A   *ACLIN    *BIC
:30: YPH30 D  *DATE
:25: YPH25
:21: NP21
:21F:NP21F
:23E:NP23E
:32B:NP32B CA *CCY      *AMT
:50C:NP50L    *BIC
:50L:NP50L
:50G:NP50     *ACLIN    *BIC
:50H:NP50     *ACLIN    *NAMAD    *NAME                                         211499
:52A:NP52     *ACLIN    *BIC
:52C:NP52     *ACLIN
:56A:NP56     *ACLIN    *BIC
:56C:NP56     *ACLIN
:56D:NP56     *ACLIN    *NAMAD    *NAME                                         211499
:57A:NP57     *ACLIN    *BIC
:57C:NP57     *ACLIN
:57D:NP57     *ACLIN    *NAMAD    *NAME                                         211499
:59: NP59     *ACLIN    *NAMAD    *NAME                                         211499
:59A:NP59     *ACLIN    *BIC
:59F:NP59                                                                                     CSW215
:70: NP70     *LINE1    *LINE2    *LINE3    *LINE4
:77B:NP77B    *LINE1    *LINE2    *LINE3
:33B:NP33B CA *CCY      *AMT
:71A:NP71
:25: NP25A    *ACLIN
:36: NP36
