     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*OVR *: OVRDBF FILE(DEPERDPD) TOFILE(DEPPERDPD) SHARE(*NO)         : *
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas DE Update period end dates')                     *
      *****************************************************************
      *                                                               *
      *  Midas - Data Export module                                   *
      *                                                               *
      *  DEUPDPERD - Update Period End Dates                          *
      *                                                               *
      *  Function:  This module will calculate a new set of period    *
      *             end dates and write these to the database.        *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      *  Last Amend No. CCB020             Date 06Aug12               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. CGL029             Date 01Sep03               *
      * Midas Release 4 --------------- Base -------------------------*
      *                 CDE002             Date 05Dec00               *
      * Midas DBA 3.03 -----------------------------------------------*
      *                 CDE001  *CREATE    Date 23Nov99               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CCB020 - COB Restructure - Secondary COB Infrastructure      *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  CDE002 - Data Export - CCRM Revenue Analysis.                *
      *  CDE001 - Data Export - CCRM Limits.                          *
      *                                                               *
      *****************************************************************
 
     FDEPERDPD  UF A E             DISK
     FCBAICDL1  IF   E           K DISK
 
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
 
      * P E R I O D   D E T A I L S
     D/COPY DECPYSRC,DEXTPERDD
 
 
     D                 DS
     D  W#DATE                 1      6
     D  W#MNTH                 1      2S 0
     D  W#DAY                  3      4S 0
     D  W#YEAR                 5      6S 0
 
 
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** External DS for BANK details
     D SDGELR        E DS                  EXTNAME(SDGELRPD)
      ** External DS for GENERAL LEDGER details
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
 
     D DEEXTCTL      E DS                  EXTNAME(DEEXTCTL)
      ** EXTRACT CONTROL DATA
 
 
      ** MPHAS Data-Area
     D***MPHAS*******DS                              1                                        CCB020
     D*****PHASE*****                  1      1                                               CCB020
      *                                                                                       CGL029
     D DSSDY         E DS                  EXTNAME(DSSDY)                                     CGL029
      *                                                                                       CGL029
 
      *
      * INPUT PARAMETERS
      *
     C     *ENTRY        PLIST
     C                   PARM                    Proj_Hist         1
 
      *
      * CALCULATE PERIODS - PROJECTED
      *
     C     Proj_Hist     IFEQ      'P'
     C                   EXSR      CALPERD_P
      *
      * CALCULATE PERIODS - HISTORIC
      *
     C                   ELSE
     C                   EXSR      CALPERD_H
     C                   ENDIF
      *
      * UPDATE PERIODS
      *
     C                   EXSR      UPDPERD
      *
      * RETURN FROM PROGRAM
      *
     C                   SETON                                        LR
     C                   RETURN
 
      /SPACE 5
      **********************************************************************
      * CALCULATE PERIODS - PROJECTED
      **********************************************************************
     C     CALPERD_P     BEGSR
 
      * Start date is run date
 
     C                   MOVE      DEPRDNB       PER(1)
 
      * Add projection cut-off date
 
     C                   MOVE      DEPCDT        PER(2)
      *
     C                   ENDSR
      **********************************************************************
      /SPACE 5
      **********************************************************************
      * CALCULATE PERIODS - HISTORIC
      **********************************************************************
     C     CALPERD_H     BEGSR
      **********                                                                              CDE002
      **Start*date*is*run*date*****************************************                       CDE002
      **********                                                                              CDE002
     C**********         Z-ADD     DEHRDNB       ZDAYNO                                       CDE002
      *                                                                                       CDE002
      * Start date is:                                                                        CDE002
      * the date of next working day - 1          if last day accruals                        CDE002
      * the date of next working day              if first day accruals                       CDE002
      *                                                                                       CDE002
     C     BKALDI        IFEQ      'Y'                                                        CDE002
     C     DEHDNWD       SUB       1             ZDAYNO                                       CDE002
     C                   ELSE                                                                 CDE002
     C                   Z-ADD     DEHDNWD       ZDAYNO                                       CDE002
     C                   ENDIF                                                                CDE002
 
     C                   MOVE      ZDAYNO        PER(1)
     C                   MOVE      ZDAYNO        PERN1             5 0                        CDE002
      *
      * Convert 1st date to MM/DD/YY
      *
     C                   EXSR      ZDATE2
      *
      * Determine 1st day of month
      *
     C                   MOVE      ZDATE         W#DATE
     C                   Z-ADD     1             W#DAY
     C                   MOVE      W#DATE        ZDATEI
     C                   EXSR      ZDATE1
     C     BKALDI        IFEQ      'Y'                                                        CDE002
     C                   SUB       1             ZDAYNO                                       CDE002
     C                   ENDIF                                                                CDE002
      *
      * Do until history cut-off date reached
      *
     C                   Z-ADD     1             #PP               3 0
     C     ZDAYNO        DOULT     DEHCDT
     C     #PP           ANDLT     256
      *
      **Add*1st*day*of*month*to*period*array***************************                       CDE002
      **********                                                                              CDE002
     C*****ZDAYNO        IFNE      DEHRDNB                                                    CDE002
      *                                                                                       CDE002
      * Add 1st/last day of month to period array                                             CDE002
      *                                                                                       CDE002
     C     ZDAYNO        IFNE      PERN1                                                      CDE002
     C                   ADD       1             #PP
     C                   MOVE      ZDAYNO        PER(#PP)
     C                   ENDIF
      *
      * Go to previous month
      *
     C                   SUB       1             W#MNTH
     C     W#MNTH        IFEQ      *ZERO
     C                   Z-ADD     12            W#MNTH
     C                   SUB       1             W#YEAR
     C     W#YEAR        IFLT      *ZERO
     C                   Z-ADD     99            W#YEAR
     C                   ENDIF
     C                   ENDIF
      *
      * Get day number of 1st day of previous month
      *
     C                   MOVE      W#DATE        ZDATEI
     C                   EXSR      ZDATE1
     C     BKALDI        IFEQ      'Y'                                                        CDE002
     C                   SUB       1             ZDAYNO                                       CDE002
     C                   ENDIF                                                                CDE002
      *
     C                   ENDDO
      *
     C                   ENDSR
      **********************************************************************
     C/SPACE 5
      **********************************************************************
      * UPDATE PERIODS
      **********************************************************************
     C     UPDPERD       BEGSR
      *
      * Sort the period dates in ascending sequence
      *
     C                   SORTA     PER
      *
      * Remove maximum values
      *
     C                   Z-ADD     1             #PP               3 0
     C     #PP           DOUGT     256
     C     PER(#PP)      IFEQ      '99999'
     C                   MOVE      '00000'       PER(#PP)
     C                   ENDIF
     C                   ADD       1             #PP
     C                   ENDDO
      *
      * Update fields on period record
      *
     C     1             CHAIN     DEPERDP0                           99
     C                   MOVEA     PER           PeriodEDT
     C     *IN99         IFEQ      '1'
     C                   WRITE     DEPERDP0
     C                   ELSE
     C                   UPDATE    DEPERDP0
     C                   ENDIF
 
     C                   ENDSR
      **********************************************************************
     C/SPACE 5
      *********************************************************************
      * SET PROJECTIONS CUT-OFF DATE
      *********************************************************************
     C     SET_PROJCD    BEGSR
 
      * Calculate projections cut-off date
      * Starting from day prior to next working day
      * add projected days, months & years
 
     C     DEPDNWD       SUB       1             DEPCDT
     C                   ADD       DEPCOD        DEPCDT
 
     C     DEPCOM        IFNE      *ZERO
     C     DEPCOY        ORNE      *ZERO
 
      * Convert day number to date
 
     C                   Z-ADD     DEPCDT        ZDAYNO
     C                   EXSR      ZDATE2
     C                   MOVE      ZDATE         W#DATE
 
     C                   ADD       DEPCOM        W#MNTH
     C     W#MNTH        IFGT      12
     C                   SUB       12            W#MNTH
     C                   ADD       1             W#YEAR
     C                   ENDIF
 
     C                   ADD       DEPCOY        W#YEAR
 
      * Convert date to day number
 
     C                   MOVE      W#DATE        ZDATEI
     C                   EXSR      ZDATE1
     C     ErrorFlag     DOWEQ     'Y'
     C     W#DAY         ANDGT     1
     C                   SUB       1             W#DAY
     C                   MOVE      W#DATE        ZDATEI
     C                   EXSR      ZDATE1
     C                   ENDDO
 
     C                   Z-ADD     ZDAYNO        DEPCDT
 
     C                   ENDIF
 
     C                   ENDSR
      **********************************************************************
     C/SPACE 5
      *********************************************************************
      * SET HISTORY CUT-OFF DATE
      *********************************************************************
     C     SET_HISTCD    BEGSR
 
      * Calculate history cut-off date
      * Starting from run date
      * subtract history days
 
     C     DEHRDNB       SUB       DEHCOD        DEHCDT
 
      * Convert day number to date
 
     C                   Z-ADD     DEHCDT        ZDAYNO
     C                   EXSR      ZDATE2
     C                   MOVE      ZDATE         W#DATE
      *
      * Determine 1st day of month
      *
     C                   MOVE      ZDATE         W#DATE
     C                   Z-ADD     1             W#DAY
     C                   MOVE      W#DATE        ZDATEI
     C                   EXSR      ZDATE1
 
      * Set History Cut-Off Date
 
     C     BKALDI        IFEQ      'Y'                                                        CDE002
     C     ZDAYNO        SUB       1             DEHCDT                                       CDE002
     C                   ELSE                                                                 CDE002
     C                   Z-ADD     ZDAYNO        DEHCDT
     C                   ENDIF                                                                CDE002
 
     C                   ENDSR
      **********************************************************************
     C/SPACE 5
      *********************************************************************
      * UPDATE EXTRACT CONTROL DATES
      *********************************************************************
     C     UPD_CTLDT     BEGSR
 
      * If in input cycle
 
     C*****PHASE         IFEQ      'A'                                                        CCB020
      *                                                                                       CCB020
     C     @RTPHS        IFEQ      '*NO'                                                      CCB020
 
      * Set Projections/History Run Date and Date of Next Working Day
 
     C     Proj_Hist     IFEQ      'P'
     C                   Z-ADD     BJRDNB        DEPRDNB
     C                   Z-ADD     BJDNWD        DEPDNWD
     C                   ELSE
     C                   Z-ADD     BJRDNB        DEHRDNB
     C                   Z-ADD     BJDNWD        DEHDNWD
     C                   ENDIF
 
     C                   ELSE
 
      * Get following run date
 
     C                   MOVEL     'A.COB '      ABACOB
     C     ABACOB        CHAIN     @AICDF1                            99        *
     C     *in99         IFEQ      '1'
     C                   DUMP
     C                   SETON                                        U7U8LR
     C                   RETURN
     C                   END
 
      * Calculate next working day after following run date
 
     C                   CALLB     'ZFWDT'
     C                   PARM      ABDBRN        ZDAYNO            5 0
     C                   PARM      1             ZNRDYS            2 0
     C                   PARM      *ZERO         ZDYNBR            5 0
     C                   PARM      BJLCCY        ZCCY              3
     C                   PARM                    ZLOC              3
 
     C     Proj_Hist     IFEQ      'P'
     C                   Z-ADD     ABDBRN        DEPRDNB
     C                   Z-ADD     ZDYNBR        DEPDNWD
     C                   ELSE
     C                   Z-ADD     BJRDNB        DEHRDNB                                      CDE002
     C                   Z-ADD     BJDNWD        DEHDNWD                                      CDE002
     C**********         Z-ADD     ABDBRN        DEHRDNB                                      CDE002
     C**********         Z-ADD     ZDYNBR        DEHDNWD                                      CDE002
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDSR
      *********************************************************************
     C/SPACE 5
      *********************************************************************
      * *INZSR - Initial subroutine called automatically at program start
      *********************************************************************
     C     *INZSR        BEGSR
      *
      **  Access Bank Details
      *
     C                   CALLB     'AOBANKR0'
     C                   PARM      '*DBERR  '    @RTCD             7
     C                   PARM      '*FIRST  '    @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
      *
      **  Access General Ledger Details
      *
     C**********         CALLB     'AOGELRR0'                                                 CGL029
     C                   CALLB     'AOGELRR1'                                                 CGL029
     C                   PARM      '*DBERR  '    @RTCD             7
     C                   PARM      '*FIRST  '    @OPTN             7
     C*****SDGELR        PARM      SDGELR        DSFDY                                        CGL029
     C     SDGELR        PARM      SDGELR        DSSDY                                        CGL029
 
 
      ** Read Extract Control Data
 
     C     *DTAARA       DEFINE                  DEEXTCTL
     C     *LOCK         IN        DEEXTCTL
 
      ** Read MPHAS data-area
 
     C******DTAARA       DEFINE                  MPHAS                                        CCB020
     C**********         IN        MPHAS                                                      CCB020
      *                                                                                       CCB020
     C                   MOVEL     'CBC00100'    @CLPRM            9                          CCB020
     C                   MOVE      '1'           @CLPRM                                       CCB020
     C                   CALL      @CLPRM                                                     CCB020
     C                   PARM      *BLANK        @RTPHS            4                          CCB020
 
      * Update Extract Control Dates
      * (Projection or History Run Date and Date of Next Working Day)
 
     C                   EXSR      UPD_CTLDT
 
      * Set Projections or History Cut-Off Date
 
     C     Proj_Hist     IFEQ      'P'
     C                   EXSR      SET_PROJCD
     C                   ELSE
     C                   EXSR      SET_HISTCD
     C                   ENDIF
 
      ** Update Extract Control Data
 
     C                   OUT       DEEXTCTL
 
      * Initialize all periods with the maximum value
 
     C                   MOVE      '99999'       PER
 
     C                   ENDSR
      *********************************************************************
     C/SPACE 5
      **********************************************************************
      * CONVERT DATE TO DAY NUMBER
      **********************************************************************
     C     ZDATE1        BEGSR
     C                   CALLB     'ZDATE1'
     C                   PARM                    ZDATEI            6
     C                   PARM      *ZEROS        ZDAYNO            5 0
     C                   PARM      'M'           ZDATFM            1
     C                   PARM      *BLANK        ErrorFlag         1
     C                   ENDSR
      **********************************************************************
     C/SPACE 5
      **********************************************************************
      * CONVERT DAY NUMBER TO DATE
      **********************************************************************
     C     ZDATE2        BEGSR
     C                   CALLB     'ZDATE2'
     C                   PARM                    ZDAYNO            5 0          Value date
     C                   PARM      'M'           ZDATFM            1            Date format ind
     C                   PARM      *ZERO         ZDATE             6 0          Value date
     C                   PARM      *BLANK        ZADATE            7            Run-date in DDM
     C                   ENDSR
      **********************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2001
