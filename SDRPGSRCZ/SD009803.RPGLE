     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2008')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas SD MIC Code maintenance display file')
      *****************************************************************
      *                                                               *
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SD009803 -This Module Is For SD MIC Code Maintenance Display *
      *            File                                               *
      *                                                               *
      *  Function:  This program is used for the maintenance of       *
      *             MIC Code file                                     *
      *                                                               *
      *  Called By: SD009802 - MIDAS SD Market Identification Code    *
      *                         Subfile                               *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2008            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *  Last Amend No. BUG20971           Date 03Sep08               *
      *  Prev Amend No. BUG21093           Date 18Sep08               *
      *                 BUG19910           Date 28Jul08               *
      *                 BUG19758           Date 03Jul08               *
      *                 BUG19525           Date 25Jun08               *
      *                 CSW208  *CREATE    Date 15Apr08               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  BUG20971 - MIC Delete/SE Market is allowed                   *
      *  BUG21093 - Time Zone code is not accepted                    *
      *  BUG19910 - Amend message IDs                                 *
      *  BUG19758 - Various error                                     *
      *  BUG19525 - Time Zone Code Desciption must be highlighted on  *
      *             the screen (Recompile)                            *
      *  CSW208 - SWIFT 2008 Changes                                  *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use Of Indicators.                                           *
      *                                                               *
      *    03 - Exit                                                  *
      *    10 - Delete Record                                         *
      *    12 - Cancel                                                *
      *    22 - Protect MIC Code                                      *
      *    22 - Under line MIC Code                                   *
      *    24 - Footer                                                *
      *    29 - Protect Fields                                        *
      *    29 - Under line Fields                                     *
      *    32 - SflMsgEnd                                             *
      *    81 - Reverse Image                                         *
      *    82 - Reverse Image                                         *
      *    83 - Reverse Image                                         *
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
      *  SRGetTIZone - Retrieve Time Zone Record                      *
      *  SRCvtDT - Convert Midas Day Format                           *                     BUG21093
      *  *PSSR    - Error processing                                  *
      *  *INZSR   - Initialise                                        *
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
      ** Market Identification Code File
     FSDMICCL0  UF A E           K DISK    INFSR(*PSSR)
     F                                     COMMIT
      *
      ** MIC Code Maintenance
     FSD009803DFCF   E             WORKSTN
      *
      ** Time Zone History
      *
     F*                                     RENAME(SDTIZHD0:SDTIZUPD)
      *
      ** Time Zone Level History
      *
     FSDTZLHL0  UF A E           K DISK
     F                                     RENAME(SDTZLHD0:SDTZLUPD)
      *
      ** DST Code Retrieval File
     FSDDSTCL1  If   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(SDDSTCD0:@DSTCL1)
     FSEMKC     IF   E           K DISK                                                     BUG20971
      *
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
      ** First DS for Access Programs, Short Data Structure
     D DSFDY         E DS                  EXTNAME(DSFDY)
      *
      ** DS SDCTRY Based On SDCTRYPD
     D SDCTRY        E DS                  EXTNAME(SDCTRYPD)
      *
      ** DS SDBANK Based On SDBANKPD
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      *
     D SDTIZO        E DS                  EXTNAME(SDTIZOPD)
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
     D TimeStamp       S                   LIKE(TVTMST)
     D IndPointer      S               *   Inz(%Addr(*IN))
     D Error           S              1A
     D YEAR            S              4S 0
      *
      ** AOTIZOR0 Parameters
      *
     D PTzld           S              1A   Inz(*Blanks)
      *
     D WOfSt           S              3S 0 Inz(*ZEROS)
     D WTmpOffset      S              4S 0
     D WTime           S               T   TIMFMT(*Hms)
     D WTime1          S              6A
     D WTmp            S              6A
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
      ** Entry Parameter
     D POpt            S              1A
     D PBranch         S              3A
     D PZone           S             10A   Inz(*Blanks)
     D PMicCod         S              4A
      *
      ** Work Variable
     D WMsgId          S              7A
     D WMsgDta         S             45A
     D WRun            S              1A
     D WIdx            S              3P 0
      *
     D TimCodeChg      C                   CONST('M')
      *
      ** --------------------------------------------------------------
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
      ** Turn Off All Reverse Image Indicators
     C                   EVAL      *IN81 = *OFF
     C                   EVAL      *IN82 = *OFF
     C                   EVAL      *IN83 = *OFF
     C                   EVAL      *IN84 = *OFF
     C                   EVAL      Cancel = *OFF
     C                   EVAL      Exit = *OFF
      *
      ** Populate The Screen Field
     C                   IF        (POpt = Amend) OR
     C                             (POpt = Enquire) OR
     C                             (POpt = Delete)
      *
      ** If found, Then Populate the Screen Fields
     C     PMicCod       CHAIN     SDMICCL0
     C                   IF        %FOUND(SDMICCL0)
      *
     C                   EVAL      D0CCOD = MICCOD
     C                   EVAL      D0CCTY = MICCTY
     C                   EVAL      D0CACM = MICACM
     C                   EVAL      D0CCIT = MICCIT
     C                   EVAL      D0DES1 = %SUBST(MICDES:1:60)
     C                   EVAL      D0DES2 = %SUBST(MICDES:61:10)
     C                   EVAL      D0TZCD = MITZCD
     C                   EXSR      SRGetTIZone
      *
     C                   ENDIF
      *
      ** If Not found, Then Set The Blank Value.
     C                   ELSE
      *
     C                   EVAL      D0CCOD = *BLANKS
     C                   EVAL      D0CCTY = *BLANKS
     C                   EVAL      D0CACM = *BLANKS
     C                   EVAL      D0CCIT = *BLANKS
     C                   EVAL      D0DES1 = *BLANKS
     C                   EVAL      D0DES2 = *BLANKS
     C                   EVAL      D0TZCD = *BLANKS
     C                   EVAL      D0TZDS = *BLANKS
      *
     C                   ENDIF
      *
      ** If F3 And F12 Not Active
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
     C                   WRITE     SD009803F1
      *
      ** Message Subfile Control Format
     C                   WRITE     SD009803C0
      *
      ** Screen Format
     C                   EXFMT     SD009803F0
      *
     C                   SELECT
      *
      ** Process Based On the Function Key Pressed
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
      *  *INZSR - Program Initialisation Routine                      *
      *                                                               *
      *  Called by: Implicitly On Program Activation                  *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
      *
     C     *INZSR        BEGSR
      *
     C     *ENTRY        PLIST
     C                   PARM                    POpt
     C                   PARM                    PMicCod
     C                   PARM                    PRtcd
      *
      **  Key List
      *
     C     KEYD1         KLIST
     C                   KFLD                    TZDSTC
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
     C                   EVAL      D0WID = PsJobName
     C                   EVAL      D0USER = PsUser
     C                   EVAL      D0MRDT = BJMRDT
      *
      ** Initialise Subfile Program Queue And Message File
     C                   EVAL      D1PGMQ = '*'
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
      *  SRFldVal - Validate The Data Of The Fields                   *
      *                                                               *
      *  Called by: MAIN Processing, SRAmend, SRInsert                *
      *                                                               *
      *  Calls: SRErrDta, *PSSR                                       *
      *                                                               *
      *****************************************************************
      *
     C     SRFldVal      BEGSR
     C                   IF        (POpt = Insert) AND
     C                             (D0CCOD = *BLANKS)
      *
      ** MIC Code Can Not be Blank
     C**********         EVAL      WMsgId = 'USR4050'                                       BUG19910
     C                   EVAL      WMsgId = 'USR6700'                                       BUG19910
     C                   EVAL      *IN81 = *ON
     C                   EVAL      WIdx = WIdx + 1
     C                   EXSR      SRErrDta
      *
     C                   ELSEIF    (POpt = Insert) AND
     C                             (D0CCOD <> *BLANKS)
      *
      ** MIC Code Should Be Equal To Four Character
     C                   IF        %LEN(%TRIM(D0CCOD)) < 4
     C**********         EVAL      WMsgId = 'USR4052'                                       BUG19910
     C                   EVAL      WMsgId = 'USR6702'                                       BUG19910
     C                   EVAL      WIdx = WIdx + 1
     C                   EVAL      *IN81 = *ON
     C                   EXSR      SRErrDta
     C                   ENDIF
      *
      ** Perform Chain Operation With MIC Code On The File SDMICCL0
      ** MIC Code Should Be Unique In the File
      *
     C     D0CCOD        CHAIN     SDMICCL0
     C                   IF        %FOUND(SDMICCL0)
     C**********         EVAL      WMsgId = 'USR4051'                                       BUG19910
     C                   EVAL      WMsgId = 'USR6701'                                       BUG19910
     C                   EVAL      WIdx = WIdx + 1
     C                   EVAL      *IN81 = *ON
     C                   EXSR      SRErrDta
     C                   ENDIF
      *
     C                   ENDIF
      *
      ** Country Code Cannot Be Blank
     C                   IF        D0CCTY = *BLANKS
     C**********         EVAL      WMsgId = 'USR4054'                                       BUG19910
     C                   EVAL      WMsgId = 'USR6704'                                       BUG19910
     C                   EVAL      *IN82 = *ON
     C                   EVAL      WIdx = WIdx + 1
     C                   EXSR      SRErrDta
      *
     C                   ELSEIF    D0CCTY <> *BLANKS
      *
      ** Check for the valid Country Code
     C                   CALL      'AOCTRYR0'
     C                   PARM      *BLANKS       PRtcd
     C                   PARM      '*VERIFY'     POptn
     C                   PARM                    D0CCTY
     C     SDCTRY        PARM      SDCTRY        DSFDY
      *
     C                   IF        (PRtcd <> *BLANKS) AND
     C                             (PRtcd <> '*NRF  ') AND
     C                             (PRtcd <> '*NOSEL')
      *
     C                   EVAL      DBKEY = POptn
     C                   EVAL      DBFILE = 'SDCTRYPD'
     C                   EVAL      DBASE = 002
     C                   EXSR      *PSSR
      *
     C                   ELSEIF    (PRtcd = '*NRF  ') OR
     C                             (PRtcd = '*NOSEL')
     C**********         EVAL      WMsgId = 'USR4055'                                       BUG19910
     C                   EVAL      WMsgId = 'USR6705'                                       BUG19910
     C                   EVAL      *IN82 = *ON
     C                   EVAL      WIdx = WIdx + 1
     C                   EXSR      SRErrDta
      *
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   IF        D0DES1 = *BLANKS
     C**********         EVAL      WMsgId = 'USR4053'                                       BUG19910
     C                   EVAL      WMsgId = 'USR6703'                                       BUG19910
     C                   EVAL      *IN83 = *ON
     C                   EVAL      WIdx = WIdx + 1
     C                   EXSR      SRErrDta
     C                   ENDIF
      *
     C                   IF        D0TZCD = *BLANKS
     C                   EVAL      WMsgId = 'SWF0022'
     C                   EVAL      *IN84 = *ON
     C                   EVAL      WIdx = WIdx + 1
     C                   EXSR      SRErrDta
     C                   ELSE
     C                   EXSR      SRGetTIZone
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
      ** Update Time Zone History File
      *
     C                   CALL      'ZAGENTS'
     C                   PARM                    TimeStamp
      *
     C                   MOVE      'N'           #WCOUNT           1
     C     *LOVAL        SETLL     SDTZLHL0
     C                   READ      SDTZLHL0
     C                   DOW       NOT (%EOF(SDTZLHL0))
     C                   MOVE      'Y'           #WCOUNT
     C                   IF        TVMICC = MICCOD AND TVRECI <> '*'
      *
      ** If the record exist on the same day, update with recor id as '*'  then
      *
     C                   IF        TVEFFD = BJRDNB AND MITZCD <> TVTZCD
     C                   EVAL      TVRECI = '*'
     C                   MOVE      TimeStamp     TVTMST
     C                   UPDATE    SDTZLUPD
      *
      ** Output a new record in Time Zone History File
      *
     C                   EXSR      SRUpdHst
     C                   WRITE     SDTZLUPD
     C                   MOVE      'E'           #WCOUNT2          1
     C                   LEAVE
     C                   ENDIF
     C                   ENDIF
     C                   READ      SDTZLHL0
     C                   ENDDO
      *
     C                   IF        #WCOUNT = 'N' OR
     C                             (#WCOUNT = 'Y' AND #WCOUNT2 <> 'E')
     C                   EXSR      SRUpdHst
     C                   IF        D0TZCD <> MITZCD
     C                   WRITE     SDTZLUPD
     C                   ENDIF
     C                   ENDIF
      *
      ** If Valid, Update Database
     C                   EVAL      MICCOD = D0CCOD
     C                   EVAL      MICCTY = D0CCTY
     C                   EVAL      MICACM = D0CACM
     C                   EVAL      MICCIT = D0CCIT
     C                   EVAL      MICDES = (D0DES1 + D0DES2)
     C                   EVAL      MITZCD = D0TZCD
     C                   EVAL      MICLCD = BJRDNB
     C                   EVAL      MICTYL = Amend
      *
     C                   EXSR      SRGetTIZone
      *
     C                   IF        Widx = 0                                                 BUG19758
      *                                                                                     BUG19758
      ** Clear Program Message Queue                                                        BUG19758
     C                   CALL      'ZA0250'                                                 BUG19758
     C**********         EVAL      CANCEL = *ON                                             BUG19758
     C                   EVAL      *IN22 = *ON
     C                   EVAL      *IN24 = *OFF
     C                   EVAL      *IN29 = *ON
     C                   WRITE     SD009803C0                                               BUG19758
     C                   EXFMT     SD009803F0
     C                   IF        Cancel = *Off and Exit = *Off                            BUG19758
      *
      ** Update the MIC Code file
     C                   UPDATE    SDMICCD0
      *
     C                   EVAL      Cancel = *ON
     C                   ENDIF                                                              BUG19758
     C                   ENDIF                                                              BUG19758
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
      ** Do not allow deletion of MIC if SE Market is linked to it.                         BUG20971
      *                                                                                     BUG20971
     C                   MOVE      'N'           WCOUNT            1                        BUG20971
     C     *LOVAL        SETLL     SEMKC                                                    BUG20971
     C                   READ      SEMKC                                                    BUG20971
     C                   DOW       NOT (%EOF(SEMKC))                                        BUG20971
     C                   IF        PMicCod = SWMKTC  AND                                    BUG20971
     C                             RECI = 'D'                                               BUG20971
     C                   MOVE      'Y'           WCOUNT                                     BUG20971
     C                   ENDIF                                                              BUG20971
     C                   READ      SEMKC                                                    BUG20971
     C                   ENDDO                                                              BUG20971
      *                                                                                     BUG20971
     C                   IF        WCOUNT <> 'Y'                                            BUG20971
     C                   IF        *IN10 = *ON
     C                   DELETE    SDMICCL0
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
     C                   ELSE                                                               BUG20971
     C                   EVAL      WMsgId = 'SWF0054'                                       BUG20971
     C                   EVAL      *IN81 = *ON                                              BUG20971
     C                   EVAL      WIdx = WIdx + 1                                          BUG20971
     C                   EXSR      SRErrDta                                                 BUG20971
     C                   ENDIF                                                              BUG20971
      *                                                                                     BUG20971
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
      *  Calls: SRFldVal, SRErrDta                                    *
      *                                                               *
      *****************************************************************
      *
     C     SRInsert      BEGSR
      *
     C                   EXSR      SRReset
      *
     C                   EXSR      SRFldVal
      *
     C                   IF        WIdx = 0
      *
     C                   EVAL      MICCOD = D0CCOD
     C                   EVAL      MICCTY = D0CCTY
     C                   EVAL      MICACM = D0CACM
     C                   EVAL      MICCIT = D0CCIT
     C                   EVAL      MICDES = (D0DES1 + D0DES2)
     C                   EVAL      MITZCD = D0TZCD
     C                   EVAL      MICLCD = BJRDNB
     C                   EVAL      MICTYL = Insert
      *
     C                   EXSR      SRGetTIZone
      *
     C                   IF        Widx = 0                                                 BUG19758
      *                                                                                     BUG19758
      ** Clear Program Message Queue                                                        BUG19758
     C                   CALL      'ZA0250'                                                 BUG19758
     C**********         EVAL      CANCEL = *ON                                             BUG19758
     C                   EVAL      *IN22 = *ON
     C                   EVAL      *IN24 = *OFF
     C                   EVAL      *IN29 = *ON
     C                   WRITE     SD009803C0                                               BUG19758
     C                   EXFMT     SD009803F0
     C
     C                   IF        Cancel = *Off and Exit = *Off                            BUG19758
      *
      ** Write record to the MIC Code file
     C                   WRITE     SDMICCD0
      *
     C                   EVAL      Cancel = *ON
     C                   ENDIF                                                              BUG19758
     C                   ENDIF                                                              BUG19758
      *
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRGetTIZone - Retrieve Time Zone Record                      *
      *                                                               *
      *  Called by:  MAIN Processing, SRAmend, SRInsert               *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
      *
     C     SRGetTIZone   BEGSR
     C                   EVAL      PZMsgId = *BLANKS
     C                   EVAL      PZMsgId = WMsgId
      *                                                                                     BUG21093
      ** Get Current year                                                                   BUG21093
      *                                                                                     BUG21093
     C                   MOVE      BJRDNB        MidasDayNo                                 BUG21093
     C                   EXSR      SRCvtDt                                                  BUG21093
     C                   Z-ADD     *ZEROS        YEAR                                       BUG21093
     C                   IF        PDateOut > 0                                             BUG21093
     C                   IF        BJDFIN  = 'D'                                            BUG21093
     C                   EVAL      YEAR = %Subdt(%Date(PDateOut:*DMY) :                     BUG21093
     C                                         *Years)                                      BUG21093
     C                   ELSE                                                               BUG21093
     C                   EVAL      YEAR = %Subdt(%Date(PDateoUt:*MDY) :                     BUG21093
     C                                         *Years)                                      BUG21093
     C                   ENDIF                                                              BUG21093
     C                   ENDIF                                                              BUG21093
      *
      ** Call Access Object
      *
     C                   CALL      'AOTIZOR0'
     C                   PARM      *BLANKS       PRtcd
     C                   PARM      '*KEY'        POptn
     C                   PARM                    D0TZCD
     C*********          PARM      *YEAR         YEAR                                       BUG21093
     C                   PARM                    YEAR                                       BUG21093
     C                   PARM                    SDTIZO
      *
     C                   IF        PRtcd   =  *BLANKS  and
     C                             D0TZCD <> '?'
     C                   EVAL      D0TZDS  = TZDESC
     C                   ENDIF
      *
     C                   IF        PRtcd  =  *BLANKS  AND
     C                             D0TZCD =  '?'
     C                   EVAL      PRtcd  =  '*ERROR'
     C                   ENDIF
      *
     C                   IF        PRtcd   = '*ERROR'
     C**********         EVAL      WMsgId = 'SWF0023'                                       BUG19758
     C                   EVAL      WMsgId = 'SWF0032'                                       BUG19758
     C                   EVAL      *IN84 = *ON
     C                   EVAL      WIdx = WIdx + 1
     C                   EXSR      SRErrDta
     C                   ENDIF
      *
     C                   IF        PRtcd   = '*NRF'
     C                   CALL      'AOTIZOR0'
     C                   PARM      *BLANKS       PRtcd
     C                   PARM      '*KEY'        POptn
     C                   PARM                    D0TZCD
     C                   PARM                    YEAR
     C                   PARM                    SDTIZO
     C                   IF        PRtcd   =  *BLANKS  and
     C                             D0TZCD <> '?'
     C                   EVAL      D0TZDS  = TZDESC
     C                   ENDIF
      *
     C                   IF        PRtcd  =  *BLANKS  and
     C                             D0TZCD =  '?'
     C                   EVAL      PRtcd  =  '*ERROR'
     C                   ENDIF
      *
     C                   IF        PRtcd  =  '*NRF'
     C                   EVAL      PRtcd  =  '*ERROR'
     C                   ENDIF
      *
     C                   IF        PRtcd   = '*ERROR'
     C**********         EVAL      WMsgId = 'SWF0023'                                       BUG19758
     C                   EVAL      WMsgId = 'SWF0032'                                       BUG19758
     C                   EVAL      *IN84 = *ON
     C                   EVAL      WIdx = WIdx + 1
     C                   EXSR      SRErrDta
     C                   ENDIF
     C                   ENDIF
      *
     C                   ENDSR
      *
      *
      *****************************************************************                     BUG21093
      /EJECT                                                                                BUG21093
      *****************************************************************                     BUG21093
      *                                                               *                     BUG21093
      *  SRCvtDt- Convert Midas Day Format to DDMMYY/MMDDYY           *                     BUG21093
      *                                                               *                     BUG21093
      *  Called By: SRGetTIZone                                       *                     BUG21093
      *                                                               *                     BUG21093
      *  Calls: None                                                  *                     BUG21093
      *                                                               *                     BUG21093
      *****************************************************************                     BUG21093
     C     SRCvtDt       BEGSR                                                              BUG21093
      *                                                                                     BUG21093
     C                   CALL      'ZDATE2'                                                 BUG21093
     C                   PARM                    MidasDayNo        5 0                      BUG21093
     C                   PARM                    BJDFIN                                     BUG21093
     C                   PARM      *ZEROS        PDateOut          6 0                      BUG21093
     C                   PARM      *BLANKS       PADateOut         7                        BUG21093
      *                                                                                     BUG21093
     C                   ENDSR                                                              BUG21093
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
      *
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
      *  Calls: None                                                  *
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
      *
      ** Clear Error Fields
     C                   EVAL      PZMsgId = *BLANKS
     C                   EVAL      PZMsgData = *BLANKS
     C                   EVAL      WMsgId  = *BLANKS
     C                   EVAL      WMsgDta = *BLANKS
     C                   EVAL      WIdx = *ZEROS
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *PSSR - Program Exception Error Routine                      *
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
      *                                                               *
      *  SrUpdHst - Save Time Zone Code changes in Time Zone          *
      *             History File                                      *
      *                                                               *
      *  Called By: SRAmend                                           *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
     C     SrUpdHst      BEGSR
      *
      *
     C                   EVAL      TVRECI = 'D'
     C                   EVAL      TVTZLC = 'M'
     C                   EVAL      TVZONE = *BLANKS
     C                   EVAL      TVBRCA = BJSBRC
     C                   EVAL      TVMICC = MICCOD
     C                   EVAL      TVTZCD = MITZCD
     C                   EVAL      TVYEAR = TZYEAR
      *
     C                   EVAL      TVEFFD = BJRDNB
     C                   MOVE      TimeStamp     TVTMST
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrCalcOff - Calculate Offset                                 *
      *                                                               *
      *  Called By: SRUpdHst                                          *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
     C     SRCalcOff     BEGSR
      *
      ** Calculate Effective Offset
      *
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
