     H DEBUG
      *****************************************************************
/**** *  RPGBASE                                                      *                     MD058085
/*STD *  RPGSQLBND                                                    *                     MD058085
/*EXI *  TEXT('Midas RE CI Interface Start-Up')
      *****************************************************************
      *                                                               *
      *  Midas - Retail Module                                        *
      *                                                               *
      *  RE4420 - CI Interface Start-Up                               *
      *                                                               *
      *  Function:  This program starts up Cashier Interface          *
      *             background jobs and function tasks before the     *
      *             branch is opened to receive any request           *
      *  (I/C or I/C Init)                                            *
      *                                                               *
      *  Called By: REC4420 - CI Interface Start-Up                   *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD058085           Date 11May21               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      * Midas Release 4.01 -------------------------------------------*
      *                 CRT005             Date 09Aug01               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 122060             Date 06Aug97               *
      *                 CRT003  *CREATE    Date 22Jul96               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD058085 - Deliverable Data Split for Standing Data          *
      *  MD046248 - Finastra Rebranding                               *
      *  CRT005 - Cashier Enhancement for Cash In/Cash Out            *
      *  122060 - Drafts Issuance.                                    *
      *  CRT003 - Cashier Interface.                                  *
      *                                                               *
      *****************************************************************
      /EJECT
     FREACJBL0  IF   E           K DISK    INFSR(*PSSR)
      **  CI Active Jobs
      *
     F*SDBAIJPD* IF   E           K DISK    INFSR(*PSSR)                                    MD058085
      **  CI Jobs File
      *
      /EJECT
      *****************************************************************
      *                                                               *
      *                  FUNCTION OF INDICATORS                       *
      *                  ----------------------                       *
      *                                                               *
      *  11 - LOKUP.                                                  *
      *  12 - EOF ind                                                 *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E   I N D E X                              *
      *                                                               *
      *  *INZSR -  Initialisation.                                    *
      *  *PSSR  -  Program Error.                                     *
      *  DBERR  -  Database Error Handling.                           *
      *  P03    -  Process Background Tasks                           *
      *  P04    -  Prepare Start Up Details                           *
      *  P05    -  Submit Start-Up                                    *
      *  P06    -  Count No. of Jobs                                  *
      *  P07    -  Process Background Jobs                            *
      *                                                               *
      *****************************************************************
      /EJECT
     D CPY@            S             80    DIM(1) CTDATA PERRCD(1)
      ** Array containing Copyright statement
      *
     D**********          PGM        25 10                                                    CRT005
     D PGM             S             10    DIM(29)
      ** Array containing Program Names from CIPGMN
      *
      /EJECT
      *
     D CIREST        E DS            10    EXTNAME(CIREST)
      ** Data area for status
      *
     D  WREST                  1     10
      *
     D LDA           E DS           256    EXTNAME(LDA)
      ** Local data area for database error details
      *
     D SDSTAT        E DS           256    EXTNAME(SDSTAT)
      ** SD data area
      *
     D  WPRFX                  6      7
      *
     D SCSARD        E DS                  EXTNAME(SCSARDPD)
      ** External DS for Switchable Features                                                  CRT005
      *                                                                                       CRT005
     D SDBAII        E DS                  EXTNAME(SDBAIIPD)
      **  CI ICD
      *
     D*SDBAIC*** E DSSDBAICPD                                                               MD058085
     D SDBAIC        E DS                  EXTNAME(SDBACJW0)                                MD058085
     D SDBAIJ        E DS                  EXTNAME(SDBAJJW0)                                MD058085
      **  CI Configuration
      *
     D DSFDY         E DS                  EXTNAME(DSFDY)
      **  First DS for access programs, Short data structure
      *
     D DSSDY         E DS                  EXTNAME(DSSDY)
      ** 2nd   DS for access programs, Long  data structure
      *
     D  PDRIS                  1      9    INZ('RE4144DRI')                     122060
      *                                                                   122060
      *COPY*ZSRSRC,CIPGMNI1                                                                 MD058085
      /COPY ZSRSRC,CIPGMNI1LE                                                               MD058085
      **  CI Function Program Names
      *
      /EJECT
      *****************************************************************
      *                                                               *
      *            MAIN   - Control Processing.                       *
      *                                                               *
      * CALLS      P03    - Process Background Tasks Routine          *
      *            P07    - Process Background Jobs Routine           *
      *                                                               *
      * CALLED BY         -                                           *
      *                                                               *
      * FLDS USED         -                                           *
      *                                                               *
      *****************************************************************
      *
     C                   MOVEA     CPY@          MKI@             80
      *
      ** Process Background Tasks
      *
     C********** WX        IFLE 25                                                            CRT005
     C     WX            IFLE      29
     C                   EXSR      P03
     C                   END
      *
      ** Process Background Jobs
      *
     C                   EXSR      P07
      *
     C                   MOVE      '1'           *INLR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *             P03   - Process Background Tasks                  *
      *                                                               *
      * CALLED BY  MAIN   - Main Processing.                          *
      *                                                               *
      * CALLS      P04    - Prepare Start Up Processing               *
      *                                                               *
      * FLDS USED         -                                           *
      *                                                               *
      *****************************************************************
     C     P03           BEGSR                                                  ** P03    **
      *
      ** Retail Account Balance Enquiry is on
      *
     C     FUBALE        IFEQ      'Y'
     C     WX            IFLE      1
     C                   MOVEL     FUBALP        WPGM             10
     C                   EXSR      P04
     C                   END
     C                   END
      *
      ** Retail Account Transfer is on
      *
     C     FURTFR        IFEQ      'Y'
     C     WX            IFLE      2
     C                   MOVEL     FUTFRP        WPGM
     C                   EXSR      P04
     C                   END
     C                   END
      *
      ** Cash Deposit in Account Currency is on
      *
     C     FUCDAC        IFEQ      'Y'
     C     WX            IFLE      3
     C                   MOVEL     FUCDAP        WPGM
     C                   EXSR      P04
     C                   END
     C                   END
      *
      ** Cheque Deposit in Account Currency is on
      *
     C     FUCQDA        IFEQ      'Y'
     C     WX            IFLE      4
     C                   MOVEL     PGM(4)        WPGM
     C                   EXSR      P04
     C                   END
     C     WX            IFLE      5
     C                   MOVEL     PGM(5)        WPGM
     C                   EXSR      P04
     C                   END
     C                   END
      *
      ** Cash Deposit in Non-Account Currency is on
      *
     C     FUCDNC        IFEQ      'Y'
     C     WX            IFLE      6
     C                   MOVEL     FUCDNP        WPGM
     C                   EXSR      P04
     C                   END
     C                   END
      *
      ** Cheque Deposit in Non-Account Currency is on
      *
     C     FUCQNA        IFEQ      'Y'
     C     WX            IFLE      7
     C                   MOVEL     PGM(7)        WPGM
     C                   EXSR      P04
     C                   END
     C     WX            IFLE      8
     C                   MOVEL     PGM(8)        WPGM
     C                   EXSR      P04
     C                   END
     C                   END
      *
      ** Cash Withdrawal in Account Currency
      *
     C     FUCWAC        IFEQ      'Y'
     C     WX            IFLE      9
     C                   MOVEL     FUCWAP        WPGM
     C                   EXSR      P04
     C                   END
     C                   END
      *
      ** Cash Withdrawal in Non-Account Currency is on
      *
     C     FUCWNA        IFEQ      'Y'
     C     WX            IFLE      10
     C                   MOVEL     FUCWNP        WPGM
     C                   EXSR      P04
     C                   END
     C                   END
      *
      ** Cheque Withdrawal in Account Currency is on
      *
     C     FUCQWA        IFEQ      'Y'
     C     WX            IFLE      11
     C                   MOVEL     FUCQWP        WPGM
     C                   EXSR      P04
     C                   END
     C                   END
      *
      ** Cheque Withdrawal in Non-Account Currency is on
      *
     C     FUCQWN        IFEQ      'Y'
     C     WX            IFLE      12
     C                   MOVEL     FUCQWQ        WPGM
     C                   EXSR      P04
     C                   END
     C                   END
      *
      ** Bureau de change is on
      *
     C     FUBDCT        IFEQ      'Y'
     C     WX            IFLE      13
     C                   MOVEL     FUBDCP        WPGM
     C                   EXSR      P04
     C                   END
     C                   END
      *
      ** Buy Travellers Cheques is on
      *
     C     FUBTC         IFEQ      'Y'
     C     WX            IFLE      14
     C                   MOVEL     PGM(14)       WPGM
     C                   EXSR      P04
     C                   END
     C     WX            IFLE      15
     C                   MOVEL     PGM(15)       WPGM
     C                   EXSR      P04
     C                   END
     C     WX            IFLE      16
     C                   MOVEL     PGM(16)       WPGM
     C                   EXSR      P04
     C                   END
     C     WX            IFLE      17
     C                   MOVEL     PGM(17)       WPGM
     C                   EXSR      P04
     C                   END
     C                   END
      *
      ** Sell Travellers Cheque is on
      *
     C     FUSTC         IFEQ      'Y'
     C     WX            IFLE      18
     C                   MOVEL     PGM(18)       WPGM
     C                   EXSR      P04
     C                   END
     C     WX            IFLE      19
     C                   MOVEL     PGM(19)       WPGM
     C                   EXSR      P04
     C                   END
     C     WX            IFLE      20
     C                   MOVEL     PGM(20)       WPGM
     C                   EXSR      P04
     C                   END
     C     WX            IFLE      21
     C                   MOVEL     PGM(21)       WPGM
     C                   EXSR      P04
     C                   END
     C                   END
      *
      ** Transaction Reversal is on
      *
     C     FUTXRV        IFEQ      'Y'
     C     WX            IFLE      22
     C                   MOVEL     FUTXRP        WPGM
     C                   EXSR      P04
     C                   END
     C                   END
      *
      ** Passbook Update is on
      *
     C     FUPUPD        IFEQ      'Y'
     C     WX            IFLE      23
     C                   MOVEL     FUPUPP        WPGM
     C                   EXSR      P04
     C                   END
     C                   END
      *
      ** Passbook Name and Address is on
      *
     C     FUPNAD        IFEQ      'Y'
     C     WX            IFLE      24
     C                   MOVEL     FUPNAP        WPGM
     C                   EXSR      P04
     C                   END
     C                   END
      *
      ** Draft Issuance is on
      *
     C     FUDISS        IFEQ      'Y'
     C     WX            IFLE      25
     C                   MOVEL     FUDISP        WPGM
     C                   EXSR      P04
     C                   END
     C                   END
      *                                                                                       CRT005
     C     CRT005        IFEQ      'Y'
      *                                                                                       CRT005
      ** Teller Cross In                                                                      CRT005
      *                                                                                       CRT005
     C     FUTCI         IFEQ      'Y'
     C     WX            ANDLE     26
     C                   MOVEL     FUTCIP        WPGM
     C                   EXSR      P04
     C                   ENDIF
      *                                                                                       CRT005
      ** Teller Cross out                                                                     CRT005
      *                                                                                       CRT005
     C     FUTCO         IFEQ      'Y'
     C     WX            ANDLE     27
     C                   MOVEL     FUTCOP        WPGM
     C                   EXSR      P04
     C                   ENDIF
      *                                                                                       CRT005
      ** Teller Treasury In                                                                   CRT005
      *                                                                                       CRT005
     C     FUTTI         IFEQ      'Y'
     C     WX            ANDLE     28
     C                   MOVEL     FUTTIP        WPGM
     C                   EXSR      P04
     C                   ENDIF
      *                                                                                       CRT005
      ** Teller Treasury Out                                                                  CRT005
      *                                                                                       CRT005
     C     FUTTO         IFEQ      'Y'
     C     WX            ANDLE     29
     C                   MOVEL     FUTTOP        WPGM
     C                   EXSR      P04
     C                   ENDIF
      *                                                                                       CRT005
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *            P04    - Prepare Start-Up Processing               *
      *                                                               *
      * CALLED BY  P03    - Process Background Tasks Routine          *
      *                                                               *
      * CALLS      DBERR  - Database Error Handling                   *
      *            P05    - Submit Start Up                           *
      *                                                               *
      * FLDS USED         -                                           *
      *                                                               *
      *****************************************************************
     C     P04           BEGSR                                                  ** P04    **
      *
      ** Save Pgm-Function to dtaara CIREST
      *
     C     *LOCK         IN        CIREST
     C                   MOVEL     WPGM          WREST
     C                   OUT       CIREST
      *
     C     WPGM          IFEQ      'CASH_REC'                                                  12206
     C                   MOVEL     'RE4144'      WKPGM            10                           12206
     C                   MOVEL     'DRI'         WKFNC             3                           12206
     C                   ELSE                                                                  12206
     C     6             SUBST     WPGM:1        WKPGM            10
     C     3             SUBST     WPGM:7        WKFNC             3
     C                   ENDIF                                                                 12206
      *
     C                   CALL      'AOBAICR0'
     C                   PARM      '*BLANKS'     @RTCD             7
     C                   PARM      '*KEY   '     @OPTN             7
     C                   PARM      WKPGM         @KEY1            10
     C                   PARM      WKFNC         @KEY2             3
     C     SDBAIC        PARM      SDBAIC        DSFDY
      *
     C     @RTCD         IFNE      *BLANKS
     C     *LOCK         IN        LDA
     C                   Z-ADD     02            DBASE
     C                   MOVEL     'SDBAICPD'    DBFILE
     C                   MOVEL     WPGM          DBKEY
     C                   EXSR      DBERR
     C                   ENDIF
      *
      ** Get the program parameters and the
      ** default no of pgm started from SDBAICPD
      *
     C                   MOVEL     CFPGPM        WPRM             50
     C                   Z-ADD     CFPGDF        WDFN              2 0
      *
      ** Submit Start-Up
      *
     C                   EXSR      P05
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *            P05    - Submit Start Up                           *
      *                                                               *
      * CALLED BY  P04    - Prepare Start-Up Processing               *
      *            P07    - Process Background Jobs                   *
      *                                                               *
      * CALLS      P06    - Count No of Jobs                          *
      *                                                               *
      * FLDS USED         -                                           *
      *                                                               *
      *****************************************************************
     C     P05           BEGSR                                                  ** P04    **
      *
     C                   Z-ADD     0             WNOTS             2 0
      *
      ** Count no of active jobs
      *
     C                   EXSR      P06
     C                   Z-ADD     WNOAJ         WNOTS
      *
     C     WPGM          IFEQ      'CASH_REC'                                                  12206
     C     PDRIS         CAT       WPRM          WPLST            60                           12206
     C                   ELSE                                                                  12206
     C     WPGM          CAT       WPRM          WPLST            60
     C                   ENDIF                                                                 12206
      *
      ** Call the tasks using the above parameter list
      *
     C     WNOTS         DOWLT     WDFN
     C                   CALL      'REC4435'
     C                   PARM                    WPLST
     C                   PARM      FUJBDE        WJOBD            10
     C                   PARM      FUJBQU        WJOBQ            10
      *
     C                   ADD       1             WNOTS
     C                   ENDDO
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *            P06    - Count No of Jobs                          *
      *                                                               *
      * CALLED BY  P05    - Submit Start Up                           *
      *                                                               *
      * CALLS             -                                           *
      *                                                               *
      * FLDS USED         -                                           *
      *                                                               *
      *****************************************************************
     C     P06           BEGSR                                                  ** P06    **
      *
     C                   Z-ADD     0             WNOAJ             2 0
      *
     C     WPGM          SETLL     REACJBD0
     C                   READ      REACJBD0                               12
      *
     C     *IN12         DOWEQ     '0'
     C     WPGM          ANDEQ     RQJBNM
     C                   ADD       1             WNOAJ
     C                   READ      REACJBD0                               12
     C                   ENDDO
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *            P07    - Process Background Jobs                   *
      *                                                               *
      * CALLED BY  MAIN   - Main Processing                           *
      *                                                               *
      * CALLS      P05    - Submit Start-Up                           *
      *                                                               *
      * FLDS USED         -                                           *
      *                                                               *
      *****************************************************************
     C     P07           BEGSR                                                  ** P07    **
      *
     C**********         READ      SDBAIJD0                               12                MD058085
     C/EXEC SQL                                                                             MD058085
     C+ declare ACursor insensitive scroll cursor for                                       MD058085
     C+ select * from SDBAJJW0                                                              MD058085
     C+ order by F0BPGM                                                                     MD058085
     C/END-EXEC                                                                             MD058085
                                                                                            MD058085
     C/EXEC SQL                                                                             MD058085
     C+ open ACursor                                                                        MD058085
     C/END-EXEC                                                                             MD058085
                                                                                            MD058085
     C/EXEC SQL                                                                             MD058085
     C+ fetch next from ACursor into :SDBAIJ                                                MD058085
     C/END-EXEC                                                                             MD058085
                                                                                            MD058085
     C******IN12         DOWEQ     '0'                                                      MD058085
     C     SQLCODE       DOWEQ     0                                                        MD058085
     C                   MOVEL     F0PGPM        WPRM
     C                   Z-ADD     1             WDFN
     C                   MOVEL     F0BPGM        WPGM
      *
      ** Save Pgm-Function to dtaara CIREST
      *
     C     *LOCK         IN        CIREST
     C                   MOVEL     WPGM          WREST
     C                   OUT       CIREST
      *
      ** Submit Start-Up
      *
     C                   EXSR      P05
     C**********         READ      SDBAIJD0                               12                MD058085
     C/EXEC SQL                                                                             MD058085
     C+ fetch next from ACursor into :SDBAIJ                                                MD058085
     C/END-EXEC                                                                             MD058085
     C                   ENDDO
      *
     C/EXEC SQL                                                                             MD058085
     C+ close ACursor                                                                       MD058085
     C/END-EXEC                                                                             MD058085
                                                                                            MD058085
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *             DBERR - Database Error Handling.                  *
      *                                                               *
      * CALLED BY         -                                           *
      *                   -                                           *
      *                                                               *
      * CALLS             -                                           *
      *                                                               *
      * FLDS USED         -                                           *
      *                                                               *
      *****************************************************************
     C     DBERR         BEGSR                                                  ** DBERR  **
      *
     C                   MOVEL     'RE4420'      DBPGM
     C                   OUT       LDA
     C                   DUMP
     C                   SETON                                        U7U8LR
     C                   RETURN
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *PSSR             - Program error                             *
      *                                                               *
      * CALLS      DBERR  -                                           *
      *                                                               *
      * CALLED BY         -                                           *
      *                                                               *
      *****************************************************************
     C     *PSSR         BEGSR                                                  ** *PSSR  **
      *
      **  Check to see that *PSSR has not been called yet
      *
     C     WRUN          IFEQ      *BLANK
     C                   MOVE      'Y'           WRUN              1
     C                   SETON                                        U7U8LR
     C     *LOCK         IN        LDA
     C                   EXSR      DBERR
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *            *INZSR - Initialisation Subroutine                 *
      *                                                               *
      * CALLS             -                                           *
      *                                                               *
      * CALLED BY         -                                           *
      *                                                               *
      * FLDS USED         -                                           *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR                                                  ** *INZSR **
      *
     C     *DTAARA       DEFINE                  LDA
     C                   IN        LDA
      *
     C     *DTAARA       DEFINE                  SDSTAT
     C                   IN        SDSTAT
      *
     C     *DTAARA       DEFINE                  CIREST
     C                   IN        CIREST
      *
     C                   MOVEL     *BLANKS       DBFILE
     C                   MOVEL     *BLANKS       DBKEY
     C                   Z-ADD     0             DBASE
      *
      ** Get the CI ICD
      *
     C**********           CALL 'AOBAIIR0'                                                    CRT005
     C                   CALL      'AOBAIIR1'
     C                   PARM      '*BLANKS'     @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C     SDBAII        PARM      SDBAII        DSSDY
      *
     C     @RTCD         IFNE      *BLANKS
     C     *LOCK         IN        LDA
     C                   Z-ADD     01            DBASE
     C                   MOVEL     'SDBAIIPD'    DBFILE
     C                   MOVEL     @OPTN         DBKEY
     C                   EXSR      DBERR
     C                   ENDIF
      *                                                                                       CRT005
      ** Determine if CRT005 is installed                                                     CRT005
      *                                                                                       CRT005
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       PRTCD             7
     C                   PARM      '*VERIFY '    POPTN             7
     C                   PARM      'CRT005'      PSARD             6
     C     SCSARD        PARM      SCSARD        DSFDY
      *                                                                                       CRT005
     C     PRTCD         IFNE      *BLANKS
     C     PRTCD         ANDNE     '*NRF   '
     C     *LOCK         IN        LDA
     C                   MOVEL     'SCSARDPD'    DBFILE
     C                   Z-ADD     03            DBASE
     C                   MOVEL     'CRT005'      DBKEY
     C                   EXSR      DBERR
     C                   ENDIF
      *                                                                                       CRT005
     C     PRTCD         IFEQ      *BLANKS
     C                   MOVE      'Y'           CRT005            1
     C                   ELSE
     C                   MOVE      'N'           CRT005
     C                   ENDIF
      *
      ** Fill the function pgm array
      *
     C                   MOVEL     WBALP         PGM(1)
     C                   MOVEL     WTFRP         PGM(2)
     C                   MOVEL     WCDAP         PGM(3)
     C                   MOVEL     WCQDP1        PGM(4)
     C                   MOVEL     WCQDP2        PGM(5)
     C                   MOVEL     WCDNP         PGM(6)
     C                   MOVEL     WCQNP1        PGM(7)
     C                   MOVEL     WCQNP2        PGM(8)
     C                   MOVEL     WCWAP         PGM(9)
     C                   MOVEL     WCWNP         PGM(10)
     C                   MOVEL     WCQWP         PGM(11)
     C                   MOVEL     WCQWQ         PGM(12)
     C                   MOVEL     WBDCP         PGM(13)
     C                   MOVEL     WBTCP1        PGM(14)
     C                   MOVEL     WBTCP2        PGM(15)
     C                   MOVEL     WBTCP3        PGM(16)
     C                   MOVEL     WBTCP4        PGM(17)
     C                   MOVEL     WSTCP1        PGM(18)
     C                   MOVEL     WSTCP2        PGM(19)
     C                   MOVEL     WSTCP3        PGM(20)
     C                   MOVEL     WSTCP4        PGM(21)
     C                   MOVEL     WTXRP         PGM(22)
     C                   MOVEL     WPUPP         PGM(23)
     C                   MOVEL     WPNAP         PGM(24)
     C                   MOVEL     WDISP         PGM(25)
      *                                                                                       CRT005
     C     CRT005        IFEQ      'Y'
      *                                                                                       CRT005
     C                   MOVEL     WTCIP         PGM(26)
     C                   MOVEL     WTCOP         PGM(27)
     C                   MOVEL     WTTIP         PGM(28)
     C                   MOVEL     WTTOP         PGM(29)
      *                                                                                       CRT005
     C                   ENDIF
      *
      ** Check from which point submission of programs will restart
      *
     C                   Z-ADD     1             WX                2 0
      *
     C     WREST         IFNE      *BLANKS
     C     WREST         LOOKUP    PGM(WX)                                11
     C     *IN11         IFEQ      '0'
     C                   Z-ADD     99            WX
     C                   END
     C                   END
      *
     C                   ENDSR
      *****************************************************************
**  CPY@  OBJECT COPYRIGHT
(c) Finastra International Limited 2001
