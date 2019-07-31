000100180410     H DEBUG
000200180410     H COPYRIGHT('(c) Finastra International Limited 2015')
000300180410      *****************************************************************
000400180410/*STD *  RPGBASEMOD                                                   *
000500180410/*EXI *  TEXT('Midas SD CRS Country Details - Validation')            *
000600180410      *****************************************************************
000700180410      *                                                               *
000800180410      *  Midas - Standing Data Module                                 *
000900180410      *                                                               *
001000180410      *  SDCRSN2VL - CRS Country Details Validation                   *
001100180410      *                                                               *
001200180530      *  (c) Finastra International Limited 2015                      *
001300180410      *                                                               *
001301180505      *  Last Amend No. MD050479           Date 05May18               *
001400180505      *  Prev Amend No. MD040876           Date 13Sep16               *
001500180505      *                 CGL177             Date 11Jan16               *
001600180410      *                 MD036274           Date 21Oct15               *
001700180410      *                 CGL157  *CREATE    Date 17Aug15               *
001800180410      *                                                               *
001900180410      *---------------------------------------------------------------*
002000180410      *                                                               *
002001180505      *  MD050479 - Deleted country in the NAHO's CRS list of         *
002002180505      *             countries maintenance can't be re-added           *
002100180410      *  MD040876 - CRS MQ (Recompile)                                *
002200180410      *  CGL177 - CRS Reporting Phase 2                               *
002300180410      *  MD036274 - Local TIN validation changes                      *
002400180410      *  CGL157 - CRS Reporting                                       *
002500180410      *                                                               *
002600180410      *****************************************************************
002700180410
002800180410      ** +--------------------------------------+
002900180410      ** ¦ F-specs                              ¦
003000180410      ** ¦ =======                              ¦
003100180410      ** +--------------------------------------+
003200180410
003300180410
003400180410      *****************************************************************
003500180410      ** +--------------------------------------+
003600180410      ** ¦ Automatically included D-specs       ¦
003700180410      ** ¦ ==============================       ¦
003800180410      ** +--------------------------------------+
003900180410      **
004000180410      ** The following /COPY line includes (among others) the LDA layout
004100180410      ** and the copyright array definition:
004200180410     D/COPY ZACPYSRC,STD_D_SPEC
004300180410
004400180410      ** The following /COPY includes the MM standard declares:
004500180410     D/COPY ZACPYSRC,STDDECLARE
004600180410
004700180410      ** The following /COPY line includes all the defined fields in the
004800180410      ** Program Status Data Structures.  They have meaningful
004900180410      ** names, prefixed by 'PS'.
005000180410     D/COPY ZACPYSRC,PSDS
005100180410
005200180410      ** The following /COPY line includes the definitions for error and
005300180410      ** warning message arrays.
005400180410     D/COPY ZACPYSRC,ERR_ARRAYS
005500180410
005600180410      ** The following /COPY line includes all the definitions of the
005700180410      ** appended error arrays, including the named constant giving the size
005800180410      ** of the arrays.
005900180410     D/COPY ZACPYSRC,ERR_XARRYS
006000180410
006100180410      ** +--------------------------------------+
006200180410      ** ¦ End of automatically included D-specs¦
006300180410      ** ¦ =====================================¦
006400180410      ** +--------------------------------------+
006500180410
006600180410      *****************************************************************
006700180410      /EJECT
006800180410      *****************************************************************
006900180410
007000180410      ** +--------------------------------------+
007100180410      ** ¦ Manually included D-specs            ¦
007200180410      ** ¦ =========================            ¦
007300180410      ** +--------------------------------------+
007400180410
007500180410      ** +--------------------------------------+
007600180410      ** ¦ Named constants                      ¦
007700180410      ** ¦ ===============                      ¦
007800180410      ** +--------------------------------------+
007900180410
008000180410      ** +--------------------------------------+
008100180410      ** ¦ Arrays and Data Structures           ¦
008200180410      ** ¦ ==========================           ¦
008300180410      ** +--------------------------------------+
008400180410
008500180410      ** CRS Country Details OK indicators
008600180410     D OKCrsN        E DS                  Extname(SDECRSNPD)
008700180410
008800180410      ** External DS for Bank Details
008900180410     D SDBANK        E DS                  Extname(SDBANKPD)
009000180410
009100180410      ** External DS for SAR Details
009200180410     D SCSARD        E DS                  Extname(SCSARDPD)
009300180410
009400180410      **  Short DS for access programs
009500180410     D DSFDY         E DS                  Extname(DSFDY)
009600180410
009700180410      **  Long DS for access programs
009800180410     D DSSDY         E DS                  Extname(DSSDY)
009900180410
010000180410      ** External DS for CRS Details
010100180410     D SDVCRSN       E DS                  EXTNAME(SDVCRSNPD)
010200180410
010300180410     D ZMUSER          DS            17
010400180410     D  USRBCH                11     13
010500180410
010600180410     D PCRSDT          DS
010700180410     D  DDCTRY                 1      2
010800180410     D  DDPREP                 3      3
010900180410     D  DDREPT                 4      4
011000180410     D  DDREPU                 5     14
011100180410     D  DDREPD                15     20
011200180410     D  DDREPM                21     26
011300180410     D  DDREP1                27     90
011400180410     D  DDREP2                91    154
011500180410     D  DDEVD1               155    156
011600180410     D  DDEVS1               157    159
011700180410     D  DDEVD2               160    161
011800180410     D  DDEVS2               162    164
011900180410     D  DDEVD3               165    166
012000180410     D  DDEVS3               167    169
012100180410     D  DDEVD4               170    171
012200180410     D  DDEVS4               172    174
012300180410     D  DDEVD5               175    176
012400180410     D  DDEVS5               177    179
012500180410     D  DDTINN               180    204
012600180410     D  DDEFFD               205    210
012700180410     D  DDEXPD               211    216
012800180410     D  DDCODO               217    217
012900180410     D  DDJACM               218    218
013000180410     D  DDMAIL               219    219
013100180410     D  DDPHON               220    220
013200180410     D  DDRPAY               221    221
013300180410     D  DDPEP1               222    285
013400180410     D  DDPEP2               286    349
013500180410     D  DDCRSA               350    350
013600180410     D  DDTINS               351    351                                                       CGL177
013700180410
013800180410     D*PCrsdF***       S            221A   DIM(30)                                            CGL177
013900180410     D*PCrsdS***       S            350A   DIM(30)                                            CGL177
014000180410     D PCrsdF          S            222A   DIM(30)                                            CGL177
014100180410     D PCrsdS          S            351A   DIM(30)                                            CGL177
014200180410     D PCtry           S              2A   DIM(30)
014300180410
014400180410      ** +--------------------------------------+
014500180410      ** ¦ Declared variables                   ¦
014600180410      ** ¦ ==================                   ¦
014700180410      ** +--------------------------------------+
014800180410
014900180410     D Retcd           S              7A
015000180410     D Option          S              7A
015100180410     D DFCTRY          S              2A
015200180410     D DFCRSA          S              1A
015300180410     D DDNAHO          S             10A
015400180410     D DDCUST          S              6A
015401180505     D WWCTRY          S              2A                                                    MD050479
015500180410
015600180410      ** Index for arrays of of error message ids etc
015700180410     D Idx             S              3P 0
015800180410
015900180410      ** Index for arrays of of warning message ids etc
016000180410     D WIdx            S              3P 0
016100180410
016200180410     D I               S              3  0
016300180410     D PMode           S              1
016400180410     D X               S              2S 0
016500180410
016600180410      ** +--------------------------------------+
016700180410      ** ¦ End of D-specs                       ¦
016800180410      ** ¦ ==============                       ¦
016900180410      ** +--------------------------------------+
017000180410
017100180410      ** +----------------------------------------+
017200180410      ** ¦ Hook for non-core D-specs (all types)  ¦
017300180410      ** ¦ also any I-specs (if necessary)        ¦
017400180410      ** ¦ =====================================  ¦
017500180410      ** +----------------------------------------+
017600180410
017700180410      *****************************************************************
017800180410      /EJECT
017900180410      *****************************************************************
018000180410
018100180410      ** +--- Start of Main processing -----------------------------------+
018200180410      ** ¦                                                                ¦
018300180410      ** ¦ Initial processing is performed automatically: the *inzsr is   ¦
018400180410      ** ¦ executed at program activation.                                ¦
018500180410      ** ¦                                                                ¦
018600180410      ** +----------------------------------------------------------------+
018700180410
018800180410      ** Validate Country
018900180410
019000180410     C                   EXSR      SRVCtry
019100180410
019200180410     C                   RETURN
019300180410
019400180410      *****************************************************************
019500180410      /EJECT
019600180410      *****************************************************************
019700180410
019800180410      *****************************************************************
019900180410      ** SRVCtry - Validate Country
020000180410      *****************************************************************
020100180410     C     SRVCtry       BEGSR
020200180410
020300180410      ** Reset variables updated by each module
020400180410
020500180410     C                   EXSR      SRResetErrs
020600180410
020700180410     C                   EVAL      PCtry = *Blanks                                          MD036274
020800180410     C                   EVAL      X = 1
020900180410     C                   DOW       X < 31
021000180410     C                   EVAL      PCRSDT = PCrsdS(X)
021100180410     C                   IF        DDCTRY <> *Blanks
021101180505     C                             AND %SUBST(PCrsdS(X):3:1) <> '*'                         MD050479
021200180410     C                   EVAL      PCtry(X) = DDCTRY
021300180410     C                   ENDIF
021400180410     C                   EVAL      X = X + 1
021500180410     C                   ENDDO
021600180410
021700180410
021800180410      ** Validate Country
021900180410
022000180410     C                   CALLB     'SDVCTRY'
022100180410      ** INPUTS
022200180410      ** Return Code
022300180410     C                   PARM                    RetCodeOut
022400180410     C                   PARM      *Blanks       DDCUST
022500180410     C                   PARM                    DDNAHO
022600180410      ** Country
022700180410     C                   PARM                    DFCTRY
022800180410     C                   PARM                    PCtry
022900180410
023000180410      ** OUTPUTS
023100180410      ** Error fields/message IDs/message data (arrays) from/to caller
023200180410     C                   PARM                    FldNamXAr
023300180410     C                   PARM                    MsgIDXAr
023400180410     C                   PARM                    MsgDtaXAr
023500180410      ** Country - OK
023600180410     C                   PARM                    DDCTRYOK
023700180410     C                   PARM                    RVCTRY
023800180410     C                   PARM                    DFCRSA
023900180410
024000180410     C                   IF        RVCTRY <> *Blanks
024100180410     C                   EVAL      X = 1
024200180410     C                   DOW       X < 31
024201180505
024300180410     C                   IF        PCrsdS(X) = *Blanks
024400180410     C                   EVAL      PCrsdS(X) = RVCTRY
024500180410     C                   MOVE      DFCRSA        PCrsdS(X)
024600180410     C                   EVAL      PCrsdF(X) = RVCTRY
024700180410     C                   MOVE      DFCRSA        PCrsdF(X)
024800180410     C                   EVAL      X = 31
024801180505     C                   ELSE                                                               MD050479
024802180505     C                   EVAL      WWCTRY = PCrsdS(X)                                       MD050479
024803180505     C                   IF        RVCTRY = WWCTRY                                          MD050479
024804180505     C                   EVAL      %SUBST(PCrsdS(X):3:1) = ' '                              MD050479
024805180505     C                   EVAL      %SUBST(PCrsdF(X):3:6) = '      '                         MD050479
024806180505     C                   EVAL      X = 31                                                   MD050479
024807180505     C                   ENDIF                                                              MD050479
024900180410     C                   ENDIF
025000180410     C                   EVAL      X = X + 1
025100180410     C                   ENDDO
025200180410
025300180410     C                   ENDIF
025400180410
025500180410      ** Update error info with that returned from the validation module
025600180410
025700180410     C                   EXSR      SRUpdatErrs
025800180410
025900180410     C                   ENDSR
026000180410
026100180410      *****************************************************************
026200180410      /EJECT
026300180410      *****************************************************************
026400180410
026500180410      *****************************************************************
026600180410      ** SRResetErrs - Reset error information that is received back  *
026700180410      **    from each validation module.                              *
026800180410      *****************************************************************
026900180410     C     SRResetErrs   BEGSR
027000180410
027100180410     C                   EVAL      RetCodeOut = *Blanks
027200180410
027300180410      ** Reset error & warning fields/message IDs/message data (arrays)
027400180410
027500180410     C                   MOVEL     *BLANK        FldNamXAr
027600180410     C                   MOVEL     *BLANK        MsgIDXAr
027700180410     C                   MOVEL     *BLANK        MsgDtaXAr
027800180410     C                   MOVEL     *BLANK        WFldNmXAr
027900180410     C                   MOVEL     *BLANK        WMsgIDXAr
028000180410     C                   MOVEL     *BLANK        WMsgDtXAr
028100180410
028200180410     C                   ENDSR
028300180410      *****************************************************************
028400180410      /EJECT
028500180410      *****************************************************************
028600180410      ** SRUpdatErrs - Update error information with that received back*
028700180410      **    from each validation module.                               *
028800180410      *****************************************************************
028900180410     C     SRUpdatErrs   BEGSR
029000180410
029100180410      ** Update error fields/message IDs/message data (arrays)
029200180410
029300180410     C                   Z-ADD     1             I
029400180410     C     *BLANK        LOOKUP    FldNameArr(I)                          99
029500180410     C     *IN99         IFEQ      *On
029600180410     C                   MOVEA     FldNamXAr     FlDNameArr(I)
029700180410     C                   MOVEA     MsgIDXAr      MsgIdArr(I)
029800180410     C                   MOVEA     MsgDtaXAr     MsgDtaArr(I)
029900180410     C                   ENDIF
030000180410
030100180410      ** Set Error Index
030200180410
030300180410     C                   Z-ADD     1             I
030400180410     C     *BLANK        LOOKUP    FldNameArr(I)                          99
030500180410     C     I             SUB       1             Idx
030600180410
030700180410      ** Update warning fields/message IDs/message data (arrays)
030800180410
030900180410     C                   Z-ADD     1             I
031000180410     C     *BLANK        LOOKUP    WFldNamArr(I)                          99
031100180410     C     *IN99         IFEQ      *On
031200180410     C                   MOVEA     WFldNmXAr     WFldNamArr(I)
031300180410     C                   MOVEA     WMsgIDXAr     WMsgIDArr(I)
031400180410     C                   MOVEA     WMsgDtXAr     WMsgDtaArr(I)
031500180410     C                   ENDIF
031600180410
031700180410      ** Set Warning Index
031800180410
031900180410     C                   Z-ADD     1             I
032000180410     C     *BLANK        LOOKUP    WFldNamArr(I)                          99
032100180410     C     I             SUB       1             WIdx
032200180410
032300180410     C                   ENDSR
032400180410      *****************************************************************
032500180410      /EJECT
032600180410      *****************************************************************
032700180410      ** *INZSR - Program Initialisation routine                      *
032800180410      *****************************************************************
032900180410     C     *INZSR        BEGSR
033000180410
033100180410     C     *Entry        PLIST
033200180410
033300180410      ** INPUTS
033400180410      ** Response mode
033500180410      ** CRS Country Details
033600180410
033700180410     C                   PARM                    Pmode
033800180410     C                   PARM                    DDNAHO
033900180410     C                   PARM                    DFCTRY
034000180410     C                   PARM                    PCrsdS
034100180410
034200180410      ** OUTPUTS
034300180410      ** CRS Country Details OK inds
034400180410      ** Error fields/message IDs/message data (arrays) from/to caller
034500180410      ** Array index (3P0) from/to caller
034600180410      ** Warning fields/message IDs/message data (arrays) from/to caller
034700180410      ** Array index (3P0) from/to caller
034800180410      ** Valid CRS Country details layout (DS) from/to caller
034900180410
035000180410     C                   PARM                    OKCrsN
035100180410     C                   PARM                    FldNameArr
035200180410     C                   PARM                    MsgIDArr
035300180410     C                   PARM                    MsgDtaArr
035400180410     C                   PARM                    Idx
035500180410     C                   PARM                    WFldNamArr
035600180410     C                   PARM                    WMsgIDArr
035700180410     C                   PARM                    WMsgDtaArr
035800180410     C                   PARM                    WIdx
035900180410     C                   PARM                    PCrsdF
036000180410
036100180410      ** Access Bank details
036200180410
036300180410     C                   CALL      'AOBANKR0'
036400180410     C                   PARM      *BLANKS       Retcd
036500180410     C                   PARM      '*FIRST '     Option
036600180410     C     SDBANK        PARM      SDBANK        DSFDY
036700180410
036800180410      ** Database error
036900180410
037000180410     C     Retcd         IFNE      *BLANKS
037100180410     C                   MOVEL     'SDBANKPD'    Dbfile
037200180410     C                   MOVEL     '001'         Dbase
037300180410     C                   MOVEL     @OPTN         Dbkey
037400180410     C                   EXSR      SRERR
037500180410     C                   ENDIF
037600180410
037700180410
037800180410      ** The following /COPY sets the values of program, module and
037900180410      ** procedure names for database error processing.
038000180410      /COPY ZACPYSRC,DBFIELDS
038100180410
038200180410     C                   ENDSR
038300180410      *****************************************************************
038400180410      /EJECT
038500180410      *****************************************************************
038600180410      ** SRERR - Exception Errors                                     *
038700180410      *****************************************************************
038800180410     C     SRERR         BEGSR
038900180410
039000180410     C                   MOVEL     'SDCRSN2VL'   Dbpgm
039100180410     C                   MOVE      *On           *INU7
039200180410     C                   MOVE      *On           *INU8
039300180410     C                   MOVE      *On           *INLR
039400180410
039500180410     C                   DUMP
039600180410
039700180410      **  Terminate the program
039800180410
039900180410     C                   RETURN
040000180410
040100180410     C                   ENDSR
040200180410      *****************************************************************
040300180410      /EJECT
040400180410      *****************************************************************
040500180410
040600180410      ** The following /COPY contains the standard program status
040700180410      ** subroutine, including a bound call to the DBERRCTL module.
040800180410      /COPY ZACPYSRC,PSSR_ILE
040900180410
041000180410      ********************************************************************
041100180410**  CPY@
041200180410(c) Finastra International Limited 2015
