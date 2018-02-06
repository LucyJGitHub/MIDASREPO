     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2008')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas AO Transaction Identifier access Object')        *
      *****************************************************************
      *                                                               *
      *  Midas - Access Objects                                       *
      *                                                               *
      *  AONTTIR1 - Transaction Type Identifier                       *
      *                                                               *
      *  Function:  This module retrieves Transaction Type.           *
      *                                                               *
      *  (c) Finastra International Limited 2008                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CER059             Date 19Jul10               *
      *                 CER030  *CREATE    Date 09Jul08               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER030 - Multicash German Feature                            *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      *  *INZSR     - Initialisation Subroutine                       *
      *  SRMain     - Main Subroutine                                 *
      *  SRCheck    - Subroutine for error handling                   *
      *                                                               *
      *    The *INZSR subroutine will only get called automatically   *
      *    on entry to the module the first time it is run            *
      *    (unless you end the program with LR on).  Similarly        *
      *    D-spec initialisation only happens the first time.  Use    *
      *    RESET for subsequent passes.                               *
      *                                                               *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** Midas Network Transaction Identifier
      *
     FSDNTTIL1  IF   E           K DISK    USROPN
      *
      ** Midas Network Transaction Identifier
      *
     FSDNTTIL2  IF   E           K DISK    USROPN
     F                                     RENAME(SDNTTID0:RTNTTID0)
      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ D-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      *
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
      *
      ** Copyright Array
      *
     D CPY@            S             80A   DIM(1) CTDATA
      *
      ** Program Status Data Structure
      *
     D PGMDS          SDS
     D  PGNAME                 1     10
     D  PGLIBR                81     90
     D  PGJBNM               244    253
     D  PGUSER               254    263
     D  PGJBNO               264    269  0
      *
      ** Network Transaction Identifierre Data Structure
      *
     D SDNTTI        E DS                  EXTNAME(SDNTTIPD)
      *
      ** Short Access Object Data Structure
      *
     D DSFDY         E DS                  EXTNAME(DSFDY)
      *
      ** +--------------------------------------+
      ** ¦ Declared Variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
      *
      ** Program Parameters
      *
     D PZRtCd          S              7A
     D PRtCd           S              7A
     D POptn           S              7A
     D PRtty           S              5A
     D PTRTYP          S              5A
     D PrNtti          S             10A
     D PCount          S              5  0
      *
      ** Key List Parameters
      *
     D KNtti           S                   LIKE(NINTTI)
     D KRtty           S                   LIKE(NIRTTY)
      *
      ** Program Parameters
     D PZPgnm          S             10A
     D PZDest          S              5A
     D PZMgId          S              7A
     D PZMsgf          S             10A
     D PZMgky          S              4A
     D PZMgda          S             50A
     D PZMgtp          S              7A
      *
      ** Working Variables
      *
     D WRtcd           S              7A
     D WRun            S              1A
     D WError          S              1A
     D WOpen           S              1A
     D WClose          S              1A
     D WEmpty          S              1A
     D WEof            S              1A
     D WNrf            S              1A
     D WOption         S              1A
     D WNoSel          S              1A
      *
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +---------------- Start of Main Processing ------------------+
      ** ¦                                                            ¦
      ** ¦  *INZSR is automatically executed at program activation.   ¦
      ** ¦                                                            ¦
      ** +------------------------------------------------------------+
      *
     C                   EXSR      SRMain
      *
     C                   EXSR      SRCheck
      *
     C                   RETURN
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRMain - Handles main processing.                            *
      *                                                               *
      *  Called by : Main Processing                                  *
      *                                                               *
      *  Calls : None                                                 *
      *                                                               *
      *****************************************************************
     C     SRMain        BEGSR
      *
     C                   IF        POptn = '*SAME  '
     C                   IF        WRun <> 'Y'
     C                   EVAL      WOpen = 'Y'
     C                   ENDIF
     C                   LEAVESR
     C                   ENDIF
      *
      ** Initialise the error flags.
      *
     C                   EVAL      WError = 'N'
     C                   EVAL      WOpen = 'N'
     C                   EVAL      WClose = 'N'
     C                   EVAL      WEmpty = 'N'
     C                   EVAL      WEof = 'N'
     C                   EVAL      WNrf = 'N'
     C                   EVAL      WOption = 'N'
     C                   EVAL      WNoSel = 'N'
      *
      ** Open the file on the first call.
      *
     C                   IF        WRun <> 'Y'
     C                   EVAL      WRun = 'Y'
     C                   OPEN(E)   SDNTTIL1
     C                   OPEN(E)   SDNTTIL2
      *
     C                   IF        %ERROR
     C                   EVAL      WOpen = 'Y'
     C                   EVAL      *INLR = *ON
     C                   LEAVESR
     C                   ENDIF
      *
     C                   ENDIF
      *
      ** Close the file and return to the calling program if required.
      *
     C                   IF        POptn = '*FREE  '
     C                   CLOSE(E)  SDNTTIL1
     C                   CLOSE(E)  SDNTTIL2
      *
     C                   IF        %ERROR
     C                   EVAL      WClose = 'Y'
     C                   EVAL      *INLR = *ON
     C                   LEAVESR
     C                   ENDIF
      *
     C                   EVAL      *INLR = *ON
     C                   ENDIF
      *
      ** Get the first record if required.
      *
     C                   IF        POptn = '*FIRST '
     C     *LOVAL        SETLL(E)  SDNTTIL1
      *
     C                   IF        %ERROR
     C                   EVAL      WError = 'Y'
     C                   EVAL      *INLR = *ON
     C                   LEAVESR
     C                   ENDIF
      *
     C                   IF        NOT %FOUND
     C                   EVAL      WEmpty = 'Y'
     C                   LEAVESR
     C                   ENDIF
      *
     C                   EVAL      POptn = '*NEXT  '
     C                   ENDIF
      *
      ** Get the next record if required.
      *
     C                   IF        POptn = '*NEXT  '
     C                   READ(E)   SDNTTIL1
      *
     C                   IF        %ERROR
     C                   EVAL      WError = 'Y'
     C                   EVAL      *INLR = *ON
     C                   LEAVESR
     C                   ENDIF
      *
     C                   IF        %EOF
     C                   EVAL      WEof = 'Y'
     C                   LEAVESR
     C                   ENDIF
      *
     C                   ENDIF
      *
      ** Get the last record if required.
      *
     C                   IF        POptn = '*LAST  '
     C     *HIVAL        SETGT(E)  SDNTTIL1
      *
     C                   IF        %ERROR
     C                   EVAL      WError = 'Y'
     C                   EVAL      *INLR = *ON
     C                   LEAVESR
     C                   ENDIF
      *
     C                   EVAL      POptn = '*PREV  '
     C                   ENDIF
      *
      ** Get the previous record if required.
      *
     C                   IF        POptn = '*PREV  '
     C                   READP(E)  SDNTTIL1
      *
     C                   IF        %ERROR
     C                   EVAL      WError = 'Y'
     C                   EVAL      *INLR = *ON
     C                   LEAVESR
     C                   ENDIF
      *
     C                   IF        %EOF
     C                   EVAL      WEof = 'Y'
     C                   LEAVESR
     C                   ENDIF
      *
     C                   ENDIF
      *
      ** Search for the record if required.
      *
     C                   IF        POptn = '*KEY   ' OR
     C                             POptn = '*VERIFY'
     C                   EVAL      KNtti = *BLANKS
     C                   MOVEL     Prntti        KNtti
     C                   EVAL      PTRTYP= *Blanks
      *
     C     '?'           SCAN      PRTTY
     C                   If        %Found
     C                   CALL      'SD00130S'
     C                   PARM      *BLANKS       PTRTYP
     C                   PARM                    PRNTTI
     C                   PARM                    PCOUNT
      *
     C                   If        PTRTYP= *Blanks  And Pcount <> 0
     C                   EVAL      WNoSel = 'Y'
     C                   EVAL      PRTTY = *Blanks
     C                   LEAVESR
     C                   ELSE
     C                   EVAL      KRtty  = PTRTYP
     C                   EVAL      PRTTY = *Blanks
     C                   ENDIF
      *
     C                   ELSE
     C                   EVAL      KRtty = PRTTY
      *
     C                   ENDIF
      *
     C                   IF        KRtty <> *Blanks
      *
     C                   IF        KNtti <> *BLANKS
      *
     C     KSNtti        CHAIN(E)  SDNTTIL1
      *
     C                   ELSE
      *
     C     KRtty         CHAIN(E)  SDNTTIL2
      *
     C                   ENDIF
      *
     C                   IF        %ERROR
     C                   EVAL      WError = 'Y'
     C                   EVAL      *INLR = *ON
     C                   LEAVESR
     C                   ENDIF
      *
     C                   IF        NOT %FOUND
     C                   EVAL      WNrf = 'Y'
     C                   LEAVESR
     C                   ENDIF
      *
     C                   Else
     C     KNtti         CHAIN(E)  SDNTTIL1
      *
     C                   IF        %FOUND
     C                   EVAL      WNrf = 'Y'
     C                   EVAL      PRTTY = *Blanks
     C                   LEAVESR
     C                   ENDIF
      *
     C                   EndIf
      *
     C                   ENDIF
      *
     C                   IF        (POptn <> '*KEY   ')  AND
     C                             (POptn <> '*NEXT  ')  AND
     C                             (POptn <> '*PREV  ')  AND
     C                             (POptn <> '*VERIFY')  AND
     C                             (POptn <> '*FREE  ')
     C                   EVAL      WOption = 'Y'
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRCheck - Handles error processing.                          *
      *                                                               *
      *  Called by : Main Processing                                  *
      *                                                               *
      *  Calls : None                                                 *
      *                                                               *
      *****************************************************************
     C     SRCheck       BEGSR
      *
     C                   EVAL      PRtCd = *BLANKS
      *
     C                   SELECT
     C                   WHEN      WError = 'Y'
     C                   EVAL      PRtCd = '*ERROR '
     C                   WHEN      WOpen = 'Y'
     C                   EVAL      PRtCd = '*OPEN  '
     C                   WHEN      WClose = 'Y'
     C                   EVAL      PRtCd = '*CLOSE '
     C                   WHEN      WEmpty = 'Y'
     C                   EVAL      PRtCd = '*EMPTY '
     C                   WHEN      WEof = 'Y'
     C                   EVAL      PRtCd = '*EOF   '
     C                   WHEN      WNrf = 'Y'
     C                   EVAL      PRtCd = '*NRF   '
     C                   WHEN      WOption = 'Y'
     C                   EVAL      PRtCd = '*OPTION'
     C                   WHEN      WNoSel = 'Y'
     C                   EVAL      PRtCd = '*NOSEL '
     C                   ENDSL
      *
      ** Send the message to the program queue if required.
      *
     C                   IF        PRtCd <> *BLANKS AND
     C                             WRtCd = '*MSG   '
     C                   SELECT
     C                   WHEN      WError = 'Y'
     C                   EVAL      PZMgId = 'ACO1001'
     C                   WHEN      WOpen = 'Y'
     C                   EVAL      PZMgId = 'ACO1002'
     C                   WHEN      WClose = 'Y'
     C                   EVAL      PZMgId = 'ACO1003'
     C                   WHEN      WEmpty = 'Y'
     C                   EVAL      PZMgId = 'ACO1004'
     C                   WHEN      WEof = 'Y'
     C                   EVAL      PZMgId = 'ACO1005'
     C                   WHEN      WNrf = 'Y'
     C                   EVAL      PZMgId = 'ACO1006'
     C                   WHEN      WOption = 'Y'
     C                   EVAL      PZMgId = 'ACO1007'
     C                   WHEN      WNoSel = 'Y'
     C                   EVAL      PZMgId = 'ACO1009'
     C                   ENDSL
      *
     C                   CALLB     'ZASNMG'
     C                   PARM      *BLANKS       PZRtCd
     C                   PARM      PGNAME        PZPgnm
     C                   PARM      '*PRV'        PZDest
     C                   PARM                    PZMgid
     C                   PARM      *BLANKS       PZMsgf
     C                   PARM      *BLANKS       PZMgky
     C                   PARM                    PZMgda
     C                   PARM      '*DIAG'       PZMgtp
      *
     C                   ENDIF
      *
      ** Execute database error-handling if required.
      *
     C                   IF        PRtCd <> *BLANKS AND
     C                             WRtCd = '*DBERR '
     C                   DUMP
     C                   CALLB     'DBERRCTL'
     C                   ENDIF
      *
     C                   IF        POptn <> '*VERIFY' AND
     C                             POptn <> '*FREE'   AND
     C                             PRtCd <> '*OPTION'
     C                   EVAL      DSFDY = SDNTTI
      *
     C                   If        PTRTYP <> *Blanks
     C                   EVAL      PRTTY = PTRTYP
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *INZSR - Program Initialisation Subroutine.                  *
      *                                                               *
      *  Called by : Implicitly on program activation                 *
      *                                                               *
      *  Calls : None                                                 *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR
      *
      ** Entry Parameter List
      *
     C     *ENTRY        PLIST
      *
      ** Return Code
      *
     C                   PARM                    PRtCd
      *
      ** Option
      *
     C                   PARM                    POptn
      *
      ** Transaction Type
      *
     C                   PARM                    PRtty
      *
      ** Network
      *
     C                   PARM                    PrNtti
      *
      ** Short Access Object Data Structure
      *
     C                   PARM                    DSFDY
      *
      ** End Parameter List
      *
     C     KSNtti        KLIST
     C                   KFLD                    KNtti
     C                   KFLD                    KRTTY
      *
     C                   EVAL      WRtCd = PRtCd
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
** CPY@
(c) Finastra International Limited 2008
