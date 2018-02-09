     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2004')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas TI Initialise SDBSRTPF and ACCNTAB')             *
      *****************************************************************
      *                                                               *
      *  Midas - Trade Innovation Module                              *
      *                                                               *
      *  TI002000 - Initialise SDBSRTPF and ACCNTAB                   *
      *                                                               *
      *  Function:  This program will patch field BAVDTO on file      *
      *             SDBSRTPD with value 6991231.                      *
      *             This program will also update A5ACKY, A5INTL,     *
      *             and A5TIAB on file ACCNTAB.                       *
      *                                                               *
      *  (c) Finastra International Limited 2004                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CRE073             Date 06Dec10               *
      *                 CRE075             Date 06Dec10               *
      *                 CER059             Date 19Jul10               *
      *                 CER047             Date 19May08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 245028             Date 02Mar07               *
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD031             Date 10Apr06               *
      *                 CSD027             Date 09Dec05               *
      *                 BUG3394            Date 24Jun04               *
      *                 BUG2814            Date 25May04               *
      *                 CTI004  *CREATE    Date 12Apr04               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CRE073 - Interest Rate Rounding (Recompile)                  *
      *  CRE075 - Effective Date for Retail Accounts (Recompile)      *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER047 - German Features LF037-00 Reporting §24c KWG         *
      *           (Recompile)                                         *
      *  245028 - Introduce new parameter to control update of        *
      *           ACCNTAB. Modify init of TI Date in SDBSHSPD.        *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  BUG3394- Base rate change dates are invalid in TI on take-on *
      *  BUG2814 - Add Base Rates History to the initialisation.      *
      *  CTI004 - MidasPlus-TI Integration Enhancements               *
      *           Base Rates Integration                              *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *    XX         Function of Indicator                           *
      *    98         Date Format                                     *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      * SRBSRT - Update SDBSRTPD fields.                              *
      * SRBSHS - Update SDBSHSPD fields.                              *                      BUG2814
      * SRACCT - Update ACCNTAB fields.                               *
      * *PSSR  - Error processing                                     *
      * *INZSR - Initialise                                           *
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
 
      ** Midas SD Base Rate File
     FSDBSRTPD  UF   E           K DISK    INFSR(*PSSR)
     F                                     COMMIT
 
      ** Midas SD Base Rate History File                                                     BUG2814
     FSDBSHSL1  UF   E           K DISK    INFSR(*PSSR)                                      BUG2814
     F                                     COMMIT                                            BUG2814
                                                                                             BUG2814
      ** Midas Account Master File
     FACCNTAB   UF   E           K DISK    INFSR(*PSSR)
     F                                     PREFIX(AC_)
     F                                     COMMIT
 
      ** SD Branch Codes
     FSDBRCHL5  IF   E           K DISK
 
      *****************************************************************
      /EJECT
     E/COPY ZSRSRC,ZDATE9Z1LE                                                                 245028
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ D-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
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
 
      ** External DS for Branch Details
     D SDBRCH        E DS                  EXTNAME(SDBRCHPD)
     D                                     PREFIX(DS_)
 
     D DSSDY         E DS                  EXTNAME(DSSDY)
      * Second DS for access programs, LONG DATA STRUCTURE
 
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
 
     D/COPY ZACPYSRC,PSDS
      *
      ** Program Status Data Structure
      *
      ** +-----------------------------------------------------------------+
      ** D specs of the following types should be inserted after the
      ** relevant box.  *** Remove this text afterwards. ***
      ** +-----------------------------------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
     D @RUN            S              1
     D WCust           S              6A
     D WAcod           S             10A
     D WAcsq           S              2A
     D PRtCd           S              7A
     D POptn           S              7A
     D PBrch           S              3A
 
     D/COPY ZSRSRC,ZDATE9Z2LE                                                                 245028
      ** DEFINE FIELDS FOR ZDATE9                                                             245028
     D @@DAYN          S              5P 0                                                    245028
     D @YYYYMMDD       S              8S 0                                                    245028
     D @RETN           S              1A                                                      245028
                                                                                              245028
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
 
      *********************************************************************
      * MAIN PROCEDURE                                                    *
      *********************************************************************
      *                                                                                       245028
      ** Input parameter                                                                      245028
      *                                                                                       245028
     C     *ENTRY        PLIST                                                                245028
     C                   PARM                    P#ACC             1                          245028
      *
      ** Read in Installation Data
      *
     C     *DTAARA       DEFINE                  RUNDAT
     C     *DTAARA       DEFINE                  LDA
     C                   IN        RUNDAT
      *                                                                                      BUG2814
      **   Define KLIST                                                                      BUG2814
      *                                                                                      BUG2814
     C     BSHSKY        KLIST                                                               BUG2814
     C                   KFLD                    WCYCD                                       BUG2814
     C                   KFLD                    WBSRC                                       BUG2814
     C                   KFLD                    WVDNR                                       BUG2814
                                                                                              245028
     C     BSHSK         KLIST                                                                245028
     C                   KFLD                    WCYCD                                        245028
     C                   KFLD                    WBSRC                                        245028
 
      ** Initialize new field on SDBSRTPD
 
     C                   EXSR      SRBSRT
 
      ** Initialize new field on ACCNTAB
 
     C                   EXSR      SRACCT
 
      ** Terminate the program
 
     C                   EVAL      *INLR = *ON
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRBSRT - Populate new fields on SDBSRTPD                      *
      *                                                               *
      *****************************************************************
      *
     C     SRBSRT        BEGSR
 
      ** Read all records on SDBSRTPD
 
     C                   READ      SDBSRTPD
 
     C                   DOW       NOT %EOF(SDBSRTPD)
 
      ** Initialize BAVDTO tp 6991231
 
     C                   EVAL      BAVDTO = 6991231
     C                   Z-ADD     BACBSR        BACBRT                                       245028
                                                                                              245028
      ** Initialisation program should be run right after COB.  However,                      245028
      ** sometimes they are run in the middle of I/C phase.                                   245028
      ** If AMENDED today, set TI Date to (Value Date of New Rate - 1)                        245028
      ** Set to 6991231 if Back Valued base rate change and earlier than current date         245028
      ** Convert Midas Date to TI Date - CYYMMDD                                              245028
                                                                                              245028
     C     BATYLC        IFEQ      'A'                                                        245028
     C     BACBSR        ANDNE     BANBRT                                                     245028
     C     BACBSR        ANDNE     *ZEROS                                                     245028
     C     BAVDRC        ORNE      BAVDNR                                                     245028
     C     BAVDNR        ANDNE     *ZEROS                                                     245028
                                                                                              245028
     C     BAVDNR        SUB       1             @@DAYN                                       245028
     C                   EXSR      SRTIDAT                                                    245028
     C                   Z-ADD     @@CYMD        BAVDTO                                       245028
                                                                                              245028
     C                   ENDIF                                                                245028
                                                                                              245028
      ** If SDBSRT's BAVDNR is backvalued, get previous day rate from                         245028
      ** SDBSHSPD.  This is for new field BACBRT.                                             245028
                                                                                              245028
     C     BAVDNR        IFLE      BAVDRC                                                     245028
     C                   MOVE      BACYCD        WCYCD                                        245028
     C                   MOVE      BABSRC        WBSRC                                        245028
     C     BAVDNR        SUB       1             WVDNR                                        245028
                                                                                              245028
     C     BSHSKY        SETGT     SDBSHSL1                                                   245028
     C     BSHSK         READPE    SDBSHSL1                               85                  245028
                                                                                              245028
     C     *IN85         IFEQ      '0'                                                        245028
     C                   Z-ADD     G0CBSR        BACBRT                                       245028
     C                   ENDIF                                                                245028
     C                   ENDIF                                                                245028
                                                                                              245028
     C                   UPDATE    SDBSRTD0
     C**********         COMMIT                                                               245028
                                                                                             BUG2814
      ** For each base rate record, set up the history records too.                          BUG2814
      ** Populate 'Date This Rate effective to:' to be use by T.I.                           BUG2814
                                                                                             BUG2814
     C     BAVDRC        IFGT      BAVDNR                                                    BUG3394
     C                   Z-ADD     BAVDRC        WHIDT                                       BUG3394
     C                   ELSE                                                                BUG3394
     C                   Z-ADD     BAVDNR        WHIDT                                       BUG3394
     C                   ENDIF                                                               BUG3394
     C     WHIDT         SUB       1             ZDAYNO                                      BUG3394
     C                   MOVE      'D'           DFF               1                          245028
     C                   CALL      'ZDATE2'                                                  BUG3394
     C                   PARM                    ZDAYNO            5 0                       BUG3394
     C                   PARM                    DFF                                         BUG3394
     C                   PARM                    ZDATE             6 0                       BUG3394
     C                   PARM                    ZADATE            7                         BUG3394
     C                   MOVEL     ZDATE         W1DDMM            4                         BUG3394
     C                   MOVEL     W1DDMM        W1DD              2                         BUG3394
     C                   MOVE      W1DDMM        W1MM              2                         BUG3394
     C                   MOVE      W1DD          W1MMDD            4                         BUG3394
     C                   MOVEL     W1MM          W1MMDD            4                         BUG3394
     C                   MOVE      ZDATE         W1YY              2                         BUG3394
     C                   MOVE      W1MMDD        WYDM              6                         BUG3394
     C                   MOVEL     W1YY          WYDM                                        BUG3394
     C                   MOVEL     '1'           WDATE             7                         BUG3394
     C                   MOVE      WYDM          WDATE                                       BUG3394
     C                   MOVE      WDATE         WPVDTO                                      BUG3394
                                                                                              245028
      ** Records in SDBSHSPD have rates up to date of SDBSRTPD/BAVDRC.                        245028
      ** Any records in SDBSHSPD greater than BAVDRC should be updated                        245028
      ** with TI date of 6991231 because XD4PF doesn't need them.                             245028
                                                                                              245028
     C                   Z-ADD     BAVDRC        WHIDT                                        245028
     C     WHIDT         SUB       1             @@DAYN                                       245028
     C                   EXSR      SRTIDAT                                                    245028
     C                   Z-ADD     @@CYMD        WPVDTO                                       245028
                                                                                              245028
     C                   Z-ADD     BACBSR        WCBSR            11 7                       BUG3394
                                                                                             BUG3394
     C                   EXSR      SRVDTO                                                    BUG2814
     C                   COMMIT                                                               245028
 
      ** Read next record
 
     C                   READ      SDBSRTPD
     C                   ENDDO
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      ********************************************************************                   BUG2814
      *                                                                  *                   BUG2814
      * SRVDTO - Populate G0VDTO and G0CHGD for Midas-TI Interface       *                   BUG2814
      *                                                                  *                   BUG2814
      ********************************************************************                   BUG2814
      *                                                                                      BUG2814
     C     SRVDTO        BEGSR                                                               BUG2814
      *                                                                                      BUG2814
      ** Read all CCY/Rate records backward and set date 'Date This                          BUG2814
      ** Rate effective to:' until Rate Change indicator (G0CHGD) is 'Y'.                    BUG2814
      *                                                                                      BUG2814
      ** Use fields BACBSR(current rate) and BAVDRC(current value date)                       245028
      ** as the backward starting point for SDBSHSPD because these two                        245028
      ** fields are not updated during I/C.  Reorg of file SDBSHSPD                           245028
      ** will only happen during COB based on new values of BANBRT/BAVDNR.                    245028
                                                                                              245028
      ** D4PF should filter unnecessary data on SDBSHSPD if BAVDNR is                         245028
      ** earlier than the last date on SDBSHSPD.                                              245028
                                                                                              245028
     C**********         MOVE      'Y'           W1STR             1                 BUG2814 BUG3394
     C                   MOVE      BACYCD        WCYCD             3                         BUG2814
     C                   MOVE      BABSRC        WBSRC             2 0                       BUG2814
     C                   MOVE      99999         WVDNR             5 0                       BUG2814
      ** Date Format is always 'D' even for US Midas system. Field is for TI use.            BUG2814
     C                   MOVE      'D'           DFF               1                         BUG2814
                                                                                              245028
     C     BSHSKY        SETGT     SDBSHSL1                                                  BUG2814
     C                   READP     SDBSHSL1                               32                 BUG2814
      *                                                                                      BUG2814
     C     *IN32         DOWEQ     *OFF                                                      BUG2814
     C     WCYCD         ANDEQ     G0CYCD                                                    BUG2814
     C     WBSRC         ANDEQ     G0BSRC                                                    BUG2814
     C*****WCHGD         ANDNE     'Y'                                               BUG2814 BUG3394
      *                                                                                      BUG2814
      ** If rate changes, set 'Date This Rate effective to:' to next date of its             BUG2814
      ***effectivity - 1 , otherwise set to 6991231. Format in CYYMMDD.              BUG2814 BUG3394
      ** effectivity - 1. Format in CYYMMDD.                                                 BUG3394
      *                                                                                      BUG2814
     C     WCBSR         IFEQ      G0CBSR                                                    BUG2814
     C*****W1STR         OREQ      'Y'                                               BUG2814 BUG3394
      *                                                                                      BUG2814
     C*****W1STR         IFEQ      'Y'                                               BUG2814 BUG3394
     C**********         Z-ADD     6991231       G0VDTO                              BUG2814 BUG3394
     C**********         MOVE      G0VDTO        WPVDTO                              BUG2814 BUG3394
     C**********         ELSE                                                        BUG2814 BUG3394
     C                   MOVE      WPVDTO        G0VDTO                                      BUG2814
     C**********         ENDIF                                                       BUG2814 BUG3394
      *                                                                                      BUG2814
     C                   ELSE                                                                BUG2814
     C     WHIDT         SUB       1             ZDAYNO                                      BUG2814
     C                   CALL      'ZDATE2'                                                  BUG2814
     C                   PARM                    ZDAYNO            5 0                       BUG2814
     C                   PARM                    DFF                                         BUG2814
     C                   PARM                    ZDATE             6 0                       BUG2814
     C                   PARM                    ZADATE            7                         BUG2814
     C                   MOVEL     ZDATE         W1DDMM            4                         BUG2814
     C                   MOVEL     W1DDMM        W1DD              2                         BUG2814
     C                   MOVE      W1DDMM        W1MM              2                         BUG2814
     C                   MOVE      W1DD          W1MMDD            4                         BUG2814
     C                   MOVEL     W1MM          W1MMDD            4                         BUG2814
     C                   MOVE      ZDATE         W1YY              2                         BUG2814
     C                   MOVE      W1MMDD        WYDM              6                         BUG2814
     C                   MOVEL     W1YY          WYDM                                        BUG2814
     C                   MOVEL     '1'           WDATE             7                         BUG2814
     C                   MOVE      WYDM          WDATE                                       BUG2814
     C                   MOVE      WDATE         G0VDTO                                      BUG2814
                                                                                              245028
     C     WHIDT         SUB       1             @@DAYN                                       245028
     C                   EXSR      SRTIDAT                                                    245028
     C                   Z-ADD     @@CYMD        G0VDTO                                       245028
     C                   MOVE      G0VDTO        WPVDTO            7 0                       BUG2814
     C                   ENDIF                                                               BUG2814
                                                                                              245028
      ** Records in SDBSHSPD is greater than or equal to SDBSRTPD's:                          245028
      **    BAVDRC - Current Rate change date                                                 245028
                                                                                              245028
     C     G0HIDT        IFGE      BAVDRC                                                     245028
     C                   Z-ADD     6991231       G0VDTO                                       245028
     C                   ENDIF                                                                245028
                                                                                              245028
     C                   MOVE      ' '           G0CHGD                                       245028
     C                   UPDATE    SDBSHSD0                                                  BUG2814
      *                                                                                      BUG2814
     C                   Z-ADD     G0CBSR        WCBSR            11 7                       BUG2814
     C                   Z-ADD     G0HIDT        WHIDT             5 0                       BUG2814
     C**********         MOVE      G0CHGD        WCHGD             1                 BUG2814 BUG3394
      *                                                                                      BUG2814
     C                   READP     SDBSHSL1                               32                 BUG2814
     C**********         MOVE      'N'           W1STR                               BUG2814 BUG3394
     C                   ENDDO                                                               BUG2814
      *                                                                                      BUG2814
      ** Start reading forward to update Rate Change Indicator                               BUG2814
      *                                                                                      BUG2814
     C                   Z-ADD     *ZEROS        WCBSR                                       BUG2814
     C                   READ      SDBSHSL1                               32                 BUG2814
      *                                                                                      BUG2814
     C     *IN32         DOWEQ     *OFF                                                      BUG2814
     C     WCYCD         ANDEQ     G0CYCD                                                    BUG2814
     C     WBSRC         ANDEQ     G0BSRC                                                    BUG2814
     C*****G0CHGD        ANDNE     'Y'                                               BUG2814 BUG3394
      *                                                                                      BUG2814
     C     WCBSR         IFNE      G0CBSR                                                    BUG2814
     C                   MOVE      'Y'           G0CHGD                                      BUG2814
     C                   UPDATE    SDBSHSD0                                                  BUG2814
     C                   ENDIF                                                               BUG2814
      *                                                                                      BUG2814
     C                   Z-ADD     G0CBSR        WCBSR                                       BUG2814
      *                                                                                      BUG2814
     C                   READ      SDBSHSL1                               32                 BUG2814
     C                   ENDDO                                                               BUG2814
      *                                                                                      BUG2814
     C                   ENDSR                                                               BUG2814
      *                                                                                      BUG2814
      ********************************************************************                   BUG2814
      /EJECT
      *****************************************************************
      *                                                               *
      * SRACCT - Populate new fields on ACCNTAB                       *
      *                                                               *
      *****************************************************************
      *
     C     SRACCT        BEGSR
 
      ** Read all records on ACCNTAB
 
     C                   READ      ACCNTAB
 
     C                   DOW       NOT %EOF(ACCNTAB)
                                                                                              245028
      ** Do not update ACCNTAB if field A5ACKY or A5INTL or A5TIAB                            245028
      ** is not equal to blanks.                                                              245028
      ** If P#ACC is blanks (from TIC002000) - selective update mode                          245028
      ** If P#ACC is 'Y'    (from TIC002001) - all records                                    245028
                                                                                              245028
     C                   MOVE      ' '           W#SKIP            1                          245028
     C     P#ACC         IFEQ      ' '                                                        245028
     C     P#ACC         OREQ      '1'                                                        245028
     C     P#ACC         OREQ      '2'                                                        245028
                                                                                              245028
     C     AC_A5ACKY     IFNE      *BLANKS                                                    245028
     C     AC_A5INTL     ORNE      *BLANKS                                                    245028
     C     AC_A5TIAB     ORNE      *BLANKS                                                    245028
     C                   MOVE      'Y'           W#SKIP                                       245028
     C                   ENDIF                                                                245028
                                                                                              245028
     C                   ENDIF                                                                245028
 
      ** Format SCOLDA Account Key
 
     C                   MOVE(P)   AC_CNUM       WCust
     C                   MOVE(P)   AC_ACOD       WAcod
     C                   MOVE(P)   AC_ACSQ       WAcsq
 
     C                   EVAL      AC_A5ACKY = AC_BRCA + WCust + AC_CCY
     C                                         + WAcod + WAcsq
 
      ** Setup Internal Flag
 
     C                   EVAL      AC_A5INTL = 'N'
 
     C     WCust         CHAIN     SDBRCHL5                           83
 
      ** Record found
     C                   IF        *IN83 = *OFF
     C                   EVAL      AC_A5INTL = 'Y'
     C                   ENDIF
 
      ** Setup TI Branch Number
 
     C                   CLEAR                   AC_A5TIAB
 
     C                   CALL      'AOBRCHR1'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*KEY   '     POPTN
     C                   PARM      AC_BRCA       PBRCH             3
     C     SDBRCH        PARM      SDBRCH        DSSDY
 
      ** Record found
     C                   IF        PRTCD = *BLANKS
     C                   EVAL      AC_A5TIAB = DS_A8TIBR
     C                   ENDIF
 
     C     W#SKIP        IFEQ      ' '                                                        245028
     C                   UPDATE    ACCNTABF
     C                   COMMIT
     C                   ENDIF                                                                245028
 
      ** Read next record
 
     C                   READ      ACCNTAB
     C                   ENDDO
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************                       245028
      *                                                               *                       245028
      * SRTIDAT - Convert Midas Date to TI Date - CYYMMDD             *                       245028
      *                                                               *                       245028
      *****************************************************************                       245028
                                                                                              245028
     C     SRTIDAT       BEGSR                                                                245028
                                                                                              245028
      **  Convert date from day number to YYYYMMDD                                            245028
                                                                                              245028
     C                   Z-ADD     @@DAYN        @@DAYN                                       245028
     C                   Z-ADD     *ZEROS        @@CYMD                                       245028
                                                                                              245028
     C                   EXSR      ZDATE9                                                     245028
                                                                                              245028
     C                   Z-ADD     @@VDT         @YYYYMMDD                                    245028
     C                   MOVEL     @YYYYMMDD     W#YY              2 0                        245028
                                                                                              245028
      ** Get century                                                                          245028
                                                                                              245028
     C                   SELECT                                                               245028
     C     W#YY          WHENEQ    20                                                         245028
     C                   MOVEL     1             W#CYYMMDD         7                          245028
     C     W#YY          WHENEQ    21                                                         245028
     C                   MOVEL     2             W#CYYMMDD                                    245028
     C     W#YY          WHENEQ    22                                                         245028
     C                   MOVEL     3             W#CYYMMDD                                    245028
     C     W#YY          WHENEQ    23                                                         245028
     C                   MOVEL     4             W#CYYMMDD                                    245028
     C     W#YY          WHENEQ    24                                                         245028
     C                   MOVEL     5             W#CYYMMDD                                    245028
     C     W#YY          WHENEQ    25                                                         245028
     C                   MOVEL     6             W#CYYMMDD                                    245028
     C                   OTHER                                                                245028
     C                   MOVEL     1             W#CYYMMDD                                    245028
     C                   ENDSL                                                                245028
                                                                                              245028
     C                   MOVE      @YYYYMMDD     W#YYMMDD          6                          245028
     C                   MOVE      W#YYMMDD      W#CYYMMDD                                    245028
                                                                                              245028
     C                   MOVE      W#CYYMMDD     @@CYMD            7 0                        245028
                                                                                              245028
     C                   ENDSR                                                                245028
      *****************************************************************                       245028
      /EJECT                                                                                  245028
     C/COPY ZSRSRC,ZDATE9Z3LE                                                                 245028
      *****************************************************************
      *                                                               *
      * *PSSR  - Program exception error routine                      *
      *          Called automatically if a program error occurs,      *
      *          or directly by the program code using EXSR.          *
      *          This subroutine DUMPs the program just once.         *
      *                                                               *
      * Called by: (**calling routines**)                             *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
      *
     C     *PSSR         BEGSR
      *
     C                   IF        @RUN = *BLANK
     C                   EVAL      @RUN = 'Y'
     C                   DUMP
      *
     C                   CALL      'DBERRCTL'
      *
     C                   ENDIF
      *
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN
      *
     C                   ENDSR
** @YD  USED BY SR. ZDATE9 - YEARS, IN DAYS, CUMULATIVE IN 4 YEAR SPAN                        245028
00366007310109601461                                                                          245028
** @MD  USED BY SR. ZDATE9 - MONTHS IN DAYS CUMULATIVE THROUGH YEAR                           245028
00000000310005900090001200015100181002120024300273003040033400365                             245028
