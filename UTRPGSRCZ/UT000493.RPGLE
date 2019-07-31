     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2012')
     H FIXNBR(*NOINPUTPACKED)
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Set corrupted fields to 0')                            *
      *****************************************************************
      *                                                               *
      *  Midas - Customer Lending Module                              *
      *                                                               *
      *  UT000493 - LE Utility to correct loan records.               *
      *                                                               *
      *  Function: This program updates records in History files      *
      *            that have invalid data in some fields.             *
      *                                                               *
      *  (c) Finastra International Limited 2012                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. AR316215 *CREATE   Date 01Aug12               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  AR316218 - Unable to extract some fields of RUDWH library    *
      *             tables due to corrupted data.                     *
      *             Patch all records with invalid data. As CAS005 is *
      *             off, set value of the corrupted fields to 0.      *
      *           - override creation parameters. Declare FIXNBR as   *
      *             to not fix packed numeric fields to avoid         *
      *             decimal data error during run time.               *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
     FHISTSHM   UF   E             DISK    INFSR(*PSSR)
     F                                     INFDS(HISTMF)
     F                                     PREFIX(LM_)
     FHISTSHN   UF   E             DISK    INFSR(*PSSR)
     F                                     INFDS(HISTNF)
     F                                     PREFIX(LN_)
     FHISTSHP   UF   E             DISK    INFSR(*PSSR)
     F                                     INFDS(HISTPF)
     F                                     PREFIX(LP_)
     FHISTSHQ   UF   E             DISK    INFSR(*PSSR)
     F                                     INFDS(HISTQF)
     F                                     PREFIX(LQ_)
     FMHISTHM   UF   E             DISK    INFSR(*PSSR)
     F                                     INFDS(MHSTMF)
     F                                     PREFIX(MM_)
     F                                     RENAME(HISTSHMF:MHISTMF)
     FMHISTHN   UF   E             DISK    INFSR(*PSSR)
     F                                     INFDS(MHSTNF)
     F                                     PREFIX(MN_)
     F                                     RENAME(HISTSHNF:MHISTNF)
     FMHISTHP   UF   E             DISK    INFSR(*PSSR)
     F                                     INFDS(MHSTPF)
     F                                     PREFIX(MP_)
     F                                     RENAME(HISTSHPF:MHISTPF)
     FMHISTHQ   UF   E             DISK    INFSR(*PSSR)
     F                                     INFDS(MHSTQF)
     F                                     PREFIX(MQ_)
     F                                     RENAME(HISTSHQF:MHISTQF)
 
     FUTL00493P1O    E             PRINTER
 
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      **
      ** The following /COPY line includes (among others) the LDA layout
      ** and the copyright array definition:
     D/COPY ZACPYSRC,STD_D_SPEC
 
      ** The following /COPY includes the LE standard declares:
     D/COPY ZACPYSRC,STDDECLARE
 
      ** The following /COPY line includes all the defined fields in the
      ** Program Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
 
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
     D/COPY ZACPYSRC,ERR_ARRAYS
 
      ** +--------------------------------------+
      ** ¦ End of automatically included D-specs¦
      ** ¦ =====================================¦
      ** +--------------------------------------+
 
      *****************************************************************
      /SPACE 5
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ Manually included D-specs            ¦
      ** ¦ =========================            ¦
      ** +--------------------------------------+
 
      ** Bank Details
 
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
 
      ** General Ledger Details
 
     D SDGELR        E DS                  EXTNAME(SDGELRPD)
 
      ** Short Data structure for Access Program
 
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      ** Long Data structure for Access Program
 
     D DSSDY         E DS                  EXTNAME(DSSDY)
 
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
     DHISTMF           DS
     D  LM_AITN              180    186P 0
     D  TM_AITN              180    186
     D  LM_AIAN              187    193P 0
     D  TM_AIAN              187    193
     D  LM_IPRN              194    200P 0
     D  TM_IPRN              194    200
     D  LM_FSPRAM            201    207P 0
     D  TM_FSPRAM            201    207
     D  LM_FSCPAM            208    214P 0
     D  TM_FSCPAM            208    214
 
     DHISTNF           DS
     D  LN_INTN              119    125P 0
     D  TN_INTN              119    125
     D  LN_FSPRAM            126    132P 0
     D  TN_FSPRAM            126    132
 
     DHISTPF           DS
     D  LP_AITN              186    192P 0
     D  TP_AITN              186    192
     D  LP_AIAN              193    199P 0
     D  TP_AIAN              193    199
     D  LP_IPRN              200    206P 0
     D  TP_IPRN              200    206
     D  LP_INTN              207    213P 0
     D  TP_INTN              207    213
     D  LP_FSPRAM            214    220P 0
     D  TP_FSPRAM            214    220
     D  LP_FSCPAM            221    227P 0
     D  TP_FSCPAM            221    227
 
     DHISTQF           DS
     D  LQ_AITN              179    185P 0
     D  TQ_AITN              179    185
     D  LQ_AIAN              186    192P 0
     D  TQ_AIAN              186    192
     D  LQ_IPRN              193    199P 0
     D  TQ_IPRN              193    199
     D  LQ_FSCPAM            200    206P 0
     D  TQ_FSCPAM            200    206
 
     DMHSTMF           DS
     D  MM_AITN              180    186P 0
     D  CM_AITN              180    186
     D  MM_AIAN              187    193P 0
     D  CM_AIAN              187    193
     D  MM_IPRN              194    200P 0
     D  CM_IPRN              194    200
     D  MM_FSPRAM            201    207P 0
     D  CM_FSPRAM            201    207
     D  MM_FSCPAM            208    214P 0
     D  CM_FSCPAM            208    214
 
     DMHSTNF           DS
     D  MN_INTN              119    125P 0
     D  CN_INTN              119    125
     D  MN_FSPRAM            126    132P 0
     D  CN_FSPRAM            126    132
 
     DMHSTPF           DS
     D  MP_AITN              186    192P 0
     D  CP_AITN              186    192
     D  MP_AIAN              193    199P 0
     D  CP_AIAN              193    199
     D  MP_IPRN              200    206P 0
     D  CP_IPRN              200    206
     D  MP_INTN              207    213P 0
     D  CP_INTN              207    213
     D  MP_FSPRAM            214    220P 0
     D  CP_FSPRAM            214    220
     D  MP_FSCPAM            221    227P 0
     D  CP_FSCPAM            221    227
 
     DMHSTQF           DS
     D  MQ_AITN              179    185P 0
     D  CQ_AITN              179    185
     D  MQ_AIAN              186    192P 0
     D  CQ_AIAN              186    192
     D  MQ_IPRN              193    199P 0
     D  CQ_IPRN              193    199
     D  MQ_FSCPAM            200    206P 0
     D  CQ_FSCPAM            200    206
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
 
      ** +----------------------------------------+
      ** ¦ Hook for non-core D-specs (all types)  ¦
      ** ¦ also any I-specs (if necessary)        ¦
      ** ¦ =====================================  ¦
      ** +----------------------------------------+
 
      *****************************************************************
      /SPACE 5
      *****************************************************************
 
      ** Initialize work variables
 
     C                   Z-ADD     0             HLMTOT           13 0
     C                   Z-ADD     0             HLNTOT           13 0
     C                   Z-ADD     0             HLPTOT           13 0
     C                   Z-ADD     0             HLQTOT           13 0
     C                   Z-ADD     0             HMMTOT           13 0
     C                   Z-ADD     0             HMNTOT           13 0
     C                   Z-ADD     0             HMPTOT           13 0
     C                   Z-ADD     0             HMQTOT           13 0
     C                   MOVE      *BLANKS       FORMAT            3
 
      ** Select Audit or Update mode.
 
     C     WMODE         IFEQ      'U'
     C     WMODE         OREQ      'u'
     C                   MOVE      '1'           *IN11
     C                   ELSE
     C                   MOVE      '0'           *IN11
     C                   ENDIF
 
      ** Update CAS005 fields for both live and matured
      ** History files.
 
     C                   EXSR      SrUpdHF
 
     C                   WRITE     DETAIL1
     C                   WRITE     FOOTER1
 
     C                   SETON                                        LR
     C                   RETURN
 
      /SPACE 5
      *****************************************************************
      *                                                               *
      * SrUpdHF - Update Lending History Files (HISTS* and MHIST*)    *
      *                                                               *
      *****************************************************************
     C     SrUpdHF       BEGSR
 
     C                   WRITE     HEADER1
 
      ** Check through entire HISTSHM
 
     C     1             SETLL     HISTSHMF
     C                   READ      HISTSHMF                               01
     C     *IN01         DOWEQ     '0'
 
     C                   EVAL      FORMAT = 'LMF'
     C                   EXSR      SrNumTst
     C     '1'           LOOKUP    *IN(40)                                50
     C     *IN50         IFEQ      '1'
     C     *IN11         IFEQ      '1'
     C                   Z-ADD     0             LM_AITN
     C                   Z-ADD     0             LM_AIAN
     C                   Z-ADD     0             LM_IPRN
     C                   Z-ADD     0             LM_FSPRAM
     C                   Z-ADD     0             LM_FSCPAM
     C                   UPDATE    HISTSHMF
     C                   ENDIF
     C                   ADD       1             HLMTOT
     C                   ENDIF
 
     C                   READ      HISTSHMF                               01
 
     C     *IN01         IFEQ      '1'
     C                   Z-ADD     HLMTOT        HLMRPT
     C                   ENDIF
     C                   ENDDO
 
      ** Check through entire HISTSHN
 
     C     1             SETLL     HISTSHNF
     C                   READ      HISTSHNF                               01
     C     *IN01         DOWEQ     '0'
 
     C                   EVAL      FORMAT = 'LNF'
     C                   EXSR      SrNumTst
     C     '1'           LOOKUP    *IN(40)                                50
     C     *IN50         IFEQ      '1'
     C     *IN11         IFEQ      '1'
     C                   Z-ADD     0             LN_INTN
     C                   Z-ADD     0             LN_FSPRAM
     C                   UPDATE    HISTSHNF
     C                   ENDIF
     C                   ADD       1             HLNTOT
     C                   ENDIF
 
     C                   READ      HISTSHNF                               01
 
     C     *IN01         IFEQ      '1'
     C                   Z-ADD     HLNTOT        HLNRPT
     C                   ENDIF
     C                   ENDDO
 
      ** Check through entire HISTSHP
 
     C     1             SETLL     HISTSHPF
     C                   READ      HISTSHPF                               01
     C     *IN01         DOWEQ     '0'
 
     C                   EVAL      FORMAT = 'LPF'
     C                   EXSR      SrNumTst
     C     '1'           LOOKUP    *IN(40)                                50
     C     *IN50         IFEQ      '1'
     C     *IN11         IFEQ      '1'
     C                   Z-ADD     0             LP_INTN
     C                   Z-ADD     0             LP_AITN
     C                   Z-ADD     0             LP_AIAN
     C                   Z-ADD     0             LP_IPRN
     C                   Z-ADD     0             LP_FSPRAM
     C                   Z-ADD     0             LP_FSCPAM
     C                   UPDATE    HISTSHPF
     C                   ENDIF
     C                   ADD       1             HLPTOT
     C                   ENDIF
 
     C                   READ      HISTSHPF                               01
 
     C     *IN01         IFEQ      '1'
     C                   Z-ADD     HLPTOT        HLPRPT
     C                   ENDIF
     C                   ENDDO
 
      ** Check through entire HISTSHQ
 
     C     1             SETLL     HISTSHQF
     C                   READ      HISTSHQF                               01
     C     *IN01         DOWEQ     '0'
 
     C                   EVAL      FORMAT = 'LQF'
     C                   EXSR      SrNumTst
     C     '1'           LOOKUP    *IN(40)                                50
     C     *IN50         IFEQ      '1'
     C     *IN11         IFEQ      '1'
     C                   Z-ADD     0             LQ_AITN
     C                   Z-ADD     0             LQ_AIAN
     C                   Z-ADD     0             LQ_IPRN
     C                   Z-ADD     0             LQ_FSCPAM
     C                   UPDATE    HISTSHQF
     C                   ENDIF
     C                   ADD       1             HLQTOT
     C                   ENDIF
 
     C                   READ      HISTSHQF                               01
 
     C     *IN01         IFEQ      '1'
     C                   Z-ADD     HLQTOT        HLQRPT
     C                   ENDIF
     C                   ENDDO
 
      ** Check through entire MHISTHM
 
     C     1             SETLL     MHISTMF
     C                   READ      MHISTMF                                01
     C     *IN01         DOWEQ     '0'
 
     C                   EVAL      FORMAT = 'MMF'
     C                   EXSR      SrNumTst
     C     '1'           LOOKUP    *IN(40)                                50
     C     *IN50         IFEQ      '1'
     C     *IN11         IFEQ      '1'
     C                   Z-ADD     0             MM_AITN
     C                   Z-ADD     0             MM_AIAN
     C                   Z-ADD     0             MM_IPRN
     C                   Z-ADD     0             MM_FSPRAM
     C                   Z-ADD     0             MM_FSCPAM
     C                   UPDATE    MHISTMF
     C                   ENDIF
     C                   ADD       1             HMMTOT
     C                   ENDIF
 
     C                   READ      MHISTMF                                01
 
     C     *IN01         IFEQ      '1'
     C                   Z-ADD     HMMTOT        HMMRPT
     C                   ENDIF
     C                   ENDDO
 
      ** Check through entire MHISTHN
 
     C     1             SETLL     MHISTNF
     C                   READ      MHISTNF                                01
     C     *IN01         DOWEQ     '0'
 
     C                   EVAL      FORMAT = 'MNF'
     C                   EXSR      SrNumTst
     C     '1'           LOOKUP    *IN(40)                                50
     C     *IN50         IFEQ      '1'
     C     *IN11         IFEQ      '1'
     C                   Z-ADD     0             MN_INTN
     C                   Z-ADD     0             MN_FSPRAM
     C                   UPDATE    MHISTNF
     C                   ENDIF
     C                   ADD       1             HMNTOT
     C                   ENDIF
 
     C                   READ      MHISTNF                                01
 
     C     *IN01         IFEQ      '1'
     C                   Z-ADD     HMNTOT        HMNRPT
     C                   ENDIF
     C                   ENDDO
 
      ** Check through entire MHISTHP
 
     C     1             SETLL     MHISTPF
     C                   READ      MHISTPF                                01
     C     *IN01         DOWEQ     '0'
 
     C                   EVAL      FORMAT = 'MPF'
     C                   EXSR      SrNumTst
     C     '1'           LOOKUP    *IN(40)                                50
     C     *IN50         IFEQ      '1'
     C     *IN11         IFEQ      '1'
     C                   Z-ADD     0             MP_INTN
     C                   Z-ADD     0             MP_AITN
     C                   Z-ADD     0             MP_AIAN
     C                   Z-ADD     0             MP_IPRN
     C                   Z-ADD     0             MP_FSPRAM
     C                   Z-ADD     0             MP_FSCPAM
     C                   UPDATE    MHISTPF
     C                   ENDIF
     C                   ADD       1             HMPTOT
     C                   ENDIF
 
     C                   READ      MHISTPF                                01
 
     C     *IN01         IFEQ      '1'
     C                   Z-ADD     HMPTOT        HMPRPT
     C                   ENDIF
     C                   ENDDO
 
      ** Check through entire MHISTHQ
 
     C     1             SETLL     MHISTQF
     C                   READ      MHISTQF                                01
     C     *IN01         DOWEQ     '0'
 
     C                   EVAL      FORMAT = 'MQF'
     C                   EXSR      SrNumTst
     C     '1'           LOOKUP    *IN(40)                                50
     C     *IN50         IFEQ      '1'
     C     *IN11         IFEQ      '1'
     C                   Z-ADD     0             MQ_AITN
     C                   Z-ADD     0             MQ_AIAN
     C                   Z-ADD     0             MQ_IPRN
     C                   Z-ADD     0             MQ_FSCPAM
     C                   UPDATE    MHISTQF
     C                   ENDIF
     C                   ADD       1             HMQTOT
     C                   ENDIF
 
     C                   READ      MHISTQF                                01
 
     C     *IN01         IFEQ      '1'
     C                   Z-ADD     HMQTOT        HMQRPT
     C                   ENDIF
     C                   ENDDO
 
     C                   ENDSR
      /SPACE 5
      *****************************************************************
      *                                                               *
      * SrNumTst - Check for numeric fields                           *
      *                                                               *
      *****************************************************************
     C     SrNumTst      BEGSR
 
     C                   MOVEA     '0000000'     *IN(40)
 
     C                   SELECT
 
     C     FORMAT        WHENEQ    'LMF'
     C                   TESTN                   TM_AITN                  41
     C                   TESTN                   TM_AIAN                  42
     C                   TESTN                   TM_IPRN                  43
     C                   TESTN                   TM_FSPRAM                44
     C                   TESTN                   TM_FSCPAM                45
 
     C     FORMAT        WHENEQ    'LNF'
     C                   TESTN                   TN_INTN                  41
     C                   TESTN                   TN_FSPRAM                42
 
     C     FORMAT        WHENEQ    'LPF'
     C                   TESTN                   TP_INTN                  41
     C                   TESTN                   TP_AITN                  42
     C                   TESTN                   TP_AIAN                  43
     C                   TESTN                   TP_IPRN                  44
     C                   TESTN                   TP_FSPRAM                45
     C                   TESTN                   TP_FSCPAM                46
 
     C     FORMAT        WHENEQ    'LQF'
     C                   TESTN                   TQ_AITN                  41
     C                   TESTN                   TQ_AIAN                  42
     C                   TESTN                   TQ_IPRN                  43
     C                   TESTN                   TQ_FSCPAM                44
 
     C     FORMAT        WHENEQ    'MMF'
     C                   TESTN                   CM_AITN                  41
     C                   TESTN                   CM_AIAN                  42
     C                   TESTN                   CM_IPRN                  43
     C                   TESTN                   CM_FSPRAM                44
     C                   TESTN                   CM_FSCPAM                45
 
     C     FORMAT        WHENEQ    'MNF'
     C                   TESTN                   CN_INTN                  41
     C                   TESTN                   CN_FSPRAM                42
 
     C     FORMAT        WHENEQ    'MPF'
     C                   TESTN                   CP_INTN                  41
     C                   TESTN                   CP_AITN                  42
     C                   TESTN                   CP_AIAN                  43
     C                   TESTN                   CP_IPRN                  44
     C                   TESTN                   CP_FSPRAM                45
     C                   TESTN                   CP_FSCPAM                46
 
     C     FORMAT        WHENEQ    'MQF'
     C                   TESTN                   CQ_AITN                  41
     C                   TESTN                   CQ_AIAN                  42
     C                   TESTN                   CQ_IPRN                  43
     C                   TESTN                   CQ_FSCPAM                44
 
     C                   ENDSL
 
     C                   ENDSR
      /SPACE 5
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
 
      ** INPUT.
 
     C                   PARM                    WMODE             1
 
      ** Access Bank Details
 
     C                   CALL      'AOBANKR0'
     C                   PARM      '       '     @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
 
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     '*ERROR '     RetCodeIn
     C                   MOVEL     'SDBANKPD'    DBFILE
     C                   MOVEL     '100'         DBASE
     C                   MOVEL     '*FIRST  '    DBKEY
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Access General Ledger Details
 
     C                   CALL      'AOGELRR0'
     C                   PARM      '       '     @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C     SDGELR        PARM      SDGELR        DSFDY
 
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     '*ERROR '     RetCodeIn
     C                   MOVEL     'SDGELRPD'    DBFILE
     C                   MOVEL     '200'         DBASE
     C                   MOVEL     '*FIRST  '    DBKEY
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
 
     C/COPY ZACPYSRC,DBFIELDS
 
     C                   ENDSR
      /SPACE 5
      *****************************************************************
      *                                                               *
      * *PSSR - Subroutine to handle error conditions                 *
      *                                                               *
      *****************************************************************
     C     *PSSR         BEGSR
 
     C                   DUMP
 
     C                   IF        RunBefore <> 'Y'
     C                   EVAL      RunBefore = 'Y'
     C                   CALL      'DBERRCTL'
     C                   ENDIF
 
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
 
     C                   RETURN
     C                   ENDSR
      ********************************************************************
**  CPY@
(c) Finastra International Limited 2012
