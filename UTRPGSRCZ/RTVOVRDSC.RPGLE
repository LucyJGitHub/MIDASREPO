     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2012')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Retrieve Override Description')                        *
      *****************************************************************
      *                                                               *
      *  Midas - Utilities                                            *
      *                                                               *
      *  RTVOVRDSC - Retrieve Override Description                    *
      *                                                               *
      *  Function:  This program is used to determince what overriedes*
      *             exist for the specified file.                     *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2012            *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Last Amend No. CLE134  *CREATE    Date 01Aug12               *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  CLE134 - Past Due Call Loan Processing                       *
      *                                                               *
      *****************************************************************
     D/SPACE
 
     D/COPY QSYSINC/QRPGLESRC,QDMRTVFO
     D/COPY QSYSINC/QRPGLESRC,QUSEC
 
     D RtvOvrInf       PR                  EXTPGM('QDMRTVFO')
     D  P@OvrInfo                     1    OPTIONS(*VARSIZE)
     D  P@OvrInfoL                   10I 0 CONST
     D  P@Fmt                         8    CONST
     D  P@File                       10    CONST
     D  QUSEC                              LIKEDS(QUSEC)
 
     D P@FmFile        S             10
     D P@ToFile        S             10
     D P@ToLibr        S             10
     D P@ToMbr         S             10
     D P@OvrTyp        S             10
     D P@RtnCd         S              1
 
     C/EJECT
     C     *INZSR        BEGSR
      *****************************************************************
      * *INZSR: Initialisation Rountine.                              *
      *****************************************************************
 
      ** Retrieve Override Details.
 
     C                   EVAL      QUSBPRV     = %SIZE(QUSEC)
 
     C                   CALLP     RtvOvrInf
     C                                          (QDML0100:
     C                                           %SIZE(QDML0100):
     C                                           'OVRL0100':
     C                                           P@FmFile:
     C                                           QUSEC)
 
     C                   IF        QUSBAVL     > 0
     C                   EVAL      P@RtnCd     = '9'
 
     C                   ELSE
     C                   IF        QDMFILNU   <> *BLANKS
     C                   EVAL      P@ToFile    = %TRIMR(QDMFILNU)
     C                   EVAL      P@ToLibr    = %TRIMR(QDMLIBNU)
     C                   EVAL      P@ToMbr     = %TRIMR(QDMMNU)
     C                   EVAL      P@OvrTyp    = %TRIMR(QDMFOT)
     C                   EVAL      P@RtnCd     = '0'
 
     C                   ELSE
     C                   EVAL      P@RtnCd     = '1'
     C                   ENDIF
     C                   ENDIF
 
     C                   EVAL      *INLR       = *ON
     C                   RETURN
 
     C                   ENDSR
      *****************************************************************
     C/SPACE
      *****************************************************************
     C     @DEFN         BEGSR
 
      ** @DEFN: Definition Rountine.
 
      ** Entry List...
 
     C     *ENTRY        PLIST
     C                   PARM                    P@FmFile
     C                   PARM                    P@ToFile
     C                   PARM                    P@ToLibr
     C                   PARM                    P@ToMbr
     C                   PARM                    P@OvrTyp
     C                   PARM                    P@RtnCd
 
     C                   ENDSR
      *****************************************************************
