     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2010')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas RE Account Balance Check Data File Triggers')    *
      *****************************************************************
      *                                                               *
      *  Midas - Retail Module                                        *
      *                                                               *
      *  REABCTRIG - Account Balance Check Data File Triggers         *
      *                                                               *
      *  Function:  This program sends triggers to the Data Queue     *
      *             when GL Account Movements file has been written   *
      *             to and can be amended to handle update of records *
      *             in RSACMTPD.                                      *
      *                                                               *
      *  (c) Finastra International Limited 2010                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. AR958145           Date 26Apr12               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      *                 CAP205  *CREATE    Date 15Feb10               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  AR958145 - ABC First day processing enhancement              *
      *           - Applied fix for AR975746                          *
      *  CAP205 - Teller Related APIs - Account Balance Check         *
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
      * SrRSACMTPD - Process RSACMTPD record                          *
      * SrReset    - Initialize                                       *
      * SrSendDtaQ - Send ABCData to data queue                       *
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
 
     D ABCData         DS
 
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
 
     C                   WHEN      PFlName = 'RSACMTPD'
     C                   EXSR      SrRSACMTPD
 
     C                   WHEN      PFlName = 'HELDIHB'
     C                   EXSR      SrHELDIHB
 
     C                   WHEN      PFlName = 'GLCOLLPD'
     C                   EXSR      SrGLCOLLPD
 
     C                   WHEN      PFlName = 'ACCNTAB'
     C                   EXSR      SrACCNTAB
 
     C                   ENDSL
 
      ** Send ABCData to CREABC data queue
 
     C                   IF        ABCData <> *BLANKS
     C                   EXSR      SrSendDtaQ
     C                   ENDIF
 
      ** Terminate Program
 
     C                   EVAL      *INLR = *ON
     C                   RETURN
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrRSACMTPD - Process RSACMTPD record                          *
      *                                                               *
      * Called by: Main program                                       *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     SrRSACMTPD    BEGSR
 
     C                   EXSR      SrReset
 
      ** Trigger event is Insert
 
     C                   IF        TrgEvent = '1'
     C                   EVAL      WEventType = 'TRAN_RSACMTPD'
     C                   EVAL      WDetail = AfterImg
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrHELDIHB - Process Held Items                                *
      *                                                               *
      * Called by: Main program                                       *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     SrHELDIHB     BEGSR
 
     C                   EXSR      SrReset
 
      ** Trigger event is Insert.
 
     C                   IF        TrgEvent = '1'
     C                   EVAL      WEventType = 'MNT_HELDIHB'
     C                   EVAL      WAfter = AfterImg
     C                   EVAL      WBefore = *BLANKS
     C                   EVAL      WTrigEvent = TrgEvent
     C                   ENDIF
 
      ** Trigger event is Update Or Delete.
 
     C                   IF        TrgEvent = '2' OR TrgEvent = '3'
     C                   EVAL      WEventType = 'MNT_HELDIHB'
     C                   EVAL      WAfter = AfterImg
     C                   EVAL      WBefore = BeforeImg
     C                   EVAL      WTrigEvent = TrgEvent
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrGLCOLLPD - Process GLCOLLPD record                          *
      *                                                               *
      * Called by: Main program                                       *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     SrGLCOLLPD    BEGSR
 
     C                   EXSR      SrReset
 
     C                   IF        TrgEvent = '1'
     C                   EVAL      WEventType = 'MNT_GLCOLLPD'
     C                   EVAL      WAfter = AfterImg
     C                   EVAL      WBefore = *BLANKS
     C                   EVAL      WTrigEvent = TrgEvent
     C                   ENDIF
 
     C                   IF        TrgEvent = '3'
     C                   EVAL      WEventType = 'MNT_GLCOLLPD'
     C                   EVAL      WAfter = AfterImg
     C                   EVAL      WBefore = BeforeImg
     C                   EVAL      WTrigEvent = TrgEvent
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrACCNTAB - Process ACCNTAB record                            *
      *                                                               *
      * Called by: Main program                                       *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     SrACCNTAB     BEGSR
 
     C                   EXSR      SrReset
 
      ** Trigger event is Update
 
     C                   IF        TrgEvent = '3'
     C                   EVAL      WEventType = 'MNT_ACCNTAB'
     C                   EVAL      WAfter = AfterImg
     C                   EVAL      WBefore = BeforeImg
     C                   EVAL      WTrigEvent = TrgEvent
     C                   ENDIF
                                                                                            AR958145
      ** Trigger event is Insert                                                            AR958145
                                                                                            AR958145
     C                   IF        TrgEvent = '1'                                           AR958145
     C                   EVAL      WEventType = 'MNT_ACCNTAB'                               AR958145
     C                   EVAL      WAfter = AfterImg                                        AR958145
     C                   EVAL      WBefore = *Blanks                                        AR958145
     C                   EVAL      WTrigEvent = TrgEvent                                    AR958145
     C                   ENDIF                                                              AR958145
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrReset - Initialize                                          *
      *                                                               *
      * Called by: SrRSACMTPD                                         *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     SrReset       BEGSR
 
     C                   CLEAR                   ABCData
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrSendDtaQ - Send ABCData to data queue                       *
      *                                                               *
      * Called by: Main program                                       *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     SrSendDtaQ    BEGSR
 
      ** Find the first non-blank position starting from the right
      ** Result field would contain the position relative to the left
 
     C     ' '           CHECKR    ABCData       WLength
 
     C                   CALL      'QSNDDTAQ'
     C                   PARM      'CREABCQ'     DtqNam
     C                   PARM                    DtqLib
     C                   PARM      WLength       DtqLen
     C                   PARM                    ABCData
 
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
     C                   CALL      'DBERRCTL'
     C                   ENDIF
 
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN
 
     C                   ENDSR
 
      *****************************************************************
