     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2022')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas GL Extract Batches from APOUTPUTPD')             *
      *****************************************************************
      *                                                               *
      *  Midas - General Ledger Module                                *
      *                                                               *
      *  GL998002 - Extract Batches from APOUTPUTPD                   *
      *                                                               *
      *  (c) Finastra International Limited 2022                      *
      *                                                               *
      *  Last Amend No. MD059435 *CREATE   Date 16Feb22               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD059435 - STP Batch entered Midas as held with an error     *
      *             in the header record                              *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *    99         Look Front Office ID                            *
      *    99         Chain indicator for GLBTCSL0                    *
      *    LR         End of program                                  *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      * UPD_BNUM   - Update Batch Number                              *
      * WRT_GLBTCS - Write to GLBTCSD0                                *
      * *PSSR      - Error processing                                 *
      * *INZSR     - Initialise                                       *
      *                                                               *
      *    The *INZSR subroutine will only get called automatically   *
      *    on entry to the module the first time it is run            *
      *    (unless you end the program with LR on).  Similarly        *
      *    D-spec initialisation only happens the first time.  Use    *
      *    RESET for subsequent passes.                               *
      *                                                               *
      *****************************************************************
     FGLCLOBPD  IP   E             DISK    INFSR(*PSSR)
     FGLBTCSL0  IF A E           K DISK    INFSR(*PSSR)
     FGLBTCHPD  O    E             DISK    INFSR(*PSSR)
     FGLBTCPPD  O    E             DISK    INFSR(*PSSR) PREFIX(X)
     D BNUM            S              3S 0 DIM(999)
     D INUM            S              3S 0 DIM(999)
     D FOID            S             20A   DIM(999)
     D STAT            S              1A   DIM(999)
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
     D DSFDY         E DS                  EXTNAME(DSFDY)
     D GLBTCH        E DS                  EXTNAME(GLBTCHPD)
     D GLBTCP        E DS                  EXTNAME(GLBTCPPD) PREFIX(X)
      *********************************************************************
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
      *********************************************************************
      * MAIN PROCEDURE                                                    *
      *********************************************************************
     C     *ENTRY        PLIST
     C                   PARM                    I#RTCD            7
     C                   PARM                    I#FOID           20
      *
     C                   MOVEL     *blank        DDFOID           20
      *
     C                   IF        I#FOID <> *blank AND
     C                             %Subst(CLOBDT:257:20) = I#FOID
     C                             OR I#FOID = *blank
      *
     C                   EVAL      W#TYPE = %Subst(CLOBDT:1:6)
      *
     C                   SELECT
      *
     C                   WHEN      W#TYPE = 'GLBITH'
     C                   EVAL      GLBTCH = %Subst(CLOBDT:319:96)
     C                   EVAL      DDFOID = %Subst(CLOBDT:257:20)
     C                   EXSR      UPD_BNUM
     C                   IF        STAT(#Y) <> 'F' and  STAT(#Y) <> 'P'
     C                   MOVEL     BNUM(#Y)      DDBTNB
     C                   WRITE     GLBTCHD0
     C                   ENDIF
      *
     C                   WHEN      W#TYPE = 'GLBITP'
     C                   EVAL      GLBTCP = %Subst(CLOBDT:319:228)
     C                   EVAL      DDFOID = %Subst(CLOBDT:257:20)
     C                   EXSR      UPD_BNUM
     C                   IF        STAT(#Y) <> 'F' and  STAT(#Y) <> 'P'
     C                   MOVEL     BNUM(#Y)      XDDBTNB
     C                   MOVEL     INUM(#Y)      XDDBINB
     C                   WRITE     GLBTCPD0
     C                   ENDIF
      *
     C                   ENDSL
      *
     C                   ENDIF
     CLR                 EXSR      WRT_GLBTCS
      *****************************************************************
      *                                                               *
      * UPD_BNUM - Update Batch Number                                *
      *                                                               *
      *****************************************************************
     C     UPD_BNUM      BEGSR
     C                   Z-ADD     1             #Y                3 0
      *
      ** Add new batch front office IDs
      *
     C     DDFOID        LOOKUP    FOID(#Y)                               98
      *
      ** Front office ID not found
      *
     C                   IF        *IN98 = *OFF
     C                   ADD       1             #X                3 0
     C                   EVAL      BNUM(#X) = #X
     C                   EVAL      FOID(#X) = DDFOID
     C     GLBTCSK       CHAIN     GLBTCSD0                           99
     C  N99              EVAL      STAT(#X) = STATUS
     C                   EVAL      #Y = #X
     C                   ENDIF
      *
      ** Increment batch items number
      *
     C                   IF        W#TYPE = 'GLBITP'
     C                   EVAL      INUM(#Y) += 1
     C                   ENDIF
     C                   ENDSR
      *****************************************************************
      *                                                               *
      *  WRT_GLBTCS - Write to GLBTCSD0                               *
      *                                                               *
      *****************************************************************
     C     WRT_GLBTCS    BEGSR
      *
     C                   Z-ADD     1             #X
     C                   DOW       FOID(#X) <> *blank
     C                   MOVEL     FOID(#X)      DDFOID
      *
     C     GLBTCSK       CHAIN     GLBTCSD0                           99
     C                   IF        *IN99 = *ON
     C                   EVAL      STATUS = *blank
     C                   EVAL      NUMVLIT = *zero
     C                   EVAL      EXTHIIN = *zero
     C                   EVAL      EXTHDIN = *zero
     C                   EVAL      EXTHINI = *zero
     C                   CALLB     'ZAGENTMSTM'
     C                   PARM                    EXTTMST
     C                   EVAL      COMTMST = EXTTMST
     C                   EVAL      MIBHUPD = *blank
     C                   WRITE     GLBTCSD0
     C                   ENDIF
      *
     C                   ADD       1             #X
     C                   ENDDO
      *
     C                   ENDSR
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
      *
     C                   CALL      'AOBANKR0'
     C                   PARM      '*DBERR '     @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
      *
      ** Key lists
      *
     C     GLBTCSK       KLIST
     C                   KFLD                    BJMRDT
     C                   KFLD                    DDFOID
      *
     C                   MOVEL     ' '           W#TYPE            6
     C                   MOVEL     ' '           W#RUN             1
      *
     C                   ENDSR
      *****************************************************************
      *                                                               *
      * *PSSR  - Program exception error routine                      *
      *          Called automatically if a program error occurs,      *
      *          or directly by the program code using EXSR.          *
      *          This subroutine DUMPs the program just once.         *
      *                                                               *
      * Called by: (**calling routines**)                             *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     *PSSR         BEGSR
      *
     C                   IF        W#RUN = *blank
     C                   EVAL      W#RUN = 'Y'
     C                   DUMP
     C                   EVAL      I#RTCD = '*ERROR*'
     C                   ENDIF
      *
     C                   SETON                                        LR
     C                   RETURN
      *
     C                   ENDSR
      *****************************************************************
