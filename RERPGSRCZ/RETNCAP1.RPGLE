     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2009')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas RE Retail Term & Notice: Cap Date Calcs')        *
      *****************************************************************
      *                                                               *
      *  Midas     - Retail T&N Accounts                              *
      *                                                               *
      *  RPG/RETNCAP1 - Calculate value, maturity and end dates for   *
      *             Midas Retail Term & Notice                        *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2009            *
      *                                                               *
      *  Last Amend No. CCB020             Date 06Aug12               *
      *  Prev Amend No. CRE073             Date 06Dec10               *
      *                 CRE075             Date 06Dec10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      *                 230355             Date 18Dec09               *
      *                 228430             Date 18Dec09               *
      *                 227316             Date 18Dec09               *
      *                 223609             Date 18Dec09               *
      *                 CRE015  *CREATE    Date 18Dec09               *
      *---------------------------------------------------------------*
      *  CCB020 - COB Restructure - Secondary COB Infrastructure      *
      *  CRE073 - Interest Rate Rounding (Recompile)                  *
      *  CRE075 - Effective Date for Retail Accounts (Recompile)      *
      *  230355 - Recompile over changes in REPRPNPD.                 *
      *  228430 - Ensure NOACRD alwasys has a value.                  *
      *  227316 - Ensure that all the records for the same account    *
      *           have the same next cap date                         *
      *  223609 - Next cap date not calculated for insert of account  *
      *  CRE015 - Retail Term and Notice Accounts                     *
      *****************************************************************
 
      ** Period & Penalty Details
 
     FREPRPNPD  UF   E           K DISK    INFSR(*PSSR)
     F                                     COMMIT
 
      ** Account Details
 
     FACCNT     UF   E           K DISK    INFSR(*PSSR)
     F                                     IGNORE(ACCNTAAF)
     F                                     IGNORE(ACCNTACF)
     F                                     COMMIT
 
      *****************************************************************
 
      ** The following /COPY line includes (among others) the LDA layout
      ** and the copyright array definition:
 
     D/COPY ZACPYSRC,STD_D_SPEC
 
      ** The following /COPY includes the MM standard declares:
 
     D/COPY ZACPYSRC,STDDECLARE
 
      ** The following /COPY line includes all the defined fields in the
      ** Program Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'.
 
     D/COPY ZACPYSRC,PSDS
 
      /EJECT
 
      *****************************************************************
 
      ** DATA STRUCTURE FOR GENERAL LEDGER DETAILS                                            220095
 
     D SDGELR        E DS                  EXTNAME(SDGELRPD)                                  220095
 
      ** FIRST DS FOR ACCESS PROGRAMS, SHORT DATA STRUCTURE                                   220095
 
     D DSFDY         E DS                  EXTNAME(DSFDY)                                     220095
 
      ** Bank details
 
     D BKFMT         E DS                  EXTNAME(SDBANKPD)
 
      ** Period & Penalties
 
     D REPFMT        E DS                  EXTNAME(REPRPNPD)
 
      ** Account details
 
     D ACFMT         E DS                  EXTNAME(ACCNTAB)
 
      ** Parameters
 
     D P@FMT         E DS                  EXTNAME(DSSDY)
 
      ** Convert ddmmyy into separate components for start/work date
 
     D DTCVT           DS
     D  WDMY                   1      6  0
     D  WDAY                   1      2  0
     D  WMTH                   3      4  0
     D  WYEAR                  5      6  0
 
      ** Convert ddmmyy into separate components for given month
 
     D DTCVT2          DS
     D  GVNDMY                 1      6  0
     D  GVNDAY                 1      2  0
     D  GVNMTH                 3      4  0
     D  GVNYER                 5      6  0
 
      ** Period and Penalties key
 
     D DTRPKEY         DS
     D  RPKEY1                 1     28
     D  K2BRCA                 1      3
     D  K2CNUM                 4      9
     D  K2CCY                 10     12
     D  K2ACOD                13     22  0
     D  K2ACSQ                23     24  0
     D  K2EVNT                25     25
     D  K2ITEM                26     28P 0
 
      ****************************************************************
 
     C                   EXSR      INIT
 
     C                   EXSR      MAIN
 
     C                   SETON                                        LR
     C                   RETURN
      *****************************************************************
      *                                                               *
      *  INIT   - Program Initialization                              *
      *                                                               *
      *****************************************************************
     C     INIT          BEGSR
 
     C     *ENTRY        PLIST
 
      ** Date to calculate next cap date from
 
     C                   PARM                    PDATE             5 0
 
      ** Key for Period & Penalties
 
     C                   PARM                    PBRCA             3
     C                   PARM                    PCNUM             6
     C                   PARM                    PCCY              3
     C                   PARM                    PACOD            10 0
     C                   PARM                    PACSQ             2 0
 
      ** Mode
 
     C                   PARM                    PMODE             7
     C                   PARM                    PRTCD             7
 
      ** Ignore default records
 
     C     PBRCA         IFEQ      *BLANKS
     C     PCNUM         OREQ      *BLANKS
     C     PCCY          OREQ      *BLANKS
     C     PACOD         OREQ      0
     C     PACSQ         OREQ      0
     C                   SETON                                        LR
     C                   RETURN
     C                   ENDIF
 
      ** Set run date                                                                         227316
 
     C                   Z-ADD     PDATE         RDATE             5 0                        227316
 
     C******DTAARA       DEFINE                  MPHAS             1                          CCB020
     C**********         IN        MPHAS                                                      CCB020
 
      ** Bank details
 
     C     BKFMT         IFEQ      *BLANKS
     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANKS       P@RTCD            7
     C                   PARM      '*FIRST'      P@OPTN            7
     C     BKFMT         PARM      *BLANKS       P@FMT
     C                   END
 
      ** ACCESS GENERAL LEDGER DETAILS (SDGELRPD)                                             155539
 
     C                   CALL      'AOGELRR0'                                                 155539
     C                   PARM      '*MSG   '     @RTCD             7                          155539
     C                   PARM      '*FIRST '     @OPTN             7                          155539
     C     SDGELR        PARM      SDGELR        DSFDY                                        155539
 
      * ACCNTAB key list
 
     C     AKEY1         KLIST
     C                   KFLD                    ACNUM             6
     C                   KFLD                    ACCY              3
     C                   KFLD                    AACOD            10 0
     C                   KFLD                    AACSQ             2 0
     C                   KFLD                    ABRCA             3
 
     C     KPRPN1        KLIST
     C                   KFLD                    K2BRCA
     C                   KFLD                    K2CNUM
     C                   KFLD                    K2CCY
     C                   KFLD                    K2ACOD
     C                   KFLD                    K2ACSQ
     C                   KFLD                    K2EVNT
     C                   KFLD                    K2ITEM
 
     C     KPRPN3        KLIST
     C                   KFLD                    K2BRCA
     C                   KFLD                    K2CNUM
     C                   KFLD                    K2CCY
     C                   KFLD                    K2ACOD
     C                   KFLD                    K2ACSQ
 
     C                   ENDSR
      *****************************************************************
      *                                                               *
      *  MAIN   - Main Processing                                     *
      *                                                               *
      *****************************************************************
     C     MAIN          BEGSR
 
      ** Get account details
 
     C                   EXSR      GETACC
 
      ** Read through REPRPNPD for this account
 
     C                   MOVE      PBRCA         K2BRCA
     C                   MOVE      PCNUM         K2CNUM
     C                   MOVE      PCCY          K2CCY
     C                   Z-ADD     PACOD         K2ACOD
     C                   Z-ADD     PACSQ         K2ACSQ
     C                   MOVE      'A'           K2EVNT
     C                   Z-ADD     1             K2ITEM
     C                   Z-ADD     0             COUNT             3 0                        227316
     C                   Z-ADD     0             W9DMIN            5 0                        227316
     C                   Z-ADD     0             W9CMIN            5 0                        227316
     C     KPRPN1        SETLL     REPRPNPD
     C     KPRPN3        READE     REPRPNPD                               71
     C     *IN71         DOWEQ     '0'
     C                   ADD       1             COUNT                                        227316
                                                                                              227316
      ** If not the first run through of the loop (i.e. not the first record)                 227316
                                                                                              227316
     C     COUNT         IFGT      1                                                          227316
                                                                                              227316
      ** Set the min cap dates to be the same as for previous record                          227316
     C     W9DCAP        IFNE      E2NDID                                                     227316
     C     W9CCAP        ORNE      E2NCID                                                     227316
     C                   Z-ADD     W9DCAP        E2NDID                                       227316
     C                   Z-ADD     W9CCAP        E2NCID                                       227316
     C                   EXCEPT    REPRP                                                      227316
     C                   ENDIF                                                                227316
                                                                                              227316
      ** Else if it is the first read of REPRPNPD                                             227316
                                                                                              227316
     C                   ELSE                                                                 227316
 
      ** Debit calculations
 
     C                   MOVE      'D'           W9DRCR            1
     C                   MOVE      E2DRIF        W9XRIF            1
     C                   Z-ADD     E2DRDY        I9XRDY            4 0
     C                   Z-ADD     E2DRDY        W9XRDY            4 0
     C                   Z-ADD     E2NDID        I9NXID            5 0
     C                   Z-ADD     LDID          W9LXID            5 0                        223609
 
      ** Determine whether to advance and update next cap date:
 
     C                   EXSR      CHKUPD
 
      ** If yes then calculate next cap date
 
     C     UPDXID        IFEQ      'Y'
     C                   EXSR      CAP0
 
      ** Position to original record and update if necessary
 
     C                   EXSR      POSREP
     C                   EXSR      UPDATE
     C                   ENDIF
 
      ** Credit calculations
 
     C                   MOVE      'C'           W9DRCR            1
     C                   MOVE      E2CRIF        W9XRIF            1
     C                   Z-ADD     E2CRDY        I9XRDY            4 0
     C                   Z-ADD     E2CRDY        W9XRDY            4 0
     C                   Z-ADD     E2NCID        I9NXID            5 0
     C                   Z-ADD     LCID          W9LXID                                       223609
 
      ** Determine whether to advance and update next cap date:
 
     C                   EXSR      CHKUPD
      ** If yes then calculate next cap date
 
     C     UPDXID        IFEQ      'Y'
     C                   EXSR      CAP0
 
      * Position to original record and update if necessary
 
     C                   EXSR      POSREP
     C                   EXSR      UPDATE
     C                   ENDIF
 
      ** First run through gives the next cap dates; thereafter just                          227316
      ** update the remaining records to have the same next cap date                          227316
                                                                                              227316
     C                   Z-ADD     E2NDID        W9DCAP            5 0                        227316
     C                   Z-ADD     E2NCID        W9CCAP            5 0                        227316
                                                                                              227316
      ** End of Count Condition                                                               227316
                                                                                              227316
     C                   ENDIF                                                                227316
 
     C     KPRPN3        READE     REPRPNPD                               71
 
      ** Retain parameters so can read this record again
 
     C                   MOVE      E2EVNT        K2EVNT
     C                   Z-ADD     E2ITEM        K2ITEM
     C                   ENDDO
 
     C                   ENDSR
      *****************************************************************
      *                                                               *
      *  POSREP - Find next record from key specified                 *
      *           (used in the program to reset values and reset the  *
      *           pointer for update)                                 *
      *                                                               *
      *****************************************************************
     C     POSREP        BEGSR
 
      ** Position to REPRPNPD record for this account
 
     C     KPRPN1        SETLL     REPRPNPD
     C                   READ      REPRPNPD                               90
 
     C     *IN90         IFEQ      *ON
     C     *LOCK         IN        LDA
     C                   MOVEL     'RETNCAP1'    DBPGM
     C                   MOVEL     'REPRPNPD'    DBFILE
     C                   Z-ADD     1             DBASE
     C                   MOVEL     RPKEY1        DBKEY
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      *                                                               *
      *  CHKUPD - Subroutine to check whether to advance and update   *
      *           next cap date                                       *
      *                                                               *
      *****************************************************************
     C     CHKUPD        BEGSR
 
      ** Determine whether to update next cap date:
      ** If no record found yet on ACCNTAB, (i.e. a newly inserted account)
      **  then calculate next cap date
      ** Else
      **  If next cap date on REPRPNPD < run date AND
      **    next cap date on REPRPNPD <= last cap date on ACCNTAB,
      **  Then update next cap date
      ** Alternatively
      ** If next cap date >= run date AND
      **     processing is not in close of business
      ** Then update next cap date
 
     C     NOACRD        IFEQ      'Y'                                                        223609
     C                   MOVE      'Y'           UPDXID                                       223609
     C                   ELSE                                                                 223609
     C                   MOVE      ' '           UPDXID            1
     C     I9NXID        IFLT      RDATE                                                      227316
     C     I9NXID        IFLE      W9LXID                                                     223609
     C                   MOVE      'Y'           UPDXID
     C                   ENDIF
     C                   ELSE
     C     PMODE         IFNE      '*COB'
     C                   MOVE      'Y'           UPDXID
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF                                                                223609
 
     C                   ENDSR
      *****************************************************************
      *                                                               *
      *  CAP0                                                         *
      *                                                               *
      *****************************************************************
     C     CAP0          BEGSR
 
      ** Set working run date
 
     C                   Z-ADD     PDATE         XDATE             5 0
 
      ** Advance to term or period which would be active for working
      **  run date
 
     C                   EXSR      ADVPER
 
      ** Calculate next cap date (whether or not it falls on a non-working
      ** day)
     C                   EXSR      CAPDAT
 
      ** Store next dates as previous dates in case they are advanced
      ** further
 
     C                   Z-ADD     W9CAPD        PRCAPD            5 0
     C                   Z-ADD     W9XRDY        PRXRDY            4 0
 
      ** Find next working day from cap date
 
     C                   EXSR      NXTWRK
 
      ** If cap date does not fall on a working day, check if there are any
      **  other cap dates before the next working day.
      **  i.e. go through same procedure again, but using a working run date
      **  of next cap date + 1
 
     C     NWD           SUB       1             NWDP              5 0
     C     W9CAPD        DOWLT     NWDP
     C                   Z-ADD     W9CAPD        PRCAPD
     C     1             ADD       W9CAPD        XDATE             5 0
     C                   EXSR      ADVPER
     C                   EXSR      CAPDAT
     C                   ENDDO
 
      ** Output final next cap dates
 
     C                   Z-ADD     PRCAPD        X9NXID            5 0
     C                   Z-ADD     PRXRDY        X9XRDY            4 0
 
     C                   ENDSR
      *****************************************************************
      *                                                               *
      *  ADVPER - Advance to term or period containing working run    *
      *           date, XDATE                                         *
      *                                                               *
      *****************************************************************
     C     ADVPER        BEGSR
 
      ** If value date or start date is very far in the future, then no need
      ** to calculate
 
     C     XDATE         IFGT      26664
     C                   Z-ADD     26664         XDATE
     C                   ENDIF
 
     C     E2VDAT        IFLT      26664
     C     XDATE         ANDLT     26664
 
      ** Advance to term where maturity >= XDATE
 
     C                   MOVE      '0'           *IN91
     C     E2MDAT        DOWLT     XDATE
     C     E2MDAT        ANDLT     26664
     C     *IN91         ANDNE     '1'
 
     C                   MOVE      XDATE         RUNCHG
     C                   CALL      'RETNDAT1'
     C                   PARM                    REPFMT
     C                   PARM      '*COB    '    MAINT             7
     C                   PARM                    RUNCHG            5
     C                   PARM                    PRCEDE            5 0
     C                   PARM                    PRTCD             7
 
     C     *INU7         IFEQ      '1'
     C     *INU8         OREQ      '1'
     C     PRTCD         OREQ      '*ERROR'
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** If maturity is less than working run date, then we need to advance
      **  to a new period.
 
     C     E2MDAT        IFLT      XDATE
     C     KPRPN3        READE     REPRPNPD                               91                  223609
     C     *IN91         IFEQ      '1'
     C                   Z-ADD     26664         E2VDAT
     C                   Z-ADD     26664         E2MDAT
     C                   ENDIF
     C                   ENDIF
     C                   ENDDO
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      *                                                               *
      *  CAPDAT - Capitalization Date                                 *
      *                                                               *
      *****************************************************************
     C     CAPDAT        BEGSR
 
     ** Minimum cap date must be end of term
     ** for notice a/c, this is end of period
 
     C     E2TPRD        IFEQ      'N'
     C                   Z-ADD     E2CEDE        W9EOTD            5 0
     C                   END
 
     ** for active term, this is maturity
 
     C     E2TPRD        IFEQ      'T'
     C     E2EVNT        ANDGE     'A'
     C     E2EVNT        ANDLT     'Z'
     C                   Z-ADD     E2MDAT        W9EOTD
     C                   END
 
     ** for termination, this is a long way in the future
 
     C     E2EVNT        IFEQ      'Z'
     C                   Z-ADD     26664         W9EOTD
     C                   END
 
      ** Initialise next cap date to far in the future
 
     C                   Z-ADD     26664         W9CAPD            5 0
      ** Initialise start date to far in the future
     C                   Z-ADD     26664         W9ADVD
 
      ** If frequency is 'Z' then there should be no day/month
 
     C     W9XRIF        IFEQ      'Z'
     C                   MOVE      '0000'        W9XRDY            4 0
     C                   END
 
      ** If frequency is 'M' monthly
      **                 'Q' quarterly
      **                 'X' half-yearly
      **                 'Y' yearly
      ** check to see if you need to advance the next frequency cap date
 
     C     W9XRIF        IFEQ      'M'
     C     W9XRIF        OREQ      'Q'
     C     W9XRIF        OREQ      'X'
     C     W9XRIF        OREQ      'Y'
     C                   EXSR      CAPFRQ
     C                   ENDIF
 
      ** Select minimum of advance-by-freq date and end-of-term date
 
     C     W9ADVD        IFLE      W9EOTD
     C                   Z-ADD     W9ADVD        W9CAPD
     C                   ELSE
     C                   Z-ADD     W9EOTD        W9CAPD
     C                   END
 
     C                   ENDSR
      *****************************************************************
      *                                                               *
      *  CAPFRQ - Do Next Cap Date Frequency calculations             *
      *                                                               *
      *****************************************************************
     C     CAPFRQ        BEGSR
 
      ** identify given frequency day and month
      ** (data structure GVNDMY splits into GVNDAY/GVMTH/GVNYER)
 
     C     W9XRDY        MULT      100           GVNDMY
 
      ** Redetermine start date for frequency
      ** (start date is lower limit on next frequency cap date and is
      ** equal to working run day or start of term, whichever later)
 
     C     XDATE         IFGT      E2VDAT
     C                   Z-ADD     XDATE         W9ADVD            5 0
     C                   ELSE
     C                   Z-ADD     E2VDAT        W9ADVD            5 0
     C                   END
 
      ** Split up start date into WDAY/WMTH/WYEAR components
 
     C                   CALL      'ZDATE2'
     C                   PARM      W9ADVD        ZDAYNO            5 0
     C                   PARM      'D'           BJDFIN            1
     C                   PARM                    ZDATE             6 0
     C                   PARM                    ZADATE            7
     C                   MOVEL     ZDATE         WDMY
 
      ** If start date is the run day and the given day and given
      ** month have just passed then assume month must now be
      ** advanced
 
     C     W9ADVD        IFEQ      XDATE
     C     GVNMTH        ADD       1             W5N0              5 0
     C     W5N0          IFGT      12
     C                   SUB       12            W5N0
     C                   END
     C     W5N0          IFEQ      WMTH
     C     GVNMTH        OREQ      WMTH
     C     GVNDAY        ANDLT     WDAY
     C     W9XRIF        IFEQ      'M'
     C                   ADD       1             GVNMTH
     C                   END
     C     W9XRIF        IFEQ      'Q'
     C                   ADD       3             GVNMTH
     C                   END
     C     W9XRIF        IFEQ      'X'
     C                   ADD       6             GVNMTH
     C                   END
     C     W9XRIF        IFEQ      'Y'
     C                   ADD       12            GVNMTH
     C                   END
     C     GVNMTH        IFGT      12
     C                   SUB       12            GVNMTH
     C                   END
     C                   END
     C                   END
 
      ** Check if the given year needs advancing
      **  start with start date year
 
     C                   Z-ADD     WYEAR         GVNYER            2 0
     C     GVNMTH        IFLT      WMTH
     C                   ADD       1             GVNYER
     C                   END
     C     GVNMTH        IFEQ      WMTH
     C     GVNDAY        ANDLT     WDAY
     C                   ADD       1             GVNYER
     C                   END
 
      ** Convert this given date into Midas day number
      ** (i.e.  GVNDAY/GVNMTH/GVNYER -> Midas day number)
 
     C                   Z-ADD     GVNDMY        ZDATE
     C                   CALL      'ZDATE1'
     C                   PARM                    ZERR              7
     C                   PARM                    ZDATE             6 0
     C                   PARM      'D'           ZDATFM            1
     C                   PARM      0             ZDAYNO            5 0
     C                   Z-ADD     ZDAYNO        W9MIND            5 0
 
      **   if start date and inferred (minimum) given date are in same
      **   month, and start date <=given date, the std frequency routine
      **   unfortunately advances to the following month.
      **   So artificially subtract one month for this case
 
     C     WMTH          IFEQ      GVNMTH
     C     W9ADVD        ANDLE     W9MIND
     C                   SUB       31            W9ADVD
     C                   SUB       1             WMTH
     C                   END
 
      **   if start date dateh < given date, advance monthly until theyequal
      **    using given day for positioning within month
 
     C                   MOVEL     'N'           MTHOK             1
     C     W9ADVD        DOWLT     W9MIND
     C     MTHOK         OREQ      'N'
 
      ** Advance start/working date by one month
 
     C                   CALL      'ZFRQB5'
     C                   PARM      'M'           ZFREQ             1
     C                   PARM      W9ADVD        ZDAYNO            5 0
     C                   PARM      GVNDAY        ZMDAY             2 0
     C                   PARM      BJLCCY        ZCCY              3
     C                   PARM      *BLANKS       ZLOC              3
     C                   PARM      'F'           ZDIREC            1
     C                   PARM      *BLANKS       ZRTRN             7
     C                   Z-ADD     ZDAYNO        W9ADVD
 
      ** Convert this working date to WDAY/WMTH/WYEAR
 
     C                   CALL      'ZDATE2'
     C                   PARM      W9ADVD        ZDAYNO            5 0
     C                   PARM      'D'           BJDFIN            1
     C                   PARM                    ZDATE             6 0
     C                   PARM                    ZADATE            7
     C                   MOVEL     ZDATE         WDMY
 
      ** Find difference between working month and given month
 
     C     WMTH          SUB       GVNMTH        W3N0              3 0
     C     W3N0          IFLE      0
     C                   ADD       12            W3N0
     C                   END
 
      ** Difference must be a suitable multiple of given month
 
     C     W9XRIF        IFEQ      'M'
     C     W3N0          IFGE      1
     C     W3N0          ANDLE     12
     C                   MOVEL     'Y'           MTHOK
     C                   END
     C                   END
     C     W9XRIF        IFEQ      'Q'
     C     W3N0          IFEQ      3
     C     W3N0          OREQ      6
     C     W3N0          OREQ      9
     C     W3N0          OREQ      12
     C                   MOVEL     'Y'           MTHOK
     C                   END
     C                   END
     C     W9XRIF        IFEQ      'X'
     C     W3N0          IFEQ      6
     C     W3N0          OREQ      12
     C                   MOVEL     'Y'           MTHOK
     C                   END
     C                   END
     C     W9XRIF        IFEQ      'Y'
     C     W3N0          IFEQ      12
     C                   MOVEL     'Y'           MTHOK
     C                   END
     C                   END
     C                   END
 
      ** Provide new given day/month, in case advancement occurred
 
     C                   MOVEL     GVNDMY        W9XRDY
      *
     C                   ENDSR
      *****************************************************************
      *                                                               *
      *  NXTWRK - Calculate first working day after maturity          *
      *                                                               *
      *****************************************************************
     C     NXTWRK        BEGSR
 
     C                   Z-ADD     0             ZDAYNO
     C     E2VDAT        IFGE      25204
     C     E2VDAT        ADD       1             ZDAYNO
     C                   ELSE
     C                   CALL      'ZFRQB5'
     C                   PARM      'D'           ZFREQ             1
     C                   PARM      W9CAPD        ZDAYNO            5 0
     C                   PARM      0             ZMDAY             2 0
     C                   PARM      BJLCCY        ZCCY              3
     C                   PARM      *BLANKS       ZLOC              3
     C                   PARM      'F'           ZDIREC            1
     C                   PARM      *BLANKS       ZRTRN             7
     C                   ENDIF
     C                   Z-ADD     ZDAYNO        NWD               5 0
 
     C                   ENDSR
      *****************************************************************
      *                                                               *
      *  GETACC - Get account details                                 *
      *                                                               *
      *****************************************************************
     C     GETACC        BEGSR
 
     C                   Z-ADD     0             CRIB
     C                   Z-ADD     0             CRIS
     C                   Z-ADD     0             CRIC
     C                   Z-ADD     0             CRCD
     C                   MOVE      *BLANKS       CRIF
     C                   Z-ADD     0             CRDY
     C                   Z-ADD     0             NCID
     C                   Z-ADD     0             DRIB
     C                   Z-ADD     0             DRIS
     C                   Z-ADD     0             DRIC
     C                   Z-ADD     0             DRCD
     C                   MOVE      *BLANKS       DRIF
     C                   Z-ADD     0             DRDY
     C                   Z-ADD     0             NDID
 
     C                   MOVE      PCNUM         ACNUM
     C                   MOVE      PCCY          ACCY
     C                   Z-ADD     PACOD         AACOD
     C                   Z-ADD     PACSQ         AACSQ
     C                   MOVE      PBRCA         ABRCA
     C                   MOVE      ' '           CLOSED            1
     C                   CLEAR                   ACFMT
     C     AKEY1         CHAIN     ACCNT                              87
 
     C     *IN87         IFEQ      '1'
     C     ACST          OREQ      'C'
     C                   MOVE      'Y'           NOACRD            1                          223609
     C                   ELSE                                                                 228430
     C                   MOVE      ' '           NOACRD            1                          228430
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      *                                                               *
      *  UPDATE -                                                     *
      *                                                               *
      *****************************************************************
     C     UPDATE        BEGSR
 
      ** If values are different then update
 
     C     I9NXID        IFNE      X9NXID
     C     I9XRDY        ORNE      X9XRDY
 
     C     W9DRCR        IFEQ      'D'
     C                   Z-ADD     X9NXID        E2NDID
     C                   Z-ADD     X9XRDY        E2DRDY
     C                   ELSE
     C                   Z-ADD     X9NXID        E2NCID
     C                   Z-ADD     X9XRDY        E2CRDY
     C                   ENDIF
 
      ** Update REPRPNPD
 
     C                   EXCEPT    REPRP
 
      ** ACCNTAB should be updated only if mode is *INDEP or *COB
      ** and if there is an existing record on ACCNTAB                                        223609
 
     C     NOACRD        IFNE      'Y'                                                        223609
     C     PMODE         IFEQ      '*INDEP'
     C     PMODE         OREQ      '*COB  '
 
     C                   EXSR      GETACC
     C     W9DRCR        IFEQ      'D'
     C                   Z-ADD     X9NXID        NDID
     C                   MOVE      E2DRIF        DRIF
     C                   MOVEL     X9XRDY        DRDY
     C                   EXCEPT    ACOUD
     C                   ELSE
     C                   Z-ADD     X9NXID        NCID
     C                   MOVE      E2CRIF        CRIF
     C                   MOVEL     X9XRDY        CRDY
     C                   EXCEPT    ACOUC
     C                   ENDIF
     C                   ENDIF                                                                223609
 
      ** End of mode condition
 
     C                   ENDIF
 
      ** End of 'values are different' condition
 
     C                   ENDIF
 
     C                   ENDSR
      /EJECT
      *****************************************************************
      *                                                               *
      * *PSSR  - Program exception error routine                      *
      *          Called automatically if a program error occurs,      *
      *          or directly by the program code using EXSR.          *
      ********************************************************************
     C     *PSSR         BEGSR
 
     C                   DUMP
 
     C                   EVAL      *INU7 = *On
     C                   EVAL      *INU8 = *On
     C                   EVAL      *INLR = *On
 
     C                   IF        RunBefore <> 'Y'
 
     C                   EVAL      RunBefore = 'Y'
 
     C                   CALL      'DBERRCTL'
 
     C                   ENDIF
 
     C                   RETURN
 
     C                   ENDSR
 
      ********************************************************************
 
      ** Account Details
 
     OACCNTABF  E            ACOUD
 
      ** Debit interest fields
 
     O                       NDID
     O                       DRIF
     O                       DRDY
     OACCNTABF  E            ACOUC
 
      ** Credit interest fields
 
     O                       NCID
     O                       CRIF
     O                       CRDY
 
      ** Period & Penalty Details
 
     OREPRPND0  E            REPRP
 
      ** Credit interest fields
 
     O                       E2CRDY
     O                       E2NCID
 
      ** Debit interest fields
 
     O                       E2DRDY
     O                       E2NDID
 
      *****************************************************************
 
**CTDATA CPY@
(c) Misys International Banking Systems Ltd. 2009
