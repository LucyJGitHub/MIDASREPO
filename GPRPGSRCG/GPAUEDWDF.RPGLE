     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2003')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas GP Edit Word Defaulting')
      *****************************************************************
      *                                                               *
      *  Midas - Global Processing Module                             *
      *                                                               *
      *  GPAUEDWDF - Edit Word Defaulting                             *
      *                                                               *
      *  (c) Finastra International Limited 2003                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. CGP004  *CREATE    Date 23May03               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CGP004 - Audit Reporting                                     *
      *                                                               *
      *****************************************************************
 
     D InvCom          S              1    DIM(1) CTDATA PERRCD(1)
     D #_IEDTW         S              1    DIM(26) ASCEND
     D #_OEDTW         S              1    DIM(26) ASCEND
 
 
      * Digits can't be greater than 17
 
     C     I#DIG         IFGT      17
     C                   Z-ADD     17            NoOfDigits        4 0
     C                   ELSE
     C                   Z-ADD     I#DIG         NoOfDigits
     C                   ENDIF
 
      * Digits can't be less than number of decimal places
 
     C     NoOfDigits    IFLT      I#NBDP
     C                   Z-ADD     0             NoOfDecPls        1 0
     C                   ELSE
     C                   Z-ADD     I#NBDP        NoOfDecPls
     C                   ENDIF
 
      * If packed format
 
     C     I#TYPE        IFEQ      'P'
 
      * Set edit word according to number of decimal places
 
     C                   MOVE      *BLANK        #_IEDTW
     C                   EXSR      P_SET_EDTW
 
      * Add commas to edit word
 
     C                   MOVE      *BLANK        #_OEDTW
     C                   EXSR      P_ADD_EDTW
 
     C                   ELSE
 
      * Set edit word according to number of decimal places
 
     C                   MOVE      *BLANK        #_OEDTW
     C                   EXSR      S_SET_EDTW
 
     C                   ENDIF
 
 
      * Output
 
     C                   Z-ADD     1             X
     C     *BLANK        LOOKUP    #_OEDTW(X)                         99        *
     C                   MOVEL     *BLANK        #OEDTW
     C                   MOVEA     #_OEDTW(X)    #OEDTW
 
     C                   RETURN
 
      /SPACE 5
      ****************************************************************
      * Set edit word according to number of decimal places
      ****************************************************************
     C     P_SET_EDTW    BEGSR
 
      * Start character
     C                   Z-ADD     1             X                 3 0
     C                   MOVEA     InvCom(1)     #_IEDTW(X)
 
     C     NoOfDecPls    IFEQ      0
 
      * ZERO d.p.
 
     C     NoOfDigits    ADD       1             X
     C                   MOVEA     '0'           #_IEDTW(X)
     C     NoOfDigits    ADD       2             X
     C                   MOVEA     '-'           #_IEDTW(X)
     C     NoOfDigits    ADD       3             X
 
     C                   ELSE
     C     NoOfDigits    IFNE      NoOfDecPls
 
      * NON-ZERO d.p.  and field size <> number of d.p.
 
     C     NoOfDigits    SUB       NoOfDecPls    X
     C                   ADD       1             X
     C                   MOVEA     '0'           #_IEDTW(X)
     C                   ADD       1             X
     C                   MOVEA     '.'           #_IEDTW(X)
     C     NoOfDigits    ADD       3             X
     C                   MOVEA     '-'           #_IEDTW(X)
     C     NoOfDigits    ADD       4             X
 
     C                   ELSE
 
      * NON-ZERO d.p.  and field size = number of d.p.
 
     C                   ADD       1             X
     C                   MOVEA     '.'           #_IEDTW(X)
     C     NoOfDigits    ADD       3             X
     C                   MOVEA     '-'           #_IEDTW(X)
     C     NoOfDigits    ADD       4             X
 
     C                   ENDIF
     C                   ENDIF
      * End character
     C                   MOVEA     InvCom(1)     #_IEDTW(X)
 
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      ****************************************************************
      * Add commas to edit word
      ****************************************************************
     C     P_ADD_EDTW    BEGSR
 
     C                   MOVE      'N'           Decimal_Place     1
 
     C                   Z-ADD     26            Y                 3 0
     C                   Z-ADD     0             D                 1 0
 
      * Count down from end character
 
     C     X             DOUEQ     0
 
     C     #_IEDTW(X)    IFEQ      '.'
     C     NoOfDecPls    OREQ      0
     C                   MOVE      'Y'           Decimal_Place
     C                   ENDIF
 
     C     D             IFEQ      3
     C     X             ANDGT     1
     C                   MOVE      ','           #_OEDTW(Y)
     C                   SUB       1             Y
     C                   Z-ADD     0             D
     C                   ENDIF
     C
     C     Decimal_Place IFEQ      'Y'
     C     #_IEDTW(X)    IFEQ      '0'
     C     #_IEDTW(X)    OREQ      ' '
     C                   ADD       1             D
     C                   ENDIF
     C                   ENDIF
 
     C                   MOVE      #_IEDTW(X)    #_OEDTW(Y)
     C                   SUB       1             X
     C                   SUB       1             Y
 
     C                   ENDDO
 
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      ********************************************************************
      * Set edit word according to number of decimal places
      ********************************************************************
     C     S_SET_EDTW    BEGSR
 
      * Start character
     C                   Z-ADD     1             X
     C                   MOVEA     InvCom(1)     #_OEDTW(X)
 
     C     NoOfDecPls    IFEQ      0
 
      * ZERO d.p.
 
     C                   MOVEA     '0'           #_OEDTW(2)
     C     NoOfDigits    ADD       2             X
     C                   MOVEA     '-'           #_OEDTW(X)
     C                   ADD       1             X
 
     C                   ELSE
     C     NoOfDigits    IFNE      NoOfDecPls
 
      * NON-ZERO d.p.  and field size <> number of d.p.
 
     C                   MOVEA     '0'           #_OEDTW(2)
     C     NoOfDigits    SUB       NoOfDecPls    X
     C                   ADD       2             X
     C                   MOVEA     '.'           #_OEDTW(X)
     C     NoOfDigits    ADD       3             X
     C                   MOVEA     '-'           #_OEDTW(X)
     C     NoOfDigits    ADD       4             X
     C                   ELSE
 
      * NON-ZERO d.p.  and field size = number of d.p.
 
     C                   MOVEA     '.'           #_OEDTW(2)
     C     NoOfDigits    ADD       3             X
     C                   MOVEA     '-'           #_OEDTW(X)
     C     NoOfDigits    ADD       4             X
 
     C                   ENDIF
     C                   ENDIF
      * End character
     C                   MOVEA     InvCom(1)     #_OEDTW(X)
 
     C                   ENDSR
      ********************************************************************
      /SPACE 5
      ********************************************************************
      * *INZSR --- INITIAL PROCESSING
      ********************************************************************
     C     *INZSR        BEGSR
 
     C* PARAMETER LIST
 
     C     *ENTRY        PLIST
     C                   PARM                    I#RTCD            7
     C                   PARM                    I#ERMS           50
      * INPUT
     C                   PARM                    I#TYPE            1
     C                   PARM                    I#DIG             4 0
     C                   PARM                    I#NBDP            1 0
      * OUTPUT
     C                   PARM                    #OEDTW           26
     C                   ENDSR
      ********************************************************************
      /SPACE 5
      ********************************************************************
      * * P S S R  --- A B N O R M A L   E R R O R   C O N D I T I O N S
      /COPY GPCPYSRCG,GPPSSR
      *****************************************************************
** InvCom
'
