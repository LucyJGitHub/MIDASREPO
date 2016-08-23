     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas TI Date conversion MODULE')
      *****************************************************************
      *                                                               *
      *  Midas - Trade Innovation Interface Module                    *
      *                                                               *
      *  TI1004M - Midas TI Date Conversion:                          *
      *                                                               *
      *           Midas date(5,0P) -> CYYMMDD(7,0N)                   *
      *                                                               *
      *  Function:  This program converts standing data from Midas    *
      *             format to TI format.                              *
      *                                                               *
      *  Phases:                                                      *
      *                                                               *
      *  Called By:                                                   *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *  Last Amend No. CTI001  *CREATE    Date 26AUG97               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CTI001 - Created for Midas/TI Interface                      *
      *                                                               *
      *****************************************************************
      *
     D CPY@            S             80    DIM(1) CTDATA PERRCD(1)
      ** Array containing Copyright statement
      *
     D TIDATE          DS
     D  CNTURY                 1      1  0
     D  YEAR                   2      3  0
     D  MMDD                   4      7  0
      *
     D                 DS
     D  ZDATE                  1      6  0
     D  W#MMDD                 1      4  0
     D  W#YEAR                 5      6  0
      *
      ** Parameters passed in
      *
     C     *ENTRY        PLIST
     C                   PARM                    MIDATE            5 0
     C                   PARM                    TIDATE
      *
      ** Set up copyright parameter
      *
     C                   MOVEA     CPY@          CPY2@            80
      *
      ** If zero date, return zeros to TI
      *
     C     MIDATE        IFEQ      0
     C                   MOVE      '0000000'     TIDATE
     C                   RETURN
     C                   ENDIF
      *
      ** Call ZDATE2M (with *IN98 on) to get ZDATE (MMDDYY)
      *
     C                   CALLB     'ZDATE2'
     C                   PARM      MIDATE        MidasDay          5 0          Value date
     C                   PARM      'M'           DateFormat        1            Date format ind
     C     ZDATE         PARM      *ZERO         RealDate          6 0          Value date
     C                   PARM      *BLANK        DateChar          7            Run-date in DDM
      *
     C                   MOVE      W#MMDD        MMDD
     C                   MOVE      W#YEAR        YEAR
      *
      ** if YEAR > 40 then 20th century, else 21st century
      *
     C     YEAR          IFGT      40
     C                   MOVE      0             CNTURY
     C                   ELSE
     C                   MOVE      1             CNTURY
     C                   ENDIF
      *
      ** return parameters
      *
     C                   RETURN
      *
**  CPY@
(c) Misys International Banking Systems Ltd. 2001
