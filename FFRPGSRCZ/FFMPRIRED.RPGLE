     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2006')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas FF Market Prices Read')
      *****************************************************************
      *                                                               *
      *  Midas - Financial Futures and Options module                 *
      *                                                               *
      *  FFMPRIRED - Midas FF Market Prices Function Code             *
      *              details read                                     *
      *                                                               *
      *  Function:  This module reads forwards and backwards          *
      *             through the Market Prices details file            *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2006            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Last Amend No. CSD027A            Date 03May06               *
      *  Prev Amend No. BUG10387           Date 06Feb06               *
      *                 CAP183  *Create    Date 05Jan06               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD027A - Conversion of customer number to alpha (post       *
      *            build 103). Recompiled.                            *
      *  BUG10387 - Checks Market Code even if OTC                    *
      *  CAP183 - Conversion of Market Prices Input into modular      *
      *           structure to use APIs.                              *
      *                                                               *
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
      ** Market Prices Transaction details file - by transaction number
     FPRICS     IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(PRICSDF:TrnFmat)
 
      ** Market Prices Transaction details file - by Front Office ID
     FPRICS2    IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(PRICSDF:FoIdFmt)
 
      ** Customer details file
     FSDCUSTL1  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(@BBREBF:CUSNUM)
 
      ** Midas FF Selected Instrument Type Details
     FINTYP2    IF   E           K DISK
     F                                      RENAME(INTYPDF:INTYP2DF)
 
      ** Midas FF Instrument Types
     FINTYP     IF   E           K DISK
 
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      **
      **-----------------------------------------------------------------------
      ** The following /COPY line includes (among others) the LDA layout
      ** and the copyright array definition:
     D/COPY ZACPYSRC,STD_D_SPEC
      **-----------------------------------------------------------------------
 
      **-----------------------------------------------------------------------
      ** The following /COPY includes the standard API declares:
     D/COPY ZACPYSRC,STDDECLARE
      **-----------------------------------------------------------------------
 
      **-----------------------------------------------------------------------
      ** The following /COPY line includes all the defined fields in the
      ** Program Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
      **-----------------------------------------------------------------------
 
      ** +--------------------------------------+
      ** ¦ End of automatically included D-specs¦
      ** ¦ =====================================¦
      ** +--------------------------------------+
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ Manually included D-specs            ¦
      ** ¦ =========================            ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
      ** External DS for bank details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
 
      ** First DS for access programs, short data structure
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Months Short Names
     D ZMNM            S              3    DIM(12) CTDATA PERRCD(12)
 
      ** Strike Price in Numeric Format Parameter
     D @PSTRP          S             15  8
 
      * Price (Screen Format)
     D FFSPRC          S             16A
 
      * Ticks Denominator
     D FFTKDM          S              3P 0
 
      ** Key to LF/INTYP
      ** Also, re-defines Instr. Type  into Mkt Centre + Instr. Code
     D ISTTK           DS             5
     D  KISTT                  1      5
     D  KMRKT                  1      2
     D  KISTC                  3      5
 
      ** Define Market Prices Transaction Reference Parameter
     D PRTRNN          DS
     D  PRISTT                 1      5
     D  PRMRKT                 1      2
     D  PRISTC                 3      5
     D  PRMTHN                 6      8
     D  PRYRNO                 9     10
     D  PRPCAL                11     11
     D  PRSTRP                12     27
 
      ** Current Market Prices Transaction Reference Parameter
     D @TRRED          DS
     D  @TRMRKT                1      2
     D  @TRISTT                1      5
     D  @TRMTHN                6      8
     D  @TRYRNO                9     10
     D  @TRPCAL               11     11
     D  @TRSTRP               12     27
 
      ** Key list definition
     D @@ISTT          S                   LIKE(ISTT)
     D @@MTHN          S                   LIKE(MTHN)
     D @@YRNO          S                   LIKE(YRNO)
     D @@PCAL          S                   LIKE(PCAL)
     D @@STRP          S                   LIKE(STRP)
 
      ** Flags
     D POTCFlag        S              1A
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *
      ** Instrument Types
      *
     IINTYPDF
     I              BCPT                        BCPTI
     I              CCPT                        CCPTI
     I              CTAM                        FFCTAM
     I              CNTT                        FFCNTT
      *
      ** Selected Instrument Type details
      *
     IINTYP2DF
     I              RECI                        RECI2
     I              ISTT                        ISTT2
     I              ISTI                        ISTI2
     I              ISPT                        ISPT2
     I              ISCY                        ISCY2
     I              QOTC                        QOTC2
     I              TKDM                        TKDM2
     I              MNPF                        MNPF2
     I              TKVL                        TKVL2
     I              OTHC                        OTHC2
      *****************************************************************
      /EJECT
      *****************************************************************
      /EJECT
      *****************************************************************
     C
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
      *
      ** Initialise outputs
     C                   EVAL      @ERRMS = *BLANK
     C                   EVAL      @TRRED = *BLANK
      *
      ** Check for user authority to browse if not multi-branching
     C                   IF        BJSBRC <> *BLANK
     C                   EXSR      CHAUTN
     C                   ENDIF
      *
      ** Validate transaction reference
     C                   EXSR      VALTRN
      *
      ** Read forwards
     C                   IF        @RDFWD = 'Y'
     C                   EXSR      RDFWD
     C                   ELSE
      *
      ** Read backwards
     C                   IF        @RDBCK = 'Y'
     C                   EXSR      RDBCK
     C                   ENDIF
     C                   ENDIF
      *
      ** Return
     C                   RETURN
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      * *INZSR - Initial processing
      *****************************************************************
     C     *INZSR        BEGSR
      *
     C     *ENTRY        PLIST
      *
      ** Input parameters :
      ** Return code
     C                   PARM                    RetCodeIn
 
      ** Action code
     C                   PARM                    DDACTN            1
 
      ** Market Prices Transaction reference parameter
     C                   PARM                    PRTRNN
 
      ** Read forwards
     C                   PARM                    @RDFWD            1
 
      ** Read backwards
     C                   PARM                    @RDBCK            1
      ** Strike price numeric format
 
     C                   PARM                    @PSTRP
 
      ** Strike price numeric format
     C                   PARM                    POTCFlag
 
      ** Output Parameters :
      ** Error meassage
     C                   PARM                    @ERRMS            7
 
      ** Transaction read
     C                   PARM                    @TRRED
 
      *
      ** Initialise program name
     C                   EVAL      DBPGM = 'FFMPRIRED'
      *
      ** Access bank details
     C                   CALL      'AOBANKR0'
     C                   PARM      '*DBERR '     @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
      *
      ** Database error
     C                   IF        @RTCD <> *BLANKS
     C                   EVAL      DBFILE = 'SDBANKPD'
     C                   EVAL      DBASE = 900
     C                   EVAL      DBKEY = @OPTN
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Define key list for  @@TRNN
     C     @@TRNN        KLIST
     C                   KFLD                    @@ISTT
     C                   KFLD                    @@YRNO
     C                   KFLD                    @@MTHN
     C                   KFLD                    @@PCAL
     C                   KFLD                    @@STRP
      *
     C                   ENDSR
      /EJECT
      *****************************************************************
      * RDFWD - Read forwards through transaction details file
      *****************************************************************
     C     RDFWD         BEGSR
      *
      ** Position to current record on file
     C     @@TRNN        SETGT     TRNFMAT
      *
      ** Read until end of file or a valid record is found or an error
     C                   DOU       *IN99 = '1' OR
     C                             (ISTT <> *BLANKS AND
     C                             @@ERR = *ZERO AND (DDACTN = 'A'
     C                             OR DDACTN = 'E' OR (DDACTN = 'D'
     C                             AND RECI <> '*')))
      *
      ** Read next transaction
     C                   READ      TRNFMAT                                99
      *
     C                   ENDDO
      *
      ** If end of file was encountered, report this fact
     C                   IF        *IN99 = '1'
     C                   EVAL      @ERRMS = 'MMM1002'
      *
      ** Else, return the transaction reference read
     C                   ELSE
      *
      ** Instrument Type
      *
     C                   MOVE      ISTT          @TRISTT
 
     C                   IF        POTCFlag <> 'Y'
      *
      ** Convert Month Number into Month Name
      *
     C                   MOVE      ZMNM(MTHN)    @TRMTHN
      *
      ** Year Number
      *
     C                   MOVE      YRNO          @TRYRNO
 
     C                   ENDIF
      *
      ** Put/Call Indicator
      *
     C                   MOVE      PCAL          @TRPCAL
      *
      ** Translate Strike Price into screen format
      *
     C                   EXSR      TranSTRP
      *
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * RDBCK - Read backwards through transaction details file
      *****************************************************************
     C     RDBCK         BEGSR
      *
      ** Position to current record on file
     C     @@TRNN        SETLL     TRNFMAT
      *
      ** Read until end of file or a valid record is found or an error
     C                   DOU       *IN99 = '1' OR
     C                             (ISTT   <> *BLANKS AND
     C                             @@ERR = *ZERO AND (DDACTN = 'A'
     C                             OR DDACTN = 'E' OR (DDACTN = 'D'
     C                             AND RECI <> '*')))
      *
      ** Read previous transaction
     C                   READP     TRNFMAT                                99
      *
     C                   ENDDO
      *
      ** If start of file was encountered, report this fact
     C                   IF        *IN99 = '1'
     C                   EVAL      @ERRMS = 'MMM1003'
      *
      ** Else, return the transaction reference read
     C                   ELSE
      *
      ** Instrument Type
      *
     C                   MOVE      ISTT          @TRISTT
 
     C                   IF        POTCFlag <> 'Y'
      *
      ** Convert Month Number into Month Name
      *
     C                   MOVE      ZMNM(MTHN)    @TRMTHN
 
     C                   ENDIF
      *
      ** Year Number
      *
     C                   MOVE      YRNO          @TRYRNO
      *
      ** Put/Call Indicator
      *
     C                   MOVE      PCAL          @TRPCAL
      *
      ** Translate Strike Price into screen format
      *
     C                   EXSR      TranSTRP
      *
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * CHAUTN - Check for user authority if not multi-branching
      *****************************************************************
     C     CHAUTN        BEGSR
      *
     C                   CALL      'ZVACTU'
     C                   PARM      'E'           ZACTN             1
     C                   PARM                    @@ERR             1 0
      *
      ** Return error message
     C                   IF        @@ERR = 1
     C                   EVAL      @ERRMS = 'FXM0292'
     C                   RETURN
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * VALTRN - validate transaction reference
      *****************************************************************
     C     VALTRN        BEGSR
      *
      ** Set the passed parameters to the key list (PRTRNN -> @@TRNN)
      *
      ** Instrument Type (from PRTRNN)
     C                   MOVE      PRISTT        @@ISTT
      *
      ** Translate the month equivalent to numeric (from PRTRNN)
     C                   EXSR      SubMonth
      *
      ** Year number (from PRTRNN)
     C                   MOVE      PRYRNO        @@YRNO
      *
      ** Put/Call Indicator (from PRTRNN)
     C                   MOVE      PRPCAL        @@PCAL
      *
      ** Numeric Equivalent of Strike Price
     C                   MOVE      @PSTRP        @@STRP
      *
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SubMonth - Substitute Month Value to Numeric format
      *****************************************************************
      *
     C     SUBMONTH      BEGSR
      *
     C                   SELECT
     C                   WHEN      PRMTHN = 'JAN'
     C                   MOVE      01            @@MTHN
     C                   WHEN      PRMTHN = 'FEB'
     C                   MOVE      02            @@MTHN
     C                   WHEN      PRMTHN = 'MAR'
     C                   MOVE      03            @@MTHN
     C                   WHEN      PRMTHN = 'APR'
     C                   MOVE      04            @@MTHN
     C                   WHEN      PRMTHN = 'MAY'
     C                   MOVE      05            @@MTHN
     C                   WHEN      PRMTHN = 'JUN'
     C                   MOVE      06            @@MTHN
     C                   WHEN      PRMTHN = 'JUL'
     C                   MOVE      07            @@MTHN
     C                   WHEN      PRMTHN = 'AUG'
     C                   MOVE      08            @@MTHN
     C                   WHEN      PRMTHN = 'SEP'
     C                   MOVE      09            @@MTHN
     C                   WHEN      PRMTHN = 'OCT'
     C                   MOVE      10            @@MTHN
     C                   WHEN      PRMTHN = 'NOV'
     C                   MOVE      11            @@MTHN
     C                   WHEN      PRMTHN = 'DEC'
     C                   MOVE      12            @@MTHN
     C                   OTHER
     C                   MOVE      0             @@MTHN
     C                   ENDSL
      *
     C                   ENDSR
      ************************************************************************
      /EJECT
      ************************************************************************
      * TranSTRP - Translate STRIKE PRICE into screen format
      ************************************************************************
      *
     C     TranSTRP      BEGSR
      *
      ** Get ticks denominator and minimum price fluctuation so that
      ** we can correctly format the contract and strike price for screen
      ** output.
 
     C                   Z-ADD     *ZERO         TKDM2
     C                   Z-ADD     *ZERO         MNPF2
 
     C     ISTT          CHAIN     INTYP                              50
 
     C*****@TRMRKT       IFNE      *BLANK                                                   BUG10387
     C     POTCFlag      IFNE      'Y'                                                      BUG10387
     C     ISPT          ANDGT     3
     C     ISPT          ANDNE     7
     C                   EVAL      KMRKT  = PRMRKT
     C                   EVAL      KISTC  = PRISTC
     C     ISTTK         CHAIN     INTYP2                             50
     C                   ELSE
     C                   Z-ADD     TKDM          TKDM2
     C                   Z-ADD     MNPF          MNPF2
     C                   ENDIF
 
      ** 'Futures'
 
     C     ISPT          IFLE      3
     C     ISPT          OREQ      7
     C                   EVAL      @TRSTRP = *BLANKS
     C                   EVAL      @PSTRP  = *ZERO
 
      ** 'Options'
 
     C                   ELSE
 
     C                   Z-ADD     TKDM2         FFTKDM            3 0
     C                   Z-ADD     MNPF2         FFMNPF           15 8
     C                   Z-ADD     STRP          FFPRIC           15 8
      *
      ** Format price
     C                   RESET                   ReturnCode
     C                   CALLB     'FFPRCS'
      ** -----------------------------------------
      ** Parameters returned from called procedure
      ** -----------------------------------------
      ** Return code
      ** Screen version of price (16A)
     C                   PARM                    ReturnCode
     C                   PARM                    FFSPRC
      ** -------------------------------------
      ** Parameters passed to called procedure
      ** -------------------------------------
      ** File version of price (15,8P)
      ** Tick denominator (3,0P)
      ** Minimum price fluctuation (15,8P)
     C                   PARM                    FFPRIC
     C                   PARM                    FFTKDM
     C                   PARM                    FFMNPF
 
     C                   MOVE      FFSPRC        @TRSTRP
     C                   EVAL      @PSTRP  = STRP
 
     C                   ENDIF
      *
      *
     C                   ENDSR
      ************************************************************************
      /EJECT
      ************************************************************************
      ** The following /COPY contains the standard program status
      ** subroutine, excluding a bound call to the DBERRCTL module.
      ************************************************************************
     C/COPY ZACPYSRC,PSSR_ILENE
     C                   RETURN
      *
     C                   ENDSR
      *****************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2006
**   ZMNM - MONTHS SHORT NAMES
JANFEBMARAPRMAYJUNJULAUGSEPOCTNOVDEC
