     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2012')
      *****************************************************************
/*STD *  RPGBASEBNC                                                   *
/*EXI *  TEXT('Midas LE Past Due Call Loans/Origin Loan prompt')      *
      *****************************************************************
      *                                                               *
      *  Midas - Customer Lending Module                              *
      *                                                               *
      *  LE000081P - Past Due Call Loans/Origin Loan report prompt    *
      *                                                               *
      *  (c) Finastra International Limited 2012                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CLE148             Date 23Jul12               *
      *                 CLE134  *CREATE    Date 01Aug12               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CLE148 - Alpha Loan Reference                                *
      *  CLE134 - Past Due Call Loan Processing                       *
      *                                                               *
      *****************************************************************
      *
     FLE000081DFCF   E             WORKSTN
      *
     FCLOAN     IF   E           K DISK    INCLUDE(CLOANCLF)
      *
      *****************************************************************
      *
     D/COPY ZACPYSRC,STD_D_SPEC
      *
     D/COPY ZACPYSRC,PSDS
      *
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      *
     D DSFDY         E DS
      *
     D PTR             S               *   INZ(%ADDR(*IN))
     D                 DS                  BASED(PTR)
     D F12_CANCEL             12     12N
     D ERRLOAN                30     30N
      *
     D RPARM           DS           100
     D   #1LNRF
     D   #1LNRFN               1      6
      *
     D CDIGITS         C                   '0123456789'
      *
      ** Additional Field Definitions
     D RNXTSEQ         S              5
     D RLEVEL          S              1
     D RENTITY         S              3
     D RACT            S              1
     D RCMD            S              1
     D ZAPGRL          S              5
     D ZAPGMQ          S             10
     D ZAMSID          S              7
     D ZAMSGF          S             10
     D ZAMSDA          S            132
     D ZAMSTP          S              7
      *
     C/EJECT
      *
      ** +--- Start of Main processing -----------------------------------+
      ** Ê                                                                Ê
      ** Ê Initial processing is performed automatically: the *INZSR is   Ê
      ** Ê executed at program activation.                                Ê
      ** Ê                                                                Ê
      ** +----------------------------------------------------------------+
      *
     C     *ENTRY        PLIST
     C                   PARM                    RNXTSEQ
     C                   PARM                    RLEVEL
     C                   PARM                    RENTITY
     C                   PARM                    RPARM
     C                   PARM                    RACT
     C                   PARM                    RCMD
      *
     C                   EXSR      MAIN
      *
     C                   EXSR      CLOSEDOWN
      *****************************************************************
      /EJECT
      *****************************************************************
      *  MAIN - Main Subroutine                                       *
      *****************************************************************
     C     MAIN          BEGSR
      *
     C                   DOU       NOT ERRLOAN
      *
     C                   WRITE     #MSGCTL
     C                   EXFMT     LE000081D1
      *
     C                   CALL      'Y2CLMSC'
     C                   PARM      SPGM          ZAPGMQ
     C                   PARM      '*SAME'       ZAPGRL
      *
     C                   IF        F12_CANCEL
     C                   LEAVE
     C                   ENDIF
      *
     C                   EXSR      VALLOAN
      *
     C                   ENDDO
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *  VALLOAN - Validate Loan                                      *
      *****************************************************************
     C     VALLOAN       BEGSR
      *
      ** Loan Number must be all digits and must exist on loans file
      *
     C                   EVAL      ERRLOAN = *OFF
      *
     C                   IF        #1LNRF = *BLANKS
     C                   EVAL      #1LNRF = 'ALL'
     C                   ENDIF
      *
     C                   IF        #1LNRF <> 'ALL'
     C**********         IF        %CHECK(CDIGITS: #1LNRF) > 0                                CLE148
     C**********         EVAL      ERRLOAN = *ON                                              CLE148
      *
     C**********         ELSE                                                                 CLE148
     C*****#1LNRFN       SETLL     CLOAN                                                      CLE148
     C     #1LNRF        SETLL     CLOAN                                                      CLE148
     C                   EVAL      ERRLOAN = NOT %EQUAL
     C**********         ENDIF                                                                CLE148
      *
     C                   IF        ERRLOAN
     C                   CALL      'Y2SNMGC'
     C                   PARM      SPGM          ZAPGMQ
     C                   PARM      '*SAME'       ZAPGRL
     C                   PARM      'LEE0002'     ZAMSID
     C                   PARM      'LERMSGF'     ZAMSGF
     C                   PARM      *BLANKS       ZAMSDA
     C                   PARM      *BLANKS       ZAMSTP
     C                   ENDIF
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *  CLOSEDOWN - Close Down Program                               *
      *****************************************************************
     C     CLOSEDOWN     BEGSR
      *
     C                   IF        F12_CANCEL
     C                   EVAL      RCMD = 'F'
     C                   ENDIF
      *
     C                   EVAL      *INLR = *ON
     C                   RETURN
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *  *INZSR - Default Initialisation Subroutine                   *
      *****************************************************************
     C     *INZSR        BEGSR
      *
     C                   EVAL      DBPGM = PSPROCPGM
     C                   EVAL      SUSER = PSUSER
     C                   EVAL      SPGM = PSPROCPGM
     C                   EVAL      SJOB = PSJOBNAME
      *
     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*FIRST '     @OPTN
     C     SDBANK        PARM      SDBANK        DSFDY
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *  *PSSR - Default Error Handling Subroutine                    *
      *****************************************************************
     C     *PSSR         BEGSR
      *
     C                   IF        RUNBEFORE <> 'Y'
     C                   EVAL      RUNBEFORE = 'Y'
     C                   DUMP
     C                   ENDIF
      *
     C                   CALL      'DBERRCTL'
      *
     C                   ENDSR
      *****************************************************************
**  CPY@
(c) Finastra International Limited 2012
