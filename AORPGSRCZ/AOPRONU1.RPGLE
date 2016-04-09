     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2014')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas AO Background update of PRONO')                  *
      *****************************************************************
      *                                                               *
      *  Midas - Access Objects Module                                *
      *                                                               *
      *  AOPRONU1 - Update Prono file                                 *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2014            *
      *                                                               *
      *  Last Amend No. MD031382           Date 11Dec14               *
      *  Prev Amend No. MD026169  *REWRITE Date 09Apr14               *
      *                 MD025679B          Date 26Mar14               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD031382  - Amount is reflected on the Projected Mov. Column *
      *              (Recompile)                                      *
      *  MD026169 - GO_ONL_OLP background job is processing           *
      *             full receiver chain                               *
      *  MD025679B - Optimized code was of AOOLPSU0.                  *
      *            - API - PRONO Locking Issue.                       *
      *                                                               *
     F*****************************************************************
     FPRONO     UF   E           K DISK    COMMIT
     F                                     USROPN
     F                                     IGNORE(PRONOHHF)
     F                                     INFSR(*PSSR)
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
 
      ** Entry parameters
 
     D pRtnCode        S              7A
     D pEntData        S                   LIKE( tpPRONO )
 
      ** SZDATE parameters
 
     D ZDAYNO          S              5P 0 INZ
     D ZCCY            S              3A   INZ
     D #LOC            S              3A   INZ
     D ZNRDYS          S              2P 0 INZ
     D ZDYNBR          S              5P 0 INZ
 
      ** Variables for OVRDBF
     D CmdString       S             80A   INZ
     D CmdLen          S             15P 5 INZ
 
      ** Work array holding projected nostro dates
     D NOSDT           S              5  0 INZ DIM(6) ASCEND
     D Ix              S              3U 0 INZ
     D Iy              S              3U 0 INZ
 
     D W0DS            DS                  INZ
     D  W0KEY#                             LIKE( tpPRONO.PRKEY )
     D   W0CCY                             LIKE( CCY  ) OVERLAY( W0KEY# )
     D   W0NOSN                       2S 0 OVERLAY( W0KEY# : *NEXT)
     D  W0VDAT                             LIKE( tpPRONO.PRVDAT )
     D  W0AMT                              LIKE( tpPRONO.PRAMT )
 
      ** Data structure used to divide projected nostro balances field
      ** into subfields representing daily balances
 
     D PNB             DS
     D  PBAL                   1     40P 0 INZ
     D                                     DIM(5)
 
      ** Data structure used to separate dates received from LF/PRONO
      ** into separate fields
 
     D PND             DS
     D  PDAT                   1     15P 0 INZ
     D                                     DIM(5) ASCEND
 
      ** Templates
 
     D tpPRONO       E DS                  TEMPLATE QUALIFIED
     D                                     EXTNAME( GLPRONTD )
 
      *****************************************************************
      /EJECT
      *****************************************************************
      * MAIN - Main body                                              *
      *****************************************************************
 
      ** Update Prono file with passed data
 
     C                   EVAL      W0DS = pEntData
     C                   EXSR      SRPRON
 
     C                   RETURN
     C/EJECT
      *****************************************************************
      *                                                               *
      *  SRPRON   : Update Prono file                                 *
      *                                                               *
      *****************************************************************
     C     SRPRON        BEGSR
      *
      ** Read Prono record for update
      *
     C     PRONKY        CHAIN     PRONO
     C                   IF        %FOUND( PRONO ) AND RECI <> 'D'
     C                   EVAL      pRtnCode = '*ERROR'
     C                   EVAL      DBFILE = 'PRONOPN'
     C                   EVAL      DBKEY = W0KEY#
     C                   EVAL      DBASE = 2
     C                   EXSR      *PSSR
     C                   END
      *
      ** If currency change then create new dates array
      *
     C     W0CCY         IFNE      W0CCYS
     C                   EXSR      SRDATE
     C                   MOVEL     W0CCY         W0CCYS            3
     C                   END
      *
      ** Now update projected nostro balances first set up counter
      ** determining which of nostro balances to be updated; then loop
      ** through array of nostro balances adding amount
      ** to existing nostro balances.
      **  -- Note: code originally from FX0390
 
      ** If event date <= first date in PDAT then all elements of PBAL
      ** are to be updated
 
     C                   EVAL      Ix = 1
 
      ** If event date between any two dates in NOSDT then previous
      ** amount and all subsequent amounts on PBAL are updated.
 
     C                   IF            W0VDAT > NOSDT(1)
     C                             AND W0VDAT < NOSDT(6)
     C     W0VDAT        LOOKUP    NOSDT(Ix)                            6061
     C                   IF        *IN60
     C                   EVAL      Ix = Ix + 1
     C                   ENDIF
     C                   ENDIF
 
      ** If date greater than or equal to last date in array PDAT then
      ** no nostro balances to be updated.
 
     C                   IF        W0VDAT >= NOSDT(6)
     C                   LEAVESR
     C                   ENDIF
 
      ** Update nostro balances
 
     C                   FOR       Iy = Ix to 5
     C                   ADD       W0AMT         PBAL(Iy)
     C                   ENDFOR
 
     C                   EXCEPT    UPDPRN
 
     C                   ENDSR
     C/EJECT
      *****************************************************************
      *                                                               *
      *  SRDATE   : Set up dates for Nostro update                    *
      *                                                               *
      *****************************************************************
     C     SRDATE        BEGSR
 
      ** Move array from file to NOSDT
 
     C                   FOR       Ix = 1 to 5
     C                   Z-ADD     PDAT(Ix)      NOSDT(Ix)
     C                   ENDFOR
      *
      ** Set up sixth element of date array. This element is the next
      ** working day in the currency after the last element of PDAT
      *
     C                   CALL(E)   'SZDATE3'
     C                   PARM      PDAT(5)       ZDAYNO            5 0
     C                   PARM      W0CCY         ZCCY              3
     C                   PARM      *BLANKS       #LOC              3
     C                   PARM      1             ZNRDYS            2 0
     C     NOSDT(6)      PARM                    ZDYNBR            5 0
      *
     C                   IF        %ERROR
     C                   EVAL      pRtnCode = '*ERROR'
     C                   EVAL      DBFILE = 'SZDATE3'
     C                   EVAL      DBKEY = '*CALL'
     C                   EVAL      DBASE = 3
     C                   EXSR      *PSSR
     C                   END
 
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      *                                                               *
      *  *INZSR - Initialise and define fields                        *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR
 
      ** Define entry parameters
 
     C     *ENTRY        PLIST
     C                   PARM                    pRtnCode
     C                   PARM                    pEntData
 
      ** Set up key list to PRONOPNF
 
     C     PRONKY        KLIST
     C                   KFLD                    W0CCY
     C                   KFLD                    W0NOSN
 
      ** Override file PRONO to share(*NO)
 
     C                   EVAL      CmdString = 'OVRDBF FILE(PRONO) +
     C                                          SHARE(*NO) SECURE(*YES)'
     C                   EVAL      CmdLen = %LEN( CmdString )
 
     C                   CALL(E)   'QCMDEXC'
     C                   PARM                    CmdString
     C                   PARM                    CmdLen
 
     C                   IF        %ERROR
     C                   EVAL      pRtnCode = '*ERROR'
     C                   EVAL      DBFILE = '*CALL'
     C                   EVAL      DBKEY = 'QCMDEXC'
     C                   EVAL      DBASE = 1
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Open Prono file for update
 
     C                   IF        NOT %OPEN(PRONO)
     C                   OPEN      PRONO
     C                   ENDIF
 
     C                   ENDSR
      ************************************************************
      /EJECT
      ************************************************************
      *                                                          *
      * *PSSR - Called whenever error occurs                     *
      *                                                          *
      ************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      ************************************************************
      /EJECT
      ************************************************************
     OPRONOPNF  E            UPDPRN
     O                       PNB
      ************************************************************
** CPY@
(c) Misys International Banking Systems Ltd. 2014
