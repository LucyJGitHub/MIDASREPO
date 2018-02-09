     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2013')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas SD FATCA Cust Type & Classif. Maintenance')      *
      *****************************************************************
      *  Includes MD024620, MD024620A                                 *
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SD000103 - Midas SD FATCA Customer Type & Classification     *
      *             Allocation Maintenance                            *
      *                                                               *
      *  Function:  This program is used for the maintenance of       *
      *             the FATCA Customer Type & Classification          *
      *             Allocation File                                   *
      *                                                               *
      *  Called By: SD000102 - MIDAS SD FATCA Customer Type &         *
      *                        Classification Allocation Subfile      *
      *                                                               *
      *  (c) Finastra International Limited 2013                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. MD027298           Date 06Aug14               *
      *                 CGL132  *CREATE    Date 01May13               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  MD027298 - Incorrect label 'Exempt' (Recompile)              *
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
      *    22 - Protect Local Institution Code                        *
      *    24 - Footer                                                *
      *    29 - Protect Screen Fields                                 *
      *    32 - SflMsgEnd                                             *
      *    81 - Error Local Institution Code                          *
      *    82 - Error FATCA Customer Type                             *
      *    83 - Error FATCA Customer Sub-Type                         *
      *    84 - Error FATCA Classification Code                       *
      *    85 - Error FATCA Information Complete                      *
      *    86 - Error Exempt                                          *
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
      ** FATCA Customer Type & Classification Allocation File
     FSDFTCTL0  UF A E           K DISK    INFSR(*PSSR)
     F                                     COMMIT
      *
      ** FATCA Customer Type & Classification Allocation Maintenance
     FSD000103DFCF   E             WORKSTN
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
      ** External DS Based On SDINSTPD
     D SDINST        E DS                  EXTNAME(SDINSTPD)
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
     D PLin            S              2A
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
     D WCLCD           S              5A
     D WLINC           S              2A
      *
      ** Entry Parameters
     D POpt            S              1A
     D PLinc           S              2A
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
     C                   EVAL      *IN86 = *OFF
     C                   EVAL      Cancel = *OFF
     C                   EVAL      Exit = *OFF
      *
     C                   IF        (POpt = Amend) OR
     C                             (POpt = Enquire) OR
     C                             POpt = Delete
      *
      ** If found, Populate the Screen Fields
     C     PLinc         CHAIN     SDFTCTL0
     C                   IF        %FOUND(SDFTCTL0)
      *
     C                   EVAL      D0LINC = FTLINC
     C                   EVAL      D0CUTP = FTCUTP
     C                   EVAL      D0CSTY = FTCSTY
     C                   EVAL      D0CLCD = FTCLCD
     C                   EVAL      D0INFO = FTINFO
     C                   EVAL      D0EXMT = FTEXMT
      *
      ** Retrieve description for FATCA Classification Code
     C                   CALL      'AOFATCR0'
     C                   PARM      *BLANKS       PRtcd
     C                   PARM      '*KEY'        POptn
     C                   PARM      D0CLCD        PClas
     C     SDFATC        PARM      SDFATC        DSFDY
      *
     C                   IF        PRtcd = *BLANKS
     C                   EVAL      D0CLNM = FCDESC
     C                   ELSE
     C                   EVAL      D0CLNM = *BLANKS
     C                   ENDIF
      *
      ** Retrieve description for Local Institution Code
     C                   CALL      'AOINSTR0'
     C                   PARM      *BLANKS       PRtcd
     C                   PARM      '*KEY'        POptn
     C                   PARM      D0LINC        PLin
     C     SDINST        PARM      SDINST        DSFDY
      *
     C                   IF        PRtcd = *BLANKS
     C                   EVAL      D0LINM = AKLINM
     C                   ELSE
     C                   EVAL      D0LINM = *BLANKS
     C                   ENDIF
      *
     C                   EXSR      SRPopCUTPD
      *
     C                   ENDIF
      *
     C                   ELSE
      *
      ** If Not found, Set The Fields To Blank
     C                   EVAL      D0LINC = *BLANKS
     C                   EVAL      D0CUTP = *BLANKS
     C                   EVAL      D0CUTPD = *BLANKS
     C                   EVAL      D0CSTY = *BLANKS
     C                   EVAL      D0CSTYD = *BLANKS
     C                   EVAL      D0CLCD = *BLANKS
     C                   EVAL      D0CLNM = *BLANKS
     C                   EVAL      D0LINM = *BLANKS
     C                   EVAL      D0INFO = *BLANKS
     C                   EVAL      D0EXMT = *BLANKS
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
     C                   WRITE     SD000103F1
      *
      ** Message Subfile Control Format
     C                   WRITE     SD000103C0
      *
      ** Screen Format
     C                   EXFMT     SD000103F0
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
     C                   PARM                    PLinc
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
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRPopCUTPD  - Populate Customer Type/SubType Description      *
      *                                                               *
      * Called by: Main, SRFldVal                                     *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     SRPopCUTPD    BEGSR
      *
     C                   SELECT
     C                   WHEN      D0CUTP = 'F'
     C                   EVAL      D0CUTPD = 'Foreign Financial Institution'
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
     C                   SELECT
     C                   WHEN      D0CSTY = 'PO'
     C                   EVAL      D0CSTYD = 'Participating - Own GIIN'
     C                   WHEN      D0CSTY = 'PW'
     C                   EVAL      D0CSTYD = 'Participating - Without GIIN'
     C                   WHEN      D0CSTY = 'PS'
     C                   EVAL      D0CSTYD = 'Participating - With someone +
     C                                        else''s GIIN'
     C                   WHEN      D0CSTY = 'NP'
     C                   EVAL      D0CSTYD = 'Non-participating'
     C                   WHEN      D0CSTY = 'OW'
     C                   EVAL      D0CSTYD = 'Owner Document FFI'
     C                   WHEN      D0CSTY = 'AC'
     C                   EVAL      D0CSTYD = 'Active'
     C                   WHEN      D0CSTY = 'PA'
     C                   EVAL      D0CSTYD = 'Passive'
     C                   WHEN      D0CSTY = 'UN'
     C                   EVAL      D0CSTYD = 'Unknown (not decided yet)'
     C                   OTHER
     C                   EVAL      D0CSTYD = *BLANKS
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
      *
      ** Validation of Local Institution Code
      ** Must Be A Valid Local Institution Code
     C                   CALL      'AOINSTR0'
     C                   PARM      *BLANKS       PRtcd
     C                   PARM      '*KEY'        POptn
     C                   PARM      D0LINC        PLin
     C     SDINST        PARM      SDINST        DSFDY
      *
     C                   IF        D0LINC = *BLANKS
     C                   EVAL      WMsgId = 'USS0490'
     C                   EVAL      *IN81 = *ON
     C                   EVAL      WIdx = WIdx + 1
     C                   EXSR      SRErrDta
     C                   ELSE
     C                   IF        PRtcd = '*NRF'
     C                   EVAL      WMsgId = 'USS0281'
     C                   EVAL      *IN81 = *ON
     C                   EVAL      WIdx = WIdx + 1
     C                   EXSR      SRErrDta
     C                   ENDIF
     C                   ENDIF
      *
     C                   IF        PRtcd = *BLANKS
     C                   EVAL      WLINC = D0LINC
     C                   EVAL      D0LINC = AKLINC
     C                   EVAL      D0LINM = AKLINM
     C                   ENDIF
      *
      ** Local Institution Code Must be Unique In The File SDFTCTPD
     C     D0LINC        CHAIN     SDFTCTL0
     C                   IF        %FOUND(SDFTCTL0)
     C                   EVAL      WMsgId = 'USS0282'
     C                   EVAL      WIdx = WIdx + 1
     C                   EVAL      *IN81 = *ON
     C                   EXSR      SRErrDta
     C                   ENDIF
     C                   ENDIF
      *
      ** Validation of FATCA Customer Type
      ** The FATCA Customer Type must be either F (FFI) N (NFE)
      ** P (Physical Person) O (Other) or J (Joint Account)
     C                   IF        D0CUTP <> 'F' AND D0CUTP <> 'N' AND
     C                             D0CUTP <> 'P' AND D0CUTP <> 'O'
     C                             AND D0CUTP <> 'J'
     C                   EVAL      WMsgId = 'USS0279'
     C                   EVAL      *IN82 = *ON
     C                   EVAL      WIdx = WIdx + 1
     C                   EXSR      SRErrDta
     C                   ENDIF
      *
      ** Validation of FATCA Customer Sub-Type
      ** The FATCA Customer Sub-Type must be either PO, PW, PS, NP,
      ** UN or OW when FATCA customer type is F
     C                   IF        D0CUTP = 'F'
     C                   IF        D0CSTY <> 'PO' AND D0CSTY <> 'PW'
     C                             AND D0CSTY <> 'PS' AND
     C                             D0CSTY <> 'NP' AND D0CSTY <> 'UN'
     C                             AND D0CSTY <> 'OW'
     C                   EVAL      WMsgId = 'USS0262'
     C                   EVAL      *IN83 = *ON
     C                   EVAL      WIdx = WIdx + 1
     C                   EXSR      SRErrDta
     C                   ENDIF
     C                   ENDIF
      *
      ** The FATCA Customer Sub-Type must be either AC, PA or UN
      ** when FATCA customer type is N
     C                   IF        D0CUTP = 'N'
     C                   IF        D0CSTY <> 'AC' AND D0CSTY <> 'PA'
     C                             AND D0CSTY <> 'UN'
     C                   EVAL      WMsgId = 'USS0263'
     C                   EVAL      *IN83 = *ON
     C                   EVAL      WIdx = WIdx + 1
     C                   EXSR      SRErrDta
     C                   ENDIF
     C                   ENDIF
      *
      ** The FATCA Customer Sub-Type must be blank when FATCA
      ** customer type is P, J or O
     C                   IF        D0CUTP = 'P' OR D0CUTP = 'J'
     C                             OR D0CUTP = 'O'
     C                   IF        D0CSTY <> *BLANKS
     C                   EVAL      WMsgId = 'USS0264'
     C                   EVAL      *IN83 = *ON
     C                   EVAL      WIdx = WIdx + 1
     C                   EXSR      SRErrDta
     C                   ENDIF
     C                   ENDIF
      *
     C                   EXSR      SRPopCUTPD
      *
      ** Validation for FATCA Classification Code
      ** If Entered, FATCA Classification Code Must Be A Valid Code
     C                   IF        D0CLCD <> *BLANKS
     C                   CALL      'AOFATCR0'
     C                   PARM      *BLANKS       PRtcd
     C                   PARM      '*KEY'        POptn
     C                   PARM      D0CLCD        PClas
     C     SDFATC        PARM      SDFATC        DSFDY
      *
     C                   IF        PRtcd = '*NRF'
     C                   EVAL      *IN84 = *ON
     C                   EVAL      WMsgId = 'USS0173'
     C                   EVAL      WIdx = WIdx + 1
     C                   EXSR      SRErrDta
     C                   ENDIF
      *
     C                   IF        PRtcd = *BLANKS
     C                   EVAL      WCLCD = D0CLCD
     C                   EVAL      D0CLNM = FCDESC
     C                   EVAL      D0CLCD = FCCODE
     C                   ENDIF
     C                   ENDIF
      *
      ** Validation for FATCA Information Complete
      ** If Entered, this flag can only be set to 'A' (Automatic)
      ** or to 'N' (No) for customers of type 'Others'.
     C                   IF        D0INFO <> *BLANKS
      *
     C                   IF        (D0INFO <> 'A' AND D0INFO <> 'N'
     C                             AND D0CUTP = 'O') OR D0CUTP <> 'O'
     C                   EVAL      *IN85 = *ON
     C                   EVAL      WMsgId = 'USS0266'
     C                   EVAL      WIdx = WIdx + 1
     C                   EXSR      SRErrDta
     C                   ENDIF
      *
     C                   ENDIF
      *
      ** Validation for Exempt
      ** If Entered, this flag can only be set to 'Y' (Yes)
      ** or to 'N' (No) for customers of type 'Others'.
     C                   IF        D0EXMT <> *BLANKS
      *
     C                   IF        (D0EXMT <> 'Y' AND D0EXMT <> 'N'
     C                             AND D0CUTP = 'O') OR D0CUTP <> 'O'
     C                   EVAL      *IN86 = *ON
     C                   EVAL      WMsgId = 'USS0267'
     C                   EVAL      WIdx = WIdx + 1
     C                   EXSR      SRErrDta
     C                   ENDIF
      *
     C                   ENDIF
      *
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
     C                   IF        WIdx = 0 AND WLINC <> '?'
     C                             AND WCLCD <> '?'
      *
      ** If Valid, Update Database
     C                   EVAL      FTLINC = D0LINC
     C                   EVAL      FTCUTP = D0CUTP
     C                   EVAL      FTCSTY = D0CSTY
     C                   EVAL      FTCLCD = D0CLCD
     C                   EVAL      FTINFO = D0INFO
     C                   EVAL      FTEXMT = D0EXMT
     C                   EVAL      FTLCDT = BJRDNB
     C                   EVAL      FTCHTP = Amend
     C                   UPDATE    SDFTCTD0
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
     C                   DELETE    SDFTCTD0
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
     C                   IF        WIdx = 0 AND WLINC <> '?'
     C                             AND WCLCD <> '?'
      *
      ** If valid, Write To Database
     C                   EVAL      FTLINC = D0LINC
     C                   EVAL      FTCUTP = D0CUTP
     C                   EVAL      FTCSTY = D0CSTY
     C                   EVAL      FTINFO = D0INFO
     C                   EVAL      FTEXMT = D0EXMT
     C                   EVAL      FTLCDT = BJRDNB
     C                   EVAL      FTCHTP = Insert
     C                   EVAL      FTCLCD = D0CLCD
      *
     C                   WRITE     SDFTCTD0
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
     C                   EVAL      *IN86 = *OFF
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
