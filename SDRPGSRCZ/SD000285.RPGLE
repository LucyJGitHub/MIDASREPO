     H DEBUG
     H COPYRIGHT('(C) Finastra International Limited 2012')
      *****************************************************************
/*STD *  RPGBASEBNC                                                   *
/*EXI *  TEXT('Midas SD Past Due Loan Type/Subtype List')             *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SD000285 - Past Due Loan Type/Subtype List                   *
      *                                                               *
      *  (c) Finastra International Limited 2012                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CLE134  *CREATE    Date 01Aug12               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CLE134 - Past Due Call Loan Processing                       *
      *                                                               *
      *****************************************************************
 
     FSDLOANL0  IF   E           K DISK
 
     FSDLOANL5  IF   E           K DISK    RENAME(SDLOAND0: SDLOANL5F)
     F                                     PREFIX(M_)
 
     FSDLOANL6  IF   E           K DISK    RENAME(SDLOAND0: SDLOANL6F)
     F                                     PREFIX(M_)
 
     FSD000285P1O    E             PRINTER INFDS(SPOOL1)
     F                                     OFLIND(P1OVERFLOW)
 
      *****************************************************************
     D/COPY ZACPYSRC,STD_D_SPEC
     D/COPY ZACPYSRC,PSDS
 
     D SPOOL1          DS
     D   SFILE1               83     92
     D   SFNUM1              123    124B 0
 
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
 
     D DSFDY         E DS
     D DSSDY         E DS
 
     D CLE042          S               N
     D FIRSTXREC       S               N   INZ(*ON)
     D FIRSTYREC       S               N   INZ(*ON)
     D FIRSTZREC       S               N   INZ(*ON)
 
     D                 DS
     D AYLNTY
     D AYLNTY1                        1    OVERLAY(AYLNTY)
 
     D CSPACE2         C                   X'4040'
 
      *****************************************************************
     C     *ENTRY        PLIST
     C                   PARM                    P@SEQ             5
     C                   PARM                    P@LEVEL           1
     C                   PARM                    P@ENTITY          3
 
     C     KPDTYPE       KLIST
     C                   KFLD                    AYLNTY
     C                   KFLD                    AYLNST
     C                   KFLD                    AYLNCL
 
      *****************************************************************
     C                   EXSR      MAIN
 
     C                   EXSR      CLOSEDOWN
 
      *****************************************************************
     C     MAIN          BEGSR
 
     C     'X '          SETLL     SDLOANL0
     C                   READ      SDLOANL0
     C                   DOW       NOT %EOF
 
     C                   EXSR      PDDETAIL
 
     C                   EXSR      PDMAIN
 
     C                   READ      SDLOANL0
     C                   ENDDO
 
     C                   ENDSR
 
      *****************************************************************
     C     PDDETAIL      BEGSR
 
      ** Set up the print fields for the Past Due Loan Type/subtype
      ** record.
 
     C                   IF        CLE042
     C                   EVAL      #1TPSTCL    = AYLNTY
     C                                         + CSPACE2
     C                                         + AYLNST
     C                                         + CSPACE2
     C                                         + AYLNCL
     C                   ELSE
     C                   EVAL      #1TPSTCL    = CSPACE2
     C                                         + AYLNTY
     C                                         + CSPACE2
     C                                         + AYLNST
     C                   ENDIF
 
     C                   EVAL      #1LNTD      = AYLNTD
     C                   EVAL      #1LNPT      = AYLNPT
     C                   EVAL      #1RANG      = AYRANG
 
     C                   CALL      'ZDATE2'
     C                   PARM      AYLCD         @DATIN            5 0
     C                   PARM                    @DATFM            1
     C                   PARM      *ZEROS        @DATE6            6 0
     C     #1LCDATE      PARM      *BLANKS       @DATE7            7
 
     C                   IF        AYTYLC = 'I'
     C                   EVAL      #1LCTYPE    = 'INSERT'
     C                   ELSEIF    AYTYLC = 'A'
     C                   EVAL      #1LCTYPE    = 'AMEND'
     C                   ELSE
     C                   EVAL      #1LCTYPE    = AYTYLC
     C                   ENDIF
 
     C                   EXSR      CHKHEADS
     C                   WRITE     DETAIL01
     C                   EVAL      #1COUNT    += 1
 
     C                   ENDSR
 
      *****************************************************************
     C     PDMAIN        BEGSR
 
      ** For types X and Y, set up the print fields for the main Loan
      ** Type/subtype records which reference the PD record.
 
     C                   IF        AYLNTY1 = 'X'
     C     KPDTYPE       SETLL     SDLOANL5
     C                   ELSE
     C     KPDTYPE       SETLL     SDLOANL6
     C                   ENDIF
 
      ** PD Loan Type/subtype is not referenced by a main type;
      ** and type Z is handled here also.
     C                   IF        NOT %EQUAL
     C                   CLEAR                   DETAIL02
     C                   WRITE     DETAIL02
     C                   LEAVESR
     C                   ENDIF
 
     C                   IF        AYLNTY1 = 'X'
     C     KPDTYPE       READE     SDLOANL5
     C                   ELSE
     C     KPDTYPE       READE     SDLOANL6
     C                   ENDIF
 
     C                   DOW       NOT %EOF
     C                   IF        CLE042
     C                   EVAL      #1MTPSTCL   = M_AYLNTY
     C                                         + CSPACE2
     C                                         + M_AYLNST
     C                                         + CSPACE2
     C                                         + M_AYLNCL
     C                   ELSE
     C                   EVAL      #1MTPSTCL   = CSPACE2
     C                                         + M_AYLNTY
     C                                         + CSPACE2
     C                                         + M_AYLNST
     C                   ENDIF
 
     C                   EVAL      #1MLNPT     = M_AYLNPT
 
     C                   EXSR      CHKHEADS
     C                   WRITE     DETAIL02
 
     C                   IF        AYLNTY1 = 'X'
     C     KPDTYPE       READE     SDLOANL5
     C                   ELSE
     C     KPDTYPE       READE     SDLOANL6
     C                   ENDIF
     C                   ENDDO
 
     C                   ENDSR
 
      *****************************************************************
     C     CHKHEADS      BEGSR
 
     C                   IF        P1OVERFLOW
     C                   WRITE     HEAD01
     C                   EVAL      P1OVERFLOW  = *OFF
     C                   ENDIF
 
     C                   IF        AYLNTY1 = 'X'
     C                             AND FIRSTXREC
     C                   WRITE     HEAD02
     C                   EVAL      FIRSTXREC   = *OFF
     C                   ENDIF
 
     C                   IF        AYLNTY1 = 'Y'
     C                             AND FIRSTYREC
     C                   WRITE     HEAD03
     C                   EVAL      FIRSTYREC   = *OFF
     C                   ENDIF
 
     C                   IF        AYLNTY1 = 'Z'
     C                             AND FIRSTZREC
     C                   WRITE     HEAD04
     C                   EVAL      FIRSTZREC   = *OFF
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
     C     CLOSEDOWN     BEGSR
 
     C                   WRITE     FOOT01
 
     C                   EVAL      *INLR       = *ON
     C                   RETURN
 
     C                   ENDSR
 
      *****************************************************************
     C     *INZSR        BEGSR
 
     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*FIRST '     @OPTN
     C     SDBANK        PARM      SDBANK        DSFDY
 
     C                   IF        @RTCD <> *BLANKS
     C                   EVAL      DBFILE      = 'SDBANK'
     C                   EVAL      DBKEY       = @OPTN
     C                   EVAL      DBASE       = 1
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Check for presence of feature CLE042
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CLE042'      @SARD
 
     C                   IF        @RTCD = *BLANKS
     C                   EVAL      CLE042      = *ON
     C                   EVAL      #1CLASTXT1  = '/CLASS'
     C                   EVAL      #1CLASTXT2  = '/CLASS'
 
     C                   ELSEIF    @RTCD <> '*NRF'
     C                   EVAL      DBFILE      = 'SCSARD'
     C                   EVAL      DBKEY       = @SARD
     C                   EVAL      DBASE       = 2
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** RECORD SPOOLED FILE DETAILS IN RCF
     C                   CALL      'ZSFILE'
     C                   PARM      P@SEQ         ZSSEQ             5
     C                   PARM      P@ENTITY      ZSENTITY          3
     C                   PARM      SFILE1        ZSFILE           10
     C                   PARM      SFNUM1        ZSNUM             6 0
     C                   PARM      *BLANK        ZSERR             1
 
     C                   IF        ZSERR = 'Y'
     C                   EVAL      DBFILE      = 'ZSFILE'
     C                   EVAL      DBASE       = 3
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** WRITE 1ST PAGE HEADINGS
     C                   WRITE     HEAD01
 
     C                   ENDSR
 
      *****************************************************************
     C     *PSSR         BEGSR
 
     C                   IF        RUNBEFORE = *BLANK
     C                   EVAL      RUNBEFORE   = 'Y'
     C                   DUMP
     C                   ENDIF
 
     C                   EVAL      *INU7       = *ON
     C                   EVAL      *INU8       = *ON
     C                   EVAL      *INLR       = *ON
 
     C                   RETURN
 
     C                   ENDSR
