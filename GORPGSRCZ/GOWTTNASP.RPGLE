     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2003')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas GO Write to TRAP - MM Neg. Assets Purchased')
      *****************************************************************
      *                                                               *
      *  Midas - Global Processing Module                             *
      *                                                               *
      *  GOWTTNASP - Write to TRAP - MM Neg. Assets Purchased         *
      *                                                               *
      *  (c) Finastra International Limited 2003                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. CDL049             Date 07Jul06               *
      *                 CSD027             Date 09Dec05               *
      *                 CDL038             Date 10May05               *
      *                 BUG3860            Date 11Aug04               *
      *                 222727             Date 05Nov03               *
      *                 CGP001  *CREATE    Date 23May03               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CDL049 - Addition of a Reference Rate field (recompile)      *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CDL038 - Extended Deal Sub Type (Recompile)                  *
      *  BUG3860 - (recompile)                                        *
      *  222727 - Release 5.0 errors  (Recompile)                     *
      *  CGP001 - Global Processing                                   *
      *                                                               *
      *****************************************************************
 
     D/COPY ZACPYSRC,STD_D_SPEC
 
 
      ** T R A N S A C T I O N    D E T A I L S
     D T_TRAP        E DS                  EXTNAME(GPTRAPPD)
 
 
     D MMDENB        E DS                  EXTNAME(MMDENBPP)
 
 
      * ENTRY PARAMETERS
 
     C     *ENTRY        PLIST
     C                   PARM                    I#RTCD            7            * RETURN CODE
     C                   PARM                    I#ERMS           50            * ERROR MESSAGE
     C                   PARM                    I#BIMG         4000
     C                   PARM                    I#AIMG         4000
 
      * Universal Transaction Updates
 
     C                   EXSR      TRAP_NASP
 
     C                   RETURN
 
      /SPACE 5
      ********************************************************************
      * Universal Transaction Updates - Loan/Deposit
      ********************************************************************
     C     TRAP_NASP     BEGSR
 
     C                   MOVEL     I#AIMG        MMDENB
 
      * SETUP TRANSACTION INDEX RECORD
      * WRITE TRANSACTION INDEX RECORD
 
     C                   EXSR      SETUP_TRAPNASP
     C                   EXSR      WRITE_TRAP
 
     C                   ENDSR
      ********************************************************************
     C/SPACE 5
      ********************************************************************
      * SETUP TRANSACTION INDEX RECORD
      ********************************************************************
     C     SETUP_TRAPNASPBEGSR
      *
     C                   CALLB     'GOSETNASP'
     C                   PARM      *BLANK        W#RTCD            7            * RETURN CODE
     C                   PARM      *BLANK        W#ERMS           50            * ERROR MESSAGE
      * INPUTS
     C                   PARM                    MMDENB
      * OUTPUTS
     C                   PARM                    T_TRAP
 
     C                   PARM                    DealDate          5 0            Midas day no.
     C                   PARM                    ValueDate         5 0            Midas day no.
     C                   PARM                    MaturityDate      5 0            Midas day no.
 
     C     W#RTCD        IFEQ      '*ERROR'
     C                   EVAL      I#ERMS = 'ERROR IN CALL TO GOSETNASP'
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
