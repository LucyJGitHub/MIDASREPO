     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2023')
      *****************************************************************
/*STD *  RPGSQLBND                                                    *
/*EXI *  TEXT('MIR and MOR Sequence Generator')                       *
      *****************************************************************
      *                                                               *
      *  Midas - SWIFT Module                                         *
      *                                                               *
      *  MS100003 - MIR and MOR Sequence Generator                    *
      *                                                               *
      *  Function:  This program will generate sequences for MIR and  *
      *             MOR                                               *
      *                                                               *
      *  Called By: Various SWIFT Interfaces                          *
      *                                                               *
      *  (c) Finastra International Limited 2023                      *
      *                                                               *
      *  Last Amend No. CSW125 *CREATE      Date 20Mar23              *
      *                                                               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSW125 - MIR and MOR Sequence Generator                      *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  USE OF INDICATORS                                            *
      *                                                               *
      *    U7         Database error                                  *
      *    U8         Database error                                  *
      *                                                               *
      *****************************************************************
      *                                                               *
      *                                                               *
      *****************************************************************
      *
      ** Files
      *

      *****************************************************************
      /EJECT
      *****************************************************************
     DLDA            E DS                  EXTNAME(LDA) DTAARA(LDA)
      ** Local data area for database error details
      ** *LOCK IN LDA immediately before and OUT LDA immediately
      ** after each database error handling.
      **                                    134 141 DBFILE
      **       Defines:                     142 170 DBKEY
      **                                    171 180 DBPGM
      **                                    181 1830DBASE
      *

      ** External data structure for bank file
      *
     D SDBANK        E DS                  EXTNAME(SDBANKPD)

      ** First DS for Access Programs, Short data structure
      *
     D DSFDY         E DS                  EXTNAME(DSFDY)

      ** Parameters for converting Midas rundate YYMMDD format .
      *
     D ZMDAY           S              5P 0
     D ZMDATE          S              6A

      ** Entry Parameters for PLIST
      *
     DIN_MSGTYPE       S              3A
     DIN_UETR          S             36A
     DIN_MIR           S             28A
     DIN_MOR           S             28A
     DOUT_MIR          S             28A
     DOUT_MOR          S             28A
     DOUT_MORERR       S             10A
     DOUT_MIRERR       S             10A

      ** Entry Parameters for AOSVALR0
      *
     DP@OP01           S             20
     DP@VL01           S            200
     DP@OP02           S             20
     DP@VL02           S            200
     DP@OP03           S             20
     DP@VL03           S            200
     DP@OP04           S             20
     DP@VL04           S            200
     DP@OP05           S             20
     DP@VL05           S            200
     DP@OP06           S             20
     DP@VL06           S            200
     DP@OP07           S             20
     DP@VL07           S            200
     DP@OP08           S             20
     DP@VL08           S            200
     DP@OP09           S             20
     DP@VL09           S            200
     DP@OP10           S             20
     DP@VL10           S            200

      ** Work Fields
      *
     DMirSysV          S              1A
     DMorSysV          S              1A
     D@RtCd            S              7
     DDupMIR           S              1A
     DDupMOR           S              1A
     DwrkChar10        S             10A
     DwrkChar7         S              7A
     D@OPTN            S              7A

      *
      ** MIR: First 6 are the input date,
      **      The next 12 are Sender, (The 9th is always 'X')
      **        (The first 8 and last 3 are taken from BICFI)
      **      The last 10 are sequence numbers
      *
     DDSMir            DS
     DInpDat                          6A
     DTerAdd                         12A
     DSeqNumMir                      10A
      *
     DWrkMir           S             28A
      *
      ** MOR: First 6 are the Output date,
      **      The next 12 are Sender, (The 9th is always 'X')
      **        (The first 8 and last 3 are taken from BICFI)
      **      The next 6 are sequence numbers
      **      The last 4 are session numbers
      **      The system will treat sequence and session as
      *         one contiguous sequence
      *
     DDSMor            DS
     DOutDat                          6A
     DTerAdd2                        12A
     DSeqNumMor                      10A
      *
     DWrkMor           S             28A
      *
     DMsMsI2DS         DS
     DCurMIR                         28A
     DCurMOR                         28A

      ** Work Data Structures
      *
     DSeqDS            DS
     DDSMIRSeq                       10P 0
     DDSMORSeq                       10P 0

      **Constant
      *
     DNO_RECORD        c                   const(100)

      *****************************************************************
      /EJECT
      *****************************************************************
      * MAIN PROCESSING                                               *
      *****************************************************************

      ** Declare Cursors
      *
     C                   EXSR      DecCur
      ** Open and Fetch current values for sequences
      *
     C                   EXSR      OpnSeqCur
     C                   EXSR      FetSeqCur
      *
      ** Increment sequences
      *
     C                   IF        SQLCOD = NO_RECORD
     C                   CLEAR                   SeqDS
     C                   EVAL      DSMIRSeq = 0
     C                   EVAL      DSMORSeq = 0
     C                   EXSR      InitTab
     C                   ENDIF
      *
      ** Get system values
      *
     C                   EXSR      RtvSysVal
     C                   If        MirSysV = '2'
     C                             or IN_UETR = *blanks
     C                   EVAL      DSMIRSeq = DSMIRSeq + 1
     C                   Endif
     C                   If        MorSysV = '1'
     C                             or MorSysV = '2'
     C                   EVAL      DSMORSeq = DSMORSeq + 1
     C                   Endif
      *
      ** Generate MIR/MOR Sequence based on the next sequence (not the sequence on file)
      *
     C                   MOVE      IN_MIR        DSMir
     C                   MOVE      IN_MOR        DSMor
      *
      ** If sequence is blanks or zeroes
      ** then process this record, otherwise do nothing
      *
     C                   If        SeqNumMir = '0000000000'
     C                             OR SeqNumMir = '          '
     C                   EVAL      DupMIR = ' '
      *
      ** If SWIFT Input Date is zeroes or blanks
      ** Assign Midas Rundate in YYMMDD format
      *
     C                   If        InpDat = *blanks
     C                             or InpDat = '000000'
     C                   Eval      ZMDATE = ' '
     C                   EXSR      PoPDate
     C                   Eval      InpDat = ZMDATE
     C                   ENDIF
      *
      ** If SWIFT Output Date is zeroes or blanks
      ** Assign Midas Rundate in YYMMDD format
      *
     C                   If        OutDat = *blanks
     C                             or OutDat = '000000'
     C                   If        ZMDATE = *blanks
     C                   EXSR      PoPDate
     C                   else
     C                   Eval      OutDat = ZMDATE
     C                   endif
     C                   endif
      *
      ** If MirSysV = 2 and duplicate, loop until non-duplicate is generated
      *  If MirSysV = 1 and no UETR and duplicate, loop until non-duplicate is generated
      ** If MirSysV = 1 and with UETR, pass once
      *  If MirSysV = 3, pass once
      *
     C                   DOU       DupMIR = 'N'
     C                              and MirSysV = '2'
     C                             or DupMIR = 'N'
     C                              and MirSysV = '1'
     C                              and IN_UETR =*blanks
     C                             or MirSysV = '1'
     C                              and IN_UETR <>*blanks
     C                             or MirSysV = '3'
     C                   EXSR      ChkDupMir
     C                   ENDDO
     C                   If        DupMIR = 'Y'
     C                   EVAL      OUT_MIRERR = 'DupMIR'
     C                   Else
     C                   EVAL      OUT_MIRERR = *BLANKS
     C                   Endif
     C                   MOVE      DSMir         OUT_MIR
      *
      ** Loop until non-duplicate is generated
      ** Skip MOR process if MIR generation has failed
      ** If MorSysV = 3 pass once
      *
     C                   If        DupMIR <>'Y'
     C                   EVAL      DupMOR = ' '
     C                   DOU       DupMOR = 'N'
     C                             or MirSysV = '3'
     C                   EXSR      ChkDupMor
     C                   ENDDO
     C                   If        DupMOR = 'Y'
     C                   EVAL      OUT_MORERR = 'DupMOR'
     C                   Else
     C                   EVAL      OUT_MORERR = *BLANKS
     C                   Endif
     C                   Endif
     C                   MOVE      DSMor         OUT_MOR
      *
      ** Update sequences
      *
     C                   EXSR      UpdSeqCur
     C                   Endif

     C                   EXSR      CloSeqCur

      ** End Program
     C                   COMMIT
     C
     C                   EVAL      *INLR = *ON
     C                   RETURN

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * RtvSysVal  - Retrieve value of system value GenMIROpt and     *
      *              GenMOROpt                                        *
      *                                                               *
      *****************************************************************
     C     RtvSysVal     BEGSR
      *
     C                   EVAL      P@OP01 = 'GenMIROpt'
      *
      **  Option 1: Use UETR
      **    However, if 1 is set, but UETR is not provided, do Option 2
      **  Option 2: Use Unique Sequence
      **  Option 3: Do not Generate MIR Sequence
      *
     C                   CALL      'AOSVALR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM                    P@OP01
     C                   PARM      *BLANKS       P@VL01
     C                   PARM                    P@OP02
     C                   PARM      *BLANKS       P@VL02
     C                   PARM                    P@OP03
     C                   PARM      *BLANKS       P@VL03
     C                   PARM                    P@OP04
     C                   PARM      *BLANKS       P@VL04
     C                   PARM                    P@OP05
     C                   PARM      *BLANKS       P@VL05
     C                   PARM                    P@OP06
     C                   PARM      *BLANKS       P@VL06
     C                   PARM                    P@OP07
     C                   PARM      *BLANKS       P@VL07
     C                   PARM                    P@OP08
     C                   PARM      *BLANKS       P@VL08
     C                   PARM                    P@OP09
     C                   PARM      *BLANKS       P@VL09
     C                   PARM                    P@OP10
     C                   PARM      *BLANKS       P@VL10

     C                   IF        @RTCD <> *BLANKS
     C                   EVAL      DBASE = 001
     C                   EVAL      DBFILE = 'SDSVALPD'
     C                   EVAL      DBKEY = P@OP01
     C                   EVAL      DBPGM = 'AOSVALR0'
     C                   EXSR      *PSSR
     C                   ELSE
     C                   EVAL      MirSysV =  %TRIM(P@VL01)
     C                   ENDIF
      *
     C                   EVAL      P@OP01 = 'GenMOROpt'
      *
      **  Option 1: Use 10 digit sequence
      **  Option 2: Use 'ISO'+ 7 digit sequence
      **  Option 3: Do not Generate MOR Sequence
      *
     C                   CALL      'AOSVALR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM                    P@OP01
     C                   PARM      *BLANKS       P@VL01
     C                   PARM                    P@OP02
     C                   PARM      *BLANKS       P@VL02
     C                   PARM                    P@OP03
     C                   PARM      *BLANKS       P@VL03
     C                   PARM                    P@OP04
     C                   PARM      *BLANKS       P@VL04
     C                   PARM                    P@OP05
     C                   PARM      *BLANKS       P@VL05
     C                   PARM                    P@OP06
     C                   PARM      *BLANKS       P@VL06
     C                   PARM                    P@OP07
     C                   PARM      *BLANKS       P@VL07
     C                   PARM                    P@OP08
     C                   PARM      *BLANKS       P@VL08
     C                   PARM                    P@OP09
     C                   PARM      *BLANKS       P@VL09
     C                   PARM                    P@OP10
     C                   PARM      *BLANKS       P@VL10

     C                   IF        @RTCD <> *BLANKS
     C                   EVAL      DBASE = 002
     C                   EVAL      DBFILE = 'SDSVALPD'
     C                   EVAL      DBKEY = P@OP01
     C                   EVAL      DBPGM = 'AOSVALR0'
     C                   EXSR      *PSSR
     C                   ELSE
     C                   EVAL      MorSysV = %TRIM(P@VL01)
     C                   ENDIF
     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * PopDate - Retrieve value of system system and populate the    *
      *           input dates of MIR and Output date of MOR           *
      *                                                               *
      *****************************************************************
     C     PopDate       BEGSR
      *
      ** Access Bank details via access program (Includes Run Date)
      *  (database error handling done in access program)
     C                   CALL      'AOBANKR0'
     C                   PARM      '*DBERR '     @RTCD
     C                   PARM      '*FIRST '     @OPTN
     C     SDBANK        PARM      SDBANK        DSFDY

     C     @RTCD         IFNE      *BLANKS
     C     *LOCK         IN        LDA
     C                   MOVE      '003'         DBASE
     C                   MOVEL     'FIRST'       DBKEY
     C                   MOVEL     'SDBANKPD'    DBFILE
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF

      *
      ** Convert run date to YYMMDD, for Message Generation Date
      *
     C                   CALL      'ZM0060'                             15
     C                   PARM      BJRDNB        ZMDAY
     C                   PARM                    ZMDATE
     C     *IN15         IFEQ      '1'
     C     *LOCK         IN        LDA
     C                   MOVE      '004'         DBASE
     C                   MOVEL     '       '     DBKEY
     C                   MOVEL     'ZM0060'      DBFILE
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * InitTab - Initial Insert in MSMIRGTD. This is called only if  *
      *           the table is delivered empty                        *
      *                                                               *
      * Called by: main routine                                       *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     InitTab       BEGSR
      ** Close after an end of file
     C                   EXSR      CloSeqCur

      ** Reopen again for Insert
     C                   EXSR      OpnSeqCur

      ** Insert initial values
     C/exec SQL
     C+ insert into MSMIRGTD
     C+     (MIRSEQ, MORSEQ)
     C+ values(:DSMIRSeq, :DSMORSeq)
     C/end-exec
      *
     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * ChkDupMir - Checks for duplicate MIR in MSMSI2PD              *
      *                                                               *
      *                                                               *
      * Called by: main routine                                       *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     ChkDupMir     BEGSR
     C                   IF        MirSysV = '1'
     C                             and IN_UETR <> *BLANKS
     C                   EVAL      SeqNumMir = %SUBST(IN_UETR:1:9) + '+'
     C                   ElseIf    MirSysV = '2'
     C                             or IN_UETR = *BLANKS
     C                   EVAL      SeqNumMir = '0000000000'
     C                   EVAL      wrkChar10 = '0000000000'
     C                   EVAL      wrkChar10 = %EDITC(DSMIRSeq:'X')
     C                   MOVE      wrkChar10     SeqNumMir
     C                   ENDIF
     C                   MOVE      DSMir         WrkMir
      *
      ** Open MSMSI2PD Cursor
      *
     C/exec SQL
     C+ Open MsMsCurMir
     C/end-exec
      *
      ** Fetch from MSMSI2PD where MIR = WrkMir
      *
     C/exec SQL
     C+ fetch next from MsMsCurMir into :CurMIR
     C/end-exec

     C                   IF        SQLCOD = NO_RECORD
     C                   EVAL      DupMIR = 'N'
     C                   ELSE
     C                   EVAL      DupMIR = 'Y'
     C                   If        MirSysV = '2'
     C                             or MirSysV = '1'
     C                             and IN_UETR = *blanks
     C                   EVAL      DSMIRSeq = DSMIRSeq  + 1
     C                   Endif
     C                   ENDIF
     C/exec SQL
     C+ Close MsMsCurMir
     C/end-exec
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * ChkDupMor - Checks for duplicate MOR in MSMSI2PD              *
      *                                                               *
      *                                                               *
      * Called by: main routine                                       *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     ChkDupMor     BEGSR
     C                   EVAL      SeqNumMor = '0000000000'
     C                   EVAL      wrkChar10 = '0000000000'
     C                   EVAL      wrkChar7 = '0000000'
     C                   IF        MorSysV = '1'
     C                   EVALR     wrkChar10 = %EDITC(DSMORSeq:'X')
     C                   MOVE      wrkChar10     SeqNumMor
     C                   ElseIf    MorSysV = '2'
     C                   EVALR     wrkChar7 = %EDITC(DSMORSeq:'X')
     C                   EVALR     wrkChar10 = 'ISO' + wrkChar7
     C                   MOVE      wrkChar10     SeqNumMor
     C                   ENDIF
     C                   MOVE      DSMor         wrkMor
      *
      ** Open MSMSI2PD Cursor
      *
     C/exec SQL
     C+ Open MsMsCurMor
     C/end-exec

      *
      ** Fetch from MSMSI2PD where MOR = wrkMor
      *
     C/exec SQL
     C+ fetch next from MsMsCurMor into :CurMOR
     C/end-exec

     C                   IF        SQLCOD = NO_RECORD
     C                   EVAL      DupMOR = 'N'
     C                   ELSE
     C                   EVAL      DupMOR = 'Y'
     C                   If        MorSysV <>'3'
     C                   EVAL      DSMORSeq = DSMORSeq  + 1
     C                   Endif
     C                   ENDIF
     C/exec SQL
     C+ Close MsMsCurMor
     C/end-exec
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * DecCur  - Declare Cursors                                     *
      *                                                               *
      *****************************************************************
     C     DecCur        BEGSR
      *
     C/exec SQL
     C+ declare SeqCur Cursor for
     C+ select
     C+   MIRSEQ,
     C+   MORSEQ
     C+ from MSMIRGTD
     C+ for update of
     C+   MIRSEQ,
     C+   MORSEQ
     C/end-exec
      *
     C/exec SQL
     C+ declare MsMsCurMir Cursor for
     C+ select
     C+   MIR
     C+ from MSMSI2PD
     C+ where MIR = :WrkMir
     C/end-exec

     C/exec SQL
     C+ declare MsMsCurMor Cursor for
     C+ select
     C+   MOR
     C+ from MSMSI2PD
     C+ where MOR = :WrkMor
     C/end-exec
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * UpdSeqCur - Update Seq Cursor                                 *
      *                                                               *
      *****************************************************************
     C     UpdSeqCur     BEGSR
      *
      ** Update sequences
      *
     C/exec SQL
     C+ update MSMIRGTD
     C+ set MIRSEQ = :DSMIRSeq,
     C+     MORSEQ = :DSMORSeq
     C+ where current of SeqCur
     C/end-exec
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * OpnSeqCur -  Open Cursor                                      *
      *                                                               *
      *****************************************************************
     C     OpnSeqCur     BEGSR
     C/exec SQL
     C+ open SeqCur
     C/end-exec
      *

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * FetSeqCur -  Fetch Cursor                                     *
      *                                                               *
      *****************************************************************
     C     FetSeqCur     BEGSR
     C/exec SQL
     C+ fetch next from SeqCur into :SeqDS
     C/end-exec

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * CloSeqCur - Close Seq Cursor                                  *
      *                                                               *
      *****************************************************************
     C     CloSeqCur     BEGSR
     C/exec SQL
     C+ close SeqCur
     C/end-exec

     C                   ENDSR
      *****************************************************************
      /EJECT

      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      * Called by: Implicitly on program activation                   *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR

      ** Program Parameters

     C     *ENTRY        PLIST
     C                   PARM                    IN_MSGTYPE
     C                   PARM                    IN_UETR
     C                   PARM                    IN_MIR
     C                   PARM                    IN_MOR
     C                   PARM                    OUT_MIR
     C                   PARM                    OUT_MOR
     C                   PARM                    OUT_MIRERR
     C                   PARM                    OUT_MORERR
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *PSSR  - Program exception error routine                      *
      *          Called automatically if a program error occurs,      *
      *          or directly by the program code using EXSR.          *
      *          This subroutine DUMPs the program just once.         *
      *                                                               *
      *****************************************************************
     C     *PSSR         BEGSR

     C                   DUMP

     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   EVAL      OUT_MIRERR = 'DBASE'
     C                   EVAL      OUT_MORERR = 'DBASE'
     C                   RETURN

     C                   ENDSR
      *****************************************************************
      /EJECT
