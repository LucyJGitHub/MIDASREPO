     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2003')
      *****************************************************************
/*XBIA*  OVRDBF FILE(SECTYXX) TOFILE(SECTY)   SHARE(*NO)              *
/*XBIB*  OVRDBF FILE(SDSECSL0XX) TOFILE(SDSECSL0) SHARE(*NO)          *
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas GO Write to TRAP - SE Trades')                   *
      *****************************************************************
      *                                                               *
      *  Midas - Global Processing Module                             *
      *                                                               *
      *  GOWTTTRAD - Write to TRAP - SE Trades                        *
      *                                                               *
      *  (c) Finastra International Limited 2003                      *
      *                                                               *
      *  Last Amend No. CSD103             Date 10Aug20               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      *                 CRE073             Date 06Dec10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 256564             Date 17Sep08               *
      *                 BUG13264           Date 01Mar07               *
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD027             Date 09Dec05               *
      *                 CSE075             Date 17Nov05               *
      *                 CGL035             Date 01Mar05               *
      *                 CSE071             Date 19Jul05               *
      *                 BUG3860            Date 11Aug04               *
      *                 BG3512             Date 29Jul04               *
      *                 CGP001  *CREATE    Date 23May03               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD103 - LIBOR Deregulation - Common Layer/Standing Data     *
      *             (Recompile)                                       *
      *  MD046248 - Finastra Rebranding                               *
      *  CRE073 - Interest Rate Rounding (Recompile)                  *
      *  256564 - Recompile due to PF changes done by fix 256330      *
      *  BUG13264 - Do not write to GPTRAPPD if trade is incomplete.  *
      *     Fix was also applied to MP121 via 246221 bug number.      *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CSE075 - US Enhanced Treasury Upgrade to MidasPlus           *
      *           (Recompile)                                         *
      *  CGL035 - EUSD Upgrade to Midasplus (Recompile)               *
      *  CSE071 - Multiple Holidays Re Securities (recompile)         *
      *  BUG3860 - (recompile)                                        *
      *  BG3512 - Extract of SE Trades was missing                    *
      *  CGP001 - Global Processing                                   *
      *                                                               *
      *****************************************************************
 
     FSECTYXX   IF   E           K DISK    INFSR(*PSSR) USROPN PREFIX(SE_)
     FSDSECSL0XXIF   E           K DISK    INFSR(*PSSR) USROPN PREFIX(SD_)
 
     D/COPY ZACPYSRC,STD_D_SPEC
 
 
      ** T R A N S A C T I O N    D E T A I L S
     D T_TRAP        E DS                  EXTNAME(GPTRAPPD)
 
 
     D TRADS         E DS                  EXTNAME(TRADSD)
     D SECTY         E DS                  EXTNAME(SECTYD) PREFIX(SE_)
     D PRICE         E DS                  EXTNAME(PRICED) PREFIX(PR_)
 
 
     D                 DS
     D  PrvTransDtls           1     22
     D  PrvSecurity            1     10
     D**PrvCustomer           11     16  0                                                    CSD027
     D  PrvCustomer           11     16A                                                      CSD027
     D  PrvBranch             17     19
     D  PrvBook               20     21
     D  PrvMarket             22     22
 
     D                 DS
     D  NewTransDtls           1     22
     D  NewSecurity            1     10
     D**NewCustomer           11     16  0                                                    CSD027
     D  NewCustomer           11     16A                                                      CSD027
     D  NewBranch             17     19
     D  NewBook               20     21
     D  NewMarket             22     22
 
     D                 DS
     D  TransDtls              1     22
     D  Security               1     10
     D**Customer              11     16  0                                                    CSD027
     D  Customer              11     16A                                                      CSD027
     D  CustomerA             11     16
     D  Branch                17     19
     D  Book                  20     21
     D  Market                22     22
 
 
     D*CSCN*****       S              6S 0                                                    CSD027
     D CSCN            S              6A                                                      CSD027
 
 
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
 
     C     SecuFilesOpen IFNE      'Y'
     C                   CALL      'QCMDEXC'     OV1_Parm
     C                   CALL      'QCMDEXC'     OV2_Parm
     C                   OPEN      SECTYXX
     C                   OPEN      SDSECSL0XX
     C                   MOVEL     'Y'           SecuFilesOpen     1
     C                   ENDIF
 
      * Universal Transaction Updates
 
     C                   EXSR      TRAP_TRAD
 
     C                   RETURN
 
      /SPACE 5
      ********************************************************************
      * Do trades updates
      ********************************************************************
     C     TRAP_TRAD     BEGSR
 
      * On amend, look for change of key fields
 
     C     I#BIMG        IFNE      *BLANK
     C                   MOVEL     I#BIMG        TRADS
     C                   MOVEL     TDSS          PrvSecurity
     C                   MOVEL     TCNR          PrvCustomer
     C                   MOVEL     TDBA          PrvBranch
     C                   MOVEL     TDBK          PrvBook
     C                   MOVEL     TDMI          PrvMarket
     C                   ENDIF
 
     C     I#AIMG        IFNE      *BLANK
     C                   MOVEL     I#AIMG        TRADS
     C                   MOVEL     TDSS          NewSecurity
     C                   MOVEL     TCNR          NewCustomer
     C                   MOVEL     TDBA          NewBranch
     C                   MOVEL     TDBK          NewBook
     C                   MOVEL     TDMI          NewMarket
     C                   ENDIF
 
      * If trade is incomplete do not write to GPTRAPPD                                     BUG13264
     C     TINC          IFEQ      'I'                                                      BUG13264
     C                   RETURN                                                             BUG13264
     C                   ENDIF                                                              BUG13264
                                                                                            BUG13264
      * Reverse 'Previous' (Before)
      * ===========================
 
     C     I#BIMG        IFNE      *BLANK
     C     I#AIMG        ANDNE     *BLANK
     C     NewTransDtls  ANDNE     PrvTransDtls
     C     I#BIMG        ORNE      *BLANK
     C     I#AIMG        ANDEQ     *BLANK
 
     C                   MOVEL     I#BIMG        TRADS
     C                   MOVEL     PrvTransDtls  TransDtls
 
      * Access security details
 
     C                   EXSR      ACS_SECURITY
 
      * SETUP TRANSACTION INDEX RECORD (book positions)
      * WRITE TRANSACTION INDEX RECORD
 
     C                   EXSR      SETUP_TRAPSBPS
     C                   EXSR      WRITE_TRAP
 
      * Access customer details
 
     C     CustomerA     CHAIN     @BFREDP                            99
     C  N99SD_BFCLAS     IFEQ      'S'
     C     SD_BFCLAS     OREQ      'D'
 
      * SETUP TRANSACTION INDEX RECORD (customer positions)
      * WRITE TRANSACTION INDEX RECORD
 
     C                   EXSR      SETUP_TRAPSCPS
     C                   EXSR      WRITE_TRAP
     C                   ENDIF
                                                                                              BG3512
      * SETUP TRANSACTION INDEX RECORD (SE trades)                                            BG3512
      * WRITE TRANSACTION INDEX RECORD                                                        BG3512
                                                                                              BG3512
     C                   EXSR      SETUP_TRAPSTRD                                             BG3512
     C                   EXSR      WRITE_TRAP                                                 BG3512
 
     C                   ENDIF
 
      * Apply 'New' (After)
      * ===================
 
     C     I#AIMG        IFNE      *BLANK
     C                   MOVEL     I#AIMG        TRADS
     C                   MOVEL     NewTransDtls  TransDtls
 
      * Access security details
 
     C                   EXSR      ACS_SECURITY
 
      * SETUP TRANSACTION INDEX RECORD (book positions)
      * WRITE TRANSACTION INDEX RECORD
 
     C                   EXSR      SETUP_TRAPSBPS
     C                   EXSR      WRITE_TRAP
 
      * Access customer details
 
     C     CustomerA     CHAIN     @BFREDP                            99
     C  N99SD_BFCLAS     IFEQ      'S'
     C     SD_BFCLAS     OREQ      'D'
 
      * SETUP TRANSACTION INDEX RECORD (customer positions)
      * WRITE TRANSACTION INDEX RECORD
 
     C                   EXSR      SETUP_TRAPSCPS
     C                   EXSR      WRITE_TRAP
     C                   ENDIF
                                                                                              BG3512
      * SETUP TRANSACTION INDEX RECORD (SE trades)                                            BG3512
      * WRITE TRANSACTION INDEX RECORD                                                        BG3512
                                                                                              BG3512
     C                   EXSR      SETUP_TRAPSTRD                                             BG3512
     C                   EXSR      WRITE_TRAP                                                 BG3512
     C                   ENDIF
 
     C                   ENDSR
      ********************************************************************
     C/SPACE 5
      ********************************************************************
      * SETUP TRANSACTION INDEX RECORD
      ********************************************************************
     C     SETUP_TRAPSBPSBEGSR
      *
     C                   CALLB     'GOSETSBPS'
     C                   PARM      *BLANK        W#RTCD            7            * RETURN CODE
     C                   PARM      *BLANK        W#ERMS           50            * ERROR MESSAGE
      * INPUTS
     C                   PARM      Branch        BHBA              3
     C                   PARM      Book          BHBK              2
     C                   PARM      Market        BHMK              1
     C                   PARM      Security      BHSC             10
     C                   PARM      *ZERO         LPSD              5 0
     C                   PARM                    SECTY
      * OUTPUTS
     C                   PARM                    T_TRAP
 
     C                   PARM                    PRICE
     C                   PARM                    NomCcyDec         1 0
 
     C     W#RTCD        IFEQ      '*ERROR'
     C                   EVAL      I#ERMS = 'ERROR IN CALL TO GOSETSBPS'
     C                   EXSR      *PSSR
     C                   END
      *
     C                   ENDSR
      ********************************************************************
     C/SPACE 5
      ********************************************************************
      * SETUP TRANSACTION INDEX RECORD
      ********************************************************************
     C     SETUP_TRAPSCPSBEGSR
      *
     C                   CALLB     'GOSETSCPS'
     C                   PARM      *BLANK        W#RTCD            7            * RETURN CODE
     C                   PARM      *BLANK        W#ERMS           50            * ERROR MESSAGE
      * INPUTS
     C                   PARM      Branch        CSBA              3
     C                   PARM      Customer      CSCN
     C                   PARM      Security      CSSC             10
     C                   PARM      *ZERO         CSDA              5 0
     C                   PARM                    SECTY
      * OUTPUTS
     C                   PARM                    T_TRAP
 
     C                   PARM                    PRICE
     C                   PARM                    NomCcyDec         1 0
 
     C     W#RTCD        IFEQ      '*ERROR'
     C                   EVAL      I#ERMS = 'ERROR IN CALL TO GOSETSCPS'
     C                   EXSR      *PSSR
     C                   END
      *
     C                   ENDSR
      ********************************************************************
     C/SPACE 5                                                                                BG3512
      ********************************************************************                    BG3512
      * SETUP TRANSACTION INDEX RECORD                                                        BG3512
      ********************************************************************                    BG3512
     C     SETUP_TRAPSTRDBEGSR                                                                BG3512
      *                                                                                       BG3512
     C                   CALLB     'GOSETSTRD'                                                BG3512
     C                   PARM      *BLANK        W#RTCD            7            * RETURN CODE BG3512
     C                   PARM      *BLANK        W#ERMS           50            * ERROR MESSAGBG3512
      * INPUTS                                                                                BG3512
     C                   PARM                    TRADS                                        BG3512
     C                   PARM                    SECTY                                        BG3512
      * OUTPUTS                                                                               BG3512
     C                   PARM                    T_TRAP                                       BG3512
                                                                                              BG3512
     C                   PARM                    NomCcyDec         1 0                        BG3512
                                                                                              BG3512
     C     W#RTCD        IFEQ      '*ERROR'                                                   BG3512
     C                   EVAL      I#ERMS = 'ERROR IN CALL TO GOSETSTRD'                      BG3512
     C                   EXSR      *PSSR                                                      BG3512
     C                   END                                                                  BG3512
      *                                                                                       BG3512
     C                   ENDSR                                                                BG3512
      ********************************************************************                    BG3512
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
      * Access security details
      ********************************************************************
     C     ACS_SECURITY  BEGSR
 
      * Get security details
 
     C     Security      CHAIN     SECTYDF                            99        *
 
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
OVRDBF FILE(SECTYXX) TOFILE(SECTY)   SHARE(*NO)
** ##OV2
OVRDBF FILE(SDSECSL0XX) TOFILE(SDSECSL0) SHARE(*NO)
