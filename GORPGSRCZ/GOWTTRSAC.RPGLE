     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2003')
      *****************************************************************
/*XBIA*: OVRDBF FILE(ACCNTXX) TOFILE(ACCNT) SHARE(*NO)                *
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas GO Write to TRAP - Account Movements')           *
      *****************************************************************
      *                                                               *
      *  Midas - Global Processing Module                             *
      *                                                               *
      *  GOWTTRSAC - Write to TRAP - Account Movements                *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2003            *
      *                                                               *
      *  Last Amend No. CRE075             Date 06Dec10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. CSD027             Date 09Dec05               *
      *                 BUG3860            Date 11Aug04               *
      *                 CLE025             Date 20Oct03               *
      *                 CGP001  *CREATE    Date 23May03               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CRE075 - Effective Date for Retail Accounts (Recompile)      *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  BUG3860 - (recompile)                                        *
      *  CLE025 - Credit Lines (Recompile)                            *
      *  CGP001 - Global Processing                                   *
      *                                                               *
      *****************************************************************
 
     FACCNTXX   IF   E           K DISK    INFSR(*PSSR) USROPN PREFIX(AC_)
     F                                     INCLUDE(ACCNTABF)
 
     D/COPY ZACPYSRC,STD_D_SPEC
 
 
      ** T R A N S A C T I O N    D E T A I L S
     D T_TRAP        E DS                  EXTNAME(GPTRAPPD)
 
 
     D RSAC          E DS                  EXTNAME(RSACMTPD)
     D ACCT          E DS                  EXTNAME(ACCNTAB) PREFIX(AC_)
 
 
      ** Overrides
     D ##OV1           S              1    DIM(60) CTDATA PERRCD(60)
 
 
      * ENTRY PARAMETERS
 
     C     *ENTRY        PLIST
     C                   PARM                    I#RTCD            7            * RETURN CODE
     C                   PARM                    I#ERMS           50            * ERROR MESSAGE
     C                   PARM                    I#BIMG         4000
     C                   PARM                    I#AIMG         4000
 
      * Override/open files
 
     C     AcctFileOpen  IFNE      'Y'
     C                   CALL      'QCMDEXC'     OV1_Parm
     C                   OPEN      ACCNTXX
     C                   MOVEL     'Y'           AcctFileOpen      1
     C                   ENDIF
 
      * Universal Transaction Updates
 
     C                   EXSR      TRAP_RSAC
 
     C                   RETURN
 
      /SPACE 5
      ********************************************************************
      * Universal Transaction Updates - Account Movement
      ********************************************************************
     C     TRAP_RSAC     BEGSR
 
     C                   MOVEL     I#AIMG        RSAC
 
      * Get associated account
 
     C     ACCNTK        CHAIN     ACCNTABF                           99        *
 
     C     *IN99         IFEQ      *OFF
 
      * SETUP TRANSACTION INDEX RECORD
      * WRITE TRANSACTION INDEX RECORD
 
     C                   EXSR      SETUP_TRAPACCT
     C     W#RTCD        IFNE      '*NOEXT*'
     C                   EXSR      WRITE_TRAP
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDSR
      ********************************************************************
     C/SPACE 5
      ********************************************************************
      * SETUP TRANSACTION INDEX RECORD
      ********************************************************************
     C     SETUP_TRAPACCTBEGSR
 
     C                   CALLB     'GOSETACCT'
     C                   PARM      *BLANK        W#RTCD            7            * RETURN CODE
     C                   PARM      *BLANK        W#ERMS           50            * ERROR MESSAGE
      * INPUTS
     C                   PARM                    ACCT
      * OUTPUTS
     C                   PARM                    T_TRAP
     C                   PARM      *ZERO         T_PRRN            5 0
 
     C     W#RTCD        IFEQ      '*ERROR'
     C                   EVAL      I#ERMS = 'ERROR IN CALL TO GOSETACCT'
     C                   EXSR      *PSSR
     C                   END
 
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
 
     C                   Z-ADD     60            MESLEN           15 5
 
      * Key lists
 
     C     ACCNTK        KLIST
     C                   KFLD                    CUSN
     C                   KFLD                    CCYD
     C                   KFLD                    ACDE
     C                   KFLD                    ASNC
     C                   KFLD                    BRCA
 
      * Parameter lists
 
     C     OV1_Parm      PLIST
     C                   PARM                    ##OV1
     C                   PARM                    MESLEN
     C                   ENDSR
      ********************************************************************
      /SPACE 5
      ********************************************************************
      * * P S S R  --- A B N O R M A L   E R R O R   C O N D I T I O N S
      /COPY GOCPYSRC,GOPSSR
      *****************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2003
** ##OV1
OVRDBF FILE(ACCNTXX) TOFILE(ACCNT) SHARE(*NO)
