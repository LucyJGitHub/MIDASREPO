     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2005')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas GO BSPL Request Retrieve')
      *****************************************************************
      *                                                               *
      *  Midas - Global Processing Module                             *
      *                                                               *
      *  GOBSRQRTV - BSPL Request Retrieve                            *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2005            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Last Amend No. CAS014             Date 10Aug05               *
      *  Prev Amend No. CGP010  *CREATE    Date 17Jan05               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CAS014 - IAS21 (The Effects of Changes in Foreign Exchange   *
      *           Rates). Recompile.                                  *
      *  CGP010 - Global BSPL                                         *
      *                                                               *
      *****************************************************************
 
     FGPBSRQPD  IF   E           K DISK    INFSR(*PSSR)
 
 
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
 
 
      * BSPL Request - File Format
     D GPBSRQ        E DS                  EXTNAME(GPBSRQPD)
 
 
      * Clear outputs
 
     C                   CLEAR                   GPBSRQ
 
      * Validate Action Code
 
     C                   EXSR      V_ACTION
 
     C     Ix            IFNE      0
     C                   RETURN
     C                   ENDIF
 
      * Validate Request Type
 
     C                   EXSR      V_REQTYPE
 
      * Validate Request ID
 
     C                   EXSR      V_REQUESTID
 
     C     Ix            IFNE      0
     C                   RETURN
     C                   ENDIF
 
      * Access record
 
     C     DDACTN        IFEQ      'A'
     C     DDACTN        OREQ      'E'
     C     DDACTN        OREQ      'D'
     C                   EXSR      ACS_RECORD
     C                   ENDIF
 
 
     C                   RETURN
 
      /SPACE 5
      ********************************************************************
      * Validate Action Code
      ********************************************************************
     C     V_ACTION      BEGSR
 
      * 'Action code must be insert (I), amend (A) enquire (E) or delete (D)'
 
     C     DDACTN        IFNE      'I'
     C     DDACTN        ANDNE     'A'
     C     DDACTN        ANDNE     'E'
     C     DDACTN        ANDNE     'D'
     C                   ADD       1             Ix
     C                   MOVEL     'DDACTN   '   FldNameArr(Ix)
     C                   MOVEL     'GO00500'     MsgIDArr(Ix)
     C                   ENDIF
 
     C                   ENDSR
      *********************************************************************
      /SPACE 5
      ********************************************************************
      * Validate Request Type
      ********************************************************************
     C     V_REQTYPE     BEGSR
 
      * 'Request Type must be Scheduled (S) or Immediate (I)'
 
     C     DDRQTYP       IFNE      'S'
     C     DDRQTYP       ANDNE     'I'
     C                   ADD       1             Ix
     C                   MOVEL     'DDRQTYP  '   FldNameArr(Ix)
     C                   MOVEL     'GO00501'     MsgIDArr(Ix)
     C                   ENDIF
 
     C                   MOVEL     DDRQTYP       SCRQTYP
 
     C                   ENDSR
      ********************************************************************
      /SPACE 5
      ********************************************************************
      * Validate Request ID
      ********************************************************************
     C     V_REQUESTID   BEGSR
 
      * 'Request ID must be blank on insert'
 
     C     DDACTN        IFEQ      'I'
 
     C     DDRQID        IFNE      *BLANK
     C                   ADD       1             Ix
     C                   MOVEL     'DDRQID   '   FldNameArr(Ix)
     C                   MOVEL     'GO00502'     MsgIDArr(Ix)
     C                   ENDIF
 
     C                   ELSE
 
      * 'Request ID must be defined on amend, enquire or delete'
 
     C     DDRQID        IFEQ      *BLANK
     C                   ADD       1             Ix
     C                   MOVEL     'DDRQID   '   FldNameArr(Ix)
     C                   MOVEL     'GO00503'     MsgIDArr(Ix)
     C                   ELSE
     C                   MOVE      *BLANKS       ZFIELD
     C                   MOVEL     DDRQID        ZFIELD
     C                   Z-ADD     0             ZADEC
     C                   Z-ADD     15            ZADIG
     C                   EXSR      ZALIGN
     C     ZALIGNok      IFEQ      'Y'
     C                   MOVE      ZFIELD        SCRQID
     C                   MOVE      ZFIELD        DDRQID
     C                   ELSE
 
      * 'Invalid Request ID'
     C                   ADD       1             Ix
     C                   MOVEL     'DDRQID   '   FldNameArr(Ix)
     C                   MOVEL     'GO00504'     MsgIDArr(Ix)
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDSR
      ********************************************************************
      /SPACE 5
      *******************************************************************
      * Access record
      *******************************************************************
     C     ACS_RECORD    BEGSR
 
     C     GPBSRQK       CHAIN     GPBSRQD0                           99        *
 
      * 'BSPL Request record does not exist'
 
     C     *IN99         IFEQ      *ON
     C                   ADD       1             Ix
     C                   MOVEL     'DDRQID   '   FldNameArr(Ix)
     C                   MOVEL     'GO00505'     MsgIDArr(Ix)
     C                   ENDIF
 
     C                   ENDSR
      ********************************************************************
      /SPACE 5
      ********************************************************************
      * Convert Digits to a Number
      ********************************************************************
     C     ZALIGN        BEGSR
     C                   CALLB     'ZALIGN'
     C                   PARM                    ZALIGNok          1
     C                   PARM                    ZFIELD           16
     C                   PARM                    ZADEC             1 0
     C                   PARM                    ZADIG             2 0
     C                   ENDSR
      *******************************************************************
      /SPACE 5
      *******************************************************************
      * *INZSR - Initial Processing
      *******************************************************************
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
     C                   PARM                    I#RTCD            7
     C                   PARM                    I#ERMS           50
 
      * Action
     C                   PARM                    DDACTN            1
      * Request Type
      * Request ID
     C                   PARM                    DDRQTYP           1
     C                   PARM                    DDRQID           15
 
      * OUTPUTS
 
      * BSPL Request - File Format
     C                   PARM                    GPBSRQ
 
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
      * Array index (3P0) from/to caller
     C                   PARM                    Ix                3 0
 
      * Key lists
 
     C     GPBSRQK       KLIST
     C                   KFLD                    SCRQTYP
     C                   KFLD                    SCRQID
 
     C                   ENDSR
      **********************************************************************************
      /SPACE 5
      ********************************************************************
      * * P S S R  --- A B N O R M A L   E R R O R   C O N D I T I O N S
      /COPY GOCPYSRC,GOPSSR
      *****************************************************************
