     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2010')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  DBGVIEW(*LIST)                                               *
/*EXI *  TEXT('Midas SM Populate daily RCF files')                    *
      *****************************************************************
      *                                                               *
      *  Midas - Implementation Module                                *
      *                                                               *
      *  SM000000 - Populate daily RCF files                          *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2010            *
      *                                                               *
      *  Last Amend No. CUP003  *CREATE    Date 21Sep10               *
      *  Prev Amend No. xxxxxx             Date ddMmmyy               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CUP003 - Enhancement to update FCRREQPD and FCPARDPD.        *
      *                                                               *
      *****************************************************************
     FFCRREQPD  UF A E             DISK    INFSR(*PSSR)
     FFCPARDPD  UF A E             DISK    INFSR(*PSSR)
     FFCPREQPD  IF   E             DISK    INFSR(*PSSR)
     FFCPARPL0  IF   E           K DISK    INFSR(*PSSR)
     FMUSER     IF   E           K DISK    INFSR(*PSSR)
      *
     D RptName         S             10
     D RptSeq          S              2
     D Recursive       S              1    INZ('N')
      *
     D                 DS
     D  SeqNoN                 1      5  0 INZ(1)
     D  SeqNoA                 1      5
      *
     C     NameAndSeq    KLIST
     C                   KFLD                    RptName
     C                   KFLD                    RptSeq
      *
      * Start to read the periodic requests file.
     C     1             SETLL     FCPREQPD
     C                   READ      FCPREQPD
      *
     C                   DOW       NOT(%EOF)
      *
      * Set up fields for FCRREQPD.
     C                   EVAL      D5RNAM = D9RNAM
     C                   EVAL      D5RQSQ = SeqNoA
     C                   EVAL      D5SOID = D9SOID
     C                   EVAL      D5LVL  = D9LVL
     C                   EVAL      D5ETTY = D9ETTY
     C                   EVAL      D5IPCY = 'N'
     C                   EVAL      D5PDFL = 'Y'
     C                   EVAL      D5DLS1 = D9DLS1
     C                   EVAL      D5DLS2 = D9DLS2
     C                   EVAL      D5USRO = D9USRO
     C                   EVAL      D5ARMF = D9ARMF
     C                   EVAL      D5AROD = D9AROD
     C                   EVAL      D5DRQD = D9DRQD
     C                   EVAL      D5USRR = D9USRR
      * Get user information.
     C                   EXSR      ChkUser
     C                   EVAL      D5RQTM = 0
     C                   EVAL      D5COBR = 'N'
     C                   EVAL      D5JBNM = *blanks
     C                   EVAL      D5JUSR = *blanks
     C                   EVAL      D5JBNB = *blanks
     C                   EVAL      D5PSQR = D9PSQN
     C                   EVAL      D5COTT = D9COTT
     C                   EVAL      D5CSEQ = D9CSEQ
     C                   EVAL      D5TNLU = D9TNLU
     C                   WRITE     FCRREQD0
      *
     C                   EXSR      UpdFCPARD
      *
     C                   EVAL      SeqNoN = SeqNoN + 1
     C                   READ      FCPREQPD
     C                   ENDDO
      *
     C                   EVAL      *INLR = *ON
     C                   RETURN
      /EJECT
      *****************************************************************
      *                                                               *
      *  UpdFCPARD - Update FCPARDPD with parameters from FCPARPPD    *
      *                                                               *
      *****************************************************************
      *
     C     UpdFCPARD     BEGSR
      *
     C                   EVAL      RptName = D9RNAM
     C                   EVAL      RptSeq  = D9PSQN
      *
     C     NameAndSeq    CHAIN     FCPARPL0
     C                   IF        %FOUND
     C                   EVAL      D7RNAM = D8RNAM
     C                   EVAL      D7RQSQ = SeqNoA
     C                   EVAL      D7PARM = D8PARM
     C                   WRITE     FCPARDD0
     C                   ENDIF
      *
     C     UpdFCPARDE    ENDSR
      *
      /EJECT
      *****************************************************************
      *                                                               *
      *  ChkUser - Find information about user.                       *
      *                                                               *
      *****************************************************************
      *
     C     ChkUser       BEGSR
      *
     C     D5USRR        CHAIN     MUSER
     C                   IF        %FOUND
     C                   EVAL      D5DBRN = DBRN
     C                   ENDIF
      *
     C     ChkUserE      ENDSR
      *
      /EJECT
      *****************************************************************
      *                                                               *
      *  *PSSR  - Program Exception Error Routine                     *
      *                                                               *
      *****************************************************************
      *
     C     *PSSR         BEGSR
      *
     C                   IF        Recursive = *blanks
     C                   EVAL      Recursive = 'Y'
     C                   DUMP
      *
     C                   ENDIF
      *
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN
      *
     C     PSSRE         ENDSR
      *
      *****************************************************************
