     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2016')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas SD CRS High Value A/C Identif. Maintenance')     *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SD000313 - Midas SD CRS High Value Account Identification    *
      *             Maintenance                                       *
      *                                                               *
      *  Function:  This program is used for the maintenance of       *
      *             the CRS High Value Account Identification         *
      *             File                                              *
      *                                                               *
      *  Called By: SD000311 - MIDAS SD CRS High Value Account        *
      *                        Identification Subfile                 *
      *                                                               *
      *  (c) Finastra International Limited 2016                      *
      *                                                               *
      *  Last Amend No. CGL177  *CREATE    Date 11Jan16               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CGL177 - CRS Reporting Phase 2                               *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use Of Indicators.                                           *
      *                                                               *
      *    03 - Exit                                                  *
      *    10 - Delete Record                                         *
      *    12 - Cancel                                                *
      *    24 - Footer                                                *
      *    29 - Protect Screen Fields                                 *
      *    32 - SflMsgEnd                                             *
      *    82 - Error CRS Customer Type                               *
      *    83 - Error High Value Indicator                            *
      *    85 - Error Subject To Reporting                            *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      *  SRFldVal - Validate The Data Of The Fields                   *
      *  SRAmend  - Amend the Record Subroutine                       *
      *  SRDelete - Delete The select record                          *
      *  SRInsert - Insert A New Record In The File                   *
      *  SRErrDta - Output error Message With Data                    *
      *  *INZSR   - Initialise                                        *
      *  *PSSR    - Error processing                                  *
      *                                                               *
      *    The *INZSR Subroutine Will Only Get Called Automatically   *
      *    On Entry To The Module The First Time It Is Run            *
      *    (Unless You End The Program With LR On).  Similarly        *
      *    D-spec initialisation only happens The First Time.  Use    *
      *    RESET For Subsequent Passes.                               *
      *                                                               *
      *****************************************************************
      *---------------------------------------------------------------*
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      *
      ** CRS High Value Account Identification (update)
     FSDCRHVL0  UF A E           K DISK    INFSR(*PSSR)
      *
      ** CRS High Value Account Identification (retrieve)
     FSDCRHVL1  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(SDCRHVD0:SDCRHVD1)
     F                                     PREFIX(H_)
      *
      ** CRS High Value Account Identification Subfile
     FSD000313DFCF   E             WORKSTN
      *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically Included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      *
      ** The Following /COPY Line Includes The LDA Layout,
      ** The Copyright Array Definition,
      ** And The Following Named Constants:
      **    True       Logical = *ON (For Indcator Processing)
      **    False      Logical = *OFF (For Indcator Processing)
      **    DBErrCtl   10A     = 'DBERRCTL' (The Name Of The Database
      **                         Error Handler)
      ** And The Following Variables:
      **    RunBefore  1A (for the PSSR)
      *
     D/COPY ZACPYSRC,STD_D_SPEC
      *
      ** Program Status Data Structure
      ** =============================
      *
      ** The Following /COPY Line Includes All The Defined Fields In
      ** The PSDS.  They Have Meaningful Names, Prefixed By 'PS'.
      *
     D/COPY ZACPYSRC,PSDS
      *
      ** +--------------------------------------+
      ** ¦ End Of Automatically Included D-specs¦
      ** ¦ =====================================¦
      ** +--------------------------------------+
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +--------------------------------------+
      ** ¦ Arrays And Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
      *
     D DSFDY         E DS                  EXTNAME(DSFDY)
      *
      ** DS SDBANK Based On SDBANKPD
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      *
      ** External DS Based On SDFATCPD
     D SDFATC        E DS                  EXTNAME(SDFATCPD)
      *
     D Indicators      DS                  BASED(IndPointer)
     D  Exit                   3      3
     D  DltRecord             10     10
     D  Cancel                12     12
     D  SflMsgEnd             32     32
      *
      ** +--------------------------------------+
      ** ¦ Declared Variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
      *
     D IndPointer      S               *   Inz(%Addr(*IN))
     D Error           S              1A
     D PClas           S              5A
      *
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
      *
     D Amend           C                   CONST('A')
     D Enquire         C                   CONST('E')
     D Delete          C                   CONST('D')
     D Insert          C                   CONST('I')
      *
      ** Paramaters For AOBANKR0
     D PRtcd           S              7A
     D POptn           S              7A
      *
      ** Paramaters For ZA0350
     D PZMsgFile       S             10A
     D PZMsgId         S             10A
     D PZMsgData       S             45A
      *
      ** Work Variable
     D WMsgId          S              7A
     D WMsgDta         S             45A
     D WRun            S              1A
     D WIdx            S              3P 0
     D KCType          S                   LIKE(HVCUTP)
     D KHVInd          S                   LIKE(HVHVIN)
      *
      ** Entry Parameters
     D POpt            S              1A
     D PCutp           S                   LIKE(HVCUTP)
     D PHvin           S                   LIKE(HVHVIN)
      *
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *****************************************************************
      *
      ** +--- Start of Main processing -------------------------------+
      ** ¦                                                            ¦
      ** ¦ Initial Processing Is Performed Automatically: The *INZSR  ¦
      ** ¦ Is Executed At Program Activation.                         ¦
      ** ¦                                                            ¦
      ** +------------------------------------------------------------+
      *
      *****************************************************************
      *  MAIN - Processing                                            *
      *****************************************************************
      *
      ** Turn Off All Error Indicators
     C                   EVAL      *IN81 = *OFF
     C                   EVAL      *IN82 = *OFF
     C                   EVAL      *IN83 = *OFF
     C                   EVAL      *IN84 = *OFF
     C                   EVAL      *IN85 = *OFF
     C                   EVAL      Cancel = *OFF
     C                   EVAL      Exit = *OFF
     C                   EVAL      D0HVIN = 'L'
      *
     C                   IF        (POpt = Amend) OR
     C                             (POpt = Enquire) OR
     C                             POpt = Delete
      *
      ** If found, Populate the Screen Fields
     C                   EVAL      KCType = PCutp
     C                   EVAL      KHVInd = PHvin
     C     KCRHV         CHAIN     SDCRHVL0
     C                   IF        %FOUND(SDCRHVL0)
      *
     C                   EVAL      D0CUTP = HVCUTP
     C                   EVAL      D0HVIN = HVHVIN
     C                   EVAL      D0SUBJ = HVSUBJ
      *
     C                   EXSR      SRPopCUTPD
     C                   ENDIF
      *
     C                   ELSE
      *
      ** If Not found, Set The Fields To Blank
     C                   EVAL      D0CUTP = *BLANKS
     C                   EVAL      D0CUTD = *BLANKS
     C                   EVAL      D0HVIN = 'L'
     C                   EVAL      D0SUBJ = *BLANKS
      *
     C                   ENDIF
      *
     C                   DOW       (Exit = *OFF) AND
     C                             (Cancel = *OFF)
      *
      ** If Amendment, Set Required Indicators
     C                   IF        POpt = Amend
      *
     C                   EVAL      *IN22 = *ON
     C                   EVAL      *IN24 = *OFF
     C                   EVAL      *IN29 = *OFF
      *
      ** If Enquire, Set Required Indicators
     C                   ELSEIF    POpt = Enquire
      *
     C                   EVAL      *IN22 = *ON
     C                   EVAL      *IN24 = *OFF
     C                   EVAL      *IN29 = *ON
      *
      ** If Delete, Set Required Indicators
     C                   ELSEIF    POpt = Delete
      *
     C                   EVAL      *IN22 = *ON
     C                   EVAL      *IN24 = *ON
     C                   EVAL      *IN29 = *ON
      *
      ** If Insert, Set Required Indicators
     C                   ELSEIF    POpt = Insert
      *
     C                   EVAL      *IN22 = *OFF
     C                   EVAL      *IN24 = *OFF
     C                   EVAL      *IN29 = *OFF
      *
     C                   ENDIF
      *
      ** Populate The Time Field
     C                   TIME                    D0TIME
      *
      ** Footer Of The Screen With Function Keys
     C                   WRITE     SD000313F1
      *
      ** Message Subfile Control Format
     C                   WRITE     SD000313C0
      *
      ** Screen Format
     C                   EXFMT     SD000313F0
      *
     C                   SELECT
      *
     C                   WHEN      Exit = *ON
     C                   EVAL      PRtcd = 'F3'
     C                   RETURN
      *
     C                   WHEN      Cancel = *ON
     C                   EVAL      PRtcd = 'F12'
     C                   RETURN
      *
      ** Amend The Record
     C                   WHEN      POpt = Amend
     C                   EXSR      SRAmend
      *
      ** Delete The Record
     C                   WHEN      POpt = Delete
     C                   EXSR      SRDelete
      *
      ** Insert The Record
     C                   WHEN      POpt = Insert
     C                   EXSR      SRInsert
      *
      ** Enquire The Record
     C                   WHEN      POpt = Enquire
     C                   EVAL      Cancel = *ON
     C                   EVAL      *IN29 = *OFF
     C                   EVAL      *IN22 = *OFF
      *
     C                   ENDSL
      *
     C                   ENDDO
      *
     C                   COMMIT
      *
     C                   EVAL      *INLR = *ON
     C                   RETURN
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *INZSR - Program initialisation routine                      *
      *                                                               *
      *  Called by: Implicitly On Program Activation                  *
      *                                                               *
      *  Calls: *PSSR                                                 *
      *                                                               *
      *****************************************************************
      *
     C     *INZSR        BEGSR
      *
     C     *ENTRY        PLIST
     C                   PARM                    POpt
     C                   PARM                    PCutp
     C                   PARM                    PHvin
     C                   PARM                    PRtcd
      *
     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANKS       PRtcd
     C                   PARM      '*FIRST'      POptn
     C     SDBANK        PARM      SDBANK        DSFDY
      *
      ** Check the Return Parameter
     C                   IF        PRtcd <> *BLANKS
      *
     C                   EVAL      DBKEY = POptn
     C                   EVAL      DBFILE = 'SDBANKPD'
     C                   EVAL      DBASE = 001
      *
     C                   EXSR      *PSSR
      *
     C                   ENDIF
      *
     C                   EVAL      D0WOID = PsJobName
     C                   EVAL      D0USRP = PsUser
     C                   EVAL      D0MRDT = BJMRDT
      *
      ** Initialise Subfile Program Queue And Message File
     C                   EVAL      D0PGMQ = '*'
     C                   EVAL      PZMsgFile = 'SDUSRMSG'
      *
      ** Clear Program Message Queue
     C                   CALL      'ZA0250'
      *
     C                   EVAL      SflMsgEnd = *ON
      *
     C     KCRHV         KLIST
     C                   KFLD                    KCType
     C                   KFLD                    KHVInd
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRPopCUTPD  - Populate Customer Type Description              *
      *                                                               *
      * Called by: Main, SRFldVal                                     *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************

     C     SRPopCUTPD    BEGSR
      *
     C                   SELECT
     C                   WHEN      D0CUTP = '*'
     C                   EVAL      D0CUTD = 'All'
     C                   WHEN      D0CUTP = 'N'
     C                   EVAL      D0CUTD = 'Non-Financial Entity'
     C                   WHEN      D0CUTP = 'P'
     C                   EVAL      D0CUTD = 'Physical Person'
     C                   WHEN      D0CUTP = 'J'
     C                   EVAL      D0CUTD = 'Joint Account'
     C                   WHEN      D0CUTP = 'O'
     C                   EVAL      D0CUTD = 'Others'
     C                   OTHER
     C                   EVAL      D0CUTD = *BLANKS
     C                   ENDSL
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRFldVal - Validate The Data Of The Fields                   *
      *                                                               *
      *  Called by: MAIN Processing, SRAmend, SRInsert                *
      *                                                               *
      *  Calls: SRErrDta                                              *
      *                                                               *
      *****************************************************************
     C     SRFldVal      BEGSR
     C                   IF        (POpt = Insert)
     C                              OR
     C                             (POpt = Amend)
      *
      ** Validation of CRS Type
      ** The CRS Type must be N (NFE), P (Physical Person)
      ** O (Other), J (Joint Account), * (All) or Blanks
     C                   IF        D0CUTP <> 'N' AND D0CUTP <> 'P'
     C                             AND D0CUTP <> 'O'
     C                             AND D0CUTP <> 'J'
     C                             AND D0CUTP <> '*'
     C                   EVAL      WMsgId = 'USS0678'
     C                   EVAL      *IN82 = *ON
     C                   EVAL      WIdx = WIdx + 1
     C                   EXSR      SRErrDta
     C                   ENDIF
      *
     C                   EXSR      SRPopCUTPD
      *
      ** Validation of High Value Indicator
      ** Subject to reporting is NOT required when high value indicator input is 'H' or 'M'
     C                   IF        D0HVIN = 'H' OR D0HVIN = 'M'
     C                   EVAL      WMsgId = 'USS0671'
     C                   EVAL      *IN84 = *ON
     C                   EVAL      *IN85 = *ON
     C                   EVAL      WIdx = WIdx + 1
     C                   EXSR      SRErrDta
     C                   ENDIF
      ** If high value indicator is low, field 'Subject to Reporting' valid values are blank or 'N'
     C                   IF        D0HVIN = 'L'
     C                   IF        D0SUBJ <> *BLANKS
     C                             AND D0SUBJ <> 'N'
     C                   EVAL      WMsgId = 'USS0672'
     C                   EVAL      *IN84 = *ON
     C                   EVAL      *IN85 = *ON
     C                   EVAL      WIdx = WIdx + 1
     C                   EXSR      SRErrDta
     C                   ENDIF
     C                   ENDIF
      ** The High Value Indicator must be L (Low)
     C                   IF        D0HVIN <> 'L'
     C                   EVAL      WMsgId = 'USS0674'
     C                   EVAL      *IN83 = *ON
     C                   EVAL      WIdx = WIdx + 1
     C                   EXSR      SRErrDta
     C                   ENDIF
      *
      ** Record Must be Unique In The File SDCRHVPD
     C                   EVAL      KCType = D0CUTP
     C                   EVAL      KHVInd = D0HVIN
      *
     C                   IF        D0CUTP <> PCutp OR
     C                             D0HVIN <> PHvin

     C     KCRHV         CHAIN     SDCRHVL1
     C                   IF        %FOUND(SDCRHVL1)
     C                   EVAL      WMsgId = 'USR0017'
     C                   EVAL      WIdx = WIdx + 1
     C                   EVAL      *IN81 = *ON
     C                   EVAL      *IN82 = *ON
     C                   EVAL      *IN83 = *ON
     C                   EXSR      SRErrDta
     C                   ENDIF

     C                   ENDIF
      *
      ** Check whether '*' record already exists
     C                   IF        D0CUTP <> '*'
     C                   EVAL      KCType = '*'
     C                   EVAL      KHVInd = D0HVIN
      *
     C     KCRHV         CHAIN     SDCRHVL1
     C                   IF        %FOUND(SDCRHVL1)
     C                   EVAL      WMsgId = 'USS0677'
     C                   EVAL      WIdx = WIdx + 1
     C                   EVAL      *IN81 = *ON
     C                   EVAL      *IN82 = *ON
     C                   EVAL      *IN83 = *ON
     C                   EXSR      SRErrDta
     C                   ENDIF
      *
     C                   ELSE
      *
      ** Check whether other records already exist if '*' is entered
     C     *LOVAL        SETLL     SDCRHVL1
     C                   READ      SDCRHVL1
      *
     C                   DOW       NOT %EOF(SDCRHVL1)
     C                   IF        (H_HVCUTP <> '*' AND
     C                             H_HVHVIN = D0HVIN) OR
     C                             (H_HVCUTP <> '*' AND
     C                             H_HVHVIN = D0HVIN)
     C                   EVAL      WMsgId = 'USS0675'
     C                   EVAL      WIdx = WIdx + 1
     C                   EVAL      *IN81 = *ON
     C                   EVAL      *IN82 = *ON
     C                   EVAL      *IN83 = *ON
     C                   EXSR      SRErrDta
     C                   LEAVE
     C                   ENDIF
     C                   READ      SDCRHVL1
     C                   ENDDO
      *
     C                   ENDIF
     C                   ENDIF
      *
      ** Validation of Subject to Reporting
      ** Subject to Reporting can only be set to 'N' when High Value Indicator is 'L'
     C                   IF        D0SUBJ = *BLANKS or D0SUBJ = 'N'
     C                   IF        D0HVIN <> 'L'
     C                   EVAL      *IN85 = *ON
     C                   EVAL      WMsgId = 'USS0673'
     C                   EVAL      WIdx = WIdx + 1
     C                   EXSR      SRErrDta
     C                   ENDIF
     C                   ENDIF
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRAmend - Amend The Record Subroutine                        *
      *                                                               *
      *  Called by: MAIN Processing                                   *
      *                                                               *
      *  Calls: SRFldVal                                              *
      *                                                               *
      *****************************************************************
     C     SRAmend       BEGSR
      *
      ** Reset Error Flag
     C                   EXSR      SRReset
      *
     C                   EXSR      SRFldVal
      *
     C                   IF        WIdx = 0
      *
      ** If Valid, Update Database
     C                   EVAL      HVCUTP = D0CUTP
     C                   EVAL      HVHVIN = D0HVIN
     C                   EVAL      HVSUBJ = D0SUBJ
     C                   EVAL      HVLCDT = BJRDNB
     C                   EVAL      HVCHTP = Amend
     C                   UPDATE    SDCRHVD0
      *
     C                   EVAL      Cancel = *ON
      *
     C                   ENDIF
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRDelete - Delete The Select Record                          *
      *                                                               *
      *  Called by: MAIN Processing                                   *
      *                                                               *
      *  Calls: SRErrDta                                              *
      *                                                               *
      *****************************************************************
      *
     C     SRDelete      BEGSR
      *
     C                   IF        *IN10 = *ON
     C                   DELETE    SDCRHVD0
     C                   EVAL      Cancel = *ON
      *
     C                   ELSE
     C                   EVAL      WIdx = *ZEROS
      *
      ** Clear Program Message Queue
     C                   CALL      'ZA0250'
      *
     C                   EVAL      WMsgId = 'ASM0028'
     C                   EVAL      WIdx = WIdx
     C                   EXSR      SRErrDta
      *
     C                   ENDIF
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRInsert - Insert A New Record In The File                   *
      *                                                               *
      *  Called by: MAIN Processing                                   *
      *                                                               *
      *  Calls: SRFldVal,SRErrDta                                     *
      *                                                               *
      *****************************************************************
      *
     C     SRInsert      BEGSR
      *
      ** Reset Error Flag
     C                   EXSR      SRReset
      *
     C                   EXSR      SRFldVal
      *
     C                   IF        WIdx = 0
      *
      ** If valid, Write To Database
     C                   EVAL      HVCUTP = D0CUTP
     C                   EVAL      HVHVIN = D0HVIN
     C                   EVAL      HVSUBJ = D0SUBJ
     C                   EVAL      HVLCDT = BJRDNB
     C                   EVAL      HVCHTP = Insert
      *
     C                   WRITE     SDCRHVD0
      *
     C                   EVAL      Cancel = *ON
      *
     C                   ENDIF
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRErrDta - Output Error Message With Data                    *
      *                                                               *
      *  Called by: MAIN Processing, SRFldVal, SRDelete, SRInsert     *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
      *
     C     SRErrDta      BEGSR
     C                   EVAL      PZMsgId = *BLANKS
     C                   EVAL      PZMsgId = WMsgId
      *
      ** Send Error Message To Message Subfile
     C                   CALL      'ZA0350'
      *
     C                   PARM                    PZMsgFile
     C                   PARM                    PZMsgId
     C                   PARM      WMsgDta       PZMsgData
     C                   ENDSR
      *
      *****************************************************************
      /EJECT                                                          *
      *****************************************************************
      *                                                               *
      *  SRReset - Reset Error Flag                                   *
      *                                                               *
      *  Called by: SRAmend, SRInsert                                 *
      *                                                               *
      *  Calls: SRFldVal, SRErrDta                                    *
      *                                                               *
      *****************************************************************
      *
     C     SRReset       BEGSR
      *
     C                   CALL      'ZA0250'
      *
      ** Reset Error Indicator
     C                   EVAL      *IN81 = *OFF
     C                   EVAL      *IN82 = *OFF
     C                   EVAL      *IN83 = *OFF
     C                   EVAL      *IN84 = *OFF
     C                   EVAL      *IN85 = *OFF
      *
      ** Clear Error Fields
     C                   EVAL      PZMsgId = *BLANKS
     C                   EVAL      PZMsgData = *BLANKS
     C                   EVAL      WIdx = *ZEROS
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *PSSR - Program exception error routine                      *
      *                                                               *
      *  Called By: Automatically if a program error occurs,          *
      *             or directly by the program code using EXSR.       *
      *             This subroutine DUMPs the program just once.      *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
     C     *PSSR         BEGSR
      *
     C                   IF        WRun = *BLANKS
      *
     C                   EVAL      WRun = 'Y'
     C                   DUMP
      *
     C                   CALL      'DBERRCTL'
      *
     C                   ENDIF
      *
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
