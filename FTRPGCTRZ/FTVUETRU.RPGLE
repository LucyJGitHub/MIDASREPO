000100191121     H DEBUG
000200191121      *****************************************************************
000300191121/*STD *  RPGBASEMOD                                                   *
000400191128/*EXI *  TEXT('Midas FT Update Unique End-to-End Reference')          *
000500191121      *****************************************************************
000600191121      *                                                               *
000700191121      *  Midas - Standard Subprograms                                 *
000800191121      *                                                               *
000900191128      *  FTVUETRU  - Update Unique End-to-End Reference               *
001000191121      *                                                               *
001100191121      *    This source is centrally supported and must ONLY be        *
001200191121      *    amended by Core Development Personnel                      *
001300191121      *                                                               *
001400191121      *    /COPY, Client or Country amendments must not be            *
001500191121      *    applied to this source.                                    *
001600191121      *                                                               *
001700191121      *  (c) Finastra International Limited 2019                      *
001800191121      *                                                               *
001900191121      *  Last Amend No. ERZ248  *Create    Date 18Nov19               *
002000191121      *  Prev Amend No.                    Date DDMMMYY               *
002100191121      *                                                               *
002200191121      *---------------------------------------------------------------*
002300191121      *                                                               *
002400191121      *  ERZ248 - SWIFT UETR via OPAY API                             *
002500191121      *                                                               *
002600191121      *****************************************************************
002700191121      ** +--------------------------------------+
002800191121      ** ¦ F-specs                              ¦
002900191121      ** ¦ =======                              ¦
003000191121      ** +--------------------------------------+
003100191121
003200191121      *****************************************************************
003300191121      /EJECT
003400191121      *****************************************************************
003500191121      ** +--------------------------------------+
003600191121      ** ¦ Automatically included D-specs       ¦
003700191121      ** ¦ ==============================       ¦
003800191121      ** +--------------------------------------+
003900191121      **
004000191121      ** Standard D-specs
004100191121      ** ================
004200191121      **
004300191121      ** The following /COPY line includes the LDA layout,
004400191121      ** the copyright array definition,
004500191121      ** and the following named constants:
004600191121      **    True       logical = *on (for indcator processing)
004700191121      **    False      logical = *off (for indcator processing)
004800191121      **    DBErrCtl   10A     = 'DBERRCTL' (the name of the database error
004900191121      **                                    handler)
005000191121      ** and the following variables:
005100191121      **    RunBefore  1A (for the PSSR)
005200191121
005300191121     D/COPY ZACPYSRC,STD_D_SPEC
005400191121
005500191121      ** Include the standard declares
005600191121     D/COPY ZACPYSRC,STDDECLARE
005700191121
005800191121      ** Program Status Data Structure
005900191121      ** =============================
006000191121      ** The following /COPY line includes all the defined fields in the
006100191121      ** PSDS.  They have meaningful names, prefixed by 'PS'.
006200191121
006300191121     D/COPY ZACPYSRC,PSDS
006400191121
006500191121      ** The following /COPY line includes definitions for the above fields
006600191121      ** as #ProcPgm, #ProcMod and #ProcName.  They are based on the
006700191121      ** corresponding fields in the PSDS /COPY member, so that member
006800191121      ** must be included where this one is used.
006900191121
007000191121     D/COPY ZACPYSRC,PROCPARMS
007100191121
007200191121      **---------------------------------------------------------------
007300191121      ** The following /COPY line includes the definitions for error and
007400191121      ** warning message arrays.
007500191121     D/COPY ZACPYSRC,ERR_ARRAYS
007600191121
007700191121      ** +--------------------------------------+
007800191121      ** ¦ End of automatically included D-specs¦
007900191121      ** ¦ =====================================¦
008000191121      ** +--------------------------------------+
008100191121
008200191121      *****************************************************************
008300191121      /EJECT
008400191121      *****************************************************************
008500191121
008600191128YB   FOTPAYQL1  UF   E           K DISK                                         ERZ248
008700191128
008800191121      ** +--------------------------------------+
008900191121      ** ¦ Manually included D-specs            ¦
009000191121      ** ¦ =========================            ¦
009100191121      ** +--------------------------------------+
009200191121
009300191121      ** +--------------------------------------+
009400191121      ** ¦ Named constants                      ¦
009500191121      ** ¦ ===============                      ¦
009600191121      ** +--------------------------------------+
009700191121
009800191121      ** +--------------------------------------+
009900191121      ** ¦ Arrays and Data Structures           ¦
010000191121      ** ¦ ==========================           ¦
010100191121      ** +--------------------------------------+
010200191121      ** Array of Fields in error.
010300191121      ** First DS for access programs, short data structure
010400191121     D DSFDY         E DS                  EXTNAME(DSFDY)
010500191121
010600191121      ** Second DS for access programs, long data structure
010700191121     D DSSDY         E DS                  EXTNAME(DSSDY)
010800191121
010900191121      ** +--------------------------------------+
011000191121      ** ¦ Declared variables                   ¦
011100191121      ** ¦ ==================                   ¦
011200191121      ** +--------------------------------------+
011300191121
011400191121
011500191121      ** +--------------------------------------+
011600191121      ** ¦ End of D-specs                       ¦
011700191121      ** ¦ ==============                       ¦
011800191121      ** +--------------------------------------+
011900191121
012000191121      *****************************************************************
012100191121      /EJECT
012200191121      *****************************************************************
012300191121     C
012400191121      ** +--- Start of Main processing -----------------------------------+
012500191121      ** ¦                                                                ¦
012600191121      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
012700191121      ** ¦ executed at program activation.                                ¦
012800191121      ** ¦                                                                ¦
012900191121      ** +----------------------------------------------------------------+
013000191121
013100191121      ** Initialization
013200191121
013300191128YB   C     KPREF         CHAIN     OTPAYQL1                           38         ERZ248
013400191128YB   C     *IN38         IFEQ      *OFF                                          ERZ248
013500191128YB   C                   Move      KUETR         OTUETR                          ERZ248
013600191128YB   C                   Update    OTPAYQD0                                      ERZ248
013700191128     C                   Endif
013800191121
013900191121     C                   Return
014000191121
014100191121      *****************************************************************
014200191121      /Title Sr/*InzSr
014300191121      *****************************************************************
014400191121      *                                                               *
014500191121      * SR/*InzSr     - Program Initialisation Routine                *
014600191121      *                                                               *
014700191121      * Called By: Automatically executed when program starts.        *
014800191121      *                                                               *
014900191121      * Calls:                                                        *
015000191121      *                                                               *
015100191121      *****************************************************************
015200191121
015300191121     C     *InzSr        BegSr
015400191121
015500191121     C     *Entry        Plist
015600191128     C                   Parm                    RetCodeIn
015700191128     C                   Parm                    KPREF            15
015800191128     C                   Parm                    KUETR            36
015900191121
016000191121     C                   EndSr
016100191121
016200191121      *****************************************************************
016300191121      /EJECT
016400191121      *****************************************************************
016500191121      ** Program, module and procedure names for database error processing.
016600191121      ** =================================================================
016700191121      ** The following /COPY sets these values, and also defines LDA as
016800191121      ** an external data area
016900191121     C/COPY ZACPYSRC,PSSR_ILE
017000191121      ********************************************************************
017100191121**  CPY@
017200191121(c) Finastra International Limited 2019
