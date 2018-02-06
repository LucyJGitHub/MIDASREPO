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
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. MD026169           Date 09Apr14               *
      *                 MD025679B          Date 26Mar14               *
      *                 MD025679A          Date 21Mar14               *
      *                 MD025679  *CREATE  Date 15Mar14               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  MD026169 - GO_ONL_OLP background job is processing           *
      *             full receiver chain                               *
      *  MD025679B - API - PRONO Locking Issue                        *
      *  MD025679A - Added copyright to program                       *
      *  MD025679 - Optimized code was of AOOLPSU0.                   *
      *           - API - OLPOSOA Locking Issue.                      *
      *                                                               *
      *****************************************************************
     FOLPOS     UF A E           K DISK    INFSR(*PSSR)
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
      *
      ** Array of DLYJOB command to edit
      *
     D EDT             S              1    DIM(80)
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
      *
      ** Read Olpos record for update
      *
     C     @OLPKY        CHAIN     OLPOSOAF                           90
      *
      ** Only report database error if record found but deleted
      *
     C     *IN90         IFEQ      '0'
     C     RECI          ANDNE     'D'
     C                   EVAL      pRtnCode = '*ERROR'
     C                   MOVEL     'OLPOSO1 '    DBFILE
     C                   MOVEL     W0KEY#        DBKEY
     C                   Z-ADD     002           DBASE
     C                   EXSR      *PSSR
     C                   END
      *
      ** Exit if record not found as currency input today
      *
     C     *IN90         CABEQ     '1'           EXOLPS
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
      *
     C     EXOLPS        TAG
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
     C                   MOVEL     '*CALL  '     DBFILE
     C                   MOVEL     'QCMDEXC'     DBKEY
     C                   Z-ADD     001           DBASE
     C                   EXSR      *PSSR
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
      *
     C                   ENDSR
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
OVRDBF     FILE(XXXXXXXXXX) SHARE(*NO) SECURE(*YES)
