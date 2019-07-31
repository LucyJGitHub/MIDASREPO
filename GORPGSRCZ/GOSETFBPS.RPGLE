     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2003')
      *****************************************************************
/*XBIA*: OVRDBF FILE(SDBRCHL0XX) TOFILE(SDBRCHL0) SHARE(*NO)          *
/*XBIB*: OVRDBF FILE(FOPCKXX   ) TOFILE(FOPCK   ) SHARE(*NO)          *
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas GO Setup F&O Book Position TRAP record')         *
      *****************************************************************
      *                                                               *
      *  Midas - Global Processing Module                             *
      *                                                               *
      *  GOSETFBPS - Setup F&O Book Position TRAP record              *
      *                                                               *
      *  (c) Finastra International Limited 2003                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. AR668434           Date 26Jun13               *
      *                 CAP208             Date 06Dec10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 256564             Date 17Sep08               *
      *                 BUG13281           Date 05Mar07               *
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 BUG11830           Date 11Aug06               *
      *                 CSD027             Date 09Dec05               *
      *                 BUG3860            Date 11Aug04               *
      *                 CGP001  *CREATE    Date 23May03               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  AR668434 - Array error due to Branch records is more than 99 *
      *             Fix is to increase the maximum number of array.   *
      *  CAP208 - F&O Market Instrument API (Recompile)               *
      *  256564 - Recompile due to PF changes done by fix 256330      *
      *  BUG13281 - Set Transaction Date and Start date to run date   *
      *   Fix is same as 246221.                                      *
      *  BUG11830- branch of settlement account not defaulted         *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  BUG3860 - (recompile)                                        *
      *  CGP001 - Global Processing                                   *
      *                                                               *
      *****************************************************************
 
     FSDBRCHL0XXIF   E           K DISK    INFSR(*PSSR) PREFIX(BR_) USROPN
     FFOPCKXX   IF   E           K DISK    INFSR(*PSSR) PREFIX(PC_) USROPN
     FGPUTXFL0  IF A E           K DISK    INFSR(*PSSR)
 
     D/COPY ZACPYSRC,STD_D_SPEC
 
 
     D MARKTX        E DS                  EXTNAME(MARKTD)  PREFIX(MK_)
     D INTYPX        E DS                  EXTNAME(INTYPD)  PREFIX(IN_)
 
 
      ** T R A N S A C T I O N    D E T A I L S
     D T_TRAP        E DS                  EXTNAME(GPTRAPPD)
 
 
      * Branch Details
     D***NoofBranches    C                   CONST(99)                                      AR668434
     D NoofBranches    C                   CONST(999)                                       AR668434
     D #_BRCD          S              3    DIM(NoofBranches) ASCEND
     D #_BICN          S              6    DIM(NoofBranches)
 
 
     D YRNO            S              2S 0
     D MTHN            S              2S 0
 
 
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
 
      ** Overrides
     D ##OV1           S              1    DIM(60) CTDATA PERRCD(60)
     D ##OV2           S              1    DIM(60) CTDATA PERRCD(60)
 
 
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)                                BUG11830
     D DSSDY         E DS                  EXTNAME(DSSDY)                                   BUG11830
      * ENTRY PARAMETERS
 
     C     *ENTRY        PLIST
     C                   PARM                    I#RTCD            7            * RETURN CODE
     C                   PARM                    I#ERMS           50            * ERROR MESSAGE
      * INPUTS
     C                   PARM                    BRCA              3
     C                   PARM                    BOKC              2
     C                   PARM                    ISTT              5
     C                   PARM                    YRNO
     C                   PARM                    MTHN
     C                   PARM                    PCAL              1
     C                   PARM                    STRP             15 8
     C                   PARM                    MARKTX
     C                   PARM                    INTYPX
      * OUTPUTS
     C                   PARM                    T_TRAP
 
      * SETUP TRANSACTION INDEX RECORD
 
     C                   EXSR      SETUP_TRAP
 
      * RETURN
 
     C                   RETURN
      *
      *****************************************************************
      * SETUP TRANSACTION INDEX RECORD
      *****************************************************************
     C     SETUP_TRAP    BEGSR
 
      * Clear Transaction Index
 
     C                   CLEAR                   T_TRAP
 
      * Zone
     C                   MOVEL     O#ZONE        T_ZONE
      * Module
     C                   MOVEL     'FF'          T_MOD
      * Sub module
     C                   MOVEL     'FBPS'        T_SMOD
      * Customer
     C                   Z-ADD     1             @BR
     C     BRCA          LOOKUP    #_BRCD(@BR)                            99
     C                   MOVEL     #_BICN(@BR)   T_CNUM
      * Portfolio reference
     C                   MOVEL     *BLANK        T_PTFR
      * Booking Branch
     C                   MOVEL     BRCA          T_BRCA
      * Book
     C                   MOVEL     BOKC          T_BOOK
      * F&O Instrument Type
     C                   MOVEL     ISTT          T_ISTT
      * F&O Year Number
     C                   MOVEL     YRNO          T_YRNO
      * F&O Month Number
     C                   MOVEL     MTHN          T_MTHN
      * F&O Put/Call
     C                   MOVEL     PCAL          T_PCAL
      * F&O Strike Price
     C                   MOVEL     STRP          T_STRP
      * Identifier
     C     GPUTXFK       CHAIN     GPUTXFD0                           99
     C     *IN99         IFEQ      *ON
      /COPY GOCPYSRC,GOGETNTID
     C                   MOVEL     T_ZONE        XFZONE
     C                   MOVEL     T_SMOD        XFSMOD
     C                   MOVEL     T_CNUM        XFCNUM
     C                   MOVEL     T_BRCA        XFBRCA
     C                   MOVEL     T_BOOK        XFBOOK
     C                   MOVEL     T_ISTT        XFISTT
     C                   MOVEL     T_YRNO        XFYRNO
     C                   MOVEL     T_MTHN        XFMTHN
     C                   MOVEL     T_PCAL        XFPCAL
     C                   MOVEL     T_STRP        XFSTRP
     C                   Z-ADD     O#NTID        XFID
     C                   WRITE     GPUTXFD0
     C                   ENDIF
     C                   Z-ADD     XFID          T_ID
      * Shortname
     C                   MOVEL     T_YRNO        W#YRNO            2
     C                   MOVEL     T_MTHN        W#MTHN            2
     C                   MOVEL     *BLANK        W#STRP           18
     C                   SELECT
     C     T_MTHN        WHENEQ    0
     C     T_PCAL        ANDEQ     *BLANK
     C                   EVAL      T_SNAM = T_BRCA+'-'+T_BOOK+'-'+T_ISTT
     C     T_MTHN        WHENEQ    0
     C     T_PCAL        ANDNE     *BLANK
     C                   EVAL      T_SNAM = T_BRCA+'-'+T_BOOK+'-'+T_ISTT+
     C                                            '-'+T_PCAL+W#STRP
     C     T_MTHN        WHENNE    0
     C     T_PCAL        ANDEQ     *BLANK
     C                   EVAL      T_SNAM = T_BRCA+'-'+T_BOOK+'-'+T_ISTT+
     C                                            '-'+W#YRNO+'-'+W#MTHN
     C     T_MTHN        WHENNE    0
     C     T_PCAL        ANDNE     *BLANK
     C                   EVAL      T_SNAM = T_BRCA+'-'+T_BOOK+'-'+T_ISTT+
     C                                            '-'+W#YRNO+'-'+W#MTHN+
     C                                            '-'+T_PCAL+W#STRP
     C                   ENDSL
      * Transaction Type
     C                   MOVEL     IN_ISPT       T_TRTP
      * Transaction Profit Centre
     C     FOPCKK        CHAIN     FOPCKDF                            99
     C  N99              MOVEL     PC_PCBK       T_TPFC
      * Risk Customer
     C                   Z-ADD     1             @BR
     C     BRCA          LOOKUP    #_BRCD(@BR)                            99
     C                   MOVEL     #_BICN(@BR)   T_RCST
      * Risk Currency
     C     IN_ISPT       IFEQ      2
     C     IN_ISPT       OREQ      5
     C                   MOVEL     IN_OTHC       T_RCCY
     C                   ELSE
     C                   MOVEL     IN_ISCY       T_RCCY
     C                   END
      * Transaction Date                                                                    BUG13281
     C                   Z-ADD     BJRDNB        T_TDAT                                     BUG13281
      * Start Date                                                                          BUG13281
     C                   Z-ADD     BJRDNB        T_SDAT                                     BUG13281
      * End Date
     C                   EXSR      DET_ENDDATE
     C                   Z-ADD     FFDAY         T_EDAT
      * Omit from exposure
     C                   MOVEL     'Y'           T_OMEI
      * Action
     C                   MOVEL     'A'           T_ACTN
      *
      * Customer branch                                                                     BUG11830
     C                   MOVEL     T_CNUM        @KEY1                                      BUG11830
     C                   EXSR      ACS_CUST                                                 BUG11830
     C                   MOVEL     BBBRCD        T_RCBR                                     BUG11830
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      ********************************************************************
      * Determine End Date of Instrument
      ********************************************************************
     C     DET_ENDDATE   BEGSR
 
      * OTC
     C     MTHN          IFEQ      0
     C                   Z-ADD     IN_FTDT       FFDAY
     C                   ELSE
     C                   CALLB     'FFDATE'
     C                   PARM                    ReturnCode       10
     C                   PARM      *ZERO         FFDAY             5 0
     C                   PARM      IN_SEDF       FFDATC            7
     C                   PARM      MTHN          FFMTH             2 0
     C                   PARM      YRNO          FFYR              2 0
     C                   PARM      MK_MKLC       FFCCY1            3
     C                   PARM      MK_MLOC       FFLOC             3
     C                   PARM      IN_ISCY       FFCCY2            3
     C                   PARM      IN_OTHC       FFCCY3            3
     C                   PARM                    BJDFIN
     C                   ENDIF
     C
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      ********************************************************************                  BUG11830
      * Access customer details                                                             BUG11830
      ********************************************************************                  BUG11830
     C     ACS_CUST      BEGSR                                                              BUG11830
     C                   CALLB     'AOCUSTR0'                                               BUG11830
     C                   PARM      *BLANKS       @RTCD             7                        BUG11830
     C                   PARM      '*KEY   '     @OPTN             7                        BUG11830
     C                   PARM                    @KEY1            10                        BUG11830
     C                   PARM      *BLANKS       @KYST             7                        BUG11830
     C     SDCUST        PARM      SDCUST        DSSDY                                      BUG11830
     C     @RTCD         IFNE      *BLANK                                                   BUG11830
     C     @KYST         OREQ      '*ERROR'                                                 BUG11830
     C                   CLEAR                   SDCUST                                     BUG11830
     C                   ENDIF                                                              BUG11830
     C                   ENDSR                                                              BUG11830
      *****************************************************************                     BUG11830
      /SPACE 5                                                                              BUG11830
      ********************************************************************
      * *INZSR
      ********************************************************************
     C     *INZSR        BEGSR
 
      * Access Bank Details
 
     C                   CALLB     'AOBANKR0'
     C                   PARM      '*DBERR  '    @RTCD             7
     C                   PARM      '*FIRST  '    @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
 
      * Get Zone
 
      /COPY GOCPYSRC,GOGETZONE
 
     C                   Z-ADD     60            MESLEN           15 5
 
      * Override/Open files
 
     C                   CALL      'QCMDEXC'     OV1_Parm
     C                   OPEN      SDBRCHL0XX
     C                   CALL      'QCMDEXC'     OV2_Parm
     C                   OPEN      FOPCKXX
 
      * Load branches
 
     C                   Z-ADD     0             @BR               3 0
     C     *LOVAL        SETLL     @A8REB1
     C                   READ      @A8REB1                                99
     C     *IN99         DOWEQ     *OFF
     C                   ADD       1             @BR
     C                   MOVEL     BR_A8BRCD     #_BRCD(@BR)
     C                   MOVEL     BR_A8BICN     #_BICN(@BR)
     C                   READ      @A8REB1                                99
     C                   ENDDO
 
     C                   CLOSE     SDBRCHL0XX
 
      * Key lists
 
     C     FOPCKK        KLIST
     C                   KFLD                    BRCA
     C                   KFLD                    BOKC
     C                   KFLD                    ISTT
     C     GPUTXFK       KLIST
     C                   KFLD                    T_ZONE
     C                   KFLD                    T_SMOD
     C                   KFLD                    T_CNUM
     C                   KFLD                    T_BRCA
     C                   KFLD                    T_BOOK
     C                   KFLD                    T_ISTT
     C                   KFLD                    T_YRNO
     C                   KFLD                    T_MTHN
     C                   KFLD                    T_PCAL
     C                   KFLD                    T_STRP
 
      * Parameter lists
 
     C     OV1_Parm      PLIST
     C                   PARM                    ##OV1
     C                   PARM                    MESLEN
     C     OV2_Parm      PLIST
     C                   PARM                    ##OV2
     C                   PARM                    MESLEN
 
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * * P S S R  --- A B N O R M A L   E R R O R   C O N D I T I O N S
      /COPY GOCPYSRC,GOPSSR
      *********************************************************************
**  CPY@
(c) Finastra International Limited 2003
** ##OV1
OVRDBF FILE(SDBRCHL0XX) TOFILE(SDBRCHL0) SHARE(*NO)
** ##OV2
OVRDBF FILE(FOPCKXX   ) TOFILE(FOPCK   ) SHARE(*NO)
