000100200604     H DEBUG
000200200604     H COPYRIGHT('(c) Finastra International Limited 2002')
000300200604      *****************************************************************
000400200604/*STD *  RPGBASEMOD                                                   *
000500200604/*EXI *  TEXT('Midas SE Validate market indicator')                   *
000600200604      *****************************************************************
000700200604      *                                                               *
000800200604      *  Midas - Securities Trading Module                            *
000900200604      *                                                               *
001000200604      *  SEVSMKTI - Validate Market Indicator                         *
001100200604      *                                                               *
001200200604      *  (c) Finastra International Limited 2001                      *
001300200604      *                                                               *
001400200604      *  Component of: SESECSSIN                                      *
001500200604      *                SESECSCTL                                      *
001600200604      *                SESECSRPR                                      *
001700200604      *                                                               *
001800200604      *    This source is centrally supported and must ONLY be        *
001900200604      *    amended by Core Development Personnel.                     *
002000200604      *                                                               *
002100200604      *    /COPY, Client or Country amendments must not be            *
002200200604      *    applied to this source.                                    *
002300200604      *                                                               *
002400200604      *  Last Amend No. MD023865           Date 01Jun20               *
002500200604      *  Prev Amend No. MD046248           Date 27Oct17               *
002600200604      *                 CRE073             Date 06Dec10               *
002700200604      * Bank Fusion Midas 1.4 Base -----------------------------------*
002800200604      * Midas Plus 1.4 Base 04 ---------------------------------------*
002900200604      * Midas Plus 1.4 Base ------------------------------------------*
003000200604      * Midas Plus 1.3 ----------- Base ------------------------------*
003100200604      *                 CSD027             Date 09Dec05               *
003200200604      *                 CSE071             Date 19Jul05               *
003300200604      *                 CGL014             Date 20Oct03               *
003400200604      *                 CAS006             Date 21Jan03               *
003500200604      * Midas Release 4 --------------- Base -------------------------*
003600200604      * Midas DBA 3.05 -----------------------------------------------*
003700200604      *                 CSD006             Date 14May01               *
003800200604      *                 CAP060             Date 14May01               *
003900200604      * Midas DBA 3.03 -----------------------------------------------*
004000200604      *                 CAP137  *CREATE    Date 07Feb00               *
004100200604      *                                                               *
004200200604      *---------------------------------------------------------------*
004300200604      *                                                               *
004400200604      *  MD023865 - Not able to change Market Indicator from          *
004500200604      *             Securities Details Screen. Check only RECI = 'D'  *
004600200604      *             records for non-zero positions before issuing     *
004700200604      *             error message.                                    *
004800200604      *  MD046248 - Finastra Rebranding                               *
004900200604      *  CRE073 - Interest Rate Rounding (Recompile)                  *
005000200604      *  CSD027 - Conversion Of Customer Number to Alpha              *
005100200604      *  CSE071 - Multiple Holidays Re Securities (recompile)         *
005200200604      *  CGL014 - Collaterals Processing (Recompile)                  *
005300200604      *  CAS006 - Hedge Accounting Phase B (Recompile)                *
005400200604      *  CSD006 - Market Data Feeds (recompile)                       *
005500200604      *  CAP060 - Midas APIs, Security Prices Full API (recompile)    *
005600200604      *  CAP137 - Conversion of SE Security inputs into modular       *
005700200604      *           structure to use as APIs.                           *
005800200604      *                                                               *
005900200604      *****************************************************************
006000200604      *
006100200604      ** +--------------------------------------+
006200200604      ** ¦ F-specs                              ¦
006300200604      ** ¦ =======                              ¦
006400200604      ** +--------------------------------------+
006500200604      *
006600200604      ** Securities trade by security/receivers trade date
006700200604     FTRADSR    IF   E           K DISK    INFSR(*PSSR)
006800200604      *
006900200604      ** Securities user depot positions non-zero nominal
007000200604     FUDEPZ     IF   E           K DISK    INFSR(*PSSR)
007100200604      *
007200200604      ** Securities customer depot positions non-zero nominal
007300200604     FCDEPZ     IF   E           K DISK    INFSR(*PSSR)
007400200604      *
007500200604      ** Securities book position header
007600200604     FBKPHD     IF   E           K DISK    INFSR(*PSSR)
007700200604      *
007800200604      ** Securities book positions
007900200604     FBKPOS     IF   E           K DISK    INFSR(*PSSR)
008000200604      *****************************************************************
008100200604      /EJECT
008200200604      *****************************************************************
008300200604      *
008400200604      ** +--------------------------------------+
008500200604      ** ¦ Automatically included D-specs       ¦
008600200604      ** ¦ ==============================       ¦
008700200604      ** +--------------------------------------+
008800200604      *
008900200604      ** Standard D-specs
009000200604      ** ================
009100200604      **
009200200604      ** The following /COPY line includes the LDA layout,
009300200604      ** the copyright array definition,
009400200604      ** and the following named constants:
009500200604      **    True       logical = *On (for indicator processing)
009600200604      **    False      logical = *Off (for indicator processing)
009700200604      **    DBErrCtl   10A     = 'DBERRCTL' (the name of the database error
009800200604      **                                    handler)
009900200604      ** and the following variables:
010000200604      **    RunBefore  1A (for the PSSR)
010100200604      *
010200200604      /COPY ZACPYSRC,STD_D_SPEC
010300200604      *
010400200604      ** Program Status Data Structure
010500200604      ** =============================
010600200604      ** The following /COPY line includes all the defined fields in the
010700200604      ** PSDS.  They have meaningful names, prefixed by 'PS'.
010800200604      *
010900200604      /COPY ZACPYSRC,PSDS
011000200604      *
011100200604      ** The following /COPY line includes all the definitions of the
011200200604      ** appended error arrays, including the named constant giving the size
011300200604      ** of the arrays.
011400200604      *
011500200604      /COPY ZACPYSRC,ERR_XARRYS
011600200604      *
011700200604      ** +--------------------------------------+
011800200604      ** ¦ End of automatically included D-specs¦
011900200604      ** ¦ =====================================¦
012000200604      ** +--------------------------------------+
012100200604      *
012200200604      *****************************************************************
012300200604      /EJECT
012400200604      *****************************************************************
012500200604      *
012600200604      ** +--------------------------------------+
012700200604      ** ¦ Manually included D-specs            ¦
012800200604      ** ¦ =========================            ¦
012900200604      ** +--------------------------------------+
013000200604      *
013100200604      ** +--------------------------------------+
013200200604      ** ¦ Named constants                      ¦
013300200604      ** ¦ ===============                      ¦
013400200604      ** +--------------------------------------+
013500200604      *
013600200604      ** +--------------------------------------+
013700200604      ** ¦ Arrays and Data Structures           ¦
013800200604      ** ¦ ==========================           ¦
013900200604      ** +--------------------------------------+
014000200604      *
014100200604      ** Securities screen 1 details from incoming transaction
014200200604      ** - screen format
014300200604     D NwSE1ScnFmt   E DS                  EXTNAME(SESEC1PD)
014400200604      *
014500200604      ** Securities screen 1 details retrieved from file
014600200604      ** - screen format
014700200604     D CrSE1ScnFmt   E DS                  EXTNAME(SESEC1PD)
014800200604     D                                     PREFIX(O)
014900200604      *
015000200604      ** Securities for file update - file format
015100200604     D NwSEFilFmt    E DS                  EXTNAME(SEVSECSPD)
015200200604      *
015300200604      ** Securities screen 1 error indicators
015400200604     D SEESEC1       E DS                  EXTNAME(SEESEC1PD)
015500200604      *
015600200604      ** +--------------------------------------+
015700200604      ** ¦ Declared variables                   ¦
015800200604      ** ¦ ==================                   ¦
015900200604      ** +--------------------------------------+
016000200604      *
016100200604      ** Index for arrays of error message ids, etc.
016200200604     D IDx             S              3P 0
016300200604      *
016400200604      ** Switchable feature
016500200604     D S01511          S              1A
016600200604      *
016700200604      ** Work parameter
016800200604     D PDMAR           S              1A
016900200604      *
017000200604      ** +--------------------------------------+
017100200604      ** ¦ End of D-specs                       ¦
017200200604      ** ¦ ==============                       ¦
017300200604      ** +--------------------------------------+
017400200604      *
017500200604      *****************************************************************
017600200604      /EJECT
017700200604      *****************************************************************
017800200604      *
017900200604      ** +--- Start of Main processing -------------------------------+
018000200604      ** ¦                                                            ¦
018100200604      ** ¦ *INZSR is executed at program activation.                  ¦
018200200604      ** ¦                                                            ¦
018300200604      ** +------------------------------------------------------------+
018400200604      *
018500200604      ** Initialise work variables.
018600200604     C                   EVAL      IDx = 0
018700200604      *
018800200604      ** Validate market indicator
018900200604      *
019000200604     C                   EXSR      SRValMktI
019100200604      *
019200200604      ** If an error has been found, set return code appropriately.
019300200604      ** Otherwise, update valid file fields.
019400200604      *
019500200604     C                   IF        OKMKTI = 'N'
019600200604     C                   EVAL      RetCodeIn = 'ERROR'
019700200604     C                   ENDIF
019800200604
019900200604     C                   IF        OKMKTI <> 'N'
020000200604     C                   MOVEL     DDMKTI        S1MKTI
020100200604     C                   ENDIF
020200200604
020300200604     C                   RETURN
020400200604
020500200604      *****************************************************************
020600200604      /EJECT
020700200604      *****************************************************************
020800200604      *                                                               *
020900200604      *  SRValMktI - Validation for Market Indicator                  *
021000200604      *                                                               *
021100200604      *****************************************************************
021200200604     C     SRValMktI     BEGSR
021300200604      *
021400200604      ** If field is blank, default market indicator from PF/INVTPD
021500200604      *
021600200604     C                   IF        DDMKTI = *BLANK
021700200604     C                   EVAL      DDMKTI = PDMAR
021800200604     C                   ENDIF
021900200604
022000200604     C                   IF        DDMKTI <> 'G' AND
022100200604     C                             DDMKTI <> 'P' AND
022200200604     C                             DDMKTI <> 'S'
022300200604     C                   MOVE      'N'           OKMKTI
022400200604     C                   ADD       1             Idx
022500200604     C                   MOVEL     'DDMKTI'      FldNamXAr(IDx)
022600200604     C                   MOVEL     'SEA0117'     MsgIDXAr(IDx)
022700200604     C                   ENDIF
022800200604      *
022900200604      ** Check for allowable changes to market indicator
023000200604      *
023100200604     C                   IF        DDACTN = 'A'
023200200604      *
023300200604      ** IF 'G' is the original value, 'G', 'P' or 'S' is allowed
023400200604      ** If 'P' is the original value, 'P' or 'S' is allowed
023500200604      ** If 'S' is the original value, amendment is not allowed
023600200604      *
023700200604     C                   IF        (ODDMKTI = 'G' AND
023800200604     C                              DDMKTI <> 'G' AND
023900200604     C                              DDMKTI <> 'P' AND
024000200604     C                              DDMKTI <> 'S') OR
024100200604
024200200604     C                             (ODDMKTI = 'P' AND
024300200604     C                              DDMKTI <> 'P' AND
024400200604     C                              DDMKTI <> 'S') OR
024500200604
024600200604     C                              ODDMKTI = 'S' AND
024700200604     C                              DDMKTI <> 'S'
024800200604
024900200604     C                   MOVE      'N'           OKMKTI
025000200604     C                   ADD       1             Idx
025100200604     C                   MOVEL     'DDMKTI'      FldNamXAr(IDx)
025200200604     C                   MOVEL     'SEA0118'     MsgIDXAr(IDx)
025300200604     C                   ENDIF
025400200604      *
025500200604      ** If S01511 is installed, only validate a change of market, if
025600200604      ** the change is from 'G' to another
025700200604      *
025800200604     C                   IF        DDMKTI <> ODDMKTI AND
025900200604     C                             (S01511 = 'N' OR
026000200604     C                             ODDMKTI = 'G')
026100200604     C                   EXSR      SrValDCMkt
026200200604     C                   ENDIF
026300200604
026400200604     C                   ENDIF
026500200604
026600200604     C                   ENDSR
026700200604      *
026800200604      *****************************************************************
026900200604      /EJECT
027000200604      *****************************************************************
027100200604      *                                                               *
027200200604      *  SRVALDCMKT - Validation for Change of Market Processing      *
027300200604      *                                                               *
027400200604      *****************************************************************
027500200604     C     SRValDCMkt    BEGSR
027600200604      *
027700200604      ** Check LF/TRADSR - trades by security
027800200604      *
027900200604     C     DDSESN        SETLL     TRADSDF
028000200604     C     *IN01         DOWEQ     *OFF
028100200604     C     DDSESN        READE     TRADSDF                                01
028200200604
028300200604     C                   IF        *IN01 = *OFF AND
028400200604     C                             TDMI = ODDMKTI
028500200604     C                   MOVE      'N'           OKMKTI
028600200604     C                   ADD       1             IDx
028700200604     C                   MOVEL     'DDMKTI'      FldNamXAr(IDx)
028800200604     C                   MOVEL     'SEA0119'     MsgIdXAr(IDx)
028900200604     C                   GOTO      EValDCMkt
029000200604     C                   ENDIF
029100200604
029200200604     C                   ENDDO
029300200604      *
029400200604      ** Check LF/UDEPZ - user depot positions
029500200604      *
029600200604     C                   MOVE      *OFF          *IN01
029700200604     C     DDSESN        SETLL     UDEPPDF
029800200604     C     *IN01         DOWEQ     *OFF
029900200604     C     DDSESN        READE     UDEPPDF                                01
030000200604
030100200604     C                   IF        *IN01 = *OFF and
030200200604     C                             (UECN <> *ZEROS OR                                       MD023865
030300200604     C                             UDNT <> *ZEROS OR                                        MD023865
030400200604     C                             UDNV <> *ZEROS OR                                        MD023865
030500200604     C                             UDNS <> *ZEROS OR                                        MD023865
030600200604     C                             UNRT <> *ZEROS OR                                        MD023865
030700200604     C                             UNRV <> *ZEROS) AND                                      MD023865
030800200604     C                             RECI = 'D' AND                                           MD023865
030900200604     C                             UDMK = ODDMKTI
031000200604     C                   MOVE      'N'           OKMKTI
031100200604     C                   ADD       1             IDx
031200200604     C                   MOVEL     'DDMKTI'      FldNamXAr(IDx)
031300200604     C                   MOVEL     'SEA0119'     MsgIdXAr(IDx)
031400200604     C                   GOTO      EValDCMkt
031500200604     C                   ENDIF
031600200604
031700200604     C                   ENDDO
031800200604      *
031900200604      ** Check CDEPZ - customer depot positions
032000200604      *
032100200604     C                   MOVE      *OFF          *IN01
032200200604     C     DDSESN        SETLL     CDEPPDF
032300200604     C     *IN01         DOWEQ     *OFF
032400200604     C     DDSESN        READE     CDEPPDF                                01
032500200604
032600200604     C                   IF        *IN01 = *OFF AND
032700200604     C                             (CECN <> *ZEROS OR                                       MD023865
032800200604     C                             CDNT <> *ZEROS OR                                        MD023865
032900200604     C                             CDNV <> *ZEROS OR                                        MD023865
033000200604     C                             CDNS <> *ZEROS) AND                                      MD023865
033100200604     C                             RECI = 'D' AND                                           MD023865
033200200604     C                             CDMK = ODDMKTI
033300200604     C                   MOVE      'N'           OKMKTI
033400200604     C                   ADD       1             IDx
033500200604     C                   MOVEL     'DDMKTI'      FldNamXAr(IDx)
033600200604     C                   MOVEL     'SEA0119'     MsgIdXAr(IDx)
033700200604     C                   GOTO      EValDCMkt
033800200604     C                   ENDIF
033900200604
034000200604     C                   ENDDO
034100200604      *
034200200604      ** Check LF/BKPHD - book positions header
034300200604      *
034400200604     C                   MOVE      *OFF          *IN01
034500200604     C     DDSESN        SETLL     BKPHDDF
034600200604     C     *IN01         DOWEQ     *OFF
034700200604     C     DDSESN        READE     BKPHDDF                                01
034800200604
034900200604     C                   IF        *IN01 = *OFF AND
035000200604     C                             RECI = 'D'
035100200604      *
035200200604      ** Check BKPOSD of record found on header
035300200604      *
035400200604     C     KBPKY         CHAIN     BKPOS                              01
035500200604
035600200604     C                   IF        *IN01 = *OFF AND
035700200604     C                             (ECNP <> *ZEROS OR
035800200604     C                             NPSN <> *ZEROS) AND
035900200604     C                             BPMK = ODDMKTI
036000200604     C                   MOVE      'N'           OKMKTI
036100200604     C                   ADD       1             IDx
036200200604     C                   MOVEL     'DDMKTI'      FldNamXAr(IDx)
036300200604     C                   MOVEL     'SEA0119'     MsgIdXAr(IDx)
036400200604     C                   ENDIF
036500200604
036600200604     C                   ENDIF
036700200604
036800200604     C                   ENDDO
036900200604
037000200604     C     EValDCMkt     ENDSR
037100200604
037200200604      *****************************************************************
037300200604      /EJECT
037400200604      *****************************************************************
037500200604      *                                                               *
037600200604      *  *INZSR - Program Initialisation                              *
037700200604      *         - This subroutine runs automatically for program      *
037800200604      *           initialisation.                                     *
037900200604      *                                                               *
038000200604      *****************************************************************
038100200604      *
038200200604     C     *INZSR        BEGSR
038300200604      *
038400200604     C     *ENTRY        PLIST
038500200604      *
038600200604      ** INPUT
038700200604      ** =====
038800200604      *
038900200604      ** Return code
039000200604     C                   PARM                    RetCodeIn
039100200604      *
039200200604      ** Securities screen 1 details from incoming transaction
039300200604      ** - screen format
039400200604     C                   PARM                    NwSE1ScnFmt
039500200604      *
039600200604      ** Securities screen 1 details retrieved from file
039700200604      ** - screen format
039800200604     C                   PARM                    CrSE1ScnFmt
039900200604      *
040000200604      ** Default market indicator from, PF/INVTPD
040100200604     C                   PARM                    PDMAR
040200200604      *
040300200604      ** SWITCHABLE FEATURES
040400200604      ** ===================
040500200604      *
040600200604      ** Market migration
040700200604     C                   PARM                    S01511
040800200604      *
040900200604      ** OUTPUT
041000200604      ** ======
041100200604      *
041200200604      ** Error fields/message IDs/message data (arrays) from/to caller
041300200604     C                   PARM                    FldNamXAr
041400200604     C                   PARM                    MsgIDXAr
041500200604     C                   PARM                    MsgDtaXAr
041600200604      *
041700200604      ** Securities screen 1 error indicators
041800200604     C                   PARM                    SEESEC1
041900200604      *
042000200604      ** Securities for file update - file format
042100200604     C                   PARM                    NwSEFilFmt
042200200604      *
042300200604      ** Key to access book position records.
042400200604      *
042500200604     C     KBPKY         KLIST
042600200604     C                   KFLD                    BHSC
042700200604     C                   KFLD                    BHBA
042800200604     C                   KFLD                    BHBK
042900200604     C                   KFLD                    BHMK
043000200604     C                   KFLD                    BHTV
043100200604     C                   KFLD                    LPSD
043200200604      *
043300200604      ** Program, module and procedure names for dbase error processing
043400200604      ** ==============================================================
043500200604      ** The following /COPY sets these values.
043600200604      *
043700200604      /COPY ZACPYSRC,DBFIELDS
043800200604      *
043900200604     C                   ENDSR
044000200604      *
044100200604      *****************************************************************
044200200604      /EJECT
044300200604      *****************************************************************
044400200604      *
044500200604      ** The following /COPY contains the standard program status
044600200604      ** subroutine, including a bound call to the DBERRCTL module.
044700200604      *
044800200604      /COPY ZACPYSRC,PSSR_ILE
044900200604      *
045000200604      *****************************************************************
045100200604      /EJECT
045200200604      *****************************************************************
045300200604      *
045400200604**  CPY@
045500200604(c) Finastra International Limited 2001
