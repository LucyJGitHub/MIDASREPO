     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2003')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas GP Audit Field Contents - Retrieval')
      *****************************************************************
      *                                                               *
      *  Midas - Global Processing Module                             *
      *                                                               *
      *  GPAUFCRTL - Audit Field Contents - Retrieval                 *
      *                                                               *
      *  (c) Finastra International Limited 2003                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. CSD031             Date 10Apr06               *
      *                 CGP004  *CREATE    Date 23May03               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CGP004 - Audit Reporting                                     *
      *                                                               *
      *****************************************************************
 
 
     D BIT             S              2  0 DIM(16) CTDATA PERRCD(16)
     D ALP             S              1    DIM(16) CTDATA PERRCD(16)
 
 
      * Field Attributes
      * Field Shortnames
     D/COPY GPCPYSRCG,GPAUFDATB
     D/COPY GPCPYSRCG,GPAUFDSNM
 
 
      * Field Contents
     D/COPY GPCPYSRCG,GPAUFDCON
 
 
     D IN              S              1    DIM(4000)
     D OUT             S              1    DIM(100) ASCEND
     D OUTW            S              1    DIM(100)
 
     D BlankArr        S              1    DIM(100)
 
 
     D InvCom          S              1    DIM(1) CTDATA PERRCD(1)
     D #_EDTW          S              1    DIM(26) ASCEND
 
 
      * Currency Details
     D GPCURR        E DS                  EXTNAME(GPCURRPD)
 
      * Clear outputs
 
     C                   MOVEL     *BLANK        #_FDCON
 
      * Input record
 
     C                   MOVEA     InRecord      IN
 
      * Loop through all fields
      * Extract the contents of each field
 
     C                   Z-ADD     1             #FD               5 0
     C     #FD           DOWLE     250
     C     #_FDATRB(#FD) ANDNE     *BLANK
     C                   MOVEL     #_FDATRB(#FD) #FDATRB
     C                   EXSR      EXTR_CONTENTS
     C                   MOVEA     OUT           #_FDCON(#FD)
     C                   ADD       1             #FD
     C                   ENDDO
 
      * Loop through all fields
      * Edit the contents of each field
 
     C                   Z-ADD     1             #FD
     C     #FD           DOWLE     250
     C     #_FDATRB(#FD) ANDNE     *BLANK
     C                   MOVEL     #_FDATRB(#FD) #FDATRB
     C     AFEDTW        IFNE      *BLANK
     C                   MOVEA     #_FDCON(#FD)  OUT
     C                   EXSR      EDIT_CONTENTS
     C                   MOVEA     OUT           #_FDCON(#FD)
     C                   ENDIF
     C                   ADD       1             #FD
     C                   ENDDO
 
 
     C                   RETURN
 
      ****************************************************************
      * Extract contents of audit field
      ****************************************************************
     C     EXTR_CONTENTS BEGSR
 
     C                   Z-ADD     AFFOBO        InPos             4 0
     C                   Z-ADD     1             OutPos            4 0
     C                   MOVEL     *BLANK        OUT
 
      * ALPHAMERIC
 
     C     AFTYPE        IFEQ      'A'
     C                   EXSR      ALPHAMERIC
     C                   END
 
      * PACKED NUMERIC
 
     C     AFTYPE        IFEQ      'P'
     C                   EXSR      PACKEDNUMERIC
     C                   END
 
      * SIGNED NUMERIC
 
     C     AFTYPE        IFEQ      'S'
     C                   EXSR      SIGNEDNUMERIC
     C                   END
 
      * Blank out all characters after field
 
     C     OutPos        IFLE      100
     C                   MOVEA     BlankArr      OUT(OutPos)
     C                   END
 
     C                   ENDSR
      *****************************************************************
      * Edit contents of audit field
      ****************************************************************
     C     EDIT_CONTENTS BEGSR
 
     C                   SELECT
 
      * No editing
      * ==========
 
     C     AFEDTW        WHENEQ    '*NONE'
 
      * Edit word is user-defined
      * =========================
 
     C     AFEDTW_1Char  WHENEQ    InvCom(1)
 
      * Put data into edit word
 
     C                   MOVEA     AFEDTW        #_EDTW
     C                   EXSR      PUT_INTO_EDTW
 
      * Date editing
      * ============
 
     C     AFEDTW        WHENEQ    '*DATE'
     C                   MOVEA     OUT           Work5A            5
     C                   TESTN                   Work5A               9798
     C     *IN97         IFEQ      *ON
     C     *IN98         OREQ      *ON
     C                   MOVEL     WORK5A        ZDAYNO
     C                   CALL      'ZDATE2'
     C                   PARM                    ZDAYNO            5 0
     C                   PARM      'M'           BJDFIN            1
     C                   PARM                    ZDATE             6 0
     C                   PARM                    ZADATE            7
     C                   MOVEA     ZADATE        OUT
     C                   ENDIF
 
      * Base Currency editing
      * =====================
 
     C     AFEDTW        WHENEQ    '*BASE'
 
     C                   Z-ADD     BaseCcyDP     NoOfDecPls
 
      * Default edit word according to number of decimal places
 
     C                   EXSR      DFT_EDTW
 
      * Put data into edit word
 
     C                   EXSR      PUT_INTO_EDTW
 
      * Edit word is an RPG field name
      * ==============================
 
     C                   OTHER
 
      * Get value of RPG field
 
     C                   Z-ADD     1             #FDI              4 0
     C     EditRPGName   LOOKUP    #_FDSNAM(#FDI)                         99    *
     C     *IN99         IFEQ      *ON
     C                   MOVEA     #_FDCON(#FDI) OUTW
 
      * If field is numeric it is a number of decimal places
      * Otherwise field is a currency, so get those currency decimal places
 
     C                   MOVEL     OUTW(1)       Work2A            2
     C                   TESTN                   Work2A               9798
     C     *IN97         IFEQ      *ON
     C     *IN98         OREQ      *ON
     C                   MOVEL     OUTW(1)       NoOfDecPls        1 0
     C                   ELSE
     C                   MOVEA     OUTW(1)       Currency          3
     C                   EXSR      ACS_CURR
     C                   Z-ADD     GCNBDP        NoOfDecPls
     C                   ENDIF
 
      * Default edit word according to number of decimal places
 
     C                   EXSR      DFT_EDTW
 
      * Put data into edit word
 
     C                   EXSR      PUT_INTO_EDTW
     C                   ENDIF
 
     C                   ENDSL
 
     C                   ENDSR
      ****************************************************************
      /SPACE 5
      ****************************************************************
      * Default edit word according to number of decimal places
      ****************************************************************
     C     DFT_EDTW      BEGSR
 
     C                   CALLB     'GPAUEDWDF'
     C                   PARM      *BLANK        I#RTCD            7
     C                   PARM      *BLANK        I#ERMS           50
      * INPUT
     C                   PARM      'P'           I#TYPE            1
     C                   PARM      AFDIG         I#DIG             4 0
     C                   PARM      NoOfDecPls    I#NBDP            1 0
      * OUTPUT
     C                   PARM      *BLANK        #OEDTW           26
      * Edit word
     C                   MOVEA     #OEDTW        #_EDTW
      * Error
     C     I#RTCD        IFNE      *BLANK
     C                   EVAL      I#ERMS = 'BAD EDIT WORD:' + AFSNAM
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      ****************************************************************
      * Put data into edit word
      ****************************************************************
     C     PUT_INTO_EDTW BEGSR
 
      * Position to end of edit word
 
     C                   Z-ADD     2             X                 3 0
     C     InvCom(1)     LOOKUP    #_EDTW(X)                              99
     C                   SUB       1             X
 
      * Position to sign
 
     C                   Z-ADD     1             Y                 3 0
     C     '-'           LOOKUP    OUT(Y)                                 99
     C  N99' '           LOOKUP    OUT(Y)                                 99
 
      * Move sign into edit word if required
 
     C     #_EDTW(X)     IFEQ      '-'
     C                   MOVE      OUT(Y)        #_EDTW(X)
     C                   SUB       1             X
     C                   ENDIF
     C                   SUB       1             Y
 
      * Position to first non-zero byte
 
     C                   Z-ADD     1             ZX                3 0
     C     '0'           LOOKUP    #_EDTW(ZX)                             99
     C  N99              Z-ADD     999           ZX
     C                   Z-ADD     1             ZY                3 0
     C     '0'           LOOKUP    OUT(ZY)                            99
     C  N99              Z-ADD     999           ZY
 
      * Loop down through edit word putting data into it
 
     C     X             DOWGT     1
     C     #_EDTW(X)     IFEQ      *BLANK
     C     #_EDTW(X)     OREQ      '0'
     C     X             IFGE      ZX
     C     Y             ORGE      ZY
     C                   MOVE      OUT(Y)        #_EDTW(X)
     C                   SUB       1             Y
     C                   ENDIF
     C                   ELSE
     C     Y             IFLT      ZY
     C     #_EDTW(X)     ANDNE     '.'
     C                   MOVE      *BLANK        #_EDTW(X)
     C                   ENDIF
     C                   ENDIF
     C                   SUB       1             X
     C                   ENDDO
 
      * Remove inverted commas
 
     C                   MOVE      *BLANK        OUT
     C                   MOVEA     #_EDTW(2)     OUT
     C                   Z-ADD     1             X
     C     InvCom(1)     LOOKUP    OUT(X)                                 99
     C                   MOVE      *BLANK        OUT(X)
 
      * Convert an all-zero field to blank
 
     C     ZY            IFEQ      999
     C     #_EDTW(2)     ANDEQ     '0'
     C                   MOVE      *BLANK        OUT
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      ****************************************************************
      * Access Currency Decimal Places
      ****************************************************************
     C     ACS_CURR      BEGSR
 
     C                   CALLB     'GPACSCURR'
     C                   PARM      *BLANK        I#RTCD            7
     C                   PARM      *BLANK        I#ERMS           50
      * INPUT
      * Currency code
     C                   PARM      Currency      I#CURR            3
      * OUTPUT
      * Currency details
     C                   PARM                    GPCURR
      * Error
     C     I#RTCD        IFNE      *BLANK
     C                   EVAL      I#ERMS = 'BAD CURRENCY:' + I#CURR
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      * Alphameric fields
      *****************************************************************
     C     ALPHAMERIC    BEGSR
     C                   MOVEA     IN(InPos)     OUT(OutPos)
     C                   ADD       AFLEN         OutPos
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * Packed numeric fields
      *****************************************************************
     C     PACKEDNUMERIC BEGSR
 
     C                   Z-ADD     *ZERO         NoOfDigits        4 0
     C     NoOfDigits    DOWLT     AFDIG
     C                   MOVEA     IN(InPos)     FLD               1
     C                   EXSR      DECON_PACKED
     C                   MOVE      FLD1          OUT(OutPos)
     C                   ADD       1             OutPos
     C                   ADD       1             NoOfDigits
     C     NoOfDigits    IFLT      AFDIG
     C                   MOVE      FLD2          OUT(OutPos)
     C                   ADD       1             OutPos
     C                   ADD       1             NoOfDigits
     C                   ELSE
     C                   SUB       1             OutPos
     C     OUT(OutPos)   IFEQ      *BLANK
     C                   MOVEL     '0'           OUT(OutPos)
     C                   END
     C                   ADD       1             OutPos
     C                   MOVEL     SIGN          OUT(OutPos)
     C                   ADD       1             OutPos
     C                   END
     C                   ADD       1             InPos
     C                   ENDDO
 
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * Decontruct packed byte
      *****************************************************************
     C     DECON_PACKED  BEGSR
 
     C                   EXSR      BITSET
 
     C     CHCK1         IFLE      9
     C                   MOVEL     FLD1N         FLD1              1
     C                   ELSE
     C                   MOVEL     '*'           FLD1
     C                   END
      *
     C     CHCK2         IFLE      9
     C                   MOVEL     *BLANK        SIGN              1
     C                   MOVEL     FLD2N         FLD2              1
     C                   ELSE
     C                   MOVEL     '*'           FLD2
     C     CHCK2         IFEQ      15
     C                   MOVEL     *BLANK        SIGN
     C                   ELSE
     C                   MOVEL     '-'           SIGN
     C                   END
     C                   END
 
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * Signed numeric fields
      *****************************************************************
     C     SIGNEDNUMERIC BEGSR
 
     C                   Z-ADD     *ZERO         NoOfDigits        4 0
 
     C     NoOfDigits    DOWLT     AFLEN
     C                   MOVEA     IN(InPos)     FLD               1
     C                   EXSR      DECON_SIGNED
     C                   MOVE      FLD2          OUT(OutPos)
     C                   ADD       1             OutPos
     C                   ADD       1             NoOfDigits
     C     NoOfDigits    IFEQ      AFLEN
     C                   SUB       1             OutPos
     C     OUT(OutPos)   IFEQ      *BLANK
     C                   MOVEL     '0'           OUT(OutPos)
     C                   END
     C                   ADD       1             OutPos
     C                   MOVEL     SIGN          OUT(OutPos)
     C                   ADD       1             OutPos
     C                   END
     C                   ADD       1             InPos
     C                   ENDDO
 
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * Decontruct signed byte
      *****************************************************************
     C     DECON_SIGNED  BEGSR
 
     C                   EXSR      BITSET
      *
     C     CHCK1         IFEQ      15
     C                   MOVEL     *BLANK        SIGN
     C                   ELSE
     C                   MOVEL     '-'           SIGN
     C                   END
      *
     C     CHCK2         IFLE      9
     C                   MOVEL     FLD2N         FLD2              1
     C                   ELSE
     C                   MOVEL     '*'           FLD2
     C                   END
      *
     C                   ENDSR
      *****************************************************************
      * Bit Settings
      *****************************************************************
     C     BITSET        BEGSR
     C                   Z-ADD     *ZERO         FLD1N
     C                   Z-ADD     *ZERO         CHCK1
     C                   Z-ADD     *ZERO         FLD2N
     C                   Z-ADD     *ZERO         CHCK2
      *
     C                   TESTB     '0'           FLD                      30
     C     *IN30         IFEQ      '1'
     C                   ADD       8             FLD1N             1 0
     C                   ADD       8             CHCK1             2 0
     C                   END
      *
     C                   TESTB     '1'           FLD                      30
     C     *IN30         IFEQ      '1'
     C                   ADD       4             FLD1N
     C                   ADD       4             CHCK1
     C                   END
      *
     C                   TESTB     '2'           FLD                      30
     C     *IN30         IFEQ      '1'
     C                   ADD       2             FLD1N
     C                   ADD       2             CHCK1
     C                   END
      *
     C                   TESTB     '3'           FLD                      30
     C     *IN30         IFEQ      '1'
     C                   ADD       1             FLD1N
     C                   ADD       1             CHCK1
     C                   END
      *
     C                   TESTB     '4'           FLD                      30
     C     *IN30         IFEQ      '1'
     C                   ADD       8             FLD2N             1 0
     C                   ADD       8             CHCK2             2 0
     C                   END
      *
     C                   TESTB     '5'           FLD                      30
     C     *IN30         IFEQ      '1'
     C                   ADD       4             FLD2N
     C                   ADD       4             CHCK2
     C                   END
      *
     C                   TESTB     '6'           FLD                      30
     C     *IN30         IFEQ      '1'
     C                   ADD       2             FLD2N
     C                   ADD       2             CHCK2
     C                   END
      *
     C                   TESTB     '7'           FLD                      30
     C     *IN30         IFEQ      '1'
     C                   ADD       1             FLD2N
     C                   ADD       1             CHCK2
     C                   END
      *
     C                   Z-ADD     1             BS                2 0
     C     CHCK1         LOOKUP    BIT(BS)                                99    *
     C                   MOVEL     ALP(BS)       FLD1A             1
     C                   Z-ADD     1             BS
     C     CHCK2         LOOKUP    BIT(BS)                                99    *
     C                   MOVEL     ALP(BS)       FLD2A             1
      *
     C                   ENDSR
      *****************************************************************
     C/SPACE 5
      ********************************************************************
      * *INZSR --- INITIAL PROCESSING
      ********************************************************************
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
     C                   PARM                    I#RTCD            7
     C                   PARM                    I#ERMS           50
      * INPUT
      * Base Currency
     C                   PARM                    I#BCCY            3
      * Record
      * Field Attributes
      * Field Shortnames
     C                   PARM                    InRecord       4000
     C                   PARM                    #_FDATRB
     C                   PARM                    #_FDSNAM
 
      * OUTPUT
      * Field Contents
     C                   PARM                    #_FDCON
 
     C                   MOVEL     I#BCCY        Currency          3
     C                   EXSR      ACS_CURR
     C                   Z-ADD     GCNBDP        BaseCcyDP         1 0
 
     C                   ENDSR
      ********************************************************************
      /SPACE 5
      ********************************************************************
      * * P S S R  --- A B N O R M A L   E R R O R   C O N D I T I O N S
      /COPY GPCPYSRCG,GPPSSR
      *****************************************************************
** BIT
00010203040506070809101112131415
** ALP
0123456789ABCDEF
** InvCom
'
