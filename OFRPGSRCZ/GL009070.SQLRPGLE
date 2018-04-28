     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2014')
      *****************************************************************
/*STD *  RPGSQLBND                                                    *
/*EXI *  TEXT('Midas OF Update Nostro Group Totals (Trigger Pgm)')
      *****************************************************************
      *                                                               *
      *  Midas - General Ledger Module                                *
      *                                                               *
      *  GL009070 - Nostro Group totals Triggers                      *
      *                                                               *
      *  Function:  This program sends triggers to the Data Queue     *
      *             when files involved in the Nostro Group Total     *
      *             calculations are amended.                         *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2014            *
      *                                                               *
      *  Last Amend No. MD027208B          Date 03Jun14               *
      *  Prev Amend No. MD027224           Date 28May14               *
      *                 CGL155  *Create    Date 24Mar14               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD027208B - GLRTNOTD not updated by the time totals are      *
      *              calculated                                       *
      *  MD027224 - Use Total forecast instead of o/s forecast in     *
      *             calculation of Nostro Group Totals                *
      *  CGL155 - Forecast Group Limits                               *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *    70         Error On Call                                   *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      * *PSSR      - Error processing                                 *
      * *INZSR     - Initialise                                       *
      * SrACCNTAB - Process ACCNTAB record                            *
      * SrPRONOPN - Process PRONOPN record                            *
      * SrSDNOSTPD - Process SDNOSTPD record                          *
      * SrSDCURRPD - Process SDCURRPD record                          *
      * SrGLTNOSTD - Process GLTNOSTD record                          *
      * SrSDNGLHTD - Process SDNGLHTD record                          *
      * SrGLFORTTD - Process GLFORTTD record                          *                     MD027224
      * SrReset    - Initialize                                       *
      * SrSendDtaQ - Send data to data queue                          *
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
      ** +--------------------------------------+
      ** ¦ D-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
     D LDA           E DS           256    EXTNAME(LDA)
      ** Local data area for database error details
      ** *LOCK IN LDA immediately before and OUT LDA immediately
      ** after each database error handling.
      **
      **                                    134 141 DBFILE
      **       Defines:                     142 170 DBKEY
      **                                    171 180 DBPGM
      **                                    181 1830DBASE
 
     D RUNDAT        E DS                  EXTNAME(RUNDAT)
      ** Data Area giving Installation Control Details
 
     D SDSTAT        E DS                  EXTNAME(SDSTAT)
      ** Data Area for Standing Data Details
 
     D RsaBeforeImg  E DS                  EXTNAME(RSACMTPD) PREFIX(B_)
      **  External DS for Before Image RSACMTPD
 
     D RsaAfterImg   E DS                  EXTNAME(RSACMTPD) PREFIX(A_)
      **  External DS for After Image RSACMTPD
 
     D RSACW1        E DS                  EXTNAME(GLRSACMW1)
      **  External DS for GLRSACMW1
 
     D/COPY ZACPYSRC,PSDS
      ** The following /COPY line includes all the defined fields in the
      ** Program Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'.
 
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
     D PARM1           DS
      ** First entry parameter
 
     D  PFlName                1     10
      ** Physical file name
 
     D  MbrName               21     30
      ** Member name
 
     D  TrgEvent              31     31
      ** Trigger event 1=Insert, 2=Delete, 3=Update, 4=Read
 
     D  TrgTime               32     32
      ** Trigger time  1=After, 2=Before
 
     D  BOff                  49     52B 0
      ** Offset to the before image of the record
 
     D  BLen                  53     56B 0
      ** Length of the before image of the record
 
     D  AOff                  65     68B 0
      ** Offset to the after image of the record
 
     D  ALen                  69     72B 0
      ** Length of the after image of the record
 
     D  EntryData            117  10117A
      ** Images
 
     D PARM2           DS
      ** Second entry parameter
 
     D  Leng                   1      4B 0
 
     D FGLData         DS
 
      ** Event Type
 
     D  WEventType             1     20
     D  WTrigEvent            21     21
 
      ** Event Detail
 
     D  WDetail               22   4021
     D  WAfter                22   2021
     D  WBefore             2022   4021
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
     D AfterImg        S           2000A
     D BeforeImg       S           2000A
     D DtqLen          S              5P 0
     D DtqLib          S             10A
     D DtqNam          S             10A
     D Offset          S              5P 0
     D WRun            S              1
     D WLength         S              4S 0
     D UpdRSAC         S              1
     D RsacAft         S              1
     D RsacBef         S              1
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
 
      ** Retrieve before/after image from PARM1 using length and offset
 
     C                   EVAL      OffSet = BOff + 1
     C     BLen          SUBST     PARM1:OffSet  BeforeImg
 
     C                   EVAL      OffSet = AOff + 1
     C     ALen          SUBST     PARM1:OffSet  AfterImg
 
      ** Call the appropriate subroutine, based on received physical file
 
     C                   SELECT
 
     C                   WHEN      PFlName = 'ACCNTAB'
     C                   EXSR      SrACCNTAB
 
     C                   WHEN      PFlName = 'PRONOPN'
     C                   EXSR      SrPRONOPN
 
     C                   WHEN      PFlName = 'SDNOSTPD'
     C                   EXSR      SrSDNOSTPD
 
     C                   WHEN      PFlName = 'SDCURRPD'
     C                   EXSR      SrSDCURRPD
 
     C**********         WHEN      PFlName = 'GLTNOSTD'                                     MD027224
     C**********         EXSR      SrGLTNOSTD                                               MD027224
 
     C                   WHEN      PFlName = 'GLFORTTD'                                     MD027224
     C                   EXSR      SrGLFORTTD                                               MD027224
 
     C                   WHEN      PFlName = 'SDNGLHTD'
     C                   EXSR      SrSDNGLHTD
 
     C                   WHEN      PFlName = 'RSACMTPD'
     C                   EXSR      SrRSACMTPD
                                                                                           MD027208B
     C                   WHEN      PFlName = 'GLRTNOTD'                                    MD027208B
     C                   EXSR      SrGLRTNOTD                                              MD027208B
 
     C                   ENDSL
 
      ** Send FGLData to CGLFORIQ data queue
 
     C                   IF        FGLData <> *BLANKS
     C                   EXSR      SrSendDtaQ
     C                   ENDIF
 
      ** Terminate Program
 
     C                   EVAL      *INLR = *ON
     C                   RETURN
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrACCNTAB  - Process ACCNTAB record                           *
      *                                                               *
      * Called by: Main program                                       *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     SrACCNTAB     BEGSR
 
     C                   EXSR      SrReset
 
      ** Trigger event is Update Or Delete.
 
     C                   IF        TrgEvent = '2' OR TrgEvent = '3'
     C                   EVAL      WEventType = 'MNT_ACCNTAB'
     C                   EVAL      WAfter = AfterImg
     C                   EVAL      WBefore = BeforeImg
     C                   EVAL      WTrigEvent = TrgEvent
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrPRONOPN  - Process PRONOPN record                           *
      *                                                               *
      * Called by: Main program                                       *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     SrPRONOPN     BEGSR
 
     C                   EXSR      SrReset
 
      ** Trigger event is Update Or Delete.
 
     C                   IF        TrgEvent = '2' OR TrgEvent = '3'
     C                   EVAL      WEventType = 'MNT_PRONOPN'
     C                   EVAL      WAfter = AfterImg
     C                   EVAL      WBefore = BeforeImg
     C                   EVAL      WTrigEvent = TrgEvent
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrSDNOSTPD - Process SDNOSTPD record                          *
      *                                                               *
      * Called by: Main program                                       *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     SrSDNOSTPD    BEGSR
 
     C                   EXSR      SrReset
 
      ** Trigger event is Update Or Delete.
 
     C                   IF        TrgEvent = '2' OR TrgEvent = '3'
     C                   EVAL      WEventType = 'MNT_SDNOSTPD'
     C                   EVAL      WAfter = AfterImg
     C                   EVAL      WBefore = BeforeImg
     C                   EVAL      WTrigEvent = TrgEvent
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrSDCURRPD - Process SDCURRPD record                          *
      *                                                               *
      * Called by: Main program                                       *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     SrSDCURRPD    BEGSR
 
     C                   EXSR      SrReset
 
      ** Trigger event is Update Or Delete.
 
     C                   IF        TrgEvent = '2' OR TrgEvent = '3'
     C                   EVAL      WEventType = 'MNT_SDCURRPD'
     C                   EVAL      WAfter = AfterImg
     C                   EVAL      WBefore = BeforeImg
     C                   EVAL      WTrigEvent = TrgEvent
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      **SrGLTNOSTD-*Process*GLTNOSTD*record****************************                     MD027224
      * SrGLFORTTD - Process GLFORTTD record                          *                     MD027224
      *                                                               *
      * Called by: Main program                                       *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C*****SrGLTNOSTD    BEGSR                                                              MD027224
     C     SrGLFORTTD    BEGSR                                                              MD027224
 
     C                   EXSR      SrReset
 
      ** Trigger event is Insert.
 
     C                   IF        TrgEvent = '1'
     C**********         EVAL      WEventType = 'MNT_GLTNOSTD'                              MD027224
     C                   EVAL      WEventType = 'MNT_GLFORTTD'                              MD027224
     C                   EVAL      WAfter = AfterImg
     C                   EVAL      WBefore = *BLANKS
     C                   EVAL      WTrigEvent = TrgEvent
     C                   ENDIF
 
      ** Trigger event is Update Or Delete.
 
     C                   IF        TrgEvent = '2' OR TrgEvent = '3'
     C**********         EVAL      WEventType = 'MNT_GLTNOSTD'                              MD027224
     C                   EVAL      WEventType = 'MNT_GLFORTTD'                              MD027224
     C                   EVAL      WAfter = AfterImg
     C                   EVAL      WBefore = BeforeImg
     C                   EVAL      WTrigEvent = TrgEvent
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrSDNGLHTD- Process SDNGLHTD record                           *
      *                                                               *
      * Called by: Main program                                       *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     SrSDNGLHTD    BEGSR
 
     C                   EXSR      SrReset
 
      ** Trigger event is Insert.
 
     C                   IF        TrgEvent = '1'
     C                   EVAL      WEventType = 'MNT_SDNGLHTD'
     C                   EVAL      WAfter = AfterImg
     C                   EVAL      WBefore = *BLANKS
     C                   EVAL      WTrigEvent = TrgEvent
     C                   ENDIF
 
      ** Trigger event is Update Or Delete.
 
     C                   IF        TrgEvent = '2' OR TrgEvent = '3'
     C                   EVAL      WEventType = 'MNT_SDNGLHTD'
     C                   EVAL      WAfter = AfterImg
     C                   EVAL      WBefore = BeforeImg
     C                   EVAL      WTrigEvent = TrgEvent
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrRSACMTPD- Process RSACMTPD record                           *
      *                                                               *
      * Called by: Main program                                       *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     SrRSACMTPD    BEGSR
 
     C                   EXSR      SrReset
 
     C                   eval      UpdRSAC = *Blanks
     C                   eval      RsacAft = *Blanks
     C                   eval      RsacBef = *Blanks
     C                   clear                   RsaBeforeImg
     C                   clear                   RsaAfterImg
 
      ** Trigger event is Insert.
 
     C                   If        TrgEvent = '1'
     C                   eval      RsaAfterImg = AfterImg
 
     C/exec SQL
     C+ declare LISTA cursor for
     C+ SELECT * from GLRSACMW1
     C+ where
     C+       BRCA = :A_BRCA
     C+   and CUSN = :A_CUSN
     C+   and CCYD = :A_CCYD
     C+   and ACDE = :A_ACDE
     C+   and ASNC = :A_ASNC
     C/end-exec
 
     C/exec SQL
     C+ open LISTA
     C/end-exec
 
      ** Handle SQL Error (if not %EOF)
     C                   If        SQLCOD < 0
     C     *LOCK         IN        LDA
     C                   EVAL      DBASE = 1
     C                   EVAL      DBFILE = 'SQL STM'
     C                   EVAL      DBKEY = 'SQLSTT : ' + SQLSTT
     C                                   + ';  SQLCOD : ' + %char(SQLCOD)
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   EndIf
 
     C/exec SQL
     C+ fetch next
     C+ from LISTA
     C+ into :RSACW1
     C/end-exec
 
     C                   If        SQLCode <> 100
     C                   eval      UpdRsac = 'Y'
     C                   Endif
 
     C/exec SQL
     C+ close LISTA
     C/end-exec
 
     C                   Endif
 
      ** Trigger event is Update or Delete
 
     C                   If        TrgEvent = '2' OR TrgEvent = '3'
 
     C                   eval      RsaBeforeImg = BeforeImg
     C     AfterImg      Ifne      *Blanks
     C                   eval      RsaAfterImg = AfterImg
     C                   Endif
 
     C                   If        B_BRCA <> A_BRCA or
     C                             B_CUSN <> A_CUSN or
     C                             B_CCYD <> A_CCYD or
     C                             B_ACDE <> A_ACDE or
     C                             B_ASNC <> A_ASNC
 
     C/exec SQL
     C+ declare LISTB cursor for
     C+ SELECT * from GLRSACMW1
     C+ where
     C+       BRCA = :B_BRCA
     C+   and CUSN = :B_CUSN
     C+   and CCYD = :B_CCYD
     C+   and ACDE = :B_ACDE
     C+   and ASNC = :B_ASNC
     C/end-exec
 
     C/exec SQL
     C+ open LISTB
     C/end-exec
 
      ** Handle SQL Error (if not %EOF)
     C                   If        SQLCOD < 0
     C     *LOCK         IN        LDA
     C                   EVAL      DBASE = 2
     C                   EVAL      DBFILE = 'SQL STM'
     C                   EVAL      DBKEY = 'SQLSTT : ' + SQLSTT
     C                                   + ';  SQLCOD : ' + %char(SQLCOD)
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   EndIf
 
     C/exec SQL
     C+ fetch next
     C+ from LISTB
     C+ into :RSACW1
     C/end-exec
 
     C                   If        SQLCode <> 100
     C                   eval      UpdRsac = 'Y'
     C                   eval      RsacBef = 'Y'
     C                   Endif
 
     C/exec SQL
     C+ close LISTB
     C/end-exec
 
     C/exec SQL
     C+ declare LISTC cursor for
     C+ SELECT * from GLRSACMW1
     C+ where
     C+       BRCA = :A_BRCA
     C+   and CUSN = :A_CUSN
     C+   and CCYD = :A_CCYD
     C+   and ACDE = :A_ACDE
     C+   and ASNC = :A_ASNC
     C/end-exec
 
     C/exec SQL
     C+ open LISTC
     C/end-exec
 
      ** Handle SQL Error (if not %EOF)
     C                   If        SQLCOD < 0
     C     *LOCK         IN        LDA
     C                   EVAL      DBASE = 3
     C                   EVAL      DBFILE = 'SQL STM'
     C                   EVAL      DBKEY = 'SQLSTT : ' + SQLSTT
     C                                   + ';  SQLCOD : ' + %char(SQLCOD)
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   EndIf
 
     C/exec SQL
     C+ fetch next
     C+ from LISTC
     C+ into :RSACW1
     C/end-exec
 
     C                   If        SQLCode <> 100
     C                   eval      UpdRsac = 'Y'
     C                   eval      RsacAft = 'Y'
     C                   Endif
 
     C/exec SQL
     C+ close LISTC
     C/end-exec
 
     C                   else
 
     C/exec SQL
     C+ declare LISTD cursor for
     C+ SELECT * from GLRSACMW1
     C+ where
     C+       BRCA = :B_BRCA
     C+   and CUSN = :B_CUSN
     C+   and CCYD = :B_CCYD
     C+   and ACDE = :B_ACDE
     C+   and ASNC = :B_ASNC
     C/end-exec
 
     C/exec SQL
     C+ open LISTD
     C/end-exec
 
      ** Handle SQL Error (if not %EOF)
     C                   If        SQLCOD < 0
     C     *LOCK         IN        LDA
     C                   EVAL      DBASE = 4
     C                   EVAL      DBFILE = 'SQL STM'
     C                   EVAL      DBKEY = 'SQLSTT : ' + SQLSTT
     C                                   + ';  SQLCOD : ' + %char(SQLCOD)
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   EndIf
 
     C/exec SQL
     C+ fetch next
     C+ from LISTD
     C+ into :RSACW1
     C/end-exec
 
     C                   If        SQLCode <> 100
     C                   eval      UpdRsac = 'Y'
     C                   eval      RsacBef = 'Y'
     C                   Endif
 
     C/exec SQL
     C+ close LISTD
     C/end-exec
 
     C                   Endif
 
     C                   Endif
 
 
      ** Trigger event is Insert.
     C     UpdRSAC       Ifeq      'Y'
 
     C                   IF        TrgEvent = '1'
     C                   EVAL      WEventType = 'MNT_RSACMTPD_AFTER'
     C                   EVAL      WAfter = AfterImg
     C                   EVAL      WBefore = *BLANKS
     C                   EVAL      WTrigEvent = TrgEvent
     C                   ENDIF
 
      ** Trigger event is Update Or Delete.
 
     C                   IF        TrgEvent = '2' OR TrgEvent = '3'
     C                   If        RsacBef = 'Y' and RsacAft = 'Y'
     C                   EVAL      WEventType = 'MNT_RSACMTPD_BOTH'
     C                   else
     C                   If        RsacBef = 'Y'
     C                   EVAL      WEventType = 'MNT_RSACMTPD_BEFORE'
     C                   Endif
     C                   If        RsacAft = 'Y'
     C                   EVAL      WEventType = 'MNT_RSACMTPD_AFTER'
     C                   Endif
     C                   Endif
     C                   EVAL      WAfter = AfterImg
     C                   EVAL      WBefore = BeforeImg
     C                   EVAL      WTrigEvent = TrgEvent
     C                   ENDIF
 
     C                   Endif
 
     C                   ENDSR
                                                                                          MD027208B
      *****************************************************************                   MD027208B
      /EJECT                                                                              MD027208B
      *****************************************************************                   MD027208B
      *                                                               *                   MD027208B
      * SrGLRTNOTD- Process GLRTNOTD record                           *                   MD027208B
      *                                                               *                   MD027208B
      * Called by: Main program                                       *                   MD027208B
      *                                                               *                   MD027208B
      * Calls: None                                                   *                   MD027208B
      *                                                               *                   MD027208B
      *****************************************************************                   MD027208B
                                                                                          MD027208B
     C     SrGLRTNOTD    BEGSR                                                            MD027208B
                                                                                          MD027208B
     C                   EXSR      SrReset                                                MD027208B
                                                                                          MD027208B
      ** Trigger event is Insert.                                                         MD027208B
                                                                                          MD027208B
     C                   IF        TrgEvent = '1'                                         MD027208B
     C                   EVAL      WEventType = 'MNT_GLRTNOTD'                            MD027208B
     C                   EVAL      WAfter = AfterImg                                      MD027208B
     C                   EVAL      WBefore = *BLANKS                                      MD027208B
     C                   EVAL      WTrigEvent = TrgEvent                                  MD027208B
     C                   ENDIF                                                            MD027208B
                                                                                          MD027208B
      ** Trigger event is Update Or Delete.                                               MD027208B
                                                                                          MD027208B
     C                   IF        TrgEvent = '2' OR TrgEvent = '3'                       MD027208B
     C                   EVAL      WEventType = 'MNT_GLRTNOTD'                            MD027208B
     C                   EVAL      WAfter = AfterImg                                      MD027208B
     C                   EVAL      WBefore = BeforeImg                                    MD027208B
     C                   EVAL      WTrigEvent = TrgEvent                                  MD027208B
     C                   ENDIF                                                            MD027208B
                                                                                          MD027208B
     C                   ENDSR                                                            MD027208B
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrReset - Initialize                                          *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     SrReset       BEGSR
 
     C                   CLEAR                   FGLData
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrSendDtaQ - Send data to data queue                          *
      *                                                               *
      * Called by: Main program                                       *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     SrSendDtaQ    BEGSR
 
      ** Find the first non-blank position starting from the right
      ** Result field would contain the position relative to the left
 
     C     ' '           CHECKR    FGLData       WLength
 
     C                   CALL      'QSNDDTAQ'
     C                   PARM      'CGLFORIQ'    DtqNam
     C                   PARM                    DtqLib
     C                   PARM      WLength       DtqLen
     C                   PARM                    FGLData
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      * *INZSR - Program Initialisation routine                       *
      *****************************************************************
 
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
     C                   PARM                    PARM1
     C                   PARM                    PARM2
 
      ** Read in data areas
 
     C     *DTAARA       DEFINE                  RUNDAT
     C     *DTAARA       DEFINE                  LDA
     C     *DTAARA       DEFINE                  SDSTAT
     C                   IN        RUNDAT
     C                   IN        SDSTAT
 
     C                   EVAL      DtqLib = LIBR + 'DPLIB'
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
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
 
     C                   IF        WRun = *BLANKS
     C                   EVAL      WRun = 'Y'
     C                   DUMP
     C                   ENDIF
 
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN
 
     C                   ENDSR
 
      *****************************************************************
