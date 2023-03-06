     H DEBUG
     H OPTION(*NOUNREF)
     H COPYRIGHT('(c) Finastra International Limited 2023')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas AO Background update of MEMOS')                  *
      *****************************************************************
      *                                                               *
      *  Midas - Access Objects Module                                *
      *                                                               *
      *     AOMEMSU2 - Background update of MEMOS                     *
      *                                                               *
      *  (c) Finastra International Limited 2023                      *
      *                                                               *
      *  Last Amend No. MD060909  *CREATE  Date 14Feb23               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD060909 - After COB job FTC0630 go in MSGW.                 *
      *                                                               *
      *****************************************************************
     FMEMOSL1   UF   E           K DISK    COMMIT
     F                                     USROPN
     F                                     INFSR(SRFILE)
     F                                     INFDS(@MEMO1)
      *
      ** Define Shadow balances by G/L Account Number
      *
     FMEMOSL2   UF   E           K DISK    COMMIT
     F                                     USROPN
     F                                     INFSR(SRFILE)
     F                                     RENAME(MEMOSMDF:@MEMOSXX)
     F                                     INFDS(@MEMO2)
      *
      ** Define Shadow balances by Retail Account Number
      *

      /EJECT
      *****************************************************************
      ** +--------------------------------------+
      **   Automatically included D-specs        
      **   ==============================        
      ** +--------------------------------------+
      **----------------------------------------------------------------
      ** The following /COPY line includes (among others) the LDA layout
      ** and the copyright array definition:
     D/COPY ZACPYSRC,STD_D_SPEC
      **----------------------------------------------------------------
      ** The following /COPY line includes all the defined fields in the
      ** Program Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
      **----------------------------------------------------------------
      ** +--------------------------------------+
      **   End of automatically included D-specs 
      **   ===================================== 
      ** +--------------------------------------+
      *****************************************************************
      *
      ** Entry parameter
      *
     D pRtnCode        S              7A
     D pEntData        S                   LIKE( tpMEMOS )
      *
      ** Array of QCMDEXC commands
      *
     D CMD@            S             80    DIM(1) CTDATA PERRCD(1)
      *
      ** Error texts
      *
     D ERR@            S             80    DIM(5) CTDATA PERRCD(1)
      *
      ** Array of DLYJOB command to edit
      *
     D CMDDLY          S             80    DIM(1) CTDATA PERRCD(1)
      *
      ** Array of DLYJOB command to edit
      *
     D EDT             S              1    DIM(80)
      *
      ** Subroutine stack
      *
     D @STK            S             10    DIM(20)
      *
      ** Data structure used in setting up day no of next working day
      *
     D ODT             DS
     D  @WD                    1     48P 0
     D                                     DIM(16) ASCEND
      *
      ** Data structure used in setting up incoming amounts
      *
     D OFI             DS
     D  @IA                    1    128P 0
     D                                     DIM(16)
      *
      ** Data structure used in setting up incoming amounts
      *
     D OFO             DS
     D  @OA                    1    128P 0
     D                                     DIM(16)

      ** External DS for access programs, short DS
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** External DS for bank details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)

     D W0DS            DS                  INZ
     D  W0ACNO                             LIKE( tpMEMOS.MEACNO)
     D  W0CNUM                             LIKE( tpMEMOS.MECNUM)
     D  W0CCY                              LIKE( tpMEMOS.MECCY )
     D  W0ACOD                             LIKE( tpMEMOS.MEACOD)
     D  W0ACSQ                             LIKE( tpMEMOS.MEACSQ)
     D  W0BRCA                             LIKE( tpMEMOS.MEBRCA)
     D  W0RDAT                             LIKE( tpMEMOS.MERDAT)
     D  W0VDAT                             LIKE( tpMEMOS.MEVDAT)
     D  W0PDAT                             LIKE( tpMEMOS.MEPDAT)
     D  W0AMT                              LIKE( tpMEMOS.MEAMT )
     D  W0FTOV                             LIKE( tpMEMOS.MEFTOV)
      *
      ** Working array of balances for next sixteen working days
      *
     D @WK             S             15  0 DIM(16)
      *

      ** Templates

     D tpMEMOS       E DS                  TEMPLATE QUALIFIED
     D                                     EXTNAME( GLMEMOTD )
      *
      ** Send message data structure
      *
     D DBDTA           DS
     D  DBERNB                51     55  0
     D  DBNARR                56    135
     D  DBSTK                136    145
     D  DBPREF               146    175

     D @MEMO1        E DS                  EXTNAME(Y2IUDSP)
     D @MEMO2        E DS                  EXTNAME(Y2IUDSP)
     D                                     PREFIX(@)

     D UGLERR          DS
     D  U0CNUM                 1      6
     D  U0CCY                  7      9
     D  U0ACOD                10     19  0
     D  U0ACSQ                20     21  0
     D  U0BRCA                22     24

     D PRTCD           S              7A
     D POPTN           S              7A

      /EJECT
      *****************************************************************
      * MAIN - Main body                                              *
      *****************************************************************

      ** Update MEMOS file with passed data

     C                   EVAL      W0DS = pEntData

      *
      ** Ascertain whether General Ledger or Retail.
      *
     C     W0ACNO        IFEQ      *ZEROS
     C                   MOVE      'G'           UACTYP            1
     C                   ELSE
     C                   MOVE      'R'           UACTYP
     C                   ENDIF
      *
      **  Read Memos record for update
      *
     C     UACTYP        IFEQ      'G'
     C     *LOVAL        SETLL     MEMOSL1
     C     GLKEY         CHAIN     MEMOSL1                            9091
     C     *IN91         IFEQ      '1'
     C                   EXSR      SRFILE
     C                   ENDIF
     C                   ELSE
     C     *LOVAL        SETLL     MEMOSL2
     C     W0ACNO        CHAIN     MEMOSL2                            9091
     C     *IN91         IFEQ      '1'
     C                   EXSR      SRFILE
     C                   ENDIF
     C                   ENDIF
      *
      ** If CHAIN failure ascertain correct key.
      *
     C     *IN90         IFEQ      '1'
     C     RECI          ORNE      'D'
     C     UACTYP        IFEQ      'G'
     C                   EVAL      U0CNUM = W0CNUM
     C                   MOVEL     W0CCY         U0CCY
     C                   Z-ADD     W0ACOD        U0ACOD
     C                   Z-ADD     W0ACSQ        U0ACSQ
     C                   MOVEL     W0BRCA        U0BRCA
     C                   MOVEL     UGLERR        W0KEY
     C                   MOVEL     'MEMOSL1 '    W0FILE
     C                   Z-ADD     4             W0ERNB
     C                   EXSR      SRERR
     C                   ELSE
     C                   MOVEL     W0ACNO        W0KEY
     C                   MOVEL     'MEMOSL2 '    W0FILE
     C                   Z-ADD     4             W0ERNB
     C                   EXSR      SRERR
     C                   ENDIF
     C                   ENDIF
      *
     C     *IN90         IFEQ      '1'
     C     RECI          ORNE      'D'
     C                   Z-ADD     5             W0ERNB
     C                   MOVEL     ERR@(3)       W0NARR
     C                   EXSR      SRERR
     C                   END
      *
      ** Change values on Memos record
      *
      ** If value date is today or less then alter both balances
      *
     C     W0VDAT        IFLE      BJRDNB
     C                   ADD       W0AMT         LDBLN
     C                   ADD       W0AMT         CLBLN
     C                   ELSE
      *
      ** If posting date is today or less then alter ledger balance
      ** or if FT override is in effect
      *
     C     W0PDAT        IFLE      BJRDNB
     C     W0FTOV        OREQ      'Y'
     C                   ADD       W0AMT         LDBLN
     C                   END
     C                   END
      *
      ** Update Memos fields
      *
     C     UACTYP        IFEQ      'G'
     C                   EXCEPT    UPDMMS
     C                   ELSE
     C                   EXCEPT    UPDMM1
     C                   ENDIF
     C/COPY WNCPYSRC,AOMEMSU0C1
      *
     C                   IF        %OPEN(MEMOSL1)
     C                   CLOSE     MEMOSL1
     C                   ENDIF

     C                   IF        %OPEN(MEMOSL2)
     C                   CLOSE     MEMOSL2
     C                   ENDIF

     C                   SETON                                        LR

     C                   RETURN
     C/EJECT
      *****************************************************************
      *                                                               *
      *  *INZSR     Initialise and define fields                      *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR
      *
      ** Define entry parameters
      *
     C     *ENTRY        PLIST
     C                   PARM                    pRtnCode
     C                   PARM                    pEntData
      *
      ** GL key
      *
     C     GLKEY         KLIST
     C                   KFLD                    W0CNUM
     C                   KFLD                    W0CCY
     C                   KFLD                    W0ACOD
     C                   KFLD                    W0ACSQ
     C                   KFLD                    W0BRCA

      *
      ** Access Bank Details
      *
     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*FIRST '     POPTN
     C     SDBANK        PARM      SDBANK        DSFDY

     C                   IF        PRTCD <> *BLANKS
     C                   EVAL      DBFILE = 'SDBANKPD'
     C                   EVAL      DBASE = 1
     C                   EVAL      DBKEY = '*FIRST'
     C                   EXSR      SRERR
     C                   ENDIF

      *
      ** Set up subroutine stack name
      *
     C                   ADD       1             Q                 5 0
     C                   MOVEL     '*INZSR'      @STK(Q)
      *
      ** Define W0 database error variables
      *
     C     *LIKE         DEFINE    DBFILE        W0FILE
     C     *LIKE         DEFINE    DBKEY         W0KEY
     C     *LIKE         DEFINE    DBERNB        W0ERNB
     C     *LIKE         DEFINE    DBNARR        W0NARR
     C     *LIKE         DEFINE    DBPREF        W0PREF
      *
      ** Override file MEMOSL0 to share(*NO)
      *
     C                   MOVEA     CMD@(1)       EDT
     C                   MOVEL     'MEMOSL1'     U#FILE           10
     C                   MOVEA     U#FILE        EDT(17)
     C                   MOVEA     EDT           OVRDBF           80
     C                   Z-ADD     80            CMDLEN           15 5
     C                   CALL      'QCMDEXC'                              90    90
     C                   PARM                    OVRDBF
     C                   PARM                    CMDLEN
      *
     C     *IN90         IFEQ      '1'
     C                   EVAL      pRtnCode = '*ERROR'
     C                   MOVEL     '*CALL  '     W0FILE
     C                   MOVEL     'QCMDEXC'     W0KEY
     C                   Z-ADD     2             W0ERNB
     C                   EXSR      SRERR
     C                   END
      *
      ** Override file MEMOSL1 to share(*NO)
      *
     C                   MOVEA     CMD@(1)       EDT
     C                   MOVEL     'MEMOSL2'     U#FILE           10
     C                   MOVEA     U#FILE        EDT(17)
     C                   MOVEA     EDT           OVRDBF           80
     C                   Z-ADD     80            CMDLEN           15 5
     C                   CALL      'QCMDEXC'                              90    90
     C                   PARM                    OVRDBF
     C                   PARM                    CMDLEN
      *
     C     *IN90         IFEQ      '1'
     C                   EVAL      pRtnCode = '*ERROR'
     C                   MOVEL     '*CALL  '     W0FILE
     C                   MOVEL     'QCMDEXC'     W0KEY
     C                   Z-ADD     3             W0ERNB
     C                   EXSR      SRERR
     C                   END
      *
      ** Open MEMOS file for update
      *
     C                   IF        NOT %OPEN(MEMOSL1)
     C                   OPEN      MEMOSL1
     C                   ENDIF

     C                   IF        NOT %OPEN(MEMOSL2)
     C                   OPEN      MEMOSL2
     C                   ENDIF
      *
      ** Indicate that set up is complete
      *
     C                   SETON                                        50
      *
      ** Unwind subroutine stack name
      *
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
      *
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      *                                                               *
      *  SRERR    : Report error and close down program               *
      *                                                               *
      *****************************************************************
     CSR   SRERR         BEGSR
      *
      *  Dump program
      *
     C                   DUMP
      *
      ** Send message to MOPERQ
      *
     C                   MOVEL     *BLANKS       DBDTA
     C                   MOVEL     'AOMEMSU2'    DBPGM
     C                   MOVEL     @STK(Q)       DBSTK
     C                   MOVEL     W0KEY         DBKEY
     C                   MOVEL     W0ERNB        DBERNB
     C                   MOVEL     W0FILE        DBFILE
     C     W0NARR        IFEQ      *BLANKS
     C                   MOVEL     ERR@(1)       DBNARR
     C                   ELSE
     C                   MOVEL     W0NARR        DBNARR
     C                   END
      *
     C                   CALLB     'AOCREPT'                            9090
     C                   PARM      'MEM5000'     #MSGID
     C                   PARM      'MIDAS  '     #MSGF
     C                   PARM      *BLANKS       #MSGFL
     C                   PARM      DBDTA         #MSGDT
     C                   PARM      '*PRV'        #MSGR
     C                   PARM      '*'           #PRGM
     C                   PARM      'MOPERQ '     #MSGQ
     C                   PARM      '*INFO  '     #MSGT
      *
      ** Close down program
      *
     C                   SETON                                        LR
     C                   MOVEL     '*ERROR*'     pRtnCode
     C                   RETURN
      *
     CSR   EXERR         ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      *                                                               *
      *  SRFILE   : *PSSR routine for all files                       *
      *                                                               *
      *  CALLED BY: IBM controlled - invalid access to file           *
      *                                                               *
      *****************************************************************
     CSR   SRFILE        BEGSR
      *
      ** Dump program
      *
     C                   DUMP
      *
      ** If called again seton LR and return
      *
     C     @@FILE        IFNE      *BLANKS
     C                   MOVEL     '1'           *INLR
     C                   RETURN
     C                   END
     C                   MOVEL     'Y'           @@FILE            1
      *
      ** Send message to MOPERQ
      *
     C                   MOVEL     *BLANKS       DBDTA
     C                   MOVEL     'AOMEMSU2'    DBPGM
     C                   MOVEL     @STK(Q)       DBSTK
     C                   MOVEL     'MEMOS'       DBKEY
     C                   MOVEL     1             DBERNB
     C                   MOVEL     'MEMOS'       DBFILE
     C                   MOVEL     ERR@(4)       DBNARR
      *
     C                   CALLB     'AOCREPT'                            9090
     C                   PARM      'MEM5000'     #MSGID            7
     C                   PARM      'MIDAS  '     #MSGF            10
     C                   PARM      *BLANKS       #MSGFL           10
     C                   PARM      DBDTA         #MSGDT          256
     C                   PARM      '*PRV'        #MSGR             5
     C                   PARM      '*'           #PRGM            10
     C                   PARM      'MOPERQ '     #MSGQ            10
     C                   PARM      '*INFO  '     #MSGT             7
      *
      ** Close down program
      *
     C                   SETON                                        LR
     C                   MOVEL     '*ERROR*'     pRtnCode
     C                   RETURN
      *
     CSR   EXFILE        ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
     C/EJECT
     OMEMOSMDF  E            UPDMMS
     O                       LDBLN
     O                       CLBLN
     O@MEMOSXX  E            UPDMM1                                             CCB002
     O                       LDBLN                                              CCB002
     O                       CLBLN                                              CCB002
** CPY@
(c) Finastra International Limited 2014
** CTDATA CMD@
OVRDBF     FILE(XXXXXXXXXX) SHARE(*NO) SECURE(*YES) WAITRCD(15)
** CTDATA ERR@
See dump for further information
Invalid Access to update object
Record not found or marked as deleted
File access error occurred - see dump for full details - see key for opcode
Error occurred on call to program - see dumps for further details
** CTDATA CMDDLY
DLYJOB     DLY(1)
