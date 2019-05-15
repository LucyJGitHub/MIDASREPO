     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2013')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas SD FATCA High Value A/C Identif. Maintenance')   *
      *****************************************************************
      *  Includes MD024749, MD025299, MD025027                        *
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SD000140 - Midas SD FATCA High Value Account Identification  *
      *             Maintenance                                       *
      *                                                               *
      *  Function:  This program is used for the maintenance of       *
      *             the FATCA High Value Account Identification       *
      *             File                                              *
      *                                                               *
      *  Called By: SD000109 - MIDAS SD FATCA High Value Account      *
      *                        Identification Subfile                 *
      *                                                               *
      *  (c) Finastra International Limited 2013                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CGL132  *CREATE    Date 01May13               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CGL132 - FATCA Phase 1 - Customers' Identification and       *
      *           Classification - Master                             *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use Of Indicators.                                           *
      *                                                               *
      *    03 - Exit                                                  *
      *    10 - Delete Record                                         *
      *    12 - Cancel                                                *
      *    22 - Protect Current Classification Code                   *
      *    24 - Footer                                                *
      *    29 - Protect Screen Fields                                 *
      *    32 - SflMsgEnd                                             *
      *    81 - Error Current Classification Code                     *
      *    82 - Error FATCA Customer Type                             *
      *    83 - Error High Value Indicator                           *
      *    84 - Error FATCA Classification Code                       *
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
      ** FATCA High Value Account Identification (update)
     FSDFTHVL0  UF A E           K DISK    INFSR(*PSSR)
     F                                     COMMIT
      *
      ** FATCA High Value Account Identification (retrieve)
     FSDFTHVL1  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(SDFTHVD0:SDFTHVD1)
     F                                     PREFIX(H_)
      *
      ** FATCA High Value Account Identification Subfile
     FSD000140DFCF   E             WORKSTN
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
     D WCCLC           S                   LIKE(HVCCLC)
     D WNCLC           S                   LIKE(HVNCLC)
     D KCCode          S                   LIKE(HVCCLC)
     D KCType          S                   LIKE(HVCUTP)
     D KHVInd          S                   LIKE(HVHVIN)
      *
      ** Entry Parameters
     D POpt            S              1A
     D PCclc           S                   LIKE(HVCCLC)
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
      *
     C                   IF        (POpt = Amend) OR
     C                             (POpt = Enquire) OR
     C                             POpt = Delete
      *
      ** If found, Populate the Screen Fields
     C                   EVAL      KCCode = PCclc
     C                   EVAL      KCType = PCutp
     C                   EVAL      KHVInd = PHvin
     C     KFTHV         CHAIN     SDFTHVL0
     C                   IF        %FOUND(SDFTHVL0)
      *
     C                   EVAL      D0CCLC = HVCCLC
     C                   EVAL      D0CUTP = HVCUTP
     C                   EVAL      D0HVIN = HVHVIN
     C                   EVAL      D0NCLC = HVNCLC
     C                   EVAL      D0SUBJ = HVSUBJ
      *
      ** Retrieve description for Current FATCA Classification Code
     C                   CALL      'AOFATCR0'
     C                   PARM      *BLANKS       PRtcd
     C                   PARM      '*KEY'        POptn
     C                   PARM      D0CCLC        PClas
     C     SDFATC        PARM      SDFATC        DSFDY
      *
     C                   IF        PRtcd = *BLANKS
     C                   EVAL      D0CCLD = FCDESC
     C                   ELSE
     C                   EVAL      D0CCLD = *BLANKS
     C                   ENDIF
      *
      ** Retrieve description for New FATCA Classification Code
     C                   CALL      'AOFATCR0'
     C                   PARM      *BLANKS       PRtcd
     C                   PARM      '*KEY'        POptn
     C                   PARM      D0NCLC        PClas
     C     SDFATC        PARM      SDFATC        DSFDY
      *
     C                   IF        PRtcd = *BLANKS
     C                   EVAL      D0NCLD = FCDESC
     C                   ELSE
     C                   EVAL      D0NCLD = *BLANKS
     C                   ENDIF
      *
     C                   EXSR      SRPopCUTPD
      *
     C                   ENDIF
      *
     C                   ELSE
      *
      ** If Not found, Set The Fields To Blank
     C                   EVAL      D0CCLC = *BLANKS
     C                   EVAL      D0CCLD = *BLANKS
     C                   EVAL      D0CUTP = *BLANKS
     C                   EVAL      D0CUTPD = *BLANKS
     C                   EVAL      D0HVIN = *BLANKS
     C                   EVAL      D0NCLC = *BLANKS
     C                   EVAL      D0NCLD = *BLANKS
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
     C                   WRITE     SD000140F1
      *
      ** Message Subfile Control Format
     C                   WRITE     SD000140C0
      *
      ** Screen Format
     C                   EXFMT     SD000140F0
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
     C                   PARM                    PCclc
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
     C     KFTHV         KLIST
     C                   KFLD                    KCCode
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
     C                   EVAL      D0CUTPD = 'All'
     C                   WHEN      D0CUTP = 'N'
     C                   EVAL      D0CUTPD = 'Non-Financial Entity'
     C                   WHEN      D0CUTP = 'P'
     C                   EVAL      D0CUTPD = 'Physical Person'
     C                   WHEN      D0CUTP = 'J'
     C                   EVAL      D0CUTPD = 'Joint Account'
     C                   WHEN      D0CUTP = 'O'
     C                   EVAL      D0CUTPD = 'Others'
     C                   OTHER
     C                   EVAL      D0CUTPD = *BLANKS
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
      ** Validation of Current Classification Code
      ** Must Be A Valid Current Classification Code or '*ALL'
     C                   IF        D0CCLC <> '*ALL'
     C                   CALL      'AOFATCR0'
     C                   PARM      *BLANKS       PRtcd
     C                   PARM      '*KEY'        POptn
     C                   PARM      D0CCLC        PClas
     C     SDFATC        PARM      SDFATC        DSFDY
      *
     C                   IF        PRtcd = '*NRF'
     C                   EVAL      WMsgId = 'USS0292'
     C                   EVAL      *IN81 = *ON
     C                   EVAL      WIdx = WIdx + 1
     C                   EXSR      SRErrDta
     C                   ENDIF
      *
     C                   IF        PRtcd = *BLANKS
     C                   EVAL      WCCLC = D0CCLC
     C                   EVAL      D0CCLC = FCCODE
     C                   EVAL      D0CCLD = FCDESC
     C                   ENDIF
     C                   ENDIF
      *
      ** Validation of FATCA Customer Type
      ** The FATCA Customer Type must be N (NFE), P (Physical Person)
      ** O (Other), J (Joint Account), * (All) or Blanks
     C                   IF        D0CUTP <> 'N' AND D0CUTP <> 'P'
     C                             AND D0CUTP <> 'O'
     C                             AND D0CUTP <> 'J'
     C                             AND D0CUTP <> '*'
     C                             AND D0CUTP <> *BLANKS
     C                   EVAL      WMsgId = 'USS0297'
     C                   EVAL      *IN82 = *ON
     C                   EVAL      WIdx = WIdx + 1
     C                   EXSR      SRErrDta
     C                   ENDIF
      *
     C                   EXSR      SRPopCUTPD
      *
      ** Validation of High Value Indicator
      ** The High Value Indicator must be H (High), M (Medium),
      ** L (Low)
     C                   IF        D0NCLC = *BLANK  AND
     C                             D0SUBJ = *BLANKS
     C                   IF        D0HVIN <> *BLANK
     C                   EVAL      WMsgId = 'USS0468'
     C                   EVAL      *IN84 = *ON
     C                   EVAL      *IN85 = *ON
     C                   EVAL      WIdx = WIdx + 1
     C                   EXSR      SRErrDta
     C                   ENDIF
     C                   ELSE
 
     C                   IF        D0HVIN <> 'H' AND D0HVIN <> 'M'
     C                             AND D0HVIN <> 'L'
     C                   EVAL      WMsgId = 'USS0298'
     C                   EVAL      *IN83 = *ON
     C                   EVAL      WIdx = WIdx + 1
     C                   EXSR      SRErrDta
     C                   ENDIF
     C                   ENDIF
      *
      ** Record Must be Unique In The File SDFTHVPD
     C                   EVAL      KCCode = D0CCLC
     C                   EVAL      KCType = D0CUTP
     C                   EVAL      KHVInd = D0HVIN
      *
     C                   IF        D0CCLC <> PCclc OR
     C                             D0CUTP <> PCutp OR
     C                             D0HVIN <> PHvin
 
     C     KFTHV         CHAIN     SDFTHVL1
     C                   IF        %FOUND(SDFTHVL1)
     C                   EVAL      WMsgId = 'USR0017'
     C                   EVAL      WIdx = WIdx + 1
     C                   EVAL      *IN81 = *ON
     C                   EVAL      *IN82 = *ON
     C                   EVAL      *IN83 = *ON
     C                   EXSR      SRErrDta
     C                   ENDIF
 
     C                   ENDIF
      *
      ** Check whether '*ALL' record already exists
     C                   IF        D0CCLC <> '*ALL'
     C                   EVAL      KCCode = '*ALL'
     C                   EVAL      KCType = D0CUTP
     C                   EVAL      KHVInd = D0HVIN
      *
     C     KFTHV         CHAIN     SDFTHVL1
     C                   IF        %FOUND(SDFTHVL1)
     C                   EVAL      WMsgId = 'USS0270'
     C                   EVAL      WIdx = WIdx + 1
     C                   EVAL      *IN81 = *ON
     C                   EVAL      *IN82 = *ON
     C                   EVAL      *IN83 = *ON
     C                   EXSR      SRErrDta
     C                   ENDIF
      *
     C                   EVAL      KCCode = '*ALL'
     C                   EVAL      KCType = '*'
     C                   EVAL      KHVInd = D0HVIN
      *
     C     KFTHV         CHAIN     SDFTHVL1
     C                   IF        %FOUND(SDFTHVL1)
     C                   EVAL      WMsgId = 'USS0270'
     C                   EVAL      WIdx = WIdx + 1
     C                   EVAL      *IN81 = *ON
     C                   EVAL      *IN82 = *ON
     C                   EVAL      *IN83 = *ON
     C                   EXSR      SRErrDta
     C                   ENDIF
      *
     C                   EVAL      KCCode = '*ALL'
     C                   EVAL      KCType = '*'
     C                   EVAL      KHVInd = *BLANKS
      *
     C     KFTHV         CHAIN     SDFTHVL1
     C                   IF        %FOUND(SDFTHVL1)
     C                   EVAL      WMsgId = 'USS0270'
     C                   EVAL      WIdx = WIdx + 1
     C                   EVAL      *IN81 = *ON
     C                   EVAL      *IN82 = *ON
     C                   EVAL      *IN83 = *ON
     C                   EXSR      SRErrDta
     C                   ENDIF
      *
     C                   ELSE
      ** Check whether other records already exist if '*ALL'
      ** is entered
      *
     C                   IF        D0CCLC <> PCclc OR
     C                             D0CUTP <> PCutp OR
     C                             D0HVIN <> PHvin
     C     *LOVAL        SETLL     SDFTHVL1
     C                   READ      SDFTHVL1
      *
     C                   DOW       NOT %EOF(SDFTHVL1)
     C                   IF        (H_HVCUTP =  D0CUTP AND
     C                             H_HVHVIN = D0HVIN  AND
     C                             H_HVCCLC <> '*ALL') OR
     C                             (H_HVCUTP =  '*' AND
     C                             H_HVHVIN = D0HVIN AND
     C                             H_HVCCLC <> '*ALL') OR
     C                             (D0CUTP =  '*' AND
     C                             H_HVHVIN = D0HVIN)
     C                             OR (H_HVCUTP =  D0CUTP
     C                             AND D0HVIN = *BLANKS)
     C                             OR (D0CUTP =  '*'
     C                             AND D0HVIN = *BLANKS)
     C                   EVAL      WMsgId = 'USS0271'
     C                   EVAL      WIdx = WIdx + 1
     C                   EVAL      *IN81 = *ON
     C                   EVAL      *IN82 = *ON
     C                   EVAL      *IN83 = *ON
     C                   EXSR      SRErrDta
     C                   LEAVE
     C                   ENDIF
     C                   READ      SDFTHVL1
     C                   ENDDO
     C                   ENDIF
      *
     C                   ENDIF
      *
      ** Check whether '*' record already exists
     C                   IF        D0CUTP <> '*'
     C                   EVAL      KCCode = D0CCLC
     C                   EVAL      KCType = '*'
     C                   EVAL      KHVInd = D0HVIN
      *
     C     KFTHV         CHAIN     SDFTHVL1
     C                   IF        %FOUND(SDFTHVL1)
     C                   EVAL      WMsgId = 'USS0272'
     C                   EVAL      WIdx = WIdx + 1
     C                   EVAL      *IN81 = *ON
     C                   EVAL      *IN82 = *ON
     C                   EVAL      *IN83 = *ON
     C                   EXSR      SRErrDta
     C                   ENDIF
      *
     C                   EVAL      KCCode = '*ALL'
     C                   EVAL      KCType = '*'
     C                   EVAL      KHVInd = D0HVIN
      *
     C     KFTHV         CHAIN     SDFTHVL1
     C                   IF        %FOUND(SDFTHVL1)
     C                   EVAL      WMsgId = 'USS0272'
     C                   EVAL      WIdx = WIdx + 1
     C                   EVAL      *IN81 = *ON
     C                   EVAL      *IN82 = *ON
     C                   EVAL      *IN83 = *ON
     C                   EXSR      SRErrDta
     C                   ENDIF
      *
     C                   ELSE
      ** Check whether other records already exist if '*'
      ** is entered
      *
     C     *LOVAL        SETLL     SDFTHVL1
     C                   READ      SDFTHVL1
      *
     C                   DOW       NOT %EOF(SDFTHVL1)
     C                   IF        (H_HVCUTP <> '*' AND
     C                             H_HVHVIN = D0HVIN  AND
     C                             H_HVCCLC = D0CCLC) OR
     C                             (H_HVCUTP <> '*' AND
     C                             H_HVHVIN = D0HVIN  AND
     C                             H_HVCCLC = '*ALL')
     C                   EVAL      WMsgId = 'USS0273'
     C                   EVAL      WIdx = WIdx + 1
     C                   EVAL      *IN81 = *ON
     C                   EVAL      *IN82 = *ON
     C                   EVAL      *IN83 = *ON
     C                   EXSR      SRErrDta
     C                   LEAVE
     C                   ENDIF
     C                   READ      SDFTHVL1
     C                   ENDDO
      *
     C                   ENDIF
     C                   ENDIF
      *
      ** Validation for New FATCA Classification Code
      ** If Entered, New FATCA Classification Code must be a
      ** valid code and not be the same as the Current FATCA
      ** Classification Code
     C                   IF        D0NCLC <> *BLANKS
      *
     C                   CALL      'AOFATCR0'
     C                   PARM      *BLANKS       PRtcd
     C                   PARM      '*KEY'        POptn
     C                   PARM      D0NCLC        PClas
     C     SDFATC        PARM      SDFATC        DSFDY
      *
     C                   IF        PRtcd = '*NRF'
     C                   EVAL      *IN84 = *ON
     C                   EVAL      WMsgId = 'USS0280'
 
      ** New FATCA Classification Code when High Value Flag
      ** is set to "L", "M", "H" error message
 
     C                   SeleCT
     C                   WHEN      KHVIND = 'H'
     C                   EVAL      WMsgId = 'USS0119'
 
     C                   WHEN      KHVIND = 'M'
     C                   EVAL      WMsgId = 'USS0120'
 
     C                   WHEN      KHVIND = 'L'
     C                   EVAL      WMsgId = 'USS0121'
     C                   ENDSL
 
     C                   EVAL      WIdx = WIdx + 1
     C                   EXSR      SRErrDta
     C                   ENDIF
      *
     C                   IF        PRtcd = *BLANKS
     C                   EVAL      WNCLC = D0NCLC
     C                   EVAL      D0NCLC = FCCODE
     C                   EVAL      D0NCLD = FCDESC
     C                   ENDIF
      *
     C                   IF        D0NCLC = D0CCLC
     C                   EVAL      *IN84 = *ON
     C                   EVAL      WMsgId = 'USS0265'
     C                   EVAL      WIdx = WIdx + 1
     C                   EXSR      SRErrDta
     C                   ENDIF
      *
     C                   ENDIF
      *
      ** Validation of Subject to Reporting
      ** Subject to Reporting can be set to 'N' (No) for low
      ** value customers only.
     C                   IF        D0SUBJ <> *BLANKS
     C                   IF        D0HVIN <> 'L' OR
     C                             D0HVIN = 'L' AND D0SUBJ <> 'N'
     C                   EVAL      *IN85 = *ON
     C                   EVAL      WMsgId = 'USS0268'
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
     C                   IF        WIdx = 0 AND WCCLC <> '?'
     C                             AND WNCLC <> '?'
      *
      ** If Valid, Update Database
     C                   EVAL      HVCCLC = D0CCLC
     C                   EVAL      HVCUTP = D0CUTP
     C                   EVAL      HVHVIN = D0HVIN
     C                   EVAL      HVNCLC = D0NCLC
     C                   EVAL      HVSUBJ = D0SUBJ
     C                   EVAL      HVLCDT = BJRDNB
     C                   EVAL      HVCHTP = Amend
     C                   UPDATE    SDFTHVD0
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
     C                   DELETE    SDFTHVD0
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
     C                   IF        WIdx = 0 AND WCCLC <> '?'
     C                             AND WNCLC <> '?'
      *
      ** If valid, Write To Database
     C                   EVAL      HVCCLC = D0CCLC
     C                   EVAL      HVCUTP = D0CUTP
     C                   EVAL      HVHVIN = D0HVIN
     C                   EVAL      HVNCLC = D0NCLC
     C                   EVAL      HVSUBJ = D0SUBJ
     C                   EVAL      HVLCDT = BJRDNB
     C                   EVAL      HVCHTP = Insert
      *
     C                   WRITE     SDFTHVD0
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
