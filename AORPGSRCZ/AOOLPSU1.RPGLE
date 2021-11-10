     H DEBUG
     H OPTION(*NOUNREF)
     H COPYRIGHT('(c) Finastra International Limited 2014')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas AO Background update of OLPOS')                  *
      *****************************************************************
      *                                                               *
      *  Midas - Access Objects Module                                *
      *                                                               *
      *     AOOPLSU1 - Background update of OLPOS                     *
      *                                                               *
      *  (c) Finastra International Limited 2014                      *
      *                                                               *
      *  Last Amend No. MD058972           Date 03Nov21               *
      *  Prev Amend No. MD053378           Date 03Nov21               *
      *                 213720             Date 03Nov21               *
      *                 MD046248           Date 27Oct17               *
      *                 MD026169           Date 09Apr14               *
      *                 MD025679B          Date 26Mar14               *
      *                 MD025679A          Date 21Mar14               *
      *                 MD025679  *CREATE  Date 15Mar14               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD058972 - BFM - Deal Amendments error                       *
      *  MD053378 - Amend fix 213720 to delay the job for 1 second    *
      *             instead of 10. Logical file OLPOS wait record     *
      *             time is reduced to 15 seconds.                    *
      *             Pattern fix 249627                                *
      *           - Applied for MD058972.                             *
      *  213720 - Record lock occured.  Delay job if record is locked *
      *           by another user.  Bypass if record cannot be        *
      *           allocated.                                          *
      *           - Applied for MD058972.                             *
      *  MD046248 - Finastra Rebranding                               *
      *  MD026169 - GO_ONL_OLP background job is processing           *
      *             full receiver chain                               *
      *  MD025679B - API - PRONO Locking Issue                        *
      *  MD025679A - Added copyright to program                       *
      *  MD025679 - Optimized code was of AOOLPSU0.                   *
      *           - API - OLPOSOA Locking Issue.                      *
      *                                                               *
      *****************************************************************
     F***OLPOS**   UF A E           K DISK    INFSR(*PSSR)                                  MD058972
     FOLPOS     UF A E           K DISK    INFSR(SRFILE)                                    MD058972
     F                                     COMMIT
     F                                     USROPN
     F                                     IGNORE(OLPOSHHF)
     F                                     IGNORE(OLPOSOBF)
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
     D pEntData        S                   LIKE( tpOLPOS )
      *
      ** Array of QCMDEXC commands
      *
     D CMD@            S             80    DIM(1) CTDATA PERRCD(1)
      *                                                                                     MD058972
      ** Error texts                                                                        MD058972
      *                                                                                     MD058972
     D ERR@            S             80    DIM(5) CTDATA PERRCD(1)                          MD058972
      *                                                                                       213720
      ** Array of DLYJOB command to edit                                                      213720
      *                                                                                       213720
     D CMDDLY          S             80    DIM(1) CTDATA PERRCD(1)                            213720
      *
      ** Array of DLYJOB command to edit
      *
     D EDT             S              1    DIM(80)
      *                                                                                     MD058972
      ** Subroutine stack                                                                   MD058972
      *                                                                                     MD058972
     D @STK            S             10    DIM(20)                                          MD058972
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

     D W0DS            DS                  INZ
     D  W0KEY#                             LIKE( tpOLPOS.OLKEY )
     D   W0BRCA                            LIKE( BRCA ) OVERLAY( W0KEY# )
     D   W0CCY                             LIKE( CCY  ) OVERLAY( W0KEY# : *NEXT)
     D   W0RECN                       2S 0 OVERLAY( W0KEY# : *NEXT )
     D  W0VDAT                             LIKE( tpOLPOS.OLVDAT )
     D  W0AMT                              LIKE( tpOLPOS.OLAMT )
     D  W0IO                               LIKE( tpOLPOS.OLIO )
      *
      ** Working array of balances for next sixteen working days
      *
     D @WK             S             15  0 DIM(16)
      *

      ** Templates

     D tpOLPOS       E DS                  TEMPLATE QUALIFIED
     D                                     EXTNAME( GLOLPSTD )
      *                                                                                     MD058972
      ** Send message data structure                                                        MD058972
      *                                                                                     MD058972
     D DBDTA           DS                                                                   MD058972
     D  DBPGM                  1     10                                                     MD058972
     D  DBFILE                11     20                                                     MD058972
     D  DBKEY                 21     50                                                     MD058972
     D  DBERNB                51     55  0                                                  MD058972
     D  DBNARR                56    135                                                     MD058972
     D  DBSTK                136    145                                                     MD058972
     D  DBPREF               146    175                                                     MD058972

      /EJECT
      *****************************************************************
      * MAIN - Main body                                              *
      *****************************************************************

      ** Update Olpos file with passed data

     C                   EVAL      W0DS = pEntData
     C                   EXSR      SROLPS

     C                   RETURN
     C/EJECT
      *****************************************************************
      *                                                               *
      *  SROLPS   : Update Olpos file                                 *
      *                                                               *
      *  CALLED BY: Main Processing                                   *
      *                                                               *
      *****************************************************************
     C     SROLPS        BEGSR
      *                                                                                     MD058972
      ** Set up subroutine stack name                                                       MD058972
      *                                                                                     MD058972
     C                   ADD       1             Q                                          MD058972
     C                   MOVEL     'SROLPS'      @STK(Q)                                    MD058972
      *
      ** Read Olpos record for update
      *
     C*****@OLPKY        CHAIN     OLPOSOAF                           90                      213720
     C     @OLPKY        CHAIN     OLPOSOAF                           9091                    213720
      *                                                                                       213720
     C                   Z-ADD     1             COUNT             1 0                        213720
     C     *IN91         DOWEQ     '1'                                                        213720
     C*****COUNT         ANDLT     7                                                 213720 MD053378
     C     COUNT         ANDLT     5                                                        MD053378
      *                                                                                       213720
     C                   MOVEA     CMDDLY(1)     DLYJOB           80                          213720
     C                   Z-ADD     80            CMDLEN                                       213720
     C                   CALL      'QCMDEXC'                              93                  213720
     C                   PARM                    DLYJOB                                       213720
     C                   PARM                    CMDLEN                                       213720
      *                                                                                       213720
     C     *IN93         IFEQ      '1'                                                        213720
     C                   MOVEL     '*CALL  '     W0FILE                                       213720
     C                   MOVEL     'QCMDEXC'     W0KEY                                        213720
     C                   Z-ADD     6             W0ERNB                                       213720
     C                   EXSR      SRERR                                                      213720
     C                   END                                                                  213720
      *                                                                                       213720
     C     *LOVAL        SETLL     OLPOSOAF                                                   213720
     C     @OLPKY        CHAIN     OLPOSOAF                           9091                    213720
     C                   ADD       1             COUNT                                        213720
      *                                                                                       213720
     C                   ENDDO                                                                213720
      *
      ** Only report database error if record found but deleted
      *
     C     *IN90         IFEQ      '0'
     C     RECI          ANDNE     'D'
     C                   EVAL      pRtnCode = '*ERROR'
     C**********         MOVEL     'OLPOSO1 '    DBFILE                                     MD058972
     C**********         MOVEL     W0KEY#        DBKEY                                      MD058972
     C**********         Z-ADD     002           DBASE                                      MD058972
     C**********         EXSR      *PSSR                                                    MD058972
     C                   MOVEL     'OLPOSO1 '    W0FILE                                     MD058972
     C                   MOVEL     W0KEY#        W0KEY                                      MD058972
     C                   Z-ADD     5             W0ERNB                                     MD058972
     C                   MOVEL     ERR@(3)       W0NARR                                     MD058972
     C                   EXSR      SRERR                                                    MD058972
     C                   END
      *
      ** Exit if record not found as currency input today
      *
     C     *IN90         CABEQ     '1'           EXOLPS
      *                                                                                       213720
      ** Update should only be done if record was successfully locked                         213720
      *                                                                                       213720
     C     *IN91         CABEQ     '1'           EXOLPS                                       213720
      *
      ** Depending upon whether amount is to be added to incoming or
      ** outgoing amounts set up work array of balance
      *
     C     W0IO          IFEQ      'I'
     C     1             DO        16            @I                3 0
     C                   Z-ADD     @IA(@I)       @WK(@I)
     C                   END
     C                   ELSE
     C     1             DO        16            @I
     C                   Z-ADD     @OA(@I)       @WK(@I)
     C                   END
     C                   END
      *
      ** Determine online position balance to be altered
      *
     C                   Z-ADD     1             @I
     C     W0VDAT        LOOKUP    @WD(@I)                              6061
      *
      ** Add amount into correct balance if date found in array less
      ** than or equal to event date, otherwise use element 1.
      *
     C     *IN60         IFEQ      '0'
     C     *IN61         ANDEQ     '0'
     C                   Z-ADD     1             @I
     C                   END
      *
      ** If value date is after last element of the array then update
      ** the last element of the on-line position array (as per GL0630).
      *
     C                   Z-ADD     16            @J                2 0
     C     W0VDAT        IFGT      @WD(@J)
     C                   Z-ADD     16            @I
     C                   ENDIF
      *
     C                   ADD       W0AMT         @WK(@I)
      *
      ** Move updated work array back into arrays of incoming /
      ** balances.
      *
     C     W0IO          IFEQ      'I'
     C     1             DO        16            @I
     C                   Z-ADD     @WK(@I)       @IA(@I)
     C                   END
     C                   ELSE
     C     1             DO        16            @I                3 0
     C                   Z-ADD     @WK(@I)       @OA(@I)
     C                   END
     C                   END
      *
      ** Update Olpos fields
      *
     C     MISS          TAG
     C                   EXCEPT    UPDOLP
     C                   UNLOCK    OLPOS                                94                    213720
      *                                                                                       213720
     C     *IN94         IFEQ      '1'                                                        213720
     C                   MOVEL     '*UNLOCK'     W0FILE                                       213720
     C                   MOVEL     W0KEY#        W0KEY                                        213720
     C                   Z-ADD     7             W0ERNB                                       213720
     C                   EXSR      SRERR                                                      213720
     C                   END                                                                  213720
      *
     C     EXOLPS        TAG
      *                                                                                     MD058972
      ** Unwind subroutine stack name                                                       MD058972
      *                                                                                     MD058972
     C                   MOVEA     *BLANKS       @STK(Q)                                    MD058972
     C                   SUB       1             Q                                          MD058972
      *
     C                   ENDSR
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
      ** Set up key list to OLPOSOAF
      *
     C     @OLPKY        KLIST
     C                   KFLD                    W0BRCA
     C                   KFLD                    W0CCY
     C                   KFLD                    W0RECN
      *                                                                                     MD058972
      ** Set up subroutine stack name                                                       MD058972
      *                                                                                     MD058972
     C                   ADD       1             Q                 5 0                      MD058972
     C                   MOVEL     '*INZSR'      @STK(Q)                                    MD058972
      *                                                                                     MD058972
      ** Define W0 database error variables                                                 MD058972
      *                                                                                     MD058972
     C     *LIKE         DEFINE    DBFILE        W0FILE                                     MD058972
     C     *LIKE         DEFINE    DBKEY         W0KEY                                      MD058972
     C     *LIKE         DEFINE    DBERNB        W0ERNB                                     MD058972
     C     *LIKE         DEFINE    DBNARR        W0NARR                                     MD058972
     C     *LIKE         DEFINE    DBPREF        W0PREF                                     MD058972
      *
      ** Override file OLPOS to share(*NO)
      *
     C                   MOVEA     CMD@(1)       EDT
     C                   MOVEL     'OLPOS'       U#FILE           10
     C                   MOVEA     U#FILE        EDT(17)
     C                   MOVEA     EDT           OVRDBF           80
     C                   Z-ADD     80            CMDLEN           15 5
     C                   CALL      'QCMDEXC'                              90    90
     C                   PARM                    OVRDBF
     C                   PARM                    CMDLEN
      *
     C     *IN90         IFEQ      '1'
     C                   EVAL      pRtnCode = '*ERROR'
     C**********         MOVEL     '*CALL  '     DBFILE                                     MD058972
     C**********         MOVEL     'QCMDEXC'     DBKEY                                      MD058972
     C**********         Z-ADD     001           DBASE                                      MD058972
     C**********         EXSR      *PSSR                                                    MD058972
     C                   MOVEL     '*CALL  '     W0FILE                                     MD058972
     C                   MOVEL     'QCMDEXC'     W0KEY                                      MD058972
     C                   Z-ADD     1             W0ERNB                                     MD058972
     C                   EXSR      SRERR                                                    MD058972
     C                   END
      *
      ** Open Olpos file for update
      *
     C                   IF        NOT %OPEN(OLPOS)
     C                   OPEN      OLPOS
     C                   ENDIF
      *
      ** Indicate that set up is complete
      *
     C                   SETON                                        50
      *                                                                                     MD058972
      ** Unwind subroutine stack name                                                       MD058972
      *                                                                                     MD058972
     C                   MOVEA     *BLANKS       @STK(Q)                                    MD058972
     C                   SUB       1             Q                                          MD058972
      *
     C                   ENDSR
      *****************************************************************                     MD058972
     C/EJECT                                                                                MD058972
      *****************************************************************                     MD058972
      *                                                               *                     MD058972
      *  SRERR    : Report error and close down program               *                     MD058972
      *                                                               *                     MD058972
      *****************************************************************                     MD058972
     CSR   SRERR         BEGSR                                                              MD058972
      *                                                                                     MD058972
      *  Dump program                                                                       MD058972
      *                                                                                     MD058972
     C                   DUMP                                                               MD058972
      *                                                                                     MD058972
      *  Send message to MOPERQ                                                             MD058972
      *                                                                                     MD058972
     C                   MOVEL     *BLANKS       DBDTA                                      MD058972
     C                   MOVEL     'AOOLPSU1'    DBPGM                                      MD058972
     C                   MOVEL     @STK(Q)       DBSTK                                      MD058972
     C                   MOVEL     W0KEY         DBKEY                                      MD058972
     C                   MOVEL     W0ERNB        DBERNB                                     MD058972
     C                   MOVEL     W0FILE        DBFILE                                     MD058972
     C     W0NARR        IFEQ      *BLANKS                                                  MD058972
     C                   MOVEL     ERR@(1)       DBNARR                                     MD058972
     C                   ELSE                                                               MD058972
     C                   MOVEL     W0NARR        DBNARR                                     MD058972
     C                   END                                                                MD058972
      *                                                                                     MD058972
     C                   CALLB     'AOCREPT'                            9090                MD058972
     C                   PARM      'MEM5000'     #MSGID                                     MD058972
     C                   PARM      'MIDAS  '     #MSGF                                      MD058972
     C                   PARM      *BLANKS       #MSGFL                                     MD058972
     C                   PARM      DBDTA         #MSGDT                                     MD058972
     C                   PARM      '*PRV'        #MSGR                                      MD058972
     C                   PARM      '*'           #PRGM                                      MD058972
     C                   PARM      'MOPERQ '     #MSGQ                                      MD058972
     C                   PARM      '*INFO  '     #MSGT                                      MD058972
      *                                                                                     MD058972
      *  Close down program                                                                 MD058972
      *                                                                                     MD058972
     C                   SETON                                        LR                    MD058972
     C                   MOVEL     '*ERROR*'     pRtnCode                                   MD058972
     C                   RETURN                                                             MD058972
      *                                                                                     MD058972
     CSR   EXERR         ENDSR                                                              MD058972
      *****************************************************************                     MD058972
     C/EJECT                                                                                MD058972
      *****************************************************************                     MD058972
      *                                                               *                     MD058972
      *  SRFILE   : *PSSR routine for all files                       *                     MD058972
      *                                                               *                     MD058972
      *  CALLED BY: IBM controlled - invalid access to file           *                     MD058972
      *                                                               *                     MD058972
      *****************************************************************                     MD058972
     CSR   SRFILE        BEGSR                                                              MD058972
      *                                                                                     MD058972
      *  Dump program                                                                       MD058972
      *                                                                                     MD058972
     C                   DUMP                                                               MD058972
      *                                                                                     MD058972
      *  If called again seton LR and return                                                MD058972
      *                                                                                     MD058972
     C     @@FILE        IFNE      *BLANKS                                                  MD058972
     C                   MOVEL     '1'           *INLR                                      MD058972
     C                   RETURN                                                             MD058972
     C                   END                                                                MD058972
     C                   MOVEL     'Y'           @@FILE            1                        MD058972
      *                                                                                     MD058972
      *  Send message to MOPERQ                                                             MD058972
      *                                                                                     MD058972
     C                   MOVEL     *BLANKS       DBDTA                                      MD058972
     C                   MOVEL     'AOOLPSU1'    DBPGM                                      MD058972
     C                   MOVEL     @STK(Q)       DBSTK                                      MD058972
     C                   MOVEL     'OLPOS'       DBKEY                                      MD058972
     C                   MOVEL     1             DBERNB                                     MD058972
     C                   MOVEL     'OLPOS'       DBFILE                                     MD058972
     C                   MOVEL     ERR@(4)       DBNARR                                     MD058972
      *                                                                                     MD058972
     C                   CALLB     'AOCREPT'                            9090                MD058972
     C                   PARM      'MEM5000'     #MSGID            7                        MD058972
     C                   PARM      'MIDAS  '     #MSGF            10                        MD058972
     C                   PARM      *BLANKS       #MSGFL           10                        MD058972
     C                   PARM      DBDTA         #MSGDT          256                        MD058972
     C                   PARM      '*PRV'        #MSGR             5                        MD058972
     C                   PARM      '*'           #PRGM            10                        MD058972
     C                   PARM      'MOPERQ '     #MSGQ            10                        MD058972
     C                   PARM      '*INFO  '     #MSGT             7                        MD058972
      *                                                                                     MD058972
      *  Close down program                                                                 MD058972
      *                                                                                     MD058972
     C                   SETON                                        LR                    MD058972
     C                   MOVEL     '*ERROR*'     pRtnCode                                   MD058972
     C                   RETURN                                                             MD058972
      *                                                                                     MD058972
     CSR   EXFILE        ENDSR                                                              MD058972
      *****************************************************************
     C/EJECT
      *****************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
     C/EJECT
     OOLPOSOAF  E            UPDOLP
     O                       OFI
     O                       OFO
** CPY@
(c) Finastra International Limited 2014
** CTDATA CMD@
OVRDBF     FILE(XXXXXXXXXX) SHARE(*NO) SECURE(*YES) WAITRCD(15)                             MD053378
** CTDATA ERR@                                                                              MD058972
See dump for further information                                                            MD058972
Invalid Access to update object                                                             MD058972
Record not found or marked as deleted                                                       MD058972
File access error occurred - see dump for full details - see key for opcode                 MD058972
Error occurred on call to program - see dumps for further details                           MD058972
** CTDATA CMDDLY                                                                            MD053378
DLYJOB     DLY(1)                                                                   213720  MD053378
