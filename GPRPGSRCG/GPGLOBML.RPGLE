     H DEBUG
     H EXTBININT(*NO)
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2004')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas GP Global updates - ML')                         *
      *****************************************************************
      *                                                               *
      *  Midas - Global Processing Module                             *
      *                                                               *
      *  GPGLOBML - Global Updates - ML                               *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2004            *
      *                                                               *
      *  If file T_MLMTRAN is changed, this will need to be changed   *
      *  as well                                                      *
      *                                                               *
      *  Last Amend No. AR466512           Date 19Aug14               *
      *  Prev Amend No. CLE148             Date 23Jul12               *
      *                 AR733372           Date 05Apr11               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 245952             Date 23Feb07               *
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 BUG6921            Date 21Nov05               *
      *                 CSD027             Date 09Dec05               *
      *                 CSW037A            Date 02May05               *
      *                 CSD025             Date 11Jan05               *
      *                 BUG5762            Date 02Feb05               *
      *                 CSW037             Date 15Dec04               *
      *                 CSW036             Date 15Dec04               *
      *                 BUG3860            Date 19Aug04               *
      *                 BUG4022            Date 18Aug04               *
      *                BUG3652             Date 12Jul04               *
      *                BUG3562             Date 12Jul04               *
      *                BUG3368             Date 16Jun04               *
      *                 CGP003  *CREATE    Date 09Mar04               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  AR466512 - Global system value 'UseCtryCitizenship' is not   *
      *             considered in Manual Transactions updates.        *
      *  CLE148 - Alpha Loan Reference                                *
      *  AR733372 - Facility exposure is doubled when Amending a ma-  *
      *             nual transaction. Amended the program to exclude  *
      *             the transaction reference on the chain key to pre-*
      *             vent the double exposure on the facility.         *
      *             (Child: AR733373)                                 *
      *  245952 - T_GRCUSTH, T_GRCTRYH and T_GRINDSH                  *
      *           all have a record format longer than 30,000,        *
      *           which means that the substring operation for the    *
      *           after image begins after the end of the EntryData   *
      *           variable.  Increase length of EntryData.            *
      *  BUG6921 - T_LVCONFIG has a record format longer than 20,000, *
      *            which means that the substring operation for the   *
      *            after image begins after the end of the EntryData  *
      *            variable.  Increase length of EntryData.           *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CSW037A- Additional Field extended to 40 chars (recompile)   *
      *  CSD025 - Customer De-Activation                              *
      *  BUG5762- Selecting customer in the wrong branch              *
      *  CSW037 - Additional Field Data on MT300/MT320                *
      *  CSW036 - Dual SWIFT BIC held on Client Details               *
      * BUG3860 - Update Alpha customer/risk customer, trans ref      *
      *     numeric and alpha, account code and sequence numeric      *
      * BUG4022 - Truncated decimal places in GPPOSNPD                *
      * BUG3652 - Unique identier of GPTRAPPD must include Trans ID   *
      * BUG3562 - Null dates on T_MLMTRAN not correctly handled.      *
      * BUG3368 - Manual transactions do not update ML or CL exposure *
      *  CGP003 - Management Limits                                   *
      *           Required to move details of manual transactions     *
      *           to the Global Transactions file.                    *
      *                                                               *
      *****************************************************************
 
     FGZSDBRCHL0IF   E           K DISK    INFSR(*PSSR)
     F                                     Prefix(HF)
     FGZSDBANKL1IF   E           K DISK    INFSR(*PSSR)
     FGZSDCUSTL0IF   E           K DISK    INFSR(*PSSR)
     FGZSDCUSTL1IF   E           K DISK    INFSR(*PSSR)                                      BUG5762
     F                                       RENAME(SDCUSTD0:SDCUSTD1)                       BUG5762
     FGPCUSTXL2 IF   E           K DISK    INFSR(*PSSR)
     FGPUTXML0  IF   E           K DISK    INFSR(*PSSR)
     FGPCURRL0  IF   E           K DISK    INFSR(*PSSR)                                      BUG3368
     FGPUTXMPD  O    E             DISK    INFSR(*PSSR)
     F                                       RENAME(GPUTXMD0:GPUTXMP)
     FGPTRAPL0  UF A E           K DISK    INFSR(*PSSR) PREFIX(G)
     F                                       RENAME(GOTRAPD0:GPTRAPP)
     F                                     COMMIT
     FGPPOSNL0  UF A E           K DISK    INFSR(*PSSR)
     F                                       RENAME(GOPOSND0:GPPOSNP)
     F                                     COMMIT
 
      ** Array containing Copyright statement
     D CPY@            S             80    DIM(1) CTDATA PERRCD(1)
 
     D POWER           S              9S 0 DIM(10) CTDATA PERRCD(1)                          BUG3368
                                                                                             BUG3368
     DT_TRAP         E DS                  EXTNAME(GPTRAPPD)
     DGT_TRAP        E DS                  EXTNAME(GPTRAPPD) PREFIX(G)
     DP_POSN         E DS                  EXTNAME(GPPOSNPD)
 
      ** This matches the file description for the file T_MLMTRAN
      ** but cannot use the external description due to the binary fields
      ** For example MTID would be taken to be 20 Integer long which is
      ** equivalent of 10A, instead of 18 Binary which is equivalent of 8A
     DMLMTRAN          DS          4192
     D MTID                    1      8I 0
     D MTREF                   9     60A
     D WTREF                  11     60A
     D MTMODULE               61     62A
     D MTTRNTYP               63     67A
     D MTTRNSTYP              68     72A
     D MTBRCHCODE             73     75A
     D MTCUSTCODE             76     85A
     D MTASSETAMT             86     97P 8
     D MTASSETCCY             98    100A
     D MTLIABAMT             101    112P 8
     D MTLIABCCY             113    115A
     D MTDEALDATE                      D
     D MTVALDATE                       D
     D MTMATDATE                       D
     D MTREMARK              146   4147A
     D WTREMARK              148   4147A
     D MTRESVID             4148   4155I 0
     D MTDELETED            4156   4156A
     D MTUSERID             4157   4178A
     D MTFACBRCD            4179   4181A
     D MTFACCUST            4182   4187A
     D MTFACTYPE            4188   4190A
     D MTFACSEQ             4191   4192A
 
     D PARM1           DS
      * Physical file name
     D  PFLNAME                1     10
      * Member name
     D  MBRNAME               21     30
      * Trigger event
     D  TRGEVENT              31     31
      * Offset to the before image of the record
     D  BOFF                  49     52B 0
      * Length of the before image of the record
     D  BLEN                  53     56B 0
      * Offset to the after image of the record
     D  AOFF                  65     68B 0
      * Length of the after image of the record
     D  ALEN                  69     72B 0
     D**EntryData******      117  10117A                                                     BUG6921
     D**EntryData******      117  22000A                                              BUG6921 245952
     D  EntryData            117  32000A                                                      245952
 
 
     D PARM2           DS
     D  LENG                   1      4B 0
 
     D SPLITCUST       DS
      * Split up customer sent from ML
     D  SP_BRANCH              1      3
      * Branch in zone
     D  SP_HYPHEN              4      4
      * Separator
     D  SP_CUST                5     10
      * Customer in zone
 
     D ZWDTIN          S              8S 0
                                                                                             BUG3368
     D                 DS                                                                    BUG3368
      * Manual Transaction ID                                                                BUG3368
     D  MTID_NM                1     20S 0                                                   BUG3368
     D  MTID_CH                1     20    DIM(20)                                           BUG3368
                                                                                             BUG3368
     D                 DS                                                                    BUG3368
     D  TREF_CH                1     20    DIM(20)                                           BUG3368
 
 
      * ENTRY PARAMETERS
 
     C     *ENTRY        PLIST
     C                   PARM                    PARM1
     C                   PARM                    PARM2
 
      * Recover before and after image
 
     C     BOFF          ADD       1             OffSet            5 0
     C     BLen          SUBST     PARM1:OffSet  I#BIMG         4192
 
     C     AOFF          ADD       1             OffSet
     C     ALen          SUBST     PARM1:OffSet  I#AIMG         4192
 
      * Global Updates - BEFORE/AFTER image
      * TRGEVENT: '1'=INSERT, '2'=DELETE, '3'=UPDATE
     C     TRGEVENT      IFEQ      '1'
     C                   MOVEL     *BLANK        I#BIMG
     C                   ENDIF
     C     TRGEVENT      IFEQ      '2'
     C                   MOVEL     *BLANK        I#AIMG
     C                   ENDIF
 
     C                   MOVEL     I#AIMG        MLMTRAN
     C     MLMTRAN       IFEQ      *BLANKS
     C                   MOVEL     I#BIMG        MLMTRAN
     C                   ENDIF
 
     C*******************DUMP                                                                BUG3368
     C                   EXSR      TRAP
     C                   EXSR      POSN
 
     C                   RETURN
      /SPACE 5
      *****************************************************************
      * TRAP   - Set up GPTRAPPD record
      ********************************************************************
     C     TRAP          BEGSR
      * Recover the zone attached to the branch
 
     C     MTBRCHCODE    CHAIN     SDBRCHD0                           99
      * error
     C     *IN99         IFEQ      *ON
     C                   EVAL      I#ERMS = 'BRANCH ' + MTBRCHCODE
     C                              + ' NOT IN GLOBAL LAYER'
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   CLEAR                   T_TRAP
      * Zone
     C                   MOVEL     HFA8ZONE      T_ZONE
     C     T_ZONE        CHAIN     SDBANKD0                           99                     BUG3562
      * error                                                                                BUG3562
     C     *IN99         IFEQ      *ON                                                       BUG3562
     C                   EVAL      I#ERMS = 'ZONE' + T_ZONE                                  BUG3562
     C                              + ' NOT IN GLOBAL LAYER'                                 BUG3562
     C                   EXSR      *PSSR                                                     BUG3562
     C                   ENDIF                                                               BUG3562
      * Module
     C                   MOVEL     MTMODULE      T_MOD
      * Sub module
     C                   MOVEL     MTMODULE      T_SMOD
     C*
      * Customer
     C                   MOVEL     MTCUSTCODE    SPLITCUST
     C     SP_HYPHEN     IFEQ      '-'
     C* CUST IN BBB-CCCCCC FORM
     C                   MOVEL     SP_CUST       T_CNUM
     C                   MOVEL     SP_BRANCH     KBRCH
     C                   MOVEL     SP_CUST       KCUST
     C*****SP_CUST       CHAIN     GZSDCUSTL0                         87                     BUG5762
     C     KGBRCH        CHAIN     GZSDCUSTL1                         87                     BUG5762
      * error
     C     *IN87         IFEQ      *ON
     C                   EVAL      I#ERMS = 'Customer' + MTCUSTCODE
     C                              + ' not defined'
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   ELSE
     C* CUST IN GLOBAL FORM
     C     MTCUSTCODE    READE     GPCUSTXL2                              99
      * error
     C     *IN99         IFEQ      *ON
     C                   EVAL      I#ERMS = 'CUSTOMER' + MTCUSTCODE
     C                              + ' NOT IN GLOBAL LAYER'
     C                   EXSR      *PSSR
     C                   ENDIF
     C                   MOVEL     'N'           WORKFOUND         1
     C     *IN99         DOWEQ     '0'
     C     WORKFOUND     ANDNE     'Y'
     C     CUBRCD        CHAIN     GZSDBRCHL0                         88
      * error
     C     *IN88         IFEQ      *ON
     C                   EVAL      I#ERMS = 'Branch of Customer' + CUBRCD
     C                              + ' NOT IN GLOBAL LAYER'
     C                   EXSR      *PSSR
     C                   ENDIF
     C     HFA8ZONE      IFEQ      T_ZONE
     C                   MOVEL     'Y'           WORKFOUND
     C                   ENDIF
     C     WORKFOUND     IFNE      'Y'
     C     MTCUSTCODE    READE     GPCUSTXL2                              99
      * error
     C     *IN99         IFEQ      *ON
     C                   EVAL      I#ERMS = 'CUSTOMER' + MTCUSTCODE
     C                              + ' NOT IN GLOBAL LAYER'
     C                   EXSR      *PSSR
     C                   ENDIF
     C                   ENDIF
     C                   ENDDO
     C*
     C     WORKFOUND     IFEQ      'N'
      * error
     C                   EVAL      I#ERMS = 'CUSTOMER' + MTCUSTCODE
     C                              + ' NOT IN ZONE OF TRANSACTION'
     C                   EXSR      *PSSR
     C                   ELSE
     C                   MOVEL     CUCUST        T_CNUM
     C                   MOVEL     CUBRCD        WORKCUSTBRCH      3
     C                   ENDIF
     C                   ENDIF
     C*
      * Booking Branch
     C                   MOVEL     MTBRCHCODE    T_BRCA
      * Transaction Reference
     C                   EXSR      DET_TREF                                                  BUG3368
     C                   MOVEA     TREF_CH       T_TREF                                      BUG3368
     C*******************MOVEL     MTID          T_TREF                                      BUG3368
      * Shortname (use the short form of the Reference as the first 2 chars
      * indicate how long the VARCHAR is)
     C                   MOVEL     WTREF         T_SNAM
      * Transaction Type
     C                   MOVEL     MTTRNTYP      T_TRTP
      * Transaction Sub-Type
     C                   MOVEL     MTTRNSTYP     T_TRST
      * Identifier
     C                   MOVEL     T_ZONE        KZONE
     C                   MOVEL     T_MOD         KMOD
     C                   MOVEL     T_SMOD        KSMOD
     C**********         MOVEL     T_SNAM        KSNAM                                      AR733372
     C                   MOVE      T_TREF        KSNAM                                       BUG3652
     C     GPUTXMK       CHAIN     GPUTXMD0                           99
     C     *IN99         IFEQ      *ON
      /COPY GPCPYSRCG,GPGETNTID
     C                   MOVEL     T_ZONE        XTZONE
     C                   MOVEL     T_MOD         XTMOD
     C                   MOVEL     T_SMOD        XTSMOD
     C**********         MOVEL     T_SNAM        XTSNAM                                     AR733372
     C                   MOVE      T_TREF        XTSNAM                                      BUG3652
     C                   Z-ADD     O#NTID        XTID
     C                   WRITE     GPUTXMP
     C                   ENDIF
     C                   Z-ADD     XTID          T_ID
      * Risk Customer
     C                   MOVEL     T_CNUM        T_RCST
      * Update alpha customer and risk customer                                              BUG3860
     C                   MOVE      T_CNUM        T_CNMA                                      BUG3860
     C                   MOVE      T_RCST        T_RCSA                                      BUG3860
      * Update Account Code,Account Sequence, Transaction ref                                BUG3860
     C                   MOVEL     T_ACOD        T_ACDN                                      BUG3860
     C                   MOVEL     T_ACSQ        T_ACSN                                      BUG3860
     C                   IF        T_MOD <> 'LE'                                              CLE148
     C                   MOVEL     T_TREF        T_TR6N                                      BUG3860
     C                   ENDIF                                                                CLE148
     C                   MOVEL     T_TREF        T_TR6A                                      BUG3860
      * Risk Currency
     C                   MOVEL     MTASSETCCY    T_RCCY
     C     MTASSETCCY    IFEQ      *BLANKS
     C                   MOVEL     MTLIABCCY     T_RCCY
     C                   ENDIF
      * Transaction Date
     C                   MOVEL     *BLANKS       WORKDATE          8
     C                   EVAL      WORKDATE = %CHAR(MTDEALDATE:*ISO0)
     C                   MOVEL     WORKDATE      ZWDTIN
     C     ZWDTIN        IFEQ      00010101                                                  BUG3562
     C                   Z-ADD     BJRDNB        T_TDAT                                      BUG3562
     C                   ELSE                                                                BUG3562
     C                   EXSR      ZDATE10
     C                   Z-ADD     ZZMDNO        T_TDAT                           Midas day no.
     C                   ENDIF                                                               BUG3562
      * Start Date
     C                   MOVEL     *BLANKS       WORKDATE          8
     C                   EVAL      WORKDATE = %CHAR(MTVALDATE:*ISO0)
     C                   MOVEL     WORKDATE      ZWDTIN
     C     ZWDTIN        IFEQ      00010101                                                  BUG3562
     C                   Z-ADD     BJRDNB        T_SDAT                                      BUG3562
     C                   ELSE                                                                BUG3562
     C                   EXSR      ZDATE10
     C                   Z-ADD     ZZMDNO        T_SDAT                           Midas day no.
     C                   ENDIF                                                               BUG3562
 
      * End Date
     C                   MOVEL     *BLANKS       WORKDATE          8
     C                   EVAL      WORKDATE = %CHAR(MTMATDATE:*ISO0)
     C                   MOVEL     WORKDATE      ZWDTIN
     C     ZWDTIN        IFEQ      00010101                                                  BUG3562
     C                   Z-ADD     *ZERO         T_EDAT                                      BUG3562
     C                   ELSE                                                                BUG3562
     C                   EXSR      ZDATE10
     C                   Z-ADD     ZZMDNO        T_EDAT                           Midas day no.
     C                   ENDIF                                                               BUG3562
 
      * Reservation Id
     C                   MOVEL     MTRESVID      W_RSID           20
     C     W_RSID        IFNE      *BLANKS
     C                   MOVE      W_RSID        T_RSID
     C                   ELSE
     C                   MOVEL     *ZEROS        T_RSID
     C                   ENDIF
 
     C     SP_HYPHEN     IFNE      '-'
     C     CUCUST        CHAIN     GZSDCUSTL0                         87
      * error
     C     *IN87         IFEQ      *ON
     C                   EVAL      I#ERMS = 'Customer' + MTCUSTCODE
     C                              + ' not defined'
     C                   EXSR      *PSSR
     C                   ENDIF
     C                   ENDIF
 
     C                   MOVEL     BBBRCD        T_CUBR
      * Risk Customer Branch
     C                   MOVEL     BBBRCD        T_RCBR
      * Local Industry Code
     C                   MOVEL     BBLICD        T_LICD
      * Country Code
      *                                                                                     AR466512
      ** If system value UseCtryCitizenship = 'Y' then use                                  AR466512
      ** Country of Citizenship, otherwise use Country of Location.                         AR466512
      *                                                                                     AR466512
     C     W#UCC         IFEQ      'Y'                                                      AR466512
     C                   MOVEL     BBCNCZ        T_CNCD                                     AR466512
     C                   ELSE                                                               AR466512
     C                   MOVEL     BBCOLC        T_CNCD
     C                   ENDIF                                                              AR466512
      * Matured?
 
     C*****T_ZONE********CHAIN     SDBANKD0                           99                     BUG3562
      **error************                                                                    BUG3562
     C******IN99*********IFEQ      *ON                                                       BUG3562
     C*******************EVAL      I#ERMS = 'ZONE' + T_ZONE                                  BUG3562
     C*******************           + ' NOT IN GLOBAL LAYER'                                 BUG3562
     C*******************EXSR      *PSSR                                                     BUG3562
     C*******************ENDIF                                                               BUG3562
     C     T_EDAT        IFLT      BJRDNB
     C     T_EDAT        ANDNE     *ZERO                                                     BUG3562
     C                   MOVEL     'Y'           T_MATI
     C                   ENDIF
      * Action
     C                   SELECT
     C     TRGEVENT      WHENEQ    '1'
     C                   MOVEL     'I'           T_ACTN
     C     TRGEVENT      WHENEQ    '2'
     C                   MOVEL     'D'           T_ACTN
     C     TRGEVENT      WHENEQ    '3'
     C                   MOVEL     'U'           T_ACTN
     C                   ENDSL
 
     C     MTDELETED     IFEQ      'Y'
     C                   MOVEL     'D'           T_ACTN
     C                   ENDIF
 
     C     T_ID          SETLL     GPTRAPP
     C     T_ID          READE     GPTRAPP                                99
     C  N99GT_UNUM       ADD       1             T_UNUM
     C                   EVAL      GT_TRAP = T_TRAP
     C*****T_ACTN********IFEQ      'D'                                                       BUG3368
     C*******************DELETE    GPTRAPP                                                   BUG3368
     C*******************ELSE                                                                BUG3368
     C     *IN99         IFEQ      *OFF
     C                   UPDATE    GPTRAPP
     C                   ELSE
     C     T_ACTN        IFNE      'D'                                                       BUG3368
     C                   WRITE     GPTRAPP
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDSR
      ********************************************************************
      /SPACE 5
      *****************************************************************
      * POSN   - Set up GPPOSNPD record
      ********************************************************************
     C     POSN          BEGSR
                                                                                             BUG3368
     C     MTASSETCCY    CHAIN     GPCURRD0                           99                     BUG3368
     C                   Z-ADD     GCNBDP        AssetCDP          1 0                       BUG3368
     C     1             ADD       AssetCDP      AssetIx           1 0                       BUG3368
     C     MTLIABCCY     CHAIN     GPCURRD0                           99                     BUG3368
     C                   Z-ADD     GCNBDP        LiablCDP          1 0                       BUG3368
     C     1             ADD       LiablCDP      LiablIx           1 0                       BUG3368
 
     C     MTASSETAMT    IFNE      *ZEROS
     C     MTLIABAMT     ORNE      *ZEROS
     C     T_ACTN        OREQ      'D'
     C     T_ID          SETLL     GPPOSNL0
     C     T_ID          READE     GPPOSNL0                               79
     C     *IN79         DOWEQ     '0'
     C                   DELETE    GPPOSNL0
     C     T_ID          READE     GPPOSNL0                               79
     C                   ENDDO
     C                   ENDIF
 
     C     MTASSETAMT    IFNE      *ZEROS
     C     T_ACTN        ANDNE     'D'
     C     MTLIABAMT     ORNE      *ZEROS
     C     T_ACTN        ANDNE     'D'
     C     MTASSETAMT    IFNE      *ZEROS
     C                   CLEAR                   P_POSN
     C                   MOVEL     T_ID          P_ID
     C                   MOVEL     T_TDAT        P_PDAT
     C                   MOVEL     'T'           P_TVDI
     C                   MOVEL     'C'           P_PSTP                                      BUG3368
     C                   MOVEL     'A'           P_ASLI
     C**********         MOVEL     MTASSETAMT    P_NOML                                      BUG4022
     C**********         MULT      POWER(AssetIx)P_NOML                              BUG3368 BUG4022
     C                   MOVEL     MTASSETAMT    W_NOML           18 3                       BUG4022
     C     W_NOML        MULT      POWER(AssetIx)P_NOML                                      BUG4022
     C                   MOVEL     MTASSETCCY    P_CCY
     C                   MOVEL     'L'           P_OASL
     C**********         MOVEL     MTLIABAMT     P_ONOM                                      BUG4022
     C**********         MULT      POWER(LiablIx)P_ONOM                              BUG3368 BUG4022
     C                   MOVEL     MTLIABAMT     W_ONOM           18 3                       BUG4022
     C     W_ONOM        MULT      POWER(LiablIx)P_ONOM                                      BUG4022
     C                   MOVEL     MTLIABCCY     P_OCCY
     C                   Z-ADD     AssetCDP      P_NMDP                                      BUG3368
     C                   WRITE     GPPOSNP
     C*
     C     T_SDAT        IFLE      BJRDNB
     C                   MOVEL     'V'           P_TVDI
     C                   MOVEL     'C'           P_PSTP                                      BUG3368
     C                   MOVEL     T_SDAT        P_PDAT
     C                   WRITE     GPPOSNP
     C                   ENDIF
     C                   ENDIF
 
     C     MTLIABAMT     IFNE      *ZEROS
     C                   CLEAR                   P_POSN
     C                   MOVEL     T_ID          P_ID
     C                   MOVEL     T_TDAT        P_PDAT
     C                   MOVEL     'T'           P_TVDI
     C                   MOVEL     'C'           P_PSTP                                      BUG3368
     C                   MOVEL     'L'           P_ASLI
     C**********         MOVEL     MTLIABAMT     P_NOML                                      BUG4022
     C**********         MULT      POWER(LiablIx)P_NOML                              BUG3368 BUG4022
     C                   MOVEL     MTLIABAMT     W_NOML                                      BUG4022
     C     W_NOML        MULT      POWER(LiablIx)P_NOML                                      BUG4022
     C                   MOVEL     MTLIABCCY     P_CCY
     C                   MOVEL     'A'           P_OASL
     C**********         MOVEL     MTASSETAMT    P_ONOM                                      BUG4022
     C**********         MULT      POWER(AssetIx)P_ONOM                              BUG3368 BUG4022
     C                   MOVEL     MTASSETAMT    W_ONOM                                      BUG4022
     C     W_ONOM        MULT      POWER(AssetIx)P_ONOM                                      BUG4022
     C                   MOVEL     MTASSETCCY    P_OCCY
     C                   Z-ADD     LiablCDP      P_NMDP                                      BUG3368
     C                   WRITE     GPPOSNP
     C*
     C     T_SDAT        IFLE      BJRDNB
     C                   MOVEL     'V'           P_TVDI
     C                   MOVEL     'C'           P_PSTP                                      BUG3368
     C                   MOVEL     T_SDAT        P_PDAT
     C                   WRITE     GPPOSNP
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDSR
      /SPACE 5                                                                               BUG3368
      *****************************************************************                      BUG3368
      * DET_TREF - Determine Transaction Reference                                           BUG3368
      ********************************************************************                   BUG3368
     C     DET_TREF      BEGSR                                                               BUG3368
                                                                                             BUG3368
     C                   MOVEL     'N'           FirstDigit        1                         BUG3368
     C                   MOVEL     *BLANK        TREF_CH                                     BUG3368
                                                                                             BUG3368
     C                   Z-ADD     MTID          MTID_NM                                     BUG3368
     C                   Z-ADD     1             TI                2 0                       BUG3368
     C                   Z-ADD     1             TO                2 0                       BUG3368
     C     TI            DOWLE     20                                                        BUG3368
     C     MTID_CH(TI)   IFNE      '0'                                                       BUG3368
     C                   EVAL      FirstDigit = 'Y'                                          BUG3368
     C                   ENDIF                                                               BUG3368
     C     FirstDigit    IFEQ      'Y'                                                       BUG3368
     C                   MOVE      MTID_CH(TI)   TREF_CH(TO)                                 BUG3368
     C                   ADD       1             TO                                          BUG3368
     C                   ENDIF                                                               BUG3368
     C                   ADD       1             TI                                          BUG3368
     C                   ENDDO                                                               BUG3368
                                                                                             BUG3368
     C                   ENDSR                                                               BUG3368
      /SPACE 5
      *****************************************************************
      * *INZSR - Initial subroutine called automatically at program start
      ********************************************************************
     C     *INZSR        BEGSR
 
     C                   MOVEL     *BLANK        I#RTCD            7
     C                   MOVEL     *BLANK        I#ERMS           50
 
     C     KGBRCH        KLIST
     C                   KFLD                    KBRCH             3
     C                   KFLD                    KCUST             6
 
     C     GPUTXMK       KLIST
     C                   KFLD                    KZONE            10
     C                   KFLD                    KMOD              2
     C                   KFLD                    KSMOD             4
     C                   KFLD                    KSNAM            50
      *                                                                                     AR466512
     C                   EVAL      P@RTCD = *BLANKS                                         AR466512
     C                   EVAL      P@OP01 = 'UseCtryCitizenship'                            AR466512
      *                                                                                     AR466512
     C                   CALL      'GPAOSVALR0'                                             AR466512
     C                   PARM      *BLANK        P@RTCD            7                        AR466512
     C                   PARM                    P@OP01           20                        AR466512
     C                   PARM                    P@VL01          200                        AR466512
     C                   PARM                    P@OP02           20                        AR466512
     C                   PARM                    P@VL02          200                        AR466512
     C                   PARM                    P@OP03           20                        AR466512
     C                   PARM                    P@VL03          200                        AR466512
     C                   PARM                    P@OP04           20                        AR466512
     C                   PARM                    P@VL04          200                        AR466512
     C                   PARM                    P@OP05           20                        AR466512
     C                   PARM                    P@VL05          200                        AR466512
     C                   PARM                    P@OP06           20                        AR466512
     C                   PARM                    P@VL06          200                        AR466512
     C                   PARM                    P@OP07           20                        AR466512
     C                   PARM                    P@VL07          200                        AR466512
     C                   PARM                    P@OP08           20                        AR466512
     C                   PARM                    P@VL08          200                        AR466512
     C                   PARM                    P@OP09           20                        AR466512
     C                   PARM                    P@VL09          200                        AR466512
     C                   PARM                    P@OP10           20                        AR466512
     C                   PARM                    P@VL10          200                        AR466512
      *                                                                                     AR466512
      ** Extract the system value                                                           AR466512
      *                                                                                     AR466512
     C                   MOVEL     'N'           W#UCC             1                        AR466512
      *                                                                                     AR466512
     C     P@RTCD        IFEQ      *BLANK                                                   AR466512
     C                   MOVEL     P@VL01        W#UCC                                      AR466512
      *                                                                                     AR466512
      ** Error                                                                              AR466512
      *                                                                                     AR466512
     C                   ELSE                                                               AR466512
     C                   EVAL      I#ERMS = 'MISSING GLOBAL SYSTEM VALUE'                   AR466512
     C                   EXSR      *PSSR                                                    AR466512
     C                   ENDIF                                                              AR466512
 
     C                   ENDSR
      ********************************************************************
      /SPACE 5
      ********************************************************************
      * ZDATE10
      ********************************************************************
     C     ZDATE10       BEGSR
     C                   CALLB     'GPZDATE10'
     C                   PARM                    ZWDTIN
     C                   PARM                    ZZMDNO            5 0
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      ********************************************************************
      * * P S S R  --- A B N O R M A L   E R R O R   C O N D I T I O N S
      /COPY GPCPYSRCG,GPPSSR
      *****************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2004
** POWER                                                                                     BUG3368
000000001                                                                                    BUG3368
000000010                                                                                    BUG3368
000000100                                                                                    BUG3368
000001000                                                                                    BUG3368
000010000                                                                                    BUG3368
000100000                                                                                    BUG3368
001000000                                                                                    BUG3368
010000000                                                                                    BUG3368
100000000                                                                                    BUG3368
