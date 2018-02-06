     H DEBUG
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
      *****************************************************************
      *                                                               *
      *  Midas - Access Objects                                       *
      *                                                               *
      *  AOWTDFR0 - Withholding Tax Rate Defaulting                   *
      *                                                               *
      *  (c) Finastra International Limited 2015                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CGL165  *CREATE    Date 23Feb15               *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CGL165 - Dual Withholding Tax                                *
      *                                                               *
      *****************************************************************
      *                                                               *
      *       11      BRANCH CODE PRIORITY IS NEXT LOWEST             *
      *       12      BOOK CODE PRIORITY IS NEXT LOWEST               *
      *       13      CURRENCY PRIORITY IS NEXT LOWEST                *
      *       14      COUNTRY OF DOMICILE PRIORITY IS NEXT LOWEST     *
      *       15      CUSTOMER TYPE PRIORITY IS NEXT LOWEST           *
      *       16      INSTITUTION CODE PRIORITY IS NEXT LOWEST        *
      *       17      MODULE PRIORITY IS NEXT LOWEST                  *
      *       18      PRODUCT TYPE PRIORITY IS NEXT LOWEST            *
      *       19      PRODUCT SUBTYPE PRIORITY IS NEXT LOWEST         *
      *                                                               *
      *****************************************************************
      *       RETURN CODES FROM THIS PROGRAM                          *
      *                                                               *
      *       0       TAX RATE CODE FOUND - NO ERROR                  *
      *       1       DEFAULT NOT FOUND FOR THIS COMBINATION-BLANK    *
      *               TAX RATE CODE IS RETUNED                        *
      *       2       TAX RATE CODE FOUND BUT IS INVALID              *
      *                                                               *
      *****************************************************************
      *
     FSDWTDML1  IF   E           K DISK
     F*
     D CPY@            S             80    DIM(1) CTDATA PERRCD(1)
     D*
     D*
     D SDWTRC        E DS                  EXTNAME(SDWTRCPD)
     D**  EXTERNAL DS FOR WITHHOLDING TAX RATE CODE
     D*
     D DSFDY         E DS                  EXTNAME(DSFDY)
     D* FIRST DS FOR ACCESS PROGRAMS, SHORT DATA STRUCTURE
     D*
     D DSSDY         E DS                  EXTNAME(DSSDY)
     D* SECOND DS FOR ACCESS PROGRAMS, LONG DATA STRUCTURE
     D*
      * System Value
     D                 DS
     D DFLTPR          DS
     D  DMBR                   1      1
     D  DMBO                   2      2
     D  DMCU                   3      3
     D  DMCD                   4      4
     D  DMCT                   5      5
     D  DMIN                   6      6
     D  DMMO                   7      7
     D  DMTY                   8      8
     D  DMTS                   9      9
      *
     C                   MOVEA     CPY@          CPY2@            80
     C*
     C**  Input Parameters
     C*
     C     *ENTRY        PLIST
     C                   PARM                    RTCD              1
     C                   PARM                    BRC1              3
     C                   PARM                    BOK1              2
     C                   PARM                    CUY1              3
     C                   PARM                    CDO1              2
     C                   PARM                    CTY1              1
     C                   PARM                    INS1              2
     C                   PARM                    MOD1              2
     C                   PARM                    PRD1             10
     C                   PARM                    PST1              2
     C                   PARM                    WTR1              2
     C                   PARM                    WTR2              2
     C*
     C**  Input Parameters
     C*
     C     FLKEY         KLIST
     C                   KFLD                    BRC1
     C                   KFLD                    BOK1
     C                   KFLD                    CUY1
     C                   KFLD                    CDO1
     C                   KFLD                    CTY1
     C                   KFLD                    INS1
     C                   KFLD                    MOD1
     C                   KFLD                    PRD1
     C                   KFLD                    PST1
     C*
     C                   MOVEL     '********'    STARS            10
     C                   MOVE      '**'          STARS
     C                   Z-ADD     0             COUNT             1 0
     C                   MOVE      *BLANKS       RTCD
     C*
     C     BRC1          IFEQ      *BLANKS
     C                   MOVE      STARS         BRC1
     C                   END
     C*
     C     BOK1          IFEQ      *BLANKS
     C                   MOVE      STARS         BOK1
     C                   END
     C*
     C     CUY1          IFEQ      *BLANKS
     C                   MOVE      STARS         CUY1
     C                   END
     C*
     C     CDO1          IFEQ      *BLANKS
     C                   MOVE      STARS         CDO1
     C                   END
     C*
     C     CTY1          IFEQ      *BLANKS
     C                   MOVE      STARS         CTY1
     C                   END
     C*
     C     INS1          IFEQ      *BLANKS
     C                   MOVE      STARS         INS1
     C                   END
     C*
     C     MOD1          IFEQ      *BLANKS
     C                   MOVE      STARS         MOD1
     C                   END
     C*
     C     PRD1          IFEQ      *BLANKS
     C                   MOVE      STARS         PRD1
     C                   END
     C*
     C     PST1          IFEQ      *BLANKS
     C                   MOVE      STARS         PST1
     C                   END
     C*
     C**  Obtain Withholding Tax Default Matrix priorities from
      **  System Value WHTDftMtrxPriorities
     C*
     C                   Eval      P@Op01 = 'WHTDftMtrxPriorities'
     C                   Call      'AOSVALR0'
     C                   Parm      *Blanks       P@Rtcd            7
     C                   Parm                    P@Op01           20
     C                   Parm      *Blanks       P@Vl01          200
     C                   Parm      *Blanks       P@Op02           20
     C                   Parm      *Blanks       P@Vl02          200
     C                   Parm      *Blanks       P@Op03           20
     C                   Parm      *Blanks       P@Vl03          200
     C                   Parm      *Blanks       P@Op04           20
     C                   Parm      *Blanks       P@Vl04          200
     C                   Parm      *Blanks       P@Op05           20
     C                   Parm      *Blanks       P@Vl05          200
     C                   Parm      *Blanks       P@Op06           20
     C                   Parm      *Blanks       P@Vl06          200
     C                   Parm      *Blanks       P@Op07           20
     C                   Parm      *Blanks       P@Vl07          200
     C                   Parm      *Blanks       P@Op08           20
     C                   Parm      *Blanks       P@Vl08          200
     C                   Parm      *Blanks       P@Op09           20
     C                   Parm      *Blanks       P@Vl09          200
     C                   Parm      *Blanks       P@Op10           20
     C                   Parm      *Blanks       P@Vl10          200
 
      *
      * Move priorities to fields for comparison. If error on access
      * of the system value, simply end program with no defaulting
     C     P@RTCD        IFEQ      *BLANKS
     C                   MOVEL     P@VL01        DFLTPR
     C                   ELSE
     C                   SETON                                        LR
     C                   RETURN
     C                   ENDIF
     C** If one of the priorities is zero,set the relevant key to
     C** asterisks, else add one to number of non-zero priorities.
     C*
     C     DMBR          IFEQ      '0'
     C                   MOVE      STARS         BRC1
     C                   ELSE
     C                   ADD       1             COUNT
     C                   END
     C*
     C     DMBO          IFEQ      '0'
     C                   MOVE      STARS         BOK1
     C                   ELSE
     C                   ADD       1             COUNT
     C                   END
     C*
     C     DMCU          IFEQ      '0'
     C                   MOVE      STARS         CUY1
     C                   ELSE
     C                   ADD       1             COUNT
     C                   END
     C*
     C     DMCD          IFEQ      '0'
     C                   MOVE      STARS         CDO1
     C                   ELSE
     C                   ADD       1             COUNT
     C                   END
     C*
     C     DMCT          IFEQ      '0'
     C                   MOVE      STARS         CTY1
     C                   ELSE
     C                   ADD       1             COUNT
     C                   END
     C*
     C     DMIN          IFEQ      '0'
     C                   MOVE      STARS         INS1
     C                   ELSE
     C                   ADD       1             COUNT
     C                   END
     C*
     C     DMMO          IFEQ      '0'
     C                   MOVE      STARS         MOD1
     C                   ELSE
     C                   ADD       1             COUNT
     C                   END
     C*
     C     DMTY          IFEQ      '0'
     C                   MOVE      STARS         PRD1
     C                   ELSE
     C                   ADD       1             COUNT
     C                   END
     C*
     C     DMTS          IFEQ      '0'
     C                   MOVE      STARS         PST1
     C                   ELSE
     C                   ADD       1             COUNT
     C                   END
     C*
     C**  While number of non-zero priorities is greater than zero
     C**  or haven't found a TAX RATE CODE do the following
     C*
     C                   SETON                                        30
     C     *IN30         DOWEQ     '1'
     C     COUNT         ANDGT     0
     C*
     C** Chain to LF/SDWTDML1 for Withholding Tax Rate Code
     C     FLKEY         CHAIN     SDWTDMD0                           55
     C*
     C** If Tax Rate Code is found,verify it in SDWTRCPD
     C     *IN55         IFEQ      '0'
     C                   SETOFF                                       30
     C                   CALL      'AOWTRCR0'
     C                   PARM      '       '     @RTCD             7
     C                   PARM      '*VERIFY'     @OPTN             7
     C                   PARM      TXR1          @KEY              2
     C     SDWTRC        PARM      SDWTRC        DSFDY
     C*
     C** Invalid TAX RATE CODE
     C     @RTCD         IFNE      *BLANKS
     C                   MOVE      '2'           RTCD
     C                   MOVEL     TXR1          WTR1
      *
     C                   ELSE
     C                   CALL      'AOWTRCR0'
     C                   PARM      '       '     @RTCD             7
     C                   PARM      '*VERIFY'     @OPTN             7
     C                   PARM      TXR2          @KEY              2
     C     SDWTRC        PARM      SDWTRC        DSFDY
     C*
     C** Invalid TAX RATE CODE
     C     @RTCD         IFNE      *BLANKS
     C                   MOVE      '2'           RTCD
     C                   MOVEL     TXR2          WTR2
     C                   END
     C                   END
     C*
     C                   ELSE
     C*
     C** Field with next lowest priority is asterisked
     C                   MOVE      COUNT         COUNTA            1
     C     DMBR          IFEQ      COUNTA
     C     *IN11         ANDEQ     '0'
     C                   MOVE      STARS         BRC1
     C                   SETON                                        11
     C                   END
     C     DMBO          IFEQ      COUNTA
     C     *IN12         ANDEQ     '0'
     C                   MOVE      STARS         BOK1
     C                   SETON                                        12
     C                   END
     C     DMCU          IFEQ      COUNTA
     C     *IN13         ANDEQ     '0'
     C                   MOVE      STARS         CUY1
     C                   SETON                                        13
     C                   END
     C     DMCD          IFEQ      COUNTA
     C     *IN14         ANDEQ     '0'
     C                   MOVE      STARS         CDO1
     C                   SETON                                        14
     C                   END
     C     DMCT          IFEQ      COUNTA
     C     *IN15         ANDEQ     '0'
     C                   MOVE      STARS         CTY1
     C                   SETON                                        15
     C                   END
     C     DMIN          IFEQ      COUNTA
     C     *IN16         ANDEQ     '0'
     C                   MOVE      STARS         INS1
     C                   SETON                                        16
     C                   END
     C     DMMO          IFEQ      COUNTA
     C     *IN17         ANDEQ     '0'
     C                   MOVE      STARS         MOD1
     C                   SETON                                        17
     C                   END
     C     DMTY          IFEQ      COUNTA
     C     *IN18         ANDEQ     '0'
     C                   MOVE      STARS         PRD1
     C                   SETON                                        18
     C                   END
     C     DMTS          IFEQ      COUNTA
     C     *IN19         ANDEQ     '0'
     C                   MOVE      STARS         PST1
     C                   SETON                                        19
     C                   END
     C                   SUB       1             COUNT
     C                   END
     C                   END
     C*
     C     END           TAG
     C*
     C** Valid TAX RATE CODE found
     C*
     C     RTCD          IFEQ      *BLANKS
     C     *IN30         IFEQ      '0'
     C     COUNT         ANDGT     0
     C                   MOVE      '0'           RTCD
     C                   MOVEL     TXR1          WTR1
     C                   MOVEL     TXR2          WTR2
     C                   ELSE
     C                   MOVE      '1'           RTCD
     C                   MOVEL     *BLANKS       WTR1
     C                   MOVEL     *BLANKS       WTR2
     C                   END
     C                   END
     C                   SETON                                        LR
** CPY@
(c) Finastra International Limited 2015
