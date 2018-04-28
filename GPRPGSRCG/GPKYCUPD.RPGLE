     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2006')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas GP Update KYC Items')
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  GPKYCUPD - Midas GP Update KYC Items                         *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2006            *
      *                                                               *
      *  Last Amend No. CSC043             Date 18Jun10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. BUG10603 *CREATE   Date 02Mar06               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSC043 - MidasPlus IASP Enablement                           *
      *  BUG10603 - (Reopen) Compliance Alert Changes for KYC         *
      *                                                               *
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ D-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Named Constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
      ** Copyright Statement Array
     D CPY@            S             80A   DIM(1) CTDATA
 
      ** Log Message Array
     D LOGMSG          S             60A   DIM(10) CTDATA
 
      ** +--------------------------------------+
      ** ¦ Declared Variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Entry Parameters (Variable Character)
     D PvchRslt        S             10A   VARYING
     D PvchSysP        S              2A   VARYING
     D PvchCNum        S              6A   VARYING
     D PvchStat        S              1A   VARYING
     D PvchItem        S           5000A   VARYING
 
      ** Entry Parameters (Fixed Length)
     D PResult         S             10A
     D PSysPrefix      S              2A
     D PCustNumber     S              6A
     D PKycStatus      S              1A
     D PKycItems       S           5000A
 
      ** KYC Logger Parameters
     D PPgmName        S             10A
     D PLogType        S             10A
     D PLogMsg         S             60A
 
      ** Working Variables
     D WLogMsg         S                   LIKE(PLogMsg)
     D WResult         S                   LIKE(PResult)
     D***WPgm***         S             14A                                                    CSC043
     D WPgm            S             15A                                                      CSC043
 
      ** +---------------- Start of Main Processing ------------------+
      ** ¦                                                            ¦
      ** ¦  *INZSR is automatically executed at program activation.   ¦
      ** ¦                                                            ¦
      ** +------------------------------------------------------------+
 
     C                   EXSR      SRSetLibL
 
     C                   EXSR      SRKycUpd
 
     C                   EVAL      PLogMsg = LOGMSG(8)
     C                   EXSR      SRWrtLog
 
     C                   EVAL      *INLR = *ON
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRSetLibL - Sets the library list.                           *
      *                                                               *
      *****************************************************************
     C     SRSetLibL     BEGSR
 
     C**********         EVAL      WPgm = PSysPrefix + 'XLIB/UPC0014'                         CSC043
     C                   EVAL      WPgm = PSysPrefix + 'XPLIB/UPC0014'                        CSC043
 
     C                   MONITOR
 
     C                   CALL      WPgm
     C                   PARM                    PSysPrefix
 
     C                   EVAL      PLogMsg = LOGMSG(1)
     C                   EXSR      SRWrtLog
 
     C                   ON-ERROR  *ALL
     C                   EVAL      PLogMsg = LOGMSG(2)
     C                   EXSR      *PSSR
     C                   ENDMON
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRKycUpd - Does KYC updates.                                 *
      *                                                               *
      *****************************************************************
     C     SRKycUpd      BEGSR
 
     C                   EVAL      PLogMsg = %TRIM(LOGMSG(3)) + ' ' +
     C                                       PSysPrefix + '.' + ' ' +
     C                                       %TRIM(LOGMSG(4)) + ' ' +
     C                                       PCustNumber + '.'
     C                   EXSR      SRWrtLog
 
     C                   MONITOR
 
     C                   CALL      'SDCKYCMUPD'
     C                   PARM                    PResult
     C                   PARM                    PSysPrefix
     C                   PARM                    PCustNumber
     C                   PARM                    PKycStatus
     C                   PARM                    PKycItems
 
     C                   EVAL      PLogMsg = LOGMSG(5)
     C                   EXSR      SRWrtLog
 
     C                   ON-ERROR  *ALL
     C                   EVAL      PLogType = '*ERROR'
     C                   EVAL      PLogMsg = LOGMSG(6)
     C                   EXSR      SRWrtLog
     C                   EXSR      SREndPgm
     C                   ENDMON
 
     C                   IF        PResult <> *BLANKS
     C                   EVAL      WResult = PResult
     C                   ELSE
     C                   EVAL      WResult = '*BLANKS'
     C                   ENDIF
 
     C                   EVAL      PLogMsg = LOGMSG(7)
     C                   EVAL      PLogMsg = %TRIM(PLogMsg) + ' ' +
     C                                       %TRIM(WResult) + '.'
     C                   EXSR      SRWrtLog
 
     C                   EVAL      PvchRslt = PResult
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRWrtLog - Writes to the KYC Log.                            *
      *                                                               *
      *****************************************************************
     C     SRWrtLog      BEGSR
 
     C                   CALL      'SD000054'
     C                   PARM      'GPKYCUPD'    PPgmName
     C                   PARM                    PLogType
     C                   PARM                    PLogMsg
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SREndPgm - Ends the program.                                 *
      *                                                               *
      *****************************************************************
     C     SREndPgm      BEGSR
 
     C                   EVAL      PLogMsg = LOGMSG(9)
     C                   EXSR      SRWrtLog
 
     C                   DUMP
 
     C                   EVAL      *INLR = *ON
     C                   RETURN
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *PSSR - Program exception subroutine.                        *
      *                                                               *
      *****************************************************************
     C     *PSSR         BEGSR
 
     C                   DUMP
 
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
 
     C                   RETURN
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *INZSR - Program initialisation subroutine.                  *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR
 
      ** Entry Parameters
 
     C     *ENTRY        PLIST
     C                   PARM                    PvchRslt
     C                   PARM                    PvchSysP
     C                   PARM                    PvchCNum
     C                   PARM                    PvchStat
     C                   PARM                    PvchItem
 
     C                   EVAL      PResult = PvchRslt
     C                   EVAL      PSysPrefix = PvchSysP
     C                   EVAL      PCustNumber = PvchCNum
     C                   EVAL      PKycStatus = PvchStat
     C                   EVAL      PKycItems = PvchItem
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
** CPY@
(c) Misys International Banking Systems Ltd. 2006
** LOGMSG
UPC0014 completed. Library list set.
UPC0014 failed. Library list not set.
System Prefix is
Customer Number is
SDCKYCMUPD completed.
SDCKYCMUPD failed.
Result (return value) is
GPKYCUPD completed.
GPKYCUPD failed.
GPKYCUPD terminated abnormally.
