     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2008')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD Validate Expiry Date')                        *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SDVEXPDT - Validate Expiry Date                              *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2008            *
      *                                                               *
      *  Last Amend No. CER059             Date 19Jul10               *
      *  Prev Amend No. BUG22863           Date 12Jan09               *
      *  Last Amend No. CER047  *CREATE    Date 19May08               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  BUG22863 - Expiry Date must be equal to or greater than      *
      *             system run date                                   *
      *  CER047 - German Features LF037-00 Reporting §24c KWG         *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      *  SRVexdt - Subroutine to validate Expiry Date                 *
      *  *INZSR - Initialisation Subroutine                           *
      *                                                               *
      *****************************************************************
      *
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      *
      * Midas SD Local Industry Codes
      * Hook to enable non-core files to be included
      /COPY WNCPYSRC,SDCUDPV001
      *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      *
      ** The following /COPY line includes (among others) the LDA
      ** layout and the copyright array definition:
      *
     D/COPY ZACPYSRC,STD_D_SPEC
      *
      ** The following /COPY includes the MM standard declares:
      *
     D/COPY ZACPYSRC,STDDECLARE
      *
      ** The following /COPY line includes all the defined fields in
      ** the Program Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'.
      *
     D/COPY ZACPYSRC,PSDS
      *
      ** The following /COPY line includes the definitions for error
      ** and warning message arrays.
      *
     D/COPY ZACPYSRC,ERR_ARRAYS
      *
      ** The following /COPY line includes all the definitions of the
      ** appended error arrays, including the named constant giving
      ** the size of the arrays.
      *
     D/COPY ZACPYSRC,ERR_XARRYS
      *
      ** +--------------------------------------+
      ** ¦ End of automatically included D-specs¦
      ** ¦ =====================================¦
      ** +--------------------------------------+
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +--------------------------------------+
      ** ¦ Manually included D-specs            ¦
      ** ¦ =========================            ¦
      ** +--------------------------------------+
      *
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
      *
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
      *
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
      *
      ** Parameters for *Entry
      *
     D PDateIn         S              6P 0
     D BjDFIn          S              1A
     D PDayNo          S              5P 0
      *
     D OKEXDT          S              1A
     D DDEXDT          S              8A
     D DateIn          S              6A                                                    BUG22863
     D DaynoOut        S              5P 0                                                  BUG22863
     D WDaynoOut       S              5P 0                                                  BUG22863
     D WDateOut        S              8A                                                    BUG22863
     D WDate1          S              4A                                                    BUG22863
     D WDate2          S              6A                                                    BUG22863
     D WDay            S              2A                                                    BUG22863
     D WNDay           S              2S 0                                                  BUG22863
     D WMonth          S              2A                                                    BUG22863
     D WNMonth         S              2S 0                                                  BUG22863
     D WYear           S              4A                                                    BUG22863
     D WYrNum          S              4S 0                                                  BUG22863
     D WNYear          S              2S 0                                                  BUG22863
     D WCentury        S              2S 0                                                  BUG22863
     D WrkYear         S              5S 0                                                  BUG22863
     D WLeapYear       S              5S 0                                                  BUG22863
     D WRemLeapY       S              1S 0                                                  BUG22863
     D WDayMon         S              4A                                                    BUG22863
      *
     D Idx             S              3  0
     D WIdx            S              3P 0                                                  BUG22863
      *
     D ERrorFlg        S              7A
      *
     D BjRDNb          S              5P 0
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *
      ** +----------------------------------------+
      ** ¦ Hook for non-core D-specs (all types)  ¦
      ** ¦ also any I-specs (if necessary)        ¦
      ** ¦ =====================================  ¦
      ** +----------------------------------------+
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *inzsr is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
      *
     C                   CLEAR                   RetCodeIn
      *
     C                   EVAL      FldNamXAr = *BLANKS
     C                   EVAL      MsgIDXAr = *BLANKS
     C                   EVAL      MsgDtaXAr = *BLANKS
     C                   EVAL      Idx = *ZERO
     C                   EVAL      WDaynoOut = *ZEROS                                       BUG22863
     C                   EVAL      DaynoOut = *ZEROS                                        BUG22863
     C                   EVAL      ERrorFlg  = *BLANKS                                      BUG22863
     C                   EVAL      WDateOut = *BLANKS                                       BUG22863
      *
      ** Validation
      *
     C                   EXSR      SRVexdt
      *
      ** If an error was found, set the return code appropriately
      *
     C                   IF        OKEXDT = 'N'
      *
     C                   EVAL      RetCodeIn = 'Error'
      *
     C                   ENDIF
      *
      ** Return
      *
     C                   RETURN
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRVexdt - Subroutine to validate Expiry Date                  *
      *                                                               *
      * Called By - Main Processing                                   *
      *                                                               *
      * Calls - None                                                  *
      *****************************************************************
      *
     C     SRVexdt       BEGSR
      *
     C**********         CLEAR                   ERrorFlg                                   BUG22863
     C**********         CLEAR                   PDateIn                                    BUG22863
      *
      ** Expiry Date should be numeric                                                      BUG22863
      *                                                                                     BUG22863
     C                   IF        DDEXDT <> *BLANKS
     C                   EVAL      WIdx = %Check('0123456789':DDEXDT)                       BUG22863
                                                                                            BUG22863
     C                   IF        WIdx <> 0                                                BUG22863
                                                                                            BUG22863
     C                   EVAL      OKEXDT = 'N'                                             BUG22863
     C                   EVAL      Idx = Idx + 1                                            BUG22863
     C                   EVAL      FldNamXAr(Idx) = 'DDEXDT'                                BUG22863
     C                   EVAL      MsgIDXAr(Idx) = 'USR5918'                                BUG22863
     C                   LEAVESR                                                            BUG22863
      *                                                                                     BUG22863
     C                   ENDIF                                                              BUG22863
      *                                                                                     BUG22863
     C                   ENDIF                                                              BUG22863
      *                                                                                     BUG22863
      ** If Expiry Date must be in correct format                                           BUG22863
      *                                                                                     BUG22863
     C                   IF        DDEXDT <> *Blanks                                        BUG22863
      *                                                                                     BUG22863
      ** Split date into day, month and year; then convert to numeric                       BUG22863
      *                                                                                     BUG22863
     C                   MOVEL     DDEXDT        WDate1                                     BUG22863
     C                   MOVE      WDate1        WMonth                                     BUG22863
     C                   MOVEL     WDate1        WDay                                       BUG22863
      *                                                                                     BUG22863
     C                   MOVE      DDEXDT        WYear                                      BUG22863
     C                   MOVEL     WYear         WCentury                                   BUG22863
     C                   MOVEL     WDay          WNDay                                      BUG22863
     C                   MOVEL     WMonth        WNMonth                                    BUG22863
      *                                                                                     BUG22863
     C                   IF        BJDFIN = 'M'                                             BUG22863
      *                                                                                     BUG22863
     C                   MOVEL     WMonth        WDayMon                                    BUG22863
     C                   MOVE      WDay          WDayMon                                    BUG22863
     C                   ELSE                                                               BUG22863
     C                   MOVEL     WDay          WDayMon                                    BUG22863
     C                   MOVE      WMonth        WDayMon                                    BUG22863
      *                                                                                     BUG22863
     C                   ENDIF                                                              BUG22863
      *                                                                                     BUG22863
     C                   MOVE      WYear         WNYear                                     BUG22863
      *                                                                                     BUG22863
     C                   MOVEL     WDayMon       WDate2                                     BUG22863
     C                   MOVE      WNYear        WDate2                                     BUG22863
      *                                                                                     BUG22863
      ** Validate of values outside of range                                                BUG22863
      *                                                                                     BUG22863
     C                   IF        WNDay > 31  OR                                           BUG22863
     C                             WNDay <= 0  OR                                           BUG22863
     C                             WNMonth > 12 OR                                          BUG22863
     C                             WNMonth <= 0 OR                                          BUG22863
     C                             WCentury < 19 OR                                         BUG22863
     C                             WCentury > 20                                            BUG22863
      *                                                                                     BUG22863
     C                   EVAL      OKEXDT = 'N'                                             BUG22863
     C                   EVAL      Idx = Idx + 1                                            BUG22863
     C                   EVAL      FldNamXAr(Idx) = 'DDEXDT'                                BUG22863
     C                   EVAL      MsgIDXAr(Idx) = 'USR5918'                                BUG22863
     C                   LEAVESR                                                            BUG22863
      *                                                                                     BUG22863
     C                   ENDIF                                                              BUG22863
      *                                                                                     BUG22863
      ** Validate day for 30-day month                                                      BUG22863
      *                                                                                     BUG22863
     C                   IF        WNMonth = 4  OR                                          BUG22863
     C                             WNMonth = 6  OR                                          BUG22863
     C                             WNMonth = 9  OR                                          BUG22863
     C                             WNMonth = 11                                             BUG22863
      *                                                                                     BUG22863
     C                   IF        WNDay > 30                                               BUG22863
      *                                                                                     BUG22863
     C                   EVAL      OKEXDT = 'N'                                             BUG22863
     C                   EVAL      Idx = Idx + 1                                            BUG22863
     C                   EVAL      FldNamXAr(Idx) = 'DDEXDT'                                BUG22863
     C                   EVAL      MsgIDXAr(Idx) = 'USR5918'                                BUG22863
     C                   LEAVESR                                                            BUG22863
      *                                                                                     BUG22863
     C                   ENDIF                                                              BUG22863
      *                                                                                     BUG22863
     C                   ENDIF                                                              BUG22863
      *                                                                                     BUG22863
      ** Validate the leap year                                                             BUG22863
      *                                                                                     BUG22863
     C                   EVAL      WrkYear = WNYear + 28                                    BUG22863
     C     WrkYear       DIV       4             WLeapYear                                  BUG22863
     C                   MVR                     WRemLeapY                                  BUG22863
      *                                                                                     BUG22863
     C                   IF        WNMonth = 2                                              BUG22863
      *                                                                                     BUG22863
     C                   IF        WRemLeapY >  0  AND                                      BUG22863
     C                             WNDay > 28  OR                                           BUG22863
     C                             WRemLeapY =  0  AND                                      BUG22863
     C                             WNDay > 29                                               BUG22863
      *                                                                                     BUG22863
     C                   EVAL      OKEXDT = 'N'                                             BUG22863
     C                   EVAL      Idx = Idx + 1                                            BUG22863
     C                   EVAL      FldNamXAr(Idx) = 'DDEXDT'                                BUG22863
     C                   EVAL      MsgIDXAr(Idx) = 'USR5918'                                BUG22863
     C                   LEAVESR                                                            BUG22863
      *                                                                                     BUG22863
     C                   ENDIF                                                              BUG22863
      *                                                                                     BUG22863
     C                   ENDIF                                                              BUG22863
      *                                                                                     BUG22863
     C**********         MOVEL     DDEXDT        PDateIn                                    BUG22863
     C*                  EVAL      PDateIn = %INT(DDEXDT)
      *
     C**********         CALL      'ZDATE1'                                                 BUG22863
     C                   CALLB     'ZDATE1'                                                 BUG22863
      *                                                                                     BUG22863
     C**********         PARM                    ERrorFlg                                   BUG22863
     C**********         PARM                    PDateIn                                    BUG22863
     C**********         PARM                    BjDFIn                                     BUG22863
     C**********         PARM      *ZEROS        PDayno                                     BUG22863
      *
     C                   PARM      WDate2        DateIn                                     BUG22863
     C                   PARM                    DaynoOut                                   BUG22863
     C                   PARM                    BJDFIN                                     BUG22863
     C                   PARM                    ERrorFlg                                   BUG22863
      *                                                                                     BUG22863
     C                   IF        ERrorFlg = '*ERROR*'
      *
     C                   EVAL      OKEXDT = 'N'
      *
     C                   EVAL      Idx = Idx + 1
      *
     C                   EVAL      FldNamXAr(Idx) = 'DDEXDT'
     C**********         EVAL      MsgIdXAr(Idx) = 'USR8083'                                BUG22863
     C                   EVAL      MsgIDXAr(Idx) = 'USR5918'                                BUG22863
     C                   LEAVESR                                                            BUG22863
      *
     C                   ENDIF
      *                                                                                     BUG22863
     C                   ENDIF                                                              BUG22863
      *
     C**********         IF        PDayno > BjRDNb                                          BUG22863
      *
      ** Expiry Date must be after the Rundate                                              BUG22863
      *                                                                                     BUG22863
     C                   MOVEL     WYear         WYrNum                                     BUG22863
     C                   IF        WYrNum >= 1972                                           BUG22863
      *                                                                                     BUG22863
     C                   IF        DDEXDT <> *Blanks  AND                                   BUG22863
     C                             DaynoOut < BJRDNB                                        BUG22863
      *                                                                                     BUG22863
     C                   EVAL      OKEXDT = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNamXAr(Idx) = 'DDEXDT'
     C**********         EVAL      MsgIdXAr(Idx) = 'USR8084'                                BUG22863
     C                   EVAL      MsgIDXAr(Idx) = 'USR5919'                                BUG22863
     C                   LEAVESR                                                            BUG22863
      *
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   EVAL      WDaynoOut = DaynoOut                                     BUG22863
     C                   EVAL      WDateOut = DDEXDT                                        BUG22863
      *                                                                                     BUG22863
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      * Called By - Main Processing                                   *
      *                                                               *
      * Calls - None                                                  *
      *****************************************************************
     C     *INZSR        BEGSR
      *
     C     *ENTRY        PLIST
      *
     C                   PARM                    RetCodeOut
     C                   PARM                    DDEXDT
     C                   PARM                    BjRDNb
     C                   PARM                    BjDFIn
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
     C                   PARM                    OKEXDT
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2008
