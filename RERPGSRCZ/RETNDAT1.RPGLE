     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2009')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas RE Retail Term & Notice: Date Calculations')     *
      *****************************************************************
      *                                                               *
      *  Midas     - Retail T&N Accounts                              *
      *                                                               *
      *  RPGLE/RETNDAT1 - Calculate value, maturity and end dates for *
      *              Midas Retail Term & Notice                       *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2009            *
      *                                                               *
      *  Last Amend No. CRE073             Date 06Dec10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      *  Prev Amend No. 254071             Date 18Dec09               *
      *                 250852             Date 18Dec09               *
      *                 244324             Date 18Dec09               *
      *                 230355             Date 18Dec09               *
      *                 223605             Date 18Dec09               *
      *                 CRE015  *CREATE    Date 18Dec09               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CRE073 - Interest Rate Rounding (Recompile)                  *
      *  254071 - Ensure end of term correctly calculated for         *
      *           change of maturity date.                            *
      *  250852 - Correct NOMTH routine if total months exceed 99     *
      *           Also apply 244324.                                  *
      *  244324 - Ensure that end date from previous record is        *
      *           passed on.                                          *
      *           Also correct default value date for B-Z records     *
      *           which may have contributed to the problem.          *
      *           And correct NOMTH routine if total months exceed 99 *
      *  230355 - Recompile over changes to REPRPNPD.                 *
      *  223605 - Day number 99 should be equivalent of day number of *
      *           run date.                                           *
      *  CRE015 - Retail Term and Notice Accounts                     *
      *                                                               *
      *****************************************************************
 
      ** Account Details
 
     FACCNT     IF   E           K DISK    INFSR(*PSSR)
     F                                     IGNORE(ACCNTAAF)
     F                                     IGNORE(ACCNTACF)
 
      *****************************************************************
 
     D LDA           E DS           256    EXTNAME(LDA) DTAARA(LDA)
 
      ** The following fields are defined in the external file:
      **                                    134 141 DBFile
      **                                    142 170 DBKey
      **                                    171 180 DBPgm
      **                                    181 1830DBase
      **                                    184 193 DBMod
      **                                    194 203 DBProc
 
     D RunBefore       S              1A
 
      ** Array containing Copyright statement
 
      ** Number of days in each month                                                         EPK040
                                                                                              EPK040
     D UFMD            S              2    DIM(12) CTDATA PERRCD(12)                          EPK040
 
      ** Bank Details
 
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
 
     D REPFWX        E DS                  EXTNAME(REPRPNPD)
     D                                     PREFIX(WX:2)
 
      ** Short DS for access programs
 
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      *****************************************************************
 
     C     *ENTRY        PLIST
 
      ** Inputs
 
     C                   PARM                    REPFWX
     C                   PARM                    MAINT             7
     C                   PARM                    RUNCHG            5
 
      ** Previous end of period
 
     C                   PARM                    PRCEDE            5 0
     C                   PARM                    PRTCD             7
 
      ** Get Bank Details
 
     C                   CALL      'AOBANKR0'
     C                   PARM      '*MSG   '     @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
 
      ** ACCNTAB key list
 
     C     AKEY1         KLIST
     C                   KFLD                    ACNUM             6
     C                   KFLD                    ACCY              3
     C                   KFLD                    AACOD            10 0
     C                   KFLD                    AACSQ             2 0
     C                   KFLD                    ABRCA             3
 
      ** If before run date change in COB use Next Working day
      ** If run date move in run date
      ** Else assume it is a Midas day number
 
     C                   SELECT
     C     RUNCHG        WHENEQ    '*NXWD'
     C                   Z-ADD     BJDNWD        RUNDAY            5 0
     C     RUNCHG        WHENEQ    '*RUND'
     C                   Z-ADD     BJRDNB        RUNDAY            5 0
     C                   OTHER
     C                   MOVE      RUNCHG        RUNDAY            5 0
     C                   ENDSL
 
      ** 'A' record
 
     C     WXEVNT        IFEQ      'A'
 
      ** Day Number Processing
 
     C                   EXSR      EXDAYM
 
      ** Dates Calculation
 
     C                   EXSR      CALCA
     C                   ENDIF
 
      ** 'B','C',...,'Y' RECORD
 
     C     WXEVNT        IFNE      'A'
     C     WXEVNT        ANDNE     'Z'
 
      ** Dates Calculation
 
     C                   EXSR      CALCBY
 
     C                   ENDIF
 
      ** 'Z' RECORD
 
     C     WXEVNT        IFEQ      'Z'
 
      ** Dates Calculation
 
     C                   EXSR      CALCZ
 
     C                   ENDIF
 
      ** Calculate next working day after maturity
 
     C     MAINT         IFEQ      '*EXIST'
     C     MAINT         OREQ      '*COB'
     C     MAINT         OREQ      '*NEW'
     C     WXTPRD        IFEQ      'T'
     C     WXEVNT        ANDLT     'Z'
     C                   EXSR      NXTWRK
     C                   ENDIF
     C                   ENDIF
 
     C                   SETON                                        LR
     C                   RETURN
 
      *****************************************************************
      *                                                               *
      *  EXDAYM - Frequency Day Number Processing                     *
      *                                                               *
      *                                                               *
      *****************************************************************
     C     EXDAYM        BEGSR
 
      ** For non-default accounts:
      ** If Frequency Day number is 99, then convert
      ** Frequency Day number to run day - 1
 
     C     MAINT         IFNE      '*DFT'
     C     WXDAYM        ANDEQ     99
     C                   Z-ADD     RUNDAY        W#VDAT            5 0
     C                   SUB       1             W#VDAT
     C                   CALL      'ZDATE2'
     C                   PARM      W#VDAT        ZDAYNO            5 0
     C                   PARM      'D'           BJDFIN            1
     C                   PARM                    ZDATE             6 0
     C                   PARM                    ZADATE            7
     C                   MOVEL     ZDATE         W0DAYM            2 0                        223605
     C                   Z-ADD     W0DAYM        WXDAYM            2 0
     C                   END
 
     C                   ENDSR
      *****************************************************************
      *                                                               *
      *  CALCA  - 'A' Record Date Calculations                        *
      *                                                               *
      *****************************************************************
     C     CALCA         BEGSR
 
     C                   SELECT
 
      ** New Record
 
     C     MAINT         WHENEQ    '*NEW'
 
      ** Value
 
     C                   Z-ADD     RUNDAY        WXVDAT
 
      ** Maturity
 
     C     WXTPRD        IFEQ      'N'
     C                   Z-ADD     WXCEDE        WXMDAT
     C                   ELSE
     C     WXVDAT        SUB       1             I0DAT
     C                   Z-ADD     WXNDPD        I0NDPD
     C                   Z-ADD     WXNMPD        WXNMPD            2 0
     C                   Z-ADD     WXNMPD        I0NMPD
     C                   MOVEL     WXFREQ        I0FREQ
     C                   Z-ADD     WXDAYM        I0DAYM
     C                   MOVEL     'F'           I0DIRE
 
     C                   EXSR      ADVANC
 
     C                   Z-ADD     O0DAT         WXMDAT
     C                   ENDIF
 
      ** Calculate and store actual end date
 
     C                   EXSR      CALEND
 
     C                   Z-ADD     ACTEND        PRCEDE            5 0
 
      ** Default Record
 
     C     MAINT         WHENEQ    '*DFT'
 
      ** Value
 
     C                   Z-ADD     0             WXVDAT
 
      ** Maturity
 
     C     WXCEDE        IFGT      999
     C                   Z-ADD     WXCEDE        WXMDAT
     C                   ELSE
     C                   Z-SUB     1             WXMDAT
     C                   ENDIF
 
      ** Record has been changed
 
     C     MAINT         WHENEQ    '*EXIST '
 
      ** Value date cannot be less than date account opened
 
     C                   MOVE      WXCNUM        ACNUM
     C                   MOVE      WXCCY         ACCY
     C                   Z-ADD     WXACOD        AACOD
     C                   Z-ADD     WXACSQ        AACSQ
     C                   MOVE      WXBRCA        ABRCA
     C     AKEY1         CHAIN     ACCNT                              87
     C     WXVDAT        IFLT      DACO
     C                   Z-ADD     DACO          WXVDAT
     C                   ENDIF
 
      ** Maturity (Notice only)
 
     C     WXTPRD        IFEQ      'N'
     C                   Z-ADD     WXCEDE        WXMDAT
     C                   ENDIF
 
      ** Calculate and store actual end date
 
     C                   EXSR      CALEND
     C                   Z-ADD     ACTEND        PRCEDE            5 0
 
      ** Close of Business processing
 
     C     MAINT         WHENEQ    '*COB'
 
      ** Advance to next term if necesary (Term accounts only)
 
     C     WXTPRD        IFEQ      'T'
 
      ** Check if end of period
 
     C                   EXSR      ENDCHK
 
      ** If end of period then end date = maturity date                                       244324
                                                                                              244324
     C     ENDPER        IFEQ      'Y'                                                        244324
     C                   Z-ADD     WXMDAT        PRCEDE                                       244324
     C                   ELSE                                                                 244324
 
      ** While Maturity date < working run date
      ** and period end not yet reached
 
     C     WXMDAT        DOWLT     RUNDAY
     C     ENDPER        ANDNE     'Y'
 
      ** Value date ( = previous maturity + 1)
 
     C     WXMDAT        ADD       1             WXVDAT
 
      ** Maturity date ( = advance one term from previous maturity)
 
     C                   Z-ADD     WXMDAT        I0DAT
     C                   Z-ADD     WXNDPD        I0NDPD
     C                   Z-ADD     WXNMPD        I0NMPD
     C                   MOVEL     WXFREQ        I0FREQ
     C                   Z-ADD     WXDAYM        I0DAYM
     C                   MOVEL     'F'           I0DIRE
     C                   EXSR      ADVANC
     C                   Z-ADD     O0DAT         WXMDAT
 
      ** If end date expressed as a number of terms i.e. =< 999, then
      **  subtract 1 from number of terms
 
     C     WXCEDE        IFGT      1
     C     WXCEDE        ANDLE     999
     C     WXCEDE        SUB       1             WXCEDE
     C                   ENDIF
 
      ** If maturity date is greater than end date then set equal to end date
      ** (assuming end date > 999, i.e. an actual date)
 
     C     WXMDAT        IFGT      WXCEDE
     C     WXCEDE        ANDGT     999
     C                   Z-ADD     WXCEDE        WXMDAT
     C                   ENDIF
 
      ** Calculate and store actual end date
 
     C                   EXSR      CALEND
     C                   Z-ADD     ACTEND        PRCEDE            5 0
 
      ** Check if end of period
 
     C                   EXSR      ENDCHK
 
     C                   ENDDO
     C                   ENDIF                                                                244324
     C                   ENDIF
     C                   ENDSL
 
     C                   ENDSR
      *****************************************************************
      *                                                               *
      *  CALCBY - 'B' - 'Y' Record Date Calculations                  *
      *                                                               *
      *****************************************************************
     C     CALCBY        BEGSR
 
     C                   SELECT
 
      ** New Record
 
     C     MAINT         WHENEQ    '*NEW'
 
      ** Value
 
     C     1             ADD       PRCEDE        WXVDAT
 
      ** Maturity
 
     C     WXTPRD        IFEQ      'N'
     C                   Z-ADD     WXCEDE        WXMDAT
     C                   ELSE
     C     WXVDAT        SUB       1             I0DAT
     C                   Z-ADD     WXNDPD        I0NDPD
     C                   Z-ADD     WXNMPD        WXNMPD            2 0
     C                   Z-ADD     WXNMPD        I0NMPD
     C                   MOVEL     WXFREQ        I0FREQ
     C                   Z-ADD     WXDAYM        I0DAYM
     C                   MOVEL     'F'           I0DIRE
     C                   EXSR      ADVANC
     C                   Z-ADD     O0DAT         WXMDAT
     C                   ENDIF
 
      ** Calculate and store actual end date
 
     C                   EXSR      CALEND
     C                   Z-ADD     ACTEND        PRCEDE            5 0
 
      ** Default Record
 
     C     MAINT         WHENEQ    '*DFT'
 
      ** Value
 
     C                   Z-ADD     1             WXVDAT                                       244324
 
      ** Maturity
 
     C     WXCEDE        IFGT      999
     C                   Z-ADD     WXCEDE        WXMDAT
     C                   ELSE
     C                   Z-SUB     1             WXMDAT
     C                   ENDIF
 
      ** Record has been changed
 
     C     MAINT         WHENEQ    '*EXIST '
 
      ** Value
      **    = Previous end date + 1
      **    But only use previous end date if there is a preceding active
      **    record i.e. end date of previous record exists                                    244324
                                                                                              244324
     C     PRCEDE        IFNE      0                                                          244324
     C     1             ADD       PRCEDE        WXVDAT
     C                   ENDIF                                                                244324
 
      **     cannot be greater than 01/01/41
 
     C     WXVDAT        IFGT      25204
     C                   Z-ADD     25204         WXVDAT
     C                   ENDIF
 
      ** Maturity (Notice only)
 
     C     WXTPRD        IFEQ      'N'
     C                   Z-ADD     WXCEDE        WXMDAT
     C                   ELSE
     C     WXVDAT        SUB       1             I0DAT
     C                   Z-ADD     WXNDPD        I0NDPD
     C                   Z-ADD     WXNMPD        WXNMPD            2 0
     C                   Z-ADD     WXNMPD        I0NMPD
     C                   MOVEL     WXFREQ        I0FREQ
     C                   Z-ADD     WXDAYM        I0DAYM
     C                   MOVEL     'F'           I0DIRE
     C                   EXSR      ADVANC
     C                   Z-ADD     O0DAT         WXMDAT
     C                   ENDIF
 
      ** Calculate and store actual end date
 
     C                   EXSR      CALEND
     C                   Z-ADD     ACTEND        PRCEDE            5 0
 
      ** Close of Business processing
 
     C     MAINT         WHENEQ    '*COB'
 
      ** Advance to next term if necesary (Term accounts only)
 
     C     WXTPRD        IFEQ      'T'
 
      ** Check if end of period
 
     C                   EXSR      ENDCHK
 
      ** If end of period then end date = maturity date                                       244324
                                                                                              244324
     C     ENDPER        IFEQ      'Y'                                                        244324
     C                   Z-ADD     WXMDAT        PRCEDE                                       244324
     C                   ELSE                                                                 244324
 
      ** While Maturity date < working run date
      ** and period end not yet reached
 
     C     WXMDAT        DOWLT     RUNDAY
     C     ENDPER        ANDNE     'Y'
 
      ** Value date ( = previous maturity + 1)
 
     C     WXMDAT        ADD       1             WXVDAT
 
      ** Maturity date ( = advance one term from previous maturity)
 
     C                   Z-ADD     WXMDAT        I0DAT
     C                   Z-ADD     WXNDPD        I0NDPD
     C                   Z-ADD     WXNMPD        I0NMPD
     C                   MOVEL     WXFREQ        I0FREQ
     C                   Z-ADD     WXDAYM        I0DAYM
     C                   MOVEL     'F'           I0DIRE
     C                   EXSR      ADVANC
     C                   Z-ADD     O0DAT         WXMDAT
 
      ** If end date expressed as a number of terms i.e. =< 999, then
      **  subtract 1 from number of terms
 
     C     WXCEDE        IFGT      1
     C     WXCEDE        ANDLE     999
     C     WXCEDE        SUB       1             WXCEDE
     C                   ENDIF
 
      * If maturity date is greater than end date then set equal to end date
      ** (assuming end date > 999, i.e. an actual date)
 
     C     WXMDAT        IFGT      WXCEDE
     C     WXCEDE        ANDGT     999
     C                   Z-ADD     WXCEDE        WXMDAT
     C                   ENDIF
 
      ** Calculate and store actual end date
 
     C                   EXSR      CALEND
     C                   Z-ADD     ACTEND        PRCEDE            5 0
 
      ** Check if end of period
 
     C                   EXSR      ENDCHK
 
     C                   ENDDO
     C                   ENDIF                                                                244324
     C                   ENDIF
     C                   ENDSL
 
     C                   ENDSR
      *****************************************************************
      *                                                               *
      *  CALCZ  - 'Z' Record Date Calculations                        *
      *                                                               *
      *****************************************************************
     C     CALCZ         BEGSR
 
     C                   SELECT
 
      ** New Record
 
     C     MAINT         WHENEQ    '*NEW'
 
      ** Value
 
     C     1             ADD       PRCEDE        WXVDAT
 
      ** Cannot be greater than 01/01/41
 
     C     WXVDAT        IFGT      25204
     C                   Z-ADD     25204         WXVDAT
     C                   ENDIF
 
      ** Maturity
 
     C                   Z-ADD     26664         WXMDAT
 
      ** Default Record
 
     C     MAINT         WHENEQ    '*DFT'
 
      ** Value
     C                   Z-ADD     2             WXVDAT                                       244324
 
      ** Maturity
 
     C     WXVDAT        IFGT      WXMDAT
     C                   Z-ADD     WXVDAT        WXMDAT
     C                   ENDIF
 
      ** Record has been changed or COB
 
     C     MAINT         WHENEQ    '*EXIST '
     C     MAINT         OREQ      '*COB   '
 
      ** Value
      **    = Previous end date + 1
      **    But only use previous end date if there is a preceding active
      **    record (i.e. value date > run date)
      **    or the value date is a ridiculously low value
      **    i.e. has not been set yet.
 
     C     WXVDAT        IFGT      RUNDAY
     C     WXVDAT        ORLT      10                                                         244324
     C     PRCEDE        IFNE      0                                                          244324
     C     1             ADD       PRCEDE        WXVDAT
     C                   ENDIF                                                                244324
 
      ** Cannot be greater than 01/01/41
 
     C     WXVDAT        IFGT      25204
     C                   Z-ADD     25204         WXVDAT
     C                   ENDIF
     C                   ENDIF
 
      ** Maturity  is always 26664 for end date & maturity
 
     C                   Z-ADD     26664         WXCEDE
     C                   Z-ADD     WXCEDE        WXMDAT
     C                   ENDSL
 
     C                   ENDSR
      *****************************************************************
      *                                                               *
      *  NXTWRK - Calculate first working day after maturity.         *
      *                                                               *
      *****************************************************************
     C     NXTWRK        BEGSR
 
     C                   Z-ADD     0             ZDAYNO
     C     WXMDAT        IFGE      25204
     C     WXMDAT        ADD       1             ZDAYNO
     C                   ELSE
     C                   CALL      'ZFRQB5'
     C                   PARM      'D'           ZFREQ             1
     C                   PARM      WXMDAT        ZDAYNO            5 0
     C                   PARM      0             ZMDAY             2 0
     C                   PARM      BJLCCY        ZCCY              3
     C                   PARM      *BLANKS       ZLOC              3
     C                   PARM      'F'           ZDIREC            1
     C                   PARM      *BLANKS       ZRTRN             7
     C                   ENDIF
     C                   Z-ADD     ZDAYNO        WXDTWD            5 0
 
     C                   ENDSR
      *****************************************************************
      *                                                               *
      *  ENDCHK - End of Period check                                 *
      *                                                               *
      *****************************************************************
     C     ENDCHK        BEGSR
 
      ** Prospective new value date = old maturity date + 1
 
     C     WXMDAT        ADD       1             W2VDAY            5 0
 
      ** Initialise end of period flag
 
     C                   MOVE      ' '           ENDPER            1
 
     C                   SELECT
     C     WXCEDE        WHENGT    999
     C     WXCEDE        IFLT      W2VDAY
     C                   MOVE      'Y'           ENDPER
     C                   ENDIF
     C     WXCEDE        WHENLE    1
     C                   MOVE      'Y'           ENDPER
     C                   ENDSL
 
     C                   ENDSR
      *****************************************************************
      *                                                               *
      *  CALEND - Calculate actual end date.                          *
      *                                                               *
      *****************************************************************
     C     CALEND        BEGSR
 
      ** Cannot be beyond Midas limit date
      ** which is 31/12/44 for Z records                                                      244324
      ** and 31/12/40 for all other records                                                   244324
 
     C     WXCEDE        IFGT      26664
     C     WXEVNT        ANDEQ     'Z'                                                        244324
     C                   Z-ADD     26664         WXCEDE            5 0
     C                   ENDIF
 
     C     WXCEDE        IFGT      25203                                                      244324
     C     WXEVNT        ANDNE     'Z'                                                        244324
     C                   Z-ADD     25203         WXCEDE            5 0                        244324
     C                   ENDIF                                                                244324
 
     C     WXCEDE        IFGT      999
     C                   Z-ADD     WXCEDE        ACTEND            5 0
     C                   ENDIF
 
      ** If end date expressed as number of terms, then
      ** advance iteratively to establish actual end date as Midas day.
 
     C     WXCEDE        IFGT      0
     C     WXCEDE        ANDLE     999
     C     WXVDAT        SUB       1             I0DAT
     C                   Z-ADD     0             O0DAT
     C                   Z-ADD     WXNDPD        I0NDPD
     C                   Z-ADD     WXNMPD        I0NMPD
     C                   MOVEL     WXFREQ        I0FREQ
     C                   Z-ADD     WXDAYM        I0DAYM
     C                   MOVEL     'F'           I0DIRE
     C                   Z-ADD     1             X                 3 0
                                                                                              254071
      ** If 'A' period use maturity and advance already to next term                          254071
      ** in case first term maturity has been changed                                         254071
                                                                                              254071
     C     WXEVNT        IFEQ      'A'                                                        254071
     C                   Z-ADD     2             X                                            254071
     C                   Z-ADD     WXMDAT        I0DAT                                        254071
                                                                                              254071
      ** Initialise end date here in case no further terms                                    254071
                                                                                              254071
     C                   Z-ADD     WXMDAT        ACTEND                                       254071
     C                   Z-ADD     WXMDAT        O0DAT                                        254071
     C                   ENDIF                                                                254071
                                                                                              254071
      ** If there are more terms to process keep advancing until all terms used up            254071
                                                                                              254071
     C     X             DOWLE     WXCEDE
     C     O0DAT         ANDLT     26664
 
     C                   EXSR      ADVANC
 
     C                   Z-ADD     O0DAT         I0DAT
     C                   ADD       1             X
     C                   ENDDO
 
     C                   Z-ADD     O0DAT         ACTEND            5 0
 
      ** Cannot be beyond Midas limit date                                                    244324
      ** which is 31/12/44 for Z records                                                      244324
      ** and 31/12/40 for all other records                                                   244324
                                                                                              244324
     C     ACTEND        IFGT      26664                                                      244324
     C     WXEVNT        ANDEQ     'Z'                                                        244324
     C                   Z-ADD     26664         ACTEND            5 0                        244324
     C                   ENDIF                                                                244324
     C     ACTEND        IFGT      25203                                                      244324
     C     WXEVNT        ANDNE     'Z'                                                        244324
     C                   Z-ADD     25203         ACTEND            5 0                        244324
     C                   ENDIF                                                                244324
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      *                                                               *
      *  ADVANC - Advance date forwards or backwards by one term      *
      *           length                                              *
      *                                                               *
      *****************************************************************
     C     ADVANC        BEGSR
 
      ** Inputs:
      **   Input date         : I0DAT
      **   Term length (days) : I0NDPD
      **   Term length (mths) : I0NMPD
      **   Frequency          : I0FREQ
      **   Day number         : I0DAYM
      **   Direction (F = Forward, B = Backwards) : I0DIRE
      **   Local Currency : BJLCCY
 
      ** Outputs
      **   Output date        : O0DAT
      **   Term length (sign indicates direction) : O0LEN
 
      ** Define local variables
 
     C                   Z-ADD     I0DAT         I0DAT             5 0
     C                   MOVEL     I0DIRE        I0DIRE            1
     C                   Z-ADD     I0NDPD        I0NDPD            3 0
     C                   Z-ADD     I0NMPD        I0NMPD            2 0
     C                   MOVEL     I0FREQ        I0FREQ            1
     C                   Z-ADD     I0DAYM        I0DAYM            2 0
     C                   Z-ADD     0             O0DAT             5 0
 
      ** If input date sensible i.e. < Midas limit date 31/12/44
      **  advance forwards/backwards 1 term
 
     C     I0DAT         IFLT      26664
      *
      ** If freq code used, call routine
 
     C     I0FREQ        IFNE      *BLANKS
     C                   CALL      'ZFRQB5'
     C                   PARM      I0FREQ        ZFREQ             1
     C                   PARM      I0DAT         ZDAYNO            5 0
     C                   PARM      I0DAYM        ZMDAY             2 0
     C                   PARM      BJLCCY        ZCCY              3
     C                   PARM      *BLANKS       ZLOC              3
     C                   PARM      I0DIRE        ZDIREC            1
     C                   PARM      *BLANKS       ZRTRN             7
     C                   Z-ADD     ZDAYNO        O0DAT             5 0
 
      ** Else if frequency blank
 
     C                   ELSE
 
      ** If calculating backwards, subtract no. of days or months
 
     C                   SELECT
     C     I0DIRE        WHENEQ    'F'
     C                   Z-ADD     I0NDPD        W0NDPD            3 0
     C                   Z-ADD     I0NMPD        W0NMPD            2 0
     C     I0DIRE        WHENEQ    'B'
     C                   Z-SUB     I0NDPD        W0NDPD
     C                   Z-SUB     I0NMPD        W0NMPD
     C                   ENDSL
 
      ** Increase/decrease by term length depending on sign
 
     C     W0NMPD        IFEQ      0
     C     I0DAT         ADD       W0NDPD        O0DAT
     C                   ELSE
     C                   MOVE      *BLANKS       #SDATE
     C                   Z-ADD     I0DAT         #SDAYN
     C                   Z-ADD     W0NMPD        #NMTH
     C                   Z-ADD     WXDAYM        #SDAYM
     C                   EXSR      NOMTHS
     C                   Z-ADD     #EDAYN        O0DAT
     C                   ENDIF
 
      ** End of Frequency condition
 
     C                   ENDIF
 
      ** End of sensible date condition
 
     C                   ENDIF
 
      ** Set to Midas limit date 31/12/44 if beyond it
 
     C     I0DAT         IFGE      26664
     C                   Z-ADD     26664         I0DAT
     C                   Z-ADD     26664         O0DAT
     C                   ENDIF
 
     C     O0DAT         IFGT      26664
     C                   Z-ADD     26664         O0DAT
     C                   ENDIF
 
      ** Term length (negative value implies backwards)
 
     C     O0DAT         SUB       I0DAT         O0LEN             5 0
 
     C                   ENDSR
      *****************************************************************                       EPK040
      *                                                               *                       EPK040
      *  NOMTHS - Calculate term length in days                       *                       EPK040
      *                                                               *                       EPK040
      *****************************************************************                       EPK040
     C     NOMTHS        BEGSR                                                                EPK040
      *                                                                                       EPK040
      ** Calculate term length in days and end date given                                     EPK040
      ** start date and number of months. Note that number of months                          EPK040
      ** can also be a negative number, in which case the end date                            EPK040
      ** will be earlier than the start date.                                                 EPK040
      *                                                                                       EPK040
      ** Inputs                                                                               EPK040
      *                                                                                       EPK040
     C                   MOVE(P)   #SDATE        #SDATE            6                          EPK040
     C                   Z-ADD     #SDAYN        #SDAYN            5 0                        EPK040
     C                   Z-ADD     #NMTH         #NMTH             2 0                        EPK040
     C                   Z-ADD     #SDAYM        #SDAYM            2 0                        EPK040
      *                                                                                       EPK040
      ** Outputs                                                                              EPK040
      *                                                                                       EPK040
     C                   Z-ADD     0             EDD               2 0                        EPK040
     C                   Z-ADD     0             EMM               2 0                        EPK040
     C                   Z-ADD     0             EYY               2 0                        EPK040
     C                   MOVE      *BLANKS       #EDATE            6                          EPK040
     C                   Z-ADD     0             #EDAYN            5 0                        EPK040
     C                   Z-ADD     0             #TERML            5 0                        EPK040
     C                   MOVE      *BLANK        ZZERR@            7                          EPK040
                                                                                              EPK040
     C     #SDATE        IFEQ      *BLANKS                                                    EPK040
                                                                                              EPK040
      ** Convert day number to date (DDMMYY)                                                  EPK040
                                                                                              EPK040
     C                   CALL      'ZDATE2'                                                   EPK040
     C                   PARM      #SDAYN        ZDAYNO            5 0                        EPK040
     C                   PARM      'D'           BJDFIN            1                          EPK040
     C                   PARM                    ZDATE             6 0                        EPK040
     C                   PARM                    ZADATE            7                          EPK040
     C                   MOVE      ZDATE         #SDATE                                       EPK040
     C                   ENDIF                                                                EPK040
                                                                                              EPK040
     C     #SDAYN        IFEQ      0                                                          EPK040
                                                                                              EPK040
      ** Convert date to day number                                                           EPK040
                                                                                              EPK040
     C                   MOVE      #SDATE        ZDATE                                        EPK040
     C                   CALL      'ZDATE1'                                                   EPK040
     C                   PARM                    ZERR              7                          EPK040
     C                   PARM                    ZDATE             6 0                        EPK040
     C                   PARM      'D'           ZDATFM            1                          EPK040
     C                   PARM                    ZDAYNO            5 0                        EPK040
     C                   Z-ADD     ZDAYNO        #SDAYN                                       EPK040
     C                   ENDIF                                                                EPK040
                                                                                              EPK040
      **   Set end day number to be same as start day number                                  EPK040
                                                                                              EPK040
     C     #SDAYM        IFEQ      0                                                          EPK040
     C                   MOVEL     #SDATE        UUWRK2            2                          EPK040
     C                   MOVE      UUWRK2        EDD               2 0                        EPK040
     C                   ELSE                                                                 EPK040
     C                   MOVE      #SDAYM        EDD                                          EPK040
     C                   ENDIF                                                                EPK040
                                                                                              EPK040
      ** Calculate date nmth no. of months ahead                                              EPK040
                                                                                              EPK040
     C                   Z-ADD     0             UMTH              3 0                        250852
     C                   Z-ADD     0             UMTH2             2 0                        250852
     C                   MOVEL     #SDATE        UWRK4             4                          EPK040
     C                   MOVE      UWRK4         UMTH2                                        250852
     C     UMTH2         ADD       #NMTH         UMTH                                         250852
                                                                                              EPK040
      ** Convert into months and years                                                        EPK040
                                                                                              EPK040
     C                   Z-ADD     UMTH          EMM                                          EPK040
     C                   MOVE      #SDATE        EYY               2 0                        EPK040
     C     UMTH          IFGE      12                                                         EPK040
     C     UMTH          ORLE      -12                                                        EPK040
     C     UMTH          DIV       12            UMYR              2 0                        EPK040
     C                   MVR                     UMY               2 0                        EPK040
     C                   Z-ADD     UMY           EMM                                          EPK040
     C     EYY           ADD       UMYR          EYY                                          EPK040
     C                   END                                                                  EPK040
                                                                                              EPK040
      ** If negative values of month and year, make valid values                              EPK040
                                                                                              EPK040
     C     EMM           IFLT      1                                                          EPK040
     C     12            ADD       EMM           EMM                                          EPK040
     C     EYY           SUB       1             EYY                                          EPK040
     C                   ENDIF                                                                EPK040
                                                                                              EPK040
     C     EYY           IFLT      0                                                          EPK040
     C     100           ADD       EYY           EYY                                          EPK040
     C                   ENDIF                                                                EPK040
                                                                                              EPK040
      ** Check for leap year                                                                  EPK040
                                                                                              EPK040
     C     EYY           DIV       4             ULYR              2 0                        EPK040
     C                   MVR                     ULY               1 0                        EPK040
                                                                                              EPK040
      ** Check day number is within end of month                                              EPK040
                                                                                              EPK040
     C                   MOVE      UFMD(EMM)     UWRK2             2 0                        EPK040
     C     EMM           IFEQ      2                                                          EPK040
     C     ULY           ANDEQ     0                                                          EPK040
     C                   Z-ADD     29            UWRK2                                        EPK040
     C                   END                                                                  EPK040
                                                                                              EPK040
     C     EDD           IFGT      UWRK2                                                      EPK040
     C                   Z-ADD     UWRK2         EDD                                          EPK040
     C                   END                                                                  EPK040
                                                                                              EPK040
      **   Reformat date, DDMMYY, and convert to day number                                   EPK040
                                                                                              EPK040
     C                   MOVEL     EDD           ZWRK4             4 0                        EPK040
     C                   MOVE      EMM           ZWRK4                                        EPK040
     C                   MOVEL     ZWRK4         ZDATE                                        EPK040
     C                   MOVE      EYY           ZDATE                                        EPK040
     C                   MOVE(P)   ZDATE         #EDATE            6                          EPK040
                                                                                              EPK040
     C                   CALL      'ZDATE1'                                                   EPK040
     C                   PARM                    ZERR              7                          EPK040
     C                   PARM                    ZDATE             6 0                        EPK040
     C                   PARM      'D'           ZDATFM            1                          EPK040
     C                   PARM      0             ZDAYNO            5 0                        EPK040
                                                                                              EPK040
     C                   Z-ADD     ZDAYNO        #EDAYN                                       EPK040
                                                                                              EPK040
      ** Determine length of term                                                             EPK040
                                                                                              EPK040
     C     #EDAYN        SUB       #SDAYN        #TERML                                       EPK040
                                                                                              EPK040
     C                   ENDSR                                                                EPK040
      /EJECT
      *****************************************************************
      *                                                               *
      * *PSSR  - Program exception error routine                      *
      *          Called automatically if a program error occurs,      *
      *          or directly by the program code using EXSR.          *
      *****************************************************************
     C     *PSSR         BEGSR
 
     C                   DUMP
 
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
 
     C                   IF        RunBefore <> 'Y'
 
     C                   EVAL      RunBefore = 'Y'
 
     C                   CALL      'DBERRCTL'
 
     C                   ENDIF
 
     C                   RETURN
 
     C                   ENDSR
 
      *****************************************************************
 
**CTDATA UFMD  -  NUMBER OF DAYS IN THE MONTH                                                 EPK040
312831303130313130313031                                                                      EPK040
