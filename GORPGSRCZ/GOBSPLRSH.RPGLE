     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2005')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas GO BSPL Report Scheduling')                      *
      *****************************************************************
      *                                                               *
      *  Midas - Global Processing Module                             *
      *                                                               *
      *  GOBSPLRSH - BSPL Report Scheduling                           *
      *                                                               *
      *  (c) Finastra International Limited 2005                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. AR702741           Date 02Feb11               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CAS014             Date 10Aug05               *
      *                 CGP010  *CREATE    Date 17Jan05               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  AR702741 - Include location as parameter in ZFREQB to        *
      *             determine the next settlement date                *
      *             (Child: AR702742)                                 *
      *  CAS014 - IAS21 (The Effects of Changes in Foreign Exchange   *
      *           Rates). Recompile.                                  *
      *  CGP010 - Global BSPL                                         *
      *                                                               *
      *****************************************************************
 
     FGPBSRQL1  UF   E           K DISK    INFSR(*PSSR)
     F                                     COMMIT
 
 
     D                 DS
     D DayMonthYear            1      6  0
     D Day                     1      2  0
     D Month                   3      4  0
     D Year                    5      6  0
 
 
      * BSPL Request - File Format
     D GPBSRQ        E DS                  EXTNAME(GPBSRQPD)
      * BSPL Request - Screen Format
     D GOBSRQ        E DS                  EXTNAME(GOBSRQPD)
 
 
      ** Message data
     D #MsgData        S             45A
      ** Message ID
     D #MsgID          S              7A
 
 
      ** The maximum size of the error arrays
     D ArrayMax        C                   CONST(75)
      ** Array of Fields in error.
     D FldNameArr      S             10A   DIM(ArrayMax)
      ** Array of error message IDs
     D MsgIDArr        S                   DIM(ArrayMax)
     D                                     LIKE(#MsgID)
      ** Array of error message data.
     D MsgDtaArr       S                   DIM(ArrayMax)
     D                                     LIKE(#MsgData)
 
 
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** Externally described DS for bank details
     D SDGELR        E DS                  EXTNAME(SDGELRPD)
      ** Externally described DS for general ledger details
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** Second DS for access programs
 
 
      * Read BSPL Scheduled Requests
 
     C     GPBSRQK       KLIST
     C                   KFLD                    Zone2Process     10
     C                   KFLD                    RequestType       1
 
     C                   MOVE      I#ZONE        Zone2Process
     C                   MOVE      'S'           RequestType
 
     C     GPBSRQK       SETLL     GPBSRQD0
     C     GPBSRQK       READE     GPBSRQD0                               99
     C     *IN99         DOWEQ     *OFF
 
      * If scheduled request is due
 
     C     SCRDATE       IFLE      EventCtlDate
 
     C                   MOVEL     SCRQID        RequestID        15
 
      * Update next report date
 
     C                   EXSR      UPDATE_NEXTDAT
     C                   Z-ADD     ZDAYNO        SCRDATE
     C                   EXCEPT
 
      * Generate immediate request
 
     C                   EXSR      GENERATE_REQ
 
     C                   COMMIT
 
     C                   ENDIF
 
     C     GPBSRQK       READE     GPBSRQD0                               99
     C                   ENDDO
 
     C                   SETON                                        LR
     C                   RETURN
 
      /SPACE 5
      ********************************************************************
      * Update next scheduled date
      ********************************************************************
     C     UPDATE_NEXTDATBEGSR
 
     C                   CALLB     'ZFREQB'
     C                   PARM                    RetCodeIn         7
     C                   PARM      SCRFREQ       ZFREQ             1
     C                   PARM      SCRDATE       ZDAYNO            5 0
     C                   PARM      BJLCCY        ZCCY              3
     C                   PARM      *BLANKS       ZLOC              3                        AR702741
     C                   PARM      SCRDAYN       ZMDAY             2 0
     C                   PARM                    BJDFIN
     C                   PARM                    SDGELR
 
     C                   ENDSR
      ********************************************************************
      /SPACE 5
      ********************************************************************
      * Generate immediate request
      ********************************************************************
     C     GENERATE_REQ  BEGSR
 
      * CONVERT INPUT RECORD TO SCREEN FORMAT
 
     C                   CALLB     'GOBSRQCVT'
     C                   PARM                    I#RTCD            7
     C                   PARM                    I#ERMS           50
 
      * BSPL Request - File Format
     C                   PARM                    GPBSRQ
 
      * OUTPUTS
 
      * BSPL Request - Screen Format
     C                   PARM                    GOBSRQ
 
      * EDIT DETAILS
 
      * Action
     C                   MOVEL     'I'           DDACTN
      * Immediate request
     C                   MOVE      'I'           DDRQTYP
      * Assign request id
     C                   MOVE      *BLANK        DDRQID
      * Calendar year and month
     C                   EXSR      CAL_CALYM
     C                   MOVEL     Year          DDCYR
     C                   MOVEL     Month         DDCMTH
 
      * VALIDATE
 
     C                   CALLB     'GOBSRQVAL'
     C                   PARM                    I#RTCD            7
     C                   PARM                    I#ERMS           50
 
      * INPUTS
 
      * BSPL Request - Screen Format
     C                   PARM                    GOBSRQ
 
      * OUTPUTS
 
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
      * Array index (3P0) from/to caller
     C                   PARM                    Ix                3 0
 
      * BSPL Request - File Format
     C                   PARM                    GPBSRQ
 
      * ERROR IN VALIDATION
 
     C     Ix            IFNE      *ZERO
     C                   EVAL      I#ERMS = 'ERROR IN VALIDATION:'
     C                                      + RequestID
     C                                      + ' ' + MsgIDArr(1)
     C                   EXSR      *PSSR
     C                   ENDIF
 
      * SETUP REQUEST ID
 
     C                   EXSR      SETUP_REQID
 
      * ERROR IN REQUEST ID SET UP
 
     C     Ix            IFNE      *ZERO
     C                   EVAL      I#ERMS = 'NO REQUEST ID GENERATED:'
     C                                      + RequestID
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   MOVEL     DDRQTYP       SCRQTYP
     C                   MOVEL     DDRQID        SCRQID
     C                   MOVEL     DDACTN        SCCHTP
     C                   MOVEL     RequestID     SCRRQID
 
      * WRITE NEW RECORD
 
     C                   CALLB     'GOBSRQUPD'
     C                   PARM      *BLANK        @RTCD             7
     C                   PARM      *BLANK        @ERMS            50
 
      * BSPL Request - File Format
     C                   PARM                    GPBSRQ
 
      * ERROR IN THE UPDATE FUNCTIONS
 
     C     @RTCD         IFNE      *BLANK
     C     @RTCD         ANDNE     '*RECUPD'
     C                   EVAL      I#ERMS = 'NO REQUEST GENERATED:'
     C                                      + RequestID
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   ENDSR
      ********************************************************************
      /EJECT
      *****************************************************************
      * CAL_CALYM - Calculate Calendar Year and Month                *
      *****************************************************************
     C     CAL_CALYM     BEGSR
 
     C                   Z-ADD     CurMonth      Month
     C                   Z-ADD     CurYear       Year
 
     C                   SUB       SCRELPN       Month
     C     Month         DOWLE     0
     C                   ADD       12            Month
     C                   SUB       1             Year
     C                   ENDDO
 
     C                   ENDSR
      ********************************************************************
      /EJECT
      *****************************************************************
      * SETUP_REQID - Set up Request ID for Inserts                   *
      *****************************************************************
     C     SETUP_REQID   BEGSR
 
     C                   IF           DDRQID = *blanks
     C                             OR DDRQID = *zeros
 
     C                   CALL      'GPBSRIGEN'
     C                   PARM                    @RTCD
     C                   PARM                    @ERMS
     C                   PARM                    DDRQTYP
     C                   PARM      *BLANK        DDRQID
 
     C     @RTCD         IFNE      *BLANK
     C                   ADD       1             Ix
     C                   EVAL      FldNameArr(Ix) = 'DDRQID'
     C                   EVAL      MsgIDArr(Ix) = 'GBMIDAS'
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      ********************************************************************
     C     ZDATE2        BEGSR
     C                   CALL      'ZDATE2'
     C                   PARM                    ZDAYNO            5 0          Value date
     C                   PARM      'D'           ZDATFM            1            Date format ind
     C                   PARM      *zero         ZDATE             6 0          Value date
     C                   PARM      *blank        ZADATE            7            Run-date in DDM
     C                   ENDSR
      ********************************************************************
      /SPACE 5
      ********************************************************************
      * *INZSR - Initial Processing
      ********************************************************************
     C     *INZSR        BEGSR
     C     *ENTRY        PLIST
     C                   PARM                    I#RTCD            7
     C                   PARM                    I#ERMS           50
 
      * Zone
     C                   PARM                    I#ZONE           10
 
      * Access Bank Details
 
     C                   CALL      'AOBANKR0'
     C                   PARM      '*DBERR  '    @RTCD             7
     C                   PARM      '*FIRST  '    @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
 
      * Access General Ledger Details
 
     C                   CALL      'AOGELRR0'
     C                   PARM      '*DBERR  '    @RTCD             7
     C                   PARM      '*FIRST  '    @OPTN             7
     C     SDGELR        PARM      SDGELR        DSFDY
 
     C     BJDNWD        SUB       1             EventCtlDate      5 0
 
     C     BKAPDT        IFLT      EventCtlDate
     C                   Z-ADD     BKAPDT        EventCtlDate
     C                   ENDIF
 
      * Convert current run date to day, month and year
 
     C                   Z-ADD     BJRDNB        ZDAYNO
     C                   EXSR      ZDATE2
     C                   MOVEL     ZDATE         DayMonthYear
 
     C                   Z-ADD     Month         CurMonth          2 0
     C                   Z-ADD     Year          CurYear           2 0
 
     C                   ENDSR
      ********************************************************************
      /SPACE 5
      ********************************************************************
      * * P S S R  --- A B N O R M A L   E R R O R   C O N D I T I O N S
      /COPY GOCPYSRC,GOPSSR
      *****************************************************************
     OGPBSRQD0  E
     O                       SCRDATE
