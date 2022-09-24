     H DEBUG
      *****************************************************************
/**** *  RPGBASE                                                      *                     MD058085
/*STD *  RPGSQLBND                                                    *                     MD058085
/*EXI *  TEXT('Midas ME Validate Field 77D: Conditions')              *
      *****************************************************************
      *                                                               *
      *  Midas - Message Management Module                            *
      *                                                               *
      *  ME9960 - Validate Field 77D: Conditions                      *
      *                                                               *
      *  Function:  This program handles the validation of Field 77D: *
      *             Conditions                                        *
      *                                                               *
      *  Called By: SD2410 - Extended Settlement Instructions         *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD058085           Date 11May21               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      *                 MD023071           Date 31Oct13               *
      *                 MD022945           Date 18Oct13               *
      *                 CSW213             Date 03Jun13               *
      *                 CSW212             Date 03May12               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD027             Date 09Dec05               *
      *                 CSC022             Date 24Feb04               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.02 -----------------------------------------------*
      *                 CSW097             Date 02DEC99               *
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 CSW005  *CREATE    Date 01Aug96               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD058085 - Deliverable Data Split for Standing Data          *
      *  MD046248 - Finastra Rebranding                               *
      *  MD023071 - No error message shown when /VALD/ is inputted in *
      *             a line other than the first, or when /SETC/ is    *
      *             inputted in a line other than the second, or when *
      *             /VALD/ is inputted on the first line but not      *
      *             followed by a date.                               *
      *  MD022945 - Incorrect message shown for /SRCE/ validation.    *
      *  CSW213 - SWIFT Changes 2013                                  *
      *  CSW212 - SWIFT 2012 Changes                                  *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CSC022 - Commitment Control Changes for MidasPlus            *
      *  CSW097 - MT34*s and MT36*s Message Generation.               *
      *           Remove the codeword validation.                     *
      *  CSW005 - FRAIRS MG34n & MG34n Message Generation             *
      *                                                               *
      *****************************************************************
      /TITLE FUNCTION OF INDICATORS
      *****************************************************************
      *                                                               *
      *  F U N C T I O N    O F   I N D I C A T O R S                 *
      *                                                               *
      *  90    General Error Indicator                                *
      *                                                               *
      *****************************************************************
      /EJECT
      /TITLE SUBROUTINE INDEX
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E   I N D E X                              *
      *                                                               *
      *  SRCOND   : Validate Field 77D:  Conditions                   *
      *  SROTHR   : Validate Other Details                            *
      ***SRKYWD***:*Validate*keywords*used*****************************   CSW097
      *  SRNEBL   : Check for embedded blanks                         *
      *  SRSWCH   : Check for valid SWIFT characters                  *
      *  SRSNMS   : Send Message to Calling program                   *
      *                                                               *
      *****************************************************************
     F*SDISOCL0* IF   E           K DISK                                                    MD058085
     FSDCURRL1  IF   E           K DISK
      /EJECT
     D CPY@            S             80    DIM(1) CTDATA PERRCD(1)
      *  Array containing Copyright statement
      *
      *  Error codes array
      *
     D***********         CDEW    1  15 35                                CSW097
      ***Swift*codewords*                                                 CSW097
      *
      ** Array of Commitment Job Names                                                        CSC022
     D CMTJOB          S             10    DIM(10)
      *                                                                                       CSC022
     D*COPY*MECPYSRC,SRERRE                                                                 MD058085
     D/COPY MECPYSRC,SRERRELE                                                               MD058085
     I*COPY*ZSRSRC,ZDATE1Z1                                                          MD058085 CSW212
     I/COPY ZSRSRC,ZDATE2Z1LE                                                               MD058085
      * Data structures:
     D JBDTTM          DS
      * Job date/time
     D  ##JDT                  1      6  0
     D  ##JYY                  1      2  0
     D  ##JMM                  3      4  0
     D  ##JDD                  5      6  0
     D  ##JTM                  7     12  0
     D  ##JHH                  7      8  0
     D  ##JNN                  9     10  0
     D  ##JSS                 11     12  0
      *
      *  Copysource for error processing
      *
     D*COPY*MECPYSRC,SRERRI                                                                 MD058085
     D/COPY MECPYSRC,SRERRILE                                                               MD058085
      *
     D I#PARM          DS           512
      * Field to be validated
     D  I#VFLD                 1      5
      * Message Type                                                                          CSW213
     D  I#MTYP                62     64
      * Transaction type
     D  I#TTYP               144    145
      * Conditions
     D  I#CND                257    466
     D  I#CND1               257    291
     D  I#CND2               292    326
     D  I#CND3               327    361
     D  I#CND4               362    396
     D  I#CND5               397    431
     D  I#CND6               432    466
     D  I#C1DT               263    270
     D  I#C1DY               265    270
     D  I#C1BL               271    291
     D  I#C2IS               298    300
     D  I#C2BL               301    326
      *
      * Output Parameters
      *
     D O#PARM          DS           512
      * Conditions
     D  O#CND                257    466
     D  O#CND1               257    291
     D  O#CND2               292    326
     D  O#CND3               327    361
     D  O#CND4               362    396
     D  O#CND5               397    431
     D  O#CND6               432    466
      *
      * Error Parameters
      *
     D E#PARM          DS           256
      * Calling Program
     D  E#CPGM                 1     10
      * Error message sent
     D  E#ERRM                12     12
      * Warning message sent
     D  E#WARN                13     13
      * Error index
     D  E#INDX                14     18  0
      * Message text to prefix error message
     D  E#MSGD                19     25
     D  E#MSGF                26     35
      * Error codes array
     D  E#ERCD                51    200
     D  ERCD                  51    200
     D                                     DIM(50)
     D DSMTR           DS
      *
      *  Define fields for message transalation
      *
     D  #MSDTA                 1    132
     D  #MSTX1               133    264
     D #MSTX2          DS
     D  #MSTXA                 1    256
     D  #MSTXB               257    512
      *                                                                                       CSC022
     D SCCMT           DS           256
     D  CMTNUM                 1      3  0
     D  CMTARR                 4    103
      *                                                                                       CSC022
     D WDATE           DS
     D  WDAY                   1      2
     D  WMTH                   3      4
     D  WYRS                   5      6
      *                                                                                       CSW212
      * Extended ISO
     D ISOEX           C                   CONST('ABCDEFGHIJKLMNOPQRST-
     D                                     UVWXYZ 1234567890/-?-
     D                                     ?:().,''+abcdefghijk-
     D                                     lmnopqrstuvwxyz')
      *
     D SDISOC        E DS                  EXTNAME(SDISOJW0)                                MD058085
      /EJECT
      *
      *  Set up copyright statement
      *
     C                   MOVEA     CPY@          CPY2@            80
      *
      *  Set up subroutine stack name
      *
     C                   ADD       1             Q
     C                   MOVEL     'MAIN'        @STK(Q)
      * Entry parameters
      *
     C     *ENTRY        PLIST
     C                   PARM                    W0RTN             7
     C                   PARM                    I#PARM                         I Input Parms
     C                   PARM                    O#PARM                         O Output Parms
     C                   PARM                    E#PARM                         E Error Inform
     C                   PARM                    Z#PARM          256            B User Defined
      *
      * Initialise return code etc
      *
     C                   MOVEL     *BLANK        P#RTCD            7
     C                   MOVEL     *BLANK        E#ERRM
     C                   MOVEL     *BLANK        E#WARN
     C                   MOVEL     *BLANK        E#ERCD
     C                   Z-ADD     1             E                 5 0
      *                                                                                       CSC022
      ** Check if CSC022 is switched *ON.                                                     CSC022
      *                                                                                       CSC022
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD             7
     C                   PARM      '*VERIFY'     @OPTN             7
     C                   PARM      'CSC022'      @SARD             6
      *                                                                                       CSC022
     C     @RTCD         IFEQ      *BLANKS
     C                   MOVE      'Y'           CSC022            1
     C     *DTAARA       DEFINE    SCCMTJOB      SCCMT
     C                   IN        SCCMT
     C                   Z-ADD     1             C                 3 0
     C                   MOVEL     *BLANKS       WCMTSK            1
     C                   MOVEA     CMTARR        CMTJOB
     C     CMTNUM        IFGT      0
     C     C             DOWLE     CMTNUM
     C     ##JOB         IFEQ      CMTJOB(C)
     C                   MOVEL     'Y'           WCMTSK
     C                   ENDIF
     C                   ADD       1             C
     C                   ENDDO
     C                   ENDIF
     C                   ELSE
     C                   MOVE      'N'           CSC022
     C                   ENDIF
      *                                                                                       CSW212
      ** Check if SWIFT Changes 2012 (CSW212) is installed                                    CSW212
      *                                                                                       CSW212
     C                   CALL      'SWIF2012'
     C                   PARM      *BLANKS       P@RTCD            7
      *                                                                                       CSW212
     C     P@RTCD        IFEQ      'CSW2012'
     C                   MOVE      'Y'           CSW212            1
     C                   ELSE
     C                   MOVE      'N'           CSW212
     C                   ENDIF
      *                                                                                       CSW213
      ** Check if SWIFT Changes 2013 (CSW213) is installed                                    CSW213
      *                                                                                       CSW213
     C                   CALL      'SWIF2013'
     C                   PARM      *BLANKS       P@RTCD
      *                                                                                       CSW213
     C     P@RTCD        IFEQ      'CSW2013'
     C                   MOVE      'Y'           CSW213            1
     C                   ELSE
     C                   MOVE      'N'           CSW213
     C                   ENDIF
      *
      ** Depending on field call relevant subroutine
      *
     C                   SELECT
      *  Conditions flds
     C     I#VFLD        WHENEQ    ':77D:'
     C                   EXSR      SRCOND
      * Catch all
     C                   OTHER
     C                   EXSR      SROTHR
     C                   ENDSL
      *
      *
      ** Set return depending errors found
     C     P#RTCD        IFNE      *BLANKS
     C                   MOVEL     P#RTCD        W0RTN
     C                   ENDIF
     C     E             IFNE      0
     C                   Z-ADD     E             E#INDX
     C                   ENDIF
     C                   MOVEL     I#CND         O#CND
      *
      *  Unwind subroutine stack name
      *
     C     EXMAIN        TAG
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
      *
     C                   RETURN
      *
      *****************************************************************
     C/EJECT
      *****************************************************************
      *                                                               *
      *  SRCOND   : Validate Field 77D: Conditions                    *
      *                                                               *
      *  CALLED BY: Main                                              *
      *                                                               *
      *****************************************************************
     CSR   SRCOND        BEGSR
      *
      *  Set up subroutine stack name
      *
     C                   ADD       1             Q
     C                   MOVEL     'SRCOND'      @STK(Q)
      ***********                                                         CSW097
      ***Check*valid*keywords*on*line*1*                                  CSW097
      ***********                                                         CSW097
     C***********I#TTYP    IFEQ 'FR'                                      CSW097
     C***********E#CPGM    OREQ 'SSI '                                    CSW097
     C***********I#TTYP    ANDEQ'AT'                                      CSW097
     C***********          EXSR SRKYWD                                    CSW097
     C***********E#ERRM    IFNE *BLANKS                                   CSW097
     C***********          GOTO EXCOND                                    CSW097
     C***********          ENDIF                                          CSW097
     C***********          ENDIF                                          CSW097
      *
      *  No embedded blank lines allowed
      *
     C                   EXSR      SRNEBL
     C     E#ERRM        IFNE      *BLANKS
     C                   GOTO      EXCOND
     C                   ENDIF
      *
      *  Check SWIFT Character Set
      *
     C                   EXSR      SRSWCH
     C     E#ERRM        IFNE      *BLANKS
     C                   GOTO      EXCOND
     C                   ENDIF
      *                                                                                       CSW213
     C     I#MTYP        IFEQ      '300'
      *                                                                                       CSW212
     C     CSW212        IFEQ      'Y'
     C     I#TTYP        IFEQ      'AT'
     C     I#TTYP        OREQ      'FX'
     C     I#TTYP        OREQ      'OP'
     C     I#TTYP        OREQ      'FF'
     C     I#TTYP        OREQ      'CL'
      *                                                                                       CSW212
      ** 77D Condition line 1                                                                 CSW212
      *                                                                                       CSW212
     C                   MOVEL     ' '           WVALD             1
     C     '/VALD/'      SCAN      I#CND1        COND1             2 0
     C     '/VALD/'      SCAN      I#CND2        COND2
     C     '/VALD/'      SCAN      I#CND3        COND3
     C     '/VALD/'      SCAN      I#CND4        COND4
     C     '/VALD/'      SCAN      I#CND5        COND5
     C     '/VALD/'      SCAN      I#CND6        COND6
     C                   SELECT
     C     COND1         WHENEQ    0
     C     COND2         ANDEQ     0
     C     COND3         ANDEQ     0
     C     COND4         ANDEQ     0
     C     COND5         ANDEQ     0
     C     COND6         ANDEQ     0
     C                   MOVEL     'N'           WVALD
     C     COND1         WHENGT    1
     C     COND2         ORNE      0
     C     COND3         ORNE      0
     C     COND4         ORNE      0
     C     COND5         ORNE      0
     C     COND6         ORNE      0
      *                                                                                       CSW212
      ** If /VALD/ is input, it must be put on as 6 first characters                          CSW212
      ** on the first line                                                                    CSW212
      *                                                                                       CSW212
     C                   MOVEL     'N'           WVALD
     C     E#CPGM        IFEQ      'ME9960'
     C                   MOVEL     '751'         ERCD(E)
     C                   ELSE
     C                   MOVEL     'X03'         ERCD(E)
     C                   ENDIF
     C                   ADD       1             E
     C                   MOVEL     'Y'           E#ERRM
     C                   MOVEL     'MEC2304'     E#MSGD
     C                   MOVEL     *BLANKS       MEMSDT
     C                   MOVEL     'MEC2304'     MEMSID
     C                   MOVEL     'MEMSG'       MEMSGF
     C                   EXSR      SRSNMS
      *                                                                                       CSW212
     C     COND1         WHENEQ    1
      *                                                                                       CSW212
      ** If /VALD/ is input, it must be followed by a date in YYYYMMDD                        CSW212
      *                                                                                       CSW212
     C                   MOVEL     'Y'           WVALD
     C     I#C1DT        IFNE      *BLANKS
     C                   MOVEL     '0'           WC1DT             8
     C                   MOVEL     I#C1DT        WC1DT
     C                   TESTN                   WC1DT                60
     C     *IN60         IFEQ      *ON
     C                   MOVE      *OFF          *IN98
     C                   MOVE      *OFF          *IN99
      *                                                                                       CSW212
     C                   MOVE      I#C1DY        WDAY
     C                   MOVEL     I#C1DY        WYRS
     C                   MOVE      I#C1DY        WRK4              4
     C                   MOVEL     WRK4          WMTH
     C                   MOVEL     WDATE         ZDATE
     C                   EXSR      ZDATE1
     C                   ENDIF
     C                   ENDIF
      *                                                                                       CSW212
     C     *IN60         IFEQ      *OFF
     C     I#C1DT        ANDNE     *BLANKS
     C     *IN99         OREQ      *ON
     C     I#C1DT        ANDNE     *BLANKS
     C     I#C1DT        OREQ      *BLANKS
     C**********           MOVEL'N'       WVALD                                      CSW212 MD023071
     C     E#CPGM        IFEQ      'ME9960'
     C                   MOVEL     '752'         ERCD(E)
     C                   ELSE
     C                   MOVEL     'X03'         ERCD(E)
     C                   ENDIF
     C                   ADD       1             E
     C                   MOVEL     'Y'           E#ERRM
     C                   MOVEL     'MEC2305'     E#MSGD
     C                   MOVEL     *BLANKS       MEMSDT
     C                   MOVEL     'MEC2305'     MEMSID
     C                   MOVEL     'MEMSG'       MEMSGF
     C                   EXSR      SRSNMS
      *                                                                                       CSW212
      ** No character is allowed after the date                                               CSW212
      *                                                                                       CSW212
     C                   ELSE
     C     I#C1BL        IFNE      *BLANKS
     C**********           MOVEL'N'       WVALD                                      CSW212 MD023071
     C     E#CPGM        IFEQ      'ME9960'
     C                   MOVEL     '753'         ERCD(E)
     C                   ELSE
     C                   MOVEL     'X03'         ERCD(E)
     C                   ENDIF
     C                   ADD       1             E
     C                   MOVEL     'Y'           E#ERRM
     C                   MOVEL     'MEC2306'     E#MSGD
     C                   MOVEL     *BLANKS       MEMSDT
     C                   MOVEL     'MEC2306'     MEMSID
     C                   MOVEL     'MEMSG'       MEMSGF
     C                   EXSR      SRSNMS
     C                   ENDIF
     C                   ENDIF
     C**********           ENDIF                                                     CSW212 MD023071
     C                   ENDSL
      *                                                                                       CSW212
      ** 77D Condition Line 2                                                                 CSW212
      *                                                                                       CSW212
     C     '/SETC/'      SCAN      I#CND2        COND2             2 0
     C     '/SETC/'      SCAN      I#CND1        COND1
     C     '/SETC/'      SCAN      I#CND3        COND3
     C     '/SETC/'      SCAN      I#CND4        COND4
     C     '/SETC/'      SCAN      I#CND5        COND5
     C     '/SETC/'      SCAN      I#CND6        COND6
     C                   SELECT
     C     COND2         WHENEQ    0
     C     COND3         ANDEQ     0
     C     COND4         ANDEQ     0
     C     COND5         ANDEQ     0
     C     COND6         ANDEQ     0
     C     WVALD         ANDEQ     'Y'
     C     COND2         OREQ      1
     C     WVALD         ANDNE     'Y'
      *                                                                                       CSW212
      ** If /VALD/ is input on the first line, /SETC/ must be present on                      CSW212
      ** on the second line and conversely                                                    CSW212
      *                                                                                       CSW212
     C     E#CPGM        IFEQ      'ME9960'
     C                   MOVEL     '754'         ERCD(E)
     C                   ELSE
     C                   MOVEL     'X03'         ERCD(E)
     C                   ENDIF
     C                   ADD       1             E
     C                   MOVEL     'Y'           E#ERRM
     C                   MOVEL     'MEC2307'     E#MSGD
     C                   MOVEL     *BLANKS       MEMSDT
     C                   MOVEL     'MEC2307'     MEMSID
     C                   MOVEL     'MEMSG'       MEMSGF
     C                   EXSR      SRSNMS
      *                                                                                       CSW212
     C     COND2         WHENEQ    1
     C     WVALD         ANDEQ     'Y'
      *                                                                                       CSW212
      ** /SETC/ must be followed by an ISO Currency code                                      CSW212
      *                                                                                       CSW212
     C*****I#C2IS        SETLL     SDISOCL0                                                 MD058085
     C     I#C2IS        IFNE      *BLANKS
     C*****I#C2IS        CHAIN     SDISOCL0                           81                    MD058085
     C/EXEC SQL                                                                             MD058085
     C+ SELECT *                                                                            MD058085
     C+ into :SDISOC                                                                        MD058085
     C+ from SDISOJW0                                                                       MD058085
     C+ where GICYCD = :I#C2IS                                                              MD058085
     C/END-EXEC                                                                             MD058085
     C                   SETOFF                                       81                    MD058085
     C                   If        SQLCODE <> 0                                             MD058085
     C                   SETON                                        81                    MD058085
     C                   ENDIF                                                              MD058085
     C                   ENDIF
      *                                                                                       CSW212
     C     *IN81         IFEQ      *ON
     C     I#C2IS        SETLL     SDCURRL1
     C     I#C2IS        CHAIN     SDCURRL1                           81
     C                   ENDIF
      *                                                                                       CSW212
     C     *IN81         IFEQ      *ON
     C     I#C2IS        ANDNE     'XXX'
     C     I#C2IS        OREQ      *BLANKS
     C     E#CPGM        IFEQ      'ME9960'
     C                   MOVEL     '755'         ERCD(E)
     C                   ELSE
     C                   MOVEL     'X03'         ERCD(E)
     C                   ENDIF
     C                   ADD       1             E
     C                   MOVEL     'Y'           E#ERRM
     C                   MOVEL     'MEC2308'     E#MSGD
     C                   MOVEL     *BLANKS       MEMSDT
     C                   MOVEL     'MEC2308'     MEMSID
     C                   MOVEL     'MEMSG'       MEMSGF
     C                   EXSR      SRSNMS
     C                   ELSE
      *                                                                                       CSW212
      ** No character is allowed after the currency.                                          CSW212
      *                                                                                       CSW212
     C     I#C2BL        IFNE      *BLANKS
     C     E#CPGM        IFEQ      'ME9960'
     C                   MOVEL     '756'         ERCD(E)
     C                   ELSE
     C                   MOVEL     'X03'         ERCD(E)
     C                   ENDIF
     C                   ADD       1             E
     C                   MOVEL     'Y'           E#ERRM
     C                   MOVEL     'MEC2309'     E#MSGD
     C                   MOVEL     *BLANKS       MEMSDT
     C                   MOVEL     'MEC2309'     MEMSID
     C                   MOVEL     'MEMSG'       MEMSGF
     C                   EXSR      SRSNMS
     C                   ENDIF
     C                   ENDIF
     C     COND2         WHENGT    1
     C     COND1         ORNE      0
     C     COND3         ORNE      0
     C     COND4         ORNE      0
     C     COND5         ORNE      0
     C     COND6         ORNE      0
      *                                                                                       CSW212
      ** If /SECT/ is input, it must be put on as 6 first characters                          CSW212
      ** on the second line                                                                   CSW212
      *                                                                                       CSW212
     C     E#CPGM        IFEQ      'ME9960'
     C                   MOVEL     '757'         ERCD(E)
     C                   ELSE
     C                   MOVEL     'X03'         ERCD(E)
     C                   ENDIF
     C                   ADD       1             E
     C                   MOVEL     'Y'           E#ERRM
     C                   MOVEL     'MEC2310'     E#MSGD
     C                   MOVEL     *BLANKS       MEMSDT
     C                   MOVEL     'MEC2310'     MEMSID
     C                   MOVEL     'MEMSG'       MEMSGF
     C                   EXSR      SRSNMS
      *                                                                                       CSW212
     C                   ENDSL
     C                   ENDIF
     C                   ENDIF
      *                                                                                       CSW213
     C     CSW213        IFEQ      'Y'
     C     I#TTYP        IFEQ      'AT'
     C     I#TTYP        OREQ      'FX'
     C     I#TTYP        OREQ      'OP'
     C     I#TTYP        OREQ      'FF'
     C     I#TTYP        OREQ      'CL'
      *                                                                                       CSW213
      ** Validate line 3 for /SRCE/                                                           CSW213
      *                                                                                       CSW213
     C     '/SRCE/'      SCAN      I#CND1        COND1
     C     '/SRCE/'      SCAN      I#CND2        COND2
     C     '/SRCE/'      SCAN      I#CND3        COND3             2 0
     C     '/SRCE/'      SCAN      I#CND4        COND4             2 0
     C     '/SRCE/'      SCAN      I#CND5        COND5             2 0
     C     '/SRCE/'      SCAN      I#CND6        COND6             2 0
      *                                                                                       CSW213
     C     COND1         IFNE      0
     C     COND2         ORNE      0
     C     COND3         ORGT      1
     C     COND4         ORNE      0
     C     COND5         ORNE      0
     C     COND6         ORNE      0
      *                                                                                       CSW213
     C     E#CPGM        IFEQ      'ME9960'
     C*******              MOVEL'431'     ERCD,E                                     CSW213 MD022945
     C                   MOVEL     '143'         ERCD(E)
     C                   ELSE
     C                   MOVEL     'X03'         ERCD(E)
     C                   ENDIF
     C                   ADD       1             E
     C                   MOVEL     'Y'           E#ERRM
     C                   MOVEL     *BLANKS       MEMSDT
     C                   MOVEL     'MEC0121'     MEMSID
     C                   MOVEL     'MEMSG'       MEMSGF
     C                   EXSR      SRSNMS
      *                                                                                       CSW213
     C                   ELSE
      *                                                                                       CSW213
     C     COND3         IFEQ      1
      *                                                                                       CSW213
      ** Validate line 1 for /VALD/ and line 2 for /SETC/                                     CSW213
      *                                                                                       CSW213
     C     '/VALD/'      SCAN      I#CND1        COND1
     C     '/SETC/'      SCAN      I#CND2        COND2
     C     COND1         IFNE      1
     C     COND2         ORNE      1
      *                                                                                       CSW213
     C     E#CPGM        IFEQ      'ME9960'
     C*********            MOVEL'432'     ERCD,E                                     CSW213 MD022945
     C                   MOVEL     '144'         ERCD(E)
     C                   ELSE
     C                   MOVEL     'X03'         ERCD(E)
     C                   ENDIF
     C                   ADD       1             E
     C                   MOVEL     'Y'           E#ERRM
     C                   MOVEL     *BLANKS       MEMSDT
     C                   MOVEL     'MEC0122'     MEMSID
     C                   MOVEL     'MEMSG'       MEMSGF
     C                   EXSR      SRSNMS
      *                                                                                       CSW213
     C                   ENDIF
      *                                                                                       CSW213
     C                   ENDIF
      *                                                                                       CSW213
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
      *
      *  Unwind subroutine stack name
      *
     C     EXCOND        TAG
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
      *
     CSR                 ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      *                                                               *
      *  SROTHR   : Validate Other Details                            *
      *                                                               *
      *  CALLED BY: Main processing                                   *
      *                                                               *
      *****************************************************************
     CSR   SROTHR        BEGSR
      *
      *  Set up subroutine stack name
      *
     C                   ADD       1             Q
     C                   MOVEL     'SROTHR'      @STK(Q)
      *
      *  Unwind subroutine stack name
      *
     C     EXOTHR        TAG
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
      *
     CSR                 ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      *                                                               *
      *  SRNEBL   : Check for embedded blanks                         *
      *                                                               *
      *  CALLED BY: SRCOND Validate Field :77D:                       *
      *                                                               *
      *****************************************************************
     CSR   SRNEBL        BEGSR
      *
      *  Set up subroutine stack name
      *
     C                   ADD       1             Q                 5 0
     C                   MOVEL     'SRNEBL'      @STK(Q)
      *
      *  No blank lines allowed between lines
      *
     C     I#CND         IFNE      *BLANKS
      * Line 2 input line 1 blank
     C     I#CND1        IFEQ      *BLANKS
     C     I#CND2        ANDNE     *BLANKS
      * Line 3 input line 2 blank
     C     I#CND2        OREQ      *BLANKS
     C     I#CND3        ANDNE     *BLANKS
      * Line 4 input line 3 blank
     C     I#CND3        OREQ      *BLANKS
     C     I#CND4        ANDNE     *BLANKS
      * Line 5 input line 4 blank
     C     I#CND4        OREQ      *BLANKS
     C     I#CND5        ANDNE     *BLANKS
      * Line 6 input line 5 blank
     C     I#CND5        OREQ      *BLANKS
     C     I#CND6        ANDNE     *BLANKS
     C                   MOVEL     'X03'         ERCD(E)
     C                   ADD       1             E
      *
     C                   MOVEL     'Y'           E#ERRM
     C                   MOVEL     *BLANKS       MEMSDT
     C                   MOVEL     'MEC0105'     MEMSID
     C                   MOVEL     'MEMSG'       MEMSGF
     C                   EXSR      SRSNMS
      *
     C                   ENDIF
      *
     C                   ENDIF
      *
      *  Unwind subroutine stack name
      *
     C     EXNEBL        TAG
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
      *
     CSR                 ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************   CSW097
      *****************************************************************   CSW097
      ***SRKYWD***:*Validate*Keywords**********************************   CSW097
      *****************************************************************   CSW097
      ***CALLED*BY:*SRCOND*Validate*Field*:77D*************************   CSW097
      *****************************************************************   CSW097
      *****************************************************************   CSW097
     C*SR*********SRKYWD    BEGSR                                         CSW097
      ***********                                                         CSW097
      ***Set*up*subroutine*stack*name*                                    CSW097
      ***********                                                         CSW097
     C***********          ADD  1         Q       50                      CSW097
     C***********          MOVEL'SRKYWD'  @STK,Q                          CSW097
      ***********                                                         CSW097
      ***Validate*first*line:*                                            CSW097
      ***********                                                         CSW097
     C***********          Z-ADD1         #S      50                      CSW097
     C***********          Z-ADD1         #X      50                      CSW097
     C***********          MOVE *BLANKS   WERR    1                       CSW097
      ***********                                                         CSW097
      ***If*not*equal*to*blanks*validate*                                 CSW097
      ***********                                                         CSW097
     C***********I#CND1    IFNE *BLANKS                                   CSW097
      ***********                                                         CSW097
      **First*position*must*be*a*'/'*                                     CSW097
      ***********                                                         CSW097
     C***********1         SUBSTI#CND1:1  ##001   1                       CSW097
      ***********                                                         CSW097
     C***********##001     IFNE '/'                                       CSW097
     C***********          MOVEL'Y'       WERR                            CSW097
     C***********          ENDIF                                          CSW097
      ***********                                                         CSW097
8888  ****Look*up*for*next*'/'*8                                          CSW097
      ***********                                                         CSW097
     C***********WERR      IFNE 'Y'                                       CSW097
      ***********                                                         CSW097
     C***********'/'       SCAN I#CND1:2  #R      30     90               CSW097
      ***********                                                         CSW097
     C************IN90     IFEQ *ON                                       CSW097
     C***********#R        SUBSTI#CND1:1  ##KYWD 35 P                     CSW097
      ***********                                                         CSW097
      ***Determine*if*codeword*found*in*array:*                           CSW097
      ***********                                                         CSW097
     C***********          Z-ADD1         #Y      50                      CSW097
     C***********##KYWD    LOKUPCDEW,#Y                  90               CSW097
     C************IN90     IFEQ *OFF                                      CSW097
     C***********          MOVE 'Y'       WERR                            CSW097
     C***********          ENDIF                                          CSW097
      ***********                                                         CSW097
     C***********          ELSE                                           CSW097
     C***********          MOVEL'Y'       WERR                            CSW097
     C***********          ENDIF                                          CSW097
      ***********                                                         CSW097
     C***********          ENDIF                                          CSW097
      ***********                                                         CSW097
      **Codeword*invalid*                                                 CSW097
      ***********                                                         CSW097
     C***********WERR      IFEQ 'Y'                                       CSW097
     C***********          MOVEL'X04'     ERCD,E                          CSW097
     C***********          ADD  1         E                               CSW097
      ***********                                                         CSW097
     C***********          MOVEL'Y'       E#ERRM                          CSW097
     C***********          MOVEL*BLANKS   MEMSDT    P                     CSW097
     C***********MEMSDT    CAT  ##KYWD:0  MEMSDT                          CSW097
     C***********          MOVEL'MEC0200' MEMSID                          CSW097
     C***********          MOVEL'MEMSG'   MEMSGF                          CSW097
     C***********          EXSR SRSNMS                                    CSW097
     C***********          GOTO EXKYWD                                    CSW097
      ***********                                                         CSW097
     C***********          ENDIF                                          CSW097
      ***********                                                         CSW097
     C***********          ENDIF                                          CSW097
      ***Unwind*subroutine*stack*name*                                    CSW097
      ***********                                                         CSW097
     C***********EXKYWD    TAG                                            CSW097
     C***********          MOVEA*BLANKS   @STK,Q                          CSW097
     C***********          SUB  1         Q                               CSW097
      ***********                                                         CSW097
     C*SR********           ENDSR                                         CSW097
      *****************************************************************
     C/EJECT
      *****************************************************************
      *                                                               *
      *  SRSWCH   : Validate SWIFT EXtended Characters                *
      *                                                               *
      *  CALLED BY: SRCOND Validate Field :77D:                       *
      *                                                               *
      *****************************************************************
     CSR   SRSWCH        BEGSR
      *
      *  Set up subroutine stack name
      *
     C                   ADD       1             Q                 5 0
     C                   MOVEL     'SRSWCH'      @STK(Q)
      *
     C     ISOEX         CHECK     I#CND         V#                5 0    90
      *
      * If invalid then get character and format number
      *
     C     *IN90         IFEQ      *ON
     C     1             SUBST     I#CND:V#      ##001             1
     C     V#            DIV       35            V#
     C                   MVR                     R#                5 0
      *
     C                   MOVE      'X03'         ERCD(E)
     C                   ADD       1             E
      *
     C                   MOVEL     'Y'           E#ERRM
     C     R#            IFNE      0
     C                   ADD       1             V#
     C                   ELSE
     C                   Z-ADD     35            R#
     C                   ENDIF
     C                   MOVEL(P)  V#            ##005A            5
     C                   MOVEL     R#            MEMSDT
     C     MEMSDT        CAT(P)    ##005A:0      MEMSDT
     C     MEMSDT        CAT(P)    ##001:0       MEMSDT
     C                   MOVEL     'MEC0118'     MEMSID
     C                   MOVEL     'MEMSG'       MEMSGF
     C                   EXSR      SRSNMS
     C                   ENDIF
      *
      *  Unwind subroutine stack name
      *
     C     EXSWCH        TAG
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
      *
     CSR                 ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      *                                                               *
      *  SRSNMS   : Send Message to Calling program                   *
      *                                                               *
      *  CALLED BY: *Any Error                                        *
      *                                                               *
      *****************************************************************
     CSR   SRSNMS        BEGSR
      *
      *  Set up subroutine stack name
      *
     C                   ADD       1             Q                 5 0
     C                   MOVEL     'SRSNMS'      @STK(Q)
      *
      * Obtain leading text for field
      *
     C     E#MSGD        IFNE      *BLANKS
     C                   CALL      'MEC1150'                            9090
     C                   PARM      E#MSGD        #MSGID
     C                   PARM      E#MSGF        #MSGF
     C                   PARM                    #MSDTA
     C                   PARM      *BLANKS       #MSTX1
     C                   PARM      *BLANKS       #MSTX2
      *
     C     MEMSDT        CAT       #MSTX1:0      MEMSDT
     C                   END
      *
      * Send message
      *
     C                   MOVEL     E#CPGM        MEPGMQ
     C                   EXSR      MESNMS
      *
      *  Unwind subroutine stack name
      *
     C     EXSNMS        TAG
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
      *
     CSR                 ENDSR
      *****************************************************************
     C/EJECT
      *  File and Program Error Processing
     C*COPY*MECPYSRC,SRERRC                                                                 MD058085
     C/COPY MECPYSRC,SRERRCLE                                                               MD058085
      *  Standard send-program-message routine /COPY
     C*COPY*MECPYSRC,SMESNMSC                                                               MD058085
     C/COPY MECPYSRC,SMESNMSCLE                                                             MD058085
     C*COPY*ZSRSRC,ZDATE1Z2                                                          CSW212 MD058085
     C/COPY ZSRSRC,ZDATE1Z2LE                                                               MD058085
      *
      ** This compile time array has been removed as                      CSW097
      ** codeword validation is no longer required.                       CSW097
      ** (originally it's positioned after the copyright array)           CSW097
      *                                                                   CSW097
      ***********CDEW*-*Condition*Codewords*                              CSW097
      ***********/FRABBA/                                                 CSW097
      ***********/VARYFRAB/                                               CSW097
      ***********/MASTER/                                                 CSW097
      ***********/VMASTER/                                                CSW097
      ***********/OTHER/                                                  CSW097
      ***********/*spare/*spare/*spare/*spare/*spare                      CSW097
      ***********/*spare/*spare/*spare/*spare/*spare                      CSW097
      ***********/*spare/*spare/*spare/*spare/*spare                      CSW097
      ***********/*spare/*spare/*spare/*spare/*spare                      CSW097
      ***********/*spare/*spare/*spare/*spare/*spare                      CSW097
      ***********/*spare/*spare/*spare/*spare/*spare                      CSW097
      ***********/*spare/*spare/*spare/*spare/*spare                      CSW097
      ***********/*spare/*spare/*spare/*spare/*spare                      CSW097
      ***********/*spare/*spare/*spare/*spare/*spare                      CSW097
      ***********/*spare/*spare/*spare/*spare/*spare                      CSW097
**  CPY@
(c) Finastra International Limited 2001
**   ZYDY - YEARS IN DAYS CUMULATIVE, FOUR YEAR SPAN                                          CSW212
0366073110961461                                                                              CSW212
**   ZMDY - MONTHS IN DAYS CUMULATIVE THROUGH YEAR                                            CSW212
000031059090120151181212243273304334365                                                       CSW212
