     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas Date to Day number conversion.')
     F*****************************************************************
     F*                                                               *
     F*  Midas - Common processing                                    *
     F*                                                               *
     F*     ZA0270 - DATE TO DAY NUMBER CONVERSION                    *
     F*                                                               *
      *  (c) Finastra International Limited 2001                      *
     F*                                                               *
      *    This source is centrally supported and must ONLY be        *
      *    amended by Core Development Personnel                      *
      *                                                               *
      *    /COPY, Client or Country amendments must not be            *
      *    applied to this source.                                    *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *  Prev Amend No. CAP002             Date 07Nov97               *
      *                                    Date DDMmmYY               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CAP002 - Conversion of Midas inputs into modular structure   *
      *           to use as APIs.  This existing OPM program has been *
      *           converted into an ILE module to allow bound calls   *
      *           to be made to it.  Additionally a source member     *
      *           has been created for it in ZAPGMSRC, to ensure that *
      *           dynamic calls to it will still work.                *
      *                                                               *
     F*****************************************************************
     F*
     F**ID F  C  H  L    FUNCTION OF INDICATORS
     F*                  NO INDICATORS USED
     D/EJECT
     D*
     D**  ARRAY FOR CUMULATIVE DAYS IN A FOUR YEAR PERIOD
     D*
     D @YR             S              4  0 DIM(4) CTDATA PERRCD(4)
     D*
     D**  ARRAY FOR CUMULATIVE DAYS IN A YEAR, BY MONTH
     D @MT             S              3  0 DIM(13) CTDATA PERRCD(13)
     D*
     D**  ARRAY OF DAYS IN A MONTH
     D @DY             S              2  0 DIM(12) CTDATA PERRCD(12)
     D CPY@            S             80    DIM(1) CTDATA PERRCD(1)
     D/EJECT
     D PSDS           SDS
     D*
     D** PROGRAM DATA STRUCTURE
     D  @JOB                 244    253
     D  @USER                254    263
     C/EJECT
     C*
     C**  RECEIVE PARAMETERS FROM CALLING PROGRAM
     C     *ENTRY        PLIST
     C                   PARM                    @@DATE            6 0
     C                   PARM                    @@DFMT            1
     C                   PARM                    @@RTN             1
     C                   PARM                    @@DAYN            5 0
     C*
     C**  INITIALISATION PROCESSING
     C                   EXSR      #A
     C*
     C**  MAIN PROCESSING
     C                   EXSR      #B
     C*
     C**  TERMINATION PROCESS
     C                   RETURN
     C*
     C     ENDPGM        TAG                                                    ENDPGM
     C/EJECT
     C****************************************************************
     C*  INDEX TO SUBROUTINES - LISTED ACCORDING TO USAGE            *
     C*                                                              *
     C*                       1) #A       - INITIALISE WORK FIELDS   *
     C*                       2) #B       - MAIN PROCESS             *
     C*                       3) #BA      - VALIDATION OF PARAMETERS *
     C*                       4) #BB      - CALCULATION OF NUMBER OF *
     C*                                     DAYS                     *
     C****************************************************************
     C/EJECT
     C****************************************************************
     C*  SUBROUTINE - #A     INITIAL PROCESS                         *
     C*                                                              *
     C*                      INITIALISATION OF ALL WORK FIELDS AND   *
     C*                      RETURN CODE                             *
     C*  FIELDS USED :-                                              *
     C*                      @@YY - YEAR PORTION OF DATE             *
     C*                      @@MM - MONTH PORTION OF DATE            *
     C*                      @@DD - DAY PORTION OF DATE              *
     C*                      @@MD - MONTH & DAY PORTION              *
     C*                      @@4Y - NUMBER OF FOUR YEAR PERIODS      *
     C*                             SINCE 1/1/71                     *
     C*                      @@REM - REMAINING YEARS                 *
     C*                      @@DAYN - NO OF DAYS SINCE 1/1/71        *
     C*                      @@NO - NO. OF DAYS IN MONTH             *
     C*                                                              *
     C*  CALLED BY :-                                                *
     C*                                                              *
     C*  CALLS     :-                                                *
     C****************************************************************
     C*
     C     #A            BEGSR                                                  #A
     C                   MOVEA     CPY@          BIS@             80
     C*
     C                   Z-ADD     0             @@YY              2 0
     C                   Z-ADD     0             @@MM              2 0
     C                   Z-ADD     0             @@DD              2 0
     C                   Z-ADD     0             @@MD              4 0
     C                   Z-ADD     0             @@4Y              2 0
     C                   Z-ADD     0             @@REM             1 0
     C                   Z-ADD     0             @@DAYN            5 0
     C                   Z-ADD     0             @@NO              2 0
     C*
     C                   MOVE      '0'           @@RTN
     C*
     C     #A9           ENDSR                                                  #A9
     C/EJECT
     C****************************************************************
     C*  SUBROUTINE - #B     MAIN PROCESS                            *
     C*                                                              *
     C*                      VALIDATION OF PARAMETERS AND CALCULATION*
     C*                      OF DAY NUMBER                           *
     C*  FIELDS USED :-                                              *
     C*                                                              *
     C*  CALLED BY :-                                                *
     C*                                                              *
     C*  CALLS     :-        #BA,#BB                                 *
     C****************************************************************
     C*
     C     #B            BEGSR                                                  #B
     C*
     C**  VALIDATE PARAMETERS RECEIVED -
     C                   EXSR      #BA
     C*
     C**  CHECK IF INVALID PARAMETER FOUND -
     C     @@RTN         IFEQ      '1'
     C                   GOTO      #B9
     C                   END
     C*
     C**  IF VALIDATION SUCCESSFUL, CALCULATE DAYS -
     C                   EXSR      #BB
     C*
     C     #B9           ENDSR                                                  #B9
     C/EJECT
     C****************************************************************
     C*  SUBROUTINE - #BA    VALIDATION OF RECIEVED PARAMETERS       *
     C*                                                              *
     C*  FIELDS USED :-                                              *
     C*                                                              *
     C*  CALLED BY :-        #B                                      *
     C*                                                              *
     C*  CALLS     :-                                                *
     C****************************************************************
     C*
     C     #BA           BEGSR                                                  #BA
     C*
     C**  CHECK VALUE OF @@DFMT IS VALID  SHOULD BE M OR D
     C     @@DFMT        IFNE      'D'
     C     @@DFMT        IFNE      'M'
     C*
     C                   MOVE      '1'           @@RTN
     C                   GOTO      #BA9
     C*
     C                   END
     C                   END
     C*
     C**  CHECK VALUE OF @@DATE IS VALID
     C**  BREAK DATE INTO YEAR,MONTH,DATE PORTIONS.
     C                   MOVE      @@DATE        @@YY
     C                   MOVEL     @@DATE        @@MD
     C*
     C**  CHECK IF DATE FORMAT MMDDYY
     C     @@DFMT        IFEQ      'M'
     C                   MOVEL     @@MD          @@MM
     C                   MOVE      @@MD          @@DD
     C*
     C                   ELSE
     C*
     C                   MOVEL     @@MD          @@DD
     C                   MOVE      @@MD          @@MM
     C*
     C                   END
     C*
     C**  VALIDATE MONTH VALUE
     C     @@MM          IFLT      1
     C                   MOVE      '1'           @@RTN
     C                   GOTO      #BA9
     C                   END
     C*
     C     @@MM          IFGT      12
     C                   MOVE      '1'           @@RTN
     C                   GOTO      #BA9
     C                   END
     C*
     C**  GET DAYS IN THIS MONTH
     C                   Z-ADD     @DY(@@MM)     @@NO
     C*
     C**  CHECK IF A LEAP YEAR
     C                   ADD       28            @@YY
     C     @@YY          DIV       4             @@4Y
     C                   MVR                     @@REM
     C*
     C**  VALIDATE DAY VALUE
     C     @@MM          IFNE      2
     C     @@DD          IFGT      @@NO
     C*
     C                   MOVE      '1'           @@RTN
     C                   GOTO      #BA9
     C*
     C                   END
     C                   END
     C*
     C     @@DD          IFLT      1
     C                   MOVE      '1'           @@RTN
     C                   GOTO      #BA9
     C                   END
     C*
     C**  IF FEBRUARY FURTHER VALIDATE
     C     @@MM          IFEQ      2
     C*
     C     @@REM         IFEQ      0
     C     @@DD          IFGT      29
     C*
     C                   MOVE      '1'           @@RTN
     C                   GOTO      #BA9
     C*
     C                   END
     C                   END
     C*
     C     @@REM         IFGT      0
     C     @@DD          IFGT      28
     C*
     C                   MOVE      '1'           @@RTN
     C                   GOTO      #BA9
     C*
     C                   END
     C                   END
     C*
     C                   END
     C*
     C     #BA9          ENDSR                                                  #BA9
     C/EJECT
     C****************************************************************
     C*  SUBROUTINE - #BB    CALCULATE NUMBER OF DAYS FROM 1/1/71    *
     C*                                                              *
     C*  FIELDS USED :-                                              *
     C*                                                              *
     C*  CALLED BY :-        #B                                      *
     C*                                                              *
     C*  CALLS     :-                                                *
     C****************************************************************
     C     #BB           BEGSR                                                  #BB
     C*
     C     @@4Y          MULT      1461          @@DAYN
     C*
     C     @@REM         IFEQ      0
     C     @@MM          IFGT      2
     C*
     C                   ADD       1             @@DAYN
     C*
     C                   END
     C                   END
     C*
     C     @@REM         IFGT      0
     C                   ADD       @YR(@@REM)    @@DAYN
     C                   END
     C*
     C                   ADD       @MT(@@MM)     @@DAYN
     C                   ADD       @@DD          @@DAYN
     C*
     C     #BB9          ENDSR                                                  #BB9
     C*
     C********************************************************************
**  SSY - CUMULATIVE DAYS IN A FOUR YEAR PERIOD
0366073110961461
**  SSM - CUMULATIVE DAYS IN A YEAR, BY MONTH
000031059090120151181212243273304334365
**  MDY - DAYS IN A MONTH
312831303130313130313031
**
(c) Finastra International Limited 2001
