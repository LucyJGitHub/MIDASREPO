     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2003')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas GP Confirmation Matching Generation')
      *****************************************************************
      *                                                               *
      *  Midas - Global Processing Module                             *
      *                                                               *
      *  GOCFFEEGEN - Confirmation Matching Generation                *
      *                                                               *
      *  (c) Finastra International Limited 2003                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. BUG4562  *CREATE   Date 21Sep05               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  BUG4562 - Generate data in GPCFFEEDPD from zonal file,       *
      *            with latest sequence only                          *
      *                                                               *
      *****************************************************************
 
     FCFFEEDL0  IF A E           K DISK    INFSR(*PSSR)
     F                                     PREFIX(C_)
      *
     FGPCFFEEDL0UF A E           K DISK    INFSR(*PSSR)
 
      ** CFFEEDL0 key
     D  WCFKY          DS            16
     D  WTST1                  1      8
     D  WKEY1                  1      2
     D  WKEY2                  3      8
     D  WKEY3                  9     11
 
      /SPACE 5
 
     C     *ENTRY        PLIST
     C                   PARM                    I#RTCD            7
     C                   PARM                    I#ERMS           50
      * INPUTS
     C                   PARM                    I#ZONE           10
 
 
      * If one zone required
 
     C     I#ZONE        IFNE      *BLANK
 
      * Read the zonal file and write new records or update existing ones on the global file
     C                   EVAL      *IN96 = *OFF
 
     C     *LOVAL        SETLL     CFFEEDL0
     C                   READ      CFFEEDL0                               96
 
     C                   DOW       NOT *IN96
     C                   EVAL      WCFKY = C_IMRF
     C                   EVAL      WKEY3 = '999'
 
     C     WCFKY         SETGT     CFFEEDL0
     C                   READP     CFFEEDL0                               96
     C                   EVAL      WCFKY = C_IMRF
 
     C     CFKey         CHAIN     GPCFFEEDL0                         99
 
     C                   EXSR      SETFIELD
     C                   EVAL      CFMOD = WKEY1
     C                   EVAL      CFTRAN = WKEY2
     C                   EVAL      CFSEQ = WKEY3
     C                   EVAL      CFZONE = I#ZONE
 
     C     *IN99         IFEQ      *ON
     C                   WRITE     GPCFFEEDD0
     C                   ELSE
     C                   UPDATE    GPCFFEEDD0
     C                   ENDIF
 
     C                   READ      CFFEEDL0                               96
     C                   ENDDO
 
      * Then work backwards to identify records to be dropped from the Global File
     C                   EVAL      *IN98 = *OFF
     C     GPKey         SETLL     GPCFFEEDL0
     C     GPKey         READE     GPCFFEEDL0                             98
 
     C                   DOW       NOT *IN98
 
     C     IMRF          CHAIN     CFFEEDL0                           97
 
     C     *IN97         IFEQ      *ON
     C                   DELETE    GPCFFEEDD0
     C                   ENDIF
 
     C     GPKey         READE     GPCFFEEDL0                             98
     C                   ENDDO
 
 
     C                   ENDIF
 
     C                   SETON                                        LR
     C                   RETURN
 
      *****************************************************************
      * Set up Fields
      *****************************************************************
     C     SETFIELD      BEGSR
 
      * Setup fields
 
     C                   Z-ADD     C_DTSC        DTSC
     C                   Z-ADD     C_TMSC        TMSC
     C                   MOVEL     C_IMRF        IMRF
     C                   MOVEL     C_FRF1        FRF1
     C                   MOVEL     C_FRF2        FRF2
     C                   MOVEL     C_CPRF        CPRF
     C                   Z-ADD     C_CPSX        CPSX
     C                   MOVEL     C_BKRF        BKRF
     C                   Z-ADD     C_BKSX        BKSX
     C                   MOVEL     C_CHSN        CHSN
     C                   MOVEL     C_CNRQ        CNRQ
     C                   MOVEL     C_BRCA        BRCA
      *
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
     C/SPACE 5
      ********************************************************************
      * *INZSR - Initial subroutine called automatically at program start
      ********************************************************************
     C     *INZSR        BEGSR
 
      * Key lists
 
     C     CFKey         KLIST
     C                   KFLD                    I#ZONE
     C                   KFLD                    WKEY1
     C                   KFLD                    WKEY2
 
     C     GPKey         KLIST
     C                   KFLD                    I#ZONE
 
     C                   ENDSR
 
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * * P S S R  --- A B N O R M A L   E R R O R   C O N D I T I O N S
      /COPY GPCPYSRCG,GPPSSR
      *****************************************************************
