     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas MA Control Data Maintenance')
      *****************************************************************
      *                                                               *
      *  Midas - Microfiche Module                                    *
      *                                                               *
      *  MA000010 - Microfiche Control Data Maintenance Run           *
      *                                                               *
      *  Function:  This program copy/duplicate spool files for       *
      *              microfiche bureau                                *
      *                                                               *
      *  Called By: MAC000010                                         *
      *                                                               *
      *  (c) Finastra International Limited 2002                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. CFC002  *CREATE    Date 29Apr02               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CFC002 - Multiple Output Queues In Std Output Instructions   *
      *                                                               *
      *****************************************************************
      /EJECT
      *                                                               *
      * ID F  C  H  L    FUNCTION OF INDICATORS                       *
      *                                                               *
      *       30         Screen Error on Action                       *
      *       83         SFLEND                                       *
      *       81         SFLDSP                                       *
      *       85         SFLCLR                                       *
      *       97         SFLNXTCHG                                    *
      *       99         READC END-OF-FILE                            *
      *       U7         DATA BASE ERROR                              *
      *       U8         DATA BASE ERROR                              *
      *                                                               *
      *****************************************************************
     FMA0340M#  CF   E             WORKSTN INFSR(*PSSR)
     FMAFOQPPD  UF A E             DISK    INFSR(*PSSR)
     F                                     INFDS(INFDS)
     F                                     COMMIT
      /EJECT
      *****************************************************************
      *                  ARRAYS                                       *
      *****************************************************************
      * Arrays for validating and converting date from Midas format
     D AU1             S              1    DIM(3) CTDATA PERRCD(3)              Screen Action val
     D AU2             S              7    DIM(3) ALT(AU1)
     D WAR             S             10    DIM(10)                              WORK ARRAY
     D/EJECT
      *****************************************************************
      *                  DATA STRUCTURES                              *
      *****************************************************************
      *
     D INFDS           DS
      *
      ** Data Structure For File Status To Check For 01021 'Rec exists'
      *
     D  STATUS           *STATUS
     D                UDS
     D  DBFILE               134    141
     D  DBKEY                142    170
     D  DBPROG               171    180
      *
      **  Program Status Data Structure for  COMIT text information
      *
     D                SDS
     D  @WSID                244    253
     D  @USER                254    263
      *
      ** Initialise Message file parm to msgf
      *
     D PMSGF           DS
     D  DSMSG                  1     10    INZ('GBFCUSRMSG')
      *
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
     D DSFDY         E DS                  EXTNAME(DSFDY)
     D SAOQME          DS
     D  SOQ                    1    100
     D                                     DIM(10)                              Screen Action val
     D  OUTQ01                 1     10
     D  OUTQ02                11     20
     D  OUTQ03                21     30
     D  OUTQ04                31     40
     D  OUTQ05                41     50
     D  OUTQ06                51     60
     D  OUTQ07                61     70
     D  OUTQ08                71     80
     D  OUTQ09                81     90
     D  OUTQ10                91    100
     D                 DS
     D  FOQ                    1    100
     D                                     DIM(10)
     D  MFOQ01                 1     10
     D  MFOQ02                11     20
     D  MFOQ03                21     30
     D  MFOQ04                31     40
     D  MFOQ05                41     50
     D  MFOQ06                51     60
     D  MFOQ07                61     70
     D  MFOQ08                71     80
     D  MFOQ09                81     90
     D  MFOQ10                91    100
      /EJECT
      *****************************************************************
      *
      *                M A I N  P R O C E S S I N G
      *
      *****************************************************************
      *
      ** Initialise data
      *
     C                   EXSR      SRINIT
      *
      ** Perform Controlling Subroutine
      *
     C                   EXSR      SRMAIN
      *
     C                   EXSR      SRTERM                                       End of Program
      /EJECT
      *****************************************************************
      *                                                               *
      * SRMAIN - Controlling subroutine.  Display prompt screen       *
      *          and data.                                            *
      *                                                               *
      * Called by: Main pgm                                           *
      *                                                               *
      * Calls: SRSCN1 - prompt screen                                 *
      *        SRSCN2 - data screen                                   *
      *        SRUPDT - do file updates                               *
      *                                                               *
      *****************************************************************
     C     SRMAIN        BEGSR
      *
     C     *INKC         DOWEQ     '0'                                          Until F3
     C                   MOVE      '1'           *IN70
     C                   MOVE      '1'           *IN71
      *
      ** Display prompt screen
      *
     C                   EXSR      SRSCN1
      *
      ** Process valid requested action and display data
      *
     C                   EXSR      SRSCN2
      *
     C     SAACTN        IFNE      'E'
     C     *IN12         ANDNE     '1'
     C     *IN99         ANDEQ     '0'
     C                   EXSR      SRUPDT
     C                   ENDIF
      *
     C                   ENDDO
     C                   ENDSR
      /EJECT
      *****************************************************************
      *                                                               *
      * SRSCN1 - Screen 1. Prompt for action type and validate        *
      *                                                               *
      * Called by: SRMAIN                                             *
      *                                                               *
      * Calls: ZA0250, ZA0340                                         *
      *                                                               *
      *****************************************************************
     C     SRSCN1        BEGSR
      *
     C                   MOVE      *BLANKS       SAFUNC                         Function Narrtv
     C                   MOVE      '0'           *IN74                          No PC LH crn
     C     SAACTN        IFNE      ' '                                          Previous S2s
     C                   WRITE     MA0340X2                                     Clear scn 2
     C                   ENDIF
     C                   MOVE      *BLANKS       SAACTN                         Action
      *
      ** Display screen until no more errors
      *
     C     *IN30         DOUEQ     '0'                                          Until No error
     C                   WRITE     MA0340C0                                     Subfile msgs
     C                   EXFMT     MA0340X0                                     Prompt record
      *
     C     *INKC         IFEQ      '1'                                          F3 pressed
     C                   EXSR      SRTERM                                       Exit Program
     C                   ENDIF
     C                   CALL      'ZA0250'                                     Clear sfl msgq
     C                   MOVE      '1'           *IN10                          SFLEND
     C                   MOVE      '0'           *IN30                          Setof 30
      *
      ** Validate Action code
      *
     C                   Z-ADD     1             X                              Index
     C     SAACTN        LOOKUP    AU1(X)                                 93     A,E, or I?
     C     *IN93         IFEQ      '0'                                          Not A,E, or I
     C                   MOVE      '1'           *IN30                          Error Indicator
      *
      ** Invalid Action  Code
      *
     C                   CALL      'ZA0340'                                     Send message
     C                   PARM                    PMSGF                           to msg sfil
     C                   PARM      'RCF1094'     PMSGID                          to msg sfil
     C                   MOVE      *BLANKS       SAFUNC                         No action
     C                   ELSE
     C                   MOVEA     AU2(X)        SAFUNC                         Action narratve
     C                   ENDIF
      *
      ** If not an error, check further
      *
     C     *IN30         IFEQ      '0'
     C     1             CHAIN     MAFOQPD0                           41
      *
      ** If record does not exists, send error message
      *
     C     SAACTN        IFEQ      'A'                                          Amend
     C     SAACTN        OREQ      'E'                                          Enquiry
     C     *IN41         IFEQ      '1'
     C                   MOVE      '1'           *IN30
     C                   CALL      'ZA0340'                                     Send message
     C                   PARM                    PMSGF                           to msg sfil
     C                   PARM      'RCF1095'     PMSGID                          to msg sfil
     C                   MOVE      *BLANKS       SAFUNC                         No action
     C                   ENDIF
      *
      ** Else if record already exists, send error message
      *
     C                   ELSE                                                    Insert
     C     *IN41         IFEQ      '0'
     C                   MOVE      '1'           *IN30
     C                   CALL      'ZA0340'                                     Send message
     C                   PARM                    PMSGF                           to msg sfil
     C                   PARM      'RCF1096'     PMSGID                          to msg sfil
     C                   MOVE      *BLANKS       SAFUNC                         No action
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
      *
     C                   ENDDO                                                  *IN99  DOWEQ
     C                   ENDSR
      /EJECT
      *****************************************************************
      *                                                               *
      * SRSCN2 - Screen 2. Prepare data and display screen            *
      *                                                               *
      * Called by: SRMAIN                                             *
      *                                                               *
      * Calls: SRTERM, SRVALD, ZA0250                                 *
      *                                                               *
      *****************************************************************
     C     SRSCN2        BEGSR
      *
      ** Set on display conditioners for Action Type
      *
     C                   MOVE      '1'           *IN70                          Protect Scn1
     C                   MOVE      '0'           *IN72                          Unhilite cmd
     C                   Z-ADD     1             ONCE                           Warning msg
      *
      ** I=1 A=2 E=3.  See Compile time array at end of prog
      *
     C     X             IFLE      2                                            Insert/Amend
     C                   MOVE      '1'           *IN73                          PC on Microoutq
     C                   ELSE                                                   Enquiry
     C                   MOVE      '1'           *IN74                          PC left hand sc
     C                   MOVE      '1'           *IN71                          Protect screen
     C                   ENDIF
      *
      ** Format screen with data
      *
     C     SAACTN        IFEQ      'I'                                          Insert
     C                   MOVE      *BLANKS       SAOQME                         MFiche Oput Queues
     C                   MOVE      *BLANKS       SAMFOF                         MFiche Flag Indic
     C                   ELSE
     C                   MOVE      MFMCRO        SAMFOF
     C                   MOVE      MFOQ01        OUTQ01
     C                   MOVE      MFOQ02        OUTQ02
     C                   MOVE      MFOQ03        OUTQ03
     C                   MOVE      MFOQ04        OUTQ04
     C                   MOVE      MFOQ05        OUTQ05
     C                   MOVE      MFOQ06        OUTQ06
     C                   MOVE      MFOQ07        OUTQ07
     C                   MOVE      MFOQ08        OUTQ08
     C                   MOVE      MFOQ09        OUTQ09
     C                   MOVE      MFOQ10        OUTQ10
     C                   ENDIF
      *
      ** Write screen
      *
     C     *IN99         DOUEQ     '0'
     C     *IN12         OREQ      '1'                                          F12 pressed
     C                   WRITE     MA0340C0                                     Subfile msgs
     C     SAACTN        IFEQ      'A'                                          Amend
     C                   MOVE      '1'           *IN72                          Amend Screen
     C                   ENDIF
     C                   EXFMT     MA0340X1
     C                   MOVE      '0'           *IN99
     C                   MOVEA     '000000'      *IN(50)                        Setof 50-55
     C                   MOVEA     '0000'        *IN(56)                        Setof 56-59
      *
     C     *INKC         IFEQ      '1'                                          F3 pressed
     C                   EXSR      SRTERM                                       Exit Program
     C                   ENDIF
      *
     C                   CALL      'ZA0250'
     C                   MOVE      '1'           *IN10                          SFLEND
     C                   MOVE      '0'           *IN30                          Setof 30
     C                   MOVE      '0'           *IN73
      *
      ** If mode is Amend or Insert, then validate
      *
     C     *IN71         IFEQ      '1'                                          Enquiry
     C                   MOVE      '0'           *IN99                          Go to Scr 1
     C                   ELSE                                                   Amend/Enquiry
     C     SAACTN        IFNE      'E'                                          Amend
     C                   EXSR      SRVALD                                       Validate
     C                   ENDIF
     C                   ENDIF
     C                   ENDDO
      *
     C                   CALL      'ZA0250'                                     Clear sfl msgq
     C                   ENDSR
      /EJECT
      *****************************************************************
      *                                                               *
      * SRVALD - Validate entries for insert and amend mode           *
      *                                                               *
      * Called by: SRSCN2                                             *
      *                                                               *
      * Calls: FCC0520, ZA0340                                        *
      *                                                               *
      *****************************************************************
     C     SRVALD        BEGSR
      *
     C                   Z-ADD     1             X
     C                   Z-ADD     49            Z                 2 0
     C                   DO        10            X
      *
      ** CASE:     DTL.Output Queue Name is Not ?
      *
     C     SOQ(X)        IFNE      *BLANK                                       *IF
     C                   MOVEL     SOQ(X)        WUAOTQ           10            Output Queue
      *
      ** CASE:     WRK.Output Queue is not blank
      *
     C     WUAOTQ        IFNE      *BLANK                                       *IF
     C                   MOVEL     *BLANK        WURTN             7            *Return code
      *
      ** Check Output Queue Exists - standard functions  *
      *
     C                   CALL      'FCC0520'                            90      Check Output Q
     C                   PARM      WUAOTQ        PQ0001           10            Output Queue
     C     WURTN         PARM      WURTN         PQ0002            7            *Return code
      *
     C     *IN90         IFEQ      '1'
      *
      ** Call to program ended in error.
      *
     C                   MOVEL     'Y2U0021'     WURTN             7
     C                   ENDIF
      *
      ** CASE:     WRK.*Return code is *Record does not exist
      *
     C     WURTN         IFEQ      'Y2U0005'                                    *IF
     C                   CALL      'ZA0340'                                     Send message
     C                   PARM                    PMSGF                          To msg sfil
     C                   PARM      'RCF0022'     PMSGID                         To msg sfil
     C                   MOVE      '1'           *IN99
     C     X             ADD       Z             Q                 2 0
     C                   MOVE      '1'           *IN(Q)
     C                   ENDIF                                                  End of WURTN
     C                   ENDIF                                                  End of WUAOTQ
     C                   ENDIF                                                  of SOQ,X
     C                   ENDDO
      *
      ** Check that outqs are not repeated if they are not blank
      *
     C     SAOQME        IFNE      *BLANKS
     C     *IN99         ANDEQ     '0'
      *
     C                   Z-ADD     1             X                 2 0
     C                   Z-ADD     0             Y                 2 0
     C                   Z-ADD     49            Z                 2 0
     C                   MOVEA     *ALL' '       WAR(1)
     C                   MOVEA     '000000'      *IN(50)                        Setof 50-55
     C                   MOVEA     '0000'        *IN(56)                        Setof 56-59
      *
     C                   DO        10            X
     C     SOQ(X)        IFNE      *BLANKS
     C     SOQ(X)        LOOKUP    WAR(1)                                 66
      *
      ** Found repeat
      *
     C     *IN66         IFEQ      '1'
     C     X             ADD       Z             Q
     C                   MOVE      '1'           *IN(Q)
     C                   MOVE      '1'           *IN99
      *
      ** Send message 'OUT Q REPEATED'
      *
     C                   CALL      'ZA0340'                                     SEND MESSAGE
     C                   PARM                    PMSGF                          TO MSG SFIL
     C                   PARM      'RCF1093'     PMSGID                         Message id.
     C                   ELSE                                                     NOT FOUND
     C                   ADD       1             Y                                STORE IT
     C                   MOVEL     SOQ(X)        WAR(Y)
     C                   ENDIF                                                    OF *IN66
     C                   ENDIF                                                    OF SOQ,X
      *
     C                   ENDDO                                                    OF DO 10X
      *
     C                   ENDIF                                                    OF SAOQME
      *
     C     SAMFOF        IFNE      'Y'
     C     SAMFOF        ANDNE     'N'
     C                   MOVE      '1'           *IN30
     C                   MOVE      '1'           *IN99
     C                   CALL      'ZA0340'                                     Send message
     C                   PARM                    PMSGF                           to msg sfil
     C                   PARM      'RCF1031'     PMSGID                          to msg sfil
     C                   ENDIF
      *
     C                   ENDSR
      /EJECT
      *****************************************************************
      *                                                               *
      * SRUPDT - Update file during insert and amend mode             *
      *                                                               *
      * Called by: SRMAIN                                             *
      *                                                               *
      * Calls: NONE                                                   *
      *                                                               *
      *****************************************************************
     C     SRUPDT        BEGSR
      *
     C                   Z-ADD     1             Y                 2 0
     C                   Z-ADD     1             X                 2 0
     C                   MOVE      SAMFOF        MFMCRO
     C                   MOVE      SAACTN        MFTYLC
     C                   MOVEA     *ALL' '       FOQ(1)
      *
     C                   DO        10            X
     C     SOQ(X)        IFNE      *BLANK
     C                   MOVE      SOQ(X)        FOQ(Y)
     C                   ADD       1             Y
     C                   ENDIF
     C                   ENDDO
      *
     C     SAACTN        IFEQ      'I'                                          Insert
     C   41              WRITE     MAFOQPD0                                     Write record
     C                   ELSE                                                   Amend
     C  N41              UPDATE    MAFOQPD0                                     Amend record
     C                   ENDIF                                                  SAACTN EQ I
      *
     C                   COMMIT
     C                   ENDSR
      /EJECT
      *****************************************************************
      *                                                               *
      * SRINIT - Initial Subroutine.                                  *
      *                                                               *
      * Called by: Main Program                                       *
      *                                                               *
      * Calls: AOBANKR0                                               *
      *                                                               *
      *****************************************************************
     C     SRINIT        BEGSR
      *
     C                   MOVEL     '*'           PGMQ                           Subfile message
     C                   MOVE      *BLANKS       PMSGID           10            Message ID
     C                   Z-ADD     1             ONCE              1 0          Do warning once
     C                   MOVE      '0'           *IN98                          ZDATE2 DDMMYY
     C                   MOVE      '1'           *IN10                          SFLEND
      *
      ** Retrieve Midas Run Date from SDBANKPD
      *
     C                   CALL      'AOBANKR0'
     C                   PARM      '*DBERR  '    PRTCD             7
     C                   PARM      '*FIRST  '    POPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
      *
     C     PRTCD         IFEQ      *BLANKS
     C                   MOVE      BJMRDT        SADATE
     C                   MOVE      BJRDNB        MFLCD
     C                   MOVE      @WSID         SWSID
     C                   MOVE      @USER         SUSER
     C                   ENDIF
      *
     C                   ENDSR
      /EJECT
      *****************************************************************
      *                                                               *
      * SRTERM - Termination Subroutine.  Clean up and exit pgm.      *
      *                                                               *
      * Called by:                                                    *
      *                                                               *
      * Calls: NONE                                                   *
      *                                                               *
     *****************************************************************
     C     SRTERM        BEGSR
      *
     C                   MOVE      '1'           *INLR                          LAST RECORD
     C                   RETURN
      *
     C                   ENDSR
      /EJECT
      *****************************************************************
      *                                                               *
      * *PSSR - Program exception error routine                       *
      *         Called automatically if a program error occurs,       *
      *         or directly by the program code using EXSR.           *
      *         This subroutine DUMPs the program just once.          *
      *                                                               *
      * Called by:                                                    *
      *                                                               *
      * Calls: NONE                                                   *
      *                                                               *
      ****************************************************************
     C     *PSSR         BEGSR
      *
     C     WRUN          IFEQ      ' '
     C                   MOVE      'Y'           WRUN              1
     C                   MOVE      '1'           *INU7
     C                   MOVE      '1'           *INU8
     C                   MOVE      '1'           *INLR
     C                   DUMP
     C                   CALL      'DBERRCTL'
     C                   ENDIF
      *
     C                   ENDSR
      /EJECT
      *
** Compile time array to hold valid Action values
IINSERT AAMEND  EENQUIRY
