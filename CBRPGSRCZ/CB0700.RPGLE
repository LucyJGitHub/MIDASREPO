     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2012')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas PEA Menu')                                       *
      *****************************************************************
      *                                                               *
      *  Midas - Close of Business Processing                         *
      *                                                               *
      *  CB0700 - Close of Business PEA Menu                          *
      *                                                               *
      *  (c) Finastra International Limited 2012                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CSC054  *CREATE    Date 23Feb12               *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CSC054 - Period End Adjustments                              *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E   I N D E X                              *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  I N D I C A T O R S   I N D E X                              *
      *                                                               *
      *    03      COMMAND KEY F03                                    *
      *    50      FAIL ON READ OF DISPLAY FILE - CB0700DF            *
      *    60      INVALID ENTRY ON SCREEN                            *
      *    65      ALLOW USE OF F6/F12                                *
      *    70      RE-TRY LOCK OF DATA AREA                           *
      *                                                               *
      *    U1      SCREEN TIMED OUT                                   *
      *    U7&U8   DATABASE ERROR                                     *
      *                                                               *
      *****************************************************************
      *
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      *
      ** Midas CB PEA Menu
      *
     FCB0700DF  CF   E             WORKSTN
     F                                     MAXDEV(*FILE)
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
      *
      ** Invalid option error message array
      *
     D OPTINV          S             78    DIM(5) CTDATA PERRCD(1)
      *
      ** Option ended in error Error Message Array
      *
     D OPTERR          S             78    DIM(5) CTDATA PERRCD(1)
      *
      *****************************************************************
      *
      ** Local Data Area
      *
     D LDA             DS           256
     D  DBFILE               134    141
     D  DBKEY                142    170
     D  DBPGM                179    180
     D  DBASE                181    183  0
      *
      ** CBSTAT Data Area
      *
     D CBSTAT          DS            50
     D  JBSTHT                20     20
     D  REOPFL                32     32
      *
      ** Set up error option number for array opterr
      *
     D ERARR           DS
     D  ERRSTR                 1     78
     D  OPTION                 8      8
      *
      ** Data Structure to get date from rundat data area
      *
     D RUNDAT          DS            13
     D  AGMRDT                 1      7
      *
      ** Data Structure for workstation ID for screen output
      *
     D PSDS           SDS
     D  WSID                 244    253
     D  USRID                254    263
      *
      ** Data Structure for DSSDY
      *
     DDSSDY          E DS                  EXTNAME(DSSDY)
      *
      ** Constant value
      *
     D CVALK1          C                   CONST('PEAHandShakingQM')
     D CVALK2          C                   CONST('PEAHandShakingIQ')
     D CVALK3          C                   CONST('BrgMidasSystemPrefix')
     D CMsg01          C                   CONST('PEA Transfer')
      *
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
      *
     D UniqueID        S             10
     D ReturnCode      S              7
     D AOOption        S              7
     D CName           S             10
     D Number          S              5
     D Error           S              1
     D X               S              1S 0
     D SysPrefix       S              2
     D MQManager       S             48
     D MQueue          S             48
     D Message         S           2000
 
     D SVALK1          S             20
     D SVAL1           S            200
     D SVALK2          S             20
     D SVAL2           S            200
     D SVALK3          S             20
     D SVAL3           S            200
     D SVALK4          S             20
     D SVAL4           S            200
     D SVALK5          S             20
     D SVAL5           S            200
     D SVALK6          S             20
     D SVAL6           S            200
     D SVALK7          S             20
     D SVAL7           S            200
     D SVALK8          S             20
     D SVAL8           S            200
     D SVALK9          S             20
     D SVAL9           S            200
     D SVALK0          S             20
     D SVAL10          S            200
      *
      *****************************************************************
      *
      ** DEFINE DATA AREA LDA AND LOCK TO SET
      ** UP PROGRAM NAME FOR DATABASE ERRORS
      *
     C     *DTAARA       DEFINE                  LDA
     C     *LOCK         IN        LDA
     C                   MOVEL     'CB0700  '    DBPGM
     C                   MOVE      *BLANKS       DBKEY
     C                   OUT       LDA
      *
      **  GET RUN DATE FROM DATA AREA RUNDAT
      *
     C     *DTAARA       DEFINE                  RUNDAT
     C                   IN        RUNDAT
     C                   MOVE      AGMRDT        RUNA
     C                   UNLOCK    RUNDAT
      *
      ** DO WHILE KEY F3 NOT PRESSED AND SCREEN NOT TIMED OUT
      *
     C                   DoW       *In03 <> '1'
      *
      ** Define data area CBSTAT and lock to check if job streams are not halted
      ** set on indicator to display 'Request Immediate Halt' option
      *
     C     *DtaAra       Define                  CBSTAT
      *
     C                   DoU       *In70 = *Off
     C     *LOCK         In        CBSTAT                               70
     C                   EndDo
      *
     C                   If        JBSTHT = 'N'
     C                   Eval      *In34 = *On
     C                   EndIf
      *
      ** Unlock data area CBSTAT
      *
     C                   Out       CBSTAT
      *
      ** Write header and selection formats to screen and read for selection or time out
      *
     C                   Write     CB0700F0
     C                   Write     CB0700F1
     C                   Read      CB0700DF                             U150
      *
      ** If key F3 not pressed and screen not timed
      ** out then check validity on entry made
      *
     C                   If        *In03 <> *On
      *
      ** Set off screen error indicators
      *
     C                   Eval      *In60 = *Off
      *
      ** If value entered is not 1, 2, 3, 4
      ** Set on error indicator and set up error
      ** message as 'ENTRY MUST BE VALID OPTION'
      *
     C                   If        Select <> '1' and
     C                             Select <> '2' and
     C                             Select <> '3' and
     C                             Select <> '4'
      *
     C                   Eval      *In60 = *On
     C                   Eval      ErrMsg = OptInv(1)
      *
      ** Else CALL HALT PROGRAM REQUESTED
      *
     C                   ELSE
      *
      ** If value = 1 call Re-open input cycle in the period end system
      *
     C                   If        Select = '1'
      *
      ** SET MESSAGE FIELD AND ALLOW
      ** USE OF KEYS F6 AND F12
      *
     C                   Eval      ErrMsg = OptInv(2)
     C                   Eval      *In60 = *On
     C                   Eval      *In65 = *On
     C                   Eval      *In70 = *On
      *
      ** Write Selection format (CB0700F1) to screen
      *
     C                   Write     CB0700F1
      *
      ** Do while command keys F6 and F12
      ** not pressed, screen not timed out
      *
     C                   Dow       *In06 = *Off and
     C                             *In12 = *Off and
     C                             *InU1 = *Off
      *
      ** Re-write SELECTION FORMAT (CB0700F1) to screen if neither F6
      ** nor F12 was chosen
      *
     C                   Write     CB0700F1
      *
     C                   Read      CB0700DF                             U150
      *
     C                   EndDo
     C                   Eval      *In70 = *Off
      *
      ** If key F6 pressed and screen not timed out
      *
     C                   If        *In06 = *On and
     C                             *InU1 = *Off
      *
      ** Call CBC0028 to setup MSGQ/MSPECIAL and to reopen input cycle.
      *
      * Release the lock on the SFMENU* files so that the database can be restored.
      *
     C                   Eval      AOOption = '*FREE'
      *
     C                   Call      'AOMENUR0'
     C                   Parm                    ReturnCode                     Return code
     C                   Parm                    AOOption                       AOOption
     C                   Parm                    UniqueID                       UniqueID
     C                   Parm                    DSSDY                          Format
      *
     C                   Call      'CBC0028'
      *
      ** If SCMINIT fails to reopen input cycle (IE CBSTAT POS 32 IS STILL = 'Y')
      ** Deactivate command keys F6 and F12, and write error message
      *
     C                   DoU       *In79 = *Off
     C     *LOCK         In        CBSTAT                               79
     C                   EndDo
     C                   If        ReOpFl = 'Y'
      *
     C                   Eval      *In65 = *Off
     C                   Eval      Option = Select
     C                   Eval      ErrMsg = OptErr(1)
      *
     C                   EndIf
      *
     C                   Else
      *
      ** Else if command key 12 pressed to cancel request
      ** to reopen input cycle then clear message
      *
     C                   If        *In12 = *On
     C                   Eval      *In60 = *Off
     C                   Eval      *In65 = *Off
     C                   EndIf
      *
     C                   EndIf
      *
     C                   EndIf
      *
      ** If value = 2 call Generate a report of all the transaction to be transferred
      *
     C                   If        Select = '2'
      *
      ** Set message field and allow use of Keys F6 and F12
      *
     C                   Eval      ErrMsg = OptInv(3)
     C                   Eval      *In60 = *On
     C                   Eval      *In65 = *On
     C                   Eval      *In70 = *On
      *
      ** Write Selection format (CB0700F1) to screen
      *
     C                   Write     CB0700F1
      *
      ** Do while command keys F6 and F12
      ** not pressed, screen not timed out
      *
     C                   Dow       *In06 = *Off and
     C                             *In12 = *Off and
     C                             *InU1 = *Off
      *
      ** Re-write SELECTION FORMAT (CB0700F1) to screen if neither F6
      ** nor F12 was chosen
      *
     C                   Write     CB0700F1
      *
     C                   Read      CB0700DF                             U150
      *
     C                   EndDo
     C                   Eval      *In70 = *Off
      *
      ** If key F6 pressed and screen not timed out
      *
     C                   If        *In06 = *On and
     C                             *InU1 = *Off
      *
     C                   Call      'APC001003'
      *
     C                   Eval      ErrMsg = OptErr(2)
     C                   Eval      *In60 = *On
     C                   Eval      *In65 = *Off
      *
     C                   Else
      *
      ** Else if command key 12 pressed to cancel request
      ** to reopen input cycle then clear message
      *
     C                   If        *In12 = *On
     C                   Eval      *In60 = *Off
     C                   Eval      *In65 = *Off
     C                   EndIf
      *
     C                   EndIf
     C                   EndIf
      *
      ** If value = 3 call Close PEA System and Transfer Transactions to Live System
      *
     C                   If        Select = '3'
      *
      ** SET MESSAGE FIELD AND ALLOW
      ** USE OF KEYS F6 AND F12
      *
     C                   Eval      ErrMsg = OptInv(4)
     C                   Eval      *In60 = *On
     C                   Eval      *In65 = *On
     C                   Eval      *In70 = *On
      *
      ** Write Selection format (CB0700F1) to screen
      *
     C                   Write     CB0700F1
      *
      ** Do while command keys F6 and F12
      ** not pressed, screen not timed out
      *
     C                   Dow       *In06 = *Off and
     C                             *In12 = *Off and
     C                             *InU1 = *Off
      *
      ** Re-write SELECTION FORMAT (CB0700F1) to screen if neither F6
      ** nor F12 was chosen
      *
     C                   Write     CB0700F1
      *
     C                   Read      CB0700DF                             U150
      *
     C                   EndDo
     C                   Eval      *In70 = *Off
      *
      ** If key F6 pressed and screen not timed out
      *
     C                   If        *In06 = *On and
     C                             *InU1 = *Off
      *
     C                   Exsr      GetOpt3Parms
      *
     C                   Call      'SCC000119'
     C                   Parm      *Blanks       ReturnCode
     C                   Parm                    SysPrefix
     C                   Parm                    MQManager
     C                   Parm                    MQueue
     C                   Parm      CMsg01        Message
      *
     C                   If        ReturnCode = *Blanks
     C                   Eval      ErrMsg = OptErr(3)
     C                   Else
     C                   Eval      ErrMsg = OptErr(5)
     C                   EndIf
     C                   Eval      *In60 = *On
     C                   Eval      *In65 = *Off
      *
     C                   Else
      *
      ** Else if command key 12 pressed to cancel request
      ** to reopen input cycle then clear message
      *
     C                   If        *In12 = *On
     C                   Eval      *In60 = *Off
     C                   Eval      *In65 = *Off
     C                   EndIf
      *
     C                   EndIf
      *
     C                   EndIf
      *
      ** If value = 4 call Clear PEA System
      *
     C                   If        Select = '4'
      *
      ** Set message field and allow use of Keys F6 and F12
      *
     C                   Eval      ErrMsg = OptInv(5)
     C                   Eval      *In60 = *On
     C                   Eval      *In65 = *On
     C                   Eval      *In70 = *On
      *
      ** Write Selection format (CB0700F1) to screen
      *
     C                   Write     CB0700F1
      *
      ** Do while command keys F6 and F12
      ** not pressed, screen not timed out
      *
     C                   Dow       *In06 = *Off and
     C                             *In12 = *Off and
     C                             *InU1 = *Off
      *
      ** Re-write SELECTION FORMAT (CB0700F1) to screen if neither F6
      ** nor F12 was chosen
      *
     C                   Write     CB0700F1
      *
     C                   Read      CB0700DF                             U150
      *
     C                   EndDo
     C                   Eval      *In70 = *Off
      *
      ** If key F6 pressed and screen not timed out
      *
     C                   If        *In06 = *On and
     C                             *InU1 = *Off
      *
     C                   Call      'SCC000122'
      *
     C                   Eval      ErrMsg = OptErr(4)
     C                   Eval      *In60 = *On
     C                   Eval      *In65 = *Off
      *
     C                   Else
      *
      ** Else if command key 12 pressed to cancel request
      ** to reopen input cycle then clear message
      *
     C                   If        *In12 = *On
     C                   Eval      *In60 = *Off
     C                   Eval      *In65 = *Off
     C                   EndIf
      *
     C                   EndIf
      *
     C                   EndIf
      *
      ** If error parameter passed back from CBC0026 is 'Y' set on error indicator
      ** and set up error message as 'Option X ended in error'
      *
     C                   If        Error = 'Y'
     C                   Eval      *In60 = *On
     C                   Eval      Errstr = OptErr(X)
     C                   Eval      Option = Select
     C                   Eval      ErrMsg = ErrStr
     C                   Write     CB0700F2
     C                   EndIf
      *
      ** If error parameter passed back from CBC0026 is 'T' set on screen timed out indicator
      *
     C                   If        Error = 'T'
     C                   Eval      *InU1 = *On
     C                   EndIf
      *
      ** If valid option taken clear screen input field
      *
     C                   If        Error <> 'Y' and
     C                             Error <> 'T'
     C                   Eval      Select = *Blanks
     C                   Write     CB0700F2
     C                   Eval      *In34 = *Off
     C                   EndIf
      *
     C                   EndIf
      *
     C                   EndIf
      *
     C                   EndDo
      *
     C                   Eval      *InLR = *On
      *
     C/EJECT
      *****************************************************************
      *                                                               *
      *  GetOpt3Parm - Get Option 3 parameters in System Values       *
      *                                                               *
      *                                                               *
      *****************************************************************
     C     GetOpt3Parms  BegSr
 
     C                   Eval      MQManager = *Blanks
     C                   Eval      MQueue    = *Blanks
     C                   Eval      SysPrefix = *Blanks
 
     C                   Call      'AOSVALR0'
     C                   Parm                    ReturnCode
     C                   Parm      CVALK1        SVALK1
     C                   Parm                    SVAL1
     C                   Parm      CVALK2        SVALK2
     C                   Parm                    SVAL2
     C                   Parm      CVALK3        SVALK3
     C                   Parm                    SVAL3
     C                   Parm                    SVALK4
     C                   Parm                    SVAL4
     C                   Parm                    SVALK5
     C                   Parm                    SVAL5
     C                   Parm                    SVALK6
     C                   Parm                    SVAL6
     C                   Parm                    SVALK7
     C                   Parm                    SVAL7
     C                   Parm                    SVALK8
     C                   Parm                    SVAL8
     C                   Parm                    SVALK9
     C                   Parm                    SVAL9
     C                   Parm                    SVALK0
     C                   Parm                    SVAL10
      *
     C                   If        ReturnCode = *Blanks
     C                   Eval      MQManager = SVAL1
     C                   Eval      MQueue    = SVAL2
     C                   Eval      SysPrefix = SVAL3
     C                   EndIf
     C                   EndSr
      *
     C/EJECT
      *****************************************************************
      *                                                               *
      *  *INZSR - Program Initialisation                              *
      *         - This subroutine runs automatically for program      *
      *           initialisation.                                     *
      *                                                               *
      *****************************************************************
     C     *INZSR        BegSr
 
     C                   EndSr
      ********************************************************************
**CTDATA OPTINV
ENTRY MUST BE A VALID OPTION NUMBER
PRESS F6 TO CONFIRM OR F12 TO CANCEL REQUEST TO REOPEN INPUT CYCLE
PRESS F6 TO CONFIRM OR F12 TO CANCEL GENERATION OF REPORT
PRESS F6 TO CONFIRM OR F12 TO CANCEL TRANSACTION TRANSFER AND CLOSE
PRESS F6 TO CONFIRM OR F12 TO CANCEL CLEAR THE PERIOD END SYSTEM
**CTDATA OPTERR
OPTION   ENDED IN ERROR
PEAREPORT JOB HAVE BEEN SUBMITTED
PEACLOSE JOB HAVE BEEN SUBMITTED
PEACLEAR JOB HAVE BEEN SUBMITTED
CLOSING OF PERIOD END SYSTEM ENDED IN ERROR
