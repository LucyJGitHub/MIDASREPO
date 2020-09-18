     H DEBUG
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas AO IBAN calculate/validate check digit')
      *****************************************************************
      *                                                               *
      *  Midas - Access Object                                        *
      *                                                               *
      *  AOIBANR0 - IBAN Calculate/Validate Check Digit               *
      *                                                               *
      *  Called By:                                                   *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. CSD103             Date 10Aug20               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.02 -----------------------------------------------*
      *                 CFT004  *CREATE    Date 16Jul99               *
      *                                    Date DDMmmYY               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD103 - LIBOR Deregulation - Common Layer/Standing Data     *
      *  MD046248 - Finastra Rebranding                               *
      *  CFT004 - International Bank Account Number                   *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  F U N C T I O N   O F   I N D I C A T O R S                  *
      *                                                               *
      *  30    - SCAN result                                          *
      *                                                               *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E   I N D E X                              *
      *                                                               *
      *  SECPRC - Section Process                                     *
      *                                                               *
      *****************************************************************
      /EJECT
      *
     D IIBANP          S              1    DIM(34)                              I:IBAN Number
     D IIBAN           S              1    DIM(34)                              I:IBAN Number
     D OBBAN           S              1    DIM(30)                              O:BBAN Number
     D OIBAN           S              1    DIM(34)                              O:IBAN Number
      ** Arrays containing Input and Output Parameters
     D WIBA1           S              1    DIM(66)                              Work 1 IBAN
     D WIBA2           S              1    DIM(66)                              Work 2 IBAN
      ** Work Array
      *
     D CDIGIT          C                   CONST('0123456789')
      * Constant to check valid digits numbers
      *
     D                 DS
      * Section
     D  SECT                   1      9    DIM(9)
     D  WSECAL                 1      9
     D  WSECNM                 1      9  0
     D                 DS
      * Digit
     D  WDIGITA                1      2
     D  WDIGITN                1      2  0
     D                 DS
      * Check Digit
     D  WCKDGA                 1      2
     D  WCKDGN                 1      2  0
     D                 DS
      * Save Check Digit
     D  WSVDGA                 1      2
     D  WSVDGN                 1      2  0
     D                 DS
      * Output Check Digit
     D  WOCKDGA                1      2
     D  WOCKDGN                1      2  0
      *
     D A@CPY           DS
      * Copyright array
     D  CPY@                   1     80
     D                                     DIM(1) CTDATA PERRCD(1)
      /SPACE 3
      *
      /EJECT
     C*CSTART
      *****************************************************
     C     *ENTRY        PLIST
     C                   PARM                    P@RTCD            7            O:Return code
     C                   PARM                    IACTN             1            I:Action
     C                   PARM                    ICNTY             2            I:ISO Country
     C                   PARM                    IIBANP                         I:IBAN
     C                   PARM                    OBBAN                          O:BBAN
     C                   PARM                    OIBAN                          O:IBAN
     C                   PARM                    OCKDG             2            O:Check Digt
      *****************************************************
      *MAIN
      *
     C                   MOVE      IIBANP        IIBAN
      * Save Check Digits ( for Validation only)
     C     IACTN         IFEQ      'V'
     C                   MOVEL     IIBAN(3)      WSVDGA
     C                   MOVE      IIBAN(4)      WSVDGA
     C                   ELSE
     C     IACTN         IFNE      'C'
     C                   MOVE      '*ACTION'     P@RTCD
     C                   RETURN
     C                   ENDIF
     C                   ENDIF
      *
      * Convert Country Code( to digits)
      * 1st Char
     C                   MOVEL     ICNTY         @@CHAR
     C                   CALLB     'AOIBANR1'
     C                   PARM                    @@RTCD            7
     C                   PARM                    @@CHAR            1
     C                   PARM                    @@DIGT            2
     C     @@RTCD        IFNE      *BLANKS
     C                   MOVE      @@RTCD        P@RTCD
     C                   RETURN
     C                   ENDIF
     C                   MOVEL     @@DIGT        WIBA1(1)
     C                   MOVE      @@DIGT        WIBA1(2)
      * 2nd Char
     C                   MOVE      ICNTY         @@CHAR
     C                   CALLB     'AOIBANR1'
     C                   PARM                    @@RTCD
     C                   PARM                    @@CHAR
     C                   PARM                    @@DIGT
     C     @@RTCD        IFNE      *BLANKS
     C                   MOVE      @@RTCD        P@RTCD
     C                   RETURN
     C                   ENDIF
     C                   MOVEL     @@DIGT        WIBA1(3)
     C                   MOVE      @@DIGT        WIBA1(4)
      *
      * Convert any other characters
     C                   Z-ADD     3             WIPOS             2 0          :Pos. Input
     C                   Z-ADD     5             WOPOS             2 0          :Pos. Output
     C     WIPOS         DOWLE     34
     C     IIBAN(WIPOS)  ANDNE     *BLANKS
      *
     C                   MOVE      IIBAN(WIPOS)  @@CHAR
     C     @@CHAR        SCAN      CDIGIT                                 30
     C     *IN30         IFEQ      *ON
     C                   MOVE      @@CHAR        WIBA1(WOPOS)
     C                   ADD       1             WOPOS
     C                   ELSE
     C                   CALLB     'AOIBANR1'
     C                   PARM                    @@RTCD
     C                   PARM                    @@CHAR
     C                   PARM                    @@DIGT
     C     @@RTCD        IFNE      *BLANKS
     C                   MOVE      @@RTCD        P@RTCD
     C                   RETURN
     C                   ENDIF
     C                   MOVEL     @@DIGT        WIBA1(WOPOS)
     C                   ADD       1             WOPOS
     C                   MOVE      @@DIGT        WIBA1(WOPOS)
     C                   ADD       1             WOPOS
     C                   ENDIF
      *
     C                   ADD       1             WIPOS
     C                   ENDDO
      *
      * Calculate Length of IBAN field
     C                   SUB       1             WIPOS
     C                   SUB       1             WOPOS
      *
      * Move Country Code and Check Digits to end of IBAN
     C                   Z-ADD     1             X                 2 0
     C     WOPOS         SUB       5             Y                 2 0
     C     X             DOWLE     6
     C                   MOVE      WIBA1(X)      WIBA2(Y)
     C                   ADD       1             X
     C                   ADD       1             Y
     C                   ENDDO
     C                   Z-ADD     1             Y
     C     X             DOWLE     WOPOS
     C                   MOVE      WIBA1(X)      WIBA2(Y)
     C                   ADD       1             X
     C                   ADD       1             Y
     C                   ENDDO
      *
      * Replace Check Digits with zeros
     C     WOPOS         SUB       1             X
     C                   MOVE      '0'           WIBA2(X)
     C                   ADD       1             X
     C                   MOVE      '0'           WIBA2(X)
      *
      * Process sets of 9 characters
     C                   Z-ADD     WOPOS         WCOUNT            2 0
     C                   Z-ADD     0             WSECNM
     C                   MOVE      WIBA2(1)      SECT(1)
     C                   MOVE      WIBA2(2)      SECT(2)
     C                   MOVEL     WIBA2(1)      WDIGITA
     C                   MOVE      WIBA2(2)      WDIGITA
     C                   Z-ADD     3             X
     C                   Z-ADD     1             Y
     C     X             DOWLE     WCOUNT
     C                   MOVE      WIBA2(X)      WIBA2(Y)
     C                   ADD       1             X
     C                   ADD       1             Y
     C                   ENDDO
     C                   SUB       2             WCOUNT
     C     WCOUNT        DOWGE     7
     C                   MOVE      WIBA2(1)      SECT(3)
     C                   MOVE      WIBA2(2)      SECT(4)
     C                   MOVE      WIBA2(3)      SECT(5)
     C                   MOVE      WIBA2(4)      SECT(6)
     C                   MOVE      WIBA2(5)      SECT(7)
     C                   MOVE      WIBA2(6)      SECT(8)
     C                   MOVE      WIBA2(7)      SECT(9)
      *     Process Section
     C                   EXSR      SECPRC
     C     WCOUNT        IFGT      7
     C                   Z-ADD     8             X
     C                   Z-ADD     1             Y
     C     X             DOWLE     WCOUNT
     C                   MOVE      WIBA2(X)      WIBA2(Y)
     C                   ADD       1             X
     C                   ADD       1             Y
     C                   ENDDO
     C                   ENDIF
     C                   SUB       7             WCOUNT
     C                   ENDDO
      *
      * Process last set of numbers
     C     WCOUNT        IFGT      0
     C                   Z-ADD     0             WSECNM
     C     10            SUB       WCOUNT        X
     C                   Z-ADD     1             Y
     C     X             DOWLE     9
     C                   MOVE      WIBA2(Y)      SECT(X)
     C                   ADD       1             X
     C                   ADD       1             Y
     C                   ENDDO
     C     8             SUB       WCOUNT        X
     C                   MOVEL     WDIGITA       SECT(X)
     C                   ADD       1             X
     C                   MOVE      WDIGITA       SECT(X)
      *     Process Section
     C                   EXSR      SECPRC
     C                   ENDIF
      *
      * Calculate Check digit
     C     98            SUB       WDIGITN       WCKDGN
     C     WCKDGN        IFGT      9
     C                   Z-ADD     WCKDGN        WOCKDGN           2 0
     C                   ELSE
     C                   MOVEL     '0'           WOCKDGA
     C                   MOVE      WCKDGA        WOCKDGA
     C                   ENDIF
      *
      * Check Check digit
     C     IACTN         IFEQ      'V'
     C     WSVDGN        IFNE      WOCKDGN
     C                   MOVE      '*DIGIT'      P@RTCD
     C                   ENDIF
     C                   ENDIF
      *
      * Format Return Fields
     C                   MOVE      *BLANKS       OBBAN
     C                   Z-ADD     1             X
     C                   Z-ADD     5             Y
     C     Y             DOWLE     WIPOS
     C                   MOVE      IIBAN(Y)      OBBAN(X)
     C                   ADD       1             X
     C                   ADD       1             Y
     C                   ENDDO
      *     Set Character 1 to 2 of Output IBAN to the ISO Country Code
     C                   MOVEL     ICNTY         OIBAN(1)
     C                   MOVE      ICNTY         OIBAN(2)
      *     Set Character 3 to 4 of Output IBAN to the Check Digit
     C                   MOVEL     WOCKDGA       OIBAN(3)
     C                   MOVE      WOCKDGA       OIBAN(4)
     C                   MOVE      WOCKDGA       OCKDG
      *     Set the other characters to the BBAN number
     C                   Z-ADD     1             X
     C                   Z-ADD     5             Y
     C     Y             DOWLE     WIPOS
     C                   MOVE      OBBAN(X)      OIBAN(Y)
     C                   ADD       1             X
     C                   ADD       1             Y
     C                   ENDDO
     C*
     C                   SETON                                        LR
     C                   RETURN
      /EJECT
      *****************************************************************
      *
      *    SECPRC - Section Process
      *
      *    CALLED BY: MAIN    - Main Processing
      *    CALLS    :
      *
      ********************************************************************
      *
     C     SECPRC        BEGSR
     C     WSECNM        DIV       97            WK1               9 0
     C                   MULT      97            WK1
     C     WSECNM        SUB       WK1           WDIGITN
     C                   MOVE      '0'           SECT
     C     WDIGITN       IFGT      9
     C                   MOVEL     WDIGITA       SECT(1)
     C                   MOVE      WDIGITA       SECT(2)
     C                   ELSE
     C                   MOVE      WDIGITA       SECT(2)
     C                   ENDIF
     C                   ENDSR
      *
      ********************************************************************
**CTDATA CPY@
(c) Finastra International Limited 2001
