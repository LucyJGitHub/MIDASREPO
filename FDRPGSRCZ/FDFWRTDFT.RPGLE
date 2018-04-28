     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas FD Rates Default, if S01432 is on')
      *****************************************************************
      *                                                               *
      *  Midas - Forward Rates Module                                 *
      *                                                               *
      *  FDFWRTDFT - Default first rate if S01432 is on               *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      *    This source is centrally supported and must ONLY be        *
      *    amended by Core Development Personnel                      *
      *                                                               *
      *    /COPY, Client or Country amendments must not be            *
      *    applied to this source.                                    *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Last Amend No. 238467             Date 16Aug06               *
      *  Prev Amend No. 235720             Date 18Nov03               *
      *                 BUG11740           Date 21Jul06               *
      *                 CSD031             Date 10Apr06               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *                 CSD006             Date 07Nov00               *
      *                 CAP059   *CREATE   Date 07Nov00               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  238467 - MMA1157 appears unnecessarily.  Do not validate the *
      *           first rate since it is defaulted to spot rate.      *
      *  235720 - JPY is not allowed to have 8 decimal places. Decimal*
      *           places for spot rate is selected based on its diffe-*
      *           rence to the decimal place of the base rate. This   *
      *           selection should be removed.                        *
      *           Applied BUG11740 in part.                           *
      *  BUG11740 - Error 'First Rate not amendable' displayed on     *
      *             Insert                                            *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD006 - Market Data Feeds                                   *
      *  CAP059 - Conversion of Forward Rates into Modular APIs       *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      *****************************************************************
 
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
 
      ** Include the GL standard declares
     D/COPY GLCPYSRC,STDDECLARE
 
      ** Program Status Data Structure
      ** =============================
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
 
     D/COPY ZACPYSRC,PSDS
      ** The following /COPY line includes definitions for the above fields
      ** as #ProcPgm, #ProcMod and #ProcName.  They are based on the
      ** corresponding fields in the PSDS /COPY member, so that member
      ** must be included where this one is used.
 
     D/COPY ZACPYSRC,PROCPARMS
 
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
 
 
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
      ** EXTERNAL DS FOR CURRENCY DETAILS
 
     D DSFDY         E DS                  EXTNAME(DSFDY)
      * FIRST DS FOR ACCESS PROGRAMS, SHORT DATA STRUCTURE
 
     D DSSDY         E DS                  EXTNAME(DSSDY)
      * SECOND DS FOR ACCESS PROGRAMS, LONG DATA STRUCTURE
 
      ** Difference in Number of decimal places between Fwrd Ccy
      ** and Base Ccy
     D*** DiffNDP         S              1  0                                                 235720
 
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** EXTERNAL DS FOR BANK DETAILS
 
      ** Flags to indicate whether transaction fields are valid
     D OKFlagsDS     E DS                  EXTNAME(FDEFWRTPD)
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
     D Idx             S              3P 0
     D DDRTE1          S             14
 
     D*** WKFLD12p6       S             12P 6                                                 235720
     D*** WKFLD12p7       S             12P 7                                                 235720
     D*** WKFLD12p8       S             12P 8                                                 235720
     D WKFLD13p8       S             13P 8                                                    235720
 
      ** Base Currency Number of decimal places
     D BNBDP           S              1  0
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *****************************************************************
      /EJECT
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
 
      *  First rate should be defaulted to the screen if:
      *  S01432 is on
      *  Whether values have already been entered into these fields is handled in SIN/CTL
 
     C                   EVAL      DDRTE1 = WKRTE1
 
     C                   IF          S01432 = 'Y'
     C                   EXSR      SRDEFLT
     C                   ENDIF
 
     C**********         IF        DDRTE1 <> WKRTE1  AND                                      238467
     C**********                   DDRTE1 <> *BLANKS                                          238467
     C**********         ADD       1             Idx                                          238467
     C**********         EVAL      FldNameArr(Idx) = 'DDACTN'                                 238467
     C**********         EVAL      MsgIDArr(Idx)   = 'MMA1157'                                238467
     C**********         EVAL      DDACTNOK        = 'N'                                      238467
     C**********         ENDIF                                                                238467
 
     C                   IF        RESETERRS = 'N'
     C                   EVAL      WKRTE1 = DDRTE1
     C                   ENDIF
 
     C                   RETURN
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SRDEFLT - Routine to default first rate
      *****************************************************************
     C     SRDEFLT       BEGSR
      *
      * Access currency data
      * (Database error handling done in access program).
      *
     C                   CALLB     'AOCURRR0'
     C                   PARM      *BLANKS       @RTCD             7
     C                   PARM      '*KEY   '     @OPTN             7
     C                   PARM      DDCCY         @KEYCY            3
     C     SDCURR        PARM      SDCURR        DSSDY
 
     C**********         EVAL      DiffNDP = A6NBDP - BNBDP + 4                             BUG11740
      **********                                                                            BUG11740
     C**********         SELECT                                                             BUG11740
      **********                                                                            BUG11740
     C**********         WHEN      DiffNDP = 1                                              BUG11740
     C**********         Z-ADD     6             ZADEC                                      BUG11740
      **********                                                                            BUG11740
     C**********         WHEN      DiffNDP = 2                                              BUG11740
     C**********         Z-ADD     7             ZADEC                                      BUG11740
      **********                                                                            BUG11740
     C**********         OTHER                                                              BUG11740
     C                   Z-ADD     8             ZADEC
 
     C**********         ENDSL                                                              BUG11740
 
      * If insert and S01432 is on default spot rate into first rate field
 
     C                   IF        DDACTN = 'I' AND S01432 = 'Y'
     C                   MOVE      *BLANKS       ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        WKRTE1
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * ZEDIT - Edit an unsigned field                                *
      *                                                               *
      *****************************************************************
     C     ZEDIT         BEGSR
 
     C**********         SELECT                                                             BUG11740
      **********                                                                            BUG11740
     C**********         WHEN      DiffNDP = 1                                              BUG11740
     C**********         Z-ADD     A6SPRT        WKFLD12p6                                  BUG11740
     C**********         MOVE      WKFLD12p6     ZFIELD                                     BUG11740
     C**********         EVAL      ZADEC = 6                                                BUG11740
      **********                                                                            BUG11740
     C**********         WHEN      DiffNDP = 2                                              BUG11740
     C**********         Z-ADD     A6SPRT        WKFLD12p7                                  BUG11740
     C**********         MOVE      WKFLD12p7     ZFIELD                                     BUG11740
     C**********         EVAL      ZADEC = 7                                                BUG11740
      **********                                                                            BUG11740
     C**********         OTHER                                                              BUG11740
     C**********         Z-ADD     A6SPRT        WKFLD12p8                                    235720
     C**********         MOVE      WKFLD12p8     ZFIELD                                       235720
     C                   Z-ADD     A6SPRT        WKFLD13p8                                    235720
     C                   MOVE      WKFLD13p8     ZFIELD                                       235720
     C                   EVAL      ZADEC = 8
 
     C**********         ENDSL                                                              BUG11740
 
     C                   CALLB     'ZEDIT'
     C                   PARM                    ZFIELD           16
     C                   PARM                    ZADEC             1 0
 
     C**********         SELECT                                                             BUG11740
      **********                                                                            BUG11740
     C**********         WHEN      DiffNDP = 1                                              BUG11740
     C**********                   AND ZFIELD = '        0.000000'                          BUG11740
     C**********         EVAL      ZFIELD = *BLANK                                          BUG11740
      **********                                                                            BUG11740
     C**********         WHEN      DiffNDP = 2                                              BUG11740
     C**********                   AND ZFIELD = '       0.0000000'                          BUG11740
     C**********         EVAL      ZFIELD = *BLANK                                          BUG11740
      **********                                                                            BUG11740
     C**********         OTHER                                                              BUG11740
     C                   IF        ZFIELD = '      0.00000000'
     C                   EVAL      ZFIELD = *BLANK
     C                   ENDIF
 
     C**********         ENDSL                                                              BUG11740
 
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      * *INZSR - Program Initialisation routine                       *
      *****************************************************************
 
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
      * Return Code
     C                   PARM                    RetCodeIn
      ** Action Code
     C                   PARM                    DDACTN            1
      ** Currency Code
     C                   PARM                    DDCCY             3
      ** First Rate
     C                   PARM                    WKRTE1           14
 
      * Field OK flags (DS) from/to caller
     C                   PARM                    OKFlagsDS
      *
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
      *
      * Array index (3P0) from/to caller
     C                   PARM                    Idx
      *
      * Reset of Fields in Error Required (Y/N)
     C                   PARM                    ResetErrs         1
      *
 
      *  Move program name into *LDA field.
     C     *LOCK         In        LDA
     C                   Movel     'FDFWRTDFT'   DBPGM
     C                   Out       LDA
      *
      * Access Bank details via access program
      * (database error handling done in access program).
      *
     C                   CALLB     'AOBANKR0'
     C                   PARM      '*DBERR '     @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
      *
      *  Set up the name of the MSGF from which the message handler will
      *  obtain the messages.
      *
     C                   EVAL      #MsgFile = 'DRSMM'
 
      ** Check if switchable feature CSD006 is switched on.                     CSD006
      ** Market Data Feeds.                                                     CSD006
      *                                                                         CSD006
     C                   CALL      'AOSARDR0'                                   CSD006
     C                   PARM      *BLANKS       @RTCD                          CSD006
     C                   PARM      '*VERIFY'     @OPTN                          CSD006
     C                   PARM      'CSD006'      @SARD             6            CSD006
      *
      ** Database Error
      *                                                                         CSD006
     C     @RTCD         IFNE      *BLANKS
     C     @RTCD         ANDNE     '*NRF   '                                    CSD006
     C                   MOVEL     'CSD006'      DBKEY                          CSD006
     C                   MOVEL     'SCSARDPD'    DBFILE                         CSD006
     C                   MOVEL     '902'         DBASE                          CSD006
     C                   EXSR      *PSSR                                        CSD006
     C                   ENDIF                                                  CSD006
     C     @RTCD         IFEQ      *BLANK                                       CSD006
     C                   MOVE      'Y'           CSD006            1            CSD006
     C                   ELSE                                                   CSD006
     C                   MOVE      'N'           CSD006                         CSD006
     C                   ENDIF                                                  CSD006
 
      ** Check if switchable feature S01432 is switched on.
      ** Forward Ratess Maintenance.
      *
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'S01432'      @SARD             6
      *
      ** Database Error
      *
     C     @RTCD         IFNE      *BLANKS
     C     @RTCD         ANDNE     '*NRF   '
     C                   MOVEL     'S01432'      DBKEY
     C                   MOVEL     'SCSARDPD'    DBFILE
     C                   MOVEL     '902'         DBASE
     C                   EXSR      *PSSR
     C                   ENDIF
     C     @RTCD         IFEQ      *BLANK
     C                   MOVE      'Y'           S01432            1
     C                   ELSE
     C                   MOVE      'N'           S01432
     C                   ENDIF
 
      ** Check if switchable feature CEU026 is switched on.
      *
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CEU026'      @SARD             6
      *
      ** DATABASE ERROR
      *
     C     @RTCD         IFNE      *BLANKS
     C     @RTCD         ANDNE     '*NRF   '
     C                   MOVEL     'CEU026'      DBKEY
     C                   MOVEL     'SCSARDPD'    DBFILE
     C                   MOVEL     '902'         DBASE
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C     @RTCD         IFEQ      *BLANK
     C                   MOVE      'Y'           CEU026            1
     C                   ELSE
     C                   MOVE      'N'           CEU026
     C                   ENDIF
      *
      ** Retrieve details about the base currency code
      *
     C                   CALLB     'AOCURRR0'
     C                   PARM      *BLANK        @RTCD             7
     C                   PARM      '*KEY    '    @OPTN             7
     C                   PARM      BJCYCD        @KEY              3
     C     SDCURR        PARM      SDCURR        DSSDY
      *
     C                   EVAL      BNBDP = A6NBDP
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      ********************************************************************
      ** =================================================================
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
     C/COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
      /EJECT
