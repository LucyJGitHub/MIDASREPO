     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2006')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas SD KYC Item Parser')
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SD000053 - Midas SD KYC Item Parser                          *
      *                                                               *
      *  (c) Finastra International Limited 2006                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. BUG10603 *CREATE   Date 14Feb06               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  BUG10603 - Change Control for KYC                            *
      *                                                               *
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ D-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Named Constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
      ** Copyright Statement Array
     D CPY@            S             80A   DIM(1) CTDATA
 
      ** Status Array
     D STATUS          S             10A   DIM(4) CTDATA
 
      ** Token Array
     D TOKEN           S              1A   DIM(80)
 
      ** +--------------------------------------+
      ** ¦ Declared Variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Entry Parameters
     D PRtCd           S              7A
     D POptn           S              7A
     D PItem           S           5000A
     D PStaFlg         S              1A
     D PLength         S              4P 0
     D PToken          S             80A
     D PTknTyp         S              7A
     D PCurIdx         S              4P 0
     D PStatus         S             10A
 
      ** Working Variables
     D WChar           S              1A
     D WTknIdx         S              2P 0
     D WTknLen         S              2P 0 INZ(%ELEM(TOKEN))
     D WStatus         S             10A
     D WX              S              2P 0
     D WY              S              2P 0
 
      ** +---------------- Start of Main Processing ------------------+
      ** ¦                                                            ¦
      ** ¦  *INZSR is automatically executed at program activation.   ¦
      ** ¦                                                            ¦
      ** +------------------------------------------------------------+
 
      ** Initialise relevant variables.
 
     C                   IF        POptn = '*FIRST '
     C                   EVAL      PLength = %LEN(%TRIM(PItem))
     C                   EVAL      PCurIdx = 1
     C                   ENDIF
 
     C                   EVAL      PToken = *BLANKS
     C                   EVAL      PTknTyp = *BLANKS
     C                   EVAL      PStatus = *BLANKS
 
     C                   CLEAR                   TOKEN
     C                   EVAL      WTknIdx = 0
     C                   EVAL      WStatus = *BLANKS
     C                   EVAL      WChar = *BLANK
 
     C                   IF        PCurIdx > PLength
     C                   EVAL      PRtCd = '*EOL'
     C                   EVAL      *INLR = *ON
     C                   RETURN
     C                   ENDIF
 
     C                   DOW       PCurIdx <= PLength
 
     C                   EVAL      WChar = %SUBST(PItem : PCurIdx : 1)
 
     C                   SELECT
 
     C                   WHEN      WChar = '<'
     C                   EVAL      PTknTyp = '*COL'
     C                   EXSR      SRRtnTkn
 
     C                   WHEN      WChar = '>'
 
      ** This empty block prevents subroutine SRBldTkn from executing.
 
     C                   WHEN      WChar = ','
     C                   EXSR      SRGetSta
 
      ** If the Document Status is valid, return the current token.
 
     C                   IF        PStatus <> *BLANKS
     C                   IF        PStaFlg <> 'Y'
     C                   EXSR      SRRmvSta
     C                   ENDIF
     C                   EVAL      PTknTyp = '*DOC'
     C                   EXSR      SRRtnTkn
     C                   ELSE
 
      ** Comma from the input string is part of the token. Thus, continue building.
 
     C                   EXSR      SRBldTkn
     C                   ENDIF
 
     C                   OTHER
 
      ** Character retrieved is not a delimiter. Must be part of the token.
 
     C                   EXSR      SRBldTkn
     C                   ENDSL
 
     C                   EVAL      PCurIdx = PCurIdx + 1
     C                   ENDDO
 
      ** Return the final token.
 
     C                   EXSR      SRGetSta
     C                   IF        PStatus <> *BLANKS
     C                   IF        PStaFlg <> 'Y'
     C                   EXSR      SRRmvSta
     C                   ENDIF
     C                   EVAL      PTknTyp = '*DOC'
     C                   EXSR      SRRtnTkn
     C                   ENDIF
 
     C                   EVAL      *INLR = *ON
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRGetSta - Gets the Document Status.                         *
      *                                                               *
      *****************************************************************
     C     SRGetSta      BEGSR
 
     C                   EVAL      WX = WTknIdx
     C                   EVAL      WStatus = *BLANKS
 
      ** Get the last word of the current token.
 
     C                   DOW       WX > *ZERO
 
     C                   IF        TOKEN(WX) = *BLANK
     C                   EVAL      WX = *ZERO
     C                   ELSE
     C                   EVAL      WStatus = TOKEN(WX) + %TRIM(WStatus)
     C                   EVAL      WX = WX - 1
     C                   ENDIF
 
     C                   ENDDO
 
      ** Check if the last word is a valid Document Status.
 
     C                   FOR       WY = 1 TO %ELEM(STATUS)
     C                   IF        WStatus = STATUS(WY)
     C                   EVAL      PStatus = WStatus
     C                   LEAVE
     C                   ENDIF
     C                   ENDFOR
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRRmvSta - Removes the Document Status.                      *
      *                                                               *
      *****************************************************************
     C     SRRmvSta      BEGSR
 
     C                   EVAL      WX = WTknIdx
 
      ** Change the last word of the current token to blanks.
 
     C                   DOW       WX > *ZERO
 
     C                   IF        TOKEN(WX) = *BLANK
     C                   EVAL      WX = *ZERO
     C                   ELSE
     C                   EVAL      TOKEN(WX) = *BLANK
     C                   EVAL      WX = WX - 1
     C                   ENDIF
 
     C                   ENDDO
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRBldTkn - Builds the current token.                         *
      *                                                               *
      *****************************************************************
     C     SRBldTkn      BEGSR
 
     C                   IF        WTknIdx + 1 <= WTknLen
     C                   EVAL      WTknIdx = WTknIdx + 1
     C                   EVAL      TOKEN(WTknIdx) = WChar
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRRtnTkn - Returns the current token.                        *
      *                                                               *
      *****************************************************************
     C     SRRtnTkn      BEGSR
 
     C                   MOVEA     TOKEN         PToken
     C                   EVAL      PToken = %TRIML(PToken)
     C                   EVAL      PCurIdx = PCurIdx + 1
 
     C                   EVAL      *INLR = *ON
     C                   RETURN
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *INZSR - Program Initialisation Subroutine.                  *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR
 
      ** Entry Parameters
 
     C     *ENTRY        PLIST
     C                   PARM                    PRtCd
     C                   PARM                    POptn
     C                   PARM                    PItem
     C                   PARM                    PStaFlg
     C                   PARM                    PLength
     C                   PARM                    PToken
     C                   PARM                    PTknTyp
     C                   PARM                    PCurIdx
     C                   PARM                    PStatus
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
** CPY@
(c) Finastra International Limited 2006
** STATUS
Requested
Valid
Expired
Rejected
