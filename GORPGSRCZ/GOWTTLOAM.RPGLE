     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2003')
      *****************************************************************
/*XBIA*: OVRDBF FILE(CLOANCLXX) TOFILE(CLOAN) SHARE(*NO)              *
/*XBIB*: OVRDBF FILE(CLOANCLYY) TOFILE(CLOAN) SHARE(*NO)              *
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas GO Write to TRAP - Loan Amendments')             *
      *****************************************************************
      *                                                               *
      *  Midas - Global Processing Module                             *
      *                                                               *
      *  GOWTTLOAM - Write to TRAP - Loan Amendments                  *
      *                                                               *
      *  (c) Finastra International Limited 2003                      *
      *                                                               *
      *  Last Amend No. CER050             Date 16Jun19               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      *                 CLE134             Date 01Aug12               *
      *                 CLE148             Date 23Jul12               *
      *                 CER059             Date 19Jul10               *
      *                 CER020             Date 19May08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD027             Date 09Dec05               *
      *                 CLE042             Date 06Sep05               *
      *                 CLE106             Date 01Aug04               *
      *                 BUG3860            Date 11Aug04               *
      *                 CGP001  *CREATE    Date 23May03               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CER050 - Annualised Percentage Rate (Recompile)              *
      *  MD046248 - Finastra Rebranding                               *
      *  CLE134 - Past Due Call Loan Processing (Recompile)           *
      *  CLE148 - Alpha Loan Reference                                *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER020 - Enhanced Rollover Window: Upgrade FGE089 to         *
      *           Midas Plus (Recompile)                              *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CLE042 - Extended Loan Sub Type (Recompile)                  *
      *  CLE106 - Syndications Manager. (Recompile)                   *
      *  BUG3860 - (recompile)                                        *
      *  CGP001 - Global Processing                                   *
      *                                                               *
      *****************************************************************

     FCLOANCLXX IF   E           K DISK    INFSR(*PSSR) USROPN PREFIX(CL_)
     F                                     INCLUDE(CLOANCLF)
     FCLOANCLYY IF   E           K DISK    INFSR(*PSSR) USROPN PREFIX(SL_)
     F                                     RENAME(CLOANCLF:CLOANSLF)
     F                                     INCLUDE(CLOANCLF)

     D/COPY ZACPYSRC,STD_D_SPEC


      ** T R A N S A C T I O N    D E T A I L S
     D T_TRAP        E DS                  EXTNAME(GPTRAPPD)


     D LOAMDK        E DS                  EXTNAME(LOAMSDK)
     D LOANCL        E DS                  EXTNAME(CLOANCL) PREFIX(CL_)


      ** Overrides
     D ##OV1           S              1    DIM(60) CTDATA PERRCD(60)
     D ##OV2           S              1    DIM(60) CTDATA PERRCD(60)

     D                 DS                                                                     CSD027
      ** General data structure to handle OLNO field now that is alpha.                       CSD027
     D***OLNOAlpha               1      6                                              CSD027 CLE148
     D***OLNONum                 1      6  0                                           CSD027 CLE148

      * ENTRY PARAMETERS

     C     *ENTRY        PLIST
     C                   PARM                    I#RTCD            7            * RETURN CODE
     C                   PARM                    I#ERMS           50            * ERROR MESSAGE
     C                   PARM                    I#BIMG         4000
     C                   PARM                    I#AIMG         4000

      * Override/open files

     C     LoanFilesOpen IFNE      'Y'
     C                   CALL      'QCMDEXC'     OV1_Parm
     C                   CALL      'QCMDEXC'     OV2_Parm
     C                   OPEN      CLOANCLXX
     C                   OPEN      CLOANCLYY
     C                   MOVEL     'Y'           LoanFilesOpen     1
     C                   ENDIF

      * Universal Transaction Updates

     C                   EXSR      TRAP_LOAM

     C                   RETURN

      /SPACE 5
      ********************************************************************
      * Universal Transaction Updates - Loan Amendment
      ********************************************************************
     C     TRAP_LOAM     BEGSR

     C                   MOVEL     I#AIMG        LOAMDK

      * Get associated loan

     C     LNRF          CHAIN     CLOANCLF                           99        *

     C     *IN99         IFEQ      *OFF

      * For parts sold, get sale of loan number details

     C**********         Z-ADD     0             SL_MLNR                                      CLE148
     C                   MOVEL     *BLANKS       SL_MLNR                                      CLE148
     C**********         Z-ADD     0             SL_OLNO                                      CSD027
     C**********         Z-ADD     0             SL_CNUM                                      CSD027
     C                   EVAL      SL_OLNO = *BLANKS                                          CSD027
     C                   EVAL      SL_CNUM = *BLANKS                                          CSD027
     C     CL_PTYP       IFEQ      66                                           *
     C     CL_PTYP       OREQ      67                                           *
     C     CL_PTYP       OREQ      69                                           *
     C     CL_PTYP       OREQ      72                                           *
     C*****CL_OLNO       CHAIN     CLOANSLF                           99        *             CSD027
     C**********         EVAL      OLNOAlpha = CL_OLNO                                 CSD027 CLE148
     C*****OLNONum       CHAIN     CLOANSLF                           99        *      CSD027 CLE148
     C     CL_OLNO       CHAIN     CLOANSLF                           99                      CLE148
     C                   ENDIF

      * SETUP TRANSACTION INDEX RECORD
      * WRITE TRANSACTION INDEX RECORD

     C                   EXSR      SETUP_TRAPLOAN
     C                   EXSR      WRITE_TRAP

     C                   ENDIF

     C                   ENDSR
      ********************************************************************
     C/SPACE 5
      ********************************************************************
      * SETUP TRANSACTION INDEX RECORD
      ********************************************************************
     C     SETUP_TRAPLOANBEGSR
      *
     C                   CALLB     'GOSETLOAN'
     C                   PARM      *BLANK        W#RTCD            7            * RETURN CODE
     C                   PARM      *BLANK        W#ERMS           50            * ERROR MESSAGE
      * INPUTS
     C                   PARM                    LOANCL
     C                   PARM                    SL_CNUM
     C                   PARM                    SL_MLNR
     C                   PARM                    SL_OLNO
      * OUTPUTS
     C                   PARM                    T_TRAP

     C     W#RTCD        IFEQ      '*ERROR'
     C                   EVAL      I#ERMS = 'ERROR IN CALL TO GOSETLOAN'
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
      /SPACE 5
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
OVRDBF FILE(CLOANCLXX) TOFILE(CLOAN) SHARE(*NO)
** ##OV2
OVRDBF FILE(CLOANCLYY) TOFILE(CLOAN) SHARE(*NO)
