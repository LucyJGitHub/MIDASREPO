     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2003')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas GO Write to TRAP - FRAs & IRSs')
      *****************************************************************
      *                                                               *
      *  Midas - Global Processing Module                             *
      *                                                               *
      *  GOWTTFRIR - Write to TRAP - FRAs & IRSs                      *
      *                                                               *
      *  (c) Finastra International Limited 2003                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. CSD027             Date 09Dec05               *
      *                 CDL038             Date 10May05               *
      *                 CDL028             Date 07Feb05               *
      *                 BUG3860            Date 11Aug04               *
      *                 CGP001  *CREATE    Date 23May03               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CDL038 - Extended Deal Sub Type (Recompile)                  *
      *  CDL028 - Automatic Rate Interpolations (Recompile)           *
      *  BUG3860 - (recompile)                                        *
      *  CGP001 - Global Processing                                   *
      *                                                               *
      *****************************************************************
 
     D/COPY ZACPYSRC,STD_D_SPEC
 
 
      ** T R A N S A C T I O N    D E T A I L S
     D T_TRAP        E DS                  EXTNAME(GPTRAPPD)
 
 
     D DLSDG         E DS                  EXTNAME(DEALSDG)
 
 
      * ENTRY PARAMETERS
 
     C     *ENTRY        PLIST
     C                   PARM                    I#RTCD            7            * RETURN CODE
     C                   PARM                    I#ERMS           50            * ERROR MESSAGE
     C                   PARM                    I#BIMG         4000
     C                   PARM                    I#AIMG         4000
 
      * Universal Transaction Updates
 
     C                   MOVEL     I#AIMG        DLSDG
 
     C     DTYP          CASEQ     'FR'          TRAP_FRAS
     C     DTYP          CASEQ     'RS'          TRAP_SIRS
     C     DTYP          CASEQ     'RX'          TRAP_CIRS
     C     DTYP          CASEQ     'RP'          TRAP_CFCO
     C     DTYP          CASEQ     'RF'          TRAP_CFCO
     C     DTYP          CASEQ     'RR'          TRAP_CFCO
     C                   ENDCS
 
     C                   RETURN
 
      /SPACE 5
      ********************************************************************
      * Universal Transaction Updates - FRA
      ********************************************************************
     C     TRAP_FRAS     BEGSR
 
      * SETUP TRANSACTION INDEX RECORD
      * WRITE TRANSACTION INDEX RECORD
 
     C                   EXSR      SETUP_TRAPFRAS
     C                   EXSR      WRITE_TRAP
 
     C                   ENDSR
      ********************************************************************
      /SPACE 5
      ********************************************************************
      * Universal Transaction Updates - Single Currency Swap
      ********************************************************************
     C     TRAP_SIRS     BEGSR
 
      * SETUP TRANSACTION INDEX RECORD
      * WRITE TRANSACTION INDEX RECORD
 
     C                   EXSR      SETUP_TRAPSIRS
     C                   EXSR      WRITE_TRAP
 
     C                   ENDSR
      ********************************************************************
      /SPACE 5
      ********************************************************************
      * Universal Transaction Updates - Cross Currency Swap
      ********************************************************************
     C     TRAP_CIRS     BEGSR
 
      * SETUP TRANSACTION INDEX RECORD
      * WRITE TRANSACTION INDEX RECORD
 
     C                   EXSR      SETUP_TRAPCIRS
     C                   EXSR      WRITE_TRAP
 
     C                   ENDSR
      ********************************************************************
      /SPACE 5
      ********************************************************************
      * Universal Transaction Updates - Cap, Floor or Collar
      ********************************************************************
     C     TRAP_CFCO     BEGSR
 
      * SETUP TRANSACTION INDEX RECORD
      * WRITE TRANSACTION INDEX RECORD
 
     C                   EXSR      SETUP_TRAPCFCO
     C                   EXSR      WRITE_TRAP
 
     C                   ENDSR
      ********************************************************************
     C/SPACE 5
      ********************************************************************
      * SETUP TRANSACTION INDEX RECORD
      ********************************************************************
     C     SETUP_TRAPFRASBEGSR
 
     C                   CALLB     'GOSETFRAS'
     C                   PARM      *BLANK        W#RTCD            7            * RETURN CODE
     C                   PARM      *BLANK        W#ERMS           50            * ERROR MESSAGE
      * INPUTS
     C                   PARM                    DLSDG
      * OUTPUTS
     C                   PARM                    T_TRAP
 
     C                   PARM                    FltRateSet        1
     C                   PARM                    FltRateTyp        1
     C                   PARM                    FltRate          11 7
     C                   PARM                    FixRate          11 7
     C                   PARM                    SettleAmt        15 0
 
     C     W#RTCD        IFEQ      '*ERROR'
     C                   EVAL      I#ERMS = 'ERROR IN CALL TO GOSETFRAS'
     C                   EXSR      *PSSR
     C                   END
 
     C                   ENDSR
      ********************************************************************
     C/SPACE 5
      ********************************************************************
      * SETUP TRANSACTION INDEX RECORD
      ********************************************************************
     C     SETUP_TRAPSIRSBEGSR
      *
     C                   CALLB     'GOSETSIRS'
     C                   PARM      *BLANK        W#RTCD            7            * RETURN CODE
     C                   PARM      *BLANK        W#ERMS           50            * ERROR MESSAGE
      * INPUTS
     C                   PARM                    DLSDG
      * OUTPUTS
     C                   PARM                    T_TRAP
 
     C     W#RTCD        IFEQ      '*ERROR'
     C                   EVAL      I#ERMS = 'ERROR IN CALL TO GOSETSIRS'
     C                   EXSR      *PSSR
     C                   END
      *
     C                   ENDSR
      ********************************************************************
     C/SPACE 5
      ********************************************************************
      * SETUP TRANSACTION INDEX RECORD
      ********************************************************************
     C     SETUP_TRAPCIRSBEGSR
      *
     C                   CALLB     'GOSETCIRS'
     C                   PARM      *BLANK        W#RTCD            7            * RETURN CODE
     C                   PARM      *BLANK        W#ERMS           50            * ERROR MESSAGE
      * INPUTS
     C                   PARM                    DLSDG
      * OUTPUTS
     C                   PARM                    T_TRAP
 
     C     W#RTCD        IFEQ      '*ERROR'
     C                   EVAL      I#ERMS = 'ERROR IN CALL TO GOSETCIRS'
     C                   EXSR      *PSSR
     C                   END
      *
     C                   ENDSR
      ********************************************************************
     C/SPACE 5
      ********************************************************************
      * SETUP TRANSACTION INDEX RECORD
      ********************************************************************
     C     SETUP_TRAPCFCOBEGSR
      *
     C                   CALLB     'GOSETCFCO'
     C                   PARM      *BLANK        W#RTCD            7            * RETURN CODE
     C                   PARM      *BLANK        W#ERMS           50            * ERROR MESSAGE
      * INPUTS
     C                   PARM                    DLSDG
      * OUTPUTS
     C                   PARM                    T_TRAP
 
     C     W#RTCD        IFEQ      '*ERROR'
     C                   EVAL      I#ERMS = 'ERROR IN CALL TO GOSETCFCO'
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
      * *INZSR - Initial subroutine called automatically at program start
      ********************************************************************
     C     *INZSR        BEGSR
 
     C                   ENDSR
      ********************************************************************
      /SPACE 5
      ********************************************************************
      * * P S S R  --- A B N O R M A L   E R R O R   C O N D I T I O N S
      /COPY GOCPYSRC,GOPSSR
      *****************************************************************
**  CPY@
(c) Finastra International Limited 2003
