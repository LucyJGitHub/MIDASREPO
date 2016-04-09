     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2013')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas LE Populate Fees PDCL History File')             *
      *****************************************************************
      *                                                               *
      *  Midas - Customer Lending Module                              *
      *                                                               *
      *  LE004783 - Midas LE Populate Fees PDCL History File          *
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
     FLEPDUFL9  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(LEPDUFD0:LEPDUFL9F)
     FCLOAN     IF   E           K DISK    INFSR(*PSSR) PREFIX(P_)
     F                                     RENAME(CLOANCLF:CLOANF)
     F                                     IGNORE(CLOANHHF)
     F                                     IGNORE(CLOANCKF)
     F                                     IGNORE(CLOANZ1F)
     FHISTSL0   IF   E           K DISK    INFSR(*PSSR) PREFIX(H_)
     F                                     IGNORE(HISTSHMF)
     F                                     IGNORE(HISTSHQF)
     FLEPDFHL1  IF   E           K DISK    INFSR(*PSSR) PREFIX(T_)
     F                                     RENAME(LEPDFHD0:LEPDFHL1F)
     FLEPDFHPD  UF A E           K DISK    INFSR(*PSSR) PREFIX(D_)
 
      ** Work Variables
 
     D Recursive       S              1A
 
     D DSPVDVDT        S                   INZ LIKE(H_VDAT)
     D DSPDCLREF       S              6    INZ
     D DSPDSDT         S                   INZ LIKE(T_YPDVDT2)
     D DSYPDVDT        S                   INZ LIKE(T_YPDVDT2)
 
     D KP_LNRF         S                   LIKE(P_LNRF)
 
     D KH_LNRF         S                   LIKE(H_LNRF)
     D KH_VDAT         S                   LIKE(H_VDAT)
 
     D KT_YPRECI       S                   LIKE(T_YPRECI)
 
      ** PDCL Fee Key Details
     D DSPDUF_K        DS
     D  YECNUM
     D  YEFACL
     D  YESEQ
     D  YPORG2
     D  YBRCA2
 
     D DSPDUF_KS       DS                  INZ LIKEDS(DSPDUF_K)
 
      ** Fee PDCL History Key Details (LEPDFHL1)
     D DSPDFH_K        DS
     D  T_YECNUM
     D  T_YEFACL
     D  T_YESEQ
     D  T_YPORG2
     D  T_YBRCA2
 
     D DSPDFH_KS       DS                  INZ LIKEDS(DSPDFH_K)
 
     D/COPY ZACPYSRC,PSDS
      ** External Definitions
 
     D LDA           E DS           256    EXTNAME(LDA) DTAARA(LDA)
      ** Local Data Area for Error Log
 
     ILEPDUFL9F
     I              YPORG                       YPORG2
     I              YBRCA                       YBRCA2
 
     ILEPDFHL1F
     I              YPORG                       T_YPORG2
     I              YBRCA                       T_YBRCA2
     I              YPDVDT                      T_YPDVDT2
 
      *****************************************************************
      /EJECT
      *****************************************************************
      * Main Processing                                               *
      *****************************************************************
 
      ** Populate Fees PDCL History File
      ** - Generate historical events for each PDCL for the Origin Fee
      ** Repayment Value Date
 
     C     *LOVAL        SETLL     LEPDUFL9
     C                   READ(E)   LEPDUFL9
 
     C                   DOW       NOT %EOF(LEPDUFL9)
     C                   EVAL      D_YPRECI    = 'D'
     C                   EVAL      D_YECNUM    = YECNUM
     C                   EVAL      D_YEFACL    = YEFACL
     C                   EVAL      D_YESEQ     = YESEQ
     C                   EVAL      D_YPORG     = YPORG2
     C                   EVAL      D_YBRCA     = YBRCA2
     C                   EVAL      D_YPLON     = YPLON
     C                   EVAL      D_YPDVDT    = YPDVDT
 
     C                   EVAL      D_YPCPAM    = YPCPAM
     C                   EVAL      D_YPDINT    = 0
     C                   EVAL      D_YPMOVA    = 0
 
     C                   IF        DSPDUF_KS  <> DSPDUF_K
     C                   EVAL      DSPDUF_KS   = DSPDUF_K
     C                   EVAL      DSPDCLREF   = *BLANKS
     C                   ENDIF
 
      ** Accumulate Remaining Events for Repayment Value Date
 
     C                   READ(E)   LEPDUFL9
 
     C                   DOW       NOT %EOF(LEPDUFL9)          AND
     C                             D_YECNUM    = YECNUM        AND
     C                             D_YEFACL    = YEFACL        AND
     C                             D_YESEQ     = YESEQ         AND
     C                             D_YPORG     = YPORG2        AND
     C                             D_YBRCA     = YBRCA2        AND
     C                             D_YPLON     = YPLON         AND
     C                             D_YPDVDT    = YPDVDT
 
     C                   EVAL      D_YPCPAM   += YPCPAM
     C                   EVAL      D_YPDINT   += 0
 
     C                   READ(E)   LEPDUFL9
     C                   ENDDO
 
     C                   EVAL      DSPVDVDT    = YPDVDT
 
      ** Evaluate Opening/Closing Balance
 
     C                   EXSR      XEVDOPNBAL
 
      ** Write Balance Record & Set Variables for Next Cycle
 
     C                   WRITE(E)  LEPDFHD0
 
     C                   EVAL      D_YPCLOB    = D_YPOPNB
     C                   ENDDO
 
      ** Generate historical Total events for each Origin Fee on
      ** Repayment Value Date
 
     C                   EVAL      D_YPOPNB    = 0
     C                   EVAL      D_YPMOVA    = 0
     C                   EVAL      D_YPCLOB    = 0
     C                   EVAL      DSPDSDT     = 0
 
     C                   EVAL      KT_YPRECI   = 'D'
     C     KLEPDFHL1B    SETLL     LEPDFHL1
     C     KLEPDFHL1B    READE(E)  LEPDFHL1
     C                   EVAL      DSPDFH_KS   = DSPDFH_K
     C                   CLEAR                   LEPDFHD0
 
     C                   DOW       NOT %EOF(LEPDFHL1)
     C                   EVAL      D_YPRECI    = 'T'
     C                   EVAL      D_YECNUM    = T_YECNUM
     C                   EVAL      D_YEFACL    = T_YEFACL
     C                   EVAL      D_YESEQ     = T_YESEQ
     C                   EVAL      D_YPORG     = T_YPORG2
     C                   EVAL      D_YBRCA     = T_YBRCA2
     C                   EVAL      D_YPLON     = T_YPLON
     C                   EVAL      D_YPDVDT    = T_YPDVDT2
 
     C                   EVAL      D_YPOPNB   += T_YPOPNB
     C                   EVAL      D_YPMOVA   += T_YPMOVA
     C                   EVAL      D_YPCLOB   += T_YPCLOB
 
     C                   IF        D_YPOPNB   <= 0             AND
     C                             D_YPCLOB    > 0             OR
     C                             D_YPOPNB    > 0             AND
     C                             DSPDSDT     = 0
     C                   EVAL      DSPDSDT     = T_YPDVDT2
 
     C                   ELSE
     C                   IF        D_YPOPNB   <= 0             AND
     C                             D_YPCLOB   <= 0
     C                   EVAL      DSPDSDT     = 0
     C                   ENDIF
     C                   ENDIF
 
     C                   EVAL      D_YPDSDT    = DSPDSDT
 
     C     KLEPDFHL1B    READE(E)  LEPDFHL1
 
     C                   IF        DSPDFH_KS  <> DSPDFH_K      OR
     C                             DSYPDVDT   <> T_YPDVDT2     OR
     C                             %EOF(LEPDFHL1)
 
     C                   WRITE(E)  LEPDFHD0
 
     C                   IF        DSPDFH_KS  <> DSPDFH_K
     C                   EVAL      DSPDFH_KS   = DSPDFH_K
     C                   EVAL      DSPDSDT     = 0
     C                   ENDIF
 
     C                   EVAL      DSYPDVDT    = T_YPDVDT2
     C                   CLEAR                   LEPDFHD0
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
 
     C     KLEPDFHL1B    KLIST
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
