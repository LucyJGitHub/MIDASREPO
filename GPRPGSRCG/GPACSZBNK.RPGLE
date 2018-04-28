     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2010')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas GP Access Zone Bank Details')
      *****************************************************************
      *                                                               *
      *  Midas - Retail Module                                        *
      *                                                               *
      *  GPACSZBNK - Midas GP Access Zone Bank Details                *
      *                                                               *
      *  Function:  This program will retrieve zone bank details.     *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2010            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      *  Last Amend No. CAP204  *CREATE    Date 15Mar10               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CAP204 - Teller Related APIs - Account Transfer              *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      * *PSSR    - Error processing                                   *
      *                                                               *
      *****************************************************************
 
     FGZSDBANKL1IF   E           K DISK
      ** Midas GZ Bank Details ICD
 
      *****************************************************************
      /EJECT
      *****************************************************************
     D LDA           E DS           256    EXTNAME(LDA)
 
      ** Local data area for database error details
      ** *LOCK IN LDA immediately before and OUT LDA immediately
      ** after each database error handling.
      **
      **                                    134 141 DBFILE
      **       Defines:                     142 170 DBKEY
      **                                    171 180 DBPGM
      **                                    181 1830DBASE
 
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
 
     D/COPY GPCPYSRCG,PSDS
      ** Program Status Data Structure
 
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Maximum number of zones
     D MaxNoZones      C                   CONST(20)
 
      ** Zones
     D #_ZONE          S             10    DIM(MaxNoZones)
 
      ** Zone Bank Details
     D #_BANKDT        S            129    DIM(MaxNoZones)
 
      ** Cached time
     D #_TIME          S               Z   DIM(MaxNoZones)
 
      ** Zone Bank Details
     D GZSDBANK      E DS                  EXTNAME(GZSDBANKPD)
 
     D W#LoadTime      S               Z
     D W#CurrTime      S               Z
     D W#RUN           S              1A
     D BUFFER          S           4000A
     D W#Elapse        S              5P 0
     D @IX             S              6P 0
     D @CIX            S              6P 0
     D I#RTCD          S              7A
     D I#ERMS          S             50A
     D I#Zone          S             10A
     D I#ClearCache    S              1A
     D O#RecordIMAGE   S          32000A
 
      *********************************************************************
      * MAIN PROCEDURE                                                    *
      *********************************************************************
 
     C     *ENTRY        PLIST
     C                   PARM                    I#RTCD
     C                   PARM                    I#ERMS
 
      ** INPUTS
 
     C                   PARM                    I#Zone
     C                   PARM                    I#ClearCache
 
      ** OUTPUTS
 
     C                   PARM                    O#RecordIMAGE
 
      ** Clear output
 
     C                   MOVEL     *BLANK        I#RTCD
     C                   MOVEL     *BLANK        I#ERMS
     C                   CLEAR                   GZSDBANK
     C                   EVAL      O#RecordIMAGE  = GZSDBANK
 
      ** Clear cache
 
     C     I#ClearCache  IFEQ      'Y'
     C                   Z-ADD     *ZERO         @CIX
     C                   MOVEL     *BLANK        #_ZONE
     C                   MOVEL     *BLANK        #_BANKDT
     C                   ENDIF
 
      ** Report 'No Record Found' if input fields are not supplied
 
     C     I#Zone        IFEQ      *BLANK
     C                   EVAL      I#RTCD = '*NOREC'
     C                   EVAL      I#ERMS = 'BLANK ZONE'
     C                   RETURN
     C                   ENDIF
 
      ** If the zone bank details were previously accessed,
      ** use that zone's bank details
 
     C                   Z-ADD     1             @IX
     C     I#Zone        LOOKUP    #_ZONE(@IX)                            99
     C     *IN99         IFEQ      '1'
 
      ** Refresh the data if content is older than 10 minutes
 
     C                   EVAL      W#LoadTime = #_TIME(@IX)
     C                   EVAL      W#CurrTime = %TIMESTAMP
     C     W#CurrTime    SUBDUR    W#LoadTime    W#Elapse:*MN
     C                   IF        W#Elapse > 10
     C                   EVAL      #_ZONE(@IX)   = *BLANKS
     C                   EVAL      #_BANKDT(@IX) = *BLANKS
     C                   ELSE
     C                   MOVEL     #_BANKDT(@IX) O#RecordIMAGE
     C                   RETURN
     C                   ENDIF
     C                   ENDIF
 
      ** Access the zone bank details
 
     C     I#Zone        CHAIN     GZSDBANKL1                         99
 
      ** If no zone bank details are found pass back blank details
 
     C     *IN99         IFEQ      '1'
     C                   EVAL      I#RTCD = '*NOREC'
     C                   CLEAR                   GZSDBANK
     C                   ELSE
 
      ** Save the zone's bank details
 
     C                   Z-ADD     1             @IX
     C     *BLANK        LOOKUP    #_ZONE(@IX)                            99
     C     *in99         IFEQ      '1'
     C                   MOVEL     I#Zone        #_ZONE(@IX)
     C                   MOVEL     GZSDBANK      #_BANKDT(@IX)
     C                   EVAL      #_TIME(@IX) = %TIMESTAMP
     C                   ELSE
     C                   ADD       1             @CIX
     C                   MOVEL     I#Zone        #_ZONE(@CIX)
     C                   MOVEL     GZSDBANK      #_BANKDT(@CIX)
     C                   EVAL      #_TIME(@CIX) = %TIMESTAMP
     C     @CIX          IFEQ      MaxNoZones
     C                   Z-ADD     *ZERO         @CIX
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDIF
 
      ** Set up output data
 
     C                   EVAL      O#RecordIMAGE  = GZSDBANK
 
      ** Return
 
     C                   RETURN
 
      *****************************************************************
      /SPACE 5
      *****************************************************************
      *                                                               *
      * *INZSR --- INITIAL PROCESSING                                 *
      *                                                               *
      *****************************************************************
 
     C     *INZSR        BEGSR
 
     C                   Z-ADD     *ZERO         @CIX
 
     C                   ENDSR
 
      *****************************************************************
      /SPACE 5
      *****************************************************************
      *                                                               *
      * *PSSR  - Program exception error routine                      *
      *          Called automatically if a program error occurs,      *
      *          or directly by the program code using EXSR.          *
      *          This subroutine DUMPs the program just once.         *
      *                                                               *
      * Called by: (**calling routines**)                             *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     *PSSR         BEGSR
 
     C     W#RUN         IFEQ      *BLANKS
 
     C                   MOVE      'Y'           W#RUN
 
     C                   MOVEL     '*ERROR'      I#RTCD
     C                   MOVE      '1'           *INU7
     C                   MOVE      '1'           *INU8
 
     C                   DUMP
 
      ** If no identified cause of error
 
     C     I#ERMS        IFEQ      *BLANK
     C                   EVAL      I#ERMS = 'UNEXPECTED ERROR'
     C                   ENDIF
 
      ** Log an error on the error log
 
     C                   CLEAR                   BUFFER
     C                   EVAL      BUFFER = I#ERMS
     C                   CALL      'GPWRTELOG'
     C                   PARM                    BUFFER
     C                   ENDIF
 
     C                   RETURN
 
     C                   ENDSR
