     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas SD Validate currency for a system value')
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SD009600 - Validate a Midas System Value for the following:  *
      *             - A valid TIMEe (Mode = 'HH:MM:SS')               *
      *                                                               *
      *  (c) Finastra International Limited 2005                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. CSD026  *CREATE    Date 06Apr05               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CSD026 - Program for system value 'RatesDownloadTime'        *
      *                                                               *
      *****************************************************************
      ** D-specs
      ** =======
 
 
      ** Long Data Structure for Access Objects
     D DSSDY         E DS                  EXTNAME(DSSDY)
 
      ** Data structure for RatesDownloadTime string
     D*
     D TimeVal         DS           200
     D  DPHRS                  1      2
     D  DPHRSA                 1      1
     D  COLON1                 3      3
     D  DPMIN                  4      5
     D  COLON2                 6      6
     D  DPSEC                  7      8
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Error message id in GBSDUSRMSG
     D ErrMsgId        S              7
 
      ** System value to be processed
     D SystemValue     S             20
 
      ** Processing mode
     D*ProcMode******  S             10                                                       CSC018
     D ProcMode        S            190                                                       CSC018
 
      ** General error indicator
     D GenError        S              1
 
      ** Index for arrays of of error message ids etc
     D Idx             S              2P 0
 
      ** Array of error message IDs
     D MsgIDXArr       S                   DIM(99) LIKE(ErrMsgId)
 
      /EJECT
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
 
     C                   SETOFF                                           55
      ** Check if the Time entered by the user is in HH:MM:SS format
 
     C     TimeVal       IFNE      *BLANKS
     C*    Check hours/mins/secs are numeric
     C                   TESTN                   DPHRS                55
     C   55              TESTN                   DPMIN                55
     C   55              TESTN                   DPSEC                55
     C*
     C     *IN55         IFEQ      '1'
     C*
 
     C*
     C** IF TIME ENTERED IS NOT VALID (HOURS GREATER
     C** THAN 23 OR MINUTES GREATER THAN 59) SET ON
     C** ERROR INDICATOR AND WRITE ERROR MESSAGE
     C*
     C     DPHRS         IFGT      '23'
     C     DPMIN         ORGT      '59'
     C     DPSEC         ORGT      '59'
     C                   SETOFF                                           55
     C                   ENDIF
     C     *IN55         IFEQ      '1'
 
      ** Check COLON1 and COLON2
     C     COLON1        IFNE      ':'
     C     COLON2        ORNE      ':'
     C                   SETOFF                                           55
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
     C*
     C     *IN55         IFEQ      '0'
      ** If value entered by user is not valid
      ** then return an error
 
     C                   EVAL      GenError = 'Y'
     C                   ADD       1             Idx
     C                   MOVEL     'USR9833'     MsgIDXArr(Idx)
     C                   EVAL       *INLR = *ON
     C                   RETURN
     C*
     C                   ENDIF
     C                   ENDIF
     C*
 
 
      ** Normal end processing
 
     C                   EVAL      GenError = ' '
     C                   EVAL      *INLR = *ON
 
     C                   RETURN
      /EJECT
      *****************************************************************
      *  *INZSR - Program Initialisation routine                      *
      *****************************************************************
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
 
      ** System value to be processed
     C                   PARM                    SystemValue
      ** Value entered by user
     C                   PARM                    TimeVal
      ** Processing Mode
     C                   PARM                    ProcMode
      ** General Error Indicator
     C                   PARM                    GenError
      ** Error message ID (number of entries)
     C                   PARM                    Idx
      ** Error message ID (array)
     C                   PARM                    MsgIDXArr
 
     C                   ENDSR
      /EJECT
