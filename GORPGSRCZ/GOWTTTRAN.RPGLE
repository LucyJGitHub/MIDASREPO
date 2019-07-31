     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2003')
      *****************************************************************
/*XBIA*  OVRDBF FILE(MARKTXX) TOFILE(MARKT)   SHARE(*NO)              *
/*XBIB*  OVRDBF FILE(INTYPXX) TOFILE(INTYP)   SHARE(*NO)              *
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas GO Write to TRAP - FF Transactions')             *
      *****************************************************************
      *                                                               *
      *  Midas - Global Processing Module                             *
      *                                                               *
      *  GOWTTTRAN - Write to TRAP - FF Transactions                  *
      *                                                               *
      *  (c) Finastra International Limited 2003                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CAP208             Date 06Dec10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD027             Date 09Dec05               *
      *                 BUG3860            Date 11Aug04               *
      *                 CGP001  *CREATE    Date 23May03               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CAP208 - F&O Market Instrument API (Recompile)               *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  BUG3860 - (recompile)                                        *
      *  CGP001 - Global Processing                                   *
      *                                                               *
      *****************************************************************
 
     FMARKTXX   IF   E           K DISK    INFSR(*PSSR) USROPN PREFIX(MK_)
     FINTYPXX   IF   E           K DISK    INFSR(*PSSR) USROPN PREFIX(IN_)
 
     D/COPY ZACPYSRC,STD_D_SPEC
 
 
      ** T R A N S A C T I O N    D E T A I L S
     D T_TRAP        E DS                  EXTNAME(GPTRAPPD)
 
 
     D TRANS         E DS                  EXTNAME(TRANSD)
     D MARKTX        E DS                  EXTNAME(MARKTD)  PREFIX(MK_)
     D INTYPX        E DS                  EXTNAME(INTYPD)  PREFIX(IN_)
 
 
     D*W#CBCD***       S              6S 0                                                    CSD027
     D W#CBCD          S              6A                                                      CSD027
 
 
      ** Overrides
     D ##OV1           S              1    DIM(60) CTDATA PERRCD(60)
     D ##OV2           S              1    DIM(60) CTDATA PERRCD(60)
 
 
      * ENTRY PARAMETERS
 
     C     *ENTRY        PLIST
     C                   PARM                    I#RTCD            7            * RETURN CODE
     C                   PARM                    I#ERMS           50            * ERROR MESSAGE
     C                   PARM                    I#BIMG         4000
     C                   PARM                    I#AIMG         4000
 
      * Override/open files
 
     C     InstFilesOpen IFNE      'Y'
     C                   CALL      'QCMDEXC'     OV1_Parm
     C                   CALL      'QCMDEXC'     OV2_Parm
     C                   OPEN      MARKTXX
     C                   OPEN      INTYPXX
     C                   MOVEL     'Y'           InstFilesOpen     1
     C                   ENDIF
 
      * Universal Transaction Updates
 
     C                   EXSR      TRAP_TRAN
 
     C                   RETURN
 
      /SPACE 5
      ********************************************************************
      * Universal Transaction Updates - FF transactions
      ********************************************************************
     C     TRAP_TRAN     BEGSR
 
     C                   MOVEL     I#AIMG        TRANS
 
      * Access instrument details
 
     C                   EXSR      ACS_INSTRUMNT
 
      * SETUP TRANSACTION INDEX RECORD (book positions)
      * WRITE TRANSACTION INDEX RECORD
 
     C                   EXSR      SETUP_TRAPFBPS
     C                   EXSR      WRITE_TRAP
 
      * SETUP TRANSACTION INDEX RECORD (customer positions)
      * WRITE TRANSACTION INDEX RECORD
 
     C*****CUSC*         IFNE      0                                                          CSD027
     C**********         Z-ADD     CUSC          W#CBCD                                       CSD027
     C     CUSC          IFNE      *BLANKS                                                    CSD027
     C                   EVAL      W#CBCD = CUSC                                              CSD027
     C                   EXSR      SETUP_TRAPFCPS
     C                   EXSR      WRITE_TRAP
     C                   ENDIF
 
      * SETUP TRANSACTION INDEX RECORD (customer positions)
      * WRITE TRANSACTION INDEX RECORD
 
     C*****BOCO*         IFNE      0                                                          CSD027
     C**********         Z-ADD     BOCO          W#CBCD                                       CSD027
     C     BOCO          IFNE      *BLANKS                                                    CSD027
     C                   EVAL      W#CBCD = BOCO                                              CSD027
     C                   EXSR      SETUP_TRAPFCPS
     C                   EXSR      WRITE_TRAP
     C                   ENDIF
 
     C                   ENDSR
      ********************************************************************
     C/SPACE 5
      ********************************************************************
      * SETUP TRANSACTION INDEX RECORD
      ********************************************************************
     C     SETUP_TRAPFBPSBEGSR
      *
     C                   CALLB     'GOSETFBPS'
     C                   PARM      *BLANK        W#RTCD            7            * RETURN CODE
     C                   PARM      *BLANK        W#ERMS           50            * ERROR MESSAGE
      * INPUTS
     C                   PARM                    BRCA
     C                   PARM                    BOKC
     C                   PARM                    ISTT
     C                   PARM                    YRNO
     C                   PARM                    MTHN
     C                   PARM                    PCAL
     C                   PARM                    STRP
     C                   PARM                    MARKTX
     C                   PARM                    INTYPX
      * OUTPUTS
     C                   PARM                    T_TRAP
 
     C     W#RTCD        IFEQ      '*ERROR'
     C                   EVAL      I#ERMS = 'ERROR IN CALL TO GOSETFBPS'
     C                   EXSR      *PSSR
     C                   END
      *
     C                   ENDSR
      ********************************************************************
     C/SPACE 5
      ********************************************************************
      * SETUP TRANSACTION INDEX RECORD
      ********************************************************************
     C     SETUP_TRAPFCPSBEGSR
      *
     C                   CALLB     'GOSETFCPS'
     C                   PARM      *BLANK        W#RTCD            7            * RETURN CODE
     C                   PARM      *BLANK        W#ERMS           50            * ERROR MESSAGE
      * INPUTS
     C                   PARM                    BRCA
     C                   PARM                    W#CBCD
     C                   PARM                    ISTT
     C                   PARM                    YRNO
     C                   PARM                    MTHN
     C                   PARM                    PCAL
     C                   PARM                    STRP
     C                   PARM                    MARKTX
     C                   PARM                    INTYPX
      * OUTPUTS
     C                   PARM                    T_TRAP
 
     C     W#RTCD        IFEQ      '*ERROR'
     C                   EVAL      I#ERMS = 'ERROR IN CALL TO GOSETFCPS'
     C                   EXSR      *PSSR
     C                   END
      *
     C                   ENDSR
      ********************************************************************
      /SPACE 5
      *****************************************************************
      * WRITE TRANSACTION INDEX RECORD
      *****************************************************************
     C     WRITE_TRAP    BEGSR
 
      * Commitment Cycle ID
     C                   Z-ADD     0             T_CCID
 
     C                   MOVEL     'GLOB'        I#LOC
     C                   MOVEL     'Y'           I#CUSTDEFLT
 
      /COPY GOCPYSRC,GOWRTTRAP
 
     C                   ENDSR
      *****************************************************************
     C/SPACE 5
      ********************************************************************
      * Access instrument details
      ********************************************************************
     C     ACS_INSTRUMNT BEGSR
 
      * Get market details
 
     C                   CLEAR                   MARKTX
     C     MTHN          IFNE      0
     C                   MOVEL     ISTT          Market            2
     C     Market        CHAIN     MARKTDF                            99        *
     C                   ENDIF
 
      * Get instrument details
 
     C                   CLEAR                   INTYPX
     C     ISTT          CHAIN     INTYPDF                            99         *
 
     C                   ENDSR
      ********************************************************************
     C/SPACE 5
      ********************************************************************
      * *INZSR - Initial subroutine called automatically at program start
      ********************************************************************
     C     *INZSR        BEGSR
 
     C                   Z-ADD     60            MESLEN           15 5
 
      * Parameter lists
 
     C     OV1_Parm      PLIST
     C                   PARM                    ##OV1
     C                   PARM                    MESLEN
     C     OV2_Parm      PLIST
     C                   PARM                    ##OV2
     C                   PARM                    MESLEN
     C                   ENDSR
      ********************************************************************
      /SPACE 5
      ********************************************************************
      * * P S S R  --- A B N O R M A L   E R R O R   C O N D I T I O N S
      /COPY GOCPYSRC,GOPSSR
      *****************************************************************
**  CPY@
(c) Finastra International Limited 2003
** ##OV1
OVRDBF FILE(MARKTXX) TOFILE(MARKT)   SHARE(*NO)
** ##OV2
OVRDBF FILE(INTYPXX) TOFILE(INTYP)   SHARE(*NO)
