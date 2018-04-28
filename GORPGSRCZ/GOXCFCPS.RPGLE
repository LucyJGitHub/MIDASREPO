     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2003')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas GO Extract Controller for F&O Cust Positions')   *
      *****************************************************************
      *                                                               *
      *  Midas - Global Processing Module                             *
      *                                                               *
      *  GOXCFCPS - Extract Controller for F&O Customer Positions     *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2003            *
      *                                                               *
      *  Last Amend No. CAP208             Date 06Dec10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. CSD027             Date 09Dec05               *
      *                 CGP001  *CREATE    Date 23May03               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CAP208 - F&O Market Instrument API (Recompile)               *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CGP001 - Global Processing                                   *
      *                                                               *
      *****************************************************************
 
     FPOSTNC2   IF   E           K DISK    INFSR(*PSSR)
     FMARKT     IF   E           K DISK    INFSR(*PSSR) PREFIX(MK_)
     FINTYP     IF   E           K DISK    INFSR(*PSSR) PREFIX(IN_)
 
 
     D/COPY ZACPYSRC,STD_D_SPEC
 
 
     D FCPS          E DS                  EXTNAME(POSTNCD)
     D MARKTX        E DS                  EXTNAME(MARKTD)  PREFIX(MK_)
     D INTYPX        E DS                  EXTNAME(INTYPD)  PREFIX(IN_)
 
 
     C     *ENTRY        PLIST
      /COPY GOCPYSRC,GOXCEPARM
      *
      * EXTRACT ALL F&O CUSTOMER POSITIONS
      * OR EXTRACT A SINGLE F&O CUSTOMER POSITION
      *
     C     I#EXTT        IFEQ      '*ALL'
     C                   EXSR      EXTALL
     C                   SETON                                        LR
     C                   ELSE
     C                   EXSR      EXTSIN
     C                   ENDIF
      *
     C                   RETURN
      *
     C/SPACE 5
      ********************************************************************
      * EXTRACT ALL F&O CUSTOMER POSITIONS
      ********************************************************************
     C     EXTALL        BEGSR
      *
     C                   READ      POSTNCDF                               99    *
      *
      * Whilst positions can be found
      *
     C     *IN99         DOWEQ     '0'
      *
      * Extract live positions
      *
     C     RECI          IFEQ      'D'
     C                   EXSR      ACS_INSTRUMNT
     C     Extract_POSN  IFEQ      'Y'
     C                   EXSR      EXTRCT
     C                   END
     C                   END
      *
      * Read the next record
      *
     C                   READ      POSTNCDF                               99    *
     C                   END
      *
     C                   ENDSR
      ********************************************************************
     C/SPACE 5
      ********************************************************************
      * EXTRACT A SINGLE F&O CUSTOMER POSITION
      ********************************************************************
     C     EXTSIN        BEGSR
      *
     C**********         MOVEL     I#CNUM        W#CBCD            6 0                        CSD027
     C                   MOVEL     I#CNUM        W#CBCD            6                          CSD027
     C                   MOVEL     I#BRCA        W#BRCA            3
     C                   MOVEL     I#ISTT        W#ISTT            5
     C                   MOVEL     I#YRNO        W#YRNO            2 0
     C                   MOVEL     I#MTHN        W#MTHN            2 0
     C                   MOVEL     I#PCAL        W#PCAL            1
     C                   MOVEL     I#STRP        W#STRP           15 8
     C     POSTNCK       CHAIN     POSTNCDF                           99        *
      *
      * If the position is found
      * extract it
      *
     C     *IN99         IFEQ      '0'
     C                   EXSR      ACS_INSTRUMNT
     C     Extract_POSN  IFEQ      'Y'
     C                   EXSR      EXTRCT
     C                   ENDIF
     C                   ENDIF
      *
     C                   ENDSR
      ********************************************************************
     C/SPACE 5
      ********************************************************************
      * EXTRACT
      ********************************************************************
     C     EXTRCT        BEGSR
      *
     C                   CALLB     'GOXTFCPS'
     C                   PARM      *BLANK        W#RTCD            7
     C                   PARM      *BLANK        W#ERMS           50
      * INPUTS
     C                   PARM      I#LOC         W#LOC             4
     C                   PARM      I#CCID        W#CCID           10 0
 
     C                   PARM      I#RDNB        W#RDNB            5 0
     C                   PARM      I#DNWD        W#DNWD            5 0
     C                   PARM      I#PCOD        W#PCOD            5 0
 
     C                   PARM                    FCPS
     C                   PARM                    MARKTX
     C                   PARM                    INTYPX
 
      * If data error encountered, log error
 
     C     W#RTCD        IFEQ      '*ERROR '
     C                   CLEAR                   BUFFER
     C                   EVAL      BUFFER = 'FCPS' + I#EXTT + I#TREF
     C                                    + W#RTCD + W#ERMS + FCPS
     C                   CALL      'GPWRTELOG'
     C                   PARM                    BUFFER         4000
     C                   ENDIF
      *
     C                   ENDSR
      ********************************************************************
     C/SPACE 5
      ********************************************************************
      * Access instrument details
      ********************************************************************
     C     ACS_INSTRUMNT BEGSR
 
      * Extract position
 
     C                   MOVEL     'Y'           Extract_POSN      1
 
      * Get instrument details
 
     C     ISTT          CHAIN     INTYPDF                            99        *
 
      * Do not extract position if instrument not found or if deleted
 
     C     *IN99         IFEQ      '1'
     C     IN_RECI       OREQ      '*'
     C                   MOVEL     'N'           Extract_POSN
     C                   ELSE
 
      * Get market details
 
     C                   CLEAR                   MARKTX
     C     MTHN          IFNE      0
     C                   MOVEL     ISTT          Market            2
     C     Market        CHAIN     MARKTDF                            99        *
 
      * Do not extract position if market not found or if deleted
 
     C     *IN99         IFEQ      '1'
     C     MK_RECI       OREQ      '*'
     C                   MOVEL     'N'           Extract_POSN
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDSR
      ********************************************************************
      /SPACE 5
      ********************************************************************
      * *INZSR --- INITIAL PROCESSING
      ********************************************************************
     C     *INZSR        BEGSR
 
      * Get Extract control information
 
      /COPY GOCPYSRC,GOGETEXCT
 
 
      * key lists
 
     C     POSTNCK       KLIST
     C                   KFLD                    W#BRCA
     C                   KFLD                    W#CBCD
     C                   KFLD                    W#ISTT
     C                   KFLD                    W#YRNO
     C                   KFLD                    W#MTHN
     C                   KFLD                    W#PCAL
     C                   KFLD                    W#STRP
      *
     C                   ENDSR
      ********************************************************************
      /SPACE 5
      ********************************************************************
      * * P S S R  --- A B N O R M A L   E R R O R   C O N D I T I O N S
      /COPY GOCPYSRC,GOPSSR
      *****************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2003
