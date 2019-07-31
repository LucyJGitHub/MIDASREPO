000100000000     H DEBUG
000200000000     H COPYRIGHT('(c) Finastra International Limited 2018')
000300000000      *****************************************************************
000400000000/*STD *  RPGBASEBND                                                   *
000500000000/*EXI *  TEXT('Midas SD Validate KYC User')                           *
000600000000      *****************************************************************
000700000000      *                                                               *
000800000000      *  Midas - Standing Data Module                                 *
000900000000      *                                                               *
001000000000      *  SD000409 - Validate a Midas System Value for a KYC User      *
001100000000      *                                                               *
001200000000      *  (c) Finastra International Limited 2018                      *
001300000000      *                                                               *
001400000000      *  Last Amend No. CSD101             Date 07Dec18               *
001500000000      *                                                               *
001600000000      *---------------------------------------------------------------*
001700000000      *                                                               *
001800000000      *  CSD101 - Password Encryption                                 *
001900000000      *                                                               *
002000000000      *****************************************************************
002100000000
002200000000      ** =======
002300000000      ** D-specs
002400000000      ** =======
002500000000
002600000000      ** SD data area
002700000000     D SDSTAT        E DS                  EXTNAME(SDSTAT) DTAARA(SDSTAT)
002800000000
002900000000      ** Short Data Structure for Access Objects
003000000000     D DSFDY         E DS                  EXTNAME(DSFDY)
003100000000
003200000000      ** Data structure for NewTrntVal string
003300000000     D NewTrnTVal      DS           200
003400000000     D  DataToVal              1     25
003500000000
003600000000     D PReturnCode     S              7A
003700000000     D PAction         S              1A
003800000000     D PValidList      S             10A   INZ('SDINTFVL')
003900000000     D PLibrary        S             10A
004000000000     D PIDName         S            100A
004100000000     D PPass1          S            128A
004200000000     D PDescr          S           1000A
004300000000      ** +--------------------------------------+
004400000000      ** ¦ Declared variables                   ¦
004500000000      ** ¦ ==================                   ¦
004600000000      ** +--------------------------------------+
004700000000
004800000000      ** Error message id in GBSDUSRMSG
004900000000     D ErrMsgId        S              7
005000000000
005100000000      ** System value to be processed
005200000000     D SystemValue     S             20
005300000000
005400000000      ** Processing mode
005500000000     D ProcMode        S            190
005600000000
005700000000      ** General error indicator
005800000000     D GenError        S              1
005900000000
006000000000      ** Index for arrays of of error message ids etc
006100000000     D Idx             S              2P 0
006200000000
006300000000      ** Array of error message IDs
006400000000     D MsgIDXArr       S                   DIM(99) LIKE(ErrMsgId)
006500000000
006600000000     D @RTCD           S              7
006700000000     D @OPTN           S              7
006800000000     D @PFTC           S              5
006900000000
007000000000      *****************************************************************
007100000000      /EJECT
007200000000      *****************************************************************
007300000000
007400000000      ** Check if the KYC User is defined in Validation List
007500000000
007600000000     C                   IF        DataToVal <> *BLANKS
007700000000     C                   EVAL      PLibrary = LIBR + 'DMLIB'
007800000000     C                   EVAL      PIDName = 'COMPLKYC_'    + DataToVal
007900000000
008000000000     C                   CALL      'SD000404'
008100000000     C                   PARM      *Blanks       PReturnCode
008200000000     C                   PARM      'F'           PAction
008300000000     C                   PARM                    PValidList
008400000000     C                   PARM                    PLibrary
008500000000     C                   PARM                    PIDName
008600000000     C                   PARM      *Blanks       PPass1
008700000000     C                   PARM      *Blanks       PDescr
008800000000
008900000000      ** If value entered by user is not found on the Validation List
009000000000      ** then return an error
009100000000
009200000000     C                   IF        PReturnCode <> *Blanks
009300000000     C                   ADD       1             Idx
009400000000     C                   MOVEL     'PWD0018'     MsgIDXArr(Idx)
009500000000     C                   EVAL      GenError = 'Y'
009600000000     C                   EVAL       *INLR = *ON
009700000000     C                   RETURN
009800000000     C                   ENDIF
009900000000
010000000000      ** Catch all for unprocessed errors
010100000000
010200000000     C                   IF        PReturnCode <> *BLANKS
010300000000     C                   EXSR      *PSSR
010400000000     C                   ENDIF
010500000000     C                   ENDIF
010600000000
010700000000      ** Normal end processing
010800000000
010900000000     C                   EVAL      GenError = ' '
011000000000     C                   EVAL      *INLR = *ON
011100000000
011200000000     C                   RETURN
011300000000
011400000000      *****************************************************************
011500000000      /EJECT
011600000000      *****************************************************************
011700000000      *  *INZSR - Program Initialisation routine                      *
011800000000      *****************************************************************
011900000000
012000000000     C     *INZSR        BEGSR
012100000000
012200000000     C     *ENTRY        PLIST
012300000000
012400000000      ** System value to be processed
012500000000     C                   PARM                    SystemValue
012600000000      ** Value entered by user
012700000000     C                   PARM                    NewTrntVal
012800000000      ** Processing Mode
012900000000     C                   PARM                    ProcMode
013000000000      ** General Error Indicator
013100000000     C                   PARM                    GenError
013200000000      ** Error message ID (number of entries)
013300000000     C                   PARM                    Idx
013400000000      ** Error message ID (array)
013500000000     C                   PARM                    MsgIDXArr
013600000000
013700000000     C                   IN        SDSTAT
013800000000
013900000000     C                   ENDSR
014000000000
014100000000      *****************************************************************
014200000000      /EJECT
014300000000      *****************************************************************
014400000000      *                                                               *
014500000000      * *PSSR  - Program exception error routine                      *
014600000000      *          Called automatically if a program error occurs,      *
014700000000      *          or directly by the program code using EXSR.          *
014800000000      *          This subroutine DUMPs the program just once.         *
014900000000      *                                                               *
015000000000      *****************************************************************
015100000000
015200000000     C     *PSSR         BEGSR
015300000000
015400000000     C                   DUMP
015500000000
015600000000     C                   EVAL      GenError = 'Y'
015700000000     C                   EVAL      *INU7 = *ON
015800000000     C                   EVAL      *INU8 = *ON
015900000000     C                   EVAL      *INLR = *ON
016000000000
016100000000     C                   RETURN
016200000000
016300000000     C                   ENDSR
016400000000
