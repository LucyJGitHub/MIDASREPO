     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2003')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas GO Maintain event data arrays')
      *****************************************************************
      *                                                               *
      *  Midas - Global Processing Module                             *
      *                                                               *
      *  GOMNTEVDT - Maintain Event Data Arrays.                      *
      *                                                               *
      *  Function:  This module retrieves the last and next event     *
      *             dates either side of the processing date.         *
      *                                                               *
      *  (c) Finastra International Limited 2003                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. CSD027             Date 09Dec05               *
      *                 CGP001  *CREATE    Date 23May03               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CGP001 - Global Processing                                   *
      *                                                               *
      *****************************************************************
 
 
     D/COPY ZACPYSRC,STD_D_SPEC
 
      ** E V E N T    D E T A I L S
     D E_EVNT        E DS                  EXTNAME(GOWEVNTPD)
 
     D/COPY GOCPYSRC,GOEVDARRS
 
      **
      **   ENTRY PARAMETER LIST
      **
     C     *ENTRY        PLIST
     C                   PARM                    I#RTCD            7
     C                   PARM                    I#ERMS           50
 
      * INPUTS
     C                   PARM                    I#MODE           10
     C                   PARM                    I#TYPE            2
 
      * Event
     C                   PARM                    E_EVNT
 
      * Event Data Array
     C                   PARM                    #arevdt_WK
 
      * Last/next Period?
     C                   PARM                    #LN_PERIOD        1
 
      * OUTPUTS
      * Last Date
      * Next Date
     C                   PARM                    #LASTDT           5 0
     C                   PARM                    #NEXTDT           5 0
 
 
     C                   SELECT
 
      * LOG EVENT DATE
 
     C     I#MODE        WHENEQ    '*LOGEVDT'
 
     C                   EXSR      LOGEVDT
 
      * GET LAST AND NEXT EVENT DATES
 
     C     I#MODE        WHENEQ    '*GETLNEVDT'
 
     C                   EXSR      GETLNEVDT
 
     C                   ENDSL
 
      * RETURN
 
     C                   RETURN
 
      *********************************************************************
      /SPACE 5
      *********************************************************************
      ** LOG EVENT DATE
      *********************************************************************
     C     LOGEVDT       BEGSR
      *
      ** STORE PROCESSING DATE IN DATE ARRAY
      ** AND ASSOCIATED DATA IN DATA ARRAY
      *
     C                   Z-ADD     1             #I                5 0
     C     E_PRDT        LOOKUP    #_WKdat(#I)                            99     *
      *
     C     *IN99         IFEQ      '0'
     C                   Z-ADD     1             #I
     C     *ZERO         LOOKUP    #_WKdat(#I)                            99     *
     C     *IN99         IFEQ      '1'
     C                   Z-ADD     E_PRDT        #_WKdat(#I)
 
     C                   SELECT
     C     I#TYPE        WHENEQ    'IP'
     C                   MOVE      E_INTA        #_WKdta(#I)
     C     I#TYPE        WHENEQ    'IR'
     C                   MOVE      E_IRAT        #_WKdta(#I)
     C     I#TYPE        WHENEQ    'PP'
     C                   MOVE      E_CPDP        #_WKdta(#I)
     C     I#TYPE        WHENEQ    'MP'
     C                   MOVE      E_CFCT        #_WKdta(#I)
     C                   ENDSL
 
     C                   ELSE
     C                   MOVEL     '*ARFULL'     I#RTCD
     C                   ENDIF
     C                   ELSE
     C                   MOVEL     '*DUPLIC'     I#RTCD
     C                   ENDIF
      *
     C                   ENDSR
      *********************************************************************
      /SPACE 5
      *********************************************************************
      ** GET LAST AND NEXT EVENT DATES STRADDLING THE PROCESSING DATE
      *********************************************************************
     C     GETLNEVDT     BEGSR
      *
      * CHECK DATES ARRAY
      *
     C                   Z-ADD     1             #I
     C     E_PRDT        LOOKUP    #_WKdat(#I)                            99     *
      *
      * IF PROCESSING DATE IS A DATE IN THE ARRAY:
      *
     C     *IN99         IFEQ      '1'
 
      * IF LAST PERIOD WANTED
 
     C     #LN_PERIOD    IFEQ      'L'
 
      *   NEXT DATE IS THIS DATE
      *   LAST DATE IS DATE PRIOR TO THAT
     C                   Z-ADD     E_PRDT        #NEXTDT
     C                   SUB       1             #I
     C     #I            IFGT      0
     C                   Z-ADD     #_WKdat(#I)   #LASTDT
     C                   ELSE
     C                   Z-ADD     E_PRDT        #LASTDT
     C                   ENDIF
 
      * IF NEXT PERIOD WANTED
 
     C                   ELSE
 
      *   LAST DATE IS THIS DATE
      *   NEXT DATE IS DATE AFTER THAT
     C                   Z-ADD     E_PRDT        #LASTDT
     C                   ADD       1             #I
     C     #I            IFLE      ArrSizDet
     C     #_WKdat(#I)   ANDGT     0
     C                   Z-ADD     #_WKdat(#I)   #NEXTDT
     C                   ELSE
     C                   Z-ADD     E_PRDT        #NEXTDT
     C                   ENDIF
 
     C                   ENDIF
      *
      * ELSE FIND DATE AFTER PROCESSING DATE:
      *   NEXT DATE IS THIS DATE
      *   LAST DATE IS DATE PRIOR TO THAT
 
     C                   ELSE
     C                   Z-ADD     1             #I
     C     E_PRDT        LOOKUP    #_WKdat(#I)                        99         *
     C                   Z-ADD     #_WKdat(#I)   #NEXTDT
     C                   SUB       1             #I
     C     #I            IFGT      0
     C                   Z-ADD     #_WKdat(#I)   #LASTDT
     C                   ELSE
     C                   Z-ADD     E_PRDT        #LASTDT
     C                   ENDIF
     C                   ENDIF
      *
     C                   ENDSR
      *********************************************************************
      /SPACE 5
      ********************************************************************
      * * P S S R  --- A B N O R M A L   E R R O R   C O N D I T I O N S
      /COPY GOCPYSRC,GOPSSR
      *****************************************************************
**  CPY@
(c) Finastra International Limited 2003
