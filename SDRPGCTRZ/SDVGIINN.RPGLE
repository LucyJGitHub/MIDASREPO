     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2014')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD Validate GIIN Number')                        *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SDVGIINN - Validate GIIN Owner                               *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2014            *
      *                                                               *
      *  Last Amend No. MD029805 *CREATE   Date 05Sep14               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD029805 - GIIN number validation                            *
      *                                                               *
      *****************************************************************
 
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      **
     D/COPY ZACPYSRC,STD_D_SPEC
 
      ** The following /COPY includes the MM standard declares:
     D/COPY ZACPYSRC,STDDECLARE
 
     D/COPY ZACPYSRC,PSDS
 
     D/COPY ZACPYSRC,ERR_XARRYS
 
      ** +--------------------------------------+
      ** ¦ End of automatically included D-specs¦
      ** ¦ =====================================¦
      ** +--------------------------------------+
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ Manually included D-specs            ¦
      ** ¦ =========================            ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
      ** Alphabet characters except 'O'
     D AlphaEO         S              1    DIM(25) CTDATA PERRCD(25)
 
      ** Alphabet characters except 'O' and numeric
     D AlphaNum        S              1    DIM(35) CTDATA PERRCD(35)
 
      ** Numeric
     D Numeric         S              1    DIM(10) CTDATA PERRCD(10)
 
     D WN1N6           S              1    DIM(6)
     D WN812           S              1    DIM(5)
     D W1719           S              1    DIM(3)
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
     D R               S              2S 0
     D WN1N6X          S              6A
     D WN812X          S              5A
     D W1415           S              2A
     D W1719X          S              3A
 
      ** Index for arrays of error message ids etc
     D Idx             S              3P 0
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** Initialization
 
     C                   MOVE      *BLANK        ReturnCode
     C                   MOVE      *BLANK        FldNamXAr
     C                   MOVE      *BLANK        MsgIDXAr
     C                   MOVE      *BLANK        MsgDtaXAr
     C                   Z-ADD     0             Idx
     C                   MOVE      'Y'           DDGIINOK
 
     C                   IF        DDGIIN <> *BLANKS
 
     C                   IF        DDCSTP = 'F' AND
     C                             DDCSST = 'PO' OR
     C                             DDCSTP = 'F' AND
     C                             DDCSST = 'PS'
 
     C                   EVAL      WN1N6X = %SUBST(DDGIIN:1:6)
     C                   MOVEA     WN1N6X        WN1N6
     C                   EVAL      R = 1
     C                   EVAL      *IN94 = *On
     C                   DOW       R <= 6 and
     C                             *IN94 = *On
 
     C                   IF        WN1N6(R) <> *Blanks
     C     WN1N6(R)      LOOKUP    AlphaNum                               94
 
     C                   IF        *IN94 = *OFF
     C                   MOVE      'N'           DDGIINOK
     C                   ENDIF
     C                   ELSE
     C                   MOVE      'N'           DDGIINOK
     C                   ENDIF
 
     C                   EVAL      R = R + 1
     C                   ENDDO
 
     C                   IF        %SUBST(DDGIIN:7:1) = '.' AND
     C                             %SUBST(DDGIIN:13:1) = '.' AND
     C                             %SUBST(DDGIIN:16:1) = '.'
     C                   ELSE
     C                   MOVE      'N'           DDGIINOK
     C                   ENDIF
 
     C                   EVAL      WN812X = %SUBST(DDGIIN:8:5)
     C                   MOVEA     WN812X        WN812
     C
     C                   EVAL      R = 1
     C                   EVAL      *IN95 = *On
     C                   DOW       R <= 5 and
     C                             *IN95 = *On
 
     C                   IF        WN812(R) <> *Blanks
     C     WN812(R)      LOOKUP    AlphaNum                               95
 
     C                   IF        *IN95 = *OFF
     C                   MOVE      'N'           DDGIINOK
     C                   ENDIF
     C                   ELSE
     C                   MOVE      'N'           DDGIINOK
     C                   ENDIF
 
     C                   EVAL      R = R + 1
     C                   ENDDO
 
     C                   EVAL      W1415 = %SUBST(DDGIIN:14:2)
     C                   IF        W1415 = 'BR' OR
     C                             W1415 = 'LE' OR
     C                             W1415 = 'ME' OR
     C                             W1415 = 'SL' OR
     C                             W1415 = 'SP'
     C                   ELSE
     C                   MOVE      'N'           DDGIINOK
     C                   ENDIF
 
     C                   IF        W1415 = 'LE' OR
     C                             W1415 = 'SL' OR
     C                             W1415 = 'SP'
     C                   IF        WN812X <> '00000' AND
     C                             W1415 = 'LE' OR
     C                             WN812X <> '00000' AND
     C                             W1415 = 'SP' OR
     C                             WN812X <> '99999' AND
     C                             W1415 = 'SL' OR
     C                             (WN812X = '00000' AND
     C                             (W1415 <> 'LE' AND
     C                             W1415 <> 'SP')) OR
     C                             WN812X = '99999' AND
     C                             W1415 <> 'SL'
     C                   MOVE      'N'           DDGIINOK
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        W1415 = 'ME' AND
     C                             WN812X = '00000' OR
     C                             W1415 = 'ME' AND
     C                             WN812X = '99999'
     C                   MOVE      'N'           DDGIINOK
     C                   ENDIF
 
     C                   EVAL      W1719X = %SUBST(DDGIIN:17:3)
     C                   MOVEA     W1719X        W1719
     C                   EVAL      R = 1
     C                   EVAL      *IN96 = *On
     C                   DOW       R <= 3 and
     C                             *IN96 = *On
 
     C                   IF        W1719(R) <> *Blanks
     C     W1719(R)      LOOKUP    Numeric                                96
 
     C                   IF        *IN96 = *OFF
     C                   MOVE      'N'           DDGIINOK
     C                   ENDIF
     C                   ELSE
     C                   MOVE      'N'           DDGIINOK
     C                   ENDIF
 
     C                   EVAL      R = R + 1
     C                   ENDDO
 
     C                   IF        %SUBST(DDGIIN:20:6) <> *BLANKS
     C                   MOVE      'N'           DDGIINOK
     C                   ENDIF
 
     C                   IF        DDGIINOK = 'N'
     C                   ADD       1             Idx
     C                   MOVEL     'DDGIIN'      FldNamXAr(Idx)
     C                   MOVEL     'USS0510'     MsgIdXAr(Idx)
     C                   ENDIF
 
     C                   ELSE
     C                   MOVE      'N'           DDGIINOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDGIIN'      FldNamXAr(Idx)
     C                   MOVEL     'USS0511'     MsgIdXAr(Idx)
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        DDGIINOK = 'Y'
     C                   EVAL      DFGIIN = DDGIIN
     C                   ENDIF
 
      ** Return
 
     C                   RETURN
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      *****************************************************************
 
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
 
      ** Return Code
     C                   PARM                    ReturnCode
 
      ** GIIN Number
     C                   PARM                    DDGIIN           25
 
      ** FATCA Customer Type
     C                   PARM                    DDCSTP            1
 
      ** FATCA Customer Sub Type
     C                   PARM                    DDCSST            2
 
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
 
     C                   PARM                    DDGIINOK          1
     C                   PARM                    DFGIIN           25
 
     C/COPY ZACPYSRC,DBFIELDS
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      /COPY ZACPYSRC,PSSR_ILE
      *****************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2014
**  AlphaEO - Array of alphabetic characters without letter 'O'
ABCDEFGHIJKLMNPQRSTUVWXYZ
**  AlphaNum - Array of alphabetic characters
ABCDEFGHIJKLMNPQRSTUVWXYZ1234567890
**  Numeric - Array of numeric
1234567890
