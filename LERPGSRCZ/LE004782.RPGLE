     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2013')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas LE Populate Loans PDCL History File')            *
      *****************************************************************
      *                                                               *
      *  Midas - Customer Lending Module                              *
      *                                                               *
      *  LE004782 - Midas LE Populate Loans PDCL History File         *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2013            *
      *                                                               *
      *  Last Amend No. AR1097467A *CREATE Date 11Apr13               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  AR1097467A - Expected 15% COB run optimization not met       *
      *                                                               *
      *****************************************************************
      /SPACE
      *****************************************************************
     FLEPDUEL9  IF   E           K DISK    INFSR(*PSSR)
     FCLOAN     IF   E           K DISK    INFSR(*PSSR) PREFIX(P_)
     F                                     RENAME(CLOANCLF:CLOANF)
     F                                     IGNORE(CLOANHHF)
     F                                     IGNORE(CLOANCKF)
     F                                     IGNORE(CLOANZ1F)
     FHISTSL0   IF   E           K DISK    INFSR(*PSSR) PREFIX(H_)
     F                                     IGNORE(HISTSHMF)
     F                                     IGNORE(HISTSHQF)
     FLEPDLHL1  IF   E           K DISK    INFSR(*PSSR) PREFIX(T_)
     F                                     RENAME(LEPDLHD0:LEPDLHL1F)
     FLEPDLHPD  UF A E           K DISK    INFSR(*PSSR) PREFIX(D_)
 
      ** Work Variables
 
     D Recursive       S              1A
 
     D DSPVDVDT        S                   INZ LIKE(H_VDAT)
     D DSPDCLREF       S              6    INZ
     D DSPDSDT         S                   INZ LIKE(T_YPDVDT)
     D DSYPDVDT        S                   INZ LIKE(T_YPDVDT)
 
     D KP_LNRF         S                   LIKE(P_LNRF)
 
     D KH_LNRF         S                   LIKE(H_LNRF)
     D KH_VDAT         S                   LIKE(H_VDAT)
 
     D KT_YPRECI       S                   LIKE(T_YPRECI)
 
      ** PDCL Loan Key Details
     D DSPDUE_K        DS
     D  YPORG
     D  YBRCA
 
     D DSPDUE_KS       DS                  INZ LIKEDS(DSPDUE_K)
 
      ** Loan PDCL History Key Details (LEPDLHL1)
     D DSPDLH_K        DS
     D  T_YPORG
 
     D DSPDLH_KS       DS                  INZ LIKEDS(DSPDLH_K)
 
     D/COPY ZACPYSRC,PSDS
      ** External Definitions
 
     D LDA           E DS           256    EXTNAME(LDA) DTAARA(LDA)
      ** Local Data Area for Error Log
 
      *****************************************************************
      /EJECT
      *****************************************************************
      * Main Processing                                               *
      *****************************************************************
 
      ** Populate Loans PDCL History File
      ** - Generate historical events for each PDCL for the Origin Loan
      **   Repayment Value Date
 
     C     *LOVAL        SETLL     LEPDUEL9
     C                   READ(E)   LEPDUEL9
 
     C                   DOW       NOT %EOF(LEPDUEL9)
     C                   EVAL      D_YPRECI    = 'D'
     C                   EVAL      D_YPORG     = YPORG
     C                   EVAL      D_YPLON     = YPLON
     C                   EVAL      D_YPDVDT    = YPDVDT
     C                   EVAL      D_YPCPAM    = YPCPAM
     C                   EVAL      D_YPDINT    = YPDINT
     C                   EVAL      D_YPMOVA    = 0
 
     C                   IF        DSPDUE_KS  <> DSPDUE_K
     C                   EVAL      DSPDUE_KS   = DSPDUE_K
     C                   EVAL      DSPDCLREF   = *BLANKS
     C                   ENDIF
 
      ** Accumulate Remaining Events for Repayment Value Date
 
     C                   READ(E)   LEPDUEL9
 
     C                   DOW       NOT %EOF(LEPDUEL9)          AND
     C                             D_YPORG     = YPORG         AND
     C                             D_YPLON     = YPLON         AND
     C                             D_YPDVDT    = YPDVDT
 
     C                   EVAL      D_YPCPAM   += YPCPAM
     C                   EVAL      D_YPDINT   += YPDINT
 
     C                   READ(E)   LEPDUEL9
     C                   ENDDO
 
     C                   EVAL      DSPVDVDT    = YPDVDT
 
      ** Evaluate Opening/Closing Balance
 
     C                   EXSR      XEVDOPNBAL
 
      ** Write Balance Record & Set Variables for Next Cycle
 
     C                   WRITE(E)  LEPDLHD0
 
     C                   EVAL      D_YPCLOB    = D_YPOPNB
     C                   ENDDO
 
      ** - Generate historical Total events for each Origin Loan on
      ** Repayment Value Date
 
     C                   EVAL      D_YPOPNB    = 0
     C                   EVAL      D_YPMOVA    = 0
     C                   EVAL      D_YPCLOB    = 0
     C                   EVAL      DSPDSDT     = 0
 
     C                   EVAL      KT_YPRECI   = 'D'
     C     KLEPDLHL1B    SETLL     LEPDLHL1
     C     KLEPDLHL1B    READE(E)  LEPDLHL1
     C                   EVAL      DSPDLH_KS   = DSPDLH_K
     C                   CLEAR                   LEPDLHD0
 
     C                   DOW       NOT %EOF(LEPDLHL1)
     C                   EVAL      D_YPRECI    = 'T'
     C                   EVAL      D_YPORG     = T_YPORG
     C                   EVAL      D_YPDVDT    = T_YPDVDT
     C                   EVAL      D_YPOPNB   += T_YPOPNB
     C                   EVAL      D_YPMOVA   += T_YPMOVA
     C                   EVAL      D_YPCLOB   += T_YPCLOB
 
     C                   IF        D_YPOPNB   <= 0             AND
     C                             D_YPCLOB    > 0             OR
     C                             D_YPOPNB    > 0             AND
     C                             DSPDSDT     = 0
     C                   EVAL      DSPDSDT     = T_YPDVDT
 
     C                   ELSE
     C                   IF        D_YPOPNB   <= 0             AND
     C                             D_YPCLOB   <= 0
     C                   EVAL      DSPDSDT     = 0
     C                   ENDIF
     C                   ENDIF
 
     C                   EVAL      D_YPDSDT    = DSPDSDT
 
     C     KLEPDLHL1B    READE(E)  LEPDLHL1
 
     C                   IF        DSPDLH_KS  <> DSPDLH_K      OR
     C                             DSYPDVDT   <> T_YPDVDT      OR
     C                             %EOF(LEPDLHL1)
 
     C                   WRITE(E)  LEPDLHD0
 
     C                   IF        DSPDLH_KS  <> DSPDLH_K
     C                   EVAL      DSPDLH_KS   = DSPDLH_K
     C                   EVAL      DSPDSDT     = 0
     C                   ENDIF
 
     C                   EVAL      DSYPDVDT    = T_YPDVDT
     C                   CLEAR                   LEPDLHD0
     C                   ENDIF
     C                   ENDDO
 
     C                   EVAL      *INLR = *ON
     C                   RETURN
 
      *****************************************************************
      /EJECT
      *****************************************************************
      * XEVDOPNBAL - Evaluate Value Date Opening Balance              *
      *****************************************************************
     C     XEVDOPNBAL    BEGSR
 
      ** Set Opening/Closing Balance
 
     C                   IF        DSPDCLREF  <> D_YPLON
     C                   EVAL      DSPDCLREF   = D_YPLON
     C                   EVAL      D_YPOPNB    = 0
     C                   EVAL      D_YPCLOB    = 0
 
     C                   EVAL      KP_LNRF     = D_YPLON
     C     KCLOAN        CHAIN(E)  CLOAN
 
     C                   IF        %FOUND(CLOAN)
     C                   EVAL      D_YPOPNB    = P_CPAM
     C                   EVAL      D_YPCLOB    = P_CPAM
     C                   ENDIF
     C                   ENDIF
 
      ** Adjust Opening Balance
 
     C                   EVAL      KH_LNRF     = D_YPLON
     C                   EVAL      KH_VDAT     = D_YPDVDT
     C     KHISTSL0      SETGT     HISTSL0
     C     KHISTSL0A     READPE(E) HISTSL0
 
     C                   DOW       NOT %EOF(HISTSL0)           AND
     C                             H_VDAT      > DSPVDVDT
 
     C                   IF        H_AMTP      = 'MR'          OR
     C                             H_AMTP      = 'MA'          OR
     C                             H_AMTP      = 'PF'          OR
     C                             H_AMTP      = 'RE'
     C                   EVAL      D_YPMOVA   -= H_PRAM
     C                   EVAL      D_YPOPNB   += H_PRAM
 
     C                   ELSE
     C                   EVAL      D_YPMOVA   += H_PRAM
     C                   EVAL      D_YPOPNB   -= H_PRAM
     C                   ENDIF
 
     C     KHISTSL0A     READPE(E) HISTSL0
     C                   ENDDO
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *  *INZSR - Initialisation Routine                              *
      *****************************************************************
     C     *INZSR        BEGSR
 
      ** Key List
 
     C     KCLOAN        KLIST
     C                   KFLD                    KP_LNRF
 
     C     KHISTSL0      KLIST
     C                   KFLD                    KH_LNRF
     C                   KFLD                    KH_VDAT
 
     C     KHISTSL0A     KLIST
     C                   KFLD                    KH_LNRF
 
     C     KLEPDLHL1B    KLIST
     C                   KFLD                    KT_YPRECI
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *PSSR  - Program exception error routine                      *
      *                                                               *
      *****************************************************************
     C     *PSSR         BEGSR
 
     C                   IF        Recursive = *BLANK
     C                   EVAL      Recursive = 'Y'
     C                   DUMP
     C                   ENDIF
 
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN
 
     C                   ENDSR
